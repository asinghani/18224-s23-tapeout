/* Automatically generated from https://wokwi.com/projects/350041131706221138 */

`default_nettype none

module user_module_350041131706221138(
  input [7:0] io_in,
  output [7:0] io_out
);
  wire net1 = io_in[0];
  wire net2 = io_in[1];
  wire net3 = io_in[2];
  wire net4;
  wire net5;
  wire net6;
  wire net7;
  wire net8;
  wire net9;
  wire net10;
  wire net11;
  wire net12 = 1'b0;
  wire net13 = 1'b1;
  wire net14;
  wire net15 = 1'b1;
  wire net16;
  wire net17;
  wire net18;
  wire net19;
  wire net20;
  wire net21;
  wire net22;
  wire net23;
  wire net24;
  wire net25;
  wire net26;
  wire net27;
  wire net28;
  wire net29;
  wire net30;
  wire net31;
  wire net32;
  wire net33;
  wire net34;
  wire net35;
  wire net36;
  wire net37;

  assign io_out[0] = net4;
  assign io_out[1] = net5;
  assign io_out[2] = net6;
  assign io_out[3] = net7;
  assign io_out[4] = net8;
  assign io_out[5] = net9;
  assign io_out[6] = net10;
  assign io_out[7] = net11;

  not_cell gate5 (
    .in (net2),
    .out (net14)
  );
  dff_cell flipflop2 (
    .d (net16),
    .clk (net1),
    .q (net17)
  );
  dff_cell flipflop1 (
    .d (net18),
    .clk (net1),
    .q (net19)
  );
  dff_cell flipflop3 (
    .d (net17),
    .clk (net1),
    .q (net18)
  );
  dff_cell flipflop4 (
    .d (net19),
    .clk (net1),
    .q (net20),
    .notq (net21)
  );
  dff_cell flipflop5 (
    .d (net21),
    .clk (net1),
    .q (net22)
  );
  dff_cell flipflop6 (
    .d (net23),
    .clk (net1),
    .q (net24),
    .notq (net25)
  );
  dff_cell flipflop7 (
    .d (net22),
    .clk (net1),
    .q (net23)
  );
  dff_cell flipflop8 (
    .d (net25),
    .clk (net1),
    .q (net26)
  );
  xor_cell xor1 (
    .a (net27),
    .b (net28),
    .out (net29)
  );
  xor_cell xor2 (
    .a (net23),
    .b (net26),
    .out (net28)
  );
  xor_cell xor3 (
    .a (net20),
    .b (net22),
    .out (net27)
  );
  dff_cell flipflop9 (
    .d (net30),
    .clk (net1),
    .q (net4)
  );
  dff_cell flipflop10 (
    .d (net31),
    .clk (net1),
    .q (net6)
  );
  dff_cell flipflop11 (
    .d (net32),
    .clk (net1),
    .q (net5)
  );
  dff_cell flipflop12 (
    .d (net33),
    .clk (net1),
    .q (net7)
  );
  dff_cell flipflop13 (
    .d (net34),
    .clk (net1),
    .q (net8)
  );
  dff_cell flipflop14 (
    .d (net35),
    .clk (net1),
    .q (net10)
  );
  dff_cell flipflop15 (
    .d (net36),
    .clk (net1),
    .q (net9)
  );
  dff_cell flipflop16 (
    .d (net37),
    .clk (net1),
    .q (net11)
  );
  mux_cell mux1 (
    .a (net14),
    .b (net29),
    .sel (net2),
    .out (net16)
  );
  mux_cell mux2 (
    .a (net17),
    .b (net4),
    .sel (net3),
    .out (net30)
  );
  mux_cell mux3 (
    .a (net18),
    .b (net5),
    .sel (net3),
    .out (net32)
  );
  mux_cell mux4 (
    .a (net19),
    .b (net6),
    .sel (net3),
    .out (net31)
  );
  mux_cell mux5 (
    .a (net20),
    .b (net7),
    .sel (net3),
    .out (net33)
  );
  mux_cell mux6 (
    .a (net22),
    .b (net8),
    .sel (net3),
    .out (net34)
  );
  mux_cell mux7 (
    .a (net23),
    .b (net9),
    .sel (net3),
    .out (net36)
  );
  mux_cell mux8 (
    .a (net24),
    .b (net10),
    .sel (net3),
    .out (net35)
  );
  mux_cell mux9 (
    .a (net26),
    .b (net11),
    .sel (net3),
    .out (net37)
  );
endmodule
