export BUILD_DIR ?= build
export SRC_DIR ?= src

SV2V ?= sv2v
YOSYS ?= yosys
NEXTPNR ?= nextpnr-ice40
ICEPACK ?= icepack

DIR_GUARD = @mkdir -p $(@D)
export PYTHONDONTWRITEBYTECODE=1

.PHONY: all clean test fpga tapeout
all: test

clean:
	rm -rf $(BUILD_DIR)

## Sim/testbench stuff: delegate to CocoTB ##
SIM_SOURCES += \
	$(SRC_DIR)/consts.sv \
	$(SRC_DIR)/bf.sv
export VERILOG_SOURCES = $(BUILD_DIR)/all_sim.v # for cocotb

test: $(VERILOG_SOURCES)
	$(MAKE) --no-print-directory -f cocotb.mk

$(BUILD_DIR)/all_sim.v: $(SIM_SOURCES)
	$(DIR_GUARD)
	$(SV2V) -w $(BUILD_DIR)/all_sim.v $(SIM_SOURCES)

## FPGA stuff ##
fpga: $(BUILD_DIR)/bitstream.bit

FPGA_SOURCES += \
	$(SRC_DIR)/consts.sv \
	$(SRC_DIR)/bf.sv \
	$(SRC_DIR)/chip.sv \
	$(SRC_DIR)/fpga_top.sv \
	$(SRC_DIR)/debugbus.sv

$(BUILD_DIR)/all_fpga.v: $(FPGA_SOURCES)
	$(DIR_GUARD)
	$(SV2V) -w $(BUILD_DIR)/all_fpga.v $(FPGA_SOURCES)

$(BUILD_DIR)/synthesis.json: $(BUILD_DIR)/all_fpga.v
	$(DIR_GUARD)
	$(YOSYS) -p " \
		read_verilog -sv $(BUILD_DIR)/all_fpga.v; \
		synth_ice40 -json $(BUILD_DIR)/synthesis.json -top top;"

$(BUILD_DIR)/pnr.asc: $(BUILD_DIR)/synthesis.json $(SRC_DIR)/constraints.pcf
	$(DIR_GUARD)
	$(NEXTPNR) \
		--hx8k \
		--json $(BUILD_DIR)/synthesis.json \
		--pcf $(SRC_DIR)/constraints.pcf \
		--package cb132 \
		--freq 32 \
		--asc $(BUILD_DIR)/pnr.asc

$(BUILD_DIR)/bitstream.bit: $(BUILD_DIR)/pnr.asc
	$(DIR_GUARD)
	$(ICEPACK) $(BUILD_DIR)/pnr.asc $(BUILD_DIR)/bitstream.bit

## Tapeout stuff ##
tapeout: $(BUILD_DIR)/all_tapeout.v

TAPEOUT_SOURCES += \
	$(SRC_DIR)/consts.sv \
	$(SRC_DIR)/bf.sv \
	$(SRC_DIR)/chip.sv

$(BUILD_DIR)/all_tapeout.v: $(TAPEOUT_SOURCES)
	$(DIR_GUARD)
	$(SV2V) -w $(BUILD_DIR)/all_tapeout.v $(TAPEOUT_SOURCES)
