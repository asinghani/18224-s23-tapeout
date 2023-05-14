`default_nettype none
`include "defines.vh"

module matrix
#(parameter MATRIX_DIM=16,
  parameter LENGTH=MATRIX_DIM*MATRIX_DIM)
 (input  logic                                        clk, rst, we,
  input  data_t                                       D,
  input  logic [$clog2(LENGTH)-1:0]                   addr,
  output data_t Q);

  data_t [LENGTH-1:0] data;
  assign Q = data[addr];
  always_ff @(posedge clk) begin
    if (rst)
      data <= 'b0;
    else if (we)
      data[addr] <= D;
  end

endmodule : matrix
