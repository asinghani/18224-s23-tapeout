module top_multiplier (
    input logic [7:0] a_in,
    input logic [7:0] b_in,
    input logic reset,
    input logic clk,
    input logic Begin_mul,
    output logic [15:0] mult_out,
    output logic End_mul

);
logic do_add;
logic do_shift;
logic LSB;
logic Load_mul;
logic [7:0] sum_out;
logic carry_out;
logic [7:0] b_out;
logic [7:0]a_out;






CONTROLLER i0 (
    .reset(reset),
    .clk(clk),
    .Begin_mul(Begin_mul),
    .LSB(LSB),
    .do_add(do_add),
    .do_shift(do_shift),
    .Load_mul(Load_mul),
    .End_mul(End_mul)

);

multiplicand i1 (
    .a_in(a_in),
    .Load_mul(Load_mul),
    
    .reset(reset),
    .a_out(a_out)
);

carry_select8 i2 (
    .a(a_out),
    .b(b_out),
    .carry_in(1'b0),
    .sum(sum_out),
    .carry_out(carry_out)
);

MULTIPLIER_RESULT i3 (
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


