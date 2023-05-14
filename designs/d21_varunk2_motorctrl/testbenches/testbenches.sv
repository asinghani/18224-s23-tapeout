// TB
module general_pwm_testbench (
    input logic clk,
    input logic rst,
    input logic [15:0] period, duty_cycle, ctr_d,
    input logic pwm_out
  );
  always @(posedge clk) begin
    if (rst) begin
      
    end else begin
      #1;
      if (ctr_d == period) begin
        assert (ctr_d == 0) else $error ("COUNTERROR");
      end
      else if (ctr_d <= duty_cycle) 
        assert (pwm_out == 1) else $error ("PWM ERROR_1");
      else 
        assert (pwm_out == 0) else $error ("PWM ERROR_0; CTR_D: %d PWM_OUT: %d", ctr_d, pwm_out);
    end
  end
 
endmodule

module general_pwm_test ();
  logic clk, rst, pwm_out;
  logic [15:0] period, duty_cycle;

  initial begin
    clk = 0;
    forever #1 clk = ~clk;
  end

  general_pwm_generator mut (.*);
  general_pwm_testbench cut (.ctr_d (mut.ctr_d), .*);

  initial begin
    $monitor ($time, "PWM_OUT: %b period: %d duty_cycle: %d", pwm_out, period, duty_cycle);
    @(posedge clk);
    rst <= 1;
    @(posedge clk);
    rst <= 0;
    period <= 20000;
    duty_cycle <= 1000;
    @(posedge clk);
    
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
    #20000;
    $finish;
  end
endmodule

module decode_vals_test (input logic A, B, clock, reset, p, dir);
    logic [5:0] diff_count;
    logic A_prev, B_prev;
    always @(posedge clock) begin
        // Dir Calcs
        #1;
        if (~reset) begin
            if (A & ~A_prev & ~B) begin
                assert (dir == 1) else $error ("DIR ERROR!");
            end else if (B & ~B_prev & ~A) begin
                assert (dir == 0) else $error ("DIR ERROR!");
            end

            if (A & ~B) begin
                assert (p == 1) else $error ("PULSE ERROR");
            end else begin
                assert (p == 0) else $error ("PULSE ERROR");
            end
            A_prev <= A;
            B_prev <= B;
        end
    end
endmodule

module decode_testbench ();
    logic A, B, reset, p, dir, clock, A_prev, B_prev;
    logic [4:0] speed_ct;
    logic [11:0] speed_reg;
    decode_module dec (.*);
    decode_vals_test testor (.*);

    initial begin
        clock=0;
        forever #5 clock = ~clock;
    end
    initial begin
        B = 0;
        forever #40 B = ~B;
    end

    initial begin
        A = 0;
        #20;
        forever #40 A = ~A;
    end

    initial begin
        $monitor ("speed_ser: %b, CW: %b", p, dir);
        speed_ct = 12;
        reset <=1;
        @(posedge clock);
        reset <= 0;
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
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        $finish;
    end
endmodule

module servo_testbench (); 
    logic clk, rst, servo;
    logic [7:0] position;

    servo_tb dut (.*);
    pwm_generator mut (.*);

    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    initial begin 
        @(posedge clock);
        rst <= 1;
        position <= 8'd128;
        @(posedge clock);
        rst <= 0;
        #50000;
        $finish;
    end
endmodule

module servo_tb (
    input clk,
    input rst,
    input [7:0] position, 
    input logic servo
  );
 
  reg pwm_d, pwm_q;
  reg [19:0] ctr_q;
  logic [19:0] temp_val;
  assign temp_val = 1000 + (position << 2) - 12;
  always_ff @(posedge clk) begin
    #1; // delay for servo vals to set in.
    if (rst) begin
      ctr_d <= 1'b0;
    end else begin
      if (ctr_d == 20000) begin
        ctr_d = 0;
      end
      if (ctr_d < (temp_val)) 
        assert (servo == 1) else $error ("SERVO_ERR#1");
      else 
        assert (servo == 0) else $error ("SERVO_ERR#0");
      ctr_d = ctr_d + 1;
    end
  end
 
endmodule
