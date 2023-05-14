`default_nettype none

module mac
#(parameter IN_WIDTH=4,
  parameter OUT_WIDTH=4)
 (input  logic clk, rst, en, input  logic [IN_WIDTH-1:0] a, b,
  output logic [OUT_WIDTH-1:0] sum);

  logic [OUT_WIDTH-1:0] new_sum, prod;
  assign prod = a * b;
  assign new_sum = prod + sum;
  register #(OUT_WIDTH) sum_reg(.clk, .rst, .we(en),
                                   .D(new_sum), .Q(sum));
endmodule : mac
