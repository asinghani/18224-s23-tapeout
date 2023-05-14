`default_nettype none

module register
#(parameter DATA_WIDTH=8)
 (input  logic clk, rst, we,
  input  logic [DATA_WIDTH-1:0] D,
  output logic [DATA_WIDTH-1:0] Q);

  always_ff @(posedge clk)
    if (rst)
      Q <= 'b0;
    else if (we)
      Q <= D;
endmodule : register
