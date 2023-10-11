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

#define PACKED __attribute__((packed))

typedef struct section section_t;

typedef struct instruction {
    uint8_t         opcode;
    instr_arg       args[4];
    uint32_t        (*encode)(section_t* sect, struct instruction instr);
} instruction_t;

typedef struct opcode {
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
        uint8_t     r PACKED;
        uint8_t     u8 PACKED;

        uint32_t    args_raw: 24 PACKED;
    }               args PACKED;
    uint8_t         opcode PACKED;
} opcode_t;

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
    uint64_t        offset;
    uint64_t        symbol;
} relocation_info_t;

#define SYMBOL_NAME_LEN_MAX 64

typedef struct symbol_t {
    uint64_t        sym_addr PACKED;
    uint64_t        section PACKED;
    char*           name PACKED;
    uint8_t         is_global PACKED;
} symbol_t;

struct section {
    uint16_t        type;
    uint16_t        sect_flags;
    uint64_t        size;
    uint8_t*        data;

    // compilation only
    file_insert_t*  contents;
    uint64_t        contents_size;
    uint64_t        contents_capacity;
    
    uint64_t        comp_size;
    
    uint64_t        symbol_relocs_size;
    uint64_t        symbol_relocs_capacity;
    uint64_t*       symbol_relocs;

    uint16_t        symbols_size;
    symbol_t*       symbols;

    uint16_t        globals_size;
    char**          globals;
};

typedef struct load_command {
    char            cmd[16];
    uint32_t        size;
    uint8_t*        data;
    uint32_t        section;
} load_command_t;

#define OBJECT_FILE_MAGIC 0xfeedface
#define OBJECT_FILE_VERSION 1

typedef struct object {
    uint32_t        magic;
    uint32_t        version;
    uint32_t        flags;
    uint32_t        commands_count;
    load_command_t**commands;
    uint32_t        sections_count;
    section_t**     sections;

    uint8_t         relocated;
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

static inline section_t** find_sections(object_file_t* obj, uint16_t type) {
    section_t** sections = malloc(sizeof(section_t*) * obj->sections_count);
    uint32_t count = 0;
    for (uint32_t i = 0; i < obj->sections_count; i++) {
        if (obj->sections[i]->type == type) {
            sections[count++] = obj->sections[i];
        }
    }
    return sections;
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
    
    obj.flags = NEXT(uint32_t);
    obj.commands_count = NEXT(uint32_t);
    obj.sections_count = NEXT(uint32_t);

    if (obj.commands_count) {
        obj.commands = malloc(obj.commands_count * sizeof(load_command_t));
        for (uint32_t i = 0; i < obj.commands_count; i++) {
            obj.commands[i] = malloc(sizeof(load_command_t));
            for (int k = 0; k < sizeof(obj.commands[i]->cmd); k++) {
                obj.commands[i]->cmd[k] = NEXT(char);
            }
            obj.commands[i]->size = NEXT(uint32_t);
            obj.commands[i]->data = malloc(obj.commands[i]->size);
            for (uint32_t j = 0; j < obj.commands[i]->size; j++) {
                obj.commands[i]->data[j] = NEXT(uint8_t);
            }
        }
    }
    if (obj.sections_count) {
        obj.sections = malloc(obj.sections_count * sizeof(section_t*));
        for (uint32_t i = 0; i < obj.sections_count; i++) {
            obj.sections[i] = malloc(sizeof(section_t));
            obj.sections[i]->type = NEXT(uint16_t);
            obj.sections[i]->sect_flags = NEXT(uint16_t);
            obj.sections[i]->size = NEXT(uint64_t);
            obj.sections[i]->data = align_alloc(sysconf(_SC_PAGESIZE), obj.sections[i]->size);
            for (uint32_t j = 0; j < obj.sections[i]->size; j++) {
                obj.sections[i]->data[j] = NEXT(uint8_t);
            }
        }
    }

    section_t** symtab = find_sections(&obj, SECTION_TYPE_DATA);
    uint64_t symbols_count = *(uint64_t*) symtab[0]->data;
    symbol_t* symbols = malloc(symbols_count * sizeof(symbol_t));

    uint64_t ptr = sizeof(uint64_t);
    for (uint64_t j = 0; j < symbols_count; j++) {
        symbol_t* sym = (symbol_t*) (symtab[0]->data + ptr);

        symbols[j].sym_addr = sym->sym_addr;
        symbols[j].section = sym->section;

        char* name = (char*) sym + hive_offsetof(symbol_t, name);
        symbols[j].name = malloc(strlen(name) + 1);
        strcpy(symbols[j].name, name);
        
        ptr += (sizeof(symbol_t) - sizeof(char*)) + strlen(name) + 1;
    }

    for (uint64_t j = 0; j < symbols_count; j++) {
        uint64_t addr = symbols[j].sym_addr;
        if ((addr & 0x8000000000000000) == 0) {
            symbols[j].sym_addr += (uint64_t) obj.sections[symbols[j].section]->data;
        }
    }

    symtab[0]->data = (uint8_t*) symbols;
    symtab[0]->size = symbols_count * sizeof(symbol_t);

    return obj;
}

static inline object_file_t create_translation_unit() {
    object_file_t file;

    file.magic = OBJECT_FILE_MAGIC;
    file.version = OBJECT_FILE_VERSION;
    file.flags = 0;
    file.commands_count = 0;
    file.commands = NULL;
    file.sections_count = 0;
    file.sections = NULL;

    return file;
}

static inline load_command_t** find_load_commands(object_file_t* obj, char* cmd) {
    load_command_t** commands = malloc(sizeof(load_command_t*) * obj->commands_count);
    uint32_t count = 0;
    for (uint32_t i = 0; i < obj->commands_count; i++) {
        if (strncmp(obj->commands[i]->cmd, cmd, 16) == 0) {
            commands[count++] = obj->commands[i];
        }
    }
    return commands;
}

static inline section_t* new_section(object_file_t* file, uint16_t type, uint64_t size, uint8_t* data) {
    file->sections_count++;
    file->sections = realloc(file->sections, file->sections_count * sizeof(section_t));
    file->sections[file->sections_count - 1] = malloc(sizeof(section_t));
    file->sections[file->sections_count - 1]->type = type;
    file->sections[file->sections_count - 1]->size = size;
    file->sections[file->sections_count - 1]->data = data;
    return file->sections[file->sections_count - 1];
}

static inline void add_section(object_file_t* file, section_t* sect) {
    file->sections_count++;
    file->sections = realloc(file->sections, file->sections_count * sizeof(section_t));
    file->sections[file->sections_count - 1] = sect;
}

static inline load_command_t* new_load_command(object_file_t* file, char* cmd) {
    file->commands_count++;
    file->commands = realloc(file->commands, file->commands_count * sizeof(load_command_t));
    load_command_t* command = malloc(sizeof(load_command_t));
    file->commands[file->commands_count - 1] = command;
    memcpy(command->cmd, cmd, strlen(cmd));
    command->size = 0;
    return command;
}

static inline void write_translation_unit(object_file_t* obj, FILE* fp) {
    fwrite(&obj->magic, sizeof(uint32_t), 1, fp);
    fwrite(&obj->version, sizeof(uint32_t), 1, fp);
    fwrite(&obj->flags, sizeof(uint32_t), 1, fp);
    fwrite(&obj->commands_count, sizeof(uint32_t), 1, fp);
    fwrite(&obj->sections_count, sizeof(uint32_t), 1, fp);
    for (uint32_t i = 0; i < obj->commands_count; i++) {
        fwrite(&obj->commands[i]->cmd, sizeof(char), 16, fp);
        fwrite(&obj->commands[i]->size, sizeof(uint32_t), 1, fp);
        fwrite(obj->commands[i]->data, sizeof(uint8_t), obj->commands[i]->size, fp);
    }
    for (uint32_t i = 0; i < obj->sections_count; i++) {
        fwrite(&obj->sections[i]->type, sizeof(uint16_t), 1, fp);
        fwrite(&obj->sections[i]->sect_flags, sizeof(uint16_t), 1, fp);
        fwrite(&obj->sections[i]->size, sizeof(uint64_t), 1, fp);
        fwrite(obj->sections[i]->data, sizeof(uint8_t), obj->sections[i]->size, fp);
    }
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

int16_t symbol_offset(section_t* obj, const char *name);
int add_symbol(section_t* obj, const char* name);

#define CODE(name) add_symbol(obj, name)
#define DATA(name) add_symbol(obj, name)
#define ASCII(str) add_bytes(obj, str, strlen(str))
#define ASCIZ(str) add_bytes(obj, str, strlen(str) + 1)

#define RESIZE_CONTENTS() if (obj->contents_size++ == obj->contents_capacity) { obj->contents_capacity = obj->contents_capacity ? obj->contents_capacity * 2 : 16; obj->contents = realloc(obj->contents, obj->contents_capacity * sizeof(file_insert_t)); }
#define RESIZE_SYMBOL_RELOCS() if (obj->symbol_relocs_size++ == obj->symbol_relocs_capacity) { obj->symbol_relocs_capacity = obj->symbol_relocs_capacity ? obj->symbol_relocs_capacity * 2 : 16; obj->symbol_relocs = realloc(obj->symbol_relocs, obj->symbol_relocs_capacity * sizeof(uint64_t)); }

static inline void symbol_reloc(section_t* obj) {
    RESIZE_SYMBOL_RELOCS();
    obj->symbol_relocs[obj->symbol_relocs_size - 1] = obj->comp_size;
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
    obj->symbols[obj->symbols_size - 1].is_global = 1;

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
    uint32_t op = instr.encode(obj, instr);
    obj->size -= 4;

    compile_imm_dword(obj, op);
}

/** nop
 * No operation
 * 
 * Pseudocode:
 * 
*/
#define opcode_nop                                      0x00
#define op_nop(...) (instruction_t) { .opcode = opcode_nop, .encode = encode_opcode_nop, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_nop(section_t* sect, struct instruction instr);

/** ret
 * Return from function
 * 
 * Pseudocode:
 * pc = lr
 * lr = stack[--sp]
*/
#define opcode_ret                                      0x01
#define op_ret(...) (instruction_t) { .opcode = opcode_ret, .encode = encode_opcode_ret, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_ret(section_t* sect, struct instruction instr);

/** irq
 * Interrupt
*/
#define opcode_irq                                      0x02
#define op_irq(...) (instruction_t) { .opcode = opcode_irq, .encode = encode_opcode_irq, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_irq(section_t* sect, struct instruction instr);

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
uint32_t encode_opcode_svc(section_t* sect, struct instruction instr);

/** b label
 * Branches to the label
 * 
 * Pseudocode:
 * pc += label
*/
#define opcode_b_addr                                   0x04
#define op_b_addr(...) (instruction_t) { .opcode = opcode_b_addr, .encode = encode_opcode_b_addr, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_b_addr(section_t* sect, struct instruction instr);

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
uint32_t encode_opcode_bl_addr(section_t* sect, struct instruction instr);

/** br r1
 * Branches to the address in r1
 * 
 * Pseudocode:
 * pc = r1
*/
#define opcode_br_reg                                   0x06
#define op_br_reg(...) (instruction_t) { .opcode = opcode_br_reg, .encode = encode_opcode_br_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_br_reg(section_t* sect, struct instruction instr);

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
uint32_t encode_opcode_blr_reg(section_t* sect, struct instruction instr);

/** <op>.eq <args>
 * Only executes the following instruction if the zero flag is set
 * 
 * Pseudocode:
 * if (zero_flag) ...
 * else pc += op.nbytes
*/
#define opcode_dot_eq                                   0x08
#define op_dot_eq(...) (instruction_t) { .opcode = opcode_dot_eq, .encode = encode_opcode_dot_eq, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_dot_eq(section_t* sect, struct instruction instr);

/** <op>.ne <args>
 * Only executes the following instruction if the zero flag is not set
 * 
 * Pseudocode:
 * if (!zero_flag) ...
 * else pc += op.nbytes
*/
#define opcode_dot_ne                                   0x09
#define op_dot_ne(...) (instruction_t) { .opcode = opcode_dot_ne, .encode = encode_opcode_dot_ne, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_dot_ne(section_t* sect, struct instruction instr);

/** <op>.lt <args>
 * Only executes the following instruction if the negative flag is set
 * 
 * Pseudocode:
 * if (negative_flag) ...
 * else pc += op.nbytes
*/
#define opcode_dot_lt                                   0x0A
#define op_dot_lt(...) (instruction_t) { .opcode = opcode_dot_lt, .encode = encode_opcode_dot_lt, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_dot_lt(section_t* sect, struct instruction instr);

/** <op>.gt <args>
 * Only executes the following instruction if the negative flag is not set
 * 
 * Pseudocode:
 * if (!negative_flag && !zero_flag) ...
 * else pc += op.nbytes
*/
#define opcode_dot_gt                                   0x0B
#define op_dot_gt(...) (instruction_t) { .opcode = opcode_dot_gt, .encode = encode_opcode_dot_gt, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_dot_gt(section_t* sect, struct instruction instr);

/** <op>.le <args>
 * Only executes the following instruction if the zero flag or the negative flag is set
 * 
 * Pseudocode:
 * if (zero_flag || negative_flag) ...
 * else pc += op.nbytes
*/
#define opcode_dot_le                                   0x0C
#define op_dot_le(...) (instruction_t) { .opcode = opcode_dot_le, .encode = encode_opcode_dot_le, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_dot_le(section_t* sect, struct instruction instr);

/** <op>.ge <args>
 * Only executes the following instruction if the zero flag or the negative flag is not set
 * 
 * Pseudocode:
 * if (!zero_flag && !negative_flag) ...
 * else pc += op.nbytes
*/
#define opcode_dot_ge                                   0x0D
#define op_dot_ge(...) (instruction_t) { .opcode = opcode_dot_ge, .encode = encode_opcode_dot_ge, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_dot_ge(section_t* sect, struct instruction instr);

/** <op>.cs <args>
 * Only executes the following instruction if the carry flag is set
 * 
 * Pseudocode:
 * if (carry_flag) ...
 * else pc += op.nbytes
*/
#define opcode_dot_cs                                   0x0E
#define op_dot_cs(...) (instruction_t) { .opcode = opcode_dot_cs, .encode = encode_opcode_dot_cs, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_dot_cs(section_t* sect, struct instruction instr);

/** <op>.cc <args>
 * Only executes the following instruction if the carry flag is not set
 * 
 * Pseudocode:
 * if (!carry_flag) ...
 * else pc += op.nbytes
*/
#define opcode_dot_cc                                   0x0F
#define op_dot_cc(...) (instruction_t) { .opcode = opcode_dot_cc, .encode = encode_opcode_dot_cc, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_dot_cc(section_t* sect, struct instruction instr);

/** add r1, r2, r3
 * Adds r2 and r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 + r3
*/
#define opcode_add_reg_reg_reg                          0x10
#define op_add_reg_reg_reg(...) (instruction_t) { .opcode = opcode_add_reg_reg_reg, .encode = encode_opcode_add_reg_reg_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_add_reg_reg_reg(section_t* sect, struct instruction instr);

/** sub r1, r2, r3
 * Subtracts r3 from r2 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 - r3
*/
#define opcode_sub_reg_reg_reg                          0x11
#define op_sub_reg_reg_reg(...) (instruction_t) { .opcode = opcode_sub_reg_reg_reg, .encode = encode_opcode_sub_reg_reg_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_sub_reg_reg_reg(section_t* sect, struct instruction instr);

/** mul r1, r2, r3
 * Multiplies r2 and r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 * r3
*/
#define opcode_mul_reg_reg_reg                          0x12
#define op_mul_reg_reg_reg(...) (instruction_t) { .opcode = opcode_mul_reg_reg_reg, .encode = encode_opcode_mul_reg_reg_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_mul_reg_reg_reg(section_t* sect, struct instruction instr);

/** div r1, r2, r3
 * Divides r2 by r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 / r3
*/
#define opcode_div_reg_reg_reg                          0x13
#define op_div_reg_reg_reg(...) (instruction_t) { .opcode = opcode_div_reg_reg_reg, .encode = encode_opcode_div_reg_reg_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_div_reg_reg_reg(section_t* sect, struct instruction instr);

/** mod r1, r2, r3
 * Computes the remainder of r2 divided by r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 % r3
*/
#define opcode_mod_reg_reg_reg                          0x14
#define op_mod_reg_reg_reg(...) (instruction_t) { .opcode = opcode_mod_reg_reg_reg, .encode = encode_opcode_mod_reg_reg_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_mod_reg_reg_reg(section_t* sect, struct instruction instr);

/** and r1, r2, r3
 * Computes the bitwise AND of r2 and r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 & r3
*/
#define opcode_and_reg_reg_reg                          0x15
#define op_and_reg_reg_reg(...) (instruction_t) { .opcode = opcode_and_reg_reg_reg, .encode = encode_opcode_and_reg_reg_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_and_reg_reg_reg(section_t* sect, struct instruction instr);

/** or r1, r2, r3
 * Computes the bitwise OR of r2 and r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 | r3
*/
#define opcode_or_reg_reg_reg                           0x16
#define op_or_reg_reg_reg(...) (instruction_t) { .opcode = opcode_or_reg_reg_reg, .encode = encode_opcode_or_reg_reg_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_or_reg_reg_reg(section_t* sect, struct instruction instr);

/** xor r1, r2, r3
 * Computes the bitwise XOR of r2 and r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 ^ r3
*/
#define opcode_xor_reg_reg_reg                          0x17
#define op_xor_reg_reg_reg(...) (instruction_t) { .opcode = opcode_xor_reg_reg_reg, .encode = encode_opcode_xor_reg_reg_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_xor_reg_reg_reg(section_t* sect, struct instruction instr);

/** shl r1, r2, r3
 * Shifts the bits in r2 to the left by the number of bits specified in r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 << r3
*/
#define opcode_shl_reg_reg_reg                          0x18
#define op_shl_reg_reg_reg(...) (instruction_t) { .opcode = opcode_shl_reg_reg_reg, .encode = encode_opcode_shl_reg_reg_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_shl_reg_reg_reg(section_t* sect, struct instruction instr);

/** shr r1, r2, r3
 * Shifts the bits in r2 to the right by the number of bits specified in r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 >> r3
*/
#define opcode_shr_reg_reg_reg                          0x19
#define op_shr_reg_reg_reg(...) (instruction_t) { .opcode = opcode_shr_reg_reg_reg, .encode = encode_opcode_shr_reg_reg_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_shr_reg_reg_reg(section_t* sect, struct instruction instr);

/** rol r1, r2, r3
 * Rotates the bits in r2 to the left by the number of bits specified in r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 <<< r3
*/
#define opcode_rol_reg_reg_reg                          0x1A
#define op_rol_reg_reg_reg(...) (instruction_t) { .opcode = opcode_rol_reg_reg_reg, .encode = encode_opcode_rol_reg_reg_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_rol_reg_reg_reg(section_t* sect, struct instruction instr);

/** ror r1, r2, r3
 * Rotates the bits in r2 to the right by the number of bits specified in r3 and stores the result in r1
 * The instruction updates zero, carry, and negative flags accordingly
 * 
 * Pseudocode:
 * r1 = r2 >>> r3
*/
#define opcode_ror_reg_reg_reg                          0x1B
#define op_ror_reg_reg_reg(...) (instruction_t) { .opcode = opcode_ror_reg_reg_reg, .encode = encode_opcode_ror_reg_reg_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_ror_reg_reg_reg(section_t* sect, struct instruction instr);

/** inc r1
 * Increments r1 by 1
 * 
 * Pseudocode:
 * r1++
*/
#define opcode_inc_reg                                  0x1C
#define op_inc_reg(...) (instruction_t) { .opcode = opcode_inc_reg, .encode = encode_opcode_inc_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_inc_reg(section_t* sect, struct instruction instr);

/** dec r1
 * Decrements r1 by 1
 * 
 * Pseudocode:
 * r1--
*/
#define opcode_dec_reg                                  0x1D
#define op_dec_reg(...) (instruction_t) { .opcode = opcode_dec_reg, .encode = encode_opcode_dec_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_dec_reg(section_t* sect, struct instruction instr);

/** psh r1
 * Pushes the value of r1 onto the stack
 * 
 * Pseudocode:
 * stack[sp++] = r1
*/
#define opcode_psh_reg                                  0x1E
#define op_psh_reg(...) (instruction_t) { .opcode = opcode_psh_reg, .encode = encode_opcode_psh_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_psh_reg(section_t* sect, struct instruction instr);

/** pp r1
 * Pops the value of the stack into r1
 * 
 * Pseudocode:
 * r1 = stack[--sp]
*/
#define opcode_pp_reg                                   0x1F
#define op_pp_reg(...) (instruction_t) { .opcode = opcode_pp_reg, .encode = encode_opcode_pp_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_pp_reg(section_t* sect, struct instruction instr);

/** ldr r1, r2
 * Loads the value of r2 into r1
 * 
 * Pseudocode:
 * r1 = r2
*/
#define opcode_ldr_reg_reg                              0x20
#define op_ldr_reg_reg(...) (instruction_t) { .opcode = opcode_ldr_reg_reg, .encode = encode_opcode_ldr_reg_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_ldr_reg_reg(section_t* sect, struct instruction instr);

/** ldr r1, [r2]
 * Loads the value of the memory at the address in r2 into r1
 * 
 * Pseudocode:
 * r1 = *r2
*/
#define opcode_ldr_reg_addr                             0x21
#define op_ldr_reg_addr(...) (instruction_t) { .opcode = opcode_ldr_reg_addr, .encode = encode_opcode_ldr_reg_addr, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_ldr_reg_addr(section_t* sect, struct instruction instr);

/** ldr r1, [r2 + r3]
 * Loads the value of the memory at the address in r2 + r3 into r1
 * 
 * Pseudocode:
 * r1 = *(r2 + r3)
*/
#define opcode_ldr_reg_addr_reg                         0x22
#define op_ldr_reg_addr_reg(...) (instruction_t) { .opcode = opcode_ldr_reg_addr_reg, .encode = encode_opcode_ldr_reg_addr_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_ldr_reg_addr_reg(section_t* sect, struct instruction instr);

/** ldr r1, [r2 + 32]
 * Loads the value of the memory at the address in r2 + 32 into r1
 * 
 * Pseudocode:
 * r1 = *(r2 + 32)
*/
#define opcode_ldr_reg_addr_imm                         0x23
#define op_ldr_reg_addr_imm(...) (instruction_t) { .opcode = opcode_ldr_reg_addr_imm, .encode = encode_opcode_ldr_reg_addr_imm, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_ldr_reg_addr_imm(section_t* sect, struct instruction instr);

/** str [r1], r2
 * Stores the value of r2 into the memory at the address in r1
 * 
 * Pseudocode:
 * *r1 = r2
*/
#define opcode_str_reg_reg                              0x25
#define op_str_reg_reg(...) (instruction_t) { .opcode = opcode_str_reg_reg, .encode = encode_opcode_str_reg_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_str_reg_reg(section_t* sect, struct instruction instr);

/** str [r1 + r2], r3
 * Stores the value of r3 into the memory at the address in r1 + r2
 * 
 * Pseudocode:
 * *(r1 + r2) = r3
*/
#define opcode_str_reg_addr_reg                         0x26
#define op_str_reg_addr_reg(...) (instruction_t) { .opcode = opcode_str_reg_addr_reg, .encode = encode_opcode_str_reg_addr_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_str_reg_addr_reg(section_t* sect, struct instruction instr);

// /** str [r1 + 32], r2
//  * Stores the value of r2 into the memory at the address in r1 + 32
//  * 
//  * Pseudocode:
//  * *(r1 + 32) = r2
// */
// #define opcode_str_reg_addr_imm                      0x27
// #define op_str_reg_addr_imm(...) (instruction_t) { .opcode = opcode_str_reg_addr_imm, .encode = encode_opcode_str_reg_addr_imm, .args = { __VA_ARGS__ } }

/** movl r1, 0x1234
 * Moves the immediate value into r1 at location 0 (mask: 0x000000000000ffff)
 * 
 * Pseudocode:
 * r1 = imm
*/
#define opcode_movl                                     0x28
#define op_movl(...) (instruction_t) { .opcode = opcode_movl, .encode = encode_opcode_movl, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_movl(section_t* sect, struct instruction instr);

/** movh r1, 0x1234
 * Moves the immediate value into r1 at location 1 (mask: 0x00000000ffff0000)
 * 
 * Pseudocode:
 * r1 = imm << 16
*/
#define opcode_movh                                     0x29
#define op_movh(...) (instruction_t) { .opcode = opcode_movh, .encode = encode_opcode_movh, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_movh(section_t* sect, struct instruction instr);

/** movql r1, 0x1234
 * Moves the immediate value into r1 at location 2 (mask: 0x0000ffff00000000)
 * 
 * Pseudocode:
 * r1 = imm << 32
*/
#define opcode_movql                                    0x2A
#define op_movql(...) (instruction_t) { .opcode = opcode_movql, .encode = encode_opcode_movql, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_movql(section_t* sect, struct instruction instr);

/** movqh r1, 0x1234
 * Moves the immediate value into r1 at location 3 (mask: 0xffff000000000000)
 * 
 * Pseudocode:
 * r1 = imm << 48
*/
#define opcode_movqh                                    0x2B
#define op_movqh(...) (instruction_t) { .opcode = opcode_movqh, .encode = encode_opcode_movqh, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_movqh(section_t* sect, struct instruction instr);

/** lea r1, label
 * Loads the address of the label into r1
 * 
 * Pseudocode:
 * r1 = pc + label
*/
#define opcode_lea_reg_addr                             0x2C
#define op_lea_reg_addr(...) (instruction_t) { .opcode = opcode_lea_reg_addr, .encode = encode_opcode_lea_reg_addr, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_lea_reg_addr(section_t* sect, struct instruction instr);

/** cmp r1, r2
 * Compares r1 and r2 and updates the zero and carry flags accordingly
 * 
 * Pseudocode:
 * zero_flag = r1 == r2
 * negative_flag = r1 < r2
*/
#define opcode_cmp_reg_reg                              0x2D
#define op_cmp_reg_reg(...) (instruction_t) { .opcode = opcode_cmp_reg_reg, .encode = encode_opcode_cmp_reg_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_cmp_reg_reg(section_t* sect, struct instruction instr);

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
uint32_t encode_opcode_xchg_reg_reg(section_t* sect, struct instruction instr);

/** movz r1, 0x1234
 * Moves the immediate value into r1 at location 0 while zeroing the other locations (mask: 0x000000000000ffff)
 * 
 * Pseudocode:
 * r1 = imm
*/
#define opcode_movz                                     0x2F
#define op_movz(...) (instruction_t) { .opcode = opcode_movz, .encode = encode_opcode_movz, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_movz(section_t* sect, struct instruction instr);

/** add r1, 0x1234
 * Adds the immediate value to r1 and stores the result in r1
 * 
 * Pseudocode:
 * r1 += imm
*/
#define opcode_add_reg_imm                              0x30
#define op_add_reg_imm(...) (instruction_t) { .opcode = opcode_add_reg_imm, .encode = encode_opcode_add_reg_imm, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_add_reg_imm(section_t* sect, struct instruction instr);

/** sub r1, 0x1234
 * Subtracts r2 from r1 and stores the result in r1
 * 
 * Pseudocode:
 * r1 -= r2
*/
#define opcode_sub_reg_imm                              0x31
#define op_sub_reg_imm(...) (instruction_t) { .opcode = opcode_sub_reg_imm, .encode = encode_opcode_sub_reg_imm, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_sub_reg_imm(section_t* sect, struct instruction instr);

/** mul r1, 0x1234
 * Multiplies r1 by r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 *= r2
*/
#define opcode_mul_reg_imm                              0x32
#define op_mul_reg_imm(...) (instruction_t) { .opcode = opcode_mul_reg_imm, .encode = encode_opcode_mul_reg_imm, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_mul_reg_imm(section_t* sect, struct instruction instr);

/** div r1, 0x1234
 * Divides r1 by r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 /= r2
*/
#define opcode_div_reg_imm                              0x33
#define op_div_reg_imm(...) (instruction_t) { .opcode = opcode_div_reg_imm, .encode = encode_opcode_div_reg_imm, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_div_reg_imm(section_t* sect, struct instruction instr);

/** mod r1, 0x1234
 * Computes the remainder of r1 divided by r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 %= r2
*/
#define opcode_mod_reg_imm                              0x34
#define op_mod_reg_imm(...) (instruction_t) { .opcode = opcode_mod_reg_imm, .encode = encode_opcode_mod_reg_imm, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_mod_reg_imm(section_t* sect, struct instruction instr);

/** and r1, 0x1234
 * Computes the bitwise AND of r1 and r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 &= r2
*/
#define opcode_and_reg_imm                              0x35
#define op_and_reg_imm(...) (instruction_t) { .opcode = opcode_and_reg_imm, .encode = encode_opcode_and_reg_imm, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_and_reg_imm(section_t* sect, struct instruction instr);

/** or r1, 0x1234
 * Computes the bitwise OR of r1 and r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 |= r2
*/
#define opcode_or_reg_imm                               0x36
#define op_or_reg_imm(...) (instruction_t) { .opcode = opcode_or_reg_imm, .encode = encode_opcode_or_reg_imm, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_or_reg_imm(section_t* sect, struct instruction instr);

/** xor r1, 0x1234
 * Computes the bitwise XOR of r1 and r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 ^= r2
*/
#define opcode_xor_reg_imm                              0x37
#define op_xor_reg_imm(...) (instruction_t) { .opcode = opcode_xor_reg_imm, .encode = encode_opcode_xor_reg_imm, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_xor_reg_imm(section_t* sect, struct instruction instr);

/** shl r1, 0x1234
 * Shifts the bits of r1 to the left by r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 <<= r2
*/
#define opcode_shl_reg_imm                              0x38
#define op_shl_reg_imm(...) (instruction_t) { .opcode = opcode_shl_reg_imm, .encode = encode_opcode_shl_reg_imm, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_shl_reg_imm(section_t* sect, struct instruction instr);

/** shr r1, 0x1234
 * Shifts the bits of r1 to the right by r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 >>= r2
*/
#define opcode_shr_reg_imm                              0x39
#define op_shr_reg_imm(...) (instruction_t) { .opcode = opcode_shr_reg_imm, .encode = encode_opcode_shr_reg_imm, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_shr_reg_imm(section_t* sect, struct instruction instr);

/** rol r1, 0x1234
 * Rotates the bits of r1 to the left by r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 = (r1 << r2) | (r1 >> (64 - r2))
*/
#define opcode_rol_reg_imm                              0x3A
#define op_rol_reg_imm(...) (instruction_t) { .opcode = opcode_rol_reg_imm, .encode = encode_opcode_rol_reg_imm, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_rol_reg_imm(section_t* sect, struct instruction instr);

/** ror r1, 0x1234
 * Rotates the bits of r1 to the right by r2 and stores the result in r1
 * 
 * Pseudocode:
 * r1 = (r1 >> r2) | (r1 << (64 - r2))
*/
#define opcode_ror_reg_imm                              0x3B
#define op_ror_reg_imm(...) (instruction_t) { .opcode = opcode_ror_reg_imm, .encode = encode_opcode_ror_reg_imm, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_ror_reg_imm(section_t* sect, struct instruction instr);

/** not r1
 * Computes the bitwise NOT of r1 and stores the result in r1
 * 
 * Pseudocode:
 * r1 = ~r1
*/
#define opcode_not_reg                                  0x3C
#define op_not_reg(...) (instruction_t) { .opcode = opcode_not_reg, .encode = encode_opcode_not_reg, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_not_reg(section_t* sect, struct instruction instr);

/** <op>.byte <args> / <op>.word <args> / <op>.dword <args> / <op>.qword <args>
 * Changes the addressing mode of the following instruction to byte
 * 
 * Pseudocode:
 * Addressing mode = byte
*/
#define opcode_dot_addressing_override                  0x48
#define op_dot_addressing_override(...) (instruction_t) { .opcode = opcode_dot_addressing_override, .encode = encode_opcode_dot_addressing_override, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_dot_addressing_override(section_t* sect, struct instruction instr);

/** .symbol
 * Internal instruction used to mark the location of a symbol
*/
#define opcode_dot_symbol                               0x49
#define op_dot_symbol(...) (instruction_t) { .opcode = opcode_dot_symbol, .encode = encode_opcode_dot_symbol, .args = { __VA_ARGS__ } }
uint32_t encode_opcode_dot_symbol(section_t* sect, struct instruction instr);
