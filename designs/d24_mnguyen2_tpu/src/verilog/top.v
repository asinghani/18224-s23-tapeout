`default_nettype none
module counter (
	clk,
	rst,
	en,
	Q
);
	parameter DATA_WIDTH = 0;
	input wire clk;
	input wire rst;
	input wire en;
	output reg [DATA_WIDTH - 1:0] Q;
	always @(posedge clk)
		if (rst)
			Q <= 'b0;
		else if (en)
			Q <= Q + 'b1;
endmodule
`default_nettype none
module mac (
	clk,
	rst,
	en,
	a,
	b,
	sum
);
	parameter IN_WIDTH = 4;
	parameter OUT_WIDTH = 4;
	input wire clk;
	input wire rst;
	input wire en;
	input wire [IN_WIDTH - 1:0] a;
	input wire [IN_WIDTH - 1:0] b;
	output wire [OUT_WIDTH - 1:0] sum;
	wire [OUT_WIDTH - 1:0] new_sum;
	wire [OUT_WIDTH - 1:0] prod;
	assign prod = a * b;
	assign new_sum = prod + sum;
	register #(.DATA_WIDTH(OUT_WIDTH)) sum_reg(
		.clk(clk),
		.rst(rst),
		.we(en),
		.D(new_sum),
		.Q(sum)
	);
endmodule
`default_nettype none
module register (
	clk,
	rst,
	we,
	D,
	Q
);
	parameter DATA_WIDTH = 8;
	input wire clk;
	input wire rst;
	input wire we;
	input wire [DATA_WIDTH - 1:0] D;
	output reg [DATA_WIDTH - 1:0] Q;
	always @(posedge clk)
		if (rst)
			Q <= 'b0;
		else if (we)
			Q <= D;
endmodule
`default_nettype none
module tpu (
	clk,
	rst,
	insert_kernal,
	insert_matrix,
	ready,
	data_in,
	done,
	data_out
);
	parameter MATRIX_DIM = 16;
	parameter CONV_DIM = 3;
	input wire clk;
	input wire rst;
	input wire insert_kernal;
	input wire insert_matrix;
	input wire ready;
	input wire [7:0] data_in;
	output wire done;
	output wire [7:0] data_out;
	wire [((CONV_DIM * CONV_DIM) * 8) - 1:0] kernal_data;
	wire [($clog2(CONV_DIM) + $clog2(CONV_DIM)) - 1:0] kernal_addr;
	reg [(CONV_DIM * CONV_DIM) - 1:0] kernal_we;
	reg [$clog2(CONV_DIM * CONV_DIM) - 1:0] kernal_data_sel;
	always @(*) begin
		kernal_we = 'b0;
		kernal_data_sel = (kernal_addr[$clog2(CONV_DIM) + ($clog2(CONV_DIM) - 1)-:(($clog2(CONV_DIM) + ($clog2(CONV_DIM) - 1)) >= $clog2(CONV_DIM) ? (($clog2(CONV_DIM) + ($clog2(CONV_DIM) - 1)) - $clog2(CONV_DIM)) + 1 : ($clog2(CONV_DIM) - ($clog2(CONV_DIM) + ($clog2(CONV_DIM) - 1))) + 1)] * CONV_DIM) + {{$clog2(CONV_DIM) {1'b0}}, kernal_addr[$clog2(CONV_DIM) - 1-:$clog2(CONV_DIM)]};
		kernal_we[kernal_data_sel] = insert_kernal;
	end
	genvar i;
	generate
		for (i = 0; i < CONV_DIM; i = i + 1) begin : outer_loop_kernal
			genvar j;
			for (j = 0; j < CONV_DIM; j = j + 1) begin : inner_loop_kernal
				register #(.DATA_WIDTH(8)) kernal_reg(
					.clk(clk),
					.rst(rst),
					.we(kernal_we[(i * CONV_DIM) + j]),
					.D(data_in),
					.Q(kernal_data[((i * CONV_DIM) + j) * 8+:8])
				);
			end
		end
	endgenerate
	wire [((MATRIX_DIM * MATRIX_DIM) * 8) - 1:0] matrix_data;
	wire [(($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)) + ($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM))) - 1:0] matrix_addr;
	reg [(MATRIX_DIM * MATRIX_DIM) - 1:0] matrix_we;
	reg [$clog2(MATRIX_DIM * MATRIX_DIM) - 1:0] matrix_data_sel;
	always @(*) begin
		matrix_we = 'b0;
		matrix_data_sel = (matrix_addr[($clog2(MATRIX_DIM) >= 0 ? (($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)) + (($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)) - 1)) - ($clog2(MATRIX_DIM) - ($clog2(MATRIX_DIM) - 1)) : ($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)) + (1 - $clog2(MATRIX_DIM))):($clog2(MATRIX_DIM) >= 0 ? (($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)) + (($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)) - 1)) - $clog2(MATRIX_DIM) : ($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)))] * MATRIX_DIM) + {{$clog2(MATRIX_DIM) {1'b0}}, matrix_addr[($clog2(MATRIX_DIM) >= 0 ? (($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)) - 1) - ($clog2(MATRIX_DIM) - ($clog2(MATRIX_DIM) - 1)) : 1 - $clog2(MATRIX_DIM)):($clog2(MATRIX_DIM) >= 0 ? (($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)) - 1) - $clog2(MATRIX_DIM) : 0)]};
		matrix_we[matrix_data_sel] = insert_matrix;
	end
	generate
		for (i = 0; i < MATRIX_DIM; i = i + 1) begin : outer_loop_matrix
			genvar j;
			for (j = 0; j < MATRIX_DIM; j = j + 1) begin : inner_loop_matrix
				register #(.DATA_WIDTH(8)) matrix_reg(
					.clk(clk),
					.rst(rst),
					.we(matrix_we[(i * MATRIX_DIM) + j]),
					.D(data_in),
					.Q(matrix_data[((i * MATRIX_DIM) + j) * 8+:8])
				);
			end
		end
	endgenerate
	wire [($clog2(MATRIX_DIM) + $clog2(MATRIX_DIM)) - 1:0] base_addr;
	wire kernal_y_incr;
	assign kernal_y_incr = &kernal_addr[$clog2(CONV_DIM) + ($clog2(CONV_DIM) - 1)-:(($clog2(CONV_DIM) + ($clog2(CONV_DIM) - 1)) >= $clog2(CONV_DIM) ? (($clog2(CONV_DIM) + ($clog2(CONV_DIM) - 1)) - $clog2(CONV_DIM)) + 1 : ($clog2(CONV_DIM) - ($clog2(CONV_DIM) + ($clog2(CONV_DIM) - 1))) + 1)];
	counter #(.DATA_WIDTH((($clog2(CONV_DIM) + ($clog2(CONV_DIM) - 1)) >= $clog2(CONV_DIM) ? (($clog2(CONV_DIM) + ($clog2(CONV_DIM) - 1)) - $clog2(CONV_DIM)) + 1 : ($clog2(CONV_DIM) - ($clog2(CONV_DIM) + ($clog2(CONV_DIM) - 1))) + 1))) kernal_addr_x_counter(
		.clk(clk),
		.rst(rst),
		.en(1'b1),
		.Q(kernal_addr[$clog2(CONV_DIM) + ($clog2(CONV_DIM) - 1)-:(($clog2(CONV_DIM) + ($clog2(CONV_DIM) - 1)) >= $clog2(CONV_DIM) ? (($clog2(CONV_DIM) + ($clog2(CONV_DIM) - 1)) - $clog2(CONV_DIM)) + 1 : ($clog2(CONV_DIM) - ($clog2(CONV_DIM) + ($clog2(CONV_DIM) - 1))) + 1)])
	);
	counter #(.DATA_WIDTH($clog2(CONV_DIM))) kernal_addr_y_counter(
		.clk(clk),
		.rst(rst),
		.en(kernal_y_incr),
		.Q(kernal_addr[$clog2(CONV_DIM) - 1-:$clog2(CONV_DIM)])
	);
	wire base_y_incr;
	wire base_x_incr;
	assign base_x_incr = &kernal_y_incr;
	assign base_y_incr = &base_addr[$clog2(MATRIX_DIM) + ($clog2(MATRIX_DIM) - 1)-:(($clog2(MATRIX_DIM) + ($clog2(MATRIX_DIM) - 1)) >= $clog2(MATRIX_DIM) ? (($clog2(MATRIX_DIM) + ($clog2(MATRIX_DIM) - 1)) - $clog2(MATRIX_DIM)) + 1 : ($clog2(MATRIX_DIM) - ($clog2(MATRIX_DIM) + ($clog2(MATRIX_DIM) - 1))) + 1)];
	counter #(.DATA_WIDTH((($clog2(MATRIX_DIM) + ($clog2(MATRIX_DIM) - 1)) >= $clog2(MATRIX_DIM) ? (($clog2(MATRIX_DIM) + ($clog2(MATRIX_DIM) - 1)) - $clog2(MATRIX_DIM)) + 1 : ($clog2(MATRIX_DIM) - ($clog2(MATRIX_DIM) + ($clog2(MATRIX_DIM) - 1))) + 1))) base_addr_x_counter(
		.clk(clk),
		.rst(rst),
		.en(base_x_incr),
		.Q(base_addr[$clog2(MATRIX_DIM) + ($clog2(MATRIX_DIM) - 1)-:(($clog2(MATRIX_DIM) + ($clog2(MATRIX_DIM) - 1)) >= $clog2(MATRIX_DIM) ? (($clog2(MATRIX_DIM) + ($clog2(MATRIX_DIM) - 1)) - $clog2(MATRIX_DIM)) + 1 : ($clog2(MATRIX_DIM) - ($clog2(MATRIX_DIM) + ($clog2(MATRIX_DIM) - 1))) + 1)])
	);
	counter #(.DATA_WIDTH($clog2(MATRIX_DIM))) base_addr_y_counter(
		.clk(clk),
		.rst(rst),
		.en(base_y_incr),
		.Q(base_addr[$clog2(MATRIX_DIM) - 1-:$clog2(MATRIX_DIM)])
	);
	parameter DIFF = $clog2(MATRIX_DIM) - $clog2(CONV_DIM);
	assign matrix_addr[($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)) + (($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)) - 1)-:((($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)) + (($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)) - 1)) >= ($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)) ? ((($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)) + (($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)) - 1)) - ($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM))) + 1 : (($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)) - (($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)) + (($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)) - 1))) + 1)] = base_addr[$clog2(MATRIX_DIM) + ($clog2(MATRIX_DIM) - 1)-:(($clog2(MATRIX_DIM) + ($clog2(MATRIX_DIM) - 1)) >= $clog2(MATRIX_DIM) ? (($clog2(MATRIX_DIM) + ($clog2(MATRIX_DIM) - 1)) - $clog2(MATRIX_DIM)) + 1 : ($clog2(MATRIX_DIM) - ($clog2(MATRIX_DIM) + ($clog2(MATRIX_DIM) - 1))) + 1)] + {{DIFF {1'b0}}, kernal_addr[$clog2(CONV_DIM) + ($clog2(CONV_DIM) - 1)-:(($clog2(CONV_DIM) + ($clog2(CONV_DIM) - 1)) >= $clog2(CONV_DIM) ? (($clog2(CONV_DIM) + ($clog2(CONV_DIM) - 1)) - $clog2(CONV_DIM)) + 1 : ($clog2(CONV_DIM) - ($clog2(CONV_DIM) + ($clog2(CONV_DIM) - 1))) + 1)]};
	assign matrix_addr[($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM)) - 1-:($clog2(MATRIX_DIM) >= 0 ? $clog2(MATRIX_DIM) + 1 : 1 - $clog2(MATRIX_DIM))] = base_addr[$clog2(MATRIX_DIM) - 1-:$clog2(MATRIX_DIM)] + {{DIFF {1'b0}}, kernal_addr[$clog2(CONV_DIM) - 1-:$clog2(CONV_DIM)]};
	wire mac_en;
	wire mac_rst;
	assign mac_rst = base_x_incr & ready;
	assign done = mac_rst;
	assign mac_en = 1'b1;
	mac #(
		.IN_WIDTH(8),
		.OUT_WIDTH(8)
	) conv_mac(
		.clk(clk),
		.rst(mac_rst),
		.en(mac_en),
		.a(kernal_data[kernal_data_sel * 8+:8]),
		.b(matrix_data[matrix_data_sel * 8+:8]),
		.sum(data_out)
	);
endmodule
