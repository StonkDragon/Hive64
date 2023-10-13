#include "new_ops.h"

opcode_t encode_opcode_nop(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_nop };
    return opcode;
}

opcode_t encode_opcode_ret(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_ret };
    return opcode;
}

opcode_t encode_opcode_irq(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_irq };
    return opcode;
}

opcode_t encode_opcode_svc(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_svc };
    return opcode;
}

opcode_t encode_opcode_b_addr(section_t* sect, struct instruction instr) {
    int32_t s = symbol_offset(sect, instr.args[0].sym);
    if (s > 0x7fffff || s < -0x800000) {
        printf("Error: Symbol offset too large for b instruction. Is: 0x%06x\n", s);
        exit(1);
    }
    opcode_t opcode = (opcode_t) { .opcode = opcode_b_addr };
    opcode.args.args_raw = s & 0xffffff;
    return opcode;
}

opcode_t encode_opcode_bl_addr(section_t* sect, struct instruction instr) {
    int32_t s = symbol_offset(sect, instr.args[0].sym);
    if (s > 0x7fffff || s < -0x800000) {
        printf("Error: Symbol offset too large for bl instruction. Is: 0x%06x\n", s);
        exit(1);
    }
    opcode_t opcode = (opcode_t) { .opcode = opcode_bl_addr };
    opcode.args.args_raw = s & 0xffffff;
    return opcode;
}

opcode_t encode_opcode_br_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_br_reg };
    opcode.args.r = instr.args[0].reg;
    return opcode;
}

opcode_t encode_opcode_blr_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_blr_reg };
    opcode.args.r = instr.args[0].reg;
    return opcode;
}

opcode_t encode_opcode_dot_eq(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_dot_eq };
    opcode.args.u8 = instr.args[0].imm8;
    return opcode;
}

opcode_t encode_opcode_dot_ne(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_dot_ne };
    opcode.args.u8 = instr.args[0].imm8;
    return opcode;
}

opcode_t encode_opcode_dot_lt(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_dot_lt };
    opcode.args.u8 = instr.args[0].imm8;
    return opcode;
}

opcode_t encode_opcode_dot_gt(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_dot_gt };
    opcode.args.u8 = instr.args[0].imm8;
    return opcode;
}

opcode_t encode_opcode_dot_le(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_dot_le };
    opcode.args.u8 = instr.args[0].imm8;
    return opcode;
}

opcode_t encode_opcode_dot_ge(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_dot_ge };
    opcode.args.u8 = instr.args[0].imm8;
    return opcode;
}

opcode_t encode_opcode_dot_cs(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_dot_cs };
    opcode.args.u8 = instr.args[0].imm8;
    return opcode;
}

opcode_t encode_opcode_dot_cc(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_dot_cc };
    opcode.args.u8 = instr.args[0].imm8;
    return opcode;
}

opcode_t encode_opcode_add_reg_reg_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_add_reg_reg_reg };
    opcode.args.rrr.reg1 = instr.args[0].reg;
    opcode.args.rrr.reg2 = instr.args[1].reg;
    opcode.args.rrr.reg3 = instr.args[2].reg;
    return opcode;
}

opcode_t encode_opcode_sub_reg_reg_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_sub_reg_reg_reg };
    opcode.args.rrr.reg1 = instr.args[0].reg;
    opcode.args.rrr.reg2 = instr.args[1].reg;
    opcode.args.rrr.reg3 = instr.args[2].reg;
    return opcode;
}

opcode_t encode_opcode_mul_reg_reg_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_mul_reg_reg_reg };
    opcode.args.rrr.reg1 = instr.args[0].reg;
    opcode.args.rrr.reg2 = instr.args[1].reg;
    opcode.args.rrr.reg3 = instr.args[2].reg;
    return opcode;
}

opcode_t encode_opcode_div_reg_reg_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_div_reg_reg_reg };
    opcode.args.rrr.reg1 = instr.args[0].reg;
    opcode.args.rrr.reg2 = instr.args[1].reg;
    opcode.args.rrr.reg3 = instr.args[2].reg;
    return opcode;
}

opcode_t encode_opcode_mod_reg_reg_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_mod_reg_reg_reg };
    opcode.args.rrr.reg1 = instr.args[0].reg;
    opcode.args.rrr.reg2 = instr.args[1].reg;
    opcode.args.rrr.reg3 = instr.args[2].reg;
    return opcode;
}

opcode_t encode_opcode_and_reg_reg_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_and_reg_reg_reg };
    opcode.args.rrr.reg1 = instr.args[0].reg;
    opcode.args.rrr.reg2 = instr.args[1].reg;
    opcode.args.rrr.reg3 = instr.args[2].reg;
    return opcode;
}

opcode_t encode_opcode_or_reg_reg_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_or_reg_reg_reg };
    opcode.args.rrr.reg1 = instr.args[0].reg;
    opcode.args.rrr.reg2 = instr.args[1].reg;
    opcode.args.rrr.reg3 = instr.args[2].reg;
    return opcode;
}

opcode_t encode_opcode_xor_reg_reg_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_xor_reg_reg_reg };
    opcode.args.rrr.reg1 = instr.args[0].reg;
    opcode.args.rrr.reg2 = instr.args[1].reg;
    opcode.args.rrr.reg3 = instr.args[2].reg;
    return opcode;
}

opcode_t encode_opcode_shl_reg_reg_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_shl_reg_reg_reg };
    opcode.args.rrr.reg1 = instr.args[0].reg;
    opcode.args.rrr.reg2 = instr.args[1].reg;
    opcode.args.rrr.reg3 = instr.args[2].reg;
    return opcode;
}

opcode_t encode_opcode_shr_reg_reg_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_shr_reg_reg_reg };
    opcode.args.rrr.reg1 = instr.args[0].reg;
    opcode.args.rrr.reg2 = instr.args[1].reg;
    opcode.args.rrr.reg3 = instr.args[2].reg;
    return opcode;
}

opcode_t encode_opcode_rol_reg_reg_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_rol_reg_reg_reg };
    opcode.args.rrr.reg1 = instr.args[0].reg;
    opcode.args.rrr.reg2 = instr.args[1].reg;
    opcode.args.rrr.reg3 = instr.args[2].reg;
    return opcode;
}

opcode_t encode_opcode_ror_reg_reg_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_ror_reg_reg_reg };
    opcode.args.rrr.reg1 = instr.args[0].reg;
    opcode.args.rrr.reg2 = instr.args[1].reg;
    opcode.args.rrr.reg3 = instr.args[2].reg;
    return opcode;
}

opcode_t encode_opcode_inc_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_inc_reg };
    opcode.args.r = instr.args[0].reg;
    return opcode;
}

opcode_t encode_opcode_dec_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_dec_reg };
    opcode.args.r = instr.args[0].reg;
    return opcode;
}

opcode_t encode_opcode_psh_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_psh_reg };
    opcode.args.r = instr.args[0].reg;
    return opcode;
}

opcode_t encode_opcode_pp_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_pp_reg };
    opcode.args.r = instr.args[0].reg;
    return opcode;
}

opcode_t encode_opcode_ldr_reg_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_ldr_reg_reg };
    opcode.args.rr.reg1 = instr.args[0].reg;
    opcode.args.rr.reg2 = instr.args[1].reg;
    return opcode;
}

opcode_t encode_opcode_ldr_reg_addr_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_ldr_reg_addr_reg };
    opcode.args.rrr.reg1 = instr.args[0].reg;
    opcode.args.rrr.reg2 = instr.args[1].reg;
    opcode.args.rrr.reg3 = instr.args[2].reg;
    return opcode;
}

opcode_t encode_opcode_ldr_reg_addr_imm(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_ldr_reg_addr_imm };
    opcode.args.rri.reg1 = instr.args[0].reg;
    opcode.args.rri.reg2 = instr.args[1].reg;
    opcode.args.rri.imm = instr.args[2].imm8;
    return opcode;
}

opcode_t encode_opcode_str_reg_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_str_reg_reg };
    opcode.args.rr.reg1 = instr.args[0].reg;
    opcode.args.rr.reg2 = instr.args[1].reg;
    return opcode;
}

opcode_t encode_opcode_str_reg_addr_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_str_reg_addr_reg };
    opcode.args.rrr.reg1 = instr.args[0].reg;
    opcode.args.rrr.reg2 = instr.args[1].reg;
    opcode.args.rrr.reg3 = instr.args[2].reg;
    return opcode;
}

opcode_t encode_opcode_movz(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_movz };
    opcode.args.ris.reg1 = instr.args[0].reg;
    opcode.args.ris.imm = instr.args[1].imm16;
    opcode.args.ris.shift = instr.args[2].imm8 / 16;
    return opcode;
}

opcode_t encode_opcode_movk(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_movz };
    opcode.args.ris.reg1 = instr.args[0].reg;
    opcode.args.ris.imm = instr.args[1].imm16;
    opcode.args.ris.shift = instr.args[2].imm8 / 16;
    return opcode;
}

opcode_t encode_opcode_adrp_reg_addr(section_t* sect, struct instruction instr) {
    int32_t s = symbol_offset(sect, instr.args[1].sym);
    opcode_t opcode = (opcode_t) { .opcode = opcode_adrp_reg_addr };
    opcode.args.ri.reg1 = instr.args[0].reg;
    opcode.args.ri.imm = (s >> 16) & 0xffff;
    return opcode;
}

opcode_t encode_opcode_adp_reg_addr(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_adp_reg_addr };
    opcode.args.ri.reg1 = instr.args[0].reg;
    
    int32_t s = symbol_offset(sect, instr.args[1].sym) + 1;
    opcode.args.ri.imm = (s & 0xffff);

    return opcode;
}

opcode_t encode_opcode_cmp_reg_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_cmp_reg_reg };
    opcode.args.rr.reg1 = instr.args[0].reg;
    opcode.args.rr.reg2 = instr.args[1].reg;
    return opcode;
}

opcode_t encode_opcode_xchg_reg_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_xchg_reg_reg };
    opcode.args.rr.reg1 = instr.args[0].reg;
    opcode.args.rr.reg2 = instr.args[1].reg;
    return opcode;
}

opcode_t encode_opcode_cmpxchg_reg_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_xchg_reg_reg };
    opcode.args.rr.reg1 = instr.args[0].reg;
    opcode.args.rr.reg2 = instr.args[1].reg;
    return opcode;
}

opcode_t encode_opcode_add_reg_imm(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_add_reg_imm };
    opcode.args.ri.reg1 = instr.args[0].reg;
    opcode.args.ri.imm = instr.args[1].imm16;
    return opcode;
}

opcode_t encode_opcode_sub_reg_imm(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_sub_reg_imm };
    opcode.args.ri.reg1 = instr.args[0].reg;
    opcode.args.ri.imm = instr.args[1].imm16;
    return opcode;
}

opcode_t encode_opcode_mul_reg_imm(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_mul_reg_imm };
    opcode.args.ri.reg1 = instr.args[0].reg;
    opcode.args.ri.imm = instr.args[1].imm16;
    return opcode;
}

opcode_t encode_opcode_div_reg_imm(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_div_reg_imm };
    opcode.args.ri.reg1 = instr.args[0].reg;
    opcode.args.ri.imm = instr.args[1].imm16;
    return opcode;
}

opcode_t encode_opcode_mod_reg_imm(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_mod_reg_imm };
    opcode.args.ri.reg1 = instr.args[0].reg;
    opcode.args.ri.imm = instr.args[1].imm16;
    return opcode;
}

opcode_t encode_opcode_and_reg_imm(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_and_reg_imm };
    opcode.args.ri.reg1 = instr.args[0].reg;
    opcode.args.ri.imm = instr.args[1].imm16;
    return opcode;
}

opcode_t encode_opcode_or_reg_imm(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_or_reg_imm };
    opcode.args.ri.reg1 = instr.args[0].reg;
    opcode.args.ri.imm = instr.args[1].imm16;
    return opcode;
}

opcode_t encode_opcode_xor_reg_imm(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_xor_reg_imm };
    opcode.args.ri.reg1 = instr.args[0].reg;
    opcode.args.ri.imm = instr.args[1].imm16;
    return opcode;
}

opcode_t encode_opcode_shl_reg_imm(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_shl_reg_imm };
    opcode.args.ri.reg1 = instr.args[0].reg;
    opcode.args.ri.imm = instr.args[1].imm16;
    return opcode;
}

opcode_t encode_opcode_shr_reg_imm(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_shr_reg_imm };
    opcode.args.ri.reg1 = instr.args[0].reg;
    opcode.args.ri.imm = instr.args[1].imm16;
    return opcode;
}

opcode_t encode_opcode_rol_reg_imm(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_rol_reg_imm };
    opcode.args.ri.reg1 = instr.args[0].reg;
    opcode.args.ri.imm = instr.args[1].imm16;
    return opcode;
}

opcode_t encode_opcode_ror_reg_imm(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_ror_reg_imm };
    opcode.args.ri.reg1 = instr.args[0].reg;
    opcode.args.ri.imm = instr.args[1].imm16;
    return opcode;
}

opcode_t encode_opcode_not_reg(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_not_reg };
    opcode.args.r = instr.args[0].reg;
    return opcode;
}

opcode_t encode_opcode_psh_imm(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_psh_imm };
    opcode.args.i16 = instr.args[0].imm16;
    return opcode;
}

opcode_t encode_opcode_psh_addr(section_t* sect, struct instruction instr) {
    int32_t s = symbol_offset(sect, instr.args[0].sym);
    if (s > 0x7fffff || s < -0x800000) {
        printf("Error: Symbol offset too large for psh instruction. Is: 0x%x\n", s);
        exit(1);
    }
    opcode_t opcode = (opcode_t) { .opcode = opcode_psh_addr };
    opcode.args.args_raw = s & 0xffffff;
    return opcode;
}

opcode_t encode_opcode_pause(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_pause };
    return opcode;
}

opcode_t encode_opcode_dot_addressing_override(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_dot_addressing_override };
    opcode.args.u8 = instr.args[0].imm8;
    return opcode;
}

opcode_t encode_opcode_dot_symbol(section_t* sect, struct instruction instr) {
    opcode_t opcode = (opcode_t) { .opcode = opcode_dot_symbol };
    return opcode;
}
