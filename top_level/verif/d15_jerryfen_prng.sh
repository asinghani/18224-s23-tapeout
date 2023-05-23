#!/bin/sh
DES_NAME=d15_jerryfen_prng
TESTBENCH=test_wrapped.sv

`dirname "$0"`/run-icarus-tb.sh $DES_NAME $TESTBENCH $TB_MODE
