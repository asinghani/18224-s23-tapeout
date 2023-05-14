`default_nettype none

module Counter
  #(parameter WIDTH = 8)
  (input  logic [WIDTH - 1:0] D,
   input  logic               clear, load, clock, en,
   output logic [WIDTH - 1:0] Q);

  always_ff @(posedge clock)
    if(clear)
      Q <= 8'b0;
    else if(load)
      Q <= D;
    else if (en)
      Q <= Q + 1'b1;
    else 
      Q <= Q;

endmodule: Counter

module MagComp
  #(parameter WIDTH = 8)
  (input  logic [WIDTH - 1:0] A, B,
   output logic               AgtB, AeqB, AltB);

  assign AeqB = (A == B);
  assign AgtB = (A > B);
  assign AltB = (A < B);

endmodule: MagComp

module Register
  #(parameter WIDTH = 1)
  (input logic button, ped_clr, clock,
   output logic ped);
  
  always_ff @(posedge clock)
    if(button)
      ped <= 1'b1;
    else if (ped_clr)
      ped <= 1'b0;
    else 
      ped <= ped;

endmodule: Register

module FSM
  (input  logic clock, reset, 
                car1, car2, car3, car4, ped, 
                stop_yellow, stop_ped, stop_five,
   output logic red1, yellow1, green1, 
                red2, yellow2, green2,
                red3, yellow3, green3,
                turn, orange, white, 
                yellow_en, 
                yellow_clr, 
                stop_en,
                stop_clr, 
                five_en,
                five_clr, 
                ped_clr);
  
  enum logic [3:0] {INIT, CAR1, CAR2, CAR3_4, PED, 
                    YELLOW1, YELLOW2, YELLOW3, DELAY} state, nextState;
  
  always_ff @(posedge clock)
    if (reset)
      state <= INIT;
    else
      state <= nextState;
  
  //default if no one waiting at yellow is PED
  //next state logic
  always_comb begin
    unique case (state)
      INIT: if (car1) nextState = CAR1;
            else if (car2) nextState = CAR2;
            else if (car3 | car4) nextState = CAR3_4;
            else if (ped) nextState = PED;
            else nextState = INIT;
      CAR1: nextState = (~car1 | stop_ped) ? YELLOW1 : CAR1;
      CAR2: nextState = (~car2 | stop_ped) ? YELLOW2 : CAR2;
      CAR3_4: nextState = (~(car3 |car4) | stop_ped) ? YELLOW3 : CAR3_4;
      PED: nextState = (stop_ped) ? DELAY : PED;
      YELLOW1: if (stop_yellow) begin
                 if (car2) nextState = CAR2;
                 else if (car3 | car4) nextState = CAR3_4;
                 else if (ped) nextState = PED;
                 else if (car1) nextState = CAR1;
                 else nextState = PED;
               end else nextState = YELLOW1;
      YELLOW2: if (stop_yellow) begin
                 if (car3 | car4) nextState = CAR3_4;
                 else if (ped) nextState = PED;
                 else if (car1) nextState = CAR1;
                 else if (car2) nextState = CAR2;
                 else nextState = PED;
               end else nextState = YELLOW2;
      YELLOW3: if (stop_yellow) begin
                 if (ped) nextState = PED;
                 else if (car1) nextState = CAR1;
                 else if (car2) nextState = CAR2;
                 else if (car3 | car4) nextState = CAR3_4;
                 else nextState = PED;
               end else nextState = YELLOW3;
      DELAY: if (stop_five) begin
                 if (car1) nextState = CAR1;
                 else if (car2) nextState = CAR2;
                 else if (car3 | car4) nextState = CAR3_4;
                 else if (ped) nextState = PED;
                 else nextState = PED;
               end else nextState = DELAY;
    endcase
  end

  //output logic
  always_comb begin
      red1 = 1'b0;
      yellow1 = 1'b0;
      green1 = 1'b0;
      red2 = 1'b0;
      yellow2 = 1'b0; 
      green2 = 1'b0;
      red3 = 1'b0;
      yellow3 = 1'b0; 
      green3 = 1'b0;
      turn = 1'b0;
      orange = 1'b0;
      white = 1'b0;
      yellow_en = 1'b0;
      yellow_clr = 1'b0;
      stop_en = 1'b0;
      stop_clr = 1'b0;
      five_en = 1'b0;
      five_clr = 1'b0;
      ped_clr = 1'b0;
    
      unique case (state)
        INIT: begin
              yellow_clr = 1'b1;
              stop_clr = 1'b1;
              five_clr = 1'b1;
              red1 = 1'b1;
              red2 = 1'b1;
              red3 = 1'b1;
              orange = 1'b1;
              ped_clr = 1'b1;
              end
        CAR1: begin
              green1 = 1'b1;
              green3 = 1'b1;
              red2 = 1'b1;
              orange = 1'b1;
              stop_en = 1'b1;
              five_clr = 1'b1;
              end
        CAR2: begin
              green2 = 1'b1;
              red1 = 1'b1;
              red3 = 1'b1;
              orange = 1'b1;
              stop_en = 1'b1;
              yellow_clr = 1'b1;
              end
        CAR3_4: begin
              green3 = 1'b1;
              turn = 1'b1;
              red1 = 1'b1;
              red2 = 1'b1;
              orange = 1'b1;
              stop_en = 1'b1;
              yellow_clr = 1'b1;
              end
        PED: begin
              white = 1'b1;
              red1 = 1'b1;
              red2 = 1'b1;
              red3 = 1'b1;
              stop_en = 1'b1;
              yellow_clr = 1'b1;
              ped_clr = 1'b1;
              end
        YELLOW1: begin
                 yellow1 = 1'b1;
                 yellow3 = 1'b1;
                 yellow_en = 1'b1;
                 stop_clr = 1'b1;
                 red2 = 1'b1;
                 orange = 1'b1;
                 end
        YELLOW2: begin
                 yellow2 = 1'b1;
                 red1 = 1'b1;
                 red3 = 1'b1;
                 stop_clr = 1'b1;
                 yellow_en = 1'b1;
                 orange = 1'b1;
                 end
        YELLOW3: begin
                 yellow3 = 1'b1;
                 red1 = 1'b1;
                 red2 = 1'b1;
                 stop_clr = 1'b1;
                 yellow_en = 1'b1;
                 orange = 1'b1;
                 end
        DELAY: begin
                 red1 = 1'b1;
                 red2 = 1'b1;
                 red3 = 1'b1;
                 stop_clr = 1'b1;
                 five_en = 1'b1;
                 orange = 1'b1;
                 end
      endcase
    end

endmodule: FSM
