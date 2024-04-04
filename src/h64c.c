#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "new_ops.h"

Token_Array parse(char* src, int l);
SB_Array compile(Token_Array tokens, Symbol_Array* syms, Relocation_Array* relocations, uint64_t current_sect_type);
char* dis(hive_instruction_t** insp, uint64_t addr);

#ifdef __printflike
__printflike(1, 2)
#endif
char* strformat(const char* fmt, ...);

static char* file;
Nob_File_Paths errors = {0};

SB_Array run_compile(const char* file_name, Symbol_Array* syms, Relocation_Array* relocations) {
    file = malloc(strlen(file_name) + 1);
    strcpy(file, file_name);

    FILE* file = fopen(file_name, "r");
    if (!file) {
        printf("Could not open file: %s\n", file_name);
        return (SB_Array) {0};
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
            return (SB_Array) {0};
        }
        if ((src[i] == ';' || src[i] == '#' || src[i] == '@') && !inside_string) {
            while (src[i] != '\n' && i < size) {
                src[i] = ' ';
                i++;
            }
        }
    }

    Token_Array tokens = parse(src, 1);
    if (errors.count) {
        for (size_t i = 0; i < errors.count; i++) {
            fprintf(stderr, "%s", errors.items[i]);
        }
        exit(errors.count);
    }

    return compile(tokens, syms, relocations, SECT_TYPE_NOEMIT);
}

bool isHex(char c) {
    return (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F');
}

void disline(char* line, size_t size) {
    uint8_t bytes[size < 8 ? 8 : size];
    memset(bytes, 0, size < 8 ? 8 : size);
    size_t count = 0;
    size_t index = 0;
    while (line[index]) {
        if (!isHex(line[index])) {
            index++;
            continue;
        }

        for (int i = 0; i < 2; i++) {
            bytes[count] *= 16;
            if (line[index + i] >= '0' && line[index + i] <= '9') {
                bytes[count] += line[index + i] - '0';
            } else if (line[index + i] >= 'a' && line[index + i] <= 'f') {
                bytes[count] += line[index + i] - 'a' + 10;
            } else if (line[index + i] >= 'A' && line[index + i] <= 'F') {
                bytes[count] += line[index + i] - 'A' + 10;
            } else {
                nob_da_append(&errors, strformat("(stdin): Invalid hex number: %s\n", line));
            }
        }
        count++;
        index += 2;
    }
    hive_instruction_t* ins = (hive_instruction_t*) bytes;
    char* s = dis(&ins, (uint64_t) ins);
    printf("%s\n", s);
    free(s);
}

void asline(char* line, size_t size, int lc) {
    Token_Array tokens = parse(line, lc);
    if (errors.count) {
        for (size_t i = 0; i < errors.count; i++) {
            fprintf(stderr, "%s", errors.items[i]);
        }
        return;
    }
    Symbol_Array syms = {0};
    Relocation_Array relocations = {0};
    SB_Array cur = compile(tokens, &syms, &relocations, SECT_TYPE_TEXT);
    for (size_t i = 0; i < cur.count; i++) {
        for (size_t j = 0; j < cur.items[i].data.count; j++) {
            printf("%02x ", cur.items[i].data.items[j] & 0xFF);
        }
        printf("\n");
    }
}

void shell() {
    file = "(stdin)";
    FILE* file = stdin;
    if (!file) {
        printf("Could not open stdin\n");
        return;
    }
    printf("Hive64 interactive shell\nRun /help for a list of all commands\n");

    char* line = NULL;
    size_t size = 0;
    int lc = 1;
    bool dis_mode = false;
    do {
        errors = (Nob_File_Paths) {0};
        #define strstarts(a, b) (strncmp(a, b, strlen(b)) == 0)
        if (line) {
            if (line[0] == '/') {
                if (strstarts(line, "/dis\n")) {
                    dis_mode = true;
                } else if (strstarts(line, "/as\n")) {
                    dis_mode = false;
                } else if (strstarts(line, "/dis ")) {
                    disline(line + 5, size - 5);
                } else if (strstarts(line, "/as ")) {
                    asline(line + 4, size - 4, lc);
                } else if (strstarts(line, "/exit")) {
                    return;
                } else if (strstarts(line, "/help")) {
                    printf("/as [instr]: Switch to assembly mode or assemble instruction\n");
                    printf("/dis [bytes]: Switch to disassembly mode or disassemble bytes\n");
                    printf("/exit: Exit\n");
                    printf("/help: Show this\n");
                }
            } else {
                if (dis_mode) {
                    disline(line, size);
                } else {
                    asline(line, size, lc);
                }
            }
            lc++;

            line[0] = 0;
            free(line);
            line = NULL;
        }
        if (dis_mode) {
            printf("dis> ");
        } else {
            printf("as> ");
        }
    } while (getline(&line, &size, file) >= 0);
}

int isValidBegin(int c) {
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_' || c == '$';
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
                nob_da_append(&errors, strformat("%s:%d: Invalid hex number: %s\n", file, line, value));
                return 0;
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
                nob_da_append(&errors, strformat("%s:%d: Invalid binary number: %s\n", file, line, value));
                return 0;
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
                nob_da_append(&errors, strformat("%s:%d: Invalid octal number: %s\n", file, line, value));
                return 0;
            }
            s++;
        }
    } else {
        while (*s) {
            result *= 10;
            if (*s >= '0' && *s <= '9') {
                result += *s - '0';
            } else {
                nob_da_append(&errors, strformat("%s:%d: Invalid decimal number: %s\n", file, line, value));
                return 0;
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

static hive_instruction_t prefix = {0};

uint8_t parse_reg_(char* s, uint8_t c, char* file, int line, char* value, ...) {
    if (s[0] == 'r' || s[0] == 'b' || s[0] == 'w' || s[0] == 'd' || s[0] == 'q') {
        char* suf = NULL;
        uint8_t val = strtoul(s + 1, &suf, 0);
        if (val >= 32) {
            nob_da_append(&errors, strformat("%s:%d: Unknown register: %s\n", file, line, value));
        }
        if (suf[0] == 'h') {
            va_list ap;
            va_start(ap, value);
            prefix.generic.condition = COND_ALWAYS;
            for (uint8_t i = 0; i < c; i++) {
                uint32_t x = va_arg(ap, uint32_t);
                prefix.type_other_prefix.reg_override |= IS_HIGH(x);
            }
            va_end(ap);
        }
        return val;
    } else if (s[0] == 'c' && s[1] == 'r') {
        char* suf = NULL;
        uint8_t val = strtoul(s + 2, &suf, 0);
        if (val >= 12) {
            nob_da_append(&errors, strformat("%s:%d: Unknown control register: %s\n", file, line, value));
        }
        prefix.generic.condition = COND_ALWAYS;
        va_list ap;
        va_start(ap, value);
        for (uint8_t i = 0; i < c; i++) {
            uint32_t x = va_arg(ap, uint32_t);
            prefix.type_other_prefix.references_cr |= IS_HIGH(x);
            if (suf[0] == 'h') {
                prefix.type_other_prefix.reg_override |= IS_HIGH(x);
            }
        }
        va_end(ap);
        return val;
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
    nob_da_append(&errors, strformat("%s:%d: Unknown register: %s\n", file, line, value));
    return -1;
}
uint8_t parse_vreg_(char* s, char* file, int line, char* value) {
    if (s[0] == 'v') {
        uint8_t val = strtoul(s + 1, NULL, 0);
        if (val >= 16) {
            nob_da_append(&errors, strformat("%s:%d: Unknown vector register: %s\n", file, line, value));
        }
        return val;
    }
    nob_da_append(&errors, strformat("%s:%d: Unknown vector register: %s\n", file, line, value));
    return -1;
}
uint8_t parse_condition_(char* s, char* file, int line, char* value) {
    if (eq(s, "eq") || eq(s, "z")) return COND_EQ;
    if (eq(s, "ne") || eq(s, "nz")) return COND_NE;
    if (eq(s, "ge") || eq(s, "pl")) return COND_GE;
    if (eq(s, "gt")) return COND_GT;
    if (eq(s, "le")) return COND_LE;
    if (eq(s, "lt") || eq(s, "mi")) return COND_LT;
    nob_da_append(&errors, strformat("%s:%d: Unknown condition: %s\n", file, line, value));
    return -1;
}
uint8_t parse_size_(char* s, char* file, int line, char* value) {
    if (eq(s, "byte")) return SIZE_8BIT;
    if (eq(s, "word")) return SIZE_16BIT;
    if (eq(s, "dword")) return SIZE_32BIT;
    if (eq(s, "qword")) return SIZE_64BIT;
    nob_da_append(&errors, strformat("%s:%d: Unknown condition: %s\n", file, line, value));
    return -1;
}

#define EXPECT(_type, _diag, ...) \
    if (tokens.items[i].type != _type) { \
        nob_da_append(&errors, strformat("%s:%d: " _diag "\n", tokens.items[i].file, tokens.items[i].line, __VA_ARGS__ __VA_OPT__(,) tokens.items[i].value)); \
        continue; \
    }

#define parse_reg(s, ...) parse_reg_((s), PREPROC_NARG(__VA_ARGS__), tokens.items[i].file, tokens.items[i].line, tokens.items[i].value, __VA_ARGS__)
#define parse_condition(s) parse_condition_((s), tokens.items[i].file, tokens.items[i].line, tokens.items[i].value)
#define parse_vreg(s) parse_vreg_((s), tokens.items[i].file, tokens.items[i].line, tokens.items[i].value)
#define parse_size(s) parse_size_((s), tokens.items[i].file, tokens.items[i].line, tokens.items[i].value)

#define inc() do { i++; if (i >= tokens.count) { EXPECT(Eof, "Expected more tokens: %s"); } } while (0)

#define POW2(_n) (1 << _n)

TokenType register_types[] = {
    [SIZE_8BIT] = Register8,
    [SIZE_16BIT] = Register16,
    [SIZE_32BIT] = Register32,
    [SIZE_64BIT] = Register64,
};

#define EXPECT_REG(_diag, ...) \
    if (tokens.items[i].type > Register64 || tokens.items[i].type < Register8) { \
        EXPECT(Eof, _diag, __VA_ARGS__);  \
    } else if (!set_size) { \
        set_size = 1; \
        if (tokens.items[i].type != Register64) { \
            register_type = tokens.items[i].type; \
            prefix.generic.condition = COND_ALWAYS; \
            switch ((int) register_type) { \
                case Register8: \
                    register_size = 8; \
                    prefix.type_other_prefix.size = SIZE_8BIT; \
                    break; \
                case Register16: \
                    register_size = 16; \
                    prefix.type_other_prefix.size = SIZE_16BIT; \
                    break; \
                case Register32: \
                    register_size = 32; \
                    prefix.type_other_prefix.size = SIZE_32BIT; \
                    break; \
                case Register64: \
                    register_size = 64; \
                    prefix.type_other_prefix.size = SIZE_64BIT; \
                    break; \
            } \
        } \
    } else if (register_type != tokens.items[i].type) { \
        EXPECT(Eof, _diag, __VA_ARGS__);  \
    }

#define LDR() \
    inc(); \
    EXPECT_REG("Expected %d-bit register, got %s", register_size); \
    uint8_t r1 = parse_reg(tokens.items[i].value, REG_DEST); \
    inc(); \
    EXPECT(Comma, "Expected comma, got %s"); \
    inc(); \
    EXPECT(LeftBracket, "Expected '[', got %s"); \
    inc(); \
    if (tokens.items[i].type == Identifier) { \
        ins.generic.type = MODE_LOAD; \
        ins.type_load_ls_off.op = OP_LOAD_ls_off; \
        ins.type_load_ls_off.r1 = r1; \
        char* str = tokens.items[i].value; \
        str = unquote(str); \
        if (last_global_symbol && str[0] == '$') { \
            str = strformat("%s%s", last_global_symbol, str); \
        } \
        Relocation off = { \
            .data.name = str, \
            .source_offset = current_section.count, \
            .source_section = sects.count, \
            .type = sym_ls_off \
        };  \
        nob_da_append(relocations, off); \
        inc(); \
        EXPECT(RightBracket, "Expected ']', got %s"); \
    } else { \
        EXPECT(Register64, "Expected 64-bit register or identifier, got %s"); \
        uint8_t r2 = parse_reg(tokens.items[i].value, REG_SRC1); \
        inc(); \
        ins.generic.type = MODE_DATA; \
        ins.type_data_ls_imm.data_op = SUBOP_DATA_LS; \
        if (tokens.items[i].type == RightBracket) { \
            ins.type_data_ls_imm.is_store = 0; \
            ins.type_data_ls_imm.r1 = r1; \
            ins.type_data_ls_imm.r2 = r2; \
            ins.type_data_ls_imm.imm = 0; \
            ins.type_data_ls_imm.use_immediate = 1; \
            if (tokens.items[i + 1].type == Bang) { \
                inc(); \
                ins.type_data_ls_imm.update_ptr = 1; \
            } \
        } else if (tokens.items[i].type == Comma) { \
            inc(); \
            if (tokens.items[i].type == Register64) { \
                ins.type_data_ls_reg.is_store = 0; \
                ins.type_data_ls_reg.r1 = r1; \
                ins.type_data_ls_reg.r2 = r2; \
                ins.type_data_ls_reg.r3 = parse_reg(tokens.items[i].value, REG_SRC2); \
            } else if (tokens.items[i].type == Number) { \
                ins.type_data_ls_imm.is_store = 0; \
                ins.type_data_ls_imm.r1 = r1; \
                ins.type_data_ls_imm.r2 = r2; \
                int16_t num = parse16(tokens.items[i].value); \
                if (num < 128 && num >= -128) { \
                    ins.type_data_ls_imm.use_immediate = 1; \
                    ins.type_data_ls_imm.imm = num; \
                } else if (num >= 0) { \
                    uint16_t x = *(uint16_t*) &num; \
                    ins.type_data_ls_far.data_op = SUBOP_DATA_LS_FAR; \
                    uint8_t shift = 0; \
                    if (x % 256 == 0) { \
                        ins.type_data_ls_far.imm = (x >> 8); \
                        shift = 7; \
                    } else if (x % 128 == 0 && x < POW2(15)) { \
                        ins.type_data_ls_far.imm = (x >> 7); \
                        shift = 6; \
                    } else if (x % 64 == 0 && x < POW2(14)) { \
                        ins.type_data_ls_far.imm = (x >> 6); \
                        shift = 5; \
                    } else if (x % 32 == 0 && x < POW2(13)) { \
                        ins.type_data_ls_far.imm = (x >> 5); \
                        shift = 4; \
                    } else if (x % 16 == 0 && x < POW2(12)) { \
                        ins.type_data_ls_far.imm = (x >> 4); \
                        shift = 3; \
                    } else if (x % 8 == 0 && x < POW2(11)) { \
                        ins.type_data_ls_far.imm = (x >> 3); \
                        shift = 2; \
                    } else if (x % 4 == 0 && x < POW2(10)) { \
                        ins.type_data_ls_far.imm = (x >> 2); \
                        shift = 1; \
                    } else if (x % 2 == 0 && x < POW2(9)) { \
                        ins.type_data_ls_far.imm = (x >> 1); \
                    } else { \
                        EXPECT(Eof, "Number out of range: %s"); \
                    } \
                    ins.type_data_ls_far.shift = shift; \
                } else { \
                    EXPECT(Eof, "Number out of range: %s"); \
                } \
            } else { \
                EXPECT(Eof, "Expected %d-bit register or number, got %s", register_size); \
            } \
            inc(); \
            EXPECT(RightBracket, "Expected ']', got %s"); \
            if (tokens.items[i + 1].type == Bang) { \
                inc(); \
                ins.type_data_ls_imm.update_ptr = 1; \
            } \
        } else { \
            EXPECT(Eof, "Expected comma or ']', got %s"); \
        } \
    }

#define STR()  \
    inc(); \
    EXPECT_REG("Expected %d-bit register, got %s", register_size); \
    uint8_t r1 = parse_reg(tokens.items[i].value, REG_DEST); \
    inc(); \
    EXPECT(Comma, "Expected comma, got %s"); \
    inc(); \
    EXPECT(LeftBracket, "Expected '[', got %s"); \
    inc(); \
    if (tokens.items[i].type == Identifier) { \
        ins.generic.type = MODE_LOAD; \
        ins.type_load_ls_off.op = OP_LOAD_ls_off; \
        ins.type_load_ls_off.is_store = 1; \
        ins.type_load_ls_off.r1 = r1; \
        char* str = tokens.items[i].value; \
        str = unquote(str); \
        if (last_global_symbol && str[0] == '$') { \
            str = strformat("%s%s", last_global_symbol, str); \
        } \
        Relocation off = { \
            .data.name = str, \
            .source_offset = current_section.count, \
            .source_section = sects.count, \
            .type = sym_ls_off \
        };  \
        nob_da_append(relocations, off); \
        inc(); \
        EXPECT(RightBracket, "Expected ']', got %s"); \
    } else { \
        EXPECT(Register64, "Expected 64-bit register or identifier, got %s"); \
        uint8_t r2 = parse_reg(tokens.items[i].value, REG_SRC1); \
        inc(); \
        ins.generic.type = MODE_DATA; \
        ins.type_data_ls_imm.data_op = SUBOP_DATA_LS; \
        if (tokens.items[i].type == RightBracket) { \
            ins.type_data_ls_imm.is_store = 1; \
            ins.type_data_ls_imm.r1 = r1; \
            ins.type_data_ls_imm.r2 = r2; \
            ins.type_data_ls_imm.imm = 0; \
            ins.type_data_ls_imm.use_immediate = 1; \
            if (tokens.items[i + 1].type == Bang) { \
                inc(); \
                ins.type_data_ls_imm.update_ptr = 1; \
            } \
        } else if (tokens.items[i].type == Comma) { \
            inc(); \
            if (tokens.items[i].type == Register64) { \
                ins.type_data_ls_reg.is_store = 1; \
                ins.type_data_ls_reg.r1 = r1; \
                ins.type_data_ls_reg.r2 = r2; \
                ins.type_data_ls_reg.r3 = parse_reg(tokens.items[i].value, REG_SRC2); \
            } else if (tokens.items[i].type == Number) { \
                ins.type_data_ls_imm.is_store = 1; \
                ins.type_data_ls_imm.r1 = r1; \
                ins.type_data_ls_imm.r2 = r2; \
                int16_t num = parse16(tokens.items[i].value); \
                if (num < 128 && num >= -128) { \
                    ins.type_data_ls_imm.use_immediate = 1; \
                    ins.type_data_ls_imm.imm = num; \
                } else if (num >= 0) { \
                    uint16_t x = *(uint16_t*) &num; \
                    ins.type_data_ls_far.data_op = SUBOP_DATA_LS_FAR; \
                    uint8_t shift = 0; \
                    if (x % 2 == 0 && x < POW2(9)) { \
                        ins.type_data_ls_far.imm = (x >> 1); \
                    } else if (x % 4 == 0 && x < POW2(10)) { \
                        ins.type_data_ls_far.imm = (x >> 2); \
                        shift = 1; \
                    } else if (x % 8 == 0 && x < POW2(11)) { \
                        ins.type_data_ls_far.imm = (x >> 3); \
                        shift = 2; \
                    } else if (x % 16 == 0 && x < POW2(12)) { \
                        ins.type_data_ls_far.imm = (x >> 4); \
                        shift = 3; \
                    } else if (x % 32 == 0 && x < POW2(13)) { \
                        ins.type_data_ls_far.imm = (x >> 5); \
                        shift = 4; \
                    } else if (x % 64 == 0 && x < POW2(14)) { \
                        ins.type_data_ls_far.imm = (x >> 6); \
                        shift = 5; \
                    } else if (x % 128 == 0 && x < POW2(15)) { \
                        ins.type_data_ls_far.imm = (x >> 7); \
                        shift = 6; \
                    } else if (x % 256 == 0) { \
                        ins.type_data_ls_far.imm = (x >> 8); \
                        shift = 7; \
                    } else { \
                        EXPECT(Eof, "Number out of range: %s"); \
                    } \
                    ins.type_data_ls_far.shift = shift; \
                } else { \
                    EXPECT(Eof, "Number out of range: %s"); \
                } \
            } else { \
                EXPECT(Eof, "Expected %d-bit register or number, got %s", register_size); \
            } \
            inc(); \
            EXPECT(RightBracket, "Expected ']', got %s"); \
            if (tokens.items[i + 1].type == Bang) { \
                inc(); \
                ins.type_data_ls_imm.update_ptr = 1; \
            } \
        } else { \
            EXPECT(Eof, "Expected comma or ']', got %s"); \
        } \
    }

#define OP(_what) \
    inc(); \
    EXPECT_REG("Expected %d-bit register, got %s", register_size); \
    uint8_t r1 = parse_reg(tokens.items[i].value, REG_DEST, REG_SRC1); \
    inc(); \
    EXPECT(Comma, "Expected comma, got %s"); \
    inc(); \
    ins.generic.type = MODE_DATA; \
    ins.type_data_alui.op = OP_DATA_ALU_ ## _what; \
    if (tokens.items[i].type == register_type) { \
        uint8_t r2 = parse_reg(tokens.items[i].value, REG_SRC1, REG_SRC2); \
        if (tokens.items[i + 1].type == Comma) { \
            i += 2; \
            if (tokens.items[i].type == Number) { \
                uint8_t num = parse8(tokens.items[i].value); \
                ins.type_data.data_op = SUBOP_DATA_ALU_I; \
                ins.type_data_alui.r1 = r1; \
                ins.type_data_alui.r2 = r2; \
                ins.type_data_alui.imm = num; \
            } else if (tokens.items[i].type == register_type) { \
                uint8_t r3 = parse_reg(tokens.items[i].value, REG_SRC2); \
                ins.type_data.data_op = SUBOP_DATA_ALU_R; \
                ins.type_data_alur.r1 = r1; \
                ins.type_data_alur.r2 = r2; \
                ins.type_data_alur.r3 = r3; \
            } else { \
                EXPECT(Eof, "Expected number or register, got %s"); \
            } \
        } else { \
            ins.type_data.data_op = SUBOP_DATA_ALU_R; \
            ins.type_data_alur.r1 = r1; \
            ins.type_data_alur.r2 = r1; \
            ins.type_data_alur.r3 = r2; \
        } \
    } else if (tokens.items[i].type == Number) { \
        uint8_t num = parse8(tokens.items[i].value); \
        ins.type_data.data_op = SUBOP_DATA_ALU_I; \
        ins.type_data_alui.r1 = r1; \
        ins.type_data_alui.r2 = r1; \
        ins.type_data_alui.imm = num; \
    } else { \
        EXPECT_REG("Expected %d-bit register or number, got %s", register_size); \
    }

#define FLOAT_OP(_op) \
    uint8_t full_float = eq(mnemonic, #_op); \
    inc(); \
    EXPECT_REG("Expected %d-bit register, got %s", register_size); \
    uint8_t r1 = parse_reg(tokens.items[i].value, REG_DEST); \
    inc(); \
    EXPECT(Comma, "Expected comma, got %s"); \
    inc(); \
    EXPECT_REG("Expected %d-bit register, got %s", register_size); \
    uint8_t r2 = parse_reg(tokens.items[i].value, REG_SRC1); \
    inc(); \
    EXPECT(Comma, "Expected comma, got %s"); \
    inc(); \
    EXPECT_REG("Expected %d-bit register, got %s", register_size); \
    uint8_t r3 = parse_reg(tokens.items[i].value, REG_SRC2); \
    ins.type_data_fpu.op = OP_DATA_FLOAT_ ## _op; \
    ins.type_data_fpu.use_int_arg2 = !full_float; \
    ins.type_data_fpu.r1 = r1; \
    ins.type_data_fpu.r2 = r2; \
    ins.type_data_fpu.r3 = r3;

uint64_t find_symbol_address(Symbol_Array syms, char* name);
Symbol find_symbol(Symbol_Array syms, char* name);

SB_Array compile(Token_Array tokens, Symbol_Array* syms, Relocation_Array* relocations, uint64_t current_sect_type) {
    Nob_String_Builder current_section = {0};
    SB_Array sects = {0};

    Nob_File_Paths exported_symbols = {0};

    char* last_global_symbol = NULL;

    for (size_t i = 0; i < tokens.count; i++) {
        if (tokens.items[i].type == Eof) break;

        if (tokens.items[i].type == Identifier) {
            Nob_String_Builder additional_ops = {0};
            char* mnemonic = lower(tokens.items[i].value);

            uint8_t register_size = 64;
            TokenType register_type = Register64;
            uint8_t set_size = 0;

            prefix = (hive_instruction_t) {0};
            prefix.generic.condition = COND_NEVER;
            prefix.generic.type = MODE_OTHER;
            prefix.type_other_prefix.op = OP_OTHER_prefix;
            prefix.type_other_prefix.reg_override = 0;
            prefix.type_other_prefix.reset_flags = 0;
            prefix.type_other_prefix.size = SIZE_64BIT;
            
            hive_instruction_t ins = {0};
            ins.generic.condition = COND_ALWAYS;
        check_again:
            if (tokens.items[i + 1].line == tokens.items[i].line) {
                if (tokens.items[i + 1].type == Directive) {
                    inc();
                    ins.generic.condition = parse_condition(tokens.items[i].value);
                    goto check_again;
                } else if (
                    eq(tokens.items[i + 1].value, "byte") ||
                    eq(tokens.items[i + 1].value, "word") ||
                    eq(tokens.items[i + 1].value, "dword") ||
                    eq(tokens.items[i + 1].value, "qword")
                ) {
                    inc();
                    prefix.generic.condition = COND_ALWAYS;
                    prefix.type_other_prefix.size = parse_size(tokens.items[i].value);
                    set_size = 1;
                    switch (prefix.type_other_prefix.size) {
                        case SIZE_8BIT:
                            register_size = 8;
                            register_type = Register8;
                            break;
                        case SIZE_16BIT:
                            register_size = 16;
                            register_type = Register16;
                            break;
                        case SIZE_32BIT:
                            register_size = 32;
                            register_type = Register32;
                            break;
                        case SIZE_64BIT:
                            register_size = 64;
                            register_type = Register64;
                            break;
                    }
                }
            }
            if (eq(mnemonic, "nop")) {
                ins.generic.condition = COND_NEVER;
            } else if (eq(mnemonic, "ret")) {
                ins.generic.type = MODE_DATA;
                ins.type_data.data_op = SUBOP_DATA_ALU_I;
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
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t reg = parse_reg(tokens.items[i].value, REG_DEST);
                ins.type_branch_register.r1 = reg;
            } else if (eq(mnemonic, "blr")) {
                ins.generic.type = MODE_BRANCH;
                ins.type_branch.is_reg = 1;
                ins.type_branch.link = 1;
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t reg = parse_reg(tokens.items[i].value, REG_DEST);
                ins.type_branch_register.r1 = reg;
            } else if (eq(mnemonic, "svc")) {
                ins.generic.type = MODE_LOAD;
                ins.type_load.op = OP_LOAD_svc;
            } else if (eq(mnemonic, "cpuid")) {
                ins.generic.type = MODE_OTHER;
                ins.type_other.op = OP_OTHER_priv_op;
                ins.type_other_priv.op = SUBOP_OTHER_cpuid;
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
                if (eq(mnemonic, "asl")) {
                    ins.type_data_alui.salu = 1;
                }
            } else if (eq(mnemonic, "shr") || eq(mnemonic, "asr")) {
                OP(shr)
                if (eq(mnemonic, "asr")) {
                    ins.type_data_alui.salu = 1;
                }
            } else if (eq(mnemonic, "rol")) {
                OP(rol)
            } else if (eq(mnemonic, "ror")) {
                OP(ror)
            } else if (eq(mnemonic, "neg") || eq(mnemonic, "not")) {
                bool not = eq(mnemonic, "not");
                ins.generic.type = MODE_DATA;
                ins.type_data.data_op = SUBOP_DATA_ALU_R;
                ins.type_data_alur.op = not ? OP_DATA_ALU_not : OP_DATA_ALU_neg;
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r1 = parse_reg(tokens.items[i].value, REG_DEST, REG_SRC1);
                uint8_t r2 = r1;
                inc();
                if (tokens.items[i].type == Comma) {
                    inc();
                    EXPECT_REG("Expected %d-bit register, got %s", register_size);
                    r2 = parse_reg(tokens.items[i].value, REG_SRC1);
                } else {
                    i--;
                }
                ins.type_data_alur.r1 = r1;
                ins.type_data_alur.r2 = r2;
            } else if (eq(mnemonic, "zeroupper")) {
                ins.generic.type = MODE_OTHER;
                ins.type_other_zeroupper.op = OP_OTHER_zeroupper;
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r1 = parse_reg(tokens.items[i].value, REG_DEST);
                if (register_size == 64) {
                    EXPECT(Eof, "Expected register of at most 32 bits, got %s");
                }
                ins.type_other_zeroupper.r1 = r1;
            } else if (eq(mnemonic, "swe")) {
                ins.generic.type = MODE_DATA;
                ins.type_data.data_op = SUBOP_DATA_ALU_R;
                ins.type_data_alur.op = OP_DATA_ALU_swe;
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r1 = parse_reg(tokens.items[i].value, REG_DEST, REG_SRC1);
                uint8_t r2 = r1;
                inc();
                if (tokens.items[i].type == Comma) {
                    inc();
                    EXPECT_REG("Expected %d-bit register, got %s", register_size);
                    r2 = parse_reg(tokens.items[i].value, REG_SRC1);
                } else {
                    i--;
                }
                ins.type_data_alur.r1 = r1;
                ins.type_data_alur.r2 = r2;
                if (register_size == 8) {
                    EXPECT(Eof, "Expected register of at least 16 bits, got %s");
                }
            } else if (eq(mnemonic, "xchg")) {
                ins.generic.type = MODE_DATA;
                ins.type_data_xchg.data_op = SUBOP_DATA_XCHG;
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r1 = parse_reg(tokens.items[i].value, REG_DEST);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r2 = parse_reg(tokens.items[i].value, REG_SRC1);
                ins.type_data_xchg.r1 = r1;
                ins.type_data_xchg.r2 = r2;
            } else if (eq(mnemonic, "cswp")) {
                ins.generic.type = MODE_DATA;
                ins.type_data_cswap.data_op = SUBOP_DATA_CSWAP;
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r1 = parse_reg(tokens.items[i].value, REG_DEST);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r2 = parse_reg(tokens.items[i].value, REG_SRC1);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r3 = parse_reg(tokens.items[i].value, REG_SRC2);
                ins.type_data_cswap.r1 = r1;
                ins.type_data_cswap.r2 = r2;
                ins.type_data_cswap.r3 = r3;
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                EXPECT(Identifier, "Expected identifier, got %s");
                ins.type_data_cswap.cond = parse_condition(tokens.items[i].value);
            } else if (eq(mnemonic, "ldr")) {
                LDR()
            } else if (eq(mnemonic, "str")) {
                STR()
            } else if (eq(mnemonic, "psh")) {
                ins.generic.type = MODE_DATA;
                inc();
                if (tokens.items[i].type >= Register8 && tokens.items[i].type <= Register64) {
                    EXPECT_REG("Expected %d-bit register or vector register, got %s", register_size);
                    uint8_t reg = parse_reg(tokens.items[i].value, REG_DEST);
                    ins.type_data_ls_imm.data_op = SUBOP_DATA_LS;
                    ins.type_data_ls_imm.is_store = 1;
                    ins.type_data_ls_imm.r1 = reg;
                    ins.type_data_ls_imm.r2 = REG_SP;
                    ins.type_data_ls_imm.imm = -16;
                    ins.type_data_ls_imm.update_ptr = 1;
                    ins.type_data_ls_imm.use_immediate = 1;
                } else if (tokens.items[i].type == VecRegister) {
                    ins.type_data_vpu_ls_imm.data_op = SUBOP_DATA_VPU;
                    uint8_t reg = parse_vreg(tokens.items[i].value);
                    ins.type_data_vpu_ls_imm.r1 = REG_SP;
                    ins.type_data_vpu_ls_imm.v1 = reg;
                    ins.type_data_vpu_ls_imm.imm = -32;
                    ins.type_data_vpu_ls_imm.update_ptr = 1;
                    ins.type_data_vpu_ls_imm.use_imm = 1;
                    ins.type_data_vpu_ls_imm.op = OP_DATA_VPU_str;
                } else {
                    EXPECT_REG("Expected %d-bit register or vector register, got %s", register_size);
                }
            } else if (eq(mnemonic, "pp")) {
                ins.generic.type = MODE_DATA;
                inc();
                if (tokens.items[i].type >= Register8 && tokens.items[i].type <= Register64) {
                    EXPECT_REG("Expected %d-bit register or vector register, got %s", register_size);
                    uint8_t reg = parse_reg(tokens.items[i].value, REG_DEST);
                    ins.type_data_ls_imm.data_op = SUBOP_DATA_LS;
                    ins.type_data_ls_imm.is_store = 0;
                    ins.type_data_ls_imm.r1 = reg;
                    ins.type_data_ls_imm.r2 = REG_SP;
                    ins.type_data_ls_imm.imm = 16;
                    ins.type_data_ls_imm.update_ptr = 1;
                    ins.type_data_ls_imm.use_immediate = 1;
                } else if (tokens.items[i].type == VecRegister) {
                    ins.type_data_vpu_ls_imm.data_op = SUBOP_DATA_VPU;
                    uint8_t reg = parse_vreg(tokens.items[i].value);
                    ins.type_data_vpu_ls_imm.r1 = REG_SP;
                    ins.type_data_vpu_ls_imm.v1 = reg;
                    ins.type_data_vpu_ls_imm.imm = 32;
                    ins.type_data_vpu_ls_imm.update_ptr = 1;
                    ins.type_data_vpu_ls_imm.use_imm = 1;
                    ins.type_data_vpu_ls_imm.op = OP_DATA_VPU_ldr;
                } else {
                    EXPECT_REG("Expected %d-bit register or vector register, got %s", register_size);
                }
            } else if (eq(mnemonic, "lea")) {
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t reg = parse_reg(tokens.items[i].value, REG_DEST);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                ins.generic.type = MODE_LOAD;
                ins.type_load_signed.op = OP_LOAD_lea;
                ins.type_load_signed.r1 = reg;
            } else if (eq(mnemonic, "movz") || eq(mnemonic, "movk")) {
                bool no_zero = eq(mnemonic, "movk");
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t reg = parse_reg(tokens.items[i].value, REG_DEST);
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
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r1 = parse_reg(tokens.items[i].value, REG_DEST);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                if (tokens.items[i].type == register_type) {
                    uint8_t r2 = parse_reg(tokens.items[i].value, REG_SRC1);
                    ins.generic.type = MODE_DATA;
                    ins.type_data.data_op = SUBOP_DATA_ALU_I;
                    ins.type_data_alui.op = OP_DATA_ALU_shl;
                    ins.type_data_alui.r1 = r1;
                    ins.type_data_alui.r2 = r2;
                    ins.type_data_alui.imm = 0;
                } else if (tokens.items[i].type == Number) {
                    uint64_t imm = parse64(tokens.items[i].value);
                    ins.generic.type = MODE_LOAD;
                    ins.type_load_mov.op = OP_LOAD_movzk;
                    ins.type_load_mov.no_zero = 0;
                    ins.type_load_mov.r1 = r1;
                    if ((imm & (0xFFFFULL << 0)) == imm) {
                        ins.type_load_mov.shift = 0;
                        ins.type_load_mov.imm = (imm >> 0) & 0xFFFF;
                    } else if ((imm & (0xFFFFULL << 16)) == imm) {
                        ins.type_load_mov.shift = 1;
                        ins.type_load_mov.imm = (imm >> 16) & 0xFFFF;
                    } else if ((imm & (0xFFFFULL << 32)) == imm) {
                        ins.type_load_mov.shift = 2;
                        ins.type_load_mov.imm = (imm >> 32) & 0xFFFF;
                    } else if ((imm & (0xFFFFULL << 48)) == imm) {
                        ins.type_load_mov.shift = 3;
                        ins.type_load_mov.imm = (imm >> 48) & 0xFFFF;
                    } else {
                        EXPECT(Eof, "Number out of range for mov: %s");
                    }
                } else {
                    EXPECT(Eof, "Expected %d-bit register or number, got %s", register_size);
                }
            } else if (eq(mnemonic, "inc") || eq(mnemonic, "dec")) {
                uint8_t inc = eq(mnemonic, "inc");
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r1 = parse_reg(tokens.items[i].value, REG_DEST, REG_SRC1);
                uint8_t r2 = r1;
                if (tokens.items[i + 1].type == Comma) {
                    inc();
                    EXPECT(Comma, "Expected comma, got %s");
                    inc();
                    EXPECT_REG("Expected %d-bit register, got %s", register_size);
                    r2 = parse_reg(tokens.items[i].value, REG_SRC1);
                }
                ins.generic.type = MODE_DATA;
                ins.type_data.data_op = SUBOP_DATA_ALU_I;
                ins.type_data_alui.op = inc ? OP_DATA_ALU_add : OP_DATA_ALU_sub;
                ins.type_data_alui.r1 = r1;
                ins.type_data_alui.r2 = r2;
                ins.type_data_alui.imm = 1;
            } else if (strncmp(mnemonic, "ext", 3) == 0) {
                uint8_t sizes[] = {
                    ['b'] = SIZE_8BIT,
                    ['w'] = SIZE_16BIT,
                    ['d'] = SIZE_32BIT,
                    ['q'] = SIZE_64BIT,
                };
                if (strlen(mnemonic) != 5) {
                    EXPECT(Eof, "Illegal sign extend: %s");
                }
                uint8_t from = sizes[mnemonic[3]];
                uint8_t to = sizes[mnemonic[4]];

                if (to <= from) {
                    EXPECT(Eof, "Illegal sign extend: %s");
                }

                ins.type_data_sext.from = from;
                ins.type_data_sext.to = to;
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r1 = parse_reg(tokens.items[i].value, REG_DEST, REG_SRC1);
                uint8_t r2 = r1;
                if (tokens.items[i + 1].type == Comma) {
                    inc();
                    EXPECT(Comma, "Expected comma, got %s");
                    inc();
                    EXPECT_REG("Expected %d-bit register, got %s", register_size);
                    r2 = parse_reg(tokens.items[i].value, REG_SRC1);
                }
                ins.generic.type = MODE_DATA;
                ins.type_data_sext.data_op = SUBOP_DATA_ALU_I;
                ins.type_data_sext.op = OP_DATA_ALU_sext;
                ins.type_data_sext.r1 = r1;
                ins.type_data_sext.r2 = r2;
            } else if (eq(mnemonic, "tst")) {
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r1 = parse_reg(tokens.items[i].value, REG_SRC1);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                if (tokens.items[i].type == register_type) {
                    uint8_t r2 = parse_reg(tokens.items[i].value, REG_SRC2);
                    ins.generic.type = MODE_DATA;
                    ins.type_data.data_op = SUBOP_DATA_ALU_R;
                    ins.type_data_alur.op = OP_DATA_ALU_and;
                    ins.type_data_alur.r2 = r1;
                    ins.type_data_alur.r3 = r2;
                    ins.type_data_alur.no_writeback = 1;
                } else if (tokens.items[i].type == Number) {
                    uint8_t num = parse8(tokens.items[i].value);
                    ins.generic.type = MODE_DATA;
                    ins.type_data.data_op = SUBOP_DATA_ALU_I;
                    ins.type_data_alui.op = OP_DATA_ALU_and;
                    ins.type_data_alui.r2 = r1;
                    ins.type_data_alui.imm = num;
                    ins.type_data_alui.no_writeback = 1;
                } else {
                    EXPECT(Eof, "Expected %d-bit register or number, got %s", register_size);
                }
            } else if (eq(mnemonic, "cmp")) {
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r1 = parse_reg(tokens.items[i].value, REG_SRC1);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                if (tokens.items[i].type == register_type) {
                    uint8_t r2 = parse_reg(tokens.items[i].value, REG_SRC2);
                    ins.generic.type = MODE_DATA;
                    ins.type_data.data_op = SUBOP_DATA_ALU_R;
                    ins.type_data_alur.op = OP_DATA_ALU_sub;
                    ins.type_data_alur.r2 = r1;
                    ins.type_data_alur.r3 = r2;
                    ins.type_data_alur.no_writeback = 1;
                } else if (tokens.items[i].type == Number) {
                    uint32_t num = parse32(tokens.items[i].value);
                    ins.generic.type = MODE_DATA;
                    ins.type_data.data_op = SUBOP_DATA_ALU_I;
                    ins.type_data_alui.op = OP_DATA_ALU_sub;
                    ins.type_data_alui.r2 = r1;
                    ins.type_data_alui.imm = num;
                    ins.type_data_alui.no_writeback = 1;
                } else {
                    EXPECT(Eof, "Expected %d-bit register or number, got %s", register_size);
                }
            } else if (eq(mnemonic, "sbxt") || eq(mnemonic, "ubxt")) {
                ins.generic.type = MODE_DATA;
                ins.type_data_bit.extend = (mnemonic[0] == 's');
                ins.type_data_bit.data_op = SUBOP_DATA_BEXT >> 1;
                ins.type_data_bit.is_dep = 0;

                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r1 = parse_reg(tokens.items[i].value, REG_DEST);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r2 = parse_reg(tokens.items[i].value, REG_SRC1);
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
                ins.type_data_bit.data_op = SUBOP_DATA_BDEP >> 1;
                ins.type_data_bit.is_dep = 1;

                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r1 = parse_reg(tokens.items[i].value, REG_DEST);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r2 = parse_reg(tokens.items[i].value, REG_SRC1);
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
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r1 = parse_reg(tokens.items[i].value, REG_DEST);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r2 = parse_reg(tokens.items[i].value, REG_SRC1);
                ins.generic.type = MODE_DATA;
                ins.type_data_fpu.data_op = SUBOP_DATA_FPU;
                ins.type_data_fpu.op = OP_DATA_FLOAT_f2i;
                ins.type_data_fpu.use_int_arg2 = i2f;
                ins.type_data_fpu.r1 = r1;
                ins.type_data_fpu.r2 = r2;
            } else if (eq(mnemonic, "f2s") || eq(mnemonic, "s2f")) {
                uint8_t f2s = eq(mnemonic, "f2s");
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r1 = parse_reg(tokens.items[i].value, REG_DEST);
                inc();
                EXPECT(Comma, "Expected comma, got %s");
                inc();
                EXPECT_REG("Expected %d-bit register, got %s", register_size);
                uint8_t r2 = parse_reg(tokens.items[i].value, REG_SRC1);
                ins.generic.type = MODE_DATA;
                ins.type_data_fpu.data_op = SUBOP_DATA_FPU;
                ins.type_data_fpu.op = OP_DATA_FLOAT_s2f;
                ins.type_data_fpu.is_single_op = f2s;
                ins.type_data_fpu.r1 = r1;
                ins.type_data_fpu.r2 = r2;
            } else if (mnemonic[0] == 'f' || mnemonic[0] == 's') {
                mnemonic++;
                ins.generic.type = MODE_DATA;
                ins.type_data_fpu.is_single_op = (mnemonic[0] == 's');
                ins.type_data_fpu.data_op = SUBOP_DATA_FPU;
                if (eq(mnemonic, "sin") || eq(mnemonic, "sqrt")) {
                    uint8_t sin = eq(mnemonic, "sin");
                    inc();
                    EXPECT_REG("Expected %d-bit register, got %s", register_size);
                    uint8_t r1 = parse_reg(tokens.items[i].value, REG_DEST);
                    inc();
                    EXPECT(Comma, "Expected comma, got %s");
                    inc();
                    EXPECT_REG("Expected %d-bit register, got %s", register_size);
                    uint8_t r2 = parse_reg(tokens.items[i].value, REG_SRC1);
                    ins.type_data_fpu.op = sin ? OP_DATA_FLOAT_sin : OP_DATA_FLOAT_sqrt;
                    ins.type_data_fpu.r1 = r1;
                    ins.type_data_fpu.r2 = r2;
                } else if (eq(mnemonic, "cmp") || eq(mnemonic, "cmpi")) {
                    uint8_t fcmp = eq(mnemonic, "cmp");
                    inc();
                    EXPECT_REG("Expected %d-bit register, got %s", register_size);
                    uint8_t r1 = parse_reg(tokens.items[i].value, REG_SRC1);
                    inc();
                    EXPECT(Comma, "Expected comma, got %s");
                    inc();
                    EXPECT_REG("Expected %d-bit register, got %s", register_size);
                    uint8_t r2 = parse_reg(tokens.items[i].value, REG_SRC2);
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
                ins.type_data_vpu.data_op = SUBOP_DATA_VPU;
                mnemonic++;
                if (eq(mnemonic, "ldr") || eq(mnemonic, "str")) {
                    if (eq(mnemonic, "ldr")) {
                        inc();
                        EXPECT(VecRegister, "Expected vector register, got %s");
                        uint8_t v1 = parse_vreg(tokens.items[i].value);
                        inc();
                        EXPECT(Comma, "Expected comma, got %s");
                        inc();
                        EXPECT(LeftBracket, "Expected '[', got %s");
                        inc();
                        EXPECT_REG("Expected %d-bit register, got %s", register_size);
                        uint8_t r1 = parse_reg(tokens.items[i].value, REG_SRC1);
                        inc();
                        ins.generic.type = MODE_DATA;
                        ins.type_data_vpu.data_op = SUBOP_DATA_VPU;
                        ins.type_data_vpu_ls.op = OP_DATA_VPU_ldr;
                        if (tokens.items[i].type == RightBracket) {
                            ins.type_data_vpu_ls_imm.v1 = v1;
                            ins.type_data_vpu_ls_imm.r1 = r1;
                            ins.type_data_vpu_ls_imm.imm = 0;
                            ins.type_data_vpu_ls_imm.use_imm = 1;
                            if (tokens.items[i + 1].type == Bang) {
                                inc();
                                ins.type_data_vpu_ls_imm.update_ptr = 1;
                            }
                        } else if (tokens.items[i].type == Comma) {
                            inc();
                            if (tokens.items[i].type == register_type) {
                                ins.type_data_vpu_ls.v1 = v1;
                                ins.type_data_vpu_ls.r1 = r1;
                                ins.type_data_vpu_ls.r2 = parse_reg(tokens.items[i].value, REG_SRC2);
                            } else if (tokens.items[i].type == Number) {
                                ins.type_data_vpu_ls_imm.v1 = v1;
                                ins.type_data_vpu_ls_imm.r1 = r1;
                                int16_t num = parse16(tokens.items[i].value);
                                if (num < 128 && num >= -128) {
                                    ins.type_data_vpu_ls_imm.use_imm = 1;
                                    ins.type_data_vpu_ls_imm.imm = num;
                                } else {
                                    EXPECT(Eof, "Number out of range: %s");
                                }
                            } else {
                                EXPECT(Eof, "Expected %d-bit register or number, got %s", register_size);
                            }
                            inc();
                            EXPECT(RightBracket, "Expected ']', got %s");
                            if (tokens.items[i + 1].type == Bang) {
                                inc();
                                ins.type_data_vpu_ls_imm.update_ptr = 1;
                            }
                        } else {
                            EXPECT(Eof, "Expected comma or ']', got %s");
                        }
                    } else {
                        inc();
                        EXPECT(VecRegister, "Expected vector register, got %s");
                        uint8_t v1 = parse_vreg(tokens.items[i].value);
                        inc();
                        EXPECT(Comma, "Expected comma, got %s");
                        inc();
                        EXPECT(LeftBracket, "Expected '[', got %s");
                        inc();
                        EXPECT_REG("Expected %d-bit register, got %s", register_size);
                        uint8_t r1 = parse_reg(tokens.items[i].value, REG_SRC1);
                        inc();
                        ins.generic.type = MODE_DATA;
                        ins.type_data_vpu.data_op = SUBOP_DATA_VPU;
                        ins.type_data_vpu_ls.op = OP_DATA_VPU_str;
                        if (tokens.items[i].type == RightBracket) {
                            ins.type_data_vpu_ls_imm.v1 = v1;
                            ins.type_data_vpu_ls_imm.r1 = r1;
                            ins.type_data_vpu_ls_imm.imm = 0;
                            ins.type_data_vpu_ls_imm.use_imm = 1;
                            if (tokens.items[i + 1].type == Bang) {
                                inc();
                                ins.type_data_vpu_ls_imm.update_ptr = 1;
                            }
                        } else if (tokens.items[i].type == Comma) {
                            inc();
                            if (tokens.items[i].type == register_type) {
                                ins.type_data_vpu_ls.v1 = v1;
                                ins.type_data_vpu_ls.r1 = r1;
                                ins.type_data_vpu_ls.r2 = parse_reg(tokens.items[i].value, REG_SRC2);
                            } else if (tokens.items[i].type == Number) {
                                ins.type_data_vpu_ls_imm.v1 = v1;
                                ins.type_data_vpu_ls_imm.r1 = r1;
                                int16_t num = parse16(tokens.items[i].value);
                                if (num < 128 && num >= -128) {
                                    ins.type_data_vpu_ls_imm.use_imm = 1;
                                    ins.type_data_vpu_ls_imm.imm = num;
                                } else {
                                    EXPECT(Eof, "Number out of range: %s");
                                }
                            } else {
                                EXPECT(Eof, "Expected %d-bit register or number, got %s", register_size);
                            }
                            inc();
                            EXPECT(RightBracket, "Expected ']', got %s");
                            if (tokens.items[i + 1].type == Bang) {
                                inc();
                                ins.type_data_vpu_ls_imm.update_ptr = 1;
                            }
                        } else {
                            EXPECT(Eof, "Expected comma or ']', got %s");
                        }
                    }
                } else {

                    uint8_t mode = modes[mnemonic[0]];
                    ins.type_data_vpu.mode = mode;
                    mnemonic++;
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
                        } else if (tokens.items[i].type >= Register8 && tokens.items[i].type <= Register64) {
                            ins.type_data_vpu_mov.op = OP_DATA_VPU_mov;
                            EXPECT_REG("Epxected %d-bit register, got %s", register_size);
                            uint8_t r2 = parse_reg(tokens.items[i].value, REG_SRC1);
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
                            EXPECT(Eof, "Expected %d-bit register or vector register, got %s", register_size);
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
                        EXPECT_REG("Expected %d-bit register, got %s", register_size);
                        uint8_t r1 = parse_reg(tokens.items[i].value, REG_DEST);
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
                }
            } else {
                EXPECT(Eof, "Unknown opcode: %s");
            }

            if (prefix.generic.condition != COND_NEVER) {
                nob_da_append_many(&current_section, &prefix, sizeof(prefix));
            }
            if (ins.generic.condition != COND_NEVER) {
                if (ins.generic.type == MODE_BRANCH && !ins.type_branch.is_reg) {
                    inc();
                    EXPECT(Identifier, "Expected identifier, got %s");
                    char* str = tokens.items[i].value;
                    str = unquote(str);
                    if (last_global_symbol && str[0] == '$') {
                        str = strformat("%s%s", last_global_symbol, str);
                    }
                    Relocation off = {
                        .data.name = str,
                        .source_offset = current_section.count,
                        .source_section = sects.count,
                        .type = sym_branch
                    }; 
                    nob_da_append(relocations, off);
                } else if (ins.generic.type == MODE_LOAD && ins.type_load_signed.op == OP_LOAD_lea) {
                    inc();
                    EXPECT(Identifier, "Expected identifier, got %s");
                    char* str = tokens.items[i].value;
                    str = unquote(str);
                    if (last_global_symbol && str[0] == '$') {
                        str = strformat("%s%s", last_global_symbol, str);
                    }
                    Relocation off = {
                        .data.name = str,
                        .source_offset = current_section.count,
                        .source_section = sects.count,
                        .type = sym_load
                    }; 
                    nob_da_append(relocations, off);
                }
            }
            nob_da_append_many(&current_section, &ins, sizeof(ins));
            for (size_t k = 0; k < additional_ops.count; k++) {
                nob_da_append_many(&current_section, &additional_ops.items[k], sizeof(additional_ops.items[k]));
            }
        } else if (tokens.items[i].type == Directive) {
            if (eq(tokens.items[i].value, "asciz") || eq(tokens.items[i].value, "ascii")) {
                inc();
                EXPECT(String, "Expected string, got %s");
                char* str = tokens.items[i].value;
                str = unquote(str);
                nob_sb_append_cstr(&current_section, str);
                if (eq(tokens.items[i - 1].value, "asciz")) {
                    nob_sb_append_null(&current_section);
                }
                while (current_section.count % 4) {
                    nob_sb_append_null(&current_section);
                }
            } else if (eq(tokens.items[i].value, "text")) {
                last_global_symbol = NULL;
                if (current_sect_type != SECT_TYPE_NOEMIT) {
                    CompilerSection s = {
                        .data = current_section,
                        .type = current_sect_type,
                    };
                    nob_da_append(&sects, s);
                }
                current_section = (Nob_String_Builder) {0};
                current_sect_type = SECT_TYPE_TEXT;
            } else if (eq(tokens.items[i].value, "data")) {
                last_global_symbol = NULL;
                if (current_sect_type != SECT_TYPE_NOEMIT) {
                    CompilerSection s = {
                        .data = current_section,
                        .type = current_sect_type,
                    };
                    nob_da_append(&sects, s);
                }
                current_section = (Nob_String_Builder) {0};
                current_sect_type = SECT_TYPE_DATA;
            } else if (eq(tokens.items[i].value, "bss")) {
                last_global_symbol = NULL;
                if (current_sect_type != SECT_TYPE_NOEMIT) {
                    CompilerSection s = {
                        .data = current_section,
                        .type = current_sect_type,
                    };
                    nob_da_append(&sects, s);
                }
                current_section = (Nob_String_Builder) {0};
                current_sect_type = SECT_TYPE_BSS;
            } else if (eq(tokens.items[i].value, "byte")) {
                inc();
                EXPECT(Number, "Expected number, got %s");
                uint8_t num = parse8(tokens.items[i].value);
                nob_da_append_many(&current_section, &num, 1);
            } else if (eq(tokens.items[i].value, "word")) {
                inc();
                EXPECT(Number, "Expected number, got %s");
                uint16_t num = parse16(tokens.items[i].value);
                nob_da_append_many(&current_section, &num, 2);
            } else if (eq(tokens.items[i].value, "dword")) {
                inc();
                EXPECT(Number, "Expected number, got %s");
                uint32_t num = parse32(tokens.items[i].value);
                nob_da_append_many(&current_section, &num, 4);
            } else if (eq(tokens.items[i].value, "qword")) {
                inc();
                if (tokens.items[i].type == Number) {
                    uint64_t num = parse64(tokens.items[i].value);
                    nob_da_append_many(&current_section, &num, 8);
                } else if (tokens.items[i].type == Identifier) {
                    char* str = tokens.items[i].value;
                    str = unquote(str);
                    if (last_global_symbol && str[0] == '$') {
                        str = strformat("%s%s", last_global_symbol, str);
                    }
                    Relocation off = {
                        .data.name = str,
                        .source_offset = current_section.count,
                        .source_section = sects.count,
                        .type = sym_abs
                    }; 
                    nob_da_append(relocations, off);
                    nob_da_append_many(&current_section, &(off.source_offset), 8);
                } else {
                    EXPECT(Eof, "Expected number or identifier, got %s");
                }
            } else if (eq(tokens.items[i].value, "float")) {
                inc();
                EXPECT(NumberFloat, "Expected float, got %s");;
                float num = atof(tokens.items[i].value);
                nob_da_append_many(&current_section, &num, 4);
            } else if (eq(tokens.items[i].value, "double")) {
                inc();
                EXPECT(NumberFloat, "Expected float, got %s");;
                double num = atof(tokens.items[i].value);
                nob_da_append_many(&current_section, &num, 8);
            } else if (eq(tokens.items[i].value, "offset")) {
                inc();
                EXPECT(Identifier, "Expected identifier, got %s");
                char* str = tokens.items[i].value;
                str = unquote(str);
                if (last_global_symbol && str[0] == '$') {
                    str = strformat("%s%s", last_global_symbol, str);
                }
                Relocation off = {
                    .data.name = str,
                    .source_offset = current_section.count,
                    .source_section = sects.count,
                    .type = sym_abs
                }; 
                nob_da_append(relocations, off);
                nob_da_append_many(&current_section, &(off.source_offset), 8);
            } else if (eq(tokens.items[i].value, "zerofill")) {
                inc();
                EXPECT(Number, "Expected number, got %s");
                uint64_t size = parse64(tokens.items[i].value);
                if (size % 4) {
                    size += (4 - (size % 4));
                }
                while (size > 0) {
                    if (size >= 8) {
                        nob_da_append_many(&current_section, &(uint64_t){0}, 8);
                        size -= 8;
                    } else if (size >= 4) {
                        nob_da_append_many(&current_section, &(uint32_t){0}, 4);
                        size -= 4;
                    } else if (size >= 2) {
                        nob_da_append_many(&current_section, &(uint16_t){0}, 2);
                        size -= 2;
                    } else if (size >= 1) {
                        nob_da_append_many(&current_section, &(uint8_t){0}, 1);
                        size -= 1;
                    } else {
                        break;
                    }
                }
            } else if (eq(tokens.items[i].value, "global") || eq(tokens.items[i].value, "globl")) {
                inc();
                EXPECT(Identifier, "Expected identifier, got %s");
                last_global_symbol = tokens.items[i].value;
                nob_da_append(&exported_symbols, tokens.items[i].value);
            } else {
                EXPECT(Eof, "Unknown directive: %s");
            }
        } else if (tokens.items[i].type == Label) {
            char* str = tokens.items[i].value;
            str = unquote(str);
            if (last_global_symbol && str[0] == '$') {
                str = strformat("%s%s", last_global_symbol, str);
            }
            Symbol off = {
                .name = str,
                .offset = current_section.count,
                .section = sects.count,
            };
            nob_da_append(syms, off);
        }
    }

    if (errors.count) {
        for (size_t i = 0; i < errors.count; i++) {
            fprintf(stderr, "%s", errors.items[i]);
        }
        return (SB_Array) {0};
    }

    if (current_sect_type != SECT_TYPE_NOEMIT) {
        CompilerSection s = {
            .data = current_section,
            .type = current_sect_type
        };
        nob_da_append(&sects, s);
    }

    Relocation_Array extern_relocs = {0};

    for (size_t i = 0; i < syms->count; i++) {
        for (size_t j = 0; j < exported_symbols.count; j++) {
            if (eq(syms->items[i].name, exported_symbols.items[j])) {
                syms->items[i].flags |= sf_exported;
                break;
            }
        }
    }

    for (size_t i = 0; i < relocations->count; i++) {
        Relocation reloc = relocations->items[i];
        uint64_t current_address = reloc.source_offset;
        Symbol target = find_symbol(*syms, reloc.data.name);
        uint64_t target_address = target.offset;

        if (target_address == -1 || reloc.source_section != target.section) {
            if (reloc.source_section != target.section) {
                reloc.is_local = 1;
                reloc.data.local.target_section = target.section;
                reloc.data.local.target_offset = target.offset;
            }
            nob_da_append(&extern_relocs, reloc);
            continue;
        }

        Nob_String_Builder sect = sects.items[reloc.source_section].data;

        #define POW2(_n) (1 << _n)
        #define check_align() \
            if (diff % 4) { \
                fprintf(stderr, "Relative target not aligned: %x\n", diff); \
                exit(1); \
            }
        #define relative_check(_dist) \
            if (diff >= _dist || diff < -_dist) { \
                fprintf(stderr, "Relative address too far: %d > %d (%llx -> %llx)\n", diff, _dist, (QWord_t) &sect.items[current_address], target_address); \
                exit(1); \
            }

        switch (reloc.type) {
            case sym_abs:
                *((QWord_t*) &sect.items[current_address]) = target_address;
                nob_da_append(&extern_relocs, reloc);
                break;
            case sym_branch: {
                    hive_instruction_t* s = ((hive_instruction_t*) &sect.items[current_address]);
                    int32_t diff = target_address - (current_address);
                    check_align();
                    diff /= sizeof(hive_instruction_t);
                    relative_check(POW2(24));
                    s->type_branch_generic.offset = diff;
                }
                break;
            case sym_load: {
                    hive_instruction_t* s = ((hive_instruction_t*) &sect.items[current_address]);
                    int32_t diff = target_address - (current_address);
                    check_align();
                    diff /= sizeof(hive_instruction_t);
                    relative_check(POW2(19));
                    s->type_load_signed.imm = diff;
                }
                break;
            case sym_ls_off: {
                    hive_instruction_t* s = ((hive_instruction_t*) &sect.items[current_address]);
                    int32_t diff = target_address - (current_address);
                    check_align();
                    diff /= sizeof(hive_instruction_t);
                    relative_check(POW2(18));
                    s->type_load_ls_off.imm = diff;
                }
                break;
        }
    }
    *relocations = extern_relocs;

    return sects;
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
static int line;

Token_Array parse(char* data, int l) {
    Token_Array tokens = {0};
    src = data;
    line = l;
    while (*src) {
        Token t = nextToken();
        if (t.type == Eof) break;
        nob_da_append(&tokens, t);
    }
    nob_da_append(&tokens, (Token) {.type = Eof});
    return tokens;
}

Token nextToken(void) {
    while (*src == ' ' || *src == '\n' || *src == '\r' || *src == '\t') {
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
        if (*s == 'r' || *s == 'b' || *s == 'w' || *s == 'd' || *s == 'q') {
            TokenType type[] = {
                ['b'] = Register8,
                ['w'] = Register16,
                ['d'] = Register32,
                ['q'] = Register64,
                ['r'] = Register64,
            };
            src++;
            if (isnumber(*src)) {
                while (isnumber(*src))
                    src++;

                if (*src == 'l' || *src == 'h') {
                    if (type[*s] == Register64 && *src == 'h') {
                        s[src - start + 1] = 0;
                        nob_da_append(&errors, strformat("%s:%d: Unsupported addressing form: %s\n", file, line, s));
                    }
                    src++;
                }

                s[src - start] = 0;
                return (Token) {
                    .file = file,
                    .line = line,
                    .value = s,
                    .type = type[*s]
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
        } else if (s[0] == 'c' && s[1] == 'r') {
            src += 2;
            if (isnumber(*src)) {
                while (isnumber(*src))
                    src++;

                if (*src == 'l' || *src == 'h') {
                    src++;
                }

                s[src - start] = 0;
                return (Token) {
                    .file = file,
                    .line = line,
                    .value = s,
                    .type = Register64
                };

            }
            src -= 2;
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
                    .type = Register64
                };
            } else {
                return (Token) {
                    .file = file,
                    .line = line,
                    .value = "y",
                    .type = Register64
                };
            }
        } else if (eq(s, "pc")) {
            return (Token) {
                .file = file,
                .line = line,
                .value = "pc",
                .type = Register64
            };
        } else if (eq(s, "lr")) {
            return (Token) {
                .file = file,
                .line = line,
                .value = "lr",
                .type = Register64
            };
        } else if (eq(s, "sp")) {
            return (Token) {
                .file = file,
                .line = line,
                .value = "sp",
                .type = Register64
            };
        } else if (eq(s, "fr")) {
            return (Token) {
                .file = file,
                .line = line,
                .value = "fr",
                .type = Register64
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
                    nob_da_append(&errors, strformat("Unknown escape sequence: \\%c\n", s[1]));
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
