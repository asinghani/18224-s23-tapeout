# Continuous Math

Sophia Li
98-154 Intro to Open-Source Chip Design, Fall 2022

## Description

Output is a total you can ADD, SUBTRACT, XOR, or LEFT_SHIFT with the input.

Uses a register and some combinational logic. There is a simple state machine so you must release the button for enable_arithmetic before enabling it again. Basically, the same operation won't happen every clock cycle 100k times a second.

## Testing

Switch 6. after reset, the output should be zero. Hitting enable (Switch 5) will compute the current arithOp (+ = 2'b00, - = 2'b01, ^ = 2'b10, << = 2'b11

### Inputs

- clock
- reset
- enable
- in_val[2]
- in_val[1]
- in_val[0]
- arithOp[1]
- arithOp[0]


### Outputs

- LED[7]
- LED[6]
- LED[5]
- LED[4]
- LED[3]
- LED[2]
- LED[1]
- LED[0]


