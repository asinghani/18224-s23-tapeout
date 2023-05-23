module test;
	reg reset;
	reg clock;
	wire mac_carry_out;
	wire finish;
	wire shiftout;
	wire end_mul;
	wire [11:0] io_out;
	reg start;
	reg shiftA;
	reg shiftB;
	reg shift;
	reg do_next;
	assign {mac_carry_out, finish, shiftout, end_mul} = io_out[11:8];
	toplevel_chip dut(
		.io_in({reset, clock, start, shiftA, shiftB, shift, do_next, 7'b0000000}),
		.io_out(io_out)
	);
	initial begin
		clock = 0;
		forever #(5) clock = ~clock;
	end
	task shiftIn;
		input [7:0] d1;
		input [7:0] d2;
		begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < 8; i = i + 1)
				begin
					shiftA = d1[7 - i];
					shiftB = d2[7 - i];
					shift = 1;
					@(posedge clock)
						;
					@(posedge clock)
						;
					shift = 0;
					@(posedge clock)
						;
					@(posedge clock)
						;
				end
		end
	endtask
	reg [19:0] dout;
	task shiftOut;
		begin : sv2v_autoblock_2
			reg signed [31:0] i;
			for (i = 0; i < 20; i = i + 1)
				begin
					dout[i] = shiftout;
					shift = 1;
					@(posedge clock)
						;
					@(posedge clock)
						;
					shift = 0;
					@(posedge clock)
						;
					@(posedge clock)
						;
				end
		end
	endtask
	initial begin
		reset = 1;
		start = 0;
		shiftA = 0;
		shiftB = 0;
		shift = 0;
		do_next = 0;
		$monitor($time, , "finish=%d, end_mul=%d, shiftout=%d, start=%d, shiftA=%d, shiftB=%d, shift=%d", finish, end_mul, shiftout, start, shiftA, shiftB, shift);
		@(posedge clock)
			@(posedge clock) reset = 0;
		@(posedge clock)
			@(posedge clock) start = 1;
		@(posedge clock)
			;
		start = 0;
		@(posedge clock)
			;
		@(posedge clock)
			;
		repeat (100) @(posedge clock)
			;
		begin : sv2v_autoblock_3
			reg signed [31:0] i;
			for (i = 0; i < 9; i = i + 1)
				begin
					shiftIn(i + 2, i + 3);
					repeat (20) @(posedge clock)
						;
					do_next = 1;
					@(posedge clock) do_next = 0;
					repeat (100) @(posedge clock)
						;
				end
		end
		while (!finish) @(posedge clock)
			;
		@(posedge clock)
			;
		@(posedge clock)
			;
		shiftOut;
		$display("result = %d (exp = 438)", dout);
		$finish;
	end
endmodule
`default_nettype none
module toplevel_chip (
	io_in,
	io_out
);
	input [13:0] io_in;
	output wire [13:0] io_out;
	my_chip mchip(
		.io_in(io_in[11:0]),
		.io_out(io_out[11:0]),
		.clock(io_in[12]),
		.reset(io_in[13])
	);
	assign io_out[13:12] = 2'b00;
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
	wire reset_n;
	wire START;
	reg [7:0] op_a_in;
	reg [7:0] op_b_in;
	wire [19:0] mac_res;
	wire mac_carry_out;
	wire Finish;
	wire End_mul;
	wire do_next;
	assign reset_n = !reset;
	assign START = io_in[11];
	assign do_next = io_in[7];
	assign io_out[11] = mac_carry_out;
	assign io_out[10] = Finish;
	reg [19:0] shiftout;
	assign io_out[9] = shiftout[0];
	assign io_out[8] = End_mul;
	assign io_out[7:0] = 8'd0;
	reg shiftin;
	reg _Finish;
	wire control_reset;
	always @(posedge clock) begin
		$display("OPS %b %b %b %d %d %d %d %d", op_a_in, op_b_in, mac_res, End_mul, Finish, START, control.state, control_reset);
		shiftin <= io_in[8];
		_Finish <= Finish;
		if (io_in[8] && !shiftin) begin
			op_a_in <= {op_a_in, io_in[10]};
			op_b_in <= {op_b_in, io_in[9]};
			shiftout <= shiftout[19:1];
		end
		if (Finish && ~_Finish)
			shiftout <= mac_res;
	end
	wire Begin_mul;
	wire add;
	wire Load_op;
	wire [7:0] op_a_out;
	wire [7:0] op_b_out;
	wire [15:0] mult_res;
	CONTROLLER_MAC control(
		.reset(reset_n),
		.clk(clock),
		.START(START),
		.End_mul(End_mul),
		.Finish(Finish),
		.RESET_cmd(control_reset),
		.Load_op(Load_op),
		.Begin_mul(Begin_mul),
		.add(add),
		.do_next(do_next)
	);
	register8 opa(
		.in(op_a_in),
		.Load_op(Load_op),
		.reset(control_reset),
		.out(op_a_out)
	);
	register8 opb(
		.in(op_b_in),
		.Load_op(Load_op),
		.reset(control_reset),
		.out(op_b_out)
	);
	top_multiplier mult(
		.a_in(op_a_out),
		.b_in(op_b_out),
		.reset(control_reset),
		.clk(clock),
		.Begin_mul(Begin_mul),
		.mult_out(mult_res),
		.End_mul(End_mul)
	);
	add_accumulate aa(
		.mult_res_in(mult_res),
		.add(add),
		.reset(control_reset),
		.result(mac_res),
		.result_carry_out(mac_carry_out)
	);
endmodule
module carry_select8 (
	a,
	b,
	carry_in,
	sum,
	carry_out
);
	input wire [7:0] a;
	input wire [7:0] b;
	input wire carry_in;
	output wire [7:0] sum;
	output wire carry_out;
	wire temp_carry;
	carry_select4 S0(
		.a(a[3:0]),
		.b(b[3:0]),
		.carry_in(carry_in),
		.sum(sum[3:0]),
		.carry_out(temp_carry)
	);
	carry_select4 S1(
		.a(a[7:4]),
		.b(b[7:4]),
		.carry_in(temp_carry),
		.sum(sum[7:4]),
		.carry_out(carry_out)
	);
endmodule
module DFF (
	reset,
	clk,
	D,
	Q
);
	input wire reset;
	input wire clk;
	input wire D;
	output reg Q;
	always @(posedge clk)
		if (!reset)
			Q <= 0;
		else
			Q <= D;
endmodule
module add_accumulate (
	mult_res_in,
	add,
	reset,
	result,
	result_carry_out
);
	input wire [15:0] mult_res_in;
	input wire add;
	input wire reset;
	output wire [19:0] result;
	output wire result_carry_out;
	wire [19:0] temp_mult_res_in;
	wire [19:0] mult_res_out;
	wire [19:0] add_out;
	wire [19:0] add_in;
	wire [19:0] temp_result;
	assign temp_result = result;
	assign add_in = temp_result;
	assign temp_mult_res_in[19:0] = {4'b0000, mult_res_in};
	register20 i0(
		.in(temp_mult_res_in),
		.add(add),
		.reset(reset),
		.out(mult_res_out)
	);
	carry_select20 adder(
		.a(mult_res_out),
		.b(add_in),
		.carry_in(1'b0),
		.sum(add_out),
		.carry_out(result_carry_out)
	);
	register20 accmulate(
		.in(add_out),
		.add(!add),
		.reset(reset),
		.out(result)
	);
endmodule
module carry_select20 (
	a,
	b,
	carry_in,
	sum,
	carry_out
);
	input wire [19:0] a;
	input wire [19:0] b;
	input wire carry_in;
	output wire [19:0] sum;
	output wire carry_out;
	wire temp_carry1;
	wire temp_carry2;
	wire temp_carry3;
	wire temp_carry4;
	carry_select4 S0(
		.a(a[3:0]),
		.b(b[3:0]),
		.carry_in(carry_in),
		.sum(sum[3:0]),
		.carry_out(temp_carry1)
	);
	carry_select4 S1(
		.a(a[7:4]),
		.b(b[7:4]),
		.carry_in(temp_carry1),
		.sum(sum[7:4]),
		.carry_out(temp_carry2)
	);
	carry_select4 S2(
		.a(a[11:8]),
		.b(b[11:8]),
		.carry_in(temp_carry2),
		.sum(sum[11:8]),
		.carry_out(temp_carry3)
	);
	carry_select4 S3(
		.a(a[15:12]),
		.b(b[15:12]),
		.carry_in(temp_carry3),
		.sum(sum[15:12]),
		.carry_out(temp_carry4)
	);
	carry_select4 S4(
		.a(a[19:16]),
		.b(b[19:16]),
		.carry_in(temp_carry4),
		.sum(sum[19:16]),
		.carry_out(carry_out)
	);
endmodule
module carry_select4 (
	a,
	b,
	carry_in,
	sum,
	carry_out
);
	input wire [3:0] a;
	input wire [3:0] b;
	input wire carry_in;
	output wire [3:0] sum;
	output wire carry_out;
	wire [3:0] SUM0;
	wire [3:0] SUM1;
	wire carry0;
	wire carry1;
	ripple_carry_adder S0(
		.a(a),
		.b(b),
		.carry_in(1'b0),
		.sum(SUM0),
		.carry_out(carry0)
	);
	ripple_carry_adder S1(
		.a(a),
		.b(b),
		.carry_in(1'b1),
		.sum(SUM1),
		.carry_out(carry1)
	);
	assign sum = (carry_in == 1'b0 ? SUM0 : (carry_in == 1'b1 ? SUM1 : 4'bxxxx));
	assign carry_out = (carry_in & carry1) | carry0;
endmodule
module fulladder (
	a,
	b,
	carry_in,
	sum,
	carry_out
);
	input a;
	input b;
	input carry_in;
	output wire sum;
	output wire carry_out;
	wire w1;
	wire w2;
	wire w3;
	assign w1 = a ^ b;
	assign sum = w1 ^ carry_in;
	assign w2 = a & b;
	assign w3 = w1 & carry_in;
	assign carry_out = w2 | w3;
endmodule
module CONTROLLER_MAC (
	reset,
	clk,
	START,
	End_mul,
	do_next,
	Finish,
	RESET_cmd,
	Load_op,
	Begin_mul,
	add
);
	input wire reset;
	input wire clk;
	input wire START;
	input wire End_mul;
	input wire do_next;
	output wire Finish;
	output wire RESET_cmd;
	output wire Load_op;
	output wire Begin_mul;
	output wire add;
	reg [3:0] temp_count;
	reg [2:0] state;
	reg _do_next;
	always @(posedge clk) begin
		_do_next <= do_next;
		if (!reset) begin
			state <= 3'd0;
			temp_count <= 4'b1001;
		end
		else
			case (state)
				3'd0:
					if (START)
						state <= 3'd1;
					else
						state <= 3'd0;
				3'd1: state <= 3'd2;
				3'd2: state <= 3'd3;
				3'd3: state <= 3'd4;
				3'd4:
					if (!End_mul)
						state <= 3'd4;
					else
						state <= 3'd5;
				3'd5:
					if (temp_count == 4'b0000) begin
						temp_count <= 4'b1001;
						state <= 3'd0;
					end
					else
						state <= 3'd6;
				3'd6:
					if (do_next && !_do_next) begin
						temp_count <= temp_count - 1;
						state <= 3'd2;
					end
				default: state <= 3'd0;
			endcase
	end
	assign Finish = state == 3'd0;
	assign Load_op = state == 3'd2;
	assign Begin_mul = state == 3'd3;
	assign add = state == 3'd5;
	assign RESET_cmd = ((state == 3'd1) || (reset == 1'b0) ? 1'b0 : 1'b1);
endmodule
module multiplicand (
	a_in,
	Load_mul,
	reset,
	a_out
);
	input wire [7:0] a_in;
	input wire Load_mul;
	input wire reset;
	output wire [7:0] a_out;
	register8 r1(
		.reset(reset),
		.Load_op(Load_mul),
		.in(a_in),
		.out(a_out)
	);
endmodule
module MULTIPLIER_RESULT (
	reset,
	clk,
	b_in,
	Load_mul,
	do_shift,
	do_add,
	sum_out,
	carry_out,
	mult_out,
	LSB,
	b_out
);
	input wire reset;
	input wire clk;
	input wire [7:0] b_in;
	input wire Load_mul;
	input wire do_shift;
	input wire do_add;
	input wire [7:0] sum_out;
	input wire carry_out;
	output wire [15:0] mult_out;
	output wire LSB;
	output wire [7:0] b_out;
	reg [16:0] temp_register;
	reg temp_Add;
	always @(posedge clk)
		if (!reset) begin
			temp_register <= 1'sb0;
			temp_Add <= 1'b0;
		end
		else if (Load_mul) begin
			temp_register[16:8] <= 1'sb0;
			temp_register[7:0] <= b_in;
		end
		else begin
			if (do_add)
				temp_Add <= 1'b1;
			if (do_shift)
				if (temp_Add) begin
					temp_Add <= 1'b0;
					temp_register <= {1'b0, carry_out, sum_out, temp_register[7:1]};
				end
				else
					temp_register <= {1'b0, temp_register[16:1]};
		end
	assign b_out = temp_register[15:8];
	assign LSB = temp_register[0];
	assign mult_out = temp_register[15:0];
endmodule
module CONTROLLER (
	reset,
	clk,
	Begin_mul,
	LSB,
	do_add,
	do_shift,
	Load_mul,
	End_mul
);
	input wire reset;
	input wire clk;
	input wire Begin_mul;
	input wire LSB;
	output wire do_add;
	output wire do_shift;
	output wire Load_mul;
	output wire End_mul;
	reg [2:0] temp_count;
	reg [3:0] state;
	always @(posedge clk)
		if (!reset) begin
			state <= 4'd0;
			temp_count <= 3'b000;
		end
		else
			case (state)
				4'd0:
					if (Begin_mul)
						state <= 4'd1;
					else
						state <= 4'd0;
				4'd1: state <= 4'd2;
				4'd2:
					if (!LSB)
						state <= 4'd4;
					else
						state <= 4'd3;
				4'd3: state <= 4'd4;
				4'd4:
					if (temp_count == 3'b111) begin
						temp_count <= 3'b000;
						state <= 4'd0;
					end
					else begin
						temp_count <= temp_count + 1;
						state <= 4'd2;
					end
				default: state <= 4'd0;
			endcase
	assign End_mul = state == 4'd0;
	assign do_add = state == 4'd3;
	assign do_shift = state == 4'd4;
	assign Load_mul = state == 4'd1;
endmodule
module register20 (
	in,
	add,
	reset,
	out
);
	input wire [19:0] in;
	input wire add;
	input wire reset;
	output wire [19:0] out;
	wire [19:0] temp_out;
	genvar i;
	generate
		for (i = 0; i < 20; i = i + 1) begin : dff_gen
			DFF d2(
				.reset(reset),
				.clk(add),
				.D(in[i]),
				.Q(temp_out[i])
			);
		end
	endgenerate
	assign out = temp_out;
endmodule
module register8 (
	in,
	Load_op,
	reset,
	out
);
	input wire [7:0] in;
	input wire Load_op;
	input wire reset;
	output wire [7:0] out;
	wire [7:0] temp_out;
	genvar i;
	generate
		for (i = 0; i < 8; i = i + 1) begin : dff_gen
			DFF d1(
				.reset(reset),
				.clk(Load_op),
				.D(in[i]),
				.Q(temp_out[i])
			);
		end
	endgenerate
	assign out = temp_out;
endmodule
module ripple_carry_adder (
	a,
	b,
	carry_in,
	sum,
	carry_out
);
	input wire [3:0] a;
	input wire [3:0] b;
	input wire carry_in;
	output wire [3:0] sum;
	output wire carry_out;
	wire w1;
	wire w2;
	wire w3;
	fulladder fa0(
		.a(a[0]),
		.b(b[0]),
		.carry_in(carry_in),
		.sum(sum[0]),
		.carry_out(w1)
	);
	fulladder fa1(
		.a(a[1]),
		.b(b[1]),
		.carry_in(w1),
		.sum(sum[1]),
		.carry_out(w2)
	);
	fulladder fa2(
		.a(a[2]),
		.b(b[2]),
		.carry_in(w2),
		.sum(sum[2]),
		.carry_out(w3)
	);
	fulladder fa3(
		.a(a[3]),
		.b(b[3]),
		.carry_in(w3),
		.sum(sum[3]),
		.carry_out(carry_out)
	);
endmodule
module top_multiplier (
	a_in,
	b_in,
	reset,
	clk,
	Begin_mul,
	mult_out,
	End_mul
);
	input wire [7:0] a_in;
	input wire [7:0] b_in;
	input wire reset;
	input wire clk;
	input wire Begin_mul;
	output wire [15:0] mult_out;
	output wire End_mul;
	wire do_add;
	wire do_shift;
	wire LSB;
	wire Load_mul;
	wire [7:0] sum_out;
	wire carry_out;
	wire [7:0] b_out;
	wire [7:0] a_out;
	CONTROLLER i0(
		.reset(reset),
		.clk(clk),
		.Begin_mul(Begin_mul),
		.LSB(LSB),
		.do_add(do_add),
		.do_shift(do_shift),
		.Load_mul(Load_mul),
		.End_mul(End_mul)
	);
	multiplicand i1(
		.a_in(a_in),
		.Load_mul(Load_mul),
		.reset(reset),
		.a_out(a_out)
	);
	carry_select8 i2(
		.a(a_out),
		.b(b_out),
		.carry_in(1'b0),
		.sum(sum_out),
		.carry_out(carry_out)
	);
	MULTIPLIER_RESULT i3(
		.reset(reset),
		.clk(clk),
		.b_in(b_in),
		.Load_mul(Load_mul),
		.do_shift(do_shift),
		.do_add(do_add),
		.sum_out(sum_out),
		.carry_out(carry_out),
		.mult_out(mult_out),
		.LSB(LSB),
		.b_out(b_out)
	);
endmodule
