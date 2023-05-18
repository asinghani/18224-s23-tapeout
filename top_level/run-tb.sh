#!/bin/sh
DES_NAME=$1
DES_NUM=$(echo $DES_NAME | cut -d "_" -f 1 | tr -d "d")

rm -r build || true
mkdir -p build
sv2v ../designs/$DES_NAME/standard_tb.sv > build/tb.v
sv2v --define=DES_NUM=$DES_NUM design_insts_tb.sv > build/des_tb.v

cat build/tb.v build/des_tb.v design_instantiations_flattened.v > build/tb_top.v


iverilog -g2012 -o build/tb.vvp build/tb_top.v

echo ""
echo ============ Starting TB for design $DES_NAME ============
vvp build/tb.vvp
echo $?
echo ""
