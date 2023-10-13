#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "new_ops.h"

typedef enum _TokenType {
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

section_t compile(Token* tokens);
Token* parse(char* src);

static char* file;

section_t run_compile(const char* file_name) {
    file = malloc(strlen(file_name) + 1);
    strcpy(file, file_name);

    FILE* file = fopen(file_name, "r");
    if (!file) {
        printf("Could not open file: %s\n", file_name);
        return (section_t) {0};
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
            return (section_t) {0};
        }
        if ((src[i] == ';' || src[i] == '#' || src[i] == '@') && !inside_string) {
            while (src[i] != '\n' && i < size) {
                src[i] = ' ';
                i++;
            }
        }
    }

    Token* tokens = parse(src);
    
    return compile(tokens);
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
#define ins(s) eq(instruction_token->value, (s))

char* unquote(const char* str);

uint64_t parse64(char* s) {
    if (s[0] == '0' && s[1] == 'x') {
        return strtoull(s + 2, NULL, 16);
    } else if (s[0] == '0' && s[1] == 'b') {
        return strtoull(s + 2, NULL, 2);
    } else if (s[0] == '0' && s[1] == 'o') {
        return strtoull(s + 2, NULL, 8);
    } else {
        return strtoull(s, NULL, 10);
    }
}

uint32_t parse32(char* s) {
    if (s[0] == '0' && s[1] == 'x') {
        return strtoul(s + 2, NULL, 16);
    } else if (s[0] == '0' && s[1] == 'b') {
        return strtoul(s + 2, NULL, 2);
    } else if (s[0] == '0' && s[1] == 'o') {
        return strtoul(s + 2, NULL, 8);
    } else {
        return strtoul(s, NULL, 10);
    }
}

uint16_t parse16(char* s) {
    if (s[0] == '0' && s[1] == 'x') {
        return strtoul(s + 2, NULL, 16);
    } else if (s[0] == '0' && s[1] == 'b') {
        return strtol(s + 2, NULL, 2);
    } else if (s[0] == '0' && s[1] == 'o') {
        return strtoul(s + 2, NULL, 8);
    } else {
        return strtoul(s, NULL, 10);
    }
}

uint8_t parse8(char* s) {
    if (s[0] == '0' && s[1] == 'x') {
        return strtoul(s + 2, NULL, 16);
    } else if (s[0] == '0' && s[1] == 'b') {
        return strtol(s + 2, NULL, 2);
    } else if (s[0] == '0' && s[1] == 'o') {
        return strtoul(s + 2, NULL, 8);
    } else {
        return strtoul(s, NULL, 10);
    }
}

uint8_t is_conditional(uint8_t opcode) {
    return  opcode == opcode_dot_eq ||
            opcode == opcode_dot_ne ||
            opcode == opcode_dot_cs ||
            opcode == opcode_dot_cc ||
            opcode == opcode_dot_ge ||
            opcode == opcode_dot_lt ||
            opcode == opcode_dot_gt ||
            opcode == opcode_dot_le;
}

section_t compile(Token* tokens) {
    section_t obj;
    for (;tokens->type != EOF; tokens++) {
        if (tokens->type == Identifier) {
            char* mnemonic = lower(tokens->value);
            
            uint64_t flags = 0;
            #define ADDRESSING_BYTE         0x0001
            #define ADDRESSING_WORD         0x0002
            #define ADDRESSING_DWORD        0x0004
            #define ADDRESSING_QWORD        0x0008

            Token* instruction_token = tokens;
            tokens++;
            instruction_t cond[16] = {0};
            int cond_count = 0;
            int extra_dwords = 0;
            instr_arg extra_arg = {0};
            while (tokens->type == Directive && cond_count < 16 && tokens->line == instruction_token->line) {
                char* cond_str = lower(tokens->value);
                
                if (eq(cond_str, "eq")) {
                    cond[cond_count++] = op_dot_eq(
                        ARG_8BIT(0)
                    );
                } else if (eq(cond_str, "ne")) {
                    cond[cond_count++] = op_dot_ne(
                        ARG_8BIT(0)
                    );
                } else if (eq(cond_str, "cs")) {
                    cond[cond_count++] = op_dot_cs(
                        ARG_8BIT(0)
                    );
                } else if (eq(cond_str, "cc")) {
                    cond[cond_count++] = op_dot_cc(
                        ARG_8BIT(0)
                    );
                } else if (eq(cond_str, "ge")) {
                    cond[cond_count++] = op_dot_ge(
                        ARG_8BIT(0)
                    );
                } else if (eq(cond_str, "lt")) {
                    cond[cond_count++] = op_dot_lt(
                        ARG_8BIT(0)
                    );
                } else if (eq(cond_str, "gt")) {
                    cond[cond_count++] = op_dot_gt(
                        ARG_8BIT(0)
                    );
                } else if (eq(cond_str, "le")) {
                    cond[cond_count++] = op_dot_le(
                        ARG_8BIT(0)
                    );
                } else if (eq(cond_str, "byte")) {
                    cond[cond_count++] = op_dot_addressing_override(
                        ARG_8BIT(1)
                    );
                    flags |= ADDRESSING_BYTE;
                } else if (eq(cond_str, "word")) {
                    cond[cond_count++] = op_dot_addressing_override(
                        ARG_8BIT(2)
                    );
                    flags |= ADDRESSING_WORD;
                } else if (eq(cond_str, "dword")) {
                    cond[cond_count++] = op_dot_addressing_override(
                        ARG_8BIT(3)
                    );
                    flags |= ADDRESSING_DWORD;
                } else if (eq(cond_str, "qword")) {
                    cond[cond_count++] = op_dot_addressing_override(
                        ARG_8BIT(4)
                    );
                    flags |= ADDRESSING_QWORD;
                }
                tokens++;
            }
            tokens--;

            instruction_t instr = {0};

            #define EXPECT(_type, _diag) \
                if (tokens->type != _type) { \
                    printf("%s:%d: " _diag, tokens->file, tokens->line, tokens->value); \
                    return (section_t) {0}; \
                }

            if (ins("nop")) {
                instr = op_nop();
            } else if (ins("ret")) {
                instr = op_ret();
            } else if (ins("irq")) {
                instr = op_irq();
            } else if (ins("svc")) {
                instr = op_svc();
            } else if (ins("b")) {
                tokens++;
                EXPECT(Identifier, "Expected identifier, got %s\n");
                instr = op_b_addr(
                    ARG_SYM(tokens->value)
                );
            } else if (ins("bl")) {
                tokens++;
                EXPECT(Identifier, "Expected identifier, got %s\n");
                instr = op_bl_addr(
                    ARG_SYM(tokens->value)
                );
            } else if (ins("br")) {
                tokens++;
                EXPECT(Register, "Expected register, got %s\n");
                instr = op_br_reg(
                    ARG_8BIT(parse8(tokens->value + 1))
                );
            } else if (ins("blr")) {
                tokens++;
                EXPECT(Register, "Expected register, got %s\n");
                instr = op_blr_reg(
                    ARG_8BIT(parse8(tokens->value + 1))
                );
            #define ARITH(_what) \
            } else if (ins(#_what)) { \
                tokens++; \
                EXPECT(Register, "Expected register, got %s\n"); \
                instr_arg dest = ARG_8BIT(parse8(tokens->value + 1)); \
                tokens++; \
                EXPECT(Comma, "Expected comma, got %s\n"); \
                tokens++; \
                if (tokens->type == Register) { \
                    instr_arg lhs = ARG_8BIT(parse8(tokens->value + 1)); \
                    tokens++; \
                    EXPECT(Comma, "Expected comma, got %s\n"); \
                    tokens++; \
                    EXPECT(Register, "Expected register, got %s\n"); \
                    instr_arg rhs = ARG_8BIT(parse8(tokens->value + 1)); \
                    instr = op_ ## _what ## _reg_reg_reg(dest, lhs, rhs); \
                } else if (tokens->type == Number) { \
                    instr_arg imm16 = ARG_16BIT(parse16(tokens->value)); \
                    instr = op_ ## _what ## _reg_imm(dest, imm16); \
                } else { \
                    printf("%s:%d: Expected register or number, got %s\n", tokens->file, tokens->line, tokens->value); \
                    return (section_t) {0}; \
                }
            ARITH(add)
            ARITH(sub)
            ARITH(mul)
            ARITH(div)
            ARITH(mod)
            ARITH(and)
            ARITH(or)
            ARITH(xor)
            ARITH(shl)
            ARITH(shr)
            ARITH(rol)
            ARITH(ror)
            } else if (ins("inc")) {
                tokens++;
                EXPECT(Register, "Expected register, got %s\n");
                instr_arg what = ARG_8BIT(parse8(tokens->value + 1));
                instr = op_inc_reg(what);
            } else if (ins("dec")) {
                tokens++;
                EXPECT(Register, "Expected register, got %s\n");
                instr_arg what = ARG_8BIT(parse8(tokens->value + 1));
                instr = op_dec_reg(what);
            } else if (ins("psh")) {
                tokens++;
                if (tokens->type == Register) {
                    instr_arg what = ARG_8BIT(parse8(tokens->value + 1));
                    instr = op_psh_reg(what);
                } else if (tokens->type == Number) {
                    instr_arg what = ARG_16BIT(parse16(tokens->value));
                    instr = op_psh_imm(what);
                } else if (tokens->type == Identifier) {
                    instr_arg what = ARG_SYM(tokens->value);
                    instr = op_psh_addr(what);
                } else {
                    printf("%s:%d: Expected register, number or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return (section_t) {0};
                }
            } else if (ins("pp")) {
                tokens++;
                EXPECT(Register, "Expected register, got %s\n");
                instr_arg what = ARG_8BIT(parse8(tokens->value + 1));
                instr = op_pp_reg(what);
            } else if (ins("ldr")) {
                tokens++;
                EXPECT(Register, "Expected register, got %s\n");
                instr_arg dest = ARG_8BIT(parse8(tokens->value + 1));
                tokens++;
                EXPECT(Comma, "Expected comma, got %s\n");
                tokens++;
                if (tokens->type == Register) {
                    instr_arg addr = ARG_8BIT(parse8(tokens->value + 1));
                    instr = op_ldr_reg_reg(dest, addr);
                } else if (tokens->type == LeftBracket) {
                    tokens++;
                    EXPECT(Register, "Expected register, got %s\n");
                    instr_arg src = ARG_8BIT(parse8(tokens->value + 1));
                    tokens++;
                    if (tokens->type != RightBracket) {
                        int8_t offset = 0;
                        int8_t sign = 1;
                        if (tokens->type == Minus) {
                            sign = -1;
                            tokens++;
                        } else if (tokens->type == Plus) {
                            tokens++;
                        } else {
                            printf("%s:%d: Expected plus or minus, got %s\n", tokens->file, tokens->line, tokens->value);
                            return (section_t) {0};
                        }
                        if (tokens->type == Number) {
                            offset = parse8(tokens->value);
                            tokens++;
                            EXPECT(RightBracket, "Expected right bracket, got %s\n");
                            instr = op_ldr_reg_addr_imm(dest, src, offset * sign);
                        } else if (tokens->type == Register) {
                            instr_arg offset_reg = ARG_8BIT(parse8(tokens->value + 1));
                            tokens++;
                            EXPECT(RightBracket, "Expected right bracket, got %s\n");
                            if (sign == -1) {
                                printf("%s:%d: Cannot use minus with register offset\n", tokens->file, tokens->line);
                                return (section_t) {0};
                            }
                            instr = op_ldr_reg_addr_reg(dest, src, offset_reg);
                        } else {
                            printf("%s:%d: Expected number or register, got %s\n", tokens->file, tokens->line, tokens->value);
                            return (section_t) {0};
                        }
                    } else {
                        instr = op_ldr_reg_addr_imm(dest, src, 0);
                    }
                } else {
                    printf("%s:%d: Expected register or left bracket, got %s\n", tokens->file, tokens->line, tokens->value);
                    return (section_t) {0};
                }
            } else if (ins("str")) {
                tokens++;
                EXPECT(LeftBracket, "Expected left bracket, got %s\n");
                tokens++;
                EXPECT(Register, "Expected register, got %s\n");
                instr_arg dest = ARG_8BIT(parse8(tokens->value + 1));
                tokens++;
                if (tokens->type == RightBracket) {
                    tokens++;
                    EXPECT(Comma, "Expected comma, got %s\n");
                    tokens++;
                    EXPECT(Register, "Expected register, got %s\n");
                    instr_arg src = ARG_8BIT(parse8(tokens->value + 1));
                    instr = op_str_reg_reg(dest, src);
                } else if (tokens->type == Plus) {
                    tokens++;
                    EXPECT(Register, "Expected register, got %s\n");
                    instr_arg offset_reg = ARG_8BIT(parse8(tokens->value + 1));
                    tokens++;
                    EXPECT(RightBracket, "Expected right bracket, got %s\n");
                    tokens++;
                    EXPECT(Comma, "Expected comma, got %s\n");
                    tokens++;
                    EXPECT(Register, "Expected register, got %s\n");
                    instr_arg src = ARG_8BIT(parse8(tokens->value + 1));
                    instr = op_str_reg_addr_reg(dest, src, offset_reg);
                } else {
                    printf("%s:%d: Expected right bracket or plus, got %s\n", tokens->file, tokens->line, tokens->value);
                    return (section_t) {0};
                }
            } else if (ins("movz")) {
                tokens++;
                EXPECT(Register, "Expected register, got %s\n");
                instr_arg dest = ARG_8BIT(parse8(tokens->value + 1));
                tokens++;
                EXPECT(Comma, "Expected comma, got %s\n");
                tokens++;
                EXPECT(Number, "Expected number, got %s\n");
                int line = tokens->line;
                instr_arg imm16 = ARG_16BIT(parse16(tokens->value));
                tokens++;
                if (tokens->line != line) {
                    tokens--;
                    instr = op_movz(dest, imm16, ARG_8BIT(0));
                } else if (tokens->type != Identifier) {
                    printf("%s:%d: Expected identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return (section_t) {0};
                } else if (eq(tokens->value, "shl")) {
                    tokens++;
                    EXPECT(Number, "Expected number, got %s\n");
                    instr_arg shift = ARG_8BIT(parse8(tokens->value));
                    if (shift.imm8 % 16 != 0) {
                        printf("%s:%d: Shift must be multiple of 16, got %d\n", tokens->file, tokens->line, shift.imm8);
                        return (section_t) {0};
                    }
                    if (shift.imm8 >= 64) {
                        printf("%s:%d: Shift must be less than 64, got %d\n", tokens->file, tokens->line, shift.imm8);
                        return (section_t) {0};
                    }
                    instr = op_movz(dest, imm16, shift);
                } else {
                    printf("%s:%d: Expected shl, got %s\n", tokens->file, tokens->line, tokens->value);
                    return (section_t) {0};
                }
            } else if (ins("movk")) {
                tokens++;
                EXPECT(Register, "Expected register, got %s\n");
                instr_arg dest = ARG_8BIT(parse8(tokens->value + 1));
                tokens++;
                EXPECT(Comma, "Expected comma, got %s\n");
                tokens++;
                EXPECT(Number, "Expected number, got %s\n");
                int line = tokens->line;
                instr_arg imm16 = ARG_16BIT(parse16(tokens->value));
                tokens++;
                if (tokens->line != line) {
                    tokens--;
                    instr = op_movk(dest, imm16, ARG_8BIT(0));
                } else if (tokens->type != Identifier) {
                    printf("%s:%d: Expected identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return (section_t) {0};
                } else if (eq(tokens->value, "shl")) {
                    tokens++;
                    EXPECT(Number, "Expected number, got %s\n");
                    instr_arg shift = ARG_8BIT(parse8(tokens->value));
                    if (shift.imm8 % 16 != 0) {
                        printf("%s:%d: Shift must be multiple of 16, got %d\n", tokens->file, tokens->line, shift.imm8);
                        return (section_t) {0};
                    }
                    if (shift.imm8 >= 64) {
                        printf("%s:%d: Shift must be less than 64, got %d\n", tokens->file, tokens->line, shift.imm8);
                        return (section_t) {0};
                    }
                    instr = op_movk(dest, imm16, shift);
                } else {
                    printf("%s:%d: Expected shl, got %s\n", tokens->file, tokens->line, tokens->value);
                    return (section_t) {0};
                }
            } else if (ins("adrp")) {
                tokens++;
                EXPECT(Register, "Expected register, got %s\n");
                instr_arg dest = ARG_8BIT(parse8(tokens->value + 1));
                tokens++;
                EXPECT(Comma, "Expected comma, got %s\n");
                tokens++;
                EXPECT(Identifier, "Expected identifier, got %s\n");
                instr = op_adrp_reg_addr(dest, ARG_SYM(tokens->value));
            } else if (ins("adp")) {
                tokens++;
                EXPECT(Register, "Expected register, got %s\n");
                instr_arg dest = ARG_8BIT(parse8(tokens->value + 1));
                tokens++;
                EXPECT(Comma, "Expected comma, got %s\n");
                tokens++;
                EXPECT(Identifier, "Expected identifier, got %s\n");
                instr = op_adp_reg_addr(dest, ARG_SYM(tokens->value));
            } else if (ins("cmp")) {
                tokens++;
                EXPECT(Register, "Expected register, got %s\n");
                instr_arg op1 = ARG_8BIT(parse8(tokens->value + 1));
                tokens++;
                EXPECT(Comma, "Expected comma, got %s\n");
                tokens++;
                EXPECT(Register, "Expected register, got %s\n");
                instr_arg op2 = ARG_8BIT(parse8(tokens->value + 1));
                instr = op_cmp_reg_reg(op1, op2);
            } else if (ins("xchg")) {
                tokens++;
                EXPECT(Register, "Expected register, got %s\n");
                instr_arg op1 = ARG_8BIT(parse8(tokens->value + 1));
                tokens++;
                EXPECT(Comma, "Expected comma, got %s\n");
                tokens++;
                EXPECT(Register, "Expected register, got %s\n");
                instr_arg op2 = ARG_8BIT(parse8(tokens->value + 1));
                instr = op_xchg_reg_reg(op1, op2);
            } else if (ins("cmpxchg")) {
                tokens++;
                EXPECT(Register, "Expected register, got %s\n");
                instr_arg op1 = ARG_8BIT(parse8(tokens->value + 1));
                tokens++;
                EXPECT(Comma, "Expected comma, got %s\n");
                tokens++;
                EXPECT(Register, "Expected register, got %s\n");
                instr_arg op2 = ARG_8BIT(parse8(tokens->value + 1));
                instr = op_cmpxchg_reg_reg(op1, op2);
            } else if (ins("movz")) {
                tokens++;
                EXPECT(Register, "Expected register, got %s\n");
                instr_arg dest = ARG_8BIT(parse8(tokens->value + 1));
                tokens++;
                EXPECT(Comma, "Expected comma, got %s\n");
                tokens++;
                EXPECT(Number, "Expected number, got %s\n");
                instr = op_movz(dest, ARG_16BIT(parse16(tokens->value)));
            } else if (ins("not")) {
                tokens++;
                EXPECT(Register, "Expected register, got %s\n");
                instr = op_not_reg(ARG_8BIT(parse8(tokens->value + 1)));
            } else if (ins("pause")) {
                instr = op_pause();
            } else {
                printf("%s:%d: Unknown instruction: %s\n", tokens->file, tokens->line, tokens->value);
                return (section_t) {0};
            }
            for (int i = 0; i < cond_count; i++) {
                if (is_conditional(cond[i].opcode)) {
                    cond[i].args[0].imm8 += cond_count - i - 1 + extra_dwords;
                }
                add_instruction(&obj, cond[i]);
            }
            add_instruction(&obj, instr);
        } else if (tokens->type == Directive) {
            if (eq(tokens->value, "asciz") || eq(tokens->value, "ascii")) {
                tokens++;
                if (tokens->type != String) {
                    printf("%s:%d: Expected string, got %s\n", tokens->file, tokens->line, tokens->value);
                    return (section_t) {0};
                }
                char* str = tokens->value;
                str = unquote(str);
                size_t len = strlen(str) + !eq((tokens - 1)->value, "ascii");
                if (eq((tokens - 1)->value, "ascii")) {
                    ASCII(str);
                } else {
                    ASCIZ(str);
                }
                while (len % 4 != 0) {
                    add_imm_byte(&obj, 0);
                    len++;
                }
            } else if (eq(tokens->value, "byte")) {
                tokens++;
                if (tokens->type != Number) {
                    printf("%s:%d: Expected number, got %s\n", tokens->file, tokens->line, tokens->value);
                    return (section_t) {0};
                }
                uint8_t num = parse8(tokens->value);
                add_imm_byte(&obj, num);
                add_imm_byte(&obj, 0);
                add_imm_byte(&obj, 0);
                add_imm_byte(&obj, 0);
            } else if (eq(tokens->value, "word")) {
                tokens++;
                if (tokens->type != Number) {
                    printf("%s:%d: Expected number, got %s\n", tokens->file, tokens->line, tokens->value);
                    return (section_t) {0};
                }
                uint16_t num = parse16(tokens->value);
                add_imm_word(&obj, num);
                add_imm_word(&obj, 0);
            } else if (eq(tokens->value, "dword")) {
                tokens++;
                if (tokens->type != Number) {
                    printf("%s:%d: Expected number, got %s\n", tokens->file, tokens->line, tokens->value);
                    return (section_t) {0};
                }
                uint32_t num = parse32(tokens->value);
                add_imm_dword(&obj, num);
            } else if (eq(tokens->value, "qword")) {
                tokens++;
                if (tokens->type == Number) {
                    uint64_t num = parse64(tokens->value);
                    add_imm_qword(&obj, num);
                } else if (tokens->type == Identifier) {
                    add_symbol_offset(&obj, tokens->value);
                } else {
                    printf("%s:%d: Expected number or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                }
            } else if (eq(tokens->value, "float")) {
                tokens++;
                if (tokens->type != NumberFloat) {
                    printf("%s:%d: Expected number, got %s\n", tokens->file, tokens->line, tokens->value);
                    return (section_t) {0};
                }
                float num = atof(tokens->value);
                add_imm_dword(&obj, *(int32_t*) &num);
            } else if (eq(tokens->value, "double")) {
                tokens++;
                if (tokens->type != NumberFloat) {
                    printf("%s:%d: Expected number, got %s\n", tokens->file, tokens->line, tokens->value);
                    return (section_t) {0};
                }
                double num = atof(tokens->value);
                add_imm_qword(&obj, *(int64_t*) &num);
            } else if (eq(tokens->value, "offset")) {
                tokens++;
                if (tokens->type != Identifier) {
                    printf("%s:%d: Expected identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return (section_t) {0};
                }
                add_symbol_offset(&obj, tokens->value);
            } else if (eq(tokens->value, "zerofill")) {
                tokens++;
                EXPECT(Number, "Expected number, got %s\n");
                uint64_t size = parse64(tokens->value);
                size += 4 - size % 4;
                while (size > 0) {
                    add_imm_byte(&obj, 0);
                    size--;
                }
            } else {
                printf("%s:%d: Unknown directive: %s\n", tokens->file, tokens->line, tokens->value);
                return (section_t) {0};
            }
        } else if (tokens->type == Label) {
            char* str = tokens->value;
            str = unquote(str);
            CODE(str);
        }
    }
    return obj;
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

Token nextToken();

static char* src;
static int line = 1;

Token* parse(char* data) {
    Token* tokens = malloc(sizeof(Token) * 1024);
    size_t i = 0;
    src = data;
    while (*src) {
        tokens[i++] = nextToken();
    }
    tokens[i++] = (Token) {
        .type = EOF
    };
    return tokens;
}

Token nextToken() {
    while (*src == ' ' || *src == '\n' || *src == '\r') {
        if (*src == '\n')
            line++;
        src++;
    }

    if (*src == ';' || *src == '@') {
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
                    .value = "r0",
                    .type = Register
                };
            } else {
                return (Token) {
                    .file = file,
                    .line = line,
                    .value = "r1",
                    .type = Register
                };
            }
        } else if (eq(s, "pc")) {
            return (Token) {
                .file = file,
                .line = line,
                .value = "r32",
                .type = Register
            };
        } else if (eq(s, "lr")) {
            return (Token) {
                .file = file,
                .line = line,
                .value = "r33",
                .type = Register
            };
        } else if (eq(s, "sp")) {
            return (Token) {
                .file = file,
                .line = line,
                .value = "r34",
                .type = Register
            };
        } else if (eq(s, "fr")) {
            return (Token) {
                .file = file,
                .line = line,
                .value = "r35",
                .type = Register
            };
        } else if (eq(s, "zero")) {
            return (Token) {
                .file = file,
                .line = line,
                .value = "r48",
                .type = Register
            };
        } else if (eq(s, "one")) {
            return (Token) {
                .file = file,
                .line = line,
                .value = "r49",
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
        return (Token) {
            .file = file,
            .line = line,
            .value = "+",
            .type = Plus
        };
    } else if (*src == '-') {
        src++;
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
            .type = EOF
        };
    } else {
        return nextToken();
    }
    return (Token) {
        .file = file,
        .line = line,
        .type = EOF
    };
}
