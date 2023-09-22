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
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <ffi/ffi.h>

#include "new_ops.h"

tregister_t registers[37] = {0};

simd_register_t simd_registers[16] = {0};

object_file* read_object_file(char* file) {
    FILE* f = fopen(file, "rb");
    if (f == NULL) {
        fprintf(stderr, "File %s not found.\n", file);
        return NULL;
    }
    fseek(f, 0, SEEK_END);
    int size = ftell(f);
    fseek(f, 0, SEEK_SET);
    
    #define NEXT(type) ({ data += sizeof(type); *((type*) (data - sizeof(type))); })

    object_file* obj = malloc(sizeof(object_file));

    uint8_t* data = malloc(size);
    fread(data, size, 1, f);
    fclose(f);

    obj->magic = NEXT(uint32_t);

    if (obj->magic == 0x0DF0EDFE) {
        fprintf(stderr, "Object file is big endian, this is not supported.\n");
        return NULL;
    }
    if (obj->magic != 0xFEEDF00D) {
        fprintf(stderr, "Invalid magic number: %x\n", obj->magic);
        return NULL;
    }

    obj->data = data;
    obj->data_capacity = obj->data_size = size - sizeof(uint32_t);
    
    return obj;
}

void write_object_file(object_file* obj, char const* file) {
    int errnoNow = errno;
    remove(file);
    errno = errnoNow;

    FILE* f = fopen(file, "ab");
    uint32_t magic = 0xFEEDF00D;
    fwrite(&magic, sizeof(uint32_t), 1, f);
    
    for (uint64_t i = 0; i < obj->contents_size; i++) {
        compile_bytes_or_instr(obj, obj->contents[i]);
    }
    fwrite(obj->data, obj->data_size, 1, f);
    fclose(f);
}

#define irq (registers[32].asInteger)
#define pc (registers[33].asPointer)
#define sp (registers[34].asPointer)
#define bp (registers[35].asPointer)
#define flags (registers[36].asInteger)

#define FLAG_ZERO       0x00000001
#define FLAG_NEGATIVE   0x00000002
#define FLAG_GREATER    0x00000004
#define FLAG_LESS       0x00000008
#define FLAG_EQUAL      0x00000010

void dump_registers(object_file* obj, int dumpToFile) {
    if (!dumpToFile) {
        printf("Registers:\n");
        printf("  PC: 0x%016llx\n", (uint64_t) pc);
        printf("  SP: 0x%016llx\n", (uint64_t) sp);
        printf("  BP: 0x%016llx\n", (uint64_t) bp);
        printf("  Flags: 0x%016llx\n", flags);
        for (int i = 0; i < 32; i++) {
            printf("  r%d: 0x%016llx %f\n", i, registers[i].asInteger, registers[i].asFloat);
        }
        for (int i = 0; i < 16; i++) {
            printf("  xmm%d:\n", i);
            printf("    ");
            for (int j = 0; j < 4; j++) {
                printf("0x%016llx ", simd_registers[i].i64[j]);
            }
            printf("\n");
            printf("    ");
            for (int j = 0; j < 4; j++) {
                printf("%f ", simd_registers[i].f64[j]);
            }
            printf("\n");
        }
    } else {
        remove("memory.dump");
        FILE* f = fopen("memory.dump", "a");
        fprintf(f, "          |.0|.1|.2|.3|.4|.5|.6|.7|.8|.9|.A|.B|.C|.D|.E|.F|\n");
        for (uint64_t addr = 0; addr < obj->data_size; addr += 16) {
            fprintf(f, "0x%08llx|", addr);
            for (int i = 0; i < 16; i++) {
                if (addr + i < obj->data_size) {
                    fprintf(f, "%02x|", obj->data[addr + i]);
                } else {
                    fprintf(f, "  |");
                }
            }
            fprintf(f, "\n");
        }
        fprintf(f, "\n");
        fprintf(f, "Registers:\n");
        fprintf(f, "  PC: 0x%016llx\n", (uint64_t) pc);
        fprintf(f, "  SP: 0x%016llx\n", (uint64_t) sp);
        fprintf(f, "  BP: 0x%016llx\n", (uint64_t) bp);
        fprintf(f, "  Flags: 0x%016llx\n", flags);
        for (int i = 0; i < 32; i++) {
            fprintf(f, "  r%d: 0x%016llx %f\n", i, registers[i].asInteger, registers[i].asFloat);
        }
        for (int i = 0; i < 16; i++) {
            fprintf(f, "  xmm%d:\n", i);
            fprintf(f, "    ");
            for (int j = 0; j < 4; j++) {
                fprintf(f, "0x%016llx ", simd_registers[i].i64[j]);
            }
            fprintf(f, "\n");
            fprintf(f, "    ");
            for (int j = 0; j < 4; j++) {
                fprintf(f, "%f ", simd_registers[i].f64[j]);
            }
            fprintf(f, "\n");
        }
        fprintf(f, "\n");
        fclose(f);
    }
}

void spill() {
    for (int i = 0; i < 32; i++) {
        *(uint64_t*) (sp++) = registers[i].asInteger;
    }
}

void restore() {
    for (int i = 31; i >= 0; i--) {
        registers[i].asInteger = *(uint64_t*) (--sp);
    }
}

__attribute__((always_inline))
static inline uint64_t readUint64(uint8_t* data) {
    uint64_t value = 0;
    value |= ((uint64_t) data[0]);
    value |= ((uint64_t) data[1]) << 8;
    value |= ((uint64_t) data[2]) << 16;
    value |= ((uint64_t) data[3]) << 24;
    value |= ((uint64_t) data[4]) << 32;
    value |= ((uint64_t) data[5]) << 40;
    value |= ((uint64_t) data[6]) << 48;
    value |= ((uint64_t) data[7]) << 56;
    return value;
}

__attribute__((always_inline))
static inline uint32_t readUint32(uint8_t* data) {
    uint32_t value = 0;
    value |= ((uint32_t) data[0]);
    value |= ((uint32_t) data[1]) << 8;
    value |= ((uint32_t) data[2]) << 16;
    value |= ((uint32_t) data[3]) << 24;
    return value;
}

__attribute__((always_inline))
static inline uint16_t readUint16(uint8_t* data) {
    uint16_t value = 0;
    value |= ((uint16_t) data[0]);
    value |= ((uint16_t) data[1]) << 8;
    return value;
}

__attribute__((always_inline))
static inline uint8_t readUint8(uint8_t* data) {
    return data[0];
}

#define SIMD_OP(_on, _op, _what) \
__attribute__((always_inline)) \
static inline void simd_ ## _on ## _ ## _op(uint8_t r1, uint8_t r2) { \
    for (int i = 0; i < 32 / sizeof(_on ## _t); i++) { \
        simd_registers[r1]._on[i] _what ## = simd_registers[r2]._on[i]; \
    } \
} \
__attribute__((always_inline)) \
static inline void simd_ ## _on ## _ ## _op ## _imm(uint8_t r1, int64_t imm) { \
    for (int i = 0; i < 32 / sizeof(_on ## _t); i++) { \
        simd_registers[r1]._on[i] _what ## = imm; \
    } \
}

SIMD_OP(i8, add, +)
SIMD_OP(i16, add, +)
SIMD_OP(i32, add, +)
SIMD_OP(i64, add, +)
SIMD_OP(f32, add, +)
SIMD_OP(f64, add, +)

SIMD_OP(i8, sub, -)
SIMD_OP(i16, sub, -)
SIMD_OP(i32, sub, -)
SIMD_OP(i64, sub, -)
SIMD_OP(f32, sub, -)
SIMD_OP(f64, sub, -)

SIMD_OP(i8, mul, *)
SIMD_OP(i16, mul, *)
SIMD_OP(i32, mul, *)
SIMD_OP(i64, mul, *)
SIMD_OP(f32, mul, *)
SIMD_OP(f64, mul, *)

SIMD_OP(i8, div, /)
SIMD_OP(i16, div, /)
SIMD_OP(i32, div, /)
SIMD_OP(i64, div, /)
SIMD_OP(f32, div, /)
SIMD_OP(f64, div, /)

SIMD_OP(i8, mod, %)
SIMD_OP(i16, mod, %)
SIMD_OP(i32, mod, %)
SIMD_OP(i64, mod, %)

SIMD_OP(i8, and, &)
SIMD_OP(i16, and, &)
SIMD_OP(i32, and, &)
SIMD_OP(i64, and, &)

SIMD_OP(i8, or, |)
SIMD_OP(i16, or, |)
SIMD_OP(i32, or, |)
SIMD_OP(i64, or, |)

SIMD_OP(i8, xor, ^)
SIMD_OP(i16, xor, ^)
SIMD_OP(i32, xor, ^)
SIMD_OP(i64, xor, ^)

SIMD_OP(i8, shl, <<)
SIMD_OP(i16, shl, <<)
SIMD_OP(i32, shl, <<)
SIMD_OP(i64, shl, <<)

SIMD_OP(i8, shr, >>)
SIMD_OP(i16, shr, >>)
SIMD_OP(i32, shr, >>)
SIMD_OP(i64, shr, >>)

__attribute__((always_inline))
static inline void simd_i64_addsub(uint8_t r1, uint8_t r2) {
    for (int i = 0; i < 4; i += 2) {
        simd_registers[r1].i64[i] += simd_registers[r2].i64[i];
        simd_registers[r1].i64[i + 1] -= simd_registers[r2].i64[i + 1];
    }
}

__attribute__((always_inline))
static inline void simd_i32_addsub(uint8_t r1, uint8_t r2) {
    for (int i = 0; i < 8; i += 2) {
        simd_registers[r1].i32[i] += simd_registers[r2].i32[i];
        simd_registers[r1].i32[i + 1] -= simd_registers[r2].i32[i + 1];
    }
}

__attribute__((always_inline))
static inline void simd_i16_addsub(uint8_t r1, uint8_t r2) {
    for (int i = 0; i < 16; i += 2) {
        simd_registers[r1].i16[i] += simd_registers[r2].i16[i];
        simd_registers[r1].i16[i + 1] -= simd_registers[r2].i16[i + 1];
    }
}

__attribute__((always_inline))
static inline void simd_i8_addsub(uint8_t r1, uint8_t r2) {
    for (int i = 0; i < 32; i += 2) {
        simd_registers[r1].i8[i] += simd_registers[r2].i8[i];
        simd_registers[r1].i8[i + 1] -= simd_registers[r2].i8[i + 1];
    }
}

__attribute__((always_inline))
static inline void simd_f64_addsub(uint8_t r1, uint8_t r2) {
    for (int i = 0; i < 4; i += 2) {
        simd_registers[r1].f64[i] += simd_registers[r2].f64[i];
        simd_registers[r1].f64[i + 1] -= simd_registers[r2].f64[i + 1];
    }
}

__attribute__((always_inline))
static inline void simd_f32_addsub(uint8_t r1, uint8_t r2) {
    for (int i = 0; i < 8; i += 2) {
        simd_registers[r1].f32[i] += simd_registers[r2].f32[i];
        simd_registers[r1].f32[i + 1] -= simd_registers[r2].f32[i + 1];
    }
}

__attribute__((always_inline))
static inline void simd_i64_shuf(uint8_t r1, uint8_t r2) {
    simd_register_t tmp = simd_registers[r1];
    for (int i = 0; i < 8; i++) {
        simd_registers[r1].i32[i] = tmp.i32[simd_registers[r2].i32[i]];
    }
}

__attribute__((always_inline))
static inline void simd_i32_shuf(uint8_t r1, uint8_t r2) {
    simd_register_t tmp = simd_registers[r1];
    for (int i = 0; i < 4; i++) {
        simd_registers[r1].i64[i] = tmp.i64[simd_registers[r2].i64[i]];
    }
}

__attribute__((always_inline))
static inline void simd_i16_shuf(uint8_t r1, uint8_t r2) {
    simd_register_t tmp = simd_registers[r1];
    for (int i = 0; i < 16; i++) {
        simd_registers[r1].i16[i] = tmp.i16[simd_registers[r2].i16[i]];
    }
}

__attribute__((always_inline))
static inline void simd_i8_shuf(uint8_t r1, uint8_t r2) {
    simd_register_t tmp = simd_registers[r1];
    for (int i = 0; i < 32; i++) {
        simd_registers[r1].i8[i] = tmp.i8[simd_registers[r2].i8[i]];
    }
}

#define SIMD_CONVERT(_from, _to) \
__attribute__((always_inline)) \
static inline void simd_ ## _from ## _to_ ## _to(uint8_t r1, uint8_t r2) { \
    static_assert(sizeof(_from ## _t) == sizeof(_to ## _t), "Invalid SIMD conversion"); \
    for (int i = 0; i < sizeof(_from ## _t); i++) { \
        simd_registers[r1]._to [i] = simd_registers[r2]._from [i]; \
    } \
}

SIMD_CONVERT(i32, f32)
SIMD_CONVERT(i64, f64)
SIMD_CONVERT(f32, i32)
SIMD_CONVERT(f64, i64)

__attribute__((always_inline))
static inline void simd_conv(uint8_t srcReg, uint8_t srcMode, uint8_t destReg, uint8_t destMode) {
    if (srcMode < 0x10 && destMode >= 0x10) {
        switch (destMode) {
            case 0x10: simd_i32_to_f32(destReg, srcReg); break;
            case 0x20: simd_i64_to_f64(destReg, srcReg); break;
            default: printf("Invalid SIMD mode: %02x\n", destMode); break;
        }
    } else if (srcMode >= 0x10 && destMode < 0x10) {
        switch (srcMode) {
            case 0x10: simd_f32_to_i32(destReg, srcReg); break;
            case 0x20: simd_f64_to_i64(destReg, srcReg); break;
            default: printf("Invalid SIMD mode: %02x\n", srcMode); break;
        }
    } else if ((srcMode < 0x10 && destMode < 0x10) || (srcMode >= 0x10 && destMode >= 0x10)) {
        simd_registers[destReg] = simd_registers[srcReg];
    } else {
        printf("Invalid SIMD mode: %02x\n", srcMode);
    }
}

__attribute__((always_inline))
static inline void branch_to(void* to) {
    if (*(uint8_t*) to != 0x7F) {
        pc = to;
        return;
    }

    static void* self = NULL;
    if (self == NULL) {
        self = dlopen(NULL, RTLD_LAZY);
        if (self == NULL) {
            printf("Failed to load self\n");
            exit(1);
        }
    }

    char* sym = (char*) to + 1;
    printf("Calling foreign function %s\n", sym);

    void* func = dlsym(self, sym);
    if (func == NULL) {
        printf("Failed to find symbol %s\n", sym);
        exit(1);
    }
    
    void* values[32] = {0};
    for (int i = 0; i < 32; i++) {
        if (i < 8) {
            values[i] = (void*) registers[i].asInteger;
        } else {
            if (sp <= bp) {
                break;
            }
            values[i] = *((void**) --sp);
        }
    }

    void*(*funcPtr)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*)
        = func;
    registers[0].asInteger = (uint64_t) funcPtr(
        values[0], values[1], values[2], values[3], values[4], values[5], values[6], values[7],
        values[8], values[9], values[10], values[11], values[12], values[13], values[14], values[15],
        values[16], values[17], values[18], values[19], values[20], values[21], values[22], values[23],
        values[24], values[25], values[26], values[27], values[28], values[29], values[30], values[31]
    );
}

void exec(object_file* obj) {
    uint8_t* data = obj->data;
    pc = data;
    while (1) {
        uint16_t op = readUint16((uint8_t*) pc);
        pc += 2;
        uint8_t count = (op & opcode_nbytes_mask) >> opcode_nbytes_shift;
        uint16_t opcode = op & ~opcode_nbytes_mask;

        switch (count) {
        case 0: {
            switch (opcode) {
            case opcode_nop: {
                break;
            }

            case opcode_halt: {
                return;
            }

            case opcode_pshi: {
                *(void**) (sp++) = pc;
                break;
            }

            case opcode_ret: {
                if (sp == bp) {
                    return;
                }
                pc = (void**) (--sp);
                break;
            }

            case opcode_pshx: {
                *(uint64_t*) (sp++) = registers[0].asInteger;
                break;
            }

            case opcode_ppx: {
                registers[0].asInteger = *(uint64_t*) (--sp);
                break;
            }

            case opcode_pshy: {
                *(uint64_t*) (sp++) = registers[1].asInteger;
                break;
            }

            case opcode_ppy: {
                registers[1].asInteger = *(uint64_t*) (--sp);
                break;
            }

            case opcode_irq: {
                switch (registers[15].asInteger) {
                    case 1:
                        exit(registers[0].asInteger);
                        break;
                    case 2:
                        registers[0].asInteger = write(registers[0].asInteger, (void*) registers[1].asPointer, registers[2].asInteger);
                        break;
                    case 3:
                        registers[0].asInteger = read(registers[0].asInteger, (void*) registers[1].asPointer, registers[2].asInteger);
                        break;
                    case 4:
                        dump_registers(obj, 1);
                        break;
                    default:
                        printf("Unknown IRQ: %llu\n", registers[0].asInteger);
                        break;
                }
                break;
            }

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }

            break;
        }

        case 1: {
            switch (opcode) {
            case opcode_cmpz: {
                uint8_t reg = readUint8((uint8_t*) pc);
                if (registers[reg].asInteger == 0) {
                    flags |= FLAG_ZERO;
                } else {
                    flags &= ~FLAG_ZERO;
                }
                break;
            }

            case opcode_b: {
                uint8_t reg = readUint8((uint8_t*) pc);
                branch_to(registers[reg].asPointer);
                break;
            }

            case opcode_bne: {
                uint8_t reg = readUint8((uint8_t*) pc);
                if (!(flags & FLAG_EQUAL)) {
                    branch_to(registers[reg].asPointer);
                }
                break;
            }

            case opcode_beq: {
                uint8_t reg = readUint8((uint8_t*) pc);
                if (flags & FLAG_EQUAL) {
                    branch_to(registers[reg].asPointer);
                }
                break;
            }

            case opcode_bgt: {
                uint8_t reg = readUint8((uint8_t*) pc);
                if (flags & FLAG_GREATER) {
                    branch_to(registers[reg].asPointer);
                }
                break;
            }

            case opcode_blt: {
                uint8_t reg = readUint8((uint8_t*) pc);
                if (flags & FLAG_LESS) {
                    branch_to(registers[reg].asPointer);
                }
                break;
            }

            case opcode_bge: {
                uint8_t reg = readUint8((uint8_t*) pc);
                if (flags & (FLAG_GREATER | FLAG_EQUAL)) {
                    branch_to(registers[reg].asPointer);
                }
                break;
            }

            case opcode_ble: {
                uint8_t reg = readUint8((uint8_t*) pc);
                if (flags & (FLAG_LESS | FLAG_EQUAL)) {
                    branch_to(registers[reg].asPointer);
                }
                break;
            }

            case opcode_bnz: {
                uint8_t reg = readUint8((uint8_t*) pc);
                if (!(flags & FLAG_ZERO)) {
                    branch_to(registers[reg].asPointer);
                }
                break;
            }

            case opcode_bz: {
                uint8_t reg = readUint8((uint8_t*) pc);
                if (flags & FLAG_ZERO) {
                    branch_to(registers[reg].asPointer);
                }
                break;
            }

            case opcode_psh: {
                uint8_t reg = readUint8((uint8_t*) pc);
                *(uint64_t*) (sp++) = registers[reg].asInteger;
                break;
            }

            case opcode_pp: {
                uint8_t reg = readUint8((uint8_t*) pc);
                registers[reg].asInteger = *(uint64_t*) (--sp);
                break;
            }

            case opcode_not: {
                uint8_t reg = readUint8((uint8_t*) pc);
                registers[reg].asInteger = ~registers[reg].asInteger;
                break;
            }

            case opcode_inc: {
                uint8_t reg = readUint8((uint8_t*) pc);
                registers[reg].asInteger++;
                break;
            }

            case opcode_dec: {
                uint8_t reg = readUint8((uint8_t*) pc);
                registers[reg].asInteger--;
                break;
            }

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }

            pc += 1;
            break;
        }
        
        case 2: {
            switch (opcode) {
            case opcode_ldr: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                registers[reg1].asInteger = registers[reg2].asInteger;
                break;
            }

            case opcode_str: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                *(uint64_t*) (registers[reg2].asPointer) = registers[reg1].asInteger;
                break;
            }

            case opcode_cmp: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                uint64_t a = registers[reg1].asInteger;
                uint64_t b = registers[reg2].asInteger;
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
                break;
            }

            case opcode_psh: {
                uint16_t value = readUint16((uint8_t*) pc);
                *(uint64_t*) (sp++) = value;
                break;
            }

            #define ARITH_REG_REG(_op, _what) \
            case opcode_ ## _op: { \
                uint8_t reg1 = readUint8((uint8_t*) pc); \
                uint8_t reg2 = readUint8((uint8_t*) pc + 1); \
                registers[reg1].asInteger _what ## = registers[reg2].asInteger; \
                break; \
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

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }
            pc += 2;

            break;
        }

        case 3: {
            switch (opcode) {
            case opcode_ldr: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint16_t value = readUint16((uint8_t*) pc + 1);
                registers[reg1].asInteger = value;
                break;
            }

            case opcode_str: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint16_t value = readUint16((uint8_t*) pc + 1);
                *(uint64_t*) (registers[reg1].asPointer) = value;
                break;
            }

            case opcode_cmp: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint64_t a = registers[reg1].asInteger;
                uint64_t b = readUint16((uint8_t*) pc + 1);
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
                break;
            }

            #define ARITH_REG_IMM(_op, _what) \
            case opcode_ ## _op: { \
                uint8_t reg1 = readUint8((uint8_t*) pc); \
                uint16_t value = readUint16((uint8_t*) pc + 1); \
                registers[reg1].asInteger _what ## = value; \
                break; \
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

            #undef ARITH_REG_IMM

            #define ARITH_SIMD(_op) \
            case opcode_q ## _op: { \
                uint8_t mode = readUint8((uint8_t*) pc); \
                uint8_t reg1 = readUint8((uint8_t*) pc + 1); \
                uint8_t reg2 = readUint8((uint8_t*) pc + 2); \
                switch (mode) { \
                    case 0x01: simd_i8_ ## _op(reg1, reg2); break; \
                    case 0x02: simd_i16_ ## _op(reg1, reg2); break; \
                    case 0x04: simd_i32_ ## _op(reg1, reg2); break; \
                    case 0x08: simd_i64_ ## _op(reg1, reg2); break; \
                    case 0x10: simd_f32_ ## _op(reg1, reg2); break; \
                    case 0x20: simd_f64_ ## _op(reg1, reg2); break; \
                    default: printf("Invalid SIMD mode: %02x\n", mode); break; \
                } \
                break; \
            }

            ARITH_SIMD(add)
            ARITH_SIMD(sub)
            ARITH_SIMD(mul)
            ARITH_SIMD(div)

            #undef ARITH_SIMD

            #define ARITH_SIMD(_op) \
            case opcode_q ## _op: { \
                uint8_t mode = readUint8((uint8_t*) pc); \
                uint8_t reg1 = readUint8((uint8_t*) pc + 1); \
                uint8_t reg2 = readUint8((uint8_t*) pc + 2); \
                switch (mode) { \
                    case 0x01: simd_i8_ ## _op(reg1, reg2); break; \
                    case 0x02: simd_i16_ ## _op(reg1, reg2); break; \
                    case 0x04: simd_i32_ ## _op(reg1, reg2); break; \
                    case 0x08: simd_i64_ ## _op(reg1, reg2); break; \
                    default: printf("Invalid SIMD mode: %02x\n", mode); break; \
                } \
                break; \
            }

            ARITH_SIMD(mod)
            ARITH_SIMD(and)
            ARITH_SIMD(or)
            ARITH_SIMD(xor)
            ARITH_SIMD(shl)
            ARITH_SIMD(shr)
            ARITH_SIMD(addsub)
            ARITH_SIMD(shuf)

            #undef ARITH_SIMD

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }
            pc += 3;

            break;
        }

        case 4: {
            switch (opcode) {
            case opcode_ldr: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                int16_t offset = (int16_t) readUint16((uint8_t*) pc + 2);
                registers[reg1].asInteger = *(uint64_t*) (registers[reg2].asPointer + offset);
                break;
            }

            case opcode_b: {
                uint32_t offset = readUint32((uint8_t*) pc);
                branch_to(data + offset);
                break;
            }

            case opcode_bne: {
                uint32_t offset = readUint32((uint8_t*) pc);
                if (!(flags & FLAG_EQUAL)) {
                    branch_to(data + offset);
                }
                break;
            }

            case opcode_beq: {
                uint32_t offset = readUint32((uint8_t*) pc);
                if (flags & FLAG_EQUAL) {
                    branch_to(data + offset);
                }
                break;
            }

            case opcode_bgt: {
                uint32_t offset = readUint32((uint8_t*) pc);
                if (flags & FLAG_GREATER) {
                    branch_to(data + offset);
                }
                break;
            }

            case opcode_blt: {
                uint32_t offset = readUint32((uint8_t*) pc);
                if (flags & FLAG_LESS) {
                    branch_to(data + offset);
                }
                break;
            }

            case opcode_bge: {
                uint32_t offset = readUint32((uint8_t*) pc);
                if (flags & (FLAG_GREATER | FLAG_EQUAL)) {
                    branch_to(data + offset);
                }
                break;
            }

            case opcode_ble: {
                uint32_t offset = readUint32((uint8_t*) pc);
                if (flags & (FLAG_LESS | FLAG_EQUAL)) {
                    branch_to(data + offset);
                }
                break;
            }

            case opcode_bnz: {
                uint32_t offset = readUint32((uint8_t*) pc);
                if (!(flags & FLAG_ZERO)) {
                    branch_to(data + offset);
                }
                break;
            }

            case opcode_bz: {
                uint32_t offset = readUint32((uint8_t*) pc);
                if (flags & FLAG_ZERO) {
                    branch_to(data + offset);
                }
                break;
            }

            case opcode_psh: {
                uint32_t value = readUint32((uint8_t*) pc);
                *(uint8_t**) (sp++) = (data + value);
                break;
            }

            case opcode_pp: {
                uint32_t value = readUint32((uint8_t*) pc);
                *(uint64_t*) (data + value) = *(uint64_t*) (--sp);
            }

            case opcode_qconv: {
                uint8_t destMode = readUint8((uint8_t*) pc);
                uint8_t dest = readUint8((uint8_t*) pc + 1);
                uint8_t srcMode = readUint8((uint8_t*) pc + 2);
                uint8_t src = readUint8((uint8_t*) pc + 3);
                simd_conv(src, srcMode, dest, destMode);
            }

            case opcode_qmov: {
                uint8_t mode = readUint8((uint8_t*) pc);
                uint8_t dest = readUint8((uint8_t*) pc + 1);
                uint8_t index = readUint8((uint8_t*) pc + 2);
                uint8_t src = readUint8((uint8_t*) pc + 3);
                if (index != 0xFF) {
                    switch (mode) {
                        case 0x01: simd_registers[dest].i8[index] = registers[src].asInteger & 0xFF; break;
                        case 0x02: simd_registers[dest].i16[index] = registers[src].asInteger & 0xFFFF; break;
                        case 0x04: simd_registers[dest].i32[index] = registers[src].asInteger & 0xFFFFFFFF; break;
                        case 0x08: simd_registers[dest].i64[index] = registers[src].asInteger; break;
                        case 0x10: simd_registers[dest].f32[index] = registers[src].asInteger; break;
                        case 0x20: simd_registers[dest].f64[index] = registers[src].asInteger; break;
                        default: printf("Invalid SIMD mode: %02x\n", mode); break;
                    }
                } else {
                    switch (mode) {
                        case 0x01:
                            for (int i = 0; i < 32; i++) {
                                simd_registers[dest].i8[i] = registers[src].asInteger & 0xFF;
                            }
                            break;
                        case 0x02:
                            for (int i = 0; i < 16; i++) {
                                simd_registers[dest].i16[i] = registers[src].asInteger & 0xFFFF;
                            }
                            break;
                        case 0x04:
                            for (int i = 0; i < 8; i++) {
                                simd_registers[dest].i32[i] = registers[src].asInteger & 0xFFFFFFFF;
                            }
                            break;
                        case 0x08:
                            for (int i = 0; i < 4; i++) {
                                simd_registers[dest].i64[i] = registers[src].asInteger;
                            }
                            break;
                        case 0x10:
                            for (int i = 0; i < 8; i++) {
                                simd_registers[dest].f32[i] = registers[src].asInteger;
                            }
                            break;
                        case 0x20:
                            for (int i = 0; i < 4; i++) {
                                simd_registers[dest].f64[i] = registers[src].asInteger;
                            }
                            break;
                        default:
                            printf("Invalid SIMD mode: %02x\n", mode);
                            break;
                    }

                }
                break;
            }

            case opcode_qmov2: {
                uint8_t dest = readUint8((uint8_t*) pc);
                uint8_t mode = readUint8((uint8_t*) pc + 1);
                uint8_t index = readUint8((uint8_t*) pc + 2);
                uint8_t src = readUint8((uint8_t*) pc + 3);
                switch (mode) {
                    case 0x01: registers[dest].asInteger = simd_registers[src].i8[index]; break;
                    case 0x02: registers[dest].asInteger = simd_registers[src].i16[index]; break;
                    case 0x04: registers[dest].asInteger = simd_registers[src].i32[index]; break;
                    case 0x08: registers[dest].asInteger = simd_registers[src].i64[index]; break;
                    case 0x10: registers[dest].asInteger = simd_registers[src].f32[index]; break;
                    case 0x20: registers[dest].asInteger = simd_registers[src].f64[index]; break;
                    default: printf("Invalid SIMD mode: %02x\n", mode); break;
                }
                break;
            }

            #define ARITH_SIMD(_op) \
            case opcode_q ## _op: { \
                uint8_t mode = readUint8((uint8_t*) pc); \
                uint8_t reg1 = readUint8((uint8_t*) pc + 1); \
                int16_t value = (int16_t) readUint16((uint8_t*) pc + 2); \
                switch (mode) { \
                    case 0x01: simd_i8_ ## _op ## _imm(reg1, value); break; \
                    case 0x02: simd_i16_ ## _op ## _imm(reg1, value); break; \
                    case 0x04: simd_i32_ ## _op ## _imm(reg1, value); break; \
                    case 0x08: simd_i64_ ## _op ## _imm(reg1, value); break; \
                    case 0x10: simd_f32_ ## _op ## _imm(reg1, value); break; \
                    case 0x20: simd_f64_ ## _op ## _imm(reg1, value); break; \
                    default: printf("Invalid SIMD mode: %02x\n", mode); break; \
                } \
                break; \
            }

            ARITH_SIMD(add)
            ARITH_SIMD(sub)
            ARITH_SIMD(mul)
            ARITH_SIMD(div)

            #undef ARITH_SIMD

            #define ARITH_SIMD(_op) \
            case opcode_q ## _op: { \
                uint8_t mode = readUint8((uint8_t*) pc); \
                uint8_t reg1 = readUint8((uint8_t*) pc + 1); \
                int16_t value = (int16_t) readUint16((uint8_t*) pc + 2); \
                switch (mode) { \
                    case 0x01: simd_i8_ ## _op ## _imm(reg1, value); break; \
                    case 0x02: simd_i16_ ## _op ## _imm(reg1, value); break; \
                    case 0x04: simd_i32_ ## _op ## _imm(reg1, value); break; \
                    case 0x08: simd_i64_ ## _op ## _imm(reg1, value); break; \
                    default: printf("Invalid SIMD mode: %02x\n", mode); break; \
                } \
                break; \
            }

            ARITH_SIMD(mod)
            ARITH_SIMD(and)
            ARITH_SIMD(or)
            ARITH_SIMD(xor)
            ARITH_SIMD(shl)
            ARITH_SIMD(shr)

            #undef ARITH_SIMD

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }
            pc += 4;

            break;
        }

        case 5: {
            switch (opcode) {
            case opcode_ldr: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint32_t offset = readUint32((uint8_t*) pc + 1);
                registers[reg1].asPointer = (data + offset);
                break;
            }

            case opcode_mov: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t nbytes = readUint8((uint8_t*) pc + 1);
                int16_t offset = (int16_t) readUint16((uint8_t*) pc + 2);
                uint8_t reg2 = readUint8((uint8_t*) pc + 4);
                uint8_t* ptr = registers[reg2].asPointer + offset;
                registers[reg1].asInteger = 0;
                for (uint8_t n = 0; n < nbytes; n++) {
                    registers[reg1].asInteger |= ((uint64_t) ptr[n]) << (n * 8);
                }
                break;
            }
            #define ARITH_REG_MEM(_op, _what) \
            case opcode_ ## _op: { \
                uint8_t reg1 = readUint8((uint8_t*) pc); \
                uint8_t nbytes = readUint8((uint8_t*) pc + 1); \
                uint8_t reg2 = readUint8((uint8_t*) pc + 2); \
                int16_t offset = (int16_t) readUint16((uint8_t*) pc + 3); \
                uint8_t* ptr = registers[reg2].asPointer + offset; \
                uint64_t value = 0; \
                for (uint8_t n = 0; n < nbytes; n++) { \
                    value |= ((uint64_t) ptr[n]) << (n * 8); \
                } \
                registers[reg1].asInteger _what ## = value; \
                break; \
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

            #define ARITH_SIMD(_op) \
            case opcode_q ## _op: { \
                uint8_t mode = readUint8((uint8_t*) pc); \
                uint8_t reg1 = readUint8((uint8_t*) pc + 1); \
                uint8_t reg2 = readUint8((uint8_t*) pc + 2); \
                int64_t value = registers[reg2].asInteger; \
                (void) readUint16((uint8_t*) pc + 3); \
                switch (mode) { \
                    case 0x01: simd_i8_ ## _op ## _imm(reg1, value); break; \
                    case 0x02: simd_i16_ ## _op ## _imm(reg1, value); break; \
                    case 0x04: simd_i32_ ## _op ## _imm(reg1, value); break; \
                    case 0x08: simd_i64_ ## _op ## _imm(reg1, value); break; \
                    case 0x10: simd_f32_ ## _op ## _imm(reg1, value); break; \
                    case 0x20: simd_f64_ ## _op ## _imm(reg1, value); break; \
                    default: printf("Invalid SIMD mode: %02x\n", mode); break; \
                } \
                break; \
            }

            ARITH_SIMD(add)
            ARITH_SIMD(sub)
            ARITH_SIMD(mul)
            ARITH_SIMD(div)

            #undef ARITH_SIMD

            #define ARITH_SIMD(_op) \
            case opcode_q ## _op: { \
                uint8_t mode = readUint8((uint8_t*) pc); \
                uint8_t reg1 = readUint8((uint8_t*) pc + 1); \
                uint8_t reg2 = readUint8((uint8_t*) pc + 2); \
                int64_t value = registers[reg2].asInteger; \
                (void) readUint16((uint8_t*) pc + 3); \
                switch (mode) { \
                    case 0x01: simd_i8_ ## _op ## _imm(reg1, value); break; \
                    case 0x02: simd_i16_ ## _op ## _imm(reg1, value); break; \
                    case 0x04: simd_i32_ ## _op ## _imm(reg1, value); break; \
                    case 0x08: simd_i64_ ## _op ## _imm(reg1, value); break; \
                    default: printf("Invalid SIMD mode: %02x\n", mode); break; \
                } \
                break; \
            }

            ARITH_SIMD(mod)
            ARITH_SIMD(and)
            ARITH_SIMD(or)
            ARITH_SIMD(xor)
            ARITH_SIMD(shl)
            ARITH_SIMD(shr)

            #undef ARITH_SIMD

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }
            pc += 5;

            break;
        }

        case 6: {
            switch (opcode) {
            case opcode_ldr: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                uint32_t offset = readUint32((uint8_t*) pc + 2);
                registers[reg1].asInteger = *(uint64_t*) (data + offset + registers[reg2].asSignedInteger);
                break;
            }

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }
            pc += 6;

            break;
        }

        case 7: {
            switch (opcode) {
            case opcode_ldr: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                int16_t off2 = (int16_t) readUint16((uint8_t*) pc + 1);
                uint32_t offset = readUint32((uint8_t*) pc + 3);
                registers[reg1].asInteger = *(uint64_t*) (data + offset + off2);
                break;
            }

            #define ARITH_REG_SYM(_op, _what) \
            case opcode_ ## _op: { \
                uint8_t reg1 = readUint8((uint8_t*) pc); \
                uint8_t nbytes = readUint8((uint8_t*) pc + 1); \
                int16_t off2 = (int16_t) readUint16((uint8_t*) pc + 2); \
                uint32_t offset = readUint32((uint8_t*) pc + 4); \
                uint8_t* ptr = data + offset + off2; \
                uint64_t value = 0; \
                for (uint8_t n = 0; n < nbytes; n++) { \
                    value |= ((uint64_t) ptr[n]) << (n * 8); \
                } \
                registers[reg1].asInteger _what ## = value; \
                break; \
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

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }
            pc += 7;

            break;
        }

        case 8: {
            switch (opcode) {
            case opcode_psh: {
                uint64_t value = readUint64((uint8_t*) pc);
                *(uint64_t*) (sp++) = value;
                break;
            }

            case opcode_mov: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t nbytes = readUint8((uint8_t*) pc + 1);
                int16_t offset = (int16_t) readUint16((uint8_t*) pc + 2);
                uint32_t value = readUint32((uint8_t*) pc + 4);
                uint8_t* ptr = (data + value + offset);
                registers[reg1].asInteger = 0;
                for (uint8_t n = 0; n < nbytes; n++) {
                    registers[reg1].asInteger |= ((uint64_t) ptr[n]) << (n * 8);
                }
                break;
            }

            #define ARITH_REG_ADDR_OFF(_op, _what) \
            case opcode_ ## _op: { \
                uint8_t reg1 = readUint8((uint8_t*) pc); \
                uint8_t nbytes = readUint8((uint8_t*) pc + 1); \
                uint32_t binaryOffset = readUint32((uint8_t*) pc + 2); \
                int16_t offset = (int16_t) readUint16((uint8_t*) pc + 6); \
                uint8_t* ptr = (data + binaryOffset + offset); \
                uint64_t value = 0; \
                for (uint8_t n = 0; n < nbytes; n++) { \
                    value |= ((uint64_t) ptr[n]) << (n * 8); \
                } \
                registers[reg1].asInteger _what ## = value; \
                break; \
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

            case opcode_qmov: {
                uint8_t mode = readUint8((uint8_t*) pc);
                uint8_t dest = readUint8((uint8_t*) pc + 1);
                uint32_t value = readUint32((uint8_t*) pc + 2);
                int16_t offset = (int16_t) readUint16((uint8_t*) pc + 6);
                uint8_t* ptr = (data + value + offset);
                switch (mode) {
                    case 0x01: 
                        for (int i = 0; i < 32; i++) {
                            simd_registers[dest].i8[i] = *(uint8_t*) (ptr + i * sizeof(uint8_t));
                        }
                        break;
                    case 0x02:
                        for (int i = 0; i < 16; i++) {
                            simd_registers[dest].i16[i] = *(uint16_t*) (ptr + (i * sizeof(uint16_t)));
                        }
                        break;
                    case 0x04:
                        for (int i = 0; i < 8; i++) {
                            simd_registers[dest].i32[i] = *(uint32_t*) (ptr + (i * sizeof(uint32_t)));
                        }
                        break;
                    case 0x08:
                        for (int i = 0; i < 4; i++) {
                            simd_registers[dest].i64[i] = *(uint64_t*) (ptr + (i * sizeof(uint64_t)));
                        }
                        break;
                    case 0x10:
                        for (int i = 0; i < 8; i++) {
                            simd_registers[dest].f32[i] = *(float*) (ptr + (i * sizeof(float)));
                        }
                        break;
                    case 0x20:
                        for (int i = 0; i < 4; i++) {
                            simd_registers[dest].f64[i] = *(double*) (ptr + (i * sizeof(double)));
                        }
                        break;
                    default:
                        printf("Invalid SIMD mode: %02x\n", mode);
                        break;
                }
                break;
            }

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }
            pc += 8;

            break;
        }

        case 9: {
            switch (opcode) {
            case opcode_ldr: {
                uint8_t reg = readUint8((uint8_t*) pc);
                uint64_t value = readUint64((uint8_t*) pc + 1);
                registers[reg].asInteger = value;
                break;
            }

            case opcode_str: {
                uint8_t reg = readUint8((uint8_t*) pc);
                uint64_t value = readUint64((uint8_t*) pc + 1);
                *(uint64_t*) (registers[reg].asPointer) = value;
                break;
            }

            case opcode_cmp: {
                uint8_t reg = readUint8((uint8_t*) pc);
                uint64_t a = registers[reg].asInteger;
                uint64_t b = readUint64((uint8_t*) pc + 1);
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
                break;
            }

            #define ARITH_REG_IMM64(_op, _what) \
            case opcode_ ## _op: { \
                uint8_t reg = readUint8((uint8_t*) pc); \
                uint64_t value = readUint64((uint8_t*) pc + 1); \
                registers[reg].asInteger _what ## = value; \
                break; \
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

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }
            pc += 9;

            break;
        }

        default:
            printf("Unknown instruction: %02x\n", op);
            break;
        }
    }
}

size_t symbol_size(symbol* sym) {
    return sizeof(uint8_t) + sizeof(uint16_t) + strlen((char*) sym->name) + sizeof(uint32_t);
}

int add_symbol(object_file* obj, char* name) {
    obj->symbols = realloc(obj->symbols, sizeof(symbol) * (obj->symbols_size + 1));

    symbol* sym = &obj->symbols[obj->symbols_size];
    sym->name = (int8_t*) name;

    sym->offset = obj->comp_size;

    printf("symbol %s at %llu\n", name, sym->offset);

    obj->symbols_size++;
    return 0;
}

uint64_t symbol_offset(object_file* obj, const char* name) {
    for (uint32_t i = 0; i < obj->symbols_size; i++) {
        if (strcmp((char*) obj->symbols[i].name, name) == 0) {
            return obj->symbols[i].offset;
        }
    }

    return 0;
}

object_file* create_object() {
    object_file* obj = malloc(sizeof(object_file));
    obj->magic = 0xFEEDF00D;
    obj->data_capacity = 64;
    obj->data = malloc(obj->data_capacity);
    obj->data_size = 0;

    // compiler info
    obj->symbols = NULL;
    obj->symbols_size = 0;

    return obj;
}

object_file* run_compile(const char* file_name);

void sig_handler(int sig) {
    void* callstack[1024];
	int frames = backtrace(callstack, 1024);
    if (pc) {
        printf("Last instruction: %02x%02x%02x%02x\n", *(uint8_t*) (pc - 4), *(uint8_t*) (pc - 3), *(uint8_t*) (pc - 2), *(uint8_t*) (pc - 1));
    }
    printf("Signal %d\n", sig);
    dump_registers(NULL, 0);
	write(STDERR_FILENO, "Backtrace:\n", 11);
	backtrace_symbols_fd(callstack, frames, STDERR_FILENO);
	write(STDERR_FILENO, "\n", 1);
    exit(1);
}

int main(int argc, char **argv) {
    signal(SIGSEGV, sig_handler);
    signal(SIGILL, sig_handler);
    signal(SIGFPE, sig_handler);
    signal(SIGABRT, sig_handler);

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
        write_object_file(run_compile(argv[2]), argv[3]);
        return 0;
    } else if (strcmp(argv[1], "run") == 0) {
        object_file* obj = read_object_file(argv[2]);

        bp = sp = malloc(sizeof(uint64_t) * 1024);
        registers[0].asInteger = argc - 2;
        registers[1].asInteger = (uint64_t) (argv + 2);

        exec(obj);
        return registers[0].asInteger;
    } else {
        fprintf(stderr, "Unknown command '%s'\n", argv[1]);
        return 1;
    }
}
