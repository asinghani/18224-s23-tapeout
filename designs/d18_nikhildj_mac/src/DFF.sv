module DFF (
    input logic reset,
    input logic clk,
    input logic D,
    output logic Q
);
    always_ff @(posedge clk, negedge reset) begin
        if (!reset) begin
            Q <= 0;     // Clear the register
        end else begin
            Q <= D;     // Load the register
        end
    end
endmodule
