#!/bin/sh
iverilog -g2005-sv tb.v src/chip.sv flattened.v && vvp a.out
