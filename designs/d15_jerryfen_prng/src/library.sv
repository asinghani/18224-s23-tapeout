`default_nettype none

// a decoder with an enable line that converts a b bit number into 
// activating only one line of the 2^b outputs
module Decoder
#(parameter WIDTH = 8)
  (input logic en,
   input logic [$clog2(WIDTH)-1:0] I, 
   output logic [WIDTH-1:0] D);

      always_comb 
        if(en == 1'b0) begin
            D = 8'd0;
        end
        else begin
            case (I)
                3'b000 : D = 8'b00000001; 
                3'b001 : D = 8'b00000010; 
                3'b010 : D = 8'b00000100; 
                3'b011 : D = 8'b00001000; 
                3'b100 : D = 8'b00010000; 
                3'b101 : D = 8'b00100000; 
                3'b110 : D = 8'b01000000; 
                3'b111 : D = 8'b10000000; 
            endcase
        end
        
endmodule : Decoder

// BarrelShifter takes in a b bit number to be shifted, 
// and a clog2(b) bit number
// as input to indicate how much to shift the b bit number left by
module BarrelShifter
#(parameter WIDTH = 16)
  (input logic [WIDTH-1:0] V,
   input logic [$clog2(WIDTH)-1:0] by,
   output logic [WIDTH-1:0] S);

  assign S = (V << by);

endmodule: BarrelShifter

// multiplexer takes in an b bit number and a 
// clog2(b) bit "select" number as input
// and uses the clog2(b) bit number to select the corresponding 
// position's bit in the b bit number as output.
module Multiplexer
#(parameter WIDTH = 8)
  (input logic [WIDTH-1:0] I,
   input logic [$clog2(WIDTH)-1:0] S,
   output logic Y);

   assign Y = I[S];

endmodule: Multiplexer

// takes in two b bit numbers and a 1 bit select number,
// depending on if the select number is 1 or 0,
// one of the two b bit numbers is "selected" as the output.
module Mux2to1
#(parameter WIDTH = 8)
  (input logic [WIDTH-1:0] I0,
   input logic [WIDTH-1:0] I1,
   input logic S,
   output logic [WIDTH-1:0] Y);

   always_comb
     case(S)
        1'b0 : Y = I0; 
        1'b1 : Y = I1;
     endcase

endmodule: Mux2to1

// MagComparator takes in two same width numbers, A and B,
// and outputs a 1 or 0 to AeqB, AltB, or AgtB
// if A == B, A < B, or A > B, respectively
module MagComp
#(parameter WIDTH = 8)
  (input logic [WIDTH-1:0] A, 
   input logic [WIDTH-1:0] B,
   output logic AeqB, AltB, AgtB);

  assign AeqB = (A == B);
  assign AltB = (A < B);
  assign AgtB = (A > B);

endmodule: MagComp

// Comparator takes two same width numbers, A and B as input
// and outputs 1 if they are equal, and 0 otherwise
module Comparator
#(parameter WIDTH = 4)
  (input logic [WIDTH-1:0] A, B,
   output logic AeqB);
  
  assign AeqB = (A == B);

endmodule: Comparator

// Adds two same width numbers and outputs the sum 
// and 6th bit carryout 
// if a carryout is produced
module Adder
#(parameter WIDTH = 5)
  (input logic cin,
   input logic [WIDTH-1:0] A, B,
   output logic cout,
   output logic [WIDTH-1:0] sum);

  always_comb begin
    {cout, sum} = A + B + cin;
  end

endmodule: Adder

// DFlipFlop propagates the D input value to the output
// on a rising edge of a clock
// active low preset sets output to 1
// and active low reset sets output to 0
module DFlipFlop
  (input logic D, preset_L, reset_L, clock,
   output logic Q);

   always_ff @(posedge clock, negedge reset_L) begin
     
     if(~preset_L)
       Q <= 1;
     else if(~reset_L)
       Q <= 0;
     else
       Q <= D;
   end

endmodule: DFlipFlop

// Register loads in value on input
// and stores it on the output Q on a
// rising clock edge 
// clear sets output Q to 0 synchronously 
module Register
#(parameter WIDTH = 8)
  (input logic en, clear, clock,
   input logic [WIDTH-1:0] D,
   output logic [WIDTH-1:0] Q);

   always_ff @(posedge clock)
   
     if(en) begin
       Q <= D;
     end
     else if(clear) begin
       Q <= {WIDTH {1'b0}};
     end

endmodule: Register

// width_FlipFlop loads in value on input
// and stores it on the output Q on a
// rising clock edge 
// clear sets output Q to 0 synchronously 
module width_FlipFlop
#(parameter WIDTH = 8)
  (input logic preset_L, reset_L, clock,
   input logic [WIDTH-1:0] D,
   output logic [WIDTH-1:0] Q);

   always_ff @(posedge clock, negedge reset_L) begin
     
     if(~preset_L)
       Q <= 8'b1;
     else if(~reset_L)
       Q <= 8'b0;
     else
       Q <= D;
   end
     

endmodule: width_FlipFlop

// Counter is a register that 
// when enabled adds 1 or subtracts one
// from the value loaded in on the D input
// and outputs the result to output Q
// if load is enabled you just load the value
// clear synchronously sets Q to 0
module Counter
#(parameter WIDTH = 8)
  (input logic              en, 
   input logic              clear, 
   input logic              load, 
   input logic              up, 
   input logic              clock,
   input logic  [WIDTH-1:0] D,
   output logic [WIDTH-1:0] Q);
   
   logic iterator;
  always_ff @(posedge clock, posedge clear)
     if (clear) begin
       Q <= {WIDTH {1'b0}};
     end
     else if(load) begin
       Q <= D;
     end
     else if(en & ~load) begin
       iterator = up ? 1 : -1;
       Q <= Q + iterator; 
     end

endmodule: Counter

// synchronizer takes in an
// asynchronous signal as input
// and synchronizes it to the clock signal
// on output
module Synchronizer
#(parameter WIDTH = 8)
 (input logic async, clock,
  output logic sync);
  
  logic intermediate;

  always_ff @(posedge clock) begin

    intermediate <= async;
    sync <= intermediate;
  end
  

endmodule: Synchronizer

// ShiftRegister_PIPO is a PIPO register that 
// shifts left or right if the
// left control input is 1 or 0 respectively 
// and it only shifts when enabled and load is not active.
// load loads in the D value and propogates it to the Q
// value without shifting
module ShiftRegister_PIPO
#(parameter WIDTH = 8)
  (input  logic [WIDTH-1:0] D,
   input  logic         en,
   input  logic         left,
   input  logic         load,
   input  logic         clock,
   output logic [WIDTH-1:0] Q);
   
   always_ff @(posedge clock)
     if (~en & load) begin
       Q <= D;
     end
     else if (en & ~load & left) begin
       Q <= Q << 1;
     end
     else if (en & ~load & ~left) begin
       Q <= Q >> 1;
     end

endmodule: ShiftRegister_PIPO

// ShiftRegister_SIPO is a SIPO register that shifts either left or right
// It will consume the bit on the serial input and place it in either
// the MSB or LSB position of the output depending on the shift direction
// When not enabled, nothing will change.
module ShiftRegister_SIPO
#(parameter WIDTH = 8)
  (input  logic [WIDTH-1:0] D,
   input  logic         serial,
   input  logic         en,
   input  logic         left,
   input  logic         clock,
   output logic [WIDTH-1:0] Q);
   
   
   always_ff @(posedge clock)
     if (~en) begin
       Q <= D;
     end
     else if (en & left) begin
       Q <= Q << 1;
       Q[0] <= serial;
     end
     else if (en & ~left) begin
       Q <= Q >> 1;
       Q[WIDTH-1] <= serial;
     end

endmodule: ShiftRegister_SIPO

// BarrelShiftRegister is a PIPO register that shifts left.
// It shifts left either 0, 1, 2 or 3
// positions based on the 2-bit by input when enabled
// Load has priority over shifting.
module BarrelShiftRegister
#(parameter WIDTH = 8)
  (input  logic             en,
   input  logic             load,
   input  logic [$clog2(WIDTH)-1:0]       by,
   input  logic [WIDTH-1:0] D,
   input  logic             clock,
   output logic [WIDTH-1:0] Q);
   
   always_ff @(posedge clock)
     if (~en & load) begin
       Q <= D;
     end
     else if (en & ~load) begin
       Q <= D << by;
     end

endmodule: BarrelShiftRegister

// When BusDriver enabled, whatever value
// of data will be driven onto the bus, 
// otherwise the bus driver will not drive anything
// code from lecture 7
module BusDriver
#(parameter WIDTH = 8)
 (input logic             en,
  input logic [WIDTH-1:0] data,
  output logic [WIDTH-1:0] buff,
  inout tri   [WIDTH-1:0] bus);

  assign buff =  bus;
  assign bus = (en) ? data : 'bz;

endmodule: BusDriver

// Memory is a memory module which stores a number of words. 
// It is combinational read and sequential write
// and has read and write enable inputs
// code adapted from lecture 14
module Memory 
 #(parameter DW = 16,  
             W  = 256, 
             AW = $clog2(W)) 
  (input logic re, we, clock, 
   input logic [AW-1:0] addr, 
   inout tri   [DW-1:0] data); 

   logic [DW-1:0] M[W]; 
   logic [DW-1:0] rData; 
   assign data = (re) ? rData: 'bz; 
   always_ff @(posedge clock) 
     if (we)  
       M[addr] <= data; 
   always_comb 
     rData = M[addr]; 

endmodule: Memory


module count
#(parameter WIDTH = 8)
  (input logic              clock, 
   input logic              reset,
   output logic [WIDTH-1:0] out);
   
   logic iterator;
   always_ff @(posedge clock) begin
     
    if (reset) begin
      out <= 0;
    end
    else begin
      out <= out + 1;
    end
  end

endmodule: count
