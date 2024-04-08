# Hive64 Microcode
## Opcode struct
```c
struct hive_micro_operation {
    uint16_t arg: 10;
    uint8_t odata: 5;
    uint8_t arg_mode: 2;
    uint8_t target_reg: 1;
    uint8_t opcode: 6;
};
```

## Opcodes
|Bits|Opcode Mnemonic|
|-|-|
|`000000rmm....0aaaaaaaaaa`|`add %r`|
|`000001rmm....0aaaaaaaaaa`|`sub %r`|
|`000010rmm....0aaaaaaaaaa`|`mul %r`|
|`000011rmm....0aaaaaaaaaa`|`div %r`|
|`000011rmm....1aaaaaaaaaa`|`divs %r`|
|`000100rmm....0aaaaaaaaaa`|`mod %r`|
|`000100rmm....1aaaaaaaaaa`|`mods %r`|
|`000101rmm....0aaaaaaaaaa`|`and %r`|
|`000110rmm....0aaaaaaaaaa`|`or %r`|
|`000111rmm....0aaaaaaaaaa`|`xor %r`|
|`001000rmm....0aaaaaaaaaa`|`shl %r`|
|`001001rmm....0aaaaaaaaaa`|`shr %r`|
|`001000rmm....1aaaaaaaaaa`|`asl %r`|
|`001001rmm....1aaaaaaaaaa`|`asr %r`|
|`001010rmm....0aaaaaaaaaa`|`rol %r`|
|`001011rmm....0aaaaaaaaaa`|`ror %r`|
|`001100rmm....0aaaaaaaaaa`|`bitmask %r`|
|`001101rll.....aaaaaaaaaa`|`ld %r`|
|`001101r11....1aaaaaaaaaa`|`ldc %r []`|
|`001110rll.....aaaaaaaaaa`|`st %r`|
|`001110r11....1aaaaaaaaaa`|`stc %r []`|
|`001111r01....0.........r`|`fetch %r %r`|
|`001111r01....1.........r`|`store %r %r`|
|`010000r.................`|`neg %r`|
|`010001r.................`|`not %r`|
|`010010r.................`|`swap %r`|
|`010011r.................`|`clearother %r`|
|`010100rmm.....aaaaaaaaaa`|`sel %r`|
|`010101r10.....aaaaaaaaaa`|`set %r #%[]`|
|`010110.00.....[--dest--]`|`b dest`|
|`010111r00[imm][--dest--]`|`beq %r # dest`|
|`011000.00.....aaaaaaaaaa`|`checklevel #`|
|`011001.10.....aaaaaaaaaa`|`disableflags #%[]`|
|`011010.10.....aaaaaaaaaa`|`setctrl #%[]`|
|`011011.10.....aaaaaaaaaa`|`sethigh #%[]`|
|`011100.10.....aaaaaaaaaa`|`setsize #%[]`|
|`011101r.................`|`svc %r`|
|`011110..................`|`next`|
|`011111..................`|`mcret`|
|`100000r01..............r`|`fadd %r %r`|
|`100001r01..............r`|`fsub %r %r`|
|`100010r01..............r`|`fmul %r %r`|
|`100011r01..............r`|`fdiv %r %r`|
|`100100r01..............r`|`fmod %r %r`|
|`100101r.................`|`fsin %r`|
|`100110r.................`|`fsqrt %r`|
|`100111r.................`|`i2f %r`|
|`101000r.................`|`f2i %r`|
|`101001r.................`|`f2s %r`|
|`101010r.................`|`<reserved>`|
|`101011r.................`|`<reserved>`|
|`101100r.................`|`<reserved>`|
|`101101r.................`|`<reserved>`|
|`101110r.................`|`<reserved>`|
|`101111r.................`|`<reserved>`|
|`110000r01..............r`|`sadd %r %r`|
|`110001r01..............r`|`ssub %r %r`|
|`110010r01..............r`|`smul %r %r`|
|`110011r01..............r`|`sdiv %r %r`|
|`110100r01..............r`|`smod %r %r`|
|`110101r.................`|`ssin %r`|
|`110110r.................`|`ssqrt %r`|
|`110111r.................`|`i2s %r`|
|`111000r.................`|`s2i %r`|
|`111001r.................`|`s2f %r`|
|`111010r.................`|`<reserved>`|
|`111011r.................`|`<reserved>`|
|`111100r.................`|`<reserved>`|
|`111101r.................`|`<reserved>`|
|`111110r.................`|`<reserved>`|
|`111111111111111111111111`|`#UD`|

## `mm` bits
Where applicable, append `Means` after opcode mnemonic
|Bits|Means|Description|
|-|-|-|
|`00`|`#`|Immediate (`odata` specifies signed operation)|
|`01`|`%r`|Microcode register (`odata` specifies signed operation)|
|`10`|`#%[]`|Immediate from instruction (`odata` specifies signed operation)|
|`11`|`%[]`|Register from instruction (`odata` specifies signed operation)|

## `ll` bits
Where applicable, append `Means` after opcode mnemonic
|Bits|Means|Description|
|-|-|-|
|`00`|`#`|Immediate (`odata` is shift)|
|`01`|`#%[]`|Immediate from instruction (`odata` is shift)|
|`10`|`%[]`|Register from instruction (`odata` unused)|
|`11`|`[]`|Immediate register (`odata` specifies if control register)|
