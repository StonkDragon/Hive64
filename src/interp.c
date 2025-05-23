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
    QWord_t: set_flags64, SQWord_t: set_flags64, \
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
    QWord_t: ror64, SQWord_t: ror64, \
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

#define swap_bytes(x) _Generic((x), \
    QWord_t: swap_bytes_64, SQWord_t: swap_bytes_64, \
    uint64_t: swap_bytes_64, int64_t: swap_bytes_64, \
    uint32_t: swap_bytes_32, int32_t: swap_bytes_32, \
    uint16_t: swap_bytes_16, int16_t: swap_bytes_16, \
    uint8_t: swap_bytes_8, int8_t: swap_bytes_8 \
)(x)

#define INTENT_WRITE 1
#define INTENT_READ 0

#define reg_reader(_type) \
static inline _type ## _t read ## _type (struct cpu_state* ctx, uint8_t reg) { \
    if (sizeof(_type ## _t) != sizeof(QWord_t)) { \
        if (unlikely(reg & 0x10)) { \
            return ctx->r[reg & 0x0F].as ## _type ## Pair.high; \
        } else { \
            return ctx->r[reg & 0x0F].as ## _type ## Pair.low; \
        } \
    } else { \
        return ctx->r[reg].as ## _type; \
    } \
}
#define reg_writer(_type) \
static inline void write ## _type (struct cpu_state* ctx, uint8_t reg, _type ## _t val) { \
    if (sizeof(_type ## _t) != sizeof(QWord_t)) { \
        if (unlikely(reg & 0x10)) { \
            ctx->r[reg & 0x0F].as ## _type ## Pair.high = val; \
        } else { \
            ctx->r[reg & 0x0F].as ## _type ## Pair.low = val; \
        } \
    } else { \
        ctx->r[reg].as ## _type = val; \
    } \
}

extern svc_call svcs[];
__thread bool handling_interrupt = false;
__thread jmp_buf lidt;

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
Float32_t readFloat32(struct cpu_state* ctx, uint8_t reg) {
    return ctx->r[reg].asFloat32;
}
Float64_t readFloat64(struct cpu_state* ctx, uint8_t reg) {
    return ctx->r[reg].asFloat64;
}
QWord_t readQWord(struct cpu_state* ctx, uint8_t reg) {
    return ctx->r[reg].asQWord;
}
SQWord_t readSQWord(struct cpu_state* ctx, uint8_t reg) {
    return ctx->r[reg].asSQWord;
}

reg_writer(Byte)
reg_writer(Word)
reg_writer(DWord)
reg_writer(SByte)
reg_writer(SWord)
reg_writer(SDWord)
void writeFloat32(struct cpu_state* ctx, uint8_t reg, Float32_t val) {
    ctx->r[reg].asFloat32 = val;
}
void writeFloat64(struct cpu_state* ctx, uint8_t reg, Float64_t val) {
    ctx->r[reg].asFloat64 = val;
}
void writeQWord(struct cpu_state* ctx, uint8_t reg, QWord_t val) {
    ctx->r[reg].asQWord = val;
}
void writeSQWord(struct cpu_state* ctx, uint8_t reg, SQWord_t val) {
    ctx->r[reg].asSQWord = val;
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
    if (ctx->cr[CR_FLAGS].asFlags.allow_unaligned_mem) {
        return true;
    } else {
        if (read_size > 8) {
            return ((uint64_t) addr % 8) == 0;
        } else {
            return ((uint64_t) addr % read_size) == 0;
        }
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

bool hive64_branch(DisasContext *ctx, arg_branch *a) {
    BRANCH_RELATIVE(a->rel);
    return true;
}
bool hive64_branch_link(DisasContext *ctx, arg_branch_link *a) {
    LINK();
    BRANCH_RELATIVE(a->rel);
    return true;
}
bool hive64_branch_reg(DisasContext *ctx, arg_branch_reg *a) {
    BRANCH(readQWord(ctx, a->r1));
    return true;
}
bool hive64_branch_reg_link(DisasContext *ctx, arg_branch_reg_link *a) {
    LINK();
    BRANCH(readQWord(ctx, a->r1));
    return true;
}

#define ALU_R(_op) switch (a->size) { \
        case SIZE_8BIT: writeByte(ctx, a->r1, set_flags(ctx, readByte(ctx, a->r2) _op readByte(ctx, a->r3))); break; \
        case SIZE_16BIT: writeWord(ctx, a->r1, set_flags(ctx, readWord(ctx, a->r2) _op readWord(ctx, a->r3))); break; \
        case SIZE_32BIT: writeDWord(ctx, a->r1, set_flags(ctx, readDWord(ctx, a->r2) _op readDWord(ctx, a->r3))); break; \
        case SIZE_64BIT: writeQWord(ctx, a->r1, set_flags(ctx, readQWord(ctx, a->r2) _op readQWord(ctx, a->r3))); break; \
    }
#define ALU_I(_op) switch (a->size) { \
        case SIZE_8BIT: writeByte(ctx, a->r1, set_flags(ctx, readByte(ctx, a->r2) _op (Byte_t) a->imm8)); break; \
        case SIZE_16BIT: writeWord(ctx, a->r1, set_flags(ctx, readWord(ctx, a->r2) _op (Word_t) a->imm8)); break; \
        case SIZE_32BIT: writeDWord(ctx, a->r1, set_flags(ctx, readDWord(ctx, a->r2) _op (DWord_t) a->imm8)); break; \
        case SIZE_64BIT: writeQWord(ctx, a->r1, set_flags(ctx, readQWord(ctx, a->r2) _op (QWord_t) a->imm8)); break; \
    }
#define ALU_R_ROT(_rot) switch (a->size) { \
        case SIZE_8BIT: writeByte(ctx, a->r1, set_flags(ctx, _rot(readByte(ctx, a->r2), readByte(ctx, a->r3)))); break; \
        case SIZE_16BIT: writeWord(ctx, a->r1, set_flags(ctx, _rot(readWord(ctx, a->r2), readWord(ctx, a->r3)))); break; \
        case SIZE_32BIT: writeDWord(ctx, a->r1, set_flags(ctx, _rot(readDWord(ctx, a->r2), readDWord(ctx, a->r3)))); break; \
        case SIZE_64BIT: writeQWord(ctx, a->r1, set_flags(ctx, _rot(readQWord(ctx, a->r2), readQWord(ctx, a->r3)))); break; \
    }
#define ALU_I_ROT(_rot) switch (a->size) { \
        case SIZE_8BIT: writeByte(ctx, a->r1, set_flags(ctx, _rot(readByte(ctx, a->r2), (Byte_t) a->imm8))); break; \
        case SIZE_16BIT: writeWord(ctx, a->r1, set_flags(ctx, _rot(readWord(ctx, a->r2), (Word_t) a->imm8))); break; \
        case SIZE_32BIT: writeDWord(ctx, a->r1, set_flags(ctx, _rot(readDWord(ctx, a->r2), (DWord_t) a->imm8))); break; \
        case SIZE_64BIT: writeQWord(ctx, a->r1, set_flags(ctx, _rot(readQWord(ctx, a->r2), (QWord_t) a->imm8))); break; \
    }
#define ALU_R_DISC(_op) switch (a->size) { \
        case SIZE_8BIT: set_flags(ctx, readByte(ctx, a->r2) _op readByte(ctx, a->r3)); break; \
        case SIZE_16BIT: set_flags(ctx, readWord(ctx, a->r2) _op readWord(ctx, a->r3)); break; \
        case SIZE_32BIT: set_flags(ctx, readDWord(ctx, a->r2) _op readDWord(ctx, a->r3)); break; \
        case SIZE_64BIT: set_flags(ctx, readQWord(ctx, a->r2) _op readQWord(ctx, a->r3)); break; \
    }
#define ALU_I_DISC(_op) switch (a->size) { \
        case SIZE_8BIT: set_flags(ctx, readByte(ctx, a->r2) _op (Byte_t) a->imm8); break; \
        case SIZE_16BIT: set_flags(ctx, readWord(ctx, a->r2) _op (Word_t) a->imm8); break; \
        case SIZE_32BIT: set_flags(ctx, readDWord(ctx, a->r2) _op (DWord_t) a->imm8); break; \
        case SIZE_64BIT: set_flags(ctx, readQWord(ctx, a->r2) _op (QWord_t) a->imm8); break; \
    }
#define SALU_R(_op) switch (a->size) { \
        case SIZE_8BIT: writeSByte(ctx, a->r1, set_flags(ctx, readSByte(ctx, a->r2) _op readSByte(ctx, a->r3))); break; \
        case SIZE_16BIT: writeSWord(ctx, a->r1, set_flags(ctx, readSWord(ctx, a->r2) _op readSWord(ctx, a->r3))); break; \
        case SIZE_32BIT: writeSDWord(ctx, a->r1, set_flags(ctx, readSDWord(ctx, a->r2) _op readSDWord(ctx, a->r3))); break; \
        case SIZE_64BIT: writeSQWord(ctx, a->r1, set_flags(ctx, readSQWord(ctx, a->r2) _op readSQWord(ctx, a->r3))); break; \
    }
#define SALU_I(_op) switch (a->size) { \
        case SIZE_8BIT: writeSByte(ctx, a->r1, set_flags(ctx, readSByte(ctx, a->r2) _op (SByte_t) a->imm8)); break; \
        case SIZE_16BIT: writeSWord(ctx, a->r1, set_flags(ctx, readSWord(ctx, a->r2) _op (SWord_t) a->imm8)); break; \
        case SIZE_32BIT: writeSDWord(ctx, a->r1, set_flags(ctx, readSDWord(ctx, a->r2) _op (SDWord_t) a->imm8)); break; \
        case SIZE_64BIT: writeSQWord(ctx, a->r1, set_flags(ctx, readSQWord(ctx, a->r2) _op (SQWord_t) a->imm8)); break; \
    }

bool hive64_add_reg(DisasContext *ctx, arg_add_reg *a) {
    ALU_R(+);
    return true;
}
bool hive64_sub_reg(DisasContext *ctx, arg_sub_reg *a) {
    ALU_R(-);
    return true;
}
bool hive64_cmp_reg(DisasContext *ctx, arg_cmp_reg *a) {
    ALU_R_DISC(-);
    return true;
}
bool hive64_mul_reg(DisasContext *ctx, arg_mul_reg *a) {
    ALU_R(*);
    return true;
}
bool hive64_div_reg(DisasContext *ctx, arg_div_reg *a) {
    ALU_R(/);
    return true;
}
bool hive64_mod_reg(DisasContext *ctx, arg_mod_reg *a) {
    ALU_R(%);
    return true;
}
bool hive64_divs_reg(DisasContext *ctx, arg_divs_reg *a) {
    SALU_R(/);
    return true;
}
bool hive64_mods_reg(DisasContext *ctx, arg_mods_reg *a) {
    SALU_R(%);
    return true;
}
bool hive64_and_reg(DisasContext *ctx, arg_and_reg *a) {
    ALU_R(&)
    return true;
}
bool hive64_tst_reg(DisasContext *ctx, arg_tst_reg *a) {
    ALU_R_DISC(&)
    return true;
}
bool hive64_or_reg(DisasContext *ctx, arg_or_reg *a) {
    ALU_R(|)
    return true;
}
bool hive64_xor_reg(DisasContext *ctx, arg_xor_reg *a) {
    ALU_R(^)
    return true;
}
bool hive64_shl_reg(DisasContext *ctx, arg_shl_reg *a) {
    ALU_R(<<)
    return true;
}
bool hive64_shr_reg(DisasContext *ctx, arg_shr_reg *a) {
    ALU_R(>>)
    return true;
}
bool hive64_sar_reg(DisasContext *ctx, arg_sar_reg *a) {
    SALU_R(>>)
    return true;
}
bool hive64_rol_reg(DisasContext *ctx, arg_rol_reg *a) {
    ALU_R_ROT(ROL);
    return true;
}
bool hive64_ror_reg(DisasContext *ctx, arg_ror_reg *a) {
    ALU_R_ROT(ROR);
    return true;
}
bool hive64_add_imm(DisasContext *ctx, arg_add_imm *a) {
    ALU_I(+);
    return true;
}
bool hive64_sub_imm(DisasContext *ctx, arg_sub_imm *a) {
    ALU_I(-);
    return true;
}
bool hive64_cmp_imm(DisasContext *ctx, arg_cmp_imm *a) {
    ALU_I_DISC(-);
    return true;
}
bool hive64_mul_imm(DisasContext *ctx, arg_mul_imm *a) {
    ALU_I(*);
    return true;
}
bool hive64_div_imm(DisasContext *ctx, arg_div_imm *a) {
    ALU_I(/);
    return true;
}
bool hive64_mod_imm(DisasContext *ctx, arg_mod_imm *a) {
    ALU_I(%);
    return true;
}
bool hive64_divs_imm(DisasContext *ctx, arg_divs_imm *a) {
    SALU_I(/);
    return true;
}
bool hive64_mods_imm(DisasContext *ctx, arg_mods_imm *a) {
    SALU_I(%);
    return true;
}
bool hive64_and_imm(DisasContext *ctx, arg_and_imm *a) {
    ALU_I(&)
    return true;
}
bool hive64_tst_imm(DisasContext *ctx, arg_tst_imm *a) {
    ALU_I_DISC(&)
    return true;
}
bool hive64_or_imm(DisasContext *ctx, arg_or_imm *a) {
    ALU_I(|)
    return true;
}
bool hive64_xor_imm(DisasContext *ctx, arg_xor_imm *a) {
    ALU_I(^)
    return true;
}
bool hive64_shl_imm(DisasContext *ctx, arg_shl_imm *a) {
    ALU_I(<<)
    return true;
}
bool hive64_shr_imm(DisasContext *ctx, arg_shr_imm *a) {
    ALU_I(>>)
    return true;
}
bool hive64_sar_imm(DisasContext *ctx, arg_sar_imm *a) {
    SALU_I(>>)
    return true;
}
bool hive64_rol_imm(DisasContext *ctx, arg_rol_imm *a) {
    ALU_I_ROT(ROL);
    return true;
}
bool hive64_ror_imm(DisasContext *ctx, arg_ror_imm *a) {
    ALU_I_ROT(ROR);
    return true;
}
bool hive64_neg(DisasContext *ctx, arg_neg *a) {
    switch (a->size) {
        case SIZE_8BIT: writeSByte(ctx, a->r1, -readSByte(ctx, a->r2)); break;
        case SIZE_16BIT: writeSWord(ctx, a->r1, -readSWord(ctx, a->r2)); break;
        case SIZE_32BIT: writeSDWord(ctx, a->r1, -readSDWord(ctx, a->r2)); break;
        case SIZE_64BIT: writeSQWord(ctx, a->r1, -readSQWord(ctx, a->r2)); break;
    }
    return true;
}
bool hive64_not(DisasContext *ctx, arg_not *a) {
    switch (a->size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, ~readByte(ctx, a->r2)); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, ~readWord(ctx, a->r2)); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, ~readDWord(ctx, a->r2)); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, ~readQWord(ctx, a->r2)); break;
    }
    return true;
}
bool hive64_extend(DisasContext *ctx, arg_extend *a) {
    if (a->to <= a->size) {
        return false;
    }
    SQWord_t val;
    switch (a->size) {
        case SIZE_8BIT: val = readSByte(ctx, a->r2); break;
        case SIZE_16BIT: val = readSWord(ctx, a->r2); break;
        case SIZE_32BIT: val = readSDWord(ctx, a->r2); break;
        default: return false;
    }
    switch (a->to) {
        case SIZE_16BIT: writeSWord(ctx, a->r2, val); break;
        case SIZE_32BIT: writeSDWord(ctx, a->r2, val); break;
        case SIZE_64BIT: writeSQWord(ctx, a->r2, val); break;
        default: return false;
    }

    return true;
}
bool hive64_swe(DisasContext *ctx, arg_swe *a) {
    switch (a->size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, swap_bytes(readByte(ctx, a->r2))); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, swap_bytes(readWord(ctx, a->r2))); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, swap_bytes(readDWord(ctx, a->r2))); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, swap_bytes(readQWord(ctx, a->r2))); break;
    }
    return true;
}
bool hive64_cswp(DisasContext *ctx, arg_cswp *a) {
    uint8_t reg = a->r3;
    int check_condition1(uint8_t cond, hive_flag_register_t fr);
    if (check_condition1(a->cond, ctx->cr[CR_FLAGS].asFlags)) {
        reg = a->r2;
    }
    switch (a->size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, readByte(ctx, reg)); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, readWord(ctx, reg)); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, readDWord(ctx, reg)); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, readQWord(ctx, reg)); break;
    }
    return true;
}
bool hive64_xchg(DisasContext *ctx, arg_xchg *a) {
    switch (a->size) {
        case SIZE_8BIT: {
                Byte_t tmp = readByte(ctx, a->r1);
                writeByte(ctx, a->r1, readByte(ctx, a->r2));
                writeByte(ctx, a->r2, tmp);
            }
            break;
        case SIZE_16BIT: {
                Word_t tmp = readWord(ctx, a->r1);
                writeWord(ctx, a->r1, readWord(ctx, a->r2));
                writeWord(ctx, a->r2, tmp);
            }
            break;
        case SIZE_32BIT: {
                DWord_t tmp = readDWord(ctx, a->r1);
                writeDWord(ctx, a->r1, readDWord(ctx, a->r2));
                writeDWord(ctx, a->r2, tmp);
            }
            break;
        case SIZE_64BIT: {
                QWord_t tmp = readQWord(ctx, a->r1);
                writeQWord(ctx, a->r1, readQWord(ctx, a->r2));
                writeQWord(ctx, a->r2, tmp);
            }
            break;
    }
    return true;
}
bool hive64_fadd(DisasContext *ctx, arg_fadd *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2) + readFloat32(ctx, a->r3)));
    return true;
}
bool hive64_fsub(DisasContext *ctx, arg_fsub *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2) - readFloat32(ctx, a->r3)));
    return true;
}
bool hive64_fcmp(DisasContext *ctx, arg_fcmp *a) {
    set_flags(ctx, readFloat32(ctx, a->r2) - readFloat32(ctx, a->r3));
    return true;
}
bool hive64_fmul(DisasContext *ctx, arg_fmul *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2) * readFloat32(ctx, a->r3)));
    return true;
}
bool hive64_fdiv(DisasContext *ctx, arg_fdiv *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2) / readFloat32(ctx, a->r3)));
    return true;
}
bool hive64_fmod(DisasContext *ctx, arg_fmod *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, fmodf(readFloat32(ctx, a->r2), readFloat32(ctx, a->r3))));
    return true;
}
bool hive64_i2f(DisasContext *ctx, arg_i2f *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, readSDWord(ctx, a->r2)));
    return true;
}
bool hive64_fsin(DisasContext *ctx, arg_fsin *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, sinf(readFloat32(ctx, a->r2))));
    return true;
}
bool hive64_fsqrt(DisasContext *ctx, arg_fsqrt *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, sqrtf(readFloat32(ctx, a->r2))));
    return true;
}
bool hive64_f2d(DisasContext *ctx, arg_f2d *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat32(ctx, a->r2)));
    return true;
}

bool hive64_dadd(DisasContext *ctx, arg_dadd *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2) + readFloat64(ctx, a->r3)));
    return true;
}

bool hive64_dsub(DisasContext *ctx, arg_dsub *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2) - readFloat64(ctx, a->r3)));
    return true;
}

bool hive64_dcmp(DisasContext *ctx, arg_dcmp *a) {
    set_flags(ctx, readFloat64(ctx, a->r2) - readFloat64(ctx, a->r3));
    return true;
}

bool hive64_dmul(DisasContext *ctx, arg_dmul *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2) * readFloat64(ctx, a->r3)));
    return true;
}

bool hive64_ddiv(DisasContext *ctx, arg_ddiv *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2) / readFloat64(ctx, a->r3)));
    return true;
}

bool hive64_dmod(DisasContext *ctx, arg_dmod *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, fmod(readFloat64(ctx, a->r2), readFloat64(ctx, a->r3))));
    return true;
}

bool hive64_i2d(DisasContext *ctx, arg_i2d *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, readSDWord(ctx, a->r2)));
    return true;
}

bool hive64_d2i(DisasContext *ctx, arg_d2i *a) {
    writeSQWord(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2)));
    return true;
}

bool hive64_dsin(DisasContext *ctx, arg_dsin *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, sin(readFloat64(ctx, a->r2))));
    return true;
}

bool hive64_dsqrt(DisasContext *ctx, arg_dsqrt *a) {
    writeFloat64(ctx, a->r1, set_flags(ctx, sqrt(readFloat64(ctx, a->r2))));
    return true;
}

bool hive64_d2f(DisasContext *ctx, arg_d2f *a) {
    writeFloat32(ctx, a->r1, set_flags(ctx, readFloat64(ctx, a->r2)));
    return true;
}

bool hive64_cpuid(DisasContext *ctx, arg_cpuid *a) {
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
bool hive64_brk(DisasContext *ctx, arg_brk *a) {
    ctx->cr[CR_BREAK].asWord = a->what;
    raise(SIGTRAP);
    return true;
}
bool hive64_zeroupper(DisasContext *ctx, arg_zeroupper *a) {
    switch (a->size) {
        case SIZE_8BIT: {
            Byte_t value = readByte(ctx, a->r1);
            ctx->r[a->r1].asQWord = 0;
            writeByte(ctx, a->r1, value);
            break;
        }
        case SIZE_16BIT: {
            Word_t value = readWord(ctx, a->r1);
            ctx->r[a->r1].asQWord = 0;
            writeWord(ctx, a->r1, value);
            break;
        }
        case SIZE_32BIT: {
            DWord_t value = readDWord(ctx, a->r1);
            ctx->r[a->r1].asQWord = 0;
            writeDWord(ctx, a->r1, value);
            break;
        }
        default: return false;
    }
    return true;
}
bool hive64_sret(DisasContext *ctx, arg_sret *a) {
    check_permissions(ctx, EM_SUPERVISOR);
    ctx->r[REG_PC].asQWord = ctx->r[REG_LR].asQWord;
    ctx->cr[CR_RUNLEVEL].asQWord = EM_USER;
    return true;
}
bool hive64_hret(DisasContext *ctx, arg_hret *a) {
    check_permissions(ctx, EM_HYPERVISOR);
    ctx->r[REG_PC].asQWord = ctx->r[REG_LR].asQWord;
    ctx->cr[CR_RUNLEVEL].asQWord = EM_SUPERVISOR;
    return true;
}
bool hive64_iret(DisasContext *ctx, arg_iret *a) {
    check_permissions(ctx, EM_HYPERVISOR);
    ctx->cr[CR_RUNLEVEL].asQWord = ctx->r[REG_SP].asQWordPtr[1];
    BRANCH(ctx->r[REG_SP].asQWordPtr[0]);
    ctx->r[REG_SP].asQWord += 16;
    handling_interrupt = false;
    return true;
}
bool hive64_svc(DisasContext *ctx, arg_svc *a) {
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
bool hive64_mov_cr_r(DisasContext *ctx, arg_mov_cr_r *a) {
    check_permissions(ctx, EM_HYPERVISOR);
    ctx->cr[a->cr1].asQWord = set_flags(ctx, ctx->r[a->r1].asQWord);
    return true;
}
bool hive64_mov_r_cr(DisasContext *ctx, arg_mov_r_cr *a) {
    ctx->r[a->r1].asQWord = set_flags(ctx, ctx->cr[a->cr1].asQWord);
    return true;
}
bool hive64_hexit(DisasContext *ctx, arg_hexit *a) {
    check_permissions(ctx, EM_HYPERVISOR);
    ctx->cr[CR_RUNLEVEL].asQWord = EM_SUPERVISOR;
    return true;
}
bool hive64_sexit(DisasContext *ctx, arg_sexit *a) {
    check_permissions(ctx, EM_SUPERVISOR);
    ctx->cr[CR_RUNLEVEL].asQWord = EM_USER;
    return true;
}
bool hive64_lea(DisasContext *ctx, arg_lea *a) {
    writeQWord(ctx, a->r1, PC_REL(a->rel));
    return true;
}
bool hive64_movz_0(DisasContext *ctx, arg_movz_0 *a) {
    writeQWord(ctx, a->r1, set_flags(ctx, ((QWord_t) a->imm) << 0));
    return true;
}
bool hive64_movz_16(DisasContext *ctx, arg_movz_16 *a) {
    writeQWord(ctx, a->r1, set_flags(ctx, ((QWord_t) a->imm) << 16));
    return true;
}
bool hive64_movz_32(DisasContext *ctx, arg_movz_32 *a) {
    writeQWord(ctx, a->r1, set_flags(ctx, ((QWord_t) a->imm) << 32));
    return true;
}
bool hive64_movz_48(DisasContext *ctx, arg_movz_48 *a) {
    writeQWord(ctx, a->r1, set_flags(ctx, ((QWord_t) a->imm) << 48));
    return true;
}
bool hive64_movk_0(DisasContext *ctx, arg_movk_0 *a) {
    QWord_t val = readQWord(ctx, a->r1);
    val &= 0xFFFFFFFFFFFF0000;
    val |= ((QWord_t) a->imm) << 0;
    writeQWord(ctx, a->r1, set_flags(ctx, val));
    return true;
}
bool hive64_movk_16(DisasContext *ctx, arg_movk_16 *a) {
    QWord_t val = readQWord(ctx, a->r1);
    val &= 0xFFFFFFFF0000FFFF;
    val |= ((QWord_t) a->imm) << 16;
    writeQWord(ctx, a->r1, set_flags(ctx, val));
    return true;
}
bool hive64_movk_32(DisasContext *ctx, arg_movk_32 *a) {
    QWord_t val = readQWord(ctx, a->r1);
    val &= 0xFFFF0000FFFFFFFF;
    val |= ((QWord_t) a->imm) << 32;
    writeQWord(ctx, a->r1, set_flags(ctx, val));
    return true;
}
bool hive64_movk_48(DisasContext *ctx, arg_movk_48 *a) {
    QWord_t val = readQWord(ctx, a->r1);
    val &= 0x0000FFFFFFFFFFFF;
    val |= ((QWord_t) a->imm) << 48;
    writeQWord(ctx, a->r1, set_flags(ctx, val));
    return true;
}
bool hive64_ldr_reg(DisasContext *ctx, arg_ldr_reg *a) {
    QWord_t addr = readQWord(ctx, a->r2) + (readQWord(ctx, a->r3) << a->shift);
    switch (a->size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, memReadByte(ctx, (void*) addr)); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, memReadWord(ctx, (void*) addr)); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, memReadDWord(ctx, (void*) addr)); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, memReadQWord(ctx, (void*) addr)); break;
    }
    return true;
}
bool hive64_ldr_reg_update(DisasContext *ctx, arg_ldr_reg_update *a) {
    QWord_t addr = readQWord(ctx, a->r2);
    writeQWord(ctx, a->r2, addr + (readQWord(ctx, a->r3) << a->shift));
    switch (a->size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, memReadByte(ctx, (void*) addr)); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, memReadWord(ctx, (void*) addr)); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, memReadDWord(ctx, (void*) addr)); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, memReadQWord(ctx, (void*) addr)); break;
    }
    return true;
}
bool hive64_ldr_imm(DisasContext *ctx, arg_ldr_imm *a) {
    QWord_t addr = readQWord(ctx, a->r2) + a->imm;
    switch (a->size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, memReadByte(ctx, (void*) addr)); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, memReadWord(ctx, (void*) addr)); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, memReadDWord(ctx, (void*) addr)); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, memReadQWord(ctx, (void*) addr)); break;
    }
    return true;
}
bool hive64_ldr_imm_update(DisasContext *ctx, arg_ldr_imm_update *a) {
    QWord_t addr = readQWord(ctx, a->r2);
    writeQWord(ctx, a->r2, addr + a->imm);
    switch (a->size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, memReadByte(ctx, (void*) addr)); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, memReadWord(ctx, (void*) addr)); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, memReadDWord(ctx, (void*) addr)); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, memReadQWord(ctx, (void*) addr)); break;
    }
    return true;
}
bool hive64_str_reg(DisasContext *ctx, arg_str_reg *a) {
    QWord_t addr = readQWord(ctx, a->r2) + (readQWord(ctx, a->r3) << a->shift);
    switch (a->size) {
        case SIZE_8BIT: memWriteByte(ctx, (void*) addr, readByte(ctx, a->r1)); break;
        case SIZE_16BIT: memWriteWord(ctx, (void*) addr, readWord(ctx, a->r1)); break;
        case SIZE_32BIT: memWriteDWord(ctx, (void*) addr, readDWord(ctx, a->r1)); break;
        case SIZE_64BIT: memWriteQWord(ctx, (void*) addr, readQWord(ctx, a->r1)); break;
    }
    return true;
}
bool hive64_str_reg_update(DisasContext *ctx, arg_str_reg_update *a) {
    QWord_t addr = readQWord(ctx, a->r2);
    writeQWord(ctx, a->r2, addr += (readQWord(ctx, a->r3) << a->shift));
    switch (a->size) {
        case SIZE_8BIT: memWriteByte(ctx, (void*) addr, readByte(ctx, a->r1)); break;
        case SIZE_16BIT: memWriteWord(ctx, (void*) addr, readWord(ctx, a->r1)); break;
        case SIZE_32BIT: memWriteDWord(ctx, (void*) addr, readDWord(ctx, a->r1)); break;
        case SIZE_64BIT: memWriteQWord(ctx, (void*) addr, readQWord(ctx, a->r1)); break;
    }
    return true;
}
bool hive64_str_imm(DisasContext *ctx, arg_str_imm *a) {
    QWord_t addr = readQWord(ctx, a->r2) + a->imm;
    switch (a->size) {
        case SIZE_8BIT: memWriteByte(ctx, (void*) addr, readByte(ctx, a->r1)); break;
        case SIZE_16BIT: memWriteWord(ctx, (void*) addr, readWord(ctx, a->r1)); break;
        case SIZE_32BIT: memWriteDWord(ctx, (void*) addr, readDWord(ctx, a->r1)); break;
        case SIZE_64BIT: memWriteQWord(ctx, (void*) addr, readQWord(ctx, a->r1)); break;
    }
    return true;
}
bool hive64_str_imm_update(DisasContext *ctx, arg_str_imm_update *a) {
    QWord_t addr = readQWord(ctx, a->r2);
    writeQWord(ctx, a->r2, addr += a->imm);
    switch (a->size) {
        case SIZE_8BIT: memWriteByte(ctx, (void*) addr, readByte(ctx, a->r1)); break;
        case SIZE_16BIT: memWriteWord(ctx, (void*) addr, readWord(ctx, a->r1)); break;
        case SIZE_32BIT: memWriteDWord(ctx, (void*) addr, readDWord(ctx, a->r1)); break;
        case SIZE_64BIT: memWriteQWord(ctx, (void*) addr, readQWord(ctx, a->r1)); break;
    }
    return true;
}
bool hive64_ldr_pc_rel(DisasContext *ctx, arg_ldr_pc_rel *a) {
    QWord_t addr = PC_REL(a->rel);
    switch (a->size) {
        case SIZE_8BIT: writeByte(ctx, a->r1, memReadByte(ctx, (void*) addr)); break;
        case SIZE_16BIT: writeWord(ctx, a->r1, memReadWord(ctx, (void*) addr)); break;
        case SIZE_32BIT: writeDWord(ctx, a->r1, memReadDWord(ctx, (void*) addr)); break;
        case SIZE_64BIT: writeQWord(ctx, a->r1, memReadQWord(ctx, (void*) addr)); break;
    }
    return true;
}
bool hive64_str_pc_rel(DisasContext *ctx, arg_str_pc_rel *a) {
    QWord_t addr = PC_REL(a->rel);
    switch (a->size) {
        case SIZE_8BIT: memWriteByte(ctx, (void*) addr, readByte(ctx, a->r1)); break;
        case SIZE_16BIT: memWriteWord(ctx, (void*) addr, readWord(ctx, a->r1)); break;
        case SIZE_32BIT: memWriteDWord(ctx, (void*) addr, readDWord(ctx, a->r1)); break;
        case SIZE_64BIT: memWriteQWord(ctx, (void*) addr, readQWord(ctx, a->r1)); break;
    }
    return true;
}
bool hive64_ubxt(DisasContext *ctx, arg_ubxt *a) {
    writeQWord(ctx, a->r1, extract64(readQWord(ctx, a->r2), a->start, a->count + 1));
    return true;
}
bool hive64_sbxt(DisasContext *ctx, arg_sbxt *a) {
    writeSQWord(ctx, a->r1, sextract64(readQWord(ctx, a->r2), a->start, a->count + 1));
    return true;
}
bool hive64_ubdp(DisasContext *ctx, arg_ubdp *a) {
    QWord_t val = readQWord(ctx, a->r1);
    QWord_t ins = readQWord(ctx, a->r2);
    val = deposit64(val, a->start, a->count + 1, ins);
    writeQWord(ctx, a->r1, val);
    return true;
}
bool hive64_sbdp(DisasContext *ctx, arg_sbdp *a) {
    QWord_t val = readQWord(ctx, a->r1);
    QWord_t ins = readQWord(ctx, a->r2);
    val = deposit64(val, a->start, a->count + 1, ins);
    writeQWord(ctx, a->r1, val);
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
    _sc ## _t val = read ## _sc(ctx, a->r2); \
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
        writeQWord(ctx, a->r1, set_flags(ctx, count)); \
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

bool hive64_vadd(DisasContext *ctx, arg_vadd *a) {
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
bool hive64_vsub(DisasContext *ctx, arg_vsub *a) {
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
bool hive64_vmul(DisasContext *ctx, arg_vmul *a) {
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
bool hive64_vdiv(DisasContext *ctx, arg_vdiv *a) {
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
bool hive64_vaddsub(DisasContext *ctx, arg_vaddsub *a) {
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
bool hive64_vmadd(DisasContext *ctx, arg_vmadd *a) {
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
bool hive64_vmov_reg(DisasContext *ctx, arg_vmov_reg *a) {
    switch (a->type) {
        case 0: ctx->v[a->v1].asQWord[0] = readQWord(ctx, a->r2); break;
        case 1: ctx->v[a->v1].asBytes[a->slot] = readByte(ctx, a->r2); break;
        case 2: ctx->v[a->v1].asWords[a->slot] = readWord(ctx, a->r2); break;
        case 3: ctx->v[a->v1].asDWords[a->slot] = readDWord(ctx, a->r2); break;
        case 4: ctx->v[a->v1].asQWords[a->slot] = readQWord(ctx, a->r2); break;
        case 5: ctx->v[a->v1].asLWords[a->slot] = readQWord(ctx, a->r2); break;
        case 6: ctx->v[a->v1].asFloat32s[a->slot] = readFloat32(ctx, a->r2); break;
        case 7: ctx->v[a->v1].asFloat64s[a->slot] = readFloat32(ctx, a->r2); break;
    }
    return true;
}
bool hive64_vmov_reg2(DisasContext *ctx, arg_vmov_reg2 *a) {
    switch (a->type) {
        case 0: writeQWord(ctx, a->r2, ctx->v[a->v1].asQWord[0]); break;
        case 1: writeByte(ctx, a->r2, ctx->v[a->v1].asBytes[a->slot]); break;
        case 2: writeWord(ctx, a->r2, ctx->v[a->v1].asWords[a->slot]); break;
        case 3: writeDWord(ctx, a->r2, ctx->v[a->v1].asDWords[a->slot]); break;
        case 4: writeQWord(ctx, a->r2, ctx->v[a->v1].asQWords[a->slot]); break;
        case 5: writeQWord(ctx, a->r2, ctx->v[a->v1].asLWords[a->slot]); break;
        case 6: writeFloat32(ctx, a->r2, ctx->v[a->v1].asFloat32s[a->slot]); break;
        case 7: writeFloat64(ctx, a->r2, ctx->v[a->v1].asFloat64s[a->slot]); break;
    }
    return true;
}
bool hive64_vmov(DisasContext *ctx, arg_vmov *a) {
    ctx->v[a->v1] = ctx->v[a->v2];
    return true;
}
bool hive64_vconv(DisasContext *ctx, arg_vconv *a) {
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
bool hive64_vlen(DisasContext *ctx, arg_vlen *a) {
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
bool hive64_vldr_imm(DisasContext *ctx, arg_vldr_imm *a) {
    QWord_t* addr = (QWord_t*) (readQWord(ctx, a->r1) + a->imm);
    for (size_t i = 0; i < sizeof(ctx->v[a->v1].asQWords) / sizeof(ctx->v[a->v1].asQWords[0]); i++) {
        ctx->v[a->v1].asQWords[i] = memReadQWord(ctx, &addr[i]);
    }
    return true;
}
bool hive64_vldr_imm_update(DisasContext *ctx, arg_vldr_imm_update *a) {
    QWord_t* addr = (QWord_t*) (readQWord(ctx, a->r1));
    writeQWord(ctx, a->r1, (QWord_t) (addr + a->imm));
    for (size_t i = 0; i < sizeof(ctx->v[a->v1].asQWords) / sizeof(ctx->v[a->v1].asQWords[0]); i++) {
        ctx->v[a->v1].asQWords[i] = memReadQWord(ctx, &addr[i]);
    }
    return true;
}
bool hive64_vstr_imm(DisasContext *ctx, arg_vstr_imm *a) {
    QWord_t* addr = (QWord_t*) (readQWord(ctx, a->r1) + a->imm);
    for (size_t i = 0; i < sizeof(ctx->v[a->v1].asQWords) / sizeof(ctx->v[a->v1].asQWords[0]); i++) {
        memWriteQWord(ctx, &addr[i], ctx->v[a->v1].asQWords[i]);
    }
    return true;
}
bool hive64_vstr_imm_update(DisasContext *ctx, arg_vstr_imm_update *a) {
    QWord_t* addr = (QWord_t*) (readQWord(ctx, a->r1) + a->imm);
    writeQWord(ctx, a->r1, (QWord_t) (addr));
    for (size_t i = 0; i < sizeof(ctx->v[a->v1].asQWords) / sizeof(ctx->v[a->v1].asQWords[0]); i++) {
        memWriteQWord(ctx, &addr[i], ctx->v[a->v1].asQWords[i]);
    }
    return true;
}
bool hive64_vldr_reg(DisasContext *ctx, arg_vldr_reg *a) {
    QWord_t* addr = (QWord_t*) (readQWord(ctx, a->r1) + readQWord(ctx, a->r2));
    for (size_t i = 0; i < sizeof(ctx->v[a->v1].asQWords) / sizeof(ctx->v[a->v1].asQWords[0]); i++) {
        ctx->v[a->v1].asQWords[i] = memReadQWord(ctx, &addr[i]);
    }
    return true;
}
bool hive64_vldr_reg_update(DisasContext *ctx, arg_vldr_reg_update *a) {
    QWord_t* addr = (QWord_t*) (readQWord(ctx, a->r1));
    writeQWord(ctx, a->r1, (QWord_t) (addr + readQWord(ctx, a->r2)));
    for (size_t i = 0; i < sizeof(ctx->v[a->v1].asQWords) / sizeof(ctx->v[a->v1].asQWords[0]); i++) {
        ctx->v[a->v1].asQWords[i] = memReadQWord(ctx, &addr[i]);
    }
    return true;
}
bool hive64_vstr_reg(DisasContext *ctx, arg_vstr_reg *a) {
    QWord_t* addr = (QWord_t*) (readQWord(ctx, a->r1) + readQWord(ctx, a->r2));
    for (size_t i = 0; i < sizeof(ctx->v[a->v1].asQWords) / sizeof(ctx->v[a->v1].asQWords[0]); i++) {
        memWriteQWord(ctx, &addr[i], ctx->v[a->v1].asQWords[i]);
    }
    return true;
}
bool hive64_vstr_reg_update(DisasContext *ctx, arg_vstr_reg_update *a) {
    QWord_t* addr = (QWord_t*) (readQWord(ctx, a->r1) + readQWord(ctx, a->r2));
    writeQWord(ctx, a->r1, (QWord_t) (addr));
    for (size_t i = 0; i < sizeof(ctx->v[a->v1].asQWords) / sizeof(ctx->v[a->v1].asQWords[0]); i++) {
        memWriteQWord(ctx, &addr[i], ctx->v[a->v1].asQWords[i]);
    }
    return true;
}
bool hive64_vand(DisasContext *ctx, arg_vand *a) {
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
bool hive64_vor(DisasContext *ctx, arg_vor *a) {
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
bool hive64_vxor(DisasContext *ctx, arg_vxor *a) {
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
bool hive64_vcmp(DisasContext *ctx, arg_vcmp *a) {
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
bool hive64_vtst(DisasContext *ctx, arg_vtst *a) {
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
bool hive64_vminmax(DisasContext *ctx, arg_vminmax *a) {
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
bool hive64_vabs(DisasContext *ctx, arg_vabs *a) {
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
bool hive64_vshl(DisasContext *ctx, arg_vshl *a) {
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
bool hive64_vshr(DisasContext *ctx, arg_vshr *a) {
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
bool hive64_vsqrt(DisasContext *ctx, arg_vsqrt *a) {
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
bool hive64_vmod(DisasContext *ctx, arg_vmod *a) {
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
bool hive64_vmovall(DisasContext *ctx, arg_vmovall *a) {
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
    if (!check_condition(*(hive_instruction_t*) &ins, ctx->cr[CR_FLAGS].asFlags)) return;
    hive_instruction_t* old_x = ctx->r[REG_PC].asInstrPtr;
    hive_instruction_t* x = old_x;
    // char* s = dis(&x, (uint64_t) x);
    // if (s) {
    //     printf("%016llx: %s\n", (uint64_t) old_x, s);
    // } else {
    //     printf("%016llx: .dword 0x%08x\n", (uint64_t) old_x, *(uint32_t*) old_x);
    // }
    // free(s);
    if (!decode(ctx, ins)) {
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
            [SIGABRT] = INT_BRK,
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
