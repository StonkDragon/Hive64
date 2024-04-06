#include <math.h>
#include <signal.h>
#include <pthread.h>
#include <setjmp.h>
#include <stdatomic.h>
#include <sys/mman.h>
#include <unistd.h>

#include "new_ops.h"

extern svc_call svcs[];

struct cpu_state state[CORE_COUNT * THREAD_COUNT] = {0};

int check_condition(hive_instruction_t ins, hive_flag_register_t fr);

#define set_flagsQWord(state, res) set_flags64((state), (res))
#define set_flagsDWord(state, res) set_flags32((state), (res))
#define set_flagsWord(state, res) set_flags16((state), (res))
#define set_flagsByte(state, res) set_flags8((state), (res))

    // lt, mi   -> negative
    // gt       -> !zero && !negative
    // ge, pl   -> !negative
    // le       -> negative || zero
    // eq, z    -> zero
    // ne, nz   -> !zero
    // always   -> 1
    // never    -> 0
static inline SQWord_t set_flags64(struct cpu_state* state, SQWord_t res) {
    state->cr[CR_FLAGS].asFlags.negative = (res < 0);
    state->cr[CR_FLAGS].asFlags.zero = (res == 0);
    return res;
}
static inline SDWord_t set_flags32(struct cpu_state* state, SDWord_t res) {
    state->cr[CR_FLAGS].asFlags.zero = (res == 0);
    state->cr[CR_FLAGS].asFlags.negative = (res < 0);
    return res;
}
static inline SWord_t set_flags16(struct cpu_state* state, SWord_t res) {
    state->cr[CR_FLAGS].asFlags.zero = (res == 0);
    state->cr[CR_FLAGS].asFlags.negative = (res < 0);
    return res;
}
static inline SByte_t set_flags8(struct cpu_state* state, SByte_t res) {
    state->cr[CR_FLAGS].asFlags.zero = (res == 0);
    state->cr[CR_FLAGS].asFlags.negative = (res < 0);
    return res;
}
static inline Float64_t set_flagsf64(struct cpu_state* state, Float64_t res) {
    state->cr[CR_FLAGS].asFlags.zero = (res == 0.0);
    state->cr[CR_FLAGS].asFlags.negative = (res < 0.0);
    return res;
}
static inline Float32_t set_flagsf32(struct cpu_state* state, Float32_t res) {
    state->cr[CR_FLAGS].asFlags.zero = (res == 0.0);
    state->cr[CR_FLAGS].asFlags.negative = (res < 0.0);
    return res;
}

#define PC_REL(what)                (state->r[REG_PC].asQWord + ((what) << 2))
#define PC_REL32(what)              (state->r[REG_PC].asDWord + ((what) << 2))
#define BRANCH(to)                  (state->r[REG_PC].asQWord = (QWord_t) ((to) - sizeof(hive_instruction_t)))
#define BRANCH_RELATIVE(offset)     BRANCH(PC_REL(offset))
#define LINK()                      (state->r[REG_LR].asQWord = state->r[REG_PC].asQWord)

#define def_ror(type, size) type ror ## size(type a, type b) { return (((a) >> (b)) | ((a) << ((sizeof(a) << 3) - (b)))); }

def_ror(QWord_t, 64)
def_ror(DWord_t, 32)
def_ror(Word_t, 16)
def_ror(Byte_t, 8)

#define ROR(_a, _b) _Generic((_a), \
    uint64_t: ror64, int64_t: ror64, \
    uint32_t: ror32, int32_t: ror32, \
    uint16_t: ror16, int16_t: ror16, \
    uint8_t: ror8, int8_t: ror8 \
)(_a, _b)
#define ROL(_a, _b) ROR(_a, (sizeof(_a) << 3) - (_b))

typedef void(*hive_executor_t)(hive_instruction_t, struct cpu_state*);

#define BEGIN_OP(_op, ...)   void exec_ ## _op (hive_instruction_t ins, struct cpu_state* state) {
#define END_OP               }

uint64_t swap_bytes_64(uint64_t x) {
    return (((x >> 0) & 0xFF) << 56) |
           (((x >> 8) & 0xFF) << 48) |
           (((x >> 16) & 0xFF) << 40) |
           (((x >> 24) & 0xFF) << 32) |
           (((x >> 32) & 0xFF) << 24) |
           (((x >> 40) & 0xFF) << 16) |
           (((x >> 48) & 0xFF) << 8) |
           (((x >> 56) & 0xFF) << 0);
}
uint32_t swap_bytes_32(uint32_t x) {
    return (((x >> 0) & 0xFF) << 24) |
           (((x >> 8) & 0xFF) << 16) |
           (((x >> 16) & 0xFF) << 8) |
           (((x >> 24) & 0xFF) << 0);
}
uint16_t swap_bytes_16(uint16_t x) {
    return (((x >> 0) & 0xFF) << 8) |
           (((x >> 8) & 0xFF) << 0);
}

uint8_t swap_bytes_8(uint8_t x) {
    raise(SIGILL);
    return x;
}

#define swap_bytes(x) _Generic((x), int64_t: swap_bytes_64, uint64_t: swap_bytes_64, int32_t: swap_bytes_32, uint32_t: swap_bytes_32, int16_t: swap_bytes_16, uint16_t: swap_bytes_16, int8_t: swap_bytes_8, uint8_t: swap_bytes_8)((x))

#define INTENT_WRITE 1
#define INTENT_READ 0

#define reg_reader(_type) \
_type ## _t read ## _type (struct cpu_state* state, uint8_t reg, uint8_t counter) { \
    if (is_slot_overridden(state, counter)) { \
        return getRegister(state, reg, counter, INTENT_READ)->as ## _type ## Pair.high; \
    } else { \
        return getRegister(state, reg, counter, INTENT_READ)->as ## _type ## Pair.low; \
    } \
} \
S ## _type ## _t readS ## _type (struct cpu_state* state, uint8_t reg, uint8_t counter) { \
    if (is_slot_overridden(state, counter)) { \
        return getRegister(state, reg, counter, INTENT_READ)->asS ## _type ## Pair.high; \
    } else { \
        return getRegister(state, reg, counter, INTENT_READ)->asS ## _type ## Pair.low; \
    } \
}
#define reg_writer(_type) \
void write ## _type (struct cpu_state* state, uint8_t reg, _type ## _t val, uint8_t write, uint8_t counter) { \
    set_flags ## _type (state, val); \
    if (!write) return; \
    if (is_slot_overridden(state, counter)) { \
        getRegister(state, reg, counter, INTENT_WRITE)->as ## _type ## Pair.high = val; \
    } else { \
        getRegister(state, reg, counter, INTENT_WRITE)->as ## _type ## Pair.low = val; \
    } \
} \
void writeS ## _type (struct cpu_state* state, uint8_t reg, S ## _type ## _t val, uint8_t write, uint8_t counter) { \
    set_flags ## _type (state, val); \
    if (!write) return; \
    if (is_slot_overridden(state, counter)) { \
        getRegister(state, reg, counter, INTENT_WRITE)->asS ## _type ## Pair.high = val; \
    } else { \
        getRegister(state, reg, counter, INTENT_WRITE)->asS ## _type ## Pair.low = val; \
    } \
}

uint8_t is_slot_overridden(struct cpu_state* state, uint8_t counter) {
    return (state->cr[CR_FLAGS].asFlags.reg_state & (1 << counter)) != 0;
}
uint8_t is_control_register(struct cpu_state* state, uint8_t counter) {
    return (state->cr[CR_FLAGS].asFlags.references_cr & (1 << counter)) != 0;
}

hive_register_t* getRegister(struct cpu_state* state, uint8_t reg, uint8_t counter, uint8_t intent) {
    if (is_control_register(state, counter)) {
        if (reg >= 12 || state->cr[CR_FLAGS].asFlags.execution_mode != EM_HYPERVISOR) {
            raise(SIGILL);
        }
        return &state->cr[reg];
    } else {
        return &state->r[reg];
    }
}

reg_reader(Byte)
reg_reader(Word)
reg_reader(DWord)
Float32_t readFloat32(struct cpu_state* state, uint8_t reg, uint8_t counter) {
    return getRegister(state, reg, counter, INTENT_READ)->asFloat32;
}
Float64_t readFloat64(struct cpu_state* state, uint8_t reg, uint8_t counter) {
    return getRegister(state, reg, counter, INTENT_READ)->asFloat64;
}
QWord_t readQWord(struct cpu_state* state, uint8_t reg, uint8_t counter) {
    return getRegister(state, reg, counter, INTENT_READ)->asQWord;
}
SQWord_t readSQWord(struct cpu_state* state, uint8_t reg, uint8_t counter) {
    return getRegister(state, reg, counter, INTENT_READ)->asSQWord;
}

reg_writer(Byte)
reg_writer(Word)
reg_writer(DWord)
void writeFloat32(struct cpu_state* state, uint8_t reg, Float32_t val, uint8_t write, uint8_t counter) {
    set_flagsf32(state, val);
    if (write) {
        getRegister(state, reg, counter, INTENT_WRITE)->asFloat32 = val;
    }
}
void writeFloat64(struct cpu_state* state, uint8_t reg, Float64_t val, uint8_t write, uint8_t counter) {
    set_flagsf64(state, val);
    if (write) {
        getRegister(state, reg, counter, INTENT_WRITE)->asFloat64 = val;
    }
}
void writeQWord(struct cpu_state* state, uint8_t reg, QWord_t val, uint8_t write, uint8_t counter) {
    set_flagsQWord(state, val);
    if (write) {
        getRegister(state, reg, counter, INTENT_WRITE)->asQWord = val;
    }
}
void writeSQWord(struct cpu_state* state, uint8_t reg, SQWord_t val, uint8_t write, uint8_t counter) {
    set_flagsQWord(state, val);
    if (write) {
        getRegister(state, reg, counter, INTENT_WRITE)->asSQWord = val;
    }
}

#define mem_reader(_type) \
_type ## _t memRead ## _type (struct cpu_state* state, void* addr) { \
    if (!authenticate_ptr(state, addr)) { \
        fprintf(stderr, "Invalid ptr: %p\n", addr); \
        raise(SIGBUS); \
    } \
    if (((uint64_t) addr) % (sizeof(_type ## _t) > 4 ? 4 : sizeof(_type ## _t))) { \
        raise(SIGBUS); \
    } \
    return *(_type ## _t*) addr; \
}
#define mem_writer(_type) \
void memWrite ## _type (struct cpu_state* state, void* addr, _type ## _t val) { \
    if (!authenticate_ptr(state, addr)) { \
        fprintf(stderr, "Invalid ptr: %p\n", addr); \
        raise(SIGBUS); \
    } \
    if (((uint64_t) addr) % (sizeof(_type ## _t) > 4 ? 4 : sizeof(_type ## _t))) { \
        raise(SIGBUS); \
    } \
    *(_type ## _t*) addr = val; \
}

bool authenticate_ptr(struct cpu_state* state, void* addr) {
    bool in_addr_range = ((uint64_t) addr >= (uint64_t) HIVE_MEMORY_BASE) && ((uint64_t) addr < ((uint64_t) HIVE_MEMORY_BASE + HIVE_MEMORY_SIZE));
    return in_addr_range;
}

mem_reader(Byte)
mem_reader(Word)
mem_reader(DWord)
mem_reader(QWord)
mem_reader(SByte)
mem_reader(SWord)
mem_reader(SDWord)
mem_reader(SQWord)
mem_reader(Float32)
mem_reader(Float64)
mem_reader(hive_vector_register)
mem_reader(hive_instruction)

mem_writer(Byte)
mem_writer(Word)
mem_writer(DWord)
mem_writer(QWord)
mem_writer(SByte)
mem_writer(SWord)
mem_writer(SDWord)
mem_writer(SQWord)
mem_writer(Float32)
mem_writer(Float64)
mem_writer(hive_vector_register)
mem_writer(hive_instruction)

#define ALU(nbits) \
uint ## nbits ## _t alu ## nbits(hive_instruction_t ins, struct cpu_state *state, uint ## nbits ## _t a, uint ## nbits ## _t b) { \
    hive_register_t target; \
    switch (ins.type_data_alui.op) { \
        case OP_DATA_ALU_add: target.asU ## nbits = a + b; break; \
        case OP_DATA_ALU_sub: target.asU ## nbits = a - b; break; \
        case OP_DATA_ALU_mul: target.asU ## nbits = a * b; break; \
        case OP_DATA_ALU_div: target.asU ## nbits = a / b; break; \
        case OP_DATA_ALU_mod: target.asU ## nbits = a % b; break; \
        case OP_DATA_ALU_and: target.asU ## nbits = a & b; break; \
        case OP_DATA_ALU_or: target.asU ## nbits = a | b; break; \
        case OP_DATA_ALU_xor: target.asU ## nbits = a ^ b; break; \
        case OP_DATA_ALU_shl: target.asU ## nbits = a << b; break; \
        case OP_DATA_ALU_shr: target.asU ## nbits = a >> b; break; \
        case OP_DATA_ALU_rol: target.asU ## nbits = ROL(a, b); break; \
        case OP_DATA_ALU_ror: target.asU ## nbits = ROR(a, b); break; \
        case OP_DATA_ALU_neg: target.asI ## nbits = -((int ## nbits ## _t) a); break; \
        case OP_DATA_ALU_not: target.asU ## nbits = ~a; break; \
        case OP_DATA_ALU_swe: target.asU ## nbits = swap_bytes(a); break; \
        default: raise(SIGILL); \
    } \
    set_flags ## nbits(state, target.asI ## nbits); \
    return target.asU ## nbits; \
} \
uint ## nbits ## _t salu ## nbits(hive_instruction_t ins, struct cpu_state *state, uint ## nbits ## _t _a, uint ## nbits ## _t _b) { \
    int ## nbits ## _t a = *(int ## nbits ## _t*) &_a; \
    int ## nbits ## _t b = *(int ## nbits ## _t*) &_b; \
    hive_register_t target; \
    switch (ins.type_data_alui.op) { \
        case OP_DATA_ALU_add: target.asI ## nbits = a + b; break; \
        case OP_DATA_ALU_sub: target.asI ## nbits = a - b; break; \
        case OP_DATA_ALU_mul: target.asI ## nbits = a * b; break; \
        case OP_DATA_ALU_div: target.asI ## nbits = a / b; break; \
        case OP_DATA_ALU_mod: target.asI ## nbits = a % b; break; \
        case OP_DATA_ALU_and: target.asI ## nbits = a & b; break; \
        case OP_DATA_ALU_or: target.asI ## nbits = a | b; break; \
        case OP_DATA_ALU_xor: target.asI ## nbits = a ^ b; break; \
        case OP_DATA_ALU_shl: target.asI ## nbits = a << b; break; \
        case OP_DATA_ALU_shr: target.asI ## nbits = a >> b; break; \
        case OP_DATA_ALU_rol: target.asI ## nbits = ROL(a, b); break; \
        case OP_DATA_ALU_ror: target.asI ## nbits = ROR(a, b); break; \
        case OP_DATA_ALU_neg: target.asI ## nbits = -(*(int ## nbits ## _t*) &a); break; \
        case OP_DATA_ALU_not: target.asI ## nbits = ~a; break; \
        case OP_DATA_ALU_swe: target.asI ## nbits = swap_bytes(a); break; \
        default: raise(SIGILL); \
    } \
    set_flags ## nbits(state, target.asI ## nbits); \
    return target.asU ## nbits; \
} \
uint ## nbits ## _t (*alu ## nbits ## _func[2])(hive_instruction_t ins, struct cpu_state *state, uint ## nbits ## _t a, uint ## nbits ## _t b) = { \
    alu ## nbits, \
    salu ## nbits, \
};

hive_register_t signextend(hive_instruction_t ins, struct cpu_state* state, uint8_t src) {
    uint8_t from = ins.type_data_sext.from;
    uint8_t to = ins.type_data_sext.to;
    if (to <= from) {
        raise(SIGILL);
    }
    hive_register_t dest;
    switch (from) {
        case SIZE_8BIT:
            switch (to) {
                case SIZE_16BIT: dest.asSWord = readSByte(state, src, REG_SRC1); break;
                case SIZE_32BIT: dest.asSDWord = readSByte(state, src, REG_SRC1); break;
                case SIZE_64BIT: dest.asSQWord = readSByte(state, src, REG_SRC1); break;
                default: raise(SIGILL);
            }
            break;
        case SIZE_16BIT:
            switch (to) {
                case SIZE_32BIT: dest.asSDWord = readSWord(state, src, REG_SRC1); break;
                case SIZE_64BIT: dest.asSQWord = readSWord(state, src, REG_SRC1); break;
                default: raise(SIGILL);
            }
            break;
        case SIZE_32BIT:
            switch (to) {
                case SIZE_64BIT: dest.asSQWord = readSDWord(state, src, REG_SRC1); break;
                default: raise(SIGILL);
            }
            break;
        default: raise(SIGILL);
    }
    return dest;
}

ALU(64)
ALU(32)
ALU(16)
ALU(8)

BEGIN_OP(data_alu)
    hive_register_t target;
    if (ins.type_data_alui.op == OP_DATA_ALU_sext) {
        target = signextend(ins, state, ins.type_data_sext.r2);
    } else {
        if (ins.type_data_alui.use_imm) {
            switch (state->cr[CR_FLAGS].asFlags.size) {
                case SIZE_64BIT: target.asQWord = alu64_func[ins.type_data_alui.salu](ins, state, readQWord(state, ins.type_data_alui.r2, REG_SRC1), (QWord_t) (ins.type_data_alui.imm)); break;
                case SIZE_32BIT: target.asDWord = alu32_func[ins.type_data_alui.salu](ins, state, readDWord(state, ins.type_data_alui.r2, REG_SRC1), (DWord_t) (ins.type_data_alui.imm)); break;
                case SIZE_16BIT: target.asWord = alu16_func[ins.type_data_alui.salu](ins, state, readWord(state, ins.type_data_alui.r2, REG_SRC1), (Word_t) (ins.type_data_alui.imm)); break;
                case SIZE_8BIT:  target.asByte = alu8_func[ins.type_data_alui.salu](ins, state, readByte(state, ins.type_data_alui.r2, REG_SRC1), (Byte_t) (ins.type_data_alui.imm)); break;
            }
        } else {
            switch (state->cr[CR_FLAGS].asFlags.size) {
                case SIZE_64BIT: target.asQWord = alu64_func[ins.type_data_alui.salu](ins, state, readSQWord(state, ins.type_data_alui.r2, REG_SRC1), readSQWord(state, ins.type_data_alur.r3, REG_SRC2)); break;
                case SIZE_32BIT: target.asDWord = alu32_func[ins.type_data_alui.salu](ins, state, readSDWord(state, ins.type_data_alui.r2, REG_SRC1), readSDWord(state, ins.type_data_alur.r3, REG_SRC2)); break;
                case SIZE_16BIT: target.asWord = alu16_func[ins.type_data_alui.salu](ins, state, readSWord(state, ins.type_data_alui.r2, REG_SRC1), readSWord(state, ins.type_data_alur.r3, REG_SRC2)); break;
                case SIZE_8BIT:  target.asByte = alu8_func[ins.type_data_alui.salu](ins, state, readSByte(state, ins.type_data_alui.r2, REG_SRC1), readSByte(state, ins.type_data_alur.r3, REG_SRC2)); break;
            }
        }
    }
    switch (state->cr[CR_FLAGS].asFlags.size) {
        case SIZE_64BIT: writeQWord(state, ins.type_data_alui.r1, target.asQWord, ins.type_data_alui.no_writeback == 0, REG_DEST); break;
        case SIZE_32BIT: writeDWord(state, ins.type_data_alui.r1, target.asDWord, ins.type_data_alui.no_writeback == 0, REG_DEST); break;
        case SIZE_16BIT: writeWord(state, ins.type_data_alui.r1, target.asWord, ins.type_data_alui.no_writeback == 0, REG_DEST); break;
        case SIZE_8BIT:  writeByte(state, ins.type_data_alui.r1, target.asByte, ins.type_data_alui.no_writeback == 0, REG_DEST); break;
    }
END_OP
BEGIN_OP(data_fpu)
    hive_register_t target;
    uint8_t src1 = ins.type_data_fpu.r2;
    uint8_t src2 = ins.type_data_fpu.r3;
    if (ins.type_data_fpu.is_single_op) {
        if (ins.type_data_fpu.use_int_arg2) {
            switch (ins.type_data_fpu.op) {
                case OP_DATA_FLOAT_add: target.asFloat32 = set_flagsf32(state, readFloat32(state, src1, REG_SRC1) + readSDWord(state, src2, REG_SRC2)); break;
                case OP_DATA_FLOAT_sub: target.asFloat32 = set_flagsf32(state, readFloat32(state, src1, REG_SRC1) - readSDWord(state, src2, REG_SRC2)); break;
                case OP_DATA_FLOAT_mul: target.asFloat32 = set_flagsf32(state, readFloat32(state, src1, REG_SRC1) * readSDWord(state, src2, REG_SRC2)); break;
                case OP_DATA_FLOAT_div: target.asFloat32 = set_flagsf32(state, readFloat32(state, src1, REG_SRC1) / readSDWord(state, src2, REG_SRC2)); break;
                case OP_DATA_FLOAT_mod: target.asFloat32 = set_flagsf32(state, fmod(readFloat32(state, src1, REG_SRC1), readSDWord(state, src2, REG_SRC2))); break;
                case OP_DATA_FLOAT_f2i: target.asFloat32 = set_flagsf32(state, (Float32_t) readSDWord(state, src1, REG_SRC1)); break;
                case OP_DATA_FLOAT_sin: target.asFloat32 = set_flagsf32(state, sinf(readSDWord(state, src1, REG_SRC1))); break;
                case OP_DATA_FLOAT_sqrt: target.asFloat32 = set_flagsf32(state, sqrtf(readSDWord(state, src1, REG_SRC1))); break;
                default: raise(SIGILL);
            }
        } else {
            switch (ins.type_data_fpu.op) {
                case OP_DATA_FLOAT_add: target.asFloat32 = set_flagsf32(state, readFloat32(state, src1, REG_SRC1) + readFloat32(state, src2, REG_SRC2)); break;
                case OP_DATA_FLOAT_sub: target.asFloat32 = set_flagsf32(state, readFloat32(state, src1, REG_SRC1) - readFloat32(state, src2, REG_SRC2)); break;
                case OP_DATA_FLOAT_mul: target.asFloat32 = set_flagsf32(state, readFloat32(state, src1, REG_SRC1) * readFloat32(state, src2, REG_SRC2)); break;
                case OP_DATA_FLOAT_div: target.asFloat32 = set_flagsf32(state, readFloat32(state, src1, REG_SRC1) / readFloat32(state, src2, REG_SRC2)); break;
                case OP_DATA_FLOAT_mod: target.asFloat32 = set_flagsf32(state, fmod(readFloat32(state, src1, REG_SRC1), readFloat32(state, src2, REG_SRC2))); break;
                case OP_DATA_FLOAT_f2i: target.asSDWord = set_flags32(state, (SDWord_t) readFloat32(state, src1, REG_SRC1)); break;
                case OP_DATA_FLOAT_sin: target.asFloat32 = set_flagsf32(state, sinf(readFloat32(state, src1, REG_SRC1))); break;
                case OP_DATA_FLOAT_sqrt: target.asFloat32 = set_flagsf32(state, sqrtf(readFloat32(state, src1, REG_SRC1))); break;
                case OP_DATA_FLOAT_s2f: target.asFloat32 = set_flagsf32(state, (Float32_t) readFloat32(state, src1, REG_SRC1)); break;
                default: raise(SIGILL);
            }
        }
    } else {
        if (ins.type_data_fpu.use_int_arg2) {
            switch (ins.type_data_fpu.op) {
                case OP_DATA_FLOAT_add: target.asFloat64 = set_flagsf64(state, readFloat64(state, src1, REG_SRC1) + readSQWord(state, src2, REG_SRC2)); break;
                case OP_DATA_FLOAT_sub: target.asFloat64 = set_flagsf64(state, readFloat64(state, src1, REG_SRC1) - readSQWord(state, src2, REG_SRC2)); break;
                case OP_DATA_FLOAT_mul: target.asFloat64 = set_flagsf64(state, readFloat64(state, src1, REG_SRC1) * readSQWord(state, src2, REG_SRC2)); break;
                case OP_DATA_FLOAT_div: target.asFloat64 = set_flagsf64(state, readFloat64(state, src1, REG_SRC1) / readSQWord(state, src2, REG_SRC2)); break;
                case OP_DATA_FLOAT_mod: target.asFloat64 = set_flagsf64(state, fmod(readFloat64(state, src1, REG_SRC1), readSQWord(state, src2, REG_SRC2))); break;
                case OP_DATA_FLOAT_f2i: target.asFloat64 = set_flagsf64(state, (Float64_t) readSQWord(state, src1, REG_SRC1)); break;
                case OP_DATA_FLOAT_sin: target.asFloat64 = set_flagsf64(state, sin(readSQWord(state, src1, REG_SRC1))); break;
                case OP_DATA_FLOAT_sqrt: target.asFloat64 = set_flagsf64(state, sqrt(readSQWord(state, src1, REG_SRC1))); break;
                default: raise(SIGILL);
            }
        } else {
            switch (ins.type_data_fpu.op) {
                case OP_DATA_FLOAT_add: target.asFloat64 = set_flagsf64(state, readFloat64(state, src1, REG_SRC1) + readFloat64(state, src2, REG_SRC2)); break;
                case OP_DATA_FLOAT_sub: target.asFloat64 = set_flagsf64(state, readFloat64(state, src1, REG_SRC1) - readFloat64(state, src2, REG_SRC2)); break;
                case OP_DATA_FLOAT_mul: target.asFloat64 = set_flagsf64(state, readFloat64(state, src1, REG_SRC1) * readFloat64(state, src2, REG_SRC2)); break;
                case OP_DATA_FLOAT_div: target.asFloat64 = set_flagsf64(state, readFloat64(state, src1, REG_SRC1) / readFloat64(state, src2, REG_SRC2)); break;
                case OP_DATA_FLOAT_mod: target.asFloat64 = set_flagsf64(state, fmod(readFloat64(state, src1, REG_SRC1), readFloat64(state, src2, REG_SRC2))); break;
                case OP_DATA_FLOAT_f2i: target.asSQWord = set_flags64(state, (SQWord_t) readFloat64(state, src1, REG_SRC1)); break;
                case OP_DATA_FLOAT_sin: target.asFloat64 = set_flagsf64(state, sin(readFloat64(state, src1, REG_SRC1))); break;
                case OP_DATA_FLOAT_sqrt: target.asFloat64 = set_flagsf64(state, sqrt(readFloat64(state, src1, REG_SRC1))); break;
                case OP_DATA_FLOAT_s2f: target.asFloat64 = set_flagsf64(state, (Float64_t) readFloat64(state, src1, REG_SRC1)); break;
                default: raise(SIGILL);
            }
        }
    }
    if (ins.type_data_fpu.is_single_op) {
        writeFloat32(state, ins.type_data_fpu.r1, target.asFloat32, ins.type_data_fpu.no_writeback == 0, REG_DEST);
    } else {
        writeFloat64(state, ins.type_data_fpu.r1, target.asFloat64, ins.type_data_fpu.no_writeback == 0, REG_DEST);
    }
END_OP
BEGIN_OP(data_vpu)
    extern hive_executor_t vpu_execs[];
    vpu_execs[ins.type_data_vpu.op](ins, state);
END_OP

BEGIN_OP(data_bit)
    uint8_t lowest;
    uint8_t num;
    lowest = ins.type_data_bit.start;
    num = (ins.type_data_bit.count_hi << 1 | ins.type_data_bit.count_lo) + 1;
    uint64_t mask = ((1ULL << num) - 1);
    if (ins.type_data_bit.is_dep) {
        QWord_t val = readQWord(state, ins.type_data_bit.r1, REG_DEST);
        val &= ~(mask << lowest);
        val |= (readQWord(state, ins.type_data_bit.r2, REG_SRC1) & mask) << lowest;
        writeQWord(state, ins.type_data_bit.r1, val, 1, REG_DEST);
    } else {
        uint64_t val = (readQWord(state, ins.type_data_bit.r2, REG_SRC1) >> lowest) & mask;
        uint64_t sign_bit = val & (1ULL << (num - 1));
        val |= ins.type_data_bit.extend * (-sign_bit);
        writeQWord(state, ins.type_data_bit.r1, val, 1, REG_DEST);
    }
END_OP
BEGIN_OP(data_ls)
    QWord_t addr;
    uint8_t r1 = ins.type_data_ls_imm.r1;
    uint8_t r2 = ins.type_data_ls_imm.r2;
    if (ins.type_data_ls_imm.data_op == SUBOP_DATA_LS_FAR) {
        uint32_t imm = ins.type_data_ls_far.imm;
        uint32_t shift = ins.type_data_ls_far.shift + 1;
        if (ins.type_data_ls_far.update_ptr) {
            if (ins.type_data_ls_far.is_store) {
                QWord_t val = readQWord(state, r2, REG_SRC1) + (imm << shift);
                writeQWord(state, r2, val, 1, REG_SRC1);
                addr = val;
            } else {
                QWord_t val = readQWord(state, r2, REG_SRC1);
                addr = val;
                writeQWord(state, r2, val + (imm << shift), 1, REG_SRC1);
            }
        } else {
            addr = (readQWord(state, r2, REG_SRC1) + (imm << shift));
        }
    } else if (ins.type_data_ls_imm.use_immediate) {
        if (ins.type_data_ls_imm.update_ptr) {
            if (ins.type_data_ls_imm.is_store) {
                QWord_t val = readQWord(state, r2, REG_SRC1) + ins.type_data_ls_imm.imm;
                writeQWord(state, r2, val, 1, REG_SRC1);
                addr = val;
            } else {
                QWord_t val = readQWord(state, r2, REG_SRC1);
                addr = val;
                writeQWord(state, r2, val + ins.type_data_ls_imm.imm, 1, REG_SRC1);
            }
        } else {
            addr = (readQWord(state, r2, REG_SRC1) + ins.type_data_ls_imm.imm);
        }
    } else {
        uint8_t r3 = ins.type_data_ls_reg.r3;
        if (ins.type_data_ls_imm.update_ptr) {
            if (ins.type_data_ls_imm.is_store) {
                QWord_t val = readQWord(state, r2, REG_SRC1) + readQWord(state, r3, REG_SRC2);
                writeQWord(state, r2, val, 1, REG_SRC1);
                addr = val;
            } else {
                QWord_t val = readQWord(state, r2, REG_SRC1);
                addr = val;
                writeQWord(state, r2, val + readQWord(state, r3, REG_SRC2), 1, REG_SRC1);
            }
        } else {
            addr = (readQWord(state, r2, REG_SRC1) + readQWord(state, r3, REG_SRC2));
        }
    }
    if (ins.type_data_ls_imm.is_store) {
        switch (state->cr[CR_FLAGS].asFlags.size) {
            case SIZE_8BIT: memWriteByte(state, (void*) addr, readByte(state, r1, REG_DEST)); break;
            case SIZE_16BIT: memWriteWord(state, (void*) addr, readWord(state, r1, REG_DEST)); break;
            case SIZE_32BIT: memWriteDWord(state, (void*) addr, readDWord(state, r1, REG_DEST)); break;
            case SIZE_64BIT: memWriteQWord(state, (void*) addr, readQWord(state, r1, REG_DEST)); break;
        }
    } else {
        switch (state->cr[CR_FLAGS].asFlags.size) {
            case SIZE_8BIT: writeByte(state, r1, memReadByte(state, (void*) addr), 1, REG_DEST); break;
            case SIZE_16BIT: writeDWord(state, r1, memReadDWord(state, (void*) addr), 1, REG_DEST); break;
            case SIZE_32BIT: writeWord(state, r1, memReadWord(state, (void*) addr), 1, REG_DEST); break;
            case SIZE_64BIT: writeQWord(state, r1, memReadQWord(state, (void*) addr), 1, REG_DEST); break;
        }
    }
END_OP
BEGIN_OP(data_cswap)
    int check_condition1(uint8_t cond, hive_flag_register_t fr);
    uint8_t r2 = ins.type_data_cswap.r2;
    uint8_t r3 = ins.type_data_cswap.r3;
    uint8_t dest;
    uint8_t destC;
    if (check_condition1(ins.type_data_cswap.cond, state->cr[CR_FLAGS].asFlags)) {
        dest = r2;
        destC = REG_SRC1;
    } else {
        dest = r3;
        destC = REG_SRC2;
    }
    switch (state->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(state, ins.type_data_cswap.r1, readByte(state, dest, destC), 1, REG_DEST); break;
        case SIZE_16BIT: writeWord(state, ins.type_data_cswap.r1, readWord(state, dest, destC), 1, REG_DEST); break;
        case SIZE_32BIT: writeDWord(state, ins.type_data_cswap.r1, readDWord(state, dest, destC), 1, REG_DEST); break;
        case SIZE_64BIT: writeQWord(state, ins.type_data_cswap.r1, readQWord(state, dest, destC), 1, REG_DEST); break;
    }
END_OP
BEGIN_OP(data_xchg)
    uint8_t r1 = ins.type_data_xchg.r1;
    uint8_t r2 = ins.type_data_xchg.r2;
    switch (state->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: {
                Byte_t tmp = readByte(state, r1, REG_DEST);
                writeByte(state, r1, readByte(state, r2, REG_SRC1), 1, REG_DEST);
                writeByte(state, r2, tmp, 1, REG_SRC1);
            }
            break;
        case SIZE_16BIT: {
                Word_t tmp = readWord(state, r1, REG_DEST);
                writeWord(state, r1, readWord(state, r2, REG_SRC1), 1, REG_DEST);
                writeWord(state, r2, tmp, 1, REG_SRC1);
            }
            break;
        case SIZE_32BIT: {
                DWord_t tmp = readDWord(state, r1, REG_DEST);
                writeDWord(state, r1, readDWord(state, r2, REG_SRC1), 1, REG_DEST);
                writeDWord(state, r2, tmp, 1, REG_SRC1);
            }
            break;
        case SIZE_64BIT: {
                QWord_t tmp = readQWord(state, r1, REG_DEST);
                writeQWord(state, r1, readQWord(state, r2, REG_SRC1), 1, REG_DEST);
                writeQWord(state, r2, tmp, 1, REG_SRC1);
            }
            break;
    }
END_OP

BEGIN_OP(load_lea)
    writeQWord(state, ins.type_load_signed.r1, PC_REL(ins.type_load_signed.imm), 1, REG_DEST);
END_OP
BEGIN_OP(load_movzk)
    QWord_t shift = (16 * ins.type_load_mov.shift);
    QWord_t mask = ~ROL((QWord_t) 0xFFFF, shift);
    QWord_t value = ((QWord_t) ins.type_load_mov.imm) << shift;
    if (ins.type_load_mov.no_zero) {
        QWord_t val;
        switch (state->cr[CR_FLAGS].asFlags.size) {
            case SIZE_64BIT: val = readQWord(state, ins.type_load_mov.r1, REG_DEST); break;
            case SIZE_32BIT: val = readDWord(state, ins.type_load_mov.r1, REG_DEST); break;
            case SIZE_16BIT: val = readWord(state, ins.type_load_mov.r1, REG_DEST); break;
            case SIZE_8BIT: val = readByte(state, ins.type_load_mov.r1, REG_DEST); break;
        }
        val &= mask;
        val |= value;
        switch (state->cr[CR_FLAGS].asFlags.size) {
            case SIZE_64BIT: writeQWord(state, ins.type_load_mov.r1, val, 1, REG_DEST); break;
            case SIZE_32BIT: writeDWord(state, ins.type_load_mov.r1, val, 1, REG_DEST); break;
            case SIZE_16BIT: writeWord(state, ins.type_load_mov.r1, val, 1, REG_DEST); break;
            case SIZE_8BIT: writeByte(state, ins.type_load_mov.r1, val, 1, REG_DEST); break;
        }
    } else {
        switch (state->cr[CR_FLAGS].asFlags.size) {
            case SIZE_64BIT: writeQWord(state, ins.type_load_mov.r1, value, 1, REG_DEST); break;
            case SIZE_32BIT: writeDWord(state, ins.type_load_mov.r1, value, 1, REG_DEST); break;
            case SIZE_16BIT: writeWord(state, ins.type_load_mov.r1, value, 1, REG_DEST); break;
            case SIZE_8BIT: writeByte(state, ins.type_load_mov.r1, value, 1, REG_DEST); break;
        }
    }
END_OP
BEGIN_OP(load_svc)
    state->r[0].asQWord = svcs[state->r[8].asQWord](
        state->r[0].asQWord,
        state->r[1].asQWord,
        state->r[2].asQWord,
        state->r[3].asQWord,
        state->r[4].asQWord,
        state->r[5].asQWord,
        state->r[6].asQWord,
        state->r[7].asQWord
    );
END_OP
BEGIN_OP(load_ls_off)
    QWord_t addr = PC_REL(ins.type_load_ls_off.imm);
    if (ins.type_load_ls_off.is_store) {
        switch (state->cr[CR_FLAGS].asFlags.size) {
            case SIZE_8BIT:  memWriteByte(state, (void*) addr, readByte(state, ins.type_load_ls_off.r1, REG_DEST)); break;
            case SIZE_16BIT: memWriteWord(state, (void*) addr, readWord(state, ins.type_load_ls_off.r1, REG_DEST)); break;
            case SIZE_32BIT: memWriteDWord(state, (void*) addr, readDWord(state, ins.type_load_ls_off.r1, REG_DEST)); break;
            case SIZE_64BIT: memWriteQWord(state, (void*) addr, readQWord(state, ins.type_load_ls_off.r1, REG_DEST)); break;
        }
    } else {
        uint8_t reg = ins.type_load_ls_off.r1;
        switch (state->cr[CR_FLAGS].asFlags.size) {
            case SIZE_8BIT:  writeByte(state, reg, memReadByte(state, (void*) addr), 1, REG_DEST); break;
            case SIZE_16BIT: writeWord(state, reg, memReadWord(state, (void*) addr), 1, REG_DEST); break;
            case SIZE_32BIT: writeDWord(state, reg, memReadDWord(state, (void*) addr), 1, REG_DEST); break;
            case SIZE_64BIT: writeQWord(state, reg, memReadQWord(state, (void*) addr), 1, REG_DEST); break;
        }
    }
END_OP

BEGIN_OP(other_cpuid)
    switch (state->r[0].asQWord) {
        case 0:
            state->r[0].asQWord = set_flags64(state, state->cr[CR_CPUID].asQWord);
            break;
        case 1:
            state->r[0].asQWord = set_flags64(state, state->cr[CR_CORES].asQWord);
            break;
        case 2:
            state->r[0].asQWord = set_flags64(state, state->cr[CR_THREADS].asQWord);
            break;
    }
END_OP

BEGIN_OP(other_privileged)
    switch (ins.type_other_priv.priv_op) {
        case SUBOP_OTHER_cpuid:     exec_other_cpuid(ins, state); break;
        default:                    raise(SIGILL); break;
    }
END_OP
BEGIN_OP(other_prefix)
    void exec_instr(hive_instruction_t ins, struct cpu_state* state);
    // save
    uint8_t old_size = state->cr[CR_FLAGS].asFlags.size;
    uint8_t old_overrides = state->cr[CR_FLAGS].asFlags.reg_state;
    uint8_t old_crs = state->cr[CR_FLAGS].asFlags.references_cr;
    uint8_t nz = state->cr[CR_FLAGS].asDWord & 0b11;

    // update
    state->cr[CR_FLAGS].asFlags.size = ins.type_other_prefix.size;
    state->cr[CR_FLAGS].asFlags.reg_state = ins.type_other_prefix.reg_override;
    state->cr[CR_FLAGS].asFlags.references_cr = ins.type_other_prefix.references_cr;
    state->r[REG_PC].asInstrPtr++;

    if (state->cr[CR_FLAGS].asFlags.size == SIZE_64BIT && state->cr[CR_FLAGS].asFlags.reg_state != 0) {
        state->cr[CR_FLAGS].asFlags.size = old_size;
        state->cr[CR_FLAGS].asFlags.reg_state = old_overrides;
        state->cr[CR_FLAGS].asFlags.references_cr = old_crs;
        raise(SIGILL);
    }
    
    // exec
    exec_instr(memReadhive_instruction(state, state->r[REG_PC].asInstrPtr), state);
    
    // restore
    state->cr[CR_FLAGS].asFlags.size = old_size;
    state->cr[CR_FLAGS].asFlags.reg_state = old_overrides;
    state->cr[CR_FLAGS].asFlags.references_cr = old_crs;
    if (ins.type_other_prefix.reset_flags) {
        state->cr[CR_FLAGS].asDWord &= ~0b11;
        state->cr[CR_FLAGS].asDWord |= nz;
    }
END_OP
BEGIN_OP(other_zeroupper)
    switch (state->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: {
            Byte_t value = readByte(state, ins.type_other_zeroupper.r1, REG_DEST);
            state->r[ins.type_other_zeroupper.r1].asQWord = 0;
            writeByte(state, ins.type_other_zeroupper.r1, value, 1, REG_DEST);
            break;
        }
        case SIZE_16BIT: {
            Word_t value = readWord(state, ins.type_other_zeroupper.r1, REG_DEST);
            state->r[ins.type_other_zeroupper.r1].asQWord = 0;
            writeWord(state, ins.type_other_zeroupper.r1, value, 1, REG_DEST);
            break;
        }
        case SIZE_32BIT: {
            DWord_t value = readDWord(state, ins.type_other_zeroupper.r1, REG_DEST);
            state->r[ins.type_other_zeroupper.r1].asQWord = 0;
            writeDWord(state, ins.type_other_zeroupper.r1, value, 1, REG_DEST);
            break;
        }
        case SIZE_64BIT: {
            raise(SIGILL);
        }
    }
END_OP

BEGIN_OP(branch)
    QWord_t target;
    if (ins.type_branch.is_reg) {
        target = readQWord(state, ins.type_branch_register.r1, REG_DEST);
    } else {
        target = PC_REL(ins.type_branch.offset);
    }
    if (ins.type_branch.link) {
        LINK();
    }
    if (target == state->r[31].asQWord) {
        sched_yield();
    }
    BRANCH(target);
END_OP
BEGIN_OP(data)
    switch (ins.type_data.data_op) {
        case SUBOP_DATA_ALU_I:  case_fallthrough;
        case SUBOP_DATA_ALU_R:  case_fallthrough;
        case SUBOP_DATA_SALU_I: case_fallthrough;
        case SUBOP_DATA_SALU_R: exec_data_alu(ins, state); break;
        case SUBOP_DATA_BDEP:   case_fallthrough;
        case SUBOP_DATA_BEXT:   exec_data_bit(ins, state); break;
        case SUBOP_DATA_LS:     case_fallthrough;
        case SUBOP_DATA_LS_FAR: exec_data_ls(ins, state); break;
        case SUBOP_DATA_FPU:    exec_data_fpu(ins, state); break;
        case SUBOP_DATA_VPU:    exec_data_vpu(ins, state); break;
        case SUBOP_DATA_CSWAP:  exec_data_cswap(ins, state); break;
        case SUBOP_DATA_XCHG:   exec_data_xchg(ins, state); break;
        default:                raise(SIGILL); break;
    }
END_OP
BEGIN_OP(load)
    switch (ins.type_load.op) {
        case OP_LOAD_lea:       exec_load_lea(ins, state); break;
        case OP_LOAD_movzk:     exec_load_movzk(ins, state); break;
        case OP_LOAD_svc:       exec_load_svc(ins, state); break;
        case OP_LOAD_ls_off:    exec_load_ls_off(ins, state); break;
        default:                raise(SIGILL); break;
    }
END_OP
BEGIN_OP(other)
    switch (ins.type_other.op) {
        case OP_OTHER_priv_op:  exec_other_privileged(ins, state); break;
        case OP_OTHER_prefix:   exec_other_prefix(ins, state); break;
        case OP_OTHER_zeroupper:exec_other_zeroupper(ins, state); break;
        default:                raise(SIGILL); break;
    }
END_OP

#define vop_(_type, _what) for (size_t i = 0; i < sizeof(state->v[0].as ## _type) / sizeof(state->v[0].as ## _type[0]); i++) { \
    state->v[ins.type_data_vpu.v1].as ## _type[i] = state->v[ins.type_data_vpu.v2].as ## _type[i] _what state->v[ins.type_data_vpu.v3].as ## _type[i]; \
}
#define vop_as_(_type) for (size_t i = 0; i < sizeof(state->v[0].as ## _type) / sizeof(state->v[0].as ## _type[0]); i += 2) { \
    state->v[ins.type_data_vpu.v1].as ## _type[i] = state->v[ins.type_data_vpu.v2].as ## _type[i] + state->v[ins.type_data_vpu.v3].as ## _type[i]; \
    state->v[ins.type_data_vpu.v1].as ## _type[i + 1] = state->v[ins.type_data_vpu.v2].as ## _type[i + 1] - state->v[ins.type_data_vpu.v3].as ## _type[i + 1]; \
}
#define vop_madd_(_type) for (size_t i = 0; i < sizeof(state->v[0].as ## _type) / sizeof(state->v[0].as ## _type[0]); i++) { \
    state->v[ins.type_data_vpu.v1].as ## _type[i] = state->v[ins.type_data_vpu.v2].as ## _type[i] * state->v[ins.type_data_vpu.v3].as ## _type[i]; \
} \
for (size_t i = 0; i < sizeof(state->v[0].as ## _type) / sizeof(state->v[0].as ## _type[0]); i++) { \
    state->v[ins.type_data_vpu.v1].as ## _type[0] += state->v[ins.type_data_vpu.v1].as ## _type[i]; \
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

BEGIN_OP(vpu_add)
    switch (ins.type_data_vpu.mode) {
        case 0: vop(vpu_o, +); break;
        case 1: vop(vpu_b, +); break;
        case 2: vop(vpu_w, +); break;
        case 3: vop(vpu_d, +); break;
        case 4: vop(vpu_q, +); break;
        case 5: vop(vpu_l, +); break;
        case 6: vop(vpu_s, +); break;
        case 7: vop(vpu_f, +); break;
    }
END_OP
BEGIN_OP(vpu_sub)
    switch (ins.type_data_vpu.mode) {
        case 0: vop(vpu_o, -)
        case 1: vop(vpu_b, -)
        case 2: vop(vpu_w, -)
        case 3: vop(vpu_d, -)
        case 4: vop(vpu_q, -)
        case 5: vop(vpu_l, -)
        case 6: vop(vpu_s, -)
        case 7: vop(vpu_f, -)
    }
END_OP
BEGIN_OP(vpu_mul)
    switch (ins.type_data_vpu.mode) {
        case 0: vop(vpu_o, *)
        case 1: vop(vpu_b, *)
        case 2: vop(vpu_w, *)
        case 3: vop(vpu_d, *)
        case 4: vop(vpu_q, *)
        case 5: vop(vpu_l, *)
        case 6: vop(vpu_s, *)
        case 7: vop(vpu_f, *)
    }
END_OP
BEGIN_OP(vpu_div)
    switch (ins.type_data_vpu.mode) {
        case 0: vop(vpu_o, /)
        case 1: vop(vpu_b, /)
        case 2: vop(vpu_w, /)
        case 3: vop(vpu_d, /)
        case 4: vop(vpu_q, /)
        case 5: vop(vpu_l, /)
        case 6: vop(vpu_s, /)
        case 7: vop(vpu_f, /)
    }
END_OP
BEGIN_OP(vpu_addsub)
    switch (ins.type_data_vpu.mode) {
        case 0: vop_as(vpu_o)
        case 1: vop_as(vpu_d)
        case 2: vop_as(vpu_w)
        case 3: vop_as(vpu_d)
        case 4: vop_as(vpu_q)
        case 5: vop_as(vpu_l)
        case 6: vop_as(vpu_s)
        case 7: vop_as(vpu_f)
    }
END_OP
BEGIN_OP(vpu_madd)
    switch (ins.type_data_vpu.mode) {
        case 0: vop_madd(vpu_o)
        case 1: vop_madd(vpu_b)
        case 2: vop_madd(vpu_w)
        case 3: vop_madd(vpu_d)
        case 4: vop_madd(vpu_q)
        case 5: vop_madd(vpu_l)
        case 6: vop_madd(vpu_s)
        case 7: vop_madd(vpu_f)
    }
END_OP
uint8_t decode_slot(hive_instruction_t ins) {
    return ins.type_data_vpu_mov.slot_hi << 3 | ins.type_data_vpu_mov.slot_lo;
}
BEGIN_OP(vpu_mov)
    uint8_t slot = decode_slot(ins);
    switch (ins.type_data_vpu.mode) {
        case 0: state->v[ins.type_data_vpu_mov.v1].asQWord[slot] = readQWord(state, ins.type_data_vpu_mov.r2, REG_SRC1);
        case 1: state->v[ins.type_data_vpu_mov.v1].asBytes[slot] = readByte(state, ins.type_data_vpu_mov.r2, REG_SRC1);
        case 2: state->v[ins.type_data_vpu_mov.v1].asWords[slot] = readWord(state, ins.type_data_vpu_mov.r2, REG_SRC1);
        case 3: state->v[ins.type_data_vpu_mov.v1].asDWords[slot] = readDWord(state, ins.type_data_vpu_mov.r2, REG_SRC1);
        case 4: state->v[ins.type_data_vpu_mov.v1].asQWords[slot] = readQWord(state, ins.type_data_vpu_mov.r2, REG_SRC1);
        case 5: state->v[ins.type_data_vpu_mov.v1].asLWords[slot] = readQWord(state, ins.type_data_vpu_mov.r2, REG_SRC1);
        case 6: state->v[ins.type_data_vpu_mov.v1].asFloat32s[slot] = readFloat32(state, ins.type_data_vpu_mov.r2, REG_SRC1);
        case 7: state->v[ins.type_data_vpu_mov.v1].asFloat64s[slot] = readFloat64(state, ins.type_data_vpu_mov.r2, REG_SRC1);
    }
END_OP
BEGIN_OP(vpu_mov_vec)
    state->v[ins.type_data_vpu.v1] = state->v[ins.type_data_vpu.v2];
END_OP

#define vpu_conv_(_from, _to) { \
    uint8_t min = \
        sizeof(state->v[0].as ## _to) / sizeof(state->v[0].as ## _to[0]) < sizeof(state->v[0].as ## _from) / sizeof(state->v[0].as ## _from[0]) ? \
        sizeof(state->v[0].as ## _to) / sizeof(state->v[0].as ## _to[0]) : \
        sizeof(state->v[0].as ## _from) / sizeof(state->v[0].as ## _from[0]); \
    for (size_t i = 0; i < min; i++) { \
        state->v[ins.type_data_vpu_conv.v1].as ## _to[i] = state->v[ins.type_data_vpu_conv.v2].as ## _from[i]; \
    } \
}
#define vpu_conv2(_from, _to) vpu_conv_(_from, _to)
#define vpu_conv(_from) \
    switch (ins.type_data_vpu_conv.target_mode) { \
        case 0: vpu_conv2(_from, vpu_o) break; \
        case 1: vpu_conv2(_from, vpu_b) break; \
        case 2: vpu_conv2(_from, vpu_w) break; \
        case 3: vpu_conv2(_from, vpu_d) break; \
        case 4: vpu_conv2(_from, vpu_q) break; \
        case 5: vpu_conv2(_from, vpu_l) break; \
        case 6: vpu_conv2(_from, vpu_s) break; \
        case 7: vpu_conv2(_from, vpu_f) break; \
    }

BEGIN_OP(vpu_conv)
    switch (ins.type_data_vpu.mode) {
        case 0: vpu_conv(vpu_o)
        case 1: vpu_conv(vpu_b)
        case 2: vpu_conv(vpu_w)
        case 3: vpu_conv(vpu_d)
        case 4: vpu_conv(vpu_q)
        case 5: vpu_conv(vpu_l)
        case 6: vpu_conv(vpu_s)
        case 7: vpu_conv(vpu_f)
    }
END_OP

#define vpu_len_(_what) \
    do { \
        QWord_t count = 0; \
        for (size_t i = 0; sizeof(state->v[0].as ## _what) / sizeof(state->v[0].as ## _what[0]); i++) { \
            if (state->v[ins.type_data_vpu_len.v1].as ## _what[i]) { \
                count++; \
            } else { \
                break; \
            } \
        } \
        writeQWord(state, ins.type_data_vpu_len.r1, count, 1, REG_DEST); \
    } while (0)
#define vpu_len(_what) vpu_len_(_what)

BEGIN_OP(vpu_len)
    switch (ins.type_data_vpu.mode) {
        case 0: vpu_len(vpu_o);
        case 1: vpu_len(vpu_b);
        case 2: vpu_len(vpu_w);
        case 3: vpu_len(vpu_d);
        case 4: vpu_len(vpu_q);
        case 5: vpu_len(vpu_l);
        case 6: vpu_len(vpu_s);
        case 7: vpu_len(vpu_f);
    }
END_OP
BEGIN_OP(vpu_ldr)
    QWord_t addr;
    SQWord_t offset;
    if (ins.type_data_vpu_ls_imm.use_imm) {
        offset = ins.type_data_vpu_ls_imm.imm;
    } else {
        offset = readSQWord(state, ins.type_data_vpu_ls.r2, REG_SRC2);
    }
    if (ins.type_data_vpu_ls.update_ptr) {
        addr = readQWord(state, ins.type_data_vpu_ls_imm.r1, REG_SRC1);
        writeQWord(state, ins.type_data_vpu_ls_imm.r1, addr + offset, 1, REG_SRC1);
    } else {
        addr = (readQWord(state, ins.type_data_vpu_ls_imm.r1, REG_SRC1) + offset);
    }
    state->v[ins.type_data_vpu_ls.v1] = memReadhive_vector_register(state, (void*) addr);
END_OP
BEGIN_OP(vpu_str)
    QWord_t addr;
    SQWord_t offset;
    if (ins.type_data_vpu_ls_imm.use_imm) {
        offset = ins.type_data_vpu_ls_imm.imm;
    } else {
        offset = readSQWord(state, ins.type_data_vpu_ls.r2, REG_SRC2);
    }
    if (ins.type_data_vpu_ls.update_ptr) {
        addr = readQWord(state, ins.type_data_vpu_ls_imm.r1, REG_SRC1) + offset;
        writeQWord(state, ins.type_data_vpu_ls_imm.r1, addr, 1, REG_SRC1);
    } else {
        addr = (readQWord(state, ins.type_data_vpu_ls_imm.r1, REG_SRC1) + offset);
    }
    memWritehive_vector_register(state, (void*) addr, state->v[ins.type_data_vpu_ls.v1]);
END_OP

hive_executor_t vpu_execs[] = {
    [OP_DATA_VPU_add] = exec_vpu_add,
    [OP_DATA_VPU_sub] = exec_vpu_sub,
    [OP_DATA_VPU_mul] = exec_vpu_mul,
    [OP_DATA_VPU_div] = exec_vpu_div,
    [OP_DATA_VPU_addsub] = exec_vpu_addsub,
    [OP_DATA_VPU_madd] = exec_vpu_madd,
    [OP_DATA_VPU_mov] = exec_vpu_mov,
    [OP_DATA_VPU_mov_vec] = exec_vpu_mov_vec,
    [OP_DATA_VPU_conv] = exec_vpu_conv,
    [OP_DATA_VPU_len] = exec_vpu_len,
    [OP_DATA_VPU_ldr] = exec_vpu_ldr,
    [OP_DATA_VPU_str] = exec_vpu_str,
};

void coredump(struct cpu_state* state);
char* dis(hive_instruction_t** ins, uint64_t addr);

void exec_instr(hive_instruction_t ins, struct cpu_state* state) {
    if (!check_condition(ins, state->cr[CR_FLAGS].asFlags)) return;
    switch (ins.generic.type) {
        case MODE_BRANCH: exec_branch(ins, state); break;
        case MODE_DATA:   exec_data(ins, state); break;
        case MODE_LOAD:   exec_load(ins, state); break;
        case MODE_OTHER:  exec_other(ins, state); break;
        default:          raise(SIGILL); break;
    }
}

int check_condition0(uint8_t ins, hive_flag_register_t fr) {
    switch (ins) {
        case FLAG_ALWAYS:   return 1;
        case FLAG_EQ:       return fr.zero;
        case FLAG_LE:       return fr.negative || fr.zero;
        case FLAG_LT:       return fr.negative;
    }
    return 0;
}

int check_condition1(uint8_t cond, hive_flag_register_t fr) {
    if (cond & FLAG_NOT) {
        return !check_condition0(cond & 0b11, fr);
    } else {
        return check_condition0(cond & 0b11, fr);
    }
}

int check_condition(hive_instruction_t ins, hive_flag_register_t fr) {
    return check_condition1(ins.generic.condition, fr);
}

__thread jmp_buf lidt;

int runstate(struct cpu_state* state) {
    size_t current_thread = 0;

    int sig = setjmp(lidt);
    if (sig) {
        fprintf(stderr, "Fault on vcore #%llu: %s\n", state[current_thread].cr[CR_CPUID].asQWord, strsignal(sig));
        return sig;
    }
    while (1) {
        for (current_thread = 0; current_thread < THREAD_COUNT; current_thread++) {
            hive_instruction_t ins = memReadhive_instruction(state, state[current_thread].r[REG_PC].asInstrPtr);
            exec_instr(ins, &(state[current_thread]));
            state[current_thread].r[REG_PC].asInstrPtr++;
            state[current_thread].cr[CR_CYCLES].asQWord++;
        }
    }
}

void interrupt_handler(int sig) {
    longjmp(lidt, sig);
}

void exec(void* start) {
    for (uint16_t cpuid = 0; cpuid < CORE_COUNT * THREAD_COUNT; cpuid++) {
        state[cpuid].r[REG_PC].asPointer = start;
        state[cpuid].cr[CR_CPUID].asQWord = cpuid;
        state[cpuid].cr[CR_CORES].asQWord = CORE_COUNT;
        state[cpuid].cr[CR_THREADS].asQWord = THREAD_COUNT;
        state[cpuid].cr[CR_FLAGS].asFlags.size = SIZE_64BIT;
    }

    pthread_t cores[CORE_COUNT] = {0};

    signal(SIGABRT, interrupt_handler);
    signal(SIGILL, interrupt_handler);
    signal(SIGSEGV, interrupt_handler);
    signal(SIGBUS, interrupt_handler);

    for (uint16_t cpuid = 0; cpuid < CORE_COUNT * THREAD_COUNT; cpuid += THREAD_COUNT) {
        int ret = pthread_create(&(cores[cpuid / THREAD_COUNT]), NULL, (void*) &runstate, &(state[cpuid]));
        if (ret) {
            fprintf(stderr, "Could not create vcore #%hu: %s\n", cpuid, strerror(errno));
        }
    }
    sched_yield();
    for (uint16_t cpuid = 0; cpuid < CORE_COUNT * THREAD_COUNT; cpuid += THREAD_COUNT) {
        int ret_val = 0;
        int ret = pthread_join(cores[cpuid / THREAD_COUNT], (void*) &ret_val);
        if (ret) {
            fprintf(stderr, "failed to reattach vcode #%hu: %s\n", cpuid, strerror(errno));
        }
        if (ret_val) {
            fprintf(stderr, "vcore #%hu locked up/crashed abnormally: %d\n", cpuid, ret_val);
        }
    }
    exit(state[0].r[0].asQWord);
}
