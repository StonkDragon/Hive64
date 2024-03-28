#include <math.h>
#include <signal.h>
#include <pthread.h>
#include <setjmp.h>
#include <stdatomic.h>
#include <sys/mman.h>

#include "new_ops.h"

extern svc_call svcs[];

struct cpu_state state[CORE_COUNT * THREAD_COUNT] = {0};
struct cpu_transfer transfers[CORE_COUNT * THREAD_COUNT];

int check_condition(hive_instruction_t ins, hive_flag_register_t fr);

    // lt, mi   -> negative
    // gt       -> !zero && !negative
    // ge, pl   -> !negative
    // le       -> negative || zero
    // eq, z    -> zero
    // ne, nz   -> !zero
    // always   -> 1
    // never    -> 0
static inline SQWord_t set_flags64(struct cpu_state* state, SQWord_t res) {
    state->fr.flags.negative = (res < 0);
    state->fr.flags.zero = (res == 0);
    return res;
}
static inline SDWord_t set_flags32(struct cpu_state* state, SDWord_t res) {
    state->fr.flags.zero = (res == 0);
    state->fr.flags.negative = (res < 0);
    return res;
}
static inline SWord_t set_flags16(struct cpu_state* state, SWord_t res) {
    state->fr.flags.zero = (res == 0);
    state->fr.flags.negative = (res < 0);
    return res;
}
static inline SByte_t set_flags8(struct cpu_state* state, SByte_t res) {
    state->fr.flags.zero = (res == 0);
    state->fr.flags.negative = (res < 0);
    return res;
}
static inline Float64_t set_flagsf64(struct cpu_state* state, Float64_t res) {
    state->fr.flags.zero = (res == 0.0);
    state->fr.flags.negative = (res < 0.0);
    return res;
}
static inline Float32_t set_flagsf32(struct cpu_state* state, Float32_t res) {
    state->fr.flags.zero = (res == 0.0);
    state->fr.flags.negative = (res < 0.0);
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
uint64_t swap_bytes_64(uint64_t x) { return htonll(x); }
uint32_t swap_bytes_32(uint32_t x) { return htonl(x); }
uint16_t swap_bytes_16(uint16_t x) { return htons(x); }
uint8_t swap_bytes_8(uint8_t x) { return x; }
#define swap_bytes(x) _Generic((x), int64_t: swap_bytes_64, uint64_t: swap_bytes_64, int32_t: swap_bytes_32, uint32_t: swap_bytes_32, int16_t: swap_bytes_16, uint16_t: swap_bytes_16, int8_t: swap_bytes_8, uint8_t: swap_bytes_8)((x))

#define ALU(nbits) \
uint ## nbits ## _t alu ## nbits(uint8_t op, uint ## nbits ## _t a, uint ## nbits ## _t b, struct cpu_state* state) { \
    hive_register_t target; \
    switch (op) { \
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
        case OP_DATA_ALU_asr: target.asI ## nbits = ((int ## nbits ## _t) a) >> b; break; \
        case OP_DATA_ALU_swe: target.asU ## nbits = swap_bytes(a); break; \
    } \
    set_flags ## nbits(state, target.asI ## nbits); \
    return target.asU ## nbits; \
} \
uint ## nbits ## _t salu ## nbits(uint8_t op, uint ## nbits ## _t _a, uint ## nbits ## _t _b, struct cpu_state* state) { \
    int ## nbits ## _t a = *(int ## nbits ## _t*) &_a; \
    int ## nbits ## _t b = *(int ## nbits ## _t*) &_b; \
    hive_register_t target; \
    switch (op) { \
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
        case OP_DATA_ALU_neg: target.asI ## nbits = -((int ## nbits ## _t) a); break; \
        case OP_DATA_ALU_not: target.asI ## nbits = ~a; break; \
        case OP_DATA_ALU_asr: target.asI ## nbits = ((int ## nbits ## _t) a) >> b; break; \
        case OP_DATA_ALU_swe: target.asI ## nbits = swap_bytes(a); break; \
    } \
    set_flags ## nbits(state, target.asI ## nbits); \
    return target.asU ## nbits; \
} \
uint ## nbits ## _t (*alu ## nbits ## _func[2])(uint8_t op, uint ## nbits ## _t a, uint ## nbits ## _t b, struct cpu_state *state) = { \
    alu ## nbits, \
    salu ## nbits, \
};

ALU(64)
ALU(32)
ALU(16)
ALU(8)

BEGIN_OP(data_alu)
    hive_register_t target;
    hive_register_t src1 = state->r[ins.type_data_alui.r2];
    uint64_t src2;
    if (ins.type_data_alui.use_imm) {
        src2 = ins.type_data_alui.imm;
    } else {
        src2 = state->r[ins.type_data_alur.r3].asQWord;
    }
    switch (state->fr.flags.size) {
        case SIZE_64BIT: target.asQWord = alu64_func[ins.type_data_alui.salu](ins.type_data_alui.op, src1.asSQWord, src2, state); break;
        case SIZE_32BIT: target.asDWord = alu32_func[ins.type_data_alui.salu](ins.type_data_alui.op, src1.asSQWord, src2, state); break;
        case SIZE_16BIT: target.asWord = alu16_func[ins.type_data_alui.salu](ins.type_data_alui.op, src1.asSQWord, src2, state); break;
        case SIZE_8BIT:  target.asByte = alu8_func[ins.type_data_alui.salu](ins.type_data_alui.op, src1.asSQWord, src2, state); break;
    }
    if (ins.type_data_alui.no_writeback == 0) {
        switch (state->fr.flags.size) {
            case SIZE_64BIT: state->r[ins.type_data_alui.r1].asQWord = target.asQWord; break;
            case SIZE_32BIT: state->r[ins.type_data_alui.r1].asDWord = target.asDWord; break;
            case SIZE_16BIT: state->r[ins.type_data_alui.r1].asWord = target.asWord; break;
            case SIZE_8BIT:  state->r[ins.type_data_alui.r1].asByte = target.asByte; break;
        }
    }
END_OP
BEGIN_OP(data_fpu)
    hive_register_t target;
    hive_register_t src1 = state->r[ins.type_data_fpu.r2];
    hive_register_t src2 = state->r[ins.type_data_fpu.r3];
    if (ins.type_data_fpu.is_single_op) {
        if (ins.type_data_fpu.use_int_arg2) {
            switch (ins.type_data_fpu.op) {
                case OP_DATA_FLOAT_add: target.asFloat32 = set_flagsf32(state, src1.asFloat32 + src2.asSDWord); break;
                case OP_DATA_FLOAT_sub: target.asFloat32 = set_flagsf32(state, src1.asFloat32 - src2.asSDWord); break;
                case OP_DATA_FLOAT_mul: target.asFloat32 = set_flagsf32(state, src1.asFloat32 * src2.asSDWord); break;
                case OP_DATA_FLOAT_div: target.asFloat32 = set_flagsf32(state, src1.asFloat32 / src2.asSDWord); break;
                case OP_DATA_FLOAT_mod: target.asFloat32 = set_flagsf32(state, fmod(src1.asFloat32, src2.asSDWord)); break;
                case OP_DATA_FLOAT_f2i: target.asFloat32 = set_flagsf32(state, (Float32_t) src1.asSDWord); break;
                case OP_DATA_FLOAT_sin: target.asFloat32 = set_flagsf32(state, sinf(src1.asSDWord)); break;
                case OP_DATA_FLOAT_sqrt: target.asFloat32 = set_flagsf32(state, sqrtf(src1.asSDWord)); break;
            }
        } else {
            switch (ins.type_data_fpu.op) {
                case OP_DATA_FLOAT_add: target.asFloat32 = set_flagsf32(state, src1.asFloat32 + src2.asFloat32); break;
                case OP_DATA_FLOAT_sub: target.asFloat32 = set_flagsf32(state, src1.asFloat32 - src2.asFloat32); break;
                case OP_DATA_FLOAT_mul: target.asFloat32 = set_flagsf32(state, src1.asFloat32 * src2.asFloat32); break;
                case OP_DATA_FLOAT_div: target.asFloat32 = set_flagsf32(state, src1.asFloat32 / src2.asFloat32); break;
                case OP_DATA_FLOAT_mod: target.asFloat32 = set_flagsf32(state, fmod(src1.asFloat32, src2.asFloat32)); break;
                case OP_DATA_FLOAT_f2i: target.asSDWord = set_flags32(state, (SDWord_t) src1.asFloat32); break;
                case OP_DATA_FLOAT_sin: target.asFloat32 = set_flagsf32(state, sinf(src1.asFloat32)); break;
                case OP_DATA_FLOAT_sqrt: target.asFloat32 = set_flagsf32(state, sqrtf(src1.asFloat32)); break;
                case OP_DATA_FLOAT_s2f: target.asFloat32 = set_flagsf32(state, (Float32_t) src1.asFloat64); break;
            }
        }
    } else {
        if (ins.type_data_fpu.use_int_arg2) {
            switch (ins.type_data_fpu.op) {
                case OP_DATA_FLOAT_add: target.asFloat64 = set_flagsf64(state, src1.asFloat64 + src2.asSQWord); break;
                case OP_DATA_FLOAT_sub: target.asFloat64 = set_flagsf64(state, src1.asFloat64 - src2.asSQWord); break;
                case OP_DATA_FLOAT_mul: target.asFloat64 = set_flagsf64(state, src1.asFloat64 * src2.asSQWord); break;
                case OP_DATA_FLOAT_div: target.asFloat64 = set_flagsf64(state, src1.asFloat64 / src2.asSQWord); break;
                case OP_DATA_FLOAT_mod: target.asFloat64 = set_flagsf64(state, fmod(src1.asFloat64, src2.asSQWord)); break;
                case OP_DATA_FLOAT_f2i: target.asFloat64 = set_flagsf64(state, (Float64_t) src1.asSQWord); break;
                case OP_DATA_FLOAT_sin: target.asFloat64 = set_flagsf64(state, sin(src1.asSQWord)); break;
                case OP_DATA_FLOAT_sqrt: target.asFloat64 = set_flagsf64(state, sqrt(src1.asSQWord)); break;
            }
        } else {
            switch (ins.type_data_fpu.op) {
                case OP_DATA_FLOAT_add: target.asFloat64 = set_flagsf64(state, src1.asFloat64 + src2.asFloat64); break;
                case OP_DATA_FLOAT_sub: target.asFloat64 = set_flagsf64(state, src1.asFloat64 - src2.asFloat64); break;
                case OP_DATA_FLOAT_mul: target.asFloat64 = set_flagsf64(state, src1.asFloat64 * src2.asFloat64); break;
                case OP_DATA_FLOAT_div: target.asFloat64 = set_flagsf64(state, src1.asFloat64 / src2.asFloat64); break;
                case OP_DATA_FLOAT_mod: target.asFloat64 = set_flagsf64(state, fmod(src1.asFloat64, src2.asFloat64)); break;
                case OP_DATA_FLOAT_f2i: target.asSQWord = set_flags64(state, (SQWord_t) src1.asFloat64); break;
                case OP_DATA_FLOAT_sin: target.asFloat64 = set_flagsf64(state, sin(src1.asFloat64)); break;
                case OP_DATA_FLOAT_sqrt: target.asFloat64 = set_flagsf64(state, sqrt(src1.asFloat64)); break;
                case OP_DATA_FLOAT_s2f: target.asFloat64 = set_flagsf64(state, (Float64_t) src1.asFloat32); break;
            }
        }
    }
    state->r[ins.type_data_fpu.r1] = ins.type_data_fpu.no_writeback ? state->r[ins.type_data_fpu.r1] : target;
END_OP
BEGIN_OP(data_vpu)
    extern hive_executor_t vpu_execs[];
    vpu_execs[ins.type_data_vpu.data_op](ins, state);
END_OP

BEGIN_OP(data_bit)
    uint8_t lowest;
    uint8_t num;
    lowest = ins.type_data_bit.start;
    num = (ins.type_data_bit.count_hi << 1 | ins.type_data_bit.count_lo) + 1;
    uint64_t mask = ((1ULL << num) - 1);
    if (ins.type_data_bit.is_dep) {
        state->r[ins.type_data_bit.r1].asQWord &= ~(mask << lowest);
        state->r[ins.type_data_bit.r1].asQWord |= (state->r[ins.type_data_bit.r2].asQWord & mask) << lowest;
    } else {
        uint64_t val = (state->r[ins.type_data_bit.r2].asQWord >> lowest) & mask;
        uint64_t sign_bit = val & (1ULL << (num - 1));
        val |= ins.type_data_bit.extend * (-sign_bit);
        state->r[ins.type_data_bit.r1].asQWord = val;
    }
    set_flags64(state, state->r[ins.type_data_bit.r1].asQWord);
END_OP
BEGIN_OP(data_ls)
    QWord_t addr;
    uint8_t r1 = ins.type_data_ls_imm.r1;
    uint8_t r2 = ins.type_data_ls_imm.r2;
    if (ins.type_data_ls_imm.data_op == SUBOP_DATA_LS_FAR) {
        uint32_t imm = ins.type_data_ls_far.imm;
        uint32_t shift = (((ins.type_data_ls_far.shift_hi << 2) | ins.type_data_ls_far.shift) + 1);
        if (ins.type_data_ls_far.update_ptr) {
            if (ins.type_data_ls_far.is_store) {
                state->r[r2].asQWord += (imm << shift);
                addr = state->r[r2].asQWord;
            } else {
                addr = state->r[r2].asQWord;
                state->r[r2].asQWord += (imm << shift);
            }
        } else {
            addr = (state->r[r2].asQWord + (imm << shift));
        }
    } else if (ins.type_data_ls_imm.use_immediate) {
        if (ins.type_data_ls_imm.update_ptr) {
            if (ins.type_data_ls_imm.is_store) {
                state->r[r2].asQWord += ins.type_data_ls_imm.imm;
                addr = state->r[r2].asQWord;
            } else {
                addr = state->r[r2].asQWord;
                state->r[r2].asQWord += ins.type_data_ls_imm.imm;
            }
        } else {
            addr = (state->r[r2].asQWord + ins.type_data_ls_imm.imm);
        }
    } else {
        uint8_t r3 = ins.type_data_ls_reg.r3;
        if (ins.type_data_ls_reg.update_ptr) {
            if (ins.type_data_ls_reg.is_store) {
                state->r[r2].asQWord += state->r[r3].asQWord;
                addr = state->r[r2].asQWord;
            } else {
                addr = state->r[r2].asQWord;
                state->r[r2].asQWord += state->r[r3].asQWord;
            }
        } else {
            addr = (state->r[r2].asQWord + state->r[r3].asQWord);
        }
    }
    if (ins.type_data_ls_imm.is_store) {
        QWord_t value = state->r[r1].asQWord;
        switch (ins.type_data_ls_imm.size) {
            case SIZE_8BIT: *(uint8_t*) addr = value; break;
            case SIZE_16BIT: *(uint32_t*) addr = value; break;
            case SIZE_32BIT: *(uint16_t*) addr = value; break;
            case SIZE_64BIT: *(uint64_t*) addr = value; break;
        }
    } else {
        switch (ins.type_data_ls_imm.size) {
            case SIZE_8BIT: state->r[r1].asByte = *(uint8_t*) addr; set_flags8(state, state->r[r1].asSByte); break;
            case SIZE_16BIT: state->r[r1].asDWord = *(uint32_t*) addr; set_flags16(state, state->r[r1].asSDWord); break;
            case SIZE_32BIT: state->r[r1].asWord = *(uint16_t*) addr; set_flags32(state, state->r[r1].asSWord); break;
            case SIZE_64BIT: state->r[r1].asQWord = *(uint64_t*) addr; set_flags64(state, state->r[r1].asSQWord); break;
        }
    }
END_OP

BEGIN_OP(load_lea)
    state->r[ins.type_load_signed.r1].asQWord = set_flags64(state, PC_REL(ins.type_load_signed.imm));
END_OP
BEGIN_OP(load_movzk)
    QWord_t shift = (16 * ins.type_load_mov.shift);
    QWord_t mask = ~ROL((QWord_t) 0xFFFF, shift);
    QWord_t value = ((QWord_t) ins.type_load_mov.imm) << shift;
    if (ins.type_load_mov.no_zero) {
        state->r[ins.type_load_mov.r1].asQWord &= mask;
        state->r[ins.type_load_mov.r1].asQWord |= value;
    } else {
        state->r[ins.type_load_mov.r1].asQWord = 0;
        state->r[ins.type_load_mov.r1].asQWord = value;
    }
    set_flags64(state, state->r[ins.type_load_mov.r1].asQWord);
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
        hive_register_t value = state->r[ins.type_load_ls_off.r1];
        switch (state->fr.flags.size) {
            case SIZE_8BIT:  *(Byte_t*) addr = value.asByte; break;
            case SIZE_16BIT: *(Word_t*) addr = value.asWord; break;
            case SIZE_32BIT: *(DWord_t*) addr = value.asDWord; break;
            case SIZE_64BIT: *(QWord_t*) addr = value.asQWord; break;
        }
    } else {
        uint8_t reg = ins.type_load_ls_off.r1;
        hive_register_t val;
        switch (state->fr.flags.size) {
            case SIZE_8BIT:  val.asByte = *(Byte_t*) addr; break;
            case SIZE_16BIT: val.asWord = *(Word_t*) addr; break;
            case SIZE_32BIT: val.asDWord = *(DWord_t*) addr; break;
            case SIZE_64BIT: val.asQWord = *(QWord_t*) addr; break;
        }
        state->r[reg] = val;
    }
END_OP

BEGIN_OP(other_cpuid)
    switch (state->r[0].asQWord) {
        case 0:
            state->r[0].asQWord = set_flags64(state, state->fr.flags.cpuid);
            break;
        case 1:
            state->r[0].asQWord = set_flags64(state, CORE_COUNT);
            break;
        case 2:
            state->r[0].asQWord = set_flags64(state, THREAD_COUNT);
            break;
    }
END_OP

BEGIN_OP(other_privileged)
    switch (ins.type_other_priv.priv_op) {
        case SUBOP_OTHER_cpuid:     exec_other_cpuid(ins, state); break;
    }
END_OP
BEGIN_OP(other_size_override)
    void exec_instr(hive_instruction_t ins, struct cpu_state* state);
    uint8_t old_size = state->fr.flags.size;
    state->fr.flags.size = ins.type_other_size_override.size;
    state->r[REG_PC].asInstrPtr++;
    exec_instr(*state->r[REG_PC].asInstrPtr, state);
    state->fr.flags.size = old_size;
END_OP
BEGIN_OP(other_signextend)
    uint8_t from = ins.type_other_signextend.from;
    uint8_t to = ins.type_other_signextend.to;
    if (to <= from) {
        raise(SIGILL);
    }
    hive_register_t src = state->r[ins.type_other_signextend.r1];
    hive_register_t dest;
    switch (from) {
        case SIZE_8BIT:
            switch (to) {
                case SIZE_16BIT: dest.asSWord = src.asSByte; break;
                case SIZE_32BIT: dest.asSDWord = src.asSByte; break;
                case SIZE_64BIT: dest.asSQWord = src.asSByte; break;
            }
            break;
        case SIZE_16BIT:
            switch (to) {
                case SIZE_32BIT: dest.asSDWord = src.asSWord; break;
                case SIZE_64BIT: dest.asSQWord = src.asSWord; break;
            }
            break;
        case SIZE_32BIT:
            switch (to) {
                case SIZE_64BIT: dest.asSQWord = src.asSDWord; break;
            }
            break;
    }
    state->r[ins.type_other_signextend.r2] = dest;
END_OP

BEGIN_OP(branch)
    QWord_t target;
    if (ins.type_branch.is_reg) {
        target = state->r[ins.type_branch_register.r1].asQWord;
    } else {
        target = PC_REL(ins.type_branch.offset);
    }
    if (ins.type_branch.link) {
        LINK();
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
    }
END_OP
BEGIN_OP(load)
    switch (ins.type_load.op) {
        case OP_LOAD_lea:       exec_load_lea(ins, state); break;
        case OP_LOAD_movzk:     exec_load_movzk(ins, state); break;
        case OP_LOAD_svc:       exec_load_svc(ins, state); break;
        case OP_LOAD_ls_off:    exec_load_ls_off(ins, state); break;
    }
END_OP
BEGIN_OP(other)
    switch (ins.type_other.op) {
        case OP_OTHER_priv_op:          exec_other_privileged(ins, state); break;
        case OP_OTHER_size_override:    exec_other_size_override(ins, state); break;
        case OP_OTHER_signextend:       exec_other_signextend(ins, state); break;
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
        case 0: state->v[ins.type_data_vpu_mov.v1].asQWord[slot] = state->r[ins.type_data_vpu_mov.r2].asQWord;
        case 1: state->v[ins.type_data_vpu_mov.v1].asBytes[slot] = state->r[ins.type_data_vpu_mov.r2].asByte;
        case 2: state->v[ins.type_data_vpu_mov.v1].asWords[slot] = state->r[ins.type_data_vpu_mov.r2].asWord;
        case 3: state->v[ins.type_data_vpu_mov.v1].asDWords[slot] = state->r[ins.type_data_vpu_mov.r2].asDWord;
        case 4: state->v[ins.type_data_vpu_mov.v1].asQWords[slot] = state->r[ins.type_data_vpu_mov.r2].asQWord;
        case 5: state->v[ins.type_data_vpu_mov.v1].asLWords[slot] = state->r[ins.type_data_vpu_mov.r2].asQWord;
        case 6: state->v[ins.type_data_vpu_mov.v1].asFloat32s[slot] = state->r[ins.type_data_vpu_mov.r2].asFloat32;
        case 7: state->v[ins.type_data_vpu_mov.v1].asFloat64s[slot] = state->r[ins.type_data_vpu_mov.r2].asFloat64;
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
    state->r[ins.type_data_vpu_len.r1].asQWord = 0; \
    for (size_t i = 0; sizeof(state->v[0].as ## _what) / sizeof(state->v[0].as ## _what[0]); i++) { \
        if (state->v[ins.type_data_vpu_len.v1].as ## _what[i]) { \
            state->r[ins.type_data_vpu_len.r1].asQWord++; \
        } else { \
            break; \
        } \
    }
#define vpu_len(_what) vpu_len_(_what)

BEGIN_OP(vpu_len)
    switch (ins.type_data_vpu.mode) {
        case 0: vpu_len(vpu_o)
        case 1: vpu_len(vpu_b)
        case 2: vpu_len(vpu_w)
        case 3: vpu_len(vpu_d)
        case 4: vpu_len(vpu_q)
        case 5: vpu_len(vpu_l)
        case 6: vpu_len(vpu_s)
        case 7: vpu_len(vpu_f)
    }
END_OP
BEGIN_OP(vpu_ldr)
    QWord_t addr;
    SQWord_t offset;
    if (ins.type_data_vpu_ls_imm.use_imm) {
        offset = ins.type_data_vpu_ls_imm.imm;
    } else {
        offset = state->r[ins.type_data_vpu_ls.r2].asSQWord;
    }
    if (ins.type_data_vpu_ls.update_ptr) {
        addr = state->r[ins.type_data_vpu_ls_imm.r1].asQWord;
        state->r[ins.type_data_vpu_ls_imm.r1].asQWord += offset;
    } else {
        addr = (state->r[ins.type_data_vpu_ls_imm.r1].asQWord + offset);
    }
    state->v[ins.type_data_vpu_ls.v1] = *(hive_vector_register_t*) addr;
END_OP
BEGIN_OP(vpu_str)
    QWord_t addr;
    SQWord_t offset;
    if (ins.type_data_vpu_ls_imm.use_imm) {
        offset = ins.type_data_vpu_ls_imm.imm;
    } else {
        offset = state->r[ins.type_data_vpu_ls.r2].asSQWord;
    }
    if (ins.type_data_vpu_ls.update_ptr) {
        state->r[ins.type_data_vpu_ls_imm.r1].asQWord += offset;
        addr = state->r[ins.type_data_vpu_ls_imm.r1].asQWord;
    } else {
        addr = (state->r[ins.type_data_vpu_ls_imm.r1].asQWord + offset);
    }
    *(hive_vector_register_t*) addr = state->v[ins.type_data_vpu_ls.v1];
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
char* dis(hive_instruction_t ins, uint64_t addr);

void exec_instr(hive_instruction_t ins, struct cpu_state* state) {
    if (!check_condition(ins, state->fr)) return;
    switch (ins.generic.type) {
        case MODE_BRANCH: exec_branch(ins, state); break;
        case MODE_DATA:   exec_data(ins, state); break;
        case MODE_LOAD:   exec_load(ins, state); break;
        case MODE_OTHER:  exec_other(ins, state); break;
    }
}

int check_condition0(uint8_t ins, hive_flag_register_t fr) {
    switch (ins) {
        case FLAG_ALWAYS:   return 1;
        case FLAG_EQ:       return fr.flags.zero;
        case FLAG_LE:       return fr.flags.negative || fr.flags.zero;
        case FLAG_LT:       return fr.flags.negative;
    }
    return 0;
}

int check_condition(hive_instruction_t ins, hive_flag_register_t fr) {
    if (ins.generic.condition & FLAG_NOT) {
        return !check_condition0(ins.generic.condition & 0b11, fr);
    } else {
        return check_condition0(ins.generic.condition & 0b11, fr);
    }
}

__thread jmp_buf lidt;

int runstate(struct cpu_state* state) {
    int sig = setjmp(lidt);

    size_t t = 0;
    
    if (sig) {
        fprintf(stderr, "Fault on vcore #%d: %s\n", state[t].fr.flags.cpuid, strsignal(sig));
        fprintf(stderr, "%016llx: %s\n", state[t].r[REG_PC].asQWord, dis(*state[t].r[REG_PC].asInstrPtr, state[t].r[REG_PC].asQWord));
        return sig;
    }
    while (1) {
        hive_instruction_t ins[THREAD_COUNT];
        for (t = 0; t < THREAD_COUNT; t++) {
            ins[t] = *(state[t].r[REG_PC].asInstrPtr);
        }
        for (t = 0; t < THREAD_COUNT; t++) {
            exec_instr(ins[t], &(state[t]));
        }
        for (t = 0; t < THREAD_COUNT; t++) {
            state[t].r[REG_PC].asInstrPtr++;
        }
        for (t = 0; t < THREAD_COUNT; t++) {
            struct cpu_transfer tr = transfers[state[t].fr.flags.cpuid];
            if (tr.request) {
                state[t].r[tr.dest_reg].asQWord = tr.value;
                transfers[state[t].fr.flags.cpuid].request = 0;
            }
        }
    }
}

void interrupt_handler(int sig) {
    longjmp(lidt, sig);
}

void exec(void* start) {
    for (uint16_t cpuid = 0; cpuid < CORE_COUNT * THREAD_COUNT; cpuid++) {
        state[cpuid].r[REG_PC].asPointer = start;
        state[cpuid].fr.flags.cpuid = cpuid;
        state[cpuid].fr.flags.size = SIZE_64BIT;
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
