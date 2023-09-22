#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <unistd.h>
#include <errno.h>
#include <signal.h>
#include <dlfcn.h>
#include <execinfo.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <ffi/ffi.h>

#include "new_ops.h"

tregister_t registers[37] = {0};

object_file* read_object_file(char* file) {
    FILE* f = fopen(file, "rb");
    if (f == NULL) {
        fprintf(stderr, "File %s not found.\n", file);
        return NULL;
    }
    fseek(f, 0, SEEK_END);
    int size = ftell(f);
    fseek(f, 0, SEEK_SET);
    
    #define NEXT(type) ({ data += sizeof(type); *((type*) (data - sizeof(type))); })

    object_file* obj = malloc(sizeof(object_file));

    uint8_t* data = malloc(size);
    fread(data, size, 1, f);
    fclose(f);

    obj->magic = NEXT(uint32_t);

    if (obj->magic == 0x0DF0EDFE) {
        fprintf(stderr, "Object file is big endian, this is not supported.\n");
        return NULL;
    }
    if (obj->magic != 0xFEEDF00D) {
        fprintf(stderr, "Invalid magic number: %x\n", obj->magic);
        return NULL;
    }

    obj->data = data;
    obj->data_capacity = obj->data_size = size - sizeof(uint32_t);
    
    return obj;
}

void write_object_file(object_file* obj, char const* file) {
    int errnoNow = errno;
    remove(file);
    errno = errnoNow;

    FILE* f = fopen(file, "ab");
    uint32_t magic = 0xFEEDF00D;
    fwrite(&magic, sizeof(uint32_t), 1, f);
    
    for (uint64_t i = 0; i < obj->contents_size; i++) {
        printf("Writing %d\n", obj->contents[i].type);
        compile_bytes_or_instr(obj, obj->contents[i]);
    }
    fwrite(obj->data, obj->data_size, 1, f);
    fclose(f);
}

#define irq (registers[32].asInteger)
#define pc (registers[33].asInteger)
#define sp (registers[34].asPointer)
#define bp (registers[35].asPointer)
#define flags (registers[36].asInteger)

#define FLAG_ZERO       0x00000001
#define FLAG_NEGATIVE   0x00000002
#define FLAG_GREATER    0x00000004
#define FLAG_LESS       0x00000008
#define FLAG_EQUAL      0x00000010

void dump_registers() {
    printf("Registers:\n");
    printf("  PC: 0x%016llx\n", pc);
    printf("  SP: 0x%016llx\n", (uint64_t) sp);
    printf("  BP: 0x%016llx\n", (uint64_t) bp);
    printf("  Flags: 0x%016llx\n", flags);
    for (int i = 0; i < 32; i++) {
        printf("  R% 2d: 0x%016llx %f\n", i, registers[i].asInteger, registers[i].asFloat);
    }
}

void spill() {
    for (int i = 0; i < 32; i++) {
        *(uint64_t*) (sp++) = registers[i].asInteger;
    }
}

void restore() {
    for (int i = 31; i >= 0; i--) {
        registers[i].asInteger = *(uint64_t*) (--sp);
    }
}

static inline uint64_t readUint64(uint8_t* data) {
    uint64_t value = 0;
    value |= ((uint64_t) data[0]);
    value |= ((uint64_t) data[1]) << 8;
    value |= ((uint64_t) data[2]) << 16;
    value |= ((uint64_t) data[3]) << 24;
    value |= ((uint64_t) data[4]) << 32;
    value |= ((uint64_t) data[5]) << 40;
    value |= ((uint64_t) data[6]) << 48;
    value |= ((uint64_t) data[7]) << 56;
    return value;
}

static inline uint32_t readUint32(uint8_t* data) {
    uint32_t value = 0;
    value |= ((uint32_t) data[0]);
    value |= ((uint32_t) data[1]) << 8;
    value |= ((uint32_t) data[2]) << 16;
    value |= ((uint32_t) data[3]) << 24;
    return value;
}

static inline uint16_t readUint16(uint8_t* data) {
    uint16_t value = 0;
    value |= ((uint16_t) data[0]);
    value |= ((uint16_t) data[1]) << 8;
    return value;
}

static inline uint8_t readUint8(uint8_t* data) {
    return data[0];
}

void exec(uint8_t* data) {
    pc = (uint64_t) data;
    while (1) {
        uint16_t op = readUint16((uint8_t*) pc);
        pc += 2;
        uint8_t count = (op & opcode_nbytes_mask) >> opcode_nbytes_shift;
        uint16_t opcode = op & ~opcode_nbytes_mask;

        switch (count) {
        case 0: {
            switch (opcode) {
            case opcode_nop: {
                break;
            }

            case opcode_halt: {
                return;
            }

            case opcode_pshi: {
                *(uint64_t*) (sp++) = pc;
                break;
            }

            case opcode_ret: {
                if (sp == bp) {
                    return;
                }
                pc = *(uint64_t*) (--sp);
                break;
            }

            case opcode_pshx: {
                *(uint64_t*) (sp++) = registers[0].asInteger;
                break;
            }

            case opcode_ppx: {
                registers[0].asInteger = *(uint64_t*) (--sp);
                break;
            }

            case opcode_pshy: {
                *(uint64_t*) (sp++) = registers[1].asInteger;
                break;
            }

            case opcode_ppy: {
                registers[1].asInteger = *(uint64_t*) (--sp);
                break;
            }

            case opcode_irq: {
                dump_registers();
                switch (registers[0].asInteger) {
                    case 1:
                        exit(registers[1].asInteger);
                        break;
                    case 2:
                        registers[1].asInteger = write(registers[1].asInteger, (void*) registers[2].asPointer, registers[3].asInteger);
                        break;
                    case 3:
                        registers[1].asInteger = read(registers[2].asInteger, (void*) registers[3].asPointer, registers[4].asInteger);
                        break;
                    default:
                        printf("Unknown IRQ: %d\n", registers[0].asInteger);
                        break;
                }
                break;
            }

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }

            break;
        }

        case 1: {
            switch (opcode) {
            case opcode_cmpz: {
                uint8_t reg = readUint8((uint8_t*) pc);
                pc += 1;
                if (registers[reg].asInteger == 0) {
                    flags |= FLAG_ZERO;
                } else {
                    flags &= ~FLAG_ZERO;
                }
                break;
            }

            case opcode_b: {
                uint8_t reg = readUint8((uint8_t*) pc);
                pc = registers[reg].asInteger;
                break;
            }

            case opcode_bne: {
                uint8_t reg = readUint8((uint8_t*) pc);
                pc += 1;
                if (!(flags & FLAG_EQUAL)) {
                    pc = registers[reg].asInteger;
                }
                break;
            }

            case opcode_beq: {
                uint8_t reg = readUint8((uint8_t*) pc);
                pc += 1;
                if (flags & FLAG_EQUAL) {
                    pc = registers[reg].asInteger;
                }
                break;
            }

            case opcode_bgt: {
                uint8_t reg = readUint8((uint8_t*) pc);
                pc += 1;
                if (flags & FLAG_GREATER) {
                    pc = registers[reg].asInteger;
                }
                break;
            }

            case opcode_blt: {
                uint8_t reg = readUint8((uint8_t*) pc);
                pc += 1;
                if (flags & FLAG_LESS) {
                    pc = registers[reg].asInteger;
                }
                break;
            }

            case opcode_bge: {
                uint8_t reg = readUint8((uint8_t*) pc);
                pc += 1;
                if (flags & (FLAG_GREATER | FLAG_EQUAL)) {
                    pc = registers[reg].asInteger;
                }
                break;
            }

            case opcode_ble: {
                uint8_t reg = readUint8((uint8_t*) pc);
                pc += 1;
                if (flags & (FLAG_LESS | FLAG_EQUAL)) {
                    pc = registers[reg].asInteger;
                }
                break;
            }

            case opcode_bnz: {
                uint8_t reg = readUint8((uint8_t*) pc);
                pc += 1;
                if (!(flags & FLAG_ZERO)) {
                    pc = registers[reg].asInteger;
                }
                break;
            }

            case opcode_bz: {
                uint8_t reg = readUint8((uint8_t*) pc);
                pc += 1;
                if (flags & FLAG_ZERO) {
                    pc = registers[reg].asInteger;
                }
                break;
            }

            case opcode_psh: {
                uint8_t reg = readUint8((uint8_t*) pc);
                pc += 1;
                *(uint64_t*) (sp++) = registers[reg].asInteger;
                break;
            }

            case opcode_pp: {
                uint8_t reg = readUint8((uint8_t*) pc);
                pc += 1;
                registers[reg].asInteger = *(uint64_t*) (--sp);
                break;
            }

            case opcode_not: {
                uint8_t reg = readUint8((uint8_t*) pc);
                pc += 1;
                registers[reg].asInteger = ~registers[reg].asInteger;
                break;
            }

            case opcode_inc: {
                uint8_t reg = readUint8((uint8_t*) pc);
                pc += 1;
                registers[reg].asInteger++;
                break;
            }

            case opcode_dec: {
                uint8_t reg = readUint8((uint8_t*) pc);
                pc += 1;
                registers[reg].asInteger--;
                break;
            }

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }

            break;
        }
        
        case 2: {
            switch (opcode) {
            case opcode_ldr: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                pc += 2;
                registers[reg1].asInteger = *(uint64_t*) (registers[reg2].asPointer);
                break;
            }

            case opcode_str: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                pc += 2;
                *(uint64_t*) (registers[reg2].asPointer) = registers[reg1].asInteger;
                break;
            }

            case opcode_cmp: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                pc += 2;
                uint64_t a = registers[reg1].asInteger;
                uint64_t b = registers[reg2].asInteger;
                int64_t as = (int64_t) a;
                int64_t bs = (int64_t) b;
                flags = 0;
                if (a == b) {
                    flags |= FLAG_EQUAL;
                } else if (as > bs) {
                    flags |= FLAG_GREATER;
                } else if (as < bs) {
                    flags |= FLAG_LESS;
                }
                if (a == 0) {
                    flags |= FLAG_ZERO;
                }
                if (as < 0) {
                    flags |= FLAG_NEGATIVE;
                }
                break;
            }

            case opcode_psh: {
                uint16_t value = readUint16((uint8_t*) pc);
                pc += 2;
                *(uint64_t*) (sp++) = value;
                break;
            }

            case opcode_add: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                pc += 2;
                registers[reg1].asInteger += registers[reg2].asInteger;
                break;
            }

            case opcode_sub: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                pc += 2;
                registers[reg1].asInteger -= registers[reg2].asInteger;
                break;
            }

            case opcode_mul: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                pc += 2;
                registers[reg1].asInteger *= registers[reg2].asInteger;
                break;
            }

            case opcode_div: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                pc += 2;
                registers[reg1].asInteger /= registers[reg2].asInteger;
                break;
            }

            case opcode_mod: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                pc += 2;
                registers[reg1].asInteger %= registers[reg2].asInteger;
                break;
            }

            case opcode_and: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                pc += 2;
                registers[reg1].asInteger &= registers[reg2].asInteger;
                break;
            }

            case opcode_or: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                pc += 2;
                registers[reg1].asInteger |= registers[reg2].asInteger;
                break;
            }

            case opcode_xor: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                pc += 2;
                registers[reg1].asInteger ^= registers[reg2].asInteger;
                break;
            }

            case opcode_shl: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                pc += 2;
                registers[reg1].asInteger <<= registers[reg2].asInteger;
                break;
            }

            case opcode_shr: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                pc += 2;
                registers[reg1].asInteger >>= registers[reg2].asInteger;
                break;
            }

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }
            break;
        }

        case 3: {
            switch (opcode) {
            case opcode_ldr: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint16_t value = readUint16((uint8_t*) pc + 1);
                pc += 3;
                registers[reg1].asInteger = value;
                break;
            }

            case opcode_str: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint16_t value = readUint16((uint8_t*) pc + 1);
                pc += 3;
                *(uint64_t*) (registers[reg1].asPointer) = value;
                break;
            }

            case opcode_cmp: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint64_t a = registers[reg1].asInteger;
                uint64_t b = readUint16((uint8_t*) pc + 1);
                pc += 3;
                int64_t as = (int64_t) a;
                int64_t bs = (int64_t) b;
                flags = 0;
                if (a == b) {
                    flags |= FLAG_EQUAL;
                } else if (as > bs) {
                    flags |= FLAG_GREATER;
                } else if (as < bs) {
                    flags |= FLAG_LESS;
                }
                if (a == 0) {
                    flags |= FLAG_ZERO;
                }
                if (as < 0) {
                    flags |= FLAG_NEGATIVE;
                }
                break;
            }

            case opcode_add: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint16_t value = readUint16((uint8_t*) pc + 1);
                pc += 3;
                registers[reg1].asInteger += value;
                break;
            }

            case opcode_sub: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint16_t value = readUint16((uint8_t*) pc + 1);
                pc += 3;
                registers[reg1].asInteger -= value;
                break;
            }

            case opcode_mul: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint16_t value = readUint16((uint8_t*) pc + 1);
                pc += 3;
                registers[reg1].asInteger *= value;
                break;
            }

            case opcode_div: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint16_t value = readUint16((uint8_t*) pc + 1);
                pc += 3;
                registers[reg1].asInteger /= value;
                break;
            }

            case opcode_mod: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint16_t value = readUint16((uint8_t*) pc + 1);
                pc += 3;
                registers[reg1].asInteger %= value;
                break;
            }

            case opcode_and: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint16_t value = readUint16((uint8_t*) pc + 1);
                pc += 3;
                registers[reg1].asInteger &= value;
                break;
            }

            case opcode_or: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint16_t value = readUint16((uint8_t*) pc + 1);
                pc += 3;
                registers[reg1].asInteger |= value;
                break;
            }

            case opcode_xor: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint16_t value = readUint16((uint8_t*) pc + 1);
                pc += 3;
                registers[reg1].asInteger ^= value;
                break;
            }

            case opcode_shl: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint16_t value = readUint16((uint8_t*) pc + 1);
                pc += 3;
                registers[reg1].asInteger <<= value;
                break;
            }

            case opcode_shr: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint16_t value = readUint16((uint8_t*) pc + 1);
                pc += 3;
                registers[reg1].asInteger >>= value;
                break;
            }

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }

            break;
        }

        case 4: {
            switch (opcode) {
            case opcode_ldr: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                int16_t offset = (int16_t) readUint16((uint8_t*) pc + 2);
                pc += 4;
                registers[reg1].asInteger = *(uint64_t*) (registers[reg2].asPointer + offset);
                break;
            }

            case opcode_b: {
                uint32_t offset = readUint32((uint8_t*) pc);
                pc += 4;
                pc = (data + offset);
                break;
            }

            case opcode_bne: {
                uint32_t offset = readUint32((uint8_t*) pc);
                pc += 4;
                if (!(flags & FLAG_EQUAL)) {
                    pc = (data + offset);
                }
                break;
            }

            case opcode_beq: {
                uint32_t offset = readUint32((uint8_t*) pc);
                pc += 4;
                if (flags & FLAG_EQUAL) {
                    pc = (data + offset);
                }
                break;
            }

            case opcode_bgt: {
                uint32_t offset = readUint32((uint8_t*) pc);
                pc += 4;
                if (flags & FLAG_GREATER) {
                    pc = (data + offset);
                }
                break;
            }

            case opcode_blt: {
                uint32_t offset = readUint32((uint8_t*) pc);
                pc += 4;
                if (flags & FLAG_LESS) {
                    pc = (data + offset);
                }
                break;
            }

            case opcode_bge: {
                uint32_t offset = readUint32((uint8_t*) pc);
                pc += 4;
                if (flags & (FLAG_GREATER | FLAG_EQUAL)) {
                    pc = (data + offset);
                }
                break;
            }

            case opcode_ble: {
                uint32_t offset = readUint32((uint8_t*) pc);
                pc += 4;
                if (flags & (FLAG_LESS | FLAG_EQUAL)) {
                    pc = (data + offset);
                }
                break;
            }

            case opcode_bnz: {
                uint32_t offset = readUint32((uint8_t*) pc);
                pc += 4;
                if (!(flags & FLAG_ZERO)) {
                    pc = (data + offset);
                }
                break;
            }

            case opcode_bz: {
                uint32_t offset = readUint32((uint8_t*) pc);
                pc += 4;
                if (flags & FLAG_ZERO) {
                    pc = (data + offset);
                }
                break;
            }

            case opcode_psh: {
                uint32_t value = readUint32((uint8_t*) pc);
                pc += 4;
                *(uint64_t*) (sp++) = (data + value);
                break;
            }

            case opcode_pp: {
                uint32_t value = readUint32((uint8_t*) pc);
                pc += 4;
                *(uint64_t*) (data + value) = *(uint64_t*) (--sp);
            }

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }

            break;
        }

        case 5: {
            switch (opcode) {
            case opcode_ldr: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint32_t offset = readUint32((uint8_t*) pc + 1);
                pc += 5;
                registers[reg1].asInteger = *(uint64_t*) (data + offset);
                break;
            }

            case opcode_ldr_addr: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint32_t offset = readUint32((uint8_t*) pc + 1);
                pc += 5;
                registers[reg1].asPointer = (data + offset);
                break;
            }

            case opcode_mov: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t nbytes = readUint8((uint8_t*) pc + 1);
                int16_t offset = (int16_t) readUint16((uint8_t*) pc + 2);
                uint8_t reg2 = readUint8((uint8_t*) pc + 4);
                pc += 5;
                char* ptr = registers[reg2].asPointer + offset;
                registers[reg1].asInteger = 0;
                for (uint8_t n = 0; n < nbytes; n++) {
                    registers[reg1].asInteger |= ((uint64_t) ptr[n]) << (n * 8);
                }
                break;
            }

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }

            break;
        }

        case 6: {
            switch (opcode) {
            case opcode_ldr: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t reg2 = readUint8((uint8_t*) pc + 1);
                uint32_t offset = readUint32((uint8_t*) pc + 2);
                pc += 6;
                registers[reg1].asInteger = *(uint64_t*) (data + offset + registers[reg2].asSignedInteger);
                break;
            }

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }

            break;
        }

        case 7: {
            switch (opcode) {
            case opcode_ldr: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                int16_t off2 = (int16_t) readUint16((uint8_t*) pc + 1);
                uint32_t offset = readUint32((uint8_t*) pc + 3);
                pc += 7;
                registers[reg1].asInteger = *(uint64_t*) (data + offset + off2);
                break;
            }

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }

            break;
        }

        case 8: {
            switch (opcode) {
            case opcode_psh: {
                uint64_t value = readUint64((uint8_t*) pc);
                pc += 8;
                *(uint64_t*) (sp++) = value;
                break;
            }

            case opcode_mov: {
                uint8_t reg1 = readUint8((uint8_t*) pc);
                uint8_t nbytes = readUint8((uint8_t*) pc + 1);
                int16_t offset = (int16_t) readUint16((uint8_t*) pc + 2);
                uint32_t value = readUint32((uint8_t*) pc + 4);
                pc += 8;
                char* ptr = (data + value + offset);
                registers[reg1].asInteger = 0;
                for (uint8_t n = 0; n < nbytes; n++) {
                    registers[reg1].asInteger |= ((uint64_t) ptr[n]) << (n * 8);
                }
                break;
            }

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }

            break;
        }

        case 9: {
            switch (opcode) {
            case opcode_ldr: {
                uint8_t reg = readUint8((uint8_t*) pc);
                uint64_t value = readUint64((uint8_t*) pc + 1);
                pc += 9;
                registers[reg].asInteger = value;
                break;
            }

            case opcode_str: {
                uint8_t reg = readUint8((uint8_t*) pc);
                uint64_t value = readUint64((uint8_t*) pc + 1);
                pc += 9;
                *(uint64_t*) (registers[reg].asPointer) = value;
                break;
            }

            case opcode_cmp: {
                uint8_t reg = readUint8((uint8_t*) pc);
                uint64_t a = registers[reg].asInteger;
                uint64_t b = readUint64((uint8_t*) pc + 1);
                pc += 9;
                int64_t as = (int64_t) a;
                int64_t bs = (int64_t) b;
                flags = 0;
                if (a == b) {
                    flags |= FLAG_EQUAL;
                } else if (as > bs) {
                    flags |= FLAG_GREATER;
                } else if (as < bs) {
                    flags |= FLAG_LESS;
                }
                if (a == 0) {
                    flags |= FLAG_ZERO;
                }
                if (as < 0) {
                    flags |= FLAG_NEGATIVE;
                }
                break;
            }

            case opcode_add: {
                uint8_t reg = readUint8((uint8_t*) pc);
                uint64_t value = readUint64((uint8_t*) pc + 1);
                pc += 9;
                registers[reg].asInteger += value;
                break;
            }

            case opcode_sub: {
                uint8_t reg = readUint8((uint8_t*) pc);
                uint64_t value = readUint64((uint8_t*) pc + 1);
                pc += 9;
                registers[reg].asInteger -= value;
                break;
            }

            case opcode_mul: {
                uint8_t reg = readUint8((uint8_t*) pc);
                uint64_t value = readUint64((uint8_t*) pc + 1);
                pc += 9;
                registers[reg].asInteger *= value;
                break;
            }

            case opcode_div: {
                uint8_t reg = readUint8((uint8_t*) pc);
                uint64_t value = readUint64((uint8_t*) pc + 1);
                pc += 9;
                registers[reg].asInteger /= value;
                break;
            }

            case opcode_mod: {
                uint8_t reg = readUint8((uint8_t*) pc);
                uint64_t value = readUint64((uint8_t*) pc + 1);
                pc += 9;
                registers[reg].asInteger %= value;
                break;
            }

            case opcode_and: {
                uint8_t reg = readUint8((uint8_t*) pc);
                uint64_t value = readUint64((uint8_t*) pc + 1);
                pc += 9;
                registers[reg].asInteger &= value;
                break;
            }

            case opcode_or: {
                uint8_t reg = readUint8((uint8_t*) pc);
                uint64_t value = readUint64((uint8_t*) pc + 1);
                pc += 9;
                registers[reg].asInteger |= value;
                break;
            }

            case opcode_xor: {
                uint8_t reg = readUint8((uint8_t*) pc);
                uint64_t value = readUint64((uint8_t*) pc + 1);
                pc += 9;
                registers[reg].asInteger ^= value;
                break;
            }

            case opcode_shl: {
                uint8_t reg = readUint8((uint8_t*) pc);
                uint64_t value = readUint64((uint8_t*) pc + 1);
                pc += 9;
                registers[reg].asInteger <<= value;
                break;
            }

            case opcode_shr: {
                uint8_t reg = readUint8((uint8_t*) pc);
                uint64_t value = readUint64((uint8_t*) pc + 1);
                pc += 9;
                registers[reg].asInteger >>= value;
                break;
            }

            default:
                printf("Unknown instruction: %02x\n", op);
                break;
            }

            break;
        }

        default:
            printf("Unknown instruction: %02x\n", op);
            break;
        }
    }
}

size_t symbol_size(symbol* sym) {
    return sizeof(uint8_t) + sizeof(uint16_t) + strlen((char*) sym->name) + sizeof(uint32_t);
}

int add_symbol(object_file* obj, char* name) {
    obj->symbols = realloc(obj->symbols, sizeof(symbol) * (obj->symbols_size + 1));

    symbol* sym = &obj->symbols[obj->symbols_size];
    sym->name = (int8_t*) name;

    sym->offset = obj->comp_size;

    printf("symbol %s at %llu\n", name, sym->offset);

    obj->symbols_size++;
    return 0;
}

uint64_t symbol_offset(object_file* obj, const char* name) {
    for (uint32_t i = 0; i < obj->symbols_size; i++) {
        if (strcmp((char*) obj->symbols[i].name, name) == 0) {
            return obj->symbols[i].offset;
        }
    }

    return 0;
}

object_file* create_object() {
    object_file* obj = malloc(sizeof(object_file));
    obj->magic = 0xFEEDF00D;
    obj->data_capacity = 64;
    obj->data = malloc(obj->data_capacity);
    obj->data_size = 0;

    // compiler info
    obj->symbols = NULL;
    obj->symbols_size = 0;

    return obj;
}

object_file* run_compile(const char* file_name);

void sig_handler(int sig) {
    void* callstack[1024];
	int frames = backtrace(callstack, 1024);
    if (pc) {
        printf("Last instruction: %02x%02x%02x%02x\n", *(uint8_t*) (pc - 4), *(uint8_t*) (pc - 3), *(uint8_t*) (pc - 2), *(uint8_t*) (pc - 1));
    }
    printf("Signal %d\n", sig);
    dump_registers();
	write(STDERR_FILENO, "Backtrace:\n", 11);
	backtrace_symbols_fd(callstack, frames, STDERR_FILENO);
	write(STDERR_FILENO, "\n", 1);
    exit(1);
}

int main(int argc, char **argv) {
    signal(SIGSEGV, sig_handler);
    signal(SIGILL, sig_handler);
    signal(SIGFPE, sig_handler);
    signal(SIGABRT, sig_handler);

    if (argc < 3) {
        fprintf(stderr, "Usage: %s run <objfile>\n", argv[0]);
        fprintf(stderr, "       %s comp <srcfile> <objfile>\n", argv[0]);
        return 1;
    }
    if (strcmp(argv[1], "comp") == 0) {
        if (argc < 4) {
            fprintf(stderr, "Usage: %s comp <srcfile> <objfile>\n", argv[0]);
            return 1;
        }
        write_object_file(run_compile(argv[2]), argv[3]);
        return 0;
    } else if (strcmp(argv[1], "run") == 0) {
        object_file* obj = read_object_file(argv[2]);

        bp = sp = malloc(sizeof(uint64_t) * 1024);
        registers[0].asInteger = argc - 2;
        registers[1].asInteger = (uint64_t) (argv + 2);

        exec(obj->data);
        return registers[0].asInteger;
    } else {
        fprintf(stderr, "Unknown command '%s'\n", argv[1]);
        return 1;
    }
}
