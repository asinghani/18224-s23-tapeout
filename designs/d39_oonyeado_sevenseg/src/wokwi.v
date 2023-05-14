/* Automatically generated from https://wokwi.com/projects/350866594173289042 */

`default_nettype none

module user_module_350866594173289042(
  input [7:0] io_in,
  output [7:0] io_out
);
  wire net1 = io_in[4];
  wire net2 = io_in[5];
  wire net3 = io_in[6];
  wire net4 = io_in[7];
  wire net5;
  wire net6;
  wire net7;
  wire net8;
  wire net9;
  wire net10;
  wire net11;
  wire net12 = 1'b1;
  wire net13;
  wire net14;
  wire net15;
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
  wire net53;
  wire net54;
  wire net55;
  wire net56;
  wire net57;
  wire net58;
  wire net59;
  wire net60;
  wire net61;
  wire net62;
  wire net63;
  wire net64;
  wire net65;
  wire net66;
  wire net67;
  wire net68;
  wire net69;
  wire net70;
  wire net71;
  wire net72;
  wire net73;
  wire net74;
  wire net75;
  wire net76;
  wire net77;
  wire net78;
  wire net79;
  wire net80;
  wire net81;
  wire net82;
  wire net83;
  wire net84 = 1'b0;

  assign io_out[1] = net5;
  assign io_out[2] = net6;
  assign io_out[3] = net7;
  assign io_out[4] = net8;
  assign io_out[5] = net9;
  assign io_out[6] = net10;
  assign io_out[7] = net11;

  and_cell gate1 (
    .a (net13),
    .b (net3),
    .out (net14)
  );
  or_cell gate2 (
    .a (net15),
    .b (net16),
    .out (net17)
  );
  not_cell gate5 (
    .in (net4),
    .out (net13)
  );
  not_cell gate7 (
    .in (net3),
    .out (net18)
  );
  not_cell gate8 (
    .in (net2),
    .out (net19)
  );
  not_cell gate9 (
    .in (net1),
    .out (net20)
  );
  or_cell gate10 (
    .a (net21),
    .b (net22),
    .out (net23)
  );
  or_cell gate11 (
    .a (net17),
    .b (net23),
    .out (net8)
  );
  or_cell gate12 (
    .a (net24),
    .b (net25),
    .out (net22)
  );
  or_cell gate13 (
    .a (net26),
    .b (net27),
    .out (net28)
  );
  or_cell gate14 (
    .a (net29),
    .b (net30),
    .out (net31)
  );
  or_cell gate15 (
    .a (net28),
    .b (net31),
    .out (net10)
  );
  or_cell gate16 (
    .a (net32),
    .b (net33),
    .out (net30)
  );
  or_cell gate17 (
    .a (net34),
    .b (net35),
    .out (net36)
  );
  or_cell gate18 (
    .a (net37),
    .b (net38),
    .out (net39)
  );
  or_cell gate19 (
    .a (net36),
    .b (net39),
    .out (net9)
  );
  or_cell gate20 (
    .a (net40),
    .b (net41),
    .out (net42)
  );
  or_cell gate21 (
    .a (net43),
    .b (net44),
    .out (net45)
  );
  or_cell gate22 (
    .a (net42),
    .b (net45),
    .out (net11)
  );
  or_cell gate23 (
    .a (net46),
    .b (net47),
    .out (net44)
  );
  or_cell gate24 (
    .a (net48),
    .b (net49),
    .out (net50)
  );
  or_cell gate25 (
    .a (net51),
    .b (net52),
    .out (net53)
  );
  or_cell gate26 (
    .a (net50),
    .b (net53),
    .out (net6)
  );
  or_cell gate27 (
    .a (net54),
    .b (net55),
    .out (net52)
  );
  or_cell gate28 (
    .a (net56),
    .b (net57),
    .out (net58)
  );
  or_cell gate29 (
    .a (net59),
    .b (net60),
    .out (net61)
  );
  or_cell gate30 (
    .a (net58),
    .b (net61),
    .out (net7)
  );
  or_cell gate31 (
    .a (net62),
    .b (net63),
    .out (net60)
  );
  or_cell gate3 (
    .a (net64),
    .b (net65),
    .out (net66)
  );
  or_cell gate6 (
    .a (net67),
    .b (net68),
    .out (net69)
  );
  or_cell gate32 (
    .a (net66),
    .b (net69),
    .out (net5)
  );
  or_cell gate33 (
    .a (net70),
    .b (net71),
    .out (net68)
  );
  or_cell gate34 (
    .a (net72),
    .b (net73),
    .out (net64)
  );
  and_cell gate4 (
    .a (net14),
    .b (net19),
    .out (net40)
  );
  and_cell gate35 (
    .a (net20),
    .b (net18),
    .out (net74)
  );
  and_cell gate36 (
    .a (net74),
    .b (net13),
    .out (net15)
  );
  and_cell gate37 (
    .a (net1),
    .b (net2),
    .out (net75)
  );
  and_cell gate38 (
    .a (net75),
    .b (net18),
    .out (net16)
  );
  and_cell gate39 (
    .a (net3),
    .b (net19),
    .out (net76)
  );
  and_cell gate40 (
    .a (net76),
    .b (net1),
    .out (net21)
  );
  and_cell gate41 (
    .a (net3),
    .b (net2),
    .out (net77)
  );
  and_cell gate42 (
    .a (net77),
    .b (net20),
    .out (net24)
  );
  and_cell gate43 (
    .a (net13),
    .b (net3),
    .out (net78)
  );
  and_cell gate44 (
    .a (net78),
    .b (net19),
    .out (net26)
  );
  and_cell gate45 (
    .a (net4),
    .b (net19),
    .out (net79)
  );
  and_cell gate46 (
    .a (net79),
    .b (net1),
    .out (net51)
  );
  and_cell gate47 (
    .a (net13),
    .b (net2),
    .out (net80)
  );
  and_cell gate48 (
    .a (net80),
    .b (net1),
    .out (net49)
  );
  and_cell gate49 (
    .a (net13),
    .b (net3),
    .out (net81)
  );
  and_cell gate50 (
    .a (net81),
    .b (net1),
    .out (net73)
  );
  and_cell gate51 (
    .a (net13),
    .b (net19),
    .out (net82)
  );
  and_cell gate52 (
    .a (net82),
    .b (net20),
    .out (net48)
  );
  and_cell gate53 (
    .a (net4),
    .b (net18),
    .out (net83)
  );
  and_cell gate54 (
    .a (net83),
    .b (net19),
    .out (net72)
  );
  and_cell gate57 (
    .a (net18),
    .b (net20),
    .out (net65)
  );
  and_cell gate58 (
    .a (net13),
    .b (net2),
    .out (net67)
  );
  and_cell gate59 (
    .a (net4),
    .b (net20),
    .out (net70)
  );
  and_cell gate60 (
    .a (net3),
    .b (net2),
    .out (net71)
  );
  and_cell gate61 (
    .a (net18),
    .b (net19),
    .out (net54)
  );
  and_cell gate62 (
    .a (net18),
    .b (net20),
    .out (net55)
  );
  and_cell gate63 (
    .a (net13),
    .b (net19),
    .out (net56)
  );
  and_cell gate64 (
    .a (net13),
    .b (net1),
    .out (net57)
  );
  and_cell gate65 (
    .a (net19),
    .b (net1),
    .out (net59)
  );
  and_cell gate66 (
    .a (net13),
    .b (net3),
    .out (net62)
  );
  and_cell gate67 (
    .a (net4),
    .b (net18),
    .out (net63)
  );
  and_cell gate69 (
    .a (net4),
    .b (net19),
    .out (net25)
  );
  and_cell gate55 (
    .a (net4),
    .b (net2),
    .out (net34)
  );
  and_cell gate56 (
    .a (net4),
    .b (net3),
    .out (net35)
  );
  and_cell gate68 (
    .a (net2),
    .b (net20),
    .out (net37)
  );
  and_cell gate70 (
    .a (net18),
    .b (net20),
    .out (net38)
  );
  and_cell gate71 (
    .a (net19),
    .b (net20),
    .out (net27)
  );
  and_cell gate72 (
    .a (net3),
    .b (net20),
    .out (net29)
  );
  and_cell gate73 (
    .a (net4),
    .b (net18),
    .out (net32)
  );
  and_cell gate74 (
    .a (net4),
    .b (net2),
    .out (net33)
  );
  and_cell gate75 (
    .a (net4),
    .b (net18),
    .out (net41)
  );
  and_cell gate76 (
    .a (net4),
    .b (net1),
    .out (net43)
  );
  and_cell gate77 (
    .a (net18),
    .b (net2),
    .out (net46)
  );
  and_cell gate78 (
    .a (net2),
    .b (net20),
    .out (net47)
  );
endmodule
