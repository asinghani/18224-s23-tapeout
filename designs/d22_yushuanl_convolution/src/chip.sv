//Shift Register
module shiftReg
  (input logic [5:0] In, 
   input logic en, load, clk,
   output logic [5:0] Shifted);
  always_ff @(posedge clk)
    if (load)
      Shifted <= In;
    else if (en)
      Shifted <= {1'b0, Shifted[5:1]};
endmodule

//Multiplier
module Multiplier
  (input logic First, Second,
   output logic Out);
  assign Out = First & Second;
endmodule

//Adder
module Adder
  (input logic First,
   input logic [3:0] Second,
   output logic [3:0] Out);
  assign Out = {3'b0, First} + Second;
endmodule

//Mux
module Mux
  (input logic [3:0] A, B,
   input logic sel,
   output logic [3:0] Out);
  assign Out = (sel) ? A: B;
endmodule

//Register
module Reg
  (input logic [3:0] In,
   input logic clk, en,
   output logic [3:0] Out);
  always_ff @(posedge clk)
    if (en)
      Out <= In;
endmodule

//Convolutor
module my_chip
  (input logic [11:0] io_in,
   input clock, reset,
   output logic [3:0] io_out);
  //RTL
  logic en, load, enRT, enRO;
  logic [5:0] Shifted_A, Shifted_B;
  logic newTerm;
  logic sel;
  logic [3:0] inReg, oldSum, choice;
  shiftReg shiftA(.In(io_in[5:0]), .en, .load, 
                  .clk(clock), .Shifted(Shifted_A));
  shiftReg shiftB(.In(io_in[11:6]), .en, .load, 
                  .clk(clock), .Shifted(Shifted_B));
  Multiplier mul(.First(Shifted_A[0]), 
                 .Second(Shifted_B[0]), 
                 .Out(newTerm));
  Mux mux(.A(oldSum), .B(4'b0), .sel, .Out(choice));
  Adder add(.First(newTerm), .Second(choice), .Out(inReg));
  Reg registerTemp(.In(inReg), .clk(clock), .en(enRT), .Out(oldSum));
  Reg registerOut(.In(oldSum), .clk(clock), .en(enRO), .Out(io_out));
  //FSM Output
  enum logic [2:0] {Start = 3'b000, Wait = 3'b001,
                   Shift1 = 3'b010, Shift2 = 3'b011,
                   Shift3 = 3'b100, Shift4 = 3'b101,
                   Shift5 = 3'b110, End = 3'b111} 
                   curState, nextState;
  always_comb begin
    case (curState)
      Start: begin
        load = 1;
        en = 0;
        sel = 0;
        enRT = 1;
        enRO = 0;
      end
      Wait: begin
        load = 0;
        en = 1;
        sel = 1;
        enRT = 0;
        enRO = 0;
      end
      Shift1: begin
        load = 0;
        en = 1;
        sel = 1;
        enRT = 1;
        enRO = 0;
      end
      Shift2: begin
        load = 0;
        en = 1;
        sel = 1;
        enRT = 1;
        enRO = 0;
      end
      Shift3: begin
        load = 0;
        en = 1;
        sel = 1;
        enRT = 1;
        enRO = 0;
      end
      Shift4: begin
        load = 0;
        en = 1;
        sel = 1;
        enRT = 1;
        enRO = 0;
      end
      Shift5: begin
        load = 0;
        en = 1;
        sel = 1;
        enRT = 1;
        enRO = 0;
      end
      End: begin
        load = 0;
        en = 0;
        sel = 0;
        enRT = 0;
        enRO = 1;
      end
      default: begin
        load = 1;
        en = 0;
        sel = 0;
        enRT = 1;
        enRO = 0;
      end
    endcase
  end
  //FSM Transfer
  always_comb begin
    case (curState)
      Start: nextState = Wait;
      Wait: nextState = Shift1;
      Shift1: nextState = Shift2;
      Shift2: nextState = Shift3;
      Shift3: nextState = Shift4;
      Shift4: nextState = Shift5;
      Shift5: nextState = End;
      End: nextState = End;
      default: nextState = Start;
    endcase
  end
  always_ff @(posedge clock, posedge reset)
    if (reset)
      curState <= Start;
    else
      curState <= nextState;
endmodule