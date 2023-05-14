yosys -import
read_verilog -sv src/*.sv src/*.vh
procs; opt;
synth -top tpu -flatten
stat -tech cmos
