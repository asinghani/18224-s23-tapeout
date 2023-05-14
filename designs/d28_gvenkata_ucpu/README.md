# Micro-programmed 8-bit CPU, with horizontal control store

Ganesh Venkatachalam
18-224/624 Spring 2023 Final Tapeout Project

## Overview

The goal of this project is to design an 8-bit CPU with a microprogrammed control unit instead of a hardwired control unit. A hardwired control unit takes an
instruction, decodes it and generates control signals that direct the flow of data between the CPU’s registers, ALU units and data memory. This is established by the 
use of hardware multiplexers that are built at RTL design time and are responsible for selecting among various input operands to various functional and memory units in 
the CPU. This design paradigm is highly efficient in terms of performance and power but comes at the cost of flexibility since interconnections between the various 
units in a CPU are determined and hardwired at design time and cannot be changed later after the CPU has been fabricated. Introducing new instructions/modified 
functionality for existing instructions in the ISA is not possible. 
A microprogrammed CPU solves this problem by introducing another level of abstraction on top of the instructions in the ISA. A microprogrammed CPU decomposes an instruction into a series of micro-instructions/microcodes that are typically simple operations carried out in succession to realize the effect of the original instruction. 


## How it Works
Each instruction is decomposed into a set of template-micro-instructions (micro-ops) which are stored in an External data memory. The CPU's FSM will fetch each micro-instruction corresponding to an instruction and executes them to completion.


## Inputs/Outputs

1. System clock - Input system clock/external clock.
2. System reset - Input system reset.
3. Instruction address - Output pin that sends out the address of the next instruction to be executed ( address bits are sent synchronous with respect to the system clock).
4. Micro-Instruction address - Output pin that sends out the address of the next micro-instruction to be fetched and executed ( address bits are sent synchronous with respect to the system clock).
5. Instruction stream - Input pin that receives instruction address bits serially.
6. Micro-instruction stream - Input pin that receives micro-instruction address bits serially.

