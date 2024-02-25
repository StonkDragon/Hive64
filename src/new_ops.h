#pragma once

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define PACKED _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Wattribute-packed-for-bitfield\"") __attribute__((packed)) _Pragma("clang diagnostic pop")

#include "opcode.h"

typedef __uint128_t Word128_t;
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

typedef union {
    struct {
        uint8_t type: 2;
        uint32_t data: 30;
    } PACKED generic;
    struct {
        uint8_t type: 2;
        uint8_t op: 5;
        uint32_t data: 25;
    } PACKED data;
    struct {
        uint8_t type: 2;
        uint8_t op: 5;
        int32_t data: 25;
    } PACKED data_s;
    struct {
        uint8_t type: 2;
        uint8_t op: 5;
        uint16_t imm: 15;
        uint8_t r1: 5;
        uint8_t r2: 5;
    } PACKED rri;
    struct {
        uint8_t type: 2;
        uint8_t op: 5;
        int16_t imm: 15;
        uint8_t r1: 5;
        uint8_t r2: 5;
    } PACKED rri_s;
    struct {
        uint8_t type: 2;
        uint8_t op: 6;
        uint16_t instr_spec: 9;
        uint8_t r1: 5;
        uint8_t r2: 5;
        uint8_t r3: 5;
    } PACKED rrr;
    struct {
        uint8_t type: 2;
        uint8_t op: 5;
        uint32_t imm: 20;
        uint8_t r1: 5;
    } PACKED ri;
    struct {
        uint8_t type: 2;
        uint8_t op: 5;
        uint8_t shift: 4;
        uint16_t imm: 16;
        uint8_t r1: 5;
    } PACKED ri_mov;
    struct {
        uint8_t type: 2;
        uint8_t op: 5;
        int32_t imm: 20;
        uint8_t r1: 5;
    } PACKED ri_s;
} PACKED hive_instruction_t;

typedef union hive_register_t {
    QWord_t             asQWord;
    Word_t              asWords[4];
    DWord_t             asDWord;
    Word_t              asWord;
    Byte_t              asByte;
    SQWord_t            asSQWord;
    SDWord_t            asSDWord;
    SWord_t             asSWord;
    SByte_t             asSByte;
    Pointer_t           asPointer;
    Byte_t*             asBytePtr;
    SByte_t*            asSBytePtr;
    Word_t*             asWordPtr;
    SWord_t*            asSWordPtr;
    DWord_t*            asDWordPtr;
    SDWord_t*           asSDWordPtr;
    QWord_t*            asQWordPtr;
    SQWord_t*           asSQWordPtr;
    Float64_t           asFloat64;
    Float32_t           asFloat32;
    hive_instruction_t* asInstrPtr;
    uint8_t             bytes[8];
} hive_register_t;

typedef struct {
    uint64_t            reserved:62;
    uint8_t             negative:1;
    uint8_t             equal:1;
} PACKED hive_flag_register_t;

typedef union {
    hive_register_t r[32];
    struct {
        hive_register_t r[28];
        hive_flag_register_t flags;
        hive_register_t lr;
        hive_register_t sp;
        hive_register_t pc;
    } spec PACKED;
} hive_register_file_t;

enum exec_mode {
    MODE_HYPERVISOR,
    MODE_SUPERVISOR,
    MODE_USER,
    MODE_COUNT
};

typedef union {
    Word128_t           asWord128[4];
    QWord_t             asQWords[8];
    Float64_t           asFloat64s[8];
    DWord_t             asDWords[16];
    Float32_t           asFloat32s[16];
    Word_t              asWords[32];
    Byte_t              asBytes[64];
    SQWord_t            asSQWords[8];
    SDWord_t            asSDWords[16];
    SWord_t             asSWords[32];
    SByte_t             asSBytes[64];
} hive_simd_register_t;

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
    } *items;
    size_t count;
    size_t capacity;
} Symbol_Offsets;

typedef struct {
    uint32_t type;
    uint32_t len;
    char* data;
} Section;

typedef struct {
    Section* items;
    size_t count;
    size_t capacity;
} Section_Array;

typedef struct {
    uint32_t magic;
    Section_Array sects;
} HiveFile;
