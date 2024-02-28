#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <unistd.h>
#include <errno.h>
#include <signal.h>
#include <dlfcn.h>
#include <execinfo.h>
#include <fcntl.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <ctype.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/ptrace.h>
#include <sys/syscall.h>
#include <setjmp.h>

#define NOB_IMPLEMENTATION
#include "nob.h"
#include "new_ops.h"

typedef QWord_t(*svc_call)(QWord_t,QWord_t,QWord_t,QWord_t,QWord_t,QWord_t,QWord_t,QWord_t);

#define SVC_exit        0
#define SVC_read        1
#define SVC_write       2
#define SVC_open        3
#define SVC_close       4
#define SVC_mmap        5
#define SVC_munmap      6
#define SVC_mprotect    7

#define SVC(what) [SVC_ ## what] = (svc_call) &what

svc_call svcs[] = {
    SVC(exit),
    SVC(read),
    SVC(write),
    SVC(open),
    SVC(close),
    SVC(mmap),
    SVC(munmap),
    SVC(mprotect),
};

hive_register_file_t exec_svc(hive_register_file_t regs) {
    regs.r[0].asQWord = svcs[regs.r[8].asQWord](
        regs.r[0].asQWord,
        regs.r[1].asQWord,
        regs.r[2].asQWord,
        regs.r[3].asQWord,
        regs.r[4].asQWord,
        regs.r[5].asQWord,
        regs.r[6].asQWord,
        regs.r[7].asQWord
    );
    return regs;
}
    // lt, mi   -> negative
    // gt       -> !equal && !negative
    // ge, pl   -> !negative
    // le       -> negative || equal
    // eq, z    -> equal
    // ne, nz   -> !equal
#define set_flags(fr, res) ({ \
    typeof(res) _res = (res); \
    (fr).equal = (_res == 0); \
    (fr).negative = (_res < 0); \
    _res; \
})
#define test(fr, a, b) set_flags((fr), (a) & (b))
#define cmp(fr, a, b) set_flags((fr), (a) - (b))

#define BRANCH(to)                  ({ regs.pc.asInstrPtr = (hive_instruction_t*) (to); return regs; })
#define LINK()                      (regs.lr.asQWord = regs.pc.asQWord)
#define LINK_ON(what)               ({ if ((what)) { LINK(); } })
#define BRANCH_LINK(to)             (LINK(), BRANCH(to))
#define BRANCH_ON(to, what)         ({ if ((what)) { BRANCH(to); } })
#define BRANCH_LINK_ON(to, what)    ({ if ((what)) { BRANCH_LINK(to); } })
#define PC_REL(what)                (regs.pc.asQWord + (what) * sizeof(hive_instruction_t))

hive_register_file_t exec_fpu_type(hive_register_file_t regs, hive_instruction_t ins) {
    switch (ins.float_rrr.op) {
        case OP_FLOAT_add:
            regs.r[ins.float_rrr.r1].asFloat64 = set_flags(regs.flags, regs.r[ins.float_rrr.r2].asFloat64 + regs.r[ins.float_rrr.r3].asFloat64);
            break;
        case OP_FLOAT_addi:
            regs.r[ins.float_rrr.r1].asFloat64 = set_flags(regs.flags, regs.r[ins.float_rrr.r2].asFloat64 + regs.r[ins.float_rrr.r3].asSQWord);
            break;
        case OP_FLOAT_sub:
            regs.r[ins.float_rrr.r1].asFloat64 = set_flags(regs.flags, regs.r[ins.float_rrr.r2].asFloat64 - regs.r[ins.float_rrr.r3].asFloat64);
            break;
        case OP_FLOAT_subi:
            regs.r[ins.float_rrr.r1].asFloat64 = set_flags(regs.flags, regs.r[ins.float_rrr.r2].asFloat64 - regs.r[ins.float_rrr.r3].asSQWord);
            break;
        case OP_FLOAT_mul:
            regs.r[ins.float_rrr.r1].asFloat64 = set_flags(regs.flags, regs.r[ins.float_rrr.r2].asFloat64 * regs.r[ins.float_rrr.r3].asFloat64);
            break;
        case OP_FLOAT_muli:
            regs.r[ins.float_rrr.r1].asFloat64 = set_flags(regs.flags, regs.r[ins.float_rrr.r2].asFloat64 * regs.r[ins.float_rrr.r3].asSQWord);
            break;
        case OP_FLOAT_div:
            regs.r[ins.float_rrr.r1].asFloat64 = set_flags(regs.flags, regs.r[ins.float_rrr.r2].asFloat64 / regs.r[ins.float_rrr.r3].asFloat64);
            break;
        case OP_FLOAT_divi:
            regs.r[ins.float_rrr.r1].asFloat64 = set_flags(regs.flags, regs.r[ins.float_rrr.r2].asFloat64 / regs.r[ins.float_rrr.r3].asSQWord);
            break;
        case OP_FLOAT_mod:
            regs.r[ins.float_rrr.r1].asFloat64 = set_flags(regs.flags, fmod(regs.r[ins.float_rrr.r2].asFloat64, regs.r[ins.float_rrr.r3].asFloat64));
            break;
        case OP_FLOAT_modi:
            regs.r[ins.float_rrr.r1].asFloat64 = set_flags(regs.flags, fmod(regs.r[ins.float_rrr.r2].asFloat64, (Float64_t) regs.r[ins.float_rrr.r3].asSQWord));
            break;
        case OP_FLOAT_i2f:
            regs.r[ins.float_rrr.r1].asFloat64 = set_flags(regs.flags, (Float64_t) regs.r[ins.float_rrr.r2].asSQWord);
            break;
        case OP_FLOAT_f2i:
            regs.r[ins.float_rrr.r1].asSQWord = set_flags(regs.flags, (SQWord_t) regs.r[ins.float_rrr.r2].asFloat64);
            break;
        case OP_FLOAT_sin:
            regs.r[ins.float_rrr.r1].asFloat64 = set_flags(regs.flags, sin(regs.r[ins.float_rrr.r2].asFloat64));
            break;
        case OP_FLOAT_sqrt:
            regs.r[ins.float_rrr.r1].asFloat64 = set_flags(regs.flags, sqrt(regs.r[ins.float_rrr.r2].asFloat64));
            break;
        case OP_FLOAT_cmp:
            set_flags(regs.flags, regs.r[ins.float_rrr.r2].asFloat64 - regs.r[ins.float_rrr.r3].asFloat64);
            break;
        case OP_FLOAT_cmpi:
            set_flags(regs.flags, regs.r[ins.float_rrr.r2].asFloat64 - regs.r[ins.float_rrr.r3].asSQWord);
            break;
        default:
            raise(SIGILL);
            break;
    }
    return regs;
}

#define ROL(_a, _b) ((_a) >> (_b)) | ((_a) << ((sizeof(typeof(_a)) << 3) - (_b)))
#define ROR(_a, _b) ((_a) << (_b)) | ((_a) >> ((sizeof(typeof(_a)) << 3) - (_b)))

hive_register_file_t exec_branch_type(hive_register_file_t regs, hive_instruction_t ins) {
    switch (ins.branch.op) {
        case OP_BRANCH_b:
            if (ins.branch.link) LINK();
            BRANCH(PC_REL(ins.branch.offset));
            break;
        case OP_BRANCH_blt:
            if (ins.branch.link) LINK_ON(regs.flags.negative);
            BRANCH_ON(PC_REL(ins.branch.offset), regs.flags.negative);
            break;
        case OP_BRANCH_bgt:
            if (ins.branch.link) LINK_ON(!regs.flags.negative && !regs.flags.equal);
            BRANCH_ON(PC_REL(ins.branch.offset), !regs.flags.negative && !regs.flags.equal);
            break;
        case OP_BRANCH_bge:
            if (ins.branch.link) LINK_ON(!regs.flags.negative);
            BRANCH_ON(PC_REL(ins.branch.offset), !regs.flags.negative);
            break;
        case OP_BRANCH_ble:
            if (ins.branch.link) LINK_ON(regs.flags.negative || regs.flags.equal);
            BRANCH_ON(PC_REL(ins.branch.offset), regs.flags.negative || regs.flags.equal);
            break;
        case OP_BRANCH_beq:
            if (ins.branch.link) LINK_ON(regs.flags.equal);
            BRANCH_ON(PC_REL(ins.branch.offset), regs.flags.equal);
            break;
        case OP_BRANCH_bne:
            if (ins.branch.link) LINK_ON(!regs.flags.equal);
            BRANCH_ON(PC_REL(ins.branch.offset), !regs.flags.equal);
            break;
        case OP_BRANCH_cb:
            set_flags(regs.flags, regs.r[ins.comp_branch.r1].asQWord);
                if (ins.branch.link) LINK_ON(regs.flags.equal == ins.comp_branch.zero);
            BRANCH_ON(PC_REL(ins.comp_branch.offset), regs.flags.equal == ins.comp_branch.zero);
            break;
        default:
            raise(SIGILL);
            break;
    }
    regs.pc.asInstrPtr++;
    return regs;
}

hive_register_file_t exec_rri_type(hive_register_file_t regs, hive_instruction_t ins) {
    switch (ins.rri.op) {
        case OP_RRI_add:
            regs.r[ins.rri.r1].asQWord = set_flags(regs.flags, regs.r[ins.rri.r2].asQWord + (QWord_t) ins.rri.imm);
            break;
        case OP_RRI_sub:
            regs.r[ins.rri.r1].asQWord = set_flags(regs.flags, regs.r[ins.rri.r2].asQWord - (QWord_t) ins.rri.imm);
            break;
        case OP_RRI_mul:
            regs.r[ins.rri.r1].asQWord = set_flags(regs.flags, regs.r[ins.rri.r2].asQWord * (QWord_t) ins.rri.imm);
            break;
        case OP_RRI_div:
            regs.r[ins.rri.r1].asQWord = set_flags(regs.flags, regs.r[ins.rri.r2].asQWord / (QWord_t) ins.rri.imm);
            break;
        case OP_RRI_mod:
            regs.r[ins.rri.r1].asQWord = set_flags(regs.flags, regs.r[ins.rri.r2].asQWord % (QWord_t) ins.rri.imm);
            break;
        case OP_RRI_and:
            regs.r[ins.rri.r1].asQWord = set_flags(regs.flags, regs.r[ins.rri.r2].asQWord & (QWord_t) ins.rri.imm);
            break;
        case OP_RRI_or:
            regs.r[ins.rri.r1].asQWord = set_flags(regs.flags, regs.r[ins.rri.r2].asQWord | (QWord_t) ins.rri.imm);
            break;
        case OP_RRI_xor:
            regs.r[ins.rri.r1].asQWord = set_flags(regs.flags, regs.r[ins.rri.r2].asQWord ^ (QWord_t) ins.rri.imm);
            break;
        case OP_RRI_shl:
            regs.r[ins.rri.r1].asQWord = set_flags(regs.flags, regs.r[ins.rri.r2].asQWord << (QWord_t) ins.rri.imm);
            break;
        case OP_RRI_shr:
            regs.r[ins.rri.r1].asQWord = set_flags(regs.flags, regs.r[ins.rri.r2].asQWord >> (QWord_t) ins.rri.imm);
            break;
        case OP_RRI_rol:
            #ifdef __aarch64__
            asm("ror %0, %1, %2" : "=r"(regs.r[ins.rri.r1].asQWord) : "r"(regs.r[ins.rri.r2].asQWord), "r"((sizeof(QWord_t) * 8) - (QWord_t) ins.rri.imm));
            set_flags(regs.flags, regs.r[ins.rri.r1].asQWord);
            #else
            regs.r[ins.rri.r1].asQWord = set_flags(regs.flags, ROL(regs.r[ins.rri.r2].asQWord, ins.rri.imm));
            #endif
            break;
        case OP_RRI_ror:
            #ifdef __aarch64__
            asm("ror %0, %1, %2" : "=r"(regs.r[ins.rri.r1].asQWord) : "r"(regs.r[ins.rri.r2].asQWord), "r"((QWord_t) ins.rri.imm));
            set_flags(regs.flags, regs.r[ins.rri.r1].asQWord);
            #else
            regs.r[ins.rri.r1].asQWord = set_flags(regs.flags, ROR(regs.r[ins.rri.r2].asQWord, ins.rri.imm));
            #endif
            break;
        case OP_RRI_ldr:
            switch (ins.rri_ls.size) {
                case 0: regs.r[ins.rri_ls.r1].asSQWord = set_flags(regs.flags, *(SQWord_t*) (regs.r[ins.rri_ls.r2].asQWord + ins.rri_ls.imm)); break;
                case 1: regs.r[ins.rri_ls.r1].asSDWord = set_flags(regs.flags, *(SDWord_t*) (regs.r[ins.rri_ls.r2].asQWord + ins.rri_ls.imm)); break;
                case 2: regs.r[ins.rri_ls.r1].asSWord = set_flags(regs.flags, *(SWord_t*) (regs.r[ins.rri_ls.r2].asQWord + ins.rri_ls.imm)); break;
                case 3: regs.r[ins.rri_ls.r1].asSByte = set_flags(regs.flags, *(SByte_t*) (regs.r[ins.rri_ls.r2].asQWord + ins.rri_ls.imm)); break;
            }
            break;
        case OP_RRI_str:
            switch (ins.rri_ls.size) {
                case 0: *(SQWord_t*) (regs.r[ins.rri_ls.r2].asQWord + ins.rri_ls.imm) = set_flags(regs.flags, regs.r[ins.rri_ls.r1].asSQWord); break;
                case 1: *(SDWord_t*) (regs.r[ins.rri_ls.r2].asQWord + ins.rri_ls.imm) = set_flags(regs.flags, regs.r[ins.rri_ls.r1].asSDWord); break;
                case 2: *(SWord_t*) (regs.r[ins.rri_ls.r2].asQWord + ins.rri_ls.imm) = set_flags(regs.flags, regs.r[ins.rri_ls.r1].asSWord); break;
                case 3: *(SByte_t*) (regs.r[ins.rri_ls.r2].asQWord + ins.rri_ls.imm) = set_flags(regs.flags, regs.r[ins.rri_ls.r1].asSByte); break;
            }
            break;
        case OP_RRI_bext: {
                uint8_t lowest = ins.rri_bit.lowest;
                uint8_t num = ins.rri_bit.nbits;
                uint64_t mask = ((1ULL << num) - 1);
                uint64_t val = (regs.r[ins.rri.r2].asQWord & (mask << lowest)) >> lowest;
                if (ins.rri_bit.sign_extend) {
                    uint8_t sign_bit_mask = (1ULL << (num - 1));
                    if (val & sign_bit_mask) {
                        val |= ~mask;
                    }
                }
                regs.r[ins.rri.r1].asQWord = val;
            }
            break;
        case OP_RRI_bdep: {
                uint8_t lowest = ins.rri_bit.lowest;
                uint8_t num = ins.rri_bit.nbits;
                uint64_t mask = ((1ULL << num) - 1);
                regs.r[ins.rri.r1].asQWord &= ~(mask << lowest);
                regs.r[ins.rri.r1].asQWord |= (regs.r[ins.rri.r2].asQWord & mask) << lowest;
            }
            break;
        case OP_RRI_ldp:
            switch (ins.rri_rpairs.size) {
                case 0: {
                        regs.r[ins.rri_rpairs.r1].asQWord = *(QWord_t*) (regs.r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm);
                        regs.r[ins.rri_rpairs.r2].asQWord = *(QWord_t*) (regs.r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm + sizeof(QWord_t));
                    }
                    break;
                case 1: {
                        regs.r[ins.rri_rpairs.r1].asDWord = *(DWord_t*) (regs.r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm);
                        regs.r[ins.rri_rpairs.r1].asDWord = *(DWord_t*) (regs.r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm + sizeof(DWord_t));
                    }
                    break;
                case 2: {
                        regs.r[ins.rri_rpairs.r1].asWord = *(Word_t*) (regs.r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm);
                        regs.r[ins.rri_rpairs.r1].asWord = *(Word_t*) (regs.r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm + sizeof(Word_t));
                    }
                    break;
                case 3: {
                        regs.r[ins.rri_rpairs.r1].asByte = *(Byte_t*) (regs.r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm);
                        regs.r[ins.rri_rpairs.r1].asByte = *(Byte_t*) (regs.r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm + sizeof(Byte_t));
                    }
                    break;
            }
            break;
        case OP_RRI_stp:
            switch (ins.rri_rpairs.size) {
                case 0: {
                        *(QWord_t*) (regs.r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm) = regs.r[ins.rri_rpairs.r1].asQWord;
                        *(QWord_t*) (regs.r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm + sizeof(QWord_t)) = regs.r[ins.rri_rpairs.r2].asQWord;
                    }
                    break;
                case 1: {
                        *(DWord_t*) (regs.r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm) = regs.r[ins.rri_rpairs.r1].asDWord;
                        *(DWord_t*) (regs.r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm + sizeof(DWord_t)) = regs.r[ins.rri_rpairs.r2].asDWord;
                    }
                    break;
                case 2: {
                        *(Word_t*) (regs.r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm) = regs.r[ins.rri_rpairs.r1].asWord;
                        *(Word_t*) (regs.r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm + sizeof(Word_t)) = regs.r[ins.rri_rpairs.r2].asWord;
                    }
                    break;
                case 3: {
                        *(Byte_t*) (regs.r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm) = regs.r[ins.rri_rpairs.r1].asByte;
                        *(Byte_t*) (regs.r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm + sizeof(Byte_t)) = regs.r[ins.rri_rpairs.r2].asByte;
                    }
                    break;
            }
            break;
        default:
            raise(SIGILL);
            break;
    }
    regs.pc.asInstrPtr++;
    return regs;
}
hive_register_file_t exec_rrr_type(hive_register_file_t regs, hive_instruction_t ins) {
    switch (ins.rrr.op) {
        case OP_RRR_add:
            regs.r[ins.rrr.r1].asQWord = set_flags(regs.flags, regs.r[ins.rrr.r2].asQWord + regs.r[ins.rrr.r3].asQWord);
            break;
        case OP_RRR_sub:
            regs.r[ins.rrr.r1].asQWord = set_flags(regs.flags, regs.r[ins.rrr.r2].asQWord - regs.r[ins.rrr.r3].asQWord);
            break;
        case OP_RRR_mul:
            regs.r[ins.rrr.r1].asQWord = set_flags(regs.flags, regs.r[ins.rrr.r2].asQWord * regs.r[ins.rrr.r3].asQWord);
            break;
        case OP_RRR_div:
            regs.r[ins.rrr.r1].asQWord = set_flags(regs.flags, regs.r[ins.rrr.r2].asQWord / regs.r[ins.rrr.r3].asQWord);
            break;
        case OP_RRR_mod:
            regs.r[ins.rrr.r1].asQWord = set_flags(regs.flags, regs.r[ins.rrr.r2].asQWord % regs.r[ins.rrr.r3].asQWord);
            break;
        case OP_RRR_and:
            regs.r[ins.rrr.r1].asQWord = set_flags(regs.flags, regs.r[ins.rrr.r2].asQWord & regs.r[ins.rrr.r3].asQWord);
            break;
        case OP_RRR_or:
            regs.r[ins.rrr.r1].asQWord = set_flags(regs.flags, regs.r[ins.rrr.r2].asQWord | regs.r[ins.rrr.r3].asQWord);
            break;
        case OP_RRR_xor:
            regs.r[ins.rrr.r1].asQWord = set_flags(regs.flags, regs.r[ins.rrr.r2].asQWord ^ regs.r[ins.rrr.r3].asQWord);
            break;
        case OP_RRR_shl:
            regs.r[ins.rrr.r1].asQWord = set_flags(regs.flags, regs.r[ins.rrr.r2].asQWord << regs.r[ins.rrr.r3].asQWord);
            break;
        case OP_RRR_shr:
            regs.r[ins.rrr.r1].asQWord = set_flags(regs.flags, regs.r[ins.rrr.r2].asQWord >> regs.r[ins.rrr.r3].asQWord);
            break;
        case OP_RRR_rol:
            #ifdef __aarch64__
            asm("ror %0, %1, %2" : "=r"(regs.r[ins.rrr.r1].asQWord) : "r"(regs.r[ins.rrr.r2].asQWord), "r"((sizeof(QWord_t) * 8) - regs.r[ins.rrr.r3].asQWord));
            set_flags(regs.flags, regs.r[ins.rrr.r1].asQWord);
            #else
            regs.r[ins.rrr.r1].asQWord = set_flags(regs.flags, ROL(regs.r[ins.rrr.r2].asQWord, regs.r[ins.rrr.r3].asQWord));
            #endif
            break;
        case OP_RRR_ror:
            #ifdef __aarch64__
            asm("ror %0, %1, %2" : "=r"(regs.r[ins.rrr.r1].asQWord) : "r"(regs.r[ins.rrr.r2].asQWord), "r"(regs.r[ins.rrr.r3].asQWord));
            set_flags(regs.flags, regs.r[ins.rrr.r1].asQWord);
            #else
            regs.r[ins.rrr.r1].asQWord = set_flags(regs.flags, ROR(regs.r[ins.rrr.r2].asQWord, regs.r[ins.rrr.r3].asQWord));
            #endif
            break;
        case OP_RRR_ldr:
            switch (ins.rrr_ls.size) {
                case 0: regs.r[ins.rrr_ls.r1].asSQWord = set_flags(regs.flags, *(SQWord_t*) (regs.r[ins.rrr_ls.r2].asQWord + regs.r[ins.rrr_ls.r3].asQWord)); break;
                case 1: regs.r[ins.rrr_ls.r1].asSDWord = set_flags(regs.flags, *(SDWord_t*) (regs.r[ins.rrr_ls.r2].asQWord + regs.r[ins.rrr_ls.r3].asQWord)); break;
                case 2: regs.r[ins.rrr_ls.r1].asSWord = set_flags(regs.flags, *(SWord_t*) (regs.r[ins.rrr_ls.r2].asQWord + regs.r[ins.rrr_ls.r3].asQWord)); break;
                case 3: regs.r[ins.rrr_ls.r1].asSByte = set_flags(regs.flags, *(SByte_t*) (regs.r[ins.rrr_ls.r2].asQWord + regs.r[ins.rrr_ls.r3].asQWord)); break;
            }
            break;
        case OP_RRR_str:
            switch (ins.rrr_ls.size) {
                case 0: *(SQWord_t*) (regs.r[ins.rrr_ls.r2].asQWord + regs.r[ins.rrr_ls.r3].asQWord) = set_flags(regs.flags, regs.r[ins.rrr_ls.r1].asSQWord); break;
                case 1: *(SDWord_t*) (regs.r[ins.rrr_ls.r2].asQWord + regs.r[ins.rrr_ls.r3].asQWord) = set_flags(regs.flags, regs.r[ins.rrr_ls.r1].asSDWord); break;
                case 2: *(SWord_t*) (regs.r[ins.rrr_ls.r2].asQWord + regs.r[ins.rrr_ls.r3].asQWord) = set_flags(regs.flags, regs.r[ins.rrr_ls.r1].asSWord); break;
                case 3: *(SByte_t*) (regs.r[ins.rrr_ls.r2].asQWord + regs.r[ins.rrr_ls.r3].asQWord) = set_flags(regs.flags, regs.r[ins.rrr_ls.r1].asSByte); break;
            }
            break;
        case OP_RRR_tst:
            test(regs.flags, regs.r[ins.rrr.r1].asQWord, regs.r[ins.rrr.r2].asQWord);
            break;
        case OP_RRR_cmp:
            cmp(regs.flags, regs.r[ins.rrr.r1].asQWord, regs.r[ins.rrr.r2].asQWord);
            break;
        case OP_RRR_ldp:
            switch (ins.rrr_rpairs.size) {
                case 0: {
                        regs.r[ins.rrr_rpairs.r1].asQWord = *(QWord_t*) (regs.r[ins.rrr_rpairs.r3].asQWord + regs.r[ins.rrr_rpairs.r4].asQWord);
                        regs.r[ins.rrr_rpairs.r2].asQWord = *(QWord_t*) (regs.r[ins.rrr_rpairs.r3].asQWord + regs.r[ins.rrr_rpairs.r4].asQWord + sizeof(QWord_t));
                    }
                    break;
                case 1: {
                        regs.r[ins.rrr_rpairs.r1].asDWord = *(DWord_t*) (regs.r[ins.rrr_rpairs.r3].asQWord + regs.r[ins.rrr_rpairs.r4].asQWord);
                        regs.r[ins.rrr_rpairs.r1].asDWord = *(DWord_t*) (regs.r[ins.rrr_rpairs.r3].asQWord + regs.r[ins.rrr_rpairs.r4].asQWord + sizeof(DWord_t));
                    }
                    break;
                case 2: {
                        regs.r[ins.rrr_rpairs.r1].asWord = *(Word_t*) (regs.r[ins.rrr_rpairs.r3].asQWord + regs.r[ins.rrr_rpairs.r4].asQWord);
                        regs.r[ins.rrr_rpairs.r1].asWord = *(Word_t*) (regs.r[ins.rrr_rpairs.r3].asQWord + regs.r[ins.rrr_rpairs.r4].asQWord + sizeof(Word_t));
                    }
                    break;
                case 3: {
                        regs.r[ins.rrr_rpairs.r1].asByte = *(Byte_t*) (regs.r[ins.rrr_rpairs.r3].asQWord + regs.r[ins.rrr_rpairs.r4].asQWord);
                        regs.r[ins.rrr_rpairs.r1].asByte = *(Byte_t*) (regs.r[ins.rrr_rpairs.r3].asQWord + regs.r[ins.rrr_rpairs.r4].asQWord + sizeof(Byte_t));
                    }
                    break;
            }
            break;
        case OP_RRR_stp:
            switch (ins.rrr_rpairs.size) {
                case 0: {
                        *(QWord_t*) (regs.r[ins.rrr_rpairs.r3].asQWord + regs.r[ins.rrr_rpairs.r4].asQWord) = regs.r[ins.rrr_rpairs.r1].asQWord;
                        *(QWord_t*) (regs.r[ins.rrr_rpairs.r3].asQWord + regs.r[ins.rrr_rpairs.r4].asQWord + sizeof(QWord_t)) = regs.r[ins.rrr_rpairs.r2].asQWord;
                    }
                    break;
                case 1: {
                        *(DWord_t*) (regs.r[ins.rrr_rpairs.r3].asQWord + regs.r[ins.rrr_rpairs.r4].asQWord) = regs.r[ins.rrr_rpairs.r1].asDWord;
                        *(DWord_t*) (regs.r[ins.rrr_rpairs.r3].asQWord + regs.r[ins.rrr_rpairs.r4].asQWord + sizeof(DWord_t)) = regs.r[ins.rrr_rpairs.r2].asDWord;
                    }
                    break;
                case 2: {
                        *(Word_t*) (regs.r[ins.rrr_rpairs.r3].asQWord + regs.r[ins.rrr_rpairs.r4].asQWord) = regs.r[ins.rrr_rpairs.r1].asWord;
                        *(Word_t*) (regs.r[ins.rrr_rpairs.r3].asQWord + regs.r[ins.rrr_rpairs.r4].asQWord + sizeof(Word_t)) = regs.r[ins.rrr_rpairs.r2].asWord;
                    }
                    break;
                case 3: {
                        *(Byte_t*) (regs.r[ins.rrr_rpairs.r3].asQWord + regs.r[ins.rrr_rpairs.r4].asQWord) = regs.r[ins.rrr_rpairs.r1].asByte;
                        *(Byte_t*) (regs.r[ins.rrr_rpairs.r3].asQWord + regs.r[ins.rrr_rpairs.r4].asQWord + sizeof(Byte_t)) = regs.r[ins.rrr_rpairs.r2].asByte;
                    }
                    break;
            }
            break;
        case OP_RRR_fpu:
            regs = exec_fpu_type(regs, ins);
            break;
        default:
            raise(SIGILL);
            break;
    }
    regs.pc.asInstrPtr++;
    return regs;
}
hive_register_file_t exec_ri_type(hive_register_file_t regs, hive_instruction_t ins) {
    if (ins.ri.is_branch) {
        switch (ins.ri_branch.op) {
            case OP_RI_br:
                if (ins.ri_branch.link) LINK();
                BRANCH(regs.r[ins.ri_branch.r1].asQWord);
                break;
            case OP_RI_brlt:
                if (ins.ri_branch.link) LINK_ON(regs.flags.negative);
                BRANCH_ON(regs.r[ins.ri_branch.r1].asQWord, regs.flags.negative);
                break;
            case OP_RI_brgt:
                if (ins.ri_branch.link) LINK_ON(!regs.flags.negative && !regs.flags.equal);
                BRANCH_ON(regs.r[ins.ri_branch.r1].asQWord, !regs.flags.negative && !regs.flags.equal);
                break;
            case OP_RI_brge:
                if (ins.ri_branch.link) LINK_ON(!regs.flags.negative);
                BRANCH_ON(regs.r[ins.ri_branch.r1].asQWord, !regs.flags.negative);
                break;
            case OP_RI_brle:
                if (ins.ri_branch.link) LINK_ON(regs.flags.negative || regs.flags.equal);
                BRANCH_ON(regs.r[ins.ri_branch.r1].asQWord, regs.flags.negative || regs.flags.equal);
                break;
            case OP_RI_breq:
                if (ins.ri_branch.link) LINK_ON(regs.flags.equal);
                BRANCH_ON(regs.r[ins.ri_branch.r1].asQWord, regs.flags.equal);
                break;
            case OP_RI_brne:
                if (ins.ri_branch.link) LINK_ON(!regs.flags.equal);
                BRANCH_ON(regs.r[ins.ri_branch.r1].asQWord, !regs.flags.equal);
                break;
            case OP_RI_cbr:
                set_flags(regs.flags, regs.r[ins.ri_cbranch.r1].asQWord);
                if (ins.ri_branch.link) LINK_ON(regs.flags.equal == ins.ri_cbranch.zero);
                BRANCH_ON(regs.r[ins.ri_cbranch.r1].asQWord, regs.flags.equal == ins.ri_cbranch.zero);
                break;
        }
    } else {
        switch (ins.ri.op) {
            case OP_RI_lea:
                regs.r[ins.ri.r1].asInstrPtr = regs.pc.asInstrPtr + ins.ri_s.imm;
                break;
            case OP_RI_movzk: {
                    QWord_t shift = (16 * ins.ri_mov.shift);
                    QWord_t mask = (~(0xFFFFULL) << shift);
                    QWord_t value = ((QWord_t) ins.ri_mov.imm) << shift;
                    regs.r[ins.ri_mov.r1].asQWord = ((regs.r[ins.ri_mov.r1].asQWord) & (ins.ri_mov.no_zero * mask)) | value;
                    set_flags(regs.flags, regs.r[ins.ri_mov.r1].asQWord);
                }
                break;
            case OP_RI_tst:
                test(regs.flags, regs.r[ins.ri.r1].asQWord, ins.ri.imm);
                break;
            case OP_RI_cmp:
                cmp(regs.flags, regs.r[ins.ri.r1].asQWord, ins.ri.imm);
                break;
            case OP_RI_svc:
                regs = exec_svc(regs);
                break;
            default:
                raise(SIGILL);
                break;
        }
    }
    regs.pc.asInstrPtr++;
    return regs;
}

#pragma region tostring
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

char* str_data_type(hive_instruction_t ins) {
    if (ins.branch.op <= OP_BRANCH_bne) {
        switch (ins.branch.op) {
            case OP_BRANCH_b: return strformat("b%s %d", (ins.branch.link ? "l" : ""), ins.branch.offset);
            case OP_BRANCH_blt: return strformat("b%slt %d", (ins.branch.link ? "l" : ""), ins.branch.offset);
            case OP_BRANCH_bgt: return strformat("b%sgt %d", (ins.branch.link ? "l" : ""), ins.branch.offset);
            case OP_BRANCH_bge: return strformat("b%sge %d", (ins.branch.link ? "l" : ""), ins.branch.offset);
            case OP_BRANCH_ble: return strformat("b%sle %d", (ins.branch.link ? "l" : ""), ins.branch.offset);
            case OP_BRANCH_beq: return strformat("b%seq %d", (ins.branch.link ? "l" : ""), ins.branch.offset);
            case OP_BRANCH_bne: return strformat("b%sne %d", (ins.branch.link ? "l" : ""), ins.branch.offset);
            case OP_BRANCH_cb: if (ins.ri_cbranch.zero) {
                return strformat("cb%sz r%d, %d", (ins.branch.link ? "l" : ""), ins.comp_branch.r1, ins.branch.offset);
            } else {
                return strformat("cb%snz r%d, %d", (ins.branch.link ? "l" : ""), ins.comp_branch.r1, ins.branch.offset);
            }
        }
    }
    return NULL;
}
char* str_rri_type(hive_instruction_t ins) {
    switch (ins.rri.op) {
        case OP_RRI_add: return strformat("add r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_sub: return strformat("sub r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_mul: return strformat("mul r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_div: return strformat("div r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_mod: return strformat("mod r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_and: return strformat("and r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_or: return strformat("or r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_xor: return strformat("xor r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_shl: {
            if (ins.rri.r1 == ins.rri.r2 && ins.rri.imm == 0) {
                return strformat("nop");
            } else if (ins.rri.r1 == 31 && ins.rri.r2 == 29 && ins.rri.imm == 0) {
                return strformat("ret");
            } else if (ins.rri.imm == 0) {
                return strformat("mov r%d, r%d", ins.rri.r1, ins.rri.r2);
            } else {
                return strformat("shl r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
            }
        }
        case OP_RRI_shr: {
            if (ins.rri.r1 == ins.rri.r2 && ins.rri.imm == 0) {
                return strformat("nop");
            } else if (ins.rri.r1 == 31 && ins.rri.r2 == 29 && ins.rri.imm == 0) {
                return strformat("ret");
            } else if (ins.rri.imm == 0) {
                return strformat("mov r%d, r%d", ins.rri.r1, ins.rri.r2);
            } else {
                return strformat("shr r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
            }
        }
        case OP_RRI_rol: return strformat("rol r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_ror: return strformat("ror r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_ldr: {
            switch (ins.rri_ls.size) {
                case 0: return strformat("ldr r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm);
                case 1: return strformat("ldrd r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm);
                case 2: return strformat("ldrw r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm);
                case 3: return strformat("ldrb r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm);
            }
        }
        case OP_RRI_str: {
            switch (ins.rri_ls.size) {
                case 0: return strformat("str r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm);
                case 1: return strformat("strd r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm);
                case 2: return strformat("strw r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm);
                case 3: return strformat("strb r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm);
            }
        }
        case OP_RRI_bext: {
            if (ins.rri_bit.sign_extend) {
                return strformat("sbxt r%d, r%d, %d, %d", ins.rri.r1, ins.rri.r2, ins.rri_bit.lowest, ins.rri_bit.nbits);
            } else {
                return strformat("ubxt r%d, r%d, %d, %d", ins.rri.r1, ins.rri.r2, ins.rri_bit.lowest, ins.rri_bit.nbits);
            }
        }
        case OP_RRI_bdep: {
            if (ins.rri_bit.sign_extend) {
                return strformat("sbdp r%d, r%d, %d, %d", ins.rri.r1, ins.rri.r2, ins.rri_bit.lowest, ins.rri_bit.nbits);
            } else {
                return strformat("ubdp r%d, r%d, %d, %d", ins.rri.r1, ins.rri.r2, ins.rri_bit.lowest, ins.rri_bit.nbits);
            }
        }
        case OP_RRI_ldp: {
            switch (ins.rri_rpairs.size) {
                case 0: return strformat("ldp r%d, r%d, [r%d, %d]", ins.rri_rpairs.r1, ins.rri_rpairs.r2, ins.rri_rpairs.r3, ins.rri_rpairs.imm);
                case 1: return strformat("ldpd r%d, r%d, [r%d, %d]", ins.rri_rpairs.r1, ins.rri_rpairs.r2, ins.rri_rpairs.r3, ins.rri_rpairs.imm);
                case 2: return strformat("ldpw r%d, r%d, [r%d, %d]", ins.rri_rpairs.r1, ins.rri_rpairs.r2, ins.rri_rpairs.r3, ins.rri_rpairs.imm);
                case 3: return strformat("ldpb r%d, r%d, [r%d, %d]", ins.rri_rpairs.r1, ins.rri_rpairs.r2, ins.rri_rpairs.r3, ins.rri_rpairs.imm);
            }
        }
        case OP_RRI_stp: {
            switch (ins.rri_rpairs.size) {
                case 0: return strformat("stp r%d, r%d, [r%d, %d]", ins.rri_rpairs.r1, ins.rri_rpairs.r2, ins.rri_rpairs.r3, ins.rri_rpairs.imm);
                case 1: return strformat("stpd r%d, r%d, [r%d, %d]", ins.rri_rpairs.r1, ins.rri_rpairs.r2, ins.rri_rpairs.r3, ins.rri_rpairs.imm);
                case 2: return strformat("stpw r%d, r%d, [r%d, %d]", ins.rri_rpairs.r1, ins.rri_rpairs.r2, ins.rri_rpairs.r3, ins.rri_rpairs.imm);
                case 3: return strformat("stpb r%d, r%d, [r%d, %d]", ins.rri_rpairs.r1, ins.rri_rpairs.r2, ins.rri_rpairs.r3, ins.rri_rpairs.imm);
            }
        }
    }
    return NULL;
}
char* str_fpu_type(hive_instruction_t ins) {
    switch (ins.float_rrr.op) {
        case OP_FLOAT_add: return strformat("fadd r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_addi: return strformat("faddi r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_sub: return strformat("fsub r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_subi: return strformat("fsubi r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_mul: return strformat("fmul r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_muli: return strformat("fmuli r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_div: return strformat("fdiv r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_divi: return strformat("fdivi r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_mod: return strformat("fmod r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_modi: return strformat("fmodi r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_i2f: return strformat("i2f r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2);
        case OP_FLOAT_f2i: return strformat("f2i r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2);
        case OP_FLOAT_sin: return strformat("fsin r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2);
        case OP_FLOAT_sqrt: return strformat("fsqrt r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2);
        case OP_FLOAT_cmp: return strformat("fcmp r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2);
        case OP_FLOAT_cmpi: return strformat("fcmpi r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2);
    }
    return NULL;
}
char* str_rrr_type(hive_instruction_t ins) {
    switch (ins.rrr.op) {
        case OP_RRR_add: return strformat("add r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_sub: return strformat("sub r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_mul: return strformat("mul r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_div: return strformat("div r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_mod: return strformat("mod r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_and: return strformat("and r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_or: return strformat("or r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_xor: return strformat("xor r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_shl: return strformat("shl r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_shr: return strformat("shr r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_rol: return strformat("rol r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_ror: return strformat("ror r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRI_ldr: {
            switch (ins.rrr_ls.size) {
                case 0: return strformat("ldr r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
                case 1: return strformat("ldrd r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
                case 2: return strformat("ldrw r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
                case 3: return strformat("ldrb r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
            }
        }
        case OP_RRI_str: {
            switch (ins.rrr_ls.size) {
                case 0: return strformat("str r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
                case 1: return strformat("strd r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
                case 2: return strformat("strw r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
                case 3: return strformat("strb r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
            }
        }
        case OP_RRR_tst: return strformat("tst r%d, r%d", ins.rrr.r1, ins.rrr.r2);
        case OP_RRR_cmp: return strformat("cmp r%d, r%d", ins.rrr.r1, ins.rrr.r2);
        case OP_RRR_ldp: {
            switch (ins.rrr_rpairs.size) {
                case 0: return strformat("ldp r%d, r%d, [r%d, r%d]", ins.rrr_rpairs.r1, ins.rrr_rpairs.r2, ins.rrr_rpairs.r3, ins.rrr_rpairs.r4);
                case 1: return strformat("ldpd r%d, r%d, [r%d, r%d]", ins.rrr_rpairs.r1, ins.rrr_rpairs.r2, ins.rrr_rpairs.r3, ins.rrr_rpairs.r4);
                case 2: return strformat("ldpw r%d, r%d, [r%d, r%d]", ins.rrr_rpairs.r1, ins.rrr_rpairs.r2, ins.rrr_rpairs.r3, ins.rrr_rpairs.r4);
                case 3: return strformat("ldpb r%d, r%d, [r%d, r%d]", ins.rrr_rpairs.r1, ins.rrr_rpairs.r2, ins.rrr_rpairs.r3, ins.rrr_rpairs.r4);
            }
        }
        case OP_RRR_stp: {
            switch (ins.rrr_rpairs.size) {
                case 0: return strformat("stp r%d, r%d, [r%d, r%d]", ins.rrr_rpairs.r1, ins.rrr_rpairs.r2, ins.rrr_rpairs.r3, ins.rrr_rpairs.r4);
                case 1: return strformat("stpd r%d, r%d, [r%d, r%d]", ins.rrr_rpairs.r1, ins.rrr_rpairs.r2, ins.rrr_rpairs.r3, ins.rrr_rpairs.r4);
                case 2: return strformat("stpw r%d, r%d, [r%d, r%d]", ins.rrr_rpairs.r1, ins.rrr_rpairs.r2, ins.rrr_rpairs.r3, ins.rrr_rpairs.r4);
                case 3: return strformat("stpb r%d, r%d, [r%d, r%d]", ins.rrr_rpairs.r1, ins.rrr_rpairs.r2, ins.rrr_rpairs.r3, ins.rrr_rpairs.r4);
            }
        }
        case OP_RRR_fpu: return str_fpu_type(ins);
    }
    return NULL;
}
char* str_ri_type(hive_instruction_t ins) {
    if (ins.ri.is_branch) {
        switch (ins.ri_branch.op) {
            case OP_RI_br: return strformat("b%sr r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
            case OP_RI_brlt: return strformat("b%srlt r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
            case OP_RI_brgt: return strformat("b%srgt r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
            case OP_RI_brge: return strformat("b%srge r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
            case OP_RI_brle: return strformat("b%srle r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
            case OP_RI_breq: return strformat("b%sreq r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
            case OP_RI_brne: return strformat("b%srne r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
            case OP_RI_cbr: if (ins.ri_cbranch.zero) {
                return strformat("cb%sz r%d, 0x%08x", (ins.ri_branch.link ? "l" : ""), ins.ri_s.r1, ins.ri_s.imm);
            } else {
                return strformat("cb%snz r%d, 0x%08x", (ins.ri_branch.link ? "l" : ""), ins.ri_s.r1, ins.ri_s.imm);
            }
        }
    } else {
        switch (ins.ri.op) {
            case OP_RI_lea: return strformat("lea r%d, 0x%08x", ins.ri_s.r1, ins.ri_s.imm);
            case OP_RI_movzk: if (ins.ri_mov.no_zero) {
                return strformat("movk r%d, %d, shl %d", ins.ri.r1, ins.ri_mov.imm, ins.ri_mov.shift);
            } else {
                return strformat("movz r%d, %d, shl %d", ins.ri.r1, ins.ri_mov.imm, ins.ri_mov.shift);
            }
            case OP_RI_svc: return strformat("svc");
            case OP_RI_tst: return strformat("tst r%d, %d", ins.ri.r1, ins.ri.imm);
            case OP_RI_cmp: return strformat("cmp r%d, %d", ins.ri.r1, ins.ri.imm);
        }
    }
    return NULL;
}

char* dis(hive_instruction_t ins) {
    char* instr = NULL;
    switch (ins.generic.type) {
        case 0: instr = str_data_type(ins); break;
        case 1: instr = str_rri_type(ins); break;
        case 2: instr = str_rrr_type(ins); break;
        case 3: instr = str_ri_type(ins); break;
    }
    return instr;
}

#pragma endregion

hive_register_file_t exec(hive_register_file_t regs) {
    while (regs.pc.asQWord != 4) {
        hive_instruction_t ins = *(regs.pc.asInstrPtr);
        // printf("0x%016llx: 0x%08x %s\n", regs.pc.asQWord, *regs.pc.asDWordPtr, dis(ins));
        switch (ins.generic.type) {
            case 0: regs = exec_branch_type(regs, ins); break;
            case 1: regs = exec_rri_type(regs, ins); break;
            case 2: regs = exec_rrr_type(regs, ins); break;
            case 3: regs = exec_ri_type(regs, ins); break;
        }
    }
    return regs;
}

void disassemble(Section code_sect) {
    for (hive_instruction_t* p = (hive_instruction_t*) code_sect.data; p < (hive_instruction_t*) (code_sect.data + code_sect.len);) {
        hive_instruction_t ins = *(p++);
        char* s = dis(ins);
        printf(
            "0x%016llx: 0x%08x\t",
            ((QWord_t) (p - 1) - (QWord_t) code_sect.data),
            *(uint32_t*) &ins
        );
        if (s == NULL) {
            printf(".dword 0x%08x\n", *(uint32_t*) &ins);
        } else {
            printf("%s\n", s);
            free(s);
        }
    }
}

Nob_String_Builder run_compile(const char* file_name, Symbol_Offsets* syms, Symbol_Offsets* relocations);

#define SECT_TYPE_CODE  0x01
#define SECT_TYPE_SYMS  0x02
#define SECT_TYPE_RELOC 0x04
#define SECT_TYPE_LD    0x08

typedef struct {
    HiveFile* items;
    size_t count;
    size_t capacity;
} HiveFile_Array;

HiveFile read_hive_file(FILE* fp) {
    HiveFile hf;
    fread(&hf.magic, sizeof(hf.magic), 1, fp);
    fread(&hf.sects.count, sizeof(hf.sects.count), 1, fp);
    hf.sects.capacity = hf.sects.count;
    hf.sects.items = malloc(sizeof(*hf.sects.items) * hf.sects.count);
    for (size_t i = 0; i < hf.sects.count; i++) {
        fread(&hf.sects.items[i].len, sizeof(hf.sects.items[i].len), 1, fp);
        fread(&hf.sects.items[i].type, sizeof(hf.sects.items[i].type), 1, fp);
        if (hf.sects.items[i].len) {
            hf.sects.items[i].data = malloc(hf.sects.items[i].len);
            fread(hf.sects.items[i].data, sizeof(char), hf.sects.items[i].len, fp);
        }
    }
    return hf;
}

Nob_File_Paths create_ld_section(Section s);
Section get_section(HiveFile f, uint32_t sect_type);

HiveFile_Array get_all_files(FILE* fp) {
    HiveFile_Array files = {0};
    HiveFile src = read_hive_file(fp);
    nob_da_append(&files, src);
    Nob_File_Paths ld_sect = create_ld_section(get_section(src, SECT_TYPE_LD));
    for (size_t i = 0; i < ld_sect.count; i++) {
        FILE* file = fopen(ld_sect.items[i], "rb");
        if (file == NULL) {
            fprintf(stderr, "Unable to locate library %s\n", ld_sect.items[i]);
            exit(1);
        }
        HiveFile_Array tmp = get_all_files(file);
        nob_da_append_many(&files, tmp.items, tmp.count);
        fclose(file);
    }
    return files;
}

void write_hive_file(HiveFile hf, FILE* fp) {
    fwrite(&hf.magic, sizeof(hf.magic), 1, fp);
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

    #define mem_read(ptr, type) ({ type t = *(type*) ptr; ptr += sizeof(type); t; })
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

    #define mem_read(ptr, type) ({ type t = *(type*) ptr; ptr += sizeof(type); t; })
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

    #define mem_read(ptr, type) ({ type t = *(type*) ptr; ptr += sizeof(type); t; })
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
            if (reloc.type == st_abs) {
                *((QWord_t*) &code_sect.data[current_address]) += (uint64_t) code_sect.data;
                continue;
            } else {
                fprintf(stderr, "Undefined symbol: %s\n", reloc.name);
                exit(1);
            }
        }

        switch (reloc.type) {
            case st_abs:
                *((QWord_t*) &code_sect.data[current_address]) = target_address;
                break;
            case st_data: {
                    hive_instruction_t* s = ((hive_instruction_t*) &code_sect.data[current_address]);
                    int32_t diff = target_address - (uint64_t) s;
                    if (diff % 4) {
                        fprintf(stderr, "Relative target not aligned!");
                        exit(1);
                    }
                    diff >>= 2;
                    if (diff >= 0b10000000000000000000000000 || diff < -0b10000000000000000000000000) {
                        fprintf(stderr, "Relative address too far: %x (%llx -> %llx)\n", diff, (QWord_t) &code_sect.data[current_address], target_address);
                        exit(1);
                    }
                    s->branch.offset = diff;
                }
                break;
            case st_ri: {
                    hive_instruction_t* s = ((hive_instruction_t*) &code_sect.data[current_address]);
                    int32_t diff = target_address - (uint64_t) s;
                    if (diff % 4) {
                        fprintf(stderr, "Relative target not aligned!");
                        exit(1);
                    }
                    diff >>= 2;
                    if (diff >= 0b10000000000000000000 || diff < -0b10000000000000000000) {
                        fprintf(stderr, "Relative address too far: %x (%llx -> %llx)\n", diff, (uint64_t) &code_sect.data[current_address], target_address);
                        exit(1);
                    }
                    s->ri_s.imm = diff;
                }
                break;
        }
    }
}

int main(int argc, char **argv) {
    if (argc < 3) {
        fprintf(stderr, "Usage: %s run <objfile>\n", argv[0]);
        fprintf(stderr, "       %s comp <srcfile> <objfile>\n", argv[0]);
        return 1;
    }
    if (strcmp(argv[1], "comp") == 0) {
        if (argc < 4) {
            fprintf(stderr, "Usage: %s comp <srcfile> <objfile>\n", argv[0]);
            return 1;
        }
        
        Nob_File_Paths link_with = {0};
        for (size_t i = 4; i < argc; i++) {
            if (argv[i][0] == '-' && argv[i][1] == 'l') {
                i++;
                if (i == argc) {
                    fprintf(stderr, "-l requires an argument!\n");
                    return 1;
                }
                nob_da_append(&link_with, argv[i]);
            }
        }

        Symbol_Offsets syms = {0};
        Symbol_Offsets relocations = {0};
        Nob_String_Builder obj = run_compile(argv[2], &syms, &relocations);

        if (obj.items == NULL) {
            fprintf(stderr, "Failed to compile!\n");
            return 1;
        }

        Section code_sect = {
            .data = obj.items,
            .len = obj.count,
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

        if (link_with.count) {
            Section s = {0};
            for (size_t i = 0; i < link_with.count; i++) {
                s.len += strlen(link_with.items[i]) + 1;
            }
            s.data = malloc(s.len);
            size_t x = 0;
            for (size_t i = 0; i < link_with.count; i++) {
                strcpy((char*) &s.data[x], link_with.items[i]);
                x += strlen(link_with.items[i]) + 1;
            }
            s.type = SECT_TYPE_LD;
            nob_da_append(&sa, s);
        }

        HiveFile hf = {
            .magic = 0xFEEDF00D,
            .sects = sa
        };
        
        FILE* f = fopen(argv[3], "wb");
        write_hive_file(hf, f);
        fclose(f);
        return 0;
    } else if (strcmp(argv[1], "run") == 0 || strcmp(argv[1], "dis") == 0) {
        FILE* f = fopen(argv[2], "rb");
        if (!f) {
            fprintf(stderr, "Could not open file '%s'\n", argv[2]);
            return 1;
        }

        HiveFile_Array hf = get_all_files(f);
        fclose(f);
        f = NULL;

        Symbol_Offsets all_syms;

        for (size_t i = 0; i < hf.count; i++) {
            Symbol_Offsets symbols = create_symbol_section(get_section(hf.items[i], SECT_TYPE_SYMS));
            Section code_sect = get_section(hf.items[i], SECT_TYPE_CODE);
            for (size_t j = 0; j < symbols.count; j++) {
                symbols.items[j].offset += (uint64_t) code_sect.data;
            }
            nob_da_append_many(&all_syms, symbols.items, symbols.count);
        }

        for (size_t i = 0; i < hf.count; i++) {
            Symbol_Offsets relocs = create_relocation_section(get_section(hf.items[i], SECT_TYPE_RELOC));
            Section code_sect = get_section(hf.items[i], SECT_TYPE_CODE);

            relocate(code_sect, relocs, all_syms);
        }

        if (strcmp(argv[1], "dis") == 0) {
            disassemble(get_section(hf.items[0], SECT_TYPE_CODE));
            return 0;
        }

        hive_register_file_t regs = {0};

        regs.pc.asPointer = (void*) find_symbol_address(all_syms, "_start");

        if (regs.pc.asSQWord != -1) {
            char stack[1024 * 1024];
            regs.sp.asPointer = ((void*) stack) + sizeof(stack);
            regs = exec(regs);
            return regs.r[0].asQWord;
        }
        
        fprintf(stderr, "Could not find _start symbol\n");
        return 1;
    } else {
        fprintf(stderr, "Unknown command '%s'\n", argv[1]);
        return 1;
    }
}
