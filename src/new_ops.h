#pragma once

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

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
#define CONDITION_AND_TYPE uint8_t __header: 5

typedef QWord_t(*svc_call)(QWord_t,QWord_t,QWord_t,QWord_t,QWord_t,QWord_t,QWord_t,QWord_t);

typedef union {
    DWord_t word;
    struct {
        PAD(27);
        uint8_t type: 2;
        uint8_t condition: 3;
    } PACKED generic;
    struct {
        int32_t offset: 25;
        uint8_t type: 2;
        CONDITION_AND_TYPE;
    } PACKED type_branch_generic;
    struct {
        int32_t offset: 25;
        uint8_t link: 1;
        uint8_t is_reg: 1;
        CONDITION_AND_TYPE;
    } PACKED type_branch;
    struct {
        PAD(20);
        uint8_t r1: 5;
        uint8_t link: 1;
        uint8_t is_reg: 1;
        CONDITION_AND_TYPE;
    } PACKED type_branch_register;
    struct {
        PAD(8);
        uint8_t data_op: 4;
        PAD(15);
        CONDITION_AND_TYPE;
    } PACKED type_data;
    struct {
        uint8_t r3: 5;
        PAD(3);
        uint8_t use_imm: 1;
        uint8_t salu: 1;
        uint8_t data_op: 2;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t no_writeback: 1;
        uint8_t op: 4;
        CONDITION_AND_TYPE;
    } PACKED type_data_alur;
    struct {
        uint8_t imm;
        uint8_t use_imm: 1;
        uint8_t salu: 1;
        uint8_t data_op: 2;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t no_writeback: 1;
        uint8_t op: 4;
        CONDITION_AND_TYPE;
    } PACKED type_data_alui;
    struct {
        int8_t imm;
        uint8_t data_op: 4;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t update_ptr: 1;
        uint8_t size: 2;
        uint8_t is_store: 1;
        uint8_t use_immediate: 1;
        CONDITION_AND_TYPE;
    } PACKED type_data_ls_imm;
    struct {
        uint16_t imm: 6;
        uint8_t shift: 2;
        uint8_t data_op: 4;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t update_ptr: 1;
        uint8_t size: 2;
        uint8_t is_store: 1;
        uint8_t shift_hi: 1;
        CONDITION_AND_TYPE;
    } PACKED type_data_ls_far;
    struct {
        uint8_t r3: 5;
        PAD(3);
        uint8_t data_op: 4;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t update_ptr: 1;
        uint8_t size: 2;
        uint8_t is_store: 1;
        uint8_t use_immediate: 1;
        CONDITION_AND_TYPE;
    } PACKED type_data_ls_reg;
    struct {
        uint8_t r3: 5;
        PAD(1);
        uint8_t is_single_op: 1;
        uint8_t use_int_arg2: 1;
        uint8_t data_op: 4;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t no_writeback: 1;
        uint8_t op: 4;
        CONDITION_AND_TYPE;
    } PACKED type_data_fpu;
    struct {
        uint8_t v3: 4;
        PAD(4);
        uint8_t data_op: 4;
        uint8_t v1: 4;
        uint8_t v2: 4;
        uint8_t mode: 3;
        uint8_t op: 4;
        CONDITION_AND_TYPE;
    } PACKED type_data_vpu;
    struct {
        uint8_t target_mode: 3;
        PAD(5);
        uint8_t data_op: 4;
        uint8_t v1: 4;
        uint8_t v2: 4;
        uint8_t mode: 3;
        uint8_t op: 4;
        CONDITION_AND_TYPE;
    } PACKED type_data_vpu_conv;
    struct {
        uint8_t r2: 5;
        uint8_t slot_lo: 3;
        uint8_t data_op: 4;
        uint8_t v1: 4;
        uint8_t slot_hi: 2;
        PAD(2);
        uint8_t mode: 3;
        uint8_t op: 4;
        CONDITION_AND_TYPE;
    } PACKED type_data_vpu_mov;
    struct {
        uint8_t r1: 5;
        PAD(3);
        uint8_t data_op: 4;
        uint8_t v1: 4;
        PAD(4);
        uint8_t mode: 3;
        uint8_t op: 4;
        CONDITION_AND_TYPE;
    } PACKED type_data_vpu_len;
    struct {
        uint8_t r2: 5;
        PAD(3);
        uint8_t data_op: 4;
        uint8_t v1: 4;
        uint8_t r1: 5;
        uint8_t update_ptr: 1;
        uint8_t use_imm: 1;
        uint8_t op: 4;
        CONDITION_AND_TYPE;
    } PACKED type_data_vpu_ls;
    struct {
        int8_t imm;
        uint8_t data_op: 4;
        uint8_t v1: 4;
        uint8_t r1: 5;
        uint8_t update_ptr: 1;
        uint8_t use_imm: 1;
        uint8_t op: 4;
        CONDITION_AND_TYPE;
    } PACKED type_data_vpu_ls_imm;
    struct {
        uint8_t start: 6;
        uint8_t count_lo: 1;
        uint8_t extend: 1;
        uint8_t is_dep: 1;
        uint8_t data_op: 3;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t count_hi: 5;
        CONDITION_AND_TYPE;
    } PACKED type_data_bit;
    struct {
        uint32_t imm: 20;
        uint8_t r1: 5;
        uint8_t op: 2;
        CONDITION_AND_TYPE;
    } PACKED type_load;
    struct {
        int32_t imm: 20;
        uint8_t r1: 5;
        uint8_t op: 2;
        CONDITION_AND_TYPE;
    } PACKED type_load_signed;
    struct {
        int32_t imm: 19;
        uint8_t is_store: 1;
        uint8_t r1: 5;
        uint8_t op: 2;
        CONDITION_AND_TYPE;
    } PACKED type_load_ls_off;
    struct {
        uint16_t imm;
        uint8_t shift: 2;
        uint8_t no_zero: 1;
        PAD(1);
        uint8_t r1: 5;
        uint8_t op: 2;
        CONDITION_AND_TYPE;
    } PACKED type_load_mov;
    struct {
        PAD(22);
        uint8_t op: 5;
        CONDITION_AND_TYPE;
    } PACKED type_other;
    struct {
        uint8_t size: 2;
        PAD(20);
        uint8_t op: 5;
        CONDITION_AND_TYPE;
    } PACKED type_other_size_override;
    struct {
        uint8_t from: 2;
        uint8_t to: 2;
        PAD(8);
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t op: 5;
        CONDITION_AND_TYPE;
    } PACKED type_other_signextend;
    struct {
        PAD(17);
        uint8_t priv_op: 5;
        uint8_t op: 5;
        CONDITION_AND_TYPE;
    } PACKED type_other_priv;
    struct {
        uint8_t target_thread_reg: 5;
        uint8_t target_reg: 5;
        uint8_t value_reg: 5;
        PAD(2);
        uint8_t priv_op: 5;
        uint8_t op: 5;
        CONDITION_AND_TYPE;
    } PACKED type_other_priv_transfer;
    struct {
        uint8_t r1: 5;
        PAD(12);
        uint8_t priv_op: 5;
        uint8_t op: 5;
        CONDITION_AND_TYPE;
    } PACKED type_other_priv_xsl;
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
        uint16_t            cpuid:16;
        uint8_t             size:2;
    } PACKED flags;
    DWord_t dword;
} PACKED hive_flag_register_t;

#ifdef static_assert
static_assert(sizeof(hive_flag_register_t) == sizeof(DWord_t), "hive_flag_register_t is wrong size");
#endif

#define REG_LR 29
#define REG_SP 30
#define REG_PC 31

#define SIZE_8BIT   0b00
#define SIZE_16BIT  0b01
#define SIZE_32BIT  0b10
#define SIZE_64BIT  0b11

#define INT_UD 0x01 // Undefined opcode
#define INT_PF 0x02 // Page fault
#define INT_IL 0x03 // Illegal instruction
#define INT_IP 0x04 // Insufficient privileges

#define FLAG_NOT    0b100

#define FLAG_EQ     0b000
#define FLAG_LE     0b001
#define FLAG_LT     0b010
#define FLAG_ALWAYS 0b011

#define COND_EQ     (FLAG_EQ)
#define COND_LE     (FLAG_LE)
#define COND_LT     (FLAG_LT)
#define COND_ALWAYS (FLAG_ALWAYS)
#define COND_NE     (FLAG_NOT | FLAG_EQ)
#define COND_GT     (FLAG_NOT | FLAG_LE)
#define COND_GE     (FLAG_NOT | FLAG_LT)
#define COND_NEVER  (FLAG_NOT | FLAG_ALWAYS)

#define SVC_exit            0
#define SVC_read            1
#define SVC_write           2
#define SVC_open            3
#define SVC_close           4
#define SVC_mmap            5
#define SVC_munmap          6
#define SVC_mprotect        7
#define SVC_fstat           8

#ifndef CORE_COUNT
#define CORE_COUNT 6
#endif

#ifndef THREAD_COUNT
#define THREAD_COUNT 3
#endif

#define STACK_SIZE (1024 * 1024)

#if __has_attribute(fallthrough)
#define case_fallthrough __attribute__((fallthrough))
#else
#define case_fallthrough (void) 0
#endif

struct cpu_state {
    hive_register_t r[32];
    hive_vector_register_t v[16];
    hive_flag_register_t fr;
};

struct cpu_transfer {
    volatile bool request;
    uint8_t dest_reg;
    QWord_t value;
};

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
    char* name;
    uint64_t section;
    uint64_t offset;
    enum symbol_flag {
        sf_exported = 1,
    } flags;
} Symbol;

typedef struct {
    uint64_t source_section;
    uint64_t source_offset;
    uint8_t is_local;
    enum reloc_type {
        sym_abs,
        sym_branch,
        sym_load,
        sym_ls_off,
    } type;
    union {
        char* name;
        struct {
            uint64_t target_section;
            uint64_t target_offset;
        } local;
    } data;
} Relocation;

typedef struct {
    Symbol* items;
    size_t count;
    size_t capacity;
} Symbol_Array;

typedef struct {
    Relocation* items;
    size_t count;
    size_t capacity;
} Relocation_Array;

typedef struct {
    uint8_t type;
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

typedef struct {
    Nob_String_Builder data;
    uint64_t type;
} CompilerSection;

typedef struct {
    CompilerSection* items;
    size_t count;
    size_t capacity;
} SB_Array;

#define SECT_TYPE_SYMS      0b00000001
#define SECT_TYPE_RELOC     0b00000010
#define SECT_TYPE_LD        0b00000100

#define SECT_TYPE_TEXT      0b10000000
#define SECT_TYPE_DATA      0b10000001
#define SECT_TYPE_BSS       0b10000010

#define SECT_TYPE_NOEMIT    0b01111111

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
void get_all_files(const char* name, HiveFile_Array* current, bool must_be_fat, bool do_dyload);
void write_hive_file(HiveFile hf, FILE* fp);
Symbol_Array create_symbol_section(Section s);
Relocation_Array create_relocation_section(Section s);
Nob_File_Paths create_ld_section(Section s);
Section get_section(HiveFile f, uint8_t sect_type);
char* get_code_section_address(HiveFile f);
uint64_t find_symbol_address(Symbol_Array syms, char* name);
Symbol find_symbol(Symbol_Array syms, char* name);
Nob_String_Builder pack_symbol_table(Symbol_Array syms);
Nob_String_Builder pack_ld_section(Nob_File_Paths dylibs);
Nob_String_Builder pack_relocation_table(Relocation_Array relocs);
void relocate(Section_Array sects, Relocation_Array relocs, Symbol_Array symbols);
void prepare(HiveFile_Array hf, bool try_relocate, Symbol_Array* all_syms);
int debug(int argc, char** argv);
void exec(void* start);
void disassemble(Section code_sect, Symbol_Array syms, Relocation_Array relocations);
SB_Array run_compile(const char* file_name, Symbol_Array* syms, Relocation_Array* relocations);
