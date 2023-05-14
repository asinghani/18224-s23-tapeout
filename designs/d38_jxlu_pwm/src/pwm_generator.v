`default_nettype none

module pwm_generator (
    input logic clk,
    input logic reset,
    input logic [5:0] duty,
    output logic pwm_signal
);
    logic [5:0] counter;
    logic [5:0] active_duty;

    always_ff @(posedge clk) begin
        if (reset == 1) begin
            if (duty > 6'd50) begin
                active_duty <= 6'd50;
            end
            else begin
                active_duty <= duty;
            end

            counter <= 0;
        end
        else begin
            counter <= counter + 1'b1;

            if (counter == 49) begin
                counter <= 0;
            end

            if (counter >= active_duty) begin
                pwm_signal <= 1'b0;
            end
            else begin
                pwm_signal <= 1'b1;
            end
        end
    end

endmodule