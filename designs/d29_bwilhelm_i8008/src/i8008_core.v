`default_nettype none
module top (
	clk100,
	reset_n,
	uart_rx,
	uart_tx,
	base_led,
	led,
	sw,
	display_sel,
	display
);
	input wire clk100;
	input wire reset_n;
	input wire uart_rx;
	output wire uart_tx;
	output wire [7:0] base_led;
	output wire [23:0] led;
	input wire [23:0] sw;
	output wire [3:0] display_sel;
	output wire [7:0] display;
	wire clk;
	wire rst;
	wire [11:0] chip_inputs;
	wire [11:0] chip_outputs;
	wire [7:0] D_in;
	wire [7:0] D_out;
	wire INTR;
	wire READY;
	wire Sync;
	wire [2:0] state;
	reg [1:0] display_cnt;
	wire [3:0] disp_arr [0:3];
	debug_harness dbg(
		.uart_rx(uart_rx),
		.uart_tx(uart_tx),
		.chip_inputs(chip_inputs),
		.chip_outputs(chip_outputs),
		.chip_clock(clk),
		.chip_reset(rst),
		.clk100(clk100)
	);
	always @(posedge clk0)
		if (rst)
			display_cnt <= 2'd0;
		else
			display_cnt <= display_cnt + 1;
	assign display_sel = ~(1 << display_cnt);
	hex_to_sevenseg convert(
		.hexdigit(disp_arr[display_cnt]),
		.seg(display)
	);
	assign disp_arr[0] = chip_inputs[3:0];
	assign disp_arr[1] = chip_inputs[7:4];
	assign disp_arr[2] = chip_outputs[3:0];
	assign disp_arr[3] = chip_outputs[7:4];
	assign chip_outputs[7:0] = D_out;
	assign chip_outputs[10:8] = state;
	assign chip_outputs[11] = Sync;
	assign D_in = chip_inputs[7:0];
	assign INTR = chip_inputs[8];
	assign READY = chip_inputs[9];
	i8008_core #(
		.WIDTH(8),
		.STACK_HEIGHT(8)
	) DUT(
		.D_in(D_in),
		.INTR(INTR),
		.READY(READY),
		.clk(clk),
		.rst(rst),
		.D_out(D_out),
		.Sync(Sync),
		.state(state)
	);
	assign led = {rst, clk, chip_inputs[9:8], chip_outputs[10:0], chip_inputs[7:0]};
endmodule
module i8008_core (
	D_in,
	INTR,
	READY,
	clk,
	rst,
	D_out,
	Sync,
	state
);
	parameter WIDTH = 8;
	parameter STACK_HEIGHT = 8;
	input wire [7:0] D_in;
	input wire INTR;
	input wire READY;
	input wire clk;
	input wire rst;
	output wire [7:0] D_out;
	output wire Sync;
	output wire [2:0] state;
	reg [7:0] bus;
	wire [7:0] instr;
	wire enable_SP;
	reg Ready;
	reg tempR;
	reg Intr;
	reg S_Intr;
	wire A_rst;
	wire B_rst;
	wire IR_rst;
	wire SP_rst;
	wire IR_en;
	wire A_en;
	wire [7:0] A_in;
	wire [7:0] A_out;
	wire [7:0] B_in;
	wire [7:0] B_out;
	wire [7:0] ALU_out;
	wire [7:0] DBR_out;
	wire [7:0] DBR_in;
	wire [7:0] PC_out;
	wire [7:0] rf_out;
	wire [7:0] ACC;
	wire [39:0] ctrl_signals;
	wire [3:0] flags;
	wire [2:0] sel_Stack;
	wire [1:0] cycle;
	always @(posedge clk) begin
		if (rst) begin
			Ready <= 1'b0;
			tempR <= 1'b0;
		end
		else begin
			tempR <= READY;
			Ready <= tempR;
		end
		if (rst) begin
			Intr <= 1'b0;
			S_Intr <= 1'b0;
		end
		else if (state != 3'b110) begin
			S_Intr <= INTR;
			Intr <= Intr | S_Intr;
		end
		else begin
			Intr <= 1'b0;
			S_Intr <= 1'b0;
		end
	end
	assign Sync = ctrl_signals[38];
	assign D_out = bus;
	always @(*)
		if (ctrl_signals[5])
			bus = PC_out | (ctrl_signals[4] ? 8'd0 : ctrl_signals[1-:2] << 6);
		else if (ctrl_signals[11])
			bus = rf_out | (ctrl_signals[1-:2] << 6);
		else if (ctrl_signals[24])
			bus = ALU_out;
		else if (ctrl_signals[27]) begin
			bus[7:4] = 4'd0;
			bus[3:0] = flags;
		end
		else if (ctrl_signals[33])
			bus = A_out;
		else if (ctrl_signals[30])
			bus = B_out | (ctrl_signals[1-:2] << 6);
		else if (ctrl_signals[39])
			bus = D_in;
		else
			bus = 8'd0;
	assign IR_rst = ctrl_signals[34] | rst;
	assign IR_en = ctrl_signals[35] | (Ready && (cycle == 2'b00));
	Register #(.WIDTH(WIDTH)) IR(
		.d(D_in),
		.Q(instr),
		.clk(clk),
		.en(IR_en),
		.clear(IR_rst)
	);
	assign A_rst = ctrl_signals[31] | rst;
	assign B_rst = ctrl_signals[28] | rst;
	assign A_en = ctrl_signals[32];
	assign A_in = ((cycle == 2'b00) && ((state == 3'b010) || (state == 3'b110)) ? ACC : bus);
	Register #(.WIDTH(WIDTH)) regA(
		.d(A_in),
		.Q(A_out),
		.clk(clk),
		.en(A_en),
		.clear(A_rst)
	);
	Register #(.WIDTH(WIDTH)) regB(
		.d(bus),
		.Q(B_out),
		.clk(clk),
		.en(ctrl_signals[29]),
		.clear(B_rst)
	);
	ALU Unit(
		.clk(clk),
		.rst(rst),
		.a(A_out),
		.b(B_out),
		.ALU_ctrl(ctrl_signals[24-:10]),
		.d(ALU_out),
		.flags(flags)
	);
	reg_file #(
		.WIDTH(WIDTH),
		.HEIGHT(7)
	) rf(
		.clk(clk),
		.rst(rst),
		.bus(bus),
		.ACC(ACC),
		.rf_out(rf_out),
		.rf_ctrl(ctrl_signals[14-:5])
	);
	assign enable_SP = (ctrl_signals[9] & ~((sel_Stack == 3'd0) & ~ctrl_signals[7])) & ~((sel_Stack == 3'd7) & ctrl_signals[7]);
	assign SP_rst = ctrl_signals[8] | rst;
	Counter #(.WIDTH(3)) SP_SEL(
		.load(1'd0),
		.clk(clk),
		.d(3'd0),
		.Q(sel_Stack),
		.en(enable_SP),
		.clear(SP_rst),
		.up(ctrl_signals[7])
	);
	stack #(
		.WIDTH(14),
		.HEIGHT(STACK_HEIGHT)
	) Stack(
		.clk(clk),
		.rst(rst),
		.PC_out(PC_out),
		.bus(bus),
		.sel(sel_Stack),
		.Stack_ctrl(ctrl_signals[6-:7])
	);
	fsm_decoder Brain(
		.clk(clk),
		.Ready(Ready),
		.Intr(Intr),
		.rst(rst),
		.instr(instr),
		.flags(flags),
		.ctrl_signals(ctrl_signals),
		.state(state),
		.cycle(cycle)
	);
endmodule
module ALU (
	a,
	b,
	ALU_ctrl,
	clk,
	rst,
	d,
	flags
);
	parameter WIDTH = 8;
	input wire [7:0] a;
	input wire [7:0] b;
	input wire [9:0] ALU_ctrl;
	input clk;
	input rst;
	output reg [7:0] d;
	output wire [3:0] flags;
	wire [7:0] add_tmp;
	wire [7:0] art_tmp;
	reg [3:0] flag_in;
	reg [7:0] NA;
	wire Flag_rst;
	assign Flag_rst = rst | ALU_ctrl[0];
	FlagRegister #(.WIDTH(4)) flag_reg(
		.d(flag_in),
		.Q(flags),
		.clk(clk),
		.en(ALU_ctrl[1]),
		.clear(Flag_rst)
	);
	always @(*) begin
		flag_in[0] = 1'b0;
		NA = 'd0;
		d = 'd0;
		if (ALU_ctrl[2])
			case (ALU_ctrl[5-:3])
				3'b100: begin
					d = a + 1;
					flag_in[0] = flags[0];
				end
				3'b101: begin
					d = a - 1;
					flag_in[0] = flags[0];
				end
				3'b000: begin
					d = {a[6:0], a[7]};
					flag_in[0] = a[7];
				end
				3'b001: begin
					d = {a[0], a[7:1]};
					flag_in[0] = a[0];
				end
				3'b010: begin
					d = {a[6:0], flags[0]};
					flag_in[0] = a[7];
				end
				3'b011: begin
					d = {flags[0], a[7:1]};
					flag_in[0] = a[0];
				end
			endcase
		else begin
			d = 'd0;
			case (ALU_ctrl[8-:3])
				3'b000: {flag_in[0], d} = a + b;
				3'b001: {flag_in[0], d} = (a + b) + flags[0];
				3'b010: {flag_in[0], d} = a - b;
				3'b011: {flag_in[0], d} = (a - b) - flags[0];
				3'b100: d = a & b;
				3'b110: d = a | b;
				3'b101: d = a ^ b;
				3'b111: begin
					{flag_in[0], NA} = a - b;
					d = a;
				end
				default: d = 'b0;
			endcase
		end
		if (ALU_ctrl[2]) begin
			flag_in[1] = ((ALU_ctrl[5-:3] == 3'b100) || (ALU_ctrl[5-:3] == 3'b101) ? ~(|d) : flags[1]);
			flag_in[2] = ((ALU_ctrl[5-:3] == 3'b100) || (ALU_ctrl[5-:3] == 3'b101) ? d[7] : flags[2]);
			flag_in[3] = ((ALU_ctrl[5-:3] == 3'b100) || (ALU_ctrl[5-:3] == 3'b101) ? ~(^d) : flags[3]);
		end
		else begin
			flag_in[1] = (ALU_ctrl[8-:3] != 3'b111 ? ~(|d) : ~(|NA));
			flag_in[2] = (ALU_ctrl[8-:3] != 3'b111 ? d[7] : NA[7]);
			flag_in[3] = (ALU_ctrl[8-:3] != 3'b111 ? ~(^d) : ~(^NA));
		end
	end
endmodule
module fsm_decoder (
	clk,
	Ready,
	Intr,
	rst,
	instr,
	flags,
	ctrl_signals,
	state,
	cycle
);
	input wire clk;
	input wire Ready;
	input wire Intr;
	input wire rst;
	input wire [7:0] instr;
	input wire [3:0] flags;
	output reg [39:0] ctrl_signals;
	output reg [2:0] state;
	output reg [1:0] cycle;
	wire [2:0] SSS;
	wire [2:0] DDD;
	wire [2:0] D5_3;
	assign SSS = instr[2:0];
	assign DDD = instr[5:3];
	assign D5_3 = instr[5:3];
	reg [1:0] next_cycle;
	reg [2:0] next_state;
	reg CF;
	always @(*)
		case (instr[4:3])
			2'b00: CF = ~flags[0];
			2'b01: CF = ~flags[1];
			2'b10: CF = ~flags[2];
			2'b11: CF = ~flags[3];
			default: CF = 1'b1;
		endcase
	always @(*) begin
		next_cycle = cycle;
		ctrl_signals = 'd0;
		case (cycle)
			2'b00:
				case (state)
					3'b010, 3'b110: begin
						next_state = 3'b100;
						ctrl_signals[38] = 1'b1;
						ctrl_signals[5] = 1'b1;
						ctrl_signals[4] = 1'b1;
						ctrl_signals[32] = 1'b1;
					end
					3'b100: begin
						next_state = (Ready ? 3'b001 : 3'b000);
						ctrl_signals[38] = 1'b1;
						ctrl_signals[5] = 1'b1;
						ctrl_signals[4] = 1'b0;
						ctrl_signals[1-:2] = 2'b00;
						ctrl_signals[3] = 1'b1;
					end
					3'b000: next_state = (Ready ? 3'b001 : 3'b000);
					3'b001, 3'b011: begin
						if (instr == 8'b00zzz101) begin
							ctrl_signals[29] = 1'b1;
							ctrl_signals[31] = 1'b1;
							ctrl_signals[7] = 1'b1;
							ctrl_signals[9] = 1'b1;
							ctrl_signals[39] = 1'b1;
						end
						else begin
							ctrl_signals[29] = 1'b1;
							ctrl_signals[39] = 1'b1;
						end
						casez (instr)
							8'b0000000z, 8'b11111111, 8'b11zzz111:
								if (instr[7] && (D5_3 != 3'b111)) begin
									next_cycle = 2'b01;
									next_state = 3'b010;
								end
								else if (Intr) begin
									next_state = 3'b110;
									next_cycle = 2'b00;
								end
								else
									next_state = 3'b011;
							8'b000zz011, 8'b001zz011:
								if ((instr[5] & ~CF) | (~instr[5] & CF))
									next_state = 3'b111;
								else begin
									next_cycle = 2'b00;
									next_state = 3'b010;
								end
							8'b10zzz111, 8'b00zzz100, 8'b0100zzz1, 8'b01zzzzz1, 8'b00zzz110, 8'b01zzz100, 8'b010zz000, 8'b011zz000, 8'b01zzz110, 8'b011zz010, 8'b010zz010: begin
								next_cycle = 2'b01;
								next_state = 3'b010;
							end
							default: next_state = 3'b111;
						endcase
					end
					3'b111: begin
						casez (instr)
							8'b11zzzzzz, 8'b11111zzz, 8'b10zzzzzz: begin
								ctrl_signals[29] = 1'b1;
								ctrl_signals[11] = 1'b1;
								ctrl_signals[14-:3] = SSS;
							end
							8'b00zzz000, 8'b00zzz001: begin
								ctrl_signals[11] = 1'b1;
								ctrl_signals[14-:3] = DDD;
								ctrl_signals[32] = 1'b1;
							end
							8'b00000010, 8'b00001010, 8'b00010010, 8'b00011010: begin
								ctrl_signals[11] = 1'b1;
								ctrl_signals[14-:3] = 3'd0;
								ctrl_signals[32] = 1'b1;
							end
							8'b00zzz111, 8'b000zz011, 8'b001zz011: begin
								ctrl_signals[7] = 1'b0;
								ctrl_signals[9] = 1'b1;
							end
							8'b00zzz101: begin
								ctrl_signals[33] = 1'b1;
								ctrl_signals[4] = 1'b0;
								ctrl_signals[6] = 1'b1;
							end
							default:
								;
						endcase
						if (instr[7:3] == 5'b11111) begin
							next_state = 3'b010;
							next_cycle = 2'b01;
						end
						else
							next_state = 3'b101;
					end
					3'b101: begin
						casez (instr)
							8'b11zzzzzz: begin
								ctrl_signals[30] = 1'b1;
								ctrl_signals[10] = 1'b1;
								ctrl_signals[14-:3] = DDD;
							end
							8'b00zzz101: begin
								ctrl_signals[30] = 1'b1;
								ctrl_signals[6] = 1'b1;
								ctrl_signals[4] = 1'b1;
								ctrl_signals[2] = 1'b1;
							end
							8'b00zzz000, 8'b00zzz001: begin
								ctrl_signals[10] = 1'b1;
								ctrl_signals[14-:3] = DDD;
								ctrl_signals[20-:3] = (instr[2:0] == 3'b000 ? 3'b100 : 3'b101);
								ctrl_signals[17] = 1'b1;
								ctrl_signals[24] = 1'b1;
								ctrl_signals[16] = 1'b1;
							end
							8'b10zzzzzz: begin
								ctrl_signals[10] = 1'b1;
								ctrl_signals[14-:3] = 3'd0;
								ctrl_signals[23-:3] = D5_3;
								ctrl_signals[17] = 1'b0;
								ctrl_signals[24] = 1'b1;
								ctrl_signals[16] = 1'b1;
							end
							8'b00000010, 8'b00001010, 8'b00010010, 8'b00011010: begin
								ctrl_signals[10] = 1'b1;
								ctrl_signals[14-:3] = 3'd0;
								ctrl_signals[20-:3] = D5_3;
								ctrl_signals[17] = 1'b1;
								ctrl_signals[24] = 1'b1;
								ctrl_signals[16] = 1'b1;
							end
							default:
								;
						endcase
						next_state = 3'b010;
						next_cycle = 2'b00;
					end
					default: begin
						next_state = 3'b010;
						next_cycle = 2'b00;
					end
				endcase
			2'b01:
				case (state)
					3'b010, 3'b110: begin
						next_state = 3'b100;
						casez (instr)
							8'b00111110, 8'b00zzz110, 8'b00zzz100, 8'b01zzz100, 8'b010zz000, 8'b011zz000, 8'b01zzz110, 8'b011zz010, 8'b010zz010: begin
								ctrl_signals[5] = 1'b1;
								ctrl_signals[4] = 1'b1;
								ctrl_signals[38] = 1'b1;
							end
							8'b11zzz111, 8'b11111zzz, 8'b10zzz111: begin
								ctrl_signals[11] = 1'b1;
								ctrl_signals[14-:3] = 3'd6;
								ctrl_signals[38] = 1'b1;
							end
							8'b0100zzz1, 8'b01zzzzz1: begin
								ctrl_signals[33] = 1'b1;
								ctrl_signals[38] = 1'b1;
							end
							default:
								;
						endcase
					end
					3'b100: begin
						next_state = (Ready ? 3'b001 : 3'b000);
						casez (instr)
							8'b00111110, 8'b00zzz110, 8'b00zzz100, 8'b01zzz100, 8'b010zz000, 8'b011zz000, 8'b01zzz110, 8'b011zz010, 8'b010zz010: begin
								ctrl_signals[5] = 1'b1;
								ctrl_signals[38] = 1'b1;
								ctrl_signals[1-:2] = 2'b01;
								ctrl_signals[4] = 1'b0;
								ctrl_signals[3] = 1'b1;
							end
							8'b11zzz111, 8'b11111zzz, 8'b10zzz111: begin
								ctrl_signals[11] = 1'b1;
								ctrl_signals[14-:3] = 3'd5;
								ctrl_signals[1-:2] = (instr[7:3] == 5'b11111 ? 2'b11 : 2'b01);
								ctrl_signals[4] = 1'b0;
								ctrl_signals[38] = 1'b1;
							end
							8'b0100zzz1, 8'b01zzzzz1: begin
								ctrl_signals[1-:2] = 2'b10;
								ctrl_signals[4] = 1'b0;
								ctrl_signals[30] = 1'b1;
								ctrl_signals[38] = 1'b1;
							end
							default:
								;
						endcase
					end
					3'b000: next_state = (Ready ? 3'b001 : 3'b000);
					3'b001, 3'b011: begin
						casez (instr)
							8'b01zzzzz1, 8'b11111zzz: begin
								next_cycle = 2'b00;
								next_state = 3'b010;
							end
							8'b00111110, 8'b01zzz100, 8'b010zz000, 8'b011zz000, 8'b01zzz110, 8'b011zz010, 8'b010zz010: begin
								next_state = 3'b010;
								next_cycle = 2'b10;
							end
							default: next_state = 3'b111;
						endcase
						casez (instr)
							8'b0100zzz1, 8'b10zzz111, 8'b00zzz100, 8'b11zzz111, 8'b00111110, 8'b00zzz110, 8'b01zzz100, 8'b010zz000, 8'b011zz000, 8'b01zzz110, 8'b011zz010, 8'b010zz010: begin
								ctrl_signals[39] = 1'b1;
								ctrl_signals[29] = 1'b1;
							end
							8'b11111zzz: begin
								ctrl_signals[38] = 1'b1;
								ctrl_signals[30] = 1'b1;
							end
							default:
								;
						endcase
					end
					3'b111: begin
						next_state = 3'b101;
						if ((instr[7:4] == 4'b0100) && instr[0]) begin
							ctrl_signals[38] = 1'b1;
							ctrl_signals[27] = 1'b1;
						end
					end
					3'b101: begin
						next_state = 3'b010;
						next_cycle = 2'b00;
						casez (instr)
							8'b11zzz111, 8'b00zzz110, 8'b0100zzz1: begin
								ctrl_signals[30] = 1'b1;
								ctrl_signals[14-:3] = ((instr[7:4] == 4'b0100) && instr[0] ? 3'd0 : DDD);
								ctrl_signals[10] = 1'b1;
							end
							8'b10zzz111, 8'b00zzz100: begin
								ctrl_signals[14-:3] = 3'd0;
								ctrl_signals[10] = 1'b1;
								ctrl_signals[23-:3] = D5_3;
								ctrl_signals[17] = 1'b0;
								ctrl_signals[24] = 1'b1;
								ctrl_signals[16] = 1'b1;
							end
							default:
								;
						endcase
					end
					default: begin
						next_cycle = 2'b00;
						next_state = 3'b010;
					end
				endcase
			2'b10:
				case (state)
					3'b010, 3'b110: begin
						next_state = 3'b100;
						casez (instr)
							8'b00111110: begin
								ctrl_signals[14-:3] = 3'd6;
								ctrl_signals[11] = 1'b1;
								ctrl_signals[38] = 1'b1;
							end
							8'b01zzz100, 8'b010zz000, 8'b011zz000, 8'b01zzz110, 8'b011zz010, 8'b010zz010: begin
								ctrl_signals[5] = 1'b1;
								ctrl_signals[4] = 1'b1;
								ctrl_signals[38] = 1'b1;
							end
							default:
								;
						endcase
					end
					3'b100: begin
						next_state = (Ready ? 3'b001 : 3'b000);
						casez (instr)
							8'b00111110: begin
								ctrl_signals[14-:3] = 3'd5;
								ctrl_signals[11] = 1'b1;
								ctrl_signals[38] = 1'b1;
								ctrl_signals[1-:2] = 2'b11;
								ctrl_signals[4] = 1'b0;
							end
							8'b01zzz100, 8'b010zz000, 8'b011zz000, 8'b01zzz110, 8'b011zz010, 8'b010zz010: begin
								ctrl_signals[5] = 1'b1;
								ctrl_signals[4] = 1'b0;
								ctrl_signals[38] = 1'b1;
								ctrl_signals[1-:2] = 2'b01;
								ctrl_signals[3] = 1'b1;
							end
							default:
								;
						endcase
					end
					3'b000: next_state = (Ready ? 3'b001 : 3'b000);
					3'b001, 3'b011: begin
						casez (instr)
							8'b00111110: begin
								next_state = 3'b010;
								next_cycle = 2'b00;
							end
							8'b01zzz110: begin
								ctrl_signals[7] = 1'b1;
								ctrl_signals[9] = 1'b1;
								next_state = 3'b111;
							end
							8'b010zz000, 8'b010zz010:
								if (~CF) begin
									next_state = 3'b010;
									next_cycle = 2'b00;
								end
								else begin
									if ((instr[7:5] == 3'b010) && (instr[2:0] == 3'b010)) begin
										ctrl_signals[7] = 1'b1;
										ctrl_signals[9] = 1'b1;
									end
									next_state = 3'b111;
								end
							8'b011zz000, 8'b011zz010:
								if (CF) begin
									next_state = 3'b010;
									next_cycle = 2'b00;
								end
								else begin
									if ((instr[7:5] == 3'b011) && (instr[2:0] == 3'b010)) begin
										ctrl_signals[7] = 1'b1;
										ctrl_signals[9] = 1'b1;
									end
									next_state = 3'b111;
								end
							default: next_state = 3'b111;
						endcase
						casez (instr)
							8'b00111110: begin
								ctrl_signals[30] = 1'b1;
								ctrl_signals[38] = 1'b1;
							end
							8'b01zzz100, 8'b010zz000, 8'b011zz000, 8'b01zzz110, 8'b011zz010, 8'b010zz010: begin
								ctrl_signals[32] = 1'b1;
								ctrl_signals[39] = 1'b1;
							end
							default:
								;
						endcase
					end
					3'b111: begin
						next_state = 3'b101;
						casez (instr)
							8'b01zzz110, 8'b011zz010, 8'b010zz010: begin
								ctrl_signals[33] = 1'b1;
								ctrl_signals[6] = 1'b1;
								ctrl_signals[4] = 1'b0;
							end
							8'b01zzz100, 8'b010zz000, 8'b011zz000: begin
								ctrl_signals[33] = 1'b1;
								ctrl_signals[6] = 1'b1;
								ctrl_signals[4] = 1'b0;
							end
							default:
								;
						endcase
					end
					3'b101: begin
						next_state = 3'b010;
						next_cycle = 2'b00;
						casez (instr)
							8'b01zzz110, 8'b011zz010, 8'b010zz010, 8'b01zzz100, 8'b010zz000, 8'b011zz000: begin
								ctrl_signals[30] = 1'b1;
								ctrl_signals[6] = 1'b1;
								ctrl_signals[4] = 1'b1;
							end
							default:
								;
						endcase
					end
					default: begin
						next_state = 3'b010;
						next_cycle = 2'b00;
					end
				endcase
			default: begin
				next_state = 3'b010;
				next_cycle = 2'b00;
				ctrl_signals = 'd0;
			end
		endcase
	end
	always @(posedge clk)
		if (rst) begin
			cycle <= 2'b00;
			state <= 3'b010;
		end
		else begin
			cycle <= next_cycle;
			state <= next_state;
		end
endmodule
module reg_file (
	bus,
	clk,
	rst,
	rf_ctrl,
	rf_out,
	ACC
);
	parameter WIDTH = 8;
	parameter HEIGHT = 7;
	parameter SEL = $clog2(HEIGHT);
	input wire [7:0] bus;
	input wire clk;
	input wire rst;
	input wire [4:0] rf_ctrl;
	output wire [7:0] rf_out;
	output wire [7:0] ACC;
	reg [7:0] rf [0:6];
	reg [7:0] rs;
	wire [2:0] sel;
	assign sel = (rf_ctrl[4-:3] == 3'b111 ? 3'd0 : rf_ctrl[4-:3]);
	assign rf_out = rs;
	assign ACC = rf[0];
	always @(posedge clk)
		if (rst) begin
			rf[3'd0] <= 8'd0;
			rf[3'd1] <= 8'd0;
			rf[3'd2] <= 8'd0;
			rf[3'd3] <= 8'd0;
			rf[3'd4] <= 8'd0;
			rf[3'd5] <= 8'd0;
			rf[3'd6] <= 8'd0;
		end
		else if (rf_ctrl[0] && (rf_ctrl[4-:3] != 3'b111))
			rf[rf_ctrl[4-:3]] <= bus;
	always @(*) rs = rf[sel];
endmodule
module stack (
	bus,
	sel,
	clk,
	rst,
	Stack_ctrl,
	PC_out
);
	parameter WIDTH = 14;
	parameter BUS_WIDTH = 8;
	parameter HEIGHT = 8;
	parameter SEL = $clog2(HEIGHT);
	input wire [7:0] bus;
	input wire [2:0] sel;
	input wire clk;
	input wire rst;
	input wire [6:0] Stack_ctrl;
	output wire [7:0] PC_out;
	reg [13:0] rf [0:7];
	reg [13:0] rs;
	wire [7:0] upper;
	wire [7:0] RST_AAA;
	assign upper = {2'd0, rs[13:8]};
	assign PC_out = (Stack_ctrl[4] ? rs[7:0] : upper);
	assign RST_AAA[5:3] = bus[5:3];
	assign RST_AAA[2:0] = 3'd0;
	assign RST_AAA[7:6] = 2'd0;
	always @(posedge clk)
		if (rst) begin
			rf[3'd0] <= 14'd0;
			rf[3'd1] <= 14'd0;
			rf[3'd2] <= 14'd0;
			rf[3'd3] <= 14'd0;
			rf[3'd4] <= 14'd0;
			rf[3'd5] <= 14'd0;
			rf[3'd6] <= 14'd0;
			rf[3'd7] <= 14'd0;
		end
		else if (Stack_ctrl[6] && Stack_ctrl[4])
			rf[sel] <= (Stack_ctrl[2] ? {8'd0, RST_AAA} : {rf[sel][13:8], bus});
		else if (Stack_ctrl[6] && ~Stack_ctrl[4])
			rf[sel] <= {bus[5:0], rf[sel][7:0]};
		else if (Stack_ctrl[3])
			rf[sel] <= rf[sel] + 1;
	always @(*) rs = rf[sel];
endmodule
module Register (
	en,
	clear,
	clk,
	d,
	Q
);
	parameter WIDTH = 8;
	input wire en;
	input wire clear;
	input wire clk;
	input wire [7:0] d;
	output reg [7:0] Q;
	always @(posedge clk)
		if (clear)
			Q <= 'd0;
		else if (en)
			Q <= d;
endmodule
module FlagRegister (
	en,
	clear,
	clk,
	d,
	Q
);
	parameter WIDTH = 4;
	input wire en;
	input wire clear;
	input wire clk;
	input wire [3:0] d;
	output reg [3:0] Q;
	always @(posedge clk)
		if (clear)
			Q <= 'd0;
		else if (en)
			Q <= d;
endmodule
module Counter (
	en,
	clear,
	load,
	up,
	clk,
	d,
	Q
);
	parameter WIDTH = 3;
	input wire en;
	input wire clear;
	input wire load;
	input wire up;
	input wire clk;
	input wire [2:0] d;
	output reg [2:0] Q;
	always @(posedge clk)
		if (clear)
			Q <= 'd0;
		else if (load)
			Q <= d;
		else if (en && up)
			Q <= Q + 1;
		else if (en && ~up)
			Q <= Q - 1;
endmodule
module Stabilizer (
	D,
	clk,
	Q
);
	input wire D;
	input wire clk;
	output reg Q;
	reg temp;
	always @(posedge clk) begin
		temp <= D;
		Q <= temp;
	end
endmodule
`default_nettype wire
