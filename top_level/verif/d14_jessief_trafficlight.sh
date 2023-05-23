#!/bin/sh
DES_NAME=d14_jessief_trafficlight
TESTBENCH=test_wrapped.sv

`dirname "$0"`/run-icarus-tb.sh $DES_NAME $TESTBENCH $TB_MODE
