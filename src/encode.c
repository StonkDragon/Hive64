#include "new_ops.h"

uint32_t encode_opcode_nop(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_nop << 24;
    return opcode;
}

uint32_t encode_opcode_ret(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_ret << 24;
    return opcode;
}

uint32_t encode_opcode_irq(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_irq << 24;
    return opcode;
}

uint32_t encode_opcode_svc(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_svc << 24;
    return opcode;
}

uint32_t encode_opcode_b_addr(section_t* sect, struct instruction instr) {
    uint16_t s = symbol_offset(sect, instr.args[0].sym);
    uint32_t opcode = opcode_b_addr << 24 | s;
    return opcode;
}

uint32_t encode_opcode_bl_addr(section_t* sect, struct instruction instr) {
    uint16_t s = symbol_offset(sect, instr.args[0].sym);
    uint32_t opcode = opcode_bl_addr << 24 | s;
    return opcode;
}

uint32_t encode_opcode_br_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_br_reg << 24 | instr.args[0].reg;
    return opcode;
}

uint32_t encode_opcode_blr_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_blr_reg << 24 | instr.args[0].reg;
    return opcode;
}

uint32_t encode_opcode_dot_eq(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_dot_eq << 24 | instr.args[0].reg;
    return opcode;
}

uint32_t encode_opcode_dot_ne(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_dot_ne << 24 | instr.args[0].reg;
    return opcode;
}

uint32_t encode_opcode_dot_lt(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_dot_lt << 24 | instr.args[0].reg;
    return opcode;
}

uint32_t encode_opcode_dot_gt(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_dot_gt << 24 | instr.args[0].reg;
    return opcode;
}

uint32_t encode_opcode_dot_le(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_dot_le << 24 | instr.args[0].reg;
    return opcode;
}

uint32_t encode_opcode_dot_ge(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_dot_ge << 24 | instr.args[0].reg;
    return opcode;
}

uint32_t encode_opcode_dot_cs(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_dot_cs << 24 | instr.args[0].reg;
    return opcode;
}

uint32_t encode_opcode_dot_cc(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_dot_cc << 24 | instr.args[0].reg;
    return opcode;
}

uint32_t encode_opcode_add_reg_reg_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_add_reg_reg_reg << 24 | instr.args[0].reg << 16 | instr.args[1].reg << 8 | instr.args[2].reg;
    return opcode;
}

uint32_t encode_opcode_sub_reg_reg_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_sub_reg_reg_reg << 24 | instr.args[0].reg << 16 | instr.args[1].reg << 8 | instr.args[2].reg;
    return opcode;
}

uint32_t encode_opcode_mul_reg_reg_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_mul_reg_reg_reg << 24 | instr.args[0].reg << 16 | instr.args[1].reg << 8 | instr.args[2].reg;
    return opcode;
}

uint32_t encode_opcode_div_reg_reg_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_div_reg_reg_reg << 24 | instr.args[0].reg << 16 | instr.args[1].reg << 8 | instr.args[2].reg;
    return opcode;
}

uint32_t encode_opcode_mod_reg_reg_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_mod_reg_reg_reg << 24 | instr.args[0].reg << 16 | instr.args[1].reg << 8 | instr.args[2].reg;
    return opcode;
}

uint32_t encode_opcode_and_reg_reg_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_and_reg_reg_reg << 24 | instr.args[0].reg << 16 | instr.args[1].reg << 8 | instr.args[2].reg;
    return opcode;
}

uint32_t encode_opcode_or_reg_reg_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_or_reg_reg_reg << 24 | instr.args[0].reg << 16 | instr.args[1].reg << 8 | instr.args[2].reg;
    return opcode;
}

uint32_t encode_opcode_xor_reg_reg_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_xor_reg_reg_reg << 24 | instr.args[0].reg << 16 | instr.args[1].reg << 8 | instr.args[2].reg;
    return opcode;
}

uint32_t encode_opcode_shl_reg_reg_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_shl_reg_reg_reg << 24 | instr.args[0].reg << 16 | instr.args[1].reg << 8 | instr.args[2].reg;
    return opcode;
}

uint32_t encode_opcode_shr_reg_reg_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_shr_reg_reg_reg << 24 | instr.args[0].reg << 16 | instr.args[1].reg << 8 | instr.args[2].reg;
    return opcode;
}

uint32_t encode_opcode_rol_reg_reg_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_rol_reg_reg_reg << 24 | instr.args[0].reg << 16 | instr.args[1].reg << 8 | instr.args[2].reg;
    return opcode;
}

uint32_t encode_opcode_ror_reg_reg_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_ror_reg_reg_reg << 24 | instr.args[0].reg << 16 | instr.args[1].reg << 8 | instr.args[2].reg;
    return opcode;
}

uint32_t encode_opcode_inc_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_inc_reg << 24 | instr.args[0].reg;
    return opcode;
}

uint32_t encode_opcode_dec_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_dec_reg << 24 | instr.args[0].reg;
    return opcode;
}

uint32_t encode_opcode_psh_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_psh_reg << 24 | instr.args[0].reg;
    return opcode;
}

uint32_t encode_opcode_pp_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_pp_reg << 24 | instr.args[0].reg;
    return opcode;
}

uint32_t encode_opcode_ldr_reg_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_ldr_reg_reg << 24 | instr.args[0].reg << 8 | instr.args[1].reg;
    return opcode;
}

uint32_t encode_opcode_ldr_reg_addr(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_ldr_reg_addr << 24 | instr.args[0].reg << 8 | instr.args[1].reg;
    return opcode;
}

uint32_t encode_opcode_ldr_reg_addr_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_ldr_reg_addr_reg << 24 | instr.args[0].reg << 16 | instr.args[1].reg << 8 | instr.args[2].reg;
    return opcode;
}

uint32_t encode_opcode_ldr_reg_addr_imm(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_ldr_reg_addr_imm << 24 | instr.args[0].reg << 16 | instr.args[1].reg << 8 | instr.args[2].imm8;
    return opcode;
}

uint32_t encode_opcode_str_reg_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_str_reg_reg << 24 | instr.args[0].reg << 8 | instr.args[1].reg;
    return opcode;
}

uint32_t encode_opcode_str_reg_addr_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_str_reg_addr_reg << 24 | instr.args[0].reg << 16 | instr.args[1].reg << 8 | instr.args[2].reg;
    return opcode;
}

uint32_t encode_opcode_movl(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_movl << 24 | instr.args[0].reg << 16 | instr.args[1].imm16;
    return opcode;
}

uint32_t encode_opcode_movh(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_movh << 24 | instr.args[0].reg << 16 | instr.args[1].imm16;
    return opcode;
}

uint32_t encode_opcode_movql(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_movql << 24 | instr.args[0].reg << 16 | instr.args[1].imm16;
    return opcode;
}

uint32_t encode_opcode_movqh(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_movqh << 24 | instr.args[0].reg << 16 | instr.args[1].imm16;
    return opcode;
}

uint32_t encode_opcode_lea_reg_addr(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_lea_reg_addr << 24 | instr.args[0].reg << 16 | symbol_offset(sect, instr.args[1].sym);
    return opcode;
}

uint32_t encode_opcode_cmp_reg_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_cmp_reg_reg << 24 | instr.args[0].reg << 8 | instr.args[1].reg;
    return opcode;
}

uint32_t encode_opcode_xchg_reg_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_xchg_reg_reg << 24 | instr.args[0].reg << 8 | instr.args[1].reg;
    return opcode;
}

uint32_t encode_opcode_movz(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_movz << 24 | instr.args[0].reg << 16 | instr.args[1].imm16;
    return opcode;
}

uint32_t encode_opcode_add_reg_imm(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_add_reg_imm << 24 | instr.args[0].reg << 16 | instr.args[1].imm16;
    return opcode;
}

uint32_t encode_opcode_sub_reg_imm(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_sub_reg_imm << 24 | instr.args[0].reg << 16 | instr.args[1].imm16;
    return opcode;
}

uint32_t encode_opcode_mul_reg_imm(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_mul_reg_imm << 24 | instr.args[0].reg << 16 | instr.args[1].imm16;
    return opcode;
}

uint32_t encode_opcode_div_reg_imm(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_div_reg_imm << 24 | instr.args[0].reg << 16 | instr.args[1].imm16;
    return opcode;
}

uint32_t encode_opcode_mod_reg_imm(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_mod_reg_imm << 24 | instr.args[0].reg << 16 | instr.args[1].imm16;
    return opcode;
}

uint32_t encode_opcode_and_reg_imm(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_and_reg_imm << 24 | instr.args[0].reg << 16 | instr.args[1].imm16;
    return opcode;
}

uint32_t encode_opcode_or_reg_imm(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_or_reg_imm << 24 | instr.args[0].reg << 16 | instr.args[1].imm16;
    return opcode;
}

uint32_t encode_opcode_xor_reg_imm(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_xor_reg_imm << 24 | instr.args[0].reg << 16 | instr.args[1].imm16;
    return opcode;
}

uint32_t encode_opcode_shl_reg_imm(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_shl_reg_imm << 24 | instr.args[0].reg << 16 | instr.args[1].imm16;
    return opcode;
}

uint32_t encode_opcode_shr_reg_imm(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_shr_reg_imm << 24 | instr.args[0].reg << 16 | instr.args[1].imm16;
    return opcode;
}

uint32_t encode_opcode_rol_reg_imm(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_rol_reg_imm << 24 | instr.args[0].reg << 16 | instr.args[1].imm16;
    return opcode;
}

uint32_t encode_opcode_ror_reg_imm(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_ror_reg_imm << 24 | instr.args[0].reg << 16 | instr.args[1].imm16;
    return opcode;
}

uint32_t encode_opcode_not_reg(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_not_reg << 24 | instr.args[0].reg;
    return opcode;
}

uint32_t encode_opcode_dot_addressing_override(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_dot_addressing_override << 24 | instr.args[0].reg;
    return opcode;
}

uint32_t encode_opcode_dot_symbol(section_t* sect, struct instruction instr) {
    uint32_t opcode = opcode_dot_symbol << 24;
    return opcode;
}
