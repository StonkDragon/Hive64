#define MODE_BRANCH             0b00
#define MODE_DATA               0b01
#define MODE_LOAD               0b10
#define MODE_OTHER              0b11

#define OP_BRANCH_b             0b00
#define OP_BRANCH_bl            0b01
#define OP_BRANCH_br            0b10
#define OP_BRANCH_blr           0b11

#define SUBOP_DATA_ALU_R        0b0000
#define SUBOP_DATA_ALU_I        0b0001
#define SUBOP_DATA_SALU_R       0b0010
#define SUBOP_DATA_SALU_I       0b0011
#define SUBOP_DATA_BEXT         0b0100
#define SUBOP_DATA_BDEP         0b0101
#define SUBOP_DATA_LS           0b0110
#define SUBOP_DATA_LS_FAR       0b0111
#define SUBOP_DATA_FPU          0b1000
#define SUBOP_DATA_VPU          0b1001
#define SUBOP_DATA_CSWAP        0b1010
#define SUBOP_DATA_XCHG         0b1011

#define OP_DATA_ALU_add         0x0
#define OP_DATA_ALU_sub         0x1
#define OP_DATA_ALU_mul         0x2
#define OP_DATA_ALU_div         0x3
#define OP_DATA_ALU_sdiv        0x3
#define OP_DATA_ALU_mod         0x4
#define OP_DATA_ALU_smod        0x4
#define OP_DATA_ALU_and         0x5
#define OP_DATA_ALU_or          0x6
#define OP_DATA_ALU_xor         0x7
#define OP_DATA_ALU_shl         0x8
#define OP_DATA_ALU_shr         0x9
#define OP_DATA_ALU_rol         0xA
#define OP_DATA_ALU_ror         0xB
#define OP_DATA_ALU_neg         0xC
#define OP_DATA_ALU_not         0xD
#define OP_DATA_ALU_sext        0xE
#define OP_DATA_ALU_swe         0xF

#define OP_DATA_FLOAT_add       0x0
#define OP_DATA_FLOAT_sub       0x1
#define OP_DATA_FLOAT_mul       0x2
#define OP_DATA_FLOAT_div       0x3
#define OP_DATA_FLOAT_mod       0x4
#define OP_DATA_FLOAT_f2i       0x5
#define OP_DATA_FLOAT_sin       0x6
#define OP_DATA_FLOAT_sqrt      0x7
#define OP_DATA_FLOAT_s2f       0x8

#define OP_DATA_VPU_add         0x0
#define OP_DATA_VPU_sub         0x1
#define OP_DATA_VPU_mul         0x2
#define OP_DATA_VPU_div         0x3
#define OP_DATA_VPU_addsub      0x4
#define OP_DATA_VPU_madd        0x5
#define OP_DATA_VPU_mov         0x6
#define OP_DATA_VPU_mov_vec     0x7
#define OP_DATA_VPU_conv        0x8
#define OP_DATA_VPU_len         0x9
#define OP_DATA_VPU_ldr         0xA
#define OP_DATA_VPU_str         0xB

#define OP_DATA_LS_ldrb_reg     0b0000
#define OP_DATA_LS_ldrw_reg     0b0001
#define OP_DATA_LS_ldrd_reg     0b0010
#define OP_DATA_LS_ldrq_reg     0b0011
#define OP_DATA_LS_strb_reg     0b0100
#define OP_DATA_LS_strw_reg     0b0101
#define OP_DATA_LS_strd_reg     0b0110
#define OP_DATA_LS_strq_reg     0b0111
#define OP_DATA_LS_ldrb_imm     0b1000
#define OP_DATA_LS_ldrw_imm     0b1001
#define OP_DATA_LS_ldrd_imm     0b1010
#define OP_DATA_LS_ldrq_imm     0b1011
#define OP_DATA_LS_strb_imm     0b1100
#define OP_DATA_LS_strw_imm     0b1101
#define OP_DATA_LS_strd_imm     0b1110
#define OP_DATA_LS_strq_imm     0b1111

#define OP_LOAD_lea             0b00
#define OP_LOAD_movzk           0b01
#define OP_LOAD_svc             0b10
#define OP_LOAD_ls_off          0b11

#define OP_OTHER_priv_op        0b00000
#define OP_OTHER_prefix         0b00001
#define OP_OTHER_zeroupper      0b00010

#define SUBOP_OTHER_cpuid       0b00000
