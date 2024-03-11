# The Hive 64 Architecture
## Data type sizes
|Name|Size in bits|Appropriate type in C|
|-|-|-|
|byte|``char`|
|word|`1`short`|
|doubleword|`3`int`|
|quadword|`6`long long int`|
|longword|`128`|Standard C does not specify an integer type of longword size|
|single precision float|`3`float`|
|double precision float|`6`double`|

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
Instructions are encoded as 32-bit values.

### Instruction encoding description
- `[]`: all bits in brackets belong to some argument
- `.`: this bit is ignored by the instruction
- `0`: this bit is `0` ignored by the instruction
- `1`: this bit is `1` ignored by the instruction

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
|`ret`|`00110001111111110...000000000000`|Returns from a subroutine|
|`b offset`|`0000000[---------imm25---------]`|Branches to an address|
|`bl offset`|`0000001[---------imm25---------]`|Branches to a subroutine|
|`blt offset`|`0000010[---------imm25---------]`|Branches to an address if less than|
|`bllt offset`|`0000011[---------imm25---------]`|Branches to a subroutine if less than|
|`bgt offset`|`0000100[---------imm25---------]`|Branches to an address if greater than|
|`blgt offset`|`0000101[---------imm25---------]`|Branches to a subroutine if greater than|
|`bge offset`|`0000110[---------imm25---------]`|Branches to an address if greater than or equal|
|`blge offset`|`0000111[---------imm25---------]`|Branches to a subroutine if greater than or equal|
|`ble offset`|`0001000[---------imm25---------]`|Branches to an address if less than or equal|
|`blle offset`|`0001001[---------imm25---------]`|Branches to a subroutine if less than or equal|
|`beq offset`|`0001010[---------imm25---------]`|Branches to an address if equal|
|`bleq offset`|`0001011[---------imm25---------]`|Branches to a subroutine if equal|
|`bne offset`|`0001100[---------imm25---------]`|Branches to an address if not equal|
|`blne offset`|`0001101[---------imm25---------]`|Branches to a subroutine if not equal|
|`cbnz r1, offset`|`0001110[r1-]0[------imm19------]`|Branches to an address if register is not zero|
|`cblnz r1, offset`|`0001111[r1-]0[------imm19------]`|Branches to a subroutine if register is not zero|
|`cbz r1, offset`|`0001110[r1-]1[------imm19------]`|Branches to an address if register is zero|
|`clbz r1, offset`|`0001111[r1-]1[------imm19------]`|Branches to a subroutine if register is zero|
|`br r1`|`1010000[r1-]....................`|Branches to a register value|
|`blr r1`|`1010001[r1-]....................`|Branches and links to a register value|
|`brlt r1`|`1010010[r1-]....................`|Branches to a register value if less than|
|`blrlt r1`|`1010011[r1-]....................`|Branches and links to a register value if less than|
|`brgt r1`|`1010100[r1-]....................`|Branches to a register value if greater than|
|`blrgt r1`|`1010101[r1-]....................`|Branches and links to a register value if greater than|
|`brge r1`|`1010110[r1-]....................`|Branches to a register value if greater than or equal|
|`blrge r1`|`1010111[r1-]....................`|Branches and links to a register value if greater than or equal|
|`brle r1`|`1011000[r1-]....................`|Branches to a register value if less than or equal|
|`blrle r1`|`1011001[r1-]....................`|Branches and links to a register value if less than or equal|
|`breq r1`|`1011010[r1-]....................`|Branches to a register value if equal|
|`blreq r1`|`1011011[r1-]....................`|Branches and links to a register value if equal|
|`brne r1`|`1011100[r1-]....................`|Branches to a register value if not equal|
|`blrne r1`|`1011101[r1-]....................`|Branches and links to a register value if not equal|
|`cbrnz r1, r2`|`1011110[r1-]..............0[r2-]`|Branches to a register value if other register is not zero|
|`cblrnz r1, r2`|`1011111[r1-]..............0[r2-]`|Branches and links to a register value if other register is not zero|
|`cbrz r1, r2`|`1011110[r1-]..............1[r2-]`|Branches to a register value if other register is zero|
|`cblrz r1, r2`|`1011111[r1-]..............1[r2-]`|Branches and links to a register value if other register is zero|

### Integer Arithmetic
|Mnemonic|Encoding|Description|
|-|-|-|
|`add r1, r2, imm`|`0010000[r1-][r2-]...[--imm12---]`|Adds r2 and an immediate and stores the result in r1|
|`add r1, r2, r3`|`0110000..........[r1-][r2-][r3-]`|Adds r2 and r3 and stores the result in r1|
|`sub r1, r2, imm`|`0010001[r1-][r2-]...[--imm12---]`|Subtracts an immediate from r2 and stores the result in r1|
|`sub r1, r2, r3`|`0110001..........[r1-][r2-][r3-]`|Subtracts r3 from r2 and stores the result in r1|
|`mul r1, r2, imm`|`0010010[r1-][r2-]...[--imm12---]`|Multiplies r2 and an immediate and stores the result in r1|
|`mul r1, r2, r3`|`0110010..........[r1-][r2-][r3-]`|Multiplies r2 and r3 and stores the result in r1|
|`div r1, r2, imm`|`0010011[r1-][r2-]...[--imm12---]`|Divides r2 by an immediate and stores the result in r1|
|`div r1, r2, r3`|`0110011..........[r1-][r2-][r3-]`|Divides r2 by r3 and stores the result in r1|
|`mod r1, r2, imm`|`0010100[r1-][r2-]...[--imm12---]`|Calculates the remainder of the division of r2 and an immediate and stores it in r1|
|`mod r1, r2, r3`|`0110100..........[r1-][r2-][r3-]`|Calculates the remainder of the division of r2 and r3 and stores it in r1|
|`and r1, r2, imm`|`0010101[r1-][r2-]...[--imm12---]`|Ands r2 and an immediate and stores the result in r1|
|`and r1, r2, r3`|`0110101..........[r1-][r2-][r3-]`|Ands r2 and r3 and stores the result in r1|
|`or r1, r2, imm`|`0010110[r1-][r2-]...[--imm12---]`|Ors r2 and an immediate and stores the result in r1|
|`or r1, r2, r3`|`0110110..........[r1-][r2-][r3-]`|Ors r2 and r3 and stores the result in r1|
|`xor r1, r2, imm`|`0010111[r1-][r2-]...[--imm12---]`|Xors r2 and an immediate and stores the result in r1|
|`xor r1, r2, r3`|`0110111..........[r1-][r2-][r3-]`|Xors r2 and r3 and stores the result in r1|
|`shl r1, r2, imm`|`0011000[r1-][r2-]...[--imm12---]`|Shifts r2 left by an immediate and stores the result in r1|
|`shl r1, r2, r3`|`0111000..........[r1-][r2-][r3-]`|Shifts r2 left by r3 and stores the result in r1|
|`shr r1, r2, imm`|`0011001[r1-][r2-]...[--imm12---]`|Shifts r2 right by an immediate and stores the result in r1|
|`shr r1, r2, r3`|`0111001..........[r1-][r2-][r3-]`|Shifts r2 right by r3 and stores the result in r1|
|`rol r1, r2, imm`|`0011010[r1-][r2-]...[--imm12---]`|Rotates r2 left by an immediate and stores the result in r1|
|`rol r1, r2, r3`|`0111010..........[r1-][r2-][r3-]`|Rotates r2 left by r3 and stores the result in r1|
|`ror r1, r2, imm`|`0011011[r1-][r2-]...[--imm12---]`|Rotates r2 right by an immediate and stores the result in r1|
|`ror r1, r2, r3`|`0111011..........[r1-][r2-][r3-]`|Rotates r2 right by r3 and stores the result in r1|
|`neg r1, r2`|`0111100..........[r1-][r2-].....`|Stores the negative value of r2 in r1|
|`not r1, r2`|`0111101..........[r1-][r2-].....`|Stores the bitwise not of r2 in r1|
|`asr r1, r2, imm`|`0011110[r1-][r2-]...[--imm12---]`|Arithmetically shifts r2 right by an immediate and stores the result in r1|
|`asr r1, r2, r3`|`0111110..........[r1-][r2-][r3-]`|Arithmetically shifts r2 right by r3 and stores the result in r1|
|`swe r1, r2`|`0111111..........[r1-][r2-].....`|Switches all bytes in r2 and stores the result in r1|
|`tst r1, r2`|`1000010..........[r1-][r2-].....`|Subtracts r2 from r1 and sets the flag based on the result. Result ignored|
|`tst r1, imm`|`1100010[r1-][-------imm20------]`|Subtracts an immediate from r1 and sets the flag based on the result. Result ignored|
|`cmp r1, r2`|`1000011..........[r1-][r2-].....`|Ands r1 and r2 and sets the flag based on the result. Result ignored|
|`cmp r1, imm`|`1100011[r1-][-------imm20------]`|Ands r1 and an immediate and sets the flag based on the result. Result ignored|

### Floating point Arithmetic
|Mnemonic|Encoding|Description|
|-|-|-|
|`fadd r1, r2, r3`|`100010000000.....[r1-][r2-][r3-]`|Adds float in r2 and r3 and stores the result in r1|
|`faddi r1, r2, r3`|`100010000010.....[r1-][r2-][r3-]`|Adds float in r2 and integer in r3 and stores the result in r1|
|`fsub r1, r2, r3`|`100010000100.....[r1-][r2-][r3-]`|Subtracts float in r2 from r3 and stores the result in r1|
|`fsubi r1, r2, r3`|`100010000110.....[r1-][r2-][r3-]`|Subtracts float in r2 from integer in r3 and stores the result in r1|
|`fmul r1, r2, r3`|`100010001000.....[r1-][r2-][r3-]`|Multiplies float in r2 and r3 and stores the result in r1|
|`fmuli r1, r2, r3`|`100010001010.....[r1-][r2-][r3-]`|Multiplies float in r2 and integer in r3 and stores the result in r1|
|`fdiv r1, r2, r3`|`100010001100.....[r1-][r2-][r3-]`|Divides float in r2 by r3 and stores the result in r1|
|`fdivi r1, r2, r3`|`100010001110.....[r1-][r2-][r3-]`|Divides float in r2 by integer in r3 and stores the result in r1|
|`fmod r1, r2, r3`|`100010010000.....[r1-][r2-][r3-]`|Calculates the floating point remainder of dividing float in r2 by r3 and stores it in r1|
|`fmodi r1, r2, r3`|`100010010010.....[r1-][r2-][r3-]`|Calculates the floating point remainder of dividing float in r2 by integer in r3 and stores it in r1|
|`fsin r1, r2`|`100010011000.....[r1-][r2-].....`|Calculates the sin of float in r2 and stores it in r1|
|`fsqrt r1, r2`|`100010011010.....[r1-][r2-].....`|Calculates the sqare root of float in r2 and stores it in r1|
|`fcmp r1, r2`|`100010011100.....[r1-][r2-].....`|Subtracts float in r2 from r1 and sets the flag based on the result. Result ignored|
|`fcmpi r1, r2`|`100010011110.....[r1-][r2-].....`|Subtracts float in r2 from integer in r1 and sets the flag based on the result. Result ignored|
|`i2f r1, r2`|`100010010100.....[r1-][r2-].....`|Converts the integer in r2 to a float and stores it in r1|
|`f2i r1, r2`|`100010010110.....[r1-][r2-].....`|Converts the float in r2 to an integer and stores it in r1|

### Utility
|Mnemonic|Encoding|Description|
|-|-|-|
|`svc`|`1100100.........................`|Supervisor call|
|`nop`|`00110000000000000...000000000000`|No operation (`shl r0, r0, 0`)|

### Data transfer
|Mnemonic|Encoding|Description|
|-|-|-|
|`mov r1, r2`|`0011000[r1-][r2-]...000000000000`|Moves the value in r2 to r1 (`shl r1, r2, 0`)|
|`lea r1, offset`|`1100000[r1-][-------imm20------]`|Loads the effective address of offset into r1|
|`movz r1, imm`|`1100001[r1-]000.[-----imm16----]`|Clears r1 and moves the 16-bit immediate value into the 1st 16-bit window of r1|
|`movz r1, imm, shl 16`|`1100001[r1-]001.[-----imm16----]`|Clears r1 and moves the 16-bit immediate value into the 2nd 16-bit window of r1|
|`movz r1, imm, shl 32`|`1100001[r1-]010.[-----imm16----]`|Clears r1 and moves the 16-bit immediate value into the 3rd 16-bit window of r1|
|`movz r1, imm, shl 48`|`1100001[r1-]011.[-----imm16----]`|Clears r1 and moves the 16-bit immediate value into the 4th 16-bit window of r1|
|`movk r1, imm`|`1100001[r1-]100.[-----imm16----]`|Moves the 16-bit immediate value into the 1st 16-bit window of r1. Only clears the affected 16-bit window|
|`movk r1, imm, shl 16`|`1100001[r1-]101.[-----imm16----]`|Moves the 16-bit immediate value into the 2nd 16-bit window of r1. Only clears the affected 16-bit window|
|`movk r1, imm, shl 32`|`1100001[r1-]110.[-----imm16----]`|Moves the 16-bit immediate value into the 3rd 16-bit window of r1. Only clears the affected 16-bit window|
|`movk r1, imm, shl 48`|`1100001[r1-]111.[-----imm16----]`|Moves the 16-bit immediate value into the 4th 16-bit window of r1. Only clears the affected 16-bit window|
|`ldr r1, [r2, imm]`|`0100000[r1-][r2-]000[--imm12---]`|Loads a quadword from memory address r2 + immediate into r1|
|`ldr r1, [r2, imm]!`|`0100000[r1-][r2-]001[--imm12---]`|Loads a quadword from memory address r2 into r1 and adds imm to r2|
|`ldrd r1, [r2, imm]`|`0100000[r1-][r2-]010[--imm12---]`|Loads a doubleword from memory address r2 + immediate into r1|
|`ldrd r1, [r2, imm]!`|`0100000[r1-][r2-]011[--imm12---]`|Loads a doubleword from memory address r2 into r1 and adds imm to r2|
|`ldrw r1, [r2, imm]`|`0100000[r1-][r2-]100[--imm12---]`|Loads a word from memory address r2 + immediate into r1|
|`ldrw r1, [r2, imm]!`|`0100000[r1-][r2-]101[--imm12---]`|Loads a word from memory address r2 into r1 and adds imm to r2|
|`ldrb r1, [r2, imm]`|`0100000[r1-][r2-]110[--imm12---]`|Loads a byte from memory address r2 + immediate into r1|
|`ldrb r1, [r2, imm]!`|`0100000[r1-][r2-]111[--imm12---]`|Loads a byte from memory address r2 into r1 and adds imm to r2|
|`str r1, [r2, imm]`|`0100001[r1-][r2-]000[--imm12---]`|Stores a quadword from r1 to memory address r2 + immediate|
|`str r1, [r2, imm]!`|`0100001[r1-][r2-]001[--imm12---]`|Adds the immediate to r2 and stores a quadword from r1 to memory address now in r2|
|`strd r1, [r2, imm]`|`0100001[r1-][r2-]010[--imm12---]`|Stores a doubleword from r1 to memory address r2 + immediate|
|`strd r1, [r2, imm]!`|`0100001[r1-][r2-]011[--imm12---]`|Adds the immediate to r2 and stores a doubleword from r1 to memory address now in r2|
|`strw r1, [r2, imm]`|`0100001[r1-][r2-]100[--imm12---]`|Stores a word from r1 to memory address r2 + immediate|
|`strw r1, [r2, imm]!`|`0100001[r1-][r2-]101[--imm12---]`|Adds the immediate to r2 and stores a word from r1 to memory address now in r2|
|`strb r1, [r2, imm]`|`0100001[r1-][r2-]110[--imm12---]`|Stores a byte from r1 to memory address r2 + immediate|
|`strb r1, [r2, imm]!`|`0100001[r1-][r2-]111[--imm12---]`|Adds the immediate to r2 and stores a byte from r1 to memory address now in r2|
|`ubxt r1, r2, a, b`|`0100010[r1-][r2-]..0[a---][b---]`|Extracts a bits starting at bit b from register r2 and stores the value into r1|
|`sbxt r1, r2, a, b`|`0100010[r1-][r2-]..1[a---][b---]`|Extracts a bits starting at bit b from register r2 and stores the sign extended value into r1|
|`ubdp r1, r2, a, b`|`0100011[r1-][r2-]..0[a---][b---]`|Deposits the lowest a bits from r2 into r1 starting at bit b|
|`ldr r1, [r2, r3]`|`1000000.......000[r1-][r2-][r3-]`|Loads a quadword from memory address r2 + r3 into r1|
|`ldr r1, [r2, r3]!`|`1000000.......001[r1-][r2-][r3-]`|Loads a quadword from memory address r2 into r1 and adds r3 to r2|
|`ldrd r1, [r2, r3]`|`1000000.......010[r1-][r2-][r3-]`|Loads a doubleword from memory address r2 + r3 into r1|
|`ldrd r1, [r2, r3]!`|`1000000.......011[r1-][r2-][r3-]`|Loads a doubleword from memory address r2 into r1 and adds r3 to r2|
|`ldrw r1, [r2, r3]`|`1000000.......100[r1-][r2-][r3-]`|Loads a word from memory address r2 + r3 into r1|
|`ldrw r1, [r2, r3]!`|`1000000.......101[r1-][r2-][r3-]`|Loads a word from memory address r2 into r1 and adds r3 to r2|
|`ldrb r1, [r2, r3]`|`1000000.......110[r1-][r2-][r3-]`|Loads a byte from memory address r2 + r3 into r1|
|`ldrb r1, [r2, r3]!`|`1000000.......111[r1-][r2-][r3-]`|Loads a byte from memory address r2 into r1 and adds r3 to r2|
|`str r1, [r2, r3]`|`1000001.......000[r1-][r2-][r3-]`|Stores a quadword from r1 to memory address r2 + r3|
|`str r1, [r2, r3]!`|`1000001.......001[r1-][r2-][r3-]`|Adds r3 to r2 and stores a quadword from r1 to memory address now in r2|
|`strd r1, [r2, r3]`|`1000001.......010[r1-][r2-][r3-]`|Stores a doubleword from r1 to memory address r2 + r3|
|`strd r1, [r2, r3]!`|`1000001.......011[r1-][r2-][r3-]`|Adds r3 to r2 and stores a doubleword from r1 to memory address now in r2|
|`strw r1, [r2, r3]`|`1000001.......100[r1-][r2-][r3-]`|Stores a word from r1 to memory address r2 + r3|
|`strw r1, [r2, r3]!`|`1000001.......101[r1-][r2-][r3-]`|Adds r3 to r2 and stores a word from r1 to memory address now in r2|
|`strb r1, [r2, r3]`|`1000001.......110[r1-][r2-][r3-]`|Stores a byte from r1 to memory address r2 + r3|
|`strb r1, [r2, r3]!`|`1000001.......111[r1-][r2-][r3-]`|Adds r3 to r2 and stores a byte from r1 to memory address now in r2|

### Vector Operations
|Mnemonic|Encoding|Description|
|-|-|-|
|`vbadd v1, v2, v3`|`10001010000001......[v3][v2][v1]`|Adds v2 and v3 and stores the result in v1|
|`voadd v1, v2, v3`|`10001010000000......[v3][v2][v1]`|Adds v2 and v3 and stores the result in v1|
|`vwadd v1, v2, v3`|`10001010000010......[v3][v2][v1]`|Adds v2 and v3 and stores the result in v1|
|`vdadd v1, v2, v3`|`10001010000011......[v3][v2][v1]`|Adds v2 and v3 and stores the result in v1|
|`vqadd v1, v2, v3`|`10001010000100......[v3][v2][v1]`|Adds v2 and v3 and stores the result in v1|
|`vladd v1, v2, v3`|`10001010000101......[v3][v2][v1]`|Adds v2 and v3 and stores the result in v1|
|`vsadd v1, v2, v3`|`10001010000110......[v3][v2][v1]`|Adds v2 and v3 and stores the result in v1|
|`vfadd v1, v2, v3`|`10001010000111......[v3][v2][v1]`|Adds v2 and v3 and stores the result in v1|
|`vosub v1, v2, v3`|`10001010001000......[v3][v2][v1]`|Subtracts v3 from v2 and stores the result in v1|
|`vbsub v1, v2, v3`|`10001010001001......[v3][v2][v1]`|Subtracts v3 from v2 and stores the result in v1|
|`vwsub v1, v2, v3`|`10001010001010......[v3][v2][v1]`|Subtracts v3 from v2 and stores the result in v1|
|`vdsub v1, v2, v3`|`10001010001011......[v3][v2][v1]`|Subtracts v3 from v2 and stores the result in v1|
|`vqsub v1, v2, v3`|`10001010001100......[v3][v2][v1]`|Subtracts v3 from v2 and stores the result in v1|
|`vlsub v1, v2, v3`|`10001010001101......[v3][v2][v1]`|Subtracts v3 from v2 and stores the result in v1|
|`vssub v1, v2, v3`|`10001010001110......[v3][v2][v1]`|Subtracts v3 from v2 and stores the result in v1|
|`vfsub v1, v2, v3`|`10001010001111......[v3][v2][v1]`|Subtracts v3 from v2 and stores the result in v1|
|`vomul v1, v2, v3`|`10001010010000......[v3][v2][v1]`|Multiplies v2 and v3 and stores the result in v1|
|`vbmul v1, v2, v3`|`10001010010001......[v3][v2][v1]`|Multiplies v2 and v3 and stores the result in v1|
|`vwmul v1, v2, v3`|`10001010010010......[v3][v2][v1]`|Multiplies v2 and v3 and stores the result in v1|
|`vdmul v1, v2, v3`|`10001010010011......[v3][v2][v1]`|Multiplies v2 and v3 and stores the result in v1|
|`vqmul v1, v2, v3`|`10001010010100......[v3][v2][v1]`|Multiplies v2 and v3 and stores the result in v1|
|`vlmul v1, v2, v3`|`10001010010101......[v3][v2][v1]`|Multiplies v2 and v3 and stores the result in v1|
|`vsmul v1, v2, v3`|`10001010010110......[v3][v2][v1]`|Multiplies v2 and v3 and stores the result in v1|
|`vfmul v1, v2, v3`|`10001010010111......[v3][v2][v1]`|Multiplies v2 and v3 and stores the result in v1|
|`vodiv v1, v2, v3`|`10001010011000......[v3][v2][v1]`|Divides v2 by v3 and stores the result in v1|
|`vbdiv v1, v2, v3`|`10001010011001......[v3][v2][v1]`|Divides v2 by v3 and stores the result in v1|
|`vwdiv v1, v2, v3`|`10001010011010......[v3][v2][v1]`|Divides v2 by v3 and stores the result in v1|
|`vddiv v1, v2, v3`|`10001010011011......[v3][v2][v1]`|Divides v2 by v3 and stores the result in v1|
|`vqdiv v1, v2, v3`|`10001010011100......[v3][v2][v1]`|Divides v2 by v3 and stores the result in v1|
|`vldiv v1, v2, v3`|`10001010011101......[v3][v2][v1]`|Divides v2 by v3 and stores the result in v1|
|`vsdiv v1, v2, v3`|`10001010011110......[v3][v2][v1]`|Divides v2 by v3 and stores the result in v1|
|`vfdiv v1, v2, v3`|`10001010011111......[v3][v2][v1]`|Divides v2 by v3 and stores the result in v1|
|`voaddsub v1, v2, v3`|`10001010100000......[v3][v2][v1]`|Adds even indexed elements in v2 and v3 and subtracts odd indexed elements in v2 and v3 and stores the result in v1|
|`vbaddsub v1, v2, v3`|`10001010100001......[v3][v2][v1]`|Adds even indexed elements in v2 and v3 and subtracts odd indexed elements in v2 and v3 and stores the result in v1|
|`vwaddsub v1, v2, v3`|`10001010100010......[v3][v2][v1]`|Adds even indexed elements in v2 and v3 and subtracts odd indexed elements in v2 and v3 and stores the result in v1|
|`vdaddsub v1, v2, v3`|`10001010100011......[v3][v2][v1]`|Adds even indexed elements in v2 and v3 and subtracts odd indexed elements in v2 and v3 and stores the result in v1|
|`vqaddsub v1, v2, v3`|`10001010100100......[v3][v2][v1]`|Adds even indexed elements in v2 and v3 and subtracts odd indexed elements in v2 and v3 and stores the result in v1|
|`vladdsub v1, v2, v3`|`10001010100101......[v3][v2][v1]`|Adds even indexed elements in v2 and v3 and subtracts odd indexed elements in v2 and v3 and stores the result in v1|
|`vsaddsub v1, v2, v3`|`10001010100110......[v3][v2][v1]`|Adds even indexed elements in v2 and v3 and subtracts odd indexed elements in v2 and v3 and stores the result in v1|
|`vfaddsub v1, v2, v3`|`10001010100111......[v3][v2][v1]`|Adds even indexed elements in v2 and v3 and subtracts odd indexed elements in v2 and v3 and stores the result in v1|
|`vomadd v1, v2, v3`|`10001010101000......[v3][v2][v1]`|Multiplies v2 and v3 and stores the sum of the results into the lowest element of v1|
|`vbmadd v1, v2, v3`|`10001010101001......[v3][v2][v1]`|Multiplies v2 and v3 and stores the sum of the results into the lowest element of v1|
|`vwmadd v1, v2, v3`|`10001010101010......[v3][v2][v1]`|Multiplies v2 and v3 and stores the sum of the results into the lowest element of v1|
|`vdmadd v1, v2, v3`|`10001010101011......[v3][v2][v1]`|Multiplies v2 and v3 and stores the sum of the results into the lowest element of v1|
|`vqmadd v1, v2, v3`|`10001010101100......[v3][v2][v1]`|Multiplies v2 and v3 and stores the sum of the results into the lowest element of v1|
|`vlmadd v1, v2, v3`|`10001010101101......[v3][v2][v1]`|Multiplies v2 and v3 and stores the sum of the results into the lowest element of v1|
|`vsmadd v1, v2, v3`|`10001010101110......[v3][v2][v1]`|Multiplies v2 and v3 and stores the sum of the results into the lowest element of v1|
|`vfmadd v1, v2, v3`|`10001010101111......[v3][v2][v1]`|Multiplies v2 and v3 and stores the sum of the results into the lowest element of v1|
|`vomov v1, r2, at`|`10001010110000....[at-][r2-][v1]`|Moves r2 into the specified element of v1|
|`vbmov v1, r2, at`|`10001010110001....[at-][r2-][v1]`|Moves r2 into the specified element of v1|
|`vwmov v1, r2, at`|`10001010110010....[at-][r2-][v1]`|Moves r2 into the specified element of v1|
|`vdmov v1, r2, at`|`10001010110011....[at-][r2-][v1]`|Moves r2 into the specified element of v1|
|`vqmov v1, r2, at`|`10001010110100....[at-][r2-][v1]`|Moves r2 into the specified element of v1|
|`vlmov v1, r2, at`|`10001010110101....[at-][r2-][v1]`|Moves r2 into the specified element of v1|
|`vsmov v1, r2, at`|`10001010110110....[at-][r2-][v1]`|Moves r2 into the specified element of v1|
|`vfmov v1, r2, at`|`10001010110111....[at-][r2-][v1]`|Moves r2 into the specified element of v1|
|`vomov v1, v2`|`10001010111000..........[v2][v1]`|Moves v2 to v1|
|`vbmov v1, v2`|`10001010111001..........[v2][v1]`|Moves v2 to v1|
|`vwmov v1, v2`|`10001010111010..........[v2][v1]`|Moves v2 to v1|
|`vdmov v1, v2`|`10001010111011..........[v2][v1]`|Moves v2 to v1|
|`vqmov v1, v2`|`10001010111100..........[v2][v1]`|Moves v2 to v1|
|`vlmov v1, v2`|`10001010111101..........[v2][v1]`|Moves v2 to v1|
|`vsmov v1, v2`|`10001010111110..........[v2][v1]`|Moves v2 to v1|
|`vfmov v1, v2`|`10001010111111..........[v2][v1]`|Moves v2 to v1|
|`voconvT v1, v2`|`10001011000000TTT.......[v2][v1]`|Converts all elements in v2 [to another type](#vector-convert-instruction) and stores them in v1|
|`vbconvT v1, v2`|`10001011000001TTT.......[v2][v1]`|Converts all elements in v2 [to another type](#vector-convert-instruction) and stores them in v1|
|`vwconvT v1, v2`|`10001011000010TTT.......[v2][v1]`|Converts all elements in v2 [to another type](#vector-convert-instruction) and stores them in v1|
|`vdconvT v1, v2`|`10001011000011TTT.......[v2][v1]`|Converts all elements in v2 [to another type](#vector-convert-instruction) and stores them in v1|
|`vqconvT v1, v2`|`10001011000100TTT.......[v2][v1]`|Converts all elements in v2 [to another type](#vector-convert-instruction) and stores them in v1|
|`vlconvT v1, v2`|`10001011000101TTT.......[v2][v1]`|Converts all elements in v2 [to another type](#vector-convert-instruction) and stores them in v1|
|`vsconvT v1, v2`|`10001011000110TTT.......[v2][v1]`|Converts all elements in v2 [to another type](#vector-convert-instruction) and stores them in v1|
|`vfconvT v1, v2`|`10001011000111TTT.......[v2][v1]`|Converts all elements in v2 [to another type](#vector-convert-instruction) and stores them in v1|
|`volen r1, v2`|`10001011001000.........[v2][r1-]`|Stores the index of the first element of value 0 in v2 into r1|
|`vblen r1, v2`|`10001011001001.........[v2][r1-]`|Stores the index of the first element of value 0 in v2 into r1|
|`vwlen r1, v2`|`10001011001010.........[v2][r1-]`|Stores the index of the first element of value 0 in v2 into r1|
|`vdlen r1, v2`|`10001011001011.........[v2][r1-]`|Stores the index of the first element of value 0 in v2 into r1|
|`vqlen r1, v2`|`10001011001100.........[v2][r1-]`|Stores the index of the first element of value 0 in v2 into r1|
|`vllen r1, v2`|`10001011001101.........[v2][r1-]`|Stores the index of the first element of value 0 in v2 into r1|
|`vslen r1, v2`|`10001011001110.........[v2][r1-]`|Stores the index of the first element of value 0 in v2 into r1|
|`vflen r1, v2`|`10001011001111.........[v2][r1-]`|Stores the index of the first element of value 0 in v2 into r1|

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

## Quirks of the instruction set
### It's `shl` all the way down
To save opcodes, `mov`, `ret`, and `nop` are all encoded as `shl` with an immediate value of `0`:
- `mov rn, rm` is actually `shl rn, rm, 0`
- `ret` is actually `shl pc, lr, 0`
- `nop` is actually `shl r0, r0, 0`

### Why do `cblz` and `cblnz` exist
Branch instructions are encoded in a way that disconnects link or no link from the opcode of the branch:
- 3 bits for instruction type (`000` for branch, `101` for branch to register)
- 3 bits for branch type
- 1 bit specifying link (`1`) or no link (`0`)

### No `psh` and `pp` instructions
Even though the assember understands `psh` and `pp` instructions, there is no actual instruction like that:
- mnemonic `psh rn` is actually `str rn, [sp, -16]!`
- mnemonic `pp rn` is actually `ldr rn, [sp, 16]!`

The same goes for `inc` and `dec` instructions:
- `inc rn` is actually `add rn, rn, 1`
- `dec rn` is actually `sub rn, rn, 1`

### Simplified arithmetic
The assembler supports `rn, rm` as a a shorthand for `rn, rn, rm` for arithmetic instructions like `add`, `sub`, and so on.
This is also done to keep the amount of opcodes to a minimum.

### Signed bit deposit?
The assembler accepts `sbdp` as a mnemonic to provide symmetry with `sbxt` and `ubxt`.
However, there is no executional difference between a signed and unsigned bit deposit

### `movz` and `movk` only use 4 bits for shift encoding
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
