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

#include "new_ops.h"

typedef QWord_t(*svc_call)(QWord_t,QWord_t,QWord_t,QWord_t,QWord_t,QWord_t,QWord_t,QWord_t);

#define SVC_exit        0
#define SVC_read        1
#define SVC_write       2
#define SVC_open        3
#define SVC_close       4
#define SVC_malloc      5
#define SVC_free        6
#define SVC_realloc     7

#define SVC(what) [SVC_ ## what] = (svc_call) &what

svc_call svcs[] = {
    SVC(exit),
    SVC(read),
    SVC(write),
    SVC(open),
    SVC(close),
    SVC(malloc),
    SVC(free),
    SVC(realloc),
};

    // lt, mi   -> negative
    // gt       -> !equal && !negative
    // ge, pl   -> !negative
    // le       -> negative || equal
    // eq, z    -> equal
    // ne, nz   -> !equal
static inline QWord_t set_flags(hive_flag_register_t* fr, QWord_t res) {
    fr->equal = (res == 0);
    fr->negative = (res < 0);
    return res;
}
#define test(fr, a, b) set_flags((fr), (a) & (b))
#define cmp(fr, a, b) set_flags((fr), (a) - (b))

#define BRANCH(to)                  do { regs->pc.asQWord = (QWord_t) (to); return; } while (0)
#define BRANCH_RELATIVE(offset)     do { BRANCH(PC_REL(offset)); } while (0)
#define LINK()                      do { regs->lr.asQWord = regs->pc.asQWord; } while (0)
#define LINK_ON(what)               do { if ((what)) { LINK(); } } while (0)
#define BRANCH_ON(to, what)         do { if ((what)) { BRANCH(to); } } while (0)
#define PC_REL(what)                (regs->pc.asQWord + ((what) << 2))

#define ROL(_a, _b) ((_a) >> (_b)) | ((_a) << ((sizeof(_a) << 3) - (_b)))
#define ROR(_a, _b) ((_a) << (_b)) | ((_a) >> ((sizeof(_a) << 3) - (_b)))

typedef void(*hive_executor_t)(hive_instruction_t, hive_register_file_t*);

#define BEGIN_OP(_op)   void exec_ ## _op (hive_instruction_t ins, hive_register_file_t* regs) {
#define END_OP          regs->pc.asInstrPtr++; }

BEGIN_OP(branch_b)
    if (ins.branch.link) LINK();
    BRANCH_RELATIVE(ins.branch.offset);
END_OP
BEGIN_OP(branch_blt)
    if (regs->flags.negative) {
        if (ins.branch.link) LINK();
        BRANCH_RELATIVE(ins.branch.offset);
    }
END_OP
BEGIN_OP(branch_bgt)
    if (!regs->flags.negative && !regs->flags.equal) {
        if (ins.branch.link) LINK();
        BRANCH_RELATIVE(ins.branch.offset);
    }
END_OP
BEGIN_OP(branch_bge)
    if (!regs->flags.negative) {
        if (ins.branch.link) LINK();
        BRANCH_RELATIVE(ins.branch.offset);
    }
END_OP
BEGIN_OP(branch_ble)
    if (regs->flags.negative || regs->flags.equal) {
        if (ins.branch.link) LINK();
        BRANCH_RELATIVE(ins.branch.offset);
    }
END_OP
BEGIN_OP(branch_beq)
    if (regs->flags.equal) {
        if (ins.branch.link) LINK();
        BRANCH_RELATIVE(ins.branch.offset);
    }
END_OP
BEGIN_OP(branch_bne)
    if (!regs->flags.equal) {
        if (ins.branch.link) LINK();
        BRANCH_RELATIVE(ins.branch.offset);
    }
END_OP
BEGIN_OP(branch_cb)
    set_flags(&regs->flags, regs->r[ins.comp_branch.r1].asQWord);
    if (regs->flags.equal == ins.comp_branch.zero) {
        if (ins.branch.link) LINK();
        BRANCH_RELATIVE(ins.comp_branch.offset);
    }
END_OP

BEGIN_OP(rri_add)
    regs->r[ins.rri.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rri.r2].asQWord + (QWord_t) ins.rri.imm);
END_OP
BEGIN_OP(rri_sub)
    regs->r[ins.rri.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rri.r2].asQWord - (QWord_t) ins.rri.imm);
END_OP
BEGIN_OP(rri_mul)
    regs->r[ins.rri.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rri.r2].asQWord * (QWord_t) ins.rri.imm);
END_OP
BEGIN_OP(rri_div)
    regs->r[ins.rri.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rri.r2].asQWord / (QWord_t) ins.rri.imm);
END_OP
BEGIN_OP(rri_mod)
    regs->r[ins.rri.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rri.r2].asQWord % (QWord_t) ins.rri.imm);
END_OP
BEGIN_OP(rri_and)
    regs->r[ins.rri.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rri.r2].asQWord & (QWord_t) ins.rri.imm);
END_OP
BEGIN_OP(rri_or)
    regs->r[ins.rri.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rri.r2].asQWord | (QWord_t) ins.rri.imm);
END_OP
BEGIN_OP(rri_xor)
    regs->r[ins.rri.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rri.r2].asQWord ^ (QWord_t) ins.rri.imm);
END_OP
BEGIN_OP(rri_shl)
    regs->r[ins.rri.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rri.r2].asQWord << (QWord_t) ins.rri.imm);
END_OP
BEGIN_OP(rri_shr)
    regs->r[ins.rri.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rri.r2].asQWord >> (QWord_t) ins.rri.imm);
END_OP
BEGIN_OP(rri_rol)
    regs->r[ins.rri.r1].asQWord = set_flags(&regs->flags, ROL(regs->r[ins.rri.r2].asQWord, ins.rri.imm));
END_OP
BEGIN_OP(rri_ror)
    regs->r[ins.rri.r1].asQWord = set_flags(&regs->flags, ROR(regs->r[ins.rri.r2].asQWord, ins.rri.imm));
END_OP
BEGIN_OP(rri_ldr)
    switch (ins.rri_ls.size) {
        case 0: regs->r[ins.rri_ls.r1].asSQWord = set_flags(&regs->flags, *(SQWord_t*) (regs->r[ins.rri_ls.r2].asQWord + ins.rri_ls.imm)); break;
        case 1: regs->r[ins.rri_ls.r1].asSDWord = set_flags(&regs->flags, *(SDWord_t*) (regs->r[ins.rri_ls.r2].asQWord + ins.rri_ls.imm)); break;
        case 2: regs->r[ins.rri_ls.r1].asSWord = set_flags(&regs->flags, *(SWord_t*) (regs->r[ins.rri_ls.r2].asQWord + ins.rri_ls.imm)); break;
        case 3: regs->r[ins.rri_ls.r1].asSByte = set_flags(&regs->flags, *(SByte_t*) (regs->r[ins.rri_ls.r2].asQWord + ins.rri_ls.imm)); break;
    }
END_OP
BEGIN_OP(rri_str)
    switch (ins.rri_ls.size) {
        case 0: *(SQWord_t*) (regs->r[ins.rri_ls.r2].asQWord + ins.rri_ls.imm) = set_flags(&regs->flags, regs->r[ins.rri_ls.r1].asSQWord); break;
        case 1: *(SDWord_t*) (regs->r[ins.rri_ls.r2].asQWord + ins.rri_ls.imm) = set_flags(&regs->flags, regs->r[ins.rri_ls.r1].asSDWord); break;
        case 2: *(SWord_t*) (regs->r[ins.rri_ls.r2].asQWord + ins.rri_ls.imm) = set_flags(&regs->flags, regs->r[ins.rri_ls.r1].asSWord); break;
        case 3: *(SByte_t*) (regs->r[ins.rri_ls.r2].asQWord + ins.rri_ls.imm) = set_flags(&regs->flags, regs->r[ins.rri_ls.r1].asSByte); break;
    }
END_OP
BEGIN_OP(rri_bext)
    uint8_t lowest = ins.rri_bit.lowest;
    uint8_t num = ins.rri_bit.nbits;
    uint64_t mask = ((1ULL << num) - 1);
    uint64_t val = (regs->r[ins.rri.r2].asQWord & (mask << lowest)) >> lowest;
    if (ins.rri_bit.sign_extend) {
        uint8_t sign_bit_mask = (1ULL << (num - 1));
        if (val & sign_bit_mask) {
            val |= ~mask;
        }
    }
    regs->r[ins.rri.r1].asQWord = val;
    set_flags(&regs->flags, regs->r[ins.rri.r1].asQWord);
END_OP
BEGIN_OP(rri_bdep)
    uint8_t lowest = ins.rri_bit.lowest;
    uint8_t num = ins.rri_bit.nbits;
    uint64_t mask = ((1ULL << num) - 1);
    regs->r[ins.rri.r1].asQWord &= ~(mask << lowest);
    regs->r[ins.rri.r1].asQWord |= (regs->r[ins.rri.r2].asQWord & mask) << lowest;
    set_flags(&regs->flags, regs->r[ins.rri.r1].asQWord);
END_OP
BEGIN_OP(rri_ldp)
    switch (ins.rri_rpairs.size) {
        case 0: {
                regs->r[ins.rri_rpairs.r1].asQWord = *(QWord_t*) (regs->r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm);
                regs->r[ins.rri_rpairs.r2].asQWord = *(QWord_t*) (regs->r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm + sizeof(QWord_t));
            }
            break;
        case 1: {
                regs->r[ins.rri_rpairs.r1].asDWord = *(DWord_t*) (regs->r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm);
                regs->r[ins.rri_rpairs.r1].asDWord = *(DWord_t*) (regs->r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm + sizeof(DWord_t));
            }
            break;
        case 2: {
                regs->r[ins.rri_rpairs.r1].asWord = *(Word_t*) (regs->r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm);
                regs->r[ins.rri_rpairs.r1].asWord = *(Word_t*) (regs->r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm + sizeof(Word_t));
            }
            break;
        case 3: {
                regs->r[ins.rri_rpairs.r1].asByte = *(Byte_t*) (regs->r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm);
                regs->r[ins.rri_rpairs.r1].asByte = *(Byte_t*) (regs->r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm + sizeof(Byte_t));
            }
            break;
    }
END_OP
BEGIN_OP(rri_stp)
    switch (ins.rri_rpairs.size) {
        case 0: {
                *(QWord_t*) (regs->r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm) = regs->r[ins.rri_rpairs.r1].asQWord;
                *(QWord_t*) (regs->r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm + sizeof(QWord_t)) = regs->r[ins.rri_rpairs.r2].asQWord;
            }
            break;
        case 1: {
                *(DWord_t*) (regs->r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm) = regs->r[ins.rri_rpairs.r1].asDWord;
                *(DWord_t*) (regs->r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm + sizeof(DWord_t)) = regs->r[ins.rri_rpairs.r2].asDWord;
            }
            break;
        case 2: {
                *(Word_t*) (regs->r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm) = regs->r[ins.rri_rpairs.r1].asWord;
                *(Word_t*) (regs->r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm + sizeof(Word_t)) = regs->r[ins.rri_rpairs.r2].asWord;
            }
            break;
        case 3: {
                *(Byte_t*) (regs->r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm) = regs->r[ins.rri_rpairs.r1].asByte;
                *(Byte_t*) (regs->r[ins.rri_rpairs.r3].asQWord + ins.rri_rpairs.imm + sizeof(Byte_t)) = regs->r[ins.rri_rpairs.r2].asByte;
            }
            break;
    }
END_OP

BEGIN_OP(float_add)
    regs->r[ins.float_rrr.r1].asFloat64 = set_flags(&regs->flags, regs->r[ins.float_rrr.r2].asFloat64 + regs->r[ins.float_rrr.r3].asFloat64);
END_OP
BEGIN_OP(float_addi)
    regs->r[ins.float_rrr.r1].asFloat64 = set_flags(&regs->flags, regs->r[ins.float_rrr.r2].asFloat64 + regs->r[ins.float_rrr.r3].asSQWord);
END_OP
BEGIN_OP(float_sub)
    regs->r[ins.float_rrr.r1].asFloat64 = set_flags(&regs->flags, regs->r[ins.float_rrr.r2].asFloat64 - regs->r[ins.float_rrr.r3].asFloat64);
END_OP
BEGIN_OP(float_subi)
    regs->r[ins.float_rrr.r1].asFloat64 = set_flags(&regs->flags, regs->r[ins.float_rrr.r2].asFloat64 - regs->r[ins.float_rrr.r3].asSQWord);
END_OP
BEGIN_OP(float_mul)
    regs->r[ins.float_rrr.r1].asFloat64 = set_flags(&regs->flags, regs->r[ins.float_rrr.r2].asFloat64 * regs->r[ins.float_rrr.r3].asFloat64);
END_OP
BEGIN_OP(float_muli)
    regs->r[ins.float_rrr.r1].asFloat64 = set_flags(&regs->flags, regs->r[ins.float_rrr.r2].asFloat64 * regs->r[ins.float_rrr.r3].asSQWord);
END_OP
BEGIN_OP(float_div)
    regs->r[ins.float_rrr.r1].asFloat64 = set_flags(&regs->flags, regs->r[ins.float_rrr.r2].asFloat64 / regs->r[ins.float_rrr.r3].asFloat64);
END_OP
BEGIN_OP(float_divi)
    regs->r[ins.float_rrr.r1].asFloat64 = set_flags(&regs->flags, regs->r[ins.float_rrr.r2].asFloat64 / regs->r[ins.float_rrr.r3].asSQWord);
END_OP
BEGIN_OP(float_mod)
    regs->r[ins.float_rrr.r1].asFloat64 = set_flags(&regs->flags, fmod(regs->r[ins.float_rrr.r2].asFloat64, regs->r[ins.float_rrr.r3].asFloat64));
END_OP
BEGIN_OP(float_modi)
    regs->r[ins.float_rrr.r1].asFloat64 = set_flags(&regs->flags, fmod(regs->r[ins.float_rrr.r2].asFloat64, (Float64_t) regs->r[ins.float_rrr.r3].asSQWord));
END_OP
BEGIN_OP(float_i2f)
    regs->r[ins.float_rrr.r1].asFloat64 = set_flags(&regs->flags, (Float64_t) regs->r[ins.float_rrr.r2].asSQWord);
END_OP
BEGIN_OP(float_f2i)
    regs->r[ins.float_rrr.r1].asSQWord = set_flags(&regs->flags, (SQWord_t) regs->r[ins.float_rrr.r2].asFloat64);
END_OP
BEGIN_OP(float_sin)
    regs->r[ins.float_rrr.r1].asFloat64 = set_flags(&regs->flags, sin(regs->r[ins.float_rrr.r2].asFloat64));
END_OP
BEGIN_OP(float_sqrt)
    regs->r[ins.float_rrr.r1].asFloat64 = set_flags(&regs->flags, sqrt(regs->r[ins.float_rrr.r2].asFloat64));
END_OP
BEGIN_OP(float_cmp)
    set_flags(&regs->flags, regs->r[ins.float_rrr.r2].asFloat64 - regs->r[ins.float_rrr.r3].asFloat64);
END_OP
BEGIN_OP(float_cmpi)
    set_flags(&regs->flags, regs->r[ins.float_rrr.r2].asFloat64 - regs->r[ins.float_rrr.r3].asSQWord);
END_OP
BEGIN_OP(rrr_add)
    regs->r[ins.rrr.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rrr.r2].asQWord + regs->r[ins.rrr.r3].asQWord);
END_OP
BEGIN_OP(rrr_sub)
    regs->r[ins.rrr.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rrr.r2].asQWord - regs->r[ins.rrr.r3].asQWord);
END_OP
BEGIN_OP(rrr_mul)
    regs->r[ins.rrr.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rrr.r2].asQWord * regs->r[ins.rrr.r3].asQWord);
END_OP
BEGIN_OP(rrr_div)
    regs->r[ins.rrr.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rrr.r2].asQWord / regs->r[ins.rrr.r3].asQWord);
END_OP
BEGIN_OP(rrr_mod)
    regs->r[ins.rrr.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rrr.r2].asQWord % regs->r[ins.rrr.r3].asQWord);
END_OP
BEGIN_OP(rrr_and)
    regs->r[ins.rrr.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rrr.r2].asQWord & regs->r[ins.rrr.r3].asQWord);
END_OP
BEGIN_OP(rrr_or)
    regs->r[ins.rrr.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rrr.r2].asQWord | regs->r[ins.rrr.r3].asQWord);
END_OP
BEGIN_OP(rrr_xor)
    regs->r[ins.rrr.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rrr.r2].asQWord ^ regs->r[ins.rrr.r3].asQWord);
END_OP
BEGIN_OP(rrr_shl)
    regs->r[ins.rrr.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rrr.r2].asQWord << regs->r[ins.rrr.r3].asQWord);
END_OP
BEGIN_OP(rrr_shr)
    regs->r[ins.rrr.r1].asQWord = set_flags(&regs->flags, regs->r[ins.rrr.r2].asQWord >> regs->r[ins.rrr.r3].asQWord);
END_OP
BEGIN_OP(rrr_rol)
    regs->r[ins.rrr.r1].asQWord = set_flags(&regs->flags, ROL(regs->r[ins.rrr.r2].asQWord, regs->r[ins.rrr.r3].asQWord));
END_OP
BEGIN_OP(rrr_ror)
    regs->r[ins.rrr.r1].asQWord = set_flags(&regs->flags, ROR(regs->r[ins.rrr.r2].asQWord, regs->r[ins.rrr.r3].asQWord));
END_OP
BEGIN_OP(rrr_ldr)
    switch (ins.rrr_ls.size) {
        case 0: regs->r[ins.rrr_ls.r1].asSQWord = set_flags(&regs->flags, *(SQWord_t*) (regs->r[ins.rrr_ls.r2].asQWord + regs->r[ins.rrr_ls.r3].asQWord)); break;
        case 1: regs->r[ins.rrr_ls.r1].asSDWord = set_flags(&regs->flags, *(SDWord_t*) (regs->r[ins.rrr_ls.r2].asQWord + regs->r[ins.rrr_ls.r3].asQWord)); break;
        case 2: regs->r[ins.rrr_ls.r1].asSWord = set_flags(&regs->flags, *(SWord_t*) (regs->r[ins.rrr_ls.r2].asQWord + regs->r[ins.rrr_ls.r3].asQWord)); break;
        case 3: regs->r[ins.rrr_ls.r1].asSByte = set_flags(&regs->flags, *(SByte_t*) (regs->r[ins.rrr_ls.r2].asQWord + regs->r[ins.rrr_ls.r3].asQWord)); break;
    }
END_OP
BEGIN_OP(rrr_str)
    switch (ins.rrr_ls.size) {
        case 0: *(SQWord_t*) (regs->r[ins.rrr_ls.r2].asQWord + regs->r[ins.rrr_ls.r3].asQWord) = set_flags(&regs->flags, regs->r[ins.rrr_ls.r1].asSQWord); break;
        case 1: *(SDWord_t*) (regs->r[ins.rrr_ls.r2].asQWord + regs->r[ins.rrr_ls.r3].asQWord) = set_flags(&regs->flags, regs->r[ins.rrr_ls.r1].asSDWord); break;
        case 2: *(SWord_t*) (regs->r[ins.rrr_ls.r2].asQWord + regs->r[ins.rrr_ls.r3].asQWord) = set_flags(&regs->flags, regs->r[ins.rrr_ls.r1].asSWord); break;
        case 3: *(SByte_t*) (regs->r[ins.rrr_ls.r2].asQWord + regs->r[ins.rrr_ls.r3].asQWord) = set_flags(&regs->flags, regs->r[ins.rrr_ls.r1].asSByte); break;
    }
END_OP
BEGIN_OP(rrr_tst)
    test(&regs->flags, regs->r[ins.rrr.r1].asQWord, regs->r[ins.rrr.r2].asQWord);
END_OP
BEGIN_OP(rrr_cmp)
    cmp(&regs->flags, regs->r[ins.rrr.r1].asQWord, regs->r[ins.rrr.r2].asQWord);
END_OP
BEGIN_OP(rrr_ldp)
    switch (ins.rrr_rpairs.size) {
        case 0: {
                regs->r[ins.rrr_rpairs.r1].asQWord = *(QWord_t*) (regs->r[ins.rrr_rpairs.r3].asQWord + regs->r[ins.rrr_rpairs.r4].asQWord);
                regs->r[ins.rrr_rpairs.r2].asQWord = *(QWord_t*) (regs->r[ins.rrr_rpairs.r3].asQWord + regs->r[ins.rrr_rpairs.r4].asQWord + sizeof(QWord_t));
            }
            break;
        case 1: {
                regs->r[ins.rrr_rpairs.r1].asDWord = *(DWord_t*) (regs->r[ins.rrr_rpairs.r3].asQWord + regs->r[ins.rrr_rpairs.r4].asQWord);
                regs->r[ins.rrr_rpairs.r1].asDWord = *(DWord_t*) (regs->r[ins.rrr_rpairs.r3].asQWord + regs->r[ins.rrr_rpairs.r4].asQWord + sizeof(DWord_t));
            }
            break;
        case 2: {
                regs->r[ins.rrr_rpairs.r1].asWord = *(Word_t*) (regs->r[ins.rrr_rpairs.r3].asQWord + regs->r[ins.rrr_rpairs.r4].asQWord);
                regs->r[ins.rrr_rpairs.r1].asWord = *(Word_t*) (regs->r[ins.rrr_rpairs.r3].asQWord + regs->r[ins.rrr_rpairs.r4].asQWord + sizeof(Word_t));
            }
            break;
        case 3: {
                regs->r[ins.rrr_rpairs.r1].asByte = *(Byte_t*) (regs->r[ins.rrr_rpairs.r3].asQWord + regs->r[ins.rrr_rpairs.r4].asQWord);
                regs->r[ins.rrr_rpairs.r1].asByte = *(Byte_t*) (regs->r[ins.rrr_rpairs.r3].asQWord + regs->r[ins.rrr_rpairs.r4].asQWord + sizeof(Byte_t));
            }
            break;
    }
END_OP
BEGIN_OP(rrr_stp)
    switch (ins.rrr_rpairs.size) {
        case 0: {
                *(QWord_t*) (regs->r[ins.rrr_rpairs.r3].asQWord + regs->r[ins.rrr_rpairs.r4].asQWord) = regs->r[ins.rrr_rpairs.r1].asQWord;
                *(QWord_t*) (regs->r[ins.rrr_rpairs.r3].asQWord + regs->r[ins.rrr_rpairs.r4].asQWord + sizeof(QWord_t)) = regs->r[ins.rrr_rpairs.r2].asQWord;
            }
            break;
        case 1: {
                *(DWord_t*) (regs->r[ins.rrr_rpairs.r3].asQWord + regs->r[ins.rrr_rpairs.r4].asQWord) = regs->r[ins.rrr_rpairs.r1].asDWord;
                *(DWord_t*) (regs->r[ins.rrr_rpairs.r3].asQWord + regs->r[ins.rrr_rpairs.r4].asQWord + sizeof(DWord_t)) = regs->r[ins.rrr_rpairs.r2].asDWord;
            }
            break;
        case 2: {
                *(Word_t*) (regs->r[ins.rrr_rpairs.r3].asQWord + regs->r[ins.rrr_rpairs.r4].asQWord) = regs->r[ins.rrr_rpairs.r1].asWord;
                *(Word_t*) (regs->r[ins.rrr_rpairs.r3].asQWord + regs->r[ins.rrr_rpairs.r4].asQWord + sizeof(Word_t)) = regs->r[ins.rrr_rpairs.r2].asWord;
            }
            break;
        case 3: {
                *(Byte_t*) (regs->r[ins.rrr_rpairs.r3].asQWord + regs->r[ins.rrr_rpairs.r4].asQWord) = regs->r[ins.rrr_rpairs.r1].asByte;
                *(Byte_t*) (regs->r[ins.rrr_rpairs.r3].asQWord + regs->r[ins.rrr_rpairs.r4].asQWord + sizeof(Byte_t)) = regs->r[ins.rrr_rpairs.r2].asByte;
            }
            break;
    }
END_OP
BEGIN_OP(rrr_fpu)
    extern hive_executor_t fpu_execs[16];
    fpu_execs[ins.float_rrr.op](ins, regs);
    return;
END_OP

BEGIN_OP(ri_br)
    if (ins.ri_branch.link) LINK();
    BRANCH(regs->r[ins.ri_branch.r1].asQWord);
END_OP
BEGIN_OP(ri_brlt)
    if (regs->flags.negative) {
        if (ins.ri_branch.link) LINK();
        BRANCH(regs->r[ins.ri_branch.r1].asQWord);
    }
END_OP
BEGIN_OP(ri_brgt)
    if (!regs->flags.negative && !regs->flags.equal) {
        if (ins.ri_branch.link) LINK();
        BRANCH(regs->r[ins.ri_branch.r1].asQWord);
    }
END_OP
BEGIN_OP(ri_brge)
    if (!regs->flags.negative) {
        if (ins.ri_branch.link) LINK();
        BRANCH(regs->r[ins.ri_branch.r1].asQWord);
    }
END_OP
BEGIN_OP(ri_brle)
    if (regs->flags.negative || regs->flags.equal) {
        if (ins.ri_branch.link) LINK();
        BRANCH(regs->r[ins.ri_branch.r1].asQWord);
    }
END_OP
BEGIN_OP(ri_breq)
    if (regs->flags.equal) {
        if (ins.ri_branch.link) LINK();
        BRANCH(regs->r[ins.ri_branch.r1].asQWord);
    }
END_OP
BEGIN_OP(ri_brne)
    if (!regs->flags.equal) {
        if (ins.ri_branch.link) LINK();
        BRANCH(regs->r[ins.ri_branch.r1].asQWord);
    }
END_OP
BEGIN_OP(ri_cbr)
    set_flags(&regs->flags, regs->r[ins.ri_cbranch.r1].asQWord);
    if (regs->flags.equal == ins.ri_cbranch.zero) {
        if (ins.ri_branch.link) LINK();
        BRANCH(regs->r[ins.ri_cbranch.r1].asQWord);
    }
END_OP
BEGIN_OP(ri_lea)
    regs->r[ins.ri.r1].asQWord = set_flags(&regs->flags, PC_REL(ins.ri_s.imm));
END_OP
BEGIN_OP(ri_movzk)
    QWord_t shift = (16 * ins.ri_mov.shift);
    QWord_t mask = (~(0xFFFFULL) << shift);
    QWord_t value = ((QWord_t) ins.ri_mov.imm) << shift;
    regs->r[ins.ri_mov.r1].asQWord = ((regs->r[ins.ri_mov.r1].asQWord) & (ins.ri_mov.no_zero * mask)) | value;
    set_flags(&regs->flags, regs->r[ins.ri_mov.r1].asQWord);
END_OP
BEGIN_OP(ri_tst)
    test(&regs->flags, regs->r[ins.ri.r1].asQWord, ins.ri.imm);
END_OP
BEGIN_OP(ri_cmp)
    cmp(&regs->flags, regs->r[ins.ri.r1].asQWord, ins.ri.imm);
END_OP
BEGIN_OP(ri_svc)
    regs->r[0].asQWord = svcs[regs->r[8].asQWord](
        regs->r[0].asQWord,
        regs->r[1].asQWord,
        regs->r[2].asQWord,
        regs->r[3].asQWord,
        regs->r[4].asQWord,
        regs->r[5].asQWord,
        regs->r[6].asQWord,
        regs->r[7].asQWord
    );
END_OP

hive_executor_t branch_execs[] = {
    [OP_BRANCH_b] = exec_branch_b,
    [OP_BRANCH_blt] = exec_branch_blt,
    [OP_BRANCH_bgt] = exec_branch_bgt,
    [OP_BRANCH_bge] = exec_branch_bge,
    [OP_BRANCH_ble] = exec_branch_ble,
    [OP_BRANCH_beq] = exec_branch_beq,
    [OP_BRANCH_bne] = exec_branch_bne,
    [OP_BRANCH_cb] = exec_branch_cb,
};
hive_executor_t rri_execs[] = {
    [OP_RRI_add] = exec_rri_add,
    [OP_RRI_sub] = exec_rri_sub,
    [OP_RRI_mul] = exec_rri_mul,
    [OP_RRI_div] = exec_rri_div,
    [OP_RRI_mod] = exec_rri_mod,
    [OP_RRI_and] = exec_rri_and,
    [OP_RRI_or] = exec_rri_or,
    [OP_RRI_xor] = exec_rri_xor,
    [OP_RRI_shl] = exec_rri_shl,
    [OP_RRI_shr] = exec_rri_shr,
    [OP_RRI_rol] = exec_rri_rol,
    [OP_RRI_ror] = exec_rri_ror,
    [OP_RRI_ldr] = exec_rri_ldr,
    [OP_RRI_str] = exec_rri_str,
    [OP_RRI_bext] = exec_rri_bext,
    [OP_RRI_bdep] = exec_rri_bdep,
    [OP_RRI_ldp] = exec_rri_ldp,
    [OP_RRI_stp] = exec_rri_stp,
};
hive_executor_t fpu_execs[] = {
    [OP_FLOAT_add] = exec_float_add,
    [OP_FLOAT_addi] = exec_float_addi,
    [OP_FLOAT_sub] = exec_float_sub,
    [OP_FLOAT_subi] = exec_float_subi,
    [OP_FLOAT_mul] = exec_float_mul,
    [OP_FLOAT_muli] = exec_float_muli,
    [OP_FLOAT_div] = exec_float_div,
    [OP_FLOAT_divi] = exec_float_divi,
    [OP_FLOAT_mod] = exec_float_mod,
    [OP_FLOAT_modi] = exec_float_modi,
    [OP_FLOAT_i2f] = exec_float_i2f,
    [OP_FLOAT_f2i] = exec_float_f2i,
    [OP_FLOAT_sin] = exec_float_sin,
    [OP_FLOAT_sqrt] = exec_float_sqrt,
    [OP_FLOAT_cmp] = exec_float_cmp,
    [OP_FLOAT_cmpi] = exec_float_cmpi,
};
hive_executor_t rrr_execs[] = {
    [OP_RRR_add] = exec_rrr_add,
    [OP_RRR_sub] = exec_rrr_sub,
    [OP_RRR_mul] = exec_rrr_mul,
    [OP_RRR_div] = exec_rrr_div,
    [OP_RRR_mod] = exec_rrr_mod,
    [OP_RRR_and] = exec_rrr_and,
    [OP_RRR_or] = exec_rrr_or,
    [OP_RRR_xor] = exec_rrr_xor,
    [OP_RRR_shl] = exec_rrr_shl,
    [OP_RRR_shr] = exec_rrr_shr,
    [OP_RRR_rol] = exec_rrr_rol,
    [OP_RRR_ror] = exec_rrr_ror,
    [OP_RRR_ldr] = exec_rrr_ldr,
    [OP_RRR_str] = exec_rrr_str,
    [OP_RRR_tst] = exec_rrr_tst,
    [OP_RRR_cmp] = exec_rrr_cmp,
    [OP_RRR_ldp] = exec_rrr_ldp,
    [OP_RRR_stp] = exec_rrr_stp,
    [OP_RRR_fpu] = exec_rrr_fpu,
};
hive_executor_t branchr_execs[] = {
    [OP_RI_br] = exec_ri_br,
    [OP_RI_brlt] = exec_ri_brlt,
    [OP_RI_brgt] = exec_ri_brgt,
    [OP_RI_brge] = exec_ri_brge,
    [OP_RI_brle] = exec_ri_brle,
    [OP_RI_breq] = exec_ri_breq,
    [OP_RI_brne] = exec_ri_brne,
    [OP_RI_cbr] = exec_ri_cbr,
};
hive_executor_t ri_execs[] = {
    [OP_RI_lea] = exec_ri_lea,
    [OP_RI_movzk] = exec_ri_movzk,
    [OP_RI_tst] = exec_ri_tst,
    [OP_RI_cmp] = exec_ri_cmp,
    [OP_RI_svc] = exec_ri_svc,
};

void exec_branch_type(hive_instruction_t ins, hive_register_file_t* regs) {
    branch_execs[ins.branch.op](ins, regs);
}
void exec_rri_type(hive_instruction_t ins, hive_register_file_t* regs) {
    rri_execs[ins.rri.op](ins, regs);
}
void exec_rrr_type(hive_instruction_t ins, hive_register_file_t* regs) {
    rrr_execs[ins.rrr.op](ins, regs);
}
void exec_ri_type(hive_instruction_t ins, hive_register_file_t* regs) {
    if (ins.ri.is_branch) {
        branchr_execs[ins.ri_branch.op](ins, regs);
    } else {
        ri_execs[ins.ri.op](ins, regs);
    }
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

char* dis(hive_instruction_t);

#pragma endregion

void exec(hive_register_file_t* regs) {
    void(*execs[4])(hive_instruction_t, hive_register_file_t*) = {
        exec_branch_type,
        exec_rri_type,
        exec_rrr_type,
        exec_ri_type,
    };
    while (1) {
        hive_instruction_t ins = *regs->pc.asInstrPtr;
        // printf("0x%016llx: 0x%08x %s\n", regs->pc.asQWord, *regs->pc.asDWordPtr, dis(ins));
        execs[ins.generic.type](ins, regs);
    }
}

void disassemble(Section code_sect, Symbol_Offsets syms);
Nob_String_Builder run_compile(const char* file_name, Symbol_Offsets* syms, Symbol_Offsets* relocations);

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
        
        Symbol_Offsets all_syms = prepare(hf);

        hive_register_file_t regs = {0};

        regs.pc.asQWord = find_symbol_address(all_syms, "_start");

        if (regs.pc.asSQWord != -1) {
            char stack[1024 * 1024];
            regs.sp.asQWord = ((QWord_t) stack) + sizeof(stack);
            exec(&regs);
            return regs.r[0].asSDWord;
        }
        
        fprintf(stderr, "Could not find _start symbol\n");
        return 1;
    } else if (strcmp(exe_name, HIVE64_DIS) == 0) {
        HiveFile_Array hf = {0};
        get_all_files(argv[1], &hf, false);
        
        Symbol_Offsets all_syms = prepare(hf);

        for (size_t i = 0; i < hf.count; i++) {
            if (hf.items[i].magic != HIVE_FAT_FILE_MAGIC) {
                printf("%s:\n", hf.items[i].name);
                disassemble(get_section(hf.items[i], SECT_TYPE_CODE), all_syms);
            }
        }
        return 0;
    } else {
        fprintf(stderr, "Unknown command '%s'\n", exe_name);
        return 1;
    }
}
