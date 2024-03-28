# The Hive 64 Architecture
## Data type sizes
|Name|Size in bits|Appropriate type in C|
|-|-|-|
|byte|`8`|`char`|
|word|`16`|`short`|
|doubleword|`32`|`int`|
|quadword|`64`|`long long int`|
|longword|`128`|Standard C does not specify an integer type of longword size|
|single precision float|`32`|`float`|
|double precision float|`64`|`double`|

## Registers
Hive64 has 32 general purpose/scalar registers.
All scalar registers have a size of 64 bits.
These registers can hold both integers and floating point numbers.
Of the 32 registers 3 are reserved for special use:
- `r29`: The link register
- `r30`: The stack pointer
- `r31`: The program counter

Hive64 has 16 vector registers.
All vector registers have a size of 256 bits.
They can be accessed as:
- 32 byte sized elements
- 16 word sized elements
- 8 doubleword sized elements
- 4 quadword sized elements
- 2 longword sized elements
- 8 single precision float elements
- 4 double precision float elements
Additionally, vector instructions also allow operations on just the first quadword element.

Vector instruction mnemonics differentiate between the element type by a prefix.
|Instruction starting with|Element type|
|-|-|
|`vb`|byte|
|`vw`|word|
|`vd`|doubleword|
|`vq`|quadword|
|`vl`|longword|
|`vs`|single precision float|
|`vf`|double precision float|
|`vo`|first quadword|

## Instructions
Instructions are encoded as 32-bit values, and every instruction is conditional.

### Instruction encoding description
- `[]`: all bits in brackets belong to some argument
- `.`: this bit is ignored by the instruction
- `ccc`: specifies under which condition the instruction should execute

|Condition|Bit value|
|-|-|
|`eq`|`000`|
|`le`|`001`|
|`lt`|`010`|
|`always`|`011`|
|`ne`|`100`|
|`gt`|`101`|
|`ge`|`110`|
|`never`|`111`|

Every condition except `always` and `never` can be specified in the assembler by putting `.` followed by the condition after the instruction mnemonic.

### List of instructions
- [Branches](#branches)
- [Integer Arithmetic](#integer-arithmetic)
- [Floating point Arithmetic](#floating-point-arithmetic)
- [Utility](#utility)
- [Data transfer](#data-transfer)
- [Vector Operations](#vector-operations)

### Branches
|Mnemonic|Encoding|Description|
|-|-|-|
|`ret`|                     `ccc01100001111111101000100000000`|Returns from a subroutine|
|`b offset`|                `ccc0000[---------imm25---------]`|Branches to an address|
|`bl offset`|               `ccc0001[---------imm25---------]`|Branches to a subroutine|
|`br r1`|                   `ccc0010[r1-]....................`|Branches to a register value|
|`blr r1`|                  `ccc0011[r1-]....................`|Branches and links to a register value|

### Integer Arithmetic
#### Register and Immediate value
|Mnemonic|Encoding|Description|
|-|-|-|
|`add r1, r2, imm`|         `ccc0100000[r1-][r2-]0001[-imm8-]`|Adds r2 and an immediate and stores the result in r1|
|`sub r1, r2, imm`|         `ccc0100010[r1-][r2-]0001[-imm8-]`|Subtracts an immediate from r2 and stores the result in r1|
|`cmp r1, imm`|             `ccc0100011.....[r2-]0001[-imm8-]`|Compares r1 and an immediate by calculating the difference of the two values|
|`mul r1, r2, imm`|         `ccc0100100[r1-][r2-]0001[-imm8-]`|Multiplies r2 and an immediate and stores the result in r1|
|`div r1, r2, imm`|         `ccc0100110[r1-][r2-]0001[-imm8-]`|Divides r2 by an immediate and stores the result in r1|
|`sdiv r1, r2, imm`         `ccc0100110[r1-][r2-]0011[-imm8-]`|Divides r2 by an immediate and stores the result in r1|
|`mod r1, r2, imm`|         `ccc0101000[r1-][r2-]0001[-imm8-]`|Calculates the remainder of the division of r2 and an immediate and stores it in r1|
|`smod r1, r2, imm`         `ccc0101000[r1-][r2-]0011[-imm8-]`|Calculates the remainder of the division of r2 and an immediate and stores it in r1|
|`and r1, r2, imm`|         `ccc0101010[r1-][r2-]0001[-imm8-]`|Ands r2 and an immediate and stores the result in r1|
|`tst r1, imm`|             `ccc0101011.....[r2-]0001[-imm8-]`|Compares r1 and an immediate by anding the two values|
|`or r1, r2, imm`|          `ccc0101100[r1-][r2-]0001[-imm8-]`|Ors r2 and an immediate and stores the result in r1|
|`xor r1, r2, imm`|         `ccc0101110[r1-][r2-]0001[-imm8-]`|Xors r2 and an immediate and stores the result in r1|
|`shl r1, r2, imm`|         `ccc0110000[r1-][r2-]0001[-imm8-]`|Shifts r2 left by an immediate and stores the result in r1|
|`shr r1, r2, imm`|         `ccc0110010[r1-][r2-]0001[-imm8-]`|Shifts r2 right by an immediate and stores the result in r1|
|`rol r1, r2, imm`|         `ccc0110100[r1-][r2-]0001[-imm8-]`|Rotates r2 left by an immediate and stores the result in r1|
|`ror r1, r2, imm`|         `ccc0110110[r1-][r2-]0001[-imm8-]`|Rotates r2 right by an immediate and stores the result in r1|
|`asr r1, r2, imm`|         `ccc0111100[r1-][r2-]0001[-imm8-]`|Arithmetically shifts r2 right by an immediate and stores the result in r1|

#### Register and Register
|Mnemonic|Encoding|Description|
|-|-|-|
|`add r1, r2, r3`|          `ccc0100000[r1-][r2-]0000...[r3-]`|Adds r2 and r3 and stores the result in r1|
|`sub r1, r2, r3`|          `ccc0100010[r1-][r2-]0000...[r3-]`|Subtracts r3 from r2 and stores the result in r1|
|`cmp r1, r2`|              `ccc0100011.....[r2-]0000...[r3-]`|Compares r1 and r2 by calculating the difference of the two values|
|`mul r1, r2, r3`|          `ccc0100100[r1-][r2-]0000...[r3-]`|Multiplies r2 and r3 and stores the result in r1|
|`div r1, r2, r3`|          `ccc0100110[r1-][r2-]0000...[r3-]`|Divides r2 by r3 and stores the result in r1|
|`sdiv r1, r2, r3`|         `ccc0100110[r1-][r2-]0010...[r3-]`|Divides r2 by r3 and stores the result in r1|
|`mod r1, r2, r3`|          `ccc0101000[r1-][r2-]0000...[r3-]`|Calculates the remainder of the division of r2 and r3 and stores it in r1|
|`smod r1, r2, r3`|         `ccc0101000[r1-][r2-]0010...[r3-]`|Calculates the remainder of the division of r2 and r3 and stores it in r1|
|`and r1, r2, r3`|          `ccc0101010[r1-][r2-]0000...[r3-]`|Ands r2 and r3 and stores the result in r1|
|`tst r1, r2`|              `ccc0101011.....[r2-]0000...[r3-]`|Compares r1 and r2 by anding the two values|
|`or r1, r2, r3`|           `ccc0101100[r1-][r2-]0000...[r3-]`|Ors r2 and r3 and stores the result in r1|
|`xor r1, r2, r3`|          `ccc0101110[r1-][r2-]0000...[r3-]`|Xors r2 and r3 and stores the result in r1|
|`shl r1, r2, r3`|          `ccc0110000[r1-][r2-]0000...[r3-]`|Shifts r2 left by r3 and stores the result in r1|
|`shr r1, r2, r3`|          `ccc0110010[r1-][r2-]0000...[r3-]`|Shifts r2 right by r3 and stores the result in r1|
|`rol r1, r2, r3`|          `ccc0110100[r1-][r2-]0000...[r3-]`|Rotates r2 left by r3 and stores the result in r1|
|`ror r1, r2, r3`|          `ccc0110110[r1-][r2-]0000...[r3-]`|Rotates r2 right by r3 and stores the result in r1|
|`neg r1, r2`|              `ccc0111000[r1-][r2-]0000........`|Stores the negative value of r2 in r1|
|`not r1, r2`|              `ccc0111010[r1-][r2-]0000........`|Stores the bitwise not of r2 in r1|
|`asr r1, r2, r3`|          `ccc0111100[r1-][r2-]0000...[r3-]`|Arithmetically shifts r2 right by r3 and stores the result in r1|
|`swe r1, r2`|              `ccc0111110[r1-][r2-]0000........`|Switches all bytes in r2 and stores the result in r1|
|`extbw r1, r2`|            `ccc1100010[r1-][r2-]........0100`|Sign extends the signed byte in r2 to signed word and stores it in r1|
|`extbd r1, r2`|            `ccc1100010[r1-][r2-]........1000`|Sign extends the signed byte in r2 to signed doubleword and stores it in r1|
|`extbq r1, r2`|            `ccc1100010[r1-][r2-]........1100`|Sign extends the signed byte in r2 to signed quadword and stores it in r1|
|`extwd r1, r2`|            `ccc1100010[r1-][r2-]........1001`|Sign extends the signed word in r2 to signed doubleword and stores it in r1|
|`extwq r1, r2`|            `ccc1100010[r1-][r2-]........1101`|Sign extends the signed word in r2 to signed quadword and stores it in r1|
|`extdq r1, r2`|            `ccc1100010[r1-][r2-]........1110`|Sign extends the signed doubleword in r2 to signed quadword and stores it in r1|

### Floating point Arithmetic
|Mnemonic|Encoding|Description|
|-|-|-|
|`fadd r1, r2, r3`|         `ccc0100000[r1-][r2-]100000.[r3-]`|Adds 64-bit float in r2 and r3 and stores the result in r1|
|`faddi r1, r2, r3`|        `ccc0100000[r1-][r2-]100010.[r3-]`|Adds 64-bit float in r2 and integer in r3 and stores the result in r1|
|`fsub r1, r2, r3`|         `ccc0100010[r1-][r2-]100000.[r3-]`|Subtracts 64-bit float in r2 from r3 and stores the result in r1|
|`fsubi r1, r2, r3`|        `ccc0100010[r1-][r2-]100010.[r3-]`|Subtracts 64-bit float in r2 from integer in r3 and stores the result in r1|
|`fcmp r2, r3`|             `ccc0100011.....[r2-]100000.[r3-]`|Compares 64-bit float in r2 and r1 by calculating the difference of the two values|
|`fcmpi r2, r3`|            `ccc0100011.....[r2-]100010.[r3-]`|Compares 64-bit float in r2 and integer in r1 by calculating the difference of the two values|
|`fmul r1, r2, r3`|         `ccc0100100[r1-][r2-]100000.[r3-]`|Multiplies 64-bit float in r2 and r3 and stores the result in r1|
|`fmuli r1, r2, r3`|        `ccc0100100[r1-][r2-]100010.[r3-]`|Multiplies 64-bit float in r2 and integer in r3 and stores the result in r1|
|`fdiv r1, r2, r3`|         `ccc0100110[r1-][r2-]100000.[r3-]`|Divides 64-bit float in r2 by r3 and stores the result in r1|
|`fdivi r1, r2, r3`|        `ccc0100110[r1-][r2-]100010.[r3-]`|Divides 64-bit float in r2 by integer in r3 and stores the result in r1|
|`fmod r1, r2, r3`|         `ccc0101000[r1-][r2-]100000.[r3-]`|Calculates the 64-bit floating point remainder of dividing 64-bit float in r2 by r3 and stores it in r1|
|`fmodi r1, r2, r3`|        `ccc0101000[r1-][r2-]100010.[r3-]`|Calculates the 64-bit floating point remainder of dividing 64-bit float in r2 by integer in r3 and stores it in r1|
|`fsin r1, r2`|             `ccc0101010[r1-][r2-]100000......`|Calculates the sin of 64-bit float in r2 and stores it in r1|
|`fsqrt r1, r2`|            `ccc0101100[r1-][r2-]100010......`|Calculates the sqare root of 64-bit float in r2 and stores it in r1|
|`f2i r1, r2`|              `ccc0101110[r1-][r2-]100000......`|Converts the 64-bit float in r2 to an integer and stores it in r1|
|`i2f r1, r2`|              `ccc0101110[r1-][r2-]100010......`|Converts the integer in r2 to a 64-bit float and stores it in r1|
|`sadd r1, r2, r3`|         `ccc0100000[r1-][r2-]100001.[r3-]`|Adds 32-bit float in r2 and r3 and stores the result in r1|
|`saddi r1, r2, r3`|        `ccc0100000[r1-][r2-]100011.[r3-]`|Adds 32-bit float in r2 and integer in r3 and stores the result in r1|
|`ssub r1, r2, r3`|         `ccc0100010[r1-][r2-]100001.[r3-]`|Subtracts 32-bit float in r2 from r3 and stores the result in r1|
|`ssubi r1, r2, r3`|        `ccc0100010[r1-][r2-]100011.[r3-]`|Subtracts 32-bit float in r2 from integer in r3 and stores the result in r1|
|`scmp r2, r3`|             `ccc0100011.....[r2-]100001.[r3-]`|Compares 32-bit float in r2 and r1 by calculating the difference of the two values|
|`scmpi r2, r3`|            `ccc0100011.....[r2-]100011.[r3-]`|Compares 32-bit float in r2 and integer in r1 by calculating the difference of the two values|
|`smul r1, r2, r3`|         `ccc0100100[r1-][r2-]100001.[r3-]`|Multiplies 32-bit float in r2 and r3 and stores the result in r1|
|`smuli r1, r2, r3`|        `ccc0100100[r1-][r2-]100011.[r3-]`|Multiplies 32-bit float in r2 and integer in r3 and stores the result in r1|
|`sdiv r1, r2, r3`|         `ccc0100110[r1-][r2-]100001.[r3-]`|Divides 32-bit float in r2 by r3 and stores the result in r1|
|`sdivi r1, r2, r3`|        `ccc0100110[r1-][r2-]100011.[r3-]`|Divides 32-bit float in r2 by integer in r3 and stores the result in r1|
|`smod r1, r2, r3`|         `ccc0101000[r1-][r2-]100001.[r3-]`|Calculates the 32-bit floating point remainder of dividing 32-bit float in r2 by r3 and stores it in r1|
|`smodi r1, r2, r3`|        `ccc0101000[r1-][r2-]100011.[r3-]`|Calculates the 32-bit floating point remainder of dividing 32-bit float in r2 by integer in r3 and stores it in r1|
|`ssin r1, r2`|             `ccc0101010[r1-][r2-]100001......`|Calculates the sin of 32-bit float in r2 and stores it in r1|
|`ssqrt r1, r2`|            `ccc0101100[r1-][r2-]100011......`|Calculates the sqare root of 32-bit float in r2 and stores it in r1|
|`s2i r1, r2`|              `ccc0101110[r1-][r2-]100001......`|Converts the 32-bit float in r2 to an integer and stores it in r1|
|`i2s r1, r2`|              `ccc0101110[r1-][r2-]100011......`|Converts the integer in r2 to a 32-bit float and stores it in r1|
|`s2f r1, r2`|              `ccc0101110[r1-][r2-]100000......`|Converts the 32-bit float in r2 to a 64-bit float and stores it in r1|
|`f2s r1, r2`|              `ccc0101110[r1-][r2-]100001......`|Converts the 64-bit float in r2 to a 32-bit float and stores it in r1|

### Utility
|Mnemonic|Encoding|Description|
|-|-|-|
|`svc`|                     `ccc1010.........................`|Supervisor call|
|`cpuid`|                   `ccc110000000000.................`|Returns information about the cpu (See [`cpuid`](#cpuid-instruction))|

### Size Prefixes
|Mnemonic|Encoding|Description|
|`byte` prefix|             `ccc1100001....................00`|Overrides the operand size of arithmetic instructions and [`ldr`/`str`-with-offset](#data-transfer) to 8 bits|
|`word` prefix|             `ccc1100001....................01`|Overrides the operand size of arithmetic instructions and [`ldr`/`str`-with-offset](#data-transfer) to 16 bits|
|`dword` prefix|            `ccc1100001....................10`|Overrides the operand size of arithmetic instructions and [`ldr`/`str`-with-offset](#data-transfer) to 32 bits|
|`qword` prefix|            `ccc1100001....................11`|Overrides the operand size of arithmetic instructions and [`ldr`/`str`-with-offset](#data-transfer) to 64 bits (default)|

### Data transfer
|Mnemonic|Encoding|Description|
|-|-|-|
|`mov r1, r2`|              `ccc0110000[r1-][r2-]000100000000`|Moves the value in r2 to r1 (`shl r1, r2, 0`)|
|`lea r1, offset`|          `ccc1000[r1-][-------imm20------]`|Loads the effective address of offset into r1|
|`movz r1, imm`|            `ccc1001[r1-].000[-----imm16----]`|Clears r1 and moves the 16-bit immediate value into the 1st 16-bit window of r1|
|`movz r1, imm, shl 16`|    `ccc1001[r1-].001[-----imm16----]`|Clears r1 and moves the 16-bit immediate value into the 2nd 16-bit window of r1|
|`movz r1, imm, shl 32`|    `ccc1001[r1-].010[-----imm16----]`|Clears r1 and moves the 16-bit immediate value into the 3rd 16-bit window of r1|
|`movz r1, imm, shl 48`|    `ccc1001[r1-].011[-----imm16----]`|Clears r1 and moves the 16-bit immediate value into the 4th 16-bit window of r1|
|`movk r1, imm`|            `ccc1001[r1-].100[-----imm16----]`|Moves the 16-bit immediate value into the 1st 16-bit window of r1. Only clears the affected 16-bit window|
|`movk r1, imm, shl 16`|    `ccc1001[r1-].101[-----imm16----]`|Moves the 16-bit immediate value into the 2nd 16-bit window of r1. Only clears the affected 16-bit window|
|`movk r1, imm, shl 32`|    `ccc1001[r1-].110[-----imm16----]`|Moves the 16-bit immediate value into the 3rd 16-bit window of r1. Only clears the affected 16-bit window|
|`movk r1, imm, shl 48`|    `ccc1001[r1-].111[-----imm16----]`|Moves the 16-bit immediate value into the 4th 16-bit window of r1. Only clears the affected 16-bit window|
|`ldr r1, [r2, imm]`|       `ccc0110110[r1-][r2-]0110[-imm8-]`|Loads a quadword from memory address r2 + immediate into r1|
|`ldr r1, [r2, imm]!`|      `ccc0110111[r1-][r2-]0110[-imm8-]`|Loads a quadword from memory address r2 into r1 and adds imm to r2|
|`ldrd r1, [r2, imm]`|      `ccc0110100[r1-][r2-]0110[-imm8-]`|Loads a doubleword from memory address r2 + immediate into r1|
|`ldrd r1, [r2, imm]!`|     `ccc0110101[r1-][r2-]0110[-imm8-]`|Loads a doubleword from memory address r2 into r1 and adds imm to r2|
|`ldrw r1, [r2, imm]`|      `ccc0110010[r1-][r2-]0110[-imm8-]`|Loads a word from memory address r2 + immediate into r1|
|`ldrw r1, [r2, imm]!`|     `ccc0110011[r1-][r2-]0110[-imm8-]`|Loads a word from memory address r2 into r1 and adds imm to r2|
|`ldrb r1, [r2, imm]`|      `ccc0110000[r1-][r2-]0110[-imm8-]`|Loads a byte from memory address r2 + immediate into r1|
|`ldrb r1, [r2, imm]!`|     `ccc0110001[r1-][r2-]0110[-imm8-]`|Loads a byte from memory address r2 into r1 and adds imm to r2|
|`str r1, [r2, imm]`|       `ccc0111110[r1-][r2-]0110[-imm8-]`|Stores a quadword from r1 to memory address r2 + immediate|
|`str r1, [r2, imm]!`|      `ccc0111111[r1-][r2-]0110[-imm8-]`|Adds the immediate to r2 and stores a quadword from r1 to memory address now in r2|
|`strd r1, [r2, imm]`|      `ccc0111100[r1-][r2-]0110[-imm8-]`|Stores a doubleword from r1 to memory address r2 + immediate|
|`strd r1, [r2, imm]!`|     `ccc0111101[r1-][r2-]0110[-imm8-]`|Adds the immediate to r2 and stores a doubleword from r1 to memory address now in r2|
|`strw r1, [r2, imm]`|      `ccc0111010[r1-][r2-]0110[-imm8-]`|Stores a word from r1 to memory address r2 + immediate|
|`strw r1, [r2, imm]!`|     `ccc0111011[r1-][r2-]0110[-imm8-]`|Adds the immediate to r2 and stores a word from r1 to memory address now in r2|
|`strb r1, [r2, imm]`|      `ccc0111000[r1-][r2-]0110[-imm8-]`|Stores a byte from r1 to memory address r2 + immediate|
|`strb r1, [r2, imm]!`|     `ccc0111001[r1-][r2-]0110[-imm8-]`|Adds the immediate to r2 and stores a byte from r1 to memory address now in r2|
|`ldr r1, [r2, imm]`|       `ccc01L0110[r1-][r2-]0111SH[imm6]`|Loads a quadword from memory address r2 + (immediate << ((`L << 2 \| SH`) + 1)) into r1. Encoding should only be used when the immediate value does not fit into a signed byte|
|`ldr r1, [r2, imm]!`|      `ccc01L0111[r1-][r2-]0111SH[imm6]`|Loads a quadword from memory address r2 into r1 and adds (imm << ((`L << 2 \| SH`) + 1)) to r2. Encoding should only be used when the immediate value does not fit into a signed byte|
|`ldrd r1, [r2, imm]`|      `ccc01L0100[r1-][r2-]0111SH[imm6]`|Loads a doubleword from memory address r2 + (immediate << ((`L << 2 \| SH`) + 1)) into r1. Encoding should only be used when the immediate value does not fit into a signed byte|
|`ldrd r1, [r2, imm]!`|     `ccc01L0101[r1-][r2-]0111SH[imm6]`|Loads a doubleword from memory address r2 into r1 and adds (imm << ((`L << 2 \| SH`) + 1)) to r2. Encoding should only be used when the immediate value does not fit into a signed byte|
|`ldrw r1, [r2, imm]`|      `ccc01L0010[r1-][r2-]0111SH[imm6]`|Loads a word from memory address r2 + (immediate << ((`L << 2 \| SH`) + 1)) into r1. Encoding should only be used when the immediate value does not fit into a signed byte|
|`ldrw r1, [r2, imm]!`|     `ccc01L0011[r1-][r2-]0111SH[imm6]`|Loads a word from memory address r2 into r1 and adds (imm << ((`L << 2 \| SH`) + 1)) to r2. Encoding should only be used when the immediate value does not fit into a signed byte|
|`ldrb r1, [r2, imm]`|      `ccc01L0000[r1-][r2-]0111SH[imm6]`|Loads a byte from memory address r2 + (immediate << ((`L << 2 \| SH`) + 1)) into r1. Encoding should only be used when the immediate value does not fit into a signed byte|
|`ldrb r1, [r2, imm]!`|     `ccc01L0001[r1-][r2-]0111SH[imm6]`|Loads a byte from memory address r2 into r1 and adds (imm << ((`L << 2 \| SH`) + 1)) to r2. Encoding should only be used when the immediate value does not fit into a signed byte|
|`str r1, [r2, imm]`|       `ccc01L1110[r1-][r2-]0111SH[imm6]`|Stores a quadword from r1 to memory address r2 + (immediate << ((`L << 2 \| SH`) + 1)). Encoding should only be used when the immediate value does not fit into a signed byte|
|`str r1, [r2, imm]!`|      `ccc01L1111[r1-][r2-]0111SH[imm6]`|Adds the (immediate << ((`L << 2 \| SH`) + 1)) to r2 and stores a quadword from r1 to memory address now in r2. Encoding should only be used when the immediate value does not fit into a signed byte|
|`strd r1, [r2, imm]`|      `ccc01L1100[r1-][r2-]0111SH[imm6]`|Stores a doubleword from r1 to memory address r2 + (immediate << ((`L << 2 \| SH`) + 1)). Encoding should only be used when the immediate value does not fit into a signed byte|
|`strd r1, [r2, imm]!`|     `ccc01L1101[r1-][r2-]0111SH[imm6]`|Adds the (immediate << ((`L << 2 \| SH`) + 1)) to r2 and stores a doubleword from r1 to memory address now in r2. Encoding should only be used when the immediate value does not fit into a signed byte|
|`strw r1, [r2, imm]`|      `ccc01L1010[r1-][r2-]0111SH[imm6]`|Stores a word from r1 to memory address r2 + (immediate << ((`L << 2 \| SH`) + 1)). Encoding should only be used when the immediate value does not fit into a signed byte|
|`strw r1, [r2, imm]!`|     `ccc01L1011[r1-][r2-]0111SH[imm6]`|Adds the (immediate << ((`L << 2 \| SH`) + 1)) to r2 and stores a word from r1 to memory address now in r2. Encoding should only be used when the immediate value does not fit into a signed byte|
|`strb r1, [r2, imm]`|      `ccc01L1000[r1-][r2-]0111SH[imm6]`|Stores a byte from r1 to memory address r2 + (immediate << ((`L << 2 \| SH`) + 1)). Encoding should only be used when the immediate value does not fit into a signed byte|
|`strb r1, [r2, imm]!`|     `ccc01L1001[r1-][r2-]0111SH[imm6]`|Adds the (immediate << ((`L << 2 \| SH`) + 1)) to r2 and stores a byte from r1 to memory address now in r2. Encoding should only be used when the immediate value does not fit into a signed byte|
|`ubxt r1, r2, a, b`|       `ccc01[chi][r1-][r2-]01000l[strt]`|Extracts `(chi << 1 \| l)` bits starting at bit `strt` from register r2 and stores the value into r1|
|`sbxt r1, r2, a, b`|       `ccc01[chi][r1-][r2-]01001l[strt]`|Extracts `(chi << 1 \| l)` bits starting at bit `strt` from register r2 and stores the sign extended value into r1|
|`ubdp r1, r2, a, b`|       `ccc01[chi][r1-][r2-]0101.l[strt]`|Deposits the lowest `(chi << 1 \| l)` bits from r2 into r1 starting at bit `strt`|
|`ldr r1, [r2, r3]`|        `ccc0100110[r1-][r2-]0110...[r3-]`|Loads a quadword from memory address r2 + r3 into r1|
|`ldr r1, [r2, r3]!`|       `ccc0100111[r1-][r2-]0110...[r3-]`|Loads a quadword from memory address r2 into r1 and adds r3 to r2|
|`ldrd r1, [r2, r3]`|       `ccc0100100[r1-][r2-]0110...[r3-]`|Loads a doubleword from memory address r2 + r3 into r1|
|`ldrd r1, [r2, r3]!`|      `ccc0100101[r1-][r2-]0110...[r3-]`|Loads a doubleword from memory address r2 into r1 and adds r3 to r2|
|`ldrw r1, [r2, r3]`|       `ccc0100010[r1-][r2-]0110...[r3-]`|Loads a word from memory address r2 + r3 into r1|
|`ldrw r1, [r2, r3]!`|      `ccc0100011[r1-][r2-]0110...[r3-]`|Loads a word from memory address r2 into r1 and adds r3 to r2|
|`ldrb r1, [r2, r3]`|       `ccc0100000[r1-][r2-]0110...[r3-]`|Loads a byte from memory address r2 + r3 into r1|
|`ldrb r1, [r2, r3]!`|      `ccc0100001[r1-][r2-]0110...[r3-]`|Loads a byte from memory address r2 into r1 and adds r3 to r2|
|`str r1, [r2, r3]`|        `ccc0101110[r1-][r2-]0110...[r3-]`|Stores a quadword from r1 to memory address r2 + r3|
|`str r1, [r2, r3]!`|       `ccc0101111[r1-][r2-]0110...[r3-]`|Adds r3 to r2 and stores a quadword from r1 to memory address now in r2|
|`strd r1, [r2, r3]`|       `ccc0101100[r1-][r2-]0110...[r3-]`|Stores a doubleword from r1 to memory address r2 + r3|
|`strd r1, [r2, r3]!`|      `ccc0101101[r1-][r2-]0110...[r3-]`|Adds r3 to r2 and stores a doubleword from r1 to memory address now in r2|
|`strw r1, [r2, r3]`|       `ccc0101010[r1-][r2-]0110...[r3-]`|Stores a word from r1 to memory address r2 + r3|
|`strw r1, [r2, r3]!`|      `ccc0101011[r1-][r2-]0110...[r3-]`|Adds r3 to r2 and stores a word from r1 to memory address now in r2|
|`strb r1, [r2, r3]`|       `ccc0101000[r1-][r2-]0110...[r3-]`|Stores a byte from r1 to memory address r2 + r3|
|`strb r1, [r2, r3]!`|      `ccc0101001[r1-][r2-]0110...[r3-]`|Adds r3 to r2 and stores a byte from r1 to memory address now in r2|
|`ldr r1, [offset]`|        `ccc1011[r1-]0[------imm19------]`|Loads a quadword from memory address pc + offset into r1. This instruction supports size override prefixes|
|`str r1, [offset]`|        `ccc1011[r1-]1[------imm19------]`|Stores a quadword from r1 to memory address pc + offset. This instruction supports size override prefixes|

### Vector Operations
|Mnemonic|Encoding|Description|
|-|-|-|
|`vbadd v1, v2, v3`|        `ccc010000001[v2][v1]1001....[v3]`|Adds v2 and v3 and stores the result in v1|
|`voadd v1, v2, v3`|        `ccc010000000[v2][v1]1001....[v3]`|Adds v2 and v3 and stores the result in v1|
|`vwadd v1, v2, v3`|        `ccc010000010[v2][v1]1001....[v3]`|Adds v2 and v3 and stores the result in v1|
|`vdadd v1, v2, v3`|        `ccc010000011[v2][v1]1001....[v3]`|Adds v2 and v3 and stores the result in v1|
|`vqadd v1, v2, v3`|        `ccc010000100[v2][v1]1001....[v3]`|Adds v2 and v3 and stores the result in v1|
|`vladd v1, v2, v3`|        `ccc010000101[v2][v1]1001....[v3]`|Adds v2 and v3 and stores the result in v1|
|`vsadd v1, v2, v3`|        `ccc010000110[v2][v1]1001....[v3]`|Adds v2 and v3 and stores the result in v1|
|`vfadd v1, v2, v3`|        `ccc010000111[v2][v1]1001....[v3]`|Adds v2 and v3 and stores the result in v1|
|`vosub v1, v2, v3`|        `ccc010001000[v2][v1]1001....[v3]`|Subtracts v3 from v2 and stores the result in v1|
|`vbsub v1, v2, v3`|        `ccc010001001[v2][v1]1001....[v3]`|Subtracts v3 from v2 and stores the result in v1|
|`vwsub v1, v2, v3`|        `ccc010001010[v2][v1]1001....[v3]`|Subtracts v3 from v2 and stores the result in v1|
|`vdsub v1, v2, v3`|        `ccc010001011[v2][v1]1001....[v3]`|Subtracts v3 from v2 and stores the result in v1|
|`vqsub v1, v2, v3`|        `ccc010001100[v2][v1]1001....[v3]`|Subtracts v3 from v2 and stores the result in v1|
|`vlsub v1, v2, v3`|        `ccc010001101[v2][v1]1001....[v3]`|Subtracts v3 from v2 and stores the result in v1|
|`vssub v1, v2, v3`|        `ccc010001110[v2][v1]1001....[v3]`|Subtracts v3 from v2 and stores the result in v1|
|`vfsub v1, v2, v3`|        `ccc010001111[v2][v1]1001....[v3]`|Subtracts v3 from v2 and stores the result in v1|
|`vomul v1, v2, v3`|        `ccc010010000[v2][v1]1001....[v3]`|Multiplies v2 and v3 and stores the result in v1|
|`vbmul v1, v2, v3`|        `ccc010010001[v2][v1]1001....[v3]`|Multiplies v2 and v3 and stores the result in v1|
|`vwmul v1, v2, v3`|        `ccc010010010[v2][v1]1001....[v3]`|Multiplies v2 and v3 and stores the result in v1|
|`vdmul v1, v2, v3`|        `ccc010010011[v2][v1]1001....[v3]`|Multiplies v2 and v3 and stores the result in v1|
|`vqmul v1, v2, v3`|        `ccc010010100[v2][v1]1001....[v3]`|Multiplies v2 and v3 and stores the result in v1|
|`vlmul v1, v2, v3`|        `ccc010010101[v2][v1]1001....[v3]`|Multiplies v2 and v3 and stores the result in v1|
|`vsmul v1, v2, v3`|        `ccc010010110[v2][v1]1001....[v3]`|Multiplies v2 and v3 and stores the result in v1|
|`vfmul v1, v2, v3`|        `ccc010010111[v2][v1]1001....[v3]`|Multiplies v2 and v3 and stores the result in v1|
|`vodiv v1, v2, v3`|        `ccc010011000[v2][v1]1001....[v3]`|Divides v2 by v3 and stores the result in v1|
|`vbdiv v1, v2, v3`|        `ccc010011001[v2][v1]1001....[v3]`|Divides v2 by v3 and stores the result in v1|
|`vwdiv v1, v2, v3`|        `ccc010011010[v2][v1]1001....[v3]`|Divides v2 by v3 and stores the result in v1|
|`vddiv v1, v2, v3`|        `ccc010011011[v2][v1]1001....[v3]`|Divides v2 by v3 and stores the result in v1|
|`vqdiv v1, v2, v3`|        `ccc010011100[v2][v1]1001....[v3]`|Divides v2 by v3 and stores the result in v1|
|`vldiv v1, v2, v3`|        `ccc010011101[v2][v1]1001....[v3]`|Divides v2 by v3 and stores the result in v1|
|`vsdiv v1, v2, v3`|        `ccc010011110[v2][v1]1001....[v3]`|Divides v2 by v3 and stores the result in v1|
|`vfdiv v1, v2, v3`|        `ccc010011111[v2][v1]1001....[v3]`|Divides v2 by v3 and stores the result in v1|
|`voaddsub v1, v2, v3`|     `ccc010100000[v2][v1]1001....[v3]`|Adds even indexed elements in v2 and v3 and subtracts odd indexed elements in v2 and v3 and stores the result in v1|
|`vbaddsub v1, v2, v3`|     `ccc010100001[v2][v1]1001....[v3]`|Adds even indexed elements in v2 and v3 and subtracts odd indexed elements in v2 and v3 and stores the result in v1|
|`vwaddsub v1, v2, v3`|     `ccc010100010[v2][v1]1001....[v3]`|Adds even indexed elements in v2 and v3 and subtracts odd indexed elements in v2 and v3 and stores the result in v1|
|`vdaddsub v1, v2, v3`|     `ccc010100011[v2][v1]1001....[v3]`|Adds even indexed elements in v2 and v3 and subtracts odd indexed elements in v2 and v3 and stores the result in v1|
|`vqaddsub v1, v2, v3`|     `ccc010100100[v2][v1]1001....[v3]`|Adds even indexed elements in v2 and v3 and subtracts odd indexed elements in v2 and v3 and stores the result in v1|
|`vladdsub v1, v2, v3`|     `ccc010100101[v2][v1]1001....[v3]`|Adds even indexed elements in v2 and v3 and subtracts odd indexed elements in v2 and v3 and stores the result in v1|
|`vsaddsub v1, v2, v3`|     `ccc010100110[v2][v1]1001....[v3]`|Adds even indexed elements in v2 and v3 and subtracts odd indexed elements in v2 and v3 and stores the result in v1|
|`vfaddsub v1, v2, v3`|     `ccc010100111[v2][v1]1001....[v3]`|Adds even indexed elements in v2 and v3 and subtracts odd indexed elements in v2 and v3 and stores the result in v1|
|`vomadd v1, v2, v3`|       `ccc010101000[v2][v1]1001....[v3]`|Multiplies v2 and v3 and stores the sum of the results into the lowest element of v1|
|`vbmadd v1, v2, v3`|       `ccc010101001[v2][v1]1001....[v3]`|Multiplies v2 and v3 and stores the sum of the results into the lowest element of v1|
|`vwmadd v1, v2, v3`|       `ccc010101010[v2][v1]1001....[v3]`|Multiplies v2 and v3 and stores the sum of the results into the lowest element of v1|
|`vdmadd v1, v2, v3`|       `ccc010101011[v2][v1]1001....[v3]`|Multiplies v2 and v3 and stores the sum of the results into the lowest element of v1|
|`vqmadd v1, v2, v3`|       `ccc010101100[v2][v1]1001....[v3]`|Multiplies v2 and v3 and stores the sum of the results into the lowest element of v1|
|`vlmadd v1, v2, v3`|       `ccc010101101[v2][v1]1001....[v3]`|Multiplies v2 and v3 and stores the sum of the results into the lowest element of v1|
|`vsmadd v1, v2, v3`|       `ccc010101110[v2][v1]1001....[v3]`|Multiplies v2 and v3 and stores the sum of the results into the lowest element of v1|
|`vfmadd v1, v2, v3`|       `ccc010101111[v2][v1]1001....[v3]`|Multiplies v2 and v3 and stores the sum of the results into the lowest element of v1|
|`vomov v1, r2, at`|        `ccc010110000..hi[v1]1001slo[r2-]`|Moves r2 into the specified element of v1|
|`vbmov v1, r2, at`|        `ccc010110001..hi[v1]1001slo[r2-]`|Moves r2 into the specified element of v1|
|`vwmov v1, r2, at`|        `ccc010110010..hi[v1]1001slo[r2-]`|Moves r2 into the specified element of v1|
|`vdmov v1, r2, at`|        `ccc010110011..hi[v1]1001slo[r2-]`|Moves r2 into the specified element of v1|
|`vqmov v1, r2, at`|        `ccc010110100..hi[v1]1001slo[r2-]`|Moves r2 into the specified element of v1|
|`vlmov v1, r2, at`|        `ccc010110101..hi[v1]1001slo[r2-]`|Moves r2 into the specified element of v1|
|`vsmov v1, r2, at`|        `ccc010110110..hi[v1]1001slo[r2-]`|Moves r2 into the specified element of v1|
|`vfmov v1, r2, at`|        `ccc010110111..hi[v1]1001slo[r2-]`|Moves r2 into the specified element of v1|
|`vomov v1, v2`|            `ccc010111000[v2][v1]1001........`|Moves v2 to v1|
|`vbmov v1, v2`|            `ccc010111001[v2][v1]1001........`|Moves v2 to v1|
|`vwmov v1, v2`|            `ccc010111010[v2][v1]1001........`|Moves v2 to v1|
|`vdmov v1, v2`|            `ccc010111011[v2][v1]1001........`|Moves v2 to v1|
|`vqmov v1, v2`|            `ccc010111100[v2][v1]1001........`|Moves v2 to v1|
|`vlmov v1, v2`|            `ccc010111101[v2][v1]1001........`|Moves v2 to v1|
|`vsmov v1, v2`|            `ccc010111110[v2][v1]1001........`|Moves v2 to v1|
|`vfmov v1, v2`|            `ccc010111111[v2][v1]1001........`|Moves v2 to v1|
|`voconvT v1, v2`|          `ccc011000000[v2][v1]1001.....TTT`|Converts all elements in v2 [to another type](#vector-convert-instruction-encoding) and stores them in v1|
|`vbconvT v1, v2`|          `ccc011000001[v2][v1]1001.....TTT`|Converts all elements in v2 [to another type](#vector-convert-instruction-encoding) and stores them in v1|
|`vwconvT v1, v2`|          `ccc011000010[v2][v1]1001.....TTT`|Converts all elements in v2 [to another type](#vector-convert-instruction-encoding) and stores them in v1|
|`vdconvT v1, v2`|          `ccc011000011[v2][v1]1001.....TTT`|Converts all elements in v2 [to another type](#vector-convert-instruction-encoding) and stores them in v1|
|`vqconvT v1, v2`|          `ccc011000100[v2][v1]1001.....TTT`|Converts all elements in v2 [to another type](#vector-convert-instruction-encoding) and stores them in v1|
|`vlconvT v1, v2`|          `ccc011000101[v2][v1]1001.....TTT`|Converts all elements in v2 [to another type](#vector-convert-instruction-encoding) and stores them in v1|
|`vsconvT v1, v2`|          `ccc011000110[v2][v1]1001.....TTT`|Converts all elements in v2 [to another type](#vector-convert-instruction-encoding) and stores them in v1|
|`vfconvT v1, v2`|          `ccc011000111[v2][v1]1001.....TTT`|Converts all elements in v2 [to another type](#vector-convert-instruction-encoding) and stores them in v1|
|`volen r1, v2`|            `ccc011001000....[v1]1001...[r1-]`|Stores the index of the first element of value 0 in v1 into r1|
|`vblen r1, v2`|            `ccc011001001....[v1]1001...[r1-]`|Stores the index of the first element of value 0 in v1 into r1|
|`vwlen r1, v2`|            `ccc011001010....[v1]1001...[r1-]`|Stores the index of the first element of value 0 in v1 into r1|
|`vdlen r1, v2`|            `ccc011001011....[v1]1001...[r1-]`|Stores the index of the first element of value 0 in v1 into r1|
|`vqlen r1, v2`|            `ccc011001100....[v1]1001...[r1-]`|Stores the index of the first element of value 0 in v1 into r1|
|`vllen r1, v2`|            `ccc011001101....[v1]1001...[r1-]`|Stores the index of the first element of value 0 in v1 into r1|
|`vslen r1, v2`|            `ccc011001110....[v1]1001...[r1-]`|Stores the index of the first element of value 0 in v1 into r1|
|`vflen r1, v2`|            `ccc011001111....[v1]1001...[r1-]`|Stores the index of the first element of value 0 in v1 into r1|
|`vldr v1, [r2, imm]`|      `ccc01101010[r1-][v1]1001[-imm8-]`|Loads v1 with the value at address r1 + imm8|
|`vldr v1, [r2, imm]!`|     `ccc01101011[r1-][v1]1001[-imm8-]`|Loads v1 with the value at address r1 + imm8|
|`vstr v1, [r2, imm]`|      `ccc01101110[r1-][v1]1001[-imm8-]`|Stores v1 to the address r1 + imm8|
|`vstr v1, [r2, imm]!`|     `ccc01101111[r1-][v1]1001[-imm8-]`|Stores v1 to the address r1 + imm8|
|`vldr v1, [r2, r3]`|       `ccc01101000[r1-][v1]1001...[r2-]`|Loads v1 with the value at address r1 + r2|
|`vldr v1, [r2, r3]!`|      `ccc01101001[r1-][v1]1001...[r2-]`|Loads v1 with the value at address r1 + r2|
|`vstr v1, [r2, r3]`|       `ccc01101100[r1-][v1]1001...[r2-]`|Stores v1 to the address r1 + r2|
|`vstr v1, [r2, r3]!`|      `ccc01101101[r1-][v1]1001...[r2-]`|Stores v1 to the address r1 + r2|

#### Vector convert instruction encoding
`TTT` in the encoding specifies the target element type as follows:

|Element type|Encoding|
|-|-|
|first quadword|`000`|
|byte|`001`|
|word|`010`|
|doubleword|`011`|
|quadword|`100`|
|longword|`101`|
|single precision float|`110`|
|double precision float|`111`|

`T` in the mnemonic specifies the target element type as follows:

|Character|Element type|
|-|-|
|`o`|first quadword|
|`b`|byte|
|`w`|word|
|`d`|doubleword|
|`q`|quadword|
|`l`|longword|
|`s`|single precision float|
|`f`|double precision float|

### `cpuid` Instruction
Executing a `cpuid` instruction with `r0` set to `0`, `r0` will be set to the current core id.
Executing a `cpuid` instruction with `r0` set to `1`, `r0` will be set to the amount of cores in the cpu.
Executing a `cpuid` instruction with `r0` set to `2`, `r0` will be set to the amount of threads per core in the cpu.
Any other value for `r0` is undefined.

## Quirks of the instruction set
### It's `shl` all the way down
To save opcodes, both `mov` and `ret` are encoded as `shl` with an immediate value of `0`:
- `mov rn, rm` is actually `shl rn, rm, 0`
- `ret` is actually `shl pc, lr, 0`

### 500 million `nop` instructions
Because every instruction is conditional, using `never` as the condition results in a `nop`

### No `psh` and `pp` instructions
Even though the assember understands `psh` and `pp` instructions, there is no actual instruction like that:
- `psh rn` is actually `str rn, [sp, -16]!`
- `pp rn` is actually `ldr rn, [sp, 16]!`

The same goes for `inc` and `dec` instructions:
- `inc rn` is actually `add rn, rn, 1`
- `dec rn` is actually `sub rn, rn, 1`

### Simplified arithmetic
The assembler supports `rn, rm` as a a shorthand for `rn, rn, rm` for arithmetic instructions like `add`, `sub`, and so on.
This is also done to keep the amount of opcodes to a minimum.

### Signed bit deposit?
The assembler accepts `sbdp` as a mnemonic to provide symmetry with `sbxt` and `ubxt`.
However, there is no executional difference between a signed and unsigned bit deposit

### `movz` and `movk` only use 2 bits for shift encoding
This is very simple: As it is only possible to shift the value to load by a multiple of 16 bits, there are only 4 possibilities for the value.

## Assembler directives
Assembler directives are identifiers prefixed with a `.`
|Directive|Description|
|-|-|
|`.ascii`|Puts the following string literal into the binary without adding a null terminator|
|`.asciz`|Puts the following string literal into the binary|
|`.byte`|Puts a byte into the binary|
|`.word`|Puts a word into the binary|
|`.dword`|Puts a doubleword into the binary|
|`.qword`|Puts a quadword into the binary|
|`.float`|Puts a single precision float into the binary|
|`.double`|Puts a double precision float into the binary|
|`.offset`|Puts the address of a symbol into the binary|
|`.zerofill n`|Inserts n zero bytes into the binary|
|`.global label`|Marks the specified label as global, meaning it can be seen from other binary files|
|`.text`|The next section will contain code|
|`.data`|The next section will contain immutable data|
|`.bss`|The next section will contain mutable data|
