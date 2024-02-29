#define OP_BRANCH       0

#define OP_BRANCH_b     0x0
#define OP_BRANCH_blt   0x1
#define OP_BRANCH_bgt   0x2
#define OP_BRANCH_bge   0x3
#define OP_BRANCH_ble   0x4
#define OP_BRANCH_beq   0x5
#define OP_BRANCH_bne   0x6
#define OP_BRANCH_cb    0x7

#define OP_RRI          1

#define OP_RRI_add      0x00 // 0
#define OP_RRI_sub      0x01 // 1
#define OP_RRI_mul      0x02 // 2
#define OP_RRI_div      0x03 // 3
#define OP_RRI_mod      0x04 // 4
#define OP_RRI_and      0x05 // 5
#define OP_RRI_or       0x06 // 6
#define OP_RRI_xor      0x07 // 7
#define OP_RRI_shl      0x08 // 8
#define OP_RRI_shr      0x09 // 9
#define OP_RRI_rol      0x0A // 10
#define OP_RRI_ror      0x0B // 11
#define OP_RRI_ldr      0x0C // 12
#define OP_RRI_str      0x0D // 13
#define OP_RRI_bext     0x0E // 14
#define OP_RRI_bdep     0x0F // 15
#define OP_RRI_ldp      0x10 // 16
#define OP_RRI_stp      0x11 // 17

#define OP_RRR          2

#define OP_RRR_add      0x00 // 0
#define OP_RRR_sub      0x01 // 1
#define OP_RRR_mul      0x02 // 2
#define OP_RRR_div      0x03 // 3
#define OP_RRR_mod      0x04 // 4
#define OP_RRR_and      0x05 // 5
#define OP_RRR_or       0x06 // 6
#define OP_RRR_xor      0x07 // 7
#define OP_RRR_shl      0x08 // 8
#define OP_RRR_shr      0x09 // 9
#define OP_RRR_rol      0x0A // 10
#define OP_RRR_ror      0x0B // 11
#define OP_RRR_ldr      0x0C // 12
#define OP_RRR_str      0x0D // 13
#define OP_RRR_tst      0x0E // 14
#define OP_RRR_cmp      0x0F // 15
#define OP_RRR_ldp      0x10 // 16
#define OP_RRR_stp      0x11 // 17
#define OP_RRR_fpu      0x12 // 18

#define OP_FLOAT_add    0
#define OP_FLOAT_addi   1
#define OP_FLOAT_sub    2
#define OP_FLOAT_subi   3
#define OP_FLOAT_mul    4
#define OP_FLOAT_muli   5
#define OP_FLOAT_div    6
#define OP_FLOAT_divi   7
#define OP_FLOAT_mod    8
#define OP_FLOAT_modi   9
#define OP_FLOAT_i2f    10
#define OP_FLOAT_f2i    11
#define OP_FLOAT_sin    12
#define OP_FLOAT_sqrt   13
#define OP_FLOAT_cmp    14
#define OP_FLOAT_cmpi   15

#define OP_RI           3

#define OP_RI_br        0x8
#define OP_RI_brlt      0x9
#define OP_RI_brgt      0xA
#define OP_RI_brge      0xB
#define OP_RI_brle      0xC
#define OP_RI_breq      0xD
#define OP_RI_brne      0xE
#define OP_RI_cbr       0xF

#define OP_RI_lea       0x0
#define OP_RI_movzk     0x1
#define OP_RI_tst       0x2
#define OP_RI_cmp       0x3
#define OP_RI_svc       0x4
