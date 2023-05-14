`default_nettype none

module mmx_chip (
  input [7:0] io_in,
  output [7:0] io_out
);
    
    wire clk = io_in[0];
    wire reset = io_in[1];
    reg [6:0] counter;
    assign io_out[7:0] = counter;

    always @(posedge clk) begin
        // if reset, set counter to 0
        if (reset) begin
            counter <= 0;
        end else begin
            // if up to 16e6
            // increment counter
            counter <= counter + 1'b1;
        end
    end

endmodule
