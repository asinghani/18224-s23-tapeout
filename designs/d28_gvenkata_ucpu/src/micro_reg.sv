`include "defines.vh"
/*
    Micro-instruction format: 
     _________________________________
    |43:41|40:36|35:31|30:20|19:10|9:0|
    |_________________________________| 
*/

module decode_reg (
    sys_clk,
    sys_reset,
    is_imm_active_id,
    reg_dst_id, 
    reg_src_1_id, 
    reg_src_2_id, 
    imm_id, 
    branch_target_id,
    is_imm_active,
    reg_dst,
    reg_src_1,
    reg_src_2,
    imm,
    branch_target
);

    input  sys_clk, sys_reset, is_imm_active_id;
    input  [3:0] reg_src_1_id, reg_src_2_id, reg_dst_id;
    input  [10:0] imm_id;
    input  [9:0] branch_target_id;

    output  reg is_imm_active;
    output  reg [3:0] reg_src_1, reg_src_2, reg_dst;
    output  reg [10:0] imm;
    output  reg [9:0] branch_target;

    always @(posedge sys_clk) begin
        if(sys_reset) begin
            is_imm_active <= 1'b0;
            reg_src_1 <= 0;
            reg_src_2 <= 0;
            reg_dst <= 0;
            imm <= 0;
            branch_target <= 0;
        end
        else begin
            is_imm_active <= is_imm_active_id;
            reg_src_1 <= reg_src_1_id;
            reg_src_2 <= reg_src_2_id;
            reg_dst <= reg_dst_id;
            imm <= imm_id;
            branch_target <= branch_target_id;
        end
    end

endmodule

module mdecode_reg (
    sys_clk, 
    sys_reset,
    /*Decode fields*/
    is_imm_active_md,
    reg_dst_md, 
    reg_src_md, 
    imm_md, 
    mbranch_target_md, 
    /*Flags*/
    alu_en_A_md,
    alu_en_B_md,
    alu_op_md,
    reg_file_en_md,
    reg_file_rw_md,
    is_branch_md,
    /*Registered Decode fields*/
    is_imm_active,
    reg_src,
    reg_dst,
    imm,
    mbranch_target,
    
    /*Registered Flags*/
    alu_en_A,
    alu_en_B,
    alu_op,
    reg_file_en,
    reg_file_rw,
    is_branch
);
    /*Fields from decoder unit*/
    input  sys_clk, sys_reset;
    input  [`MREG_SPEC_WIDTH-1:0] reg_src_md, reg_dst_md;
    input  [`IMM_WIDTH-1:0] imm_md;
    input  [`MBRANCH_ADDR_WIDTH-1:0] mbranch_target_md;
    /*Control signals and bus args*/
    input  is_imm_active_md;
    input  alu_en_A_md, alu_en_B_md;
    input  [$clog2(`ALU_OPS)-1:0] alu_op_md;
    input  reg_file_en_md, reg_file_rw_md;
    input  is_branch_md;

    /*Declare registers*/
    output reg [`MREG_SPEC_WIDTH-1:0] reg_src, reg_dst;
    output reg [`IMM_WIDTH-1:0] imm;
    output reg [`MBRANCH_ADDR_WIDTH-1:0] mbranch_target;

    /*Registered control signals*/
    output reg is_imm_active;

    /*Registered args*/
    output reg alu_en_A, alu_en_B;
    output reg [$clog2(`ALU_OPS)-1:0] alu_op;
    output reg reg_file_en, reg_file_rw;
    //output wire mem_en, mem_rw;
    output reg is_branch;

    /*Register all fields, control signals and args*/
    /*Yet to implement sys_reset*/
    always @(posedge sys_clk) begin
        if(sys_reset) begin
            reg_src <= 0;
            reg_dst <= 0;
            imm <= 0;
            mbranch_target <= 0;
            is_imm_active <= 0;
            alu_en_A <= 0;
            alu_en_B <= 0;
            alu_op <= 0;
            reg_file_en <= 0;
            reg_file_rw <= 0;
            is_branch <= 0;
        end
        else begin
            reg_src <= reg_src_md;
            reg_dst <= reg_dst_md;
            imm <= imm_md;
            mbranch_target <= mbranch_target_md;
            is_imm_active <= is_imm_active_md;
            alu_en_A <= alu_en_A_md;
            alu_en_B <= alu_en_B_md;
            alu_op <= alu_op_md;
            reg_file_en <= reg_file_en_md;
            reg_file_rw <= reg_file_rw_md;
            is_branch <= is_branch_md;
        end
    end

endmodule

module micro_reg_file (
    //sys clk
    input sys_clk,
    //System reset
    input sys_reset,
    //cpu_state
    input [$clog2(`CPU_STATES)-1:0] cpu_state,
    /* Register file enable signal */
    input reg_file_en, 
    /* Register file R/W signal */
    input reg_file_rw, 
    /* Register destination signal - either REG_SEL or REG_WR_DATA */
    input [3:0] reg_dst,
    /* Shared write bus data*/
    input [`DATA_WIDTH-1:0] shared_write_bus,
    /* Reg file register select  */
    //input [`REG_SPEC_WIDTH-1:0] reg_dst,
    /* Reg file register write value  */
    //input [`DATA_WIDTH-1:0] reg_wr_data,
    /* Reg file register read value   */
    output [`DATA_WIDTH-1:0] reg_rd_data
);

    /*Registered reg file addr select*/
    reg [`REG_SPEC_WIDTH-1:0] reg_sel_in;

    /*Registered reg file write data*/
    reg [`DATA_WIDTH-1:0] reg_wr_data_in;

    /*Registered reg file read data*/
    reg [`DATA_WIDTH-1:0] reg_rd_data_out;

    /*Declare register file*/
    reg [`DATA_WIDTH-1:0] mreg_file[`REG_FILE_DEPTH-1:0];

    /*reg_rd_data output*/
    assign reg_rd_data = reg_rd_data_out;
    
    /*Register file writes are synchronous*/
    always @(posedge sys_clk) begin
        if(sys_reset) begin
            reg_sel_in <= {`REG_SPEC_WIDTH{1'b0}};
            reg_wr_data_in <= {`DATA_WIDTH{1'b0}};
            reg_rd_data_out <= {`DATA_WIDTH{1'b0}};
        end
        else begin
            if(reg_file_en) begin
                if(cpu_state == `EXECUTE1) begin
                    if (reg_dst == `REG_SEL_MAP) begin
                        reg_sel_in <= shared_write_bus[`REG_SPEC_WIDTH-1:0];
                    end
                    if (reg_dst == `REG_WR_DATA_MAP) begin
                        reg_wr_data_in <= shared_write_bus; 
                    end
                    /*
                    if(reg_file_rw == `REG_FILE_WRITE) begin
                        reg_wr_data_in <= reg_wr_data; 
                    end
                    */
                end
                else if(cpu_state == `EXECUTE2) begin
                    if(reg_file_rw == `REG_FILE_READ) begin
                        reg_rd_data_out <= mreg_file[reg_sel_in];
                    end
                    else if(reg_file_rw == `REG_FILE_WRITE) begin
                        mreg_file[reg_sel_in] <= reg_wr_data_in;
                    end
                end
            end
        end
    end
endmodule