`default_nettype none

module my_chip (
  input logic [11:0] io_in, 
  input logic clock, reset,
  output logic [11:0] io_out
);
logic car1, car2, car3, car4, ped, 
                stop_yellow, stop_ped, stop_five,
                red1, yellow1, green1, 
                red2, yellow2, green2,
                red3, yellow3, green3,
                turn, orange, white, 
                yellow_en, 
                yellow_clr, 
                stop_en,
                stop_clr, 
                five_en,
                five_clr, 
                ped_clr,
                button;

  assign {car1, car2, car3, car4, button} = io_in [4:0];

  assign io_out = {red1, yellow1, green1, 
                red2, yellow2, green2,
                red3, yellow3, green3,
                turn, orange, white};

  Counter yellow (.D(4'b0), .clear(yellow_clr), .load(1'b0), .clock, .en(yellow_en), .Q(stop_yellow));
  Counter stop (.D(4'b0), .clear(stop_clr), .load(1'b0), .clock, .en(stop_en), .Q(stop_ped));
  Counter five (.D(4'b0), .clear(five_clr), .load(1'b0), .clock, .en(five_en), .Q(stop_five));
  Register pedestrian (.clock, .ped, .ped_clr, .button);
  FSM control(.*);

endmodule
