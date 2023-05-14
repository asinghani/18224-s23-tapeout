module ripple_carry_adder (
  input logic [3:0] a,
  input logic [3:0] b,
  input logic carry_in,
  output logic [3:0] sum,
  output logic carry_out
);

  wire w1, w2, w3;
  fulladder fa0(a[0], b[0], carry_in, sum[0],w1);
  fulladder fa1(a[1], b[1], w1, sum[1], w2);
  fulladder fa2(a[2], b[2], w2, sum[2], w3);
  fulladder fa3(a[3], b[3], w3, sum[3], carry_out);

endmodule