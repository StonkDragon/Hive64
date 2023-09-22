#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "new_ops.h"
#include "compile.h"

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

object_file* compile(Token* tokens);
Token* parse(char* src);

static char* file;

object_file* run_compile(const char* file_name) {
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

    Token* tokens = parse(src);
    
    object_file* obj = compile(tokens);

    return obj;
}

int isValidBegin(int c) {
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_';
}

int isValid(int c) {
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_';
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

object_file* compile(Token* tokens) {
    CREATE_OBJECT();
    for (;tokens->type != EOF; tokens++) {
        if (tokens->type == Identifier) {
            printf("%s:%d: %s\n", tokens->file, tokens->line, tokens->value);
            if (ins("nop")) {
                instruction_t instr = (instruction_t) {
                    .opcode = op_nop
                };
                add_instruction(obj, instr);
            } else if (ins("hlt")) {
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
                uint8_t reg1 = atoi(tokens->value + 1);
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg2 = atoi(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_ldr_reg_reg,
                        .args = {
                            ARG_REG(reg1),
                            ARG_REG(reg2)
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Number) {
                    int64_t num = atoll(tokens->value);
                    if (num > 32767 || num < -32768) {
                        instruction_t instr = (instruction_t) {
                            .opcode = op_ldr_reg_imm,
                            .args = {
                                ARG_REG(reg1),
                                ARG_IMM64(num)
                            }
                        };
                        add_instruction(obj, instr);
                    } else {
                        int16_t num16 = num;
                        instruction_t instr = (instruction_t) {
                            .opcode = op_ldr_reg_imm16,
                            .args = {
                                ARG_REG(reg1),
                                ARG_IMM16(num16)
                            }
                        };
                        add_instruction(obj, instr);
                    }
                } else if (tokens->type == Identifier) {
                    char* str = tokens->value;
                    str = unquote(str);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_ldr_reg_addr,
                        .args = {
                            ARG_REG(reg1),
                            ARG_SYM(str)
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == LeftBracket) {
                    tokens++;
                    if (tokens->type == Register) {
                        uint8_t reg2 = atoi(tokens->value + 1);
                        tokens++;
                        if (tokens->type == RightBracket) {
                            instruction_t instr = (instruction_t) {
                                .opcode = op_ldr_reg_mem,
                                .args = {
                                    ARG_REG(reg1),
                                    ARG_REG(reg2),
                                    ARG_IMM16(0)
                                }
                            };
                            add_instruction(obj, instr);
                        } else if (tokens->type == Number) {
                            int64_t num = atoll(tokens->value);
                            int16_t num16 = num;
                            if (num > 32767 || num < -32768) {
                                printf("%s:%d: Number too large\n", tokens->file, tokens->line);
                                return NULL;
                            } else {
                                instruction_t instr = (instruction_t) {
                                    .opcode = op_ldr_reg_mem,
                                    .args = {
                                        ARG_REG(reg1),
                                        ARG_REG(reg2),
                                        ARG_IMM16(num16)
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
                            uint8_t reg2 = atoi(tokens->value + 1);
                            tokens++;
                            if (tokens->type != RightBracket) {
                                printf("%s:%d: Expected ], got %s\n", tokens->file, tokens->line, tokens->value);
                                return NULL;
                            }
                            instruction_t instr = (instruction_t) {
                                .opcode = op_ldr_reg_addr_reg,
                                .args = {
                                    ARG_REG(reg1),
                                    ARG_REG(reg2),
                                    ARG_SYM(str)
                                }
                            };
                        } else if (tokens->type == Number) {
                            int64_t num = atoll(tokens->value);
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
                                        ARG_REG(reg1),
                                        ARG_IMM16(num16),
                                        ARG_SYM(str)
                                    }
                                };
                                add_instruction(obj, instr);
                            }
                        } else if (tokens->type == RightBracket) {
                            char* str = tokens->value;
                            str = unquote(str);
                            instruction_t instr = (instruction_t) {
                                .opcode = op_ldr_reg_addr_imm16,
                                .args = {
                                    ARG_REG(reg1),
                                    ARG_IMM16(0),
                                    ARG_SYM(str)
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
                uint8_t reg1 = atoi(tokens->value + 1);
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg2 = atoi(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_str_reg_reg,
                        .args = {
                            ARG_REG(reg1),
                            ARG_REG(reg2)
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Number) {
                    int64_t num = atoll(tokens->value);
                    int16_t num16 = num;
                    if (num > 32767 || num < -32768) {
                        instruction_t instr = (instruction_t) {
                            .opcode = op_str_reg_imm64,
                            .args = {
                                ARG_REG(reg1),
                                ARG_IMM64(num)
                            }
                        };
                        add_instruction(obj, instr);
                    } else {
                        instruction_t instr = (instruction_t) {
                            .opcode = op_str_reg_imm16,
                            .args = {
                                ARG_REG(reg1),
                                ARG_IMM16(num16)
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
                uint8_t reg1 = atoi(tokens->value + 1);
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg2 = atoi(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_cmp_reg_reg,
                        .args = {
                            ARG_REG(reg1),
                            ARG_REG(reg2)
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Number) {
                    int64_t num = atoll(tokens->value);
                    int16_t num16 = num;
                    if (num > 32767 || num < -32768) {
                        instruction_t instr = (instruction_t) {
                            .opcode = op_cmp_reg_imm64,
                            .args = {
                                ARG_REG(reg1),
                                ARG_IMM64(num)
                            }
                        };
                        add_instruction(obj, instr);
                    } else {
                        instruction_t instr = (instruction_t) {
                            .opcode = op_cmp_reg_imm16,
                            .args = {
                                ARG_REG(reg1),
                                ARG_IMM16(num16)
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
                uint8_t reg1 = atoi(tokens->value + 1);
                instruction_t instr = (instruction_t) {
                    .opcode = op_cmpz_reg,
                    .args = {
                        ARG_REG(reg1)
                    }
                };
                add_instruction(obj, instr);
            } else if (ins("b")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = atoi(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_b_reg,
                        .args = {
                            ARG_REG(reg)
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_b_addr,
                        .args = {
                            ARG_SYM(sym)
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
                    uint8_t reg = atoi(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bne_reg,
                        .args = {
                            ARG_REG(reg)
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bne_addr,
                        .args = {
                            ARG_SYM(sym)
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
                    uint8_t reg = atoi(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_beq_reg,
                        .args = {
                            ARG_REG(reg)
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_beq_addr,
                        .args = {
                            ARG_SYM(sym)
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
                    uint8_t reg = atoi(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bgt_reg,
                        .args = {
                            ARG_REG(reg)
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bgt_addr,
                        .args = {
                            ARG_SYM(sym)
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
                    uint8_t reg = atoi(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_blt_reg,
                        .args = {
                            ARG_REG(reg)
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_blt_addr,
                        .args = {
                            ARG_SYM(sym)
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
                    uint8_t reg = atoi(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bge_reg,
                        .args = {
                            ARG_REG(reg)
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bge_addr,
                        .args = {
                            ARG_SYM(sym)
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
                    uint8_t reg = atoi(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_ble_reg,
                        .args = {
                            ARG_REG(reg)
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_ble_addr,
                        .args = {
                            ARG_SYM(sym)
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
                    uint8_t reg = atoi(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bnz_reg,
                        .args = {
                            ARG_REG(reg)
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bnz_addr,
                        .args = {
                            ARG_SYM(sym)
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
                    uint8_t reg = atoi(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bz_reg,
                        .args = {
                            ARG_REG(reg)
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* sym = tokens->value;
                    sym = unquote(sym);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_bz_addr,
                        .args = {
                            ARG_SYM(sym)
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
                    .opcode = op_pshx
                };
                add_instruction(obj, instr);
            } else if (ins("ppx")) {
                instruction_t instr = (instruction_t) {
                    .opcode = op_ppx
                };
                add_instruction(obj, instr);
            } else if (ins("pshy")) {
                instruction_t instr = (instruction_t) {
                    .opcode = op_pshy
                };
                add_instruction(obj, instr);
            } else if (ins("ppy")) {
                instruction_t instr = (instruction_t) {
                    .opcode = op_ppy
                };
                add_instruction(obj, instr);
            } else if (ins("psh")) {
                tokens++;
                if (tokens->type == Register) {
                    uint8_t reg = atoi(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_psh_reg,
                        .args = {
                            ARG_REG(reg)
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Number) {
                    uint64_t num = atoll(tokens->value);
                    if (num > 0xFFFF) {
                        instruction_t instr = (instruction_t) {
                            .opcode = op_psh_imm64,
                            .args = {
                                ARG_IMM64(num)
                            }
                        };
                    } else {
                        instruction_t instr = (instruction_t) {
                            .opcode = op_psh_imm16,
                            .args = {
                                ARG_IMM16(num)
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
                            ARG_SYM(str)
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
                    uint8_t reg = atoi(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_pp_reg,
                        .args = {
                            ARG_REG(reg)
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Identifier) {
                    char* str = tokens->value;
                    str = unquote(str);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_pp_addr,
                        .args = {
                            ARG_SYM(str)
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
                uint8_t reg1 = atoi(tokens->value + 1); \
                tokens++; \
                if (tokens->type == Register) { \
                    uint8_t reg2 = atoi(tokens->value + 1); \
                    instruction_t instr = (instruction_t) { \
                        .opcode = op_ ##_type ## _reg_reg, \
                        .args = { \
                            ARG_REG(reg1), \
                            ARG_REG(reg2) \
                        } \
                    }; \
                    add_instruction(obj, instr); \
                } else if (tokens->type == Number) { \
                    int64_t num = atoll(tokens->value); \
                    int16_t num16 = num; \
                    if (num > 32767 || num < -32768) { \
                        instruction_t instr = (instruction_t) { \
                            .opcode = op_ ##_type ## _reg_imm64, \
                            .args = { \
                                ARG_REG(reg1), \
                                ARG_IMM64(num) \
                            } \
                        }; \
                        add_instruction(obj, instr); \
                    } else { \
                        instruction_t instr = (instruction_t) { \
                            .opcode = op_ ##_type ## _reg_imm16, \
                            .args = { \
                                ARG_REG(reg1), \
                                ARG_IMM16(num16) \
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
                uint8_t reg = atoi(tokens->value + 1);
                instruction_t instr = (instruction_t) {
                    .opcode = op_not_reg,
                    .args = {
                        ARG_REG(reg)
                    }
                };
                add_instruction(obj, instr);
            } else if (ins("inc")) {
                tokens++;
                if (tokens->type != Register) {
                    printf("%s:%d: Expected register, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                uint8_t reg = atoi(tokens->value + 1);
                instruction_t instr = (instruction_t) {
                    .opcode = op_inc_reg,
                    .args = {
                        ARG_REG(reg)
                    }
                };
                add_instruction(obj, instr);
            } else if (ins("dec")) {
                tokens++;
                if (tokens->type != Register) {
                    printf("%s:%d: Expected register, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                uint8_t reg = atoi(tokens->value + 1);
                instruction_t instr = (instruction_t) {
                    .opcode = op_dec_reg,
                    .args = {
                        ARG_REG(reg)
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
                uint8_t reg1 = atoi(tokens->value + 1);
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
                    uint8_t reg2 = atoi(tokens->value + 1);
                    tokens++;
                    if (tokens->type == RightBracket) {
                        instruction_t instr = (instruction_t) {
                            .opcode = op_mov_reg_reg,
                            .args = {
                                ARG_REG(reg1),
                                ARG_REG(size),
                                ARG_IMM16(0),
                                ARG_REG(reg2)
                            }
                        };
                        add_instruction(obj, instr);
                    } else if (tokens->type == Number) {
                        int64_t num = atoll(tokens->value);
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
                                    ARG_REG(reg1),
                                    ARG_REG(size),
                                    ARG_IMM16(num16),
                                    ARG_REG(reg2)
                                }
                            };
                            add_instruction(obj, instr);
                        }
                    } else if (tokens->type == Register) {
                        uint8_t reg3 = atoi(tokens->value + 1);
                        tokens++;
                        if (tokens->type != RightBracket) {
                            printf("%s:%d: Expected ], got %s\n", tokens->file, tokens->line, tokens->value);
                            return NULL;
                        }
                        instruction_t instr = (instruction_t) {
                            .opcode = op_mov_reg_reg_reg,
                            .args = {
                                ARG_REG(reg1),
                                ARG_REG(size),
                                ARG_REG(reg2),
                                ARG_REG(reg3)
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
                                ARG_REG(reg1),
                                ARG_REG(size),
                                ARG_IMM16(0),
                                ARG_SYM(str)
                            }
                        };
                        add_instruction(obj, instr);
                    } else if (tokens->type == Number) {
                        int64_t num = atoll(tokens->value);
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
                                    ARG_REG(reg1),
                                    ARG_REG(size),
                                    ARG_IMM16(num16),
                                    ARG_SYM(str)
                                }
                            };
                            add_instruction(obj, instr);
                        }
                    } else if (tokens->type == Register) {
                        uint8_t reg3 = atoi(tokens->value + 1);
                        tokens++;
                        if (tokens->type != RightBracket) {
                            printf("%s:%d: Expected ], got %s\n", tokens->file, tokens->line, tokens->value);
                            return NULL;
                        }
                        instruction_t instr = (instruction_t) {
                            .opcode = op_mov_reg_addr_reg,
                            .args = {
                                ARG_REG(reg1),
                                ARG_REG(size),
                                ARG_SYM(str),
                                ARG_REG(reg3)
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

            #define SIMD_SIMPLE(_op) \
            } else if (ins(#_op)) { \
                tokens++; \
                if (tokens->type != Identifier) { \
                    printf("%s:%d: Expected identifier, got %s\n", tokens->file, tokens->line, tokens->value); \
                    return NULL; \
                } \
                if (!ins("byte") && !ins("word") && !ins("dword") && !ins("qword") && !ins("float") && !ins("double")) { \
                    printf("%s:%d: Expected byte, word, dword, qword, float, or double, got %s\n", tokens->file, tokens->line, tokens->value); \
                    return NULL; \
                } \
                uint8_t mode = 0; \
                if (ins("byte")) { \
                    mode = 0x01; \
                } else if (ins("word")) { \
                    mode = 0x02; \
                } else if (ins("dword")) { \
                    mode = 0x04; \
                } else if (ins("qword")) { \
                    mode = 0x08; \
                } else if (ins("float")) { \
                    mode = 0x10; \
                } else if (ins("double")) { \
                    mode = 0x20; \
                } \
                tokens++; \
                if (tokens->type != SimdRegister) { \
                    printf("%s:%d: Expected simd register, got %s\n", tokens->file, tokens->line, tokens->value); \
                    return NULL; \
                } \
                uint8_t reg1 = atoi(tokens->value + 3); \
                tokens++; \
                if (tokens->type != SimdRegister) { \
                    printf("%s:%d: Expected simd register, got %s\n", tokens->file, tokens->line, tokens->value); \
                    return NULL; \
                } \
                uint8_t reg2 = atoi(tokens->value + 3); \
                instruction_t instr = (instruction_t) { \
                    .opcode = op_ ## _op ## _reg_reg, \
                    .args = { \
                        ARG_REG(mode), \
                        ARG_REG(reg1), \
                        ARG_REG(reg2) \
                    } \
                }; \
                add_instruction(obj, instr);


            SIMD_SIMPLE(qadd)
            SIMD_SIMPLE(qsub)
            SIMD_SIMPLE(qmul)
            SIMD_SIMPLE(qdiv)
            SIMD_SIMPLE(qmod)
            SIMD_SIMPLE(qand)
            SIMD_SIMPLE(qor)
            SIMD_SIMPLE(qxor)
            SIMD_SIMPLE(qshl)
            SIMD_SIMPLE(qshr)
            SIMD_SIMPLE(qaddsub)
            SIMD_SIMPLE(qshuf)

            } else if (ins("qconv")) {
                tokens++;
                if (tokens->type != Identifier) {
                    printf("%s:%d: Expected identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                if (!ins("byte") && !ins("word") && !ins("dword") && !ins("qword") && !ins("float") && !ins("double")) {
                    printf("%s:%d: Expected byte, word, dword, qword, float, or double, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                uint8_t destMode = 0;
                if (ins("byte")) {
                    destMode = 0x01;
                } else if (ins("word")) {
                    destMode = 0x02;
                } else if (ins("dword")) {
                    destMode = 0x04;
                } else if (ins("qword")) {
                    destMode = 0x08;
                } else if (ins("float")) {
                    destMode = 0x10;
                } else if (ins("double")) {
                    destMode = 0x20;
                }
                tokens++;
                if (tokens->type != SimdRegister) {
                    printf("%s:%d: Expected simd register, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                uint8_t destReg = atoi(tokens->value + 3);
                tokens++;
                if (tokens->type != Identifier) {
                    printf("%s:%d: Expected identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                if (!ins("byte") && !ins("word") && !ins("dword") && !ins("qword") && !ins("float") && !ins("double")) {
                    printf("%s:%d: Expected byte, word, dword, qword, float, or double, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                uint8_t srcMode = 0;
                if (ins("byte")) {
                    srcMode = 0x01;
                } else if (ins("word")) {
                    srcMode = 0x02;
                } else if (ins("dword")) {
                    srcMode = 0x04;
                } else if (ins("qword")) {
                    srcMode = 0x08;
                } else if (ins("float")) {
                    srcMode = 0x10;
                } else if (ins("double")) {
                    srcMode = 0x20;
                }
                tokens++;
                if (tokens->type != SimdRegister) {
                    printf("%s:%d: Expected simd register, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                uint8_t srcReg = atoi(tokens->value + 3);
                instruction_t instr = (instruction_t) {
                    .opcode = op_qconv_reg_reg,
                    .args = {
                        ARG_REG(destMode),
                        ARG_REG(destReg),
                        ARG_REG(srcMode),
                        ARG_REG(srcReg)
                    }
                };
                add_instruction(obj, instr);
            } else if (ins("qmov")) {
                tokens++;
                if (tokens->type == Identifier) {
                    if (!ins("byte") && !ins("word") && !ins("dword") && !ins("qword") && !ins("float") && !ins("double")) {
                        printf("%s:%d: Expected byte, word, dword, qword, float, or double, got %s\n", tokens->file, tokens->line, tokens->value);
                        return NULL;
                    }
                    uint8_t destMode = 0;
                    if (ins("byte")) {
                        destMode = 0x01;
                    } else if (ins("word")) {
                        destMode = 0x02;
                    } else if (ins("dword")) {
                        destMode = 0x04;
                    } else if (ins("qword")) {
                        destMode = 0x08;
                    } else if (ins("float")) {
                        destMode = 0x10;
                    } else if (ins("double")) {
                        destMode = 0x20;
                    }
                    tokens++;
                    if (tokens->type != LeftBracket) {
                        printf("%s:%d: Expected [, got %s\n", tokens->file, tokens->line, tokens->value);
                        return NULL;
                    }
                    tokens++;
                    if (tokens->type != SimdRegister) {
                        printf("%s:%d: Expected simd register, got %s\n", tokens->file, tokens->line, tokens->value);
                        return NULL;
                    }
                    uint8_t destReg = atoi(tokens->value + 3);
                    tokens++;
                    uint8_t index = 0xFF;
                    if (tokens->type == Number) {
                        index = atoi(tokens->value);
                        tokens++;
                    }
                    if (tokens->type != RightBracket) {
                        printf("%s:%d: Expected ], got %s\n", tokens->file, tokens->line, tokens->value);
                        return NULL;
                    }
                    tokens++;
                    if (tokens->type != Register) {
                        printf("%s:%d: Expected register, got %s\n", tokens->file, tokens->line, tokens->value);
                        return NULL;
                    }
                    uint8_t srcReg = atoi(tokens->value + 1);
                    instruction_t instr = (instruction_t) {
                        .opcode = op_qmov_reg_imm,
                        .args = {
                            ARG_REG(destMode),
                            ARG_REG(destReg),
                            ARG_REG(index),
                            ARG_REG(srcReg)
                        }
                    };
                    add_instruction(obj, instr);
                } else if (tokens->type == Register) {
                    uint8_t destReg = atoi(tokens->value + 1);
                    tokens++;
                    if (tokens->type != Identifier) {
                        printf("%s:%d: Expected identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                        return NULL;
                    }
                    if (!ins("byte") && !ins("word") && !ins("dword") && !ins("qword") && !ins("float") && !ins("double")) {
                        printf("%s:%d: Expected byte, word, dword, qword, float, or double, got %s\n", tokens->file, tokens->line, tokens->value);
                        return NULL;
                    }
                    uint8_t srcMode = 0;
                    if (ins("byte")) {
                        srcMode = 0x01;
                    } else if (ins("word")) {
                        srcMode = 0x02;
                    } else if (ins("dword")) {
                        srcMode = 0x04;
                    } else if (ins("qword")) {
                        srcMode = 0x08;
                    } else if (ins("float")) {
                        srcMode = 0x10;
                    } else if (ins("double")) {
                        srcMode = 0x20;
                    }
                    tokens++;
                    if (tokens->type != LeftBracket) {
                        printf("%s:%d: Expected [, got %s\n", tokens->file, tokens->line, tokens->value);
                        return NULL;
                    }
                    tokens++;
                    if (tokens->type != SimdRegister) {
                        printf("%s:%d: Expected simd register, got %s\n", tokens->file, tokens->line, tokens->value);
                        return NULL;
                    }
                    uint8_t srcReg = atoi(tokens->value + 3);
                    tokens++;
                    uint8_t index = 0;
                    if (tokens->type == Number) {
                        index = atoi(tokens->value);
                        tokens++;
                    }
                    if (tokens->type != RightBracket) {
                        printf("%s:%d: Expected ], got %s\n", tokens->file, tokens->line, tokens->value);
                        return NULL;
                    }
                    tokens++;
                    instruction_t instr = (instruction_t) {
                        .opcode = op_qmov2_reg_imm,
                        .args = {
                            ARG_REG(destReg),
                            ARG_REG(srcMode),
                            ARG_REG(index),
                            ARG_REG(srcReg)
                        }
                    };
                    add_instruction(obj, instr);
                } else {
                    printf("%s:%d: Expected identifier or register, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
            } else if (ins("call")) {
                tokens++;
                if (tokens->type != Identifier) {
                    printf("%s:%d: Expected identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                char* str = tokens->value;
                str = unquote(str);
                instruction_t instr = (instruction_t) {
                    .opcode = op_ldr_reg_imm16,
                    .args = {
                        ARG_REG(15),
                        ARG_IMM16(4)
                    }
                };
                add_instruction(obj, instr);
                instr = (instruction_t) {
                    .opcode = op_ldr_reg_addr,
                    .args = {
                        ARG_REG(14),
                        ARG_SYM(str)
                    }
                };
                add_instruction(obj, instr);
                instr = (instruction_t) {
                    .opcode = op_irq
                };
                add_instruction(obj, instr);
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
            } else if (eq(tokens->value, "code") || eq(tokens->value, "data")) {
                tokens++;
                if (tokens->type != Label) {
                    printf("%s:%d: Expected label, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                char* str = tokens->value;
                str = unquote(str);
                CODE(str);
            } else if (eq(tokens->value, "extern")) {
                tokens++;
                if (tokens->type != Identifier) {
                    printf("%s:%d: Expected identifier, got %s\n", tokens->file, tokens->line, tokens->value);
                    return NULL;
                }
                char* str = tokens->value;
                str = unquote(str);
                if (str[0] != '_') {
                    printf("%s:%d: Extern label must start with _\n", tokens->file, tokens->line);
                    return NULL;
                }
                CODE(str);
                add_imm_byte(obj, 0x7F);
                ASCIZ(str + 1);
            }
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
        while (isnumber(*src)) {
            src++;
        }
        
        s[src - start] = 0;
        return (Token) {
            .file = file,
            .line = line,
            .value = s,
            .type = Number
        };
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
