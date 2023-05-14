`default_nettype none

module clock_maker
  (output logic clock);

  initial begin
    clock = 1'b1;
    forever #1 clock = ~clock;
  end

endmodule: clock_maker

module test ();
  logic clock, reset, car1, car2, car3, car4, ped, 
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

  clock_maker clocky(.*);

  Counter yellow (.D(4'b0), .clear(yellow_clr), .load(1'b0), .clock, .en(yellow_en), .Q(stop_yellow));
  Counter stop (.D(4'b0), .clear(stop_clr), .load(1'b0), .clock, .en(stop_en), .Q(stop_ped));
  Counter five (.D(4'b0), .clear(five_clr), .load(1'b0), .clock, .en(five_en), .Q(stop_five));
  Register pedestrian (.clock, .ped, .ped_clr, .button);
  FSM control(.*);

  initial begin
      $monitor($time,, " STATE: %s \n", control.state.name,
      "_________________________________________________________________________\n",
      "                                             |_|  red    %b              \n", red3,
      "                                             |_|  yellow %b  <-- car %b  \n", yellow3, car3,
      "                                             |_|  green  %b              \n", green3,
      "- - - - - - - - - - -                        |_|  turn   %b      car %b  \n", turn, car4,
      "           red    %b                          |_|  - - - - - - - - - - - -\n", red1,
      "car %b -->  yellow %b                          |_|                         \n", car1, yellow1,
      "           green  %b                          |_|                         \n", green1,
      "______________________                       ____________________________\n",
      "                      |         | red    %b  | cross %b                   \n", red2, white,
      "                      |           yellow %b  | stop  %b                   \n", yellow2, orange,
      "                      |         | green  %b  |    ^                      \n", green2,
      "                      |              ^      |    |                       \n",
      "                      |         |    |      |   ped %b                       \n", ped,
      "                      |            car %b    |                            \n", car2);
    
    //initialize
    button <= 1'b0;
    car1 <= 1'b0;
    car2 <= 1'b0;
    car3 <= 1'b0;
    car4 <= 1'b0;
    reset <= 1'b0;
    @(posedge clock);
    reset <= 1'b1;
    @(posedge clock);
    reset <= 1'b0;
    @(posedge clock);

    //test each car/ped individually
    button <= 1'b1;
    @(posedge clock);
    car1 <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    button <= 1'b0;
    car1 <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    car2 <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    car2 <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    car3 <= 1'b1;
    car4 <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    $finish;
  end

endmodule: test