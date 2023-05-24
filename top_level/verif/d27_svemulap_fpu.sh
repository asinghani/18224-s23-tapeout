#!/bin/sh
DES_NAME=d27_svemulap_fpu
TESTBENCH=test_wrapped.sv

`dirname "$0"`/run-icarus-tb.sh $DES_NAME $TESTBENCH $TB_MODE
