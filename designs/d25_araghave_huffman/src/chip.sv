`default_nettype none

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);

    huff_encoder DUT(.clk(clock), .reset(reset), .io_in(io_in), .io_out(io_out));  
    
    
    // Basic counter design as an example

/*
    wire [6:0] led_out;
    assign io_out[6:0] = led_out;

    // external clock is 1000Hz, so need 10 bit counter
    reg [9:0] second_counter;
    reg [3:0] digit;

    always @(posedge clock) begin
        // if reset, set counter to 0
        if (reset) begin
            second_counter <= 0;
            digit <= 0;
        end else begin
            // if up to 16e6
            if (second_counter == 1000) begin
                // reset
                second_counter <= 0;

                // increment digit
                digit <= digit + 1'b1;

                // only count from 0 to 9
                if (digit == 9)
                    digit <= 0;

            end else
                // increment counter
                second_counter <= second_counter + 1'b1;
        end
    end

    // instantiate segment display
    seg7 seg7(.counter(digit), .segments(led_out));
*/
endmodule
