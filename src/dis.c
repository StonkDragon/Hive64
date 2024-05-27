#include "new_ops.h"
#include "opcode.h"

#ifdef __printflike
__printflike(1, 2)
#endif
char* strformat(const char*, ...);

char* condition_to_string0(uint8_t cond) {
    switch (cond) {
        case COND_EQ: return strformat(".eq");
        case COND_NE: return strformat(".ne");
        case COND_LE: return strformat(".le");
        case COND_GT: return strformat(".gt");
        case COND_LT: return strformat(".lt");
        case COND_GE: return strformat(".ge");
        default:      return strformat("");
    }
}
char* condition_to_string(hive_instruction_t ins) {
    return condition_to_string0(ins.generic.condition);
}

char* register_to_string_ptr(uint8_t reg, uint8_t size) {
    uint8_t high = size != SIZE_64BIT && (reg & 0x10);
    if (reg == REG_LR) return "lr";
    if (reg == REG_SP) return "sp";
    if (reg == REG_PC) return "pc";
    char* s = strformat("r%d" , reg);
    if (high) {
        s = strformat("%sh", s);
    }
    return s;
}

char* register_to_string(uint8_t reg, uint8_t size) {
    uint8_t high = size != SIZE_64BIT && (reg & 0x10);
    if (size != SIZE_64BIT) {
        reg &= 0xF;
    }
    if (reg == REG_LR) return "lr";
    if (reg == REG_SP) return "sp";
    if (reg == REG_PC) return "pc";
    char r_pref[] = {
        [SIZE_8BIT] = 'b',
        [SIZE_16BIT] = 'w',
        [SIZE_32BIT] = 'd',
        [SIZE_64BIT] = 'r',
    };
    char* s = strformat("%c%d", r_pref[size], reg);
    if (high) {
        s = strformat("%sh", s);
    }
    return s;
}

typedef struct {
    uint64_t addr;
    char* instr;
} DisasContext;

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

#include "dis.h"

bool dis_branch(DisasContext *ctx, arg_branch *a) {
    ctx->instr = strformat("b 0x%016llx", ctx->addr + a->rel);
    return true;
}
bool dis_branch_link(DisasContext *ctx, arg_branch_link *a) {
    ctx->instr = strformat("bl 0x%016llx", ctx->addr + a->rel);
    return true;
}
bool dis_branch_reg(DisasContext *ctx, arg_branch_reg *a) {
    ctx->instr = strformat("br %s", register_to_string(a->r1, SIZE_64BIT));
    return true;
}
bool dis_branch_reg_link(DisasContext *ctx, arg_branch_reg_link *a) {
    ctx->instr = strformat("blr %s", register_to_string(a->r1, SIZE_64BIT));
    return true;
}
bool dis_add_reg(DisasContext *ctx, arg_add_reg *a) {
    ctx->instr = strformat(
        "add %s, %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        register_to_string(a->r3, a->size)
    );
    return true;
}
bool dis_sub_reg(DisasContext *ctx, arg_sub_reg *a) {
    ctx->instr = strformat(
        "sub %s, %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        register_to_string(a->r3, a->size)
    );
    return true;
}
bool dis_cmp_reg(DisasContext *ctx, arg_cmp_reg *a) {
    ctx->instr = strformat(
        "cmp %s, %s",
        register_to_string(a->r2, a->size),
        register_to_string(a->r3, a->size)
    );
    return true;
}
bool dis_mul_reg(DisasContext *ctx, arg_mul_reg *a) {
    ctx->instr = strformat(
        "mul %s, %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        register_to_string(a->r3, a->size)
    );
    return true;
}
bool dis_div_reg(DisasContext *ctx, arg_div_reg *a) {
    ctx->instr = strformat(
        "div %s, %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        register_to_string(a->r3, a->size)
    );
    return true;
}
bool dis_mod_reg(DisasContext *ctx, arg_mod_reg *a) {
    ctx->instr = strformat(
        "mod %s, %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        register_to_string(a->r3, a->size)
    );
    return true;
}
bool dis_divs_reg(DisasContext *ctx, arg_divs_reg *a) {
    ctx->instr = strformat(
        "divs %s, %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        register_to_string(a->r3, a->size)
    );
    return true;
}
bool dis_mods_reg(DisasContext *ctx, arg_mods_reg *a) {
    ctx->instr = strformat(
        "mods %s, %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        register_to_string(a->r3, a->size)
    );
    return true;
}
bool dis_and_reg(DisasContext *ctx, arg_and_reg *a) {
    ctx->instr = strformat(
        "and %s, %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        register_to_string(a->r3, a->size)
    );
    return true;
}
bool dis_tst_reg(DisasContext *ctx, arg_tst_reg *a) {
    ctx->instr = strformat(
        "tst %s, %s",
        register_to_string(a->r2, a->size),
        register_to_string(a->r3, a->size)
    );
    return true;
}
bool dis_or_reg(DisasContext *ctx, arg_or_reg *a) {
    ctx->instr = strformat(
        "or %s, %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        register_to_string(a->r3, a->size)
    );
    return true;
}
bool dis_xor_reg(DisasContext *ctx, arg_xor_reg *a) {
    ctx->instr = strformat(
        "xor %s, %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        register_to_string(a->r3, a->size)
    );
    return true;
}
bool dis_shl_reg(DisasContext *ctx, arg_shl_reg *a) {
    ctx->instr = strformat(
        "shl %s, %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        register_to_string(a->r3, a->size)
    );
    return true;
}
bool dis_shr_reg(DisasContext *ctx, arg_shr_reg *a) {
    ctx->instr = strformat(
        "shr %s, %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        register_to_string(a->r3, a->size)
    );
    return true;
}
bool dis_sar_reg(DisasContext *ctx, arg_sar_reg *a) {
    ctx->instr = strformat(
        "sar %s, %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        register_to_string(a->r3, a->size)
    );
    return true;
}
bool dis_rol_reg(DisasContext *ctx, arg_rol_reg *a) {
    ctx->instr = strformat(
        "rol %s, %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        register_to_string(a->r3, a->size)
    );
    return true;
}
bool dis_ror_reg(DisasContext *ctx, arg_ror_reg *a) {
    ctx->instr = strformat(
        "ror %s, %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        register_to_string(a->r3, a->size)
    );
    return true;
}
bool dis_add_imm(DisasContext *ctx, arg_add_imm *a) {
    ctx->instr = strformat(
        "add %s, %s, %d",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        a->imm8
    );
    return true;
}
bool dis_sub_imm(DisasContext *ctx, arg_sub_imm *a) {
    ctx->instr = strformat(
        "sub %s, %s, %d",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        a->imm8
    );
    return true;
}
bool dis_cmp_imm(DisasContext *ctx, arg_cmp_imm *a) {
    ctx->instr = strformat(
        "cmp %s, %d",
        register_to_string(a->r2, a->size),
        a->imm8
    );
    return true;
}
bool dis_mul_imm(DisasContext *ctx, arg_mul_imm *a) {
    ctx->instr = strformat(
        "mul %s, %s, %d",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        a->imm8
    );
    return true;
}
bool dis_div_imm(DisasContext *ctx, arg_div_imm *a) {
    ctx->instr = strformat(
        "div %s, %s, %d",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        a->imm8
    );
    return true;
}
bool dis_mod_imm(DisasContext *ctx, arg_mod_imm *a) {
    ctx->instr = strformat(
        "mod %s, %s, %d",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        a->imm8
    );
    return true;
}
bool dis_divs_imm(DisasContext *ctx, arg_divs_imm *a) {
    ctx->instr = strformat(
        "divs %s, %s, %d",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        a->imm8
    );
    return true;
}
bool dis_mods_imm(DisasContext *ctx, arg_mods_imm *a) {
    ctx->instr = strformat(
        "mods %s, %s, %d",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        a->imm8
    );
    return true;
}
bool dis_and_imm(DisasContext *ctx, arg_and_imm *a) {
    ctx->instr = strformat(
        "and %s, %s, %d",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        a->imm8
    );
    return true;
}
bool dis_tst_imm(DisasContext *ctx, arg_tst_imm *a) {
    ctx->instr = strformat(
        "tst %s, %d",
        register_to_string(a->r2, a->size),
        a->imm8
    );
    return true;
}
bool dis_or_imm(DisasContext *ctx, arg_or_imm *a) {
    ctx->instr = strformat(
        "or %s, %s, %d",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        a->imm8
    );
    return true;
}
bool dis_xor_imm(DisasContext *ctx, arg_xor_imm *a) {
    ctx->instr = strformat(
        "xor %s, %s, %d",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        a->imm8
    );
    return true;
}
bool dis_ret(DisasContext *ctx, arg_ret *a) {
    ctx->instr = strformat("ret");
    return true;
}
bool dis_mov(DisasContext *ctx, arg_mov *a) {
    ctx->instr = strformat(
        "mov %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size)
    );
    return true;
}
bool dis_shl_imm(DisasContext *ctx, arg_shl_imm *a) {
    ctx->instr = strformat(
        "shl %s, %s, %d",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        a->imm8
    );
    return true;
}
bool dis_shr_imm(DisasContext *ctx, arg_shr_imm *a) {
    ctx->instr = strformat(
        "shr %s, %s, %d",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        a->imm8
    );
    return true;
}
bool dis_sar_imm(DisasContext *ctx, arg_sar_imm *a) {
    ctx->instr = strformat(
        "sar %s, %s, %d",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        a->imm8
    );
    return true;
}
bool dis_rol_imm(DisasContext *ctx, arg_rol_imm *a) {
    ctx->instr = strformat(
        "rol %s, %s, %d",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        a->imm8
    );
    return true;
}
bool dis_ror_imm(DisasContext *ctx, arg_ror_imm *a) {
    ctx->instr = strformat(
        "ror %s, %s, %d",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        a->imm8
    );
    return true;
}
bool dis_neg(DisasContext *ctx, arg_neg *a) {
    ctx->instr = strformat(
        "neg %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size)
    );
    return true;
}
bool dis_not(DisasContext *ctx, arg_not *a) {
    ctx->instr = strformat(
        "not %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size)
    );
    return true;
}
bool dis_extend(DisasContext *ctx, arg_extend *a) {
    char sz[] = {
        [SIZE_8BIT] = 'b',
        [SIZE_16BIT] = 'w',
        [SIZE_32BIT] = 'd',
        [SIZE_64BIT] = 'q',
    };
    ctx->instr = strformat(
        "ext%c%c %s, %s",
        sz[a->size],
        sz[a->to],
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->to)
    );
    return true;
}
bool dis_swe(DisasContext *ctx, arg_swe *a) {
    ctx->instr = strformat(
        "swe %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size)
    );
    return true;
}
bool dis_cswap(DisasContext *ctx, arg_cswap *a) {
    ctx->instr = strformat(
        "cswap %s, %s, %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size),
        register_to_string(a->r3, a->size),
        condition_to_string0(a->cond)
    );
    return true;
}
bool dis_xchg(DisasContext *ctx, arg_xchg *a) {
    ctx->instr = strformat(
        "xchg %s, %s",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, a->size)
    );
    return true;
}
bool dis_fadd(DisasContext *ctx, arg_fadd *a) {
    ctx->instr = strformat(
        "fadd %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_faddi(DisasContext *ctx, arg_faddi *a) {
    ctx->instr = strformat(
        "faddi %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_fsub(DisasContext *ctx, arg_fsub *a) {
    ctx->instr = strformat(
        "fsub %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_fsubi(DisasContext *ctx, arg_fsubi *a) {
    ctx->instr = strformat(
        "fsubi %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_fcmp(DisasContext *ctx, arg_fcmp *a) {
    ctx->instr = strformat(
        "fcmp %s, %s",
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_fcmpi(DisasContext *ctx, arg_fcmpi *a) {
    ctx->instr = strformat(
        "fcmpi %s, %s",
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_fmul(DisasContext *ctx, arg_fmul *a) {
    ctx->instr = strformat(
        "fmul %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_fmuli(DisasContext *ctx, arg_fmuli *a) {
    ctx->instr = strformat(
        "fmuli %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_fdiv(DisasContext *ctx, arg_fdiv *a) {
    ctx->instr = strformat(
        "fdiv %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_fdivi(DisasContext *ctx, arg_fdivi *a) {
    ctx->instr = strformat(
        "fdivi %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_fmod(DisasContext *ctx, arg_fmod *a) {
    ctx->instr = strformat(
        "fmod %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_fmodi(DisasContext *ctx, arg_fmodi *a) {
    ctx->instr = strformat(
        "fmodi %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_f2i(DisasContext *ctx, arg_f2i *a) {
    ctx->instr = strformat(
        "f2i %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT)
    );
    return true;
}
bool dis_i2f(DisasContext *ctx, arg_i2f *a) {
    ctx->instr = strformat(
        "i2f %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT)
    );
    return true;
}
bool dis_fsin(DisasContext *ctx, arg_fsin *a) {
    ctx->instr = strformat(
        "fsin %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT)
    );
    return true;
}
bool dis_fsini(DisasContext *ctx, arg_fsini *a) {
    ctx->instr = strformat(
        "fsini %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT)
    );
    return true;
}
bool dis_fsqrt(DisasContext *ctx, arg_fsqrt *a) {
    ctx->instr = strformat(
        "fsqrt %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT)
    );
    return true;
}
bool dis_fsqrti(DisasContext *ctx, arg_fsqrti *a) {
    ctx->instr = strformat(
        "fsqrti %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT)
    );
    return true;
}
bool dis_sadd(DisasContext *ctx, arg_sadd *a) {
    ctx->instr = strformat(
        "fadd %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_saddi(DisasContext *ctx, arg_saddi *a) {
    ctx->instr = strformat(
        "saddi %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_ssub(DisasContext *ctx, arg_ssub *a) {
    ctx->instr = strformat(
        "ssub %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_ssubi(DisasContext *ctx, arg_ssubi *a) {
    ctx->instr = strformat(
        "ssubi %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_scmp(DisasContext *ctx, arg_scmp *a) {
    ctx->instr = strformat(
        "scmp %s, %s",
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_scmpi(DisasContext *ctx, arg_scmpi *a) {
    ctx->instr = strformat(
        "scmpi %s, %s",
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_smul(DisasContext *ctx, arg_smul *a) {
    ctx->instr = strformat(
        "smul %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_smuli(DisasContext *ctx, arg_smuli *a) {
    ctx->instr = strformat(
        "smuli %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_sdiv(DisasContext *ctx, arg_sdiv *a) {
    ctx->instr = strformat(
        "sdiv %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_sdivi(DisasContext *ctx, arg_sdivi *a) {
    ctx->instr = strformat(
        "sdivi %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_smod(DisasContext *ctx, arg_smod *a) {
    ctx->instr = strformat(
        "smod %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_smodi(DisasContext *ctx, arg_smodi *a) {
    ctx->instr = strformat(
        "smodi %s, %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT)
    );
    return true;
}
bool dis_s2i(DisasContext *ctx, arg_s2i *a) {
    ctx->instr = strformat(
        "s2i %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT)
    );
    return true;
}
bool dis_i2s(DisasContext *ctx, arg_i2s *a) {
    ctx->instr = strformat(
        "i2s %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT)
    );
    return true;
}
bool dis_ssin(DisasContext *ctx, arg_ssin *a) {
    ctx->instr = strformat(
        "ssin %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT)
    );
    return true;
}
bool dis_ssini(DisasContext *ctx, arg_ssini *a) {
    ctx->instr = strformat(
        "ssini %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT)
    );
    return true;
}
bool dis_ssqrt(DisasContext *ctx, arg_ssqrt *a) {
    ctx->instr = strformat(
        "ssqrt %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT)
    );
    return true;
}
bool dis_ssqrti(DisasContext *ctx, arg_ssqrti *a) {
    ctx->instr = strformat(
        "ssqrti %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT)
    );
    return true;
}
bool dis_s2f(DisasContext *ctx, arg_s2f *a) {
    ctx->instr = strformat(
        "s2f %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT)
    );
    return true;
}
bool dis_f2s(DisasContext *ctx, arg_f2s *a) {
    ctx->instr = strformat(
        "f2s %s, %s",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT)
    );
    return true;
}
bool dis_cpuid(DisasContext *ctx, arg_cpuid *a) {
    ctx->instr = strformat("cpuid");
    return true;
}
bool dis_zeroupper(DisasContext *ctx, arg_zeroupper *a) {
    ctx->instr = strformat("zeroupper %s", register_to_string(a->r1, a->size));
    return true;
}
bool dis_sret(DisasContext *ctx, arg_sret *a) {
    ctx->instr = strformat("sret");
    return true;
}
bool dis_hret(DisasContext *ctx, arg_hret *a) {
    ctx->instr = strformat("hret");
    return true;
}
bool dis_iret(DisasContext *ctx, arg_iret *a) {
    ctx->instr = strformat("iret");
    return true;
}
bool dis_svc(DisasContext *ctx, arg_svc *a) {
    ctx->instr = strformat("svc");
    return true;
}
bool dis_mov_cr_r(DisasContext *ctx, arg_mov_cr_r *a) {
    ctx->instr = strformat("mov cr%d, %s", a->cr1, register_to_string(a->r1, SIZE_64BIT));
    return true;
}
bool dis_mov_r_cr(DisasContext *ctx, arg_mov_r_cr *a) {
    ctx->instr = strformat("mov %s, cr%d", register_to_string(a->r1, SIZE_64BIT), a->cr1);
    return true;
}
bool dis_hexit(DisasContext *ctx, arg_hexit *a) {
    ctx->instr = strformat("hexit");
    return true;
}
bool dis_sexit(DisasContext *ctx, arg_sexit *a) {
    ctx->instr = strformat("sexit");
    return true;
}
bool dis_lea(DisasContext *ctx, arg_lea *a) {
    ctx->instr = strformat(
        "lea %s, 0x%016llx",
        register_to_string(a->r1, SIZE_64BIT),
        ctx->addr + a->rel
    );
    return true;
}
bool dis_movz_0(DisasContext *ctx, arg_movz_0 *a) {
    ctx->instr = strformat(
        "movz %s, 0x%04x",
        register_to_string(a->r1, SIZE_64BIT),
        a->imm
    );
    return true;
}
bool dis_movz_16(DisasContext *ctx, arg_movz_16 *a) {
    ctx->instr = strformat(
        "movz %s, 0x%04x, 16",
        register_to_string(a->r1, SIZE_64BIT),
        a->imm
    );
    return true;
}
bool dis_movz_32(DisasContext *ctx, arg_movz_32 *a) {
    ctx->instr = strformat(
        "movz %s, 0x%04x, 32",
        register_to_string(a->r1, SIZE_64BIT),
        a->imm
    );
    return true;
}
bool dis_movz_48(DisasContext *ctx, arg_movz_48 *a) {
    ctx->instr = strformat(
        "movz %s, 0x%04x, 48",
        register_to_string(a->r1, SIZE_64BIT),
        a->imm
    );
    return true;
}
bool dis_movk_0(DisasContext *ctx, arg_movk_0 *a) {
    ctx->instr = strformat(
        "movk %s, 0x%04x",
        register_to_string(a->r1, SIZE_64BIT),
        a->imm
    );
    return true;
}
bool dis_movk_16(DisasContext *ctx, arg_movk_16 *a) {
    ctx->instr = strformat(
        "movk %s, 0x%04x, 16",
        register_to_string(a->r1, SIZE_64BIT),
        a->imm
    );
    return true;
}
bool dis_movk_32(DisasContext *ctx, arg_movk_32 *a) {
    ctx->instr = strformat(
        "movk %s, 0x%04x, 32",
        register_to_string(a->r1, SIZE_64BIT),
        a->imm
    );
    return true;
}
bool dis_movk_48(DisasContext *ctx, arg_movk_48 *a) {
    ctx->instr = strformat(
        "movk %s, 0x%04x, 48",
        register_to_string(a->r1, SIZE_64BIT),
        a->imm
    );
    return true;
}
bool dis_ldr_reg(DisasContext *ctx, arg_ldr_reg *a) {
    ctx->instr = strformat(
        "ldr %s, [%s, %s shl %d]",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT),
        a->shift
    );
    return true;
}
bool dis_ldr_reg_update(DisasContext *ctx, arg_ldr_reg_update *a) {
    ctx->instr = strformat(
        "ldr %s, [%s, %s shl %d]!",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT),
        a->shift
    );
    return true;
}
bool dis_ldr_imm(DisasContext *ctx, arg_ldr_imm *a) {
    ctx->instr = strformat(
        "ldr %s, [%s, %d]",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, SIZE_64BIT),
        a->imm
    );
    return true;
}
bool dis_ldr_imm_update(DisasContext *ctx, arg_ldr_imm_update *a) {
    ctx->instr = strformat(
        "ldr %s, [%s, %d]!",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, SIZE_64BIT),
        a->imm
    );
    return true;
}
bool dis_str_reg(DisasContext *ctx, arg_str_reg *a) {
    ctx->instr = strformat(
        "str %s, [%s, %s shl %d]",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT),
        a->shift
    );
    return true;
}
bool dis_str_reg_update(DisasContext *ctx, arg_str_reg_update *a) {
    ctx->instr = strformat(
        "str %s, [%s, %s shl %d]!",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, SIZE_64BIT),
        register_to_string(a->r3, SIZE_64BIT),
        a->shift
    );
    return true;
}
bool dis_str_imm(DisasContext *ctx, arg_str_imm *a) {
    ctx->instr = strformat(
        "str %s, [%s, %d]",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, SIZE_64BIT),
        a->imm
    );
    return true;
}
bool dis_str_imm_update(DisasContext *ctx, arg_str_imm_update *a) {
    ctx->instr = strformat(
        "str %s, [%s, %d]!",
        register_to_string(a->r1, a->size),
        register_to_string(a->r2, SIZE_64BIT),
        a->imm
    );
    return true;
}
bool dis_ldr_pc_rel(DisasContext *ctx, arg_ldr_pc_rel *a) {
    ctx->instr = strformat(
        "ldr %s, [0x%016llx]",
        register_to_string(a->r1, a->size),
        ctx->addr + a->rel
    );
    return true;
}
bool dis_str_pc_rel(DisasContext *ctx, arg_str_pc_rel *a) {
    ctx->instr = strformat(
        "str %s, [0x%016llx]",
        register_to_string(a->r1, a->size),
        ctx->addr + a->rel
    );
    return true;
}
bool dis_ubxt(DisasContext *ctx, arg_ubxt *a) {
    ctx->instr = strformat(
        "ubxt %s, %s, %d, %d",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        a->start,
        a->count + 1
    );
    return true;
}
bool dis_sbxt(DisasContext *ctx, arg_sbxt *a) {
    ctx->instr = strformat(
        "sbxt %s, %s, %d, %d",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        a->start,
        a->count + 1
    );
    return true;
}
bool dis_ubdp(DisasContext *ctx, arg_ubdp *a) {
    ctx->instr = strformat(
        "ubdp %s, %s, %d, %d",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        a->start,
        a->count + 1
    );
    return true;
}
bool dis_sbdp(DisasContext *ctx, arg_sbdp *a) {
    ctx->instr = strformat(
        "sbdp %s, %s, %d, %d",
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT),
        a->start,
        a->count + 1
    );
    return true;
}
char vector_modes[] = {
    [0] = 'o',
    [1] = 'b',
    [2] = 'w',
    [3] = 'd',
    [4] = 'q',
    [5] = 'l',
    [6] = 's',
    [7] = 'f',
};
bool dis_vadd(DisasContext *ctx, arg_vadd *a) {
    ctx->instr = strformat(
        "vadd%c v%d, v%d, v%d",
        vector_modes[a->type],
        a->v1,
        a->v2,
        a->v3
    );
    return true;
}
bool dis_vsub(DisasContext *ctx, arg_vsub *a) {
    ctx->instr = strformat(
        "vsub%c v%d, v%d, v%d",
        vector_modes[a->type],
        a->v1,
        a->v2,
        a->v3
    );
    return true;
}
bool dis_vmul(DisasContext *ctx, arg_vmul *a) {
    ctx->instr = strformat(
        "vmul%c v%d, v%d, v%d",
        vector_modes[a->type],
        a->v1,
        a->v2,
        a->v3
    );
    return true;
}
bool dis_vdiv(DisasContext *ctx, arg_vdiv *a) {
    ctx->instr = strformat(
        "vdiv%c v%d, v%d, v%d",
        vector_modes[a->type],
        a->v1,
        a->v2,
        a->v3
    );
    return true;
}
bool dis_vaddsub(DisasContext *ctx, arg_vaddsub *a) {
    ctx->instr = strformat(
        "vaddsub%c v%d, v%d, v%d",
        vector_modes[a->type],
        a->v1,
        a->v2,
        a->v3
    );
    return true;
}
bool dis_vmadd(DisasContext *ctx, arg_vmadd *a) {
    ctx->instr = strformat(
        "vmadd%c v%d, v%d, v%d",
        vector_modes[a->type],
        a->v1,
        a->v2,
        a->v3
    );
    return true;
}
bool dis_vmov_reg(DisasContext *ctx, arg_vmov_reg *a) {
    ctx->instr = strformat(
        "vmov%c v%d, %s, %d",
        vector_modes[a->type],
        a->v1,
        register_to_string(a->r2, SIZE_64BIT),
        a->slot
    );
    return true;
}
bool dis_vmov_reg2(DisasContext *ctx, arg_vmov_reg2 *a) {
    ctx->instr = strformat(
        "vmov%c %s, v%d, %d",
        vector_modes[a->type],
        register_to_string(a->r2, SIZE_64BIT),
        a->v1,
        a->slot
    );
    return true;
}
bool dis_vmov(DisasContext *ctx, arg_vmov *a) {
    ctx->instr = strformat(
        "vmov v%d, v%d",
        a->v1,
        a->v2
    );
    return true;
}
bool dis_vconv(DisasContext *ctx, arg_vconv *a) {
    ctx->instr = strformat(
        "vconv%c%c v%d, v%d",
        vector_modes[a->type],
        vector_modes[a->target],
        a->v1,
        a->v2
    );
    return true;
}
bool dis_vlen(DisasContext *ctx, arg_vlen *a) {
    ctx->instr = strformat(
        "vlen%c v%d, %s",
        vector_modes[a->type],
        a->v1,
        register_to_string(a->r1, SIZE_64BIT)
    );
    return true;
}
bool dis_vldr_imm(DisasContext *ctx, arg_vldr_imm *a) {
    ctx->instr = strformat(
        "vldr v%d, [%s, %d]",
        a->v1,
        register_to_string(a->r1, SIZE_64BIT),
        a->imm
    );
    return true;
}
bool dis_vldr_imm_update(DisasContext *ctx, arg_vldr_imm_update *a) {
    ctx->instr = strformat(
        "vldr v%d, [%s, %d]!",
        a->v1,
        register_to_string(a->r1, SIZE_64BIT),
        a->imm
    );
    return true;
}
bool dis_vstr_imm(DisasContext *ctx, arg_vstr_imm *a) {
    ctx->instr = strformat(
        "vstr v%d, [%s, %d]",
        a->v1,
        register_to_string(a->r1, SIZE_64BIT),
        a->imm
    );
    return true;
}
bool dis_vstr_imm_update(DisasContext *ctx, arg_vstr_imm_update *a) {
    ctx->instr = strformat(
        "vstr v%d, [%s, %d]!",
        a->v1,
        register_to_string(a->r1, SIZE_64BIT),
        a->imm
    );
    return true;
}
bool dis_vldr_reg(DisasContext *ctx, arg_vldr_reg *a) {
    ctx->instr = strformat(
        "vldr v%d, [%s, %s]",
        a->v1,
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT)
    );
    return true;
}
bool dis_vldr_reg_update(DisasContext *ctx, arg_vldr_reg_update *a) {
    ctx->instr = strformat(
        "vldr v%d, [%s, %s]!",
        a->v1,
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT)
    );
    return true;
}
bool dis_vstr_reg(DisasContext *ctx, arg_vstr_reg *a) {
    ctx->instr = strformat(
        "vstr v%d, [%s, %s]",
        a->v1,
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT)
    );
    return true;
}
bool dis_vstr_reg_update(DisasContext *ctx, arg_vstr_reg_update *a) {
    ctx->instr = strformat(
        "vstr v%d, [%s, %s]!",
        a->v1,
        register_to_string(a->r1, SIZE_64BIT),
        register_to_string(a->r2, SIZE_64BIT)
    );
    return true;
}
bool dis_vand(DisasContext *ctx, arg_vand *a) {
    ctx->instr = strformat(
        "vand%c v%d, v%d, v%d",
        vector_modes[a->type],
        a->v1,
        a->v2,
        a->v3
    );
    return true;
}
bool dis_vor(DisasContext *ctx, arg_vor *a) {
    ctx->instr = strformat(
        "vor%c v%d, v%d, v%d",
        vector_modes[a->type],
        a->v1,
        a->v2,
        a->v3
    );
    return true;
}
bool dis_vxor(DisasContext *ctx, arg_vxor *a) {
    ctx->instr = strformat(
        "vxor%c v%d, v%d, v%d",
        vector_modes[a->type],
        a->v1,
        a->v2,
        a->v3
    );
    return true;
}
bool dis_vcmp(DisasContext *ctx, arg_vcmp *a) {
    ctx->instr = strformat(
        "vcmp%c v%d, v%d, v%d, %s",
        vector_modes[a->type],
        a->v1,
        a->v2,
        a->v3,
        condition_to_string0(a->cond)
    );
    return true;
}
bool dis_vminmax(DisasContext *ctx, arg_vminmax *a) {
    ctx->instr = strformat(
        "vminmax%c%c v%d, v%d",
        a->check_sign ? 's' : 'u',
        vector_modes[a->type],
        a->v1,
        a->v2
    );
    return true;
}
bool dis_vabs(DisasContext *ctx, arg_vabs *a) {
    ctx->instr = strformat(
        "vabs%c v%d, v%d",
        vector_modes[a->type],
        a->v1,
        a->v2
    );
    return true;
}
bool dis_vshl(DisasContext *ctx, arg_vshl *a) {
    ctx->instr = strformat(
        "vshl%c v%d, v%d, v%d",
        vector_modes[a->type],
        a->v1,
        a->v2,
        a->v3
    );
    return true;
}
bool dis_vshr(DisasContext *ctx, arg_vshr *a) {
    ctx->instr = strformat(
        "vshr%c v%d, v%d, v%d",
        vector_modes[a->type],
        a->v1,
        a->v2,
        a->v3
    );
    return true;
}
bool dis_vsqrt(DisasContext *ctx, arg_vsqrt *a) {
    ctx->instr = strformat(
        "vsqrt%c v%d, v%d",
        vector_modes[a->type],
        a->v1,
        a->v2
    );
    return true;
}
bool dis_vmod(DisasContext *ctx, arg_vmod *a) {
    ctx->instr = strformat(
        "vmod%c v%d, v%d, v%d",
        vector_modes[a->type],
        a->v1,
        a->v2,
        a->v3
    );
    return true;
}
bool dis_vmovall(DisasContext *ctx, arg_vmovall *a) {
    ctx->instr = strformat(
        "vmovall%c v%d, %s",
        vector_modes[a->type],
        a->v1,
        register_to_string(a->r2, SIZE_64BIT)
    );
    return true;
}
bool dis_vtst(DisasContext *ctx, arg_vtst *a) {
    ctx->instr = strformat(
        "vtst%c v%d, v%d, v%d, %s",
        vector_modes[a->type],
        a->v1,
        a->v2,
        a->v3,
        condition_to_string0(a->cond)
    );
    return true;
}

char* dis(hive_instruction_t ins, uint64_t addr) {
    DisasContext x = {
        .addr = addr,
        .instr = NULL,
    };
    if (ins.generic.condition == COND_NEVER) {
        x.instr = strformat("nop");
    } else {
        if (!decode(&x, ins.word)) {
            return NULL;
        }
    }
    if (ins.generic.condition != COND_ALWAYS) {
        char* old = x.instr;
        x.instr = strformat("if%s %s", condition_to_string(ins), old);
        free(old);
    }
    return x.instr;
}

char* get_symbol_at(Symbol_Array syms, uint64_t addr) {
    for (size_t i = 0; i < syms.count; i++) {
        if (syms.items[i].offset == addr) {
            return syms.items[i].name;
        }
    }
    return NULL;
}

char* get_relocation_at(Relocation_Array relocations, uint64_t addr) {
    for (size_t i = 0; i < relocations.count; i++) {
        if (relocations.items[i].source_offset == addr && !relocations.items[i].is_local) {
            return strformat("stub for %s", relocations.items[i].data.name);
        }
    }
    return NULL;
}

void disassemble(Section code_sect, Symbol_Array syms, Relocation_Array relocations) {
    for (hive_instruction_t* ins = (hive_instruction_t*) code_sect.data; ins < (hive_instruction_t*) (code_sect.data + code_sect.len);) {
        char* s = dis(*ins, (uint64_t) ins);
        char* symbol_here = get_symbol_at(syms, (uint64_t) ins);
        if (symbol_here) {
            printf("%s:\n", symbol_here);
        }
        if (s == NULL) {
            printf("    .dword 0x%08x\n", ins->word);
        } else {
            printf("    %s", s);
            uint64_t address = (uint64_t) ins;
            char* sym = NULL;
            if (ins->generic.type == MODE_BRANCH && ins->type_branch.is_reg == 0) {
                address += (ins->type_branch.offset << 2);
                if (address == (uint64_t) ins) {
                    sym = get_relocation_at(relocations, (uint64_t) ins - (uint64_t) code_sect.data);
                }
                if (sym == NULL) {
                    sym = get_symbol_at(syms, address);
                }
            } else if (ins->generic.type == MODE_LOAD) {
                if (ins->type_load_signed.op == OP_LOAD_lea) {
                    address += (ins->type_load_signed.imm << 2);
                    if (address == (uint64_t) ins) {
                        sym = get_relocation_at(relocations, (uint64_t) ins - (uint64_t) code_sect.data);
                    }
                    if (sym == NULL) {
                        sym = get_symbol_at(syms, address);
                    }
                }
            }
            if (sym) {
                printf("\t; %s", sym);
            }
            printf("\n");
            free(s);
        }
        ins++;
    }
}
