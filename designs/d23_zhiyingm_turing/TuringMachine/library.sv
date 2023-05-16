`default_nettype none

module Demux1to4 // choose 1 from 4 outputs to get the input
 #(parameter w = 8)
  (input  logic [w-1:0] I, 
   input  logic [1:0] S,
   output logic [w-1:0] Y0, Y1, Y2, Y3);

  always_comb begin
    Y0 = w'('b0); Y1 = w'('b0); Y2 = w'('b0); Y3 = w'('b0);
    case (S)
      2'b00: Y0 = I;
      2'b01: Y1 = I;
      2'b10: Y2 = I;
      2'b11: Y3 = I;
    endcase
  end

endmodule: Demux1to4


module Mux2to1 // choose 1 from 2 inputs
 #(parameter w = 7)
  (input  logic [w-1:0] I0, I1, 
   input  logic S,
   output logic [w-1:0] Y);

  assign Y = S ? I1 : I0;

endmodule: Mux2to1


module Mux4to1 // choose 1 from 4 inputs
 #(parameter w = 7)
  (input  logic [w-1:0] I0, I1, I2, I3,
   input  logic [1:0] S,
   output logic [w-1:0] Y);

  always_comb  begin
    if (S[1]) Y = S[0] ? I3 : I2;
    else Y = S[0] ? I1 : I0;
  end

endmodule: Mux4to1


module DFlipFlop // stores 1 bit value
  (input  logic D,
   input  logic clock, reset_L, preset_L,
   output logic Q);

  always_ff @(posedge clock) begin
    // asynchronous reset and preset, active low
    if (~reset_L)
      Q <= 1'b0;
    else if (~preset_L)
      Q <= 1'b1;
    else
      Q <= D;
  end

endmodule: DFlipFlop


module Register // stores the value D
 #(parameter w = 8)
  (input  logic en, clear, clock,
   input  logic [w-1:0] D,
   output logic [w-1:0] Q);

  always_ff @(posedge clock) begin // synchronous clear, active high
    if (en)
      Q <= D;
    else if (clear)
      Q <= w'('b0);
  end

endmodule: Register


/* enable counting, clearning, loading a value from the D inputs and
   determine the direction of count (up or down) */
module Counter
 #(parameter w = 8)
  (input  logic en, clear, load, up, clock,
   input  logic [w-1:0] D,
   output logic [w-1:0] Q);

  always_ff @(posedge clock) begin // synchronous clear, active high
    if (clear)
      Q <= w'('b0);
    else if (load)
      Q <= D;
    else if (en && up)
      Q <= Q + 1'b1;
    else if (en && (!up))
      Q <= Q - 1'b1;
  end

endmodule: Counter


module Synchronizer // protects FSM / HW from asynchronous input signal
  (input  logic async, clock,
   output logic sync);

  logic async1;
  // synchronize input through DFF twice
  always_ff @(posedge clock)
    async1 <= async;
  
  always_ff @(posedge clock)
    sync <= async1;

endmodule: Synchronizer


module ShiftRegister_SIPO_wRewrite
 #(parameter w = 8)
  (input  logic en, clear, serial, left, rewrite, clock,
   output logic [w-1:0] Q);

  always_ff @(posedge clock) begin
    if (clear)
      Q <= w'('b0);
    else if (rewrite)
      Q <= {Q[w-1:1], ~Q[0]};
    else if (en && left)
      Q <= {Q[w-2:0], serial};
    else if (en && (~left))
      Q <= {serial, Q[w-1:1]};
  end

endmodule: ShiftRegister_SIPO_wRewrite


module Memory_synth // stores a number of words, conbinational read, sequential write
 #(parameter dw = 8, // size of each word
             w = 16, // number of words
             aw = $clog2(w)) // address width
  (input logic re, we, clock,
   input logic [aw-1:0] addr,
   input logic [dw-1:0] data_in,
   output logic [dw-1:0] data_out);
  
  logic [dw-1:0] M[w];

  assign data_out = (re) ? M[addr] : 'b0; // put the read data on the bus

  always_ff @(posedge clock) begin
    if (we)
      M[addr] <= data_in; // synchronized write
  end

endmodule: Memory_synth
