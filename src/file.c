#include <stdio.h>
#include <sys/mman.h>
#include "new_ops.h"

static inline size_t pad_to_instr_size(size_t x) {
    size_t word_sz = sysconf(_SC_PAGESIZE);
    return x + (word_sz - (x % word_sz));
}

Hive64File_Array read_h64_file(FILE* fp, bool load_dylibs) {
    Hive64File_Array files = {0};
    Hive64File f = {0};
    fread(&f.magic, sizeof(f.magic), 1, fp);
    if (f.magic != HIVE64_FILE_MAGIC) {
        fprintf(stderr, "Invalid file magic: %x\n", f.magic);
        exit(1);
    }
    fread(&f.v_maj, sizeof(f.v_maj), 1, fp);
    fread(&f.v_min, sizeof(f.v_min), 1, fp);
    fread(&f.filetype, sizeof(f.filetype), 1, fp);

    fread(&f.relocations.capacity, sizeof(f.relocations.capacity), 1, fp);
    f.relocations.count = f.relocations.capacity;
    f.relocations.items = malloc(sizeof(*f.relocations.items) * f.relocations.capacity);

    fread(&f.load_commands.capacity, sizeof(f.load_commands.capacity), 1, fp);
    f.load_commands.count = f.load_commands.capacity;
    f.load_commands.items = malloc(sizeof(*f.load_commands.items) * f.load_commands.capacity);

    fread(&f.symbols.capacity, sizeof(f.symbols.capacity), 1, fp);
    f.symbols.count = f.symbols.capacity;
    f.symbols.items = malloc(sizeof(*f.symbols.items) * f.symbols.capacity);

    fread(&f.libraries.capacity, sizeof(f.libraries.capacity), 1, fp);
    f.libraries.count = f.libraries.capacity;
    f.libraries.items = malloc(sizeof(*f.libraries.items) * f.libraries.capacity);

    for (size_t i = 0; i < f.relocations.count; i++) {
        fread(&f.relocations.items[i].source_offset, sizeof(f.relocations.items[i].source_offset), 1, fp);
        fread(&f.relocations.items[i].source_section, sizeof(f.relocations.items[i].source_section), 1, fp);
        fread(&f.relocations.items[i].type, sizeof(f.relocations.items[i].type), 1, fp);
        fread(&f.relocations.items[i].is_local, sizeof(f.relocations.items[i].is_local), 1, fp);
        if (f.relocations.items[i].is_local) {
            fread(&f.relocations.items[i].data.local.target_offset, sizeof(f.relocations.items[i].data.local.target_offset), 1, fp);
            fread(&f.relocations.items[i].data.local.target_section, sizeof(f.relocations.items[i].data.local.target_section), 1, fp);
        } else {
            size_t len;
            fread(&len, sizeof(len), 1, fp);
            f.relocations.items[i].data.name = malloc(len);
            fread(f.relocations.items[i].data.name, sizeof(char), len, fp);
        }
    }

    for (size_t i = 0; i < f.load_commands.count; i++) {
        fread(&f.load_commands.items[i].len, sizeof(f.load_commands.items[i].len), 1, fp);
        fread(&f.load_commands.items[i].type, sizeof(f.load_commands.items[i].type), 1, fp);
        fread(&f.load_commands.items[i].len_unpacked, sizeof(f.load_commands.items[i].len_unpacked), 1, fp);
        fread(&f.load_commands.items[i].ld_at, sizeof(f.load_commands.items[i].ld_at), 1, fp);

        if (f.load_commands.items[i].len_unpacked < f.load_commands.items[i].len) {
            fprintf(stderr, "len_unpacked is smaller than len\n");
            exit(1);
        }
        
        size_t s = pad_to_instr_size(f.load_commands.items[i].len_unpacked);
        f.load_commands.items[i].data = sys_mmap(f.load_commands.items[i].ld_at, s, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE, 0, 0);
        if (f.load_commands.items[i].data == MAP_FAILED) {
            fprintf(stderr, "Failed to map memory: %s\n", strerror(errno));
            exit(1);
        }
        if (f.load_commands.items[i].len) {
            fread(f.load_commands.items[i].data, sizeof(char), f.load_commands.items[i].len, fp);
        }
    }

    for (size_t i = 0; i < f.symbols.count; i++) {
        size_t len;
        fread(&len, sizeof(len), 1, fp);
        f.symbols.items[i].name = malloc(len);
        fread(f.symbols.items[i].name, sizeof(char), len, fp);
        fread(&f.symbols.items[i].offset, sizeof(f.symbols.items[i].offset), 1, fp);
        fread(&f.symbols.items[i].section, sizeof(f.symbols.items[i].section), 1, fp);
        fread(&f.symbols.items[i].flags, sizeof(f.symbols.items[i].flags), 1, fp);
    }

    for (size_t i = 0; i < f.libraries.count; i++) {
        size_t len;
        fread(&len, sizeof(len), 1, fp);
        f.libraries.items[i] = malloc(len);
        fread((char*) f.libraries.items[i], sizeof(char), len, fp);
    }

    nob_da_append(&files, f);

    if (load_dylibs) {
        for (size_t i = 0; i < f.libraries.count; i++) {
            FILE* fp = fopen(f.libraries.items[i], "rb");
            if (fp == NULL) {
                fprintf(stderr, "Could not open file %s!\n", f.libraries.items[i]);
                exit(1);
            }
            Hive64File_Array others = read_h64_file(fp, load_dylibs);
            nob_da_append_many(&files, others.items, others.count);
            fclose(fp);
        }
    }
    return files;
}

void write_h64_file(FILE* fp, Hive64File f) {
    if (f.magic != HIVE64_FILE_MAGIC) {
        fprintf(stderr, "Invalid file magic: %x\n", f.magic);
        exit(1);
    }
    fwrite(&f.magic, sizeof(f.magic), 1, fp);
    fwrite(&f.v_maj, sizeof(f.v_maj), 1, fp);
    fwrite(&f.v_min, sizeof(f.v_min), 1, fp);
    fwrite(&f.filetype, sizeof(f.filetype), 1, fp);

    fwrite(&f.relocations.count, sizeof(f.relocations.count), 1, fp);
    fwrite(&f.load_commands.count, sizeof(f.load_commands.count), 1, fp);
    fwrite(&f.symbols.count, sizeof(f.symbols.count), 1, fp);
    fwrite(&f.libraries.count, sizeof(f.libraries.count), 1, fp);

    for (size_t i = 0; i < f.relocations.count; i++) {
        fwrite(&f.relocations.items[i].source_offset, sizeof(f.relocations.items[i].source_offset), 1, fp);
        fwrite(&f.relocations.items[i].source_section, sizeof(f.relocations.items[i].source_section), 1, fp);
        fwrite(&f.relocations.items[i].type, sizeof(f.relocations.items[i].type), 1, fp);
        fwrite(&f.relocations.items[i].is_local, sizeof(f.relocations.items[i].is_local), 1, fp);
        if (f.relocations.items[i].is_local) {
            fwrite(&f.relocations.items[i].data.local.target_offset, sizeof(f.relocations.items[i].data.local.target_offset), 1, fp);
            fwrite(&f.relocations.items[i].data.local.target_section, sizeof(f.relocations.items[i].data.local.target_section), 1, fp);
        } else {
            size_t len = strlen(f.relocations.items[i].data.name);
            fwrite(&len, sizeof(len), 1, fp);
            fwrite(f.relocations.items[i].data.name, sizeof(char), len, fp);
        }
    }

    for (size_t i = 0; i < f.load_commands.count; i++) {
        fwrite(&f.load_commands.items[i].len, sizeof(f.load_commands.items[i].len), 1, fp);
        fwrite(&f.load_commands.items[i].type, sizeof(f.load_commands.items[i].type), 1, fp);
        fwrite(&f.load_commands.items[i].len_unpacked, sizeof(f.load_commands.items[i].len_unpacked), 1, fp);
        fwrite(&f.load_commands.items[i].ld_at, sizeof(f.load_commands.items[i].ld_at), 1, fp);

        if (f.load_commands.items[i].len_unpacked < f.load_commands.items[i].len) {
            fprintf(stderr, "len_unpacked is smaller than len\n");
            exit(1);
        }
        
        if (f.load_commands.items[i].len) {
            fwrite(f.load_commands.items[i].data, sizeof(char), f.load_commands.items[i].len, fp);
        }
    }

    for (size_t i = 0; i < f.symbols.count; i++) {
        size_t len = strlen(f.symbols.items[i].name);
        fwrite(&len, sizeof(len), 1, fp);
        fwrite(f.symbols.items[i].name, sizeof(char), len, fp);
        fwrite(&f.symbols.items[i].offset, sizeof(f.symbols.items[i].offset), 1, fp);
        fwrite(&f.symbols.items[i].section, sizeof(f.symbols.items[i].section), 1, fp);
        fwrite(&f.symbols.items[i].flags, sizeof(f.symbols.items[i].flags), 1, fp);
    }

    for (size_t i = 0; i < f.libraries.count; i++) {
        size_t len = strlen(f.libraries.items[i]);
        fwrite(&len, sizeof(len), 1, fp);
        fwrite(f.libraries.items[i], sizeof(char), len, fp);
    }
}

LoadCommand get_load_command(Hive64File f, uint8_t sect_type) {
    if (f.load_commands.items == NULL) {
        return (LoadCommand) {0};
    }
    for (size_t i = 0; i < f.load_commands.count; i++) {
        if (f.load_commands.items[i].type != sect_type) continue;

        return f.load_commands.items[i];
    }
    return (LoadCommand) {0};
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
        if (strcmp(syms.items[i].name, name) == 0) {
            return syms.items[i];
        }
    }
    return (Symbol) { .offset = -1 };
}

void relocate(LoadCommand_Array sects, Relocation_Array relocs, Symbol_Array symbols) {
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

        LoadCommand lc = sects.items[reloc.source_section];
        if (lc.data == NULL) {
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
                fprintf(stderr, "Relative address too far: %d > %d (%llx -> %llx)\n", diff, _dist, (QWord_t) (lc.data + current_address), target_address); \
                exit(1); \
            }

        hive_instruction_t* pc = ((hive_instruction_t*) (lc.data + current_address));
        switch (reloc.type) {
            case sym_abs:
                *((QWord_t*) (lc.data + current_address)) = target_address;
                break;
            case sym_branch: {
                    int32_t diff = target_address - (uint64_t) pc;
                    check_align();
                    diff /= sizeof(hive_instruction_t);
                    relative_check(POW2(24));
                    pc->type_branch_generic.offset = diff;
                }
                break;
            case sym_load: {
                    hive_instruction_t* s = ((hive_instruction_t*) (lc.data + current_address));
                    int32_t diff = target_address - (uint64_t) pc;
                    check_align();
                    diff /= sizeof(hive_instruction_t);
                    relative_check(POW2(19));
                    pc->type_load_signed.imm = diff;
                }
                break;
            case sym_ls_off: {
                    hive_instruction_t* s = ((hive_instruction_t*) (lc.data + current_address));
                    int32_t diff = target_address - (uint64_t) pc;
                    check_align();
                    diff /= sizeof(hive_instruction_t);
                    relative_check(POW2(16));
                    pc->type_load_ls_off.imm = diff;
                }
                break;
        }
    }
    if (has_errors) {
        exit(1);
    }
}

void prepare(Hive64File_Array hf, bool try_relocate, Symbol_Array* all_syms) {
    for (size_t i = 0; i < hf.count; i++) {
        Symbol_Array syms = hf.items[i].symbols;
        if (syms.items == NULL) continue;
        
        for (size_t j = 0; j < syms.count; j++) {
            Section sect = hf.items[i].load_commands.items[syms.items[j].section];
            if (sect.data == NULL) {
                fprintf(stderr, "Section %llu does not exist (max is %zu)\n", syms.items[j].section, hf.items[i].load_commands.count);
                continue;
            }
            syms.items[j].offset += (uint64_t) sect.data;
        }
        nob_da_append_many(all_syms, syms.items, syms.count);
    }

    if (try_relocate) {
        for (size_t i = 0; i < hf.count; i++) {
            Relocation_Array relocs = hf.items[i].relocations;
            if (relocs.items == NULL) continue;

            relocate(hf.items[i].load_commands, relocs, *all_syms);
        }

        for (size_t i = 0; i < hf.count; i++) {
            for (size_t s = 0; s < hf.items[i].load_commands.count; s++) {
                size_t sz = pad_to_instr_size(hf.items[i].load_commands.items[s].len_unpacked);
                if (hf.items[i].load_commands.items[s].type == SECT_TYPE_TEXT) {
                    mprotect(hf.items[i].load_commands.items[s].data, sz, PROT_READ | PROT_EXEC);
                } else if (hf.items[i].load_commands.items[s].type == SECT_TYPE_DATA) {
                    mprotect(hf.items[i].load_commands.items[s].data, sz, PROT_READ);
                } else if (hf.items[i].load_commands.items[s].type == SECT_TYPE_ZERO) {
                    mprotect(hf.items[i].load_commands.items[s].data, sz, PROT_NONE);
                } else if (hf.items[i].load_commands.items[s].type == SECT_TYPE_BSS) {
                    mprotect(hf.items[i].load_commands.items[s].data, sz, PROT_READ | PROT_WRITE);
                } else {
                    fprintf(stderr, "Unknown section: %x\n", hf.items[i].load_commands.items[s].type);
                }
            }
        }
    }
}
