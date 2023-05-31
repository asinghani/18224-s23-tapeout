#!/bin/sh
DES_NAME=$1
TESTBENCH=$2
TB_MODE=${3:-flat}
DES_NUM=$(echo $DES_NAME | cut -d "_" -f 1 | tr -d "d")

cd $(dirname "$0")/..
./gen-wrapped-gl-tb.sh $DES_NAME $TB_MODE

rm build/tb.vvp || true
rm build/tb_out.v || true

sv2v --define=LOCAL_DIR="\""$(realpath .)"/../designs/$DES_NAME/\"" ../designs/$DES_NAME/$TESTBENCH > build/tb_out.v
iverilog -Ttyp -DFUNCTIONAL -DGL -DSIM -DUSE_POWER_PINS -DUNIT_DELAY=#1 -g2012 -o build/tb.vvp "build/des"$DES_NUM"_wrapped.v" build/tb_out.v

echo ""
echo ============ Starting TB for design $DES_NAME ============
vvp build/tb.vvp
echo $?
echo ""
