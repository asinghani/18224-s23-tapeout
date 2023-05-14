`default_nettype none

module Lut
#(parameter WIDTH = 3)
(
  output logic                      O,
  input  logic [WIDTH-1:0]          I,
  input  logic [WIDTH*WIDTH-1:0] D);

  assign O = D[I];

endmodule: Lut

module Latch
#(parameter WIDTH = 8)
(
  output logic [WIDTH-1:0] Q,
  input  logic [WIDTH-1:0] D,
  input  logic             load, en, clear, clock
);

  always_ff @(posedge clock)
    if (en)
      if (clear)
        Q <= 0;
      else if (load)
        Q <= D;
      else
        Q <= Q;

endmodule: Latch

module ShiftLatch
#(parameter WIDTH = 8)
(
  output logic [WIDTH-1:0] Q,
  output logic             O,
  input  logic             I,
  input  logic             left, shift,
  input  logic             reset, en, clock
);

  logic [WIDTH-1:0] shiftedLeft, shiftedRight, shiftResult;
  logic             lowBit, highBit;

  assign shiftedLeft = (Q << 1) | I;
  assign shiftedRight = (Q >> 1) | ({I, {WIDTH-1{1'b0}}});
  assign lowBit = Q[0];
  assign highBit = Q[WIDTH-1];

  assign shiftResult = (left) ? shiftedLeft : shiftedRight;
  assign O = (left) ? highBit : lowBit;

  Latch #(WIDTH) myLatch(.Q, .D(shiftResult),
                         .load(shift), .en, .clear(reset), .clock);

endmodule: ShiftLatch
