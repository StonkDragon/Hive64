#define MODE_BRANCH             0b00
#define MODE_ARITH              0b01
#define MODE_LOAD               0b10
#define MODE_OTHER              0b11

#define OP_BRANCH_b             0b00
#define OP_BRANCH_bl            0b01
#define OP_BRANCH_br            0b10
#define OP_BRANCH_blr           0b11

#define SUBOP_DATA_ALU_R        0b00
#define SUBOP_DATA_ALU_I        0b01
#define SUBOP_DATA_SALU_R       0b10
#define SUBOP_DATA_SALU_I       0b11

#define OP_DATA_ALU_add         0x0
#define OP_DATA_ALU_sub         0x1
#define OP_DATA_ALU_mul         0x2
#define OP_DATA_ALU_div         0x3
#define OP_DATA_ALU_mod         0x4
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

#define OP_LOAD_lea             0b00
#define OP_LOAD_movzk           0b01
#define OP_LOAD_ls              0b10
#define OP_LOAD_ls_off          0b11

#define OP_OTHER_cpuid          0b00000
#define OP_OTHER_brk            0b00001
#define OP_OTHER_zeroupper      0b00010
#define OP_OTHER_sret           0b00011
#define OP_OTHER_hret           0b00100
#define OP_OTHER_iret           0b00101
#define OP_OTHER_svc            0b00110
#define OP_OTHER_storecr        0b00111
#define OP_OTHER_loadcr         0b01000
#define OP_OTHER_hexit          0b01001
#define OP_OTHER_sexit          0b01010

#define OP_OTHER_FPU64          0b01100
#define OP_OTHER_FPU32          0b01101
#define OP_OTHER_CSWAP          0b01110
#define OP_OTHER_XCHG           0b01111
#define OP_OTHER_UBXT           0b10000
#define OP_OTHER_SBXT           0b10001
#define OP_OTHER_UDEP           0b10010
#define OP_OTHER_SDEP           0b10011
// #define OP_OTHER_               0b10000
// #define OP_OTHER_               0b10001
// #define OP_OTHER_               0b10010
// #define OP_OTHER_               0b10011
// #define OP_OTHER_               0b10100
// #define OP_OTHER_               0b10101
// #define OP_OTHER_               0b10110
// #define OP_OTHER_               0b10111
// #define OP_OTHER_               0b11000
// #define OP_OTHER_               0b11001
// #define OP_OTHER_               0b11010
// #define OP_OTHER_               0b11011
#define OP_OTHER_VPU0           0b11100
#define OP_OTHER_VPU1           0b11101
#define OP_OTHER_VPU2           0b11110
#define OP_OTHER_VPU3           0b11111

#define OP_OTHER_FPU_add        0x0
#define OP_OTHER_FPU_sub        0x1
#define OP_OTHER_FPU_mul        0x2
#define OP_OTHER_FPU_div        0x3
#define OP_OTHER_FPU_mod        0x4
#define OP_OTHER_FPU_f2i        0x5
#define OP_OTHER_FPU_sin        0x6
#define OP_OTHER_FPU_sqrt       0x7
#define OP_OTHER_FPU_s2f        0x8

#define OP_OTHER_VPU_add        0b00000 // 00
#define OP_OTHER_VPU_sub        0b00001 // 01
#define OP_OTHER_VPU_mul        0b00010 // 02
#define OP_OTHER_VPU_div        0b00011 // 03
#define OP_OTHER_VPU_addsub     0b00100 // 04
#define OP_OTHER_VPU_madd       0b00101 // 05
#define OP_OTHER_VPU_mov        0b00110 // 06
#define OP_OTHER_VPU_mov_vec    0b00111 // 07
#define OP_OTHER_VPU_conv       0b01000 // 08
#define OP_OTHER_VPU_len        0b01001 // 09
#define OP_OTHER_VPU_ldr        0b01010 // 0A
#define OP_OTHER_VPU_str        0b01011 // 0B
#define OP_OTHER_VPU_and        0b01100 // 0C
#define OP_OTHER_VPU_or         0b01101 // 0D
#define OP_OTHER_VPU_xor        0b01110 // 0E
#define OP_OTHER_VPU_cmp        0b01111 // 0F
#define OP_OTHER_VPU_minmax     0b10000 // 10
#define OP_OTHER_VPU_abs        0b10001 // 11
#define OP_OTHER_VPU_shl        0b10010 // 12
#define OP_OTHER_VPU_shr        0b10011 // 13
#define OP_OTHER_VPU_sqrt       0b10100 // 14
#define OP_OTHER_VPU_mod        0b10101 // 15
#define OP_OTHER_VPU_movall     0b10110 // 16
#define OP_OTHER_VPU_tst        0b11111 // 1F
