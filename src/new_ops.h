#pragma once

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define PACKED _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Wattribute-packed-for-bitfield\"") __attribute__((packed)) _Pragma("clang diagnostic pop")

#include "nob.h"
#include "opcode.h"
#include "preproc.h"

#define HIVE_FILE_MAGIC 0xFEEDF00D
#define HIVE64_FILE_MAGIC 0x1337C0DE
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
        uint8_t cond: 3;
        uint8_t data_op: 4;
        uint8_t r2: 5;
        uint8_t r1: 5;
        PAD(5);
        CONDITION_AND_TYPE;
    } PACKED type_data_cswap;
    struct {
        PAD(8);
        uint8_t data_op: 4;
        uint8_t r2: 5;
        uint8_t r1: 5;
        PAD(5);
        CONDITION_AND_TYPE;
    } PACKED type_data_xchg;
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
        uint8_t from: 2;
        uint8_t to: 2;
        PAD(4);
        uint8_t data_op: 4;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t no_writeback: 1;
        uint8_t op: 4;
        CONDITION_AND_TYPE;
    } PACKED type_data_sext;
    struct {
        int8_t imm;
        uint8_t data_op: 4;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t update_ptr: 1;
        uint8_t is_store: 1;
        uint8_t use_immediate: 1;
        PAD(2);
        CONDITION_AND_TYPE;
    } PACKED type_data_ls_imm;
    struct {
        uint8_t imm;
        uint8_t data_op: 4;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t update_ptr: 1;
        uint8_t is_store: 1;
        uint8_t shift: 3;
        CONDITION_AND_TYPE;
    } PACKED type_data_ls_far;
    struct {
        uint8_t r3: 5;
        PAD(3);
        uint8_t data_op: 4;
        uint8_t r2: 5;
        uint8_t r1: 5;
        uint8_t update_ptr: 1;
        uint8_t is_store: 1;
        uint8_t use_immediate: 1;
        PAD(2);
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
        uint8_t r1: 5;
        PAD(17);
        uint8_t op: 5;
        CONDITION_AND_TYPE;
    } PACKED type_other_zeroupper;
    struct {
        uint8_t size: 2;
        uint8_t reset_flags: 1;
        uint8_t reg_override: 4;
        uint8_t references_cr: 4;
        PAD(11);
        uint8_t op: 5;
        CONDITION_AND_TYPE;
    } PACKED type_other_prefix;
    struct {
        PAD(17);
        uint8_t priv_op: 5;
        uint8_t op: 5;
        CONDITION_AND_TYPE;
    } PACKED type_other_priv;
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

typedef struct {
    uint8_t             zero:1;
    uint8_t             negative:1;
    uint8_t             size:2;
    uint8_t             reg_state:4;
    uint8_t             references_cr:4;
    #define EM_HYPERVISOR 0
    #define EM_SUPERVISOR 1
    #define EM_USER 2
} PACKED hive_flag_register_t;

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

    struct {
        SDWord_t            low;
        SDWord_t            high;
    }                       asSDWordPair;
    struct {
        SWord_t             low;
        SWord_t             high;
    }                       asSWordPair;
    struct {
        SByte_t             low;
        SByte_t             high;
    }                       asSBytePair;
    struct {
        DWord_t             low;
        DWord_t             high;
    }                       asDWordPair;
    struct {
        Word_t              low;
        Word_t              high;
    }                       asWordPair;
    struct {
        Byte_t              low;
        Byte_t              high;
    }                       asBytePair;

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
    hive_flag_register_t    asFlags;
} hive_register_t;

#ifdef static_assert
static_assert(sizeof(hive_flag_register_t) <= sizeof(QWord_t), "hive_flag_register_t is wrong size");
#endif

#define REG_SRC1 1
#define REG_SRC2 2
#define REG_SRC3 3
#define REG_DEST 0

#define IS_HIGH(_num) (1 << _num)

#define REG_LR 29
#define REG_SP 30
#define REG_PC 31

#define CR_CYCLES 0
#define CR_CORES 1
#define CR_THREADS 2
#define CR_CPUID 3
#define CR_FLAGS 4
#define CR_IDT 5
#define CR_INT_ID 6
#define CR_RUNLEVEL 7

#define CR_UTIL1 10
#define CR_UTIL2 11

#define SIZE_8BIT   0b00
#define SIZE_16BIT  0b01
#define SIZE_32BIT  0b10
#define SIZE_64BIT  0b11

#define INT_UD 0x01 // Undefined opcode
#define INT_PF 0x02 // Page fault
#define INT_GP 0x02 // General protection
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
#define SVC_sys_mmap        5
#define SVC_munmap          6
#define SVC_mprotect        7
#define SVC_fstat           8

void* sys_mmap(void* addr, size_t sz, int prot, int map, int fd, long long off);

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
    hive_register_t cr[12];
};

struct cpu_transfer {
    volatile bool request;
    uint8_t dest_reg;
    QWord_t value;
};

typedef enum _TokenType {
    Eof,
    Identifier,
    Register8,
    Register16,
    Register32,
    Register64,
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
    ControlRegister,
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
    size_t len_unpacked;
    char* data;
    void* ld_at;
} Section;

typedef struct {
    Section* items;
    size_t count;
    size_t capacity;
} Section_Array;

typedef struct {
    Nob_String_Builder data;
    uint64_t type;
} CompilerSection;

typedef struct {
    CompilerSection* items;
    size_t count;
    size_t capacity;
} SB_Array;
typedef struct {
    hive_instruction_t* items;
    size_t count;
    size_t capacity;
} Instr_Array;

typedef Section LoadCommand;

typedef struct {
    LoadCommand* items;
    size_t count;
    size_t capacity;
} LoadCommand_Array;

typedef Nob_File_Paths Library_Array;

typedef struct Hive64File {
    uint32_t magic;
    uint16_t v_maj;
    uint16_t v_min;
    uint32_t filetype;
    Relocation_Array relocations;
    LoadCommand_Array load_commands;
    Symbol_Array symbols;
    Library_Array libraries;
} Hive64File;

typedef struct {
    Hive64File* items;
    size_t count;
    size_t capacity;
} Hive64File_Array;

#define SECT_TYPE_TEXT      0b00000001
#define SECT_TYPE_DATA      0b00000010
#define SECT_TYPE_BSS       0b00000100
#define SECT_TYPE_ZERO      0b00001000

#define SECT_TYPE_NOEMIT    0b11111111

#define HIVE_PAGE_SHIFT 14
#define HIVE_PAGE_SIZE (1ULL << HIVE_PAGE_SHIFT)
#define HIVE_MEMORY_SIZE (0x0000100000000000ULL)
#define HIVE_MEMORY_BASE ((void*) 0x0000100000000000ULL)

#define PAGE_FLAG_READ  0x01
#define PAGE_FLAG_WRITE 0x02
#define PAGE_FLAG_EXEC  0x04

Hive64File_Array read_h64_file(FILE* fp, bool load_dylibs);
void write_h64_file(FILE* fp, Hive64File f);
uint64_t find_symbol_address(Symbol_Array syms, char* name);
Symbol find_symbol(Symbol_Array syms, char* name);
void relocate(LoadCommand_Array sects, Relocation_Array relocs, Symbol_Array symbols);
void prepare(Hive64File_Array hf, bool try_relocate, Symbol_Array* all_syms);
int debug(int argc, char** argv);
void exec(void* start);
void disassemble(Section code_sect, Symbol_Array syms, Relocation_Array relocations);
SB_Array run_compile(const char* file_name, Symbol_Array* syms, Relocation_Array* relocations);
