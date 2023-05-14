`default_nettype none


//A positive edge D flip flop with active low preset and reset inputs
module DFlipFlop
  (input  logic D, clock, 
   output logic Q);
  always_ff @(posedge clock)
      Q <= D;
endmodule: DFlipFlop


//A serial-in parallel-out shift register. Takes in a serial input and shifts
//it into the register if 'en' is asseted.
module ShiftRegister_SIPO
 #(parameter WIDTH = 8)
  (input  logic serial, en, clock, reset,
   output logic [WIDTH-1:0]Q);

  always_ff @(posedge clock, posedge reset)
    if (reset) Q <= {WIDTH {1'b0}};
    else if (en) Q <= {Q[WIDTH-2:0], serial};
    
endmodule: ShiftRegister_SIPO



