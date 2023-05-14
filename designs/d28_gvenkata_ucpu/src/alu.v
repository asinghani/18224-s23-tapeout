`include "defines.vh"

module alu_unit_interface (
        sys_clk, 
        sys_reset,
        cpu_state,
        A_bus, B_bus, 
        alu_en_A_reg, alu_en_B_reg,
        alu_op,
        cc_greater,
        cc_equal, 
        alu_result,
        A_reg,
        B_reg
    );

    input sys_clk, sys_reset;
    input alu_en_A_reg, alu_en_B_reg;
    input [$clog2(`CPU_STATES)-1:0] cpu_state;
    input [$clog2(`ALU_OPS)-1:0] alu_op;
    input [`ALU_WIDTH-1:0] A_bus, B_bus;

    wire alu_en;

    /*Registered ALU outputs*/
    output reg cc_greater, cc_equal;
    output reg [`ALU_WIDTH-1:0] alu_result;

    output reg [`ALU_WIDTH-1:0] A_reg, B_reg;

    /*Control signals for loading from A_bus and B_bus*/
    // wire A_reg_en, B_reg_en, alu_result_load;

    assign alu_en = alu_en_A_reg || alu_en_B_reg;
    // assign A_reg_en = (alu_en == 1'b1 && reg_src == A_REG_MAP && cpu_state == `EXECUTE1);
    // assign B_reg_en = (alu_en == 1'b1 && reg_src == B_REG_MAP && cpu_state == `EXECUTE1);
    // assign alu_result_load = (alu_en && cpu_state == `EXECUTE2);

    logic [`ALU_WIDTH-1:0] alu_result_out;
    logic cc_greater_out, cc_equal_out;

    /*Control signal to load ALU micro-registers*/

    always @(posedge sys_clk) begin
        if(sys_reset) begin
            A_reg <= 0;
            B_reg <= 0;
            alu_result <= 0;
            cc_greater <= 0;
            cc_equal   <= 0;
        end
        else begin
            if(alu_en_A_reg && cpu_state == `EXECUTE1) begin
                A_reg <= A_bus;
            end
            if(alu_en_B_reg && cpu_state == `EXECUTE1) begin
                B_reg <= B_bus;
            end
            if(alu_en && cpu_state == `EXECUTE2) begin
                alu_result <= alu_result_out;
                cc_greater <= cc_greater_out;
                cc_equal   <= cc_equal_out;
            end
        end
    end

    /*carry in*/
    wire carry_in;
    assign carry_in = 1'b0;

    //ALU module
    alu_unit alu(.A(A_reg), .B(B_reg), .carry_in(carry_in), 
                    .alu_op(alu_op), .alu_result(alu_result_out), 
                    .greater(cc_greater_out), .equal(cc_equal_out));

endmodule

module alu_unit (
    A,
    B,
    carry_in,
    alu_op,
    alu_result,
    greater,
    equal
);
    input [`ALU_WIDTH-1:0] A,B;
    input carry_in;
    input [$clog2(`ALU_OPS)-1:0] alu_op;
    output [`ALU_WIDTH-1:0] alu_result;
    output greater, equal;

    reg [`ALU_WIDTH-1:0] alu_result_tmp;

    assign alu_result = alu_result_tmp;

    /*
        alu_op_md
        0000 - nop
        0001 - add
        0010 - sub
        0011 - or
        0100 - and
        0101 - not
        0110 - lsl
        0111 - lsr
        1000 - asr
        1001 - cmp
    */

    wire [`ALU_WIDTH-1:0] zero, a_plus_b, a_minus_b, a_or_b, a_and_b, a_negated;
    wire [`ALU_WIDTH-1:0] a_lfs, a_rfs, a_arfs;

    assign a_plus_b = A + B;
    assign a_minus_b = A - B;
    assign a_or_b = A | B;
    assign a_and_b = A & B;
    assign a_negated = ~A;
    assign a_lfs = A << B;
    assign a_rfs = A >> B;
    assign a_arfs = A >>> B;
    assign zero = {`ALU_WIDTH{1'b0}};
    
    always @(*) begin
        case (alu_op)
            // 4'b0000: alu_result = {`ALU_WIDTH{1'b0}};
            4'b0000: alu_result_tmp = zero;
            4'b0001: alu_result_tmp = a_plus_b;
            4'b0010: alu_result_tmp = a_minus_b;
            4'b0011: alu_result_tmp = a_or_b;
            4'b0100: alu_result_tmp = a_and_b;
            4'b0101: alu_result_tmp = a_negated;
            4'b0110: alu_result_tmp = a_lfs;
            4'b0111: alu_result_tmp = a_rfs;
            4'b1000: alu_result_tmp = a_arfs;
            default: alu_result_tmp = zero;
        endcase
    end

    reg a_greater_b, a_equal_b;
    assign greater = a_greater_b;
    assign equal = a_equal_b;

    always @(*) begin
        case (alu_op)
            4'b1001: begin
                a_greater_b = (A>B);
                a_equal_b = (A==B);
            end
            default: begin
                a_greater_b = 1'b0;
                a_equal_b = 1'b0;
            end
        endcase
    end
endmodule

