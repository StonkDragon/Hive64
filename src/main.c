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

void** svc_table = NULL;

#define pc (registers[27].asPointer)
#define lr (registers[28].asPointer)
#define sp (registers[29].asPointerPointer)
#define bp (registers[30].asPointerPointer)
#define flags (registers[31].bytes[0])

#define FLAG_ZERO       0b00000001
#define FLAG_NEGATIVE   0b00000010
#define FLAG_GREATER    0b00000100
#define FLAG_LESS       0b00001000
#define FLAG_EQUAL      0b00010000

static uint8_t bios[] = {
    0xce, 0xfa, 0xed, 0xfe, 0x01, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 
    0x02, 0x00, 0x00, 0x00, 0x52, 0x45, 0x4c, 0x4f, 
    0x43, 0x41, 0x54, 0x45, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0xa0, 0x00, 0x00, 0x00, 
    0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x1e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x14, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0xd8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 
    0x1e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x5e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x26, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x64, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x2e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0xd2, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x36, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0xd4, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x3e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0xd6, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x83, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0xbe, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x97, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0xbe, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0xb6, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x7e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x01, 0x00, 0x17, 0x00, 0xd8, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x02, 0x30, 0x01, 0x00, 
    0x00, 0x02, 0x90, 0x01, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x01, 0x20, 0x00, 0x22, 0x80, 
    0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x01, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x02, 0x20, 0x00, 0x01, 0x01, 0x00, 
    0x11, 0x10, 0x00, 0x11, 0x10, 0x01, 0x11, 0x10, 
    0x0f, 0x11, 0x10, 0x10, 0x11, 0x10, 0x11, 0x11, 
    0x10, 0x03, 0x02, 0x20, 0x0f, 0x02, 0x02, 0x20, 
    0x11, 0x01, 0x05, 0x10, 0x03, 0x0e, 0x80, 0x05, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x21, 
    0x50, 0x00, 0x00, 0x10, 0x01, 0x0f, 0x05, 0x10, 
    0x10, 0x0e, 0x80, 0x05, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x02, 0x30, 0x0e, 0x00, 0x00, 
    0x02, 0x20, 0x01, 0x10, 0x02, 0x20, 0x02, 0x11, 
    0x20, 0x00, 0x1e, 0x10, 0x0f, 0x1f, 0x10, 0x03, 
    0x06, 0x80, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x12, 0x10, 0x03, 0x12, 0x10, 0x11, 
    0x12, 0x10, 0x10, 0x12, 0x10, 0x0f, 0x12, 0x10, 
    0x01, 0x12, 0x10, 0x00, 0x10, 0x00, 0x10, 0x00, 
    0x10, 0x00, 0x10, 0x00, 0x02, 0x00, 0x21, 0x00, 
    0x30, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x0a, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x5f, 0x73, 0x74, 0x61, 0x72, 0x74, 0x00, 0x1e, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x73, 
    0x79, 0x73, 0x63, 0x61, 0x6c, 0x6c, 0x2e, 0x62, 
    0x72, 0x61, 0x6e, 0x63, 0x68, 0x74, 0x61, 0x62, 
    0x6c, 0x65, 0x00, 0x5e, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x73, 0x79, 0x73, 0x63, 0x61, 
    0x6c, 0x6c, 0x2e, 0x65, 0x78, 0x69, 0x74, 0x00, 
    0x64, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x73, 0x79, 0x73, 0x63, 0x61, 0x6c, 0x6c, 0x2e, 
    0x77, 0x72, 0x69, 0x74, 0x65, 0x00, 0x7e, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x73, 0x79, 
    0x73, 0x63, 0x61, 0x6c, 0x6c, 0x2e, 0x77, 0x72, 
    0x69, 0x74, 0x65, 0x5f, 0x6c, 0x6f, 0x6f, 0x70, 
    0x00, 0xbe, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x73, 0x79, 0x73, 0x63, 0x61, 0x6c, 0x6c, 
    0x2e, 0x77, 0x72, 0x69, 0x74, 0x65, 0x5f, 0x65, 
    0x6e, 0x64, 0x00, 0xd2, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x73, 0x79, 0x73, 0x63, 0x61, 
    0x6c, 0x6c, 0x2e, 0x72, 0x65, 0x61, 0x64, 0x00, 
    0xd4, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x73, 0x79, 0x73, 0x63, 0x61, 0x6c, 0x6c, 0x2e, 
    0x6f, 0x70, 0x65, 0x6e, 0x00, 0xd6, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x73, 0x79, 0x73, 
    0x63, 0x61, 0x6c, 0x6c, 0x2e, 0x63, 0x6c, 0x6f, 
    0x73, 0x65, 0x00, 0xd8, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x6d, 0x61, 0x69, 0x6e, 0x00
};

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

typedef void (*opc_func)(hive_register_t[32], void* args);

#pragma region EXEC

#undef OPC
#undef OPC_ENDFUNC
#undef OPC_FUNC


#define ARG(_value)                 (*(typeof(((args_t*) 0) -> _value)*) ((args + hive_offsetof(args_t, _value))))
#define OPC_DEF(_nargs, _opcode)    static void _opcode ## $ ## _nargs(hive_register_t registers[32], void* args)
#define CAT_(a, b)                  a ## b
#define CAT(a, b)                   CAT_(a, b)
#define OPC(_nargs, _opcode)        [_opcode] = _opcode ## $ ## _nargs
#define OPC_ENDFUNC                 }
#define NBYTES_TO_BITMASK(_nbytes)  ((1ULL << (_nbytes * 8)) - 1)
#define OPC_FUNC(_n)                opc_func opc_ ## _n[1 << 12] = {

OPC_DEF(0, opcode_nop) {}
OPC_DEF(0, opcode_halt) { exit(registers[0].asInteger); }
OPC_DEF(0, opcode_pshi) { *(sp++) = pc; }
OPC_DEF(0, opcode_ret) {
    pc = (void*) lr;
    lr = *(--sp);
}
OPC_DEF(0, opcode_irq) {
    switch (registers[0].asInteger) {
    case 0x01: { // set up svc table
        svc_table = registers[1].asPointer;
        break;
    }
    case 0x03: { // request memory
        registers[0].asPointer = malloc(registers[1].asInteger);
        break;
    }

    case 0x0e: { // print char in r1 to r2
        char c[2] = { registers[1].asInteger, '\0' };
        write(registers[2].asInteger, c, 1);
        break;
    }
    
    default:
        break;
    }
}
OPC_DEF(0, opcode_svc) {
    *(sp++) = lr;
    lr = pc;
    pc = (void*) svc_table[registers[0].asInteger];
}

OPC_DEF(1, opcode_cmpz) {
    if (registers[ARG(reg.reg1)].asInteger == 0) {
        flags |= FLAG_ZERO;
    } else {
        flags &= ~FLAG_ZERO;
    }
}
OPC_DEF(1, opcode_b) {
    pc = (void*) registers[ARG(reg.reg1)].asPointer;
}
OPC_DEF(1, opcode_bne) {
    if (!(flags & FLAG_EQUAL)) {
        pc = (void*) registers[ARG(reg.reg1)].asPointer;
    }
}
OPC_DEF(1, opcode_beq) {
    if (flags & FLAG_EQUAL) {
        pc = (void*) registers[ARG(reg.reg1)].asPointer;
    }
}
OPC_DEF(1, opcode_bgt) {
    if (flags & FLAG_GREATER) {
        pc = (void*) registers[ARG(reg.reg1)].asPointer;
    }
}
OPC_DEF(1, opcode_blt) {
    if (flags & FLAG_LESS) {
        pc = (void*) registers[ARG(reg.reg1)].asPointer;
    }
}
OPC_DEF(1, opcode_bge) {
    if (flags & (FLAG_GREATER | FLAG_EQUAL)) {
        pc = (void*) registers[ARG(reg.reg1)].asPointer;
    }
}
OPC_DEF(1, opcode_ble) {
    if (flags & (FLAG_LESS | FLAG_EQUAL)) {
        pc = (void*) registers[ARG(reg.reg1)].asPointer;
    }
}
OPC_DEF(1, opcode_bnz) {
    if (!(flags & FLAG_ZERO)) {
        pc = (void*) registers[ARG(reg.reg1)].asPointer;
    }
}
OPC_DEF(1, opcode_bz) {
    if (flags & FLAG_ZERO) {
        pc = (void*) registers[ARG(reg.reg1)].asPointer;
    }
}
OPC_DEF(1, opcode_bl) {
    *(sp++) = lr;
    lr = pc;
    opcode_b$1(registers, args);
}
OPC_DEF(1, opcode_blne) {
    *(sp++) = lr;
    lr = pc;
    opcode_bne$1(registers, args);
}
OPC_DEF(1, opcode_bleq) {
    *(sp++) = lr;
    lr = pc;
    opcode_beq$1(registers, args);
}
OPC_DEF(1, opcode_blgt) {
    *(sp++) = lr;
    lr = pc;
    opcode_bgt$1(registers, args);
}
OPC_DEF(1, opcode_bllt) {
    *(sp++) = lr;
    lr = pc;
    opcode_blt$1(registers, args);
}
OPC_DEF(1, opcode_blge) {
    *(sp++) = lr;
    lr = pc;
    opcode_bge$1(registers, args);
}
OPC_DEF(1, opcode_blle) {
    *(sp++) = lr;
    lr = pc;
    opcode_ble$1(registers, args);
}
OPC_DEF(1, opcode_blnz) {
    *(sp++) = lr;
    lr = pc;
    opcode_bnz$1(registers, args);
}
OPC_DEF(1, opcode_blz) {
    *(sp++) = lr;
    lr = pc;
    opcode_bz$1(registers, args);
}
OPC_DEF(1, opcode_psh) {
    *(sp++) = registers[ARG(reg.reg1)].asPointer;
}
OPC_DEF(1, opcode_pp) {
    registers[ARG(reg.reg1)].asPointer = *(--sp);
}
OPC_DEF(1, opcode_not) {
    registers[ARG(reg.reg1)].asInteger = ~registers[ARG(reg.reg1)].asInteger;
}
OPC_DEF(1, opcode_inc) {
    registers[ARG(reg.reg1)].asInteger++;
}
OPC_DEF(1, opcode_dec) {
    registers[ARG(reg.reg1)].asInteger--;
}
#define ARITH_X_REG(_op, _what) \
OPC_DEF(1, opcode_ ## _op) { \
    registers[0].asInteger _what ## = registers[ARG(reg.reg1)].asInteger; \
}
ARITH_X_REG(add, +)
ARITH_X_REG(sub, -)
ARITH_X_REG(mul, *)
ARITH_X_REG(div, /)
ARITH_X_REG(mod, %)
ARITH_X_REG(and, &)
ARITH_X_REG(or, |)
ARITH_X_REG(xor, ^)
ARITH_X_REG(shl, <<)
ARITH_X_REG(shr, >>)

OPC_DEF(2, opcode_ldr) {
    registers[*(uint8_t*) ((args + hive_offsetof(args_t, reg_reg.reg1)))].asInteger = registers[*(uint8_t*) ((args + hive_offsetof(args_t, reg_reg.reg2)))].asInteger;
}
OPC_DEF(2, opcode_str) {
    *(uint64_t*) (registers[*(uint8_t*) ((args + hive_offsetof(args_t, reg_reg.reg1)))].asPointer) = registers[*(uint8_t*) ((args + hive_offsetof(args_t, reg_reg.reg2)))].asInteger;
}
OPC_DEF(2, opcode_cmp) {
    uint64_t a = registers[*(uint8_t*) ((args + hive_offsetof(args_t, reg_reg.reg1)))].asInteger;
    uint64_t b = registers[*(uint8_t*) ((args + hive_offsetof(args_t, reg_reg.reg2)))].asInteger;
    int64_t as = (int64_t) a;
    int64_t bs = (int64_t) b;
    flags = 0;
    if (a == b) {
        flags |= FLAG_EQUAL;
    } else if (as > bs) {
        flags |= FLAG_GREATER;
    } else if (as < bs) {
        flags |= FLAG_LESS;
    }
    if (a == 0) {
        flags |= FLAG_ZERO;
    }
    if (as < 0) {
        flags |= FLAG_NEGATIVE;
    }
}
OPC_DEF(2, opcode_psh) {
    *(sp++) = (void*) ((uint64_t) (*(uint16_t*) pc));
}
#define ARITH_REG_REG(_op, _what) \
OPC_DEF(2, opcode_ ## _op) { \
    registers[ARG(reg.reg1)].asInteger _what ## = registers[*(uint8_t*) ((args + hive_offsetof(args_t, reg_reg.reg2)))].asInteger; \
}
ARITH_REG_REG(add, +)
ARITH_REG_REG(sub, -)
ARITH_REG_REG(mul, *)
ARITH_REG_REG(div, /)
ARITH_REG_REG(mod, %)
ARITH_REG_REG(and, &)
ARITH_REG_REG(or, |)
ARITH_REG_REG(xor, ^)
ARITH_REG_REG(shl, <<)
ARITH_REG_REG(shr, >>)

OPC_DEF(3, opcode_ldr) {
    registers[ARG(reg_imm16.reg1)].asInteger = ARG(reg_imm16.imm);
}
OPC_DEF(3, opcode_str) {
    *(uint64_t*) (registers[ARG(reg_imm16.reg1)].asPointer) = ARG(reg_imm16.imm);
}
OPC_DEF(3, opcode_cmp) {
    uint64_t a = registers[ARG(reg_imm16.reg1)].asInteger;
    uint64_t b = ARG(reg_imm16.imm);
    int64_t as = (int64_t) a;
    int64_t bs = (int64_t) b;
    flags = 0;
    if (a == b) {
        flags |= FLAG_EQUAL;
    } else if (as > bs) {
        flags |= FLAG_GREATER;
    } else if (as < bs) {
        flags |= FLAG_LESS;
    }
    if (a == 0) {
        flags |= FLAG_ZERO;
    }
    if (as < 0) {
        flags |= FLAG_NEGATIVE;
    }
}

#define ARITH_REG_IMM(_op, _what) \
OPC_DEF(3, opcode_ ## _op) { \
    registers[ARG(reg_imm16.reg1)].asInteger _what ## = ARG(reg_imm16.imm); \
}

ARITH_REG_IMM(add, +)
ARITH_REG_IMM(sub, -)
ARITH_REG_IMM(mul, *)
ARITH_REG_IMM(div, /)
ARITH_REG_IMM(mod, %)
ARITH_REG_IMM(and, &)
ARITH_REG_IMM(or, |)
ARITH_REG_IMM(xor, ^)
ARITH_REG_IMM(shl, <<)
ARITH_REG_IMM(shr, >>)


OPC_DEF(4, opcode_ldr) {
    registers[ARG(reg_reg_offset.reg1)].asInteger = *(uint64_t*) (registers[ARG(reg_reg_offset.reg2)].asPointer + ARG(reg_reg_offset.offset));
}
OPC_DEF(4, opcode_mov) {
    uint8_t* srcPtr = (uint8_t*) registers[ARG(mov_reg_n_reg_offset_reg.reg2)].asPointer + registers[ARG(mov_reg_n_reg_offset_reg.reg2_offset_reg)].asSignedInteger;
    for (int i = 0; i < ARG(mov_reg_n_reg_offset_reg.nbytes); i++) {
        registers[ARG(mov_reg_n_reg_offset_reg.reg1)].asInteger |= (uint64_t) (srcPtr[i] << (i * 8));
    }
}

OPC_DEF(5, opcode_mov) {
    uint8_t* ptr = registers[ARG(mov_reg_n_reg_offset.reg2)].asPointer + ARG(mov_reg_n_reg_offset.offset);
    registers[ARG(mov_reg_n_reg_offset.reg1)].asInteger = (*ptr) & NBYTES_TO_BITMASK(ARG(mov_reg_n_reg_offset.nbytes));
}
#define ARITH_REG_MEM(_op, _what) \
OPC_DEF(5, opcode_ ## _op) { \
    uint8_t* ptr = registers[ARG(mov_reg_n_reg_offset.reg2)].asPointer + ARG(mov_reg_n_reg_offset.offset); \
    uint64_t value = (*ptr) & NBYTES_TO_BITMASK(ARG(mov_reg_n_reg_offset.nbytes)); \
    registers[ARG(mov_reg_n_reg_offset.reg1)].asInteger _what ## = value; \
}

ARITH_REG_MEM(add, +)
ARITH_REG_MEM(sub, -)
ARITH_REG_MEM(mul, *)
ARITH_REG_MEM(div, /)
ARITH_REG_MEM(mod, %)
ARITH_REG_MEM(and, &)
ARITH_REG_MEM(or, |)
ARITH_REG_MEM(xor, ^)
ARITH_REG_MEM(shl, <<)
ARITH_REG_MEM(shr, >>)

#undef ARITH_REG_MEM

OPC_DEF(8, opcode_psh) {
    *(sp++) = (void*) ARG(imm64.imm);
}
OPC_DEF(8, opcode_mov) {
    uint64_t* ptr = (uint64_t*) (ARG(mov_reg_n_reg_offset_reg_offset_offset.addr) + ARG(mov_reg_n_reg_offset_reg_offset_offset.offset_offset));
    registers[ARG(mov_reg_n_reg_offset_reg_offset_offset.reg1)].asInteger = (*ptr) & NBYTES_TO_BITMASK(ARG(mov_reg_n_reg_offset_reg_offset_offset.nbytes));
}

OPC_DEF(8, opcode_b) {
    pc = (void*) ARG(offset.addr);
}
OPC_DEF(8, opcode_bne) {
    if (!(flags & FLAG_EQUAL)) {
        pc = (void*) ARG(offset.addr);
    }
}
OPC_DEF(8, opcode_beq) {
    if (flags & FLAG_EQUAL) {
        pc = (void*) ARG(offset.addr);
    }
}
OPC_DEF(8, opcode_bgt) {
    if (flags & FLAG_GREATER) {
        pc = (void*) ARG(offset.addr);
    }
}
OPC_DEF(8, opcode_blt) {
    if (flags & FLAG_LESS) {
        pc = (void*) ARG(offset.addr);
    }
}
OPC_DEF(8, opcode_bge) {
    if (flags & (FLAG_GREATER | FLAG_EQUAL)) {
        pc = (void*) ARG(offset.addr);
    }
}
OPC_DEF(8, opcode_ble) {
    if (flags & (FLAG_LESS | FLAG_EQUAL)) {
        pc = (void*) ARG(offset.addr);
    }
}
OPC_DEF(8, opcode_bnz) {
    if (!(flags & FLAG_ZERO)) {
        pc = (void*) ARG(offset.addr);
    }
}
OPC_DEF(8, opcode_bz) {
    if (flags & FLAG_ZERO) {
        pc = (void*) ARG(offset.addr);
    }
}
OPC_DEF(8, opcode_bl) {
    *(sp++) = lr;
    lr = pc;
    opcode_b$8(registers, args);
}
OPC_DEF(8, opcode_blne) {
    *(sp++) = lr;
    lr = pc;
    opcode_bne$8(registers, args);
}
OPC_DEF(8, opcode_bleq) {
    *(sp++) = lr;
    lr = pc;
    opcode_beq$8(registers, args);
}
OPC_DEF(8, opcode_blgt) {
    *(sp++) = lr;
    lr = pc;
    opcode_bgt$8(registers, args);
}
OPC_DEF(8, opcode_bllt) {
    *(sp++) = lr;
    lr = pc;
    opcode_blt$8(registers, args);
}
OPC_DEF(8, opcode_blge) {
    *(sp++) = lr;
    lr = pc;
    opcode_bge$8(registers, args);
}
OPC_DEF(8, opcode_blle) {
    *(sp++) = lr;
    lr = pc;
    opcode_ble$8(registers, args);
}
OPC_DEF(8, opcode_blnz) {
    *(sp++) = lr;
    lr = pc;
    opcode_bnz$8(registers, args);
}
OPC_DEF(8, opcode_blz) {
    *(sp++) = lr;
    lr = pc;
    opcode_bz$8(registers, args);
}
OPC_DEF(8, opcode_pp) {
    *((uint64_t*) ARG(offset.addr)) = *(uint64_t*) (--sp);
}

OPC_DEF(9, opcode_ldr) {
    uint64_t ptr = ARG(reg_imm64.imm);
    uint8_t reg = ARG(reg_imm64.reg1);
    registers[reg].asInteger = ptr;
}
OPC_DEF(9, opcode_str) {
    *(uint64_t*) (registers[ARG(reg_imm64.reg1)].asPointer) = ARG(reg_imm64.imm);
}
OPC_DEF(9, opcode_cmp) {
    uint64_t a = registers[ARG(reg_imm64.reg1)].asInteger;
    uint64_t b = ARG(reg_imm64.imm);
    int64_t as = (int64_t) a;
    int64_t bs = (int64_t) b;
    flags = 0;
    if (a == b) {
        flags |= FLAG_EQUAL;
    } else if (as > bs) {
        flags |= FLAG_GREATER;
    } else if (as < bs) {
        flags |= FLAG_LESS;
    }
    if (a == 0) {
        flags |= FLAG_ZERO;
    }
    if (as < 0) {
        flags |= FLAG_NEGATIVE;
    }
}
#define ARITH_REG_IMM64(_op, _what) \
OPC_DEF(9, opcode_ ## _op) { \
    registers[ARG(reg_imm64.reg1)].asInteger _what ## = ARG(reg_imm64.imm); \
}

ARITH_REG_IMM64(add, +)
ARITH_REG_IMM64(sub, -)
ARITH_REG_IMM64(mul, *)
ARITH_REG_IMM64(div, /)
ARITH_REG_IMM64(mod, %)
ARITH_REG_IMM64(and, &)
ARITH_REG_IMM64(or, |)
ARITH_REG_IMM64(xor, ^)
ARITH_REG_IMM64(shl, <<)
ARITH_REG_IMM64(shr, >>)

#undef ARITH_REG_IMM64

OPC_DEF(10, opcode_ldr) {
    registers[ARG(reg_offset_reg.reg1)].asInteger = *((uint64_t*) ARG(reg_offset_reg.addr) + registers[ARG(reg_offset_reg.reg2)].asSignedInteger);
}

OPC_DEF(11, opcode_ldr) {
    registers[ARG(reg_offset_imm.reg1)].asInteger = *((uint64_t*) ARG(reg_offset_imm.addr) + ARG(reg_offset_imm.imm_off));
}
OPC_DEF(11, opcode_mov) {
    uint64_t* ptr = (uint64_t*) ARG(mov_reg_n_reg_offset_reg_offset.addr) + registers[ARG(mov_reg_n_reg_offset_reg_offset.reg2)].asSignedInteger;
    uint64_t value = (*ptr) & NBYTES_TO_BITMASK(ARG(mov_reg_n_reg_offset_reg_offset.nbytes));
    registers[ARG(mov_reg_n_reg_offset_reg_offset.reg1)].asInteger = value;
}
#define ARITH_REG_SYM(_op, _what) \
OPC_DEF(11, opcode_ ## _op) { \
    uint64_t* ptr = (uint64_t*) ARG(mov_reg_n_reg_offset_reg_offset.addr) + registers[ARG(mov_reg_n_reg_offset_reg_offset.reg2)].asSignedInteger; \
    uint64_t value = (*ptr) & NBYTES_TO_BITMASK(ARG(mov_reg_n_reg_offset_reg_offset.nbytes)); \
    registers[ARG(mov_reg_n_reg_offset_reg_offset.reg1)].asInteger _what ## = value; \
}

ARITH_REG_SYM(add, +)
ARITH_REG_SYM(sub, -)
ARITH_REG_SYM(mul, *)
ARITH_REG_SYM(div, /)
ARITH_REG_SYM(mod, %)
ARITH_REG_SYM(and, &)
ARITH_REG_SYM(or, |)
ARITH_REG_SYM(xor, ^)
ARITH_REG_SYM(shl, <<)
ARITH_REG_SYM(shr, >>)

#undef ARITH_REG_SYM

#define ARITH_REG_ADDR_OFF(_op, _what) \
OPC_DEF(12, opcode_ ## _op) { \
    uint64_t* ptr = (uint64_t*) (ARG(mov_reg_n_reg_offset_reg_offset_offset.addr) + ARG(mov_reg_n_reg_offset_reg_offset_offset.offset_offset)); \
    uint64_t value = (*ptr) & NBYTES_TO_BITMASK(ARG(mov_reg_n_reg_offset_reg_offset_offset.nbytes)); \
    registers[ARG(mov_reg_n_reg_offset_reg_offset_offset.reg1)].asInteger _what ## = value; \
}

ARITH_REG_ADDR_OFF(add, +)
ARITH_REG_ADDR_OFF(sub, -)
ARITH_REG_ADDR_OFF(mul, *)
ARITH_REG_ADDR_OFF(div, /)
ARITH_REG_ADDR_OFF(mod, %)
ARITH_REG_ADDR_OFF(and, &)
ARITH_REG_ADDR_OFF(or, |)
ARITH_REG_ADDR_OFF(xor, ^)
ARITH_REG_ADDR_OFF(shl, <<)
ARITH_REG_ADDR_OFF(shr, >>)

#undef ARITH_REG_ADDR_OFF

OPC_FUNC(0)
    OPC(0, opcode_nop),
    OPC(0, opcode_halt),
    OPC(0, opcode_pshi),
    OPC(0, opcode_ret),
    OPC(0, opcode_irq),
    OPC(0, opcode_svc),
OPC_ENDFUNC;
OPC_FUNC(1)
    OPC(1, opcode_cmpz),
    OPC(1, opcode_b),
    OPC(1, opcode_bne),
    OPC(1, opcode_beq),
    OPC(1, opcode_bgt),
    OPC(1, opcode_blt),
    OPC(1, opcode_bge),
    OPC(1, opcode_ble),
    OPC(1, opcode_bnz),
    OPC(1, opcode_bz),
    OPC(1, opcode_psh),
    OPC(1, opcode_pp),
    OPC(1, opcode_not),
    OPC(1, opcode_inc),
    OPC(1, opcode_dec),
    OPC(1, opcode_bl),
    OPC(1, opcode_blne),
    OPC(1, opcode_bleq),
    OPC(1, opcode_blgt),
    OPC(1, opcode_bllt),
    OPC(1, opcode_blge),
    OPC(1, opcode_blle),
    OPC(1, opcode_blnz),
    OPC(1, opcode_blz),
OPC_ENDFUNC;
OPC_FUNC(2)
    OPC(2, opcode_ldr),
    OPC(2, opcode_str),
    OPC(2, opcode_cmp),
    OPC(2, opcode_psh),
    OPC(2, opcode_add),
    OPC(2, opcode_sub),
    OPC(2, opcode_mul),
    OPC(2, opcode_div),
    OPC(2, opcode_mod),
    OPC(2, opcode_and),
    OPC(2, opcode_or),
    OPC(2, opcode_xor),
    OPC(2, opcode_shl),
    OPC(2, opcode_shr),
OPC_ENDFUNC;
OPC_FUNC(3)
    OPC(3, opcode_ldr),
    OPC(3, opcode_str),
    OPC(3, opcode_cmp),
    OPC(3, opcode_add),
    OPC(3, opcode_sub),
    OPC(3, opcode_mul),
    OPC(3, opcode_div),
    OPC(3, opcode_mod),
    OPC(3, opcode_and),
    OPC(3, opcode_or),
    OPC(3, opcode_xor),
    OPC(3, opcode_shl),
    OPC(3, opcode_shr),
OPC_ENDFUNC;
OPC_FUNC(4)
    OPC(4, opcode_ldr),
    OPC(4, opcode_mov),
OPC_ENDFUNC;
OPC_FUNC(5)
    OPC(5, opcode_mov),
    OPC(5, opcode_add),
    OPC(5, opcode_sub),
    OPC(5, opcode_mul),
    OPC(5, opcode_div),
    OPC(5, opcode_mod),
    OPC(5, opcode_and),
    OPC(5, opcode_or),
    OPC(5, opcode_xor),
    OPC(5, opcode_shl),
    OPC(5, opcode_shr),
OPC_ENDFUNC;
OPC_FUNC(6)
OPC_ENDFUNC;
OPC_FUNC(7)
OPC_ENDFUNC;
OPC_FUNC(8)
    OPC(8, opcode_psh),
    OPC(8, opcode_mov),
    OPC(8, opcode_b),
    OPC(8, opcode_bne),
    OPC(8, opcode_beq),
    OPC(8, opcode_bgt),
    OPC(8, opcode_blt),
    OPC(8, opcode_bge),
    OPC(8, opcode_ble),
    OPC(8, opcode_bnz),
    OPC(8, opcode_bz),
    OPC(8, opcode_pp),
    OPC(8, opcode_bl),
    OPC(8, opcode_blne),
    OPC(8, opcode_bleq),
    OPC(8, opcode_blgt),
    OPC(8, opcode_bllt),
    OPC(8, opcode_blge),
    OPC(8, opcode_blle),
    OPC(8, opcode_blnz),
    OPC(8, opcode_blz),
OPC_ENDFUNC;
OPC_FUNC(9)
    OPC(9, opcode_ldr),
    OPC(9, opcode_str),
    OPC(9, opcode_cmp),
    OPC(9, opcode_add),
    OPC(9, opcode_sub),
    OPC(9, opcode_mul),
    OPC(9, opcode_div),
    OPC(9, opcode_mod),
    OPC(9, opcode_and),
    OPC(9, opcode_or),
    OPC(9, opcode_xor),
    OPC(9, opcode_shl),
    OPC(9, opcode_shr),
OPC_ENDFUNC;
OPC_FUNC(10)
    OPC(10, opcode_ldr),
OPC_ENDFUNC;
OPC_FUNC(11)
    OPC(11, opcode_ldr),
    OPC(11, opcode_mov),
    OPC(11, opcode_add),
    OPC(11, opcode_sub),
    OPC(11, opcode_mul),
    OPC(11, opcode_div),
    OPC(11, opcode_mod),
    OPC(11, opcode_and),
    OPC(11, opcode_or),
    OPC(11, opcode_xor),
    OPC(11, opcode_shl),
    OPC(11, opcode_shr),
OPC_ENDFUNC;
OPC_FUNC(12)
    OPC(12, opcode_add),
    OPC(12, opcode_sub),
    OPC(12, opcode_mul),
    OPC(12, opcode_div),
    OPC(12, opcode_mod),
    OPC(12, opcode_and),
    OPC(12, opcode_or),
    OPC(12, opcode_xor),
    OPC(12, opcode_shl),
    OPC(12, opcode_shr),
OPC_ENDFUNC;
OPC_FUNC(13)
OPC_ENDFUNC;
OPC_FUNC(14)
OPC_ENDFUNC;
OPC_FUNC(15)
OPC_ENDFUNC;

#pragma endregion

static opc_func* funcs[16] = {
    opc_0,  opc_1,  opc_2,  opc_3,
    opc_4,  opc_5,  opc_6,  opc_7,
    opc_8,  opc_9,  opc_10, opc_11,
    opc_12, opc_13, opc_14, opc_15
};

OS_NOINLINE
void exec(hive_register_t registers[32]) {
    while (1) {
        uint16_t opcode = *(uint16_t*) pc;
        // TODO: make this less ugly
        pc += 2 + (opcode >> 12);
        funcs[opcode >> 12][opcode & 0x0FFF](registers, pc - (opcode >> 12));
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

uint64_t symbol_offset(section_t* obj, const char* name) {
    for (uint32_t i = 0; i < obj->symbols_size; i++) {
        if (strcmp((char*) obj->symbols[i].name, name) == 0) {
            return i;
        }
    }

    add_symbol(obj, (char*) name);
    obj->symbols[obj->symbols_size - 1].sym_addr |= 0x8000000000000000;

    return obj->symbols_size - 1;
}

section_t** run_compile(const char* file_name);

void sig_handler(int sig, siginfo_t* info, void* ucontext) {
    char* string = strsignal(sig);
    fprintf(stderr, "%s at %p\n", string, info->si_addr);
    void* bt[32];
    size_t size = backtrace(bt, 32);
    backtrace_symbols_fd(bt, size, STDERR_FILENO);
    exit(1);
}

void* find_symbol_in(object_file_t* tu, char* sym) {
    section_t** symtab = find_sections(tu, SECTION_TYPE_DATA);
    if (!symtab || !symtab[0]) {
        return NULL;
    }
    symbol_t* symbols = (symbol_t*) symtab[0]->data;
    uint64_t symbols_count = symtab[0]->size / sizeof(symbol_t);

    for (uint64_t i = 0; i < symbols_count; i++) {
        if (strcmp(symbols[i].name, sym) == 0 && ((int64_t) symbols[i].sym_addr) >= 0) {
            return (void*) symbols[i].sym_addr;
        }
    }

    return NULL;
}

void* find_symbol(char* sym, object_file_t* objects, uint64_t count) {
    for (uint64_t i = 0; i < count; i++) {
        void* addr = find_symbol_in(&objects[i], sym);
        if (addr && (((uint64_t) addr) & 0x8000000000000000) == 0) {
            return addr;
        }
    }

    return NULL;
}

void relocate(object_file_t* objects, uint64_t count) {
    for (uint64_t i = 0; i < count; i++) {
        object_file_t* obj = &objects[i];
        section_t** symtab = find_sections(obj, SECTION_TYPE_DATA);
        if (!symtab || !symtab[0]) {
            continue;
        }
        symbol_t* symbols = (symbol_t*) symtab[0]->data;
        uint64_t symbols_count = symtab[0]->size / sizeof(symbol_t);

        for (uint64_t j = 0; j < symbols_count; j++) {
            uint64_t addr = symbols[j].sym_addr;
            if ((addr & 0x8000000000000000)) {
                addr = (uint64_t) find_symbol(symbols[j].name, objects, count);
                if (addr) {
                    symbols[j].sym_addr = addr;
                    continue;
                }
                fprintf(stderr, "Failed to find symbol %s\n", symbols[j].name);
            }
        }

        load_command_t** commands = find_load_commands(obj, "RELOCATE");
        while (*commands) {
            load_command_t* lc = *commands;
            section_t* code_sect = obj->sections[lc->section];
            for (uint64_t i = 0; i < lc->size; i += sizeof(relocation_info_t)) {
                relocation_info_t reloc = *(relocation_info_t*) (lc->data + i);
                uint64_t* ptr = (uint64_t*) (code_sect->data + reloc.offset);
                uint64_t symIndex = *ptr;
                *ptr = (uint64_t) symbols[symIndex].sym_addr;
            }
            commands++;
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
        section_t** objs = run_compile(argv[2]);
        
        symbol_t* symbols = NULL;
        uint64_t symbols_size = 0;
        uint64_t symbols_count = 0;

        size_t index = 0;
        while (objs[index]) {
            section_t* obj = objs[index];
            for (uint64_t i = 0; i < obj->contents_size; i++) {
                compile_bytes_or_instr(obj, obj->contents[i]);
            }
            load_command_t* lc = new_load_command(&tu, "RELOCATE");

            symbols_size += obj->symbols_size;
            symbols = realloc(symbols, sizeof(symbol_t) * symbols_size);

            for (uint64_t i = 0; i < obj->symbols_size; i++) {
                symbols_count++;
                symbols[symbols_count - 1] = obj->symbols[i];
                symbols[symbols_count - 1].section = index;
            }

            lc->size = obj->symbol_relocs_size * sizeof(relocation_info_t);
            lc->data = malloc(lc->size);
            lc->section = tu.sections_count;

            for (uint64_t i = 0; i < obj->symbol_relocs_size; i++) {
                relocation_info_t* reloc = &((relocation_info_t*) lc->data)[i];
                reloc->offset = obj->symbol_relocs[i];
                uint64_t* ptr = (uint64_t*) (obj->data + reloc->offset);
                uint64_t symIndex = *ptr;
                reloc->symbol = obj->symbols[symIndex].sym_addr;
            }

            obj->sect_flags = SECTION_FLAG_EXEC | SECTION_FLAG_READ | SECTION_FLAG_WRITE | SECTION_FLAG_RELOCATE;

            add_section(&tu, obj);

            index++;
        }

        section_t* symtab = new_section(&tu, SECTION_TYPE_DATA, 0, NULL);
        symtab->sect_flags = SECTION_FLAG_SYMBOLS | SECTION_FLAG_READ;

        symtab->data = malloc(8);
        symtab->size = 8;
        uint64_t* symtab_size = (uint64_t*) symtab->data;
        *symtab_size = symbols_count;

        for (uint64_t i = 0; i < symbols_count; i++) {
            size_t len = strlen((char*) symbols[i].name) + 1;
            size_t size = len + (sizeof(symbol_t) - sizeof(char*));
            
            symtab->data = realloc(symtab->data, symtab->size + size);
            
            symbol_t* sym = (symbol_t*) (symtab->data + symtab->size);
            sym->sym_addr = symbols[i].sym_addr;
            sym->section = symbols[i].section;
            strncpy((char*) sym + hive_offsetof(symbol_t, name), symbols[i].name, len);

            symtab->size += size;
        }

        FILE* f = fopen(argv[3], "wb");
        write_translation_unit(&tu, f);
        fclose(f);
        return 0;
    } else if (strcmp(argv[1], "run") == 0) {
        
        FILE* f = fopen(argv[2], "rb");
        if (!f) {
            fprintf(stderr, "Could not open file '%s'\n", argv[2]);
            return 1;
        }
        object_file_t objects[] = {
            read_translation_unit_bytes(bios, sizeof(bios)),
            read_translation_unit(f),
        };
        fclose(f);

        relocate(objects, sizeof(objects) / sizeof(object_file_t));
        
        hive_register_t registers[32];
        memset(registers, 0, sizeof(registers));

        pc = (void*) find_symbol("_start", objects, sizeof(objects) / sizeof(object_file_t));

        if (pc == NULL) {
            fprintf(stderr, "Could not find _start symbol\n");
            return 1;
        }

        char stack[1024][1024];
        bp = sp = (void**) stack;
        exec(registers);
        return registers[0].asInteger;
    } else {
        fprintf(stderr, "Unknown command '%s'\n", argv[1]);
        return 1;
    }
}
