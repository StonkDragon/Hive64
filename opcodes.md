# Opcodes
## Branch type opcodes (0b00xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)
    0b00kkklnnnnnnnnnnnnnnnnnnnnnnnnnn
        |  ||
        |  |+-------------------------> 26-bit offset
        |  +--------------------------> Link
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

### `cbz`/`cbnz` specific
    0b00kkklrrrrrznnnnnnnnnnnnnnnnnnnn
        |  ||    ||
        |  ||    |+-------------------> 20-bit offset
        |  ||    +--------------------> Zero
        |  |+-------------------------> Register
        |  +--------------------------> Link
        +-----------------------------> Branch type

## Reg-Reg-Imm type opcodes (0b01xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)
    0b01kkkkknnnnnmmmmmiiiiiiiiiiiiiii
        |    |    |    |
        |    |    |    +--------------> 15-bit immediate
        |    |    +-------------------> Register 2
        |    +------------------------> Register 1
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

### `ldr`/`str` specific
    0b01kkkkknnnnnmmmmmssiiiiiiiiiiiii
        |    |    |    | |
        |    |    |    | +------------> 13-bit immediate
        |    |    |    +--------------> Size of load/store
        |    |    +-------------------> Register 2
        |    +------------------------> Register 1
        +-----------------------------> Operation

### `ldp`/`stp` specific
    0b01kkkkkssnnnnnmmmmmoooooiiiiiiii
        |    | |    |    |    |
        |    | |    |    |    +-------> 8-bit immediate
        |    | |    |    +------------> Register 3
        |    | |    +-----------------> Register 2
        |    | +----------------------> Register 1
        |    +------------------------> Size of load/store
        +-----------------------------> Operation

### `bxt`/`bdp` specific
    0b01kkkkknnnnnemmmmmssssss00llllll
        |    |    ||    |       |
        |    |    ||    |       +-----> Lowest bit
        |    |    ||    +-------------> Number of bits
        |    |    |+------------------> Register 2
        |    |    +-------------------> Sign extend
        |    +------------------------> Register 1
        +-----------------------------> Operation

## Reg-Reg-Reg type opcodes (0b10xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)
    0b10kkkkkk000nnnnn000mmmmm000ooooo
        |        |       |       |
        |        |       |       +----> Register 3
        |        |       +------------> Register 2
        |        +--------------------> Register 1
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
    0b10010010kkkknnnnn00mmmmm000ooooo
              |        |       | |
              |        |       | +----> Register 3
              |        |       +------> Register 2
              |        +--------------> Register 1
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
    0b110kkkknnnnniiiiiiiiiiiiiiiiiiii
         |   |    |
         |   |    +-------------------> 20-bit immediate
         |   +------------------------> Register 1
         +----------------------------> Operation

|Operation|Name|
|-|-|
|`0000`|`lea`|
|`0001`|`movz`/`movk`|
|`0010`|`tst`|
|`0011`|`cmp`|
|`0100`|`svc`|

#### `movz`/`movk` specific
    0b110kkkk0zssnnnnniiiiiiiiiiiiiiii
         |    || |    |
         |    || |    +---------------> 16-bit immediate
         |    || +--------------------> Register 1
         |    |+----------------------> Shift
         |    +-----------------------> Don't zero register
         +----------------------------> Operation

### When 'Is Branch' is 1
    0b111kkklnnnnn00000000000000000000
         |  ||
         |  |+------------------------> Register 1
         |  +-------------------------> Link
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

#### `cbrz`/`cbrnz` specific
    0b111kkklnnnnn00000000000000zmmmmm
         |  ||                  ||
         |  ||                  |+----> Register 2
         |  ||                  +-----> Zero
         |  |+------------------------> Register 1
         |  +-------------------------> Link
         +----------------------------> Operation
