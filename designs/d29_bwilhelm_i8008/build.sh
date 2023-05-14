#!/bin/sh

# Create verilog representations of system verilog
sv2v $(pwd)/original_sv/i8008_isa.vh $(pwd)/original_sv/internal_defines.vh $(pwd)/original_sv/i8008_core.sv > $(pwd)/src/i8008_core.v