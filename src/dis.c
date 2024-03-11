#include "new_ops.h"
#include "opcode.h"

char* strformat(const char*, ...);

char* str_branch_type(hive_instruction_t ins, uint64_t addr) {
    switch (ins.branch.op) {
        case OP_BRANCH_b: return strformat("b%s 0x%llx", (ins.branch.link ? "l" : ""), addr + ins.branch.offset * 4);
        case OP_BRANCH_blt: return strformat("b%slt 0x%llx", (ins.branch.link ? "l" : ""), addr + ins.branch.offset * 4);
        case OP_BRANCH_bgt: return strformat("b%sgt 0x%llx", (ins.branch.link ? "l" : ""), addr + ins.branch.offset * 4);
        case OP_BRANCH_bge: return strformat("b%sge 0x%llx", (ins.branch.link ? "l" : ""), addr + ins.branch.offset * 4);
        case OP_BRANCH_ble: return strformat("b%sle 0x%llx", (ins.branch.link ? "l" : ""), addr + ins.branch.offset * 4);
        case OP_BRANCH_beq: return strformat("b%seq 0x%llx", (ins.branch.link ? "l" : ""), addr + ins.branch.offset * 4);
        case OP_BRANCH_bne: return strformat("b%sne 0x%llx", (ins.branch.link ? "l" : ""), addr + ins.branch.offset * 4);
        case OP_BRANCH_cb: if (ins.comp_branch.zero) {
            return strformat("cb%sz r%d, 0x%llx", (ins.comp_branch.link ? "l" : ""), ins.comp_branch.r1, addr + ins.comp_branch.offset * 4);
        } else {
            return strformat("cb%snz r%d, 0x%llx", (ins.comp_branch.link ? "l" : ""), ins.comp_branch.r1, addr + ins.comp_branch.offset * 4);
        }
    }
    return NULL;
}
char* str_ai_type(hive_instruction_t ins, uint64_t addr) {
    switch (ins.rri.op) {
        case OP_AI_sub: return strformat("sub r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_AI_add: return strformat("add r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_AI_mul: return strformat("mul r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_AI_div: return strformat("div r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_AI_mod: return strformat("mod r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_AI_and: return strformat("and r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_AI_or: return strformat("or r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_AI_xor: return strformat("xor r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_AI_shl: {
            if (ins.rri.r1 == ins.rri.r2 && ins.rri.imm == 0) {
                return strformat("nop");
            } else if (ins.rri.r1 == REG_PC && ins.rri.r2 == REG_LR && ins.rri.imm == 0) {
                return strformat("ret");
            } else if (ins.rri.imm == 0) {
                return strformat("mov r%d, r%d", ins.rri.r1, ins.rri.r2);
            } else {
                return strformat("shl r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
            }
        }
        case OP_AI_shr: {
            if (ins.rri.r1 == ins.rri.r2 && ins.rri.imm == 0) {
                return strformat("nop");
            } else if (ins.rri.r1 == REG_PC && ins.rri.r2 == REG_LR && ins.rri.imm == 0) {
                return strformat("ret");
            } else if (ins.rri.imm == 0) {
                return strformat("mov r%d, r%d", ins.rri.r1, ins.rri.r2);
            } else {
                return strformat("shr r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
            }
        }
        case OP_AI_rol: return strformat("rol r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_AI_ror: return strformat("ror r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_AI_neg: return strformat("neg r%d, r%d", ins.rri.r1, ins.rri.r2);
        case OP_AI_not: return strformat("not r%d, r%d", ins.rri.r1, ins.rri.r2);
        case OP_AI_asr: return strformat("asr r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_AI_swe: return strformat("swe r%d, r%d", ins.rri.r1, ins.rri.r2);
    }
    return NULL;
}
char* str_rri_type(hive_instruction_t ins, uint64_t addr) {
    switch (ins.rri.op) {
        case OP_RRI_ldr: {
            char* s = NULL;
            switch (ins.rri_ls.size) {
                case 0: s = strformat("ldr r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm); break;
                case 1: s = strformat("ldrd r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm); break;
                case 2: s = strformat("ldrw r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm); break;
                case 3: s = strformat("ldrb r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm); break;
            }
            if (ins.rri_ls.update_ptr) {
                s = strformat("%s!", s);
            }
            return s;
        }
        case OP_RRI_str: {
            char* s = NULL;
            switch (ins.rri_ls.size) {
                case 0: s = strformat("str r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm); break;
                case 1: s = strformat("strd r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm); break;
                case 2: s = strformat("strw r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm); break;
                case 3: s = strformat("strb r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm); break;
            }
            if (ins.rri_ls.update_ptr) {
                s = strformat("%s!", s);
            }
            return s;
        }
        case OP_RRI_bext: {
            if (ins.rri_bit.sign_extend) {
                return strformat("sbxt r%d, r%d, %d, %d", ins.rri_bit.r1, ins.rri_bit.r2, ins.rri_bit.lowest, ins.rri_bit.nbits);
            } else {
                return strformat("ubxt r%d, r%d, %d, %d", ins.rri_bit.r1, ins.rri_bit.r2, ins.rri_bit.lowest, ins.rri_bit.nbits);
            }
        }
        case OP_RRI_bdep: {
            if (ins.rri_bit.sign_extend) {
                return strformat("sbdp r%d, r%d, %d, %d", ins.rri_bit.r1, ins.rri_bit.r2, ins.rri_bit.lowest, ins.rri_bit.nbits);
            } else {
                return strformat("ubdp r%d, r%d, %d, %d", ins.rri_bit.r1, ins.rri_bit.r2, ins.rri_bit.lowest, ins.rri_bit.nbits);
            }
        }
    }
    return NULL;
}
char* str_fpu_type(hive_instruction_t ins, uint64_t addr) {
    switch (ins.float_rrr.op) {
        case OP_FLOAT_add: return strformat("fadd r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_addi: return strformat("faddi r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_sub: return strformat("fsub r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_subi: return strformat("fsubi r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_mul: return strformat("fmul r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_muli: return strformat("fmuli r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_div: return strformat("fdiv r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_divi: return strformat("fdivi r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_mod: return strformat("fmod r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_modi: return strformat("fmodi r%d, r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2, ins.float_rrr.r3);
        case OP_FLOAT_i2f: return strformat("i2f r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2);
        case OP_FLOAT_f2i: return strformat("f2i r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2);
        case OP_FLOAT_sin: return strformat("fsin r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2);
        case OP_FLOAT_sqrt: return strformat("fsqrt r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2);
        case OP_FLOAT_cmp: return strformat("fcmp r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2);
        case OP_FLOAT_cmpi: return strformat("fcmpi r%d, r%d", ins.float_rrr.r1, ins.float_rrr.r2);
    }
    return NULL;
}
char* str_vpu_type(hive_instruction_t ins, uint64_t addr) {
    char modes[] = {
        [0] = 'o',
        [1] = 'b',
        [2] = 'w',
        [3] = 'd',
        [4] = 'q',
        [5] = 'l',
        [6] = 's',
        [7] = 'f',
    };
    char* s = strformat("v%c", modes[ins.vpu.mode]);
    switch (ins.vpu.op) {
        case OP_VPU_add: return strformat("%sadd v%d, v%d, v%d", s, ins.vpu_arith.v1, ins.vpu_arith.v2, ins.vpu_arith.v3);
        case OP_VPU_sub: return strformat("%ssub v%d, v%d, v%d", s, ins.vpu_arith.v1, ins.vpu_arith.v2, ins.vpu_arith.v3);
        case OP_VPU_mul: return strformat("%smul v%d, v%d, v%d", s, ins.vpu_arith.v1, ins.vpu_arith.v2, ins.vpu_arith.v3);
        case OP_VPU_div: return strformat("%sdiv v%d, v%d, v%d", s, ins.vpu_arith.v1, ins.vpu_arith.v2, ins.vpu_arith.v3);
        case OP_VPU_addsub: return strformat("%saddsub v%d, v%d, v%d", s, ins.vpu_arith.v1, ins.vpu_arith.v2, ins.vpu_arith.v3);
        case OP_VPU_madd: return strformat("%smadd v%d, v%d, v%d", s, ins.vpu_arith.v1, ins.vpu_arith.v2, ins.vpu_arith.v3);
        case OP_VPU_mov: return strformat("%smov v%d, r%d, %d", s, ins.vpu_mov.v1, ins.vpu_mov.r2, ins.vpu_mov.slot);
        case OP_VPU_mov_vec: return strformat("%s v%d, v%d", s, ins.vpu_mov_vec.v1, ins.vpu_mov_vec.v2);
        case OP_VPU_conv: return strformat("%sconv%c v%d, v%d", s, modes[ins.vpu_conv.target_mode], ins.vpu_conv.v1, ins.vpu_conv.v2);
        case OP_VPU_len: return strformat("%slen r%d, v%d", s, ins.vpu_len.r1, ins.vpu_len.v1);
    }
    return NULL;
}
char* str_ar_type(hive_instruction_t ins, uint64_t addr) {
    switch (ins.rrr.op) {
        case OP_AR_add: return strformat("add r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_AR_sub: return strformat("sub r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_AR_mul: return strformat("mul r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_AR_div: return strformat("div r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_AR_mod: return strformat("mod r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_AR_and: return strformat("and r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_AR_or: return strformat("or r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_AR_xor: return strformat("xor r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_AR_shl: return strformat("shl r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_AR_shr: return strformat("shr r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_AR_rol: return strformat("rol r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_AR_ror: return strformat("ror r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_AR_neg: return strformat("neg r%d, r%d", ins.rrr.r1, ins.rrr.r2);
        case OP_AR_not: return strformat("not r%d, r%d", ins.rrr.r1, ins.rrr.r2);
        case OP_AR_asr: return strformat("asr r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_AR_swe: return strformat("swe r%d, r%d", ins.rrr.r1, ins.rrr.r2);
    }
    return NULL;
}
char* str_rrr_type(hive_instruction_t ins, uint64_t addr) {
    switch (ins.rrr.op) {
        case OP_RRR_ldr: {
            char* s = NULL;
            switch (ins.rrr_ls.size) {
                case 0: s = strformat("ldr r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3); break;
                case 1: s = strformat("ldrd r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3); break;
                case 2: s = strformat("ldrw r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3); break;
                case 3: s = strformat("ldrb r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3); break;
            }
            if (ins.rrr_ls.update_ptr) {
                s = strformat("%s!", s);
            }
            return s;
        }
        case OP_RRR_str: {
            char* s = NULL;
            switch (ins.rrr_ls.size) {
                case 0: s = strformat("str r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3); break;
                case 1: s = strformat("strd r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3); break;
                case 2: s = strformat("strw r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3); break;
                case 3: s = strformat("strb r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3); break;
            }
            if (ins.rrr_ls.update_ptr) {
                s = strformat("%s!", s);
            }
            return s;
        }
        case OP_RRR_tst: return strformat("tst r%d, r%d", ins.rrr.r1, ins.rrr.r2);
        case OP_RRR_cmp: return strformat("cmp r%d, r%d", ins.rrr.r1, ins.rrr.r2);
        case OP_RRR_fpu: return str_fpu_type(ins, addr);
        case OP_RRR_vpu: return str_vpu_type(ins, addr);
    }
    return NULL;
}
char* str_br_type(hive_instruction_t ins, uint64_t addr) {
    switch (ins.ri_branch.op) {
        case OP_BR_br: return strformat("b%sr r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
        case OP_BR_brlt: return strformat("b%srlt r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
        case OP_BR_brgt: return strformat("b%srgt r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
        case OP_BR_brge: return strformat("b%srge r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
        case OP_BR_brle: return strformat("b%srle r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
        case OP_BR_breq: return strformat("b%sreq r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
        case OP_BR_brne: return strformat("b%srne r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
        case OP_BR_cbr: if (ins.ri_cbranch.zero) {
            return strformat("cb%srz r%d, r%d", (ins.ri_cbranch.link ? "l" : ""), ins.ri_cbranch.r2, ins.ri_cbranch.r1);
        } else {
            return strformat("cb%srnz r%d, r%d", (ins.ri_cbranch.link ? "l" : ""), ins.ri_cbranch.r2, ins.ri_cbranch.r1);
        }
    }
    return NULL;
}
char* str_ri_type(hive_instruction_t ins, uint64_t addr) {
    switch (ins.ri.op) {
        case OP_RI_lea: return strformat("lea r%d, 0x%llx", ins.ri_s.r1, addr + ins.ri_s.imm * 4);
        case OP_RI_movzk: if (ins.ri_mov.no_zero) {
            return strformat("movk r%d, %d, shl %d", ins.ri_mov.r1, ins.ri_mov.imm, ins.ri_mov.shift);
        } else {
            return strformat("movz r%d, %d, shl %d", ins.ri_mov.r1, ins.ri_mov.imm, ins.ri_mov.shift);
        }
        case OP_RI_svc: return strformat("svc");
        case OP_RI_tst: return strformat("tst r%d, %d", ins.ri.r1, ins.ri.imm);
        case OP_RI_cmp: return strformat("cmp r%d, %d", ins.ri.r1, ins.ri.imm);
    }
    return NULL;
}

char* dis(hive_instruction_t ins, uint64_t addr) {
    char* instr = NULL;
    switch (ins.generic.type) {
        case OP_BRANCH: instr = str_branch_type(ins, addr); break;
        case OP_AI:     instr = str_ai_type(ins, addr); break;
        case OP_RRI:    instr = str_rri_type(ins, addr); break;
        case OP_AR:     instr = str_ar_type(ins, addr); break;
        case OP_RRR:    instr = str_rrr_type(ins, addr); break;
        case OP_BR:     instr = str_br_type(ins, addr); break;
        case OP_RI:     instr = str_ri_type(ins, addr); break;
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
            if (ins.generic.type == OP_BRANCH) {
                if (ins.branch.op == OP_BRANCH_cb) {
                    address += (ins.comp_branch.offset << 2);
                } else {
                    address += (ins.branch.offset << 2);
                }
                if (address == (uint64_t) p) {
                    sym = get_relocation_at(relocations, (uint64_t) p - (uint64_t) code_sect.data);
                }
                if (sym == NULL) {
                    sym = get_symbol_at(syms, address);
                }
            } else if (ins.generic.type == OP_RI) {
                if (ins.ri.op == OP_RI_lea) {
                    address += (ins.ri_s.imm << 2);
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
