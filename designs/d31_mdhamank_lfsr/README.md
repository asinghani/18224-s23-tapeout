# LFSR PRNG

Mihir Dhamankar
98-154 Intro to Open-Source Chip Design, Fall 2022

## Description

8 bit linear feedback shift register pseudorandom number generator

8 D flip flops make a shift register. The 4th, 5th, and 8th bits are XOR'd into the 1st bit on each cycle, giving a cycle of 255 bit permutations. Another layer of flip flops delays the output by 1 cycle to facilitate holding.

## Testing

Set clock to any frequency, power enable input, outputs should be randomized. Outputs should be in the range [1, 255], with a period of 255.

#### Inputs

- clock             # clock
- enable            # on to cycle the shift register
- hold              # on to hold the output while cycling the internal shift register, connect to external clock to make PRNG less predictable.
- none
- none
- none
- none
- none

#### Outputs

- segment a         # bit 0
- segment b         # bit 1
- segment c         # bit 2
- segment d         # bit 3
- segment e         # bit 4
- segment f         # bit 5
- segment g         # bit 6
- segment h         # bit 7

