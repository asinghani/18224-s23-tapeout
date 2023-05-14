`default_nettype none

module TuringMachine_test();
  logic clock, reset_n;

  logic [7:0] base_led;
  logic [23:0] led;

  logic [23:0] sw;
  logic [4:0] btn;

  logic [3:0] display_sel;
  logic [7:0] display;

  m_design dut (.clk100(clock), .*);

  initial begin
    clock = 1'b0;
    forever #5 clock = ~clock;
  end

  initial begin
    $monitor($time,, "input_data = %d, next = %b, done = %b, display = %b, Compute_done = %b\n",
             sw[3:0], btn[0], btn[1], led[10:0], led[11]);
    reset_n <= 1'b0;
    btn[1:0] <= 2'b0;
    @(posedge clock);
    reset_n <= 1'b1;
    sw <= 3;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 2;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    
    sw <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 3;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 2;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 2;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 3;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 2;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 3;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    sw <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    btn[1] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[1] <= 1'b0;
    @(posedge clock);
    @(posedge clock);

    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    btn[0] <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    #1 $finish;
  end

endmodule: TuringMachine_test