#!/bin/sh
DES_NAME=d28_gvenkata_ucpu
TESTBENCH=test_wrapped.sv

`dirname "$0"`/run-icarus-tb.sh $DES_NAME $TESTBENCH $TB_MODE
