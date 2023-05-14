/* Automatically generated from https://wokwi.com/projects/350155397606146642 */

`default_nettype none

module user_module_350155397606146642(
  input [7:0] io_in,
  output [7:0] io_out
);
  wire net1 = io_in[0];
  wire net2 = io_in[1];
  wire net3 = io_in[2];
  wire net4 = io_in[3];
  wire net5 = io_in[4];
  wire net6 = io_in[5];
  wire net7 = io_in[6];
  wire net8 = io_in[7];
  wire net9;
  wire net10;
  wire net11;
  wire net12;
  wire net13 = 1'b1;
  wire net14 = 1'b0;
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
  wire net38;
  wire net39;
  wire net40;
  wire net41;
  wire net42;
  wire net43;
  wire net44;
  wire net45;
  wire net46;
  wire net47;
  wire net48;
  wire net49;
  wire net50;
  wire net51;
  wire net52;

  assign io_out[0] = net9;
  assign io_out[1] = net10;
  assign io_out[2] = net11;
  assign io_out[3] = net12;
  assign io_out[4] = net11;
  assign io_out[5] = net11;
  assign io_out[6] = net13;

  not_cell not1 (
    .in (net1),
    .out (net16)
  );
  not_cell not2 (
    .in (net5),
    .out (net17)
  );
  and_cell and1 (
    .a (net16),
    .b (net5),
    .out (net18)
  );
  and_cell and2 (
    .a (net1),
    .b (net17),
    .out (net19)
  );
  or_cell or1 (
    .a (net18),
    .b (net19),
    .out (net20)
  );
  not_cell not3 (
    .in (net20),
    .out (net21)
  );
  not_cell not4 (
    .in (net2),
    .out (net22)
  );
  not_cell not5 (
    .in (net6),
    .out (net23)
  );
  and_cell and3 (
    .a (net22),
    .b (net6),
    .out (net24)
  );
  and_cell and4 (
    .a (net2),
    .b (net23),
    .out (net25)
  );
  or_cell or2 (
    .a (net24),
    .b (net25),
    .out (net26)
  );
  not_cell not6 (
    .in (net26),
    .out (net27)
  );
  not_cell not7 (
    .in (net3),
    .out (net28)
  );
  not_cell not8 (
    .in (net7),
    .out (net29)
  );
  and_cell and5 (
    .a (net28),
    .b (net7),
    .out (net30)
  );
  and_cell and6 (
    .a (net3),
    .b (net29),
    .out (net31)
  );
  or_cell or3 (
    .a (net30),
    .b (net31),
    .out (net32)
  );
  not_cell not9 (
    .in (net32),
    .out (net33)
  );
  not_cell not10 (
    .in (net4),
    .out (net34)
  );
  not_cell not11 (
    .in (net8),
    .out (net35)
  );
  and_cell and7 (
    .a (net34),
    .b (net8),
    .out (net36)
  );
  and_cell and8 (
    .a (net4),
    .b (net35),
    .out (net37)
  );
  or_cell or4 (
    .a (net36),
    .b (net37),
    .out (net38)
  );
  not_cell not12 (
    .in (net38),
    .out (net39)
  );
  and_cell and9 (
    .a (net21),
    .b (net27),
    .out (net40)
  );
  and_cell and10 (
    .a (net21),
    .b (net24),
    .out (net41)
  );
  and_cell and11 (
    .a (net21),
    .b (net25),
    .out (net42)
  );
  and_cell and12 (
    .a (net40),
    .b (net33),
    .out (net43)
  );
  and_cell and13 (
    .a (net43),
    .b (net39),
    .out (net44)
  );
  and_cell and14 (
    .a (net43),
    .b (net36),
    .out (net45)
  );
  and_cell and15 (
    .a (net40),
    .b (net31),
    .out (net46)
  );
  and_cell and16 (
    .a (net40),
    .b (net30),
    .out (net47)
  );
  and_cell and17 (
    .a (net43),
    .b (net37),
    .out (net48)
  );
  or_cell or5 (
    .a (net18),
    .b (net41),
    .out (net49)
  );
  or_cell or6 (
    .a (net47),
    .b (net45),
    .out (net50)
  );
  or_cell or7 (
    .a (net49),
    .b (net50),
    .out (net12)
  );
  or_cell or8 (
    .a (net19),
    .b (net42),
    .out (net51)
  );
  or_cell or9 (
    .a (net46),
    .b (net48),
    .out (net52)
  );
  or_cell or10 (
    .a (net51),
    .b (net52),
    .out (net10)
  );
  or_cell or11 (
    .a (net10),
    .b (net44),
    .out (net9)
  );
  or_cell or12 (
    .a (net12),
    .b (net10),
    .out (net11)
  );
endmodule
