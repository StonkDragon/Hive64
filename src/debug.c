#include <math.h>
#include <signal.h>
#include <setjmp.h>
#include <time.h>

#include "new_ops.h"

void exec_instr(hive_instruction_t ins, hive_register_t* r, hive_flag_register_t* fr, hive_vector_register_t* v);
char* dis(hive_instruction_t ins, uint64_t addr);

jmp_buf reset_buf;

void sighandler(int sig) {
    longjmp(reset_buf, sig);
}

uint32_t next_instr(bool brute_force) {
    uint32_t instr = 0;
    if (brute_force) {
        static uint32_t next = 0;
        instr = htonl(next++);
    } else {
        instr = rand();
    }

    return instr;
}

bool is_svc(hive_instruction_t ins) {
    return ins.generic.type == MODE_LOAD && ins.type_load.op == OP_LOAD_svc;
}

int debug(int argc, char** argv) {
    signal(SIGILL, sighandler);
    signal(SIGSEGV, sighandler);
    signal(SIGBUS, sighandler);
    srand(time(NULL));

    FILE* log = fopen("h64-debug.log", "w");
    union {
        uint32_t x;
        hive_instruction_t ins;
    } x;
    hive_register_t regs[32] = {0};
    hive_flag_register_t fr;
    hive_vector_register_t v[16] = {0};

    bool brute_force = false;
    for (int i = 1; i < argc; i++) {
        if (argv[i][0] == '-') {
            if (argv[i][1] == 'b') {
                brute_force = true;
            }
        }
    }

    while (1) {
        for (size_t i = 0; i < REG_LR; i++) {
            regs[i].asQWord = rand() | ((QWord_t) rand()) << 32;
        }
        hive_register_t prev[32];
        memcpy(prev, regs, sizeof(prev));
        fr.dword = 0;
        memset(v, 0, sizeof(v));
        x.x = next_instr(brute_force);

        int caused = 0;
        char* instr = dis(x.ins, 0);
        typeof(x) orig = x;
        if (instr == NULL || strcmp(instr, "svc")) {
            orig.ins.generic.condition = COND_ALWAYS;
        }
        if (!is_svc(orig.ins)) {
            if ((caused = setjmp(reset_buf)) == 0) {
                exec_instr(orig.ins, regs, &fr, v);
            }
        }
        memset(reset_buf, 0, sizeof(reset_buf));
        
        fprintf(log, "\t%-45s %08x\n", instr, x.x);
        printf("\t%-45s %08x\n", instr, x.x);
        if (caused) {
            fprintf(log, "\t  caused %s\n", strsignal(caused));
        }
        if (fr.dword) {
            fprintf(log, "\t  changed flags -> %08x\n", fr.dword);
        }
        for (size_t r = 0; r < 32; r++) {
            if (regs[r].asQWord != prev[r].asQWord) {
                fprintf(log, "\t  changed r%zu %016llx -> %016llx\n", r, prev[r].asQWord, regs[r].asQWord);
            }
        }
        for (size_t r = 0; r < 16; r++) {
            for (size_t n = 0; n < 4; n++) {
                if (v[r].asQWords[n]) {
                    fprintf(log, "\t  changed v%zu ->\n", r);
                    fprintf(log, "\t    .b = { ");
                    for (size_t j = 0; j < 32; j++) {
                        fprintf(log, "\t0x%02x ", v[r].asBytes[j]);
                    }
                    fprintf(log, "\t    }\n");
                    fprintf(log, "\t    .w = { ");
                    for (size_t j = 0; j < 16; j++) {
                        fprintf(log, "\t0x%04x ", v[r].asWords[j]);
                    }
                    
                    fprintf(log, "\t    }\n");
                    fprintf(log, "\t    .d = { ");
                    for (size_t j = 0; j < 8; j++) {
                        fprintf(log, "\t0x%08x ", v[r].asDWords[j]);
                    }
                    
                    fprintf(log, "\t    }\n");
                    fprintf(log, "\t    .q = { ");
                    for (size_t j = 0; j < 4; j++) {
                        fprintf(log, "\t0x%016llx ", v[r].asQWords[j]);
                    }
                    
                    fprintf(log, "\t    }\n");
                    fprintf(log, "\t    .s = { ");
                    for (size_t j = 0; j < 8; j++) {
                        fprintf(log, "\t%f ", v[r].asFloat32s[j]);
                    }
                    
                    fprintf(log, "\t    }\n");
                    fprintf(log, "\t    .f = { ");
                    for (size_t j = 0; j < 4; j++) {
                        fprintf(log, "\t%f ", v[r].asFloat64s[j]);
                    }
                    
                    fprintf(log, "\t    }\n");
                    break;
                }
            }
        }
    }
    return 1;
}
