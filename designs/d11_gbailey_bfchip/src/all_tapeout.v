`default_nettype none
`default_nettype none
module BF (
	addr,
	val_out,
	val_in,
	bus_op,
	halted,
	clock,
	reset,
	enable
);
	parameter DATA_ADDR_WIDTH = 16;
	parameter PROG_ADDR_WIDTH = 16;
	parameter DATA_WIDTH = 8;
	parameter DEPTH_WIDTH = 12;
	function integer max;
		input integer a;
		input integer b;
		max = (a > b ? a : b);
	endfunction
	parameter ADDR_WIDTH = max(DATA_ADDR_WIDTH, PROG_ADDR_WIDTH);
	parameter BUS_WIDTH = max(DATA_WIDTH, 8);
	output reg [ADDR_WIDTH - 1:0] addr;
	output reg [BUS_WIDTH - 1:0] val_out;
	input wire [BUS_WIDTH - 1:0] val_in;
	output wire [2:0] bus_op;
	output reg halted;
	input wire clock;
	input wire reset;
	input wire enable;
	reg [5:0] state;
	reg [5:0] next_state;
	reg [13:0] ucode;
	reg [DATA_ADDR_WIDTH - 1:0] cursor;
	reg [PROG_ADDR_WIDTH - 1:0] pc;
	always @(*)
		case (ucode[10-:2])
			2'd0: addr = 1'sb0;
			2'd1: addr = pc;
			2'd2: addr = cursor;
			default: addr = 1'sb0;
		endcase
	reg [DATA_WIDTH - 1:0] acc;
	always @(*)
		case (ucode[8-:2])
			2'd0: val_out = 1'sb0;
			2'd1: val_out = acc;
			2'd2: val_out = acc + 1;
			2'd3: val_out = acc - 1;
			default: val_out = 1'sb0;
		endcase
	reg [PROG_ADDR_WIDTH - 1:0] next_pc;
	always @(*)
		case (ucode[6-:2])
			2'd0: next_pc = pc;
			2'd1: next_pc = pc + 1;
			2'd2: next_pc = pc - 1;
			default: next_pc = pc;
		endcase
	reg [DATA_ADDR_WIDTH - 1:0] next_cursor;
	always @(*)
		case (ucode[4-:2])
			2'd0: next_cursor = cursor;
			2'd1: next_cursor = cursor + 1;
			2'd2: next_cursor = cursor - 1;
			default: next_cursor = cursor;
		endcase
	reg [DATA_WIDTH - 1:0] next_acc;
	always @(*)
		case (ucode[2])
			1'd0: next_acc = acc;
			1'd1: next_acc = val_in;
			default: next_acc = acc;
		endcase
	reg [DEPTH_WIDTH - 1:0] depth;
	reg [DEPTH_WIDTH - 1:0] next_depth;
	always @(*)
		case (ucode[1-:2])
			2'd0: next_depth = depth;
			2'd1: next_depth = 1'sb0;
			2'd2: next_depth = depth + 1;
			2'd3: next_depth = depth - 1;
			default: next_depth = depth;
		endcase
	assign bus_op = ucode[13-:3];
	always @(posedge clock)
		if (reset) begin
			pc <= 1'sb0;
			cursor <= 1'sb0;
			acc <= 1'sb0;
			depth <= 1'sb0;
			state <= 6'd0;
		end
		else if (enable) begin
			pc <= next_pc;
			cursor <= next_cursor;
			acc <= next_acc;
			depth <= next_depth;
			state <= next_state;
		end
	always @(*) begin
		halted = 0;
		next_state = 6'd2;
		case (state)
			6'd0: begin
				ucode = 14'b01001000100001;
				next_state = 6'd1;
			end
			6'd1: begin
				ucode = 14'b00000000000001;
				case (val_in)
					"+": next_state = 6'd3;
					"-": next_state = 6'd6;
					">": next_state = 6'd9;
					"<": next_state = 6'd10;
					".": next_state = 6'd11;
					",": next_state = 6'd14;
					"[": next_state = 6'd17;
					"]": next_state = 6'd23;
					8'h00: next_state = 6'd2;
					default: next_state = 6'd0;
				endcase
			end
			6'd2: begin
				ucode = 14'b00000000000001;
				next_state = 6'd2;
				halted = 1;
			end
			6'd3: begin
				ucode = 14'b10010000000001;
				next_state = 6'd4;
			end
			6'd4: begin
				ucode = 14'b00000000000101;
				next_state = 6'd5;
			end
			6'd5: begin
				ucode = 14'b10110100000001;
				next_state = 6'd0;
			end
			6'd6: begin
				ucode = 14'b10010000000001;
				next_state = 6'd7;
			end
			6'd7: begin
				ucode = 14'b00000000000101;
				next_state = 6'd8;
			end
			6'd8: begin
				ucode = 14'b10110110000001;
				next_state = 6'd0;
			end
			6'd9: begin
				ucode = 14'b00000000001001;
				next_state = 6'd0;
			end
			6'd10: begin
				ucode = 14'b00000000010001;
				next_state = 6'd0;
			end
			6'd11: begin
				ucode = 14'b10010000000001;
				next_state = 6'd12;
			end
			6'd12: begin
				ucode = 14'b00000000000101;
				next_state = 6'd13;
			end
			6'd13: begin
				ucode = 14'b11100010000001;
				next_state = 6'd0;
			end
			6'd14: begin
				ucode = 14'b11000000000001;
				next_state = 6'd15;
			end
			6'd15: begin
				ucode = 14'b00000000000101;
				next_state = 6'd16;
			end
			6'd16: begin
				ucode = 14'b10110010000001;
				next_state = 6'd0;
			end
			6'd17: begin
				ucode = 14'b10010000000001;
				next_state = 6'd18;
			end
			6'd18: begin
				ucode = 14'b00000000000001;
				if (val_in == {BUS_WIDTH {1'sb0}})
					next_state = 6'd19;
				else
					next_state = 6'd0;
			end
			6'd19: begin
				ucode = 14'b01001000100000;
				next_state = 6'd20;
			end
			6'd20: begin
				ucode = 14'b00000000000000;
				case (val_in)
					"[": next_state = 6'd21;
					"]":
						if (depth == {DEPTH_WIDTH {1'sb0}})
							next_state = 6'd0;
						else
							next_state = 6'd22;
					8'h00: next_state = 6'd2;
					default: next_state = 6'd19;
				endcase
			end
			6'd21: begin
				ucode = 14'b00000000000010;
				next_state = 6'd19;
			end
			6'd22: begin
				ucode = 14'b00000000000011;
				next_state = 6'd19;
			end
			6'd23: begin
				ucode = 14'b10010000000001;
				next_state = 6'd24;
			end
			6'd24: begin
				ucode = 14'b00000000000001;
				if (val_in == {BUS_WIDTH {1'sb0}})
					next_state = 6'd0;
				else
					next_state = 6'd25;
			end
			6'd25: begin
				ucode = 14'b00000001000001;
				next_state = 6'd26;
			end
			6'd26: begin
				ucode = 14'b00000001000001;
				next_state = 6'd27;
			end
			6'd27: begin
				ucode = 14'b01001001000000;
				next_state = 6'd28;
			end
			6'd28: begin
				ucode = 14'b00000000000000;
				case (val_in)
					"[":
						if (depth == {DEPTH_WIDTH {1'sb0}})
							next_state = 6'd31;
						else
							next_state = 6'd30;
					"]": next_state = 6'd29;
					8'h00: next_state = 6'd2;
					default: next_state = 6'd27;
				endcase
			end
			6'd29: begin
				ucode = 14'b00000000000010;
				next_state = 6'd27;
			end
			6'd30: begin
				ucode = 14'b00000000000011;
				next_state = 6'd27;
			end
			6'd31: begin
				ucode = 14'b00000000100001;
				next_state = 6'd32;
			end
			6'd32: begin
				ucode = 14'b00000000100001;
				next_state = 6'd0;
			end
			default: begin
				ucode = 14'b00000000000000;
				next_state = 6'd2;
			end
		endcase
	end
endmodule
`default_nettype none
module my_chip (
	io_in,
	io_out,
	clock,
	reset
);
	input wire [11:0] io_in;
	output wire [11:0] io_out;
	input wire clock;
	input wire reset;
	reg [7:0] bus_out;
	reg [2:0] state;
	reg [2:0] next_state;
	wire halted;
	assign io_out = {halted, state, bus_out};
	wire [7:0] bus_in;
	assign bus_in = io_in[7:0];
	wire op_done;
	assign op_done = io_in[8];
	wire enable;
	assign enable = io_in[9];
	wire [15:0] addr;
	reg [7:0] val_in;
	wire [7:0] val_out;
	wire [2:0] bus_op;
	reg bf_enable;
	BF bf(
		.addr(addr),
		.val_in(val_in),
		.val_out(val_out),
		.bus_op(bus_op),
		.halted(halted),
		.clock(clock),
		.reset(reset),
		.enable(enable && bf_enable)
	);
	reg [2:0] op_cache;
	reg [15:0] addr_cache;
	reg [7:0] val_cache;
	reg cache_out;
	reg cache_in;
	always @(*) begin
		bf_enable = 0;
		cache_out = 0;
		cache_in = 0;
		bus_out = 1'sb0;
		case (state)
			3'b000: begin
				bf_enable = 1;
				cache_out = 1;
				if (bus_op != 3'b000)
					next_state = 3'b001;
				else
					next_state = 3'b000;
			end
			3'b001: begin
				bus_out = {5'b00000, op_cache};
				next_state = 3'b010;
			end
			3'b010: begin
				bus_out = addr_cache[15:8];
				next_state = 3'b011;
			end
			3'b011: begin
				bus_out = addr_cache[7:0];
				next_state = 3'b100;
			end
			3'b100: begin
				bus_out = val_cache;
				cache_in = 1;
				if (op_done)
					next_state = 3'b000;
				else
					next_state = 3'b100;
			end
			default: next_state = 3'b000;
		endcase
	end
	always @(posedge clock)
		if (reset) begin
			state <= 3'b000;
			op_cache <= 3'b000;
			addr_cache <= 1'sb0;
			val_cache <= 1'sb0;
			val_in <= 1'sb0;
		end
		else if (enable) begin
			state <= next_state;
			if (cache_out) begin
				op_cache <= bus_op;
				addr_cache <= addr;
				val_cache <= val_out;
			end
			if (cache_in)
				val_in <= bus_in;
		end
endmodule