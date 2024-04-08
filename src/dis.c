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

static uint8_t register_override = 0;
static uint8_t cr_override = 0;
static uint8_t size = SIZE_64BIT;

char* register_to_string_ptr(uint8_t reg, uint8_t counter) {
    uint8_t high = ((register_override & (1 << counter)) != 0);
    uint8_t control = ((cr_override & (1 << counter)) != 0);
    if (reg == REG_LR) return "lr";
    if (reg == REG_SP) return "sp";
    if (reg == REG_PC) return "pc";
    char* s = strformat("%s%d", control ? "cr" : "r" , reg);
    if (high) {
        s = strformat("%sh", s);
    }
    return s;
}

char* register_to_string(uint8_t reg, uint8_t counter) {
    uint8_t high = ((register_override & (1 << counter)) != 0);
    uint8_t control = ((cr_override & (1 << counter)) != 0);
    if (control) return register_to_string_ptr(reg, counter);
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

char* dis_branch(hive_instruction_t ins, uint64_t addr) {
    char* s = strformat("b%s%s", ins.type_branch.link ? "l" : "", ins.type_branch.is_reg ? "r" : "");
    if (ins.type_branch.is_reg) {
        s = strformat("%s%s %s", s, condition_to_string(ins), register_to_string(ins.type_branch_register.r1, REG_DEST));
    } else {
        s = strformat("%s%s 0x%llx", s, condition_to_string(ins), addr + ins.type_branch.offset * sizeof(hive_instruction_t));
    }
    return s;
}

char* salu_ops_nw[16] = {
    [OP_DATA_ALU_add] = "add",
    [OP_DATA_ALU_sub] = "cmp",
    [OP_DATA_ALU_mul] = "mul",
    [OP_DATA_ALU_div] = "sdiv",
    [OP_DATA_ALU_mod] = "smod",
    [OP_DATA_ALU_and] = "tst",
    [OP_DATA_ALU_or] = "or",
    [OP_DATA_ALU_xor] = "xor",
    [OP_DATA_ALU_shl] = "shl",
    [OP_DATA_ALU_shr] = "shr",
    [OP_DATA_ALU_rol] = "rol",
    [OP_DATA_ALU_ror] = "ror",
    [OP_DATA_ALU_neg] = "neg",
    [OP_DATA_ALU_not] = "not",
    [OP_DATA_ALU_sext] = "ext",
    [OP_DATA_ALU_swe] = "swe",
};
char* salu_ops[16] = {
    [OP_DATA_ALU_add] = "add",
    [OP_DATA_ALU_sub] = "sub",
    [OP_DATA_ALU_mul] = "mul",
    [OP_DATA_ALU_div] = "sdiv",
    [OP_DATA_ALU_mod] = "smod",
    [OP_DATA_ALU_and] = "and",
    [OP_DATA_ALU_or] = "or",
    [OP_DATA_ALU_xor] = "xor",
    [OP_DATA_ALU_shl] = "shl",
    [OP_DATA_ALU_shr] = "shr",
    [OP_DATA_ALU_rol] = "rol",
    [OP_DATA_ALU_ror] = "ror",
    [OP_DATA_ALU_neg] = "neg",
    [OP_DATA_ALU_not] = "not",
    [OP_DATA_ALU_sext] = "ext",
    [OP_DATA_ALU_swe] = "swe",
};
char* alu_ops_nw[16] = {
    [OP_DATA_ALU_add] = "add",
    [OP_DATA_ALU_sub] = "cmp",
    [OP_DATA_ALU_mul] = "mul",
    [OP_DATA_ALU_div] = "div",
    [OP_DATA_ALU_mod] = "mod",
    [OP_DATA_ALU_and] = "tst",
    [OP_DATA_ALU_or] = "or",
    [OP_DATA_ALU_xor] = "xor",
    [OP_DATA_ALU_shl] = "shl",
    [OP_DATA_ALU_shr] = "shr",
    [OP_DATA_ALU_rol] = "rol",
    [OP_DATA_ALU_ror] = "ror",
    [OP_DATA_ALU_neg] = "neg",
    [OP_DATA_ALU_not] = "not",
    [OP_DATA_ALU_sext] = "ext",
    [OP_DATA_ALU_swe] = "swe",
};
char* alu_ops[16] = {
    [OP_DATA_ALU_add] = "add",
    [OP_DATA_ALU_sub] = "sub",
    [OP_DATA_ALU_mul] = "mul",
    [OP_DATA_ALU_div] = "div",
    [OP_DATA_ALU_mod] = "mod",
    [OP_DATA_ALU_and] = "and",
    [OP_DATA_ALU_or] = "or",
    [OP_DATA_ALU_xor] = "xor",
    [OP_DATA_ALU_shl] = "shl",
    [OP_DATA_ALU_shr] = "shr",
    [OP_DATA_ALU_rol] = "rol",
    [OP_DATA_ALU_ror] = "ror",
    [OP_DATA_ALU_neg] = "neg",
    [OP_DATA_ALU_not] = "not",
    [OP_DATA_ALU_sext] = "ext",
    [OP_DATA_ALU_swe] = "swe",
};

char* dis_data_alu(hive_instruction_t ins, uint64_t addr) {
    char* s = NULL;
    if (ins.type_data_alui.op == OP_DATA_ALU_sext) {
        char sizes[] = {
            [SIZE_8BIT] = 'b',
            [SIZE_16BIT] = 'w',
            [SIZE_32BIT] = 'd',
            [SIZE_64BIT] = 'q',
        };
        return strformat("ext%c%c%s %s, %s", sizes[ins.type_data_sext.from], sizes[ins.type_data_sext.to], condition_to_string(ins), register_to_string(ins.type_data_sext.r1, REG_DEST), register_to_string(ins.type_data_sext.r2, REG_SRC1));
    }
    if (ins.type_data.data_op == SUBOP_DATA_ALU_I && ins.type_data_alui.op == OP_DATA_ALU_shl && ins.type_data_alui.imm == 0) {
        if (ins.type_data_alui.r1 == REG_PC && ins.type_data_alui.r2 == REG_LR) {
            return strformat("ret%s", condition_to_string(ins));
        }
        return strformat("mov%s %s, %s", condition_to_string(ins), register_to_string(ins.type_data_alui.r1, REG_DEST), register_to_string(ins.type_data_alui.r2, REG_SRC1));
    }
    if (ins.type_data_alui.salu) {
        if (ins.type_data_alui.no_writeback) {
            s = strformat("%s%s %s,", salu_ops_nw[ins.type_data_alui.op], condition_to_string(ins), register_to_string(ins.type_data_alui.r2, REG_SRC1));
        } else {
            s = strformat("%s%s %s, %s,", salu_ops[ins.type_data_alui.op], condition_to_string(ins), register_to_string(ins.type_data_alui.r1, REG_DEST), register_to_string(ins.type_data_alui.r2, REG_SRC1));
        }
    } else {
        if (ins.type_data_alui.no_writeback) {
            s = strformat("%s%s %s,", alu_ops_nw[ins.type_data_alui.op], condition_to_string(ins), register_to_string(ins.type_data_alui.r2, REG_SRC1));
        } else {
            s = strformat("%s%s %s, %s,", alu_ops[ins.type_data_alui.op], condition_to_string(ins), register_to_string(ins.type_data_alui.r1, REG_DEST), register_to_string(ins.type_data_alui.r2, REG_SRC1));
        }
    }
    if (ins.type_data.data_op == SUBOP_DATA_ALU_I) {
        s = strformat("%s %d", s, ins.type_data_alui.imm);
    } else {
        s = strformat("%s %s", s, register_to_string(ins.type_data_alur.r3, REG_SRC2));
    }
    return s;
}

char* fpu_ops[] = {
    [OP_DATA_FLOAT_add] = "add",
    [OP_DATA_FLOAT_sub] = "sub",
    [OP_DATA_FLOAT_mul] = "mul",
    [OP_DATA_FLOAT_div] = "div",
    [OP_DATA_FLOAT_mod] = "mod",
    [OP_DATA_FLOAT_f2i] = "f2i",
    [OP_DATA_FLOAT_sin] = "sin",
    [OP_DATA_FLOAT_sqrt] = "sqrt",
};
char* fpu_ops_i[] = {
    [OP_DATA_FLOAT_add] = "addi",
    [OP_DATA_FLOAT_sub] = "subi",
    [OP_DATA_FLOAT_mul] = "muli",
    [OP_DATA_FLOAT_div] = "divi",
    [OP_DATA_FLOAT_mod] = "modi",
    [OP_DATA_FLOAT_f2i] = "i2f",
    [OP_DATA_FLOAT_sin] = "sin",
    [OP_DATA_FLOAT_sqrt] = "sqrt",
};

char* dis_data_fpu(hive_instruction_t ins, uint64_t addr) {
    char* s = NULL;
    char** ops = ins.type_data_fpu.use_int_arg2 ? fpu_ops_i : fpu_ops;
    switch (ins.type_data_fpu.op) {
        case OP_DATA_FLOAT_add:  case_fallthrough;
        case OP_DATA_FLOAT_sub:  case_fallthrough;
        case OP_DATA_FLOAT_mul:  case_fallthrough;
        case OP_DATA_FLOAT_div:  case_fallthrough;
        case OP_DATA_FLOAT_mod:  s = strformat("%s%s %s, %s, %s", ops[ins.type_data_fpu.op], condition_to_string(ins), register_to_string(ins.type_data_fpu.r1, REG_DEST), register_to_string(ins.type_data_fpu.r2, REG_SRC1), register_to_string(ins.type_data_fpu.r3, REG_SRC2)); break;
        case OP_DATA_FLOAT_f2i:  case_fallthrough;
        case OP_DATA_FLOAT_sin:  case_fallthrough;
        case OP_DATA_FLOAT_sqrt: s = strformat("%s%s %s, %s", ops[ins.type_data_fpu.op], condition_to_string(ins), register_to_string(ins.type_data_fpu.r1, REG_DEST), register_to_string(ins.type_data_fpu.r2, REG_SRC1)); break;
    }
    return s;
}

char* dis_data_vpu(hive_instruction_t ins, uint64_t addr) {
    uint8_t modes[] = {
        [0] = 'o',
        [1] = 'b',
        [2] = 'w',
        [3] = 'd',
        [4] = 'q',
        [5] = 'l',
        [6] = 's',
        [7] = 'f',
    };
    uint8_t max_slots[] = {
        [0] = 1,
        [1] = 32,
        [2] = 16,
        [3] = 8,
        [4] = 4,
        [5] = 2,
        [6] = 8,
        [7] = 4,
    };
    if (ins.type_data_vpu.op == OP_DATA_VPU_ldr || ins.type_data_vpu.op == OP_DATA_VPU_str) {
        char* s = NULL;
        if (ins.type_data_vpu_ls_imm.update_ptr && ins.type_data_vpu_ls_imm.r1 == REG_SP) {
            if (ins.type_data_vpu_ls_imm.op == OP_DATA_VPU_str && ins.type_data_vpu_ls_imm.imm == -32) {
                return strformat("psh%s v%d", condition_to_string(ins), ins.type_data_vpu_ls_imm.v1);
            } else if (ins.type_data_vpu_ls_imm.op != OP_DATA_VPU_str && ins.type_data_vpu_ls_imm.imm == 32) {
                return strformat("pp%s v%d", condition_to_string(ins), ins.type_data_vpu_ls_imm.v1);
            }
        }
        if (ins.type_data_vpu.op == OP_DATA_VPU_ldr) {
            s = strformat("vldr");
        } else {
            s = strformat("vstr");
        }
        s = strformat("%s v%d, [%s", s, ins.type_data_vpu_ls.v1, register_to_string(ins.type_data_vpu_ls.r1, REG_DEST));
        if (ins.type_data_vpu_ls.use_imm) {
            if (ins.type_data_vpu_ls_imm.imm) {
                s = strformat("%s, %d", s, ins.type_data_vpu_ls_imm.imm);
            }
        } else {
            s = strformat("%s, %s", s, register_to_string(ins.type_data_vpu_ls.r2, REG_SRC1));
        }
        s = strformat("%s]", s);
        if (ins.type_data_vpu_ls.update_ptr) {
            s = strformat("%s!", s);
        }
        return s;
    }
    char* s = strformat("v%c", modes[ins.type_data_vpu.mode]);
    char* opc[] = {
        [OP_DATA_VPU_add] = "add",
        [OP_DATA_VPU_sub] = "sub",
        [OP_DATA_VPU_mul] = "mul",
        [OP_DATA_VPU_div] = "div",
        [OP_DATA_VPU_addsub] = "addsub",
        [OP_DATA_VPU_madd] = "madd",
        [OP_DATA_VPU_mov] = "mov",
        [OP_DATA_VPU_mov_vec] = "mov",
        [OP_DATA_VPU_conv] = "conv",
        [OP_DATA_VPU_len] = "len",
    };
    switch (ins.type_data_vpu.op) {
        case OP_DATA_VPU_add: case_fallthrough;
        case OP_DATA_VPU_sub: case_fallthrough;
        case OP_DATA_VPU_mul: case_fallthrough;
        case OP_DATA_VPU_div: case_fallthrough;
        case OP_DATA_VPU_addsub: case_fallthrough;
        case OP_DATA_VPU_madd: return strformat("%s%s v%d, v%d, v%d", s, opc[ins.type_data_vpu.op], ins.type_data_vpu.v1, ins.type_data_vpu.v2, ins.type_data_vpu.v3);
        case OP_DATA_VPU_mov: return strformat("%s v%d, %s, %d", s, ins.type_data_vpu_mov.v1, register_to_string(ins.type_data_vpu_mov.r2, REG_SRC1), (ins.type_data_vpu_mov.slot_hi << 3) | ins.type_data_vpu_mov.slot_lo);
        case OP_DATA_VPU_mov_vec: return strformat("%s v%d, v%d", s, ins.type_data_vpu.v1, ins.type_data_vpu.v2);
        case OP_DATA_VPU_conv: return strformat("%s%c v%d, v%d", s, modes[ins.type_data_vpu_conv.target_mode], ins.type_data_vpu_conv.v1, ins.type_data_vpu_conv.v2);
        case OP_DATA_VPU_len:  return strformat("%s %s, v%d", s, register_to_string(ins.type_data_vpu_len.r1, REG_DEST), ins.type_data_vpu_len.v1);
    }
    return NULL;
}

char* dis_data_bit(hive_instruction_t ins, uint64_t addr) {
    char* bit_len = strformat("%d, %d", ins.type_data_bit.start, (ins.type_data_bit.count_hi << 1 | ins.type_data_bit.count_lo) + 1);
    char* s = ins.type_data_bit.extend ? "s" : "u";
    if (ins.type_data_bit.is_dep) {
        s = strformat("%sbdp%s %s, %s, %s", s, condition_to_string(ins), register_to_string(ins.type_data_bit.r1, REG_DEST), register_to_string(ins.type_data_bit.r2, REG_SRC1), bit_len);
    } else {
        s = strformat("%sbxt%s %s, %s, %s", s, condition_to_string(ins), register_to_string(ins.type_data_bit.r1, REG_DEST), register_to_string(ins.type_data_bit.r2, REG_SRC1), bit_len);
    }
    return s;
}

char* dis_data_ls(hive_instruction_t ins, uint64_t addr) {
    char* s = ins.type_data_ls_reg.is_store ? "str" : "ldr";
    char* last_arg = NULL;
    if (ins.type_data_ls_reg.data_op == SUBOP_DATA_LS_FAR) {
        last_arg = strformat("%d", ins.type_data_ls_far.imm << (ins.type_data_ls_far.shift + 1));
    } else if (ins.type_data_ls_reg.use_immediate) {
        if (ins.type_data_ls_imm.update_ptr && ins.type_data_ls_imm.r2 == REG_SP) {
            if (ins.type_data_ls_imm.is_store && ins.type_data_ls_imm.imm == -16) {
                return strformat("psh%s %s", condition_to_string(ins), register_to_string(ins.type_data_ls_imm.r1, REG_DEST));
            } else if (!ins.type_data_ls_imm.is_store && ins.type_data_ls_imm.imm == 16) {
                return strformat("pp%s %s", condition_to_string(ins), register_to_string(ins.type_data_ls_imm.r1, REG_DEST));
            }
        }
        last_arg = strformat("%d", ins.type_data_ls_imm.imm);
    } else {
        last_arg = strformat("%s", register_to_string_ptr(ins.type_data_ls_reg.r3, REG_SRC2));
    }

    s = strformat("%s%s %s, [%s, %s]", s, condition_to_string(ins), register_to_string(ins.type_data_ls_imm.r1, REG_DEST), register_to_string_ptr(ins.type_data_ls_imm.r2, REG_SRC1), last_arg);

    if (ins.type_data_ls_imm.update_ptr) {
        s = strformat("%s!", s);
    }
    return s;
}

char* dis_data(hive_instruction_t ins, uint64_t addr) {
    char* s = NULL;
    switch (ins.type_data.data_op) {
        case SUBOP_DATA_ALU_I:  case_fallthrough;
        case SUBOP_DATA_ALU_R:  case_fallthrough;
        case SUBOP_DATA_SALU_R: case_fallthrough;
        case SUBOP_DATA_SALU_I: s = dis_data_alu(ins, addr); break;
        case SUBOP_DATA_BDEP:   case_fallthrough;
        case SUBOP_DATA_BEXT:   s = dis_data_bit(ins, addr); break;
        case SUBOP_DATA_LS:     case_fallthrough;
        case SUBOP_DATA_LS_FAR: s = dis_data_ls(ins, addr); break;
        case SUBOP_DATA_FPU:    s = dis_data_fpu(ins, addr); break;
        case SUBOP_DATA_VPU:    s = dis_data_vpu(ins, addr); break;
        case SUBOP_DATA_CSWAP:  s = strformat("cswp%s %s, %s, %s, %s", condition_to_string(ins), register_to_string(ins.type_data_cswap.r1, REG_DEST), register_to_string(ins.type_data_cswap.r2, REG_SRC1), register_to_string(ins.type_data_cswap.r3, REG_SRC2), condition_to_string0(ins.type_data_cswap.cond)); break;
        case SUBOP_DATA_XCHG:   s = strformat("xchg%s %s, %s", condition_to_string(ins), register_to_string(ins.type_data_xchg.r1, REG_DEST), register_to_string(ins.type_data_xchg.r2, REG_SRC1)); break;
    }
    return s;
}

char* dis_load_movzk(hive_instruction_t ins, uint64_t addr) {
    char* s = ins.type_load_mov.no_zero ? "movk" : "movz";
    s = strformat("%s%s %s, 0x%x", s, condition_to_string(ins), register_to_string(ins.type_load_mov.r1, REG_DEST), ins.type_load_mov.imm);
    if (ins.type_load_mov.shift) {
        s = strformat("%s, shl %d", s, ins.type_load_mov.shift * 16);
    }
    return s;
}

char* dis_load_ls_off(hive_instruction_t ins, uint64_t addr) {
    char* s = NULL;
    if (ins.type_load_ls_off.is_store) {
        s = strformat("str%s", condition_to_string(ins));
    } else {
        s = strformat("ldr%s", condition_to_string(ins));
    }
    s = strformat("%s %s, [0x%llx]", s, register_to_string(ins.type_load_ls_off.r1, REG_DEST), addr + ins.type_load_ls_off.imm * sizeof(hive_instruction_t));
    return s;
}

char* dis_load(hive_instruction_t ins, uint64_t addr) {
    switch (ins.type_load.op) {
        case OP_LOAD_lea:    return strformat("lea%s %s, 0x%llx", condition_to_string(ins), register_to_string(ins.type_load_signed.r1, REG_DEST), addr + ins.type_load_signed.imm * sizeof(hive_instruction_t));
        case OP_LOAD_movzk:  return dis_load_movzk(ins, addr);
        case OP_LOAD_svc:    return strformat("svc%s", condition_to_string(ins));
        case OP_LOAD_ls_off: return dis_load_ls_off(ins, addr);
    }
    return NULL;
}

char* dis_other_priv(hive_instruction_t ins, uint64_t addr) {
    switch (ins.type_other_priv.priv_op) {
        case SUBOP_OTHER_cpuid: return strformat("cpuid%s", condition_to_string(ins));
        case SUBOP_OTHER_hret:  return strformat("hret%s", condition_to_string(ins));
        case SUBOP_OTHER_sret:  return strformat("sret%s", condition_to_string(ins));
        case SUBOP_OTHER_iret:  return strformat("iret%s", condition_to_string(ins));
    }
    return NULL;
}

char* dis_other(hive_instruction_t ins, uint64_t addr) {
    switch (ins.type_other.op) {
        case OP_OTHER_priv_op:  return dis_other_priv(ins, addr);
        case OP_OTHER_zeroupper:return strformat("zeroupper%s %s", condition_to_string(ins), register_to_string(ins.type_other_zeroupper.r1, REG_DEST));
    }
    return NULL;
}

char* dis(hive_instruction_t** insp, uint64_t addr) {
    char* instr = NULL;
    hive_instruction_t ins = *((*insp)++);
    if (ins.generic.condition == COND_NEVER) {
        instr = strformat("nop");
    } else {
        if (ins.generic.type == MODE_OTHER && ins.type_other_prefix.op == OP_OTHER_prefix) {
            register_override = ins.type_other_prefix.reg_override;
            cr_override = ins.type_other_prefix.references_cr;
            size = ins.type_other_prefix.size;
            char* s = dis(insp, *(uint64_t*) insp);
            size = SIZE_64BIT;
            register_override = 0;
            cr_override = 0;
            return s;
        }
        switch (ins.generic.type) {
            case MODE_BRANCH:   instr = dis_branch(ins, addr); break;
            case MODE_DATA:     instr = dis_data(ins, addr); break;
            case MODE_LOAD:     instr = dis_load(ins, addr); break;
            case MODE_OTHER:    instr = dis_other(ins, addr); break;
        }
    }
    return instr;
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
    for (hive_instruction_t* p = (hive_instruction_t*) code_sect.data; p < (hive_instruction_t*) (code_sect.data + code_sect.len);) {
        hive_instruction_t* ins = p;
        char* s = dis(&p, (uint64_t) ins);
        char* symbol_here = get_symbol_at(syms, (uint64_t) ins);
        if (symbol_here) {
            printf("%s:\n", symbol_here);
        }
        if (s == NULL) {
            printf("    .dword 0x%08x\n", *(uint32_t*) ins);
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
    }
}
