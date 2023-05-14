
module carry_select8(
  input logic [7:0] a, b,
    input logic carry_in,
  output logic [7:0] sum,
    output logic carry_out
);
logic temp_carry;
  

  carry_select4 S0 (.a(a[3:0]), .b(b[3:0]), .carry_in(carry_in), .sum(sum[3:0]), .carry_out(temp_carry));
  carry_select4 S1 (.a(a[7:4]), .b(b[7:4]), .carry_in(temp_carry), .sum(sum[7:4]), .carry_out(carry_out));



endmodule














