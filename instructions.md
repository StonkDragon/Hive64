# Instructions
## ADD
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `add r1, r2, imm8` | `ccc010000.[r1-][r2-]SZ01[-imm8-]` |
| `add r1, r2, r3`   | `ccc010000.[r1-][r2-]SZ00...[r3-]` |

Calculates the sum of `r2` and `r3`/`imm8` and stores it in `r1`.

## AND
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `and r1, r2, imm8` | `ccc0101010[r1-][r2-]SZ01[-imm8-]` |
| `and r1, r2, r3`   | `ccc0101010[r1-][r2-]SZ00...[r3-]` |

Ands `r2` and `r3`/`imm8` and stores the result in `r1`.

## B
| Mnemonic  | Encoding                           |
| --------- | ---------------------------------- |
| `b label` | `ccc0000[---------rel29---------]` |

Transfers execution to the address `label`.

## BL
| Mnemonic   | Encoding                           |
| ---------- | ---------------------------------- |
| `bl label` | `ccc0001[---------rel29---------]` |

Calls to the address `label`.

## BR
| Mnemonic | Encoding                           |
| -------- | ---------------------------------- |
| `br r1`  | `ccc0010[r1-]....................` |

Transfers execution to the address in `r1`.

## BLR
| Mnemonic | Encoding                           |
| -------- | ---------------------------------- |
| `blr r1` | `ccc0011[r1-]....................` |

Calls to the address in `r1`.

## CMP
| Mnemonic       | Encoding                           |
| -------------- | ---------------------------------- |
| `cmp r2, imm8` | `ccc0100011.....[r2-]SZ01[-imm8-]` |
| `cmp r2, r3`   | `ccc0100011.....[r2-]SZ00...[r3-]` |

Compares `r2` with `r3`/`imm8` by subtracting the value from `r2`.

## CPUID
| Mnemonic | Encoding                           |
| -------- | ---------------------------------- |
| `cpuid`  | `ccc1100000......................` |

## CSWAP
| Mnemonic                 | Encoding                           |
| ------------------------ | ---------------------------------- |
| `cswap r1, r2, r3, cond` | `ccc1101110[r1-][r2-]SZ..cnd[r3-]` |

Sets `r1` to `r2` if the condition `cond` is true.
Sets `r1` to `r3` if the condition `cond` is false.

## DIV
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `div r1, r2, imm8` | `ccc010011.[r1-][r2-]SZ01[-imm8-]` |
| `div r1, r2, r3`   | `ccc010011.[r1-][r2-]SZ00...[r3-]` |

Calculates the unsigned quotient of `r2` and `r3`/`imm8` and stores it in `r1`.

## DIVS
| Mnemonic            | Encoding                           |
| ------------------- | ---------------------------------- |
| `divs r1, r2, imm8` | `ccc010011.[r1-][r2-]SZ11[-imm8-]` |
| `divs r1, r2, r3`   | `ccc010011.[r1-][r2-]SZ10...[r3-]` |

Calculates the signed quotient of `r2` and `r3`/`imm8` and stores it in `r1`.

## EXT
| Mnemonic       | Encoding                             |
| -------------- | ------------------------------------ |
| `extXY r1, r2` | `ccc011110.[r1-][r2-]SZ........to:2` |

Extends the value in `r2` from type `X` to type `Y` and stores it in `r1`.
`X` and `Y` may be of the following:
- `b`: Byte
- `w`: Word
- `d`: Doubleword
- `q`: Quadword
The type identified by `X` must be smaller than the type `Y`.

## F2I
| Mnemonic     | Encoding                           |
| ------------ | ---------------------------------- |
| `f2i r1, r2` | `ccc110110001010.[r1-][r2-]......` |

Converts the double-precision float in `r2` into a signed quadword and stores it in `r1`.

## F2S
| Mnemonic     | Encoding                           |
| ------------ | ---------------------------------- |
| `f2s r1, r2` | `ccc110110110000.[r1-][r2-]......` |

Converts the double-precision float in `r2` into a single-precision float and stores it in `r1`.

## FADD
| Mnemonic          | Encoding                           |
| ----------------- | ---------------------------------- |
| `fadd r1, r2, r3` | `ccc110110000000.[r1-][r2-].[r3-]` |

Calculates the double-precision float sum of `r2` and `r3` and stores it in `r1`.

## FADDI
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `faddi r1, r2, r3` | `ccc110110000001.[r1-][r2-].[r3-]` |

Converts `r3` into a double-precision float and calculates the double-precision float sum of `r2` and `r3` and stores it in `r1`.

## FCMP
| Mnemonic      | Encoding                           |
| ------------- | ---------------------------------- |
| `fcmp r2, r3` | `ccc1101100000101.....[r2-].[r3-]` |

## FCMPI
| Mnemonic       | Encoding                           |
| -------------- | ---------------------------------- |
| `fcmpi r2, r3` | `ccc1101100000111.....[r2-].[r3-]` |

## FDIV
| Mnemonic          | Encoding                           |
| ----------------- | ---------------------------------- |
| `fdiv r1, r2, r3` | `ccc110110000110.[r1-][r2-].[r3-]` |

Calculates the double-precision float quotient of `r2` and `r3` and stores it in `r1`.

## FDIVI
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `fdivi r1, r2, r3` | `ccc110110000111.[r1-][r2-].[r3-]` |

Converts `r3` into a double-precision float and calculates the double-precision float quotient of `r2` and `r3` and stores it in `r1`.

## FMOD
| Mnemonic          | Encoding                           |
| ----------------- | ---------------------------------- |
| `fmod r1, r2, r3` | `ccc110110001000.[r1-][r2-].[r3-]` |

Calculates the double-precision float remainder of `r2` and `r3` and stores it in `r1`.

## FMODI
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `fmodi r1, r2, r3` | `ccc110110001001.[r1-][r2-].[r3-]` |

Converts `r3` into a double-precision float and calculates the double-precision float remainder of `r2` and `r3` and stores it in `r1`.

## FMUL
| Mnemonic          | Encoding                           |
| ----------------- | ---------------------------------- |
| `fmul r1, r2, r3` | `ccc110110000100.[r1-][r2-].[r3-]` |

Calculates the double-precision float product of `r2` and `r3` and stores it in `r1`.

## FMULI
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `fmuli r1, r2, r3` | `ccc110110000101.[r1-][r2-].[r3-]` |

Converts `r3` into a double-precision float and calculates the double-precision float product of `r2` and `r3` and stores it in `r1`.

## FSIN
| Mnemonic      | Encoding                           |
| ------------- | ---------------------------------- |
| `fsin r1, r2` | `ccc110110001100.[r1-][r2-]......` |

Calculates the double-precision float sin of `r2` and stores it in `r1`.

## FSINI
| Mnemonic       | Encoding                           |
| -------------- | ---------------------------------- |
| `fsini r1, r2` | `ccc110110001101.[r1-][r2-]......` |

Converts `r2` into a double-precision float and calculates the double-precision float sin of `r2` and stores it in `r1`.

## FSQRT
| Mnemonic       | Encoding                           |
| -------------- | ---------------------------------- |
| `fsqrt r1, r2` | `ccc110110001110.[r1-][r2-]......` |

Calculates the double-precision float square root of `r2` and stores it in `r1`.

## FSQRTI
| Mnemonic        | Encoding                           |
| --------------- | ---------------------------------- |
| `fsqrti r1, r2` | `ccc110110001111.[r1-][r2-]......` |

Converts `r2` into a double-precision float and calculates the double-precision float square root of `r2` and stores it in `r1`.

## FSUB
| Mnemonic | Encoding                           |
| -------- | ---------------------------------- |
| `fsub`   | `ccc1101100000100[r1-][r2-].[r3-]` |

Calculates the double-precision float difference of `r2` and `r3` and stores it in `r1`.

## FSUBI
| Mnemonic | Encoding                           |
| -------- | ---------------------------------- |
| `fsubi`  | `ccc1101100000110[r1-][r2-].[r3-]` |

Converts `r3` into a double-precision float and calculates the double-precision float difference of `r2` and `r3` and stores it in `r1`.

## HEXIT
| Mnemonic | Encoding                           |
| -------- | ---------------------------------- |
| `hexit`  | `ccc1101001......................` |

Drops the processor out of hypervisor mode into supervisor mode.
Causes `SIGILL` when not in hypervisor mode.

## HRET
| Mnemonic | Encoding                           |
| -------- | ---------------------------------- |
| `hret`   | `ccc1100100......................` |

Returns from a hypervisor call.
Causes `SIGILL` when not in hypervisor mode.

## I2F
| Mnemonic     | Encoding                           |
| ------------ | ---------------------------------- |
| `i2f r1, r2` | `ccc110110001011.[r1-][r2-]......` |

Converts `r2` into a double-precision float and stores it in `r1`.

## I2S
| Mnemonic     | Encoding                           |
| ------------ | ---------------------------------- |
| `i2s r1, r2` | `ccc110110101011.[r1-][r2-]......` |

Converts `r2` into a single-precision float and stores it in `r1`.

## IRET
| Mnemonic | Encoding                           |
| -------- | ---------------------------------- |
| `iret`   | `ccc1100101......................` |

Returns from an interrupt.
Causes `SIGILL` when not in hypervisor mode.

## LDR
| Mnemonic             | Encoding                           |
| -------------------- | ---------------------------------- |
| `ldr r1, [r2, imm]`  | `ccc1010[r1-]SZ010[r2-][-imm10--]` |
| `ldr r1, [r2, imm]!` | `ccc1010[r1-]SZ011[r2-][-imm10--]` |
| `ldr r1, [label]`    | `ccc1011[r1-]SZ0[-----rel17-----]` |
| `ldr r1, [r2, r3]`   | `ccc1010[r1-]SZ000[r2-]..SHL[r3-]` |
| `ldr r1, [r2, r3]!`  | `ccc1010[r1-]SZ001[r2-]..SHL[r3-]` |

Loads a value from a given address into `r1`.

## LEA
| Mnemonic        | Encoding                           |
| --------------- | ---------------------------------- |
| `lea r1, label` | `ccc1000[r1-][------rel20-------]` |

Loads the effective address of `label` into `r1`.

## MOD
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `mod r1, r2, imm8` | `ccc010100.[r1-][r2-]SZ01[-imm8-]` |
| `mod r1, r2, r3`   | `ccc010100.[r1-][r2-]SZ00...[r3-]` |

Calculates the unsigned remainder of `r2` and `r3`/`imm8` and stores it in `r1`.

## MODS
| Mnemonic            | Encoding                           |
| ------------------- | ---------------------------------- |
| `mods r1, r2, imm8` | `ccc010100.[r1-][r2-]SZ11[-imm8-]` |
| `mods r1, r2, r3`   | `ccc010100.[r1-][r2-]SZ10...[r3-]` |

Calculates the signed remainder of `r2` and `r3`/`imm8` and stores it in `r1`.

## MOV
| Mnemonic      | Encoding                           |
| ------------- | ---------------------------------- |
| `mov r1, r2`  | `ccc011000.[r1-][r2-]SZ0100000000` |
| `mov cr1, r2` | `ccc1100111............[cr1][r2-]` |
| `mov r1, cr2` | `ccc1101000............[cr2][r1-]` |

Copies the data in `r2`/`cr2` into `r1`/`cr1`.

## MOVK
| Mnemonic               | Encoding                           |
| ---------------------- | ---------------------------------- |
| `movk r1, imm`         | `ccc1001[r1-].100[----imm16-----]` |
| `movk r1, imm, shl 16` | `ccc1001[r1-].101[----imm16-----]` |
| `movk r1, imm, shl 32` | `ccc1001[r1-].110[----imm16-----]` |
| `movk r1, imm, shl 48` | `ccc1001[r1-].111[----imm16-----]` |

Sets the selected 16 bits of `r1` to the 16-bit immediate `imm`.

## MOVZ
| Mnemonic               | Encoding                           |
| ---------------------- | ---------------------------------- |
| `movz r1, imm`         | `ccc1001[r1-].000[----imm16-----]` |
| `movz r1, imm, shl 16` | `ccc1001[r1-].001[----imm16-----]` |
| `movz r1, imm, shl 32` | `ccc1001[r1-].010[----imm16-----]` |
| `movz r1, imm, shl 48` | `ccc1001[r1-].011[----imm16-----]` |

Clears `r1` and sets the selected 16 bits of `r1` to the 16-bit immediate `imm`.

## MUL
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `mul r1, r2, imm8` | `ccc010010.[r1-][r2-]SZ01[-imm8-]` |
| `mul r1, r2, r3`   | `ccc010010.[r1-][r2-]SZ00...[r3-]` |

Calculates the product of `r2` and `r3`/`imm8` and stores it in `r1`.

## NEG
| Mnemonic     | Encoding                           |
| ------------ | ---------------------------------- |
| `neg r1, r2` | `ccc011100.[r1-][r2-]SZ0.........` |

Stores the twos-complement negated value of `r2` in `r1`.

## NOT
| Mnemonic     | Encoding                           |
| ------------ | ---------------------------------- |
| `not r1, r2` | `ccc011101.[r1-][r2-]SZ0.........` |

Stores the binary NOT of `r2` in `r1`.

## OR
| Mnemonic          | Encoding                           |
| ----------------- | ---------------------------------- |
| `or r1, r2, imm8` | `ccc010110.[r1-][r2-]SZ01[-imm8-]` |
| `or r1, r2, r3`   | `ccc010110.[r1-][r2-]SZ00...[r3-]` |

Ors `r2` and `r3`/`imm8` and stores the result in `r1`.

## RET
| Mnemonic | Encoding                           |
| -------- | ---------------------------------- |
| `ret`    | `ccc011000.1111111101110100000000` |

Sets `pc` to `lr`.

## ROL
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `rol r1, r2, imm8` | `ccc011010.[r1-][r2-]SZ01[-imm8-]` |
| `rol r1, r2, r3`   | `ccc011010.[r1-][r2-]SZ00...[r3-]` |

Rotates `r2` left by `r3`/`imm8` and stores the result in `r1`.

## ROR
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `ror r1, r2, imm8` | `ccc011011.[r1-][r2-]SZ01[-imm8-]` |
| `ror r1, r2, r3`   | `ccc011011.[r1-][r2-]SZ00...[r3-]` |

Rotates `r2` right by `r3`/`imm8` and stores the result in `r1`.

## S2F
| Mnemonic     | Encoding                           |
| ------------ | ---------------------------------- |
| `s2f r1, r2` | `ccc110110010000.[r1-][r2-]......` |

Converts the single-precision float in `r2` to a double-precision float and stores it in `r1`.

## S2I
| Mnemonic     | Encoding                           |
| ------------ | ---------------------------------- |
| `s2i r1, r2` | `ccc110110101010.[r1-][r2-]......` |

Converts the single-precision float in `r2` to a signed doubleword and stores it in `r1`.

## SADD
| Mnemonic          | Encoding                           |
| ----------------- | ---------------------------------- |
| `sadd r1, r2, r3` | `ccc110110100000.[r1-][r2-].[r3-]` |

Calculates the single-precision float sum of `r2` and `r3` and stores it in `r1`.

## SADDI
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `saddi r1, r2, r3` | `ccc110110100001.[r1-][r2-].[r3-]` |

Converts `r3` into a single-precision float and calculates the single-precision float sum of `r2` and `r3` and stores it in `r1`.

## SAR
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `sar r1, r2, imm8` | `ccc011001.[r1-][r2-]SZ11[-imm8-]` |
| `sar r1, r2, r3`   | `ccc011001.[r1-][r2-]SZ10...[r3-]` |

## SBDP
| Mnemonic                    | Encoding                           |
| --------------------------- | ---------------------------------- |
| `sbdp r1, r2, start, count` | `ccc1110011[r1-][r2-][cnt-][strt]` |

## SBXT
| Mnemonic                    | Encoding                           |
| --------------------------- | ---------------------------------- |
| `sbxt r1, r2, start, count` | `ccc1110001[r1-][r2-][cnt-][strt]` |

## SCMP
| Mnemonic      | Encoding                           |
| ------------- | ---------------------------------- |
| `scmp r2, r3` | `ccc1101101000101.....[r2-].[r3-]` |

## SCMPI
| Mnemonic       | Encoding                           |
| -------------- | ---------------------------------- |
| `scmpi r2, r3` | `ccc1101101000111.....[r2-].[r3-]` |

## SDIV
| Mnemonic          | Encoding                           |
| ----------------- | ---------------------------------- |
| `sdiv r1, r2, r3` | `ccc110110100110.[r1-][r2-].[r3-]` |

Calculates the single-precision float quotient of `r2` and `r3` and stores it in `r1`.

## SDIVI
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `sdivi r1, r2, r3` | `ccc110110100111.[r1-][r2-].[r3-]` |

Converts `r3` into a single-precision float and calculates the single-precision float quotient of `r2` and `r3` and stores it in `r1`.

## SEXIT
| Mnemonic | Encoding                           |
| -------- | ---------------------------------- |
| `sexit`  | `ccc1101010......................` |

## SHL
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `shl r1, r2, imm8` | `ccc011000.[r1-][r2-]SZ01[-imm8-]` |
| `shl r1, r2, r3`   | `ccc011000.[r1-][r2-]SZ00...[r3-]` |

## SHR
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `shr r1, r2, imm8` | `ccc011001.[r1-][r2-]SZ01[-imm8-]` |
| `shr r1, r2, r3`   | `ccc011001.[r1-][r2-]SZ00...[r3-]` |

## SMOD
| Mnemonic          | Encoding                           |
| ----------------- | ---------------------------------- |
| `smod r1, r2, r3` | `ccc110110101000.[r1-][r2-].[r3-]` |

Calculates the single-precision float remainder of `r2` and `r3` and stores it in `r1`.

## SMODI
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `smodi r1, r2, r3` | `ccc110110101001.[r1-][r2-].[r3-]` |

Converts `r3` into a single-precision float and calculates the single-precision float remainder of `r2` and `r3` and stores it in `r1`.

## SMUL
| Mnemonic          | Encoding                           |
| ----------------- | ---------------------------------- |
| `smul r1, r2, r3` | `ccc110110100100.[r1-][r2-].[r3-]` |

Calculates the single-precision float product of `r2` and `r3` and stores it in `r1`.

## SMULI
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `smuli r1, r2, r3` | `ccc110110100101.[r1-][r2-].[r3-]` |

Converts `r3` into a single-precision float and calculates the single-precision float product of `r2` and `r3` and stores it in `r1`.

## SRET
| Mnemonic | Encoding                           |
| -------- | ---------------------------------- |
| `sret`   | `ccc1100011......................` |

## SSIN
| Mnemonic      | Encoding                           |
| ------------- | ---------------------------------- |
| `ssin r1, r2` | `ccc110110101100.[r1-][r2-]......` |

## SSINI
| Mnemonic       | Encoding                           |
| -------------- | ---------------------------------- |
| `ssini r1, r2` | `ccc110110101101.[r1-][r2-]......` |

## SSQRT
| Mnemonic       | Encoding                           |
| -------------- | ---------------------------------- |
| `ssqrt r1, r2` | `ccc110110101110.[r1-][r2-]......` |

## SSQRTI
| Mnemonic        | Encoding                           |
| --------------- | ---------------------------------- |
| `ssqrti r1, r2` | `ccc110110101111.[r1-][r2-]......` |

## SSUB
| Mnemonic          | Encoding                           |
| ----------------- | ---------------------------------- |
| `ssub r1, r2, r3` | `ccc1101101000100[r1-][r2-].[r3-]` |

Calculates the single-precision float difference of `r2` and `r3` and stores it in `r1`.

## SSUBI
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `ssubi r1, r2, r3` | `ccc1101101000110[r1-][r2-].[r3-]` |

Converts `r3` into a single-precision float and calculates the single-precision float difference of `r2` and `r3` and stores it in `r1`.

## STR
| Mnemonic             | Encoding                           |
| -------------------- | ---------------------------------- |
| `str r1, [r2, imm]`  | `ccc1010[r1-]SZ110[r2-][-imm10--]` |
| `str r1, [r2, imm]!` | `ccc1010[r1-]SZ111[r2-][-imm10--]` |
| `str r1, [label]`    | `ccc1011[r1-]SZ1[-----rel17-----]` |
| `str r1, [r2, r3]`   | `ccc1010[r1-]SZ100[r2-]..SHL[r3-]` |
| `str r1, [r2, r3]!`  | `ccc1010[r1-]SZ101[r2-]..SHL[r3-]` |

## SUB
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `sub r1, r2, imm8` | `ccc0100010[r1-][r2-]SZ01[-imm8-]` |
| `sub r1, r2, r3`   | `ccc0100010[r1-][r2-]SZ00...[r3-]` |

Calculates the difference of `r2` and `r3`/`imm8` and stores it in `r1`.

## SVC
| Mnemonic | Encoding                           |
| -------- | ---------------------------------- |
| `svc`    | `ccc1100110......................` |

## SWE
| Mnemonic     | Encoding                           |
| ------------ | ---------------------------------- |
| `swe r1, r2` | `ccc011111.[r1-][r2-]SZ0.........` |

## TST
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `tst r2, imm8` | `ccc0101011.....[r2-]SZ01[-imm8-]` |
| `tst r2, r3`   | `ccc0101011.....[r2-]SZ00...[r3-]` |

Tests `r2` against `r3`/`imm8` by ANDing them.

## UBDP
| Mnemonic                    | Encoding                           |
| --------------------------- | ---------------------------------- |
| `ubdp r1, r2, start, count` | `ccc1110010[r1-][r2-][cnt-][strt]` |

## UBXT
| Mnemonic                    | Encoding                           |
| --------------------------- | ---------------------------------- |
| `ubxt r1, r2, start, count` | `ccc1110000[r1-][r2-][cnt-][strt]` |

## VABS
| Mnemonic      | Encoding                           |
| ------------- | ---------------------------------- |
| `vabs v1, v2` | `ccc1111110001ttt[v1][v2]........` |

## VADD
| Mnemonic          | Encoding                           |
| ----------------- | ---------------------------------- |
| `vadd v1, v2, v3` | `ccc1111100000ttt[v1][v2]....[v3]` |

## VADDSUB
| Mnemonic             | Encoding                           |
| -------------------- | ---------------------------------- |
| `vaddsub v1, v2, v3` | `ccc1111100100ttt[v1][v2]....[v3]` |

## VAND
| Mnemonic          | Encoding                           |
| ----------------- | ---------------------------------- |
| `vand v1, v2, v3` | `ccc1111101100ttt[v1][v2]....[v3]` |

## VCMP
| Mnemonic                | Encoding                           |
| ----------------------- | ---------------------------------- |
| `vcmp v1, v2, v3, cond` | `ccc1111101111ttt[v1][v2].cnd[v3]` |

## VCONV
| Mnemonic         | Encoding                           |
| ---------------- | ---------------------------------- |
| `vconvXY v1, v2` | `ccc1111101000ttt[v1][v2].....DDD` |

## VDIV
| Mnemonic          | Encoding                           |
| ----------------- | ---------------------------------- |
| `vdiv v1, v2, v3` | `ccc1111100011ttt[v1][v2]....[v3]` |

## VLDR
| Mnemonic              | Encoding                           |
| --------------------- | ---------------------------------- |
| `vldr v1, [r1, imm]`  | `ccc111110101010[r1-][v1][-imm8-]` |
| `vldr v1, [r1, imm]!` | `ccc111110101011[r1-][v1][-imm8-]` |
| `vldr v1, [r1, r2]`   | `ccc111110101000[r1-][v1]...[r2-]` |
| `vldr v1, [r1, r2]!`  | `ccc111110101001[r1-][v1]...[r2-]` |

## VLEN
| Mnemonic      | Encoding                           |
| ------------- | ---------------------------------- |
| `vlen v1, r1` | `ccc1111101001ttt[v1].......[r1-]` |

## VMADD
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `vmadd v1, v2, v3` | `ccc1111100101ttt[v1][v2]....[v3]` |

## VMINMAX
| Mnemonic   | Encoding                           |
| ---------- | ---------------------------------- |
| `vminmaxs` | `ccc1111110000ttt[v1][v2].......1` |
| `vminmaxu` | `ccc1111110000ttt[v1][v2].......0` |

## VMOD
| Mnemonic          | Encoding                           |
| ----------------- | ---------------------------------- |
| `vmod v1, v2, v3` | `ccc1111110101ttt[v1][v2]....[v3]` |

## VMOV
| Mnemonic            | Encoding                           |
| ------------------- | ---------------------------------- |
| `vmov v1, v2`       | `ccc1111100111ttt[v1][v2]........` |
| `vmov v1, r2, slot` | `ccc1111100110ttt[v1]0[slot][r2-]` |
| `vmov r2, v1, slot` | `ccc1111100110ttt[v1]1[slot][r2-]` |

## VMOVALL
| Mnemonic         | Encoding                           |
| ---------------- | ---------------------------------- |
| `vmovall v1, r2` | `ccc1111110110ttt[v1].......[r2-]` |

## VMUL
| Mnemonic          | Encoding                           |
| ----------------- | ---------------------------------- |
| `vmul v1, v2, v3` | `ccc1111100010ttt[v1][v2]....[v3]` |

## VOR
| Mnemonic         | Encoding                           |
| ---------------- | ---------------------------------- |
| `vor v1, v2, v3` | `ccc1111101101ttt[v1][v2]....[v3]` |

## VSHL
| Mnemonic          | Encoding                           |
| ----------------- | ---------------------------------- |
| `vshl v1, v2, v3` | `ccc1111110010ttt[v1][v2]....[v3]` |

## VSHR
| Mnemonic          | Encoding                           |
| ----------------- | ---------------------------------- |
| `vshr v1, v2, v3` | `ccc1111110011ttt[v1][v2]...0[v3]` |
| `vsar v1, v2, v3` | `ccc1111110011ttt[v1][v2]...1[v3]` |

## VSQRT
| Mnemonic       | Encoding                           |
| -------------- | ---------------------------------- |
| `vsqrt v1, v2` | `ccc1111110100ttt[v1][v2]........` |

## VSTR
| Mnemonic              | Encoding                           |
| --------------------- | ---------------------------------- |
| `vstr v1, [r1, imm]`  | `ccc111110101110[r1-][v1][-imm8-]` |
| `vstr v1, [r1, imm]!` | `ccc111110101111[r1-][v1][-imm8-]` |
| `vstr v1, [r1, r2]`   | `ccc111110101100[r1-][v1]...[r2-]` |
| `vstr v1, [r1, r2]!`  | `ccc111110101101[r1-][v1]...[r2-]` |

## VSUB
| Mnemonic          | Encoding                           |
| ----------------- | ---------------------------------- |
| `vsub v1, v2, v3` | `ccc1111100001ttt[v1][v2]....[v3]` |

## VTST
| Mnemonic                | Encoding                           |
| ----------------------- | ---------------------------------- |
| `vtst v1, v2, v3, cond` | `ccc1111111111ttt[v1][v2].cnd[v3]` |

## VXOR
| Mnemonic          | Encoding                           |
| ----------------- | ---------------------------------- |
| `vxor v1, v2, v3` | `ccc1111101110ttt[v1][v2]....[v3]` |

## XCHG
| Mnemonic      | Encoding                           |
| ------------- | ---------------------------------- |
| `xchg r1, r2` | `ccc1101111[r1-][r2-]SZ..........` |

## XOR
| Mnemonic           | Encoding                           |
| ------------------ | ---------------------------------- |
| `xor r1, r2, imm8` | `ccc010111.[r1-][r2-]SZ01[-imm8-]` |
| `xor r1, r2, r3`   | `ccc010111.[r1-][r2-]SZ00...[r3-]` |

## ZEROUPPER
| Mnemonic    | Encoding                           |
| ----------- | ---------------------------------- |
| `zeroupper` | `ccc1100010...............SZ[r1-]` |
