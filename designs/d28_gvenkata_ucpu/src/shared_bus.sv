`include "defines.vh"

module reg_src_dst_cmp(
    reg_dst,
    imm,
    A,
    B,
    cc_greater,
    cc_equal,
    alu_result,
    is_imm_active,
    
    should_branch
);
        input [`ADDR_WIDTH-1:0] reg_dst;
        input [`IMM_WIDTH-1:0] imm;
        input [`DATA_WIDTH-1:0] A, B;
        input cc_greater, cc_equal;
        input [`DATA_WIDTH-1:0] alu_result;
        input is_imm_active;
        output should_branch;
        reg [`DATA_WIDTH-1:0] reg_dst_content;

        always_comb begin
            if(reg_dst == `CC_GREATER_MAP) begin
                reg_dst_content = {7'b0, cc_greater};
            end
            else if(reg_dst == `CC_EQUAL_MAP) begin
                reg_dst_content = {7'b0, cc_equal};
            end
            else if(reg_dst == `A_REG_MAP) begin
                reg_dst_content = A;
            end
            else if(reg_dst == `B_REG_MAP) begin
                reg_dst_content = B;
            end
            else if(reg_dst == `ALU_RESULT_MAP) begin
                reg_dst_content = alu_result;
            end
            else if(reg_dst == `IS_IMM_MAP) begin
                reg_dst_content = {7'b0, is_imm_active};
            end
            else begin
                reg_dst_content = 8'b0;
            end
        end

    assign should_branch = (reg_dst_content == imm) ? 1'b1 : 1'b0;

endmodule

module write_bus (
    minstr_type,
    //fields in IR
    rs1,
    rs2, 
    //source register
    reg_src,
    //destination register
    reg_dst,
    //bus args
    // is_imm_active,
    // reg_file_en,
    // reg_file_rw,
    // alu_en,
    // alu_op,
    // is_branch,
    should_branch,
    //producer - micro-decode registers 
    imm, 
    m_pc,
    mbranch_target,    
    //producer - ALU operations
    alu_result,
    cc_greater,
    cc_equal,
    //producer - register file
    reg_rd_data,
    write_bus_out
);

    localparam MINST_TYPE_WIDTH = $clog2(`MINST_COUNT);
    parameter BRANCH_ADDR_WIDTH = 8;
    
    input [`ADDR_WIDTH-1:0] reg_src, reg_dst;
    input [$clog2(`REG_FILE_DEPTH)-1:0] rs1, rs2;
    input [`ALU_WIDTH-1:0] alu_result;
    input [MINST_TYPE_WIDTH-1:0] minstr_type;
    input [`DATA_WIDTH-1:0] reg_rd_data;
    //bus args
    // input logic is_imm_active, reg_file_en, reg_file_rw, alu_en, is_branch, should_branch;
    input should_branch;

    //input logic [$clog2(`ALU_OPS)-1:0] alu_op;

    //Other registers
    input cc_greater, cc_equal;

    //producer - micro-decode registers 
    input [`MPC_WIDTH-1:0] m_pc;
    input [`IMM_WIDTH-1:0] imm;
    input [BRANCH_ADDR_WIDTH-1:0] mbranch_target; 

    /*
    Micro Registers which are producers
    - m_pc 
    - imm
    - mbranch_target

    Data path registers which are producers
    - alu_result
    - reg_rd_data
    - cc_greater
    - cc_equal
    - ld_data (to be implemented) 
    */

    output reg [`WRITE_WIDTH-1:0] write_bus_out;

    always_comb begin
        //Fetching RS1 or RS2 from the register file
        if(minstr_type == 3'b011 ) begin
            write_bus_out = (should_branch == 1'b1) ? mbranch_target: m_pc; 
        end
        else if (minstr_type == 3'b100) begin
            write_bus_out = mbranch_target;
        end
        else begin        
            if(reg_src == `RS1_MAP) begin
                write_bus_out = rs1;
            end
            else if(reg_src == `RS2_MAP) begin
                write_bus_out = rs2;
            end
            //Immediate value register
            else if(reg_src == `IMM_MAP) begin
                write_bus_out = imm;
            end
            //Return instruction
            else if(reg_src == `M_PC_MAP) begin
                write_bus_out = m_pc;
            end
            //Branch instruction
            else if(reg_src == `BRANCH_TARGET_MAP) begin
                write_bus_out = mbranch_target;
            end
            //Result of ALU operation
            else if(reg_src == `ALU_RESULT_MAP) begin
                write_bus_out = alu_result;
            end 
            //Value from Register file 
            else if(reg_src == `REG_RD_DATA_MAP) begin
                write_bus_out = reg_rd_data;
            end
            else begin
                write_bus_out = 8'b0;
            end 
        end

    end
    
endmodule

/*
module read_bus #(
    `A_REG_MAP = 0,
    `B_REG_MAP = 1,
    `REG_SEL_MAP = 5,
    `REG_WR_DATA_MAP = 6,
    `REG_SRC_MAP = 9,
    `REG_DST_MAP = 10,
    `M_PC_MAP = 12,
    `RS1_MAP = 13, 
    `RS2_MAP = 14,
    `RD_MAP = 15,
    //widths
    `BRANCH_ADDR_WIDTH = 10,
    `IMM_WIDTH = 11,
    `WRITE_WIDTH = 8,
    `MINST_COUNT = 8,
    `ADDR_WIDTH = 5,
    `ALU_WIDTH = 8,
    //No of ALU operations
    `ALU_OPS = 8
    //`MEM_ADR = 13,
    //`MEM_DATA = 14,
    //`LD_DATA = 15
) (
    sys_clk,
    //Shared Write bus
    write_bus,
    // Shared read bus
    //instruction type
    minstr_type,
    //ALU operand 1 and 2
    a_reg,
    b_reg,
    //Micro-Reg file select register
    reg_sel,
    //Micro-reg file write data register
    reg_wr_data,
    //source register
    reg_src,
    //destination register
    reg_dst,
    //bus args
    is_imm_active,
    reg_file_en,
    reg_file_rw,
    alu_en,
    alu_op,
    is_branch,
    //consumer - micro-decode registers 
    imm, 
    m_pc,
    
    //
    read_bus
);

    input 
    
    always_comb begin
        if(reg_dst == A_REG_MAP) begin
            read_bus = alu_en ? write_bus : 8'b0;
        end 
        else if(reg_dst == B_REG_MAP) begin
            read_bus = alu_en ? write_bus : 8'b0;
        end  
        else if(reg_dst == REG_SEL_MAP) begin
            read_bus = reg_file_en ? write_bus : 8'b0;
        end  
        else if(reg_dst == REG_WR_DATA_MAP) begin
            read_bus = (reg_file_en && reg_file_rw) ? write_bus : 8'b0;
        end  
        else if(reg_dst == M_PC_MAP) begin
            read_bus = (is_branch) ? write_bus : 8'b0;
        end 
        else begin
            read_bus = 8'b0;
        end
    end

endmodule
*/