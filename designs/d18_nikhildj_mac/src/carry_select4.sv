module carry_select4(
  input logic [3:0] a, b,
    input logic carry_in,
  output logic [3:0] sum,
    output logic carry_out
);
logic [3:0] SUM0, SUM1;
logic carry0, carry1;
  

  ripple_carry_adder S0 (.a(a), .b(b), .carry_in(1'b0), .sum(SUM0), .carry_out(carry0));
  ripple_carry_adder S1 (.a(a), .b(b), .carry_in(1'b1), .sum(SUM1), .carry_out(carry1));





assign sum = (carry_in == 1'b0) ? SUM0 :
                (carry_in == 1'b1) ? SUM1 : 4'bx;
assign carry_out = (carry_in & carry1) | carry0;

endmodule