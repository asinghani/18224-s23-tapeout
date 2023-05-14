# FP8(E4M3) Multiplier

Joseph Li
98-154 Intro to Open-Source Chip Design, Fall 2022

## Description

Multiply two 8-bit floating point numbers together (4-bit exponent, 3-bit mantissa).

Provide two 8-bit floating point numbers 4 bits at a time, use enable pin to provide these bits one set at a time. Wait a while and the product will appear on the output.

### Inputs

- clock
- reset
- enable
- input1 (Sign Bit / Exponent 4)
- input1 (Exponent 1 / Mantissa 1)
- input1 (Exponent 2 / Mantissa 2)
- input1 (Exponent 3 / Mantissa 3)
- none


### Outputs

- Mantissa 3
- Mantissa 2
- Mantissa 1
- Exponent 4
- Exponent 3
- Exponent 2
- Exponent 1
- Sign Bit
