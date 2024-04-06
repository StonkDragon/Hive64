#include <stdio.h>
#include <sys/mman.h>
#include "new_ops.h"

static inline size_t pad_to_instr_size(size_t x) {
    size_t word_sz = sysconf(_SC_PAGESIZE);
    return x + (word_sz - (x % word_sz));
}

HiveFile read_hive_file(FILE* fp) {
    HiveFile hf = {0};
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
            size_t s = pad_to_instr_size(hf.sects.items[i].len);
            if (hf.sects.items[i].type < SECT_TYPE_TEXT) {
                hf.sects.items[i].data = malloc(s);
            } else {
                hf.sects.items[i].data = sys_mmap(NULL, s, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE, 0, 0);
                if (hf.sects.items[i].data == MAP_FAILED) {
                    fprintf(stderr, "Failed to map memory: %s\n", strerror(errno));
                    exit(1);
                }
            }
            fread(hf.sects.items[i].data, sizeof(char), hf.sects.items[i].len, fp);
        }
    }
    return hf;
}

Nob_File_Paths create_ld_section(Section s);
Section get_section(HiveFile f, uint8_t sect_type);

bool has_file(HiveFile_Array* arr, const char* name) {
    if (strcmp(name, "__DYLD__") == 0) return false;
    for (size_t i = 0; i < arr->count; i++) {
        if (strcmp(arr->items[i].name, name) == 0) {
            return true;
        }
    }
    return false;
}

void read_fat_file(FILE* fp, HiveFile_Array* current, bool do_dyload) {
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
        Section s = get_section(f, SECT_TYPE_LD);
        if (s.data == NULL || !do_dyload) continue;
        Nob_File_Paths ld_sect = create_ld_section(s);
        for (size_t i = 0; i < ld_sect.count; i++) {
            get_all_files(ld_sect.items[i], current, false, do_dyload);
        }
    }
}

void get_all_files(const char* name, HiveFile_Array* current, bool must_be_fat, bool do_dyload) {
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
        read_fat_file(fp, current, do_dyload);
    }
    if (!has_file(current, name) && do_dyload) {
        nob_da_append(current, src);
        Section s = get_section(src, SECT_TYPE_LD);
        if (s.data) {
            Nob_File_Paths ld_sect = create_ld_section(s);
            for (size_t i = 0; i < ld_sect.count; i++) {
                get_all_files(ld_sect.items[i], current, false, true);
            }
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

Symbol_Array create_symbol_section(Section s) {
    Symbol_Array off = {0};
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
        off.items[i].section = mem_read(data, uint64_t);
        off.items[i].flags = mem_read(data, enum symbol_flag);
    }
    #undef mem_read
    return off;
}

Relocation_Array create_relocation_section(Section s) {
    Relocation_Array off = {0};
    char* data = s.data;

    if (data == NULL) return off;

    #define mem_read(ptr, type) (ptr = (char*) (((QWord_t) ptr) + sizeof(type)), *(type*) ((QWord_t) ptr - sizeof(type)))
    off.count = mem_read(data, size_t);
    off.capacity = off.count;
    off.items = malloc(sizeof(*off.items) * off.capacity);
    for (size_t i = 0; i < off.count; i++) {
        off.items[i].source_offset = mem_read(data, uint64_t);
        off.items[i].source_section = mem_read(data, uint64_t);
        off.items[i].type = mem_read(data, enum reloc_type);
        off.items[i].is_local = mem_read(data, uint8_t);
        if (off.items[i].is_local) {
            off.items[i].data.local.target_offset = mem_read(data, uint64_t);
            off.items[i].data.local.target_section = mem_read(data, uint64_t);
        } else {
            size_t len = strlen(data);
            off.items[i].data.name = malloc(len + 1);
            strcpy(off.items[i].data.name, data);
            data += len + 1;
        }
    }
    #undef mem_read
    return off;
}

Nob_File_Paths create_ld_section(Section s) {
    Nob_File_Paths paths = {0};
    char* data = s.data;

    if (data == NULL) return paths;

    #define mem_read(ptr, type) (ptr += sizeof(type), *(type*) ((QWord_t) ptr - sizeof(type)))
    while (data < (s.data + s.len) && *data != 0) {
        size_t len = strlen(data);
        nob_da_append(&paths, data);
        data += len + 1;
    }
    #undef mem_read
    return paths;
}

Section get_section(HiveFile f, uint8_t sect_type) {
    if (f.sects.items == NULL) {
        return (Section) {0};
    }
    for (size_t i = 0; i < f.sects.count; i++) {
        if (f.sects.items[i].type != sect_type) continue;

        return f.sects.items[i];
    }
    return (Section) {0};
}

char* get_code_section_address(HiveFile f) {
    return get_section(f, SECT_TYPE_TEXT).data;
}

uint64_t find_symbol_address(Symbol_Array syms, char* name) {
    for (size_t i = 0; i < syms.count; i++) {
        if (strcmp(syms.items[i].name, name) == 0) {
            return syms.items[i].offset;
        }
    }
    return -1;
}

Symbol find_symbol(Symbol_Array syms, char* name) {
    for (size_t i = 0; i < syms.count; i++) {
        if (/*(syms.items[i].flags & sf_exported) &&*/ strcmp(syms.items[i].name, name) == 0) {
            return syms.items[i];
        }
    }
    return (Symbol) { .offset = -1 };
}

Nob_String_Builder pack_symbol_table(Symbol_Array syms) {
    Nob_String_Builder s = {0};
    size_t count = 0;
    for (size_t i = 0; i < syms.count; i++) {
        if (syms.items[i].flags & sf_exported) {
            count++;
        }
    }
    nob_da_append_many(&s, &count, sizeof(count));
    for (size_t i = 0; i < syms.count; i++) {
        Symbol so = syms.items[i];
        if ((so.flags & sf_exported) == 0) continue;
        nob_da_append_many(&s, so.name, strlen(so.name) + 1);
        nob_da_append_many(&s, &so.offset, sizeof(so.offset));
        nob_da_append_many(&s, &so.section, sizeof(so.section));
        nob_da_append_many(&s, &so.flags, sizeof(so.flags));
    }
    return s;
}

Nob_String_Builder pack_ld_section(Nob_File_Paths dylibs) {
    Nob_String_Builder s = {0};
    for (size_t i = 0; i < dylibs.count; i++) {
        nob_da_append_many(&s, dylibs.items[i], strlen(dylibs.items[i]) + 1);
    }
    return s;
}

Nob_String_Builder pack_relocation_table(Relocation_Array relocs) {
    Nob_String_Builder s = {0};
    nob_da_append_many(&s, &relocs.count, sizeof(relocs.count));
    for (size_t i = 0; i < relocs.count; i++) {
        Relocation so = relocs.items[i];
        nob_da_append_many(&s, &so.source_offset, sizeof(so.source_offset));
        nob_da_append_many(&s, &so.source_section, sizeof(so.source_section));
        nob_da_append_many(&s, &so.type, sizeof(so.type));
        nob_da_append_many(&s, &so.is_local, sizeof(so.is_local));
        if (so.is_local) {
            nob_da_append_many(&s, &so.data.local.target_offset, sizeof(so.data.local.target_offset));
            nob_da_append_many(&s, &so.data.local.target_section, sizeof(so.data.local.target_section));
        } else {
            nob_da_append_many(&s, so.data.name, strlen(so.data.name) + 1);
        }
    }
    return s;
}

void relocate(Section_Array sects, Relocation_Array relocs, Symbol_Array symbols) {
    bool has_errors = false;
    for (size_t i = 0; i < relocs.count; i++) {
        Relocation reloc = relocs.items[i];
        uint64_t current_address = reloc.source_offset;
        uint64_t target_address;
        if (reloc.is_local) {
            target_address = (uint64_t) sects.items[reloc.data.local.target_section].data + reloc.data.local.target_offset;
        } else {
            Symbol target = find_symbol(symbols, reloc.data.name);
            target_address = target.offset;
        }

        Section sect = sects.items[reloc.source_section];
        if (sect.data == NULL) {
            fprintf(stderr, "Section %llu does not exist\n", reloc.source_section);
            continue;
        }

        if (target_address == -1) {
            fprintf(stderr, "Undefined symbol");
            if (reloc.is_local) {
                fprintf(stderr, "\n");
            } else {
                fprintf(stderr, ": %s\n", reloc.data.name);
            }
            has_errors = true;
            continue;
        }
        
        #define POW2(_n) (1 << _n)
        #define check_align() \
            if (diff % 4) { \
                fprintf(stderr, "Relative target not aligned: %x\n", diff); \
                exit(1); \
            }
        #define relative_check(_dist) \
            if (diff >= _dist || diff < -_dist) { \
                fprintf(stderr, "Relative address too far: %d > %d (%llx -> %llx)\n", diff, _dist, (QWord_t) &sect.data[current_address], target_address); \
                exit(1); \
            }

        switch (reloc.type) {
            case sym_abs:
                *((QWord_t*) &sect.data[current_address]) = target_address;
                break;
            case sym_branch: {
                    hive_instruction_t* s = ((hive_instruction_t*) &sect.data[current_address]);
                    int32_t diff = target_address - (uint64_t) s;
                    check_align();
                    diff /= sizeof(hive_instruction_t);
                    relative_check(POW2(24));
                    s->type_branch_generic.offset = diff;
                }
                break;
            case sym_load: {
                    hive_instruction_t* s = ((hive_instruction_t*) &sect.data[current_address]);
                    int32_t diff = target_address - (uint64_t) s;
                    check_align();
                    diff /= sizeof(hive_instruction_t);
                    relative_check(POW2(19));
                    s->type_load_signed.imm = diff;
                }
                break;
            case sym_ls_off: {
                    hive_instruction_t* s = ((hive_instruction_t*) &sect.data[current_address]);
                    int32_t diff = target_address - (uint64_t) s;
                    check_align();
                    diff /= sizeof(hive_instruction_t);
                    relative_check(POW2(18));
                    s->type_load_ls_off.imm = diff;
                }
                break;
        }
    }
    if (has_errors) {
        exit(1);
    }
}

void prepare(HiveFile_Array hf, bool try_relocate, Symbol_Array* all_syms) {
    for (size_t i = 0; i < hf.count; i++) {
        Section syms = get_section(hf.items[i], SECT_TYPE_SYMS);
        if (!syms.data) continue;

        Symbol_Array symbols = create_symbol_section(syms);
        
        for (size_t j = 0; j < symbols.count; j++) {
            Section sect = hf.items[i].sects.items[symbols.items[j].section];
            if (sect.data == NULL) {
                fprintf(stderr, "Section %llu does not exist\n", symbols.items[j].section);
                continue;
            }
            symbols.items[j].offset += (uint64_t) sect.data;
        }
        nob_da_append_many(all_syms, symbols.items, symbols.count);
    }

    if (try_relocate) {
        for (size_t i = 0; i < hf.count; i++) {
            Section reloc_sect = get_section(hf.items[i], SECT_TYPE_RELOC);
            if (!reloc_sect.data) continue;

            Relocation_Array relocs = create_relocation_section(reloc_sect);
            relocate(hf.items[i].sects, relocs, *all_syms);
        }

        for (size_t i = 0; i < hf.count; i++) {
            for (size_t s = 0; s < hf.items[i].sects.count; s++) {
                size_t sz = pad_to_instr_size(hf.items[i].sects.items[s].len);
                if (hf.items[i].sects.items[s].type < SECT_TYPE_TEXT) {
                    free(hf.items[i].sects.items[s].data);
                    hf.items[i].sects.items[s].data = NULL;
                } else {
                    if (hf.items[i].sects.items[s].type == SECT_TYPE_TEXT) {
                        mprotect(hf.items[i].sects.items[s].data, sz, PROT_READ | PROT_EXEC);
                    } else if (hf.items[i].sects.items[s].type == SECT_TYPE_DATA) {
                        mprotect(hf.items[i].sects.items[s].data, sz, PROT_READ);
                    } else if (hf.items[i].sects.items[s].type == SECT_TYPE_BSS) {
                        mprotect(hf.items[i].sects.items[s].data, sz, PROT_READ | PROT_WRITE);
                    } else {
                        fprintf(stderr, "Unknown section: %x\n", hf.items[i].sects.items[s].type);
                    }
                }
            }
        }
    }
}
