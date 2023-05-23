#!/bin/sh
DES_NAME=d18_nikhildj_mac
TESTBENCH=test_wrapped.sv

`dirname "$0"`/run-icarus-tb.sh $DES_NAME $TESTBENCH $TB_MODE
