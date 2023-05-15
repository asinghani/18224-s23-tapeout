`default_nettype none

module my_chip (
    input logic [11:0] io_in, 
    input logic clock, reset,
    output logic [11:0] io_out
);

    logic enable, updown;
    assign enable = io_in[0];
    assign updown = io_in[1];

    always_ff @(posedge clock) begin
        if (reset) begin
            io_out <= '0;
        end
        else if (enable && updown) begin
            io_out <= io_out - 1;
        end
        else if (enable && !updown) begin
            io_out <= io_out + 1;
        end
    end

endmodule
