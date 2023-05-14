# "Sub-makefile" for interfacing with CocoTB

SIM ?= icarus
TOPLEVEL_LANG ?= verilog

TOPLEVEL = BF
MODULE = src.bf_test

SIM_BUILD = $(BUILD_DIR)/sim_build
COCOTB_RESULTS_FILE = $(BUILD_DIR)/results.xml
ifeq ($(SIM), verilator)
EXTRA_ARGS += -Wno-WIDTHEXPAND
endif

include $(shell cocotb-config --makefiles)/Makefile.sim
