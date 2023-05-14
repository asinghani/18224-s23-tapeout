`default_nettype none

// Source:
// https://assets.chaos.social/media_attachments/files/110/026/931/020/246/360/original/2f1ade7ba8151455.png

module S444_Logic (
  output logic       lut0,
  output logic       lut1,
  output logic       lut2,
  input  logic [3:0] feed0,
  input  logic [3:0] feed1,
  input  logic [3:0] main,
  
  output logic shift_out,
  input  logic shift_in,
  input  logic clk,
  input  logic en,
  input  logic reset);

  logic        m0_sel, m1_sel, m2_sel;
  logic [15:0] l0_dat, l1_dat, l2_dat;
  logic        shift_m0, shift_m1, shift_m2, shift_l0, shift_l1, shift_l2;
  logic [3:0]  feed2;
  logic        feed1_3_real;

  ShiftLatch #(1) m0_reg(.Q(m0_sel),
                         .O(shift_m0), .I(shift_in),
                         .left(1'b1), .reset, .shift(en),
                         .en(1'b1), .clock(clk)),
                  m1_reg(.Q(m1_sel),
                         .O(shift_m1), .I(shift_m0),
                         .left(1'b1), .reset, .shift(en),
                         .en(1'b1), .clock(clk)),
                  m2_reg(.Q(m2_sel),
                         .O(shift_m2), .I(shift_m1),
                         .left(1'b1), .reset, .shift(en),
                         .en(1'b1), .clock(clk));

  assign feed2[3] = (m0_sel) ? main[3] : lut0;
  assign feed2[2] = (m1_sel) ? main[2] : lut1;
  assign feed1_3_real = (m2_sel) ? feed0[3] : feed1[3];

  ShiftLatch #(16) l0_reg(.Q(l0_dat),
                          .O(shift_l0), .I(shift_m2),
                          .left(1'b1), .reset, .shift(en),
                          .en(1'b1), .clock(clk)),
                   l1_reg(.Q(l1_dat),
                          .O(shift_l1), .I(shift_l0),
                          .left(1'b1), .reset, .shift(en),
                          .en(1'b1), .clock(clk)),
                   l2_reg(.Q(l2_dat),
                          .O(shift_l2), .I(shift_l1),
                          .left(1'b1), .reset, .shift(en),
                          .en(1'b1), .clock(clk));

  assign feed2[1:0] = main[1:0];
  assign shift_out = shift_l2;

  Lut #(4) l0(.O(lut0), .I(feed0), .D(l0_dat)),
           l1(.O(lut1), .I({feed1_3_real, feed1[2:0]}), .D(l1_dat)),
           l2(.O(lut2), .I(feed2), .D(l2_dat));

endmodule: S444_Logic

module LUT5_Mux (
  output logic feed0_out,
  input  logic lut0,
  input  logic lut1,
  input  logic feed1_3,
  
  output logic shift_out,
  input  logic shift_in,
  input  logic clk,
  input  logic en,
  input  logic reset);

  logic feed0_sel, lut5_sel;

  ShiftLatch #(1) lut5_reg(.Q(lut5_sel),
                           .O(shift_out), .I(shift_in),
                           .left(1'b1), .reset, .shift(en),
                           .en(1'b1), .clock(clk));

  assign feed0_sel = (lut5_sel) ? feed1_3 : 1'b0;
  assign feed0_out = (feed0_sel) ? lut1 : lut0;

endmodule: LUT5_Mux

module Carry_Logic (
  output logic sum_out,
  output logic c_out,
  input  logic prop,
  input  logic gen,
  input  logic c_in);

  assign c_out = (prop) ? c_in : gen;

  assign sum_out = c_in ^ prop;

endmodule: Carry_Logic

module D_Flip_Flops (
  output logic dff0_out,
  output logic dff1_out,
  input  logic feed0_out,
  input  logic feed1_out,
  input  logic main_out,
  input  logic feed0_0,
  input  logic feed1_0,
  input  logic sum_out,
  
  output logic shift_out,
  input  logic shift_in,
  input  logic clk,
  input  logic en,
  input  logic reset);

  logic [1:0] dff0_sel, dff1_sel;
  logic       dff0, dff1;

  ShiftLatch #(4) dff_reg(.Q({dff1_sel, dff0_sel}),
                          .O(shift_out), .I(shift_in),
                          .left(1'b1), .reset, .shift(en),
                          .en(1'b1), .clock(clk));

  Lut #(2) dff0_mux(.O(dff0),
                    .D({sum_out, feed0_0, main_out, feed0_out}),
                    .I(dff0_sel)),
           dff1_mux(.O(dff1),
                    .D({sum_out, feed1_0, main_out, feed1_out}),
                    .I(dff1_sel));

  Latch #(2) dff(.Q({dff1_out, dff0_out}), .D({dff1, dff0}),
                 .load(1'b1), .en(1'b1), .clear(reset), .clock(clk));

endmodule: D_Flip_Flops

module S444_Cell (
  output logic feed0_out,
  output logic feed1_out,
  output logic main_out,
  output logic dff0_out,
  output logic dff1_out,
  output logic sum_out,
  output logic c_out,

  input  logic [3:0] feed0,
  input  logic [3:0] feed1,
  input  logic [3:0] main,
  input  logic       c_in,
  
  output logic shift_out,
  input  logic shift_in,
  input  logic clk,
  input  logic en,
  input  logic reset);

  logic lut0, lut1, lut2;
  logic shift0, shift1;

  S444_Logic s444_logic(.lut0, .lut1, .lut2,
             .feed0, .feed1, .main,
             .shift_out(shift0), .shift_in, .clk, .en, .reset);

  LUT5_Mux lut5_mux(.feed0_out, .lut0, .lut1, .feed1_3(feed1[3]),
           .shift_out(shift1), .shift_in(shift0), .clk, .en, .reset);

  Carry_Logic carry_logic(.sum_out, .c_out, .prop(lut1), .gen(lut2), .c_in);

  D_Flip_Flops d_flip_flops(.dff0_out, .dff1_out,
               .feed0_out, .feed1_out,
               .feed0_0(feed0[0]), .feed1_0(feed1[0]),
               .sum_out,
               .shift_out, .shift_in(shift1), .clk, .en, .reset);

  assign feed1_out = lut1;
  assign main_out = lut2;

endmodule: S444_Cell
