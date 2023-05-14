/* Automatically generated from https://wokwi.com/projects/364739787222127617 */

`default_nettype none

module user_module_364739787222127617(
  input [7:0] io_in,
  output [7:0] io_out
);
  wire net1;
  wire net2;
  wire net3;
  wire net4;
  wire net5 = io_in[0];
  wire net6 = io_in[1];
  wire net7 = io_in[2];
  wire net8 = io_in[3];
  wire net9 = io_in[4];
  wire net10 = io_in[5];
  wire net11 = 1'b0;
  wire net12 = 1'b1;
  wire net13;
  wire net14 = 1'b0;
  wire net15;
  wire net16;
  wire net17;
  wire net18;
  wire net19;
  wire net20;
  wire net21;
  wire net22 = 1'b0;

  assign io_out[0] = net1;
  assign io_out[1] = net2;
  assign io_out[2] = net3;
  assign io_out[3] = net4;

  xor_cell gate7 (
    .a (net6),
    .b (net9),
    .out (net13)
  );
  xor_cell gate8 (
    .a (net13),
    .b (net15),
    .out (net2)
  );
  and_cell gate9 (
    .a (net13),
    .b (net15),
    .out (net16)
  );
  and_cell gate10 (
    .a (net6),
    .b (net9),
    .out (net17)
  );
  or_cell gate11 (
    .a (net16),
    .b (net17),
    .out (net18)
  );
  xor_cell gate12 (
    .a (net7),
    .b (net10),
    .out (net19)
  );
  xor_cell gate13 (
    .a (net19),
    .b (net18),
    .out (net3)
  );
  and_cell gate14 (
    .a (net19),
    .b (net18),
    .out (net20)
  );
  and_cell gate15 (
    .a (net7),
    .b (net10),
    .out (net21)
  );
  or_cell gate16 (
    .a (net20),
    .b (net21),
    .out (net4)
  );
  and_cell gate17 (
    .a (net5),
    .b (net8),
    .out (net15)
  );
  xor_cell gate18 (
    .a (net5),
    .b (net8),
    .out (net1)
  );
endmodule
