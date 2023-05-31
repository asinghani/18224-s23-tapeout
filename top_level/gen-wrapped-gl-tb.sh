#!/bin/sh
DES_NAME=$1
DES_NUM=$(echo $DES_NAME | cut -d "_" -f 1 | tr -d "d")

rm -r build || true
mkdir -p build
sv2v --define=DES_NUM=$DES_NUM design_tb_gl_wrap.sv > build/mwrap.v
cat build/mwrap.v gl-netlist.v > "build/des"$DES_NUM"_wrapped.v"
echo "build/des"$DES_NUM"_wrapped.v"
