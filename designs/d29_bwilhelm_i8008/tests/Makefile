TOPLEVEL_LANG ?= verilog

PWD=$(shell pwd)

#export PYTHONPATH := $(PWD)/../model:$(PYTHONPATH)

VERILOG_SOURCES = $(PWD)/../src/i8008_core.v
TOPLEVEL := i8008_core
MODULE := i8008_tb

include $(shell cocotb-config --makefiles)/Makefile.sim