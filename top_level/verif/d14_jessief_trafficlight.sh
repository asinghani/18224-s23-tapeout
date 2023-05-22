#!/bin/sh
DES_NAME=d14_jessief_trafficlight
DES_NUM=$(echo $DES_NAME | cut -d "_" -f 1 | tr -d "d")
TESTBENCH=test_wrapped.sv

cd $(dirname "$0")/..
./gen-wrapped-tb.sh $DES_NAME

rm build/tb.vvp || true
rm build/tb_out.v || true

sv2v ../designs/$DES_NAME/$TESTBENCH > build/tb_out.v
iverilog -g2012 -o build/tb.vvp "build/des"$DES_NUM"_wrapped.v" build/tb_out.v

echo ""
echo ============ Starting TB for design $DES_NAME ============
vvp build/tb.vvp
echo $?
echo ""
