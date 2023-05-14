/// TestBench //// 

`timescale 1ns/1ps
`default_nettype none
module fpu_16_tb;

logic [15:0] input_1;
logic [15:0] input_2;
logic [15:0] result;
logic valid;
logic [15:0] expected_result;
logic [11:0] io_in,io_out;
logic reset;
logic result_en,temp;
logic clock;

logic [15:0] received_result;
integer counter;
always #0.5 clock = ~clock;

my_chip inst_fpu1 (
	.io_in(io_in),
	.io_out(io_out),
	.reset(reset),
	.clock(clock)
	);

// Select = 1 ---- Addition
// Select = 0 ---- Multiplication
initial begin
	clock = 0;
	reset = 1;
	counter = 0;
	repeat(10) @(negedge clock);
	reset = 0;
	// Addition 
	input_en(1);
	select(1);
	write(16'h5051,16'h5051);
	expected_result = 16'h5451;
	input_en(0);
	read();
	// Multiplication
	input_en(1);
	select(0);
	write(16'h5007,16'h5007);
	expected_result = 16'h640E;
	input_en(0);
	read();
	// Addition
	input_en(1);
	select(1);
	write(16'h5051,16'hD051);
	expected_result = 16'h0000;
	input_en(0);
	read();
	// Multiplication
	input_en(1);
	select(0);
	write(16'h5007,16'hD007);
	expected_result = 16'hE40E;
	input_en(0);
	read();
	// Addition
	input_en(1);
	select(1);
	write(16'h4D3D,16'h48EA);
	expected_result = 16'h4FB2;
	input_en(0);
	read();
	// Multiplication
	input_en(1);
	select(0);
	write(16'h4976,16'h426C);
	expected_result = 16'h5062;
	input_en(0);
	read();
	// Addition
	input_en(1);
	select(1);
	write(16'hCD3D,16'hC8EA);
	expected_result = 16'hCFB2;
	input_en(0);
	read();
	// Multiplication
	input_en(1);
	select(0);
	write(16'hC976,16'hC26C);
	expected_result = 16'h5062;
	input_en(0);
	read();
	// Addition
	input_en(1);
	select(1);
	write(16'h4D86,16'hC91C);
	expected_result = 16'h49F0;
	input_en(0);
	read();
	// Multiplication
	input_en(1);
	select(0);
	write(16'hC976,16'h426C);
	expected_result = 16'hD062;
	input_en(0);
	read();
	// Addition
	input_en(1);
	select(1);
	write(16'hCD86,16'h491C);
	expected_result = 16'hC9F0;
	input_en(0);
	read();
	// Multiplication
	input_en(1);
	select(0);
	write(16'h426C,16'hC976);
	expected_result = 16'hD062;
	input_en(0);
	read();
	// Addition
	input_en(1);
	select(1);
	write(16'h03FF,16'h0001);
	expected_result = 16'h0400;
	input_en(0);
	read();
	// Multiplication
	input_en(1);
	select(0);
	write(16'h03FF,16'h0001);
	expected_result = 16'h0000;
	input_en(0);
	read();
	// Addition
	input_en(1);
	select(1);
	write(16'h03FF,16'h03FF);
	expected_result = 16'h07FE;
	input_en(0);
	read();
	// Multiplication
	input_en(1);
	select(0);
	write(16'h03FF,16'h03FF);
	expected_result = 16'h0000;
	input_en(0);
	read();
	// Addition
	input_en(1);
	select(1);
	write(16'h7BFF,16'h7BFF);
	expected_result = 16'h7C00;
	input_en(0);
	read();
	// Multiplication
	input_en(1);
	select(0);
	write(16'h7BFF,16'h7BFF);
	expected_result = 16'h7C00;
	input_en(0);
	read();
	// Addition
	input_en(1);
	select(1);
	write(16'h7C00,16'h3666);
	expected_result = 16'h7C00;
	input_en(0);
	read();
	// Multiplication
	input_en(1);
	select(0);
	write(16'h7C00,16'h3666);
	expected_result = 16'h7C00;
	input_en(0);
	read();
	// Addition
	input_en(1);
	select(1);
	write(16'hFC00,16'h0015);
	expected_result = 16'hFC00;
	input_en(0);
	read();
	// Multiplication
	input_en(1);
	select(0);
	write(16'hFFFF,16'h7BFF);
	expected_result = 16'hFFFF;
	input_en(0);
	read();
	// Addition
	input_en(1);
	select(1);
	write(16'hFFFF,16'h7BFF);
	expected_result = 16'hFFFF;
	input_en(0);
	read();


#500;
$finish;
end

// Example 8'hDA -- D is for value 1 and A is for Value 2  

task automatic write(input [15:0] a, input [15:0] b);
begin

	repeat(1) @(negedge clock);
	io_in[3:0] = a[3:0];
	io_in[7:4] = b[3:0];
	repeat(1) @(negedge clock);
	io_in[3:0] = a[7:4];
	io_in[7:4] = b[7:4];
	repeat(1) @(negedge clock);
	io_in[3:0] = a[11:8];
	io_in[7:4] = b[11:8];
	repeat(1) @(negedge clock);
	io_in[3:0] = a[15:12];
	io_in[7:4] = b[15:12];
	repeat(2) @(negedge clock);
end
endtask

task automatic read();
begin
	 repeat(2) @(negedge clock);
     received_result[7:0] = io_out[7:0];
     repeat(1) @(negedge clock);
     received_result[15:8] = io_out[7:0];
     repeat(1) @(negedge clock);
	 counter = counter +1;
end
endtask

// Select Signal to chose between Adder and Multiplier
task automatic select(input logic n);
begin
	io_in[8] = n;
end
endtask

// Control Signal to tell the module that input is coming
task automatic input_en(input logic n);
begin
	io_in[9] = n;
end
endtask

always @(posedge clock) begin
	temp <= io_out[8];
end

always @(posedge clock) begin 
	result_en <= temp && io_out[8];
end

// Checker Script
always @(posedge clock) begin
	if(result_en) begin
	$display("Hello - No Error - Yaaaaay - Count - %d",counter);
	if((received_result != expected_result))  begin
		$display("Oh Shit Error --- Expected Result: %h, Achieved Result: %h",expected_result,received_result);
	end

	end
end
endmodule 
