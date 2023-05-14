/* CL_0000_MESIC: System Verilog Code for the Motor Encoder and Servo IC. 
    INPUTS: SCL: clock of microcontroller coming in.
            PERIOD: 16-Bit Input, X*10^-6 seconds for period of PWM signal.
            DUTY:   16-Bit Input, X*10^-6 seconds for duty cycle of PWM signal.
            S_IN:   8-Bit Input, extent of servo's rotation; input 128 for
                1.5 ms duty cycle.
            A:      A Wave of Quadrature Motor Encoder
            B:      B Wave of Quadrature Motor Encoder
    OUTPUTS: PWM for 2 servos, 2 general outputs.
             Speed and direction output for two Motor Encoders.*/
`default_nettype none

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);
    general_pwm PWM_1 (.PWM_PERIOD (io_in[0]), .PWM_DUTY (io_in[1]), 
        .SCL (io_in[11]), .CLK (clock), .reset (reset), .M_OUT (io_out [0]));
    general_pwm PWM_2 (.PWM_PERIOD (io_in[2]), .PWM_DUTY (io_in[3]), 
        .SCL (io_in[11]), .CLK (clock), .reset (reset), .M_OUT (io_out [1]));
    servo_pwm SERVO_1 (.S_IN (io_in[4]), .SCL (io_in[11]), .CLK (clock), 
        .reset (reset), .S_OUT (io_out[2]));
    servo_pwm SERVO_2 (.S_IN (io_in[5]), .SCL (io_in[11]), .CLK (clock), 
        .reset (reset), .S_OUT (io_out[3]));
    decode_module DECODE_1 (.A (io_in[6]), .B (io_in[7]), .clock (clock),
        .reset (reset), .p (io_out[4]), .dir (io_out[5]));
    decode_module DECODE_2 (.A (io_in[8]), .B (io_in[9]), .clock (clock),
        .reset (reset), .p (io_out[6]), .dir (io_out[7]));
endmodule
// General PWM Module, to get the PWM output.
module general_pwm (input logic PWM_PERIOD,
                    input logic PWM_DUTY, 
                    input logic SCL,
                    input logic CLK, reset,
                    output logic M_OUT);
  logic [15:0] period_reg, duty_reg, period, duty_cycle;
  logic [4:0] twelve_count;

  logic last_in_clk, in_clk_rose;
  assign in_clk_rose = (SCL && !last_in_clk);

    always_ff @(posedge CLK) begin
        last_in_clk <= SCL;
        if (reset) twelve_count <= 0;
        else begin 
            if (in_clk_rose) begin 
              period_reg <= {period_reg[10:0], PWM_PERIOD};
              duty_reg <= {duty_reg[10:0], PWM_DUTY};              
            end
            if (twelve_count == 'd12) begin
                period <= period_reg;
                duty_cycle <= duty_reg;
                twelve_count = 0;
            end
            else twelve_count = twelve_count + 1;
        end
    end

endmodule

// generates the PWM signals.
module general_pwm_generator (
    input logic clk,
    input logic rst,
    input logic [15:0] period, duty_cycle,
    output logic pwm_out
  );
 
  logic [15:0] ctr_d;
  always @(posedge clk) begin
    if (rst) begin
      ctr_d <= 1'b0;
      pwm_out <= 1;
    end else begin
      if (ctr_d == period) begin
        ctr_d = 0;
      end
      if (ctr_d < duty_cycle) 
        pwm_out <= 1;
      else 
        pwm_out <= 0;
      ctr_d = ctr_d + 1;
    end
  end
 
endmodule

// Takes in the clock of the servo and a number from 0 to 255 serially, 
// then outputs a PWM signal
module servo_pwm (input logic S_IN, 
                  input logic SCL,
                  input logic CLK, reset,
                  output logic S_OUT);
    logic [7:0] shreg, position;
    logic [3:0] eight_count;
    // detect the rising edge of the clock, store values into shreg
    logic last_in_clk, in_clk_rose;
    assign in_clk_rose = (SCL && !last_in_clk);

    always_ff @(posedge CLK) begin
        last_in_clk <= SCL;
        if (reset) eight_count <= 0;
        else begin 
            if (in_clk_rose) shreg <= {shreg[6:0], S_IN};
            if (eight_count == 'd8) begin
                position <= shreg;
                eight_count = 0;
            end
            else eight_count = eight_count + 1;
        end
    end
    servo_pwm_generator pwm (.clk (CLK), .servo (S_OUT), .rst (reset), .*);
endmodule: servo_pwm

// Takes a degree in parallel and outputs a PWM signal
module servo_pwm_generator (
    input clk,
    input rst,
    input [7:0] position,
    output logic servo
  );
 
  reg pwm_d, pwm_q;
  reg [19:0] ctr_d, ctr_q;
  logic [19:0] temp_val;
  assign temp_val = 1000 + (position << 2) - 12;
  always_ff @(posedge clk) begin
    if (rst) begin
      ctr_d <= 1'b0;
    end else begin
      if (ctr_d == 20000) begin
        ctr_d = 0;
      end
      if (ctr_d < (temp_val)) 
        servo <= 1;
      else 
        servo <= 0;
      ctr_d = ctr_d + 1;
    end
  end
 
endmodule

module decode_module (input logic A, B, clock, reset,
                      output logic p, dir);

    logic [5:0] diff_count;
    logic A_prev, B_prev;
    always @(posedge clock) begin
        if (reset) begin
            p <= 0;
            dir <= 0;
        end else begin
            // Dir Calcs
            if (A & ~A_prev & ~B) begin
                dir <= 1;
            end else if (B & ~B_prev & ~A) begin
                dir <= 0;
            end

            if (A & ~B) begin
                p <= 1;
            end else begin
                p <= 0;
            end
        end
        A_prev <= A;
        B_prev <= B;
    end
endmodule
