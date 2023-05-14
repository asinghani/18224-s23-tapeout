`default_nettype none

module sram
#(parameter DATA_WIDTH = 8,
  parameter NUM_ELEM = 8)
 (input  logic clk, rst, we, re,
  input  logic [$clog2(NUM_ELEM)-1:0] addr,
  input  logic [DATA_WIDTH-1:0] data_in,
  output logic [DATA_WIDTH-1:0] data_out);

  logic [NUM_ELEM-1:0][DATA_WIDTH-1:0] mem;

  always_ff @(posedge clk)
    if (rst)
      mem <= 'b0;
    else if (we)
      mem[addr] <= data_in;

  always_latch
    if (re)
      data_out = mem[addr];

endmodule : sram
