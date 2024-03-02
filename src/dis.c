#include "new_ops.h"
#include "opcode.h"

char* strformat(const char*, ...);

char* str_data_type(hive_instruction_t ins) {
    if (ins.branch.op <= OP_BRANCH_bne) {
        switch (ins.branch.op) {
            case OP_BRANCH_b: return strformat("b%s %d", (ins.branch.link ? "l" : ""), ins.branch.offset);
            case OP_BRANCH_blt: return strformat("b%slt %d", (ins.branch.link ? "l" : ""), ins.branch.offset);
            case OP_BRANCH_bgt: return strformat("b%sgt %d", (ins.branch.link ? "l" : ""), ins.branch.offset);
            case OP_BRANCH_bge: return strformat("b%sge %d", (ins.branch.link ? "l" : ""), ins.branch.offset);
            case OP_BRANCH_ble: return strformat("b%sle %d", (ins.branch.link ? "l" : ""), ins.branch.offset);
            case OP_BRANCH_beq: return strformat("b%seq %d", (ins.branch.link ? "l" : ""), ins.branch.offset);
            case OP_BRANCH_bne: return strformat("b%sne %d", (ins.branch.link ? "l" : ""), ins.branch.offset);
            case OP_BRANCH_cb: if (ins.ri_cbranch.zero) {
                return strformat("cb%sz r%d, %d", (ins.branch.link ? "l" : ""), ins.comp_branch.r1, ins.branch.offset);
            } else {
                return strformat("cb%snz r%d, %d", (ins.branch.link ? "l" : ""), ins.comp_branch.r1, ins.branch.offset);
            }
        }
    }
    return NULL;
}
char* str_rri_type(hive_instruction_t ins) {
    switch (ins.rri.op) {
        case OP_RRI_add: return strformat("add r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_sub: return strformat("sub r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_mul: return strformat("mul r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_div: return strformat("div r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_mod: return strformat("mod r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_and: return strformat("and r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_or: return strformat("or r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_xor: return strformat("xor r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_shl: {
            if (ins.rri.r1 == ins.rri.r2 && ins.rri.imm == 0) {
                return strformat("nop");
            } else if (ins.rri.r1 == 31 && ins.rri.r2 == 29 && ins.rri.imm == 0) {
                return strformat("ret");
            } else if (ins.rri.imm == 0) {
                return strformat("mov r%d, r%d", ins.rri.r1, ins.rri.r2);
            } else {
                return strformat("shl r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
            }
        }
        case OP_RRI_shr: {
            if (ins.rri.r1 == ins.rri.r2 && ins.rri.imm == 0) {
                return strformat("nop");
            } else if (ins.rri.r1 == 31 && ins.rri.r2 == 29 && ins.rri.imm == 0) {
                return strformat("ret");
            } else if (ins.rri.imm == 0) {
                return strformat("mov r%d, r%d", ins.rri.r1, ins.rri.r2);
            } else {
                return strformat("shr r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
            }
        }
        case OP_RRI_rol: return strformat("rol r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_ror: return strformat("ror r%d, r%d, %d", ins.rri.r1, ins.rri.r2, ins.rri.imm);
        case OP_RRI_ldr: {
            switch (ins.rri_ls.size) {
                case 0: return strformat("ldr r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm);
                case 1: return strformat("ldrd r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm);
                case 2: return strformat("ldrw r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm);
                case 3: return strformat("ldrb r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm);
            }
        }
        case OP_RRI_str: {
            switch (ins.rri_ls.size) {
                case 0: return strformat("str r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm);
                case 1: return strformat("strd r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm);
                case 2: return strformat("strw r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm);
                case 3: return strformat("strb r%d, [r%d, %d]", ins.rri_ls.r1, ins.rri_ls.r2, ins.rri_ls.imm);
            }
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
        case OP_RRI_ldp: {
            switch (ins.rri_rpairs.size) {
                case 0: return strformat("ldp r%d, r%d, [r%d, %d]", ins.rri_rpairs.r1, ins.rri_rpairs.r2, ins.rri_rpairs.r3, ins.rri_rpairs.imm);
                case 1: return strformat("ldpd r%d, r%d, [r%d, %d]", ins.rri_rpairs.r1, ins.rri_rpairs.r2, ins.rri_rpairs.r3, ins.rri_rpairs.imm);
                case 2: return strformat("ldpw r%d, r%d, [r%d, %d]", ins.rri_rpairs.r1, ins.rri_rpairs.r2, ins.rri_rpairs.r3, ins.rri_rpairs.imm);
                case 3: return strformat("ldpb r%d, r%d, [r%d, %d]", ins.rri_rpairs.r1, ins.rri_rpairs.r2, ins.rri_rpairs.r3, ins.rri_rpairs.imm);
            }
        }
        case OP_RRI_stp: {
            switch (ins.rri_rpairs.size) {
                case 0: return strformat("stp r%d, r%d, [r%d, %d]", ins.rri_rpairs.r1, ins.rri_rpairs.r2, ins.rri_rpairs.r3, ins.rri_rpairs.imm);
                case 1: return strformat("stpd r%d, r%d, [r%d, %d]", ins.rri_rpairs.r1, ins.rri_rpairs.r2, ins.rri_rpairs.r3, ins.rri_rpairs.imm);
                case 2: return strformat("stpw r%d, r%d, [r%d, %d]", ins.rri_rpairs.r1, ins.rri_rpairs.r2, ins.rri_rpairs.r3, ins.rri_rpairs.imm);
                case 3: return strformat("stpb r%d, r%d, [r%d, %d]", ins.rri_rpairs.r1, ins.rri_rpairs.r2, ins.rri_rpairs.r3, ins.rri_rpairs.imm);
            }
        }
    }
    return NULL;
}
char* str_fpu_type(hive_instruction_t ins) {
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
char* str_rrr_type(hive_instruction_t ins) {
    switch (ins.rrr.op) {
        case OP_RRR_add: return strformat("add r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_sub: return strformat("sub r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_mul: return strformat("mul r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_div: return strformat("div r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_mod: return strformat("mod r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_and: return strformat("and r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_or: return strformat("or r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_xor: return strformat("xor r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_shl: return strformat("shl r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_shr: return strformat("shr r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_rol: return strformat("rol r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRR_ror: return strformat("ror r%d, r%d, r%d", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
        case OP_RRI_ldr: {
            switch (ins.rrr_ls.size) {
                case 0: return strformat("ldr r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
                case 1: return strformat("ldrd r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
                case 2: return strformat("ldrw r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
                case 3: return strformat("ldrb r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
            }
        }
        case OP_RRI_str: {
            switch (ins.rrr_ls.size) {
                case 0: return strformat("str r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
                case 1: return strformat("strd r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
                case 2: return strformat("strw r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
                case 3: return strformat("strb r%d, [r%d, r%d]", ins.rrr.r1, ins.rrr.r2, ins.rrr.r3);
            }
        }
        case OP_RRR_tst: return strformat("tst r%d, r%d", ins.rrr.r1, ins.rrr.r2);
        case OP_RRR_cmp: return strformat("cmp r%d, r%d", ins.rrr.r1, ins.rrr.r2);
        case OP_RRR_ldp: {
            switch (ins.rrr_rpairs.size) {
                case 0: return strformat("ldp r%d, r%d, [r%d, r%d]", ins.rrr_rpairs.r1, ins.rrr_rpairs.r2, ins.rrr_rpairs.r3, ins.rrr_rpairs.r4);
                case 1: return strformat("ldpd r%d, r%d, [r%d, r%d]", ins.rrr_rpairs.r1, ins.rrr_rpairs.r2, ins.rrr_rpairs.r3, ins.rrr_rpairs.r4);
                case 2: return strformat("ldpw r%d, r%d, [r%d, r%d]", ins.rrr_rpairs.r1, ins.rrr_rpairs.r2, ins.rrr_rpairs.r3, ins.rrr_rpairs.r4);
                case 3: return strformat("ldpb r%d, r%d, [r%d, r%d]", ins.rrr_rpairs.r1, ins.rrr_rpairs.r2, ins.rrr_rpairs.r3, ins.rrr_rpairs.r4);
            }
        }
        case OP_RRR_stp: {
            switch (ins.rrr_rpairs.size) {
                case 0: return strformat("stp r%d, r%d, [r%d, r%d]", ins.rrr_rpairs.r1, ins.rrr_rpairs.r2, ins.rrr_rpairs.r3, ins.rrr_rpairs.r4);
                case 1: return strformat("stpd r%d, r%d, [r%d, r%d]", ins.rrr_rpairs.r1, ins.rrr_rpairs.r2, ins.rrr_rpairs.r3, ins.rrr_rpairs.r4);
                case 2: return strformat("stpw r%d, r%d, [r%d, r%d]", ins.rrr_rpairs.r1, ins.rrr_rpairs.r2, ins.rrr_rpairs.r3, ins.rrr_rpairs.r4);
                case 3: return strformat("stpb r%d, r%d, [r%d, r%d]", ins.rrr_rpairs.r1, ins.rrr_rpairs.r2, ins.rrr_rpairs.r3, ins.rrr_rpairs.r4);
            }
        }
        case OP_RRR_fpu: return str_fpu_type(ins);
    }
    return NULL;
}
char* str_ri_type(hive_instruction_t ins) {
    if (ins.ri.is_branch) {
        switch (ins.ri_branch.op) {
            case OP_RI_br: return strformat("b%sr r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
            case OP_RI_brlt: return strformat("b%srlt r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
            case OP_RI_brgt: return strformat("b%srgt r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
            case OP_RI_brge: return strformat("b%srge r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
            case OP_RI_brle: return strformat("b%srle r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
            case OP_RI_breq: return strformat("b%sreq r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
            case OP_RI_brne: return strformat("b%srne r%d", (ins.ri_branch.link ? "l" : ""), ins.ri_branch.r1);
            case OP_RI_cbr: if (ins.ri_cbranch.zero) {
                return strformat("cb%sz r%d, 0x%08x", (ins.ri_branch.link ? "l" : ""), ins.ri_s.r1, ins.ri_s.imm);
            } else {
                return strformat("cb%snz r%d, 0x%08x", (ins.ri_branch.link ? "l" : ""), ins.ri_s.r1, ins.ri_s.imm);
            }
        }
    } else {
        switch (ins.ri.op) {
            case OP_RI_lea: return strformat("lea r%d, 0x%08x", ins.ri_s.r1, ins.ri_s.imm);
            case OP_RI_movzk: if (ins.ri_mov.no_zero) {
                return strformat("movk r%d, %d, shl %d", ins.ri_mov.r1, ins.ri_mov.imm, ins.ri_mov.shift);
            } else {
                return strformat("movz r%d, %d, shl %d", ins.ri_mov.r1, ins.ri_mov.imm, ins.ri_mov.shift);
            }
            case OP_RI_svc: return strformat("svc");
            case OP_RI_tst: return strformat("tst r%d, %d", ins.ri.r1, ins.ri.imm);
            case OP_RI_cmp: return strformat("cmp r%d, %d", ins.ri.r1, ins.ri.imm);
        }
    }
    return NULL;
}

char* dis(hive_instruction_t ins) {
    char* instr = NULL;
    switch (ins.generic.type) {
        case 0: instr = str_data_type(ins); break;
        case 1: instr = str_rri_type(ins); break;
        case 2: instr = str_rrr_type(ins); break;
        case 3: instr = str_ri_type(ins); break;
    }
    return instr;
}

char* get_symbol_at(Symbol_Offsets syms, uint64_t addr) {
    // printf("looking for %p\n", addr);
    for (size_t i = 0; i < syms.count; i++) {
        // printf("- %s @ %p\n", syms.items[i].name, syms.items[i].offset);
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
        char* s = dis(ins);
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
                if (!ins.ri.is_branch && ins.ri.op == OP_RI_lea) {
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
