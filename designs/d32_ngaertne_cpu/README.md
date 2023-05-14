# 4-bit CPU

Noah Gaertner
98-154 Intro to Open-Source Chip Design, Fall 2022

## Description

4-bit CPU that does add, subtract, multiply, left and right shifts, conditional jump based on external signal, logical and bitwise AND and OR, equality and inequality checking, bitwise inversion, and logical NOT.

Implements a highly reduced ISA that fits on the limited allowed space, and uses a 4-bit bus to get the program and data values in and out of the chip, in addition to a two bit bus to tell it what to do at any given time, as well as a clock and reset signal.

## How to Use

Write a program for the ISA and try to run it! Remember you need to synchronously RESET and then SETRUNPT to the proper value before you try to do anything!

### ***NOTE: MUST SEND SYNCHRONOUS RESET IMMEDIATELY BEFORE OPERATION***
  ## PINS: 
  - IN:
    - IN[0]: clock
    - IN[1]: reset
    - IN[2]: instruction[0]
    - IN[3]: instruction[1]
    - IN[4]: DATA[0]
    - IN[5]: DATA[1]
    - IN[6]: DATA[2]
    - IN[7]: DATA[3]
  - OUT:
    - OUT[0]: program counter[0]
    - OUT[1]: program counter[1]
    - OUT[2]: program counter[2]
    - OUT[3]: program counter[3]
    - OUT[4]: register value[0]
    - OUT[5]: register value[1]
    - OUT[6]: register value[2]
    - OUT[7]: register value[3]
  ## INSTRUCTIONS:
  ```sv
    LOADPROG = 2'd0, //loads a program into the program "file" using IN[7:4]
    LOADDATA = 2'd1, //loads data into the data "file" using IN[7:4]
    SETRUNPT = 2'd2, //designed to be used right before run, but can also be used to input additional data i guess
    RUNPROG  = 2'd3 //run the program
  ```
  ## ISA:
  ```sv
    LOAD = 4'd0, //loads a value from data file into register
    STORE = 4'd1, //stores value from register to data file
    ADD = 4'd2, //adds datac to register value
    MUL = 4'd3, //multiples register value by datac
    SUB = 4'd4, //subtracts datac from register value
    SHIFTL = 4'd5, //shifts register value left by datac
    SHIFTR = 4'd6, //shifts register value right by datac
    JUMPTOIF = 4'd7, //jumps pc to data[value] if io_in[7] is a 1, else 
    //does nothing
    LOGICAND = 4'd8,
    //logical and between register value and datac
    LOGICOR = 4'd9,
    //logical or between register value and datac
    EQUALS = 4'd10,
    //equality check between register value and datac
    NEQ = 4'd11,
    //inequality check between register value and datac
    BITAND = 4'd12,
    //bitwise and between register value and datac    
    BITOR = 4'd13,
    //bitwise or between register value and datac
    LOGICNOT = 4'd14,
    //logical not on register value 
    BITNOT = 4'd15
    //bitwise not on register value
  ```

