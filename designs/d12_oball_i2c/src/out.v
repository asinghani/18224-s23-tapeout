`default_nettype none
module I2C (
	SCL_in,
	SDA_in,
	clock,
	reset,
	SDA_out
);
	input wire SCL_in;
	input wire SDA_in;
	input wire clock;
	input wire reset;
	output wire SDA_out;
	wire SCL_sync;
	wire SDA_sync;
	wire counted_8;
	wire clear_counter;
	wire start;
	wire stop;
	wire clear_start;
	wire clear_stop;
	wire addr_valid;
	wire clear_mem;
	wire in_enable;
	wire send_ack;
	wire we;
	wire [8:0] data_in;
	wire reg_sel_en;
	wire reg_sel_inc;
	wire data_out;
	wire [2:0] reg_sel_latched;
	wire [3:0] count;
	Synchronizer S1(
		.async(SCL_in),
		.sync(SCL_sync),
		.clock(clock)
	);
	Synchronizer S2(
		.async(SDA_in),
		.sync(SDA_sync),
		.clock(clock)
	);
	gen_output OUT(
		.send_ack(send_ack),
		.serial_out(data_out),
		.out_en(1'b0),
		.SDA_out(SDA_out)
	);
	count_8 COUNT(
		.clock(SCL_sync),
		.done(counted_8),
		.clear(clear_counter),
		.count(count)
	);
	start_detect START(
		.start(start),
		.SCL(SCL_sync),
		.SDA(SDA_sync),
		.clear_start(clear_start | reset)
	);
	stop_detect STOP(
		.stop(stop),
		.SCL(SCL_sync),
		.SDA(SDA_sync),
		.clear_stop(clear_stop | reset)
	);
	data_input IN_REG(
		.SCL(SCL_sync),
		.SDA(SDA_sync),
		.enable(in_enable),
		.data_in(data_in),
		.reset(reset)
	);
	check_addr ADDR(
		.data_in(data_in[7:1]),
		.addr_valid(addr_valid)
	);
	reg_sel REG(
		.reset(reset),
		.clock(SCL_sync),
		.sel_out(reg_sel_latched),
		.sel_in(data_in[2:0]),
		.en(reg_sel_en),
		.inc(reg_sel_inc)
	);
	memory MEM(
		.we(we),
		.clock(SCL_sync),
		.reset(reset),
		.sel(reg_sel_latched),
		.count(count[2:0]),
		.data_in(data_in[7:0]),
		.data_out(data_out)
	);
	FSM M(
		.clear_stop(clear_stop),
		.clear_start(clear_start),
		.clear_counter(clear_counter),
		.clear_mem(clear_mem),
		.SCL(SCL_sync),
		.SDA(SDA_sync),
		.clock(clock),
		.start(start),
		.stop(stop),
		.reset(reset),
		.counted_8(counted_8),
		.addr_valid(addr_valid),
		.data_in(data_in),
		.in_enable(in_enable),
		.send_ack(send_ack),
		.reg_sel_en(reg_sel_en),
		.reg_sel_inc(reg_sel_inc),
		.we(we)
	);
endmodule
module FSM (
	clear_stop,
	clear_start,
	clear_counter,
	clear_mem,
	in_enable,
	send_ack,
	reg_sel_en,
	reg_sel_inc,
	we,
	SCL,
	SDA,
	clock,
	start,
	stop,
	reset,
	counted_8,
	addr_valid,
	data_in
);
	output reg clear_stop;
	output reg clear_start;
	output reg clear_counter;
	output reg clear_mem;
	output reg in_enable;
	output reg send_ack;
	output reg reg_sel_en;
	output reg reg_sel_inc;
	output reg we;
	input wire SCL;
	input wire SDA;
	input wire clock;
	input wire start;
	input wire stop;
	input wire reset;
	input wire counted_8;
	input wire addr_valid;
	input wire [8:0] data_in;
	reg [3:0] currState;
	reg [3:0] nextState;
	wire read_write;
	assign read_write = data_in[8];
	always @(*)
		case (currState)
			4'd0: nextState = 4'd1;
			4'd1: nextState = 4'd2;
			4'd2: nextState = (start ? 4'd3 : 4'd2);
			4'd3:
				if (counted_8)
					nextState = (addr_valid ? 4'd4 : 4'd1);
				else
					nextState = 4'd3;
			4'd4: nextState = 4'd5;
			4'd5: nextState = (counted_8 ? 4'd6 : 4'd5);
			4'd6: nextState = (read_write ? 4'd8 : 4'd7);
			4'd7: nextState = (counted_8 ? 4'd9 : 4'd7);
			4'd9: nextState = 4'd7;
			default: nextState = 4'd1;
		endcase
	always @(*) begin
		clear_stop = 1'b0;
		clear_start = 1'b0;
		clear_counter = 1'b0;
		clear_mem = 1'b0;
		in_enable = 1'b0;
		send_ack = 1'b0;
		reg_sel_en = 1'b0;
		reg_sel_inc = 1'b0;
		we = 1'b0;
		case (currState)
			4'd0: clear_mem = 1'b1;
			4'd1: {clear_stop, clear_start} = 2'b11;
			4'd2: clear_counter = 1'b1;
			4'd3: {clear_start, in_enable} = 2'b11;
			4'd4: {send_ack, clear_counter} = 2'b11;
			4'd5: in_enable = 1'b1;
			4'd6: {send_ack, clear_counter, reg_sel_en} = 3'b111;
			4'd7: in_enable = 1'b1;
			4'd9: {send_ack, clear_counter, reg_sel_inc, we} = 4'b1111;
			default: clear_mem = 1'b1;
		endcase
	end
	reg prev_SCL;
	always @(posedge clock) begin
		if (reset) begin
			currState <= 4'd0;
			prev_SCL <= 1'b0;
		end
		else if (stop)
			currState <= 4'd1;
		else if ((currState == 4'd0) || (currState == 4'd1))
			currState <= nextState;
		else if ((SCL == 1'b0) && (prev_SCL == 1'b1))
			currState <= nextState;
		prev_SCL <= SCL;
	end
endmodule
`default_nettype none
module Synchronizer (
	async,
	clock,
	sync
);
	input wire async;
	input wire clock;
	output wire sync;
	wire temp;
	DFlipFlop m1(
		.D(async),
		.clock(clock),
		.Q(temp)
	);
	DFlipFlop m2(
		.D(temp),
		.clock(clock),
		.Q(sync)
	);
endmodule
module DFlipFlop (
	D,
	clock,
	Q
);
	input wire D;
	input wire clock;
	output reg Q;
	always @(posedge clock) Q <= D;
endmodule
module start_detect (
	SCL,
	SDA,
	clear_start,
	start
);
	input wire SCL;
	input wire SDA;
	input wire clear_start;
	output reg start;
	always @(negedge SDA or posedge clear_start)
		if (clear_start == 1'b1)
			start = 1'b0;
		else if (SCL == 1'b1)
			start = 1'b1;
endmodule
module stop_detect (
	SCL,
	SDA,
	clear_stop,
	stop
);
	input wire SCL;
	input wire SDA;
	input wire clear_stop;
	output reg stop;
	always @(posedge SDA or posedge clear_stop)
		if (clear_stop == 1'b1)
			stop = 1'b0;
		else if (SCL == 1'b1)
			stop = 1'b1;
endmodule
module data_input (
	SCL,
	SDA,
	enable,
	reset,
	data_in
);
	input wire SCL;
	input wire SDA;
	input wire enable;
	input wire reset;
	output wire [8:0] data_in;
	ShiftRegister_SIPO #(.WIDTH(9)) SHIFT(
		.serial(SDA),
		.clock(SCL),
		.en(enable),
		.Q(data_in),
		.reset(reset)
	);
endmodule
module ShiftRegister_SIPO (
	serial,
	en,
	clock,
	reset,
	Q
);
	parameter WIDTH = 8;
	input wire serial;
	input wire en;
	input wire clock;
	input wire reset;
	output reg [WIDTH - 1:0] Q;
	always @(posedge clock or posedge reset)
		if (reset)
			Q <= {WIDTH - 1 {1'b0}};
		else if (en)
			Q <= {Q[WIDTH - 2:0], serial};
endmodule
module count_8 (
	clear,
	clock,
	done,
	count
);
	input wire clear;
	input wire clock;
	output wire done;
	output reg [3:0] count;
	assign done = count == 4'b1000;
	always @(posedge clock or posedge clear)
		if (clear == 1'b1)
			count <= 4'b0000;
		else if (count < 4'b1000)
			count <= count + 4'b0001;
endmodule
module check_addr (
	data_in,
	addr_valid
);
	input wire [6:0] data_in;
	output wire addr_valid;
	assign addr_valid = data_in == 7'h20;
endmodule
module reg_sel (
	sel_in,
	inc,
	en,
	clock,
	reset,
	sel_out
);
	input wire [2:0] sel_in;
	input wire inc;
	input wire en;
	input wire clock;
	input wire reset;
	output reg [2:0] sel_out;
	always @(negedge clock or posedge reset)
		if (reset)
			sel_out <= 3'b000;
		else if (en)
			sel_out <= sel_in;
		else if (inc)
			sel_out = sel_out + 3'd1;
endmodule
module memory (
	we,
	clock,
	reset,
	sel,
	count,
	data_in,
	data_out
);
	input wire we;
	input wire clock;
	input wire reset;
	input wire [2:0] sel;
	input wire [2:0] count;
	input wire [7:0] data_in;
	output wire data_out;
	reg [2:0] index;
	reg [7:0] r0;
	reg [7:0] r1;
	reg [7:0] r2;
	reg [7:0] r3;
	reg [7:0] r4;
	reg [7:0] r5;
	reg [7:0] r6;
	reg [7:0] r7;
	reg [7:0] data_out_8;
	assign data_out = data_out_8[index];
	always @(*)
		case (sel)
			3'd0: data_out_8 = r0;
			3'd1: data_out_8 = r1;
			3'd2: data_out_8 = r2;
			3'd3: data_out_8 = r3;
			3'd4: data_out_8 = r4;
			3'd5: data_out_8 = r5;
			3'd6: data_out_8 = r6;
			3'd7: data_out_8 = r7;
			default: data_out_8 = 8'b00000000;
		endcase
	always @(negedge clock or posedge reset)
		if (reset)
			{r0, r1, r2, r3, r4, r5, r6, r7} <= 'b0;
		else if (we) begin
			case (sel)
				3'd0: r0 <= data_in;
				3'd1: r1 <= data_in;
				3'd2: r2 <= data_in;
				3'd3: r3 <= data_in;
				3'd4: r4 <= data_in;
				3'd5: r5 <= data_in;
				3'd6: r6 <= data_in;
				3'd7: r7 <= data_in;
			endcase
			index <= count;
		end
endmodule
module gen_output (
	send_ack,
	serial_out,
	out_en,
	SDA_out
);
	input wire send_ack;
	input wire serial_out;
	input wire out_en;
	output reg SDA_out;
	always @(*)
		if (send_ack)
			SDA_out = 1'b0;
		else if (out_en && ~serial_out)
			SDA_out = 1'b0;
		else
			SDA_out = 1'b1;
endmodule
