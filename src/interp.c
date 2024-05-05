#include <math.h>
#include <signal.h>
#include <pthread.h>
#include <setjmp.h>
#include <stdatomic.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/time.h>

#include "new_ops.h"

int check_condition(hive_instruction_t ins, hive_flag_register_t fr);

#define set_flagsLWord(state, res) set_flags128((state), (res))
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
static inline SLWord_t set_flags128(struct cpu_state* ctx, SLWord_t res) {
    ctx->cr[CR_FLAGS].asFlags.zero = (res == 0);
    ctx->cr[CR_FLAGS].asFlags.negative = (res < 0);
    return res;
}
static inline SQWord_t set_flags64(struct cpu_state* ctx, SQWord_t res) {
    ctx->cr[CR_FLAGS].asFlags.zero = (res == 0);
    ctx->cr[CR_FLAGS].asFlags.negative = (res < 0);
    return res;
}
static inline SDWord_t set_flags32(struct cpu_state* ctx, SDWord_t res) {
    ctx->cr[CR_FLAGS].asFlags.zero = (res == 0);
    ctx->cr[CR_FLAGS].asFlags.negative = (res < 0);
    return res;
}
static inline SWord_t set_flags16(struct cpu_state* ctx, SWord_t res) {
    ctx->cr[CR_FLAGS].asFlags.zero = (res == 0);
    ctx->cr[CR_FLAGS].asFlags.negative = (res < 0);
    return res;
}
static inline SByte_t set_flags8(struct cpu_state* ctx, SByte_t res) {
    ctx->cr[CR_FLAGS].asFlags.zero = (res == 0);
    ctx->cr[CR_FLAGS].asFlags.negative = (res < 0);
    return res;
}
static inline Float64_t set_flagsf64(struct cpu_state* ctx, Float64_t res) {
    ctx->cr[CR_FLAGS].asFlags.zero = (res == 0.0);
    ctx->cr[CR_FLAGS].asFlags.negative = (res < 0.0);
    return res;
}
static inline Float32_t set_flagsf32(struct cpu_state* ctx, Float32_t res) {
    ctx->cr[CR_FLAGS].asFlags.zero = (res == 0.0);
    ctx->cr[CR_FLAGS].asFlags.negative = (res < 0.0);
    return res;
}

#define set_flags(state, res) _Generic((res), \
    SLWord_t: set_flags128, LWord_t: set_flags128, \
    uint64_t: set_flags64, int64_t: set_flags64, \
    uint32_t: set_flags32, int32_t: set_flags32, \
    uint16_t: set_flags16, int16_t: set_flags16, \
    uint8_t: set_flags8, int8_t: set_flags8, \
    float: set_flagsf32, double: set_flagsf64 \
)((ctx), (res))

#define REL(what, to)               (ctx->r[(to)].asQWord + ((what) << 2))
#define REL32(what, to)             (ctx->r[(to)].asDWord + ((what) << 2))
#define PC_REL(what)                REL(what, REG_PC)
#define PC_REL32(what)              REL32(what, REG_PC)
#define BRANCH(to)                  (ctx->r[REG_PC].asQWord = (QWord_t) ((to) - sizeof(DWord_t)))
#define BRANCH_RELATIVE(offset)     BRANCH(PC_REL(offset))
#define LINK()                      (ctx->r[REG_LR].asQWord = ctx->r[REG_PC].asQWord)

#define def_ror(type, size) type ror ## size(type a, type b) { return (((a) >> (b)) | ((a) << ((sizeof(a) << 3) - (b)))); }

void exec_instr(struct cpu_state* ctx, uint32_t ins);

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

#define interrupt(i) longjmp(ctx->idt, (i))

static inline uint8_t swap_bytes_8(uint8_t x) {
    raise(SIGILL);
    return x;
}

#define swap_bytes(x) _Generic((x), int64_t: swap_bytes_64, uint64_t: swap_bytes_64, int32_t: swap_bytes_32, uint32_t: swap_bytes_32, int16_t: swap_bytes_16, uint16_t: swap_bytes_16, int8_t: swap_bytes_8, uint8_t: swap_bytes_8)((x))

#define INTENT_WRITE 1
#define INTENT_READ 0

#define reg_reader(_type) \
static inline _type ## _t read ## _type (struct cpu_state* ctx, uint8_t reg, uint8_t counter) { \
    if (unlikely(is_slot_overridden(ctx, counter))) { \
        return ctx->r[reg].as ## _type ## Pair.high; \
    } else { \
        return ctx->r[reg].as ## _type ## Pair.low; \
    } \
}
#define reg_writer(_type) \
static inline void write ## _type (struct cpu_state* ctx, uint8_t reg, _type ## _t val, uint8_t counter) { \
    if (unlikely(is_slot_overridden(ctx, counter))) { \
        ctx->r[reg].as ## _type ## Pair.high = val; \
    } else { \
        ctx->r[reg].as ## _type ## Pair.low = val; \
    } \
}

extern svc_call svcs[];
__thread bool handling_interrupt = false;
__thread jmp_buf lidt;

static inline bool is_slot_overridden(struct cpu_state* ctx, uint8_t counter) {
    return (ctx->cr[CR_FLAGS].asFlags.reg_state & (1 << counter)) != 0;
}

static inline void check_permissions(struct cpu_state* ctx, uint8_t mode) {
    if (unlikely(ctx->cr[CR_RUNLEVEL].asQWord > mode)) {
        interrupt(SIGTRAP);
    }
}

reg_reader(Byte)
reg_reader(Word)
reg_reader(DWord)
reg_reader(SByte)
reg_reader(SWord)
reg_reader(SDWord)
Float32_t readFloat32(struct cpu_state* ctx, uint8_t reg, uint8_t counter) {
    return ctx->r[reg].asFloat32;
}
Float64_t readFloat64(struct cpu_state* ctx, uint8_t reg, uint8_t counter) {
    return ctx->r[reg].asFloat64;
}
QWord_t readQWord(struct cpu_state* ctx, uint8_t reg, uint8_t counter) {
    return ctx->r[reg].asQWord;
}
SQWord_t readSQWord(struct cpu_state* ctx, uint8_t reg, uint8_t counter) {
    return ctx->r[reg].asSQWord;
}

QWord_t readUnsigned(struct cpu_state* ctx, uint8_t reg, uint8_t counter) {
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT:  return readByte(ctx, reg, counter);
        case SIZE_16BIT: return readWord(ctx, reg, counter);
        case SIZE_32BIT: return readDWord(ctx, reg, counter);
        case SIZE_64BIT: return readQWord(ctx, reg, counter);
    }
#if __has_builtin(__builtin_unreachable)
    __builtin_unreachable();
#else
    abort();
#endif
}

SQWord_t readSigned(struct cpu_state* ctx, uint8_t reg, uint8_t counter) {
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT:  return readSByte(ctx, reg, counter);
        case SIZE_16BIT: return readSWord(ctx, reg, counter);
        case SIZE_32BIT: return readSDWord(ctx, reg, counter);
        case SIZE_64BIT: return readSQWord(ctx, reg, counter);
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
void writeFloat32(struct cpu_state* ctx, uint8_t reg, Float32_t val, uint8_t counter) {
    ctx->r[reg].asFloat32 = val;
}
void writeFloat64(struct cpu_state* ctx, uint8_t reg, Float64_t val, uint8_t counter) {
    ctx->r[reg].asFloat64 = val;
}
void writeQWord(struct cpu_state* ctx, uint8_t reg, QWord_t val, uint8_t counter) {
    ctx->r[reg].asQWord = val;
}
void writeSQWord(struct cpu_state* ctx, uint8_t reg, SQWord_t val, uint8_t counter) {
    ctx->r[reg].asSQWord = val;
}

void writeUnsigned(struct cpu_state* ctx, uint8_t reg, QWord_t val, uint8_t counter) {
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT:  writeByte(ctx, reg, val, counter); return;
        case SIZE_16BIT: writeWord(ctx, reg, val, counter); return;
        case SIZE_32BIT: writeDWord(ctx, reg, val, counter); return;
        case SIZE_64BIT: writeQWord(ctx, reg, val, counter); return;
    }
#if __has_builtin(__builtin_unreachable)
    __builtin_unreachable();
#else
    abort();
#endif
}

void writeSigned(struct cpu_state* ctx, uint8_t reg, SQWord_t val, uint8_t counter) {
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT:  writeSByte(ctx, reg, val, counter); return;
        case SIZE_16BIT: writeSWord(ctx, reg, val, counter); return;
        case SIZE_32BIT: writeSDWord(ctx, reg, val, counter); return;
        case SIZE_64BIT: writeSQWord(ctx, reg, val, counter); return;
    }
#if __has_builtin(__builtin_unreachable)
    __builtin_unreachable();
#else
    abort();
#endif
}

#define mem_reader(_type) \
_type ## _t memRead ## _type (struct cpu_state* ctx, void* addr) { \
    if (!authenticate_ptr(ctx, addr, sizeof(_type ## _t))) { \
        interrupt(SIGBUS); \
    } \
    return *(_type ## _t*) addr; \
}
#define mem_writer(_type) \
void memWrite ## _type (struct cpu_state* ctx, void* addr, _type ## _t val) { \
    if (!authenticate_ptr(ctx, addr, sizeof(_type ## _t))) { \
        interrupt(SIGBUS); \
    } \
    *(_type ## _t*) addr = val; \
}

bool authenticate_ptr(struct cpu_state* ctx, void* addr, size_t read_size) {
    if (read_size > 4) {
        return ((uint64_t) addr % 4) == 0;
    } else {
        return ((uint64_t) addr % read_size) == 0;
    }
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
int check_condition1(uint8_t cond, hive_flag_register_t fr);

static bool trans_branch(DisasContext *ctx, arg_branch *a) {
    BRANCH_RELATIVE(a->rel);
    return true;
}
static bool trans_branch_link(DisasContext *ctx, arg_branch_link *a) {
    LINK();
    BRANCH_RELATIVE(a->rel);
    return true;
}
static bool trans_branch_reg(DisasContext *ctx, arg_branch_reg *a) {
    BRANCH(readQWord(ctx, a->r1, REG_DEST));
    return true;
}
static bool trans_branch_reg_link(DisasContext *ctx, arg_branch_reg_link *a) {
    LINK();
    BRANCH(readQWord(ctx, a->r1, REG_DEST));
    return true;
}

#define ALU_R(_op) switch (ctx->cr[CR_FLAGS].asFlags.size) { \
        case SIZE_8BIT: writeByte(ctx, a->r1, set_flags(ctx, readByte(ctx, a->r2, REG_SRC1) _op readByte(ctx, a->r3, REG_SRC2)), REG_DEST); break; \
        case SIZE_16BIT: writeWord(ctx, a->r1, set_flags(ctx, readWord(ctx, a->r2, REG_SRC1) _op readWord(ctx, a->r3, REG_SRC2)), REG_DEST); break; \
        case SIZE_32BIT: writeDWord(ctx, a->r1, set_flags(ctx, readDWord(ctx, a->r2, REG_SRC1) _op readDWord(ctx, a->r3, REG_SRC2)), REG_DEST); break; \
        case SIZE_64BIT: writeQWord(ctx, a->r1, set_flags(ctx, readQWord(ctx, a->r2, REG_SRC1) _op readQWord(ctx, a->r3, REG_SRC2)), REG_DEST); break; \
    }
#define ALU_I(_op) switch (ctx->cr[CR_FLAGS].asFlags.size) { \
        case SIZE_8BIT: writeByte(ctx, a->r1, set_flags(ctx, readByte(ctx, a->r2, REG_SRC1) _op (Byte_t) a->imm8), REG_DEST); break; \
        case SIZE_16BIT: writeWord(ctx, a->r1, set_flags(ctx, readWord(ctx, a->r2, REG_SRC1) _op (Word_t) a->imm8), REG_DEST); break; \
        case SIZE_32BIT: writeDWord(ctx, a->r1, set_flags(ctx, readDWord(ctx, a->r2, REG_SRC1) _op (DWord_t) a->imm8), REG_DEST); break; \
        case SIZE_64BIT: writeQWord(ctx, a->r1, set_flags(ctx, readQWord(ctx, a->r2, REG_SRC1) _op (QWord_t) a->imm8), REG_DEST); break; \
    }
#define ALU_R_ROT(_rot) switch (ctx->cr[CR_FLAGS].asFlags.size) { \
        case SIZE_8BIT: writeByte(ctx, a->r1, set_flags(ctx, _rot(readByte(ctx, a->r2, REG_SRC1), readByte(ctx, a->r3, REG_SRC2))), REG_DEST); break; \
        case SIZE_16BIT: writeWord(ctx, a->r1, set_flags(ctx, _rot(readWord(ctx, a->r2, REG_SRC1), readWord(ctx, a->r3, REG_SRC2))), REG_DEST); break; \
        case SIZE_32BIT: writeDWord(ctx, a->r1, set_flags(ctx, _rot(readDWord(ctx, a->r2, REG_SRC1), readDWord(ctx, a->r3, REG_SRC2))), REG_DEST); break; \
        case SIZE_64BIT: writeQWord(ctx, a->r1, set_flags(ctx, _rot(readQWord(ctx, a->r2, REG_SRC1), readQWord(ctx, a->r3, REG_SRC2))), REG_DEST); break; \
    }
#define ALU_I_ROT(_rot) switch (ctx->cr[CR_FLAGS].asFlags.size) { \
        case SIZE_8BIT: writeByte(ctx, a->r1, set_flags(ctx, _rot(readByte(ctx, a->r2, REG_SRC1), (Byte_t) a->imm8)), REG_DEST); break; \
        case SIZE_16BIT: writeWord(ctx, a->r1, set_flags(ctx, _rot(readWord(ctx, a->r2, REG_SRC1), (Word_t) a->imm8)), REG_DEST); break; \
        case SIZE_32BIT: writeDWord(ctx, a->r1, set_flags(ctx, _rot(readDWord(ctx, a->r2, REG_SRC1), (DWord_t) a->imm8)), REG_DEST); break; \
        case SIZE_64BIT: writeQWord(ctx, a->r1, set_flags(ctx, _rot(readQWord(ctx, a->r2, REG_SRC1), (QWord_t) a->imm8)), REG_DEST); break; \
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
        case SIZE_8BIT: writeSByte(ctx, a->r1, set_flags(ctx, readSByte(ctx, a->r2, REG_SRC1) _op readSByte(ctx, a->r3, REG_SRC2)), REG_DEST); break; \
        case SIZE_16BIT: writeSWord(ctx, a->r1, set_flags(ctx, readSWord(ctx, a->r2, REG_SRC1) _op readSWord(ctx, a->r3, REG_SRC2)), REG_DEST); break; \
        case SIZE_32BIT: writeSDWord(ctx, a->r1, set_flags(ctx, readSDWord(ctx, a->r2, REG_SRC1) _op readSDWord(ctx, a->r3, REG_SRC2)), REG_DEST); break; \
        case SIZE_64BIT: writeSQWord(ctx, a->r1, set_flags(ctx, readSQWord(ctx, a->r2, REG_SRC1) _op readSQWord(ctx, a->r3, REG_SRC2)), REG_DEST); break; \
    }
#define SALU_I(_op) switch (ctx->cr[CR_FLAGS].asFlags.size) { \
        case SIZE_8BIT: writeSByte(ctx, a->r1, set_flags(ctx, readSByte(ctx, a->r2, REG_SRC1) _op (SByte_t) a->imm8), REG_DEST); break; \
        case SIZE_16BIT: writeSWord(ctx, a->r1, set_flags(ctx, readSWord(ctx, a->r2, REG_SRC1) _op (SWord_t) a->imm8), REG_DEST); break; \
        case SIZE_32BIT: writeSDWord(ctx, a->r1, set_flags(ctx, readSDWord(ctx, a->r2, REG_SRC1) _op (SDWord_t) a->imm8), REG_DEST); break; \
        case SIZE_64BIT: writeSQWord(ctx, a->r1, set_flags(ctx, readSQWord(ctx, a->r2, REG_SRC1) _op (SQWord_t) a->imm8), REG_DEST); break; \
    }

static bool trans_add_reg(DisasContext *ctx, arg_add_reg *a) {
    ALU_R(+);
    return true;
}
static bool trans_sub_reg(DisasContext *ctx, arg_sub_reg *a) {
    ALU_R(-);
    return true;
}
static bool trans_cmp_reg(DisasContext *ctx, arg_cmp_reg *a) {
    ALU_R_DISC(-);
    return true;
}
static bool trans_mul_reg(DisasContext *ctx, arg_mul_reg *a) {
    ALU_R(*);
    return true;
}
static bool trans_div_reg(DisasContext *ctx, arg_div_reg *a) {
    ALU_R(/);
    return true;
}
static bool trans_mod_reg(DisasContext *ctx, arg_mod_reg *a) {
    ALU_R(%);
    return true;
}
static bool trans_divs_reg(DisasContext *ctx, arg_divs_reg *a) {
    SALU_R(/);
    return true;
}
static bool trans_mods_reg(DisasContext *ctx, arg_mods_reg *a) {
    SALU_R(%);
    return true;
}
static bool trans_and_reg(DisasContext *ctx, arg_and_reg *a) {
    ALU_R(&)
    return true;
}
static bool trans_tst_reg(DisasContext *ctx, arg_tst_reg *a) {
    ALU_R_DISC(&)
    return true;
}
static bool trans_or_reg(DisasContext *ctx, arg_or_reg *a) {
    ALU_R(|)
    return true;
}
static bool trans_xor_reg(DisasContext *ctx, arg_xor_reg *a) {
    ALU_R(^)
    return true;
}
static bool trans_shl_reg(DisasContext *ctx, arg_shl_reg *a) {
    ALU_R(<<)
    return true;
}
static bool trans_shr_reg(DisasContext *ctx, arg_shr_reg *a) {
    ALU_R(>>)
    return true;
}
static bool trans_sar_reg(DisasContext *ctx, arg_sar_reg *a) {
    SALU_R(>>)
    return true;
}
static bool trans_rol_reg(DisasContext *ctx, arg_rol_reg *a) {
    ALU_R_ROT(ROL);
    return true;
}
static bool trans_ror_reg(DisasContext *ctx, arg_ror_reg *a) {
    ALU_R_ROT(ROR);
    return true;
}
static bool trans_add_imm(DisasContext *ctx, arg_add_imm *a) {
    ALU_I(+);
    return true;
}
static bool trans_sub_imm(DisasContext *ctx, arg_sub_imm *a) {
    ALU_I(-);
    return true;
}
static bool trans_cmp_imm(DisasContext *ctx, arg_cmp_imm *a) {
    ALU_I_DISC(-);
    return true;
}
static bool trans_mul_imm(DisasContext *ctx, arg_mul_imm *a) {
    ALU_I(*);
    return true;
}
static bool trans_div_imm(DisasContext *ctx, arg_div_imm *a) {
    ALU_I(/);
    return true;
}
static bool trans_mod_imm(DisasContext *ctx, arg_mod_imm *a) {
    ALU_I(%);
    return true;
}
static bool trans_divs_imm(DisasContext *ctx, arg_divs_imm *a) {
    SALU_I(/);
    return true;
}
static bool trans_mods_imm(DisasContext *ctx, arg_mods_imm *a) {
    SALU_I(%);
    return true;
}
static bool trans_and_imm(DisasContext *ctx, arg_and_imm *a) {
    ALU_I(&)
    return true;
}
static bool trans_tst_imm(DisasContext *ctx, arg_tst_imm *a) {
    ALU_I_DISC(&)
    return true;
}
static bool trans_or_imm(DisasContext *ctx, arg_or_imm *a) {
    ALU_I(|)
    return true;
}
static bool trans_xor_imm(DisasContext *ctx, arg_xor_imm *a) {
    ALU_I(^)
    return true;
}
static bool trans_ret(DisasContext *ctx, arg_ret *a) {
    ctx->r[REG_PC].asQWord = set_flags(ctx, ctx->r[REG_LR].asQWord);
    return true;
}
static bool trans_mov(DisasContext *ctx, arg_mov *a) {
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, set_flags(ctx, readByte(ctx, a->r2, REG_SRC1)), REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, set_flags(ctx, readWord(ctx, a->r2, REG_SRC1)), REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, set_flags(ctx, readDWord(ctx, a->r2, REG_SRC1)), REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, set_flags(ctx, readQWord(ctx, a->r2, REG_SRC1)), REG_DEST); break;
    }
    return true;
}
static bool trans_shl_imm(DisasContext *ctx, arg_shl_imm *a) {
    ALU_I(<<)
    return true;
}
static bool trans_shr_imm(DisasContext *ctx, arg_shr_imm *a) {
    ALU_I(>>)
    return true;
}
static bool trans_sar_imm(DisasContext *ctx, arg_sar_imm *a) {
    SALU_I(>>)
    return true;
}
static bool trans_rol_imm(DisasContext *ctx, arg_rol_imm *a) {
    ALU_I_ROT(ROL);
    return true;
}
static bool trans_ror_imm(DisasContext *ctx, arg_ror_imm *a) {
    ALU_I_ROT(ROR);
    return true;
}
static bool trans_neg(DisasContext *ctx, arg_neg *a) {
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeSByte(ctx, a->r1, -readSByte(ctx, a->r2, REG_SRC1), REG_DEST); break;
        case SIZE_16BIT: writeSWord(ctx, a->r1, -readSWord(ctx, a->r2, REG_SRC1), REG_DEST); break;
        case SIZE_32BIT: writeSDWord(ctx, a->r1, -readSDWord(ctx, a->r2, REG_SRC1), REG_DEST); break;
        case SIZE_64BIT: writeSQWord(ctx, a->r1, -readSQWord(ctx, a->r2, REG_SRC1), REG_DEST); break;
    }
    return true;
}
static bool trans_not(DisasContext *ctx, arg_not *a) {
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, ~readByte(ctx, a->r2, REG_SRC1), REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, ~readWord(ctx, a->r2, REG_SRC1), REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, ~readDWord(ctx, a->r2, REG_SRC1), REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, ~readQWord(ctx, a->r2, REG_SRC1), REG_DEST); break;
    }
    return true;
}
static bool trans_extend(DisasContext *ctx, arg_extend *a) {
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
        case SIZE_16BIT: writeSWord(ctx, a->r2, val, REG_DEST); break;
        case SIZE_32BIT: writeSDWord(ctx, a->r2, val, REG_DEST); break;
        case SIZE_64BIT: writeSQWord(ctx, a->r2, val, REG_DEST); break;
        default: return false;
    }

    return true;
}
static bool trans_swe(DisasContext *ctx, arg_swe *a) {
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, swap_bytes(readByte(ctx, a->r2, REG_SRC1)), REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, swap_bytes(readWord(ctx, a->r2, REG_SRC1)), REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, swap_bytes(readDWord(ctx, a->r2, REG_SRC1)), REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, swap_bytes(readQWord(ctx, a->r2, REG_SRC1)), REG_DEST); break;
    }
    return true;
}
static bool trans_cswap(DisasContext *ctx, arg_cswap *a) {
    uint8_t reg = a->r3;
    uint8_t cnt = REG_SRC2;
    int check_condition1(uint8_t cond, hive_flag_register_t fr);
    if (check_condition1(a->cond, ctx->cr[CR_FLAGS].asFlags)) {
        reg = a->r2;
        cnt = REG_SRC1;
    }
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, readByte(ctx, reg, cnt), REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, readWord(ctx, reg, cnt), REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, readDWord(ctx, reg, cnt), REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, readQWord(ctx, reg, cnt), REG_DEST); break;
    }
    return true;
}
static bool trans_xchg(DisasContext *ctx, arg_xchg *a) {
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: {
                Byte_t tmp = readByte(ctx, a->r1, REG_DEST);
                writeByte(ctx, a->r1, readByte(ctx, a->r2, REG_SRC1), REG_DEST);
                writeByte(ctx, a->r2, tmp, REG_SRC1);
            }
            break;
        case SIZE_16BIT: {
                Word_t tmp = readWord(ctx, a->r1, REG_DEST);
                writeWord(ctx, a->r1, readWord(ctx, a->r2, REG_SRC1), REG_DEST);
                writeWord(ctx, a->r2, tmp, REG_SRC1);
            }
            break;
        case SIZE_32BIT: {
                DWord_t tmp = readDWord(ctx, a->r1, REG_DEST);
                writeDWord(ctx, a->r1, readDWord(ctx, a->r2, REG_SRC1), REG_DEST);
                writeDWord(ctx, a->r2, tmp, REG_SRC1);
            }
            break;
        case SIZE_64BIT: {
                QWord_t tmp = readQWord(ctx, a->r1, REG_DEST);
                writeQWord(ctx, a->r1, readQWord(ctx, a->r2, REG_SRC1), REG_DEST);
                writeQWord(ctx, a->r2, tmp, REG_SRC1);
            }
            break;
    }
    return true;
}
static bool trans_prefix(DisasContext *ctx, arg_prefix *a) {
    // override size, register state, and relative override
    ctx->cr[CR_FLAGS].asFlags.size = a->sz;
    ctx->cr[CR_FLAGS].asFlags.reg_state = a->reg_override;
    
    // exec
    ctx->r[REG_PC].asInstrPtr++;
    exec_instr(ctx, memReadDWord(ctx, ctx->r[REG_PC].asDWordPtr));
    
    // restore default state
    ctx->cr[CR_FLAGS].asFlags.size = SIZE_64BIT;
    ctx->cr[CR_FLAGS].asFlags.reg_state = 0;
    return true;
}
static bool trans_fadd(DisasContext *ctx, arg_fadd *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) + readFloat64(ctx, a->r3, REG_SRC2)), REG_DEST);
    return true;
}
static bool trans_faddi(DisasContext *ctx, arg_faddi *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) + readSQWord(ctx, a->r3, REG_SRC2)), REG_DEST);
    return true;
}
static bool trans_fsub(DisasContext *ctx, arg_fsub *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) - readFloat64(ctx, a->r3, REG_SRC2)), REG_DEST);
    return true;
}
static bool trans_fsubi(DisasContext *ctx, arg_fsubi *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) - readSQWord(ctx, a->r3, REG_SRC2)), REG_DEST);
    return true;
}
static bool trans_fcmp(DisasContext *ctx, arg_fcmp *a) {
    set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) - readFloat64(ctx, a->r3, REG_SRC2));
    return true;
}
static bool trans_fcmpi(DisasContext *ctx, arg_fcmpi *a) {
    set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) - readSQWord(ctx, a->r3, REG_SRC2));
    return true;
}
static bool trans_fmul(DisasContext *ctx, arg_fmul *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) * readFloat64(ctx, a->r3, REG_SRC2)), REG_DEST);
    return true;
}
static bool trans_fmuli(DisasContext *ctx, arg_fmuli *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) * readSQWord(ctx, a->r3, REG_SRC2)), REG_DEST);
    return true;
}
static bool trans_fdiv(DisasContext *ctx, arg_fdiv *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) / readFloat64(ctx, a->r3, REG_SRC2)), REG_DEST);
    return true;
}
static bool trans_fdivi(DisasContext *ctx, arg_fdivi *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1) / readSQWord(ctx, a->r3, REG_SRC2)), REG_DEST);
    return true;
}
static bool trans_fmod(DisasContext *ctx, arg_fmod *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, fmod(readFloat64(ctx, a->r2, REG_SRC1), readFloat64(ctx, a->r3, REG_SRC2))), REG_DEST);
    return true;
}
static bool trans_fmodi(DisasContext *ctx, arg_fmodi *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, fmod(readFloat64(ctx, a->r2, REG_SRC1), readSQWord(ctx, a->r3, REG_SRC2))), REG_DEST);
    return true;
}
static bool trans_f2i(DisasContext *ctx, arg_f2i *a) {
    writeSQWord(ctx, a->r1, readFloat64(ctx, a->r2, REG_SRC1), REG_DEST);
    return true;
}
static bool trans_i2f(DisasContext *ctx, arg_i2f *a) {
    writeFloat64(ctx, a->r1, readSQWord(ctx, a->r2, REG_SRC1), REG_DEST);
    return true;
}
static bool trans_fsin(DisasContext *ctx, arg_fsin *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, sin(readFloat64(ctx, a->r2, REG_SRC1))), REG_DEST);
    return true;
}
static bool trans_fsini(DisasContext *ctx, arg_fsini *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, sin(readSQWord(ctx, a->r2, REG_SRC1))), REG_DEST);
    return true;
}
static bool trans_fsqrt(DisasContext *ctx, arg_fsqrt *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, sqrt(readFloat64(ctx, a->r2, REG_SRC1))), REG_DEST);
    return true;
}
static bool trans_fsqrti(DisasContext *ctx, arg_fsqrti *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, sqrt(readSQWord(ctx, a->r2, REG_SRC1))), REG_DEST);
    return true;
}
static bool trans_sadd(DisasContext *ctx, arg_sadd *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) + readFloat32(ctx, a->r3, REG_SRC2)), REG_DEST);
    return true;
}
static bool trans_saddi(DisasContext *ctx, arg_saddi *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) + readSDWord(ctx, a->r3, REG_SRC2)), REG_DEST);
    return true;
}
static bool trans_ssub(DisasContext *ctx, arg_ssub *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) - readFloat32(ctx, a->r3, REG_SRC2)), REG_DEST);
    return true;
}
static bool trans_ssubi(DisasContext *ctx, arg_ssubi *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) - readSDWord(ctx, a->r3, REG_SRC2)), REG_DEST);
    return true;
}
static bool trans_scmp(DisasContext *ctx, arg_scmp *a) {
    set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) - readFloat32(ctx, a->r3, REG_SRC2));
    return true;
}
static bool trans_scmpi(DisasContext *ctx, arg_scmpi *a) {
    set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) - readSDWord(ctx, a->r3, REG_SRC2));
    return true;
}
static bool trans_smul(DisasContext *ctx, arg_smul *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) * readFloat32(ctx, a->r3, REG_SRC2)), REG_DEST);
    return true;
}
static bool trans_smuli(DisasContext *ctx, arg_smuli *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) * readSDWord(ctx, a->r3, REG_SRC2)), REG_DEST);
    return true;
}
static bool trans_sdiv(DisasContext *ctx, arg_sdiv *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) / readFloat32(ctx, a->r3, REG_SRC2)), REG_DEST);
    return true;
}
static bool trans_sdivi(DisasContext *ctx, arg_sdivi *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1) / readSDWord(ctx, a->r3, REG_SRC2)), REG_DEST);
    return true;
}
static bool trans_smod(DisasContext *ctx, arg_smod *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, fmod(readFloat32(ctx, a->r2, REG_SRC1), readFloat32(ctx, a->r3, REG_SRC2))), REG_DEST);
    return true;
}
static bool trans_smodi(DisasContext *ctx, arg_smodi *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, fmod(readFloat32(ctx, a->r2, REG_SRC1), readSDWord(ctx, a->r3, REG_SRC2))), REG_DEST);
    return true;
}
static bool trans_s2i(DisasContext *ctx, arg_s2i *a) {
    writeSQWord(ctx, a->r1, readFloat32(ctx, a->r2, REG_SRC1), REG_DEST);
    return true;
}
static bool trans_i2s(DisasContext *ctx, arg_i2s *a) {
    writeFloat32(ctx, a->r1, readSDWord(ctx, a->r2, REG_SRC1), REG_DEST);
    return true;
}
static bool trans_ssin(DisasContext *ctx, arg_ssin *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, sin(readFloat32(ctx, a->r2, REG_SRC1))), REG_DEST);
    return true;
}
static bool trans_ssini(DisasContext *ctx, arg_ssini *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, sin(readSDWord(ctx, a->r2, REG_SRC1))), REG_DEST);
    return true;
}
static bool trans_ssqrt(DisasContext *ctx, arg_ssqrt *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, sqrt(readFloat32(ctx, a->r2, REG_SRC1))), REG_DEST);
    return true;
}
static bool trans_ssqrti(DisasContext *ctx, arg_ssqrti *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, sqrt(readSDWord(ctx, a->r2, REG_SRC1))), REG_DEST);
    return true;
}
static bool trans_s2f(DisasContext *ctx, arg_s2f *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2, REG_SRC1)), REG_DEST);
    return true;
}
static bool trans_f2s(DisasContext *ctx, arg_f2s *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2, REG_SRC1)), REG_DEST);
    return true;
}
static bool trans_cpuid(DisasContext *ctx, arg_cpuid *a) {
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
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: {
            Byte_t value = readByte(ctx, a->r1, REG_DEST);
            ctx->r[a->r1].asQWord = 0;
            writeByte(ctx, a->r1, value, REG_DEST);
            break;
        }
        case SIZE_16BIT: {
            Word_t value = readWord(ctx, a->r1, REG_DEST);
            ctx->r[a->r1].asQWord = 0;
            writeWord(ctx, a->r1, value, REG_DEST);
            break;
        }
        case SIZE_32BIT: {
            DWord_t value = readDWord(ctx, a->r1, REG_DEST);
            ctx->r[a->r1].asQWord = 0;
            writeDWord(ctx, a->r1, value, REG_DEST);
            break;
        }
        default: return false;
    }
    return true;
}
static bool trans_sret(DisasContext *ctx, arg_sret *a) {
    check_permissions(ctx, EM_SUPERVISOR);
    ctx->r[REG_PC].asQWord = ctx->r[REG_LR].asQWord;
    ctx->cr[CR_RUNLEVEL].asQWord = EM_USER;
    return true;
}
static bool trans_hret(DisasContext *ctx, arg_hret *a) {
    check_permissions(ctx, EM_HYPERVISOR);
    ctx->r[REG_PC].asQWord = ctx->r[REG_LR].asQWord;
    ctx->cr[CR_RUNLEVEL].asQWord = EM_SUPERVISOR;
    return true;
}
static bool trans_iret(DisasContext *ctx, arg_iret *a) {
    check_permissions(ctx, EM_HYPERVISOR);
    ctx->cr[CR_RUNLEVEL].asQWord = ctx->r[REG_SP].asQWordPtr[1];
    BRANCH(ctx->r[REG_SP].asQWordPtr[0]);
    ctx->r[REG_SP].asQWord += 16;
    handling_interrupt = false;
    return true;
}
static bool trans_svc(DisasContext *ctx, arg_svc *a) {
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
    check_permissions(ctx, EM_HYPERVISOR);
    ctx->cr[a->cr1] = ctx->r[a->r1];
    return true;
}
static bool trans_mov_r_cr(DisasContext *ctx, arg_mov_r_cr *a) {
    ctx->r[a->r1] = ctx->cr[a->cr1];
    return true;
}
static bool trans_hexit(DisasContext *ctx, arg_hexit *a) {
    check_permissions(ctx, EM_HYPERVISOR);
    ctx->cr[CR_RUNLEVEL].asQWord = EM_SUPERVISOR;
    return true;
}
static bool trans_sexit(DisasContext *ctx, arg_sexit *a) {
    check_permissions(ctx, EM_SUPERVISOR);
    ctx->cr[CR_RUNLEVEL].asQWord = EM_USER;
    return true;
}
static bool trans_lea(DisasContext *ctx, arg_lea *a) {
    writeQWord(ctx, a->r1, PC_REL(a->rel), REG_DEST);
    return true;
}
static bool trans_movz_0(DisasContext *ctx, arg_movz_0 *a) {
    writeQWord(ctx, a->r1, set_flags(ctx, ((QWord_t) a->imm) << 0), REG_DEST);
    return true;
}
static bool trans_movz_16(DisasContext *ctx, arg_movz_16 *a) {
    writeQWord(ctx, a->r1, set_flags(ctx, ((QWord_t) a->imm) << 16), REG_DEST);
    return true;
}
static bool trans_movz_32(DisasContext *ctx, arg_movz_32 *a) {
    writeQWord(ctx, a->r1, set_flags(ctx, ((QWord_t) a->imm) << 32), REG_DEST);
    return true;
}
static bool trans_movz_48(DisasContext *ctx, arg_movz_48 *a) {
    writeQWord(ctx, a->r1, set_flags(ctx, ((QWord_t) a->imm) << 48), REG_DEST);
    return true;
}
static bool trans_movk_0(DisasContext *ctx, arg_movk_0 *a) {
    QWord_t val = readQWord(ctx, a->r1, REG_DEST);
    val &= 0xFFFFFFFFFFFF0000;
    val |= ((QWord_t) a->imm) << 0;
    writeQWord(ctx, a->r1, set_flags(ctx, val), REG_DEST);
    return true;
}
static bool trans_movk_16(DisasContext *ctx, arg_movk_16 *a) {
    QWord_t val = readQWord(ctx, a->r1, REG_DEST);
    val &= 0xFFFFFFFF0000FFFF;
    val |= ((QWord_t) a->imm) << 16;
    writeQWord(ctx, a->r1, set_flags(ctx, val), REG_DEST);
    return true;
}
static bool trans_movk_32(DisasContext *ctx, arg_movk_32 *a) {
    QWord_t val = readQWord(ctx, a->r1, REG_DEST);
    val &= 0xFFFF0000FFFFFFFF;
    val |= ((QWord_t) a->imm) << 32;
    writeQWord(ctx, a->r1, set_flags(ctx, val), REG_DEST);
    return true;
}
static bool trans_movk_48(DisasContext *ctx, arg_movk_48 *a) {
    QWord_t val = readQWord(ctx, a->r1, REG_DEST);
    val &= 0x0000FFFFFFFFFFFF;
    val |= ((QWord_t) a->imm) << 48;
    writeQWord(ctx, a->r1, set_flags(ctx, val), REG_DEST);
    return true;
}
static bool trans_ldr_reg(DisasContext *ctx, arg_ldr_reg *a) {
    QWord_t addr = readQWord(ctx, a->r2, REG_SRC1) + (readQWord(ctx, a->r3, REG_SRC2) << a->shift);
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, memReadByte(ctx, (void*) addr), REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, memReadWord(ctx, (void*) addr), REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, memReadDWord(ctx, (void*) addr), REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, memReadQWord(ctx, (void*) addr), REG_DEST); break;
    }
    return true;
}
static bool trans_ldr_reg_update(DisasContext *ctx, arg_ldr_reg_update *a) {
    QWord_t addr = readQWord(ctx, a->r2, REG_SRC1);
    writeQWord(ctx, a->r2, addr + (readQWord(ctx, a->r3, REG_SRC2) << a->shift), REG_SRC1);
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, memReadByte(ctx, (void*) addr), REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, memReadWord(ctx, (void*) addr), REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, memReadDWord(ctx, (void*) addr), REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, memReadQWord(ctx, (void*) addr), REG_DEST); break;
    }
    return true;
}
static bool trans_ldr_imm(DisasContext *ctx, arg_ldr_imm *a) {
    QWord_t addr = readQWord(ctx, a->r2, REG_SRC1) + a->imm;
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, memReadByte(ctx, (void*) addr), REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, memReadWord(ctx, (void*) addr), REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, memReadDWord(ctx, (void*) addr), REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, memReadQWord(ctx, (void*) addr), REG_DEST); break;
    }
    return true;
}
static bool trans_ldr_imm_update(DisasContext *ctx, arg_ldr_imm_update *a) {
    QWord_t addr = readQWord(ctx, a->r2, REG_SRC1);
    writeQWord(ctx, a->r2, addr + a->imm, REG_SRC1);
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, memReadByte(ctx, (void*) addr), REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, memReadWord(ctx, (void*) addr), REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, memReadDWord(ctx, (void*) addr), REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, memReadQWord(ctx, (void*) addr), REG_DEST); break;
    }
    return true;
}
static bool trans_str_reg(DisasContext *ctx, arg_str_reg *a) {
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
    QWord_t addr = readQWord(ctx, a->r2, REG_SRC1);
    writeQWord(ctx, a->r2, addr += (readQWord(ctx, a->r3, REG_SRC2) << a->shift), REG_SRC1);
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: memWriteByte(ctx, (void*) addr, readByte(ctx, a->r1, REG_DEST)); break;
        case SIZE_16BIT: memWriteWord(ctx, (void*) addr, readWord(ctx, a->r1, REG_DEST)); break;
        case SIZE_32BIT: memWriteDWord(ctx, (void*) addr, readDWord(ctx, a->r1, REG_DEST)); break;
        case SIZE_64BIT: memWriteQWord(ctx, (void*) addr, readQWord(ctx, a->r1, REG_DEST)); break;
    }
    return true;
}
static bool trans_str_imm(DisasContext *ctx, arg_str_imm *a) {
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
    QWord_t addr = readQWord(ctx, a->r2, REG_SRC1);
    writeQWord(ctx, a->r2, addr += a->imm, REG_SRC1);
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: memWriteByte(ctx, (void*) addr, readByte(ctx, a->r1, REG_DEST)); break;
        case SIZE_16BIT: memWriteWord(ctx, (void*) addr, readWord(ctx, a->r1, REG_DEST)); break;
        case SIZE_32BIT: memWriteDWord(ctx, (void*) addr, readDWord(ctx, a->r1, REG_DEST)); break;
        case SIZE_64BIT: memWriteQWord(ctx, (void*) addr, readQWord(ctx, a->r1, REG_DEST)); break;
    }
    return true;
}
static bool trans_ldr_pc_rel(DisasContext *ctx, arg_ldr_pc_rel *a) {
    QWord_t addr = PC_REL(a->rel);
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, memReadByte(ctx, (void*) addr), REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, memReadWord(ctx, (void*) addr), REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, memReadDWord(ctx, (void*) addr), REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, memReadQWord(ctx, (void*) addr), REG_DEST); break;
    }
    return true;
}
static bool trans_str_pc_rel(DisasContext *ctx, arg_str_pc_rel *a) {
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
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, extract64(readByte(ctx, a->r2, REG_SRC1), a->start, a->count + 1), REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, extract64(readWord(ctx, a->r2, REG_SRC1), a->start, a->count + 1), REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, extract64(readDWord(ctx, a->r2, REG_SRC1), a->start, a->count + 1), REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, extract64(readQWord(ctx, a->r2, REG_SRC1), a->start, a->count + 1), REG_DEST); break;
    }
    return true;
}
static bool trans_sbxt(DisasContext *ctx, arg_sbxt *a) {
    switch (ctx->cr[CR_FLAGS].asFlags.size) {
        case SIZE_8BIT: writeSByte(ctx, a->r1, sextract64(readByte(ctx, a->r2, REG_SRC1), a->start, a->count + 1), REG_DEST); break;
        case SIZE_16BIT: writeSWord(ctx, a->r1, sextract64(readWord(ctx, a->r2, REG_SRC1), a->start, a->count + 1), REG_DEST); break;
        case SIZE_32BIT: writeSDWord(ctx, a->r1, sextract64(readDWord(ctx, a->r2, REG_SRC1), a->start, a->count + 1), REG_DEST); break;
        case SIZE_64BIT: writeSQWord(ctx, a->r1, sextract64(readQWord(ctx, a->r2, REG_SRC1), a->start, a->count + 1), REG_DEST); break;
    }
    return true;
}
static bool trans_ubdp(DisasContext *ctx, arg_ubdp *a) {
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
        case SIZE_8BIT: writeByte(ctx, a->r1, val, REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, val, REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, val, REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, val, REG_DEST); break;
    }
    return true;
}
static bool trans_sbdp(DisasContext *ctx, arg_sbdp *a) {
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
        case SIZE_8BIT: writeByte(ctx, a->r1, val, REG_DEST); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, val, REG_DEST); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, val, REG_DEST); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, val, REG_DEST); break;
    }
    return true;
}

#define VABS(_val) _Generic((_val), \
    Byte_t: vabs8, SByte_t: vabs8, \
    Word_t: vabs16, SWord_t: vabs16, \
    DWord_t: vabs32, SDWord_t: vabs32, \
    QWord_t: vabs64, SQWord_t: vabs64, \
    LWord_t: vabs128, SLWord_t: vabs128, \
    Float32_t: vabsf32, Float64_t: vabsf64 \
)((_val))

#define VABSFUNC(_ty, _sz) static inline _ty vabs ## _sz(_ty x) { \
    if (x < 0) return -x; \
    return x; \
}

VABSFUNC(SByte_t, 8)
VABSFUNC(SWord_t, 16)
VABSFUNC(SDWord_t, 32)
VABSFUNC(SQWord_t, 64)
VABSFUNC(SLWord_t, 128)
VABSFUNC(Float32_t, f32)
VABSFUNC(Float64_t, f64)

#define vop_(_type, _what) for (size_t i = 0; i < sizeof(ctx->v[0].as ## _type) / sizeof(ctx->v[0].as ## _type[0]); i++) { \
    ctx->v[a->v1].as ## _type[i] = ctx->v[a->v2].as ## _type[i] _what ctx->v[a->v3].as ## _type[i]; \
}
#define vop_as_(_type) for (size_t i = 0; i < sizeof(ctx->v[0].as ## _type) / sizeof(ctx->v[0].as ## _type[0]); i += 2) { \
    ctx->v[a->v1].as ## _type[i] = ctx->v[a->v2].as ## _type[i] + ctx->v[a->v3].as ## _type[i]; \
    ctx->v[a->v1].as ## _type[i + 1] = ctx->v[a->v2].as ## _type[i + 1] - ctx->v[a->v3].as ## _type[i + 1]; \
}
#define vop_madd_(_type) { \
    for (size_t i = 0; i < sizeof(ctx->v[0].as ## _type) / sizeof(ctx->v[0].as ## _type[0]); i++) { \
        ctx->v[a->v1].as ## _type[i] = ctx->v[a->v2].as ## _type[i] * ctx->v[a->v3].as ## _type[i]; \
    } \
    QWord_t counter = 0; \
    for (size_t i = 0; i < sizeof(ctx->v[0].as ## _type) / sizeof(ctx->v[0].as ## _type[0]); i++) { \
        counter += ctx->v[a->v1].as ## _type[i]; \
    } \
    ctx->v[a->v1].as ## _type[0] = counter; \
}
#define vop_movall_(_type, _sc) { \
    _sc ## _t val = read ## _sc(ctx, a->r2, REG_SRC1); \
    for (size_t i = 0; i < sizeof(ctx->v[0].as ## _type) / sizeof(ctx->v[0].as ## _type[0]); i++) { \
        ctx->v[a->v1].as ## _type[i] = val; \
    } \
}
#define vop_minmax_(_type) { \
    typeof(ctx->v[0].as ## _type[0]) min; \
    typeof(ctx->v[0].as ## _type[0]) max; \
    if (a->check_sign) { \
        for (size_t i = 0; i < sizeof(ctx->v[0].asS ## _type) / sizeof(ctx->v[0].asS ## _type[0]); i++) { \
            if (ctx->v[a->v2].asS ## _type[i] < min) { \
                min = ctx->v[a->v2].asS ## _type[i]; \
            } \
            if (ctx->v[a->v2].asS ## _type[i] > max) { \
                max = ctx->v[a->v2].asS ## _type[i]; \
            } \
        } \
    } else { \
        for (size_t i = 0; i < sizeof(ctx->v[0].as ## _type) / sizeof(ctx->v[0].as ## _type[0]); i++) { \
            if (ctx->v[a->v2].as ## _type[i] < min) { \
                min = ctx->v[a->v2].as ## _type[i]; \
            } \
            if (ctx->v[a->v2].as ## _type[i] > max) { \
                max = ctx->v[a->v2].as ## _type[i]; \
            } \
        } \
    } \
    ctx->v[a->v1].as ## _type[0] = min; \
    ctx->v[a->v1].as ## _type[1] = max; \
}
#define vpu_cmp_(_type) { \
    uint32_t flags = ctx->cr[CR_FLAGS].asDWord; \
    for (size_t i = 0; i < sizeof(ctx->v[0].as ## _type) / sizeof(ctx->v[0].as ## _type[0]); i++) { \
        set_flags(ctx, ctx->v[a->v2].as ## _type[i] - ctx->v[a->v3].as ## _type[i]); \
        ctx->v[a->v1].as ## _type[i] = check_condition1(a->cond, ctx->cr[CR_FLAGS].asFlags); \
    } \
    ctx->cr[CR_FLAGS].asDWord = flags; \
}
#define vpu_tst_(_type) { \
    uint32_t flags = ctx->cr[CR_FLAGS].asDWord; \
    for (size_t i = 0; i < sizeof(ctx->v[0].as ## _type) / sizeof(ctx->v[0].as ## _type[0]); i++) { \
        set_flags(ctx, ctx->v[a->v2].as ## _type[i] & ctx->v[a->v3].as ## _type[i]); \
        ctx->v[a->v1].as ## _type[i] = check_condition1(a->cond, ctx->cr[CR_FLAGS].asFlags); \
    } \
    ctx->cr[CR_FLAGS].asDWord = flags; \
}

#define vpu_abs_(_type) { \
    for (size_t i = 0; i < sizeof(ctx->v[0].as ## _type) / sizeof(ctx->v[0].as ## _type[0]); i++) { \
        ctx->v[a->v1].as ## _type[i] = VABS(ctx->v[a->v2].as ## _type[i]); \
    } \
}
#define vop_sqrt_(_type) { \
    for (size_t i = 0; i < sizeof(ctx->v[0].as ## _type) / sizeof(ctx->v[0].as ## _type[0]); i++) { \
        ctx->v[a->v1].as ## _type[i] = sqrt(ctx->v[a->v2].as ## _type[i]); \
    } \
}
#define vop_fmod32() { \
    for (size_t i = 0; i < sizeof(ctx->v[0].asFloat32s) / sizeof(ctx->v[0].asFloat32s[0]); i++) { \
        ctx->v[a->v1].asFloat32s[i] = fmodf(ctx->v[a->v2].asFloat32s[i], ctx->v[a->v3].asFloat32s[i]); \
    } \
}
#define vop_fmod64() { \
    for (size_t i = 0; i < sizeof(ctx->v[0].asFloat64s) / sizeof(ctx->v[0].asFloat64s[0]); i++) { \
        ctx->v[a->v1].asFloat64s[i] = fmod(ctx->v[a->v2].asFloat64s[i], ctx->v[a->v3].asFloat64s[i]); \
    } \
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
        writeQWord(ctx, a->r1, set_flags(ctx, count), REG_DEST); \
    } while (0)

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
#define vop_movall(_type, _sc) vop_movall_(_type, _sc)
#define vop_minmax(_type) vop_minmax_(_type)
#define vpu_cmp(_type) vpu_cmp_(_type)
#define vpu_tst(_type) vpu_tst_(_type)
#define vpu_abs(_type) vpu_abs_(_type)
#define vop_sqrt(_type) vop_sqrt_(_type)
#define vpu_len(_what) vpu_len_(_what)

#define vpu_o QWord
#define vpu_b Bytes
#define vpu_w Words
#define vpu_d DWords
#define vpu_q QWords
#define vpu_l LWords
#define vpu_s Float32s
#define vpu_f Float64s

#define vpus_o SQWord
#define vpus_b SBytes
#define vpus_w SWords
#define vpus_d SDWords
#define vpus_q SQWords
#define vpus_l SLWords
#define vpus_s Float32s
#define vpus_f Float64s

static bool trans_vadd(DisasContext *ctx, arg_vadd *a) {
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
    switch (a->type) {
        case 0: raise(SIGILL); break;
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
    switch (a->type) {
        case 0: raise(SIGILL); break;
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
    switch (a->type) {
        case 0: ctx->v[a->v1].asQWord[0] = readQWord(ctx, a->r2, REG_SRC1); break;
        case 1: ctx->v[a->v1].asBytes[a->slot] = readByte(ctx, a->r2, REG_SRC1); break;
        case 2: ctx->v[a->v1].asWords[a->slot] = readWord(ctx, a->r2, REG_SRC1); break;
        case 3: ctx->v[a->v1].asDWords[a->slot] = readDWord(ctx, a->r2, REG_SRC1); break;
        case 4: ctx->v[a->v1].asQWords[a->slot] = readQWord(ctx, a->r2, REG_SRC1); break;
        case 5: ctx->v[a->v1].asLWords[a->slot] = readQWord(ctx, a->r2, REG_SRC1); break;
        case 6: ctx->v[a->v1].asFloat32s[a->slot] = readFloat32(ctx, a->r2, REG_SRC1); break;
        case 7: ctx->v[a->v1].asFloat64s[a->slot] = readFloat64(ctx, a->r2, REG_SRC1); break;
    }
    return true;
}
static bool trans_vmov_reg2(DisasContext *ctx, arg_vmov_reg2 *a) {
    switch (a->type) {
        case 0: writeQWord(ctx, a->r2, ctx->v[a->v1].asQWord[0], REG_DEST); break;
        case 1: writeByte(ctx, a->r2, ctx->v[a->v1].asBytes[a->slot], REG_DEST); break;
        case 2: writeWord(ctx, a->r2, ctx->v[a->v1].asWords[a->slot], REG_DEST); break;
        case 3: writeDWord(ctx, a->r2, ctx->v[a->v1].asDWords[a->slot], REG_DEST); break;
        case 4: writeQWord(ctx, a->r2, ctx->v[a->v1].asQWords[a->slot], REG_DEST); break;
        case 5: writeQWord(ctx, a->r2, ctx->v[a->v1].asLWords[a->slot], REG_DEST); break;
        case 6: writeFloat32(ctx, a->r2, ctx->v[a->v1].asFloat32s[a->slot], REG_DEST); break;
        case 7: writeFloat64(ctx, a->r2, ctx->v[a->v1].asFloat64s[a->slot], REG_DEST); break;
    }
    return true;
}
static bool trans_vmov(DisasContext *ctx, arg_vmov *a) {
    ctx->v[a->v1] = ctx->v[a->v2];
    return true;
}
static bool trans_vconv(DisasContext *ctx, arg_vconv *a) {
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
    QWord_t addr = readQWord(ctx, a->r1, REG_SRC1) + a->imm;
    ctx->v[a->v1] = *(hive_vector_register_t*) addr;
    return true;
}
static bool trans_vldr_imm_update(DisasContext *ctx, arg_vldr_imm_update *a) {
    QWord_t addr = readQWord(ctx, a->r1, REG_SRC1);
    writeQWord(ctx, a->r1, addr + a->imm, REG_SRC1);
    ctx->v[a->v1] = *(hive_vector_register_t*) addr;
    return true;
}
static bool trans_vstr_imm(DisasContext *ctx, arg_vstr_imm *a) {
    QWord_t addr = readQWord(ctx, a->r1, REG_SRC1) + a->imm;
    *(hive_vector_register_t*) addr = ctx->v[a->v1];
    return true;
}
static bool trans_vstr_imm_update(DisasContext *ctx, arg_vstr_imm_update *a) {
    QWord_t addr = readQWord(ctx, a->r1, REG_SRC1) + a->imm;
    writeQWord(ctx, a->r1, addr, REG_SRC1);
    *(hive_vector_register_t*) addr = ctx->v[a->v1];
    return true;
}
static bool trans_vldr_reg(DisasContext *ctx, arg_vldr_reg *a) {
    QWord_t addr = readQWord(ctx, a->r1, REG_SRC1) + readQWord(ctx, a->r2, REG_SRC2);
    ctx->v[a->v1] = *(hive_vector_register_t*) addr;
    return true;
}
static bool trans_vldr_reg_update(DisasContext *ctx, arg_vldr_reg_update *a) {
    QWord_t addr = readQWord(ctx, a->r1, REG_SRC1);
    writeQWord(ctx, a->r1, addr + readQWord(ctx, a->r2, REG_SRC2), REG_SRC1);
    ctx->v[a->v1] = *(hive_vector_register_t*) addr;
    return true;
}
static bool trans_vstr_reg(DisasContext *ctx, arg_vstr_reg *a) {
    QWord_t addr = readQWord(ctx, a->r1, REG_SRC1) + readQWord(ctx, a->r2, REG_SRC2);
    *(hive_vector_register_t*) addr = ctx->v[a->v1];
    return true;
}
static bool trans_vstr_reg_update(DisasContext *ctx, arg_vstr_reg_update *a) {
    QWord_t addr = readQWord(ctx, a->r1, REG_SRC1) + readQWord(ctx, a->r2, REG_SRC2);
    writeQWord(ctx, a->r1, addr, REG_SRC1);
    *(hive_vector_register_t*) addr = ctx->v[a->v1];
    return true;
}
static bool trans_vand(DisasContext *ctx, arg_vand *a) {
    switch (a->type) {
        case 0: vop(vpu_o, &); break;
        case 1: vop(vpu_b, &); break;
        case 2: vop(vpu_w, &); break;
        case 3: vop(vpu_d, &); break;
        case 4: vop(vpu_q, &); break;
        case 5: vop(vpu_l, &); break;
        case 6: raise(SIGILL); break;
        case 7: raise(SIGILL); break;
    }
    return true;
}
static bool trans_vor(DisasContext *ctx, arg_vor *a) {
    switch (a->type) {
        case 0: vop(vpu_o, |); break;
        case 1: vop(vpu_b, |); break;
        case 2: vop(vpu_w, |); break;
        case 3: vop(vpu_d, |); break;
        case 4: vop(vpu_q, |); break;
        case 5: vop(vpu_l, |); break;
        case 6: raise(SIGILL); break;
        case 7: raise(SIGILL); break;
    }
    return true;
}
static bool trans_vxor(DisasContext *ctx, arg_vxor *a) {
    switch (a->type) {
        case 0: vop(vpu_o, ^); break;
        case 1: vop(vpu_b, ^); break;
        case 2: vop(vpu_w, ^); break;
        case 3: vop(vpu_d, ^); break;
        case 4: vop(vpu_q, ^); break;
        case 5: vop(vpu_l, ^); break;
        case 6: raise(SIGILL); break;
        case 7: raise(SIGILL); break;
    }
    return true;
}
static bool trans_vcmp(DisasContext *ctx, arg_vcmp *a) {
    switch (a->type) {
        case 0: vpu_cmp(vpu_o); break;
        case 1: vpu_cmp(vpu_b); break;
        case 2: vpu_cmp(vpu_w); break;
        case 3: vpu_cmp(vpu_d); break;
        case 4: vpu_cmp(vpu_q); break;
        case 5: vpu_cmp(vpu_l); break;
        case 6: vpu_cmp(vpu_s); break;
        case 7: vpu_cmp(vpu_f); break;
    }
    return true;
}
static bool trans_vtst(DisasContext *ctx, arg_vtst *a) {
    switch (a->type) {
        case 0: vpu_tst(vpu_o); break;
        case 1: vpu_tst(vpu_b); break;
        case 2: vpu_tst(vpu_w); break;
        case 3: vpu_tst(vpu_d); break;
        case 4: vpu_tst(vpu_q); break;
        case 5: vpu_tst(vpu_l); break;
        case 6: raise(SIGILL); break;
        case 7: raise(SIGILL); break;
    }
    return true;
}
static bool trans_vminmax(DisasContext *ctx, arg_vminmax *a) {
    switch (a->type) {
        case 0: vop_minmax(vpu_o); break;
        case 1: vop_minmax(vpu_b); break;
        case 2: vop_minmax(vpu_w); break;
        case 3: vop_minmax(vpu_d); break;
        case 4: vop_minmax(vpu_q); break;
        case 5: vop_minmax(vpu_l); break;
        case 6: vop_minmax(vpu_s); break;
        case 7: vop_minmax(vpu_f); break;
    }
    return true;
}
static bool trans_vabs(DisasContext *ctx, arg_vabs *a) {
    switch (a->type) {
        case 0: vpu_abs(vpu_o); break;
        case 1: vpu_abs(vpu_b); break;
        case 2: vpu_abs(vpu_w); break;
        case 3: vpu_abs(vpu_d); break;
        case 4: vpu_abs(vpu_q); break;
        case 5: vpu_abs(vpu_l); break;
        case 6: vpu_abs(vpu_s); break;
        case 7: vpu_abs(vpu_f); break;
    }
    return true;
}
static bool trans_vshl(DisasContext *ctx, arg_vshl *a) {
    switch (a->type) {
        case 0: vop(vpu_o, <<); break;
        case 1: vop(vpu_b, <<); break;
        case 2: vop(vpu_w, <<); break;
        case 3: vop(vpu_d, <<); break;
        case 4: vop(vpu_q, <<); break;
        case 5: vop(vpu_l, <<); break;
        case 6: raise(SIGILL); break;
        case 7: raise(SIGILL); break;
    }
    return true;
}
static bool trans_vshr(DisasContext *ctx, arg_vshr *a) {
    if (a->is_signed) {
        switch (a->type) {
            case 0: vop(vpus_o, >>); break;
            case 1: vop(vpus_b, >>); break;
            case 2: vop(vpus_w, >>); break;
            case 3: vop(vpus_d, >>); break;
            case 4: vop(vpus_q, >>); break;
            case 5: vop(vpus_l, >>); break;
            case 6: raise(SIGILL); break;
            case 7: raise(SIGILL); break;
        }
    } else {
        switch (a->type) {
            case 0: vop(vpu_o, >>); break;
            case 1: vop(vpu_b, >>); break;
            case 2: vop(vpu_w, >>); break;
            case 3: vop(vpu_d, >>); break;
            case 4: vop(vpu_q, >>); break;
            case 5: vop(vpu_l, >>); break;
            case 6: raise(SIGILL); break;
            case 7: raise(SIGILL); break;
        }
    }
    return true;
}
static bool trans_vsqrt(DisasContext *ctx, arg_vsqrt *a) {
    switch (a->type) {
        case 0: vop_sqrt(vpu_o); break;
        case 1: vop_sqrt(vpu_b); break;
        case 2: vop_sqrt(vpu_w); break;
        case 3: vop_sqrt(vpu_d); break;
        case 4: vop_sqrt(vpu_q); break;
        case 5: vop_sqrt(vpu_l); break;
        case 6: vop_sqrt(vpu_s); break;
        case 7: vop_sqrt(vpu_f); break;
    }
    return true;
}
static bool trans_vmod(DisasContext *ctx, arg_vmod *a) {
    switch (a->type) {
        case 0: vop(vpu_o, %); break;
        case 1: vop(vpu_b, %); break;
        case 2: vop(vpu_w, %); break;
        case 3: vop(vpu_d, %); break;
        case 4: vop(vpu_q, %); break;
        case 5: vop(vpu_l, %); break;
        case 6: vop_fmod32(); break;
        case 7: vop_fmod64(); break;
    }
    return true;
}
static bool trans_vmovall(DisasContext *ctx, arg_vmovall *a) {
    switch (a->type) {
        case 0: vop_movall(vpu_o, QWord); break;
        case 1: vop_movall(vpu_b, Byte); break;
        case 2: vop_movall(vpu_w, Word); break;
        case 3: vop_movall(vpu_d, DWord); break;
        case 4: vop_movall(vpu_q, QWord); break;
        case 5: vop_movall(vpu_l, QWord); break;
        case 6: vop_movall(vpu_s, Float32); break;
        case 7: vop_movall(vpu_f, Float64); break;
    }
    return true;
}

void coredump(struct cpu_state* ctx);
char* dis(hive_instruction_t** ins, uint64_t addr);

void exec_instr(struct cpu_state* ctx, uint32_t ins) {
    if (
        check_condition(*(hive_instruction_t*) &ins, ctx->cr[CR_FLAGS].asFlags) &&
        !decode(ctx, ins)
    ) {
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

int runstate(struct cpu_state* ctx) {
    size_t current_thread = 0;

    int sig = setjmp(lidt);
    if (sig == 0) {
        ctx->idt = lidt;
    } else {
        if (ctx->cr[CR_IDT].asQWord == 0 || handling_interrupt || (sig != SIGILL && sig != SIGBUS && sig != SIGSEGV && sig != SIGTRAP)) {
            hive_instruction_t* x = ctx->r[REG_PC].asInstrPtr;
            if (x) {
                hive_instruction_t* old_x = x;
                char* s = dis(&x, (uint64_t) x);
                if (s) {
                    printf("%016llx: %s\n", (uint64_t) old_x, s);
                } else {
                    printf("%016llx: .dword 0x%08x\n", (uint64_t) old_x, *(uint32_t*) old_x);
                }
                free(s);
            }
            fprintf(stderr, "Fault on vcore #%llu: %s\n", ctx->cr[CR_CPUID].asQWord, strsignal(sig));
            return sig;
        }
        uint8_t ints[] = {
            [SIGILL] = INT_UD,
            [SIGBUS] = INT_PF,
            [SIGSEGV] = INT_GP,
            [SIGTRAP] = INT_IP,
        };
        handling_interrupt = true;
        ctx->r[REG_SP].asQWord -= 16;
        ctx->r[REG_SP].asQWordPtr[0] = ctx->r[REG_PC].asQWord;
        ctx->r[REG_SP].asQWordPtr[1] = ctx->cr[CR_RUNLEVEL].asQWord;
        ctx->r[REG_PC].asQWord = ctx->cr[CR_IDT].asQWordPtr[ints[sig]];
        ctx->cr[CR_RUNLEVEL].asQWord = EM_HYPERVISOR;
        sig = 0;
    }
    while (1) {
        exec_instr(ctx, memReadDWord(ctx, ctx->r[REG_PC].asPointer));
        ctx->r[REG_PC].asDWordPtr++;
        ctx->cr[CR_CYCLES].asQWord++;
    }
}

void interrupt_handler(int sig) {
    longjmp(lidt, sig);
}

void exec(void* start) {
    struct cpu_state cpu_state = {0};
    cpu_state.r[REG_PC].asPointer = start;
    cpu_state.cr[CR_CPUID].asQWord = 0;
    cpu_state.cr[CR_CORES].asQWord = 1;
    cpu_state.cr[CR_THREADS].asQWord = 1;
    cpu_state.cr[CR_FLAGS].asFlags.size = SIZE_64BIT;
    
    signal(SIGABRT, interrupt_handler);
    signal(SIGILL, interrupt_handler);
    signal(SIGSEGV, interrupt_handler);
    signal(SIGBUS, interrupt_handler);
    signal(SIGTRAP, interrupt_handler);

    int ret_val = runstate(&cpu_state);
    if (ret_val) {
        fprintf(stderr, "vcore #0 locked up/crashed abnormally: %d\n", ret_val);
        exit(ret_val);
    }
    exit(cpu_state.r[0].asQWord);
}
