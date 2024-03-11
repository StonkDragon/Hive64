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
#define SVC_coredump    8

#define SVC(what) [SVC_ ## what] = (svc_call) &what

hive_register_file_t* registers;
hive_vector_register_t* vector_registers;

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

    // lt, mi   -> negative
    // gt       -> !equal && !negative
    // ge, pl   -> !negative
    // le       -> negative || equal
    // eq, z    -> equal
    // ne, nz   -> !equal
static inline SQWord_t set_flags(hive_flag_register_t* fr, SQWord_t res) {
    fr->equal = (res == 0);
    fr->negative = (res < 0);
    return res;
}
#define test(fr, a, b) set_flags((fr), (a) & (b))
#define cmp(fr, a, b) set_flags((fr), (a) - (b))

#define PC_REL(what)                (r[REG_PC].asQWord + ((what) << 2))
#define BRANCH(to)                  (r[REG_PC].asQWord = (to) - sizeof(hive_instruction_t))
#define BRANCH_RELATIVE(offset)     BRANCH(PC_REL(offset))
#define LINK()                      (r[REG_LR].asQWord = r[REG_PC].asQWord)

#define ROR(_a, _b) ((_a) >> (_b)) | ((_a) << ((sizeof(_a) << 3) - (_b)))
#define ROL(_a, _b) ROR(_a, (sizeof(_a) << 3) - (_b))

typedef void(*hive_executor_t)(hive_instruction_t, hive_register_t*, hive_flag_register_t*, hive_vector_register_t*);

#define BEGIN_OP(_op)   void exec_ ## _op (hive_instruction_t ins, hive_register_t* r, hive_flag_register_t* fr, hive_vector_register_t* v) {
#define END_OP          }

BEGIN_OP(branch_b)
    if (ins.branch.link) LINK();
    BRANCH_RELATIVE(ins.branch.offset);
END_OP
BEGIN_OP(branch_blt)
    if (fr->negative) {
        if (ins.branch.link) LINK();
        BRANCH_RELATIVE(ins.branch.offset);
    }
END_OP
BEGIN_OP(branch_bgt)
    if (!fr->negative && !fr->equal) {
        if (ins.branch.link) LINK();
        BRANCH_RELATIVE(ins.branch.offset);
    }
END_OP
BEGIN_OP(branch_bge)
    if (!fr->negative) {
        if (ins.branch.link) LINK();
        BRANCH_RELATIVE(ins.branch.offset);
    }
END_OP
BEGIN_OP(branch_ble)
    if (fr->negative || fr->equal) {
        if (ins.branch.link) LINK();
        BRANCH_RELATIVE(ins.branch.offset);
    }
END_OP
BEGIN_OP(branch_beq)
    if (fr->equal) {
        if (ins.branch.link) LINK();
        BRANCH_RELATIVE(ins.branch.offset);
    }
END_OP
BEGIN_OP(branch_bne)
    if (!fr->equal) {
        if (ins.branch.link) LINK();
        BRANCH_RELATIVE(ins.branch.offset);
    }
END_OP
BEGIN_OP(branch_cb)
    set_flags(fr, r[ins.comp_branch.r1].asQWord);
    if (fr->equal == ins.comp_branch.zero) {
        if (ins.branch.link) LINK();
        BRANCH_RELATIVE(ins.comp_branch.offset);
    }
END_OP

BEGIN_OP(ai_add)
    r[ins.rri.r1].asQWord = r[ins.rri.r2].asQWord + (QWord_t) ins.rri.imm;
END_OP
BEGIN_OP(ai_sub)
    r[ins.rri.r1].asQWord = r[ins.rri.r2].asQWord - (QWord_t) ins.rri.imm;
END_OP
BEGIN_OP(ai_mul)
    r[ins.rri.r1].asQWord = r[ins.rri.r2].asQWord * (QWord_t) ins.rri.imm;
END_OP
BEGIN_OP(ai_div)
    r[ins.rri.r1].asQWord = r[ins.rri.r2].asQWord / (QWord_t) ins.rri.imm;
END_OP
BEGIN_OP(ai_mod)
    r[ins.rri.r1].asQWord = r[ins.rri.r2].asQWord % (QWord_t) ins.rri.imm;
END_OP
BEGIN_OP(ai_and)
    r[ins.rri.r1].asQWord = r[ins.rri.r2].asQWord & (QWord_t) ins.rri.imm;
END_OP
BEGIN_OP(ai_or)
    r[ins.rri.r1].asQWord = r[ins.rri.r2].asQWord | (QWord_t) ins.rri.imm;
END_OP
BEGIN_OP(ai_xor)
    r[ins.rri.r1].asQWord = r[ins.rri.r2].asQWord ^ (QWord_t) ins.rri.imm;
END_OP
BEGIN_OP(ai_shl)
    r[ins.rri.r1].asQWord = r[ins.rri.r2].asQWord << (QWord_t) ins.rri.imm;
END_OP
BEGIN_OP(ai_shr)
    r[ins.rri.r1].asQWord = r[ins.rri.r2].asQWord >> (QWord_t) ins.rri.imm;
END_OP
BEGIN_OP(ai_rol)
    r[ins.rri.r1].asQWord = ROL(r[ins.rri.r2].asQWord, ins.rri.imm);
END_OP
BEGIN_OP(ai_ror)
    r[ins.rri.r1].asQWord = ROR(r[ins.rri.r2].asQWord, ins.rri.imm);
END_OP
BEGIN_OP(ai_neg)
    r[ins.rri.r1].asSQWord = -r[ins.rri.r2].asSQWord;
END_OP
BEGIN_OP(ai_not)
    r[ins.rri.r1].asQWord = ~r[ins.rri.r2].asQWord;
END_OP
BEGIN_OP(ai_asr)
    r[ins.rri.r1].asSQWord = r[ins.rri.r2].asSQWord >> (QWord_t) ins.rri.imm;
END_OP
BEGIN_OP(ai_swe)
    r[ins.rri.r1].asQWord = htonll(r[ins.rri.r2].asQWord);
END_OP
BEGIN_OP(rri_ldr)
    QWord_t addr;
    if (ins.rri_ls.update_ptr) {
        addr = r[ins.rri_ls.r2].asQWord;
        r[ins.rri_ls.r2].asQWord += ins.rri_ls.imm;
    } else {
        addr = (r[ins.rri_ls.r2].asQWord + ins.rri_ls.imm);
    }
    uint8_t reg = ins.rri_ls.r1;
    QWord_t value = *(QWord_t*) addr;
    switch (ins.rri_ls.size) {
        case 0: r[reg].asQWord = value; break;
        case 1: r[reg].asDWord = value; break;
        case 2: r[reg].asWord = value; break;
        case 3: r[reg].asByte = value; break;
    }
END_OP
BEGIN_OP(rri_str)
    QWord_t addr;
    if (ins.rri_ls.update_ptr) {
        r[ins.rri_ls.r2].asQWord += ins.rri_ls.imm;
        addr = r[ins.rri_ls.r2].asQWord;
    } else {
        addr = (r[ins.rri_ls.r2].asQWord + ins.rri_ls.imm);
    }
    QWord_t value = r[ins.rri_ls.r1].asQWord;
    switch (ins.rri_ls.size) {
        case 0: *(QWord_t*) addr = value; break;
        case 1: *(DWord_t*) addr = value; break;
        case 2: *(Word_t*) addr = value; break;
        case 3: *(Byte_t*) addr = value; break;
    }
END_OP
BEGIN_OP(rri_bext)
    uint8_t lowest = ins.rri_bit.lowest;
    uint8_t num = ins.rri_bit.nbits;
    uint64_t mask = ((1ULL << num) - 1);
    uint64_t val = (r[ins.rri.r2].asQWord & (mask << lowest)) >> lowest;
    if (ins.rri_bit.sign_extend) {
        uint8_t sign_bit_mask = (1ULL << (num - 1));
        if (val & sign_bit_mask) {
            val |= ~mask;
        }
    }
    r[ins.rri.r1].asQWord = val;
    set_flags(fr, r[ins.rri.r1].asQWord);
END_OP
BEGIN_OP(rri_bdep)
    uint8_t lowest = ins.rri_bit.lowest;
    uint8_t num = ins.rri_bit.nbits;
    uint64_t mask = ((1ULL << num) - 1);
    r[ins.rri.r1].asQWord &= ~(mask << lowest);
    r[ins.rri.r1].asQWord |= (r[ins.rri.r2].asQWord & mask) << lowest;
    set_flags(fr, r[ins.rri.r1].asQWord);
END_OP

BEGIN_OP(float_add)
    r[ins.float_rrr.r1].asFloat64 = r[ins.float_rrr.r2].asFloat64 + r[ins.float_rrr.r3].asFloat64;
END_OP
BEGIN_OP(float_addi)
    r[ins.float_rrr.r1].asFloat64 = r[ins.float_rrr.r2].asFloat64 + r[ins.float_rrr.r3].asSQWord;
END_OP
BEGIN_OP(float_sub)
    r[ins.float_rrr.r1].asFloat64 = r[ins.float_rrr.r2].asFloat64 - r[ins.float_rrr.r3].asFloat64;
END_OP
BEGIN_OP(float_subi)
    r[ins.float_rrr.r1].asFloat64 = r[ins.float_rrr.r2].asFloat64 - r[ins.float_rrr.r3].asSQWord;
END_OP
BEGIN_OP(float_mul)
    r[ins.float_rrr.r1].asFloat64 = r[ins.float_rrr.r2].asFloat64 * r[ins.float_rrr.r3].asFloat64;
END_OP
BEGIN_OP(float_muli)
    r[ins.float_rrr.r1].asFloat64 = r[ins.float_rrr.r2].asFloat64 * r[ins.float_rrr.r3].asSQWord;
END_OP
BEGIN_OP(float_div)
    r[ins.float_rrr.r1].asFloat64 = r[ins.float_rrr.r2].asFloat64 / r[ins.float_rrr.r3].asFloat64;
END_OP
BEGIN_OP(float_divi)
    r[ins.float_rrr.r1].asFloat64 = r[ins.float_rrr.r2].asFloat64 / r[ins.float_rrr.r3].asSQWord;
END_OP
BEGIN_OP(float_mod)
    r[ins.float_rrr.r1].asFloat64 = fmod(r[ins.float_rrr.r2].asFloat64, r[ins.float_rrr.r3].asFloat64);
END_OP
BEGIN_OP(float_modi)
    r[ins.float_rrr.r1].asFloat64 = fmod(r[ins.float_rrr.r2].asFloat64, (Float64_t) r[ins.float_rrr.r3].asSQWord);
END_OP
BEGIN_OP(float_i2f)
    r[ins.float_rrr.r1].asFloat64 = (Float64_t) r[ins.float_rrr.r2].asSQWord;
END_OP
BEGIN_OP(float_f2i)
    r[ins.float_rrr.r1].asSQWord = (SQWord_t) r[ins.float_rrr.r2].asFloat64;
END_OP
BEGIN_OP(float_sin)
    r[ins.float_rrr.r1].asFloat64 = sin(r[ins.float_rrr.r2].asFloat64);
END_OP
BEGIN_OP(float_sqrt)
    r[ins.float_rrr.r1].asFloat64 = sqrt(r[ins.float_rrr.r2].asFloat64);
END_OP
BEGIN_OP(float_cmp)
    set_flags(fr, r[ins.float_rrr.r2].asFloat64 - r[ins.float_rrr.r3].asFloat64);
END_OP
BEGIN_OP(float_cmpi)
    set_flags(fr, r[ins.float_rrr.r2].asFloat64 - r[ins.float_rrr.r3].asSQWord);
END_OP

BEGIN_OP(float32_add)
    r[ins.float_rrr.r1].asFloat32 = r[ins.float_rrr.r2].asFloat32 + r[ins.float_rrr.r3].asFloat32;
END_OP
BEGIN_OP(float32_addi)
    r[ins.float_rrr.r1].asFloat32 = r[ins.float_rrr.r2].asFloat32 + r[ins.float_rrr.r3].asSDWord;
END_OP
BEGIN_OP(float32_sub)
    r[ins.float_rrr.r1].asFloat32 = r[ins.float_rrr.r2].asFloat32 - r[ins.float_rrr.r3].asFloat32;
END_OP
BEGIN_OP(float32_subi)
    r[ins.float_rrr.r1].asFloat32 = r[ins.float_rrr.r2].asFloat32 - r[ins.float_rrr.r3].asSDWord;
END_OP
BEGIN_OP(float32_mul)
    r[ins.float_rrr.r1].asFloat32 = r[ins.float_rrr.r2].asFloat32 * r[ins.float_rrr.r3].asFloat32;
END_OP
BEGIN_OP(float32_muli)
    r[ins.float_rrr.r1].asFloat32 = r[ins.float_rrr.r2].asFloat32 * r[ins.float_rrr.r3].asSDWord;
END_OP
BEGIN_OP(float32_div)
    r[ins.float_rrr.r1].asFloat32 = r[ins.float_rrr.r2].asFloat32 / r[ins.float_rrr.r3].asFloat32;
END_OP
BEGIN_OP(float32_divi)
    r[ins.float_rrr.r1].asFloat32 = r[ins.float_rrr.r2].asFloat32 / r[ins.float_rrr.r3].asSDWord;
END_OP
BEGIN_OP(float32_mod)
    r[ins.float_rrr.r1].asFloat32 = fmod(r[ins.float_rrr.r2].asFloat32, r[ins.float_rrr.r3].asFloat32);
END_OP
BEGIN_OP(float32_modi)
    r[ins.float_rrr.r1].asFloat32 = fmod(r[ins.float_rrr.r2].asFloat32, (Float32_t) r[ins.float_rrr.r3].asSDWord);
END_OP
BEGIN_OP(float32_i2f)
    r[ins.float_rrr.r1].asFloat32 = (Float32_t) r[ins.float_rrr.r2].asSDWord;
END_OP
BEGIN_OP(float32_f2i)
    r[ins.float_rrr.r1].asSDWord = (SDWord_t) r[ins.float_rrr.r2].asFloat32;
END_OP
BEGIN_OP(float32_sin)
    r[ins.float_rrr.r1].asFloat32 = sin(r[ins.float_rrr.r2].asFloat32);
END_OP
BEGIN_OP(float32_sqrt)
    r[ins.float_rrr.r1].asFloat32 = sqrt(r[ins.float_rrr.r2].asFloat32);
END_OP
BEGIN_OP(float32_cmp)
    set_flags(fr, r[ins.float_rrr.r2].asFloat32 - r[ins.float_rrr.r3].asFloat32);
END_OP
BEGIN_OP(float32_cmpi)
    set_flags(fr, r[ins.float_rrr.r2].asFloat32 - r[ins.float_rrr.r3].asSDWord);
END_OP

BEGIN_OP(ar_add)
    r[ins.rrr.r1].asQWord = r[ins.rrr.r2].asQWord + r[ins.rrr.r3].asQWord;
END_OP
BEGIN_OP(ar_sub)
    r[ins.rrr.r1].asQWord = r[ins.rrr.r2].asQWord - r[ins.rrr.r3].asQWord;
END_OP
BEGIN_OP(ar_mul)
    r[ins.rrr.r1].asQWord = r[ins.rrr.r2].asQWord * r[ins.rrr.r3].asQWord;
END_OP
BEGIN_OP(ar_div)
    r[ins.rrr.r1].asQWord = r[ins.rrr.r2].asQWord / r[ins.rrr.r3].asQWord;
END_OP
BEGIN_OP(ar_mod)
    r[ins.rrr.r1].asQWord = r[ins.rrr.r2].asQWord % r[ins.rrr.r3].asQWord;
END_OP
BEGIN_OP(ar_and)
    r[ins.rrr.r1].asQWord = r[ins.rrr.r2].asQWord & r[ins.rrr.r3].asQWord;
END_OP
BEGIN_OP(ar_or)
    r[ins.rrr.r1].asQWord = r[ins.rrr.r2].asQWord | r[ins.rrr.r3].asQWord;
END_OP
BEGIN_OP(ar_xor)
    r[ins.rrr.r1].asQWord = r[ins.rrr.r2].asQWord ^ r[ins.rrr.r3].asQWord;
END_OP
BEGIN_OP(ar_shl)
    r[ins.rrr.r1].asQWord = r[ins.rrr.r2].asQWord << r[ins.rrr.r3].asQWord;
END_OP
BEGIN_OP(ar_shr)
    r[ins.rrr.r1].asQWord = r[ins.rrr.r2].asQWord >> r[ins.rrr.r3].asQWord;
END_OP
BEGIN_OP(ar_rol)
    r[ins.rrr.r1].asQWord = ROL(r[ins.rrr.r2].asQWord, r[ins.rrr.r3].asQWord);
END_OP
BEGIN_OP(ar_ror)
    r[ins.rrr.r1].asQWord = ROR(r[ins.rrr.r2].asQWord, r[ins.rrr.r3].asQWord);
END_OP
BEGIN_OP(ar_neg)
    r[ins.rrr.r1].asSQWord = -r[ins.rrr.r2].asSQWord;
END_OP
BEGIN_OP(ar_not)
    r[ins.rrr.r1].asQWord = ~r[ins.rrr.r2].asQWord;
END_OP
BEGIN_OP(ar_asr)
    r[ins.rrr.r1].asSQWord = r[ins.rrr.r2].asSQWord >> r[ins.rrr.r3].asQWord;
END_OP
BEGIN_OP(ar_swe)
    r[ins.rrr.r1].asQWord = htonll(r[ins.rrr.r2].asQWord);
END_OP

BEGIN_OP(rrr_ldr)
    QWord_t addr;
    if (ins.rrr_ls.update_ptr) {
        addr = r[ins.rrr_ls.r2].asQWord;
        r[ins.rrr_ls.r2].asQWord += r[ins.rrr_ls.r3].asQWord;
    } else {
        addr = (r[ins.rrr_ls.r2].asQWord + r[ins.rrr_ls.r3].asQWord);
    }
    uint8_t reg = ins.rrr_ls.r1;
    QWord_t value = *(QWord_t*) addr;
    switch (ins.rrr_ls.size) {
        case 0: r[reg].asQWord = value; break;
        case 1: r[reg].asDWord = value; break;
        case 2: r[reg].asWord = value; break;
        case 3: r[reg].asByte = value; break;
    }
END_OP
BEGIN_OP(rrr_str)
    QWord_t addr;
    if (ins.rrr_ls.update_ptr) {
        r[ins.rrr_ls.r2].asQWord += r[ins.rrr_ls.r3].asQWord;
        addr = r[ins.rrr_ls.r2].asQWord;
    } else {
        addr = (r[ins.rrr_ls.r2].asQWord + r[ins.rrr_ls.r3].asQWord);
    }
    QWord_t value = r[ins.rrr_ls.r1].asQWord;
    switch (ins.rrr_ls.size) {
        case 0: *(QWord_t*) addr = value; break;
        case 1: *(DWord_t*) addr = value; break;
        case 2: *(Word_t*) addr = value; break;
        case 3: *(Byte_t*) addr = value; break;
    }
END_OP
BEGIN_OP(rrr_tst)
    test(fr, r[ins.rrr.r1].asQWord, r[ins.rrr.r2].asQWord);
END_OP
BEGIN_OP(rrr_cmp)
    cmp(fr, r[ins.rrr.r1].asQWord, r[ins.rrr.r2].asQWord);
END_OP
BEGIN_OP(rrr_fpu)
    extern hive_executor_t fpu_execs[16];
    extern hive_executor_t fpu32_execs[16];
    if (ins.float_rrr.mode == 0) {
        fpu_execs[ins.float_rrr.op](ins, r, fr, v);
    } else {
        fpu32_execs[ins.float_rrr.op](ins, r, fr, v);
    }
END_OP
BEGIN_OP(rrr_vpu)
    extern hive_executor_t* vpu_execs[8];
    vpu_execs[ins.vpu.mode][ins.vpu.op](ins, r, fr, v);
END_OP

BEGIN_OP(ri_br)
    if (ins.ri_branch.link) LINK();
    BRANCH(r[ins.ri_branch.r1].asQWord);
END_OP
BEGIN_OP(ri_brlt)
    if (fr->negative) {
        if (ins.ri_branch.link) LINK();
        BRANCH(r[ins.ri_branch.r1].asQWord);
    }
END_OP
BEGIN_OP(ri_brgt)
    if (!fr->negative && !fr->equal) {
        if (ins.ri_branch.link) LINK();
        BRANCH(r[ins.ri_branch.r1].asQWord);
    }
END_OP
BEGIN_OP(ri_brge)
    if (!fr->negative) {
        if (ins.ri_branch.link) LINK();
        BRANCH(r[ins.ri_branch.r1].asQWord);
    }
END_OP
BEGIN_OP(ri_brle)
    if (fr->negative || fr->equal) {
        if (ins.ri_branch.link) LINK();
        BRANCH(r[ins.ri_branch.r1].asQWord);
    }
END_OP
BEGIN_OP(ri_breq)
    if (fr->equal) {
        if (ins.ri_branch.link) LINK();
        BRANCH(r[ins.ri_branch.r1].asQWord);
    }
END_OP
BEGIN_OP(ri_brne)
    if (!fr->equal) {
        if (ins.ri_branch.link) LINK();
        BRANCH(r[ins.ri_branch.r1].asQWord);
    }
END_OP
BEGIN_OP(ri_cbr)
    set_flags(fr, r[ins.ri_cbranch.r1].asQWord);
    if (fr->equal == ins.ri_cbranch.zero) {
        if (ins.ri_branch.link) LINK();
        BRANCH(r[ins.ri_cbranch.r1].asQWord);
    }
END_OP
BEGIN_OP(ri_lea)
    r[ins.ri.r1].asQWord = PC_REL(ins.ri_s.imm);
END_OP
BEGIN_OP(ri_movzk)
    QWord_t shift = (16 * ins.ri_mov.shift);
    QWord_t mask = ROL(~(0xFFFFULL), shift);
    QWord_t value = ((QWord_t) ins.ri_mov.imm) << shift;
    if (ins.ri_mov.no_zero) {
        r[ins.ri_mov.r1].asQWord &= mask;
        r[ins.ri_mov.r1].asQWord |= value;
    } else {
        r[ins.ri_mov.r1].asQWord = 0;
        r[ins.ri_mov.r1].asQWord = value;
    }
    set_flags(fr, r[ins.ri_mov.r1].asQWord);
END_OP
BEGIN_OP(ri_tst)
    test(fr, r[ins.ri.r1].asQWord, ins.ri.imm);
END_OP
BEGIN_OP(ri_cmp)
    cmp(fr, r[ins.ri.r1].asQWord, ins.ri.imm);
END_OP
BEGIN_OP(ri_svc)
    r[0].asQWord = svcs[r[8].asQWord](
        r[0].asQWord,
        r[1].asQWord,
        r[2].asQWord,
        r[3].asQWord,
        r[4].asQWord,
        r[5].asQWord,
        r[6].asQWord,
        r[7].asQWord
    );
END_OP

#define vop_(_type, _what) for (size_t i = 0; i < sizeof(v[0].as ## _type) / sizeof(v[0].as ## _type[0]); i++) { \
    v[ins.vpu_arith.v1].as ## _type[i] = v[ins.vpu_arith.v2].as ## _type[i] _what v[ins.vpu_arith.v3].as ## _type[i]; \
}
#define vop_as_(_type) for (size_t i = 0; i < sizeof(v[0].as ## _type) / sizeof(v[0].as ## _type[0]); i += 2) { \
    v[ins.vpu_arith.v1].as ## _type[i] = v[ins.vpu_arith.v2].as ## _type[i] + v[ins.vpu_arith.v3].as ## _type[i]; \
    v[ins.vpu_arith.v1].as ## _type[i + 1] = v[ins.vpu_arith.v2].as ## _type[i + 1] - v[ins.vpu_arith.v3].as ## _type[i + 1]; \
}
#define vop_madd_(_type) for (size_t i = 0; i < sizeof(v[0].as ## _type) / sizeof(v[0].as ## _type[0]); i++) { \
    v[ins.vpu_arith.v1].as ## _type[i] = v[ins.vpu_arith.v2].as ## _type[i] * v[ins.vpu_arith.v3].as ## _type[i]; \
} \
for (size_t i = 0; i < sizeof(v[0].as ## _type) / sizeof(v[0].as ## _type[0]); i++) { \
    v[ins.vpu_arith.v1].as ## _type[0] += v[ins.vpu_arith.v1].as ## _type[i]; \
}

#define vop(_type, _what) vop_(_type, _what)
#define vop_as(_type) vop_as_(_type)
#define vop_madd(_type) vop_madd_(_type)

#define vpu_o QWord
#define vpu_b Bytes
#define vpu_w Words
#define vpu_d DWords
#define vpu_q QWords
#define vpu_l LWords
#define vpu_s Float32s
#define vpu_f Float64s

BEGIN_OP(vpu_o_add)
    vop(vpu_o, +)
END_OP
BEGIN_OP(vpu_b_add)
    vop(vpu_b, +)
END_OP
BEGIN_OP(vpu_w_add)
    vop(vpu_w, +)
END_OP
BEGIN_OP(vpu_d_add)
    vop(vpu_d, +)
END_OP
BEGIN_OP(vpu_q_add)
    vop(vpu_q, +)
END_OP
BEGIN_OP(vpu_l_add)
    vop(vpu_l, +)
END_OP
BEGIN_OP(vpu_s_add)
    vop(vpu_s, +)
END_OP
BEGIN_OP(vpu_f_add)
    vop(vpu_f, +)
END_OP
BEGIN_OP(vpu_o_sub)
    vop(vpu_o, -)
END_OP
BEGIN_OP(vpu_b_sub)
    vop(vpu_b, -)
END_OP
BEGIN_OP(vpu_w_sub)
    vop(vpu_w, -)
END_OP
BEGIN_OP(vpu_d_sub)
    vop(vpu_d, -)
END_OP
BEGIN_OP(vpu_q_sub)
    vop(vpu_q, -)
END_OP
BEGIN_OP(vpu_l_sub)
    vop(vpu_l, -)
END_OP
BEGIN_OP(vpu_s_sub)
    vop(vpu_s, -)
END_OP
BEGIN_OP(vpu_f_sub)
    vop(vpu_f, -)
END_OP
BEGIN_OP(vpu_o_mul)
    vop(vpu_o, *)
END_OP
BEGIN_OP(vpu_b_mul)
    vop(vpu_b, *)
END_OP
BEGIN_OP(vpu_w_mul)
    vop(vpu_w, *)
END_OP
BEGIN_OP(vpu_d_mul)
    vop(vpu_d, *)
END_OP
BEGIN_OP(vpu_q_mul)
    vop(vpu_q, *)
END_OP
BEGIN_OP(vpu_l_mul)
    vop(vpu_l, *)
END_OP
BEGIN_OP(vpu_s_mul)
    vop(vpu_s, *)
END_OP
BEGIN_OP(vpu_f_mul)
    vop(vpu_f, *)
END_OP
BEGIN_OP(vpu_o_div)
    vop(vpu_o, /)
END_OP
BEGIN_OP(vpu_b_div)
    vop(vpu_b, /)
END_OP
BEGIN_OP(vpu_w_div)
    vop(vpu_w, /)
END_OP
BEGIN_OP(vpu_d_div)
    vop(vpu_d, /)
END_OP
BEGIN_OP(vpu_q_div)
    vop(vpu_q, /)
END_OP
BEGIN_OP(vpu_l_div)
    vop(vpu_l, /)
END_OP
BEGIN_OP(vpu_s_div)
    vop(vpu_s, /)
END_OP
BEGIN_OP(vpu_f_div)
    vop(vpu_f, /)
END_OP
BEGIN_OP(vpu_o_addsub)
    vop_as(vpu_o)
END_OP
BEGIN_OP(vpu_b_addsub)
    vop_as(vpu_d)
END_OP
BEGIN_OP(vpu_w_addsub)
    vop_as(vpu_w)
END_OP
BEGIN_OP(vpu_d_addsub)
    vop_as(vpu_d)
END_OP
BEGIN_OP(vpu_q_addsub)
    vop_as(vpu_q)
END_OP
BEGIN_OP(vpu_l_addsub)
    vop_as(vpu_l)
END_OP
BEGIN_OP(vpu_s_addsub)
    vop_as(vpu_s)
END_OP
BEGIN_OP(vpu_f_addsub)
    vop_as(vpu_f)
END_OP
BEGIN_OP(vpu_o_madd)
    vop_madd(vpu_o)
END_OP
BEGIN_OP(vpu_b_madd)
    vop_madd(vpu_b)
END_OP
BEGIN_OP(vpu_w_madd)
    vop_madd(vpu_w)
END_OP
BEGIN_OP(vpu_d_madd)
    vop_madd(vpu_d)
END_OP
BEGIN_OP(vpu_q_madd)
    vop_madd(vpu_q)
END_OP
BEGIN_OP(vpu_l_madd)
    vop_madd(vpu_l)
END_OP
BEGIN_OP(vpu_s_madd)
    vop_madd(vpu_s)
END_OP
BEGIN_OP(vpu_f_madd)
    vop_madd(vpu_f)
END_OP
BEGIN_OP(vpu_o_mov)
    v[ins.vpu_mov.v1].asQWord[0] = r[ins.vpu_mov.r2].asQWord;
END_OP
BEGIN_OP(vpu_b_mov)
    v[ins.vpu_mov.v1].asBytes[ins.vpu_mov.slot] = r[ins.vpu_mov.r2].asByte;
END_OP
BEGIN_OP(vpu_w_mov)
    v[ins.vpu_mov.v1].asWords[ins.vpu_mov.slot] = r[ins.vpu_mov.r2].asWord;
END_OP
BEGIN_OP(vpu_d_mov)
    v[ins.vpu_mov.v1].asDWords[ins.vpu_mov.slot] = r[ins.vpu_mov.r2].asDWord;
END_OP
BEGIN_OP(vpu_q_mov)
    v[ins.vpu_mov.v1].asQWord[ins.vpu_mov.slot] = r[ins.vpu_mov.r2].asQWord;
END_OP
BEGIN_OP(vpu_l_mov)
    v[ins.vpu_mov.v1].asLWords[ins.vpu_mov.slot] = r[ins.vpu_mov.r2].asQWord;
END_OP
BEGIN_OP(vpu_s_mov)
    v[ins.vpu_mov.v1].asFloat32s[ins.vpu_mov.slot] = r[ins.vpu_mov.r2].asFloat32;
END_OP
BEGIN_OP(vpu_f_mov)
    v[ins.vpu_mov.v1].asFloat64s[ins.vpu_mov.slot] = r[ins.vpu_mov.r2].asFloat64;
END_OP
BEGIN_OP(vpu_o_mov_vec)
    v[ins.vpu_mov_vec.v1] = v[ins.vpu_mov_vec.v2];
END_OP
BEGIN_OP(vpu_b_mov_vec)
    v[ins.vpu_mov_vec.v1] = v[ins.vpu_mov_vec.v2];
END_OP
BEGIN_OP(vpu_w_mov_vec)
    v[ins.vpu_mov_vec.v1] = v[ins.vpu_mov_vec.v2];
END_OP
BEGIN_OP(vpu_d_mov_vec)
    v[ins.vpu_mov_vec.v1] = v[ins.vpu_mov_vec.v2];
END_OP
BEGIN_OP(vpu_q_mov_vec)
    v[ins.vpu_mov_vec.v1] = v[ins.vpu_mov_vec.v2];
END_OP
BEGIN_OP(vpu_l_mov_vec)
    v[ins.vpu_mov_vec.v1] = v[ins.vpu_mov_vec.v2];
END_OP
BEGIN_OP(vpu_s_mov_vec)
    v[ins.vpu_mov_vec.v1] = v[ins.vpu_mov_vec.v2];
END_OP
BEGIN_OP(vpu_f_mov_vec)
    v[ins.vpu_mov_vec.v1] = v[ins.vpu_mov_vec.v2];
END_OP
#define vpu_conv_(_from, _to) { \
    uint8_t min = \
        sizeof(v[0].as ## _to) / sizeof(v[0].as ## _to[0]) < sizeof(v[0].as ## _from) / sizeof(v[0].as ## _from[0]) ? \
        sizeof(v[0].as ## _to) / sizeof(v[0].as ## _to[0]) : \
        sizeof(v[0].as ## _from) / sizeof(v[0].as ## _from[0]); \
    for (size_t i = 0; i < min; i++) { \
        v[ins.vpu_conv.v1].as ## _to[i] = v[ins.vpu_conv.v2].as ## _from[i]; \
    } \
}
#define vpu_conv2(_from, _to) vpu_conv_(_from, _to)
#define vpu_conv(_from) \
    switch (ins.vpu_conv.target_mode) { \
        case 0: vpu_conv2(_from, vpu_o) break; \
        case 1: vpu_conv2(_from, vpu_b) break; \
        case 2: vpu_conv2(_from, vpu_w) break; \
        case 3: vpu_conv2(_from, vpu_d) break; \
        case 4: vpu_conv2(_from, vpu_q) break; \
        case 5: vpu_conv2(_from, vpu_l) break; \
        case 6: vpu_conv2(_from, vpu_s) break; \
        case 7: vpu_conv2(_from, vpu_f) break; \
    }

BEGIN_OP(vpu_o_conv)
    vpu_conv(vpu_o)
END_OP
BEGIN_OP(vpu_b_conv)
    vpu_conv(vpu_b)
END_OP
BEGIN_OP(vpu_w_conv)
    vpu_conv(vpu_w)
END_OP
BEGIN_OP(vpu_d_conv)
    vpu_conv(vpu_d)
END_OP
BEGIN_OP(vpu_q_conv)
    vpu_conv(vpu_q)
END_OP
BEGIN_OP(vpu_l_conv)
    vpu_conv(vpu_l)
END_OP
BEGIN_OP(vpu_s_conv)
    vpu_conv(vpu_s)
END_OP
BEGIN_OP(vpu_f_conv)
    vpu_conv(vpu_f)
END_OP

#define vpu_len_(_what) \
    r[ins.vpu_len.r1].asQWord = 0; \
    for (size_t i = 0; sizeof(v[0].as ## _what) / sizeof(v[0].as ## _what[0]); i++) { \
        if (v[ins.vpu_len.v1].as ## _what[i]) { \
            r[ins.vpu_len.r1].asQWord++; \
        } else { \
            break; \
        } \
    }
#define vpu_len(_what) vpu_len_(_what)

BEGIN_OP(vpu_o_len)
    vpu_len(vpu_o)
END_OP
BEGIN_OP(vpu_b_len)
    vpu_len(vpu_b)
END_OP
BEGIN_OP(vpu_w_len)
    vpu_len(vpu_w)
END_OP
BEGIN_OP(vpu_d_len)
    vpu_len(vpu_d)
END_OP
BEGIN_OP(vpu_q_len)
    vpu_len(vpu_q)
END_OP
BEGIN_OP(vpu_l_len)
    vpu_len(vpu_l)
END_OP
BEGIN_OP(vpu_s_len)
    vpu_len(vpu_s)
END_OP
BEGIN_OP(vpu_f_len)
    vpu_len(vpu_f)
END_OP

QWord_t decode_branch_target(QWord_t current_addr, hive_instruction_t ins, hive_register_t* r) {
    if (ins.generic.type == OP_BRANCH) {
        QWord_t target = current_addr;
        if (ins.branch.op != OP_BRANCH_cb) {
            target += ins.branch.offset * 4;
        } else if ((r[ins.comp_branch.r1].asQWord == 0) == ins.comp_branch.zero) {
            target += ins.comp_branch.offset * 4;
        } else {
            target += 4;
        }
        return target;
    } else if (ins.generic.type == OP_BR) {
        if (ins.ri_branch.op != OP_BR_cbr || (r[ins.ri_cbranch.r2].asQWord == 0) == ins.ri_cbranch.zero) {
            return r[ins.ri_branch.r1].asQWord;
        }
    }
    return current_addr + 4;
}

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
hive_executor_t ai_execs[] = {
    [OP_AI_add] = exec_ai_add,
    [OP_AI_sub] = exec_ai_sub,
    [OP_AI_mul] = exec_ai_mul,
    [OP_AI_div] = exec_ai_div,
    [OP_AI_mod] = exec_ai_mod,
    [OP_AI_and] = exec_ai_and,
    [OP_AI_or] = exec_ai_or,
    [OP_AI_xor] = exec_ai_xor,
    [OP_AI_shl] = exec_ai_shl,
    [OP_AI_shr] = exec_ai_shr,
    [OP_AI_rol] = exec_ai_rol,
    [OP_AI_ror] = exec_ai_ror,
    [OP_AI_neg] = exec_ai_neg,
    [OP_AI_not] = exec_ai_not,
    [OP_AI_asr] = exec_ai_asr,
    [OP_AI_swe] = exec_ai_swe,
};
hive_executor_t rri_execs[] = {
    [OP_RRI_ldr] = exec_rri_ldr,
    [OP_RRI_str] = exec_rri_str,
    [OP_RRI_bext] = exec_rri_bext,
    [OP_RRI_bdep] = exec_rri_bdep,
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
hive_executor_t fpu32_execs[] = {
    [OP_FLOAT_add] = exec_float32_add,
    [OP_FLOAT_addi] = exec_float32_addi,
    [OP_FLOAT_sub] = exec_float32_sub,
    [OP_FLOAT_subi] = exec_float32_subi,
    [OP_FLOAT_mul] = exec_float32_mul,
    [OP_FLOAT_muli] = exec_float32_muli,
    [OP_FLOAT_div] = exec_float32_div,
    [OP_FLOAT_divi] = exec_float32_divi,
    [OP_FLOAT_mod] = exec_float32_mod,
    [OP_FLOAT_modi] = exec_float32_modi,
    [OP_FLOAT_i2f] = exec_float32_i2f,
    [OP_FLOAT_f2i] = exec_float32_f2i,
    [OP_FLOAT_sin] = exec_float32_sin,
    [OP_FLOAT_sqrt] = exec_float32_sqrt,
    [OP_FLOAT_cmp] = exec_float32_cmp,
    [OP_FLOAT_cmpi] = exec_float32_cmpi,
};
hive_executor_t ar_execs[] = {
    [OP_AR_add] = exec_ar_add,
    [OP_AR_sub] = exec_ar_sub,
    [OP_AR_mul] = exec_ar_mul,
    [OP_AR_div] = exec_ar_div,
    [OP_AR_mod] = exec_ar_mod,
    [OP_AR_and] = exec_ar_and,
    [OP_AR_or] = exec_ar_or,
    [OP_AR_xor] = exec_ar_xor,
    [OP_AR_shl] = exec_ar_shl,
    [OP_AR_shr] = exec_ar_shr,
    [OP_AR_rol] = exec_ar_rol,
    [OP_AR_ror] = exec_ar_ror,
    [OP_AR_neg] = exec_ar_neg,
    [OP_AR_not] = exec_ar_not,
    [OP_AR_asr] = exec_ar_asr,
    [OP_AR_swe] = exec_ar_swe,
};
hive_executor_t rrr_execs[] = {
    [OP_RRR_ldr] = exec_rrr_ldr,
    [OP_RRR_str] = exec_rrr_str,
    [OP_RRR_tst] = exec_rrr_tst,
    [OP_RRR_cmp] = exec_rrr_cmp,
    [OP_RRR_fpu] = exec_rrr_fpu,
    [OP_RRR_vpu] = exec_rrr_vpu,
};
hive_executor_t branchr_execs[] = {
    [OP_BR_br] = exec_ri_br,
    [OP_BR_brlt] = exec_ri_brlt,
    [OP_BR_brgt] = exec_ri_brgt,
    [OP_BR_brge] = exec_ri_brge,
    [OP_BR_brle] = exec_ri_brle,
    [OP_BR_breq] = exec_ri_breq,
    [OP_BR_brne] = exec_ri_brne,
    [OP_BR_cbr] = exec_ri_cbr,
};
hive_executor_t ri_execs[] = {
    [OP_RI_lea] = exec_ri_lea,
    [OP_RI_movzk] = exec_ri_movzk,
    [OP_RI_tst] = exec_ri_tst,
    [OP_RI_cmp] = exec_ri_cmp,
    [OP_RI_svc] = exec_ri_svc,
};
#define vpu_execs(_type) \
hive_executor_t vpu_ ## _type ## _execs[] = { \
    [OP_VPU_add] = exec_vpu_ ## _type ## _add, \
    [OP_VPU_sub] = exec_vpu_ ## _type ## _sub, \
    [OP_VPU_mul] = exec_vpu_ ## _type ## _mul, \
    [OP_VPU_div] = exec_vpu_ ## _type ## _div, \
    [OP_VPU_addsub] = exec_vpu_ ## _type ## _addsub, \
    [OP_VPU_madd] = exec_vpu_ ## _type ## _madd, \
    [OP_VPU_mov] = exec_vpu_ ## _type ## _mov, \
    [OP_VPU_mov_vec] = exec_vpu_ ## _type ## _mov_vec, \
    [OP_VPU_conv] = exec_vpu_ ## _type ## _conv, \
    [OP_VPU_len] = exec_vpu_ ## _type ## _len, \
}
vpu_execs(o);
vpu_execs(b);
vpu_execs(w);
vpu_execs(d);
vpu_execs(q);
vpu_execs(l);
vpu_execs(s);
vpu_execs(f);
hive_executor_t* vpu_execs[] = {
    vpu_o_execs,
    vpu_b_execs,
    vpu_w_execs,
    vpu_d_execs,
    vpu_q_execs,
    vpu_l_execs,
    vpu_s_execs,
    vpu_f_execs,
};

hive_executor_t* execs[] = {
    [OP_BRANCH] = branch_execs,
    [OP_AI] = ai_execs,
    [OP_RRI] = rri_execs,
    [OP_AR] = ar_execs,
    [OP_RRR] = rrr_execs,
    [OP_BR] = branchr_execs,
    [OP_RI] = ri_execs,
};

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

char* dis(hive_instruction_t ins, uint64_t addr);

#pragma endregion

#define PIPELINE_SIZE 16
typedef hive_instruction_t pipeline_t[PIPELINE_SIZE];

void fetch(pipeline_t pipeline, hive_instruction_t* from, hive_register_t* r) {
    for (size_t i = 0; i < PIPELINE_SIZE; i++) {
        hive_instruction_t ins = *from;
        if (ins.generic.type == OP_BRANCH) {
            from = (hive_instruction_t*) decode_branch_target((QWord_t) from, ins, r);
        } else if (ins.generic.type == OP_RRI && ins.rri.r1 == REG_PC && ins.rri.r2 == REG_LR && ins.rri.imm == 0) {
            from = (r[ins.rri.r2].asInstrPtr + 1);
        } else {
            from++;
        }
        pipeline[i] = ins;
    }
}

void exec(hive_register_t* r, hive_flag_register_t* fr, hive_vector_register_t* v) {
    pipeline_t pipeline;
    while (1) {
        fetch(pipeline, r[REG_PC].asInstrPtr, r);

        for (size_t i = 0; i < PIPELINE_SIZE; i++) {
            hive_instruction_t ins = pipeline[i];
            if (*r[REG_PC].asDWordPtr != *(DWord_t*) &ins) {
                break;
            }
            
            switch (ins.generic.type) {
                case OP_BRANCH: branch_execs[ins.branch.op](ins, r, fr, v); break;
                case OP_AI:     ai_execs[ins.rri.op](ins, r, fr, v); break;
                case OP_RRI:    rri_execs[ins.rri.op](ins, r, fr, v); break;
                case OP_AR:     ar_execs[ins.rrr.op](ins, r, fr, v); break;
                case OP_RRR:    rrr_execs[ins.rrr.op](ins, r, fr, v); break;
                case OP_BR:     branchr_execs[ins.ri_branch.op](ins, r, fr, v); break;
                case OP_RI:     ri_execs[ins.ri.op](ins, r, fr, v); break;
            }
            r[REG_PC].asInstrPtr++;
        }
    }
}

void disassemble(Section code_sect, Symbol_Offsets syms, Symbol_Offsets relocations);
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
        
        Symbol_Offsets all_syms = prepare(hf, true);

        hive_register_file_t regs = {0};
        hive_vector_register_t vregisters[16];

        registers = &regs;
        vector_registers = vregisters;

        regs.r[REG_PC].asQWord = find_symbol_address(all_syms, "_start");

        if (regs.r[REG_PC].asSQWord != -1) {
            char stack[1024 * 1024];
            regs.r[REG_SP].asQWord = ((QWord_t) stack) + sizeof(stack);
            exec(regs.r, &regs.flags, vregisters);
            return regs.r[0].asSDWord;
        }
        
        fprintf(stderr, "Could not find _start symbol\n");
        return 1;
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
