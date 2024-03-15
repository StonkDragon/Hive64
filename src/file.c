#include <stdio.h>
#include <sys/mman.h>
#include "new_ops.h"

static inline size_t pad_to_page_size(size_t x) {
    size_t page_size = sysconf(_SC_PAGESIZE);
    return x + (page_size - (x % page_size));
}

void* create_mapping(size_t s, uint8_t flags);
void* virtual_to_physical(void* vaddr, uint8_t with_flags);
void mmu_protect(void* base_addr, size_t size, uint8_t flags);

bool use_vmem = false;

HiveFile read_hive_file(FILE* fp) {
    HiveFile hf;
    fread(&hf.magic, sizeof(hf.magic), 1, fp);
    if (hf.magic == HIVE_FAT_FILE_MAGIC) {
        fseek(fp, -sizeof(hf.magic), SEEK_CUR);
        return hf;
    }
    fread(&hf.sects.count, sizeof(hf.sects.count), 1, fp);
    hf.sects.capacity = hf.sects.count;
    hf.sects.items = malloc(sizeof(*hf.sects.items) * hf.sects.count);
    for (size_t i = 0; i < hf.sects.count; i++) {
        fread(&hf.sects.items[i].len, sizeof(hf.sects.items[i].len), 1, fp);
        fread(&hf.sects.items[i].type, sizeof(hf.sects.items[i].type), 1, fp);
        if (hf.sects.items[i].len) {
            if (hf.sects.items[i].type == SECT_TYPE_CODE) {
                size_t s = pad_to_page_size(hf.sects.items[i].len);
                hf.sects.items[i].data = mmap(NULL, s, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE, 0, 0);
                if (hf.sects.items[i].data == MAP_FAILED) {
                    fprintf(stderr, "Failed to create memory mapping: %s\n", strerror(errno));
                    exit(1);
                }
                memset(hf.sects.items[i].data, 0, s);
            } else {
                hf.sects.items[i].data = malloc(hf.sects.items[i].len);
            }
            fread(hf.sects.items[i].data, sizeof(char), hf.sects.items[i].len, fp);
        }
    }
    return hf;
}

Nob_File_Paths create_ld_section(Section s);
Section get_section(HiveFile f, uint32_t sect_type);

bool has_file(HiveFile_Array* arr, const char* name) {
    for (size_t i = 0; i < arr->count; i++) {
        if (strcmp(arr->items[i].name, name) == 0) {
            return true;
        }
    }
    return false;
}

void read_fat_file(FILE* fp, HiveFile_Array* current) {
    uint32_t magic;
    fread(&magic, sizeof(magic), 1, fp);
    if (magic != HIVE_FAT_FILE_MAGIC) {
        fprintf(stderr, "Invalid file magic: %08x\n", magic);
        exit(1);
    }
    uint32_t nfiles;
    fread(&nfiles, sizeof(nfiles), 1, fp);
    HiveFile_Array to_check = {0};
    for (uint32_t i = 0; i < nfiles; i++) {
        size_t name_len;
        fread(&name_len, sizeof(name_len), 1, fp);
        char* name = malloc(name_len);
        fread(name, sizeof(char), name_len, fp);
        HiveFile f = read_hive_file(fp);
        f.name = name;
        if (f.magic == HIVE_FAT_FILE_MAGIC) {
            fprintf(stderr, "Cannot nest fat files");
            exit(1);
        }
        if (!has_file(current, name)) {
            nob_da_append(current, f);
            nob_da_append(&to_check, f);
        }
    }
    for (size_t i = 0; i < to_check.count; i++) {
        HiveFile f = to_check.items[i];
        Nob_File_Paths ld_sect = create_ld_section(get_section(f, SECT_TYPE_LD));
        for (size_t i = 0; i < ld_sect.count; i++) {
            get_all_files(ld_sect.items[i], current, false);
        }
    }
}

void get_all_files(const char* name, HiveFile_Array* current, bool must_be_fat) {
    FILE* fp = fopen(name, "rb");
    if (fp == NULL) {
        fprintf(stderr, "Unable to open file %s\n", name);
        exit(1);
    }
    HiveFile src = read_hive_file(fp);
    src.name = name;
    if (must_be_fat && src.magic != HIVE_FAT_FILE_MAGIC) {
        fprintf(stderr, "Invalid file: %s\n", name);
        return;
    }
    if (src.magic == HIVE_FAT_FILE_MAGIC) {
        read_fat_file(fp, current);
    }
    if (!has_file(current, name)) {
        nob_da_append(current, src);
        Nob_File_Paths ld_sect = create_ld_section(get_section(src, SECT_TYPE_LD));
        for (size_t i = 0; i < ld_sect.count; i++) {
            get_all_files(ld_sect.items[i], current, false);
        }
    }
    fclose(fp);
}

void write_hive_file(HiveFile hf, FILE* fp) {
    fwrite(&hf.magic, sizeof(hf.magic), 1, fp);
    if (hf.magic == HIVE_FAT_FILE_MAGIC) {
        uint32_t count = (uint32_t) hf.sects.count;
        fwrite(&count, sizeof(count), 1, fp);
        for (size_t i = 0; i < hf.sects.count; i++) {
            fwrite(hf.sects.items[i].data, sizeof(char), hf.sects.items[i].len, fp);
        }
        return;
    }
    fwrite(&hf.sects.count, sizeof(hf.sects.count), 1, fp);
    for (size_t i = 0; i < hf.sects.count; i++) {
        fwrite(&hf.sects.items[i].len, sizeof(hf.sects.items[i].len), 1, fp);
        fwrite(&hf.sects.items[i].type, sizeof(hf.sects.items[i].type), 1, fp);
        fwrite(hf.sects.items[i].data, sizeof(char), hf.sects.items[i].len, fp);
    }
}

Symbol_Offsets create_symbol_section(Section s) {
    Symbol_Offsets off = {0};
    char* data = s.data;

    if (data == NULL) return off;

    #define mem_read(ptr, type) (ptr += sizeof(type), *(type*) (ptr - sizeof(type)))
    off.count = mem_read(data, size_t);
    off.capacity = off.count;
    off.items = malloc(sizeof(*off.items) * off.capacity);
    for (size_t i = 0; i < off.count; i++) {
        size_t len = strlen(data);
        off.items[i].name = malloc(len);
        strcpy(off.items[i].name, data);
        data += len + 1;
        off.items[i].offset = mem_read(data, uint64_t);
    }
    #undef mem_read
    return off;
}

Symbol_Offsets create_relocation_section(Section s) {
    Symbol_Offsets off = {0};
    char* data = s.data;

    if (data == NULL) return off;

    #define mem_read(ptr, type) (ptr = (char*) (((QWord_t) ptr) + sizeof(type)), *(type*) ((QWord_t) ptr - sizeof(type)))
    off.count = mem_read(data, size_t);
    off.capacity = off.count;
    off.items = malloc(sizeof(*off.items) * off.capacity);
    for (size_t i = 0; i < off.count; i++) {
        size_t len = strlen(data);
        off.items[i].name = malloc(len + 1);
        strcpy(off.items[i].name, data);
        data += len + 1;
        off.items[i].offset = mem_read(data, uint64_t);
        off.items[i].type = mem_read(data, enum symbol_type);
    }
    #undef mem_read
    return off;
}

Nob_File_Paths create_ld_section(Section s) {
    Nob_File_Paths paths = {0};
    char* data = s.data;

    if (data == NULL) return paths;

    #define mem_read(ptr, type) (ptr += sizeof(type), *(type*) ((QWord_t) ptr - sizeof(type)))
    while (data < (s.data + s.len)) {
        size_t len = strlen(data);
        nob_da_append(&paths, data);
        data += len + 1;
    }
    #undef mem_read
    return paths;
}

Section get_section(HiveFile f, uint32_t sect_type) {
    for (size_t i = 0; i < f.sects.count; i++) {
        if (f.sects.items[i].type != sect_type) continue;

        return f.sects.items[i];
    }
    return (Section) {0};
}

char* get_code_section_address(HiveFile f) {
    return get_section(f, SECT_TYPE_CODE).data;
}

uint64_t find_symbol_address(Symbol_Offsets syms, char* name) {
    for (size_t i = 0; i < syms.count; i++) {
        if (strcmp(syms.items[i].name, name) == 0) {
            return syms.items[i].offset;
        }
    }
    return -1;
}

struct symbol_offset find_symbol(Symbol_Offsets syms, char* name) {
    for (size_t i = 0; i < syms.count; i++) {
        if (strcmp(syms.items[i].name, name) == 0) {
            return syms.items[i];
        }
    }
    return (struct symbol_offset) { .offset = -1 };
}

Nob_String_Builder pack_symbol_table(Symbol_Offsets syms) {
    Nob_String_Builder s = {0};
    size_t export_count = 0;
    for (size_t i = 0; i < syms.count; i++) {
        struct symbol_offset so = syms.items[i];
        if (so.flags & sf_exported) {
            export_count++;
        }
    }
    nob_da_append_many(&s, &export_count, sizeof(syms.count));
    for (size_t i = 0; i < syms.count; i++) {
        struct symbol_offset so = syms.items[i];
        if (so.flags & sf_exported) {
            nob_da_append_many(&s, so.name, strlen(so.name) + 1);
            nob_da_append_many(&s, &so.offset, sizeof(so.offset));
        }
    }
    return s;
}

Nob_String_Builder pack_relocation_table(Symbol_Offsets relocs) {
    Nob_String_Builder s = {0};
    nob_da_append_many(&s, &relocs.count, sizeof(relocs.count));
    for (size_t i = 0; i < relocs.count; i++) {
        struct symbol_offset so = relocs.items[i];
        nob_da_append_many(&s, so.name, strlen(so.name) + 1);
        nob_da_append_many(&s, &so.offset, sizeof(so.offset));
        nob_da_append_many(&s, &so.type, sizeof(so.type));
    }
    return s;
}

void relocate(Section code_sect, Symbol_Offsets relocs, Symbol_Offsets symbols) {
    for (size_t i = 0; i < relocs.count; i++) {
        struct symbol_offset reloc = relocs.items[i];
        uint64_t current_address = reloc.offset;
        uint64_t target_address = find_symbol_address(symbols, reloc.name);

        if (target_address == -1) {
            if (reloc.type == sym_abs) {
                *((QWord_t*) &code_sect.data[current_address]) += (uint64_t) code_sect.data;
                continue;
            } else {
                fprintf(stderr, "Undefined symbol: %s\n", reloc.name);
                exit(1);
            }
        }

        switch (reloc.type) {
            case sym_abs:
                *((QWord_t*) &code_sect.data[current_address]) = target_address;
                break;
            case sym_branch: {
                    hive_instruction_t* s = ((hive_instruction_t*) &code_sect.data[current_address]);
                    int32_t diff = target_address - (uint64_t) s;
                    if (diff % 4) {
                        fprintf(stderr, "Relative target not aligned!");
                        exit(1);
                    }
                    diff >>= 2;
                    if (diff >= 0x1000000 || diff < -0x1000000) {
                        fprintf(stderr, "Relative address too far: %x (%llx -> %llx)\n", diff, (QWord_t) &code_sect.data[current_address], target_address);
                        exit(1);
                    }
                    s->type_branch_generic.offset = diff;
                }
                break;
            case sym_load: {
                    hive_instruction_t* s = ((hive_instruction_t*) &code_sect.data[current_address]);
                    int32_t diff = target_address - (uint64_t) s;
                    if (diff % 4) {
                        fprintf(stderr, "Relative target not aligned!");
                        exit(1);
                    }
                    diff >>= 2;
                    if (diff >= 0x80000 || diff < -0x80000) {
                        fprintf(stderr, "Relative address too far: %x (%llx -> %llx)\n", diff, (uint64_t) &code_sect.data[current_address], target_address);
                        exit(1);
                    }
                    s->type_load_signed.imm = diff;
                }
                break;
        }
    }
}

Symbol_Offsets prepare(HiveFile_Array hf, bool try_relocate) {
    Symbol_Offsets all_syms = {0};

    for (size_t i = 0; i < hf.count; i++) {
        Section syms = get_section(hf.items[i], SECT_TYPE_SYMS);
        if (!syms.data) continue;

        Symbol_Offsets symbols = create_symbol_section(syms);
        Section code_sect = get_section(hf.items[i], SECT_TYPE_CODE);

        if (code_sect.data == NULL) {
            fprintf(stderr, "File %s has symbols, but no code\n", hf.items[i].name);
            continue;
        }
        
        if (code_sect.data) {
            for (size_t j = 0; j < symbols.count; j++) {
                symbols.items[j].offset += (uint64_t) code_sect.data;
            }
        }
        nob_da_append_many(&all_syms, symbols.items, symbols.count);
    }

    if (try_relocate) {
        for (size_t i = 0; i < hf.count; i++) {
            Section reloc_sect = get_section(hf.items[i], SECT_TYPE_RELOC);
            if (!reloc_sect.data) continue;

            Symbol_Offsets relocs = create_relocation_section(reloc_sect);
            Section code_sect = get_section(hf.items[i], SECT_TYPE_CODE);
            
            if (code_sect.data == NULL) {
                fprintf(stderr, "File %s has relocations, but no code\n", hf.items[i].name);
                continue;
            }

            relocate(code_sect, relocs, all_syms);
        }
    }

    return all_syms;
}
