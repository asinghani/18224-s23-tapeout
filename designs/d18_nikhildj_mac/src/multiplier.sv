module MULTIPLIER_RESULT (
    input  logic reset,
    input  logic clk,
    input  logic [7:0] b_in,
    input  logic Load_mul,
    input  logic do_shift,
    input  logic do_add,
    input  logic [7:0] sum_out,
    input  logic carry_out,
    output logic [15:0] mult_out,
    output logic LSB,
    output logic [7:0] b_out
);

    logic [16:0] temp_register;
    logic temp_Add;

    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            temp_register <= '0;
            temp_Add     <= 1'b0;
        end
        else begin
            if (Load_mul) begin
                temp_register[16:8] <= '0;
                temp_register[7:0]  <= b_in;
            end
            else begin
                if (do_add) begin
                    temp_Add <= 1'b1;
                end
                
                if (do_shift) begin
                    if (temp_Add) begin
                        temp_Add          <= 1'b0;
                      temp_register     <= {1'b0, carry_out, sum_out, temp_register[7:1]};
                    end
                    else begin
                        temp_register     <= {1'b0, temp_register[16:1]};
                    end
                end
            end
        end
    end

    assign b_out      = temp_register[15:8];
    assign LSB     = temp_register[0];
    assign mult_out = temp_register[15:0];

endmodule

