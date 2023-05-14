`default_nettype none

module counter
#(parameter DATA_WIDTH = 8,
  parameter MAX = {DATA_WIDTH{1'b1}})
 (input  logic clk, rst, en,
  output logic [DATA_WIDTH-1:0] Q);

  logic [DATA_WIDTH-1:0] Q_next;
  assign Q_next = (Q == MAX) ? 'b0 : Q + 'b1;
  always_ff @(posedge clk)
    if (rst)
      Q <= 'b0;
    else if (en)
      Q <= Q_next;
endmodule : counter
