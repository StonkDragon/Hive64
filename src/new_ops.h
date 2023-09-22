/**
 * opcode layout 64 bits:
 * 
 * 
 * a: arg1 type
 * b: arg2 type
 * c: arg1
 * d: arg2
*/
#pragma once

#include <stdint.h>
#include <stdlib.h>

typedef struct symbol       symbol;
typedef struct object_file  object_file;

struct bytes {
    uint8_t*        data;
    uint64_t        size;
};

typedef struct {
    uint8_t         nbytes:4;
    uint16_t        opcode:12;
} opcode_t;

#define OPC(_nbytes, _opcode) ((opcode_t) { .nbytes = _nbytes, .opcode = _opcode })

typedef struct {
    enum {
        arg_none,       // no argument
        arg_reg,        // register
        arg_imm16,      // immediate 16 bit
        arg_imm64,      // 64 bit immediate
        arg_sym         // symbol
    }               type;
    union {
        uint8_t     reg;
        uint16_t    imm16;
        uint64_t    imm64;
        const char* sym;
    };
} instr_arg;

#define ARG_REG(_reg) ((instr_arg) { .type = arg_reg, .reg = _reg })
#define ARG_IMM16(_imm) ((instr_arg) { .type = arg_imm16, .imm16 = _imm })
#define ARG_ADDR(_imm) ((instr_arg) { .type = arg_imm64, .imm64 = _imm })
#define ARG_IMM64(_imm) ARG_ADDR(_imm)
#define ARG_SYM(_sym) ((instr_arg) { .type = arg_sym, .sym = _sym })

typedef struct instruction {
    opcode_t        opcode;
    instr_arg       args[16];
} instruction_t;

typedef struct {
    enum {
        file_insert_type_bytes,
        file_insert_type_instruction
    }               type;
    union {
        struct bytes bytes;
        instruction_t instruction;
    };
} file_insert_t;

struct object_file {
    uint32_t        magic;
    uint8_t*        data;
    uint64_t        data_size;
    uint64_t        data_capacity;

    // compilation only
    file_insert_t*  contents;
    uint64_t        contents_size;
    uint64_t        contents_capacity;
    uint64_t        comp_size;
    uint16_t        symbols_size;
    symbol*         symbols;
};

struct symbol {
    int8_t*         name;
    uint64_t        offset;
    uint8_t         type;
    uint8_t*        code;
};

typedef union tregister_t {
    uint64_t    asInteger;
    int64_t     asSignedInteger;
    void*       asPointer;
    double      asFloat;
} tregister_t;

typedef union simd_register_t {
    float       f32[8];
    double      f64[4];
    uint32_t    i32[8];
    uint64_t    i64[4];
    uint16_t    i16[16];
    uint8_t     i8[32];
} simd_register_t;

typedef uint8_t i8_t;
typedef uint16_t i16_t;
typedef uint32_t i32_t;
typedef uint64_t i64_t;
typedef float f32_t;
typedef double f64_t;

uint64_t symbol_offset(object_file *obj, const char *name);

#define CODE(name) add_symbol(obj, name)
#define DATA(name) add_symbol(obj, name)
#define ASCII(str) add_bytes(obj, str, strlen(str))
#define ASCIZ(str) add_bytes(obj, str, strlen(str) + 1)

#define CREATE_OBJECT() object_file* obj = create_object()

#define opcode_nbytes_mask  0b1111000000000000
#define opcode_nbytes_shift 12

#define RESIZE_CONTENTS() if (obj->contents_size++ == obj->contents_capacity) { obj->contents_capacity = obj->contents_capacity ? obj->contents_capacity * 2 : 16; obj->contents = realloc(obj->contents, obj->contents_capacity * sizeof(file_insert_t)); }

static inline void add_imm_byte(object_file* obj, uint8_t byte) {
    RESIZE_CONTENTS();
    obj->contents[obj->contents_size - 1].type = file_insert_type_bytes;
    obj->contents[obj->contents_size - 1].bytes.data = malloc(sizeof(uint8_t));
    obj->contents[obj->contents_size - 1].bytes.data[0] = byte;
    obj->contents[obj->contents_size - 1].bytes.size = 1;
    obj->comp_size += 1;
}

static inline void compile_imm_byte(object_file* obj, uint8_t byte) {
    if (obj->data_size == obj->data_capacity) {
        obj->data_capacity *= 2;
        obj->data = realloc(obj->data, obj->data_capacity);
    }
    obj->data[obj->data_size++] = byte;
}

static inline void add_imm_word(object_file* obj, uint16_t word) {
    RESIZE_CONTENTS();
    obj->contents[obj->contents_size - 1].type = file_insert_type_bytes;
    obj->contents[obj->contents_size - 1].bytes.data = malloc(sizeof(uint16_t));
    obj->contents[obj->contents_size - 1].bytes.data[0] = word & 0xFF;
    obj->contents[obj->contents_size - 1].bytes.data[1] = (word >> 8) & 0xFF;
    obj->contents[obj->contents_size - 1].bytes.size = 2;
    obj->comp_size += 2;
}

static inline void compile_imm_word(object_file* obj, uint16_t word) {
    compile_imm_byte(obj, word & 0xFF);
    compile_imm_byte(obj, (word >> 8) & 0xFF);
}

static inline void add_imm_dword(object_file* obj, uint32_t dword) {
    RESIZE_CONTENTS();
    obj->contents[obj->contents_size - 1].type = file_insert_type_bytes;
    obj->contents[obj->contents_size - 1].bytes.data = malloc(sizeof(uint32_t));
    obj->contents[obj->contents_size - 1].bytes.data[0] = dword & 0xFF;
    obj->contents[obj->contents_size - 1].bytes.data[1] = (dword >> 8) & 0xFF;
    obj->contents[obj->contents_size - 1].bytes.data[2] = (dword >> 16) & 0xFF;
    obj->contents[obj->contents_size - 1].bytes.data[3] = (dword >> 24) & 0xFF;
    obj->contents[obj->contents_size - 1].bytes.size = 4;
    obj->comp_size += 4;
}

static inline void compile_imm_dword(object_file* obj, uint32_t dword) {
    compile_imm_byte(obj, dword & 0xFF);
    compile_imm_byte(obj, (dword >> 8) & 0xFF);
    compile_imm_byte(obj, (dword >> 16) & 0xFF);
    compile_imm_byte(obj, (dword >> 24) & 0xFF);
}

static inline void add_imm_qword(object_file* obj, uint64_t qword) {
    RESIZE_CONTENTS();
    obj->contents[obj->contents_size - 1].type = file_insert_type_bytes;
    obj->contents[obj->contents_size - 1].bytes.data = malloc(sizeof(uint64_t));
    obj->contents[obj->contents_size - 1].bytes.data[0] = qword & 0xFF;
    obj->contents[obj->contents_size - 1].bytes.data[1] = (qword >> 8) & 0xFF;
    obj->contents[obj->contents_size - 1].bytes.data[2] = (qword >> 16) & 0xFF;
    obj->contents[obj->contents_size - 1].bytes.data[3] = (qword >> 24) & 0xFF;
    obj->contents[obj->contents_size - 1].bytes.data[4] = (qword >> 32) & 0xFF;
    obj->contents[obj->contents_size - 1].bytes.data[5] = (qword >> 40) & 0xFF;
    obj->contents[obj->contents_size - 1].bytes.data[6] = (qword >> 48) & 0xFF;
    obj->contents[obj->contents_size - 1].bytes.data[7] = (qword >> 56) & 0xFF;
    obj->contents[obj->contents_size - 1].bytes.size = 8;
    obj->comp_size += 8;
}

static inline void compile_imm_qword(object_file* obj, uint64_t qword) {
    compile_imm_byte(obj, qword & 0xFF);
    compile_imm_byte(obj, (qword >> 8) & 0xFF);
    compile_imm_byte(obj, (qword >> 16) & 0xFF);
    compile_imm_byte(obj, (qword >> 24) & 0xFF);
    compile_imm_byte(obj, (qword >> 32) & 0xFF);
    compile_imm_byte(obj, (qword >> 40) & 0xFF);
    compile_imm_byte(obj, (qword >> 48) & 0xFF);
    compile_imm_byte(obj, (qword >> 56) & 0xFF);
}

static inline void add_instruction(object_file* obj, struct instruction instr) {
    RESIZE_CONTENTS();
    obj->contents[obj->contents_size - 1].type = file_insert_type_instruction;
    obj->contents[obj->contents_size - 1].instruction = instr;
    obj->comp_size += 2 + instr.opcode.nbytes;
}

static inline void add_bytes(object_file* obj, char* data, size_t count) {
    RESIZE_CONTENTS();
    obj->contents[obj->contents_size - 1].type = file_insert_type_bytes;
    obj->contents[obj->contents_size - 1].bytes.data = malloc(count);
    memcpy(obj->contents[obj->contents_size - 1].bytes.data, data, count);
    obj->contents[obj->contents_size - 1].bytes.size = count;
    obj->comp_size += count;
}

static inline void compile_bytes(object_file* obj, struct bytes bytes);
static inline void compile_instruction(object_file* obj, struct instruction instr);

static inline void compile_bytes_or_instr(object_file* obj, file_insert_t insert) {
    switch (insert.type)
    {
    case file_insert_type_bytes:
        compile_bytes(obj, insert.bytes);
        break;
    case file_insert_type_instruction:
        compile_instruction(obj, insert.instruction);
        break;
    }
}

static inline void compile_bytes(object_file* obj, struct bytes bytes) {
    for (int i = 0; i < bytes.size; i++) {
        compile_imm_byte(obj, bytes.data[i]);
    }
}

static inline void compile_instruction(object_file* obj, struct instruction instr) {
    uint16_t op = instr.opcode.opcode;
    op |= instr.opcode.nbytes << opcode_nbytes_shift;
    compile_imm_word(obj, op);
    for (uint8_t i = 0; i < 4; i++) {
        switch (instr.args[i].type)
        {
        case arg_none:
            break;
        case arg_reg:
            compile_imm_byte(obj, instr.args[i].reg);
            break;
        case arg_imm16:
            compile_imm_word(obj, instr.args[i].imm16);
            break;
        case arg_sym:
            compile_imm_dword(obj, symbol_offset(obj, instr.args[i].sym));
            break;
        case arg_imm64:
            compile_imm_qword(obj, instr.args[i].imm64);
            break;
        default:
            printf("Unknown instruction argument type %d in instruction %01x %03x\n", instr.args[i].type, instr.opcode.nbytes, instr.opcode.opcode);
            break;
        }
    }
}

#define opcode_nop              0b000000000000
#define opcode_halt             0b000000000001
#define opcode_ldr              0b000000000010
#define opcode_str              0b000000000011
#define opcode_cmp              0b000000000100
#define opcode_cmpz             0b000000000101
#define opcode_b                0b000000000110
#define opcode_bne              0b000000000111
#define opcode_beq              0b000000001000
#define opcode_bgt              0b000000001001
#define opcode_blt              0b000000001010
#define opcode_bge              0b000000001011
#define opcode_ble              0b000000001100
#define opcode_bnz              0b000000001101
#define opcode_bz               0b000000001110
#define opcode_pshi             0b000000001111
#define opcode_ret              0b000000010000
#define opcode_pshx             0b000000010001
#define opcode_ppx              0b000000010010
#define opcode_pshy             0b000000010011
#define opcode_ppy              0b000000010100
#define opcode_psh              0b000000010101
#define opcode_pp               0b000000010110
#define opcode_add              0b000000010111
#define opcode_sub              0b000000011000
#define opcode_mul              0b000000011001
#define opcode_div              0b000000011010
#define opcode_mod              0b000000011011
#define opcode_and              0b000000011100
#define opcode_or               0b000000011101
#define opcode_xor              0b000000011110
#define opcode_shl              0b000000011111
#define opcode_shr              0b000000100000
#define opcode_not              0b000000100001
#define opcode_inc              0b000000100010
#define opcode_dec              0b000000100011
#define opcode_irq              0b000000100100
// #define opcode_ldr_addr         0b000000100101
#define opcode_mov              0b000000100110

#define opcode_qadd             0b010000100111
#define opcode_qsub             0b010000101000
#define opcode_qmul             0b010000101001
#define opcode_qdiv             0b010000101010
#define opcode_qmod             0b010000101011
#define opcode_qand             0b010000101100
#define opcode_qor              0b010000101101
#define opcode_qxor             0b010000101110
#define opcode_qshl             0b010000101111
#define opcode_qshr             0b010000110000
#define opcode_qconv            0b010000110001
#define opcode_qaddsub          0b010000110010
#define opcode_qshuf            0b010000110011
#define opcode_qmov             0b010000110100
#define opcode_qmov2            0b010000110101

//      opcode                      nbytes                 // mnemonic                                  // bytecode
#define op_nop                  OPC(0, opcode_nop)         // nop                                       // 0x000
#define op_halt                 OPC(0, opcode_halt)        // hlt                                       // 0x001
#define op_pshi                 OPC(0, opcode_pshi)        // pshi                                      // 0x00F
#define op_ret                  OPC(0, opcode_ret)         // ret                                       // 0x010
#define op_pshx                 OPC(0, opcode_pshx)        // pshx                                      // 0x011
#define op_ppx                  OPC(0, opcode_ppx)         // ppx                                       // 0x012
#define op_pshy                 OPC(0, opcode_pshy)        // pshy                                      // 0x013
#define op_ppy                  OPC(0, opcode_ppy)         // ppy                                       // 0x014
#define op_irq                  OPC(0, opcode_irq)         // irq                                       // 0x024

#define op_cmpz_reg             OPC(1, opcode_cmpz)        // cmpz r1                                   // 0x005 0x01
#define op_b_reg                OPC(1, opcode_b)           // b r1                                      // 0x006 0x01
#define op_bne_reg              OPC(1, opcode_bne)         // bne r1                                    // 0x007 0x01
#define op_beq_reg              OPC(1, opcode_beq)         // beq r1                                    // 0x008 0x01
#define op_bgt_reg              OPC(1, opcode_bgt)         // bgt r1                                    // 0x009 0x01
#define op_blt_reg              OPC(1, opcode_blt)         // blt r1                                    // 0x00A 0x01
#define op_bge_reg              OPC(1, opcode_bge)         // bge r1                                    // 0x00B 0x01
#define op_ble_reg              OPC(1, opcode_ble)         // ble r1                                    // 0x00C 0x01
#define op_bnz_reg              OPC(1, opcode_bnz)         // bnz r1                                    // 0x00D 0x01
#define op_bz_reg               OPC(1, opcode_bz)          // bz r1                                     // 0x00E 0x01
#define op_psh_reg              OPC(1, opcode_psh)         // psh r1                                    // 0x015 0x01
#define op_pp_reg               OPC(1, opcode_pp)          // pp r1                                     // 0x016 0x01
#define op_not_reg              OPC(1, opcode_not)         // not r1                                    // 0x021 0x01
#define op_inc_reg              OPC(1, opcode_inc)         // inc r1                                    // 0x022 0x01
#define op_dec_reg              OPC(1, opcode_dec)         // dec r1                                    // 0x023 0x01

#define op_ldr_reg_reg          OPC(2, opcode_ldr)         // ldr r1 r2                                 // 0x002 0x01 0x02
#define op_str_reg_reg          OPC(2, opcode_str)         // str r1 r2                                 // 0x003 0x01 0x02
#define op_cmp_reg_reg          OPC(2, opcode_cmp)         // cmp r1 r2                                 // 0x004 0x01 0x02
#define op_psh_imm16            OPC(2, opcode_psh)         // psh 0x1234                                // 0x015 0x12 0x34
#define op_add_reg_reg          OPC(2, opcode_add)         // add r1 r2                                 // 0x017 0x01 0x02
#define op_sub_reg_reg          OPC(2, opcode_sub)         // sub r1 r2                                 // 0x018 0x01 0x02
#define op_mul_reg_reg          OPC(2, opcode_mul)         // mul r1 r2                                 // 0x019 0x01 0x02
#define op_div_reg_reg          OPC(2, opcode_div)         // div r1 r2                                 // 0x01A 0x01 0x02
#define op_mod_reg_reg          OPC(2, opcode_mod)         // mod r1 r2                                 // 0x01B 0x01 0x02
#define op_and_reg_reg          OPC(2, opcode_and)         // and r1 r2                                 // 0x01C 0x01 0x02
#define op_or_reg_reg           OPC(2, opcode_or)          // or r1 r2                                  // 0x01D 0x01 0x02
#define op_xor_reg_reg          OPC(2, opcode_xor)         // xor r1 r2                                 // 0x01E 0x01 0x02
#define op_shl_reg_reg          OPC(2, opcode_shl)         // shl r1 r2                                 // 0x01F 0x01 0x02
#define op_shr_reg_reg          OPC(2, opcode_shr)         // shr r1 r2                                 // 0x020 0x01 0x02

#define op_ldr_reg_imm16        OPC(3, opcode_ldr)         // ldr r1 0x1234                             // 0x002 0x01 0x12 0x34
#define op_str_reg_imm16        OPC(3, opcode_str)         // str r1 0x1234                             // 0x003 0x01 0x12 0x34
#define op_cmp_reg_imm16        OPC(3, opcode_cmp)         // cmp r1 0x1234                             // 0x004 0x01 0x12 0x34
#define op_add_reg_imm16        OPC(3, opcode_add)         // add r1 0x1234                             // 0x017 0x01 0x12 0x34
#define op_sub_reg_imm16        OPC(3, opcode_sub)         // sub r1 0x1234                             // 0x018 0x01 0x12 0x34
#define op_mul_reg_imm16        OPC(3, opcode_mul)         // mul r1 0x1234                             // 0x019 0x01 0x12 0x34
#define op_div_reg_imm16        OPC(3, opcode_div)         // div r1 0x1234                             // 0x01A 0x01 0x12 0x34
#define op_mod_reg_imm16        OPC(3, opcode_mod)         // mod r1 0x1234                             // 0x01B 0x01 0x12 0x34
#define op_and_reg_imm16        OPC(3, opcode_and)         // and r1 0x1234                             // 0x01C 0x01 0x12 0x34
#define op_or_reg_imm16         OPC(3, opcode_or)          // or r1 0x1234                              // 0x01D 0x01 0x12 0x34
#define op_xor_reg_imm16        OPC(3, opcode_xor)         // xor r1 0x1234                             // 0x01E 0x01 0x12 0x34
#define op_shl_reg_imm16        OPC(3, opcode_shl)         // shl r1 0x1234                             // 0x01F 0x01 0x12 0x34
#define op_shr_reg_imm16        OPC(3, opcode_shr)         // shr r1 0x1234                             // 0x020 0x01 0x12 0x34
#define op_qadd_reg_reg         OPC(3, opcode_qadd)        // qadd (b|w|d|q|float|double) xmm1 xmm2     // 0x427 0x(01|02|04|08|10|20) 0x01 0x02
#define op_qsub_reg_reg         OPC(3, opcode_qsub)        // qsub (b|w|d|q|float|double) xmm1 xmm2     // 0x428 0x(01|02|04|08|10|20) 0x01 0x02
#define op_qmul_reg_reg         OPC(3, opcode_qmul)        // qmul (b|w|d|q|float|double) xmm1 xmm2     // 0x429 0x(01|02|04|08|10|20) 0x01 0x02
#define op_qdiv_reg_reg         OPC(3, opcode_qdiv)        // qdiv (b|w|d|q|float|double) xmm1 xmm2     // 0x42A 0x(01|02|04|08|10|20) 0x01 0x02
#define op_qmod_reg_reg         OPC(3, opcode_qmod)        // qmod (b|w|d|q|float|double) xmm1 xmm2     // 0x42B 0x(01|02|04|08|10|20) 0x01 0x02
#define op_qand_reg_reg         OPC(3, opcode_qand)        // qand (b|w|d|q|float|double) xmm1 xmm2     // 0x42C 0x(01|02|04|08|10|20) 0x01 0x02
#define op_qor_reg_reg          OPC(3, opcode_qor)         // qor (b|w|d|q|float|double) xmm1 xmm2      // 0x42D 0x(01|02|04|08|10|20) 0x01 0x02
#define op_qxor_reg_reg         OPC(3, opcode_qxor)        // qxor (b|w|d|q|float|double) xmm1 xmm2     // 0x42E 0x(01|02|04|08|10|20) 0x01 0x02
#define op_qshl_reg_reg         OPC(3, opcode_qshl)        // qshl (b|w|d|q|float|double) xmm1 xmm2     // 0x42F 0x(01|02|04|08|10|20) 0x01 0x02
#define op_qshr_reg_reg         OPC(3, opcode_qshr)        // qshr (b|w|d|q|float|double) xmm1 xmm2     // 0x430 0x(01|02|04|08|10|20) 0x01 0x02
#define op_qaddsub_reg_reg      OPC(3, opcode_qaddsub)     // qaddsub (b|w|d|q|float|double) xmm1 xmm2  // 0x432 0x(01|02|04|08|10|20) 0x01 0x02
#define op_qshuf_reg_reg        OPC(3, opcode_qshuf)       // qshuf (b|w|d|q|float|double) xmm1 xmm2    // 0x433 0x(01|02|04|08|10|20) 0x01 0x02
#define op_qmov_reg_reg         OPC(3, opcode_qmov)        // qmov (b|w|d|q|float|double) xmm1 r2       // 0x434 0x(01|02|04|08|10|20) 0x01 0x02

#define op_ldr_reg_mem          OPC(4, opcode_ldr)         // ldr r1 [r2 (0x1234)]                      // 0x002 0x01 0x02 0x12 0x34
#define op_b_addr               OPC(4, opcode_b)           // b label                                   // 0x006 (label address in data (32 bit))
#define op_bne_addr             OPC(4, opcode_bne)         // bne label                                 // 0x007 (label address in data (32 bit))
#define op_beq_addr             OPC(4, opcode_beq)         // beq label                                 // 0x008 (label address in data (32 bit))
#define op_bgt_addr             OPC(4, opcode_bgt)         // bgt label                                 // 0x009 (label address in data (32 bit))
#define op_blt_addr             OPC(4, opcode_blt)         // blt label                                 // 0x00A (label address in data (32 bit))
#define op_bge_addr             OPC(4, opcode_bge)         // bge label                                 // 0x00B (label address in data (32 bit))
#define op_ble_addr             OPC(4, opcode_ble)         // ble label                                 // 0x00C (label address in data (32 bit))
#define op_bnz_addr             OPC(4, opcode_bnz)         // bnz label                                 // 0x00D (label address in data (32 bit))
#define op_bz_addr              OPC(4, opcode_bz)          // bz label                                  // 0x00E (label address in data (32 bit))
#define op_psh_addr             OPC(4, opcode_psh)         // psh label                                 // 0x015 (label address in data (32 bit))
#define op_pp_addr              OPC(4, opcode_pp)          // pp label                                  // 0x016 (label address in data (32 bit))
#define op_mov_reg_reg_reg      OPC(4, opcode_mov)         // mov r1 (b|w|d|q) [r2 r3]                  // 0x026 0x01 0x0(1|2|4|8) 0x02 0x03
#define op_qconv_reg_reg        OPC(4, opcode_qconv)       // qconv (b|w|d|q|float|double) xmm1 (b|w|d|q|float|double) xmm2 // 0x431 0x(01|02|04|08|10|20) 0x01 0x(01|02|04|08|10|20) 0x02
#define op_qmov_reg_imm         OPC(4, opcode_qmov)        // qmov (b|w|d|q|float|double) [xmm1 (0x12)] r1 // 0x434 0x(01|02|04|08|10|20) 0x01 0x12 0x02
#define op_qmov2_reg_imm        OPC(4, opcode_qmov2)       // qmov r1 (b|w|d|q|float|double) [xmm1 (0x12)] // 0x435 0x01 0x(01|02|04|08|10|20) 0x12 0x02

#define op_ldr_reg_addr         OPC(5, opcode_ldr)         // ldr r1 label                              // 0x002 0x01 (label address in data (32 bit))
#define op_mov_reg_reg          OPC(5, opcode_mov)         // mov r1 (b|w|d|q) [r2 (0x1234)]            // 0x026 0x01 0x0(1|2|4|8) 0x12 0x34 0x02
#define op_add_reg_mem          OPC(5, opcode_add)         // add r1 (b|w|d|q) [r2 (0x1234)]            // 0x017 0x01 0x0(1|2|4|8) 0x02 0x12 0x34
#define op_sub_reg_mem          OPC(5, opcode_sub)         // sub r1 (b|w|d|q) [r2 (0x1234)]            // 0x018 0x01 0x0(1|2|4|8) 0x02 0x12 0x34
#define op_mul_reg_mem          OPC(5, opcode_mul)         // mul r1 (b|w|d|q) [r2 (0x1234)]            // 0x019 0x01 0x0(1|2|4|8) 0x02 0x12 0x34
#define op_div_reg_mem          OPC(5, opcode_div)         // div r1 (b|w|d|q) [r2 (0x1234)]            // 0x01A 0x01 0x0(1|2|4|8) 0x02 0x12 0x34
#define op_mod_reg_mem          OPC(5, opcode_mod)         // mod r1 (b|w|d|q) [r2 (0x1234)]            // 0x01B 0x01 0x0(1|2|4|8) 0x02 0x12 0x34
#define op_and_reg_mem          OPC(5, opcode_and)         // and r1 (b|w|d|q) [r2 (0x1234)]            // 0x01C 0x01 0x0(1|2|4|8) 0x02 0x12 0x34
#define op_or_reg_mem           OPC(5, opcode_or)          // or r1 (b|w|d|q) [r2 (0x1234)]             // 0x01D 0x01 0x0(1|2|4|8) 0x02 0x12 0x34
#define op_xor_reg_mem          OPC(5, opcode_xor)         // xor r1 (b|w|d|q) [r2 (0x1234)]            // 0x01E 0x01 0x0(1|2|4|8) 0x02 0x12 0x34
#define op_shl_reg_mem          OPC(5, opcode_shl)         // shl r1 (b|w|d|q) [r2 (0x1234)]            // 0x01F 0x01 0x0(1|2|4|8) 0x02 0x12 0x34
#define op_shr_reg_mem          OPC(5, opcode_shr)         // shr r1 (b|w|d|q) [r2 (0x1234)]            // 0x020 0x01 0x0(1|2|4|8) 0x02 0x12 0x34

#define op_ldr_reg_addr_reg     OPC(6, opcode_ldr)         // ldr r1 [label r2]                         // 0x002 0x01 0x02 (label address in data (32 bit))

#define op_ldr_reg_addr_imm16   OPC(7, opcode_ldr)         // ldr r1 [label (0x1234)]                   // 0x002 0x01 0x12 0x34 (label address in data (32 bit))
#define op_mov_reg_addr_reg     OPC(7, opcode_mov)         // mov r1 (b|w|d|q) [label r2]               // 0x026 0x01 0x0(1|2|4|8) (label address in data (32 bit)) 0x02
#define op_add_reg_addr_reg     OPC(7, opcode_add)         // add r1 (b|w|d|q) [label r2]               // 0x017 0x01 0x0(1|2|4|8) (label address in data (32 bit)) 0x02
#define op_sub_reg_addr_reg     OPC(7, opcode_sub)         // sub r1 (b|w|d|q) [label r2]               // 0x018 0x01 0x0(1|2|4|8) (label address in data (32 bit)) 0x02
#define op_mul_reg_addr_reg     OPC(7, opcode_mul)         // mul r1 (b|w|d|q) [label r2]               // 0x019 0x01 0x0(1|2|4|8) (label address in data (32 bit)) 0x02
#define op_div_reg_addr_reg     OPC(7, opcode_div)         // div r1 (b|w|d|q) [label r2]               // 0x01A 0x01 0x0(1|2|4|8) (label address in data (32 bit)) 0x02
#define op_mod_reg_addr_reg     OPC(7, opcode_mod)         // mod r1 (b|w|d|q) [label r2]               // 0x01B 0x01 0x0(1|2|4|8) (label address in data (32 bit)) 0x02
#define op_and_reg_addr_reg     OPC(7, opcode_and)         // and r1 (b|w|d|q) [label r2]               // 0x01C 0x01 0x0(1|2|4|8) (label address in data (32 bit)) 0x02
#define op_or_reg_addr_reg      OPC(7, opcode_or)          // or r1 (b|w|d|q) [label r2]                // 0x01D 0x01 0x0(1|2|4|8) (label address in data (32 bit)) 0x02
#define op_xor_reg_addr_reg     OPC(7, opcode_xor)         // xor r1 (b|w|d|q) [label r2]               // 0x01E 0x01 0x0(1|2|4|8) (label address in data (32 bit)) 0x02
#define op_shl_reg_addr_reg     OPC(7, opcode_shl)         // shl r1 (b|w|d|q) [label r2]               // 0x01F 0x01 0x0(1|2|4|8) (label address in data (32 bit)) 0x02
#define op_shr_reg_addr_reg     OPC(7, opcode_shr)         // shr r1 (b|w|d|q) [label r2]               // 0x020 0x01 0x0(1|2|4|8) (label address in data (32 bit)) 0x02

#define op_psh_imm64            OPC(8, opcode_psh)         // psh 0x123456789ABCDEF0                    // 0x015 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_mov_reg_addr         OPC(8, opcode_mov)         // mov r1 (b|w|d|q) [label (0x1234)]         // 0x026 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (32 bit)
#define op_add_reg_addr         OPC(8, opcode_add)         // add r1 (b|w|d|q) [label (0x1234)]         // 0x017 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (32 bit)
#define op_sub_reg_addr         OPC(8, opcode_sub)         // sub r1 (b|w|d|q) [label (0x1234)]         // 0x018 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (32 bit)
#define op_mul_reg_addr         OPC(8, opcode_mul)         // mul r1 (b|w|d|q) [label (0x1234)]         // 0x019 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (32 bit)
#define op_div_reg_addr         OPC(8, opcode_div)         // div r1 (b|w|d|q) [label (0x1234)]         // 0x01A 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (32 bit)
#define op_mod_reg_addr         OPC(8, opcode_mod)         // mod r1 (b|w|d|q) [label (0x1234)]         // 0x01B 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (32 bit)
#define op_and_reg_addr         OPC(8, opcode_and)         // and r1 (b|w|d|q) [label (0x1234)]         // 0x01C 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (32 bit)
#define op_or_reg_addr          OPC(8, opcode_or)          // or r1 (b|w|d|q) [label (0x1234)]          // 0x01D 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (32 bit)
#define op_xor_reg_addr         OPC(8, opcode_xor)         // xor r1 (b|w|d|q) [label (0x1234)]         // 0x01E 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (32 bit)
#define op_shl_reg_addr         OPC(8, opcode_shl)         // shl r1 (b|w|d|q) [label (0x1234)]         // 0x01F 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (32 bit)
#define op_shr_reg_addr         OPC(8, opcode_shr)         // shr r1 (b|w|d|q) [label (0x1234)]         // 0x020 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (32 bit)

#define op_ldr_reg_imm          OPC(9, opcode_ldr)         // ldr r1 0x123456789ABCDEF0                 // 0x002 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_str_reg_imm64        OPC(9, opcode_str)         // str r1 0x123456789ABCDEF0                 // 0x003 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_cmp_reg_imm64        OPC(9, opcode_cmp)         // cmp r1 0x123456789ABCDEF0                 // 0x004 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_add_reg_imm64        OPC(9, opcode_add)         // add r1 0x123456789ABCDEF0                 // 0x017 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_sub_reg_imm64        OPC(9, opcode_sub)         // sub r1 0x123456789ABCDEF0                 // 0x018 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_mul_reg_imm64        OPC(9, opcode_mul)         // mul r1 0x123456789ABCDEF0                 // 0x019 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_div_reg_imm64        OPC(9, opcode_div)         // div r1 0x123456789ABCDEF0                 // 0x01A 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_mod_reg_imm64        OPC(9, opcode_mod)         // mod r1 0x123456789ABCDEF0                 // 0x01B 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_and_reg_imm64        OPC(9, opcode_and)         // and r1 0x123456789ABCDEF0                 // 0x01C 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_or_reg_imm64         OPC(9, opcode_or)          // or r1 0x123456789ABCDEF0                  // 0x01D 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_xor_reg_imm64        OPC(9, opcode_xor)         // xor r1 0x123456789ABCDEF0                 // 0x01E 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_shl_reg_imm64        OPC(9, opcode_shl)         // shl r1 0x123456789ABCDEF0                 // 0x01F 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_shr_reg_imm64        OPC(9, opcode_shr)         // shr r1 0x123456789ABCDEF0                 // 0x020 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
