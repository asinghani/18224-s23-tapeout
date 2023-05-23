#!/bin/sh
DES_NAME=d05_meta_info
TESTBENCH=tb.v

`dirname "$0"`/run-icarus-tb.sh $DES_NAME $TESTBENCH $TB_MODE
