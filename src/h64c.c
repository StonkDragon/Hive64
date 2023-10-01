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
} TokenType;

typedef struct _Token {
    char* value;
    TokenType type;
    char* file;
    int line;
} Token;

section_t** compile(Token* tokens);
Token* parse(char* src);

static char* file;

section_t** run_compile(const char* file_name) {
    file = malloc(strlen(file_name) + 1);
    strcpy(file, file_name);

    FILE* file = fopen(file_name, "r");
    if (!file) {
        printf("Could not open file: %s\n", file_name);
        return NULL;
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
            return NULL;
        }
        if ((src[i] == ';' || src[i] == '#' || src[i] == '@') && !inside_string) {
            while (src[i] != '\n' && i < size) {
                src[i] = ' ';
                i++;
            }
        }
    }

    Token* tokens = parse(src);
    
    section_t** obj = compile(tokens);

    return obj;
}

int isValidBegin(int c) {
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_';
}

int isValid(int c) {
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_' || c == '.' || c == '$' || c == '{' || c == '}' || c == '(' || c == ')';
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
#define ins(s) eq(tokens->value, (s))

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

section_t** compile(Token* tokens) {
    uint32_t section_count = 1;
    section_t** objs = NULL;
    objs = realloc(objs, sizeof(section_t*) * section_count);
    section_t* obj = malloc(sizeof(section_t));
    objs[section_count - 1] = obj;
    obj->type = SECTION_TYPE_CODE;
    for (;tokens->type != EOF; tokens++) {
        if (tokens->type == Identifier) {
            if (ins("nop")) {
                instruction_t instr = (instruction_t) {
                    .opcode = op_nop
                };
                add_instruction(obj, instr);
            } else if (ins("halt") || ins("hlt")) {
                instruction_t instr = (instruction_t) {
                    .opcode = op_halt
                };
                add_instruction(obj, instr);
            } else if (ins("ldr")) {
                tokens++;
                if (tokens->type != Register) {
                    printf("%s:%d: Expected register, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                uint8_t reg1 = parse8(tokens->value + 1);
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg2 = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_ldr_reg_reg,
                        .args = {
                            ARG_8BIT(reg1),
                            ARG_8BIT(reg2),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Number) {
                    int64_t num = parse64(tokens->value);
                    if (num > 32767 || num < -32768) {
                        instruction_t instr = (instruction_t) {
                            .opcode = op_ldr_reg_imm,
                            .args = {
                                ARG_64BIT(num),
                                ARG_8BIT(reg1),
                            }
                        };
                        add_instruction(obj, instr);
                    } else {
                        int16_t num16 = num;
                        instruction_t instr = (instruction_t) {
                            .opcode = op_ldr_reg_imm16,
                            .args = {
                                ARG_16BIT(num16),
                                ARG_8BIT(reg1),
                            }
                        };
                        add_instruction(obj, instr);
                    }
                } else if (tokens->type == Identifier) {
                    char* str = tokens->value;
                    str = unquote(str);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_ldr_reg_imm,
                        .args = {
                            ARG_64SYM(str),
                            ARG_8BIT(reg1),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == LeftBracket) {
                    tokens++;
                    if (tokens->type == Register) {
                        uint8_t reg2 = parse8(tokens->value + 1);
                        tokens++;
                        if (tokens->type == RightBracket) {
                            instruction_t instr = (instruction_t) {
                                .opcode = op_ldr_reg_mem,
                                .args = {
                                    ARG_8BIT(reg1),
                                    ARG_8BIT(reg2),
                                    ARG_16BIT(0),
                                }
                            };
                            add_instruction(obj, instr);
                        } else if (tokens->type == Number) {
                            int64_t num = parse64(tokens->value);
                            int16_t num16 = num;
                            if (num > 32767 || num < -32768) {
                                printf("%s:%d: Number too large\n", tokens->file, tokens->line);
                                return NULL;
                            } else {
                                instruction_t instr = (instruction_t) {
                                    .opcode = op_ldr_reg_mem,
                                    .args = {
                                        ARG_8BIT(reg1),
                                        ARG_8BIT(reg2),
                                        ARG_16BIT(num16),
                                    }
                                };
                                add_instruction(obj, instr);
                            }
                        } else {
                            printf("%s:%d: Expected register, number, or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                            return NULL;
                        }
                    } else if (tokens->type == Identifier) {
                        char* str = tokens->value;
                        str = unquote(str);
                        tokens++;
                        if (tokens->type == Register) {
                            uint8_t reg2 = parse8(tokens->value + 1);
                            tokens++;
                            if (tokens->type != RightBracket) {
                                printf("%s:%d: Expected ], got %s\n", tokens->file, tokens->line, tokens->value);
                                return NULL;
                            }
                            instruction_t instr = (instruction_t) {
                                .opcode = op_ldr_reg_addr_reg,
                                .args = {
                                    ARG_64SYM(str),
                                    ARG_8BIT(reg1),
                                    ARG_8BIT(reg2),
                                }
                            };
                        } else if (tokens->type == Number) {
                            int64_t num = parse64(tokens->value);
                            if (num > 32767 || num < -32768) {
                                printf("%s:%d: Number too large\n", tokens->file, tokens->line);
                                return NULL;
                            } else {
                                tokens++;
                                if (tokens->type != RightBracket) {
                                    printf("%s:%d: Expected ], got %s\n", tokens->file, tokens->line, tokens->value);
                                    return NULL;
                                }
                                int16_t num16 = num;
                                instruction_t instr = (instruction_t) {
                                    .opcode = op_ldr_reg_addr_imm16,
                                    .args = {
                                        ARG_64SYM(str),
                                        ARG_8BIT(reg1),
                                        ARG_16BIT(num16),
                                    }
                                };
                                add_instruction(obj, instr);
                            }
                        } else if (tokens->type == RightBracket) {
                            instruction_t instr = (instruction_t) {
                                .opcode = op_ldr_reg_addr_imm16,
                                .args = {
                                    ARG_64SYM(str),
                                    ARG_8BIT(reg1),
                                    ARG_16BIT(0),
                                }
                            };
                            add_instruction(obj, instr);
                        } else {
                            printf("%s:%d: Expected register, got %s\n", tokens->file, tokens->line, tokens->value);
                            return NULL;
                        }
                    } else {
                        printf("%s:%d: Expected register, got %s\n", tokens->file, tokens->line, tokens->value);
                        return NULL;
                    }
                } else {
                    printf("%s:%d: Expected register, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("str")) {
                tokens++;
                if (tokens->type != Register) {
                    printf("%s:%d: Expected register, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                uint8_t reg1 = parse8(tokens->value + 1);
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg2 = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_str_reg_reg,
                        .args = {
                            ARG_8BIT(reg1),
                            ARG_8BIT(reg2)
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Number) {
                    int64_t num = parse64(tokens->value);
                    int16_t num16 = num;
                    if (num > 32767 || num < -32768) {
                        instruction_t instr = (instruction_t) {
                            .opcode = op_str_reg_imm64,
                            .args = {
                                ARG_64BIT(num),
                                ARG_8BIT(reg1),
                            }
                        };
                        add_instruction(obj, instr);
                    } else {
                        instruction_t instr = (instruction_t) {
                            .opcode = op_str_reg_imm16,
                            .args = {
                                ARG_16BIT(num16),
                                ARG_8BIT(reg1),
                            }
                        };
                        add_instruction(obj, instr);
                    }
                } else {
                    printf("%s:%d: Expected register or number, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("cmp")) {
                tokens++;
                if (tokens->type != Register) {
                    printf("%s:%d: Expected register, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                uint8_t reg1 = parse8(tokens->value + 1);
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg2 = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_cmp_reg_reg,
                        .args = {
                            ARG_8BIT(reg1),
                            ARG_8BIT(reg2),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Number) {
                    int64_t num = parse64(tokens->value);
                    int16_t num16 = num;
                    if (num > 32767 || num < -32768) {
                        instruction_t instr = (instruction_t) {
                            .opcode = op_cmp_reg_imm64,
                            .args = {
                                ARG_64BIT(num),
                                ARG_8BIT(reg1),
                            }
                        };
                        add_instruction(obj, instr);
                    } else {
                        instruction_t instr = (instruction_t) {
                            .opcode = op_cmp_reg_imm16,
                            .args = {
                                ARG_16BIT(num16),
                                ARG_8BIT(reg1),
                            }
                        };
                        add_instruction(obj, instr);
                    }
                } else {
                    printf("%s:%d: Expected register or number, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("cmpz")) {
                tokens++;
                if (tokens->type != Register) {
                    printf("%s:%d: Expected register, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                uint8_t reg1 = parse8(tokens->value + 1);
                instruction_t instr = (instruction_t) {
                    .opcode = op_cmpz_reg,
                    .args = {
                        ARG_8BIT(reg1),
                    }
                };
                add_instruction(obj, instr);
            } else if (ins("b")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_b_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_b_addr,
                        .args = {
                            ARG_64SYM(sym),
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("bne")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bne_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bne_addr,
                        .args = {
                            ARG_64SYM(sym),
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("beq")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_beq_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_beq_addr,
                        .args = {
                            ARG_64SYM(sym),
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("bgt")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bgt_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bgt_addr,
                        .args = {
                            ARG_64SYM(sym),
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("blt")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_blt_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_blt_addr,
                        .args = {
                            ARG_64SYM(sym),
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("bge")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bge_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bge_addr,
                        .args = {
                            ARG_64SYM(sym),
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("ble")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_ble_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_ble_addr,
                        .args = {
                            ARG_64SYM(sym),
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("bnz")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bnz_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bnz_addr,
                        .args = {
                            ARG_64SYM(sym),
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("bz")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bz_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bz_addr,
                        .args = {
                            ARG_64SYM(sym),
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("bl")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bl_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bl_addr,
                        .args = {
                            ARG_64SYM(sym),
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("blne")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_blne_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_blne_addr,
                        .args = {
                            ARG_64SYM(sym),
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("bleq")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bleq_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bleq_addr,
                        .args = {
                            ARG_64SYM(sym),
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("blgt")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_blgt_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_blgt_addr,
                        .args = {
                            ARG_64SYM(sym),
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("bllt")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bllt_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bllt_addr,
                        .args = {
                            ARG_64SYM(sym),
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("blge")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_blge_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_blge_addr,
                        .args = {
                            ARG_64SYM(sym)
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("blle")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_blle_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_blle_addr,
                        .args = {
                            ARG_64SYM(sym),
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("blnz")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_blnz_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_blnz_addr,
                        .args = {
                            ARG_64SYM(sym),
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("blz")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_blz_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_blz_addr,
                        .args = {
                            ARG_64SYM(sym),
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("pshi")) {
                instruction_t instr = (instruction_t) {
                    .opcode = op_pshi
                };
                add_instruction(obj, instr);
            } else if (ins("ret")) {
                instruction_t instr = (instruction_t) {
                    .opcode = op_ret
                };
                add_instruction(obj, instr);
            } else if (ins("pshx")) {
                instruction_t instr = (instruction_t) {
                    .opcode = op_psh_reg,
                    .args = {
                        ARG_8BIT(0),
                    }
                };
                add_instruction(obj, instr);
            } else if (ins("ppx")) {
                instruction_t instr = (instruction_t) {
                    .opcode = op_pp_reg,
                    .args = {
                        ARG_8BIT(0),
                    }
                };
                add_instruction(obj, instr);
            } else if (ins("pshy")) {
                instruction_t instr = (instruction_t) {
                    .opcode = op_psh_reg,
                    .args = {
                        ARG_8BIT(1),
                    }
                };
                add_instruction(obj, instr);
            } else if (ins("ppy")) {
                instruction_t instr = (instruction_t) {
                    .opcode = op_pp_reg,
                    .args = {
                        ARG_8BIT(1),
                    }
                };
                add_instruction(obj, instr);
            } else if (ins("svc")) {
                instruction_t instr = (instruction_t) {
                    .opcode = op_svc,
                };
                add_instruction(obj, instr);
            } else if (ins("psh")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_psh_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Number) {
                    uint64_t num = parse64(tokens->value);
                    if (num > 0xFFFF) {
                        instruction_t instr = (instruction_t) {
                            .opcode = op_psh_imm64,
                            .args = {
                                ARG_64BIT(num),
                            }
                        };
                    } else {
                        instruction_t instr = (instruction_t) {
                            .opcode = op_psh_imm16,
                            .args = {
                                ARG_16BIT(num),
                            }
                        };
                        add_instruction(obj, instr);
                    }
                } else if (tokens->type == Identifier) {
                    char* str = tokens->value;
                    str = unquote(str);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_psh_addr,
                        .args = {
                            ARG_64SYM(str),
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register, number, or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("pp")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = parse8(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_pp_reg,
                        .args = {
                            ARG_8BIT(reg),
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* str = tokens->value;
                    str = unquote(str);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_pp_addr,
                        .args = {
                            ARG_64SYM(str),
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
        #define ARITH(_type) \
            } else if (ins(#_type)) { \
                tokens++; \
                if (tokens->type != Register) { \
                    printf("%s:%d: Expected register, got %s\n", tokens->file, tokens->line, tokens->value); \
                    return NULL; \
                } \
                uint8_t reg1 = parse8(tokens->value + 1); \
                tokens++; \
                if (tokens->type == Register) { \
                    uint8_t reg2 = parse8(tokens->value + 1); \
                    instruction_t instr = (instruction_t) { \
                        .opcode = op_ ##_type ## _reg_reg, \
                        .args = { \
                            ARG_8BIT(reg1), \
                            ARG_8BIT(reg2), \
                        } \
                    }; \
                    add_instruction(obj, instr); \
                } else if (tokens->type == Number) { \
                    int64_t num = parse64(tokens->value); \
                    int16_t num16 = num; \
                    if (num > 32767 || num < -32768) { \
                        instruction_t instr = (instruction_t) { \
                            .opcode = op_ ##_type ## _reg_imm64, \
                            .args = { \
                                ARG_64BIT(num), \
                                ARG_8BIT(reg1), \
                            } \
                        }; \
                        add_instruction(obj, instr); \
                    } else { \
                        instruction_t instr = (instruction_t) { \
                            .opcode = op_ ##_type ## _reg_imm16, \
                            .args = { \
                                ARG_16BIT(num16), \
                                ARG_8BIT(reg1), \
                            } \
                        }; \
                        add_instruction(obj, instr); \
                    } \
                } else { \
                    printf("%s:%d: Expected register or number, got %s\n", tokens->file, tokens->line, tokens->value); \
                    return NULL; \
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
            } else if (ins("not")) {
                tokens++;
                if (tokens->type != Register) {
                    printf("%s:%d: Expected register, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                uint8_t reg = parse8(tokens->value + 1);
                instruction_t instr = (instruction_t) {
                    .opcode = op_not_reg,
                    .args = {
                        ARG_8BIT(reg),
                    }
                };
                add_instruction(obj, instr);
            } else if (ins("inc")) {
                tokens++;
                if (tokens->type != Register) {
                    printf("%s:%d: Expected register, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                uint8_t reg = parse8(tokens->value + 1);
                instruction_t instr = (instruction_t) {
                    .opcode = op_inc_reg,
                    .args = {
                        ARG_8BIT(reg),
                    }
                };
                add_instruction(obj, instr);
            } else if (ins("dec")) {
                tokens++;
                if (tokens->type != Register) {
                    printf("%s:%d: Expected register, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                uint8_t reg = parse8(tokens->value + 1);
                instruction_t instr = (instruction_t) {
                    .opcode = op_dec_reg,
                    .args = {
                        ARG_8BIT(reg),
                    }
                };
                add_instruction(obj, instr);
            } else if (ins("irq")) {
                instruction_t instr = (instruction_t) {
                    .opcode = op_irq
                };
                add_instruction(obj, instr);
            } else if (ins("mov")) {
                tokens++;
                if (tokens->type != Register) {
                    printf("%s:%d: Expected register, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                uint8_t reg1 = parse8(tokens->value + 1);
                tokens++;
                if (tokens->type != Identifier) {
                    printf("%s:%d: Expected identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                if (!ins("byte") && !ins("word") && !ins("dword") && !ins("qword")) {
                    printf("%s:%d: Expected byte, word, dword, or qword, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                uint8_t size = 0;
                if (ins("byte")) {
                    size = 1;
                } else if (ins("word")) {
                    size = 2;
                } else if (ins("dword")) {
                    size = 4;
                } else if (ins("qword")) {
                    size = 8;
                }
                tokens++;
                if (tokens->type != LeftBracket) {
                    printf("%s:%d: Expected [, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg2 = parse8(tokens->value + 1);
                    tokens++;
                    if (tokens->type == RightBracket) {
                        instruction_t instr = (instruction_t) {
                            .opcode = op_mov_reg_reg,
                            .args = {
                                ARG_16BIT(0),
                                ARG_8BIT(reg1),
                                ARG_8BIT(size),
                                ARG_8BIT(reg2),
                            }
                        };
                        add_instruction(obj, instr);
                    } else if (tokens->type == Number) {
                        int64_t num = parse64(tokens->value);
                        if (num > 32767 || num < -32768) {
                            printf("%s:%d: Number too large\n", tokens->file, tokens->line);
                            return NULL;
                        } else {
                            tokens++;
                            if (tokens->type != RightBracket) {
                                printf("%s:%d: Expected ], got %s\n", tokens->file, tokens->line, tokens->value);
                                return NULL;
                            }
                            int16_t num16 = num;
                            instruction_t instr = (instruction_t) {
                                .opcode = op_mov_reg_reg,
                                .args = {
                                    ARG_16BIT(num16),
                                    ARG_8BIT(reg1),
                                    ARG_8BIT(size),
                                    ARG_8BIT(reg2),
                                }
                            };
                            add_instruction(obj, instr);
                        }
                    } else if (tokens->type == Register) {
                        uint8_t reg3 = parse8(tokens->value + 1);
                        tokens++;
                        if (tokens->type != RightBracket) {
                            printf("%s:%d: Expected ], got %s\n", tokens->file, tokens->line, tokens->value);
                            return NULL;
                        }
                        instruction_t instr = (instruction_t) {
                            .opcode = op_mov_reg_reg_reg,
                            .args = {
                                ARG_8BIT(reg1),
                                ARG_8BIT(size),
                                ARG_8BIT(reg2),
                                ARG_8BIT(reg3),
                            }
                        };
                        add_instruction(obj, instr);
                    } else {
                        printf("%s:%d: Expected register or number, got %s\n", tokens->file, tokens->line, tokens->value);
                        return NULL;
                    }
                } else if (tokens->type == Identifier) {
                    char* str = tokens->value;
                    str = unquote(str);
                    tokens++;
                    if (tokens->type == RightBracket) {
                        instruction_t instr = (instruction_t) {
                            .opcode = op_mov_reg_addr,
                            .args = {
                                ARG_64SYM(str),
                                ARG_8BIT(reg1),
                                ARG_8BIT(size),
                                ARG_16BIT(0),
                            }
                        };
                        add_instruction(obj, instr);
                    } else if (tokens->type == Number) {
                        int64_t num = parse64(tokens->value);
                        if (num > 32767 || num < -32768) {
                            printf("%s:%d: Number too large\n", tokens->file, tokens->line);
                            return NULL;
                        } else {
                            tokens++;
                            if (tokens->type != RightBracket) {
                                printf("%s:%d: Expected ], got %s\n", tokens->file, tokens->line, tokens->value);
                                return NULL;
                            }
                            int16_t num16 = num;
                            instruction_t instr = (instruction_t) {
                                .opcode = op_mov_reg_addr,
                                .args = {
                                    ARG_64SYM(str),
                                    ARG_8BIT(reg1),
                                    ARG_8BIT(size),
                                    ARG_16BIT(num16),
                                }
                            };
                            add_instruction(obj, instr);
                        }
                    } else if (tokens->type == Register) {
                        uint8_t reg3 = parse8(tokens->value + 1);
                        tokens++;
                        if (tokens->type != RightBracket) {
                            printf("%s:%d: Expected ], got %s\n", tokens->file, tokens->line, tokens->value);
                            return NULL;
                        }
                        instruction_t instr = (instruction_t) {
                            .opcode = op_mov_reg_addr_reg,
                            .args = {
                                ARG_64SYM(str),
                                ARG_8BIT(reg1),
                                ARG_8BIT(size),
                                ARG_8BIT(reg3),
                            }
                        };
                        add_instruction(obj, instr);
                    } else {
                        printf("%s:%d: Expected register or number, got %s\n", tokens->file, tokens->line, tokens->value);
                        return NULL;
                    }
                } else {
                    printf("%s:%d: Expected register or identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else {
                printf("%s:%d: Unknown instruction: %s\n", tokens->file, tokens->line, tokens->value);
                return NULL;
            }
        } else if (tokens->type == Directive) {
            if (eq(tokens->value, "asciz") || eq(tokens->value, "ascii")) {
                tokens++;
                if (tokens->type != String) {
                    printf("%s:%d: Expected string, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                char* str = tokens->value;
                str = unquote(str);
                if (eq((tokens - 1)->value, "ascii")) {
                    ASCII(str);
                } else {
                    ASCIZ(str);
                }
            } else if (eq(tokens->value, "byte")) {
                tokens++;
                if (tokens->type != Number) {
                    printf("%s:%d: Expected number, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                uint8_t num = parse8(tokens->value);
                add_imm_byte(obj, num);
            } else if (eq(tokens->value, "word")) {
                tokens++;
                if (tokens->type != Number) {
                    printf("%s:%d: Expected number, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                uint16_t num = parse16(tokens->value);
                add_imm_word(obj, num);
            } else if (eq(tokens->value, "dword")) {
                tokens++;
                if (tokens->type != Number) {
                    printf("%s:%d: Expected number, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                uint32_t num = parse32(tokens->value);
                add_imm_dword(obj, num);
            } else if (eq(tokens->value, "qword")) {
                tokens++;
                if (tokens->type != Number) {
                    printf("%s:%d: Expected number, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                uint64_t num = parse64(tokens->value);
                add_imm_qword(obj, num);
            } else if (eq(tokens->value, "float")) {
                tokens++;
                if (tokens->type != NumberFloat) {
                    printf("%s:%d: Expected number, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                float num = atof(tokens->value);
                add_imm_dword(obj, *(int32_t*) &num);
            } else if (eq(tokens->value, "double")) {
                tokens++;
                if (tokens->type != NumberFloat) {
                    printf("%s:%d: Expected number, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                double num = atof(tokens->value);
                add_imm_qword(obj, *(int64_t*) &num);
            } else if (eq(tokens->value, "offset")) {
                tokens++;
                if (tokens->type != Identifier) {
                    printf("%s:%d: Expected identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                add_symbol_offset(obj, tokens->value);
            // } else if (eq(tokens->value, "section")) {
            //     SECTION_FLAG
            } else {
                printf("%s:%d: Unknown directive: %s\n", tokens->file, tokens->line, tokens->value);
                return NULL;
            }
        } else if (tokens->type == Label) {
            char* str = tokens->value;
            str = unquote(str);
            int index = CODE(str);
            obj->symbols[index].section = section_count - 1;
        }
    }
    objs = realloc(objs, sizeof(section_t*) * (section_count + 1));
    objs[section_count] = NULL;
    return objs;
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
        if (strncmp(src, "xmm", 3) == 0) {
            src += 3;
            if (isnumber(*src)) {
                while (isnumber(*src))
                    src++;
                
                s[src - start] = 0;
                return (Token) {
                    .file = file,
                    .line = line,
                    .value = s,
                    .type = SimdRegister
                };
            }
            src -= 3;
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
                .value = "r27",
                .type = Register
            };
        } else if (eq(s, "lr")) {
            return (Token) {
                .file = file,
                .line = line,
                .value = "r28",
                .type = Register
            };
        } else if (eq(s, "sp")) {
            return (Token) {
                .file = file,
                .line = line,
                .value = "r29",
                .type = Register
            };
        } else if (eq(s, "bp")) {
            return (Token) {
                .file = file,
                .line = line,
                .value = "r30",
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
