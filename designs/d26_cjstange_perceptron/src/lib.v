module counter (clk,
				reset_l,
				en,
				clr,
				count);
	parameter WIDTH = 0;
	input wire clk;
	input wire reset_l;
	input wire en;
	input wire clr;
	output reg [WIDTH - 1:0] count;

	always @(posedge clk or negedge reset_l)
		if (!reset_l)
			count <= 'b0;
		else if (clr)
			count <= 'b0;
		else if (en)
			count <= count + 1;
endmodule

module register (clk,
				 en,
				 reset_l,
				 D,
				 Q);
	parameter WIDTH = 0;
	input wire clk;
	input wire en;
	input wire reset_l;
	input wire [WIDTH - 1:0] D;
	output reg [WIDTH - 1:0] Q;

	always @(posedge clk or negedge reset_l)
		if (!reset_l)
			Q <= 'b0;
		else if (en)
			Q <= D;
endmodule

module mux (in,
			sel,
			out);
	parameter INPUTS = 0;
	parameter WIDTH = 0;
	input wire [(INPUTS * WIDTH) - 1:0] in;
	input wire [$clog2(INPUTS) - 1:0] sel;
	output wire [WIDTH - 1:0] out;

	assign out = in[sel * WIDTH+:WIDTH];
endmodule

module mult (A,
			 B,
			 M);
	input wire [5:0] A;
	input wire [5:0] B;
	output wire [5:0] M;
	wire [11:0] tmp;

	assign tmp = A * B;
	assign M = tmp[9:3];
endmodule

module adder (cin,
			  A,
	  		  B,
			  cout,
			  sum);
	parameter WIDTH = 0;
	input wire cin;
	input wire [WIDTH - 1:0] A;
	input wire [WIDTH - 1:0] B;
	output wire cout;
	output wire [WIDTH - 1:0] sum;
	
	assign {cout, sum} = (A + B) + cin;
endmodule