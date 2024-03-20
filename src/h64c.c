#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "new_ops.h"

Token_Array parse(char* src);
Nob_String_Builder compile(Token_Array tokens, Symbol_Offsets* syms, Symbol_Offsets* relocations);

static char* file;

Nob_String_Builder run_compile(const char* file_name, Symbol_Offsets* syms, Symbol_Offsets* relocations) {
    file = malloc(strlen(file_name) + 1);
    strcpy(file, file_name);

    FILE* file = fopen(file_name, "r");
    if (!file) {
        printf("Could not open file: %s\n", file_name);
        return (Nob_String_Builder) {0};
    }
    fseek(file, 0, SEEK_END);
    size_t size = ftell(file);
    fseek(file, 0, SEEK_SET);

    char src[size + 1];
    fread(src, 1, size, file);
    src[size] = 0;
    fclose(file);

    int inside_string = 0;
    int escaped = 0;
    for (int i = 0; i < size; i++) {
        if (src[i] == '"') {
            if (!escaped) {
                inside_string = !inside_string;
            }
        }
        if (src[i] == '\\' && inside_string) {
            escaped = !escaped;
        } else {
            escaped = 0;
        }
        if (src[i] == '\n' && inside_string) {
            printf("%s:%d: Unterminated string\n", file_name, i);
            return (Nob_String_Builder) {0};
        }
        if ((src[i] == ';' || src[i] == '#' || src[i] == '@') && !inside_string) {
            while (src[i] != '\n' && i < size) {
                src[i] = ' ';
                i++;
            }
        }
    }

    Token_Array tokens = parse(src);

    return compile(tokens, syms, relocations);
}

int isValidBegin(int c) {
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_';
}

int isValid(int c) {
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_' || c == '$' || c == '{' || c == '}' || c == '(' || c == ')';
}

char* lower(char* str) {
    char* new = malloc(strlen(str) + 1);
    for (int i = 0; i < strlen(str); i++) {
        new[i] = tolower(str[i]);
    }
    new[strlen(str)] = 0;
    return new;
}

#define eq(s1, s2) (strcmp(s1, s2) == 0)

char* unquote(const char* str);

uint64_t parse64_(char* s, char* file, int line, char* value) {
    int sign = 1;
    if (*s == '-') {
        sign = -1;
        s++;
    }
    uint64_t result = 0;
    if (s[0] == '0' && s[1] == 'x') {
        s += 2;
        while (*s) {
            result *= 16;
            if (*s >= '0' && *s <= '9') {
                result += *s - '0';
            } else if (*s >= 'a' && *s <= 'f') {
                result += *s - 'a' + 10;
            } else if (*s >= 'A' && *s <= 'F') {
                result += *s - 'A' + 10;
            } else {
                printf("%s:%d: Invalid hex number: %s\n", file, line, value);
                exit(1);
            }
            s++;
        }
    } else if (s[0] == '0' && s[1] == 'b') {
        s += 2;
        while (*s) {
            result *= 2;
            if (*s == '0' || *s == '1') {
                result += *s - '0';
            } else {
                printf("%s:%d: Invalid binary number: %s\n", file, line, value);
                exit(1);
            }
            s++;
        }
    } else if (s[0] == '0' && s[1] == 'o') {
        s += 2;
        while (*s) {
            result *= 8;
            if (*s >= '0' && *s <= '7') {
                result += *s - '0';
            } else {
                printf("%s:%d: Invalid octal number: %s\n", file, line, value);
                exit(1);
            }
            s++;
        }
    } else {
        while (*s) {
            result *= 10;
            if (*s >= '0' && *s <= '9') {
                result += *s - '0';
            } else {
                printf("%s:%d: Invalid decimal number: %s\n", file, line, value);
                exit(1);
            }
            s++;
        }
    }
    return result * sign;
}

uint32_t parse32_(char* s, char* file, int line, char* value) {
    return parse64_(s, file, line, value);
}

uint16_t parse16_(char* s, char* file, int line, char* value) {
    return parse64_(s, file, line, value);
}

uint8_t parse8_(char* s, char* file, int line, char* value) {
    return parse64_(s, file, line, value);
}

#define parse64(s) parse64_((s), tokens.items[i].file, tokens.items[i].line, tokens.items[i].value)
#define parse32(s) parse32_((s), tokens.items[i].file, tokens.items[i].line, tokens.items[i].value)
#define parse16(s) parse16_((s), tokens.items[i].file, tokens.items[i].line, tokens.items[i].value)
#define parse8(s) parse8_((s), tokens.items[i].file, tokens.items[i].line, tokens.items[i].value)

uint8_t parse_reg_(char* s, char* file, int line, char* value) {
    if (s[0] == 'r') {
        return strtoul(s + 1, NULL, 0);
    } else if (eq(s, "lr")) {
        return REG_LR;
    } else if (eq(s, "sp")) {
        return REG_SP;
    } else if (eq(s, "pc")) {
        return REG_PC;
    } else if (eq(s, "x")) {
        return 0;
    } else if (eq(s, "y")) {
        return 1;
    }
    printf("%s:%d: Unknown register: %s\n", file, line, value);
    exit(1);
}
uint8_t parse_vreg_(char* s, char* file, int line, char* value) {
    if (s[0] == 'v') {
        return strtoul(s + 1, NULL, 0);
    }
    printf("%s:%d: Unknown vector register: %s\n", file, line, value);
    exit(1);
}
uint8_t parse_condition_(char* s, char* file, int line, char* value) {
    if (eq(s, "eq") || eq(s, "z")) return COND_EQ;
    if (eq(s, "ne") || eq(s, "nz")) return COND_NE;
    if (eq(s, "ge") || eq(s, "pl")) return COND_GE;
    if (eq(s, "gt")) return COND_GT;
    if (eq(s, "le")) return COND_LE;
    if (eq(s, "lt") || eq(s, "mi")) return COND_LT;
    printf("%s:%d: Unknown condition: %s\n", file, line, value);
    exit(1);
}

#define EXPECT(_type, _diag) \
    if (tokens.items[i].type != _type) { \
        printf("%s:%d: " _diag "\n", tokens.items[i].file, tokens.items[i].line, tokens.items[i].value); \
        return (Nob_String_Builder) {0}; \
    }

#define parse_reg(s) parse_reg_((s), tokens.items[i].file, tokens.items[i].line, tokens.items[i].value)
#define parse_condition(s) parse_condition_((s), tokens.items[i].file, tokens.items[i].line, tokens.items[i].value)
#define parse_vreg(s) parse_vreg_((s), tokens.items[i].file, tokens.items[i].line, tokens.items[i].value)

#define inc() do { i++; if (i >= tokens.count) { EXPECT(Eof, "Expected more tokens: %s"); } } while (0)

#define LDR(_sz) \
    inc(); \
    EXPECT(Register, "Expected register, got %s"); \
    uint8_t r1 = parse_reg(tokens.items[i].value); \
    inc(); \
    EXPECT(Comma, "Expected comma, got %s"); \
    inc(); \
    EXPECT(LeftBracket, "Expected '[', got %s"); \
    inc(); \
    EXPECT(Register, "Expected register, got %s"); \
    uint8_t r2 = parse_reg(tokens.items[i].value); \
    inc(); \
    ins.generic.type = MODE_DATA; \
    ins.type_data_ls_imm.sub_op = SUBOP_DATA_LS; \
    if (tokens.items[i].type == RightBracket) { \
        ins.type_data_ls_imm.is_store = 0; \
        ins.type_data_ls_imm.r1 = r1; \
        ins.type_data_ls_imm.r2 = r2; \
        ins.type_data_ls_imm.size = _sz; \
        ins.type_data_ls_imm.imm = 0; \
        ins.type_data_ls_imm.use_immediate = 1; \
        if (tokens.items[i + 1].type == Bang) { \
            inc(); \
            ins.type_data_ls_imm.update_ptr = 1; \
        } \
    } else if (tokens.items[i].type == Comma) { \
        inc(); \
        if (tokens.items[i].type == Register) { \
            ins.type_data_ls_reg.is_store = 0; \
            ins.type_data_ls_reg.r1 = r1; \
            ins.type_data_ls_reg.r2 = r2; \
            ins.type_data_ls_reg.size = _sz; \
            ins.type_data_ls_reg.r3 = parse_reg(tokens.items[i].value); \
        } else if (tokens.items[i].type == Number) { \
            ins.type_data_ls_imm.is_store = 0; \
            ins.type_data_ls_imm.r1 = r1; \
            ins.type_data_ls_imm.r2 = r2; \
            ins.type_data_ls_imm.size = _sz; \
            int8_t num = parse8(tokens.items[i].value); \
            ins.type_data_ls_imm.use_immediate = 1; \
            ins.type_data_ls_imm.imm = num; \
        } else { \
            EXPECT(Eof, "Expected register or number, got %s"); \
        } \
        inc(); \
        EXPECT(RightBracket, "Expected ']', got %s"); \
        if (tokens.items[i + 1].type == Bang) { \
            inc(); \
            ins.type_data_ls_imm.update_ptr = 1; \
        } \
    } else { \
        EXPECT(Eof, "Expected comma or ']', got %s"); \
    }

#define STR(_sz)  \
    inc(); \
    EXPECT(Register, "Expected register, got %s"); \
    uint8_t r1 = parse_reg(tokens.items[i].value); \
    inc(); \
    EXPECT(Comma, "Expected comma, got %s"); \
    inc(); \
    EXPECT(LeftBracket, "Expected '[', got %s"); \
    inc(); \
    EXPECT(Register, "Expected register, got %s"); \
    uint8_t r2 = parse_reg(tokens.items[i].value); \
    inc(); \
    ins.generic.type = MODE_DATA; \
    ins.type_data_ls_imm.sub_op = SUBOP_DATA_LS; \
    if (tokens.items[i].type == RightBracket) { \
        ins.type_data_ls_imm.is_store = 1; \
        ins.type_data_ls_imm.r1 = r1; \
        ins.type_data_ls_imm.r2 = r2; \
        ins.type_data_ls_imm.size = _sz; \
        ins.type_data_ls_imm.imm = 0; \
        ins.type_data_ls_imm.use_immediate = 1; \
        if (tokens.items[i + 1].type == Bang) { \
            inc(); \
            ins.type_data_ls_imm.update_ptr = 1; \
        } \
    } else if (tokens.items[i].type == Comma) { \
        inc(); \
        if (tokens.items[i].type == Register) { \
            ins.type_data_ls_reg.is_store = 1; \
            ins.type_data_ls_reg.r1 = r1; \
            ins.type_data_ls_reg.r2 = r2; \
            ins.type_data_ls_reg.size = _sz; \
            ins.type_data_ls_reg.r3 = parse_reg(tokens.items[i].value); \
        } else if (tokens.items[i].type == Number) { \
            ins.type_data_ls_imm.is_store = 1; \
            ins.type_data_ls_imm.r1 = r1; \
            ins.type_data_ls_imm.r2 = r2; \
            ins.type_data_ls_imm.size = _sz; \
            int8_t num = parse8(tokens.items[i].value); \
            ins.type_data_ls_imm.use_immediate = 1; \
            ins.type_data_ls_imm.imm = num; \
        } else { \
            EXPECT(Eof, "Expected register or number, got %s"); \
        } \
        inc(); \
        EXPECT(RightBracket, "Expected ']', got %s"); \
        if (tokens.items[i + 1].type == Bang) { \
            inc(); \
            ins.type_data_ls_imm.update_ptr = 1; \
        } \
    } else { \
        EXPECT(Eof, "Expected comma or ']', got %s"); \
    }
#define OP(_what) \
    inc(); \
    EXPECT(Register, "Expected register, got %s"); \
    uint8_t r1 = parse_reg(tokens.items[i].value); \
    inc(); \
    EXPECT(Comma, "Expected comma, got %s"); \
    inc(); \
    ins.generic.type = MODE_DATA; \
    ins.type_data_alui.op = OP_DATA_ALU_ ## _what; \
    if (tokens.items[i].type == Register) { \
        uint8_t r2 = parse_reg(tokens.items[i].value); \
        if (tokens.items[i + 1].type == Comma) { \
            i += 2; \
            if (tokens.items[i].type == Number) { \
                uint8_t num = parse8(tokens.items[i].value); \
                ins.type_data.sub_op = SUBOP_DATA_ALU_I; \
                ins.type_data_alui.r1 = r1; \
                ins.type_data_alui.r2 = r2; \
                ins.type_data_alui.imm = num; \
            } else if (tokens.items[i].type == Register) { \
                uint8_t r3 = parse_reg(tokens.items[i].value); \
                ins.type_data.sub_op = SUBOP_DATA_ALU_R; \
                ins.type_data_alur.r1 = r1; \
                ins.type_data_alur.r2 = r2; \
                ins.type_data_alur.r3 = r3; \
            } else { \
                EXPECT(Eof, "Expected number or register, got %s"); \
            } \
        } else { \
            ins.type_data.sub_op = SUBOP_DATA_ALU_R; \
            ins.type_data_alur.r1 = r1; \
            ins.type_data_alur.r2 = r1; \
            ins.type_data_alur.r3 = r2; \
        } \
    } else if (tokens.items[i].type == Number) { \
        uint8_t num = parse8(tokens.items[i].value); \
        ins.type_data.sub_op = SUBOP_DATA_ALU_I; \
        ins.type_data_alui.r1 = r1; \
        ins.type_data_alui.r2 = r1; \
        ins.type_data_alui.imm = num; \
    } else { \
        EXPECT(Register, "Expected register or number, got %s"); \
    }

#define FLOAT_OP(_op) \
    uint8_t full_float = eq(mnemonic, #_op); \
    inc(); \
    EXPECT(Register, "Expected register, got %s"); \
    uint8_t r1 = parse_reg(tokens.items[i].value); \
    inc(); \
    EXPECT(Comma, "Expected comma, got %s"); \
    inc(); \
    EXPECT(Register, "Expected register, got %s"); \
    uint8_t r2 = parse_reg(tokens.items[i].value); \
    inc(); \
    EXPECT(Comma, "Expected comma, got %s"); \
    inc(); \
    EXPECT(Register, "Expected register, got %s"); \
    uint8_t r3 = parse_reg(tokens.items[i].value); \
    ins.type_data_fpu.op = OP_DATA_FLOAT_ ## _op; \
    ins.type_data_fpu.use_int_arg2 = !full_float; \
    ins.type_data_fpu.r1 = r1; \
    ins.type_data_fpu.r2 = r2; \
    ins.type_data_fpu.r3 = r3;

uint64_t find_symbol_address(Symbol_Offsets syms, char* name);
struct symbol_offset find_symbol(Symbol_Offsets syms, char* name);

Nob_String_Builder compile(Token_Array tokens, Symbol_Offsets* syms, Symbol_Offsets* relocations) {
    Nob_String_Builder data = {0};

    Nob_File_Paths exported_symbols = {0};

    for (size_t i = 0; i < tokens.count; i++) {
        if (tokens.items[i].type == Eof) break;

        if (tokens.items[i].type == Identifier) {
            char* mnemonic = lower(tokens.items[i].value);

            hive_instruction_t ins = {0};
            if (tokens.items[i + 1].line == tokens.items[i].line && tokens.items[i + 1].type == Directive) {
                inc();
                ins.generic.condition = parse_condition(tokens.items[i].value);
            } else {
                ins.generic.condition = COND_ALWAYS;
            }
            if (eq(mnemonic, "nop")) {
                ins.generic.condition = COND_NEVER;
            } else if (eq(mnemonic, "ret")) {
                ins.generic.type = MODE_DATA;
                ins.type_data.sub_op = SUBOP_DATA_ALU_I;
                ins.type_data_alui.op = OP_DATA_ALU_shl;
                ins.type_data_alui.r1 = REG_PC;
                ins.type_data_alui.r2 = REG_LR;
                ins.type_data_alui.imm = 0;
            } else if (eq(mnemonic, "b")) {
                ins.generic.type = MODE_BRANCH;
            } else if (eq(mnemonic, "bl")) {
                ins.generic.type = MODE_BRANCH;
                ins.type_branch.link = 1;
            } else if (eq(mnemonic, "br")) {
                ins.generic.type = MODE_BRANCH;
                ins.type_branch.is_reg = 1;
                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t reg = parse_reg(tokens.items[i].value);
                ins.type_branch_register.r1 = reg;
            } else if (eq(mnemonic, "blr")) {
                ins.generic.type = MODE_BRANCH;
                ins.type_branch.is_reg = 1;
                ins.type_branch.link = 1;
                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t reg = parse_reg(tokens.items[i].value);
                ins.type_branch_register.r1 = reg;
            } else if (eq(mnemonic, "svc")) {
                ins.generic.type = MODE_LOAD;
                ins.type_load.op = OP_LOAD_svc;
            } else if (eq(mnemonic, "add")) {
                OP(add)
            } else if (eq(mnemonic, "sub")) {
                OP(sub)
            } else if (eq(mnemonic, "mul")) {
                OP(mul)
            } else if (eq(mnemonic, "div")) {
                OP(div)
            } else if (eq(mnemonic, "sdiv")) {
                OP(sdiv)
                ins.type_data_alui.salu = 1;
            } else if (eq(mnemonic, "mod")) {
                OP(mod)
            } else if (eq(mnemonic, "smod")) {
                OP(smod)
                ins.type_data_alui.salu = 1;
            } else if (eq(mnemonic, "and")) {
                OP(and)
            } else if (eq(mnemonic, "or")) {
                OP(or)
            } else if (eq(mnemonic, "xor")) {
                OP(xor)
            } else if (eq(mnemonic, "shl") || eq(mnemonic, "asl")) {
                OP(shl)
            } else if (eq(mnemonic, "shr")) {
                OP(shr)
            } else if (eq(mnemonic, "rol")) {
                OP(rol)
            } else if (eq(mnemonic, "ror")) {
                OP(ror)
            } else if (eq(mnemonic, "neg") || eq(mnemonic, "not")) {
                bool not = eq(mnemonic, "not");
                ins.generic.type = MODE_DATA;
                ins.type_data.sub_op = SUBOP_DATA_ALU_R;
                ins.type_data_alur.op = not ? OP_DATA_ALU_not : OP_DATA_ALU_neg;
                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t r1 = parse_reg(tokens.items[i].value);
                uint8_t r2 = r1;
                inc();
                if (tokens.items[i].type == Comma) {
                    inc();
                    EXPECT(Register, "Expected register, got %s");
                    r2 = parse_reg(tokens.items[i].value);
                } else {
                    i--;
                }
                ins.type_data_alur.r1 = r1;
                ins.type_data_alur.r2 = r2;
            } else if (eq(mnemonic, "asr")) {
                OP(asr)
            } else if (eq(mnemonic, "swe")) {
                ins.generic.type = MODE_DATA;
                ins.type_data.sub_op = SUBOP_DATA_ALU_R;
                ins.type_data_alur.op = OP_DATA_ALU_swe;
                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t r1 = parse_reg(tokens.items[i].value);
                uint8_t r2 = r1;
                inc();
                if (tokens.items[i].type == Comma) {
                    inc();
                    EXPECT(Register, "Expected register, got %s");
                    r2 = parse_reg(tokens.items[i].value);
                } else {
                    i--;
                }
                ins.type_data_alur.r1 = r1;
                ins.type_data_alur.r2 = r2;
            } else if (eq(mnemonic, "ldr") || eq(mnemonic, "ldrq")) {
                LDR(SIZE_64BIT)
            } else if (eq(mnemonic, "str") || eq(mnemonic, "strq")) {
                STR(SIZE_64BIT)
            } else if (eq(mnemonic, "ldrd")) {
                LDR(SIZE_32BIT)
            } else if (eq(mnemonic, "strd")) {
                STR(SIZE_32BIT)
            } else if (eq(mnemonic, "ldrw")) {
                LDR(SIZE_16BIT)
            } else if (eq(mnemonic, "strw")) {
                STR(SIZE_16BIT)
            } else if (eq(mnemonic, "ldrb")) {
                LDR(SIZE_8BIT)
            } else if (eq(mnemonic, "strb")) {
                STR(SIZE_8BIT)
            } else if (eq(mnemonic, "psh")) {
                ins.generic.type = MODE_DATA;
                ins.type_data_ls_imm.sub_op = SUBOP_DATA_LS;
                ins.type_data_ls_imm.is_store = 1;
                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t reg = parse_reg(tokens.items[i].value);
                ins.type_data_ls_imm.r1 = reg;
                ins.type_data_ls_imm.r2 = REG_SP;
                ins.type_data_ls_imm.size = SIZE_64BIT;
                ins.type_data_ls_imm.imm = -16;
                ins.type_data_ls_imm.update_ptr = 1;
                ins.type_data_ls_imm.use_immediate = 1;
            } else if (eq(mnemonic, "pp")) {
                ins.generic.type = MODE_DATA;
                ins.type_data_ls_imm.sub_op = SUBOP_DATA_LS;
                ins.type_data_ls_imm.is_store = 0;
                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t reg = parse_reg(tokens.items[i].value);
                ins.type_data_ls_imm.r1 = reg;
                ins.type_data_ls_imm.r2 = REG_SP;
                ins.type_data_ls_imm.size = SIZE_64BIT;
                ins.type_data_ls_imm.imm = 16;
                ins.type_data_ls_imm.update_ptr = 1;
                ins.type_data_ls_imm.use_immediate = 1;
            } else if (eq(mnemonic, "lea")) {
                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t reg = parse_reg(tokens.items[i].value);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                ins.generic.type = MODE_LOAD;
                ins.type_load_signed.op = OP_LOAD_lea;
                ins.type_load_signed.r1 = reg;
            } else if (eq(mnemonic, "movz") || eq(mnemonic, "movk")) {
                bool no_zero = eq(mnemonic, "movk");
                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t reg = parse_reg(tokens.items[i].value);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                EXPECT(Number, "Expected number, got %s");
                uint16_t num = parse16(tokens.items[i].value);
                inc();
                uint8_t shift = 0;
                if (tokens.items[i].type == Comma) {
                    inc();
                    EXPECT(Identifier, "Expected 'shl', got %s");
                    if (!eq(tokens.items[i].value, "shl")) {
                        EXPECT(Eof, "Expected 'shl', got %s");
                    }
                    inc();
                    EXPECT(Number, "Expected number, got %s");
                    shift = parse8(tokens.items[i].value);
                } else {
                    i--;
                }
                if (shift % 16) {
                    EXPECT(Eof, "Shift must be a multiple of 16, but is %s");
                }
                ins.generic.type = MODE_LOAD;
                ins.type_load_mov.op = OP_LOAD_movzk;
                ins.type_load_mov.no_zero = no_zero;
                ins.type_load_mov.r1 = reg;
                ins.type_load_mov.shift = (shift / 16);
                ins.type_load_mov.imm = num;
            } else if (eq(mnemonic, "mov")) {
                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t r1 = parse_reg(tokens.items[i].value);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t r2 = parse_reg(tokens.items[i].value);
                ins.generic.type = MODE_DATA;
                ins.type_data.sub_op = SUBOP_DATA_ALU_I;
                ins.type_data_alui.op = OP_DATA_ALU_shl;
                ins.type_data_alui.r1 = r1;
                ins.type_data_alui.r2 = r2;
                ins.type_data_alui.imm = 0;
            } else if (eq(mnemonic, "inc") || eq(mnemonic, "dec")) {
                uint8_t inc = eq(mnemonic, "inc");
                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t r1 = parse_reg(tokens.items[i].value);
                uint8_t r2 = r1;
                if (tokens.items[i + 1].type == Comma) {
                    inc();
                    EXPECT(Comma, "Expected comma, got %s");
                    inc();
                    EXPECT(Register, "Expected register, got %s");
                    r2 = parse_reg(tokens.items[i].value);
                }
                ins.generic.type = MODE_DATA;
                ins.type_data.sub_op = SUBOP_DATA_ALU_I;
                ins.type_data_alui.op = inc ? OP_DATA_ALU_add : OP_DATA_ALU_sub;
                ins.type_data_alui.r1 = r1;
                ins.type_data_alui.r2 = r2;
                ins.type_data_alui.imm = 1;
            } else if (eq(mnemonic, "tst")) {
                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t r1 = parse_reg(tokens.items[i].value);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                if (tokens.items[i].type == Register) {
                    uint8_t r2 = parse_reg(tokens.items[i].value);
                    ins.generic.type = MODE_DATA;
                    ins.type_data.sub_op = SUBOP_DATA_ALU_R;
                    ins.type_data_alur.op = OP_DATA_ALU_and;
                    ins.type_data_alur.r2 = r1;
                    ins.type_data_alur.r3 = r2;
                    ins.type_data_alur.no_writeback = 1;
                } else if (tokens.items[i].type == Number) {
                    uint8_t num = parse8(tokens.items[i].value);
                    ins.generic.type = MODE_DATA;
                    ins.type_data.sub_op = SUBOP_DATA_ALU_I;
                    ins.type_data_alui.op = OP_DATA_ALU_and;
                    ins.type_data_alui.r2 = r1;
                    ins.type_data_alui.imm = num;
                    ins.type_data_alui.no_writeback = 1;
                } else {
                    EXPECT(Eof, "Expected register or number, got %s");
                }
            } else if (eq(mnemonic, "cmp")) {
                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t r1 = parse_reg(tokens.items[i].value);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                if (tokens.items[i].type == Register) {
                    uint8_t r2 = parse_reg(tokens.items[i].value);
                    ins.generic.type = MODE_DATA;
                    ins.type_data.sub_op = SUBOP_DATA_ALU_R;
                    ins.type_data_alur.op = OP_DATA_ALU_sub;
                    ins.type_data_alur.r2 = r1;
                    ins.type_data_alur.r3 = r2;
                    ins.type_data_alur.no_writeback = 1;
                } else if (tokens.items[i].type == Number) {
                    uint32_t num = parse32(tokens.items[i].value);
                    ins.generic.type = MODE_DATA;
                    ins.type_data.sub_op = SUBOP_DATA_ALU_I;
                    ins.type_data_alui.op = OP_DATA_ALU_sub;
                    ins.type_data_alui.r2 = r1;
                    ins.type_data_alui.imm = num;
                    ins.type_data_alui.no_writeback = 1;
                } else {
                    EXPECT(Eof, "Expected register or number, got %s");
                }
            } else if (eq(mnemonic, "sbxt") || eq(mnemonic, "ubxt")) {
                ins.generic.type = MODE_DATA;
                ins.type_data_bit.extend = (mnemonic[0] == 's');
                ins.type_data_bit.is_dep = 0;
                ins.type_data_bit.is_bit_instr = 1;

                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t r1 = parse_reg(tokens.items[i].value);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t r2 = parse_reg(tokens.items[i].value);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                EXPECT(Number, "Expected number, got %s");
                uint8_t lowest = parse8(tokens.items[i].value);
                if (lowest >= 64) {
                    EXPECT(Eof, "Lowest bit out of range: %s");
                }
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                EXPECT(Number, "Expected number, got %s");
                uint8_t nbits = parse8(tokens.items[i].value);
                if (nbits == 0 || nbits > 64) {
                    EXPECT(Eof, "Number of bits out of range: %s");
                }
                nbits--;

                ins.type_data_bit.r1 = r1;
                ins.type_data_bit.r2 = r2;
                ins.type_data_bit.start = lowest;
                ins.type_data_bit.count_hi = nbits >> 1;
                ins.type_data_bit.count_lo = nbits & 1;
            } else if (eq(mnemonic, "sbdp") || eq(mnemonic, "ubdp")) {
                ins.generic.type = MODE_DATA;
                ins.type_data_bit.extend = (mnemonic[0] == 's');
                ins.type_data_bit.is_dep = 1;
                ins.type_data_bit.is_bit_instr = 1;

                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t r1 = parse_reg(tokens.items[i].value);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t r2 = parse_reg(tokens.items[i].value);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                EXPECT(Number, "Expected number, got %s");
                uint8_t lowest = parse8(tokens.items[i].value);
                if (lowest >= 64) {
                    EXPECT(Eof, "Lowest bit out of range: %s");
                }
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                EXPECT(Number, "Expected number, got %s");
                uint8_t nbits = parse8(tokens.items[i].value);
                if (nbits == 0 || nbits > 64) {
                    EXPECT(Eof, "Number of bits out of range: %s");
                }
                nbits--;

                ins.type_data_bit.r1 = r1;
                ins.type_data_bit.r2 = r2;
                ins.type_data_bit.start = lowest;
                ins.type_data_bit.count_hi = nbits >> 1;
                ins.type_data_bit.count_lo = nbits & 1;
            } else if (eq(mnemonic, "i2f") || eq(mnemonic, "f2i")) {
                uint8_t i2f = eq(mnemonic, "i2f");
                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t r1 = parse_reg(tokens.items[i].value);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t r2 = parse_reg(tokens.items[i].value);
                ins.generic.type = MODE_DATA;
                ins.type_data_fpu.sub_op = SUBOP_DATA_FPU;
                ins.type_data_fpu.op = OP_DATA_FLOAT_f2i;
                ins.type_data_fpu.use_int_arg2 = i2f;
                ins.type_data_fpu.r1 = r1;
                ins.type_data_fpu.r2 = r2;
            } else if (eq(mnemonic, "f2s") || eq(mnemonic, "s2f")) {
                uint8_t f2s = eq(mnemonic, "f2s");
                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t r1 = parse_reg(tokens.items[i].value);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                EXPECT(Register, "Expected register, got %s");
                uint8_t r2 = parse_reg(tokens.items[i].value);
                ins.generic.type = MODE_DATA;
                ins.type_data_fpu.sub_op = SUBOP_DATA_FPU;
                ins.type_data_fpu.op = OP_DATA_FLOAT_s2f;
                ins.type_data_fpu.is_single_op = f2s;
                ins.type_data_fpu.r1 = r1;
                ins.type_data_fpu.r2 = r2;
            } else if (mnemonic[0] == 'f' || mnemonic[0] == 's') {
                mnemonic++;
                ins.generic.type = MODE_DATA;
                ins.type_data_fpu.is_single_op = (mnemonic[0] == 's');
                ins.type_data_fpu.sub_op = SUBOP_DATA_FPU;
                if (eq(mnemonic, "sin") || eq(mnemonic, "sqrt")) {
                    uint8_t sin = eq(mnemonic, "sin");
                    inc();
                    EXPECT(Register, "Expected register, got %s");
                    uint8_t r1 = parse_reg(tokens.items[i].value);
                    inc();
                    EXPECT(Comma, "Expected comma, got %s");
                    inc();
                    EXPECT(Register, "Expected register, got %s");
                    uint8_t r2 = parse_reg(tokens.items[i].value);
                    ins.type_data_fpu.op = sin ? OP_DATA_FLOAT_sin : OP_DATA_FLOAT_sqrt;
                    ins.type_data_fpu.r1 = r1;
                    ins.type_data_fpu.r2 = r2;
                } else if (eq(mnemonic, "cmp") || eq(mnemonic, "cmpi")) {
                    uint8_t fcmp = eq(mnemonic, "cmp");
                    inc();
                    EXPECT(Register, "Expected register, got %s");
                    uint8_t r1 = parse_reg(tokens.items[i].value);
                    inc();
                    EXPECT(Comma, "Expected comma, got %s");
                    inc();
                    EXPECT(Register, "Expected register, got %s");
                    uint8_t r2 = parse_reg(tokens.items[i].value);
                    ins.type_data_fpu.op = OP_DATA_FLOAT_sub;
                    ins.type_data_fpu.use_int_arg2 = !fcmp;
                    ins.type_data_fpu.r2 = r1;
                    ins.type_data_fpu.r3 = r2;
                    ins.type_data_fpu.no_writeback = 1;
                } else if (eq(mnemonic, "add") || eq(mnemonic, "addi")) {
                    FLOAT_OP(add)
                } else if (eq(mnemonic, "sub") || eq(mnemonic, "subi")) {
                    FLOAT_OP(sub)
                } else if (eq(mnemonic, "mul") || eq(mnemonic, "muli")) {
                    FLOAT_OP(mul)
                } else if (eq(mnemonic, "div") || eq(mnemonic, "divi")) {
                    FLOAT_OP(div)
                } else if (eq(mnemonic, "mod") || eq(mnemonic, "modi")) {
                    FLOAT_OP(mod)
                } else {
                    EXPECT(Eof, "Unknown float operation: %s");
                }
            } else if (mnemonic[0] == 'v') {
                uint8_t modes[] = {
                    [0] = -1,
                    ['o'] = 0,
                    ['b'] = 1,
                    ['w'] = 2,
                    ['d'] = 3,
                    ['q'] = 4,
                    ['l'] = 5,
                    ['s'] = 6,
                    ['f'] = 7,
                };
                uint8_t max_slots[] = {
                    [0] = 1,
                    [1] = 32,
                    [2] = 16,
                    [3] = 8,
                    [4] = 4,
                    [5] = 2,
                    [6] = 8,
                    [7] = 4,
                };
                ins.generic.type = MODE_DATA;
                ins.type_data_vpu.sub_op = SUBOP_DATA_VPU;
                uint8_t mode = modes[mnemonic[1]];
                ins.type_data_vpu.mode = mode;
                mnemonic += 2;
                #define vop(_name) \
                (eq(mnemonic, #_name)) { \
                    ins.type_data_vpu.op = OP_DATA_VPU_ ## _name; \
                    i++; \
                    EXPECT(VecRegister, "Expected vector register, got %s"); \
                    uint8_t v1 = parse_vreg(tokens.items[i].value); \
                    i++; \
                    EXPECT(Comma, "Expected comma, got %s"); \
                    i++; \
                    EXPECT(VecRegister, "Expected vector register, got %s"); \
                    uint8_t v2 = parse_vreg(tokens.items[i].value); \
                    i++; \
                    EXPECT(Comma, "Expected comma, got %s"); \
                    i++; \
                    EXPECT(VecRegister, "Expected vector register, got %s"); \
                    uint8_t v3 = parse_vreg(tokens.items[i].value); \
                    ins.type_data_vpu.v1 = v1; \
                    ins.type_data_vpu.v2 = v2; \
                    ins.type_data_vpu.v3 = v3; \
                }
                if vop(add)
                else if vop(sub)
                else if vop(mul)
                else if vop(div)
                else if vop(addsub)
                else if vop(madd)
                else if (eq(mnemonic, "mov")) {
                    i++;
                    EXPECT(VecRegister, "Expected vector register, got %s");
                    uint8_t v1 = parse_vreg(tokens.items[i].value);
                    i++;
                    EXPECT(Comma, "Expected comma, got %s");
                    i++;
                    if (tokens.items[i].type == VecRegister) {
                        ins.type_data_vpu.op = OP_DATA_VPU_mov_vec;
                        uint8_t v2 = parse_vreg(tokens.items[i].value);
                        ins.type_data_vpu.v1 = v1;
                        ins.type_data_vpu.v2 = v2;
                    } else if (tokens.items[i].type == Register) {
                        ins.type_data_vpu_mov.op = OP_DATA_VPU_mov;
                        uint8_t r2 = parse_reg(tokens.items[i].value);
                        i++;
                        uint8_t slot = 0;
                        if (tokens.items[i].type == Comma) {
                            i++;
                            EXPECT(Number, "Expected number, got %s");
                            slot = parse8(tokens.items[i].value);
                            if (slot >= max_slots[mode]) {
                                EXPECT(Eof, "Slot out of range for mode: %s");
                            }
                        } else {
                            i--;
                        }
                        ins.type_data_vpu_mov.slot_lo = slot & 0b111;
                        ins.type_data_vpu_mov.slot_hi = slot >> 3;
                        ins.type_data_vpu_mov.v1 = v1;
                        ins.type_data_vpu_mov.r2 = r2;
                    } else {
                        EXPECT(Eof, "Expected register or vector register, got %s");
                    }
                } else if (strncmp(mnemonic, "conv", 4) == 0) {
                    uint8_t target_mode = modes[mnemonic[4]];
                    if (target_mode == 0xff) {
                        EXPECT(Eof, "Unknown target mode: %s");
                    }
                    ins.type_data_vpu_conv.op = OP_DATA_VPU_conv;
                    ins.type_data_vpu_conv.target_mode = target_mode;
                    i++;
                    EXPECT(VecRegister, "Expected vector register, got %s");
                    uint8_t v1 = parse_vreg(tokens.items[i].value);
                    i++;
                    EXPECT(Comma, "Expected comma, got %s");
                    i++;
                    EXPECT(VecRegister, "Expected vector register, got %s");
                    uint8_t v2 = parse_vreg(tokens.items[i].value);
                    ins.type_data_vpu_conv.v1 = v1;
                    ins.type_data_vpu_conv.v2 = v2;
                } else if (eq(mnemonic, "len")) {
                    i++;
                    EXPECT(Register, "Expected register, got %s");
                    uint8_t r1 = parse_reg(tokens.items[i].value);
                    i++;
                    EXPECT(Comma, "Expected comma, got %s");
                    i++;
                    EXPECT(VecRegister, "Expected vector register, got %s");
                    uint8_t v1 = parse_vreg(tokens.items[i].value);
                    ins.type_data_vpu_len.op = OP_DATA_VPU_len;
                    ins.type_data_vpu_len.r1 = r1;
                    ins.type_data_vpu_len.v1 = v1;
                } else {
                    EXPECT(Eof, "Unknown vector operation: %s");
                }
            } else {
                EXPECT(Eof, "Unknown opcode: %s");
            }

            if (ins.generic.type == MODE_BRANCH && !ins.type_branch.is_reg) {
                inc();
                EXPECT(Identifier, "Expected identifier, got %s");
                struct symbol_offset off = {
                    .name = tokens.items[i].value,
                    .offset = data.count,
                    .type = sym_branch
                }; 
                nob_da_append(relocations, off);
            } else if (ins.generic.type == MODE_LOAD && ins.type_load_signed.op == OP_LOAD_lea) {
                inc();
                EXPECT(Identifier, "Expected identifier, got %s");
                struct symbol_offset off = {
                    .name = tokens.items[i].value,
                    .offset = data.count,
                    .type = sym_load
                }; 
                nob_da_append(relocations, off);
            }
            nob_da_append_many(&data, &ins, sizeof(ins));
        } else if (tokens.items[i].type == Directive) {
            if (eq(tokens.items[i].value, "asciz") || eq(tokens.items[i].value, "ascii")) {
                inc();
                EXPECT(String, "Expected string, got %s");
                char* str = tokens.items[i].value;
                str = unquote(str);
                nob_sb_append_cstr(&data, str);
                if (eq(tokens.items[i - 1].value, "asciz")) {
                    nob_sb_append_null(&data);
                }
                while (data.count % 4) {
                    nob_sb_append_null(&data);
                }
            } else if (eq(tokens.items[i].value, "byte")) {
                inc();
                EXPECT(Number, "Expected number, got %s");
                uint8_t num = parse8(tokens.items[i].value);
                nob_da_append_many(&data, &num, 1);
            } else if (eq(tokens.items[i].value, "word")) {
                inc();
                EXPECT(Number, "Expected number, got %s");
                uint16_t num = parse16(tokens.items[i].value);
                nob_da_append_many(&data, &num, 2);
            } else if (eq(tokens.items[i].value, "dword")) {
                inc();
                EXPECT(Number, "Expected number, got %s");
                uint32_t num = parse32(tokens.items[i].value);
                nob_da_append_many(&data, &num, 4);
            } else if (eq(tokens.items[i].value, "qword")) {
                inc();
                if (tokens.items[i].type == Number) {
                    uint64_t num = parse64(tokens.items[i].value);
                    nob_da_append_many(&data, &num, 8);
                } else if (tokens.items[i].type == Identifier) {
                    struct symbol_offset off = {
                        .name = tokens.items[i].value,
                        .offset = data.count,
                        .type = sym_abs
                    }; 
                    nob_da_append(relocations, off);
                    nob_da_append_many(&data, &(off.offset), 8);
                } else {
                    EXPECT(Eof, "Expected number or identifier, got %s");
                }
            } else if (eq(tokens.items[i].value, "float")) {
                inc();
                EXPECT(NumberFloat, "Expected float, got %s");;
                float num = atof(tokens.items[i].value);
                nob_da_append_many(&data, &num, 4);
            } else if (eq(tokens.items[i].value, "double")) {
                inc();
                EXPECT(NumberFloat, "Expected float, got %s");;
                double num = atof(tokens.items[i].value);
                nob_da_append_many(&data, &num, 8);
            } else if (eq(tokens.items[i].value, "offset")) {
                inc();
                EXPECT(Identifier, "Expected identifier, got %s");
                struct symbol_offset off = {
                    .name = tokens.items[i].value,
                    .offset = data.count,
                    .type = sym_abs
                }; 
                nob_da_append(relocations, off);
                nob_da_append_many(&data, &(off.offset), 8);
            } else if (eq(tokens.items[i].value, "zerofill")) {
                inc();
                EXPECT(Number, "Expected number, got %s");
                uint64_t size = parse64(tokens.items[i].value);
                if (size % 4) {
                    size += (4 - (size % 4));
                }
                while (size > 0) {
                    if (size >= 8) {
                        nob_da_append_many(&data, &(uint64_t){0}, 8);
                        size -= 8;
                    } else if (size >= 4) {
                        nob_da_append_many(&data, &(uint32_t){0}, 4);
                        size -= 4;
                    } else if (size >= 2) {
                        nob_da_append_many(&data, &(uint16_t){0}, 2);
                        size -= 2;
                    } else if (size >= 1) {
                        nob_da_append_many(&data, &(uint8_t){0}, 1);
                        size -= 1;
                    } else {
                        break;
                    }
                }
            } else if (eq(tokens.items[i].value, "global") || eq(tokens.items[i].value, "globl")) {
                inc();
                EXPECT(Identifier, "Expected identifier, got %s");
                nob_da_append(&exported_symbols, tokens.items[i].value);
            } else {
                EXPECT(Eof, "Unknown directive: %s");
            }
        } else if (tokens.items[i].type == Label) {
            char* str = tokens.items[i].value;
            str = unquote(str);
            struct symbol_offset off = {
                .name = str,
                .offset = data.count,
            };
            nob_da_append(syms, off);
        }
    }

    Symbol_Offsets extern_relocs = {0};

    for (size_t i = 0; i < syms->count; i++) {
        for (size_t j = 0; j < exported_symbols.count; j++) {
            if (eq(syms->items[i].name, exported_symbols.items[j])) {
                syms->items[i].flags |= sf_exported;
                break;
            }
        }
    }

    for (size_t i = 0; i < relocations->count; i++) {
        struct symbol_offset reloc = relocations->items[i];
        uint64_t current_address = reloc.offset;
        struct symbol_offset symbol = find_symbol(*syms, reloc.name);
        uint64_t target_address = symbol.offset;

        if (target_address == -1) {
            nob_da_append(&extern_relocs, reloc);
            continue;
        }

        switch (reloc.type) {
            case sym_abs:
                *((QWord_t*) &data.items[current_address]) = target_address;
                nob_da_append(&extern_relocs, reloc);
                break;
            case sym_branch: {
                    hive_instruction_t* s = ((hive_instruction_t*) &data.items[current_address]);
                    int32_t diff = target_address - (current_address);
                    if (diff % 4) {
                        fprintf(stderr, "Relative target not aligned!");
                        exit(1);
                    }
                    diff >>= 2;
                    if (diff >= 0x1000000 || diff < -0x1000000) {
                        fprintf(stderr, "Relative address too far: %x (%llx -> %llx)\n", diff, (QWord_t) &data.items[current_address], target_address);
                        exit(1);
                    }
                    s->type_branch_generic.offset = diff;
                }
                break;
            case sym_load: {
                    hive_instruction_t* s = ((hive_instruction_t*) &data.items[current_address]);
                    int32_t diff = target_address - (current_address);
                    if (diff % 4) {
                        fprintf(stderr, "Relative target not aligned!");
                        exit(1);
                    }
                    diff >>= 2;
                    if (diff >= 0x80000 || diff < -0x80000) {
                        fprintf(stderr, "Relative address too far: %x (%llx -> %llx)\n", diff, (QWord_t) &data.items[current_address], target_address);
                        exit(1);
                    }
                    s->type_load_signed.imm = diff;
                }
                break;
        }
    }
    *relocations = extern_relocs;

    return data;
}

char* unquote(const char* str) {
    char* ret = malloc(strlen(str) + 1);
    char* ptr = ret;
    while (*str) {
        if (*str == '\\') {
            str++;
            switch (*str) {
                case 'n':
                    *ptr++ = '\n';
                    break;
                case 'r':
                    *ptr++ = '\r';
                    break;
                case 't':
                    *ptr++ = '\t';
                    break;
                case '0':
                    *ptr++ = '\0';
                    break;
                case '\\':
                    *ptr++ = '\\';
                    break;
                case '\'':
                    *ptr++ = '\'';
                    break;
                case '\"':
                    *ptr++ = '\"';
                    break;
                default:
                    printf("Unknown escape sequence: \\%c\n", *str);
                    return NULL;
            }
        } else {
            *ptr++ = *str;
        }
        str++;
    }
    *ptr = '\0';
    return ret;
}

Token nextToken(void);

static char* src;
static int line = 1;

Token_Array parse(char* data) {
    Token_Array tokens = {0};
    src = data;
    line = 1;
    while (*src) {
        Token t = nextToken();
        if (t.type == Eof) break;
        nob_da_append(&tokens, t);
    }
    nob_da_append(&tokens, (Token) {.type = Eof});
    return tokens;
}

Token nextToken(void) {
    while (*src == ' ' || *src == '\n' || *src == '\r') {
        if (*src == '\n')
            line++;
        src++;
    }

    if (*src == ';' || *src == '@' || *src == '#') {
        while (*src != '\n' && *src != '\0')
            src++;
    }

    if (isValidBegin(*src)) {
        char* s = strdup(src);
        char* start = src;
        if (*s == 'r') {
            src++;
            if (isnumber(*src)) {
                while (isnumber(*src))
                    src++;

                s[src - start] = 0;
                return (Token) {
                    .file = file,
                    .line = line,
                    .value = s,
                    .type = Register
                };
            }
            src--;
        } else if (*s == 'v') {
            src++;
            if (isnumber(*src)) {
                while (isnumber(*src))
                    src++;

                s[src - start] = 0;
                return (Token) {
                    .file = file,
                    .line = line,
                    .value = s,
                    .type = VecRegister
                };
            }
            src--;
        }
        while (isValid(*src))
            src++;
        
        s[src - start] = 0;
        if (*src == ':') {
            src++;
            return (Token) {
                .file = file,
                .line = line,
                .value = s,
                .type = Label
            };
        }
        if (eq(s, "x") || eq(s, "y")) {
            if (eq(s, "x")) {
                return (Token) {
                    .file = file,
                    .line = line,
                    .value = "x",
                    .type = Register
                };
            } else {
                return (Token) {
                    .file = file,
                    .line = line,
                    .value = "y",
                    .type = Register
                };
            }
        } else if (eq(s, "pc")) {
            return (Token) {
                .file = file,
                .line = line,
                .value = "pc",
                .type = Register
            };
        } else if (eq(s, "lr")) {
            return (Token) {
                .file = file,
                .line = line,
                .value = "lr",
                .type = Register
            };
        } else if (eq(s, "sp")) {
            return (Token) {
                .file = file,
                .line = line,
                .value = "sp",
                .type = Register
            };
        } else if (eq(s, "fr")) {
            return (Token) {
                .file = file,
                .line = line,
                .value = "fr",
                .type = Register
            };
        }
        return (Token) {
            .file = file,
            .line = line,
            .value = s,
            .type = Identifier
        };
    } else if (isnumber(*src)) {
    parseNum: (void) 0;
        char* s = strdup(src);
        char* start = src;
        if (*src == '-') {
            src++;
        }
        if (strncmp(src, "0x", 2) == 0) {
            src += 2;
            while (isxdigit(*src)) {
                src++;
            }
            s[src - start] = 0;
            return (Token) {
                .file = file,
                .line = line,
                .value = s,
                .type = Number
            };
        } else if (strncmp(src, "0b", 2) == 0) {
            src += 2;
            while (*src == '0' || *src == '1') {
                src++;
            }
            s[src - start] = 0;
            return (Token) {
                .file = file,
                .line = line,
                .value = s,
                .type = Number
            };
        } else {
            while (isnumber(*src)) {
                src++;
            }
            if (*src == '.') {
                src++;
                while (isnumber(*src)) {
                    src++;
                }
                s[src - start] = 0;
                return (Token) {
                    .file = file,
                    .line = line,
                    .value = s,
                    .type = NumberFloat
                };
            }

            s[src - start] = 0;
            return (Token) {
                .file = file,
                .line = line,
                .value = s,
                .type = Number
            };
        }
    } else if (*src == '"') {
        char* s = strdup(++src);
        char* start = src;
        while (*src != '"')
            src++;
        
        s[src - start] = 0;
        src++;
        return (Token) {
            .file = file,
            .line = line,
            .value = s,
            .type = String
        };
    } else if (*src == '\'') {
        char* s = strdup(++src);
        char* start = src;
        while (*src != '\'')
            src++;
        
        s[src - start] = 0;
        src++;
        uint8_t num = 0;
        if (s[0] == '\\') {
            switch (s[1]) {
                case 'n':
                    num = '\n';
                    break;
                case 'r':
                    num = '\r';
                    break;
                case 't':
                    num = '\t';
                    break;
                case '0':
                    num = '\0';
                    break;
                case '\\':
                    num = '\\';
                    break;
                case '\'':
                    num = '\'';
                    break;
                case '\"':
                    num = '\"';
                    break;
                default:
                    printf("Unknown escape sequence: \\%c\n", s[1]);
                    return (Token) {
                        .file = file,
                        .line = line,
                        .type = EOF
                    };
            }
        } else {
            num = s[0];
        }
        s = malloc(4);
        snprintf(s, 4, "%d", num);
        return (Token) {
            .file = file,
            .line = line,
            .value = s,
            .type = Number,
        };
    } else if (*src == '.') {
        src++;
        char* s = strdup(src);
        char* start = src;
        while (isValid(*src))
            src++;
        
        s[src - start] = 0;
        return (Token) {
            .file = file,
            .line = line,
            .value = s,
            .type = Directive
        };
    } else if (*src == '[') {
        src++;
        return (Token) {
            .file = file,
            .line = line,
            .value = "[",
            .type = LeftBracket
        };
    } else if (*src == ']') {
        src++;
        return (Token) {
            .file = file,
            .line = line,
            .value = "]",
            .type = RightBracket
        };
    } else if (*src == '!') {
        src++;
        return (Token) {
            .file = file,
            .line = line,
            .value = "!",
            .type = Bang
        };
    } else if (*src == ',') {
        src++;
        return (Token) {
            .file = file,
            .line = line,
            .value = ",",
            .type = Comma
        };
    } else if (*src == '+') {
        src++;
        if (isnumber(*src)) {
            goto parseNum;
        }
        return (Token) {
            .file = file,
            .line = line,
            .value = "+",
            .type = Plus
        };
    } else if (*src == '-') {
        src++;
        if (isnumber(*src)) {
            src--;
            goto parseNum;
        }
        return (Token) {
            .file = file,
            .line = line,
            .value = "-",
            .type = Minus
        };
    } else if (*src == 0) {
        return (Token) {
            .file = file,
            .line = line,
            .type = Eof
        };
    } else {
        return nextToken();
    }
    return (Token) {
        .file = file,
        .line = line,
        .type = Eof
    };
}
