#include <math.h>
#include <signal.h>

#include "new_ops.h"

extern svc_call svcs[];

int check_condition(hive_instruction_t ins, hive_flag_register_t fr);

    // lt, mi   -> negative
    // gt       -> !zero && !negative
    // ge, pl   -> !negative
    // le       -> negative || zero
    // eq, z    -> zero
    // ne, nz   -> !zero
    // always   -> 1
    // never    -> 0
static inline SQWord_t set_flags64(hive_flag_register_t* fr, SQWord_t res) {
    fr->flags.negative = (res < 0);
    fr->flags.zero = (res == 0);
    return res;
}
static inline SDWord_t set_flags32(hive_flag_register_t* fr, SDWord_t res) {
    fr->flags.zero = (res == 0);
    fr->flags.negative = (res < 0);
    return res;
}
static inline SWord_t set_flags16(hive_flag_register_t* fr, SWord_t res) {
    fr->flags.zero = (res == 0);
    fr->flags.negative = (res < 0);
    return res;
}
static inline SByte_t set_flags8(hive_flag_register_t* fr, SByte_t res) {
    fr->flags.zero = (res == 0);
    fr->flags.negative = (res < 0);
    return res;
}
static inline Float64_t set_flagsf64(hive_flag_register_t* fr, Float64_t res) {
    fr->flags.zero = (res == 0.0);
    fr->flags.negative = (res < 0.0);
    return res;
}
static inline Float32_t set_flagsf32(hive_flag_register_t* fr, Float32_t res) {
    fr->flags.zero = (res == 0.0);
    fr->flags.negative = (res < 0.0);
    return res;
}

#define PC_REL(what)                (r[REG_PC].asQWord + ((what) << 2))
#define PC_REL32(what)              (r[REG_PC].asDWord + ((what) << 2))
#define BRANCH(to)                  (r[REG_PC].asQWord = (QWord_t) ((to) - sizeof(hive_instruction_t)))
#define BRANCH_RELATIVE(offset)     BRANCH(PC_REL(offset))
#define LINK()                      (r[REG_LR].asQWord = r[REG_PC].asQWord)

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

typedef void(*hive_executor_t)(hive_instruction_t, hive_register_t*, hive_flag_register_t*, hive_vector_register_t*);

#define BEGIN_OP(_op)   void exec_ ## _op (hive_instruction_t ins, hive_register_t* r, hive_flag_register_t* fr, hive_vector_register_t* v) {
#define END_OP          }
uint64_t swap_bytes_64(uint64_t x) { return htonll(x); }
uint32_t swap_bytes_32(uint32_t x) { return htonl(x); }
uint16_t swap_bytes_16(uint16_t x) { return htons(x); }
uint8_t swap_bytes_8(uint8_t x) { raise(SIGILL); return x; }
#define swap_bytes(x) _Generic((x), int64_t: swap_bytes_64, uint64_t: swap_bytes_64, int32_t: swap_bytes_32, uint32_t: swap_bytes_32, int16_t: swap_bytes_16, uint16_t: swap_bytes_16, int8_t: swap_bytes_8, uint8_t: swap_bytes_8)((x))

#define ALU(nbits) \
uint ## nbits ## _t alu ## nbits(uint8_t op, uint ## nbits ## _t a, uint ## nbits ## _t b, hive_flag_register_t* fr) { \
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
        default: raise(SIGILL); \
    } \
    set_flags ## nbits(fr, target.asI ## nbits); \
    return target.asU ## nbits; \
} \
int ## nbits ## _t salu ## nbits(uint8_t op, int ## nbits ## _t a, int ## nbits ## _t b, hive_flag_register_t* fr) { \
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
        default: raise(SIGILL); \
    } \
    set_flags ## nbits(fr, target.asI ## nbits); \
    return target.asI ## nbits; \
}

ALU(64)

BEGIN_OP(data_alu)
    hive_register_t target;
    hive_register_t src1 = r[ins.type_data_alui.r2];
    uint64_t src2;
    if (ins.type_data_alui.use_imm) {
        src2 = ins.type_data_alui.imm;
    } else {
        src2 = r[ins.type_data_alur.r3].asQWord;
    }
    if (ins.type_data_alui.salu) {
        target.asQWord = salu64(ins.type_data_alui.op, src1.asSQWord, src2, fr);
    } else {
        target.asQWord = alu64(ins.type_data_alui.op, src1.asQWord, src2, fr);
    }
    if (ins.type_data_alui.no_writeback == 0) {
        r[ins.type_data_alui.r1] = target;
    }
END_OP
BEGIN_OP(data_fpu)
    hive_register_t target;
    hive_register_t src1 = r[ins.type_data_fpu.r2];
    hive_register_t src2 = r[ins.type_data_fpu.r3];
    if (ins.type_data_fpu.is_single_op) {
        if (ins.type_data_fpu.use_int_arg2) {
            switch (ins.type_data_fpu.op) {
                case OP_DATA_FLOAT_add: target.asFloat32 = src1.asFloat32 + src2.asSDWord; break;
                case OP_DATA_FLOAT_sub: target.asFloat32 = src1.asFloat32 - src2.asSDWord; break;
                case OP_DATA_FLOAT_mul: target.asFloat32 = src1.asFloat32 * src2.asSDWord; break;
                case OP_DATA_FLOAT_div: target.asFloat32 = src1.asFloat32 / src2.asSDWord; break;
                case OP_DATA_FLOAT_mod: target.asFloat32 = fmod(src1.asFloat32, src2.asSDWord); break;
                case OP_DATA_FLOAT_f2i: target.asFloat32 = (Float32_t) src1.asSDWord; break;
                case OP_DATA_FLOAT_sin: target.asFloat32 = sin(src1.asFloat32); break;
                case OP_DATA_FLOAT_sqrt: target.asFloat32 = sqrt(src1.asFloat32); break;
            }
            set_flagsf32(fr, target.asFloat32);
        } else {
            switch (ins.type_data_fpu.op) {
                case OP_DATA_FLOAT_add: target.asFloat32 = src1.asFloat32 + src2.asFloat32; break;
                case OP_DATA_FLOAT_sub: target.asFloat32 = src1.asFloat32 - src2.asFloat32; break;
                case OP_DATA_FLOAT_mul: target.asFloat32 = src1.asFloat32 * src2.asFloat32; break;
                case OP_DATA_FLOAT_div: target.asFloat32 = src1.asFloat32 / src2.asFloat32; break;
                case OP_DATA_FLOAT_mod: target.asFloat32 = fmod(src1.asFloat32, src2.asFloat32); break;
                case OP_DATA_FLOAT_f2i: target.asSDWord = set_flags32(fr, (SDWord_t) src1.asFloat32); break;
                case OP_DATA_FLOAT_sin: target.asFloat32 = sin(src1.asFloat32); break;
                case OP_DATA_FLOAT_sqrt: target.asFloat32 = sqrt(src1.asFloat32); break;
            }
            if (ins.type_data_fpu.sub_op != OP_DATA_FLOAT_f2i) {
                set_flagsf32(fr, target.asFloat32);
            }
        }
    } else {
        if (ins.type_data_fpu.use_int_arg2) {
            switch (ins.type_data_fpu.op) {
                case OP_DATA_FLOAT_add: target.asFloat64 = src1.asFloat64 + src2.asSQWord; break;
                case OP_DATA_FLOAT_sub: target.asFloat64 = src1.asFloat64 - src2.asSQWord; break;
                case OP_DATA_FLOAT_mul: target.asFloat64 = src1.asFloat64 * src2.asSQWord; break;
                case OP_DATA_FLOAT_div: target.asFloat64 = src1.asFloat64 / src2.asSQWord; break;
                case OP_DATA_FLOAT_mod: target.asFloat64 = fmod(src1.asFloat64, src2.asSQWord); break;
                case OP_DATA_FLOAT_f2i: target.asFloat64 = (Float64_t) src1.asSQWord; break;
                case OP_DATA_FLOAT_sin: target.asFloat64 = sin(src1.asFloat64); break;
                case OP_DATA_FLOAT_sqrt: target.asFloat64 = sqrt(src1.asFloat64); break;
            }
            set_flagsf64(fr, target.asFloat64);
        } else {
            switch (ins.type_data_fpu.op) {
                case OP_DATA_FLOAT_add: target.asFloat64 = src1.asFloat64 + src2.asFloat64; break;
                case OP_DATA_FLOAT_sub: target.asFloat64 = src1.asFloat64 - src2.asFloat64; break;
                case OP_DATA_FLOAT_mul: target.asFloat64 = src1.asFloat64 * src2.asFloat64; break;
                case OP_DATA_FLOAT_div: target.asFloat64 = src1.asFloat64 / src2.asFloat64; break;
                case OP_DATA_FLOAT_mod: target.asFloat64 = fmod(src1.asFloat64, src2.asFloat64); break;
                case OP_DATA_FLOAT_f2i: target.asSQWord = set_flags64(fr, (SQWord_t) src1.asFloat64); break;
                case OP_DATA_FLOAT_sin: target.asFloat64 = sin(src1.asFloat64); break;
                case OP_DATA_FLOAT_sqrt: target.asFloat64 = sqrt(src1.asFloat64); break;
            }
            if (ins.type_data_fpu.sub_op != OP_DATA_FLOAT_f2i) {
                set_flagsf64(fr, target.asFloat64);
            }
        }
    }
    if (ins.type_data_fpu.no_writeback == 0) {
        r[ins.type_data_fpu.r1] = target;
    }
END_OP
BEGIN_OP(data_vpu)
    extern hive_executor_t vpu_execs[];
    vpu_execs[ins.type_data_vpu.sub_op](ins, r, fr, v);
END_OP

uint8_t decode_count(hive_instruction_t ins) {
    return ins.type_data_bit.count_hi << 1 | ins.type_data_bit.count_lo;
}

BEGIN_OP(data_bit)
    uint8_t lowest;
    uint8_t num;
    if (ins.type_data_bit.is_reg) {
        lowest = decode_count(ins) + 1;
        num = ins.type_data_bit.start;
    } else {
        lowest = r[ins.type_data_bitr.start_reg].asByte;
        lowest = r[ins.type_data_bitr.count_reg].asByte;
    }
    uint64_t mask = ((1ULL << num) - 1);
    if (ins.type_data_bit.is_dep) {
        uint64_t val = (r[ins.type_data_bit.r2].asQWord & (mask << lowest)) >> lowest;
        if (ins.type_data_bit.extend) {
            uint8_t sign_bit_mask = (1ULL << (num - 1));
            if (val & sign_bit_mask) {
                val |= ~mask;
            }
        }
        r[ins.type_data_bit.r1].asQWord = val;
    } else {
        r[ins.type_data_bit.r1].asQWord &= ~(mask << lowest);
        r[ins.type_data_bit.r1].asQWord |= (r[ins.type_data_bit.r2].asQWord & mask) << lowest;
    }
    set_flags64(fr, r[ins.type_data_bit.r1].asQWord);
END_OP
BEGIN_OP(data_ls)
    QWord_t addr;
    if (ins.type_data_ls_imm.use_immediate) {
        if (ins.type_data_ls_imm.update_ptr) {
            if (ins.type_data_ls_imm.is_store) {
                r[ins.type_data_ls_imm.r2].asQWord += ins.type_data_ls_imm.imm;
                addr = r[ins.type_data_ls_imm.r2].asQWord;
            } else {
                addr = r[ins.type_data_ls_imm.r2].asQWord;
                r[ins.type_data_ls_imm.r2].asQWord += ins.type_data_ls_imm.imm;
            }
        } else {
            addr = (r[ins.type_data_ls_imm.r2].asQWord + ins.type_data_ls_imm.imm);
        }
    } else {
        if (ins.type_data_ls_reg.update_ptr) {
            if (ins.type_data_ls_reg.is_store) {
                r[ins.type_data_ls_reg.r2].asQWord += r[ins.type_data_ls_reg.r3].asQWord;
                addr = r[ins.type_data_ls_reg.r2].asQWord;
            } else {
                addr = r[ins.type_data_ls_reg.r2].asQWord;
                r[ins.type_data_ls_reg.r2].asQWord += r[ins.type_data_ls_reg.r3].asQWord;
            }
        } else {
            addr = (r[ins.type_data_ls_reg.r2].asQWord + r[ins.type_data_ls_reg.r3].asQWord);
        }
    }
    if (ins.type_data_ls_imm.is_store) {
        QWord_t value = r[ins.type_data_ls_imm.r1].asQWord;
        switch (ins.type_data_ls_imm.size) {
            case SIZE_8BIT: *(uint8_t*) addr = value; break;
            case SIZE_16BIT: *(uint32_t*) addr = value; break;
            case SIZE_32BIT: *(uint16_t*) addr = value; break;
            case SIZE_64BIT: *(uint64_t*) addr = value; break;
        }
    } else {
        uint8_t reg = ins.type_data_ls_imm.r1;
        switch (ins.type_data_ls_imm.size) {
            case SIZE_8BIT: r[reg].asByte = *(uint8_t*) addr; set_flags8(fr, r[reg].asSByte); break;
            case SIZE_16BIT: r[reg].asDWord = *(uint32_t*) addr; set_flags16(fr, r[reg].asSDWord); break;
            case SIZE_32BIT: r[reg].asWord = *(uint16_t*) addr; set_flags32(fr, r[reg].asSWord); break;
            case SIZE_64BIT: r[reg].asQWord = *(uint64_t*) addr; set_flags64(fr, r[reg].asSQWord); break;
        }
    }
END_OP

BEGIN_OP(load_lea)
    r[ins.type_load_signed.r1].asQWord = set_flags64(fr, PC_REL(ins.type_load_signed.imm));
END_OP
BEGIN_OP(load_movzk)
    QWord_t shift = (16 * ins.type_load_mov.shift);
    QWord_t mask = ~ROL(0xFFFFULL, shift);
    QWord_t value = ((QWord_t) ins.type_load_mov.imm) << shift;
    if (ins.type_load_mov.no_zero) {
        r[ins.type_load_mov.r1].asQWord &= mask;
        r[ins.type_load_mov.r1].asQWord |= value;
    } else {
        r[ins.type_load_mov.r1].asQWord = 0;
        r[ins.type_load_mov.r1].asQWord = value;
    }
    set_flags64(fr, r[ins.type_load_mov.r1].asQWord);
END_OP
BEGIN_OP(load_svc)
    r[0].asQWord = svcs[r[8].asQWord](
        r[0].asQWord,
        r[1].asQWord,
        r[2].asQWord,
        r[3].asQWord,
        r[4].asQWord,
        r[5].asQWord,
        r[6].asQWord,
        r[7].asQWord
    );
END_OP

BEGIN_OP(branch)
    if (ins.type_branch.link) {
        LINK();
    }
    if (ins.type_branch.is_reg) {
        BRANCH(r[ins.type_branch_register.r1].asQWord);
    } else {
        BRANCH_RELATIVE(ins.type_branch.offset);
    }
END_OP
BEGIN_OP(data)
    switch (ins.type_data.sub_op) {
        case SUBOP_DATA_ALU_I:  case_fallthrough;
        case SUBOP_DATA_ALU_R:  case_fallthrough;
        case SUBOP_DATA_SALU_I: case_fallthrough;
        case SUBOP_DATA_SALU_R: exec_data_alu(ins, r, fr, v); break;
        case SUBOP_DATA_BDEP:   case_fallthrough;
        case SUBOP_DATA_BDEPR:  case_fallthrough;
        case SUBOP_DATA_BEXT:   case_fallthrough;
        case SUBOP_DATA_BEXTR:  exec_data_bit(ins, r, fr, v); break;
        case SUBOP_DATA_LS:     exec_data_ls(ins, r, fr, v); break;
        case SUBOP_DATA_FPU:    exec_data_fpu(ins, r, fr, v); break;
        case SUBOP_DATA_VPU:    exec_data_vpu(ins, r, fr, v); break;
        default:                raise(SIGILL);
    }
END_OP
BEGIN_OP(load)
    switch (ins.type_load.op) {
        case OP_LOAD_lea:       exec_load_lea(ins, r, fr, v); break;
        case OP_LOAD_movzk:     exec_load_movzk(ins, r, fr, v); break;
        case OP_LOAD_svc:       exec_load_svc(ins, r, fr, v); break;
        default:                raise(SIGILL);
    }
END_OP

#define vop_(_type, _what) for (size_t i = 0; i < sizeof(v[0].as ## _type) / sizeof(v[0].as ## _type[0]); i++) { \
    v[ins.type_data_vpu.v1].as ## _type[i] = v[ins.type_data_vpu.v2].as ## _type[i] _what v[ins.type_data_vpu.v3].as ## _type[i]; \
}
#define vop_as_(_type) for (size_t i = 0; i < sizeof(v[0].as ## _type) / sizeof(v[0].as ## _type[0]); i += 2) { \
    v[ins.type_data_vpu.v1].as ## _type[i] = v[ins.type_data_vpu.v2].as ## _type[i] + v[ins.type_data_vpu.v3].as ## _type[i]; \
    v[ins.type_data_vpu.v1].as ## _type[i + 1] = v[ins.type_data_vpu.v2].as ## _type[i + 1] - v[ins.type_data_vpu.v3].as ## _type[i + 1]; \
}
#define vop_madd_(_type) for (size_t i = 0; i < sizeof(v[0].as ## _type) / sizeof(v[0].as ## _type[0]); i++) { \
    v[ins.type_data_vpu.v1].as ## _type[i] = v[ins.type_data_vpu.v2].as ## _type[i] * v[ins.type_data_vpu.v3].as ## _type[i]; \
} \
for (size_t i = 0; i < sizeof(v[0].as ## _type) / sizeof(v[0].as ## _type[0]); i++) { \
    v[ins.type_data_vpu.v1].as ## _type[0] += v[ins.type_data_vpu.v1].as ## _type[i]; \
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
        case 0: v[ins.type_data_vpu_mov.v1].asQWord[slot] = r[ins.type_data_vpu_mov.r2].asQWord;
        case 1: v[ins.type_data_vpu_mov.v1].asBytes[slot] = r[ins.type_data_vpu_mov.r2].asByte;
        case 2: v[ins.type_data_vpu_mov.v1].asWords[slot] = r[ins.type_data_vpu_mov.r2].asWord;
        case 3: v[ins.type_data_vpu_mov.v1].asDWords[slot] = r[ins.type_data_vpu_mov.r2].asDWord;
        case 4: v[ins.type_data_vpu_mov.v1].asQWords[slot] = r[ins.type_data_vpu_mov.r2].asQWord;
        case 5: v[ins.type_data_vpu_mov.v1].asLWords[slot] = r[ins.type_data_vpu_mov.r2].asQWord;
        case 6: v[ins.type_data_vpu_mov.v1].asFloat32s[slot] = r[ins.type_data_vpu_mov.r2].asFloat32;
        case 7: v[ins.type_data_vpu_mov.v1].asFloat64s[slot] = r[ins.type_data_vpu_mov.r2].asFloat64;
    }
END_OP
BEGIN_OP(vpu_mov_vec)
    v[ins.type_data_vpu.v1] = v[ins.type_data_vpu.v2];
END_OP

#define vpu_conv_(_from, _to) { \
    uint8_t min = \
        sizeof(v[0].as ## _to) / sizeof(v[0].as ## _to[0]) < sizeof(v[0].as ## _from) / sizeof(v[0].as ## _from[0]) ? \
        sizeof(v[0].as ## _to) / sizeof(v[0].as ## _to[0]) : \
        sizeof(v[0].as ## _from) / sizeof(v[0].as ## _from[0]); \
    for (size_t i = 0; i < min; i++) { \
        v[ins.type_data_vpu_conv.v1].as ## _to[i] = v[ins.type_data_vpu_conv.v2].as ## _from[i]; \
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
    r[ins.type_data_vpu_len.r1].asQWord = 0; \
    for (size_t i = 0; sizeof(v[0].as ## _what) / sizeof(v[0].as ## _what[0]); i++) { \
        if (v[ins.type_data_vpu_len.v1].as ## _what[i]) { \
            r[ins.type_data_vpu_len.r1].asQWord++; \
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
    if (ins.type_data_vpu_ls.use_imm) {
        addr = (r[ins.type_data_vpu_ls_imm.r1].asQWord + ins.type_data_vpu_ls_imm.imm);
    } else {
        addr = (r[ins.type_data_vpu_ls.r1].asQWord + r[ins.type_data_vpu_ls.r2].asSQWord);
    }
    v[ins.type_data_vpu_ls.v1] = *(hive_vector_register_t*) addr;
END_OP
BEGIN_OP(vpu_str)
    QWord_t addr;
    if (ins.type_data_vpu_ls.use_imm) {
        addr = (r[ins.type_data_vpu_ls_imm.r1].asQWord + ins.type_data_vpu_ls_imm.imm);
    } else {
        addr = (r[ins.type_data_vpu_ls.r1].asQWord + r[ins.type_data_vpu_ls.r2].asSQWord);
    }
    *(hive_vector_register_t*) addr = v[ins.type_data_vpu_ls.v1];
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

void exec_instr(hive_instruction_t ins, hive_register_t* r, hive_flag_register_t* fr, hive_vector_register_t* v) {
    if (!check_condition(ins, *fr)) return;
    switch (ins.generic.type) {
        case MODE_BRANCH: exec_branch(ins, r, fr, v); break;
        case MODE_DATA:   exec_data(ins, r, fr, v); break;
        case MODE_LOAD:   exec_load(ins, r, fr, v); break;
        default: raise(SIGILL);
    }
}
