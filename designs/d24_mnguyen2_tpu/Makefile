SV_FILES = src/*.sv
V_FILES = src/verilog/top.v
VH_FILES = src/*.vh
INCLUDES_DIR = src/

SYNTH = yosys
SYNTH_FLAGS =

.PHONY: synth synth.verilog clean

synth: $(SV_FILES) $(VH_FILES)
	$(SYNTH) $(SYNTH_FLAGS) -c tcl/synth.tcl

synth.verilog: $(V_FILES)
	$(SYNTH) $(SYNTH_FLAGS) -c tcl/synth_verilog.tcl

$(V_FILES): $(SV_FILES) $(VH_FILES)
	sv2v -I $(INCLUDES_DIR) $(SV_FILES) > $(V_FILES)
clean:
	rm $(V_FILES)
