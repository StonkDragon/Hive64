#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdarg.h>
#include <time.h>
#include <math.h>
#include <ctype.h>
#include <signal.h>

#include "new_ops.h"

#define SVC(what) [SVC_ ## what] = (svc_call) &what

hive_register_file_t* registers;
hive_vector_register_t* vector_registers;
hive_register_t cr[8] = {0};

QWord_t coredump(QWord_t x) {
    printf("Registers:\n");
    for (size_t i = 0; i < 32; i++) {
        printf("  r%zu: 0x%llx %f %f\n", i, registers->r[i].asQWord, registers->r[i].asFloat64, registers->r[i].asFloat32);
    }
    printf("Vector Registers:\n");
    for (size_t i = 0; i < 16; i++) {
        printf("  v%zu:\n", i);
        printf("    .b = { ");
        for (size_t j = 0; j < 32; j++) {
            printf("0x%02x ", vector_registers[i].asBytes[j]);
        }
        printf("}\n");
        printf("    .w = { ");
        for (size_t j = 0; j < 16; j++) {
            printf("0x%04x ", vector_registers[i].asWords[j]);
        }
        
        printf("}\n");
        printf("    .d = { ");
        for (size_t j = 0; j < 8; j++) {
            printf("0x%08x ", vector_registers[i].asDWords[j]);
        }
        
        printf("}\n");
        printf("    .q = { ");
        for (size_t j = 0; j < 4; j++) {
            printf("0x%016llx ", vector_registers[i].asQWords[j]);
        }
        
        printf("}\n");
        printf("    .s = { ");
        for (size_t j = 0; j < 8; j++) {
            printf("%f ", vector_registers[i].asFloat32s[j]);
        }
        
        printf("}\n");
        printf("    .f = { ");
        for (size_t j = 0; j < 4; j++) {
            printf("%f ", vector_registers[i].asFloat64s[j]);
        }
        
        printf("}\n");
    }
    return x;
}

svc_call svcs[] = {
    SVC(exit),
    SVC(read),
    SVC(write),
    SVC(open),
    SVC(close),
    SVC(malloc),
    SVC(free),
    SVC(realloc),
    SVC(coredump),
};

#ifdef __printflike
__printflike(1, 2)
#endif
char* strformat(const char* fmt, ...) {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wformat-security"
    va_list l;
    va_start(l, fmt);
    size_t len = vsnprintf(NULL, 0, fmt, l) + 1;
    if (len == 0) {
        va_end(l);
        return NULL;
    }
    char* data = malloc(len);
    vsnprintf(data, len, fmt, l);
    va_end(l);
    return data;
    #pragma clang diagnostic pop
}

bool strends(const char* str, const char* suf) {
    if (str == NULL || suf == NULL) return false;
    
    size_t str_len = strlen(str);
    size_t suf_len = strlen(suf);
    
    if (suf_len > str_len) return false;
    if (suf_len == str_len) return strncmp(str, suf, str_len) == 0;
    
    const char* suf_str = (const char*) (((size_t) str) + str_len - suf_len);
    
    return strncmp(suf_str, suf, suf_len) == 0;
}

char* reformat(const char* str, const char* remove, const char* add) {
    if (!strends(str, remove)) return strformat("%s%s", str, add);
    size_t str_len = strlen(str);
    size_t remove_len = strlen(remove);
    size_t add_len = strlen(add);
    char* s = malloc(str_len - remove_len + add_len + 1);
    strncpy(s, str, str_len - remove_len);
    strcat(s, add);
    return s;
}

int main(int argc, char **argv) {
#define HIVE64_AS   "h64-as"
#define HIVE64_LD   "h64-ld"
#define HIVE64_DIS  "h64-dis"
#define HIVE64_DBG  "h64-dbg"
#define HIVE64_RUN  "h64"

    const char* exe_name = argv[0];

    char* s = strrchr(exe_name, '/');
    if (s) {
        exe_name = (const char*) (((size_t) s) + 1);
    }

    if (strcmp(exe_name, HIVE64_AS) == 0) {
        if (argc < 2) {
            fprintf(stderr, "Usage: %s <srcfile>\n", exe_name);
            return 1;
        }

        Nob_File_Paths files = {0};
        for (int i = 1; i < argc; i++) {
            if (strends(argv[i], ".hive64")) {
                nob_da_append(&files, argv[i]);
            }
        }

        for (size_t i = 0; i < files.count; i++) {
            Symbol_Offsets syms = {0};
            Symbol_Offsets relocations = {0};
            Nob_String_Builder code = run_compile(files.items[i], &syms, &relocations);

            if (code.items == NULL) {
                fprintf(stderr, "Failed to compile file %s\n", files.items[i]);
                continue;
            }

            Section code_sect = {
                .data = code.items,
                .len = code.count,
                .type = SECT_TYPE_CODE
            };
            Nob_String_Builder sym_sect_data = pack_symbol_table(syms);
            Nob_String_Builder reloc_sect_data = pack_relocation_table(relocations);

            Section sym_sect = {
                .data = sym_sect_data.items,
                .len = sym_sect_data.count,
                .type = SECT_TYPE_SYMS
            };

            Section reloc_sect = {
                .data = reloc_sect_data.items,
                .len = reloc_sect_data.count,
                .type = SECT_TYPE_RELOC
            };

            Section_Array sa = {0};
            nob_da_append(&sa, code_sect);
            nob_da_append(&sa, sym_sect);
            nob_da_append(&sa, reloc_sect);

            HiveFile hf = {
                .magic = HIVE_FILE_MAGIC,
                .sects = sa
            };
            
            FILE* f = fopen(reformat(files.items[i], ".hive64", ".rcx"), "wb");
            write_hive_file(hf, f);
            fclose(f);
        }
        return 0;
    } else if (strcmp(exe_name, HIVE64_LD) == 0) {
        char* outfile = "out.rcx";
        Nob_File_Paths link_with = {0};
        for (int i = 1; i < argc; i++) {
            if (argv[i][0] == '-' && argv[i][1] == 'o') {
                i++;
                if (i >= argc) {
                    fprintf(stderr, "-o expects one argument!\n");
                    return 1;
                }
                outfile = argv[i];
            } else if (strends(argv[i], ".rcx")) {
                nob_da_append(&link_with, argv[i]);
            }
        }

        HiveFile_Array hf = {0};
        for (size_t i = 0; i < link_with.count; i++) {
            get_all_files(link_with.items[i], &hf, false);
        }
        HiveFile dummy = {
            .magic = HIVE_FAT_FILE_MAGIC,
            .sects = {0}
        };

        for (size_t i = 0; i < link_with.count; i++) {
            FILE* fp = fopen(link_with.items[i], "rb");
            Section s = {0};

            size_t file_name_size = strlen(link_with.items[i]);
            
            fseek(fp, 0, SEEK_END);
            size_t file_size = ftell(fp);
            fseek(fp, 0, SEEK_SET);

            s.len = file_size + file_name_size + sizeof(size_t);
            s.data = malloc(s.len * sizeof(*s.data));

            *(size_t*) s.data = file_name_size;
            
            strncpy(s.data + sizeof(size_t), link_with.items[i], file_name_size);
            fread(s.data + file_name_size + sizeof(size_t), sizeof(*s.data), s.len, fp);
            nob_da_append(&dummy.sects, s);
        }

        FILE* f = fopen(outfile, "wb");
        write_hive_file(dummy, f);
        fclose(f);
    } else if (strcmp(exe_name, HIVE64_RUN) == 0) {
        HiveFile_Array hf = {0};
        get_all_files(argv[1], &hf, true);
        
        Symbol_Offsets all_syms = prepare(hf, true);

        hive_register_file_t regs = {0};
        hive_vector_register_t vregisters[16];

        registers = &regs;
        vector_registers = vregisters;


        char stack[1024 * 1024];
        regs.r[REG_PC].asQWord = find_symbol_address(all_syms, "_start");
        QWord_t stack_hi = regs.r[REG_SP].asQWord = ((QWord_t) stack) + sizeof(stack);
        mmu_prefetch((void*) (stack_hi - 64));

        if (regs.r[REG_PC].asSQWord != -1) {
            exec(regs.r, &regs.flags, vregisters);
            return regs.r[0].asSDWord;
        }
        
        fprintf(stderr, "Could not find _start symbol\n");
        return 1;
    } else if (strcmp(exe_name, HIVE64_DBG) == 0) {
        return debug(argc, argv);
    } else if (strcmp(exe_name, HIVE64_DIS) == 0) {
        HiveFile_Array hf = {0};
        get_all_files(argv[1], &hf, false);
        
        Symbol_Offsets all_syms = prepare(hf, false);

        for (size_t i = 0; i < hf.count; i++) {
            if (hf.items[i].magic != HIVE_FAT_FILE_MAGIC) {
                printf("%s:\n", hf.items[i].name);
                disassemble(get_section(hf.items[i], SECT_TYPE_CODE), all_syms, create_relocation_section(get_section(hf.items[i], SECT_TYPE_RELOC)));
            }
        }
        return 0;
    } else {
        fprintf(stderr, "Unknown command '%s'\n", exe_name);
        return 1;
    }
}
