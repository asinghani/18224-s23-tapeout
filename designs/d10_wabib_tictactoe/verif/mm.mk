TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(shell pwd)/ttt.sv
TOPLEVEL = ttt_game_control
MODULE = tb
include $(shell cocotb-config --makefiles)/Makefile.sim
