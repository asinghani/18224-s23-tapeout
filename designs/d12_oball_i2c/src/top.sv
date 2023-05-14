`default_nettype none

//Top level module for interfacing with Alchitry Cu
module chipInterface (
    input logic clk100, // 100MHz clock
    input logic reset_n, // Active-low reset
    input logic SCL_in, SDA_in, i2c_reset,
    input logic [1:0] ADDR,
    input logic [7:0] parallel_in,
    output logic [1:0] PWM,
    output logic [7:0] led,
    output logic SDA_out, UART
);

logic [31:0] counter;
logic clock;
logic [11:0] io_in, io_out;

always_ff @(posedge clk100)
        if (~reset_n) begin
            counter <= '0;
            clock <= 1'b0;
        end 
        else begin
            counter <= counter + 1;
            if (counter == 50) begin
                clock <= ~clock;
                counter <= '0;
            end
        end
  
assign io_in = {parallel_in, ADDR, SDA_in, SCL_in};
assign led = io_out[11:4];
assign PWM = io_out[3:2];
assign SDA_out = io_out[0];
assign UART = io_out[1];

my_chip CHIP (.io_in, .io_out, .clock, .reset(i2c_reset));

endmodule: chipInterface