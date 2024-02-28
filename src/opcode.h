#define OP_BRANCH       0

#define OP_BRANCH_b     0b000
#define OP_BRANCH_blt   0b001
#define OP_BRANCH_bgt   0b010
#define OP_BRANCH_bge   0b011
#define OP_BRANCH_ble   0b100
#define OP_BRANCH_beq   0b101
#define OP_BRANCH_bne   0b110
#define OP_BRANCH_cb    0b111

#define OP_RRI          1

#define OP_RRI_add      0b00000 // 0
#define OP_RRI_sub      0b00001 // 1
#define OP_RRI_mul      0b00010 // 2
#define OP_RRI_div      0b00011 // 3
#define OP_RRI_mod      0b00100 // 4
#define OP_RRI_and      0b00101 // 5
#define OP_RRI_or       0b00110 // 6
#define OP_RRI_xor      0b00111 // 7
#define OP_RRI_shl      0b01000 // 8
#define OP_RRI_shr      0b01001 // 9
#define OP_RRI_rol      0b01010 // 10
#define OP_RRI_ror      0b01011 // 11
#define OP_RRI_ldr      0b01100 // 12
#define OP_RRI_str      0b01101 // 13
#define OP_RRI_bext     0b01110 // 14
#define OP_RRI_bdep     0b01111 // 15
#define OP_RRI_ldp      0b10000 // 16
#define OP_RRI_stp      0b10001 // 17

#define OP_RRR          2

#define OP_RRR_add      0b000000 // 0
#define OP_RRR_sub      0b000001 // 1
#define OP_RRR_mul      0b000010 // 2
#define OP_RRR_div      0b000011 // 3
#define OP_RRR_mod      0b000100 // 4
#define OP_RRR_and      0b000101 // 5
#define OP_RRR_or       0b000110 // 6
#define OP_RRR_xor      0b000111 // 7
#define OP_RRR_shl      0b001000 // 8
#define OP_RRR_shr      0b001001 // 9
#define OP_RRR_rol      0b001010 // 10
#define OP_RRR_ror      0b001011 // 11
#define OP_RRR_ldr      0b001100 // 12
#define OP_RRR_str      0b001101 // 13
#define OP_RRR_tst      0b001110 // 14
#define OP_RRR_cmp      0b001111 // 15
#define OP_RRR_ldp      0b010000 // 16
#define OP_RRR_stp      0b010001 // 17
#define OP_RRR_fpu      0b010010 // 18

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

#define OP_RI_br        0b1000
#define OP_RI_brlt      0b1001
#define OP_RI_brgt      0b1010
#define OP_RI_brge      0b1011
#define OP_RI_brle      0b1100
#define OP_RI_breq      0b1101
#define OP_RI_brne      0b1110
#define OP_RI_cbr       0b1111

#define OP_RI_lea       0b0000
#define OP_RI_movzk     0b0001
#define OP_RI_tst       0b0010
#define OP_RI_cmp       0b0011
#define OP_RI_svc       0b0100
