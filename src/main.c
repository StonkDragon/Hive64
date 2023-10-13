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
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/time.h>

#include "new_ops.h"

#define PC (registers[32].asPointer)
#define LR (registers[33].asPointer)
#define SP (registers[34].asPointerPointer)
#define FR (registers[35].bytes[0])

#define CR0 (registers[36].asQWord)
#define CR1 (registers[37].asQWord)
#define CR2 (registers[38].asQWord)
#define CR3 (registers[39].asQWord)
#define CR4 (registers[40].asQWord)
#define CR5 (registers[41].asQWord)
#define CR6 (registers[42].asQWord)
#define CR7 (registers[43].asQWord)
#define CR8 (registers[44].asQWord)
#define CR9 (registers[45].asQWord)
#define SVC_TBL (registers[46].asQWord)
#define ADDR_MODE (registers[47].asQWord)

#define ZERO (registers[48].asQWord)
#define ONE (registers[49].asQWord)

#define R0 (registers[0].asQWord)
#define R1 (registers[1].asQWord)
#define R2 (registers[2].asQWord)
#define R3 (registers[3].asQWord)
#define R4 (registers[4].asQWord)
#define R5 (registers[5].asQWord)
#define R6 (registers[6].asQWord)
#define R7 (registers[7].asQWord)
#define R8 (registers[8].asQWord)
#define R9 (registers[9].asQWord)
#define R10 (registers[10].asQWord)
#define R11 (registers[11].asQWord)
#define R12 (registers[12].asQWord)
#define R13 (registers[13].asQWord)
#define R14 (registers[14].asQWord)
#define R15 (registers[15].asQWord)
#define R16 (registers[16].asQWord)
#define R17 (registers[17].asQWord)
#define R18 (registers[18].asQWord)
#define R19 (registers[19].asQWord)
#define R20 (registers[20].asQWord)
#define R21 (registers[21].asQWord)
#define R22 (registers[22].asQWord)
#define R23 (registers[23].asQWord)
#define R24 (registers[24].asQWord)
#define R25 (registers[25].asQWord)
#define R26 (registers[26].asQWord)
#define R27 (registers[27].asQWord)
#define R28 (registers[28].asQWord)
#define R29 (registers[29].asQWord)
#define R30 (registers[30].asQWord)
#define R31 (registers[31].asQWord)

#define FLAG_ZERO           0b0001
#define ZERO_FLAG_SET       (FR & FLAG_ZERO)
#define FLAG_NEGATIVE       0b0010
#define NEGATIVE_FLAG_SET   (FR & FLAG_NEGATIVE)
#define FLAG_CARRY          0b0100
#define CARRY_FLAG_SET      (FR & FLAG_CARRY)
#define FLAG_INTERRUPT      0b1000
#define INTERRUPT_FLAG_SET  (FR & FLAG_INTERRUPT)

#define RESET_ADDRESSING_MODE() ADDR_MODE = 4

typedef union {
    struct {
    } none PACKED;
    struct {
        uint8_t reg1 PACKED;
    } reg PACKED;
    struct {
        uint8_t reg1 PACKED;
        uint8_t reg2 PACKED;
    } reg_reg PACKED;
    struct {
        int16_t imm PACKED;
    } imm16 PACKED;
    struct {
        int16_t imm PACKED;
        uint8_t reg1 PACKED;
    } reg_imm16 PACKED;
    struct {
        uint8_t reg1 PACKED;
        uint8_t reg2 PACKED;
        int16_t offset PACKED;
    } reg_reg_offset PACKED;
    struct {
        uintptr_t addr PACKED;
    } offset PACKED;
    struct {
        uint8_t reg1 PACKED;
        uint8_t nbytes PACKED;
        uint8_t reg2 PACKED;
        uint8_t reg2_offset_reg PACKED;
    } mov_reg_n_reg_offset_reg PACKED;
    struct {
        uintptr_t addr PACKED;
        uint8_t reg PACKED;
    } reg_offset PACKED;
    struct {
        int16_t offset PACKED;
        uint8_t reg1 PACKED;
        uint8_t nbytes PACKED;
        uint8_t reg2 PACKED;
    } mov_reg_n_reg_offset PACKED;
    struct {
        uintptr_t addr PACKED;
        uint8_t reg1 PACKED;
        uint8_t reg2 PACKED;
    } reg_offset_reg PACKED;
    struct {
        uintptr_t addr PACKED;
        uint8_t reg1 PACKED;
        int16_t imm_off PACKED;
    } reg_offset_imm PACKED;
    struct {
        uintptr_t addr PACKED;
        uint8_t reg1 PACKED;
        uint8_t nbytes PACKED;
        uint8_t reg2 PACKED;
    } mov_reg_n_reg_offset_reg_offset PACKED;
    struct {
        uint64_t imm PACKED;
    } imm64 PACKED;
    struct {
        uintptr_t addr PACKED;
        uint8_t reg1 PACKED;
        uint8_t nbytes PACKED;
        int16_t offset_offset PACKED;
    } mov_reg_n_reg_offset_reg_offset_offset PACKED;
    struct {
        uint64_t imm PACKED;
        uint8_t reg1 PACKED;
    } reg_imm64 PACKED;

    __uint128_t imm128; // 16 bytes because that is the maximum extra size of an instruction
} args_t;

typedef void (*opc_func)(register hive_register_t* const restrict, register const opcode_t args);

#pragma region EXEC

#define NBITS_TO_BITMASK(_nbits)    ((1ULL << _nbits) - 1)
#define NBYTES_TO_BITMASK(_nbytes)  NBITS_TO_BITMASK(_nbytes * 8)

static inline uint64_t sign_extend(uint64_t src, uint8_t nbits) {
    uint64_t sign_bit = src & (1ULL << (nbits - 1));
    if (sign_bit) {
        uint64_t mask = NBITS_TO_BITMASK(nbits);
        src |= ~mask;
    }
    return src;
}

static inline uint64_t zero_extend(uint64_t src, uint8_t nbits) {
    uint64_t mask = NBITS_TO_BITMASK(nbits);
    src &= mask;
    return src;
}

#undef OPC
#undef OPC_ENDFUNC
#undef OPC_FUNC

#define CAT_(a, b)                  a ## b
#define CAT(a, b)                   CAT_(a, b)

#define OPC_DEF(_opcode)            static void execute_ ## _opcode(register hive_register_t* const restrict registers, register const opcode_t args)
#define OPC(_opcode)                [_opcode] = execute_ ## _opcode
#define OPC_FUNCS                   const opc_func opcs[] = {
#define OPC_END                     }

OPC_DEF(opcode_nop) {
    (void) args;
    (void) registers;
}

OPC_DEF(opcode_ret) {
    if (LR) {
        PC = LR;
        LR = *(--SP);
        return;
    }
    exit(R0);
}

OPC_DEF(opcode_irq) {
    switch (R0) {
        case 0x1: {
            SVC_TBL = R1;
            break;
        }
        case 0x2: {
            exit(R1);
        }
        case 0xe: {
            uint8_t s[2] = {registers[1].asByte, 0};
            write(R2, (char*) s, 1);
            break;
        }
    }
}

OPC_DEF(opcode_svc) {
    *(SP++) = LR;
    LR = PC;
    PC = ((void**) SVC_TBL)[R0];
}

OPC_DEF(opcode_b_addr) {
    int64_t offset = ((int64_t) sign_extend(args.args.args_raw, 24)) * 4;

    PC += offset;
}

OPC_DEF(opcode_bl_addr) {
    int64_t offset = ((int64_t) sign_extend(args.args.args_raw, 24)) * 4;

    *(SP++) = LR;
    LR = PC;
    PC += offset;
}

OPC_DEF(opcode_br_reg) {
    PC = registers[args.args.r].asPointer;
}

OPC_DEF(opcode_blr_reg) {
    *(SP++) = LR;
    LR = PC;
    PC = registers[args.args.r].asPointer;
}

OPC_DEF(opcode_dot_eq) {
    if (!(ZERO_FLAG_SET)) {
        PC += sizeof(opcode_t) * (args.args.u8 + 1);
    }
}

OPC_DEF(opcode_dot_ne) {
    if (ZERO_FLAG_SET) {
        PC += sizeof(opcode_t) * (args.args.u8 + 1);
    }
}

OPC_DEF(opcode_dot_lt) {
    if (!(NEGATIVE_FLAG_SET)) {
        PC += sizeof(opcode_t) * (args.args.u8 + 1);
    }
}

OPC_DEF(opcode_dot_gt) {
    if (NEGATIVE_FLAG_SET || ZERO_FLAG_SET) {
        PC += sizeof(opcode_t) * (args.args.u8 + 1);
    }
}

OPC_DEF(opcode_dot_le) {
    if (!(NEGATIVE_FLAG_SET) && !(ZERO_FLAG_SET)) {
        PC += sizeof(opcode_t) * (args.args.u8 + 1);
    }
}

OPC_DEF(opcode_dot_ge) {
    if (ZERO_FLAG_SET || NEGATIVE_FLAG_SET) {
        PC += sizeof(opcode_t) * (args.args.u8 + 1);
    }
}

OPC_DEF(opcode_dot_cs) {
    if (!(CARRY_FLAG_SET)) {
        PC += sizeof(opcode_t) * (args.args.u8 + 1);
    }
}

OPC_DEF(opcode_dot_cc) {
    if (CARRY_FLAG_SET) {
        PC += sizeof(opcode_t) * (args.args.u8 + 1);
    }
}

OPC_DEF(opcode_ldr_reg_reg) {
    uint8_t dest = args.args.rr.reg1;
    uint8_t src = args.args.rr.reg2;

    switch (ADDR_MODE) {
        case 1: registers[dest].asByte = registers[src].asByte; break;
        case 2: registers[dest].asWord = registers[src].asWord; break;
        case 3: registers[dest].asDWord = registers[src].asDWord; break;
        default: registers[dest].asQWord = registers[src].asQWord; break;
    }
    RESET_ADDRESSING_MODE();
}

OPC_DEF(opcode_ldr_reg_addr_imm) {
    uint8_t dest = args.args.rri.reg1;
    uint8_t src = args.args.rri.reg2;
    int8_t offset_imm = args.args.rri.imm;

    switch (ADDR_MODE) {
        case 1: registers[dest].asByte = *(uint8_t*) (registers[src].asPointer + offset_imm); break;
        case 2: registers[dest].asWord = *(uint16_t*) (registers[src].asPointer + offset_imm); break;
        case 3: registers[dest].asDWord = *(uint32_t*) (registers[src].asPointer + offset_imm); break;
        default: registers[dest].asQWord = *(uint64_t*) (registers[src].asPointer + offset_imm); break;
    }
    RESET_ADDRESSING_MODE();
}

OPC_DEF(opcode_ldr_reg_addr_reg) {
    uint8_t dest = args.args.rrr.reg1;
    uint8_t src = args.args.rrr.reg2;
    uint8_t offset_reg = args.args.rrr.reg3;

    switch (ADDR_MODE) {
        case 1: registers[dest].asByte = *(uint8_t*) (registers[src].asPointer + registers[offset_reg].asSQWord); break;
        case 2: registers[dest].asWord = *(uint16_t*) (registers[src].asPointer + registers[offset_reg].asSQWord); break;
        case 3: registers[dest].asDWord = *(uint32_t*) (registers[src].asPointer + registers[offset_reg].asSQWord); break;
        default: registers[dest].asQWord = *(uint64_t*) (registers[src].asPointer + registers[offset_reg].asSQWord); break;
    }
    RESET_ADDRESSING_MODE();
}

OPC_DEF(opcode_str_reg_reg) {
    uint8_t dest = args.args.rr.reg1;
    uint8_t src = args.args.rr.reg2;

    switch (ADDR_MODE) {
        case 1: *(uint8_t*) registers[dest].asPointer = registers[src].asByte; break;
        case 2: *(uint16_t*) registers[dest].asPointer = registers[src].asWord; break;
        case 3: *(uint32_t*) registers[dest].asPointer = registers[src].asDWord; break;
        default: *(uint64_t*) registers[dest].asPointer = registers[src].asQWord; break;
    }
    RESET_ADDRESSING_MODE();
}

OPC_DEF(opcode_str_reg_addr_reg) {
    uint8_t dest = args.args.rrr.reg1;
    uint8_t dest_offset_reg = args.args.rrr.reg2;
    uint8_t src = args.args.rrr.reg3;

    switch (ADDR_MODE) {
        case 1: *(uint8_t*) (registers[dest].asPointer + registers[dest_offset_reg].asSQWord) = registers[src].asByte; break;
        case 2: *(uint16_t*) (registers[dest].asPointer + registers[dest_offset_reg].asSQWord) = registers[src].asWord; break;
        case 3: *(uint32_t*) (registers[dest].asPointer + registers[dest_offset_reg].asSQWord) = registers[src].asDWord; break;
        default: *(uint64_t*) (registers[dest].asPointer + registers[dest_offset_reg].asSQWord) = registers[src].asQWord; break;
    }
    RESET_ADDRESSING_MODE();
}

#define HIGHEST_BIT(_type) (1ULL << (sizeof(_type) * 8 - 1))

#define ARITH(_op, _what) \
OPC_DEF(opcode_ ## _op ## _reg_reg_reg) { \
    uint8_t dest = args.args.rrr.reg1; \
    uint8_t src1 = args.args.rrr.reg2; \
    uint8_t src2 = args.args.rrr.reg3; \
    switch (ADDR_MODE) { \
        case 1: { \
            registers[dest].asByte = registers[src1].asByte _what registers[src2].asByte; \
            if (registers[dest].asByte < registers[src1].asByte) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; } \
            if (registers[dest].asByte == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; } \
            if (registers[dest].asByte & HIGHEST_BIT(uint8_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; } \
            break; \
        } \
        case 2: { \
            registers[dest].asWord = registers[src1].asWord _what registers[src2].asWord; \
            if (registers[dest].asWord < registers[src1].asWord) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; } \
            if (registers[dest].asWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; } \
            if (registers[dest].asWord & HIGHEST_BIT(uint16_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; } \
            break; \
        } \
        case 3: { \
            registers[dest].asDWord = registers[src1].asDWord _what registers[src2].asDWord; \
            if (registers[dest].asDWord < registers[src1].asDWord) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; } \
            if (registers[dest].asDWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; } \
            if (registers[dest].asDWord & HIGHEST_BIT(uint32_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; } \
            break; \
        } \
        default: { \
            registers[dest].asQWord = registers[src1].asQWord _what registers[src2].asQWord; \
            if (registers[dest].asQWord < registers[src1].asQWord) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; } \
            if (registers[dest].asQWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; } \
            if (registers[dest].asQWord & HIGHEST_BIT(uint64_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; } \
            break; \
        } \
    } \
    RESET_ADDRESSING_MODE(); \
}

ARITH(add, +)
ARITH(sub, -)
ARITH(mul, *)
ARITH(div, /)
ARITH(mod, %)
ARITH(and, &)
ARITH(or, |)
ARITH(xor, ^)
ARITH(shl, <<)
ARITH(shr, >>)

#define ROTATE_LEFT(_val, _n, _type)  ((_val << _n) | (_val >> (sizeof(_type) * 8 - _n)))
#define ROTATE_RIGHT(_val, _n, _type) ((_val >> _n) | (_val << (sizeof(_type) * 8 - _n)))

OPC_DEF(opcode_rol_reg_reg_reg) {
    uint8_t dest = args.args.rrr.reg1;
    uint8_t src1 = args.args.rrr.reg2;
    uint8_t src2 = args.args.rrr.reg3;

    switch (ADDR_MODE) {
        case 1: {
            registers[dest].asByte = ROTATE_LEFT(registers[src1].asByte, registers[src2].asByte, uint8_t);
            if (registers[dest].asByte < registers[src1].asByte) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; }
            if (registers[dest].asByte == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asByte & HIGHEST_BIT(uint8_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
        case 2: {
            registers[dest].asWord = ROTATE_LEFT(registers[src1].asWord, registers[src2].asWord, uint16_t);
            if (registers[dest].asWord < registers[src1].asWord) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; }
            if (registers[dest].asWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asWord & HIGHEST_BIT(uint16_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
        case 3: {
            registers[dest].asDWord = ROTATE_LEFT(registers[src1].asDWord, registers[src2].asDWord, uint32_t);
            if (registers[dest].asDWord < registers[src1].asDWord) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; }
            if (registers[dest].asDWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asDWord & HIGHEST_BIT(uint32_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
        default: {
            registers[dest].asQWord = ROTATE_LEFT(registers[src1].asQWord, registers[src2].asQWord, uint64_t);
            if (registers[dest].asQWord < registers[src1].asQWord) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; }
            if (registers[dest].asQWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asQWord & HIGHEST_BIT(uint64_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
    }
    RESET_ADDRESSING_MODE();
}

OPC_DEF(opcode_ror_reg_reg_reg) {
    uint8_t dest = args.args.rrr.reg1;
    uint8_t src1 = args.args.rrr.reg2;
    uint8_t src2 = args.args.rrr.reg3;

    switch (ADDR_MODE) {
        case 1: {
            registers[dest].asByte = ROTATE_RIGHT(registers[src1].asByte, registers[src2].asByte, uint8_t);
            if (registers[dest].asByte < registers[src1].asByte) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; }
            if (registers[dest].asByte == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asByte & HIGHEST_BIT(uint8_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
        case 2: {
            registers[dest].asWord = ROTATE_RIGHT(registers[src1].asWord, registers[src2].asWord, uint16_t);
            if (registers[dest].asWord < registers[src1].asWord) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; }
            if (registers[dest].asWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asWord & HIGHEST_BIT(uint16_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
        case 3: {
            registers[dest].asDWord = ROTATE_RIGHT(registers[src1].asDWord, registers[src2].asDWord, uint32_t);
            if (registers[dest].asDWord < registers[src1].asDWord) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; }
            if (registers[dest].asDWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asDWord & HIGHEST_BIT(uint32_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
        default: {
            registers[dest].asQWord = ROTATE_RIGHT(registers[src1].asQWord, registers[src2].asQWord, uint64_t);
            if (registers[dest].asQWord < registers[src1].asQWord) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; }
            if (registers[dest].asQWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asQWord & HIGHEST_BIT(uint64_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
    }
    RESET_ADDRESSING_MODE();
}

#undef ARITH

OPC_DEF(opcode_inc_reg) {
    uint8_t dest = args.args.r;

    switch (ADDR_MODE) {
        case 1: {
            registers[dest].asByte++;
            if (registers[dest].asByte == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asByte & HIGHEST_BIT(uint8_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
        case 2: {
            registers[dest].asWord++;
            if (registers[dest].asWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asWord & HIGHEST_BIT(uint16_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
        case 3: {
            registers[dest].asDWord++;
            if (registers[dest].asDWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asDWord & HIGHEST_BIT(uint32_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
        default: {
            registers[dest].asQWord++;
            if (registers[dest].asQWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asQWord & HIGHEST_BIT(uint64_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
    }
    RESET_ADDRESSING_MODE();
}

OPC_DEF(opcode_dec_reg) {
    uint8_t dest = args.args.r;

    switch (ADDR_MODE) {
        case 1: {
            registers[dest].asByte--;
            if (registers[dest].asByte == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asByte & HIGHEST_BIT(uint8_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
        case 2: {
            registers[dest].asWord--;
            if (registers[dest].asWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asWord & HIGHEST_BIT(uint16_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
        case 3: {
            registers[dest].asDWord--;
            if (registers[dest].asDWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asDWord & HIGHEST_BIT(uint32_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
        default: {
            registers[dest].asQWord--;
            if (registers[dest].asQWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asQWord & HIGHEST_BIT(uint64_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
    }
    RESET_ADDRESSING_MODE();
}

OPC_DEF(opcode_psh_reg) {
    uint8_t src = args.args.r;

    switch (ADDR_MODE) {
        case 1: *(uint8_t*) (SP++) = registers[src].asByte; break;
        case 2: *(uint16_t*) (SP++) = registers[src].asWord; break;
        case 3: *(uint32_t*) (SP++) = registers[src].asDWord; break;
        default: *(uint64_t*) (SP++) = registers[src].asQWord; break;
    }
    RESET_ADDRESSING_MODE();
}

OPC_DEF(opcode_pp_reg) {
    uint8_t dest = args.args.r;

    switch (ADDR_MODE) {
        case 1: registers[dest].asByte = *(uint8_t*) (--SP); break;
        case 2: registers[dest].asWord = *(uint16_t*) (--SP); break;
        case 3: registers[dest].asDWord = *(uint32_t*) (--SP); break;
        default: registers[dest].asQWord = *(uint64_t*) (--SP); break;
    }
    RESET_ADDRESSING_MODE();
}

OPC_DEF(opcode_movk) {
    uint8_t dest = args.args.ris.reg1;
    uint16_t imm = args.args.ris.imm;
    uint8_t shift = args.args.ris.shift * 16;
    uint64_t mask = 0xFFFF << shift;

    registers[dest].asQWord &= ~mask;
    registers[dest].asQWord |= ((uint64_t) imm) << shift;
}

OPC_DEF(opcode_movz) {
    uint8_t dest = args.args.ris.reg1;
    uint16_t imm = args.args.ris.imm;
    uint8_t shift = args.args.ris.shift * 16;

    registers[dest].asQWord = ((uint64_t) imm) << shift;
}

OPC_DEF(opcode_adrp_reg_addr) {
    uint8_t dest = args.args.ri.reg1;
    int64_t imm = sign_extend(args.args.ri.imm, 16) << 16;
    imm *= 4;
    int64_t base = (int64_t) PC;

    registers[dest].asPointer = (void*) (base + imm);
}

OPC_DEF(opcode_adp_reg_addr) {
    uint8_t dest = args.args.ri.reg1;
    uint64_t imm = (uint16_t) args.args.ri.imm;
    imm *= 4;

    registers[dest].asQWord += imm;
}

OPC_DEF(opcode_cmp_reg_reg) {
    uint8_t reg1 = args.args.rr.reg1;
    uint8_t reg2 = args.args.rr.reg2;

    switch (ADDR_MODE) {
        case 1: {
            if (registers[reg1].asByte < registers[reg2].asByte) {
                FR |= FLAG_CARRY;
            } else {
                FR &= ~FLAG_CARRY;
            }
            if (registers[reg1].asByte == 0) {
                FR |= FLAG_ZERO;
            } else {
                FR &= ~FLAG_ZERO;
            }
            if (registers[reg1].asByte & 0x8000000000000000) {
                FR |= FLAG_NEGATIVE;
            } else {
                FR &= ~FLAG_NEGATIVE;
            }
            break;
        }
        case 2: {
            if (registers[reg1].asWord < registers[reg2].asWord) {
                FR |= FLAG_CARRY;
            } else {
                FR &= ~FLAG_CARRY;
            }
            if (registers[reg1].asWord == 0) {
                FR |= FLAG_ZERO;
            } else {
                FR &= ~FLAG_ZERO;
            }
            if (registers[reg1].asWord & 0x8000000000000000) {
                FR |= FLAG_NEGATIVE;
            } else {
                FR &= ~FLAG_NEGATIVE;
            }
            break;
        }
        case 3: {
            if (registers[reg1].asDWord < registers[reg2].asDWord) {
                FR |= FLAG_CARRY;
            } else {
                FR &= ~FLAG_CARRY;
            }
            if (registers[reg1].asDWord == 0) {
                FR |= FLAG_ZERO;
            } else {
                FR &= ~FLAG_ZERO;
            }
            if (registers[reg1].asDWord & 0x8000000000000000) {
                FR |= FLAG_NEGATIVE;
            } else {
                FR &= ~FLAG_NEGATIVE;
            }
            break;
        }
        default: {
            if (registers[reg1].asQWord < registers[reg2].asQWord) {
                FR |= FLAG_CARRY;
            } else {
                FR &= ~FLAG_CARRY;
            }
            if (registers[reg1].asQWord == 0) {
                FR |= FLAG_ZERO;
            } else {
                FR &= ~FLAG_ZERO;
            }
            if (registers[reg1].asQWord & 0x8000000000000000) {
                FR |= FLAG_NEGATIVE;
            } else {
                FR &= ~FLAG_NEGATIVE;
            }
            break;
        }
    }
    RESET_ADDRESSING_MODE();
}

OPC_DEF(opcode_xchg_reg_reg) {
    uint8_t reg1 = args.args.rr.reg1;
    uint8_t reg2 = args.args.rr.reg2;

    switch (ADDR_MODE) {
        case 1: {
            uint8_t tmp = registers[reg1].asByte;
            registers[reg1].asByte = registers[reg2].asByte;
            registers[reg2].asByte = tmp;
            break;
        }
        case 2: {
            uint16_t tmp = registers[reg1].asWord;
            registers[reg1].asWord = registers[reg2].asWord;
            registers[reg2].asWord = tmp;
            break;
        }
        case 3: {
            uint32_t tmp = registers[reg1].asDWord;
            registers[reg1].asDWord = registers[reg2].asDWord;
            registers[reg2].asDWord = tmp;
            break;
        }
        default: {
            uint64_t tmp = registers[reg1].asQWord;
            registers[reg1].asQWord = registers[reg2].asQWord;
            registers[reg2].asQWord = tmp;
            break;
        }
    }
    RESET_ADDRESSING_MODE();
}

OPC_DEF(opcode_cmpxchg_reg_reg) {
    uint8_t addr_mode = ADDR_MODE;
    execute_opcode_cmp_reg_reg(registers, args);
    if (FR & FLAG_NEGATIVE) {
        ADDR_MODE = addr_mode;
        execute_opcode_xchg_reg_reg(registers, args);
    }
}

#define ARITH(_op, _what) \
OPC_DEF(opcode_ ## _op ## _reg_imm) { \
    uint8_t dest = args.args.ri.reg1; \
    uint16_t imm = args.args.ri.imm; \
    switch (ADDR_MODE) { \
        case 1: { \
            registers[dest].asByte _what ## = imm; \
            if (registers[dest].asByte < imm) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; } \
            if (registers[dest].asByte == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; } \
            if (registers[dest].asByte & HIGHEST_BIT(uint8_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; } \
            break; \
        } \
        case 2: { \
            registers[dest].asWord _what ## = imm; \
            if (registers[dest].asWord < imm) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; } \
            if (registers[dest].asWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; } \
            if (registers[dest].asWord & HIGHEST_BIT(uint16_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; } \
            break; \
        } \
        case 3: { \
            registers[dest].asDWord _what ## = imm; \
            if (registers[dest].asDWord < imm) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; } \
            if (registers[dest].asDWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; } \
            if (registers[dest].asDWord & HIGHEST_BIT(uint32_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; } \
            break; \
        } \
        default: { \
            registers[dest].asQWord _what ## = imm; \
            if (registers[dest].asQWord < imm) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; } \
            if (registers[dest].asQWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; } \
            if (registers[dest].asQWord & HIGHEST_BIT(uint64_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; } \
            break; \
        } \
    } \
    RESET_ADDRESSING_MODE(); \
}

ARITH(add, +)
ARITH(sub, -)
ARITH(mul, *)
ARITH(div, /)
ARITH(mod, %)
ARITH(and, &)
ARITH(or, |)
ARITH(xor, ^)
ARITH(shl, <<)
ARITH(shr, >>)

#define ROTATE_LEFT(_val, _n, _type)  ((_val << _n) | (_val >> (sizeof(_type) * 8 - _n)))
#define ROTATE_RIGHT(_val, _n, _type) ((_val >> _n) | (_val << (sizeof(_type) * 8 - _n)))

OPC_DEF(opcode_rol_reg_imm) {
    uint8_t dest = args.args.ri.reg1;
    uint16_t imm = args.args.ri.imm;

    switch (ADDR_MODE) {
        case 1: {
            registers[dest].asByte = ROTATE_LEFT(registers[dest].asByte, imm, uint8_t);
            if (registers[dest].asByte < imm) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; }
            if (registers[dest].asByte == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asByte & HIGHEST_BIT(uint8_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
        case 2: {
            registers[dest].asWord = ROTATE_LEFT(registers[dest].asWord, imm, uint16_t);
            if (registers[dest].asWord < imm) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; }
            if (registers[dest].asWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asWord & HIGHEST_BIT(uint16_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
        case 3: {
            registers[dest].asDWord = ROTATE_LEFT(registers[dest].asDWord, imm, uint32_t);
            if (registers[dest].asDWord < imm) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; }
            if (registers[dest].asDWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asDWord & HIGHEST_BIT(uint32_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
        default: {
            registers[dest].asQWord = ROTATE_LEFT(registers[dest].asQWord, imm, uint64_t);
            if (registers[dest].asQWord < imm) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; }
            if (registers[dest].asQWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asQWord & HIGHEST_BIT(uint64_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
    }
    RESET_ADDRESSING_MODE();
}

OPC_DEF(opcode_ror_reg_imm) {
    uint8_t dest = args.args.ri.reg1;
    uint16_t imm = args.args.ri.imm;

    switch (ADDR_MODE) {
        case 1: {
            registers[dest].asByte = ROTATE_RIGHT(registers[dest].asByte, imm, uint8_t);
            if (registers[dest].asByte < imm) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; }
            if (registers[dest].asByte == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asByte & HIGHEST_BIT(uint8_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
        case 2: {
            registers[dest].asWord = ROTATE_RIGHT(registers[dest].asWord, imm, uint16_t);
            if (registers[dest].asWord < imm) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; }
            if (registers[dest].asWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asWord & HIGHEST_BIT(uint16_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
        case 3: {
            registers[dest].asDWord = ROTATE_RIGHT(registers[dest].asDWord, imm, uint32_t);
            if (registers[dest].asDWord < imm) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; }
            if (registers[dest].asDWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asDWord & HIGHEST_BIT(uint32_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
        default: {
            registers[dest].asQWord = ROTATE_RIGHT(registers[dest].asQWord, imm, uint64_t);
            if (registers[dest].asQWord < imm) { FR |= FLAG_CARRY; } else { FR &= ~FLAG_CARRY; }
            if (registers[dest].asQWord == 0) { FR |= FLAG_ZERO; } else { FR &= ~FLAG_ZERO; }
            if (registers[dest].asQWord & HIGHEST_BIT(uint64_t)) { FR |= FLAG_NEGATIVE; } else { FR &= ~FLAG_NEGATIVE; }
            break;
        }
    }
    RESET_ADDRESSING_MODE();
}

OPC_DEF(opcode_not_reg) {
    uint8_t reg = args.args.r;

    switch (ADDR_MODE) {
        case 1: {
            registers[reg].asByte = ~registers[reg].asByte;
            break;
        }
        case 2: {
            registers[reg].asWord = ~registers[reg].asWord;
            break;
        }
        case 3: {
            registers[reg].asDWord = ~registers[reg].asDWord;
            break;
        }
        default: {
            registers[reg].asQWord = ~registers[reg].asQWord;
            break;
        }
    }
    RESET_ADDRESSING_MODE();
}

OPC_DEF(opcode_psh_imm) {
    uint16_t imm = args.args.i16;
    *(uint16_t*) (SP++) = imm;
}

OPC_DEF(opcode_psh_addr) {
    int64_t addr = ((int64_t) sign_extend(args.args.args_raw, 24)) * 4;
    *(uint64_t*) (SP++) = (uint64_t) (PC + addr);
}

OPC_DEF(opcode_pause) {
    CR9 = 1;
    FR |= FLAG_INTERRUPT;
    while (INTERRUPT_FLAG_SET) {
        int c = getchar();
        if (c == 10) {
            FR &= ~FLAG_INTERRUPT;
        }
    }
    CR9 = 0;
}

OPC_DEF(opcode_dot_addressing_override) {
    ADDR_MODE = args.args.r;
    if (ADDR_MODE < 1 || ADDR_MODE > 4) {
        ADDR_MODE = 4;
    }
}

OPC_DEF(opcode_dot_symbol) {
    PC = *(void**) PC;
}

OPC_FUNCS
    OPC(opcode_nop),
    OPC(opcode_ret),
    OPC(opcode_irq),
    OPC(opcode_svc),
    OPC(opcode_b_addr),
    OPC(opcode_bl_addr),
    OPC(opcode_br_reg),
    OPC(opcode_blr_reg),
    OPC(opcode_dot_eq),
    OPC(opcode_dot_ne),
    OPC(opcode_dot_lt),
    OPC(opcode_dot_gt),
    OPC(opcode_dot_le),
    OPC(opcode_dot_ge),
    OPC(opcode_dot_cs),
    OPC(opcode_dot_cc),
    OPC(opcode_add_reg_reg_reg),
    OPC(opcode_sub_reg_reg_reg),
    OPC(opcode_mul_reg_reg_reg),
    OPC(opcode_div_reg_reg_reg),
    OPC(opcode_mod_reg_reg_reg),
    OPC(opcode_and_reg_reg_reg),
    OPC(opcode_or_reg_reg_reg),
    OPC(opcode_xor_reg_reg_reg),
    OPC(opcode_shl_reg_reg_reg),
    OPC(opcode_shr_reg_reg_reg),
    OPC(opcode_rol_reg_reg_reg),
    OPC(opcode_ror_reg_reg_reg),
    OPC(opcode_inc_reg),
    OPC(opcode_dec_reg),
    OPC(opcode_psh_reg),
    OPC(opcode_pp_reg),
    OPC(opcode_ldr_reg_reg),
    OPC(opcode_ldr_reg_addr_imm),
    OPC(opcode_ldr_reg_addr_reg),
    NULL,
    NULL,
    OPC(opcode_str_reg_reg),
    OPC(opcode_str_reg_addr_reg),
    NULL,
    OPC(opcode_movz),
    OPC(opcode_movk),
    OPC(opcode_adrp_reg_addr),
    OPC(opcode_adp_reg_addr),
    NULL,
    OPC(opcode_cmp_reg_reg),
    OPC(opcode_xchg_reg_reg),
    OPC(opcode_cmpxchg_reg_reg),
    OPC(opcode_add_reg_imm),
    OPC(opcode_sub_reg_imm),
    OPC(opcode_mul_reg_imm),
    OPC(opcode_div_reg_imm),
    OPC(opcode_mod_reg_imm),
    OPC(opcode_and_reg_imm),
    OPC(opcode_or_reg_imm),
    OPC(opcode_xor_reg_imm),
    OPC(opcode_shl_reg_imm),
    OPC(opcode_shr_reg_imm),
    OPC(opcode_rol_reg_imm),
    OPC(opcode_ror_reg_imm),
    OPC(opcode_not_reg),
    NULL,
    OPC(opcode_psh_imm),
    OPC(opcode_psh_addr),
    OPC(opcode_pause),
    OPC(opcode_dot_addressing_override),
    OPC(opcode_dot_symbol),
OPC_END;

#pragma endregion

__attribute__((noreturn))
void exec(register hive_register_t* const restrict registers) {
    while (1) {
        opcode_t opcode = *(opcode_t*) PC;
        PC += sizeof(opcode_t);
        if (ZERO) ZERO = 0;
        if (ONE != 0xFFFFFFFFFFFFFFFF) ONE = 0xFFFFFFFFFFFFFFFF;
        opcs[opcode.opcode](registers, opcode);
    }
}

int add_symbol(section_t* obj, const char* name) {
    obj->symbols = realloc(obj->symbols, sizeof(symbol_t) * (obj->symbols_size + 1));

    symbol_t* sym = &obj->symbols[obj->symbols_size];
    sym->name = malloc(strlen(name) + 1);
    strcpy((char*) sym->name, name);

    sym->sym_addr = obj->comp_size;

    obj->symbols_size++;
    return 0;
}

int32_t symbol_offset(section_t* obj, const char* name) {
    for (uint32_t i = 0; i < obj->symbols_size; i++) {
        if (strcmp((char*) obj->symbols[i].name, name) == 0) {
            if (obj->symbols[i].sym_addr & 0x8000000000000000) {
                add_instr_addr_offset(obj, i);
                return i;
            }
            int32_t offset = ((int32_t) (obj->symbols[i].sym_addr - obj->size)) / 4;
            return offset;
        }
    }

    add_symbol(obj, name);
    symbol_t* sym = &obj->symbols[obj->symbols_size - 1];
    sym->sym_addr = (obj->symbols_size - 1) | 0x8000000000000000;
    add_instr_addr_offset(obj, obj->symbols_size - 1);
    return (obj->symbols_size - 1);
}

section_t run_compile(const char* file_name);

hive_register_t* registers;

void sig_handler(int sig, siginfo_t* info, void* ucontext) {
    if (CR9) {
        FR &= ~FLAG_INTERRUPT;
        return;
    }
    char* string = strsignal(sig);
    fprintf(stderr, "%s at %p\n", string, info->si_addr);
    void* bt[32];
    size_t size = backtrace(bt, 32);
    backtrace_symbols_fd(bt, size, STDERR_FILENO);
    exit(1);
}

void* find_symbol_in(object_file_t* tu, const char* sym) {
    symbol_t* symbols = tu->code.symbols;
    uint64_t symbols_count = tu->code.symbols_size;

    for (uint64_t i = 0; i < symbols_count; i++) {
        if (strcmp(symbols[i].name, sym) == 0 && ((int64_t) symbols[i].sym_addr) >= 0) {
            return (void*) symbols[i].sym_addr;
        }
    }

    return NULL;
}

void* find_symbol(const char* sym, object_file_t* objects, uint64_t count) {
    for (uint64_t i = 0; i < count; i++) {
        object_file_t* obj = &objects[i];
        void* addr = find_symbol_in(obj, sym);
        if (addr) {
            return addr;
        }
    }

    return NULL;
}

void relocate(object_file_t* tu, uint64_t count) {
    for (uint64_t i = 0; i < count; i++) {
        object_file_t* obj = &tu[i];

        for (uint32_t j = 0; j < obj->code.symbols_size; j++) {
            symbol_t* sym = &obj->code.symbols[j];
            if ((sym->sym_addr & 0x8000000000000000) == 0) {
                sym->sym_addr += (uint64_t) obj->code.data;
            }
        }
    }

    for (uint64_t i = 0; i < count; i++) {
        object_file_t* obj = &tu[i];

        for (uint32_t j = 0; j < obj->code.symbols_size; j++) {
            symbol_t* sym = &obj->code.symbols[j];
            if (sym->sym_addr & 0x8000000000000000) {
                sym->sym_addr = (uint64_t) find_symbol(sym->name, tu, count);
            }
        }
    }

    for (uint64_t i = 0; i < count; i++) {
        object_file_t* obj = &tu[i];
        for (uint64_t j = 0; j < obj->load_command.size; j++) {
            offset_t* off = &obj->load_command.data[j];
            if (!off->is_instr_addr) {
                uint64_t* ptr = (uint64_t*) (obj->code.data + off->offset);
                *ptr = (uint64_t) obj->code.symbols[off->symbol].sym_addr;
            } else {
                opcode_t* opcode = (opcode_t*) (obj->code.data + off->offset);
                uint64_t current_addr = (uint64_t) (obj->code.data + off->offset) + sizeof(opcode_t);
                switch (opcode->opcode) {
                    case opcode_b_addr:
                    case opcode_bl_addr:
                    case opcode_psh_addr: {
                        symbol_t* sym = &obj->code.symbols[opcode->args.args_raw];
                        uint64_t target_addr = (uint64_t) find_symbol(sym->name, tu, count);
                        if (target_addr) {
                            int32_t offset = (int32_t) (target_addr - current_addr);
                            if (offset & 0x3) {
                                fprintf(stderr, "Address is not aligned to 4 bytes\n");
                                exit(1);
                            }
                            offset = offset / sizeof(opcode_t);
                            if (offset > 0x7FFFFF || offset < -0x800000) {
                                fprintf(stderr, "Symbol '%s' is too far away (0x%08x)\n", sym->name, offset);
                                exit(1);
                            }
                            opcode->args.args_raw = offset;
                        } else {
                            fprintf(stderr, "Could not find symbol '%s'\n", sym->name);
                            exit(1);
                        }
                        break;
                    }
                    case opcode_adrp_reg_addr: {
                        symbol_t* sym = &obj->code.symbols[off->symbol];
                        uint64_t target_addr = (uint64_t) find_symbol(sym->name, tu, count);
                        if (target_addr) {
                            int32_t offset = (int32_t) (target_addr - current_addr) / sizeof(opcode_t);
                            opcode->args.ri.imm = (offset >> 16) & 0xFFFF;
                        } else {
                            fprintf(stderr, "Could not find symbol '%s'\n", sym->name);
                            exit(1);
                        }
                        break;
                    }
                    case opcode_adp_reg_addr: {
                        symbol_t* sym = &obj->code.symbols[off->symbol];
                        uint64_t target_addr = (uint64_t) find_symbol(sym->name, tu, count);
                        if (target_addr) {
                            int32_t offset = (int32_t) (target_addr - current_addr) / sizeof(opcode_t);
                            opcode->args.ri.imm = (offset + 1) & 0xFFFF;
                        } else {
                            fprintf(stderr, "Could not find symbol '%s'\n", sym->name);
                            exit(1);
                        }
                        break;
                    }

                    default:
                        printf("Unknown opcode 0x%08x for relocation at %p\n", *(uint32_t*) opcode, opcode);
                        exit(1);
                }
            }
        }
    }
}

int main(int argc, char **argv) {
    static struct sigaction act = {
		.sa_sigaction = (void(*)(int, siginfo_t*, void*)) sig_handler,
		.sa_flags = SA_SIGINFO,
		.sa_mask = sigmask(SIGINT) | sigmask(SIGILL) | sigmask(SIGTRAP) | sigmask(SIGABRT) | sigmask(SIGBUS) | sigmask(SIGSEGV)
	};
	#define SIGACTION(_sig) if (sigaction(_sig, &act, NULL) == -1) { fprintf(stderr, "Failed to set up signal handler\n"); fprintf(stderr, "Error: %s (%d)\n", strerror(errno), errno); }
    SIGACTION(SIGINT);
    SIGACTION(SIGILL);
    SIGACTION(SIGTRAP);
    SIGACTION(SIGABRT);
    SIGACTION(SIGBUS);
    SIGACTION(SIGSEGV);
    SIGACTION(SIGFPE);
    SIGACTION(SIGINT);

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
        
        object_file_t tu = create_translation_unit();
        section_t obj = run_compile(argv[2]);
        
        for (uint64_t i = 0; i < obj.contents_size; i++) {
            compile_bytes_or_instr(&obj, obj.contents[i]);
        }

        tu.load_command.size = obj.symbol_relocs_size + obj.instr_addr_offsets_size;
        tu.load_command.data = malloc(tu.load_command.size * sizeof(offset_t));

        for (uint64_t i = 0; i < obj.symbol_relocs_size; i++) {
            offset_t* off = &tu.load_command.data[i];
            
            off->is_instr_addr = 0;
            off->offset = obj.symbol_relocs[i];
            
            uint64_t* ptr = (uint64_t*) (obj.data + off->offset);
            uint64_t symIndex = *ptr;

            off->symbol = symIndex;
        }
        for (uint64_t i = 0; i < obj.instr_addr_offsets_size; i++) {
            tu.load_command.data[i + obj.symbol_relocs_size] = obj.instr_addr_offsets[i];
        }

        tu.code = obj;

        FILE* f = fopen(argv[3], "wb");
        write_translation_unit(&tu, f);
        fclose(f);
        return 0;
    } else if (strcmp(argv[1], "run") == 0) {
        
        FILE* f = fopen(argv[2], "rb");
        FILE* supervisor = fopen("supervisor.rcx", "rb");
        if (!f) {
            fprintf(stderr, "Could not open file '%s'\n", argv[2]);
            return 1;
        }
        if (!supervisor) {
            fprintf(stderr, "Could not open supervisor file\n");
            return 1;
        }
        object_file_t objects[] = {
            read_translation_unit(supervisor),
            read_translation_unit(f),
        };
        fclose(supervisor);
        fclose(f);
        supervisor = NULL;
        f = NULL;

        relocate(objects, 2);
        
        hive_register_t register_file[64] = {0}; // r0 - r31, LR, SP, PC, FR, cr0 - cr11, zero, one
        registers = register_file;
        PC = find_symbol("_start", objects, 2);
        ZERO = 0;
        ONE = 0xFFFFFFFFFFFFFFFF;
        ADDR_MODE = 4;

        if (PC) {
            char stack[1024][1024];
            SP = (void**) stack;
            exec(register_file);
            return R0;
        }
        
        fprintf(stderr, "Could not find _start symbol\n");
        return 1;
    } else {
        fprintf(stderr, "Unknown command '%s'\n", argv[1]);
        return 1;
    }
}
