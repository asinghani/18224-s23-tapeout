`default_nettype none

module TuringMachine_test();
  logic [5:0] input_data;
  logic clock, reset, Next, Done, Compute_done;
  logic [10:0] display;
  logic [3:0] state;
  logic tape_reg_out, data_reg_out;
  logic [1:0] direction_out;
  logic [5:0] next_state_out, tape_addr_out;

  TuringMachine #(4, 64) dut (.display_out(display), .*);

  initial begin
    clock = 1'b0;
    forever #5 clock = ~clock;
  end

  initial begin
    $monitor($time,, "input_data = %d, next = %b, done = %b, display = %b, Compute_done = %b\n",
             input_data, Next, Done, display, Compute_done);
    reset <= 1'b1;
    Next <= 1'b0; Done <= 1'b0;
    @(posedge clock);
    reset <= 1'b0;
    input_data <= 3;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 2;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    
    input_data <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 3;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 2;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 2;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 3;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 2;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 3;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    Done <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Done <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 32;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);

    input_data <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    input_data <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    Done <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Done <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);

    @(posedge clock);
    @(posedge clock);
    if ((display != 11'b00000_0_00001) || Compute_done)
      $display("error\n");
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    if ((display != 11'b00000_0_00011) || Compute_done)
      $display("error\n");
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    if ((display != 11'b00000_0_00111) || Compute_done)
      $display("error\n");
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    if ((display != 11'b00000_0_01111) || Compute_done)
      $display("error\n");
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    if ((display != 11'b00000_0_11110) || Compute_done)
      $display("error\n");
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    if ((display != 11'b00000_0_11111) || Compute_done)
      $display("error\n");
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    if ((display != 11'b00000_1_11111) || Compute_done)
      $display("error\n");
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    if ((display != 11'b00001_1_11111) || Compute_done)
      $display("error\n");
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    if ((display != 11'b00011_1_11111) || Compute_done)
      $display("error\n");
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    if ((display != 11'b00111_1_11110) || Compute_done)
      $display("error\n");
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    if ((display != 11'b00011_1_11111) || Compute_done)
      $display("error\n");
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    if ((display != 11'b00011_1_11110) || Compute_done)
      $display("error\n");
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    if ((display != 11'b00011_1_11110) || (~Compute_done))
      $display("error\n");
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    if ((display != 11'b00011_1_11110) || (~Compute_done))
      $display("error\n");
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    if ((display != 11'b00011_1_11110) || (~Compute_done))
      $display("error\n");
    Next <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    Next <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    if ((display != 11'b00011_1_11110) || (~Compute_done))
      $display("error\n");
    #1 $finish;
  end

endmodule: TuringMachine_test