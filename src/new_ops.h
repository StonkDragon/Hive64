#pragma once

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define PACKED _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Wattribute-packed-for-bitfield\"") __attribute__((packed)) _Pragma("clang diagnostic pop")

#include "nob.h"
#include "opcode.h"

#define HIVE_FILE_MAGIC 0xFEEDF00D
#define HIVE_FAT_FILE_MAGIC 0xFEEDFACF

typedef __uint128_t LWord_t;    // long word
typedef uint64_t QWord_t;       // quad word
typedef uint32_t DWord_t;       // double word
typedef uint16_t Word_t;        // word
typedef uint8_t Byte_t;         // byte
typedef int64_t SQWord_t;       // signed quad word
typedef int32_t SDWord_t;       // signed double word
typedef int16_t SWord_t;        // signed word
typedef int8_t SByte_t;         // signed byte
typedef void* Pointer_t;        // pointer
typedef double Float64_t;       // double precision floating point
typedef float Float32_t;        // single precision floating point

#define CONCAT_(a, b) a ## b
#define CONCAT(a, b) CONCAT_(a, b)

#define PAD(_n) uint32_t CONCAT(_, __LINE__) : _n
#define TYPE_PAD uint8_t __header: 5

typedef QWord_t(*svc_call)(QWord_t,QWord_t,QWord_t,QWord_t,QWord_t,QWord_t,QWord_t,QWord_t);

typedef union {
    struct {
        PAD(27);
        uint8_t type: 2;
        uint8_t condition: 3;
    } PACKED generic;
    struct {
        int32_t offset: 25;
        uint8_t type: 2;
        TYPE_PAD;
    } PACKED type_branch_generic;
    struct {
        int32_t offset: 25;
        uint8_t link: 1;
        uint8_t is_reg: 1;
        TYPE_PAD;
    } PACKED type_branch;
    struct {
        PAD(20);
        uint8_t r1: 5;
        uint8_t link: 1;
        uint8_t is_reg: 1;
        TYPE_PAD;
    } PACKED type_branch_register;
    struct {
        PAD(8);
        uint8_t sub_op: 4;
        PAD(15);
        TYPE_PAD;
    } PACKED type_data;
    struct {
        uint8_t r3: 5;
        PAD(3);
        uint8_t use_imm: 1;
        uint8_t salu: 1;
        uint8_t sub_op: 2;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t no_writeback: 1;
        uint8_t op: 4;
        TYPE_PAD;
    } PACKED type_data_alur;
    struct {
        uint8_t imm;
        uint8_t use_imm: 1;
        uint8_t salu: 1;
        uint8_t sub_op: 2;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t no_writeback: 1;
        uint8_t op: 4;
        TYPE_PAD;
    } PACKED type_data_alui;
    struct {
        int8_t imm;
        uint8_t sub_op: 4;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t update_ptr: 1;
        uint8_t size: 2;
        uint8_t is_store: 1;
        uint8_t use_immediate: 1;
        TYPE_PAD;
    } PACKED type_data_ls_imm;
    struct {
        uint8_t r3: 5;
        PAD(3);
        uint8_t sub_op: 4;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t update_ptr: 1;
        uint8_t size: 2;
        uint8_t is_store: 1;
        uint8_t use_immediate: 1;
        TYPE_PAD;
    } PACKED type_data_ls_reg;
    struct {
        uint8_t r3: 5;
        PAD(1);
        uint8_t is_single_op: 1;
        uint8_t use_int_arg2: 1;
        uint8_t sub_op: 4;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t no_writeback: 1;
        uint8_t op: 4;
        TYPE_PAD;
    } PACKED type_data_fpu;
    struct {
        uint8_t v3: 4;
        PAD(4);
        uint8_t sub_op: 4;
        uint8_t v1: 4;
        uint8_t v2: 4;
        uint8_t mode: 3;
        uint8_t op: 4;
        TYPE_PAD;
    } PACKED type_data_vpu;
    struct {
        uint8_t target_mode: 3;
        PAD(5);
        uint8_t sub_op: 4;
        uint8_t v1: 4;
        uint8_t v2: 4;
        uint8_t mode: 3;
        uint8_t op: 4;
        TYPE_PAD;
    } PACKED type_data_vpu_conv;
    struct {
        uint8_t r2: 5;
        uint8_t slot_lo: 3;
        uint8_t sub_op: 4;
        uint8_t v1: 4;
        uint8_t slot_hi: 2;
        PAD(2);
        uint8_t mode: 3;
        uint8_t op: 4;
        TYPE_PAD;
    } PACKED type_data_vpu_mov;
    struct {
        uint8_t r1: 5;
        PAD(3);
        uint8_t sub_op: 4;
        uint8_t v1: 4;
        PAD(4);
        uint8_t mode: 3;
        uint8_t op: 4;
        TYPE_PAD;
    } PACKED type_data_vpu_len;
    struct {
        uint8_t r2: 5;
        PAD(3);
        uint8_t sub_op: 4;
        uint8_t v1: 4;
        uint8_t r1: 5;
        PAD(1);
        uint8_t use_imm: 1;
        uint8_t op: 4;
        TYPE_PAD;
    } PACKED type_data_vpu_ls;
    struct {
        int8_t imm;
        uint8_t sub_op: 4;
        uint8_t v1: 4;
        uint8_t r1: 5;
        PAD(1);
        uint8_t use_imm: 1;
        uint8_t op: 4;
        TYPE_PAD;
    } PACKED type_data_vpu_ls_imm;
    struct {
        uint8_t start: 6;
        uint8_t count_lo: 1;
        uint8_t extend: 1;
        uint8_t is_reg: 1;
        uint8_t is_dep: 1;
        uint8_t is_bit_instr: 2;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t count_hi: 5;
        TYPE_PAD;
    } PACKED type_data_bit;
    struct {
        uint8_t start_reg: 5;
        PAD(2);
        uint8_t extend: 1;
        uint8_t is_reg: 1;
        uint8_t is_dep: 1;
        uint8_t is_bit_instr: 2;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t count_reg: 5;
        TYPE_PAD;
    } PACKED type_data_bitr;
    struct {
        uint32_t imm: 20;
        uint8_t r1: 5;
        uint8_t op: 2;
        TYPE_PAD;
    } PACKED type_load;
    struct {
        int32_t imm: 20;
        uint8_t r1: 5;
        uint8_t op: 2;
        TYPE_PAD;
    } PACKED type_load_signed;
    struct {
        uint16_t imm;
        uint8_t shift: 2;
        uint8_t no_zero: 1;
        PAD(1);
        uint8_t r1: 5;
        uint8_t op: 2;
        TYPE_PAD;
    } PACKED type_load_mov;
} PACKED hive_instruction_t;

#ifdef static_assert
#define CHECK(what) static_assert(sizeof(((hive_instruction_t*) NULL)->what) == sizeof(DWord_t), "hive_instruction_t::" #what " is wrong size")
static_assert(sizeof(hive_instruction_t) == sizeof(DWord_t), "hive_instruction_t is wrong size");
#endif

typedef union {
    QWord_t     asQWord[1];
    Byte_t      asBytes[32];
    Word_t      asWords[16];
    DWord_t     asDWords[8];
    QWord_t     asQWords[4];
    LWord_t     asLWords[2];
    Float32_t   asFloat32s[8];
    Float64_t   asFloat64s[4];
} hive_vector_register_t;

typedef union hive_register_t {
    QWord_t                 asU64;
    DWord_t                 asU32;
    Word_t                  asU16;
    Byte_t                  asU8;
    SQWord_t                asI64;
    SDWord_t                asI32;
    SWord_t                 asI16;
    SByte_t                 asI8;

    QWord_t                 asQWord;
    DWord_t                 asDWord;
    Word_t                  asWord;
    Byte_t                  asByte;
    SQWord_t                asSQWord;
    SDWord_t                asSDWord;
    SWord_t                 asSWord;
    SByte_t                 asSByte;
    Pointer_t               asPointer;
    Byte_t*                 asBytePtr;
    SByte_t*                asSBytePtr;
    Word_t*                 asWordPtr;
    SWord_t*                asSWordPtr;
    DWord_t*                asDWordPtr;
    SDWord_t*               asSDWordPtr;
    QWord_t*                asQWordPtr;
    SQWord_t*               asSQWordPtr;
    Float64_t               asFloat64;
    Float32_t               asFloat32;
    hive_instruction_t*     asInstrPtr;
} hive_register_t;

typedef union {
    struct {
        uint8_t             zero:1;
        uint8_t             negative:1;
    } PACKED flags;
    DWord_t dword;
} PACKED hive_flag_register_t;

#ifdef static_assert
static_assert(sizeof(hive_flag_register_t) == sizeof(DWord_t), "hive_flag_register_t is wrong size");
#endif

#define REG_LR 29
#define REG_SP 30
#define REG_PC 31

#define SIZE_8BIT 0
#define SIZE_16BIT 1
#define SIZE_32BIT 2
#define SIZE_64BIT 3

#define INT_UD 0x01 // Undefined opcode
#define INT_PF 0x02 // Page fault
#define INT_IL 0x03 // Illegal instruction
#define INT_IP 0x04 // Insufficient privileges

#define COND_EQ     0b000
#define COND_NE     0b100
#define COND_LE     0b001
#define COND_GT     0b101
#define COND_LT     0b010
#define COND_GE     0b110
#define COND_ALWAYS 0b011
#define COND_NEVER  0b111

#define SVC_exit        0
#define SVC_read        1
#define SVC_write       2
#define SVC_open        3
#define SVC_close       4
#define SVC_malloc      5
#define SVC_free        6
#define SVC_realloc     7
#define SVC_coredump    8

#if __has_attribute(fallthrough)
#define case_fallthrough __attribute__((fallthrough))
#else
#define case_fallthrough (void) 0
#endif

typedef struct {
    hive_register_t r[32];
    hive_flag_register_t flags;
} hive_register_file_t;

typedef enum _TokenType {
    Eof,
    Identifier,
    Register,
    VecRegister,
    Label,
    Number,
    NumberFloat,
    String,
    Directive,
    LeftBracket,
    RightBracket,
    Comma,
    Plus,
    Minus,
    Bang,
} TokenType;

typedef struct _Token {
    char* value;
    TokenType type;
    char* file;
    int line;
} Token;

typedef struct {
    Token* items;
    size_t count;
    size_t capacity;
} Token_Array;

typedef struct {
    struct symbol_offset {
        char* name;
        uint64_t offset;
        enum symbol_type {
            sym_abs,
            sym_branch,
            sym_load,
        } type;
        enum symbol_flag {
            sf_exported = 1,
        } flags;
    } *items;
    size_t count;
    size_t capacity;
} Symbol_Offsets;

typedef struct {
    uint32_t type;
    size_t len;
    char* data;
} Section;

typedef struct {
    Section* items;
    size_t count;
    size_t capacity;
} Section_Array;

typedef struct {
    uint32_t magic;
    const char* name;
    Section_Array sects;
} HiveFile;

#define SECT_TYPE_CODE  0x01
#define SECT_TYPE_SYMS  0x02
#define SECT_TYPE_RELOC 0x04
#define SECT_TYPE_LD    0x08

#define HIVE_PAGE_SIZE 0x4000

#define PAGE_FLAG_READ  0x01
#define PAGE_FLAG_WRITE 0x02
#define PAGE_FLAG_EXEC  0x04

typedef struct {
    HiveFile* items;
    size_t count;
    size_t capacity;
} HiveFile_Array;

HiveFile read_hive_file(FILE* fp);
void get_all_files(const char* name, HiveFile_Array* current, bool must_be_fat);
void write_hive_file(HiveFile hf, FILE* fp);
Symbol_Offsets create_symbol_section(Section s);
Symbol_Offsets create_relocation_section(Section s);
Nob_File_Paths create_ld_section(Section s);
Section get_section(HiveFile f, uint32_t sect_type);
char* get_code_section_address(HiveFile f);
uint64_t find_symbol_address(Symbol_Offsets syms, char* name);
struct symbol_offset find_symbol(Symbol_Offsets syms, char* name);
Nob_String_Builder pack_symbol_table(Symbol_Offsets syms);
Nob_String_Builder pack_relocation_table(Symbol_Offsets relocs);
void relocate(Section code_sect, Symbol_Offsets relocs, Symbol_Offsets symbols);
Symbol_Offsets prepare(HiveFile_Array hf, bool try_relocate);
