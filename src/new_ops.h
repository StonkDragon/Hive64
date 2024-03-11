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
#define TYPE_PAD PAD(3)

typedef union {
    struct {
        PAD(29);
        uint8_t type: 3;
    } PACKED generic;
    struct {
        int32_t offset: 25;
        uint8_t link: 1;
        uint8_t op: 3;
        TYPE_PAD;
    } PACKED branch;
    struct {
        int32_t offset: 19;
        uint8_t zero: 1;
        uint8_t r1: 5;
        uint8_t link: 1;
        uint8_t op: 3;
        TYPE_PAD;
    } PACKED comp_branch;
    struct {
        uint16_t imm: 12;
        PAD(3);
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t op: 4;
        TYPE_PAD;
    } PACKED rri;
    struct {
        int16_t imm: 12;
        uint8_t update_ptr: 1;
        uint8_t size: 2;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t op: 4;
        TYPE_PAD;
    } PACKED rri_ls;
    struct {
        uint8_t lowest: 6;
        uint8_t nbits: 6;
        uint8_t sign_extend: 1;
        PAD(2);
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t op: 4;
        TYPE_PAD;
    } PACKED rri_bit;
    struct {
        PAD(18);
        uint8_t mode: 3;
        uint8_t op: 4;
        PAD(4);
        TYPE_PAD;
    } PACKED vpu;
    struct {
        uint8_t v1: 4;
        uint8_t r2: 5;
        uint8_t slot: 5;
        PAD(4);
        uint8_t mode: 3;
        uint8_t op: 4;
        PAD(4);
        TYPE_PAD;
    } PACKED vpu_mov;
    struct {
        uint8_t v1: 4;
        uint8_t v2: 4;
        PAD(10);
        uint8_t mode: 3;
        uint8_t op: 4;
        PAD(4);
        TYPE_PAD;
    } PACKED vpu_mov_vec;
    struct {
        uint8_t v1: 4;
        uint8_t v2: 4;
        PAD(7);
        uint8_t target_mode: 3;
        uint8_t mode: 3;
        uint8_t op: 4;
        PAD(4);
        TYPE_PAD;
    } PACKED vpu_conv;
    struct {
        uint8_t v1: 4;
        uint8_t v2: 4;
        uint8_t v3: 4;
        PAD(6);
        uint8_t mode: 3;
        uint8_t op: 4;
        PAD(4);
        TYPE_PAD;
    } PACKED vpu_arith;
    struct {
        uint8_t r1: 5;
        uint8_t v1: 4;
        PAD(9);
        uint8_t mode: 3;
        uint8_t op: 4;
        PAD(4);
        TYPE_PAD;
    } PACKED vpu_len;
    struct {
        uint8_t r3: 5;
        uint8_t r2: 5;
        uint8_t r1: 5;
        PAD(10);
        uint8_t op: 4;
        TYPE_PAD;
    } PACKED rrr;
    struct {
        uint8_t r3: 5;
        uint8_t r2: 5;
        uint8_t r1: 5;
        PAD(5);
        uint8_t mode: 1;
        uint8_t op: 4;
        PAD(4);
        TYPE_PAD;
    } PACKED float_rrr;
    struct {
        uint8_t r3: 5;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint16_t size: 2;
        uint8_t update_ptr: 1;
        PAD(7);
        uint8_t op: 4;
        TYPE_PAD;
    } PACKED rrr_ls;
    struct {
        uint32_t imm: 20;
        uint8_t r1: 5;
        uint8_t op: 4;
        TYPE_PAD;
    } PACKED ri;
    struct {
        PAD(20);
        uint8_t r1: 5;
        uint8_t link: 1;
        uint8_t op: 3;
        TYPE_PAD;
    } PACKED ri_branch;
    struct {
        uint8_t r2: 5;
        uint8_t zero: 1;
        PAD(13);
        uint8_t r1: 5;
        uint8_t link: 1;
        uint8_t op: 4;
        TYPE_PAD;
    } PACKED ri_cbranch;
    struct {
        int32_t imm: 20;
        uint8_t r1: 5;
        uint8_t op: 4;
        TYPE_PAD;
    } PACKED ri_s;
    struct {
        uint16_t imm;
        PAD(1);
        uint8_t shift: 2;
        uint8_t no_zero: 1;
        uint8_t r1: 5;
        uint8_t op: 4;
        TYPE_PAD;
    } PACKED ri_mov;
} PACKED hive_instruction_t;

#ifdef static_assert
static_assert(sizeof(((hive_instruction_t*) NULL)->generic) == sizeof(DWord_t), "hive_instruction_t::generic is wrong size");
static_assert(sizeof(((hive_instruction_t*) NULL)->branch) == sizeof(DWord_t), "hive_instruction_t::branch is wrong size");
static_assert(sizeof(((hive_instruction_t*) NULL)->comp_branch) == sizeof(DWord_t), "hive_instruction_t::comp_branch is wrong size");
static_assert(sizeof(((hive_instruction_t*) NULL)->rri) == sizeof(DWord_t), "hive_instruction_t::rri is wrong size");
static_assert(sizeof(((hive_instruction_t*) NULL)->rri_ls) == sizeof(DWord_t), "hive_instruction_t::rri_ls is wrong size");
static_assert(sizeof(((hive_instruction_t*) NULL)->rri_bit) == sizeof(DWord_t), "hive_instruction_t::rri_bit is wrong size");
static_assert(sizeof(((hive_instruction_t*) NULL)->vpu) == sizeof(DWord_t), "hive_instruction_t::vpu is wrong size");
static_assert(sizeof(((hive_instruction_t*) NULL)->vpu_mov) == sizeof(DWord_t), "hive_instruction_t::vpu_mov is wrong size");
static_assert(sizeof(((hive_instruction_t*) NULL)->vpu_mov_vec) == sizeof(DWord_t), "hive_instruction_t::vpu_mov_vec is wrong size");
static_assert(sizeof(((hive_instruction_t*) NULL)->vpu_conv) == sizeof(DWord_t), "hive_instruction_t::vpu_conv is wrong size");
static_assert(sizeof(((hive_instruction_t*) NULL)->vpu_arith) == sizeof(DWord_t), "hive_instruction_t::vpu_arith is wrong size");
static_assert(sizeof(((hive_instruction_t*) NULL)->vpu_len) == sizeof(DWord_t), "hive_instruction_t::vpu_len is wrong size");
static_assert(sizeof(((hive_instruction_t*) NULL)->rrr) == sizeof(DWord_t), "hive_instruction_t::rrr is wrong size");
static_assert(sizeof(((hive_instruction_t*) NULL)->float_rrr) == sizeof(DWord_t), "hive_instruction_t::float_rrr is wrong size");
static_assert(sizeof(((hive_instruction_t*) NULL)->rrr_ls) == sizeof(DWord_t), "hive_instruction_t::rrr_ls is wrong size");
static_assert(sizeof(((hive_instruction_t*) NULL)->ri) == sizeof(DWord_t), "hive_instruction_t::ri is wrong size");
static_assert(sizeof(((hive_instruction_t*) NULL)->ri_branch) == sizeof(DWord_t), "hive_instruction_t::ri_branch is wrong size");
static_assert(sizeof(((hive_instruction_t*) NULL)->ri_cbranch) == sizeof(DWord_t), "hive_instruction_t::ri_cbranch is wrong size");
static_assert(sizeof(((hive_instruction_t*) NULL)->ri_s) == sizeof(DWord_t), "hive_instruction_t::ri_s is wrong size");
static_assert(sizeof(((hive_instruction_t*) NULL)->ri_mov) == sizeof(DWord_t), "hive_instruction_t::ri_mov is wrong size");
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

typedef struct {
    uint8_t             negative:1;
    uint8_t             equal:1;
    uint8_t             pipeline_invalid:1;
    uint64_t            reserved:29;
} PACKED hive_flag_register_t;

#define REG_LR 29
#define REG_SP 30
#define REG_PC 31

typedef struct {
    hive_register_t r[32];
    hive_flag_register_t flags;
} hive_register_file_t;

enum exec_mode {
    MODE_HYPERVISOR,
    MODE_SUPERVISOR,
    MODE_USER,
    MODE_COUNT
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
    SimdRegister,
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
            st_abs,
            st_data,
            st_ri,
            st_cb,
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
