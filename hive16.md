# Instructions
```
add             00000 Rd:3 Rn:3 Rm:3 -- # 1 clock cycle
sub             00001 Rd:3 Rn:3 Rm:3 -- # 1 clock cycle
mul             00010 Rd:3 Rn:3 Rm:3 -- # 1 clock cycle
div             00011 Rd:3 Rn:3 Rm:3 -0 # 1 clock cycle
mod             00100 Rd:3 Rn:3 Rm:3 -0 # 1 clock cycle
divs            00011 Rd:3 Rn:3 Rm:3 -1 # 1 clock cycle
mods            00100 Rd:3 Rn:3 Rm:3 -1 # 1 clock cycle
and             00101 Rd:3 Rn:3 Rm:3 -- # 1 clock cycle
or              00110 Rd:3 Rn:3 Rm:3 -- # 1 clock cycle
xor             00111 Rd:3 Rn:3 Rm:3 -- # 1 clock cycle
not             01000 Rd:3 Rn:3 ---  -- # 1 clock cycle
lsh             01001 Rd:3 Rn:3 Rm:3 -- # 1 clock cycle
rsh             01010 Rd:3 Rn:3 Rm:3 -- # 1 clock cycle
cmp             01011 Rd:3 Rn:3 Rm:3 -- # 1 clock cycle
ldi             01100 Rd:3 Imm:8        # 1 clock cycle
ldui            01101 Rd:3 Imm:8        # 1 clock cycle
ld              01110 Rd:3 Rn:3 ---  -0 # 1 clock cycle
st              01111 Rd:3 Rn:3 ---  -0 # 1 clock cycle
ldb             10000 Rd:3 Rn:3 ---  -0 # 1 clock cycle
stb             10001 Rd:3 Rn:3 ---  -0 # 1 clock cycle
ld2             01110 Rd:3 Rn:3 Rm:3 -1 # 1 clock cycle
st2             01111 Rd:3 Rn:3 Rm:3 -1 # 1 clock cycle
ldb2            10000 Rd:3 Rn:3 Rm:3 -1 # 1 clock cycle
stb2            10001 Rd:3 Rn:3 Rm:3 -1 # 1 clock cycle
jmp             10010 Imm:s11           # 1 clock cycle
jmpc            10011 Cond:2 Imm:s9     # 1 clock cycle
push            10100 Rd:3 ---  ---  -- # 1 clock cycle
pop             10101 Rd:3 ---  ---  -- # 1 clock cycle
call            10110 Imm:s11           # 1 clock cycle
callr           10111 Rd:3 ---  ---  -- # 1 clock cycle
ret             11000 ---  ---  ---  -- # 1 clock cycle
nop             11001 ---  ---  ---  -- # 1 clock cycle
halt            11010 ---  ---  ---  -- # 1 clock cycle
```

# Registers
```
r0              000
r1              001
r2              010
r3              011
r4              100
r5              101
sp              110
pc              111
```

# Conditions
```
eq              00 ; check zero flag
lt              01 ; check negative flag
ne              10 ; check zero flag and invert
ge              11 ; check negative flag and invert
```
