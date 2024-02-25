# Hive64 Instructions
## General layout:
    0bTTxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      |
      +------------------------------- 2 bits for instruction type

## Instruction type 0 (data)
    0bTToooooddddddddddddddddddddddddd
      | |    |
      | |    +------------------------ 25 bits for data
      | +----------------------------- 5 bits for opcode
      +------------------------------- 2 bits for instruction type

## Instruction type 1 (rri)
    0bTToooooiiiiiiiiiiiiiiixxxxxyyyyy
      | |    |              |    |
      | |    |              |    +---- 5 bits for reg 2
      | |    |              +--------- 5 bits for reg 1
      | |    +------------------------ 15 bits for immediate
      | +----------------------------- 5 bits for opcode
      +------------------------------- 2 bits for instruction type
      
## Instruction type 2 (rrr)
    0bTTooooooiiiiiiiiixxxxxyyyyyzzzzz
      | |     |        |    |    |
      | |     |        |    |    +---- 5 bits for reg 3
      | |     |        |    +--------- 5 bits for reg 2
      | |     |        +-------------- 5 bits for reg 1
      | |     +----------------------- 9 bits instruction specific
      | +----------------------------- 6 bits for opcode
      +------------------------------- 2 bits for instruction type
      
## Instruction type 3 (ri)
    0bTToooooiiiiiiiiiiiiiiiiiiiiyyyyy
      | |    |                   |
      | |    |                   +---- 5 bits for reg
      | |    +------------------------ 20 bits for immediate
      | +----------------------------- 5 bits for opcode
      +------------------------------- 2 bits for instruction type
      
## Instruction type 3 (`movk`, `movz`)
    0bTTooooossssiiiiiiiiiiiiiiiiyyyyy
      | |    |   |               |
      | |    |   |               +---- 5 bits for reg
      | |    |   +-------------------- 16 bits for immediate
      | |    +------------------------ 4 bits for shift
      | +----------------------------- 5 bits for opcode
      +------------------------------- 2 bits for instruction type
