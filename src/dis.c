#include "new_ops.h"
#include "opcode.h"

char* strformat(const char*, ...);

char* condition_to_string(hive_instruction_t ins) {
    switch (ins.generic.condition) {
        case COND_EQ: return ".eq";
        case COND_NE: return ".ne";
        case COND_LE: return ".le";
        case COND_GT: return ".gt";
        case COND_LT: return ".lt";
        case COND_GE: return ".ge";
        default:      return "";
    }
}

char* dis_branch(hive_instruction_t ins, uint64_t addr) {
    char* s = strformat("b%s%s", ins.type_branch.link ? "l" : "", ins.type_branch.is_reg ? "r" : "");
    if (ins.type_branch.is_reg) {
        s = strformat("%s%s r%d", s, condition_to_string(ins), ins.type_branch_register.r1);
    } else {
        s = strformat("%s%s 0x%llx", s, condition_to_string(ins), addr + ins.type_branch.offset * sizeof(hive_instruction_t));
    }
    return s;
}

char* alu_ops_nw[16] = {
    [OP_DATA_ALU_sub] = "cmp",
    [OP_DATA_ALU_and] = "tst",
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
    [OP_DATA_ALU_asr] = "asr",
    [OP_DATA_ALU_swe] = "swe",
};

char* dis_data_alu(hive_instruction_t ins, uint64_t addr) {
    char* s = NULL;
    if (ins.type_data_alui.sub_op == SUBOP_DATA_ALU_I && ins.type_data_alui.op == OP_DATA_ALU_shl && ins.type_data_alui.imm == 0) {
        if (ins.type_data_alui.r1 == REG_PC && ins.type_data_alui.r2 == REG_LR) {
            return strformat("ret%s", condition_to_string(ins));
        }
        return strformat("mov%s r%d, r%d", condition_to_string(ins), ins.type_data_alui.r1, ins.type_data_alui.r2);
    }
    if (ins.type_data_alui.no_writeback) {
        s = strformat("%s%s r%d, r%d, ", alu_ops_nw[ins.type_data_alui.op], condition_to_string(ins), ins.type_data_alui.r1, ins.type_data_alui.r2);
    } else {
        s = strformat("%s%s r%d, r%d, ", alu_ops[ins.type_data_alui.op], condition_to_string(ins), ins.type_data_alui.r1, ins.type_data_alui.r2);
    }
    if (ins.type_data_alui.sub_op == SUBOP_DATA_ALU_I) {
        s = strformat("%s%s %d", s, condition_to_string(ins), ins.type_data_alui.imm);
    } else {
        s = strformat("%s%s r%d", s, condition_to_string(ins), ins.type_data_alur.r3);
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
        case OP_DATA_FLOAT_mod:  s = strformat("%s%s r%d, r%d, r%d", ops[ins.type_data_fpu.op], condition_to_string(ins), ins.type_data_fpu.r1, ins.type_data_fpu.r2, ins.type_data_fpu.r3); break;
        case OP_DATA_FLOAT_f2i:  case_fallthrough;
        case OP_DATA_FLOAT_sin:  case_fallthrough;
        case OP_DATA_FLOAT_sqrt: s = strformat("%s%s r%d, r%d", ops[ins.type_data_fpu.op], condition_to_string(ins), ins.type_data_fpu.r1, ins.type_data_fpu.r2); break;
    }
    return s;
}

char* dis_data_vpu(hive_instruction_t ins, uint64_t addr) {
    return NULL;
}

uint8_t decode_count(hive_instruction_t ins);

char* dis_data_bit(hive_instruction_t ins, uint64_t addr) {
    char* bit_len = NULL;
    if (ins.type_data_bit.is_reg) {
        bit_len = strformat("r%d, r%d", ins.type_data_bitr.start_reg, ins.type_data_bitr.count_reg);
    } else {
        bit_len = strformat("%d, %d", ins.type_data_bit.start, decode_count(ins));
    }
    char* s = ins.type_data_bit.extend ? "s" : "u";
    if (ins.type_data_bit.is_dep) {
        s = strformat("%sbdp%s r%d, r%d, %s", s, condition_to_string(ins), ins.type_data_bit.r1, ins.type_data_bit.r2, bit_len);
    } else {
        s = strformat("%sbxt%s r%d, r%d, %s", s, condition_to_string(ins), ins.type_data_bit.r1, ins.type_data_bit.r2, bit_len);
    }
    return s;
}

char* dis_data_ls(hive_instruction_t ins, uint64_t addr) {
    char* s = ins.type_data_ls_reg.is_store ? "str" : "ldr";
    char* last_arg = NULL;
    if (ins.type_data_ls_reg.use_immediate) {
        last_arg = strformat("%d", ins.type_data_ls_imm.imm);
    } else {
        last_arg = strformat("r%d", ins.type_data_ls_reg.r3);
    }

    char size[] = {
        'b',
        'w',
        'd',
        'q',
    };

    s = strformat("%s%c%s r%d, [r%d, %s]", s, size[ins.type_data_ls_imm.size], condition_to_string(ins), ins.type_data_ls_imm.r1, ins.type_data_ls_imm.r2, last_arg);

    if (ins.type_data_ls_imm.update_ptr) {
        s = strformat("%s!", s);
    }
    return s;
}

char* dis_data(hive_instruction_t ins, uint64_t addr) {
    char* s = NULL;
    switch (ins.type_data.sub_op) {
        case SUBOP_DATA_ALU_I:  case_fallthrough;
        case SUBOP_DATA_ALU_R:  s = dis_data_alu(ins, addr); break;
        case SUBOP_DATA_FPU:    s = dis_data_fpu(ins, addr); break;
        case SUBOP_DATA_VPU:    s = dis_data_vpu(ins, addr); break;
        case SUBOP_DATA_BDEP:   case_fallthrough;
        case SUBOP_DATA_BDEPR:  case_fallthrough;
        case SUBOP_DATA_BEXT:   case_fallthrough;
        case SUBOP_DATA_BEXTR:  s = dis_data_bit(ins, addr); break;
        case SUBOP_DATA_LS:     s = dis_data_ls(ins, addr); break;
    }
    return s;
}

char* dis_load_movzk(hive_instruction_t ins, uint64_t addr) {
    char* s = ins.type_load_mov.no_zero ? "movk" : "movz";
    s = strformat("%s%s r%d, 0x%x", s, condition_to_string(ins), ins.type_load_mov.r1, ins.type_load_mov.imm);
    if (ins.type_load_mov.shift) {
        s = strformat("%s, shl %d", s, ins.type_load_mov.shift * 16);
    }
    return s;
}

char* dis_load(hive_instruction_t ins, uint64_t addr) {
    switch (ins.type_load.op) {
        case OP_LOAD_lea: return strformat("lea%s r%d, 0x%llx", condition_to_string(ins), ins.type_load_signed.r1, addr + ins.type_load_signed.imm * sizeof(hive_instruction_t));
        case OP_LOAD_movzk: return dis_load_movzk(ins, addr);
        case OP_LOAD_svc: return strformat("svc%s", condition_to_string(ins));
    }
    return NULL;
}

char* dis(hive_instruction_t ins, uint64_t addr) {
    char* instr = NULL;
    if (ins.generic.condition == COND_NEVER) return strformat("nop");
    switch (ins.generic.type) {
        case MODE_BRANCH:   instr = dis_branch(ins, addr); break;
        case MODE_DATA:     instr = dis_data(ins, addr); break;
        case MODE_LOAD:     instr = dis_load(ins, addr); break;
    }
    return instr;
}

char* get_symbol_at(Symbol_Offsets syms, uint64_t addr) {
    for (size_t i = 0; i < syms.count; i++) {
        if (syms.items[i].offset == addr) {
            return syms.items[i].name;
        }
    }
    return NULL;
}

char* get_relocation_at(Symbol_Offsets relocations, uint64_t addr) {
    for (size_t i = 0; i < relocations.count; i++) {
        if (relocations.items[i].offset == addr) {
            return strformat("stub for %s", relocations.items[i].name);
        }
    }
    return NULL;
}

void disassemble(Section code_sect, Symbol_Offsets syms, Symbol_Offsets relocations) {
    for (hive_instruction_t* p = (hive_instruction_t*) code_sect.data; p < (hive_instruction_t*) (code_sect.data + code_sect.len); p++) {
        hive_instruction_t ins = *p;
        char* s = dis(ins, (uint64_t) p);
        char* symbol_here = get_symbol_at(syms, (uint64_t) p);
        if (symbol_here) {
            printf("%s:\n", symbol_here);
        }
        if (s == NULL) {
            printf("    .dword 0x%08x\n", *(uint32_t*) &ins);
        } else {
            printf("    %s", s);
            uint64_t address = (uint64_t) p;
            char* sym = NULL;
            if (ins.generic.type == MODE_BRANCH && ins.type_branch.is_reg == 0) {
                address += (ins.type_branch.offset << 2);
                if (address == (uint64_t) p) {
                    sym = get_relocation_at(relocations, (uint64_t) p - (uint64_t) code_sect.data);
                }
                if (sym == NULL) {
                    sym = get_symbol_at(syms, address);
                }
            } else if (ins.generic.type == MODE_LOAD) {
                if (ins.type_load_signed.op == OP_LOAD_lea) {
                    address += (ins.type_load_signed.imm << 2);
                    if (address == (uint64_t) p) {
                        sym = get_relocation_at(relocations, (uint64_t) p - (uint64_t) code_sect.data);
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
