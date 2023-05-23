#!/bin/sh
DES_NAME=d22_yushuanl_convolution
TESTBENCH=test_wrapped.sv

`dirname "$0"`/run-icarus-tb.sh $DES_NAME $TESTBENCH $TB_MODE
