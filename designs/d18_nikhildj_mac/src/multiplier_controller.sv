module CONTROLLER (
    input  logic reset,
    input  logic clk,
    input  logic Begin_mul,
    input  logic LSB,
    output logic do_add,
    output logic do_shift,
    output logic Load_mul,
    output logic End_mul
);

    logic [2:0] temp_count;
    enum logic [3:0] {IDLE, INIT, TEST, ADD, SHIFT} state;

    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            state      <= IDLE;
            temp_count <= 3'b000;
        end
        else begin
            case (state)
                IDLE: begin
                    if (Begin_mul) begin
                        state <= INIT;
                    end
                    else begin
                        state <= IDLE;
                    end
                end
                INIT: begin
                    state <= TEST;
                end
                TEST: begin
                    if (!LSB) begin
                        state <= SHIFT;
                    end
                    else begin
                        state <= ADD;
                    end
                end
                ADD: begin
                    state <= SHIFT;
                end
                SHIFT: begin
                    if (temp_count == 3'b111) begin
                        temp_count <= 3'b000;
                        state      <= IDLE;
                    end
                    else begin
                        temp_count <= temp_count + 1;
                        state      <= TEST;
                    end
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    assign End_mul     = (state == IDLE);
    assign do_add  = (state == ADD);
    assign do_shift = (state == SHIFT);
    assign Load_mul  = (state == INIT);
endmodule

