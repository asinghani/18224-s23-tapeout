# 98154 - Convolutor Tape Out

Yushuang Liu
98154 Spring 2023 Final Tapeout Project

## Overview

This device takes in two 6-bit inputs and returns their convolution result. To accomodate chip manufacturing requirements, the two inputs are combined into one 12-bit input io_in.

## How it Works

The input signals are passed into shift registers to get the LSB's on every rising clock edge. The LSB's are then input into a one-bit multiplier (implemented simply as anding). An adder sums together all the products. One of the inputs is the new product, and the other is either the existing sum or zero, selected by a Mux. The final output is stored to a register. All devices are controlled by an FSM with 8 states.

Here are the RTL and FSM for the design:
RTL: 
![](https://github.com/yushuang-liu/98154-Convolutor/blob/main/RTL%20Final.jpg)
FSM:
![](https://github.com/yushuang-liu/98154-Convolutor/blob/main/FSM%20Final.jpg)

## Inputs/Outputs

Despite the designated pins used for clock and reset, the 12-bit input is divided into even halves to create two inputs for the convolution. The output is the lower 4 bits of the 12 pins.

## Hardware Peripherals

No additional hardware peripherals is used.

## Design Testing / Bringup

This design was tested with a testbench written in SystemVerilog. After manufacturing, input a random 12 bit number to the 12 input pins (by switches, for instance), and collect the output at the lower 4 output pins. If for testing purpose only, the collection can be done by measuring the voltage difference between the pins and the voltage rails. An example of  input is 12'b110111110101, the output should be 4'b0100.

## Media

For full SystemVerilog code for the design and testbench, please go to EDAPlayground at the following link:
https://edaplayground.com/x/CgaV
