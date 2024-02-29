#pragma once

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define PACKED _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Wattribute-packed-for-bitfield\"") __attribute__((packed)) _Pragma("clang diagnostic pop")

#include "nob.h"
#include "opcode.h"

typedef __uint128_t DQWord_t;
typedef uint64_t QWord_t;
typedef uint32_t DWord_t;
typedef uint16_t Word_t;
typedef uint8_t Byte_t;
typedef int64_t SQWord_t;
typedef int32_t SDWord_t;
typedef int16_t SWord_t;
typedef int8_t SByte_t;
typedef void* Pointer_t;
typedef void** PointerPointer_t;
typedef uint16_t* Uint16Ptr_t;
typedef double Float64_t;
typedef float Float32_t;

#define CONCAT_(a, b) a ## b
#define CONCAT(a, b) CONCAT_(a, b)

#define PAD(_n) uint32_t CONCAT(_, __LINE__) : _n
#define TYPE_PAD PAD(2)

typedef union {
    struct {
        uint8_t type: 2;
        PAD(30);
    } PACKED generic;
    struct {
        TYPE_PAD;
        uint8_t op: 3;
        uint8_t link: 1;
        int32_t offset: 26;
    } PACKED branch;
    struct {
        TYPE_PAD;
        uint8_t op: 3;
        uint8_t link: 1;
        uint8_t r1: 5;
        uint8_t zero: 1;
        int32_t offset: 20;
    } PACKED comp_branch;
    struct {
        TYPE_PAD;
        uint8_t op: 5;
        uint8_t r1: 5;
        uint8_t r2: 5;
        uint16_t imm: 15;
    } PACKED rri;
    struct {
        TYPE_PAD;
        uint8_t op: 5;
        uint8_t size: 2;
        uint8_t r1: 5;
        uint8_t r2: 5;
        uint8_t r3: 5;
        uint8_t imm: 8;
    } PACKED rri_rpairs;
    struct {
        TYPE_PAD;
        uint8_t op: 5;
        uint8_t r1: 5;
        uint8_t r2: 5;
        uint8_t size: 2;
        int16_t imm: 13;
    } PACKED rri_ls;
    struct {
        TYPE_PAD;
        uint8_t op: 5;
        uint8_t r1: 5;
        uint8_t sign_extend: 1;
        uint8_t r2: 5;
        uint8_t nbits: 6;
        PAD(2);
        uint8_t lowest: 6;
    } PACKED rri_bit;
    struct {
        TYPE_PAD;
        uint8_t op: 6;
        PAD(3);
        uint8_t r1: 5;
        PAD(3);
        uint8_t r2: 5;
        PAD(3);
        uint8_t r3: 5;
    } PACKED rrr;
    struct {
        TYPE_PAD;
        PAD(6);
        uint8_t op: 4;
        uint8_t r1: 5;
        PAD(2);
        uint8_t r2: 5;
        PAD(3);
        uint8_t r3: 5;
    } PACKED float_rrr;
    struct {
        TYPE_PAD;
        uint8_t op: 6;
        uint8_t r1: 5;
        PAD(1);
        uint8_t r2: 5;
        PAD(1);
        uint8_t size: 2;
        uint8_t r3: 5;
        uint8_t r4: 5;
    } PACKED rrr_rpairs;
    struct {
        TYPE_PAD;
        uint8_t op: 6;
        PAD(1);
        uint16_t size: 2;
        uint8_t r1: 5;
        PAD(3);
        uint8_t r2: 5;
        PAD(3);
        uint8_t r3: 5;
    } PACKED rrr_ls;
    struct {
        TYPE_PAD;
        uint8_t is_branch: 1;
        uint8_t op: 4;
        uint8_t r1: 5;
        uint32_t imm: 20;
    } PACKED ri;
    struct {
        TYPE_PAD;
        uint8_t op: 4;
        uint8_t link: 1;
        uint8_t r1: 5;
        PAD(20);
    } PACKED ri_branch;
    struct {
        TYPE_PAD;
        uint8_t op: 4;
        uint8_t link: 1;
        uint8_t r1: 5;
        PAD(14);
        uint8_t zero: 1;
        uint8_t r2: 5;
    } PACKED ri_cbranch;
    struct {
        TYPE_PAD;
        uint8_t is_branch: 1;
        uint8_t op: 4;
        uint8_t r1: 5;
        int32_t imm: 20;
    } PACKED ri_s;
    struct {
        TYPE_PAD;
        uint8_t is_branch: 1;
        uint8_t op: 4;
        PAD(1);
        uint8_t no_zero: 1;
        uint8_t shift: 2;
        uint8_t r1: 5;
        uint16_t imm;
    } PACKED ri_mov;
} PACKED hive_instruction_t;

#ifdef static_assert
static_assert(sizeof(hive_instruction_t) == sizeof(DWord_t), "hive_instruction_t is wrong size");
#endif

typedef union {
    Byte_t      asBytes[32];
    Word_t      asWords[16];
    DWord_t     asDWords[8];
    QWord_t     asQWords[4];
    DQWord_t    asDQWords[2];
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
    uint64_t            reserved:30;
} PACKED hive_flag_register_t;

typedef struct {
    hive_register_t r[29];
    hive_register_t lr;
    hive_register_t sp;
    hive_register_t pc;
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
Symbol_Offsets prepare(HiveFile_Array hf);
