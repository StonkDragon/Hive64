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
Using the `h` suffix on a quadword register is undefined.
`h`-suffixed registers are encoded with a [prefix instruction](#prefix-instruction) specifying a register override.

## Vector registers
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

### List of instructions
- [Branches](#branches)
- [Integer Arithmetic](#integer-arithmetic)
- [Prefix instruction](#prefix-instruction)
- [Floating point Arithmetic](#floating-point-arithmetic)
- [Utility](#utility)
- [Data transfer](#data-transfer)
- [Vector Operations](#vector-operations)

### Exceptions
- `SIGILL`: raised when an undefined instruction or an instruction which is undefined for the given parameters is executed
- `SIGSEGV`: raised when an invalid memory address is read/written
- `SIGBUS`: raised on an unaligned memory access
- `SIGTRAP`: raised when a privileged instruction gets executed

### Branches
|Mnemonic|Encoding|Description|
|-|-|-|
|`ret`|                     `ccc01100001111111101000100000000`|`pc = lr`|
|`b offset`|                `ccc0000[---------imm25---------]`|`pc = pc + imm25`|
|`bl offset`|               `ccc0001[---------imm25---------]`|`lr = pc; pc = pc + imm25`|
|`br r1`|                   `ccc0010[r1-]....................`|`pc = r1`|
|`blr r1`|                  `ccc0011[r1-]....................`|`lr = pc; pc = r1`|

### Integer Arithmetic
#### Register and Immediate value
|Mnemonic|Encoding|Description|
|-|-|-|
|`add r1, r2, imm`|         `ccc0100000[r1-][r2-]0001[-imm8-]`|`r1 = r2 + imm`|
|`sub r1, r2, imm`|         `ccc0100010[r1-][r2-]0001[-imm8-]`|`r1 = r2 - imm`|
|`cmp r1, imm`|             `ccc0100011.....[r2-]0001[-imm8-]`|`r2 - imm` (only sets flags)|
|`mul r1, r2, imm`|         `ccc0100100[r1-][r2-]0001[-imm8-]`|`r1 = r2 * imm`|
|`div r1, r2, imm`|         `ccc0100110[r1-][r2-]0001[-imm8-]`|`r1 = r2 / imm`|
|`divs r1, r2, imm`|        `ccc0100110[r1-][r2-]0011[-imm8-]`|`r1 = r2 / imm`|
|`mod r1, r2, imm`|         `ccc0101000[r1-][r2-]0001[-imm8-]`|`r1 = r2 % imm`|
|`mods r1, r2, imm`|        `ccc0101000[r1-][r2-]0011[-imm8-]`|`r1 = r2 % imm`|
|`and r1, r2, imm`|         `ccc0101010[r1-][r2-]0001[-imm8-]`|`r1 = r2 & imm`|
|`tst r1, imm`|             `ccc0101011.....[r2-]0001[-imm8-]`|`r2 & imm` (only sets flags)|
|`or r1, r2, imm`|          `ccc0101100[r1-][r2-]0001[-imm8-]`|`r1 = r2 \| imm`|
|`xor r1, r2, imm`|         `ccc0101110[r1-][r2-]0001[-imm8-]`|`r1 = r2 ^ imm`|
|`shl r1, r2, imm`|         `ccc0110000[r1-][r2-]0001[-imm8-]`|`r1 = r2 << imm`|
|`asl r1, r2, imm`|         `ccc0110000[r1-][r2-]0011[-imm8-]`|`r1 = r2 << imm` (signed immediate)|
|`shr r1, r2, imm`|         `ccc0110010[r1-][r2-]0001[-imm8-]`|`r1 = r2 >> imm`|
|`asr r1, r2, imm`|         `ccc0110010[r1-][r2-]0011[-imm8-]`|`r1 = r2 >> imm` (signed immediate)|
|`rol r1, r2, imm`|         `ccc0110100[r1-][r2-]0001[-imm8-]`|`r1 = r2 <<< imm`|
|`ror r1, r2, imm`|         `ccc0110110[r1-][r2-]0001[-imm8-]`|`r1 = r2 >>> imm`|

#### Register and Register
|Mnemonic|Encoding|Description|
|-|-|-|
|`add r1, r2, r3`|          `ccc0100000[r1-][r2-]0000...[r3-]`|`r1 = r2 + r3`|
|`sub r1, r2, r3`|          `ccc0100010[r1-][r2-]0000...[r3-]`|`r1 = r2 - r3`|
|`cmp r1, r2`|              `ccc0100011.....[r2-]0000...[r3-]`|`r2 - r3` (only sets flags)|
|`mul r1, r2, r3`|          `ccc0100100[r1-][r2-]0000...[r3-]`|`r1 = r2 * r3`|
|`div r1, r2, r3`|          `ccc0100110[r1-][r2-]0000...[r3-]`|`r1 = r2 / r3`|
|`divs r1, r2, r3`|         `ccc0100110[r1-][r2-]0010...[r3-]`|`r1 = r2 / r3`|
|`mod r1, r2, r3`|          `ccc0101000[r1-][r2-]0000...[r3-]`|`r1 = r2 % r3`|
|`mods r1, r2, r3`|         `ccc0101000[r1-][r2-]0010...[r3-]`|`r1 = r2 % r3`|
|`and r1, r2, r3`|          `ccc0101010[r1-][r2-]0000...[r3-]`|`r1 = r2 & r3`|
|`tst r1, r2`|              `ccc0101011.....[r2-]0000...[r3-]`|`r2 & r3` (only sets flags)|
|`or r1, r2, r3`|           `ccc0101100[r1-][r2-]0000...[r3-]`|`r1 = r2 \| r3`|
|`xor r1, r2, r3`|          `ccc0101110[r1-][r2-]0000...[r3-]`|`r1 = r2 ^ r3`|
|`shl r1, r2, r3`|          `ccc0110000[r1-][r2-]0000...[r3-]`|`r1 = r2 << r3`|
|`asl r1, r2, r3`|          `ccc0110000[r1-][r2-]0010...[r3-]`|`r1 = r2 << r3` (signed register)|
|`shr r1, r2, r3`|          `ccc0110010[r1-][r2-]0000...[r3-]`|`r1 = r2 >> r3`|
|`asr r1, r2, r3`|          `ccc0110010[r1-][r2-]0010...[r3-]`|`r1 = r2 >> r3` (signed register)|
|`rol r1, r2, r3`|          `ccc0110100[r1-][r2-]0000...[r3-]`|`r1 = r2 <<< r3`|
|`ror r1, r2, r3`|          `ccc0110110[r1-][r2-]0000...[r3-]`|`r1 = r2 >>> r3`|
|`neg r1, r2`|              `ccc0111000[r1-][r2-]000.........`|`r1 = -r2`|
|`not r1, r2`|              `ccc0111010[r1-][r2-]000.........`|`r1 = ~r2`|
|`extbw r1, r2`|            `ccc0111100[r1-][r2-]00......0100`|`r1 = extend_sign(r1, from: 8, to: 16)` (undefined when target size is smaller than source size)|
|`extbd r1, r2`|            `ccc0111100[r1-][r2-]00......1000`|`r1 = extend_sign(r1, from: 8, to: 32)` (undefined when target size is smaller than source size)|
|`extbq r1, r2`|            `ccc0111100[r1-][r2-]00......1100`|`r1 = extend_sign(r1, from: 8, to: 64)` (undefined when target size is smaller than source size)|
|`extwd r1, r2`|            `ccc0111100[r1-][r2-]00......1001`|`r1 = extend_sign(r1, from: 16, to: 32)` (undefined when target size is smaller than source size)|
|`extwq r1, r2`|            `ccc0111100[r1-][r2-]00......1101`|`r1 = extend_sign(r1, from: 16, to: 64)` (undefined when target size is smaller than source size)|
|`extdq r1, r2`|            `ccc0111100[r1-][r2-]00......1110`|`r1 = extend_sign(r1, from: 32, to: 64)` (undefined when target size is smaller than source size)|
|`swe r1, r2`|              `ccc0111110[r1-][r2-]000.........`|`r1 = swap_bytes(r2)` (undefined for byte registers)|

### Prefix Instruction
The prefix instruction always look like this: `0111100001...............CBADFsz`
A capital letter indicates the default value of the bit is `0`.
A lowercase letter indicates the default value of the bit is `1`.
- `sz`: Size override. One of `00` (byte), `01` (word), `10` (doubleword), or `11` (quadword)
- `F`: When set, `zero` and `negative` flags won't update
- `D`, `A`, `B`, `C`: Whether the destination/source 1/source 2/source 3 corresponds to the high register parts.

The prefix instruction is optional and changes the next instructions behaviour (for example changing the amount of bytes loaded in a `ldr` instruction)
Specifying any register part override (`A`/`B`/`C`/`D`) and leaving `sz` set to `11` is undefined.
Specifying any control register selector (`X`/`Y`/`Z`/`W`) for a register number >= 12 is undefined.

### Floating point Arithmetic
|Mnemonic|Encoding|Description|
|-|-|-|
|`fadd r1, r2, r3`|         `ccc0100000[r1-][r2-]011000.[r3-]`|`r1 = r2 + r3`|
|`faddi r1, r2, r3`|        `ccc0100000[r1-][r2-]011010.[r3-]`|`r1 = r2 + r3`|
|`fsub r1, r2, r3`|         `ccc0100010[r1-][r2-]011000.[r3-]`|`r1 = r2 - r3`|
|`fsubi r1, r2, r3`|        `ccc0100010[r1-][r2-]011010.[r3-]`|`r1 = r2 - r3`|
|`fcmp r2, r3`|             `ccc0100011.....[r2-]011000.[r3-]`|`r2 - r3` (only sets flags)|
|`fcmpi r2, r3`|            `ccc0100011.....[r2-]011010.[r3-]`|`r2 - r3` (only sets flags)|
|`fmul r1, r2, r3`|         `ccc0100100[r1-][r2-]011000.[r3-]`|`r1 = r2 * r3`|
|`fmuli r1, r2, r3`|        `ccc0100100[r1-][r2-]011010.[r3-]`|`r1 = r2 * r3`|
|`fdiv r1, r2, r3`|         `ccc0100110[r1-][r2-]011000.[r3-]`|`r1 = r2 / r3`|
|`fdivi r1, r2, r3`|        `ccc0100110[r1-][r2-]011010.[r3-]`|`r1 = r2 / r3`|
|`fmod r1, r2, r3`|         `ccc0101000[r1-][r2-]011000.[r3-]`|`r1 = r2 % r3`|
|`fmodi r1, r2, r3`|        `ccc0101000[r1-][r2-]011010.[r3-]`|`r1 = r2 % r3`|
|`fsin r1, r2`|             `ccc0101010[r1-][r2-]011000......`|`r1 = sin(r2)`|
|`fsini r1, r2`|            `ccc0101010[r1-][r2-]011010......`|`r1 = sin(integer_to_double(r2))`|
|`fsqrt r1, r2`|            `ccc0101100[r1-][r2-]011000......`|`r1 = sqrt(r2)`|
|`fsqrti r1, r2`|           `ccc0101100[r1-][r2-]011010......`|`r1 = sqrt(integer_to_double(r2))`|
|`f2i r1, r2`|              `ccc0101110[r1-][r2-]011000......`|`r1 = double_to_integer(r2)`|
|`i2f r1, r2`|              `ccc0101110[r1-][r2-]011010......`|`r1 = integer_to_double(r2)`|
|`sadd r1, r2, r3`|         `ccc0100000[r1-][r2-]011001.[r3-]`|`r1 = r2 + r3`|
|`saddi r1, r2, r3`|        `ccc0100000[r1-][r2-]011011.[r3-]`|`r1 = r2 + r3`|
|`ssub r1, r2, r3`|         `ccc0100010[r1-][r2-]011001.[r3-]`|`r1 = r2 - r3`|
|`ssubi r1, r2, r3`|        `ccc0100010[r1-][r2-]011011.[r3-]`|`r1 = r2 - r3`|
|`scmp r2, r3`|             `ccc0100011.....[r2-]011001.[r3-]`|`r2 - r3` (only sets flags)|
|`scmpi r2, r3`|            `ccc0100011.....[r2-]011011.[r3-]`|`r2 - r3` (only sets flags)|
|`smul r1, r2, r3`|         `ccc0100100[r1-][r2-]011001.[r3-]`|`r1 = r2 * r3`|
|`smuli r1, r2, r3`|        `ccc0100100[r1-][r2-]011011.[r3-]`|`r1 = r2 * r3`|
|`sdiv r1, r2, r3`|         `ccc0100110[r1-][r2-]011001.[r3-]`|`r1 = r2 / r3`|
|`sdivi r1, r2, r3`|        `ccc0100110[r1-][r2-]011011.[r3-]`|`r1 = r2 / r3`|
|`smod r1, r2, r3`|         `ccc0101000[r1-][r2-]011001.[r3-]`|`r1 = r2 % r3`|
|`smodi r1, r2, r3`|        `ccc0101000[r1-][r2-]011011.[r3-]`|`r1 = r2 % r3`|
|`ssin r1, r2`|             `ccc0101010[r1-][r2-]011001......`|`r1 = sin(r2)`|
|`ssqrt r1, r2`|            `ccc0101100[r1-][r2-]011011......`|`r1 = sqrt(r2)`|
|`s2i r1, r2`|              `ccc0101110[r1-][r2-]011001......`|`r1 = single_to_integer(r2)`|
|`i2s r1, r2`|              `ccc0101110[r1-][r2-]011011......`|`r1 = integer_to_single(r2)`|
|`s2f r1, r2`|              `ccc0110000[r1-][r2-]011000......`|`r1 = single_to_double(r2)`|
|`f2s r1, r2`|              `ccc0110000[r1-][r2-]011001......`|`r1 = double_to_single(r2)`|

### Utility
|Mnemonic|Encoding|Description|
|-|-|-|
|`cpuid`|                   `ccc1100000......................`|Returns information about the cpu (See [`cpuid`](#cpuid-instruction))|
|`zeroupper r1`|            `ccc1100010.................[r1-]`|`r1 = zero_upper(r2)` (undefined for quadword registers)|
|`sret`|                    `ccc1100011......................`|Supervisor return (only in supervisor mode)|
|`hret`|                    `ccc1100100......................`|Hypervisor return (only in hypervisor mode)|
|`iret`|                    `ccc1100101......................`|Return from interrupt (only in hypervisor mode)|
|`svc`|                     `ccc1100110......................`|Supervisor call|
|`mov cr1, r2`|             `ccc1100111............[cr1][r1-]`|Load control register with value (only in hypervisor mode)|
|`mov r1, cr2`|             `ccc1101000............[cr1][r1-]`|Get value of control register (only in hypervisor mode)|
|`hexit`|                   `ccc1101001......................`|Exit hypervisor mode (only in hypervisor mode)|
|`sexit`|                   `ccc1101010......................`|Exit supervisor mode (only in supervisor mode)|

### Data transfer
|Mnemonic|Encoding|Description|
|-|-|-|
|`mov r1, r2`|              `ccc0110000[r1-][r2-]000100000000`|`r1 = r2`|
|`lea r1, offset`|          `ccc1000[r1-][------imm20-------]`|`r1 = pc + offset`|
|`movz r1, imm`|            `ccc1001[r1-].000[----imm16-----]`|`r1 = imm`|
|`movz r1, imm, shl 16`|    `ccc1001[r1-].001[----imm16-----]`|`r1 = imm << 16`|
|`movz r1, imm, shl 32`|    `ccc1001[r1-].010[----imm16-----]`|`r1 = imm << 32`|
|`movz r1, imm, shl 48`|    `ccc1001[r1-].011[----imm16-----]`|`r1 = imm << 48`|
|`movk r1, imm`|            `ccc1001[r1-].100[----imm16-----]`|`r1 \|= imm`|
|`movk r1, imm, shl 16`|    `ccc1001[r1-].101[----imm16-----]`|`r1 \|= imm << 16`|
|`movk r1, imm, shl 32`|    `ccc1001[r1-].110[----imm16-----]`|`r1 \|= imm << 32`|
|`movk r1, imm, shl 48`|    `ccc1001[r1-].111[----imm16-----]`|`r1 \|= imm << 48`|
|`ldr r1, [r2, r3]`|        `ccc1010[r1-]000[r2-]....shl[r3-]`|`r1 = *(r2 + r3 << shl)`|
|`ldr r1, [r2, r3]!`|       `ccc1010[r1-]001[r2-]....shl[r3-]`|`r1 = *(r2); r2 += r3 << shl`|
|`ldr r1, [r2, imm]`|       `ccc1010[r1-]010[r2-][--imm12---]`|`r1 = *(r2 + imm)`|
|`ldr r1, [r2, imm]!`|      `ccc1010[r1-]011[r2-][--imm12---]`|`r1 = *(r2); r2 += imm`|
|`str r1, [r2, r3]`|        `ccc1010[r1-]100[r2-]....shl[r3-]`|`*(r2 + r3 << shl) = r1`|
|`str r1, [r2, r3]!`|       `ccc1010[r1-]101[r2-]....shl[r3-]`|`r2 += r3 << shl; r1 = *(r2)`|
|`str r1, [r2, imm]`|       `ccc1010[r1-]110[r2-][--imm12---]`|`*(r2 + imm) = r1`|
|`str r1, [r2, imm]!`|      `ccc1010[r1-]111[r2-][--imm12---]`|`r2 += imm; r1 = *(r2)`|
|`ldr r1, [offset]`|        `ccc1011[r1-]0[------imm19------]`|`r1 = *offset`|
|`str r1, [offset]`|        `ccc1011[r1-]1[------imm19------]`|`*offset = r1`|
|`ubxt r1, r2, a, b`|       `ccc01[chi][r1-][r2-]01000l[strt]`|`r1 = extract_bits(r2, start: a, count: b)`|
|`sbxt r1, r2, a, b`|       `ccc01[chi][r1-][r2-]01001l[strt]`|`r1 = extend_sign(extract_bits(r2, start: a, count: b), from: b, to: 64)`|
|`ubdp r1, r2, a, b`|       `ccc01[chi][r1-][r2-]01010l[strt]`|`r1 = deposit_bits(r1, r2, start: a, count: b)`|
|`sbdp r1, r2, a, b`|       `ccc01[chi][r1-][r2-]01011l[strt]`|`r1 = deposit_bits(r1, r2, start: a, count: b)`|
|`cswap r1, r2, r3, cond`|  `ccc01.....[r1-][r2-]1000cnd[r3-]`|`if (check_condition(cnd)) { r1 = r2 } else { r1 = r3 }`|
|`xchg r1, r2`|             `ccc01.....[r1-][r2-]1001........`|`tmp = r1; r1 = r2; r2 = tmp`|

### Vector Operations
|Mnemonic|Encoding|Description|
|-|-|-|
|`vbadd v1, v2, v3`|        `ccc010000001[v2][v1]0111....[v3]`|`v1 = v2 + v3`|
|`voadd v1, v2, v3`|        `ccc010000000[v2][v1]0111....[v3]`|`v1 = v2 + v3`|
|`vwadd v1, v2, v3`|        `ccc010000010[v2][v1]0111....[v3]`|`v1 = v2 + v3`|
|`vdadd v1, v2, v3`|        `ccc010000011[v2][v1]0111....[v3]`|`v1 = v2 + v3`|
|`vqadd v1, v2, v3`|        `ccc010000100[v2][v1]0111....[v3]`|`v1 = v2 + v3`|
|`vladd v1, v2, v3`|        `ccc010000101[v2][v1]0111....[v3]`|`v1 = v2 + v3`|
|`vsadd v1, v2, v3`|        `ccc010000110[v2][v1]0111....[v3]`|`v1 = v2 + v3`|
|`vfadd v1, v2, v3`|        `ccc010000111[v2][v1]0111....[v3]`|`v1 = v2 + v3`|
|`vosub v1, v2, v3`|        `ccc010001000[v2][v1]0111....[v3]`|`v1 = v2 - v3`|
|`vbsub v1, v2, v3`|        `ccc010001001[v2][v1]0111....[v3]`|`v1 = v2 - v3`|
|`vwsub v1, v2, v3`|        `ccc010001010[v2][v1]0111....[v3]`|`v1 = v2 - v3`|
|`vdsub v1, v2, v3`|        `ccc010001011[v2][v1]0111....[v3]`|`v1 = v2 - v3`|
|`vqsub v1, v2, v3`|        `ccc010001100[v2][v1]0111....[v3]`|`v1 = v2 - v3`|
|`vlsub v1, v2, v3`|        `ccc010001101[v2][v1]0111....[v3]`|`v1 = v2 - v3`|
|`vssub v1, v2, v3`|        `ccc010001110[v2][v1]0111....[v3]`|`v1 = v2 - v3`|
|`vfsub v1, v2, v3`|        `ccc010001111[v2][v1]0111....[v3]`|`v1 = v2 - v3`|
|`vomul v1, v2, v3`|        `ccc010010000[v2][v1]0111....[v3]`|`v1 = v2 * v3`|
|`vbmul v1, v2, v3`|        `ccc010010001[v2][v1]0111....[v3]`|`v1 = v2 * v3`|
|`vwmul v1, v2, v3`|        `ccc010010010[v2][v1]0111....[v3]`|`v1 = v2 * v3`|
|`vdmul v1, v2, v3`|        `ccc010010011[v2][v1]0111....[v3]`|`v1 = v2 * v3`|
|`vqmul v1, v2, v3`|        `ccc010010100[v2][v1]0111....[v3]`|`v1 = v2 * v3`|
|`vlmul v1, v2, v3`|        `ccc010010101[v2][v1]0111....[v3]`|`v1 = v2 * v3`|
|`vsmul v1, v2, v3`|        `ccc010010110[v2][v1]0111....[v3]`|`v1 = v2 * v3`|
|`vfmul v1, v2, v3`|        `ccc010010111[v2][v1]0111....[v3]`|`v1 = v2 * v3`|
|`vodiv v1, v2, v3`|        `ccc010011000[v2][v1]0111....[v3]`|`v1 = v2 / v3`|
|`vbdiv v1, v2, v3`|        `ccc010011001[v2][v1]0111....[v3]`|`v1 = v2 / v3`|
|`vwdiv v1, v2, v3`|        `ccc010011010[v2][v1]0111....[v3]`|`v1 = v2 / v3`|
|`vddiv v1, v2, v3`|        `ccc010011011[v2][v1]0111....[v3]`|`v1 = v2 / v3`|
|`vqdiv v1, v2, v3`|        `ccc010011100[v2][v1]0111....[v3]`|`v1 = v2 / v3`|
|`vldiv v1, v2, v3`|        `ccc010011101[v2][v1]0111....[v3]`|`v1 = v2 / v3`|
|`vsdiv v1, v2, v3`|        `ccc010011110[v2][v1]0111....[v3]`|`v1 = v2 / v3`|
|`vfdiv v1, v2, v3`|        `ccc010011111[v2][v1]0111....[v3]`|`v1 = v2 / v3`|
|`voaddsub v1, v2, v3`|     `ccc010100000[v2][v1]0111....[v3]`|`v1 = add_sub(v2, v3)`|
|`vbaddsub v1, v2, v3`|     `ccc010100001[v2][v1]0111....[v3]`|`v1 = add_sub(v2, v3)`|
|`vwaddsub v1, v2, v3`|     `ccc010100010[v2][v1]0111....[v3]`|`v1 = add_sub(v2, v3)`|
|`vdaddsub v1, v2, v3`|     `ccc010100011[v2][v1]0111....[v3]`|`v1 = add_sub(v2, v3)`|
|`vqaddsub v1, v2, v3`|     `ccc010100100[v2][v1]0111....[v3]`|`v1 = add_sub(v2, v3)`|
|`vladdsub v1, v2, v3`|     `ccc010100101[v2][v1]0111....[v3]`|`v1 = add_sub(v2, v3)`|
|`vsaddsub v1, v2, v3`|     `ccc010100110[v2][v1]0111....[v3]`|`v1 = add_sub(v2, v3)`|
|`vfaddsub v1, v2, v3`|     `ccc010100111[v2][v1]0111....[v3]`|`v1 = add_sub(v2, v3)`|
|`vomadd v1, v2, v3`|       `ccc010101000[v2][v1]0111....[v3]`|`v1 = dot(v2, v3)`|
|`vbmadd v1, v2, v3`|       `ccc010101001[v2][v1]0111....[v3]`|`v1 = dot(v2, v3)`|
|`vwmadd v1, v2, v3`|       `ccc010101010[v2][v1]0111....[v3]`|`v1 = dot(v2, v3)`|
|`vdmadd v1, v2, v3`|       `ccc010101011[v2][v1]0111....[v3]`|`v1 = dot(v2, v3)`|
|`vqmadd v1, v2, v3`|       `ccc010101100[v2][v1]0111....[v3]`|`v1 = dot(v2, v3)`|
|`vlmadd v1, v2, v3`|       `ccc010101101[v2][v1]0111....[v3]`|`v1 = dot(v2, v3)`|
|`vsmadd v1, v2, v3`|       `ccc010101110[v2][v1]0111....[v3]`|`v1 = dot(v2, v3)`|
|`vfmadd v1, v2, v3`|       `ccc010101111[v2][v1]0111....[v3]`|`v1 = dot(v2, v3)`|
|`vomov v1, r2, at`|        `ccc010110000..hi[v1]0111slo[r2-]`|`v1[at] = r2`|
|`vbmov v1, r2, at`|        `ccc010110001..hi[v1]0111slo[r2-]`|`v1[at] = r2`|
|`vwmov v1, r2, at`|        `ccc010110010..hi[v1]0111slo[r2-]`|`v1[at] = r2`|
|`vdmov v1, r2, at`|        `ccc010110011..hi[v1]0111slo[r2-]`|`v1[at] = r2`|
|`vqmov v1, r2, at`|        `ccc010110100..hi[v1]0111slo[r2-]`|`v1[at] = r2`|
|`vlmov v1, r2, at`|        `ccc010110101..hi[v1]0111slo[r2-]`|`v1[at] = r2`|
|`vsmov v1, r2, at`|        `ccc010110110..hi[v1]0111slo[r2-]`|`v1[at] = r2`|
|`vfmov v1, r2, at`|        `ccc010110111..hi[v1]0111slo[r2-]`|`v1[at] = r2`|
|`vomov v1, v2`|            `ccc010111000[v2][v1]0111........`|`v1 = v2`|
|`vbmov v1, v2`|            `ccc010111001[v2][v1]0111........`|`v1 = v2`|
|`vwmov v1, v2`|            `ccc010111010[v2][v1]0111........`|`v1 = v2`|
|`vdmov v1, v2`|            `ccc010111011[v2][v1]0111........`|`v1 = v2`|
|`vqmov v1, v2`|            `ccc010111100[v2][v1]0111........`|`v1 = v2`|
|`vlmov v1, v2`|            `ccc010111101[v2][v1]0111........`|`v1 = v2`|
|`vsmov v1, v2`|            `ccc010111110[v2][v1]0111........`|`v1 = v2`|
|`vfmov v1, v2`|            `ccc010111111[v2][v1]0111........`|`v1 = v2`|
|`voconvT v1, v2`|          `ccc011000000[v2][v1]0111.....TTT`|`v1 = vector_convert(v2, target: T)`|
|`vbconvT v1, v2`|          `ccc011000001[v2][v1]0111.....TTT`|`v1 = vector_convert(v2, target: T)`|
|`vwconvT v1, v2`|          `ccc011000010[v2][v1]0111.....TTT`|`v1 = vector_convert(v2, target: T)`|
|`vdconvT v1, v2`|          `ccc011000011[v2][v1]0111.....TTT`|`v1 = vector_convert(v2, target: T)`|
|`vqconvT v1, v2`|          `ccc011000100[v2][v1]0111.....TTT`|`v1 = vector_convert(v2, target: T)`|
|`vlconvT v1, v2`|          `ccc011000101[v2][v1]0111.....TTT`|`v1 = vector_convert(v2, target: T)`|
|`vsconvT v1, v2`|          `ccc011000110[v2][v1]0111.....TTT`|`v1 = vector_convert(v2, target: T)`|
|`vfconvT v1, v2`|          `ccc011000111[v2][v1]0111.....TTT`|`v1 = vector_convert(v2, target: T)`|
|`volen r1, v2`|            `ccc011001000....[v1]0111...[r1-]`|`r1 = first_zero(v1)`|
|`vblen r1, v2`|            `ccc011001001....[v1]0111...[r1-]`|`r1 = first_zero(v1)`|
|`vwlen r1, v2`|            `ccc011001010....[v1]0111...[r1-]`|`r1 = first_zero(v1)`|
|`vdlen r1, v2`|            `ccc011001011....[v1]0111...[r1-]`|`r1 = first_zero(v1)`|
|`vqlen r1, v2`|            `ccc011001100....[v1]0111...[r1-]`|`r1 = first_zero(v1)`|
|`vllen r1, v2`|            `ccc011001101....[v1]0111...[r1-]`|`r1 = first_zero(v1)`|
|`vslen r1, v2`|            `ccc011001110....[v1]0111...[r1-]`|`r1 = first_zero(v1)`|
|`vflen r1, v2`|            `ccc011001111....[v1]0111...[r1-]`|`r1 = first_zero(v1)`|
|`vldr v1, [r2, imm]`|      `ccc01101010[r1-][v1]0111[-imm8-]`|`v1 = *(r2 + imm)`|
|`vldr v1, [r2, imm]!`|     `ccc01101011[r1-][v1]0111[-imm8-]`|`v1 = *(r2); r2 += imm`|
|`vstr v1, [r2, imm]`|      `ccc01101110[r1-][v1]0111[-imm8-]`|`*(r2 + imm) = v1`|
|`vstr v1, [r2, imm]!`|     `ccc01101111[r1-][v1]0111[-imm8-]`|`r2 += imm; v1 = *(r2)`|
|`vldr v1, [r2, r3]`|       `ccc01101000[r1-][v1]0111...[r2-]`|`v1 = *(r2 + r3)`|
|`vldr v1, [r2, r3]!`|      `ccc01101001[r1-][v1]0111...[r2-]`|`v1 = *(r2); r2 += r3`|
|`vstr v1, [r2, r3]`|       `ccc01101100[r1-][v1]0111...[r2-]`|`*(r2 + r3) + v1`|
|`vstr v1, [r2, r3]!`|      `ccc01101101[r1-][v1]0111...[r2-]`|`r2 += r3; v1 = *(r2)`|

#### Builtin functions
##### `extend_sign(register, from, to)`
Copies the bit in `register` at position `from` to all bits up to and including `to`.

##### `swap_bytes(register)`
Swaps all bytes in `register` (`aabbccdd` becomes `ddccbbaa`).

##### `sin(register)`
Returns the `sin` of `register`.

##### `sqrt(register)`
Returns the `sqrt` of `register`.

##### `single_to_integer(register)`
Converts the single precision float in `register` to a doubleword.

##### `double_to_integer(register)`
Converts the double precision float in `register` to a quadword.

##### `integer_to_single(register)`
Converts the doubleword in `register` to a single precision float.

##### `integer_to_double(register)`
Converts the quadword in `register` to a double precision float.

##### `double_to_single(register)`
Converts the double precision float in `register` to a single precision float.

##### `single_to_double(register)`
Converts the single precision float in `register` to a double precision float.

##### `extract_bits(register, start, count)`
Extracts `count` bits starting at bit `start` from `register`.

##### `deposit_bits(dest_reg, src_reg, start, count)`
Deposits the lowest `count` bits from `src_reg` into `dest_reg` starting at `start`. The bits to overwrite will be zeroed out first.

##### `add_sub(vreg_a, vreg_b)`
Adds even numbered elements in `vreg_a` and `vreg_b` and subtracts odd numbered elements in `vreg_a` and `vreg_b`.

##### `dot(vreg_a, vreg_b)`
Calculates the dot product of the two vectors and puts it in the low part of the returned vector register.

##### `vector_convert(vreg, target)`
Converts as many elements in `vreg` to the vector type `target` as would fit into a vector of type `target`.

##### `first_zero(vreg)`
Returns the index of the first element equal to `0` in `vreg`. If no zero element was found, the amount of elements in the vector is returned.

##### `check_condition(cond)`
Returns `1` if the given condition currently holds.

##### `zero_upper(reg)`
Zeroes out all bits in `reg` not accessible with the specified register identifier (where `X` is the register number, `v` is the register value, and `.` is any value):
- `bX`/`bXl`: register `X` will go from `..............vv` to `00000000000000vv`
- `wX`/`wXl`: register `X` will go from `............vvvv` to `000000000000vvvv`
- `dX`/`dXl`: register `X` will go from `........vvvvvvvv` to `00000000vvvvvvvv`
- `bXh`: register `X` will go from `............vv..` to `000000000000vv00`
- `wXh`: register `X` will go from `........vvvv....` to `00000000vvvv0000`
- `dXh`: register `X` will go from `vvvvvvvv........` to `vvvvvvvv00000000`

`zero_upper(reg)` is undefined for 64-bit values.

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
