module multiplicand (
    input logic [7:0]a_in,
    input logic Load_mul,
    input logic reset,
    output logic [7:0]a_out

);


register8 r1 (

    .reset(reset),
    .Load_op(Load_mul),
    .in(a_in),
    .out(a_out)
);
endmodule

