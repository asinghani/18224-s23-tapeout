module fulladder(
input a,b,carry_in,
output sum, carry_out
  
);
  
  wire w1,w2,w3;
  
  assign w1 = a ^ b;
  assign sum = w1 ^ carry_in;
  assign w2 = a&b;
  assign w3 = w1 & carry_in;
  assign carry_out = w2 | w3;
endmodule 