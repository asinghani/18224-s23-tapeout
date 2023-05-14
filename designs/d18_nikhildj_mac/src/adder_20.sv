
module carry_select20(
  input logic [19:0] a, b,
    input logic carry_in,
  output logic [19:0] sum,
    output logic carry_out
);
wire temp_carry1,temp_carry2,temp_carry3,temp_carry4;
  

  carry_select4 S0 (.a(a[3:0]), .b(b[3:0]), .carry_in(carry_in), .sum(sum[3:0]), .carry_out(temp_carry1));
  carry_select4 S1 (.a(a[7:4]), .b(b[7:4]), .carry_in(temp_carry1), .sum(sum[7:4]), .carry_out(temp_carry2));
  carry_select4 S2 (.a(a[11:8]), .b(b[11:8]), .carry_in(temp_carry2), .sum(sum[11:8]), .carry_out(temp_carry3));
  carry_select4 S3 (.a(a[15:12]), .b(b[15:12]), .carry_in(temp_carry3), .sum(sum[15:12]), .carry_out(temp_carry4));
  carry_select4 S4 (.a(a[19:16]), .b(b[19:16]), .carry_in(temp_carry4), .sum(sum[19:16]), .carry_out(carry_out));



endmodule






  
