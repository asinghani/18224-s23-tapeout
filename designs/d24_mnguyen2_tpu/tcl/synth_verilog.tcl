yosys -import
read_verilog src/verilog/top.v
procs; opt;
synth -top tpu -flatten
stat -tech cmos
