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
#include <pthread.h>
#include <sys/mman.h>

#include "new_ops.h"

#define SVC(what) [SVC_ ## what] = (svc_call) &what

void coredump(struct cpu_state* state) {
    printf("Flags: %08x\n", state->fr.dword);
    printf("Registers:\n");
    for (size_t i = 0; i < 32; i++) {
        printf("  r%zu: 0x%llx %f %f\n", i, state->r[i].asQWord, state->r[i].asFloat64, state->r[i].asFloat32);
    }
    printf("Vector Registers:\n");
    for (size_t i = 0; i < 16; i++) {
        printf("  v%zu:\n", i);
        printf("    .b = { ");
        for (size_t j = 0; j < 32; j++) {
            printf("0x%02x ", state->v[i].asBytes[j]);
        }
        printf("}\n");
        printf("    .w = { ");
        for (size_t j = 0; j < 16; j++) {
            printf("0x%04x ", state->v[i].asWords[j]);
        }
        
        printf("}\n");
        printf("    .d = { ");
        for (size_t j = 0; j < 8; j++) {
            printf("0x%08x ", state->v[i].asDWords[j]);
        }
        
        printf("}\n");
        printf("    .q = { ");
        for (size_t j = 0; j < 4; j++) {
            printf("0x%016llx ", state->v[i].asQWords[j]);
        }
        
        printf("}\n");
        printf("    .s = { ");
        for (size_t j = 0; j < 8; j++) {
            printf("%f ", state->v[i].asFloat32s[j]);
        }
        
        printf("}\n");
        printf("    .f = { ");
        for (size_t j = 0; j < 4; j++) {
            printf("%f ", state->v[i].asFloat64s[j]);
        }
        
        printf("}\n");
    }
}

svc_call svcs[] = {
    SVC(exit),
    SVC(read),
    SVC(write),
    SVC(open),
    SVC(close),
    SVC(mmap),
    SVC(munmap),
    SVC(mprotect),
    SVC(fstat),
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

bool in_cmds(char** cmds, const char* s) {
    size_t ptr = 0;
    while (cmds[ptr]) {
        if (strcmp(cmds[ptr++], s) == 0) return true;
    }
    return false;
}

#define IS(_type) \
bool is_ ## _type ## _cmd(const char* s) { \
    char* cmds[] = { \
        "h64-" #_type, \
        "hive64-unknown-" #_type, \
        NULL, \
    }; \
    return in_cmds(cmds, s); \
}

IS(as)
IS(ld)
IS(dis)
IS(run)
IS(shell)

int main(int argc, char **argv) {
    const char* exe_name = argv[0];

    char* s = strrchr(exe_name, '/');
    if (s) {
        exe_name = (const char*) (((size_t) s) + 1);
    }

    if (is_as_cmd(exe_name)) {
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
            Symbol_Array syms = {0};
            Relocation_Array relocations = {0};
            SB_Array code = run_compile(files.items[i], &syms, &relocations);

            if (code.items == NULL) {
                fprintf(stderr, "Failed to compile file %s\n", files.items[i]);
                continue;
            }

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
            for (size_t i = 0; i < code.count; i++) {
                Section s = {
                    .data = code.items[i].data.items,
                    .len = code.items[i].data.count,
                    .type = code.items[i].type,
                };
                nob_da_append(&sa, s);
            } 
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
    } else if (is_ld_cmd(exe_name)) {
        char* outfile = "out.rcx";
        Nob_File_Paths link_with = {0};
        Nob_File_Paths dlibs = {0};
        for (int i = 1; i < argc; i++) {
            if (argv[i][0] == '-' && argv[i][1] == 'o') {
                i++;
                if (i >= argc) {
                    fprintf(stderr, "-o expects one argument!\n");
                    return 1;
                }
                outfile = argv[i];
            } else if (argv[i][0] == '-' && argv[i][1] == 'l') {
                char* dlib = NULL;
                if (argv[i][2] == 0) {
                    i++;
                    if (i >= argc) {
                        fprintf(stderr, "-o expects one argument!\n");
                        return 1;
                    }
                    dlib = argv[i];
                } else {
                    dlib = argv[i] + 2;
                }
                if (dlib[0] == ':') {
                    nob_da_append(&dlibs, dlib + 1);
                } else {
                    nob_da_append(&dlibs, strformat("lib%s.dll", dlib));
                }
            } else if (strends(argv[i], ".rcx")) {
                nob_da_append(&link_with, argv[i]);
            }
        }

        Nob_String_Builder ld_sect_data = pack_ld_section(dlibs);
        Section ld_sect = {
            .data = ld_sect_data.items,
            .len = ld_sect_data.count,
            .type = SECT_TYPE_LD,
        };
        HiveFile dl = {
            .magic = HIVE_FILE_MAGIC,
            .sects = {0},
            .name = "__DYLD__",
        };
        nob_da_append(&dl.sects, ld_sect);
        
        FILE* fp = fopen("__DYLD__", "wb");
        write_hive_file(dl, fp);
        fclose(fp);
        nob_da_append(&link_with, "__DYLD__");

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

            remove(link_with.items[i]);
        }

        remove("__DYLD__");

        FILE* f = fopen(outfile, "wb");
        write_hive_file(dummy, f);
        fclose(f);
    } else if (is_run_cmd(exe_name) || strcmp(exe_name, "h64") == 0) {
        HiveFile_Array hf = {0};
        get_all_files(argv[1], &hf, true, true);
        
        Symbol_Array all_syms = {0};
        prepare(hf, true, &all_syms);

        exec((void*) find_symbol_address(all_syms, "_start"));
        fprintf(stderr, "Could not find _start symbol\n");
        return 1;
    } else if (is_shell_cmd(exe_name)) {
        void shell();
        shell();
        return 0;
    } else if (is_dis_cmd(exe_name)) {
        HiveFile_Array hf = {0};
        get_all_files(argv[1], &hf, false, false);
        
        Symbol_Array all_syms = {0};
        prepare(hf, false, &all_syms);

        for (size_t i = 0; i < hf.count; i++) {
            if (hf.items[i].magic != HIVE_FAT_FILE_MAGIC && strcmp(hf.items[i].name, "__DYLD__")) {
                printf("%s:\n", hf.items[i].name);
                disassemble(get_section(hf.items[i], SECT_TYPE_TEXT), all_syms, create_relocation_section(get_section(hf.items[i], SECT_TYPE_RELOC)));
            }
        }
        return 0;
    } else {
        fprintf(stderr, "Unknown command '%s'\n", exe_name);
        return 1;
    }
}
