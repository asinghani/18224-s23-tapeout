`default_nettype none

module async_fifo
  #(parameter WIDTH=4,
    parameter DEPTH=4)
  (input logic rst,
   input logic wclk, we,
   output logic full,
   input logic[WIDTH-1:0] wdata,
   input logic rclk, re,
   output logic empty,
   output logic[WIDTH-1:0] rdata);

  // extra bit for full detection
  parameter PTR_WIDTH = $clog2(DEPTH)+1;

  logic [PTR_WIDTH-1:0] wptr, wptr_gray, rptr, rptr_gray;
  logic [WIDTH-1:0] data[DEPTH-1:0];

  // store data
  always_ff @(posedge wclk)
    if(we & ~full)
      data[wptr[PTR_WIDTH-2:0]] <= wdata;
  assign rdata = data[rptr[PTR_WIDTH-2:0]];

  // all logic in write domain
  write_half #(PTR_WIDTH) frontend
    (.rst, .wclk, .we,
     .rptr_gray,
     .wptr, .wptr_gray,
     .full);

  // all logic in read domain
  read_half #(PTR_WIDTH) backend
    (.rst, .rclk, .re,
     .wptr_gray,
     .rptr, .rptr_gray,
     .empty);
endmodule: async_fifo

module read_half
  #(parameter PTR_WIDTH)
  (input logic rst, rclk, re,
   input logic [PTR_WIDTH-1:0] wptr_gray,
   output logic [PTR_WIDTH-1:0] rptr, rptr_gray,
   output logic empty);

  logic [PTR_WIDTH-1:0] wptr_gray1, wptr_gray2;

  // rptr counter
  reg_ar #(PTR_WIDTH) rptr_reg
    (.rst, .clk(rclk), .en(re & ~empty),
     .d(rptr + (PTR_WIDTH)'(1)), .q(rptr));

  // sync wptr_gray
  reg_ar #(2*PTR_WIDTH) wptr_gray_sync
    (.rst, .clk(rclk), .en('1),
     .d({wptr_gray, wptr_gray1}), .q({wptr_gray1, wptr_gray2}));

  // generate gray code
  bin2gray #(PTR_WIDTH) rptr_b2g
    (.binary(rptr), .gray(rptr_gray));

  // empty is easy to check
  assign empty = wptr_gray2 == rptr_gray;
endmodule

module write_half
  #(parameter PTR_WIDTH)
  (input logic rst, wclk, we,
   input logic [PTR_WIDTH-1:0] rptr_gray,
   output logic [PTR_WIDTH-1:0] wptr, wptr_gray,
   output logic full);

  logic [PTR_WIDTH-1:0] rptr_gray1, rptr_gray2;

  // wptr counter
  reg_ar #(PTR_WIDTH) wptr_reg
    (.rst, .clk(wclk), .en(we & ~full),
     .d(wptr + (PTR_WIDTH)'(1)), .q(wptr));

  // sync rptr_gray
  reg_ar #(2*PTR_WIDTH) rptr_gray_sync
    (.rst, .clk(wclk), .en('1),
     .d({rptr_gray, rptr_gray1}), .q({rptr_gray1, rptr_gray2}));

  // generate gray code
  bin2gray #(PTR_WIDTH) wptr_b2g
    (.binary(wptr), .gray(wptr_gray));

  // grey code math...
  if(PTR_WIDTH > 2)
    assign full = rptr_gray2[PTR_WIDTH-1 -: 2] == ~wptr_gray[PTR_WIDTH-1 -: 2]
                  && rptr_gray2[0 +: (PTR_WIDTH-2)] == wptr_gray[0 +: (PTR_WIDTH-2)];
  else
    assign full = rptr_gray2 == ~wptr_gray;
endmodule

module reg_ar
  #(parameter WIDTH)
  (input logic clk, rst, en,
   input logic[WIDTH-1:0] d,
   output logic[WIDTH-1:0] q);
  always_ff @(posedge clk)
    if(rst)
      q <= '0;
    else if(en)
      q <= d;
endmodule // reg_ar

module gray2bin
  #(parameter WIDTH)
  (input logic[WIDTH-1:0] gray,
   output logic[WIDTH-1:0] binary);

  generate for(genvar i = 0; i < WIDTH-1; i++)
    assign binary[i] = gray[i] ^ binary[i+1];
  endgenerate
  assign binary[WIDTH-1] = gray[WIDTH-1];
endmodule // gray2bin

module bin2gray
  #(parameter WIDTH)
  (input logic[WIDTH-1:0] binary,
   output logic [WIDTH-1:0] gray);

  assign gray = binary ^ (binary >> 1);
endmodule // bin2gray
