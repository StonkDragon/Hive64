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
    printf("Flags: %08x\n", state->cr[CR_FLAGS].asDWord);
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

void* sys_mmap(void* addr, size_t sz, int prot, int map, int fd, long long off) {
    return mmap((void*) ((uint64_t) HIVE_MEMORY_BASE + (uint64_t) addr), sz, prot, map, fd, off);
}

svc_call svcs[] = {
    SVC(exit),
    SVC(read),
    SVC(write),
    SVC(open),
    SVC(close),
    SVC(sys_mmap),
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

            LoadCommand_Array sa = {0};
            for (size_t i = 0; i < code.count; i++) {
                Section s = {
                    .data = code.items[i].data.items,
                    .len = code.items[i].data.count,
                    .len_unpacked = code.items[i].data.count,
                    .type = code.items[i].type,
                };
                nob_da_append(&sa, s);
            } 

            Hive64File hf = {
                .magic = HIVE64_FILE_MAGIC,
                .libraries = {0},
                .load_commands = sa,
                .relocations = relocations,
                .symbols = syms,
            };

            FILE* f = fopen(reformat(files.items[i], ".hive64", ".rcx"), "wb");
            write_h64_file(f, hf);
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

        Hive64File file = {
            .magic = HIVE64_FILE_MAGIC,
            .libraries = dlibs,
        };
        
        for (size_t i = 0; i < link_with.count; i++) {
            FILE* fp = fopen(link_with.items[i], "rb");
            Hive64File_Array data = read_h64_file(fp, false);
            
            for (size_t f = 0; f < data.count; f++) {
                for (size_t k = 0; k < data.items[f].relocations.count; k++) {
                    data.items[f].relocations.items[k].source_section += file.load_commands.count;
                    if (data.items[f].relocations.items[k].is_local) {
                        data.items[f].relocations.items[k].data.local.target_section += file.load_commands.count;
                    }
                }
                for (size_t k = 0; k < data.items[f].symbols.count; k++) {
                    data.items[f].symbols.items[k].section += file.load_commands.count;
                }
                nob_da_append_many(&file.load_commands, data.items[f].load_commands.items, data.items[f].load_commands.count);
                nob_da_append_many(&file.relocations, data.items[f].relocations.items, data.items[f].relocations.count);
                nob_da_append_many(&file.symbols, data.items[f].symbols.items, data.items[f].symbols.count);
                nob_da_append_many(&file.libraries, data.items[f].libraries.items, data.items[f].libraries.count);
            }

            remove(link_with.items[i]);
        }
        
        FILE* f = fopen(outfile, "wb");
        write_h64_file(f, file);
        fclose(f);
    } else if (is_run_cmd(exe_name) || strcmp(exe_name, "h64") == 0) {
        FILE* fp = fopen(argv[1], "rb");
        Hive64File_Array hf = read_h64_file(fp, true);
        fclose(fp);
        
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
        FILE* fp = fopen(argv[1], "rb");
        Hive64File_Array hf = read_h64_file(fp, false);
        fclose(fp);
        
        Symbol_Array all_syms = {0};
        prepare(hf, false, &all_syms);

        for (size_t i = 0; i < hf.count; i++) {
            for (size_t j = 0; j < hf.items[i].load_commands.count; j++) {
                if (hf.items[i].load_commands.items[j].type != SECT_TYPE_TEXT) continue;
                disassemble(hf.items[i].load_commands.items[j], all_syms, hf.items[i].relocations);
            }
        }
        return 0;
    } else {
        fprintf(stderr, "Unknown command '%s'\n", exe_name);
        return 1;
    }
}
