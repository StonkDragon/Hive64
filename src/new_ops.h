/**
 * opcode layout 64 bits:
 * 
 * 
 * a: arg1 type
 * b: arg2 type
 * c: arg1
 * d: arg2
 * 
 * Pseudocode:
 * 
*/
#pragma once

#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#if defined(__APPLE__)
#include <malloc/malloc.h>
#else
#include <malloc.h>
#endif
#include <string.h>
#include <errno.h>

#if !defined(hive_offsetof)
#define hive_offsetof(type, member) ((size_t) &((type*) 0)->member)
#endif

struct bytes {
    uint8_t*        data;
    uint64_t        size;
};

typedef struct {
    enum {
        arg_none,       // no argument
        arg_reg,        // register
        arg_imm8,       // immediate 8 bit
        arg_imm16,      // immediate 16 bit
        arg_imm64,      // immediate 64 bit
        arg_sym         // symbol
    }               type;
    union {
        uint8_t     reg;
        uint8_t     imm8;
        uint16_t    imm16;
        uint64_t    imm64;
        const char* sym;
    };
} instr_arg;

#define ARG_8BIT(_reg) ((instr_arg) { .type = arg_imm8, .reg = _reg })
#define ARG_16BIT(_imm) ((instr_arg) { .type = arg_imm16, .imm16 = _imm })
#define ARG_64BIT(_imm) ((instr_arg) { .type = arg_imm64, .imm64 = _imm })
#define ARG_IMM64(_imm) ARG_64BIT(_imm)
#define ARG_SYM(_sym) ((instr_arg) { .type = arg_sym, .sym = _sym })

static void* align_alloc(size_t alignment, size_t size) {
    // pad the size to a multiple of the alignment
    if (size % alignment != 0) {
        size += alignment - (size % alignment);
    }
    void* ptr = aligned_alloc(alignment, size);
    if (ptr == NULL) {
        printf("Failed to allocate %lu bytes aligned to %lu bytes: %s\n", size, alignment, strerror(errno));
        exit(1);
    }
    return ptr;
}

#define PACKED _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Wattribute-packed-for-bitfield\"") __attribute__((packed)) _Pragma("clang diagnostic pop")

typedef struct section section_t;

typedef struct opcode {
    uint8_t         opcode PACKED;
    union {
        struct {
            uint8_t     reg3 PACKED;
            uint8_t     reg2 PACKED;
            uint8_t     reg1 PACKED;
        }           rrr PACKED;
        struct {
            uint8_t     imm PACKED;
            uint8_t     reg2 PACKED;
            uint8_t     reg1 PACKED;
        }           rri PACKED;
        struct {
            int16_t     imm PACKED;
            uint8_t     reg1 PACKED;
        }           ri PACKED;
        int16_t     i16 PACKED;
        struct {
            uint8_t     reg2 PACKED;
            uint8_t     reg1 PACKED;
        }           rr PACKED;
        struct {
            uint16_t    imm PACKED;
            uint8_t     shift: 2 PACKED;
            uint8_t     reg1: 6 PACKED;
        }           ris PACKED;
        uint8_t     r PACKED;
        uint8_t     u8 PACKED;

        uint32_t    args_raw: 24 PACKED;
    }               args PACKED;
} opcode_t;

typedef struct instruction {
    uint8_t         opcode;
    instr_arg       args[4];
    opcode_t        (*encode)(section_t* sect, struct instruction instr);
} instruction_t;

typedef struct {
    enum {
        file_insert_type_bytes,
        file_insert_type_instruction,
        file_insert_type_symbol
    }                   type;
    union {
        struct bytes    bytes;
        char*           symbol;
        instruction_t   instruction;
    };
} file_insert_t;

#define SECTION_TYPE_CODE 0x0001
#define SECTION_TYPE_DATA 0x0002

#define SECTION_FLAG_READ 0x0001
#define SECTION_FLAG_WRITE 0x0002
#define SECTION_FLAG_EXEC 0x0004
#define SECTION_FLAG_ZERO_INIT 0x0008
#define SECTION_FLAG_RELOCATE 0x0010
#define SECTION_FLAG_SYMBOLS 0x0020

typedef struct relocation_info {
} relocation_info_t;

#define SYMBOL_NAME_LEN_MAX 64

typedef struct symbol_t {
    uint64_t        sym_addr PACKED;
    char*           name PACKED;
} symbol_t;

typedef struct {
    uint64_t        offset;
    uint32_t        symbol;
    uint32_t        is_instr_addr;
} offset_t;

struct section {
    uint64_t        size;
    uint8_t*        data;

    uint16_t        symbols_size;
    symbol_t*       symbols;

    // compilation only
    file_insert_t*  contents;
    uint64_t        contents_size;
    uint64_t        contents_capacity;
    
    uint64_t        comp_size;
    
    uint64_t        symbol_relocs_size;
    uint64_t        symbol_relocs_capacity;
    uint64_t*       symbol_relocs;

    uint64_t        instr_addr_offsets_size;
    uint64_t        instr_addr_offsets_capacity;
    offset_t*       instr_addr_offsets;

    uint16_t        globals_size;
    char**          globals;
};

typedef struct load_command {
    uint32_t        size;
    offset_t*       data;
} load_command_t;

#define OBJECT_FILE_MAGIC 0xfeedface
#define OBJECT_FILE_VERSION 2

typedef struct object {
    uint32_t        magic;
    uint32_t        version;
    load_command_t  load_command;
    section_t       code;
} object_file_t;

static inline object_file_t create_translation_unit();
static inline object_file_t read_translation_unit_bytes(uint8_t* data, uint64_t size);

static inline object_file_t read_translation_unit(FILE* fp) {
    fseek(fp, 0, SEEK_END);
    uint64_t size = ftell(fp);
    fseek(fp, 0, SEEK_SET);

    uint8_t data[size];
    fread(data, size, 1, fp);

    return read_translation_unit_bytes(data, size);
}

static inline object_file_t read_translation_unit_bytes(uint8_t* data, uint64_t size) {
    object_file_t obj = create_translation_unit();

    #define NEXT(_type) ({ _type* ptr = (_type*) data; data += sizeof(_type); *ptr; })

    uint32_t magic = NEXT(uint32_t);
    uint32_t version = NEXT(uint32_t);

    if (magic != OBJECT_FILE_MAGIC) {
        printf("Invalid object file magic: %08x\n", magic);
        return (object_file_t) {0};
    }

    if (version != OBJECT_FILE_VERSION) {
        printf("Invalid object file version. Expected: %d, got: %d\n", OBJECT_FILE_VERSION, version);
        return (object_file_t) {0};
    }
    
    obj.code.size = NEXT(uint64_t);
    obj.code.symbols_size = NEXT(uint32_t);
    obj.load_command.size = NEXT(uint32_t);

    obj.code.data = align_alloc(0x1000, obj.code.size);
    memcpy(obj.code.data, data, obj.code.size);
    data += obj.code.size;
    
    obj.code.symbols = malloc(obj.code.symbols_size * sizeof(symbol_t));
    for (uint32_t i = 0; i < obj.code.symbols_size; i++) {
        obj.code.symbols[i].sym_addr = NEXT(uint64_t);
        obj.code.symbols[i].name = malloc(strlen((char*) data) + 1);
        strcpy(obj.code.symbols[i].name, (char*) data);
        data += strlen((char*) data) + 1;
    }

    obj.load_command.data = malloc(obj.load_command.size * sizeof(offset_t));
    for (uint32_t i = 0; i < obj.load_command.size; i++) {
        obj.load_command.data[i].offset = NEXT(uint64_t);
        obj.load_command.data[i].symbol = NEXT(uint32_t);
        obj.load_command.data[i].is_instr_addr = NEXT(uint32_t);
    }

    return obj;
}

static inline object_file_t create_translation_unit() {
    object_file_t file = {0};
    file.magic = OBJECT_FILE_MAGIC;
    file.version = OBJECT_FILE_VERSION;
    return file;
}

static inline void write_translation_unit(object_file_t* obj, FILE* fp) {
    fwrite(&obj->magic, sizeof(uint32_t), 1, fp);
    fwrite(&obj->version, sizeof(uint32_t), 1, fp);
    fwrite(&obj->code.size, sizeof(uint64_t), 1, fp);
    fwrite(&obj->code.symbols_size, sizeof(uint32_t), 1, fp);
    fwrite(&obj->load_command.size, sizeof(uint32_t), 1, fp);
    fwrite(obj->code.data, sizeof(uint8_t), obj->code.size, fp);
    for (uint32_t i = 0; i < obj->code.symbols_size; i++) {
        fwrite(&obj->code.symbols[i].sym_addr, sizeof(uint64_t), 1, fp);
        fwrite(obj->code.symbols[i].name, sizeof(char), strlen(obj->code.symbols[i].name) + 1, fp);
    }
    fwrite(obj->load_command.data, sizeof(offset_t), obj->load_command.size, fp);
}

typedef union hive_register_t {
    uint64_t    asQWord;
    uint32_t    asDWord;
    uint16_t    asWord;
    uint8_t     asByte;
    int64_t     asSQWord;
    int32_t     asSDWord;
    int16_t     asSWord;
    int8_t      asSByte;
    void*       asPointer;
    void**      asPointerPointer;
    uint16_t*   asUint16Ptr;
    double      asFloat;
    uint8_t     bytes[8];
} hive_register_t;

int32_t symbol_offset(section_t* obj, const char *name);
int add_symbol(section_t* obj, const char* name);

#define CODE(name) add_symbol(&obj, name)
#define DATA(name) add_symbol(&obj, name)
#define ASCII(str) add_bytes(&obj, str, strlen(str))
#define ASCIZ(str) add_bytes(&obj, str, strlen(str) + 1)

#define RESIZE_CONTENTS() if (obj->contents_size++ >= obj->contents_capacity) { obj->contents_capacity = obj->contents_capacity ? obj->contents_capacity * 2 : 16; obj->contents = realloc(obj->contents, obj->contents_capacity * sizeof(file_insert_t)); }
#define RESIZE_SYMBOL_RELOCS() if (obj->symbol_relocs_size++ >= obj->symbol_relocs_capacity) { obj->symbol_relocs_capacity = obj->symbol_relocs_capacity ? obj->symbol_relocs_capacity * 2 : 16; obj->symbol_relocs = realloc(obj->symbol_relocs, obj->symbol_relocs_capacity * sizeof(uint64_t)); }
#define RESIZE_ADRP_ADD_TABLE() if (obj->instr_addr_offsets_size++ >= obj->instr_addr_offsets_capacity) { obj->instr_addr_offsets_capacity = obj->instr_addr_offsets_capacity ? obj->instr_addr_offsets_capacity * 2 : 16; obj->instr_addr_offsets = realloc(obj->instr_addr_offsets, obj->instr_addr_offsets_capacity * sizeof(uint64_t)); }

static inline void symbol_reloc(section_t* obj) {
    RESIZE_SYMBOL_RELOCS();
    obj->symbol_relocs[obj->symbol_relocs_size - 1] = obj->comp_size;
}

static inline void add_instr_addr_offset(section_t* obj, uint64_t sym) {
    RESIZE_ADRP_ADD_TABLE();
    obj->instr_addr_offsets[obj->instr_addr_offsets_size - 1].is_instr_addr = 1;
    obj->instr_addr_offsets[obj->instr_addr_offsets_size - 1].symbol = sym;
    obj->instr_addr_offsets[obj->instr_addr_offsets_size - 1].offset = obj->size - 4;
}

static inline void add_imm_byte(section_t* obj, uint8_t byte) {
    RESIZE_CONTENTS();
    obj->contents[obj->contents_size - 1].type = file_insert_type_bytes;
    obj->contents[obj->contents_size - 1].bytes.data = malloc(sizeof(uint8_t));
    uint8_t* data = (uint8_t*) obj->contents[obj->contents_size - 1].bytes.data;
    *data = byte;
    obj->contents[obj->contents_size - 1].bytes.size = 1;
    obj->comp_size += 1;
}

static inline void compile_imm_byte(section_t* obj, uint8_t byte) {
    obj->data = realloc(obj->data, ++obj->size);
    obj->data[obj->size - 1] = byte;
}

static inline void add_imm_word(section_t* obj, uint16_t word) {
    RESIZE_CONTENTS();
    obj->contents[obj->contents_size - 1].type = file_insert_type_bytes;
    obj->contents[obj->contents_size - 1].bytes.data = malloc(sizeof(uint16_t));
    uint16_t* data = (uint16_t*) obj->contents[obj->contents_size - 1].bytes.data;
    *data = word;
    obj->contents[obj->contents_size - 1].bytes.size = 2;
    obj->comp_size += 2;
}

static inline void compile_imm_word(section_t* obj, uint16_t word) {
    obj->data = realloc(obj->data, obj->size + 2);
    uint16_t* data = (uint16_t*) &obj->data[obj->size];
    *data = word;
    obj->size += 2;
}

static inline void add_imm_dword(section_t* obj, uint32_t dword) {
    RESIZE_CONTENTS();
    obj->contents[obj->contents_size - 1].type = file_insert_type_bytes;
    obj->contents[obj->contents_size - 1].bytes.data = malloc(sizeof(uint32_t));
    uint32_t* data = (uint32_t*) obj->contents[obj->contents_size - 1].bytes.data;
    *data = dword;
    obj->contents[obj->contents_size - 1].bytes.size = 4;
    obj->comp_size += 4;
}

static inline void compile_imm_dword(section_t* obj, uint32_t dword) {
    obj->data = realloc(obj->data, obj->size + 4);
    uint32_t* data = (uint32_t*) &obj->data[obj->size];
    *data = dword;
    obj->size += 4;
}

static inline void add_imm_qword(section_t* obj, uint64_t qword) {
    RESIZE_CONTENTS();
    obj->contents[obj->contents_size - 1].type = file_insert_type_bytes;
    obj->contents[obj->contents_size - 1].bytes.data = malloc(sizeof(uint64_t));
    uint64_t* data = (uint64_t*) obj->contents[obj->contents_size - 1].bytes.data;
    *data = qword;
    obj->contents[obj->contents_size - 1].bytes.size = 8;
    obj->comp_size += 8;
}

static inline void compile_imm_qword(section_t* obj, uint64_t qword) {
    obj->data = realloc(obj->data, obj->size + 8);
    uint64_t* data = (uint64_t*) &obj->data[obj->size];
    *data = qword;
    obj->size += 8;
}

static inline void add_instruction(section_t* obj, struct instruction instr) {
    RESIZE_CONTENTS();
    obj->contents[obj->contents_size - 1].type = file_insert_type_instruction;
    obj->contents[obj->contents_size - 1].instruction = instr;
    obj->comp_size += 4;
}

static inline void add_bytes(section_t* obj, char* data, size_t count) {
    RESIZE_CONTENTS();
    obj->contents[obj->contents_size - 1].type = file_insert_type_bytes;
    obj->contents[obj->contents_size - 1].bytes.data = malloc(count);
    memcpy(obj->contents[obj->contents_size - 1].bytes.data, data, count);
    obj->contents[obj->contents_size - 1].bytes.size = count;
    obj->comp_size += count;
}

static inline void compile_bytes(section_t* obj, struct bytes bytes);
static inline void compile_instruction(section_t* obj, struct instruction instr);

static uint64_t symbol_index(section_t* obj, char* name) {
    for (uint64_t i = 0; i < obj->symbols_size; i++) {
        if (strcmp(obj->symbols[i].name, name) == 0) {
            return i;
        }
    }

    add_symbol(obj, (char*) name);
    obj->symbols[obj->symbols_size - 1].sym_addr = 0x8000000000000000 | (obj->symbols_size - 1);

    return obj->symbols_size - 1;
}

static inline void compile_bytes_or_instr(section_t* obj, file_insert_t insert) {
    switch (insert.type)
    {
    case file_insert_type_bytes:
        compile_bytes(obj, insert.bytes);
        break;
    case file_insert_type_instruction:
        compile_instruction(obj, insert.instruction);
        break;
    case file_insert_type_symbol:
        compile_imm_qword(obj, symbol_index(obj, insert.symbol));
        break;
    }
}

static inline void add_symbol_offset(section_t* obj, char* name) {
    RESIZE_CONTENTS();
    obj->contents[obj->contents_size - 1].type = file_insert_type_symbol;
    obj->contents[obj->contents_size - 1].symbol = name;
    symbol_reloc(obj);
    obj->comp_size += 8;
}

static inline void compile_bytes(section_t* obj, struct bytes bytes) {
    for (int i = 0; i < bytes.size; i++) {
        compile_imm_byte(obj, bytes.data[i]);
    }
}

static inline void compile_instruction(section_t* obj, struct instruction instr) {
    obj->size += 4;
    if (instr.encode == NULL) {
        printf("Instruction %02x has no encoder\n", instr.opcode);
        exit(1);
    }
    opcode_t op = instr.encode(obj, instr);
    obj->size -= 4;

    compile_imm_dword(obj, *(uint32_t*) &op);
}

/** nop
 * No operation
 * 
 * Pseudocode:
 * 
*/
#define opcode_nop                                      0x00
#define op_nop(...) (instruction_t) { .opcode = opcode_nop, .encode = encode_opcode_nop, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_nop(section_t* sect, struct instruction instr);

/** ret
 * Return from function
 * 
 * Pseudocode:
 * pc = lr
 * lr = stack[--sp]
*/
#define opcode_ret                                      0x01
#define op_ret(...) (instruction_t) { .opcode = opcode_ret, .encode = encode_opcode_ret, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_ret(section_t* sect, struct instruction instr);

/** irq
 * Interrupt
*/
#define opcode_irq                                      0x02
#define op_irq(...) (instruction_t) { .opcode = opcode_irq, .encode = encode_opcode_irq, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_irq(section_t* sect, struct instruction instr);

/** svc
 * Supervisor call
 * 
 * Pseudocode:
 * stack[sp++] = lr
 * lr = pc
 * pc = svc_handler[R0]
*/
#define opcode_svc                                      0x03
#define op_svc(...) (instruction_t) { .opcode = opcode_svc, .encode = encode_opcode_svc, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_svc(section_t* sect, struct instruction instr);

/** b label
 * Branches to the label
 * 
 * Pseudocode:
 * pc += label
*/
#define opcode_b_addr                                   0x04
#define op_b_addr(...) (instruction_t) { .opcode = opcode_b_addr, .encode = encode_opcode_b_addr, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_b_addr(section_t* sect, struct instruction instr);

/** bl label
 * Branches to the label and stores the return address in lr (old value pushed to stack)
 * 
 * Pseudocode:
 * stack[sp++] = lr
 * lr = pc
 * pc += label
*/
#define opcode_bl_addr                                  0x05
#define op_bl_addr(...) (instruction_t) { .opcode = opcode_bl_addr, .encode = encode_opcode_bl_addr, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_bl_addr(section_t* sect, struct instruction instr);

/** br r1
 * Branches to the address in r1
 * 
 * Pseudocode:
 * pc = r1
*/
#define opcode_br_reg                                   0x06
#define op_br_reg(...) (instruction_t) { .opcode = opcode_br_reg, .encode = encode_opcode_br_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_br_reg(section_t* sect, struct instruction instr);

/** blr r1
 * Branches to the address in r1 and stores the return address in lr (old value pushed to stack)
 * 
 * Pseudocode:
 * stack[sp++] = lr
 * lr = pc
 * pc = r1
*/
#define opcode_blr_reg                                  0x07
#define op_blr_reg(...) (instruction_t) { .opcode = opcode_blr_reg, .encode = encode_opcode_blr_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_blr_reg(section_t* sect, struct instruction instr);

/** <op>.eq <args>
 * Only executes the following instruction if the zero flag is set
 * 
 * Pseudocode:
 * if (zero_flag) ...
 * else pc += op.nbytes
*/
#define opcode_dot_eq                                   0x08
#define op_dot_eq(...) (instruction_t) { .opcode = opcode_dot_eq, .encode = encode_opcode_dot_eq, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_dot_eq(section_t* sect, struct instruction instr);

/** <op>.ne <args>
 * Only executes the following instruction if the zero flag is not set
 * 
 * Pseudocode:
 * if (!zero_flag) ...
 * else pc += op.nbytes
*/
#define opcode_dot_ne                                   0x09
#define op_dot_ne(...) (instruction_t) { .opcode = opcode_dot_ne, .encode = encode_opcode_dot_ne, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_dot_ne(section_t* sect, struct instruction instr);

/** <op>.lt <args>
 * Only executes the following instruction if the negative flag is set
 * 
 * Pseudocode:
 * if (negative_flag) ...
 * else pc += op.nbytes
*/
#define opcode_dot_lt                                   0x0A
#define op_dot_lt(...) (instruction_t) { .opcode = opcode_dot_lt, .encode = encode_opcode_dot_lt, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_dot_lt(section_t* sect, struct instruction instr);

/** <op>.gt <args>
 * Only executes the following instruction if the negative flag is not set
 * 
 * Pseudocode:
 * if (!negative_flag && !zero_flag) ...
 * else pc += op.nbytes
*/
#define opcode_dot_gt                                   0x0B
#define op_dot_gt(...) (instruction_t) { .opcode = opcode_dot_gt, .encode = encode_opcode_dot_gt, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_dot_gt(section_t* sect, struct instruction instr);

/** <op>.le <args>
 * Only executes the following instruction if the zero flag or the negative flag is set
 * 
 * Pseudocode:
 * if (zero_flag || negative_flag) ...
 * else pc += op.nbytes
*/
#define opcode_dot_le                                   0x0C
#define op_dot_le(...) (instruction_t) { .opcode = opcode_dot_le, .encode = encode_opcode_dot_le, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_dot_le(section_t* sect, struct instruction instr);

/** <op>.ge <args>
 * Only executes the following instruction if the zero flag or the negative flag is not set
 * 
 * Pseudocode:
 * if (!zero_flag && !negative_flag) ...
 * else pc += op.nbytes
*/
#define opcode_dot_ge                                   0x0D
#define op_dot_ge(...) (instruction_t) { .opcode = opcode_dot_ge, .encode = encode_opcode_dot_ge, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_dot_ge(section_t* sect, struct instruction instr);

/** <op>.cs <args>
 * Only executes the following instruction if the carry flag is set
 * 
 * Pseudocode:
 * if (carry_flag) ...
 * else pc += op.nbytes
*/
#define opcode_dot_cs                                   0x0E
#define op_dot_cs(...) (instruction_t) { .opcode = opcode_dot_cs, .encode = encode_opcode_dot_cs, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_dot_cs(section_t* sect, struct instruction instr);

/** <op>.cc <args>
 * Only executes the following instruction if the carry flag is not set
 * 
 * Pseudocode:
 * if (!carry_flag) ...
 * else pc += op.nbytes
*/
#define opcode_dot_cc                                   0x0F
#define op_dot_cc(...) (instruction_t) { .opcode = opcode_dot_cc, .encode = encode_opcode_dot_cc, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_dot_cc(section_t* sect, struct instruction instr);

/** add r1, r2, r3
 * Adds r2 and r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 + r3
*/
#define opcode_add_reg_reg_reg                          0x10
#define op_add_reg_reg_reg(...) (instruction_t) { .opcode = opcode_add_reg_reg_reg, .encode = encode_opcode_add_reg_reg_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_add_reg_reg_reg(section_t* sect, struct instruction instr);

/** sub r1, r2, r3
 * Subtracts r3 from r2 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 - r3
*/
#define opcode_sub_reg_reg_reg                          0x11
#define op_sub_reg_reg_reg(...) (instruction_t) { .opcode = opcode_sub_reg_reg_reg, .encode = encode_opcode_sub_reg_reg_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_sub_reg_reg_reg(section_t* sect, struct instruction instr);

/** mul r1, r2, r3
 * Multiplies r2 and r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 * r3
*/
#define opcode_mul_reg_reg_reg                          0x12
#define op_mul_reg_reg_reg(...) (instruction_t) { .opcode = opcode_mul_reg_reg_reg, .encode = encode_opcode_mul_reg_reg_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_mul_reg_reg_reg(section_t* sect, struct instruction instr);

/** div r1, r2, r3
 * Divides r2 by r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 / r3
*/
#define opcode_div_reg_reg_reg                          0x13
#define op_div_reg_reg_reg(...) (instruction_t) { .opcode = opcode_div_reg_reg_reg, .encode = encode_opcode_div_reg_reg_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_div_reg_reg_reg(section_t* sect, struct instruction instr);

/** mod r1, r2, r3
 * Computes the remainder of r2 divided by r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 % r3
*/
#define opcode_mod_reg_reg_reg                          0x14
#define op_mod_reg_reg_reg(...) (instruction_t) { .opcode = opcode_mod_reg_reg_reg, .encode = encode_opcode_mod_reg_reg_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_mod_reg_reg_reg(section_t* sect, struct instruction instr);

/** and r1, r2, r3
 * Computes the bitwise AND of r2 and r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 & r3
*/
#define opcode_and_reg_reg_reg                          0x15
#define op_and_reg_reg_reg(...) (instruction_t) { .opcode = opcode_and_reg_reg_reg, .encode = encode_opcode_and_reg_reg_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_and_reg_reg_reg(section_t* sect, struct instruction instr);

/** or r1, r2, r3
 * Computes the bitwise OR of r2 and r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 | r3
*/
#define opcode_or_reg_reg_reg                           0x16
#define op_or_reg_reg_reg(...) (instruction_t) { .opcode = opcode_or_reg_reg_reg, .encode = encode_opcode_or_reg_reg_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_or_reg_reg_reg(section_t* sect, struct instruction instr);

/** xor r1, r2, r3
 * Computes the bitwise XOR of r2 and r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 ^ r3
*/
#define opcode_xor_reg_reg_reg                          0x17
#define op_xor_reg_reg_reg(...) (instruction_t) { .opcode = opcode_xor_reg_reg_reg, .encode = encode_opcode_xor_reg_reg_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_xor_reg_reg_reg(section_t* sect, struct instruction instr);

/** shl r1, r2, r3
 * Shifts the bits in r2 to the left by the number of bits specified in r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 << r3
*/
#define opcode_shl_reg_reg_reg                          0x18
#define op_shl_reg_reg_reg(...) (instruction_t) { .opcode = opcode_shl_reg_reg_reg, .encode = encode_opcode_shl_reg_reg_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_shl_reg_reg_reg(section_t* sect, struct instruction instr);

/** shr r1, r2, r3
 * Shifts the bits in r2 to the right by the number of bits specified in r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 >> r3
*/
#define opcode_shr_reg_reg_reg                          0x19
#define op_shr_reg_reg_reg(...) (instruction_t) { .opcode = opcode_shr_reg_reg_reg, .encode = encode_opcode_shr_reg_reg_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_shr_reg_reg_reg(section_t* sect, struct instruction instr);

/** rol r1, r2, r3
 * Rotates the bits in r2 to the left by the number of bits specified in r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 <<< r3
*/
#define opcode_rol_reg_reg_reg                          0x1A
#define op_rol_reg_reg_reg(...) (instruction_t) { .opcode = opcode_rol_reg_reg_reg, .encode = encode_opcode_rol_reg_reg_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_rol_reg_reg_reg(section_t* sect, struct instruction instr);

/** ror r1, r2, r3
 * Rotates the bits in r2 to the right by the number of bits specified in r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 >>> r3
*/
#define opcode_ror_reg_reg_reg                          0x1B
#define op_ror_reg_reg_reg(...) (instruction_t) { .opcode = opcode_ror_reg_reg_reg, .encode = encode_opcode_ror_reg_reg_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_ror_reg_reg_reg(section_t* sect, struct instruction instr);

/** inc r1
 * Increments r1 by 1
 * 
 * Pseudocode:
 * r1++
*/
#define opcode_inc_reg                                  0x1C
#define op_inc_reg(...) (instruction_t) { .opcode = opcode_inc_reg, .encode = encode_opcode_inc_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_inc_reg(section_t* sect, struct instruction instr);

/** dec r1
 * Decrements r1 by 1
 * 
 * Pseudocode:
 * r1--
*/
#define opcode_dec_reg                                  0x1D
#define op_dec_reg(...) (instruction_t) { .opcode = opcode_dec_reg, .encode = encode_opcode_dec_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_dec_reg(section_t* sect, struct instruction instr);

/** psh r1
 * Pushes the value of r1 onto the stack
 * 
 * Pseudocode:
 * stack[sp++] = r1
*/
#define opcode_psh_reg                                  0x1E
#define op_psh_reg(...) (instruction_t) { .opcode = opcode_psh_reg, .encode = encode_opcode_psh_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_psh_reg(section_t* sect, struct instruction instr);

/** pp r1
 * Pops the value of the stack into r1
 * 
 * Pseudocode:
 * r1 = stack[--sp]
*/
#define opcode_pp_reg                                   0x1F
#define op_pp_reg(...) (instruction_t) { .opcode = opcode_pp_reg, .encode = encode_opcode_pp_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_pp_reg(section_t* sect, struct instruction instr);

/** ldr r1, r2
 * Loads the value of r2 into r1
 * 
 * Pseudocode:
 * r1 = r2
*/
#define opcode_ldr_reg_reg                              0x20
#define op_ldr_reg_reg(...) (instruction_t) { .opcode = opcode_ldr_reg_reg, .encode = encode_opcode_ldr_reg_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_ldr_reg_reg(section_t* sect, struct instruction instr);

/** ldr r1, [r2 + 0x12]
 * Loads the value of the memory at the address in r2 + 0x12 into r1
 * 
 * Pseudocode:
 * r1 = *(r2 + 0x12)
*/
#define opcode_ldr_reg_addr_imm                         0x21
#define op_ldr_reg_addr_imm(...) (instruction_t) { .opcode = opcode_ldr_reg_addr_imm, .encode = encode_opcode_ldr_reg_addr_imm, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_ldr_reg_addr_imm(section_t* sect, struct instruction instr);

/** ldr r1, [r2 + r3]
 * Loads the value of the memory at the address in r2 + r3 into r1
 * 
 * Pseudocode:
 * r1 = *(r2 + r3)
*/
#define opcode_ldr_reg_addr_reg                         0x22
#define op_ldr_reg_addr_reg(...) (instruction_t) { .opcode = opcode_ldr_reg_addr_reg, .encode = encode_opcode_ldr_reg_addr_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_ldr_reg_addr_reg(section_t* sect, struct instruction instr);

/** str [r1], r2
 * Stores the value of r2 into the memory at the address in r1
 * 
 * Pseudocode:
 * *r1 = r2
*/
#define opcode_str_reg_reg                              0x25
#define op_str_reg_reg(...) (instruction_t) { .opcode = opcode_str_reg_reg, .encode = encode_opcode_str_reg_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_str_reg_reg(section_t* sect, struct instruction instr);

/** str [r1 + r2], r3
 * Stores the value of r3 into the memory at the address in r1 + r2
 * 
 * Pseudocode:
 * *(r1 + r2) = r3
*/
#define opcode_str_reg_addr_reg                         0x26
#define op_str_reg_addr_reg(...) (instruction_t) { .opcode = opcode_str_reg_addr_reg, .encode = encode_opcode_str_reg_addr_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_str_reg_addr_reg(section_t* sect, struct instruction instr);

/** movz r1, 0x1234 shl n
 * Zeroes r1 and moves the immediate value shifted by n into r1
 * n must be a multiple of 16
 * 
 * Pseudocode:
 * r1 = imm
*/
#define opcode_movz                                     0x28
#define op_movz(...) (instruction_t) { .opcode = opcode_movz, .encode = encode_opcode_movz, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_movz(section_t* sect, struct instruction instr);

/** movk r1, 0x1234 shl n
 * Moves the immediate value shifted by n into r1
 * Only the bits at location n are changed
 * n must be a multiple of 16
 * 
 * Pseudocode:
 * r1 = imm << 16
*/
#define opcode_movk                                     0x29
#define op_movk(...) (instruction_t) { .opcode = opcode_movk, .encode = encode_opcode_movk, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_movk(section_t* sect, struct instruction instr);

/** adrp r1, label
 * Loads the high 16 bits of the offset of the label from pc into r1
 * 
 * Pseudocode:
 * r1 = pc + (label & 0xffff0000)
*/
#define opcode_adrp_reg_addr                            0x2A
#define op_adrp_reg_addr(...) (instruction_t) { .opcode = opcode_adrp_reg_addr, .encode = encode_opcode_adrp_reg_addr, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_adrp_reg_addr(section_t* sect, struct instruction instr);

/** adp r1, label
 * Adds the low 16 bits of the offset of the label from pc to r1
 * Assumes that the high bits of the offset have already been loaded into r1 by adrp
 * 
 * Pseudocode:
 * r1 += label & 0x0000ffff
*/
#define opcode_adp_reg_addr                             0x2B
#define op_adp_reg_addr(...) (instruction_t) { .opcode = opcode_adp_reg_addr, .encode = encode_opcode_adp_reg_addr, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_adp_reg_addr(section_t* sect, struct instruction instr);

/** cmp r1, r2
 * Compares r1 and r2 and updates the zero and carry flags accordingly
 * 
 * Pseudocode:
 * zero_flag = r1 == r2
 * negative_flag = r1 < r2
*/
#define opcode_cmp_reg_reg                              0x2D
#define op_cmp_reg_reg(...) (instruction_t) { .opcode = opcode_cmp_reg_reg, .encode = encode_opcode_cmp_reg_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_cmp_reg_reg(section_t* sect, struct instruction instr);

/** xchg r1, r2
 * Swaps the values of r1 and r2
 * 
 * Pseudocode:
 * tmp = r1
 * r1 = r2
 * r2 = tmp
*/
#define opcode_xchg_reg_reg                             0x2E
#define op_xchg_reg_reg(...) (instruction_t) { .opcode = opcode_xchg_reg_reg, .encode = encode_opcode_xchg_reg_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_xchg_reg_reg(section_t* sect, struct instruction instr);

/** cmpxchg r1, r2
 * Compares r1 and r2 and updates the zero and carry flags accordingly
 * Swaps the values of r1 and r2 if the negative flag is set
 * 
 * Pseudocode:
 * zero_flag = r1 == r2
 * negative_flag = r1 < r2
 * if (negative_flag) {
 *    tmp = r1
 *    r1 = r2
 *    r2 = tmp
 * }
*/
#define opcode_cmpxchg_reg_reg                          0x2F
#define op_cmpxchg_reg_reg(...) (instruction_t) { .opcode = opcode_cmpxchg_reg_reg, .encode = encode_opcode_cmpxchg_reg_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_cmpxchg_reg_reg(section_t* sect, struct instruction instr);

/** add r1, 0x1234
 * Adds the immediate value to r1 and stores the result in r1
 * 
 * Pseudocode:
 * r1 += imm
*/
#define opcode_add_reg_imm                              0x30
#define op_add_reg_imm(...) (instruction_t) { .opcode = opcode_add_reg_imm, .encode = encode_opcode_add_reg_imm, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_add_reg_imm(section_t* sect, struct instruction instr);

/** sub r1, 0x1234
 * Subtracts r2 from r1 and stores the result in r1
 * 
 * Pseudocode:
 * r1 -= r2
*/
#define opcode_sub_reg_imm                              0x31
#define op_sub_reg_imm(...) (instruction_t) { .opcode = opcode_sub_reg_imm, .encode = encode_opcode_sub_reg_imm, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_sub_reg_imm(section_t* sect, struct instruction instr);

/** mul r1, 0x1234
 * Multiplies r1 by r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 *= r2
*/
#define opcode_mul_reg_imm                              0x32
#define op_mul_reg_imm(...) (instruction_t) { .opcode = opcode_mul_reg_imm, .encode = encode_opcode_mul_reg_imm, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_mul_reg_imm(section_t* sect, struct instruction instr);

/** div r1, 0x1234
 * Divides r1 by r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 /= r2
*/
#define opcode_div_reg_imm                              0x33
#define op_div_reg_imm(...) (instruction_t) { .opcode = opcode_div_reg_imm, .encode = encode_opcode_div_reg_imm, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_div_reg_imm(section_t* sect, struct instruction instr);

/** mod r1, 0x1234
 * Computes the remainder of r1 divided by r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 %= r2
*/
#define opcode_mod_reg_imm                              0x34
#define op_mod_reg_imm(...) (instruction_t) { .opcode = opcode_mod_reg_imm, .encode = encode_opcode_mod_reg_imm, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_mod_reg_imm(section_t* sect, struct instruction instr);

/** and r1, 0x1234
 * Computes the bitwise AND of r1 and r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 &= r2
*/
#define opcode_and_reg_imm                              0x35
#define op_and_reg_imm(...) (instruction_t) { .opcode = opcode_and_reg_imm, .encode = encode_opcode_and_reg_imm, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_and_reg_imm(section_t* sect, struct instruction instr);

/** or r1, 0x1234
 * Computes the bitwise OR of r1 and r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 |= r2
*/
#define opcode_or_reg_imm                               0x36
#define op_or_reg_imm(...) (instruction_t) { .opcode = opcode_or_reg_imm, .encode = encode_opcode_or_reg_imm, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_or_reg_imm(section_t* sect, struct instruction instr);

/** xor r1, 0x1234
 * Computes the bitwise XOR of r1 and r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 ^= r2
*/
#define opcode_xor_reg_imm                              0x37
#define op_xor_reg_imm(...) (instruction_t) { .opcode = opcode_xor_reg_imm, .encode = encode_opcode_xor_reg_imm, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_xor_reg_imm(section_t* sect, struct instruction instr);

/** shl r1, 0x1234
 * Shifts the bits of r1 to the left by r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 <<= r2
*/
#define opcode_shl_reg_imm                              0x38
#define op_shl_reg_imm(...) (instruction_t) { .opcode = opcode_shl_reg_imm, .encode = encode_opcode_shl_reg_imm, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_shl_reg_imm(section_t* sect, struct instruction instr);

/** shr r1, 0x1234
 * Shifts the bits of r1 to the right by r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 >>= r2
*/
#define opcode_shr_reg_imm                              0x39
#define op_shr_reg_imm(...) (instruction_t) { .opcode = opcode_shr_reg_imm, .encode = encode_opcode_shr_reg_imm, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_shr_reg_imm(section_t* sect, struct instruction instr);

/** rol r1, 0x1234
 * Rotates the bits of r1 to the left by r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 = (r1 << r2) | (r1 >> (64 - r2))
*/
#define opcode_rol_reg_imm                              0x3A
#define op_rol_reg_imm(...) (instruction_t) { .opcode = opcode_rol_reg_imm, .encode = encode_opcode_rol_reg_imm, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_rol_reg_imm(section_t* sect, struct instruction instr);

/** ror r1, 0x1234
 * Rotates the bits of r1 to the right by r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 = (r1 >> r2) | (r1 << (64 - r2))
*/
#define opcode_ror_reg_imm                              0x3B
#define op_ror_reg_imm(...) (instruction_t) { .opcode = opcode_ror_reg_imm, .encode = encode_opcode_ror_reg_imm, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_ror_reg_imm(section_t* sect, struct instruction instr);

/** not r1
 * Computes the bitwise NOT of r1 and stores the result in r1
 * 
 * Pseudocode:
 * r1 = ~r1
*/
#define opcode_not_reg                                  0x3C
#define op_not_reg(...) (instruction_t) { .opcode = opcode_not_reg, .encode = encode_opcode_not_reg, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_not_reg(section_t* sect, struct instruction instr);

/** psh 0x1234
 * Pushes the immediate value onto the stack
 * 
 * Pseudocode:
 * stack[sp++] = imm
*/
#define opcode_psh_imm                                  0x3E
#define op_psh_imm(...) (instruction_t) { .opcode = opcode_psh_imm, .encode = encode_opcode_psh_imm, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_psh_imm(section_t* sect, struct instruction instr);

/** psh label
 * Pushes the address of the label onto the stack
 * 
 * Pseudocode:
 * stack[sp++] = pc + label
*/
#define opcode_psh_addr                                 0x3F
#define op_psh_addr(...) (instruction_t) { .opcode = opcode_psh_addr, .encode = encode_opcode_psh_addr, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_psh_addr(section_t* sect, struct instruction instr);

/** pause
 * Pauses the CPU until an interrupt is received
 * 
 * Pseudocode:
 * while (!interrupt_flag) {}
*/
#define opcode_pause                                    0x40
#define op_pause(...) (instruction_t) { .opcode = opcode_pause, .encode = encode_opcode_pause, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_pause(section_t* sect, struct instruction instr);

/** <op>.byte <args> / <op>.word <args> / <op>.dword <args> / <op>.qword <args>
 * Changes the addressing mode of the following instruction
*/
#define opcode_dot_addressing_override                  0x48
#define op_dot_addressing_override(...) (instruction_t) { .opcode = opcode_dot_addressing_override, .encode = encode_opcode_dot_addressing_override, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_dot_addressing_override(section_t* sect, struct instruction instr);

/** .symbol
 * Internal instruction used to mark the location of a symbol (does not have a mnemonic)
*/
#define opcode_dot_symbol                               0x49
#define op_dot_symbol(...) (instruction_t) { .opcode = opcode_dot_symbol, .encode = encode_opcode_dot_symbol, .args = { __VA_ARGS__ } }
opcode_t encode_opcode_dot_symbol(section_t* sect, struct instruction instr);
