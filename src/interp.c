#include <math.h>
#include <signal.h>
#include <pthread.h>
#include <setjmp.h>
#include <stdatomic.h>
#include <sys/mman.h>
#include <unistd.h>

#include "new_ops.h"

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
    state->cr[CR_FLAGS].asFlags.zero = (res == 0);
    state->cr[CR_FLAGS].asFlags.negative = (res < 0);
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

#define set_flags(state, res) _Generic((res), \
    uint64_t: set_flags64, int64_t: set_flags64, \
    uint32_t: set_flags32, int32_t: set_flags32, \
    uint16_t: set_flags16, int16_t: set_flags16, \
    uint8_t: set_flags8, int8_t: set_flags8, \
    float: set_flagsf32, double: set_flagsf64 \
)((state), (res))

#define PC_REL(what)                (ctx->r[REG_PC].asQWord + ((what) << 2))
#define PC_REL32(what)              (ctx->r[REG_PC].asDWord + ((what) << 2))
#define BRANCH(to)                  (ctx->r[REG_PC].asQWord = (QWord_t) ((to) - sizeof(DWord_t)))
#define BRANCH_RELATIVE(offset)     BRANCH(PC_REL(offset))
#define LINK()                      (ctx->r[REG_LR].asQWord = ctx->r[REG_PC].asQWord)

#define def_ror(type, size) type ror ## size(type a, type b) { return (((a) >> (b)) | ((a) << ((sizeof(a) << 3) - (b)))); }

void exec_instr(struct cpu_state* state, uint32_t ins);

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

static inline uint64_t swap_bytes_64(uint64_t x) {
#if __has_builtin(__builtin_bswap64)
return __builtin_bswap64(x);
#else
    return (((x >> 0) & 0xFF) << 56) |
           (((x >> 8) & 0xFF) << 48) |
           (((x >> 16) & 0xFF) << 40) |
           (((x >> 24) & 0xFF) << 32) |
           (((x >> 32) & 0xFF) << 24) |
           (((x >> 40) & 0xFF) << 16) |
           (((x >> 48) & 0xFF) << 8) |
           (((x >> 56) & 0xFF) << 0);
#endif
}
static inline uint32_t swap_bytes_32(uint32_t x) {
#if __has_builtin(__builtin_bswap32)
return __builtin_bswap32(x);
#else
    return (((x >> 0) & 0xFF) << 24) |
           (((x >> 8) & 0xFF) << 16) |
           (((x >> 16) & 0xFF) << 8) |
           (((x >> 24) & 0xFF) << 0);
#endif
}
static inline uint16_t swap_bytes_16(uint16_t x) {
#if __has_builtin(__builtin_bswap16)
return __builtin_bswap16(x);
#else
    return (((x >> 0) & 0xFF) << 8) |
           (((x >> 8) & 0xFF) << 0);
#endif
}

#define interrupt(i) longjmp(state->idt, (i))

static inline uint8_t swap_bytes_8(uint8_t x) {
    raise(SIGILL);
    return x;
}

#define swap_bytes(x) _Generic((x), int64_t: swap_bytes_64, uint64_t: swap_bytes_64, int32_t: swap_bytes_32, uint32_t: swap_bytes_32, int16_t: swap_bytes_16, uint16_t: swap_bytes_16, int8_t: swap_bytes_8, uint8_t: swap_bytes_8)((x))

#define INTENT_WRITE 1
#define INTENT_READ 0

#define reg_reader(_type) \
static inline _type ## _t read ## _type (struct cpu_state* state, uint8_t reg, uint8_t counter) { \
    if (unlikely(is_slot_overridden(state, counter))) { \
        return state->r[reg].as ## _type ## Pair.high; \
    } else { \
        return state->r[reg].as ## _type ## Pair.low; \
    } \
}
#define reg_writer(_type) \
static inline void write ## _type (struct cpu_state* state, uint8_t reg, _type ## _t val, uint8_t write, uint8_t counter) { \
    if (!write) return; \
    if (unlikely(is_slot_overridden(state, counter))) { \
        state->r[reg].as ## _type ## Pair.high = val; \
    } else { \
        state->r[reg].as ## _type ## Pair.low = val; \
    } \
}

extern svc_call svcs[];
struct cpu_state cpu_states[CORE_COUNT * THREAD_COUNT] = {0};
__thread jmp_buf lidt;

static inline bool is_slot_overridden(struct cpu_state* state, uint8_t counter) {
    return (state->cr[CR_FLAGS].asFlags.reg_state & (1 << counter)) != 0;
}

static inline void check_permissions(struct cpu_state* state, uint8_t mode) {
    if (unlikely(state->cr[CR_RUNLEVEL].asQWord > mode)) {
        interrupt(SIGTRAP);
    }
}

reg_reader(Byte)
reg_reader(Word)
reg_reader(DWord)
reg_reader(SByte)
reg_reader(SWord)
reg_reader(SDWord)
Float32_t readFloat32(struct cpu_state* state, uint8_t reg, uint8_t counter) {
    return state->r[reg].asFloat32;
}
Float64_t readFloat64(struct cpu_state* state, uint8_t reg, uint8_t counter) {
    return state->r[reg].asFloat64;
}
QWord_t readQWord(struct cpu_state* state, uint8_t reg, uint8_t counter) {
    return state->r[reg].asQWord;
}
SQWord_t readSQWord(struct cpu_state* state, uint8_t reg, uint8_t counter) {
    return state->r[reg].asSQWord;
}

QWord_t registerRead(struct cpu_state* state, uint8_t reg, uint8_t counter) {
    switch (state->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: return readByte(state, reg, counter);
        case SIZE_16BIT: return readWord(state, reg, counter);
        case SIZE_32BIT: return readDWord(state, reg, counter);
        case SIZE_64BIT: return readQWord(state, reg, counter);
    }
#if __has_builtin(__builtin_unreachable)
    __builtin_unreachable();
#else
    abort();
#endif
}

reg_writer(Byte)
reg_writer(Word)
reg_writer(DWord)
reg_writer(SByte)
reg_writer(SWord)
reg_writer(SDWord)
void writeFloat32(struct cpu_state* state, uint8_t reg, Float32_t val, uint8_t write, uint8_t counter) {
    if (write) {
        state->r[reg].asFloat32 = val;
    }
}
void writeFloat64(struct cpu_state* state, uint8_t reg, Float64_t val, uint8_t write, uint8_t counter) {
    if (write) {
        state->r[reg].asFloat64 = val;
    }
}
void writeQWord(struct cpu_state* state, uint8_t reg, QWord_t val, uint8_t write, uint8_t counter) {
    if (write) {
        state->r[reg].asQWord = val;
    }
}
void writeSQWord(struct cpu_state* state, uint8_t reg, SQWord_t val, uint8_t write, uint8_t counter) {
    if (write) {
        state->r[reg].asSQWord = val;
    }
}

void registerWrite(struct cpu_state* state, uint8_t reg, QWord_t val, uint8_t write, uint8_t counter) {
    switch (state->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(state, reg, val, write, counter); return;
        case SIZE_16BIT: writeWord(state, reg, val, write, counter); return;
        case SIZE_32BIT: writeDWord(state, reg, val, write, counter); return;
        case SIZE_64BIT: writeQWord(state, reg, val, write, counter); return;
    }
#if __has_builtin(__builtin_unreachable)
    __builtin_unreachable();
#else
    abort();
#endif
}

#define mem_reader(_type) \
_type ## _t memRead ## _type (struct cpu_state* state, void* addr) { \
    if (!authenticate_ptr(state, addr, sizeof(_type ## _t))) { \
        interrupt(SIGBUS); \
    } \
    return *(_type ## _t*) addr; \
}
#define mem_writer(_type) \
void memWrite ## _type (struct cpu_state* state, void* addr, _type ## _t val) { \
    if (!authenticate_ptr(state, addr, sizeof(_type ## _t))) { \
        interrupt(SIGBUS); \
    } \
    *(_type ## _t*) addr = val; \
}

bool authenticate_ptr(struct cpu_state* state, void* addr, size_t read_size) {
    bool aligned = ((uint64_t) addr % read_size) == 0;
    return aligned;
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

typedef struct cpu_state DisasContext;

static inline uint32_t deposit32(uint32_t value, int start, int length, uint32_t fieldval) {
    uint32_t mask;
    assert(start >= 0 && length > 0 && length <= 32 - start);
    mask = (~0U >> (32 - length)) << start;
    return (value & ~mask) | ((fieldval << start) & mask);
}

static inline uint64_t deposit64(uint64_t value, int start, int length, uint64_t fieldval) {
    uint64_t mask;
    assert(start >= 0 && length > 0 && length <= 64 - start);
    mask = (~0ULL >> (64 - length)) << start;
    return (value & ~mask) | ((fieldval << start) & mask);
}

static inline uint64_t extract64(uint64_t value, int start, int length) {
    assert(start >= 0 && length > 0 && length <= 64 - start);
    return (value >> start) & (~0ULL >> (64 - length));
}

static inline int64_t sextract64(uint64_t value, int start, int length) {
    assert(start >= 0 && length > 0 && length <= 64 - start);
    return ((int64_t)(value << (64 - length - start))) >> (64 - length);
}

static inline uint32_t extract32(uint32_t value, int start, int length) {
    assert(start >= 0 && length > 0 && length <= 32 - start);
    return (value >> start) & (~0U >> (32 - length));
}

static inline int32_t sextract32(uint32_t value, int start, int length) {
    assert(start >= 0 && length > 0 && length <= 32 - start);
    return ((int32_t)(value << (32 - length - start))) >> (32 - length);
}

#include "decode.h"

int check_condition0(uint8_t ins, hive_flag_register_t fr);

static bool trans_branch(DisasContext *ctx, arg_branch *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    BRANCH_RELATIVE(a->rel);
    return true;
}
static bool trans_branch_link(DisasContext *ctx, arg_branch_link *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    LINK();
    BRANCH_RELATIVE(a->rel);
    return true;
}
static bool trans_branch_reg(DisasContext *ctx, arg_branch_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    BRANCH(readQWord(ctx, a->r1, REG_DEST));
    return true;
}
static bool trans_branch_reg_link(DisasContext *ctx, arg_branch_reg_link *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    LINK();
    BRANCH(readQWord(ctx, a->r1, REG_DEST));
    return true;
}

#define ALU_R(_op) switch (ctx->cr[CR_FLAGS].asFlags.size) { \
        case SIZE_8BIT: writeByte(ctx, a->r1, set_flags(ctx, readByte(ctx, a->r2, REG_SRC1) _op readByte(ctx, a->r3, REG_SRC2)), 1, REG_DEST); break; \
        case SIZE_16BIT: writeWord(ctx, a->r1, set_flags(ctx, readWord(ctx, a->r2, REG_SRC1) _op readWord(ctx, a->r3, REG_SRC2)), 1, REG_DEST); break; \
        case SIZE_32BIT: writeDWord(ctx, a->r1, set_flags(ctx, readDWord(ctx, a->r2, REG_SRC1) _op readDWord(ctx, a->r3, REG_SRC2)), 1, REG_DEST); break; \
        case SIZE_64BIT: writeQWord(ctx, a->r1, set_flags(ctx, readQWord(ctx, a->r2, REG_SRC1) _op readQWord(ctx, a->r3, REG_SRC2)), 1, REG_DEST); break; \
    }
#define ALU_I(_op) switch (ctx->cr[CR_FLAGS].asFlags.size) { \
        case SIZE_8BIT: writeByte(ctx, a->r1, set_flags(ctx, readByte(ctx, a->r2, REG_SRC1) _op (Byte_t) a->imm8), 1, REG_DEST); break; \
        case SIZE_16BIT: writeWord(ctx, a->r1, set_flags(ctx, readWord(ctx, a->r2, REG_SRC1) _op (Word_t) a->imm8), 1, REG_DEST); break; \
        case SIZE_32BIT: writeDWord(ctx, a->r1, set_flags(ctx, readDWord(ctx, a->r2, REG_SRC1) _op (DWord_t) a->imm8), 1, REG_DEST); break; \
        case SIZE_64BIT: writeQWord(ctx, a->r1, set_flags(ctx, readQWord(ctx, a->r2, REG_SRC1) _op (QWord_t) a->imm8), 1, REG_DEST); break; \
    }
#define ALU_R_ROT(_rot) switch (ctx->cr[CR_FLAGS].asFlags.size) { \
        case SIZE_8BIT: writeByte(ctx, a->r1, set_flags(ctx, _rot(readByte(ctx, a->r2, REG_SRC1), readByte(ctx, a->r3, REG_SRC2))), 1, REG_DEST); break; \
        case SIZE_16BIT: writeWord(ctx, a->r1, set_flags(ctx, _rot(readWord(ctx, a->r2, REG_SRC1), readWord(ctx, a->r3, REG_SRC2))), 1, REG_DEST); break; \
        case SIZE_32BIT: writeDWord(ctx, a->r1, set_flags(ctx, _rot(readDWord(ctx, a->r2, REG_SRC1), readDWord(ctx, a->r3, REG_SRC2))), 1, REG_DEST); break; \
        case SIZE_64BIT: writeQWord(ctx, a->r1, set_flags(ctx, _rot(readQWord(ctx, a->r2, REG_SRC1), readQWord(ctx, a->r3, REG_SRC2))), 1, REG_DEST); break; \
    }
#define ALU_I_ROT(_rot) switch (ctx->cr[CR_FLAGS].asFlags.size) { \
        case SIZE_8BIT: writeByte(ctx, a->r1, set_flags(ctx, _rot(readByte(ctx, a->r2, REG_SRC1), (Byte_t) a->imm8)), 1, REG_DEST); break; \
        case SIZE_16BIT: writeWord(ctx, a->r1, set_flags(ctx, _rot(readWord(ctx, a->r2, REG_SRC1), (Word_t) a->imm8)), 1, REG_DEST); break; \
        case SIZE_32BIT: writeDWord(ctx, a->r1, set_flags(ctx, _rot(readDWord(ctx, a->r2, REG_SRC1), (DWord_t) a->imm8)), 1, REG_DEST); break; \
        case SIZE_64BIT: writeQWord(ctx, a->r1, set_flags(ctx, _rot(readQWord(ctx, a->r2, REG_SRC1), (QWord_t) a->imm8)), 1, REG_DEST); break; \
    }
#define ALU_R_DISC(_op) switch (ctx->cr[CR_FLAGS].asFlags.size) { \
        case SIZE_8BIT: set_flags(ctx, readByte(ctx, a->r2, REG_SRC1) _op readByte(ctx, a->r3, REG_SRC2)); break; \
        case SIZE_16BIT: set_flags(ctx, readWord(ctx, a->r2, REG_SRC1) _op readWord(ctx, a->r3, REG_SRC2)); break; \
        case SIZE_32BIT: set_flags(ctx, readDWord(ctx, a->r2, REG_SRC1) _op readDWord(ctx, a->r3, REG_SRC2)); break; \
        case SIZE_64BIT: set_flags(ctx, readQWord(ctx, a->r2, REG_SRC1) _op readQWord(ctx, a->r3, REG_SRC2)); break; \
    }
#define ALU_I_DISC(_op) switch (ctx->cr[CR_FLAGS].asFlags.size) { \
        case SIZE_8BIT: set_flags(ctx, readByte(ctx, a->r2, REG_SRC1) _op (Byte_t) a->imm8); break; \
        case SIZE_16BIT: set_flags(ctx, readWord(ctx, a->r2, REG_SRC1) _op (Word_t) a->imm8); break; \
        case SIZE_32BIT: set_flags(ctx, readDWord(ctx, a->r2, REG_SRC1) _op (DWord_t) a->imm8); break; \
        case SIZE_64BIT: set_flags(ctx, readQWord(ctx, a->r2, REG_SRC1) _op (QWord_t) a->imm8); break; \
    }
#define SALU_R(_op) switch (ctx->cr[CR_FLAGS].asFlags.size) { \
        case SIZE_8BIT: writeSByte(ctx, a->r1, set_flags(ctx, readSByte(ctx, a->r2, REG_SRC1) _op readSByte(ctx, a->r3, REG_SRC2)), 1, REG_DEST); break; \
        case SIZE_16BIT: writeSWord(ctx, a->r1, set_flags(ctx, readSWord(ctx, a->r2, REG_SRC1) _op readSWord(ctx, a->r3, REG_SRC2)), 1, REG_DEST); break; \
        case SIZE_32BIT: writeSDWord(ctx, a->r1, set_flags(ctx, readSDWord(ctx, a->r2, REG_SRC1) _op readSDWord(ctx, a->r3, REG_SRC2)), 1, REG_DEST); break; \
        case SIZE_64BIT: writeSQWord(ctx, a->r1, set_flags(ctx, readSQWord(ctx, a->r2, REG_SRC1) _op readSQWord(ctx, a->r3, REG_SRC2)), 1, REG_DEST); break; \
    }
#define SALU_I(_op) switch (ctx->cr[CR_FLAGS].asFlags.size) { \
        case SIZE_8BIT: writeSByte(ctx, a->r1, set_flags(ctx, readSByte(ctx, a->r2, REG_SRC1) _op (SByte_t) a->imm8), 1, REG_DEST); break; \
        case SIZE_16BIT: writeSWord(ctx, a->r1, set_flags(ctx, readSWord(ctx, a->r2, REG_SRC1) _op (SWord_t) a->imm8), 1, REG_DEST); break; \
        case SIZE_32BIT: writeSDWord(ctx, a->r1, set_flags(ctx, readSDWord(ctx, a->r2, REG_SRC1) _op (SDWord_t) a->imm8), 1, REG_DEST); break; \
        case SIZE_64BIT: writeSQWord(ctx, a->r1, set_flags(ctx, readSQWord(ctx, a->r2, REG_SRC1) _op (SQWord_t) a->imm8), 1, REG_DEST); break; \
    }

static bool trans_add_reg(DisasContext *ctx, arg_add_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_R(+);
    return true;
}
static bool trans_sub_reg(DisasContext *ctx, arg_sub_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_R(-);
    return true;
}
static bool trans_cmp_reg(DisasContext *ctx, arg_cmp_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_R_DISC(-);
    return true;
}
static bool trans_mul_reg(DisasContext *ctx, arg_mul_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_R(*);
    return true;
}
static bool trans_div_reg(DisasContext *ctx, arg_div_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_R(/);
    return true;
}
static bool trans_mod_reg(DisasContext *ctx, arg_mod_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_R(%);
    return true;
}
static bool trans_divs_reg(DisasContext *ctx, arg_divs_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    SALU_R(/);
    return true;
}
static bool trans_mods_reg(DisasContext *ctx, arg_mods_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    SALU_R(%);
    return true;
}
static bool trans_and_reg(DisasContext *ctx, arg_and_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_R(&)
    return true;
}
static bool trans_tst_reg(DisasContext *ctx, arg_tst_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_R_DISC(&)
    return true;
}
static bool trans_or_reg(DisasContext *ctx, arg_or_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_R(|)
    return true;
}
static bool trans_xor_reg(DisasContext *ctx, arg_xor_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_R(^)
    return true;
}
static bool trans_shl_reg(DisasContext *ctx, arg_shl_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_R(<<)
    return true;
}
static bool trans_shr_reg(DisasContext *ctx, arg_shr_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_R(>>)
    return true;
}
static bool trans_sar_reg(DisasContext *ctx, arg_sar_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    SALU_R(>>)
    return true;
}
static bool trans_rol_reg(DisasContext *ctx, arg_rol_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_R_ROT(ROL);
    return true;
}
static bool trans_ror_reg(DisasContext *ctx, arg_ror_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_R_ROT(ROR);
    return true;
}
static bool trans_add_imm(DisasContext *ctx, arg_add_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_I(+);
    return true;
}
static bool trans_sub_imm(DisasContext *ctx, arg_sub_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_I(-);
    return true;
}
static bool trans_cmp_imm(DisasContext *ctx, arg_cmp_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_I_DISC(-);
    return true;
}
static bool trans_mul_imm(DisasContext *ctx, arg_mul_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_I(*);
    return true;
}
static bool trans_div_imm(DisasContext *ctx, arg_div_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_I(/);
    return true;
}
static bool trans_mod_imm(DisasContext *ctx, arg_mod_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_I(%);
    return true;
}
static bool trans_divs_imm(DisasContext *ctx, arg_divs_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    SALU_I(/);
    return true;
}
static bool trans_mods_imm(DisasContext *ctx, arg_mods_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    SALU_I(%);
    return true;
}
static bool trans_and_imm(DisasContext *ctx, arg_and_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_I(&)
    return true;
}
static bool trans_tst_imm(DisasContext *ctx, arg_tst_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_I_DISC(&)
    return true;
}
static bool trans_or_imm(DisasContext *ctx, arg_or_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_I(|)
    return true;
}
static bool trans_xor_imm(DisasContext *ctx, arg_xor_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_I(^)
    return true;
}
static bool trans_ret(DisasContext *ctx, arg_ret *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ctx->r[REG_PC] = ctx->r[REG_LR];
    return true;
}
static bool trans_mov(DisasContext *ctx, arg_mov *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, set_flags(ctx, readByte(ctx, a->r2, REG_SRC1)), 1, REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, set_flags(ctx, readWord(ctx, a->r2, REG_SRC1)), 1, REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, set_flags(ctx, readDWord(ctx, a->r2, REG_SRC1)), 1, REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, set_flags(ctx, readQWord(ctx, a->r2, REG_SRC1)), 1, REG_DEST); break;
    }
    return true;
}
static bool trans_shl_imm(DisasContext *ctx, arg_shl_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_I(<<)
    return true;
}
static bool trans_shr_imm(DisasContext *ctx, arg_shr_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_I(>>)
    return true;
}
static bool trans_sar_imm(DisasContext *ctx, arg_sar_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    SALU_I(>>)
    return true;
}
static bool trans_rol_imm(DisasContext *ctx, arg_rol_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_I_ROT(ROL);
    return true;
}
static bool trans_ror_imm(DisasContext *ctx, arg_ror_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ALU_I_ROT(ROR);
    return true;
}
static bool trans_neg(DisasContext *ctx, arg_neg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeSByte(ctx, a->r1, -readSByte(ctx, a->r2, REG_SRC1), 1, REG_DEST); break;
        case SIZE_16BIT: writeSWord(ctx, a->r1, -readSWord(ctx, a->r2, REG_SRC1), 1, REG_DEST); break;
        case SIZE_32BIT: writeSDWord(ctx, a->r1, -readSDWord(ctx, a->r2, REG_SRC1), 1, REG_DEST); break;
        case SIZE_64BIT: writeSQWord(ctx, a->r1, -readSQWord(ctx, a->r2, REG_SRC1), 1, REG_DEST); break;
    }
    return true;
}
static bool trans_not(DisasContext *ctx, arg_not *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, ~readByte(ctx, a->r2, REG_SRC1), 1, REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, ~readWord(ctx, a->r2, REG_SRC1), 1, REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, ~readDWord(ctx, a->r2, REG_SRC1), 1, REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, ~readQWord(ctx, a->r2, REG_SRC1), 1, REG_DEST); break;
    }
    return true;
}
static bool trans_extend(DisasContext *ctx, arg_extend *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;

    if (a->to <= a->from) {
        return false;
    }
    SQWord_t val;
    switch (a->from) {
        case SIZE_8BIT: val = readSByte(ctx, a->r2, REG_SRC1); break;
        case SIZE_16BIT: val = readSWord(ctx, a->r2, REG_SRC1); break;
        case SIZE_32BIT: val = readSDWord(ctx, a->r2, REG_SRC1); break;
        default: return false;
    }
    switch (a->to) {
        case SIZE_16BIT: writeSWord(ctx, a->r2, val, 1, REG_DEST); break;
        case SIZE_32BIT: writeSDWord(ctx, a->r2, val, 1, REG_DEST); break;
        case SIZE_64BIT: writeSQWord(ctx, a->r2, val, 1, REG_DEST); break;
        default: return false;
    }

    return true;
}
static bool trans_swe(DisasContext *ctx, arg_swe *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, swap_bytes(readByte(ctx, a->r2, REG_SRC1)), 1, REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, swap_bytes(readWord(ctx, a->r2, REG_SRC1)), 1, REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, swap_bytes(readDWord(ctx, a->r2, REG_SRC1)), 1, REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, swap_bytes(readQWord(ctx, a->r2, REG_SRC1)), 1, REG_DEST); break;
    }
    return true;
}
static bool trans_prefix(DisasContext *ctx, arg_prefix *a) {
    uint8_t old_size = ctx->cr[CR_FLAGS].asFlags.size;
    uint8_t old_overrides = ctx->cr[CR_FLAGS].asFlags.reg_state;
    uint8_t n = ctx->cr[CR_FLAGS].asFlags.negative;
    uint8_t z = ctx->cr[CR_FLAGS].asFlags.zero;

    // update
    ctx->cr[CR_FLAGS].asFlags.size = a->sz;
    ctx->cr[CR_FLAGS].asFlags.reg_state = a->reg_override;

    if (ctx->cr[CR_FLAGS].asFlags.size == SIZE_64BIT && ctx->cr[CR_FLAGS].asFlags.reg_state != 0) {
        ctx->cr[CR_FLAGS].asFlags.reg_state = old_overrides;
        raise(SIGILL);
    }
    
    // exec
    ctx->r[REG_PC].asInstrPtr++;
    exec_instr(ctx, *ctx->r[REG_PC].asDWordPtr);
    
    // restore
    ctx->cr[CR_FLAGS].asFlags.size = old_size;
    ctx->cr[CR_FLAGS].asFlags.reg_state = old_overrides;
    if (a->discard_flags) {
        ctx->cr[CR_FLAGS].asFlags.negative = n;
        ctx->cr[CR_FLAGS].asFlags.zero = z;
    }
    return true;
}
static bool trans_fadd(DisasContext *ctx, arg_fadd *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) + readFloat64(ctx, a->r3, REG_SRC2)), 1, REG_DEST);
    return true;
}
static bool trans_faddi(DisasContext *ctx, arg_faddi *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) + readSQWord(ctx, a->r3, REG_SRC2)), 1, REG_DEST);
    return true;
}
static bool trans_fsub(DisasContext *ctx, arg_fsub *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) - readFloat64(ctx, a->r3, REG_SRC2)), 1, REG_DEST);
    return true;
}
static bool trans_fsubi(DisasContext *ctx, arg_fsubi *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) - readSQWord(ctx, a->r3, REG_SRC2)), 1, REG_DEST);
    return true;
}
static bool trans_fcmp(DisasContext *ctx, arg_fcmp *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) - readFloat64(ctx, a->r3, REG_SRC2));
    return true;
}
static bool trans_fcmpi(DisasContext *ctx, arg_fcmpi *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) - readSQWord(ctx, a->r3, REG_SRC2));
    return true;
}
static bool trans_fmul(DisasContext *ctx, arg_fmul *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) * readFloat64(ctx, a->r3, REG_SRC2)), 1, REG_DEST);
    return true;
}
static bool trans_fmuli(DisasContext *ctx, arg_fmuli *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) * readSQWord(ctx, a->r3, REG_SRC2)), 1, REG_DEST);
    return true;
}
static bool trans_fdiv(DisasContext *ctx, arg_fdiv *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) / readFloat64(ctx, a->r3, REG_SRC2)), 1, REG_DEST);
    return true;
}
static bool trans_fdivi(DisasContext *ctx, arg_fdivi *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) / readSQWord(ctx, a->r3, REG_SRC2)), 1, REG_DEST);
    return true;
}
static bool trans_fmod(DisasContext *ctx, arg_fmod *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat64(ctx, a->r1, set_flags(ctx, fmod(readFloat64(ctx, a->r2, REG_SRC1), readFloat64(ctx, a->r3, REG_SRC2))), 1, REG_DEST);
    return true;
}
static bool trans_fmodi(DisasContext *ctx, arg_fmodi *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat64(ctx, a->r1, set_flags(ctx, fmod(readFloat64(ctx, a->r2, REG_SRC1), readSQWord(ctx, a->r3, REG_SRC2))), 1, REG_DEST);
    return true;
}
static bool trans_f2i(DisasContext *ctx, arg_f2i *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeSQWord(ctx, a->r1, readFloat64(ctx, a->r2, REG_SRC1), 1, REG_DEST);
    return true;
}
static bool trans_i2f(DisasContext *ctx, arg_i2f *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat64(ctx, a->r1, readSQWord(ctx, a->r2, REG_SRC1), 1, REG_DEST);
    return true;
}
static bool trans_fsin(DisasContext *ctx, arg_fsin *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat64(ctx, a->r1, set_flags(ctx, sin(readFloat64(ctx, a->r2, REG_SRC1))), 1, REG_DEST);
    return true;
}
static bool trans_fsini(DisasContext *ctx, arg_fsini *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat64(ctx, a->r1, set_flags(ctx, sin(readSQWord(ctx, a->r2, REG_SRC1))), 1, REG_DEST);
    return true;
}
static bool trans_fsqrt(DisasContext *ctx, arg_fsqrt *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat64(ctx, a->r1, set_flags(ctx, sqrt(readFloat64(ctx, a->r2, REG_SRC1))), 1, REG_DEST);
    return true;
}
static bool trans_fsqrti(DisasContext *ctx, arg_fsqrti *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat64(ctx, a->r1, set_flags(ctx, sqrt(readSQWord(ctx, a->r2, REG_SRC1))), 1, REG_DEST);
    return true;
}
static bool trans_sadd(DisasContext *ctx, arg_sadd *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) + readFloat32(ctx, a->r3, REG_SRC2)), 1, REG_DEST);
    return true;
}
static bool trans_saddi(DisasContext *ctx, arg_saddi *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) + readSDWord(ctx, a->r3, REG_SRC2)), 1, REG_DEST);
    return true;
}
static bool trans_ssub(DisasContext *ctx, arg_ssub *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) - readFloat32(ctx, a->r3, REG_SRC2)), 1, REG_DEST);
    return true;
}
static bool trans_ssubi(DisasContext *ctx, arg_ssubi *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) - readSDWord(ctx, a->r3, REG_SRC2)), 1, REG_DEST);
    return true;
}
static bool trans_scmp(DisasContext *ctx, arg_scmp *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) - readFloat32(ctx, a->r3, REG_SRC2));
    return true;
}
static bool trans_scmpi(DisasContext *ctx, arg_scmpi *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) - readSDWord(ctx, a->r3, REG_SRC2));
    return true;
}
static bool trans_smul(DisasContext *ctx, arg_smul *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) * readFloat32(ctx, a->r3, REG_SRC2)), 1, REG_DEST);
    return true;
}
static bool trans_smuli(DisasContext *ctx, arg_smuli *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) * readSDWord(ctx, a->r3, REG_SRC2)), 1, REG_DEST);
    return true;
}
static bool trans_sdiv(DisasContext *ctx, arg_sdiv *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) / readFloat32(ctx, a->r3, REG_SRC2)), 1, REG_DEST);
    return true;
}
static bool trans_sdivi(DisasContext *ctx, arg_sdivi *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) / readSDWord(ctx, a->r3, REG_SRC2)), 1, REG_DEST);
    return true;
}
static bool trans_smod(DisasContext *ctx, arg_smod *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat32(ctx, a->r1, set_flags(ctx, fmod(readFloat32(ctx, a->r2, REG_SRC1), readFloat32(ctx, a->r3, REG_SRC2))), 1, REG_DEST);
    return true;
}
static bool trans_smodi(DisasContext *ctx, arg_smodi *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat32(ctx, a->r1, set_flags(ctx, fmod(readFloat32(ctx, a->r2, REG_SRC1), readSDWord(ctx, a->r3, REG_SRC2))), 1, REG_DEST);
    return true;
}
static bool trans_s2i(DisasContext *ctx, arg_s2i *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeSQWord(ctx, a->r1, readFloat32(ctx, a->r2, REG_SRC1), 1, REG_DEST);
    return true;
}
static bool trans_i2s(DisasContext *ctx, arg_i2s *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat32(ctx, a->r1, readSDWord(ctx, a->r2, REG_SRC1), 1, REG_DEST);
    return true;
}
static bool trans_ssin(DisasContext *ctx, arg_ssin *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat32(ctx, a->r1, set_flags(ctx, sin(readFloat32(ctx, a->r2, REG_SRC1))), 1, REG_DEST);
    return true;
}
static bool trans_ssini(DisasContext *ctx, arg_ssini *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat32(ctx, a->r1, set_flags(ctx, sin(readSDWord(ctx, a->r2, REG_SRC1))), 1, REG_DEST);
    return true;
}
static bool trans_ssqrt(DisasContext *ctx, arg_ssqrt *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat32(ctx, a->r1, set_flags(ctx, sqrt(readFloat32(ctx, a->r2, REG_SRC1))), 1, REG_DEST);
    return true;
}
static bool trans_ssqrti(DisasContext *ctx, arg_ssqrti *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat32(ctx, a->r1, set_flags(ctx, sqrt(readSDWord(ctx, a->r2, REG_SRC1))), 1, REG_DEST);
    return true;
}
static bool trans_s2f(DisasContext *ctx, arg_s2f *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1)), 1, REG_DEST);
    return true;
}
static bool trans_f2s(DisasContext *ctx, arg_f2s *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1)), 1, REG_DEST);
    return true;
}
static bool trans_cpuid(DisasContext *ctx, arg_cpuid *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    check_permissions(ctx, EM_SUPERVISOR);
    switch (ctx->r[0].asQWord) {
        case 0:
            ctx->r[0].asQWord = ctx->cr[CR_CPUID].asQWord;
            break;
        case 1:
            ctx->r[0].asQWord = ctx->cr[CR_CORES].asQWord;
            break;
        case 2:
            ctx->r[0].asQWord = ctx->cr[CR_THREADS].asQWord;
            break;
    }
    return true;
}
static bool trans_zeroupper(DisasContext *ctx, arg_zeroupper *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: {
            Byte_t value = readByte(ctx, a->r1, REG_DEST);
            ctx->r[a->r1].asQWord = 0;
            writeByte(ctx, a->r1, value, 1, REG_DEST);
            break;
        }
        case SIZE_16BIT: {
            Word_t value = readWord(ctx, a->r1, REG_DEST);
            ctx->r[a->r1].asQWord = 0;
            writeWord(ctx, a->r1, value, 1, REG_DEST);
            break;
        }
        case SIZE_32BIT: {
            DWord_t value = readDWord(ctx, a->r1, REG_DEST);
            ctx->r[a->r1].asQWord = 0;
            writeDWord(ctx, a->r1, value, 1, REG_DEST);
            break;
        }
        default: return false;
    }
    return true;
}
static bool trans_sret(DisasContext *ctx, arg_sret *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    check_permissions(ctx, EM_SUPERVISOR);
    ctx->r[REG_PC].asQWord = ctx->r[REG_LR].asQWord;
    ctx->cr[CR_RUNLEVEL].asQWord = EM_USER;
    return true;
}
static bool trans_hret(DisasContext *ctx, arg_hret *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    check_permissions(ctx, EM_HYPERVISOR);
    ctx->r[REG_PC].asQWord = ctx->r[REG_LR].asQWord;
    ctx->cr[CR_RUNLEVEL].asQWord = EM_SUPERVISOR;
    return true;
}
static bool trans_iret(DisasContext *ctx, arg_iret *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    check_permissions(ctx, EM_HYPERVISOR);
    ctx->r[REG_PC].asQWord = ctx->r[REG_SP].asQWordPtr[0] - sizeof(hive_instruction_t);
    ctx->cr[CR_RUNLEVEL].asQWord = ctx->r[REG_SP].asQWordPtr[1];
    ctx->r[REG_SP].asQWord += 16;
    return true;
}
static bool trans_svc(DisasContext *ctx, arg_svc *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ctx->r[0].asQWord = svcs[ctx->r[8].asQWord](
        ctx->r[0].asQWord,
        ctx->r[1].asQWord,
        ctx->r[2].asQWord,
        ctx->r[3].asQWord,
        ctx->r[4].asQWord,
        ctx->r[5].asQWord,
        ctx->r[6].asQWord,
        ctx->r[7].asQWord
    );
    return true;
}
static bool trans_mov_cr_r(DisasContext *ctx, arg_mov_cr_r *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ctx->cr[a->cr1] = ctx->r[a->r1];
    return true;
}
static bool trans_mov_r_cr(DisasContext *ctx, arg_mov_r_cr *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ctx->r[a->r1] = ctx->cr[a->cr1];
    return true;
}
static bool trans_lea(DisasContext *ctx, arg_lea *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeQWord(ctx, a->r1, PC_REL(a->rel), 1, REG_DEST);
    return true;
}
static bool trans_movz_0(DisasContext *ctx, arg_movz_0 *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeQWord(ctx, a->r1, set_flags(ctx, ((QWord_t) a->imm) << 0), 1, REG_DEST);
    return true;
}
static bool trans_movz_16(DisasContext *ctx, arg_movz_16 *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeQWord(ctx, a->r1, set_flags(ctx, ((QWord_t) a->imm) << 16), 1, REG_DEST);
    return true;
}
static bool trans_movz_32(DisasContext *ctx, arg_movz_32 *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeQWord(ctx, a->r1, set_flags(ctx, ((QWord_t) a->imm) << 32), 1, REG_DEST);
    return true;
}
static bool trans_movz_48(DisasContext *ctx, arg_movz_48 *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    writeQWord(ctx, a->r1, set_flags(ctx, ((QWord_t) a->imm) << 48), 1, REG_DEST);
    return true;
}
static bool trans_movk_0(DisasContext *ctx, arg_movk_0 *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t val = readQWord(ctx, a->r1, REG_DEST);
    val &= 0xFFFFFFFFFFFF0000;
    val |= ((QWord_t) a->imm) << 0;
    writeQWord(ctx, a->r1, set_flags(ctx, val), 1, REG_DEST);
    return true;
}
static bool trans_movk_16(DisasContext *ctx, arg_movk_16 *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t val = readQWord(ctx, a->r1, REG_DEST);
    val &= 0xFFFFFFFF0000FFFF;
    val |= ((QWord_t) a->imm) << 16;
    writeQWord(ctx, a->r1, set_flags(ctx, val), 1, REG_DEST);
    return true;
}
static bool trans_movk_32(DisasContext *ctx, arg_movk_32 *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t val = readQWord(ctx, a->r1, REG_DEST);
    val &= 0xFFFF0000FFFFFFFF;
    val |= ((QWord_t) a->imm) << 32;
    writeQWord(ctx, a->r1, set_flags(ctx, val), 1, REG_DEST);
    return true;
}
static bool trans_movk_48(DisasContext *ctx, arg_movk_48 *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t val = readQWord(ctx, a->r1, REG_DEST);
    val &= 0x0000FFFFFFFFFFFF;
    val |= ((QWord_t) a->imm) << 48;
    writeQWord(ctx, a->r1, set_flags(ctx, val), 1, REG_DEST);
    return true;
}
static bool trans_ldr_reg(DisasContext *ctx, arg_ldr_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t addr = readQWord(ctx, a->r2, REG_SRC1) + (readQWord(ctx, a->r3, REG_SRC2) << a->shift);
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, memReadByte(ctx, (void*) addr), 1, REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, memReadWord(ctx, (void*) addr), 1, REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, memReadDWord(ctx, (void*) addr), 1, REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, memReadQWord(ctx, (void*) addr), 1, REG_DEST); break;
    }
    return true;
}
static bool trans_ldr_reg_update(DisasContext *ctx, arg_ldr_reg_update *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t addr = readQWord(ctx, a->r2, REG_SRC1);
    writeQWord(ctx, a->r2, addr + (readQWord(ctx, a->r3, REG_SRC2) << a->shift), 1, REG_SRC1);
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, memReadByte(ctx, (void*) addr), 1, REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, memReadWord(ctx, (void*) addr), 1, REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, memReadDWord(ctx, (void*) addr), 1, REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, memReadQWord(ctx, (void*) addr), 1, REG_DEST); break;
    }
    return true;
}
static bool trans_ldr_imm(DisasContext *ctx, arg_ldr_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t addr = readQWord(ctx, a->r2, REG_SRC1) + a->imm;
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, memReadByte(ctx, (void*) addr), 1, REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, memReadWord(ctx, (void*) addr), 1, REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, memReadDWord(ctx, (void*) addr), 1, REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, memReadQWord(ctx, (void*) addr), 1, REG_DEST); break;
    }
    return true;
}
static bool trans_ldr_imm_update(DisasContext *ctx, arg_ldr_imm_update *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t addr = readQWord(ctx, a->r2, REG_SRC1);
    writeQWord(ctx, a->r2, addr + a->imm, 1, REG_SRC1);
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, memReadByte(ctx, (void*) addr), 1, REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, memReadWord(ctx, (void*) addr), 1, REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, memReadDWord(ctx, (void*) addr), 1, REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, memReadQWord(ctx, (void*) addr), 1, REG_DEST); break;
    }
    return true;
}
static bool trans_str_reg(DisasContext *ctx, arg_str_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t addr = readQWord(ctx, a->r2, REG_SRC1) + (readQWord(ctx, a->r3, REG_SRC2) << a->shift);
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: memWriteByte(ctx, (void*) addr, readByte(ctx, a->r1, REG_DEST)); break;
        case SIZE_16BIT: memWriteWord(ctx, (void*) addr, readWord(ctx, a->r1, REG_DEST)); break;
        case SIZE_32BIT: memWriteDWord(ctx, (void*) addr, readDWord(ctx, a->r1, REG_DEST)); break;
        case SIZE_64BIT: memWriteQWord(ctx, (void*) addr, readQWord(ctx, a->r1, REG_DEST)); break;
    }
    return true;
}
static bool trans_str_reg_update(DisasContext *ctx, arg_str_reg_update *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t addr = readQWord(ctx, a->r2, REG_SRC1);
    writeQWord(ctx, a->r2, addr += (readQWord(ctx, a->r3, REG_SRC2) << a->shift), 1, REG_SRC1);
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: memWriteByte(ctx, (void*) addr, readByte(ctx, a->r1, REG_DEST)); break;
        case SIZE_16BIT: memWriteWord(ctx, (void*) addr, readWord(ctx, a->r1, REG_DEST)); break;
        case SIZE_32BIT: memWriteDWord(ctx, (void*) addr, readDWord(ctx, a->r1, REG_DEST)); break;
        case SIZE_64BIT: memWriteQWord(ctx, (void*) addr, readQWord(ctx, a->r1, REG_DEST)); break;
    }
    return true;
}
static bool trans_str_imm(DisasContext *ctx, arg_str_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t addr = readQWord(ctx, a->r2, REG_SRC1) + a->imm;
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: memWriteByte(ctx, (void*) addr, readByte(ctx, a->r1, REG_DEST)); break;
        case SIZE_16BIT: memWriteWord(ctx, (void*) addr, readWord(ctx, a->r1, REG_DEST)); break;
        case SIZE_32BIT: memWriteDWord(ctx, (void*) addr, readDWord(ctx, a->r1, REG_DEST)); break;
        case SIZE_64BIT: memWriteQWord(ctx, (void*) addr, readQWord(ctx, a->r1, REG_DEST)); break;
    }
    return true;
}
static bool trans_str_imm_update(DisasContext *ctx, arg_str_imm_update *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t addr = readQWord(ctx, a->r2, REG_SRC1);
    writeQWord(ctx, a->r2, addr += a->imm, 1, REG_SRC1);
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: memWriteByte(ctx, (void*) addr, readByte(ctx, a->r1, REG_DEST)); break;
        case SIZE_16BIT: memWriteWord(ctx, (void*) addr, readWord(ctx, a->r1, REG_DEST)); break;
        case SIZE_32BIT: memWriteDWord(ctx, (void*) addr, readDWord(ctx, a->r1, REG_DEST)); break;
        case SIZE_64BIT: memWriteQWord(ctx, (void*) addr, readQWord(ctx, a->r1, REG_DEST)); break;
    }
    return true;
}
static bool trans_ldr_pc_rel(DisasContext *ctx, arg_ldr_pc_rel *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t addr = PC_REL(a->rel);
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, memReadByte(ctx, (void*) addr), 1, REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, memReadWord(ctx, (void*) addr), 1, REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, memReadDWord(ctx, (void*) addr), 1, REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, memReadQWord(ctx, (void*) addr), 1, REG_DEST); break;
    }
    return true;
}
static bool trans_str_pc_rel(DisasContext *ctx, arg_str_pc_rel *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t addr = PC_REL(a->rel);
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: memWriteByte(ctx, (void*) addr, readByte(ctx, a->r1, REG_DEST)); break;
        case SIZE_16BIT: memWriteWord(ctx, (void*) addr, readWord(ctx, a->r1, REG_DEST)); break;
        case SIZE_32BIT: memWriteDWord(ctx, (void*) addr, readDWord(ctx, a->r1, REG_DEST)); break;
        case SIZE_64BIT: memWriteQWord(ctx, (void*) addr, readQWord(ctx, a->r1, REG_DEST)); break;
    }
    return true;
}
static bool trans_ubxt(DisasContext *ctx, arg_ubxt *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, extract64(readByte(ctx, a->r2, REG_SRC1), a->start, a->count + 1), 1, REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, extract64(readWord(ctx, a->r2, REG_SRC1), a->start, a->count + 1), 1, REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, extract64(readDWord(ctx, a->r2, REG_SRC1), a->start, a->count + 1), 1, REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, extract64(readQWord(ctx, a->r2, REG_SRC1), a->start, a->count + 1), 1, REG_DEST); break;
    }
    return true;
}
static bool trans_sbxt(DisasContext *ctx, arg_sbxt *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeSByte(ctx, a->r1, sextract64(readByte(ctx, a->r2, REG_SRC1), a->start, a->count + 1), 1, REG_DEST); break;
        case SIZE_16BIT: writeSWord(ctx, a->r1, sextract64(readWord(ctx, a->r2, REG_SRC1), a->start, a->count + 1), 1, REG_DEST); break;
        case SIZE_32BIT: writeSDWord(ctx, a->r1, sextract64(readDWord(ctx, a->r2, REG_SRC1), a->start, a->count + 1), 1, REG_DEST); break;
        case SIZE_64BIT: writeSQWord(ctx, a->r1, sextract64(readQWord(ctx, a->r2, REG_SRC1), a->start, a->count + 1), 1, REG_DEST); break;
    }
    return true;
}
static bool trans_ubdp(DisasContext *ctx, arg_ubdp *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t val;
    QWord_t ins;
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: val = readByte(ctx, a->r1, REG_DEST); ins = readByte(ctx, a->r2, REG_SRC1); break;
        case SIZE_16BIT: val = readWord(ctx, a->r1, REG_DEST); ins = readWord(ctx, a->r2, REG_SRC1); break;
        case SIZE_32BIT: val = readDWord(ctx, a->r1, REG_DEST); ins = readDWord(ctx, a->r2, REG_SRC1); break;
        case SIZE_64BIT: val = readQWord(ctx, a->r1, REG_DEST); ins = readQWord(ctx, a->r2, REG_SRC1); break;
    }
    val = deposit64(val, a->start, a->count + 1, ins);
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, val, 1, REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, val, 1, REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, val, 1, REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, val, 1, REG_DEST); break;
    }
    return true;
}
static bool trans_sbdp(DisasContext *ctx, arg_sbdp *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t val;
    QWord_t ins;
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: val = readByte(ctx, a->r1, REG_DEST); ins = readByte(ctx, a->r2, REG_SRC1); break;
        case SIZE_16BIT: val = readWord(ctx, a->r1, REG_DEST); ins = readWord(ctx, a->r2, REG_SRC1); break;
        case SIZE_32BIT: val = readDWord(ctx, a->r1, REG_DEST); ins = readDWord(ctx, a->r2, REG_SRC1); break;
        case SIZE_64BIT: val = readQWord(ctx, a->r1, REG_DEST); ins = readQWord(ctx, a->r2, REG_SRC1); break;
    }
    val = deposit64(val, a->start, a->count + 1, ins);
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, val, 1, REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, val, 1, REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, val, 1, REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, val, 1, REG_DEST); break;
    }
    return true;
}


#define vop_(_type, _what) for (size_t i = 0; i < sizeof(ctx->v[0].as ## _type) / sizeof(ctx->v[0].as ## _type[0]); i++) { \
    ctx->v[a->v1].as ## _type[i] = ctx->v[a->v2].as ## _type[i] _what ctx->v[a->v3].as ## _type[i]; \
}
#define vop_as_(_type) for (size_t i = 0; i < sizeof(ctx->v[0].as ## _type) / sizeof(ctx->v[0].as ## _type[0]); i += 2) { \
    ctx->v[a->v1].as ## _type[i] = ctx->v[a->v2].as ## _type[i] + ctx->v[a->v3].as ## _type[i]; \
    ctx->v[a->v1].as ## _type[i + 1] = ctx->v[a->v2].as ## _type[i + 1] - ctx->v[a->v3].as ## _type[i + 1]; \
}
#define vop_madd_(_type) for (size_t i = 0; i < sizeof(ctx->v[0].as ## _type) / sizeof(ctx->v[0].as ## _type[0]); i++) { \
    ctx->v[a->v1].as ## _type[i] = ctx->v[a->v2].as ## _type[i] * ctx->v[a->v3].as ## _type[i]; \
} \
for (size_t i = 0; i < sizeof(ctx->v[0].as ## _type) / sizeof(ctx->v[0].as ## _type[0]); i++) { \
    ctx->v[a->v1].as ## _type[0] += ctx->v[a->v1].as ## _type[i]; \
}

#define vpu_conv_(_from, _to) { \
    uint8_t min = \
        sizeof(ctx->v[0].as ## _to) / sizeof(ctx->v[0].as ## _to[0]) < sizeof(ctx->v[0].as ## _from) / sizeof(ctx->v[0].as ## _from[0]) ? \
        sizeof(ctx->v[0].as ## _to) / sizeof(ctx->v[0].as ## _to[0]) : \
        sizeof(ctx->v[0].as ## _from) / sizeof(ctx->v[0].as ## _from[0]); \
    for (size_t i = 0; i < min; i++) { \
        ctx->v[a->v1].as ## _to[i] = ctx->v[a->v2].as ## _from[i]; \
    } \
}
#define vpu_conv2(_from, _to) vpu_conv_(_from, _to)
#define vpu_conv(_from) \
    switch (a->target) { \
        case 0: vpu_conv2(_from, vpu_o); break; \
        case 1: vpu_conv2(_from, vpu_b); break; \
        case 2: vpu_conv2(_from, vpu_w); break; \
        case 3: vpu_conv2(_from, vpu_d); break; \
        case 4: vpu_conv2(_from, vpu_q); break; \
        case 5: vpu_conv2(_from, vpu_l); break; \
        case 6: vpu_conv2(_from, vpu_s); break; \
        case 7: vpu_conv2(_from, vpu_f); break; \
    }

#define vop(_type, _what) vop_(_type, _what)
#define vop_as(_type) vop_as_(_type)
#define vop_madd(_type) vop_madd_(_type)

#define vpu_len_(_what) \
    do { \
        QWord_t count = 0; \
        for (size_t i = 0; sizeof(ctx->v[0].as ## _what) / sizeof(ctx->v[0].as ## _what[0]); i++) { \
            if (ctx->v[a->v1].as ## _what[i]) { \
                count++; \
            } else { \
                break; \
            } \
        } \
        writeQWord(ctx, a->r1, set_flags(ctx, count), 1, REG_DEST); \
    } while (0)
#define vpu_len(_what) vpu_len_(_what)

#define vpu_o QWord
#define vpu_b Bytes
#define vpu_w Words
#define vpu_d DWords
#define vpu_q QWords
#define vpu_l LWords
#define vpu_s Float32s
#define vpu_f Float64s

static bool trans_vadd(DisasContext *ctx, arg_vadd *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    switch (a->type) {
        case 0: vop(vpu_o, +); break;
        case 1: vop(vpu_b, +); break;
        case 2: vop(vpu_w, +); break;
        case 3: vop(vpu_d, +); break;
        case 4: vop(vpu_q, +); break;
        case 5: vop(vpu_l, +); break;
        case 6: vop(vpu_s, +); break;
        case 7: vop(vpu_f, +); break;
    }
    return true;
}
static bool trans_vsub(DisasContext *ctx, arg_vsub *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    switch (a->type) {
        case 0: vop(vpu_o, -); break;
        case 1: vop(vpu_b, -); break;
        case 2: vop(vpu_w, -); break;
        case 3: vop(vpu_d, -); break;
        case 4: vop(vpu_q, -); break;
        case 5: vop(vpu_l, -); break;
        case 6: vop(vpu_s, -); break;
        case 7: vop(vpu_f, -); break;
    }
    return true;
}
static bool trans_vmul(DisasContext *ctx, arg_vmul *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    switch (a->type) {
        case 0: vop(vpu_o, *); break;
        case 1: vop(vpu_b, *); break;
        case 2: vop(vpu_w, *); break;
        case 3: vop(vpu_d, *); break;
        case 4: vop(vpu_q, *); break;
        case 5: vop(vpu_l, *); break;
        case 6: vop(vpu_s, *); break;
        case 7: vop(vpu_f, *); break;
    }
    return true;
}
static bool trans_vdiv(DisasContext *ctx, arg_vdiv *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    switch (a->type) {
        case 0: vop(vpu_o, /); break;
        case 1: vop(vpu_b, /); break;
        case 2: vop(vpu_w, /); break;
        case 3: vop(vpu_d, /); break;
        case 4: vop(vpu_q, /); break;
        case 5: vop(vpu_l, /); break;
        case 6: vop(vpu_s, /); break;
        case 7: vop(vpu_f, /); break;
    }
    return true;
}
static bool trans_vaddsub(DisasContext *ctx, arg_vaddsub *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    switch (a->type) {
        case 0: vop_as(vpu_o); break;
        case 1: vop_as(vpu_b); break;
        case 2: vop_as(vpu_w); break;
        case 3: vop_as(vpu_d); break;
        case 4: vop_as(vpu_q); break;
        case 5: vop_as(vpu_l); break;
        case 6: vop_as(vpu_s); break;
        case 7: vop_as(vpu_f); break;
    }
    return true;
}
static bool trans_vmadd(DisasContext *ctx, arg_vmadd *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    switch (a->type) {
        case 0: vop_madd(vpu_o); break;
        case 1: vop_madd(vpu_b); break;
        case 2: vop_madd(vpu_w); break;
        case 3: vop_madd(vpu_d); break;
        case 4: vop_madd(vpu_q); break;
        case 5: vop_madd(vpu_l); break;
        case 6: vop_madd(vpu_s); break;
        case 7: vop_madd(vpu_f); break;
    }
    return true;
}
static bool trans_vmov_reg(DisasContext *ctx, arg_vmov_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    switch (a->type) {
        case 0: ctx->v[a->v1].asQWord[a->slot] = readQWord(ctx, a->r2, REG_SRC1);
        case 1: ctx->v[a->v1].asBytes[a->slot] = readByte(ctx, a->r2, REG_SRC1);
        case 2: ctx->v[a->v1].asWords[a->slot] = readWord(ctx, a->r2, REG_SRC1);
        case 3: ctx->v[a->v1].asDWords[a->slot] = readDWord(ctx, a->r2, REG_SRC1);
        case 4: ctx->v[a->v1].asQWords[a->slot] = readQWord(ctx, a->r2, REG_SRC1);
        case 5: ctx->v[a->v1].asLWords[a->slot] = readQWord(ctx, a->r2, REG_SRC1);
        case 6: ctx->v[a->v1].asFloat32s[a->slot] = readFloat32(ctx, a->r2, REG_SRC1);
        case 7: ctx->v[a->v1].asFloat64s[a->slot] = readFloat64(ctx, a->r2, REG_SRC1);
    }
    return true;
}
static bool trans_vmov(DisasContext *ctx, arg_vmov *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    ctx->v[a->v1] = ctx->v[a->v2];
    return true;
}
static bool trans_vconv(DisasContext *ctx, arg_vconv *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    switch (a->type) {
        case 0: vpu_conv(vpu_o); break;
        case 1: vpu_conv(vpu_b); break;
        case 2: vpu_conv(vpu_w); break;
        case 3: vpu_conv(vpu_d); break;
        case 4: vpu_conv(vpu_q); break;
        case 5: vpu_conv(vpu_l); break;
        case 6: vpu_conv(vpu_s); break;
        case 7: vpu_conv(vpu_f); break;
    }
    return true;
}
static bool trans_vlen(DisasContext *ctx, arg_vlen *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    switch (a->type) {
        case 0: vpu_len(vpu_o); break;
        case 1: vpu_len(vpu_b); break;
        case 2: vpu_len(vpu_w); break;
        case 3: vpu_len(vpu_d); break;
        case 4: vpu_len(vpu_q); break;
        case 5: vpu_len(vpu_l); break;
        case 6: vpu_len(vpu_s); break;
        case 7: vpu_len(vpu_f); break;
    }
    return true;
}
static bool trans_vldr_imm(DisasContext *ctx, arg_vldr_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t addr = readQWord(ctx, a->r1, REG_SRC1) + a->imm;
    ctx->v[a->v1] = *(hive_vector_register_t*) addr;
    return true;
}
static bool trans_vldr_imm_update(DisasContext *ctx, arg_vldr_imm_update *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t addr = readQWord(ctx, a->r1, REG_SRC1);
    writeQWord(ctx, a->r1, addr + a->imm, 1, REG_SRC1);
    ctx->v[a->v1] = *(hive_vector_register_t*) addr;
    return true;
}
static bool trans_vstr_imm(DisasContext *ctx, arg_vstr_imm *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t addr = readQWord(ctx, a->r1, REG_SRC1) + a->imm;
    *(hive_vector_register_t*) addr = ctx->v[a->v1];
    return true;
}
static bool trans_vstr_imm_update(DisasContext *ctx, arg_vstr_imm_update *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t addr = readQWord(ctx, a->r1, REG_SRC1) + a->imm;
    writeQWord(ctx, a->r1, addr, 1, REG_SRC1);
    *(hive_vector_register_t*) addr = ctx->v[a->v1];
    return true;
}
static bool trans_vldr_reg(DisasContext *ctx, arg_vldr_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t addr = readQWord(ctx, a->r1, REG_SRC1) + readQWord(ctx, a->r2, REG_SRC2);
    ctx->v[a->v1] = *(hive_vector_register_t*) addr;
    return true;
}
static bool trans_vldr_reg_update(DisasContext *ctx, arg_vldr_reg_update *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t addr = readQWord(ctx, a->r1, REG_SRC1);
    writeQWord(ctx, a->r1, addr + readQWord(ctx, a->r2, REG_SRC2), 1, REG_SRC1);
    ctx->v[a->v1] = *(hive_vector_register_t*) addr;
    return true;
}
static bool trans_vstr_reg(DisasContext *ctx, arg_vstr_reg *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t addr = readQWord(ctx, a->r1, REG_SRC1) + readQWord(ctx, a->r2, REG_SRC2);
    *(hive_vector_register_t*) addr = ctx->v[a->v1];
    return true;
}
static bool trans_vstr_reg_update(DisasContext *ctx, arg_vstr_reg_update *a) {
    if (!check_condition0(a->cond, ctx->cr[CR_FLAGS].asFlags)) return true;
    QWord_t addr = readQWord(ctx, a->r1, REG_SRC1) + readQWord(ctx, a->r2, REG_SRC2);
    writeQWord(ctx, a->r1, addr, 1, REG_SRC1);
    *(hive_vector_register_t*) addr = ctx->v[a->v1];
    return true;
}

void coredump(struct cpu_state* state);
char* dis(hive_instruction_t** ins, uint64_t addr);

void exec_instr(struct cpu_state* state, uint32_t ins) {
    if (!decode(state, ins)) {
        interrupt(SIGILL);
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

int runstate(struct cpu_state* state) {
    size_t current_thread = 0;

    bool handling = false;
    int sig = setjmp(lidt);
    if (sig == 0) {
        for (current_thread = 0; current_thread < THREAD_COUNT; current_thread++) {
            state[current_thread].idt = lidt;
        }
    } else {
        if ((sig != SIGILL && sig != SIGBUS && sig != SIGSEGV && sig != SIGTRAP) || state[current_thread].cr[CR_IDT].asQWord == 0 || handling) {
            fprintf(stderr, "Fault on vcore #%llu: %s\n", state[current_thread].cr[CR_CPUID].asQWord, strsignal(sig));
            return sig;
        }
        uint8_t ints[] = {
            [SIGILL] = INT_UD,
            [SIGBUS] = INT_PF,
            [SIGSEGV] = INT_GP,
            [SIGTRAP] = INT_IP,
        };
        handling = true;
        state[current_thread].r[REG_SP].asQWord -= 16;
        state[current_thread].r[REG_SP].asQWordPtr[0] = state[current_thread].r[REG_PC].asQWord;
        state[current_thread].r[REG_SP].asQWordPtr[1] = state[current_thread].cr[CR_RUNLEVEL].asQWord;
        state[current_thread].r[REG_PC].asQWord = state[current_thread].cr[CR_IDT].asQWord;
        state[current_thread].cr[CR_INT_ID].asQWord = ints[sig];
        state[current_thread].cr[CR_RUNLEVEL].asQWord = EM_HYPERVISOR;
        handling = false;
        sig = 0;
    }
    while (1) {
        for (current_thread = 0; current_thread < THREAD_COUNT; current_thread++) {
            DWord_t ins = *state[current_thread].r[REG_PC].asDWordPtr;
            exec_instr(&(state[current_thread]), ins);
            state[current_thread].r[REG_PC].asDWordPtr++;
            state[current_thread].cr[CR_CYCLES].asQWord++;
        }
    }
}

void interrupt_handler(int sig) {
    longjmp(lidt, sig);
}

void exec(void* start) {
    for (uint16_t cpuid = 0; cpuid < CORE_COUNT * THREAD_COUNT; cpuid++) {
        cpu_states[cpuid].r[REG_PC].asPointer = start;
        cpu_states[cpuid].cr[CR_CPUID].asQWord = cpuid;
        cpu_states[cpuid].cr[CR_CORES].asQWord = CORE_COUNT;
        cpu_states[cpuid].cr[CR_THREADS].asQWord = THREAD_COUNT;
        cpu_states[cpuid].cr[CR_FLAGS].asFlags.size = SIZE_64BIT;
    }

    pthread_t cores[CORE_COUNT] = {0};

    signal(SIGABRT, interrupt_handler);
    signal(SIGILL, interrupt_handler);
    signal(SIGSEGV, interrupt_handler);
    signal(SIGBUS, interrupt_handler);
    signal(SIGTRAP, interrupt_handler);

    if (CORE_COUNT == 1) {
        int ret_val = runstate(&cpu_states[0]);
        if (ret_val) {
            fprintf(stderr, "vcore #0 locked up/crashed abnormally: %d\n", ret_val);
        }
    } else {
        for (uint16_t cpuid = 0; cpuid < CORE_COUNT * THREAD_COUNT; cpuid += THREAD_COUNT) {
            int ret = pthread_create(&(cores[cpuid / THREAD_COUNT]), NULL, (void*) &runstate, &(cpu_states[cpuid]));
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
    }
    exit(cpu_states[0].r[0].asQWord);
}
