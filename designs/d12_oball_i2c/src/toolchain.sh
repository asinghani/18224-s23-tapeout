#!/bin/sh
#./toolchain 
files='chip.sv top.sv datapath.sv IO.sv FSM.sv library.sv I2C.sv'
set -e
yosys -p "read_verilog -sv $files; synth_ice40 -json build/synthesis.json -top chipInterface; stat"
nextpnr-ice40 --hx8k --json build/synthesis.json --asc build/pnr.asc --package cb132 --pcf constraints.pcf --freq 90 --pre-place constrain.py
icepack build/pnr.asc build/bitstream.bit
yosys -p "read_verilog -sv $files; synth -top my_chip; stat"