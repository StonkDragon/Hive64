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
#include <setjmp.h>

#define NOB_IMPLEMENTATION
#include "nob.h"
#include "new_ops.h"

hive_register_file_t register_file = {0};
hive_simd_register_t simd_registers[8] = {0};

void exec_svc(register hive_register_file_t* const restrict regs) {
    switch (regs->r[8].asQWord) {
    case 0:
        exit(regs->r[0].asDWord);
        break;
    case 1:
        regs->r[0].asSQWord = write(regs->r[0].asDWord, regs->r[1].asPointer, regs->r[2].asQWord);
        break;
    default:
        fprintf(stderr, "Invalid svc call: %lld\n", regs->r[8].asQWord);
        exit(-1);
        break;
    }
}
static inline void test(register hive_register_file_t* const restrict regs, uint64_t a, uint64_t b) {
    regs->spec.flags.equal = (a == b);
    regs->spec.flags.negative = (a < b);
    // lt, mi   -> negative
    // gt       -> !equal && !negative
    // ge, pl   -> equal || !negative
    // le       -> negative || equal
    // eq, z    -> equal
    // ne, nz   -> !equal
}
#define BRANCH(to)                  (regs->spec.pc.asInstrPtr = (to))
#define LINK()                      (regs->spec.lr.asQWord = regs->spec.pc.asQWord)
#define BRANCH_LINK(to)             (LINK(), BRANCH(to))
#define BRANCH_ON(to, what)         (regs->spec.pc.asInstrPtr = (to) * (what))
#define LINK_ON(what)               (regs->spec.lr.asQWord = regs->spec.pc.asQWord * (what) + regs->spec.lr.asQWord * !(what))
#define BRANCH_LINK_ON(to, what)    (LINK_ON(what), BRANCH_ON(to, what))
#define PC_REL(what)                (regs->spec.pc.asQWord + (what) * sizeof(hive_instruction_t))

void exec_data_type(hive_instruction_t ins, register hive_register_file_t* const restrict regs, register hive_simd_register_t simd_regs[8]) {
    switch (ins.data.op) {
        case OP_DATA_nop:
            break;
        case OP_DATA_ret:
            regs->spec.pc.asInstrPtr = regs->spec.lr.asInstrPtr;
            break;
        case OP_DATA_b:
            BRANCH(PC_REL(ins.data_s.data));
            break;
        case OP_DATA_bl:
            BRANCH_LINK(PC_REL(ins.data_s.data));
            break;
        case OP_DATA_blt:
            BRANCH_ON(PC_REL(ins.data_s.data), regs->spec.flags.negative);
            break;
        case OP_DATA_bgt:
            BRANCH_ON(PC_REL(ins.data_s.data), !regs->spec.flags.negative && !regs->spec.flags.equal);
            break;
        case OP_DATA_bge:
            BRANCH_ON(PC_REL(ins.data_s.data), !regs->spec.flags.negative || regs->spec.flags.equal);
            break;
        case OP_DATA_ble:
            BRANCH_ON(PC_REL(ins.data_s.data), regs->spec.flags.negative || regs->spec.flags.equal);
            break;
        case OP_DATA_beq:
            BRANCH_ON(PC_REL(ins.data_s.data), regs->spec.flags.equal);
            break;
        case OP_DATA_bne:
            BRANCH_ON(PC_REL(ins.data_s.data), regs->spec.flags.equal);
            break;
        case OP_DATA_bllt:
            BRANCH_LINK_ON(PC_REL(ins.data_s.data), regs->spec.flags.negative);
            break;
        case OP_DATA_blgt:
            BRANCH_LINK_ON(PC_REL(ins.data_s.data), !regs->spec.flags.negative && !regs->spec.flags.equal);
            break;
        case OP_DATA_blge:
            BRANCH_LINK_ON(PC_REL(ins.data_s.data), !regs->spec.flags.negative || regs->spec.flags.equal);
            break;
        case OP_DATA_blle:
            BRANCH_LINK_ON(PC_REL(ins.data_s.data), regs->spec.flags.negative || regs->spec.flags.equal);
            break;
        case OP_DATA_bleq:
            BRANCH_LINK_ON(PC_REL(ins.data_s.data), regs->spec.flags.equal);
            break;
        case OP_DATA_blne:
            BRANCH_LINK_ON(PC_REL(ins.data_s.data), regs->spec.flags.equal);
            break;
    }
}

void exec_rri_type(hive_instruction_t ins, register hive_register_file_t* const restrict regs, register hive_simd_register_t simd_regs[8]) {
    switch (ins.rri.op) {
        case OP_RRI_add:
            regs->r[ins.rri.r1].asQWord = regs->r[ins.rri.r2].asQWord + ins.rri.imm;
            break;
        case OP_RRI_sub:
            regs->r[ins.rri.r1].asQWord = regs->r[ins.rri.r2].asQWord - ins.rri.imm;
            break;
        case OP_RRI_mul:
            regs->r[ins.rri.r1].asQWord = regs->r[ins.rri.r2].asQWord * ins.rri.imm;
            break;
        case OP_RRI_div:
            regs->r[ins.rri.r1].asQWord = regs->r[ins.rri.r2].asQWord / ins.rri.imm;
            break;
        case OP_RRI_mod:
            regs->r[ins.rri.r1].asQWord = regs->r[ins.rri.r2].asQWord % ins.rri.imm;
            break;
        case OP_RRI_and:
            regs->r[ins.rri.r1].asQWord = regs->r[ins.rri.r2].asQWord & ins.rri.imm;
            break;
        case OP_RRI_or:
            regs->r[ins.rri.r1].asQWord = regs->r[ins.rri.r2].asQWord | ins.rri.imm;
            break;
        case OP_RRI_xor:
            regs->r[ins.rri.r1].asQWord = regs->r[ins.rri.r2].asQWord ^ ins.rri.imm;
            break;
        case OP_RRI_shl:
            regs->r[ins.rri.r1].asQWord = regs->r[ins.rri.r2].asQWord << ins.rri.imm;
            break;
        case OP_RRI_shr:
            regs->r[ins.rri.r1].asQWord = regs->r[ins.rri.r2].asQWord >> ins.rri.imm;
            break;
        case OP_RRI_rol:
            #define ROL(_a, _b) ((_a) >> (_b)) | ((_a) << ((sizeof(typeof(_a)) << 3) - (_b)))
            regs->r[ins.rri.r1].asQWord = ROL(regs->r[ins.rri.r2].asQWord, ins.rri.imm);
            break;
        case OP_RRI_ror:
            #define ROR(_a, _b) ((_a) << (_b)) | ((_a) >> ((sizeof(typeof(_a)) << 3) - (_b)))
            regs->r[ins.rri.r1].asQWord = ROR(regs->r[ins.rri.r2].asQWord, ins.rri.imm);
            break;
        case OP_RRI_ldr:
            regs->r[ins.rri.r1].asQWord = *(QWord_t*) (regs->r[ins.rri.r2].asQWord + ins.rri_s.imm);
            break;
        case OP_RRI_str:
            *(QWord_t*) (regs->r[ins.rri.r2].asQWord + ins.rri_s.imm) = regs->r[ins.rri.r1].asQWord;
            break;
        case OP_RRI_ldrb:
            regs->r[ins.rri.r1].asByte = *(Byte_t*) (regs->r[ins.rri.r2].asQWord + ins.rri_s.imm);
            break;
        case OP_RRI_strb:
            *(Byte_t*) (regs->r[ins.rri.r2].asQWord + ins.rri_s.imm) = regs->r[ins.rri.r1].asByte;
            break;
        case OP_RRI_ldrw:
            regs->r[ins.rri.r1].asWord = *(Word_t*) (regs->r[ins.rri.r2].asQWord + ins.rri_s.imm);
            break;
        case OP_RRI_strw:
            *(Word_t*) (regs->r[ins.rri.r2].asQWord + ins.rri_s.imm) = regs->r[ins.rri.r1].asWord;
            break;
        case OP_RRI_mov:
            regs->r[ins.rri.r1].asQWord = regs->r[ins.rri.r2].asQWord;
            break;
    }
}
void exec_rrr_type(hive_instruction_t ins, register hive_register_file_t* const restrict regs, register hive_simd_register_t simd_regs[8]) {
    switch (ins.rrr.op) {
        case OP_RRR_add:
            regs->r[ins.rrr.r1].asQWord = regs->r[ins.rrr.r2].asQWord + regs->r[ins.rrr.r3].asQWord;
            break;
        case OP_RRR_sub:
            regs->r[ins.rrr.r1].asQWord = regs->r[ins.rrr.r2].asQWord - regs->r[ins.rrr.r3].asQWord;
            break;
        case OP_RRR_mul:
            regs->r[ins.rrr.r1].asQWord = regs->r[ins.rrr.r2].asQWord * regs->r[ins.rrr.r3].asQWord;
            break;
        case OP_RRR_div:
            regs->r[ins.rrr.r1].asQWord = regs->r[ins.rrr.r2].asQWord / regs->r[ins.rrr.r3].asQWord;
            break;
        case OP_RRR_mod:
            regs->r[ins.rrr.r1].asQWord = regs->r[ins.rrr.r2].asQWord % regs->r[ins.rrr.r3].asQWord;
            break;
        case OP_RRR_and:
            regs->r[ins.rrr.r1].asQWord = regs->r[ins.rrr.r2].asQWord & regs->r[ins.rrr.r3].asQWord;
            break;
        case OP_RRR_or:
            regs->r[ins.rrr.r1].asQWord = regs->r[ins.rrr.r2].asQWord | regs->r[ins.rrr.r3].asQWord;
            break;
        case OP_RRR_xor:
            regs->r[ins.rrr.r1].asQWord = regs->r[ins.rrr.r2].asQWord ^ regs->r[ins.rrr.r3].asQWord;
            break;
        case OP_RRR_shl:
            regs->r[ins.rrr.r1].asQWord = regs->r[ins.rrr.r2].asQWord << regs->r[ins.rrr.r3].asQWord;
            break;
        case OP_RRR_shr:
            regs->r[ins.rrr.r1].asQWord = regs->r[ins.rrr.r2].asQWord >> regs->r[ins.rrr.r3].asQWord;
            break;
        case OP_RRR_rol:
            regs->r[ins.rrr.r1].asQWord = ROL(regs->r[ins.rrr.r2].asQWord, regs->r[ins.rrr.r3].asQWord);
            break;
        case OP_RRR_ror:
            regs->r[ins.rrr.r1].asQWord = ROR(regs->r[ins.rrr.r2].asQWord, regs->r[ins.rrr.r3].asQWord);
            break;
        case OP_RRR_ldr:
            regs->r[ins.rrr.r1].asQWord = *(QWord_t*) (regs->r[ins.rrr.r2].asQWord + regs->r[ins.rrr.r3].asQWord);
            break;
        case OP_RRR_str:
            *(QWord_t*) (regs->r[ins.rrr.r2].asQWord + regs->r[ins.rrr.r3].asQWord) = regs->r[ins.rrr.r1].asQWord;
            break;
        case OP_RRR_ldrb:
            regs->r[ins.rrr.r1].asByte = *(Byte_t*) (regs->r[ins.rrr.r2].asQWord + regs->r[ins.rrr.r3].asQWord);
            break;
        case OP_RRR_strb:
            *(Byte_t*) (regs->r[ins.rrr.r2].asQWord + regs->r[ins.rrr.r3].asQWord) = regs->r[ins.rrr.r1].asByte;
            break;
        case OP_RRR_ldrw:
            regs->r[ins.rrr.r1].asWord = *(Word_t*) (regs->r[ins.rrr.r2].asQWord + regs->r[ins.rrr.r3].asQWord);
            break;
        case OP_RRR_strw:
            *(Word_t*) (regs->r[ins.rrr.r2].asQWord + regs->r[ins.rrr.r3].asQWord) = regs->r[ins.rrr.r1].asWord;
            break;
        case OP_RRR_tst:
            test(regs, regs->r[ins.rrr.r1].asQWord, regs->r[ins.rrr.r2].asQWord);
            break;
    }
}
void exec_ri_type(hive_instruction_t ins, register hive_register_file_t* const restrict regs, register hive_simd_register_t simd_regs[8]) {
    switch (ins.ri.op) {
        case OP_RI_cbz:
            if (regs->spec.flags.equal) {
                regs->spec.pc.asInstrPtr += ins.data_s.data;
            }
            break;
        case OP_RI_cbnz:
            if (!regs->spec.flags.equal) {
                regs->spec.pc.asInstrPtr += ins.data_s.data;
            }
            break;
        case OP_RI_lea:
            regs->r[ins.ri.r1].asInstrPtr = regs->spec.pc.asInstrPtr + ins.ri_s.imm;
            break;
        case OP_RI_movk:
            regs->r[ins.ri_mov.r1].asQWord &= ROL(0xFFFFFFFFFFFF0000, (16 * ins.ri_mov.shift));
            regs->r[ins.ri_mov.r1].asQWord |= ROL((uint64_t) ins.ri_mov.imm, (16 * ins.ri_mov.shift));
            break;
        case OP_RI_movz:
            regs->r[ins.ri_mov.r1].asQWord = ROL((uint64_t) ins.ri_mov.imm, (16 * ins.ri_mov.shift));
            break;
        case OP_RI_svc:
            exec_svc(regs);
            break;
        case OP_RI_br:
            BRANCH(regs->r[ins.ri.r1].asQWord);
            break;
        case OP_RI_blr:
            BRANCH_LINK(regs->r[ins.ri.r1].asQWord);
            break;
        case OP_RI_brlt:
            BRANCH_ON(regs->r[ins.ri.r1].asQWord, regs->spec.flags.negative);
            break;
        case OP_RI_brgt:
            BRANCH_ON(regs->r[ins.ri.r1].asQWord, !regs->spec.flags.negative && !regs->spec.flags.equal);
            break;
        case OP_RI_brge:
            BRANCH_ON(regs->r[ins.ri.r1].asQWord, !regs->spec.flags.negative || regs->spec.flags.equal);
            break;
        case OP_RI_brle:
            BRANCH_ON(regs->r[ins.ri.r1].asQWord, regs->spec.flags.negative || regs->spec.flags.equal);
            break;
        case OP_RI_breq:
            BRANCH_ON(regs->r[ins.ri.r1].asQWord, regs->spec.flags.equal);
            break;
        case OP_RI_brne:
            BRANCH_ON(regs->r[ins.ri.r1].asQWord, regs->spec.flags.equal);
            break;
        case OP_RI_blrlt:
            BRANCH_LINK_ON(regs->r[ins.ri.r1].asQWord, regs->spec.flags.negative);
            break;
        case OP_RI_blrgt:
            BRANCH_LINK_ON(regs->r[ins.ri.r1].asQWord, !regs->spec.flags.negative && !regs->spec.flags.equal);
            break;
        case OP_RI_blrge:
            BRANCH_LINK_ON(regs->r[ins.ri.r1].asQWord, !regs->spec.flags.negative || regs->spec.flags.equal);
            break;
        case OP_RI_blrle:
            BRANCH_LINK_ON(regs->r[ins.ri.r1].asQWord, regs->spec.flags.negative || regs->spec.flags.equal);
            break;
        case OP_RI_blreq:
            BRANCH_LINK_ON(regs->r[ins.ri.r1].asQWord, regs->spec.flags.equal);
            break;
        case OP_RI_blrne:
            BRANCH_LINK_ON(regs->r[ins.ri.r1].asQWord, regs->spec.flags.equal);
            break;
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

char* str_data_type(hive_instruction_t ins) {
    switch (ins.data.op) {
        case OP_DATA_nop: return strformat("nop");
        case OP_DATA_ret: return strformat("ret");
        case OP_DATA_b: return strformat("b %d", ins.data_s.data);
        case OP_DATA_bl: return strformat("bl %d", ins.data_s.data);
        case OP_DATA_blt: return strformat("blt %d", ins.data_s.data);
        case OP_DATA_bgt: return strformat("bgt %d", ins.data_s.data);
        case OP_DATA_bge: return strformat("bge %d", ins.data_s.data);
        case OP_DATA_ble: return strformat("ble %d", ins.data_s.data);
        case OP_DATA_beq: return strformat("beq %d", ins.data_s.data);
        case OP_DATA_bne: return strformat("bne %d", ins.data_s.data);
        case OP_DATA_bllt: return strformat("bllt %d", ins.data_s.data);
        case OP_DATA_blgt: return strformat("blgt %d", ins.data_s.data);
        case OP_DATA_blge: return strformat("blge %d", ins.data_s.data);
        case OP_DATA_blle: return strformat("blle %d", ins.data_s.data);
        case OP_DATA_bleq: return strformat("bleq %d", ins.data_s.data);
        case OP_DATA_blne: return strformat("blne %d", ins.data_s.data);
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
        case OP_RRI_shl: return strformat("shl r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_shr: return strformat("shr r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_rol: return strformat("rol r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_ror: return strformat("ror r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_ldr: return strformat("ldr r%d, [r%d, %d]", ins.rri.r1, ins.rri.r2, ins.rri_s.imm);
        case OP_RRI_str: return strformat("str r%d, [r%d, %d]", ins.rri.r1, ins.rri.r2, ins.rri_s.imm);
        case OP_RRI_ldrb: return strformat("ldrb r%d, [r%d, %d]", ins.rri.r1, ins.rri.r2, ins.rri_s.imm);
        case OP_RRI_strb: return strformat("strb r%d, [r%d, %d]", ins.rri.r1, ins.rri.r2, ins.rri_s.imm);
        case OP_RRI_ldrw: return strformat("ldrw r%d, [r%d, %d]", ins.rri.r1, ins.rri.r2, ins.rri_s.imm);
        case OP_RRI_strw: return strformat("strw r%d, [r%d, %d]", ins.rri.r1, ins.rri.r2, ins.rri_s.imm);
        case OP_RRI_mov: return strformat("mov r%d, r%d", ins.rri.r1, ins.rri.r2);
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
        case OP_RRR_ldr: return strformat("ldr r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_str: return strformat("str r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_ldrb: return strformat("ldrb r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_strb: return strformat("strb r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_ldrw: return strformat("ldrw r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_strw: return strformat("strw r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_tst: return strformat("tst r%d, r%d", ins.rrr.r1, ins.rrr.r2);
    }
    return NULL;
}
char* str_ri_type(hive_instruction_t ins) {
    switch (ins.ri.op) {
        case OP_RI_cbz: return strformat("cbz r%d, 0x%08x", ins.ri_s.r1, ins.ri_s.imm);
        case OP_RI_cbnz: return strformat("cbnz r%d, 0x%08x", ins.ri_s.r1, ins.ri_s.imm);
        case OP_RI_lea: return strformat("lea r%d, 0x%08x", ins.ri_s.r1, ins.ri_s.imm);
        case OP_RI_movk: return strformat("movk r%d, %d, shl %d", ins.ri.r1, ins.ri_mov.imm, ins.ri_mov.shift);
        case OP_RI_movz: return strformat("movz r%d, %d, shl %d", ins.ri.r1, ins.ri_mov.imm, ins.ri_mov.shift);
        case OP_RI_svc: return strformat("svc");
        case OP_RI_br: return strformat("br r%d", ins.ri.r1);
        case OP_RI_blr: return strformat("blr r%d", ins.ri.r1);
        case OP_RI_brlt: return strformat("brlt r%d", ins.ri.r1);
        case OP_RI_brgt: return strformat("brgt r%d", ins.ri.r1);
        case OP_RI_brge: return strformat("brge r%d", ins.ri.r1);
        case OP_RI_brle: return strformat("brle r%d", ins.ri.r1);
        case OP_RI_breq: return strformat("breq r%d", ins.ri.r1);
        case OP_RI_brne: return strformat("brne r%d", ins.ri.r1);
        case OP_RI_blrlt: return strformat("blrlt r%d", ins.ri.r1);
        case OP_RI_blrgt: return strformat("blrgt r%d", ins.ri.r1);
        case OP_RI_blrge: return strformat("blrge r%d", ins.ri.r1);
        case OP_RI_blrle: return strformat("blrle r%d", ins.ri.r1);
        case OP_RI_blreq: return strformat("blreq r%d", ins.ri.r1);
        case OP_RI_blrne: return strformat("blrne r%d", ins.ri.r1);
    }
    return NULL;
}

void dis(hive_instruction_t ins) {
    char* instr = NULL;
    switch (ins.generic.type) {
        case 0: instr = str_data_type(ins); break;
        case 1: instr = str_rri_type(ins); break;
        case 2: instr = str_rrr_type(ins); break;
        case 3: instr = str_ri_type(ins); break;
    }
    printf("0x%08x\t%s\n", *(uint32_t*) &ins, instr);
    free(instr);
}

#pragma endregion

__attribute__((noreturn))
void exec(register hive_register_file_t* const restrict regs, register hive_simd_register_t simd_regs[8]) {
    void** op = NULL;
    while (1) {
        hive_instruction_t ins;
        printf("0x%016llx: ", regs->spec.pc.asQWord);
        ins = *(regs->spec.pc.asInstrPtr++);
        dis(ins);
        switch (ins.generic.type) {
            case 0: exec_data_type(ins, regs, simd_regs); break;
            case 1: exec_rri_type(ins, regs, simd_regs); break;
            case 2: exec_rrr_type(ins, regs, simd_regs); break;
            case 3: exec_ri_type(ins, regs, simd_regs); break;
        }
    }
}

Nob_String_Builder run_compile(const char* file_name, Symbol_Offsets* syms, Symbol_Offsets* relocations);

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
            hf.sects.items[i].data = malloc(sizeof(char) * hf.sects.items[i].len);
            fread(hf.sects.items[i].data, sizeof(char), hf.sects.items[i].len, fp);
        }
    }
    return hf;
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

#define SECT_TYPE_CODE  0x01
#define SECT_TYPE_SYMS  0x02
#define SECT_TYPE_RELOC 0x04

Symbol_Offsets create_symbol_section(Section s) {
    Symbol_Offsets off = {0};
    char* data = s.data;

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
        off.items[i].type = mem_read(data, enum symbol_type);
    }
    #undef mem_read
    return off;
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

Nob_String_Builder pack_symbol_table(Symbol_Offsets syms) {
    Nob_String_Builder s = {0};
    nob_da_append_many(&s, &syms.count, sizeof(syms.count));
    for (size_t i = 0; i < syms.count; i++) {
        struct symbol_offset so = syms.items[i];
        nob_da_append_many(&s, so.name, strlen(so.name) + 1);
        nob_da_append_many(&s, &so.offset, sizeof(so.offset));
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

        switch (reloc.type) {
            case st_abs:
                *((QWord_t*) &code_sect.data[current_address]) = target_address;
                break;
            case st_data: {
                    hive_instruction_t* s = ((hive_instruction_t*) &code_sect.data[current_address]);
                    int32_t diff = target_address - (current_address + sizeof(*s));
                    if (diff % 4) {
                        fprintf(stderr, "Relative target not aligned!");
                        exit(1);
                    }
                    s->data_s.data = diff / 4;
                }
                break;
            case st_ri: {
                    hive_instruction_t* s = ((hive_instruction_t*) &code_sect.data[current_address]);
                    int32_t diff = target_address - (current_address + sizeof(*s));
                    if (diff % 4) {
                        fprintf(stderr, "Relative target not aligned!");
                        exit(1);
                    }
                    s->ri_s.imm = diff / 4;
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

        HiveFile hf = {
            .magic = 0xFEEDF00D,
            .sects = sa
        };
        
        FILE* f = fopen(argv[3], "wb");
        write_hive_file(hf, f);
        fclose(f);
        return 0;
    } else if (strcmp(argv[1], "run") == 0) {
        FILE* f = fopen(argv[2], "rb");
        if (!f) {
            fprintf(stderr, "Could not open file '%s'\n", argv[2]);
            return 1;
        }
        HiveFile hf = read_hive_file(f);
        fclose(f);
        f = NULL;

        Symbol_Offsets symbols = create_symbol_section(get_section(hf, SECT_TYPE_SYMS));
        Symbol_Offsets relocs = create_relocation_section(get_section(hf, SECT_TYPE_RELOC));
        Section code_sect = get_section(hf, SECT_TYPE_CODE);

        relocate(code_sect, relocs, symbols);

        register_file.spec.pc.asPointer = code_sect.data + find_symbol_address(symbols, "_start");

        if (register_file.spec.pc.asSQWord != -1) {
            char stack[1024 * 1024];
            register_file.spec.sp.asPointer = (void*) stack;
            exec(&register_file, simd_registers);
            return register_file.r[0].asQWord;
        }
        
        fprintf(stderr, "Could not find _start symbol\n");
        return 1;
    } else {
        fprintf(stderr, "Unknown command '%s'\n", argv[1]);
        return 1;
    }
}
