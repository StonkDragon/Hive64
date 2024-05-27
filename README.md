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

### Memory read/write alignment
Reading a certain type from memory must be done aligned:
- byte: 1 byte alignment
- word: 2 byte alignment
- doubleword: 4 byte alignment
- quadword: 4 byte alignment
- single precision float: 4 byte alignment
- double precision float: 4 byte alignment

## Registers
Hive64 has 32 general purpose/scalar registers.
All scalar registers have quadword size.
These registers can hold both integers and floating point numbers.
Of the 32 registers 3 are reserved for special use:
- `r29`/`lr`: The link register
- `r30`/`sp`: The stack pointer
- `r31`/`pc`: The program counter

### Register Mnemonics
- `bX`: A byte-sized register where `X` is the register number
- `wX`: A word-sized register where `X` is the register number
- `dX`: A doubleword-sized register where `X` is the register number
- `qX`: A quadword-sized register where `X` is the register number
- `rX`: A quadword-sized register where `X` is the register number

### Register size overrides
Using size overrides, the register size can be temporarily changed for an instruction to byte, word, or doubleword size.
If that is the case, using the `h` suffix for a register will instead access the high half of the next biggest type (where `X` is the register number):
- `bXh`: 2nd byte in word-sized register (`000000000000xx00` instead of `00000000000000xx`)
- `wXh`: 2nd word in doubleword-sized register (`00000000xxxx0000` instead of `000000000000xxxx`)
- `dXh`: 2nd doubleword in quadword-sized register (`xxxxxxxx00000000` instead of `00000000xxxxxxxx`)

Size overrides are inferred by the first register in the instruction:
```
add b0, b1, b2
```
All registers in an instruction must have the same size (Exception: Address/offset register in `ldr`/`str` instructions -> always 64-bit)

Operating on any part of the register using a size override leaves all other parts unchanged.
When operating on non-quadword sized registers, only the low 16 registers are accessible, as the high bit of the register field is used to encode the register half.

## Vector registers
Hive64 has 16 vector registers.
All vector registers have a size of 512 bits.
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

## Control registers
Hive64 has 12 control registers.
Control registers are quadword sized.
Control registers can only be directly read and written, and not used in other instructions.
Use `mov crX, rX` to write to a control register.
Use `mov rX, crX` to read from a control register.

- `cr0`: Amount of instructions executed. Updated after instructions
- `cr1`: Amount of cores
- `cr2`: Amount of threads per core
- `cr3`: Core id
- `cr4`: [Flags register](#flag-register)
- `cr5`: [Interrupt descriptor table](#interrupts)
- `cr6`: [Current privilege level](#privileges)

All other control registers have unspecified values and may be used in the future.

The `cpuid` instruction reads these registers.

### Flag register
The flag register contains the current processor flags (zero, negative), current operand size, and register part state.
The zero and negative flags get updated by all arithmetic and floating point operations, immediate value loads, and register to register transfers (except `lr` to `pc` transfers).

### Interrupts
Some operations can cause interrupts to occur, such as:
- writing to an invalid address (causes `SIGSEGV`)
- writing to/reading from an unaligned address (causes `SIGBUS`)
- trying to decode and execute an illegal instruction (causes `SIGILL`)
- trying to execute a privileged instruction with insufficient privileges (causes `SIGTRAP`)

### Privileges
Hive64 has 3 privilege levels.

#### Hypervisor Mode
- In charge of CPU management
- "First responder" to CPU interrupts
- The processor starts up in this mode
- Prepares the processor for an OS to boot up
- Unrestricted access to the hardware

#### Supervisor Mode
- Runs the kernel of the OS
- Near unrestricted access to the hardware

#### User Mode
- Least privileged mode
- Runs user programs

## Calling convention
The first 8 arguments are passed in registers `r0` - `r15`.
Further arguments are passed on the stack.
If a struct bigger than 128 bytes is passed as an argument, the register corresponding to that argument (for example `r0`) must contain a pointer to a temporary object on the stack.
The return value is in `r0`.
When returning a struct bigger than 64 bits, further registers may be used in order `r1` -> `r15`.
If a struct bigger than 128 bytes is returned, then `r0` will contain a pointer to a caller-allocated temporary storage location on the stack for the returned struct, and arguments start at `r1`.
All registers used by a function that aren't intended to return a value must be saved and restored by the function.

## Instructions
In Hive64 all instructions are conditional, meaning they only execute when a certain flag is set or not set.
Conditions:
|Condition|Flags|Bit value|Assembler symbol (where `<instr>` is the mnemonic)|
|-|-|-|-|
|Equal|Zero flag set|`000`|`<instr>.eq`/`<instr>.z`|
|Less than or equal|Zero or negative flag set|`001`|`<instr>.le`|
|Less than|Negative flag set|`010`|`<instr>.lt`/`<instr>.mi`|
|Always|Any flag state|`011`|No symbol|

Inverses:
|Condition|Flags|Bit value|Assembler symbol (where `<instr>` is the mnemonic)|
|-|-|-|-|
|Not equal|Zero flag not set|`100`|`<instr>.ne`/`<instr>.nz`|
|Greater than|Zero and negative flag not set|`101`|`<instr>.gt`|
|Greater than or equal|Negative flag not set|`110`|`<instr>.ge`/`<instr>.pl`|
|Never|Any flag state|`111`|No symbol|

The 'Always' condition means the instruction always executes.
The 'Never' condition means the instruction never executes.

The instruction condition is checked before the instruction is fully decoded, meaning some illegal instructions with a 'Never' condition won't throw a `SIGILL` [exception](#exceptions).

Instructions always have a length that is a multiple of 4 bytes.

### Instruction encoding description
- `[]`: all bits in brackets belong to some argument
- `.`: this bit is ignored by the instruction
- `ccc`: specifies under which condition the instruction should execute
- `[rX-]`: scalar registers

Every condition except `always` and `never` can be specified in the assembler by putting `.` followed by the condition after the instruction mnemonic.

### Exceptions
- `SIGILL`: raised when an undefined instruction or an instruction which is undefined for the given parameters is executed
- `SIGSEGV`: raised when an invalid memory address is read/written
- `SIGBUS`: raised on an unaligned memory access
- `SIGTRAP`: raised when a privileged instruction gets executed

### `cpuid` Instruction
Executing a `cpuid` instruction with `r0` set to `0` causes `r0` to be set to the current core id.
Executing a `cpuid` instruction with `r0` set to `1` causes `r0` to be set to the amount of cores in the cpu.
Executing a `cpuid` instruction with `r0` set to `2` causes `r0` to be set to the amount of threads per core in the cpu.
Any other value for `r0` is unspecified.

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
