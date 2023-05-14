module CONTROLLER_MAC (
    input  logic reset,
    input  logic clk,
    input  logic START,
    input  logic End_mul,
    output logic Finish,
    output logic RESET_cmd,
    output logic Load_op,
    output logic Begin_mul,
    output logic add
);

    logic [3:0] temp_count;
    enum logic [2:0] {IDLE, INIT, LOAD, RUN, TEST, ADD} state;

    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            state      <= IDLE;
            temp_count <= 4'b1001;
        end
        else begin
            case (state)
                IDLE: begin
                    if (START) begin
                        state <= INIT;
                    end
                    else begin
                        state <= IDLE;
                    end
                end
                INIT: begin
                    state <= LOAD;
                end
                LOAD: begin
                    state <= RUN;
                end
                RUN: begin
                    state <= TEST;
                end
                TEST: begin
                    if (!End_mul) begin
                        state <= TEST;
                    end
                    else begin
                        state <= ADD;
                    end
                end
                ADD: begin
                    if (temp_count == 4'b0000) begin
                        temp_count <= 4'b1001;
                        state      <= IDLE;
                    end
                    else begin
                        temp_count <= temp_count - 1;
                        state      <= LOAD;
                    end
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    assign Finish     = (state == IDLE);
    assign Load_op  = (state == LOAD);
    assign Begin_mul = (state == RUN);
    assign add        = (state == ADD);
  	assign RESET_cmd      = (state == INIT || reset == 1'b0) ? 1'b0 : 1'b1;
      
endmodule

