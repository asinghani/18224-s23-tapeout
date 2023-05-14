# TinyTapeout_FPGA

Yu-Ching Wu
18-224/624 Spring 2023 Final Tapeout Project

## Overview

A 4 by 4 basic FPGA. Can simulate up to 12 gates.

## How it Works

Each CLB block contains two switch box, one connecting to sel 0 in the LUT and the other connecting to sel 1 in the LUT. There is also the option of using the CLB block as register. It is possible for the CLB to be connected to any other CLB in the column before, current column, and the column after.

![](datapath.png)

## Inputs/Outputs
| Input Number | Config | User Input|
| ---      | ---       | --- |
| 0 | 1'b0 | 1'b1 |
| 1 | SelDFF | input[0] |
| 2 | LUT[0] | input[1] |
| 3 | LUT[1] | input[2] |
| 4 | LUT[2] | input[3]|
| 5 | LUW[3] | |
| 6 | Addr[0] | |
| 7 | Addr[1] | |
| 8 | Addr[2] | |
| 9 | Addr[3] | |
| 10 | Addr[4] | |
| 11 | Addr[5] | |

Output[3:0] will be connected to the last four clb of the FPGA.

## Hardware Peripherals
None

## Design Testing / Bringup
Write system verilog testbench. Two testcases, one to be able to pass values through all the modules, and the other to simulate a simply 2 bit counter.

![](Images/2bitCounter.jpg)

![](Images/passThrough.jpg)

Setting up and output of counter.

![](Images/OutputTestcase.png)

