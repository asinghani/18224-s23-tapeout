TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(shell pwd)/src/perceptron.sv src/lib.v
TOPLEVEL = perceptron
MODULE = perceptronTester
include $(shell cocotb-config --makefiles)/Makefile.sim