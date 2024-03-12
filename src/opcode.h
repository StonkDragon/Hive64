#define OP_BRANCH       0x0

#define OP_BRANCH_b     0x0
#define OP_BRANCH_blt   0x1
#define OP_BRANCH_bgt   0x2
#define OP_BRANCH_bge   0x3
#define OP_BRANCH_ble   0x4
#define OP_BRANCH_beq   0x5
#define OP_BRANCH_bne   0x6
#define OP_BRANCH_cb    0x7

#define OP_AI           0x1

#define OP_AI_add       0x0 // 0
#define OP_AI_sub       0x1 // 1
#define OP_AI_mul       0x2 // 2
#define OP_AI_div       0x3 // 3
#define OP_AI_mod       0x4 // 4
#define OP_AI_and       0x5 // 5
#define OP_AI_or        0x6 // 6
#define OP_AI_xor       0x7 // 7
#define OP_AI_shl       0x8 // 8
#define OP_AI_shr       0x9 // 9
#define OP_AI_rol       0xA // 10
#define OP_AI_ror       0xB // 11
#define OP_AI_neg       0xC // 12
#define OP_AI_not       0xD // 13
#define OP_AI_asr       0xE // 14
#define OP_AI_swe       0xF // 15

#define OP_RRI          0x2

#define OP_RRI_ldr      0x0 // 16
#define OP_RRI_str      0x1 // 17
#define OP_RRI_bext     0x2 // 18
#define OP_RRI_bdep     0x3 // 19

#define OP_AR           0x3

#define OP_AR_add       0x0 // 0
#define OP_AR_sub       0x1 // 1
#define OP_AR_mul       0x2 // 2
#define OP_AR_div       0x3 // 3
#define OP_AR_mod       0x4 // 4
#define OP_AR_and       0x5 // 5
#define OP_AR_or        0x6 // 6
#define OP_AR_xor       0x7 // 7
#define OP_AR_shl       0x8 // 8
#define OP_AR_shr       0x9 // 9
#define OP_AR_rol       0xA // 10
#define OP_AR_ror       0xB // 11
#define OP_AR_neg       0xC // 12
#define OP_AR_not       0xD // 13
#define OP_AR_asr       0xE // 14
#define OP_AR_swe       0xF // 15

#define OP_RRR          0x4

#define OP_RRR_ldr      0x0 // 0
#define OP_RRR_str      0x1 // 1
#define OP_RRR_tst      0x2 // 2
#define OP_RRR_cmp      0x3 // 3
#define OP_RRR_fpu      0x4 // 4
#define OP_RRR_vpu      0x5 // 5

#define OP_FLOAT_add    0x0
#define OP_FLOAT_addi   0x1
#define OP_FLOAT_sub    0x2
#define OP_FLOAT_subi   0x3
#define OP_FLOAT_mul    0x4
#define OP_FLOAT_muli   0x5
#define OP_FLOAT_div    0x6
#define OP_FLOAT_divi   0x7
#define OP_FLOAT_mod    0x8
#define OP_FLOAT_modi   0x9
#define OP_FLOAT_i2f    0xA
#define OP_FLOAT_f2i    0xB
#define OP_FLOAT_sin    0xC
#define OP_FLOAT_sqrt   0xD
#define OP_FLOAT_cmp    0xE
#define OP_FLOAT_cmpi   0xF

#define OP_VPU_add      0x0 // 0
#define OP_VPU_sub      0x1 // 1
#define OP_VPU_mul      0x2 // 2
#define OP_VPU_div      0x3 // 3
#define OP_VPU_addsub   0x4 // 4
#define OP_VPU_madd     0x5 // 5
#define OP_VPU_mov      0x6 // 6
#define OP_VPU_mov_vec  0x7 // 7
#define OP_VPU_conv     0x8 // 8
#define OP_VPU_len      0x9 // 9
#define OP_VPU_ldr      0xA // 10
#define OP_VPU_str      0xB // 11
#define OP_VPU_ldr_imm  0xC // 12
#define OP_VPU_str_imm  0xD // 13

#define OP_BR           0x5

#define OP_BR_br        0x0
#define OP_BR_brlt      0x1
#define OP_BR_brgt      0x2
#define OP_BR_brge      0x3
#define OP_BR_brle      0x4
#define OP_BR_breq      0x5
#define OP_BR_brne      0x6
#define OP_BR_cbr       0x7

#define OP_RI           0x6

#define OP_RI_lea       0x0
#define OP_RI_movzk     0x1
#define OP_RI_tst       0x2
#define OP_RI_cmp       0x3
#define OP_RI_svc       0x4
#define OP_RI_rsv       0x5
#define OP_RI_sidt      0x6
