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

#define ARG_8BIT(_reg) ((instr_arg) { .type = arg_reg, .reg = _reg })
#define ARG_16BIT(_imm) ((instr_arg) { .type = arg_imm16, .imm16 = _imm })
#define ARG_64BIT(_imm) ((instr_arg) { .type = arg_imm64, .imm64 = _imm })
#define ARG_IMM64(_imm) ARG_64BIT(_imm)
#define ARG_64SYM(_sym) ((instr_arg) { .type = arg_sym, .sym = _sym })

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

typedef struct instruction {
    opcode_t        opcode;
    instr_arg       args[16];
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
    uint64_t        offset;
    uint64_t        symbol;
} relocation_info_t;

#define SYMBOL_NAME_LEN_MAX 64

#define PACKED __attribute__((packed))

typedef struct symbol_t {
    uint64_t        sym_addr PACKED;
    uint64_t        section PACKED;
    char*           name PACKED;
} symbol_t;

typedef struct section {
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
} section_t;

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
    uint64_t    asInteger;
    int64_t     asSignedInteger;
    void*       asPointer;
    void**      asPointerPointer;
    uint16_t*   asUint16Ptr;
    double      asFloat;
    uint8_t     bytes[8];
} hive_register_t;

uint64_t symbol_offset(section_t* obj, const char *name);
int add_symbol(section_t* obj, const char* name);

#define CODE(name) add_symbol(obj, name)
#define DATA(name) add_symbol(obj, name)
#define ASCII(str) add_bytes(obj, str, strlen(str))
#define ASCIZ(str) add_bytes(obj, str, strlen(str) + 1)

#define opcode_nbytes_mask  0b1111000000000000
#define opcode_nbytes_shift 12

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
    obj->comp_size += 2;
    for (uint8_t i = 0; i < 4; i++) {
        switch (instr.args[i].type)
        {
        case arg_none:
            break;
        case arg_reg:
            obj->comp_size += 1;
            break;
        case arg_imm16:
            obj->comp_size += 2;
            break;
        case arg_sym:
            symbol_reloc(obj);
            obj->comp_size += 8;
            break;
        case arg_imm64:
            obj->comp_size += 8;
            break;
        default:
            printf("Unknown instruction argument type %d in instruction %01x %03x\n", instr.args[i].type, instr.opcode.nbytes, instr.opcode.opcode);
            break;
        }
    }
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
        compile_imm_qword(obj, symbol_offset(obj, insert.symbol));
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
            // symbol_reloc(obj);
            compile_imm_qword(obj, symbol_offset(obj, instr.args[i].sym));
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
#define opcode_psh              0b000000010001
#define opcode_pp               0b000000010010
#define opcode_add              0b000000010011
#define opcode_sub              0b000000010100
#define opcode_mul              0b000000010101
#define opcode_div              0b000000010110
#define opcode_mod              0b000000010111
#define opcode_and              0b000000011000
#define opcode_or               0b000000011001
#define opcode_xor              0b000000011010
#define opcode_shl              0b000000011011
#define opcode_shr              0b000000011100
#define opcode_not              0b000000011101
#define opcode_inc              0b000000011110
#define opcode_dec              0b000000011111
#define opcode_irq              0b000000100000
#define opcode_mov              0b000000100001
#define opcode_bl               0b000000100010
#define opcode_blne             0b000000100011
#define opcode_bleq             0b000000100100
#define opcode_blgt             0b000000100101
#define opcode_bllt             0b000000100110
#define opcode_blge             0b000000100111
#define opcode_blle             0b000000101000
#define opcode_blnz             0b000000101001
#define opcode_blz              0b000000101010
#define opcode_svc              0b000000101011

//      opcode                      nbytes                 // mnemonic                                                          // bytecode
#define op_nop                  OPC(0, opcode_nop)         // nop                                                               // 0x000
#define op_halt                 OPC(0, opcode_halt)        // hlt                                                               // 0x001
#define op_pshi                 OPC(0, opcode_pshi)        // pshi                                                              // 0x00F
#define op_ret                  OPC(0, opcode_ret)         // ret                                                               // 0x010
#define op_irq                  OPC(0, opcode_irq)         // irq                                                               // 0x024
#define op_svc                  OPC(0, opcode_svc)         // svc                                                               // 0x040

#define op_cmpz_reg             OPC(1, opcode_cmpz)        // cmpz r1                                                           // 0x005 0x01
#define op_b_reg                OPC(1, opcode_b)           // b r1                                                              // 0x006 0x01
#define op_bne_reg              OPC(1, opcode_bne)         // bne r1                                                            // 0x007 0x01
#define op_beq_reg              OPC(1, opcode_beq)         // beq r1                                                            // 0x008 0x01
#define op_bgt_reg              OPC(1, opcode_bgt)         // bgt r1                                                            // 0x009 0x01
#define op_blt_reg              OPC(1, opcode_blt)         // blt r1                                                            // 0x00A 0x01
#define op_bge_reg              OPC(1, opcode_bge)         // bge r1                                                            // 0x00B 0x01
#define op_ble_reg              OPC(1, opcode_ble)         // ble r1                                                            // 0x00C 0x01
#define op_bnz_reg              OPC(1, opcode_bnz)         // bnz r1                                                            // 0x00D 0x01
#define op_bz_reg               OPC(1, opcode_bz)          // bz r1                                                             // 0x00E 0x01
#define op_psh_reg              OPC(1, opcode_psh)         // psh r1                                                            // 0x015 0x01
#define op_pp_reg               OPC(1, opcode_pp)          // pp r1                                                             // 0x016 0x01
#define op_not_reg              OPC(1, opcode_not)         // not r1                                                            // 0x021 0x01
#define op_inc_reg              OPC(1, opcode_inc)         // inc r1                                                            // 0x022 0x01
#define op_dec_reg              OPC(1, opcode_dec)         // dec r1                                                            // 0x023 0x01
#define op_bl_reg               OPC(1, opcode_bl)          // bl r1                                                             // 0x036 0x01
#define op_blne_reg             OPC(1, opcode_blne)        // blne r1                                                           // 0x037 0x01
#define op_bleq_reg             OPC(1, opcode_bleq)        // bleq r1                                                           // 0x038 0x01
#define op_blgt_reg             OPC(1, opcode_blgt)        // blgt r1                                                           // 0x039 0x01
#define op_bllt_reg             OPC(1, opcode_bllt)        // bllt r1                                                           // 0x03A 0x01
#define op_blge_reg             OPC(1, opcode_blge)        // blge r1                                                           // 0x03B 0x01
#define op_blle_reg             OPC(1, opcode_blle)        // blle r1                                                           // 0x03C 0x01
#define op_blnz_reg             OPC(1, opcode_blnz)        // blnz r1                                                           // 0x03D 0x01
#define op_blz_reg              OPC(1, opcode_blz)         // blz r1                                                            // 0x03E 0x01

#define op_ldr_reg_reg          OPC(2, opcode_ldr)         // ldr r1 r2                                                         // 0x002 0x01 0x02
#define op_str_reg_reg          OPC(2, opcode_str)         // str r1 r2                                                         // 0x003 0x01 0x02
#define op_cmp_reg_reg          OPC(2, opcode_cmp)         // cmp r1 r2                                                         // 0x004 0x01 0x02
#define op_psh_imm16            OPC(2, opcode_psh)         // psh 0x1234                                                        // 0x015 0x12 0x34
#define op_add_reg_reg          OPC(2, opcode_add)         // add r1 r2                                                         // 0x017 0x01 0x02
#define op_sub_reg_reg          OPC(2, opcode_sub)         // sub r1 r2                                                         // 0x018 0x01 0x02
#define op_mul_reg_reg          OPC(2, opcode_mul)         // mul r1 r2                                                         // 0x019 0x01 0x02
#define op_div_reg_reg          OPC(2, opcode_div)         // div r1 r2                                                         // 0x01A 0x01 0x02
#define op_mod_reg_reg          OPC(2, opcode_mod)         // mod r1 r2                                                         // 0x01B 0x01 0x02
#define op_and_reg_reg          OPC(2, opcode_and)         // and r1 r2                                                         // 0x01C 0x01 0x02
#define op_or_reg_reg           OPC(2, opcode_or)          // or r1 r2                                                          // 0x01D 0x01 0x02
#define op_xor_reg_reg          OPC(2, opcode_xor)         // xor r1 r2                                                         // 0x01E 0x01 0x02
#define op_shl_reg_reg          OPC(2, opcode_shl)         // shl r1 r2                                                         // 0x01F 0x01 0x02
#define op_shr_reg_reg          OPC(2, opcode_shr)         // shr r1 r2                                                         // 0x020 0x01 0x02

#define op_ldr_reg_imm16        OPC(3, opcode_ldr)         // ldr r1 0x1234                                                     // 0x002 0x01 0x12 0x34
#define op_str_reg_imm16        OPC(3, opcode_str)         // str r1 0x1234                                                     // 0x003 0x01 0x12 0x34
#define op_cmp_reg_imm16        OPC(3, opcode_cmp)         // cmp r1 0x1234                                                     // 0x004 0x01 0x12 0x34
#define op_add_reg_imm16        OPC(3, opcode_add)         // add r1 0x1234                                                     // 0x017 0x01 0x12 0x34
#define op_sub_reg_imm16        OPC(3, opcode_sub)         // sub r1 0x1234                                                     // 0x018 0x01 0x12 0x34
#define op_mul_reg_imm16        OPC(3, opcode_mul)         // mul r1 0x1234                                                     // 0x019 0x01 0x12 0x34
#define op_div_reg_imm16        OPC(3, opcode_div)         // div r1 0x1234                                                     // 0x01A 0x01 0x12 0x34
#define op_mod_reg_imm16        OPC(3, opcode_mod)         // mod r1 0x1234                                                     // 0x01B 0x01 0x12 0x34
#define op_and_reg_imm16        OPC(3, opcode_and)         // and r1 0x1234                                                     // 0x01C 0x01 0x12 0x34
#define op_or_reg_imm16         OPC(3, opcode_or)          // or r1 0x1234                                                      // 0x01D 0x01 0x12 0x34
#define op_xor_reg_imm16        OPC(3, opcode_xor)         // xor r1 0x1234                                                     // 0x01E 0x01 0x12 0x34
#define op_shl_reg_imm16        OPC(3, opcode_shl)         // shl r1 0x1234                                                     // 0x01F 0x01 0x12 0x34
#define op_shr_reg_imm16        OPC(3, opcode_shr)         // shr r1 0x1234                                                     // 0x020 0x01 0x12 0x34

#define op_ldr_reg_mem          OPC(4, opcode_ldr)         // ldr r1 [r2 (0x1234)]                                              // 0x002 0x01 0x02 0x12 0x34
#define op_mov_reg_reg_reg      OPC(4, opcode_mov)         // mov r1 (b|w|d|q) [r2 r3]                                          // 0x026 0x01 0x0(1|2|4|8) 0x02 0x03
#define op_add_reg_reg_reg      OPC(4, opcode_add)         // add r1 (b|w|d|q) [r2 r3]                                          // 0x017 0x01 0x0(1|2|4|8) 0x02 0x03
#define op_sub_reg_reg_reg      OPC(4, opcode_sub)         // sub r1 (b|w|d|q) [r2 r3]                                          // 0x018 0x01 0x0(1|2|4|8) 0x02 0x03
#define op_mul_reg_reg_reg      OPC(4, opcode_mul)         // mul r1 (b|w|d|q) [r2 r3]                                          // 0x019 0x01 0x0(1|2|4|8) 0x02 0x03
#define op_div_reg_reg_reg      OPC(4, opcode_div)         // div r1 (b|w|d|q) [r2 r3]                                          // 0x01A 0x01 0x0(1|2|4|8) 0x02 0x03
#define op_mod_reg_reg_reg      OPC(4, opcode_mod)         // mod r1 (b|w|d|q) [r2 r3]                                          // 0x01B 0x01 0x0(1|2|4|8) 0x02 0x03
#define op_and_reg_reg_reg      OPC(4, opcode_and)         // and r1 (b|w|d|q) [r2 r3]                                          // 0x01C 0x01 0x0(1|2|4|8) 0x02 0x03
#define op_or_reg_reg_reg       OPC(4, opcode_or)          // or r1 (b|w|d|q) [r2 r3]                                           // 0x01D 0x01 0x0(1|2|4|8) 0x02 0x03
#define op_xor_reg_reg_reg      OPC(4, opcode_xor)         // xor r1 (b|w|d|q) [r2 r3]                                          // 0x01E 0x01 0x0(1|2|4|8) 0x02 0x03
#define op_shl_reg_reg_reg      OPC(4, opcode_shl)         // shl r1 (b|w|d|q) [r2 r3]                                          // 0x01F 0x01 0x0(1|2|4|8) 0x02 0x03
#define op_shr_reg_reg_reg      OPC(4, opcode_shr)         // shr r1 (b|w|d|q) [r2 r3]                                          // 0x020 0x01 0x0(1|2|4|8) 0x02 0x03

#define op_mov_reg_reg          OPC(5, opcode_mov)         // mov r1 (b|w|d|q) [r2 (0x1234)]                                    // 0x026 0x01 0x0(1|2|4|8) 0x02 0x12 0x34
#define op_add_reg_mem          OPC(5, opcode_add)         // add r1 (b|w|d|q) [r2 (0x1234)]                                    // 0x017 0x01 0x0(1|2|4|8) 0x02 0x12 0x34
#define op_sub_reg_mem          OPC(5, opcode_sub)         // sub r1 (b|w|d|q) [r2 (0x1234)]                                    // 0x018 0x01 0x0(1|2|4|8) 0x02 0x12 0x34
#define op_mul_reg_mem          OPC(5, opcode_mul)         // mul r1 (b|w|d|q) [r2 (0x1234)]                                    // 0x019 0x01 0x0(1|2|4|8) 0x02 0x12 0x34
#define op_div_reg_mem          OPC(5, opcode_div)         // div r1 (b|w|d|q) [r2 (0x1234)]                                    // 0x01A 0x01 0x0(1|2|4|8) 0x02 0x12 0x34
#define op_mod_reg_mem          OPC(5, opcode_mod)         // mod r1 (b|w|d|q) [r2 (0x1234)]                                    // 0x01B 0x01 0x0(1|2|4|8) 0x02 0x12 0x34
#define op_and_reg_mem          OPC(5, opcode_and)         // and r1 (b|w|d|q) [r2 (0x1234)]                                    // 0x01C 0x01 0x0(1|2|4|8) 0x02 0x12 0x34
#define op_or_reg_mem           OPC(5, opcode_or)          // or r1 (b|w|d|q) [r2 (0x1234)]                                     // 0x01D 0x01 0x0(1|2|4|8) 0x02 0x12 0x34
#define op_xor_reg_mem          OPC(5, opcode_xor)         // xor r1 (b|w|d|q) [r2 (0x1234)]                                    // 0x01E 0x01 0x0(1|2|4|8) 0x02 0x12 0x34
#define op_shl_reg_mem          OPC(5, opcode_shl)         // shl r1 (b|w|d|q) [r2 (0x1234)]                                    // 0x01F 0x01 0x0(1|2|4|8) 0x02 0x12 0x34
#define op_shr_reg_mem          OPC(5, opcode_shr)         // shr r1 (b|w|d|q) [r2 (0x1234)]                                    // 0x020 0x01 0x0(1|2|4|8) 0x02 0x12 0x34

#define op_psh_imm64            OPC(8, opcode_psh)         // psh 0x123456789ABCDEF0                                            // 0x015 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_b_addr               OPC(8, opcode_b)           // b label                                                           // 0x006 (label address in data (64 bit))
#define op_bne_addr             OPC(8, opcode_bne)         // bne label                                                         // 0x007 (label address in data (64 bit))
#define op_beq_addr             OPC(8, opcode_beq)         // beq label                                                         // 0x008 (label address in data (64 bit))
#define op_bgt_addr             OPC(8, opcode_bgt)         // bgt label                                                         // 0x009 (label address in data (64 bit))
#define op_blt_addr             OPC(8, opcode_blt)         // blt label                                                         // 0x00A (label address in data (64 bit))
#define op_bge_addr             OPC(8, opcode_bge)         // bge label                                                         // 0x00B (label address in data (64 bit))
#define op_ble_addr             OPC(8, opcode_ble)         // ble label                                                         // 0x00C (label address in data (64 bit))
#define op_bnz_addr             OPC(8, opcode_bnz)         // bnz label                                                         // 0x00D (label address in data (64 bit))
#define op_bz_addr              OPC(8, opcode_bz)          // bz label                                                          // 0x00E (label address in data (64 bit))
#define op_psh_addr             OPC(8, opcode_psh)         // psh label                                                         // 0x015 (label address in data (64 bit))
#define op_pp_addr              OPC(8, opcode_pp)          // pp label                                                          // 0x016 (label address in data (64 bit))
#define op_bl_addr              OPC(8, opcode_bl)          // bl label                                                          // 0x036 (label address in data (64 bit))
#define op_blne_addr            OPC(8, opcode_blne)        // blne label                                                        // 0x037 (label address in data (64 bit))
#define op_bleq_addr            OPC(8, opcode_bleq)        // bleq label                                                        // 0x038 (label address in data (64 bit))
#define op_blgt_addr            OPC(8, opcode_blgt)        // blgt label                                                        // 0x039 (label address in data (64 bit))
#define op_bllt_addr            OPC(8, opcode_bllt)        // bllt label                                                        // 0x03A (label address in data (64 bit))
#define op_blge_addr            OPC(8, opcode_blge)        // blge label                                                        // 0x03B (label address in data (64 bit))
#define op_blle_addr            OPC(8, opcode_blle)        // blle label                                                        // 0x03C (label address in data (64 bit))
#define op_blnz_addr            OPC(8, opcode_blnz)        // blnz label                                                        // 0x03D (label address in data (64 bit))
#define op_blz_addr             OPC(8, opcode_blz)         // blz label                                                         // 0x03E (label address in data (64 bit))

#define op_ldr_reg_imm          OPC(9, opcode_ldr)         // ldr r1 0x123456789ABCDEF0                                         // 0x002 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_str_reg_imm64        OPC(9, opcode_str)         // str r1 0x123456789ABCDEF0                                         // 0x003 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_cmp_reg_imm64        OPC(9, opcode_cmp)         // cmp r1 0x123456789ABCDEF0                                         // 0x004 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_add_reg_imm64        OPC(9, opcode_add)         // add r1 0x123456789ABCDEF0                                         // 0x017 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_sub_reg_imm64        OPC(9, opcode_sub)         // sub r1 0x123456789ABCDEF0                                         // 0x018 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_mul_reg_imm64        OPC(9, opcode_mul)         // mul r1 0x123456789ABCDEF0                                         // 0x019 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_div_reg_imm64        OPC(9, opcode_div)         // div r1 0x123456789ABCDEF0                                         // 0x01A 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_mod_reg_imm64        OPC(9, opcode_mod)         // mod r1 0x123456789ABCDEF0                                         // 0x01B 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_and_reg_imm64        OPC(9, opcode_and)         // and r1 0x123456789ABCDEF0                                         // 0x01C 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_or_reg_imm64         OPC(9, opcode_or)          // or r1 0x123456789ABCDEF0                                          // 0x01D 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_xor_reg_imm64        OPC(9, opcode_xor)         // xor r1 0x123456789ABCDEF0                                         // 0x01E 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_shl_reg_imm64        OPC(9, opcode_shl)         // shl r1 0x123456789ABCDEF0                                         // 0x01F 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0
#define op_shr_reg_imm64        OPC(9, opcode_shr)         // shr r1 0x123456789ABCDEF0                                         // 0x020 0x01 0x12 0x34 0x56 0x78 0x9A 0xBC 0xDE 0xF0

#define op_ldr_reg_addr_reg     OPC(10, opcode_ldr)        // ldr r1 [label r2]                                                 // 0x002 0x01 0x02 (label address in data (64 bit))

#define op_ldr_reg_addr_imm16   OPC(11, opcode_ldr)        // ldr r1 [label (0x1234)]                                           // 0x002 0x01 0x12 0x34 (label address in data (64 bit))
#define op_mov_reg_addr_reg     OPC(11, opcode_mov)        // mov r1 (b|w|d|q) [label r2]                                       // 0x026 0x01 0x0(1|2|4|8) (label address in data (64 bit)) 0x02
#define op_add_reg_addr_reg     OPC(11, opcode_add)        // add r1 (b|w|d|q) [label r2]                                       // 0x017 0x01 0x0(1|2|4|8) (label address in data (64 bit)) 0x02
#define op_sub_reg_addr_reg     OPC(11, opcode_sub)        // sub r1 (b|w|d|q) [label r2]                                       // 0x018 0x01 0x0(1|2|4|8) (label address in data (64 bit)) 0x02
#define op_mul_reg_addr_reg     OPC(11, opcode_mul)        // mul r1 (b|w|d|q) [label r2]                                       // 0x019 0x01 0x0(1|2|4|8) (label address in data (64 bit)) 0x02
#define op_div_reg_addr_reg     OPC(11, opcode_div)        // div r1 (b|w|d|q) [label r2]                                       // 0x01A 0x01 0x0(1|2|4|8) (label address in data (64 bit)) 0x02
#define op_mod_reg_addr_reg     OPC(11, opcode_mod)        // mod r1 (b|w|d|q) [label r2]                                       // 0x01B 0x01 0x0(1|2|4|8) (label address in data (64 bit)) 0x02
#define op_and_reg_addr_reg     OPC(11, opcode_and)        // and r1 (b|w|d|q) [label r2]                                       // 0x01C 0x01 0x0(1|2|4|8) (label address in data (64 bit)) 0x02
#define op_or_reg_addr_reg      OPC(11, opcode_or)         // or r1 (b|w|d|q) [label r2]                                        // 0x01D 0x01 0x0(1|2|4|8) (label address in data (64 bit)) 0x02
#define op_xor_reg_addr_reg     OPC(11, opcode_xor)        // xor r1 (b|w|d|q) [label r2]                                       // 0x01E 0x01 0x0(1|2|4|8) (label address in data (64 bit)) 0x02
#define op_shl_reg_addr_reg     OPC(11, opcode_shl)        // shl r1 (b|w|d|q) [label r2]                                       // 0x01F 0x01 0x0(1|2|4|8) (label address in data (64 bit)) 0x02
#define op_shr_reg_addr_reg     OPC(11, opcode_shr)        // shr r1 (b|w|d|q) [label r2]                                       // 0x020 0x01 0x0(1|2|4|8) (label address in data (64 bit)) 0x02

#define op_mov_reg_addr         OPC(12, opcode_mov)        // mov r1 (b|w|d|q) [label (0x1234)]                                 // 0x026 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (64 bit)
#define op_add_reg_addr         OPC(12, opcode_add)        // add r1 (b|w|d|q) [label (0x1234)]                                 // 0x017 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (64 bit)
#define op_sub_reg_addr         OPC(12, opcode_sub)        // sub r1 (b|w|d|q) [label (0x1234)]                                 // 0x018 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (64 bit)
#define op_mul_reg_addr         OPC(12, opcode_mul)        // mul r1 (b|w|d|q) [label (0x1234)]                                 // 0x019 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (64 bit)
#define op_div_reg_addr         OPC(12, opcode_div)        // div r1 (b|w|d|q) [label (0x1234)]                                 // 0x01A 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (64 bit)
#define op_mod_reg_addr         OPC(12, opcode_mod)        // mod r1 (b|w|d|q) [label (0x1234)]                                 // 0x01B 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (64 bit)
#define op_and_reg_addr         OPC(12, opcode_and)        // and r1 (b|w|d|q) [label (0x1234)]                                 // 0x01C 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (64 bit)
#define op_or_reg_addr          OPC(12, opcode_or)         // or r1 (b|w|d|q) [label (0x1234)]                                  // 0x01D 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (64 bit)
#define op_xor_reg_addr         OPC(12, opcode_xor)        // xor r1 (b|w|d|q) [label (0x1234)]                                 // 0x01E 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (64 bit)
#define op_shl_reg_addr         OPC(12, opcode_shl)        // shl r1 (b|w|d|q) [label (0x1234)]                                 // 0x01F 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (64 bit)
#define op_shr_reg_addr         OPC(12, opcode_shr)        // shr r1 (b|w|d|q) [label (0x1234)]                                 // 0x020 0x01 0x0(1|2|4|8) 0x12 0x34 (label address in data (64 bit)
