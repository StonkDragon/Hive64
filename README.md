# The Hive64 Architecture
- [Instruction encoding](#instruction-encoding)
- [Instructions](#instructions)

# Instruction Encoding
## Branch type opcodes (0b00xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)
    0b00kkkxxxxxxxxxxxxxxxxxxxxxxxxxxx
        |
        +-----------------------------> Branch type

|Branch type|Name|
|-|-|
|`000`|`b`|
|`001`|`blt`|
|`010`|`bgt`|
|`011`|`bge`|
|`100`|`ble`|
|`101`|`beq`|
|`110`|`bne`|
|`111`|`cbz`/`cbnz`|

## Reg-Reg-Imm type opcodes (0b01xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)
    0b01kkkkkxxxxxxxxxxxxxxxxxxxxxxxxx
        |
        +-----------------------------> Operation

|Operation|Name|
|-|-|
|`00000`|`add`|
|`00001`|`sub`|
|`00010`|`mul`|
|`00011`|`div`|
|`00100`|`mod`|
|`00101`|`and`|
|`00110`|`or`|
|`00111`|`xor`|
|`01000`|`shl`|
|`01001`|`shr`|
|`01010`|`rol`|
|`01011`|`ror`|
|`01100`|`ldr`|
|`01101`|`str`|
|`01110`|`bxt`|
|`01111`|`bdp`|
|`10000`|`ldp`|
|`10001`|`stp`|

## Reg-Reg-Reg type opcodes (0b10xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)
    0b10kkkkkkxxxxxxxxxxxxxxxxxxxxxxxx
        |
        +-----------------------------> Operation

|Operation|Name|
|-|-|
|`000000`|`add`|
|`000001`|`sub`|
|`000010`|`mul`|
|`000011`|`div`|
|`000100`|`mod`|
|`000101`|`and`|
|`000110`|`or`|
|`000111`|`xor`|
|`001000`|`shl`|
|`001001`|`shr`|
|`001010`|`rol`|
|`001011`|`ror`|
|`001100`|`ldr`|
|`001101`|`str`|
|`001110`|`tst`|
|`001111`|`cmp`|
|`010000`|`ldp`|
|`010001`|`stp`|
|`010010`|Float type opcodes|

## Float type opcodes (0b10010010xxxxxxxxxxxxxxxxxxxxxxxx)
    0b10010010kkkkxxxxxxxxxxxxxxxxxxxx
              |
              +-----------------------> Operation

|Operation|Name|
|-|-|
|`0000`|`add`|
|`0001`|`addi`|
|`0010`|`sub`|
|`0011`|`subi`|
|`0100`|`mul`|
|`0101`|`muli`|
|`0110`|`div`|
|`0111`|`divi`|
|`1000`|`mod`|
|`1001`|`modi`|
|`1010`|`i2f`|
|`1011`|`f2i`|
|`1100`|`sin`|
|`1101`|`sqrt`|
|`1110`|`cmp`|
|`1111`|`cmpi`|

## Reg-Imm type opcodes (0b11xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)
    0b11bxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        |
        +-----------------------------> Is Branch

### When 'Is Branch' is 0
    0b110kkkkxxxxxxxxxxxxxxxxxxxxxxxxx
         |
         +----------------------------> Operation

|Operation|Name|
|-|-|
|`0000`|`lea`|
|`0001`|`movz`/`movk`|
|`0010`|`tst`|
|`0011`|`cmp`|
|`0100`|`svc`|

### When 'Is Branch' is 1
    0b111kkkxxxxxxxxxxxxxxxxxxxxxxxxxx
         |
         +----------------------------> Operation

|Branch Type|Name|
|-|-|
|`000`|`br`|
|`001`|`brlt`|
|`010`|`brgt`|
|`011`|`brge`|
|`100`|`brle`|
|`101`|`breq`|
|`110`|`brne`|
|`111`|`cbrz`/`cbrnz`|

# Instructions
## Branches
### `b` - `bl`
#### Description
The `b` and `bl` instructions perform an uncoditional jump to a PC-relative offset.
The `bl` instruction also saves the current value of PC in LR.

#### Assembler Symbols
```
b <label>
bl <label>
```

`<label>`: The program label to jump to. It is the signed offset from the current instruction and is encoded as `T` times 4.

#### Pseudocode
```c
// 00000 L TTTTTTTTTTTTTTTTTTTTTTTTTT

if (L) {
    LR = PC;
}
PC = PC + sign_extend(T * 4, bits: 26);
```
### `br` - `blr`
#### Description
The `br` and `blr` instructions perform an uncoditional jump to the address stored in a register.
The `blr` instruction also saves the current value of PC in LR.

#### Assembler Symbols
```
br <Rn>
blr <Rn>
```

`<Rn>`: The register containing the address to jump to.

#### Pseudocode
```c
// 111001 L TTTTT ____________________

if (L) {
    LR = PC;
}
PC = Registers[T];
```
### `blt`/`bmi` - `bllt`/`blmi`
#### Description
The `blt` and `bllt` instructions perform a conditional jump to a PC-relative offset.
The `bllt` instruction also saves the current value of PC in LR.
The jump is only performed if the `negative` flag is set.

#### Assembler Symbols
```
blt <label>
bllt <label>
```

`<label>`: The program label to jump to. It is the signed offset from the current instruction and is encoded as `T` times 4.

#### Pseudocode
```c
// 00001 L TTTTTTTTTTTTTTTTTTTTTTTTTT

if (flag_set(negative)) {
    if (L) {
        LR = PC;
    }
    PC = PC + sign_extend(T * 4, bits: 26);
}
```
### `brlt`/`brmi` - `blrlt`/`blrmi`
#### Description
The `brlt` and `blrlt` instructions perform a conditional jump to the address stored in a register.
The `brlt` instruction also saves the current value of PC in LR.
The jump is only performed if the `negative` flag is set.

#### Assembler Symbols
```
brlt <Rn>
blrlt <Rn>
```

`<Rn>`: The register containing the address to jump to.

#### Pseudocode
```c
// 111001 L TTTTT ____________________

if (flag_set(negative)) {
    if (L) {
        LR = PC;
    }
    PC = Registers[T];
}
```

### `bgt` - `blgt`
#### Description
The `bgt` and `blgt` instructions perform a conditional jump to a PC-relative offset.
The `blgt` instruction also saves the current value of PC in LR.
The jump is only performed if the `negative` and `equal` flags are both not set.

#### Assembler Symbols
```
bgt <label>
blgt <label>
```

`<label>`: The program label to jump to. It is the signed offset from the current instruction and is encoded as `T` times 4.

#### Pseudocode
```c
// 00010 L TTTTTTTTTTTTTTTTTTTTTTTTTT

if (flag_not_set(negative) and flag_not_set(equal)) {
    if (L) {
        LR = PC;
    }
    PC = PC + sign_extend(T * 4, bits: 26);
}
```
### `brgt` - `blrgt`
#### Description
The `brgt` and `blrgt` instructions perform a conditional jump to the address stored in a register.
The `brgt` instruction also saves the current value of PC in LR.
The jump is only performed if the `negative` and `equal` flags are both not set.

#### Assembler Symbols
```
brgt <Rn>
blrgt <Rn>
```

`<Rn>`: The register containing the address to jump to.

#### Pseudocode
```c
// 111010 L TTTTT ____________________

if (flag_not_set(negative) and flag_not_set(equal)) {
    if (L) {
        LR = PC;
    }
    PC = Registers[T];
}
```

### `bge`/`bpl` - `blge`/`blpl`
#### Description
The `bge` and `blge` instructions perform a conditional jump to a PC-relative offset.
The `blge` instruction also saves the current value of PC in LR.
The jump is only performed if the `negative` flag is not set.

#### Assembler Symbols
```
bge <label>
blge <label>
```

`<label>`: The program label to jump to. It is the signed offset from the current instruction and is encoded as `T` times 4.

#### Pseudocode
```c
// 00011 L TTTTTTTTTTTTTTTTTTTTTTTTTT

if (flag_not_set(negative)) {
    if (L) {
        LR = PC;
    }
    PC = PC + sign_extend(T * 4, bits: 26);
}
```
### `brge`/`brpl` - `blrge`/`blrpl`
#### Description
The `brge` and `blrge` instructions perform a conditional jump to the address stored in a register.
The `brge` instruction also saves the current value of PC in LR.
The jump is only performed if the `negative` flag is not set.

#### Assembler Symbols
```
brge <Rn>
blrge <Rn>
```

`<Rn>`: The register containing the address to jump to.

#### Pseudocode
```c
// 111011 L TTTTT ____________________

if (flag_not_set(negative)) {
    if (L) {
        LR = PC;
    }
    PC = Registers[T];
}
```

### `ble` - `blle`
#### Description
The `ble` and `blle` instructions perform a conditional jump to a PC-relative offset.
The `blle` instruction also saves the current value of PC in LR.
The jump is only performed if the `negative` or `equal` flags are set.

#### Assembler Symbols
```
ble <label>
blle <label>
```

`<label>`: The program label to jump to. It is the signed offset from the current instruction and is encoded as `T` times 4.

#### Pseudocode
```c
// 00100 L TTTTTTTTTTTTTTTTTTTTTTTTTT

if (flag_set(negative) or flag_set(equal)) {
    if (L) {
        LR = PC;
    }
    PC = PC + sign_extend(T * 4, bits: 26);
}
```
### `brle`
#### Description
The `brle` and `blrle` instructions perform a conditional jump to the address stored in a register.
The `brle` instruction also saves the current value of PC in LR.
The jump is only performed if the `negative` or `equal` flags are set.

#### Assembler Symbols
```
brle <Rn>
blrle <Rn>
```

`<Rn>`: The register containing the address to jump to.

#### Pseudocode
```c
// 111100 L TTTTT ____________________

if (flag_set(negative) or flag_set(equal)) {
    if (L) {
        LR = PC;
    }
    PC = Registers[T];
}
```

### `beq`/`bz` - `bleq`/`blz`
#### Description
The `beq` and `bleq` instructions perform a conditional jump to a PC-relative offset.
The `bleq` instruction also saves the current value of PC in LR.
The jump is only performed if the `equal` flag is set.

#### Assembler Symbols
```
beq <label>
bleq <label>
```

`<label>`: The program label to jump to. It is the signed offset from the current instruction and is encoded as `T` times 4.

#### Pseudocode
```c
// 00101 L TTTTTTTTTTTTTTTTTTTTTTTTTT

if (flag_set(equal)) {
    if (L) {
        LR = PC;
    }
    PC = PC + sign_extend(T * 4, bits: 26);
}
```
### `breq`/`brz` - `blreq`/`blrz`
#### Description
The `breq` and `blreq` instructions perform a conditional jump to the address stored in a register.
The `breq` instruction also saves the current value of PC in LR.
The jump is only performed if the `equal` flag is set.

#### Assembler Symbols
```
breq <Rn>
blreq <Rn>
```

`<Rn>`: The register containing the address to jump to.

#### Pseudocode
```c
// 111101 L TTTTT ____________________

if (flag_set(equal)) {
    if (L) {
        LR = PC;
    }
    PC = Registers[T];
}
```

### `bne`/`bnz` - `blne`/`blnz`
#### Description
The `bne` and `blne` instructions perform a conditional jump to a PC-relative offset.
The `blne` instruction also saves the current value of PC in LR.
The jump is only performed if the `equal` flag is not set.

#### Assembler Symbols
```
bne <label>
blne <label>
```

`<label>`: The program label to jump to. It is the signed offset from the current instruction and is encoded as `T` times 4.

#### Pseudocode
```c
// 00110 L TTTTTTTTTTTTTTTTTTTTTTTTTT

if (flag_not_set(equal)) {
    if (L) {
        LR = PC;
    }
    PC = PC + sign_extend(T * 4, bits: 26);
}
```
### `brne`/`brnz` - `blrne`/`blrnz`
#### Description
The `brne` and `blrne` instructions perform a conditional jump to the address stored in a register.
The `brne` instruction also saves the current value of PC in LR.
The jump is only performed if the `equal` flag is not set.

#### Assembler Symbols
```
brne <Rn>
blrne <Rn>
```

`<Rn>`: The register containing the address to jump to.

#### Pseudocode
```c
// 111110 L TTTTT ____________________

if (flag_not_set(equal)) {
    if (L) {
        LR = PC;
    }
    PC = Registers[T];
}
```

### `cbz`/`cbnz` - `cblz`/`cblnz`
#### Description
The `cbz` and `cbnz` instructions perform a comparison with a register and then conditionally jump to a PC-relative offset.
The `cblz`/`cblnz` stores the current PC in LR before taking the jump.
The `cbz` instruction jumps if the comparion sets the `equal` flag.
The `cbnz` instruction jumps if the comparion unsets the `equal` flag.

#### Assembler Symbols
```
cbz <Rn>, <label>
cbnz <Rn>, <label>
cblz <Rn>, <label>
cblnz <Rn>, <label>
```

`<Rn>`: The register to compare.
`<label>`: The program label to jump to. It is the signed offset from the current instruction and is encoded as `T` times 4.

#### Pseudocode
```c
// 00111 L RRRRR Z TTTTTTTTTTTTTTTTTTTT

set_flags(Registers[R]);
if (get_flag(equal) == Z) {
    if (L) {
        LR = PC;
    }
    PC = PC + sign_extend(T * 4, bits: 20);
}
```
### `cbrz`/`cbrnz` - `cblrz`/`cblrnz`
The `cbrz` and `cbrnz` instructions perform a comparison with a register and then conditionally jump to the address stored in a register.
The `cblrz`/`cblrnz` stores the current PC in LR before taking the jump.
The `cbrz` instruction jumps if the comparion sets the `equal` flag.
The `cbrnz` instruction jumps if the comparion unsets the `equal` flag.

#### Assembler Symbols
```
cbrz <Rn>, <Rm>
cbrnz <Rn>, <Rm>
cblrz <Rn>, <Rm>
cblrnz <Rn>, <Rm>
```

`<Rn>`: The register to compare.
`<Rm>`: The register containing the address to jump to.

#### Pseudocode
```c
// 111111 L TTTTT ______________ Z CCCCC

set_flags(Registers[C]);
if (get_flag(equal) == Z) {
    if (L) {
        LR = PC;
    }
    PC = Registers[T];
}
```

## Integer math
### `add`
#### Description
The `add` instruction adds two registers together and stores the result in a third register.

#### Assembler Symbols
```
add <Rd>, <Rn>, <Rm>
add <Rd>, <Rn>, <Imm15>
add <Rd>, <Rn>          ; alias for: add <Rd>, <Rd>, <Rn>
add <Rd>, <Imm15>       ; alias for: add <Rd>, <Rd>, <Imm15>
inc <Rd>, <Rn>          ; alias for: add <Rd>, <Rn>, 1
inc <Rd>                ; alias for: add <Rd>, <Rd>, 1
```

`<Rd>`: The destination register.
`<Rn>`: The left source register.
`<Rm>`: The right source register.
`<Imm15>`: A 15-bit immediate value.

#### Pseudocode
```c
// 0100000 DDDDD SSSSS IIIIIIIIIIIIIII
Registers[D] = Registers[S] + zero_extend(I, bits: 15);
```
```c
// 10000000 _________ DDDDD AAAAA BBBBB
Registers[D] = Registers[A] + Registers[B];
```
### `sub`
The `sub` instruction subtracts two registers from each other and stores the result in a third register.

#### Assembler Symbols
```
sub <Rd>, <Rn>, <Rm>
sub <Rd>, <Rn>, <Imm15>
sub <Rd>, <Rn>          ; alias for: sub <Rd>, <Rd>, <Rn>
sub <Rd>, <Imm15>       ; alias for: sub <Rd>, <Rd>, <Imm15>
dec <Rd>, <Rn>          ; alias for: sub <Rd>, <Rn>, 1
dec <Rd>                ; alias for: sub <Rd>, <Rd>, 1
```

`<Rd>`: The destination register.
`<Rn>`: The left source register.
`<Rm>`: The right source register.
`<Imm15>`: A 15-bit immediate value.

#### Pseudocode
```c
// 0100001 DDDDD SSSSS IIIIIIIIIIIIIII
Registers[D] = Registers[S] - zero_extend(I, bits: 15);
```
```c
// 10000001 _________ DDDDD AAAAA BBBBB
Registers[D] = Registers[A] - Registers[B];
```
### `mul`
The `mul` instruction multiplies two registers together and stores the result in a third register.

#### Assembler Symbols
```
mul <Rd>, <Rn>, <Rm>
mul <Rd>, <Rn>, <Imm15>
mul <Rd>, <Rn>          ; alias for: mul <Rd>, <Rd>, <Rn>
mul <Rd>, <Imm15>       ; alias for: mul <Rd>, <Rd>, <Imm15>
```

`<Rd>`: The destination register.
`<Rn>`: The left source register.
`<Rm>`: The right source register.
`<Imm15>`: A 15-bit immediate value.

#### Pseudocode
```c
// 0100010 DDDDD SSSSS IIIIIIIIIIIIIII
Registers[D] = Registers[S] * zero_extend(I, bits: 15);
```
```c
// 10000010 _________ DDDDD AAAAA BBBBB
Registers[D] = Registers[A] * Registers[B];
```
### `div`
The `div` instruction divides two registers and stores the result in a third register.

#### Assembler Symbols
```
div <Rd>, <Rn>, <Rm>
div <Rd>, <Rn>, <Imm15>
div <Rd>, <Rn>          ; alias for: div <Rd>, <Rd>, <Rn>
div <Rd>, <Imm15>       ; alias for: div <Rd>, <Rd>, <Imm15>
```

`<Rd>`: The destination register.
`<Rn>`: The left source register.
`<Rm>`: The right source register.
`<Imm15>`: A 15-bit immediate value.

#### Pseudocode
```c
// 0100011 DDDDD SSSSS IIIIIIIIIIIIIII
Registers[D] = Registers[S] / zero_extend(I, bits: 15);
```
```c
// 10000011 _________ DDDDD AAAAA BBBBB
Registers[D] = Registers[A] / Registers[B];
```
### `mod`
The `mod` instruction calculates the modulo of two registers and stores the result in a third register.

#### Assembler Symbols
```
mod <Rd>, <Rn>, <Rm>
mod <Rd>, <Rn>, <Imm15>
mod <Rd>, <Rn>          ; alias for: mod <Rd>, <Rd>, <Rn>
mod <Rd>, <Imm15>       ; alias for: mod <Rd>, <Rd>, <Imm15>
```

`<Rd>`: The destination register.
`<Rn>`: The left source register.
`<Rm>`: The right source register.
`<Imm15>`: A 15-bit immediate value.

#### Pseudocode
```c
// 0100100 DDDDD SSSSS IIIIIIIIIIIIIII
Registers[D] = Registers[S] % zero_extend(I, bits: 15);
```
```c
// 10000100 _________ DDDDD AAAAA BBBBB
Registers[D] = Registers[A] % Registers[B];
```
### `and`
The `and` instruction ands two registers together and stores the result in a third register.

#### Assembler Symbols
```
and <Rd>, <Rn>, <Rm>
and <Rd>, <Rn>, <Imm15>
and <Rd>, <Rn>          ; alias for: and <Rd>, <Rd>, <Rn>
and <Rd>, <Imm15>       ; alias for: and <Rd>, <Rd>, <Imm15>
```

`<Rd>`: The destination register.
`<Rn>`: The left source register.
`<Rm>`: The right source register.
`<Imm15>`: A 15-bit immediate value.

#### Pseudocode
```c
// 0100101 DDDDD SSSSS IIIIIIIIIIIIIII
Registers[D] = Registers[S] & zero_extend(I, bits: 15);
```
```c
// 10000101 _________ DDDDD AAAAA BBBBB
Registers[D] = Registers[A] & Registers[B];
```
### `or`
The `or` instruction ors two registers together and stores the result in a third register.

#### Assembler Symbols
```
or <Rd>, <Rn>, <Rm>
or <Rd>, <Rn>, <Imm15>
or <Rd>, <Rn>          ; alias for: or <Rd>, <Rd>, <Rn>
or <Rd>, <Imm15>       ; alias for: or <Rd>, <Rd>, <Imm15>
```

`<Rd>`: The destination register.
`<Rn>`: The left source register.
`<Rm>`: The right source register.
`<Imm15>`: A 15-bit immediate value.

#### Pseudocode
```c
// 0100110 DDDDD SSSSS IIIIIIIIIIIIIII
Registers[D] = Registers[S] | zero_extend(I, bits: 15);
```
```c
// 10000110 _________ DDDDD AAAAA BBBBB
Registers[D] = Registers[A] | Registers[B];
```
### `xor`
The `xor` instruction xors two registers together and stores the result in a third register.

#### Assembler Symbols
```
xor <Rd>, <Rn>, <Rm>
xor <Rd>, <Rn>, <Imm15>
xor <Rd>, <Rn>          ; alias for: xor <Rd>, <Rd>, <Rn>
xor <Rd>, <Imm15>       ; alias for: xor <Rd>, <Rd>, <Imm15>
```

`<Rd>`: The destination register.
`<Rn>`: The left source register.
`<Rm>`: The right source register.
`<Imm15>`: A 15-bit immediate value.

#### Pseudocode
```c
// 0100111 DDDDD SSSSS IIIIIIIIIIIIIII
Registers[D] = Registers[S] ^ zero_extend(I, bits: 15);
```
```c
// 10000111 _________ DDDDD AAAAA BBBBB
Registers[D] = Registers[A] ^ Registers[B];
```
### `shl`
The `shl` instruction shifts the first register to the left by the amount in the second register and stores the result in the third register.

#### Assembler Symbols
```
shl <Rd>, <Rn>, <Rm>
shl <Rd>, <Rn>, <Imm15>
shl <Rd>, <Rn>          ; alias for: shl <Rd>, <Rd>, <Rn>
shl <Rd>, <Imm15>       ; alias for: shl <Rd>, <Rd>, <Imm15>
mov <Rd>, <Rn>          ; alias for: shl <Rd>, <Rn>, 0
ret                     ; alias for: shl pc, lr, 0
nop                     ; alias for: shl r0, r0, 0
```

`<Rd>`: The destination register.
`<Rn>`: The left source register.
`<Rm>`: The right source register.
`<Imm15>`: A 15-bit immediate value.

#### Pseudocode
```c
// 0101000 DDDDD SSSSS IIIIIIIIIIIIIII
Registers[D] = Registers[S] << zero_extend(I, bits: 15);
```
```c
// 10001000 _________ DDDDD AAAAA BBBBB
Registers[D] = Registers[A] << Registers[B];
```
### `shr`
The `shr` instruction shifts the first register to the right by the amount in the second register and stores the result in the third register.

#### Assembler Symbols
```
shr <Rd>, <Rn>, <Rm>
shr <Rd>, <Rn>, <Imm15>
shr <Rd>, <Rn>          ; alias for: shr <Rd>, <Rd>, <Rn>
shr <Rd>, <Imm15>       ; alias for: shr <Rd>, <Rd>, <Imm15>
```

`<Rd>`: The destination register.
`<Rn>`: The left source register.
`<Rm>`: The right source register.
`<Imm15>`: A 15-bit immediate value.

#### Pseudocode
```c
// 0101001 DDDDD SSSSS IIIIIIIIIIIIIII
Registers[D] = Registers[S] >> zero_extend(I, bits: 15);
```
```c
// 10001001 _________ DDDDD AAAAA BBBBB
Registers[D] = Registers[A] >> Registers[B];
```
### `rol`
The `rol` instruction rotates the first register to the left by the amount in the second register and stores the result in the third register.

#### Assembler Symbols
```
rol <Rd>, <Rn>, <Rm>
rol <Rd>, <Rn>, <Imm15>
rol <Rd>, <Rn>          ; alias for: rol <Rd>, <Rd>, <Rn>
rol <Rd>, <Imm15>       ; alias for: rol <Rd>, <Rd>, <Imm15>
```

`<Rd>`: The destination register.
`<Rn>`: The left source register.
`<Rm>`: The right source register.
`<Imm15>`: A 15-bit immediate value.

#### Pseudocode
```c
// 0101010 DDDDD SSSSS IIIIIIIIIIIIIII
Registers[D] = Registers[S] <<< zero_extend(I, bits: 15);
```
```c
// 10001010 _________ DDDDD AAAAA BBBBB
Registers[D] = Registers[A] <<< Registers[B];
```
### `ror`
The `ror` instruction rotates the first register to the right by the amount in the second register and stores the result in the third register.

#### Assembler Symbols
```
ror <Rd>, <Rn>, <Rm>
ror <Rd>, <Rn>, <Imm15>
ror <Rd>, <Rn>          ; alias for: ror <Rd>, <Rd>, <Rn>
ror <Rd>, <Imm15>       ; alias for: ror <Rd>, <Rd>, <Imm15>
```

`<Rd>`: The destination register.
`<Rn>`: The left source register.
`<Rm>`: The right source register.
`<Imm15>`: A 15-bit immediate value.

#### Pseudocode
```c
// 0101011 DDDDD SSSSS IIIIIIIIIIIIIII
Registers[D] = Registers[S] >>> zero_extend(I, bits: 15);
```
```c
// 10001011 _________ DDDDD AAAAA BBBBB
Registers[D] = Registers[A] >>> Registers[B];
```

## Load and Store
### `ldr`
#### Description
The `ldr` instruction loads the given register with a value from a memory address.

#### Assembler Symbols
```
; ldr is an alias for ldrq

ldr <Rd>, [<Rs>, <Ro>]
ldr <Rd>, [<Rs>, <Imm13>]
ldr <Rd>, [<Rs>]            ; alias for: ldr <Rd>, [<Rs>, 0]
```

`<Rd>`: The register to load the value into
`<Rs>`: The register containing the base address to load from.
`<Ro>`: The register to offset the address by.
`<Imm13>`: The signed 13-bit immediate value to offset the address by.

#### Load Sizes
|Mnemonic|Bytes read|
|-|-|
|`ldrb`|`1`|
|`ldrw`|`2`|
|`ldrd`|`4`|
|`ldrq`/`ldr`|`8`|

#### Pseudocode
```c
// 0101100 DDDDD SSSSS NN IIIIIIIIIIIII
address = Registers[S] + sign_extend(I, bits: 13);

Registers[D] = memory_read_bytes(address, bytes: N);
```
```c
// 10001100 _______ NN DDDDD SSSSS OOOOO
address = Registers[S] + Registers[O];

Registers[D] = memory_read_bytes(address, bytes: N);
```
### `str`
#### Description
The `str` instruction stores the given register to a memory address.

#### Assembler Symbols
```
; str is an alias for strq

str <Rd>, [<Rs>, <Ro>]
str <Rd>, [<Rs>, <Imm13>]
str <Rd>, [<Rs>]            ; alias for: str <Rd>, [<Rs>, 0]
```

`<Rd>`: The register to load the value into
`<Rs>`: The register containing the base address to load from.
`<Ro>`: The register to offset the address by.
`<Imm13>`: The signed 13-bit immediate value to offset the address by.

#### Load Sizes
|Mnemonic|Bytes read|
|-|-|
|`strb`|`1`|
|`strw`|`2`|
|`strd`|`4`|
|`strq`/`str`|`8`|

#### Pseudocode
```c
// 0101101 SSSSS DDDDD NN IIIIIIIIIIIII
address = Registers[D] + sign_extend(I, bits: 13);

memory_write_bytes(address, bytes: N, value: Registers[S]);
```
```c
// 10001101 _______ NN SSSSS DDDDD OOOOO
address = Registers[D] + Registers[O];

memory_write_bytes(address, bytes: N, value: Registers[S]);
```
### `ldp`
#### Description
The `ldp` instruction loads the given registers with a value from a memory address.

#### Assembler Symbols
```
; ldp is an alias for ldpq

ldp <Rd>, <Rn>, [<Rs>, <Ro>]
ldp <Rd>, <Rn>, [<Rs>, <Imm13>]
ldp <Rd>, <Rn>, [<Rs>]            ; alias for: ldp <Rd>, <Rn> [<Rs>, 0]
```

`<Rd>`: The first register to load the value into
`<Rn>`: The second register to load the value into
`<Rs>`: The register containing the base address to load from.
`<Ro>`: The register to offset the address by.
`<Imm13>`: The signed 13-bit immediate value to offset the address by.

#### Load Sizes
|Mnemonic|Bytes read|
|-|-|
|`ldpb`|`1`|
|`ldpw`|`2`|
|`ldpd`|`4`|
|`ldpq`/`ldp`|`8`|

#### Pseudocode
```c
// 0110000 RRRRR DDDDD NN SSSSS IIIIIIII
flags = get_flags();

address = Registers[S] + sign_extend(I, bits: 8);

Registers[R] = memory_read_bytes(address, bytes: N);
Registers[D] = memory_read_bytes(address + N, bytes: N);

restore_flags(flags);
```
```c
// 10010000 __ NN RRRRR DDDDD SSSSS OOOOO
flags = get_flags();

address = Registers[S] + Registers[O];

Registers[R] = memory_read_bytes(address, bytes: N);
Registers[D] = memory_read_bytes(address + N, bytes: N);

restore_flags(flags);
```
### `stp`
#### Description
The `stp` instruction stores the given registers to a memory address.

#### Assembler Symbols
```
; stp is an alias for stpq

stp <Rd>, <Rn>, [<Rs>, <Ro>]
stp <Rd>, <Rn>, [<Rs>, <Imm13>]
stp <Rd>, <Rn>, [<Rs>]            ; alias for: stp <Rd>, <Rn> [<Rs>, 0]
```

`<Rd>`: The first register to load the value into
`<Rn>`: The second register to load the value into
`<Rs>`: The register containing the base address to load from.
`<Ro>`: The register to offset the address by.
`<Imm13>`: The signed 13-bit immediate value to offset the address by.

#### Load Sizes
|Mnemonic|Bytes read|
|-|-|
|`stpb`|`1`|
|`stpw`|`2`|
|`stpd`|`4`|
|`stpq`/`stp`|`8`|

#### Pseudocode
```c
// 0110000 RRRRR SSSSS NN DDDDD IIIIIIII
address = Registers[D] + sign_extend(I, bits: 8);

memory_write_bytes(address, bytes: N, value: Registers[R]);
memory_write_bytes(address + N, bytes: N, value: Registers[S]);
```
```c
// 10010001 __ NN RRRRR SSSSS DDDDD OOOOO
address = Registers[D] + Registers[O];

memory_write_bytes(address, bytes: N, value: Registers[R]);
memory_write_bytes(address + N, bytes: N, value: Registers[S]);
```

## Bit Instructions
### `bxt`
#### Description
The `sbxt` and `ubxt` instructions extract bits from the second register and store them in the first register.

#### Assembler Symbols
```
sbxt <Rd>, <Rs>, <ImmStart6>, <ImmCount6>
ubxt <Rd>, <Rs>, <ImmStart6>, <ImmCount6>
```

`<Rd>`: The register to store the extracted bits in.
`<Rs>`: The register to load the bits from
`<ImmStart6>`: The lowest bit to load.
`<ImmCount6>`: The amount of bits starting at `<ImmStart6>` to load.

The `sbxt` mnemonic causes sign extention.

#### Pseudocode
```c
// 0101110 DDDDD SSSSS __ X NNNNNN LLLLLL
bitmask = bitmask(bits: N);
value = Registers[S] & (bitmask << L);
if (X) {
    value = sign_extend(value, bits: N);
}
Registers[D] = value;
```

### `bdp`
#### Description
The `sbdp` and `ubdp` instructions deposit bits from the second register into the first register.

#### Assembler Symbols
```
sbdp <Rd>, <Rs>, <ImmStart6>, <ImmCount6>
ubdp <Rd>, <Rs>, <ImmStart6>, <ImmCount6>
```

`<Rd>`: The register to deposit the bits into.
`<Rs>`: The register to load the bits from.
`<ImmStart6>`: The location where to store the bits in the destination register.
`<ImmCount6>`: The amount of bits starting at `<ImmStart6>` to store.

Even though there are two mnemonics for a bit deposit, both `sbdp` and `ubdp` behave in exactly the same way.

#### Pseudocode
```c
// 0101111 DDDDD SSSSS __ X NNNNNN LLLLLL
bitmask = bitmask(bits: N);
value = (Registers[S] & bitmask) << L;
Registers[D] = Registers[D] & (invert_mask(bitmask) << L);
Registers[D] = Registers[D] | value;
```

## Test and Compare
### `tst`
#### Description
The `tst` instruction calculates the logical and between two values and sets the flags accordingly.
The result is ignored.

#### Assembler Symbols
```
tst <Rn>, <Rm>
tst <Rn>, <Imm20>
```

`<Rn>`: The left register of the and operation.
`<Rm>`: The right register of the and operation.
`<Imm20>`: The right value of the and operation.

#### Pseudocode
```c
// 10001110 _________ AAAAA BBBBB _____
set_flags(Registers[A] & Registers[B]);
```
```c
// 1100010 RRRRR IIIIIIIIIIIIIIIIIIII
set_flags(Registers[A] & zero_extend(I, bits: 20));
```
### `cmp`
#### Description
The `cmp` instruction calculates the difference of the two values and sets the flags accordingly.
The result is ignored.

#### Assembler Symbols
```
cmp <Rn>, <Rm>
cmp <Rn>, <Imm20>
```

`<Rn>`: The left register of the subtract operation.
`<Rm>`: The right register of the subtract operation.
`<Imm20>`: The right value of the subtract operation.

#### Pseudocode
```c
// 10001111 _________ AAAAA BBBBB _____
set_flags(Registers[A] - Registers[B]);
```
```c
// 1100011 RRRRR IIIIIIIIIIIIIIIIIIII
set_flags(Registers[A] - zero_extend(I, bits: 20));
```

## Loading Registers
### `lea`
#### Description
The `lea` instruction loads a register with the effective address of a label.

#### Assembler Symbols
```
lea <Rd>, <label>
```

`<Rn>`: The register to store the address in.
`<label>`: The program label to load the address of. It is the signed offset from the current instruction and is encoded as `O` times 4.

#### Pseudocode
```c
// 1100000 RRRRR OOOOOOOOOOOOOOOOOOOO
Registers[R] = PC + sign_extend(O, bits: 20);
```

### `movz`/`movk`
#### Description
The `movz` and `movk` instructions load a register with an immediate value.
The `movz` zeroes out the target register.
The `movk` zeroes out only the 16 bits selected to contain the immediate.

#### Assembler Symbols
```
movz <Rd>, <Imm16>, shl <Shift4>
movk <Rd>, <Imm16>, shl <Shift4>
movz <Rd>, <Imm16>                  ; alias for: movz <Rd>, <Imm16>, shl 0
movk <Rd>, <Imm16>                  ; alias for: movk <Rd>, <Imm16>, shl 0
```

`<Rn>`: The register to store the immediate value in
`<Imm16>`: The immediate value to store.
`<Shift4>`: How many 16-bit slots to shift the value by before storing.

#### Pseudocode
```c
// 1100001 RRRRR _ N SS IIIIIIIIIIIIIIII
mask = invert_mask(bitmask(bits: 16)) << S;
value = zero_extend(I, bits: 16) << S;
if (N) {
    Registers[R] = value;
} else {
    Registers[R] = Registers[R] & mask;
    Registers[R] = Registers[R] | value;
}
```

### `svc`
#### Pseudocode
```c
// 1100100 _________________________
flags = get_flags();

Registers[0] = execute_system_call(
    Registers[0],
    Registers[1],
    Registers[2],
    Registers[3],
    Registers[4],
    Registers[5],
    Registers[6],
    Registers[7]
);

restore_flags(flags);
```

## Float Operations
### `fadd`
#### Pseudocode
```c
// 100100100000 _____ DDDDD AAAAA BBBBB
FloatRegisters[D] = FloatRegisters[A] + FloatRegisters[B];
```
### `faddi`
#### Pseudocode
```c
// 100100100001 _____ DDDDD AAAAA BBBBB
FloatRegisters[D] = FloatRegisters[A] + convert_to_float64(Registers[B]);
```
### `fsub`
#### Pseudocode
```c
// 100100100010 _____ DDDDD AAAAA BBBBB
FloatRegisters[D] = FloatRegisters[A] - FloatRegisters[B];
```
### `fsubi`
#### Pseudocode
```c
// 100100100011 _____ DDDDD AAAAA BBBBB
FloatRegisters[D] = FloatRegisters[A] - convert_to_float64(Registers[B]);
```
### `fmul`
#### Pseudocode
```c
// 100100100100 _____ DDDDD AAAAA BBBBB
FloatRegisters[D] = FloatRegisters[A] * FloatRegisters[B];
```
### `fmuli`
#### Pseudocode
```c
// 100100100101 _____ DDDDD AAAAA BBBBB
FloatRegisters[D] = FloatRegisters[A] * convert_to_float64(Registers[B]);
```
### `fdiv`
#### Pseudocode
```c
// 100100100110 _____ DDDDD AAAAA BBBBB
FloatRegisters[D] = FloatRegisters[A] / FloatRegisters[B];
```
### `fdivi`
#### Pseudocode
```c
// 100100100111 _____ DDDDD AAAAA BBBBB
FloatRegisters[D] = FloatRegisters[A] / convert_to_float64(Registers[B]);
```
### `fmod`
#### Pseudocode
```c
// 100100101000 _____ DDDDD AAAAA BBBBB
FloatRegisters[D] = FloatRegisters[A] % FloatRegisters[B];
```
### `fmodi`
#### Pseudocode
```c
// 100100101001 _____ DDDDD AAAAA BBBBB
FloatRegisters[D] = FloatRegisters[A] % convert_to_float64(Registers[B]);
```
### `i2f`
#### Pseudocode
```c
// 100100101010 _____ DDDDD SSSSS
FloatRegisters[D] = convert_to_float64(Registers[S]);
```
### `f2i`
#### Pseudocode
```c
// 100100101011 _____ DDDDD SSSSS
Registers[D] = convert_to_int64(FloatRegisters[S]);
```
### `fsin`
#### Pseudocode
```c
// 100100101100 _____ DDDDD SSSSS
FloatRegisters[D] = sin(FloatRegisters[S]);
```
### `fsqrt`
#### Pseudocode
```c
// 100100101101 _____ DDDDD SSSSS
FloatRegisters[D] = sqrt(FloatRegisters[S]);
```
### `fcmp`
#### Pseudocode
```c
// 100100101110 _____ AAAAA BBBBB
set_flags(FloatRegisters[A] % FloatRegisters[B]);
```
### `fcmpi`
#### Pseudocode
```c
// 100100101111 _____ AAAAA BBBBB
set_flags(FloatRegisters[A] % convert_to_float64(Registers[B]));
```
