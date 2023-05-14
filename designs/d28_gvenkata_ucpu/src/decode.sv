`include "defines.vh"
/*
    Instruction format
    Branch
     __________
    |27:31|0:26|
    |__________|   

    Register 3 operand
     _______________________________
    |27:31|26|22:25|18:21|14:17|13:0|
    |_______________________________|  

    Immediate 3 operand
     _________________________
    |27:31|26|22:25|18:21|0:17|
    |_________________________| 
*/
module instruction_decoder(
    instr_in,
    is_imm_active_id,
    inst_type,
    reg_dst_id, 
    reg_src_1_id, 
    reg_src_2_id, 
    imm_id, 
    branch_target_id
    );
    input   [31:0]  instr_in;
    output  is_imm_active_id;
    output  [3:0] reg_src_1_id, reg_src_2_id, reg_dst_id;
    output  [7:0] imm_id;
    output  [7:0] branch_target_id;
    output  [4:0] inst_type;
    
    assign inst_type = instr_in[31:27];
    assign is_imm_active_id = instr_in[26];
    assign reg_dst_id = instr_in[25:22];
    assign reg_src_1_id = instr_in[21:18];
    assign reg_src_2_id = instr_in[17:14];
    assign branch_target_id = instr_in[7:0];
    assign imm_id = instr_in[7:0];

endmodule

/*
    Micro-instruction format
     _________________________________
    |43:41|40:36|35:31|30:20|19:10|9:0|
    |_________________________________| 
    Fields:
    43:41 - Micro-instruction type
    40:36 - Source register
    35:31 - Destination register
    30:20 - Immediate value (consider only 27:20)
    19:10 - Branch target micro PC ( consider only 10:17 )
    9:0   - Bus arguments
        
*/
module micro_inst_decoder (
    minstr_in, 
    minstr_type,
    reg_src_md, 
    reg_dst_md, 
    imm_md, 
    mbranch_target_md, 
    is_imm_active_md,
    reg_file_en_md,
    reg_file_rw_md,
    alu_en_A_md,
    alu_en_B_md,
    alu_op_md,
    // mem_en_md,
    // mem_rw_md,
    is_branch_md
    );
    //localparam MREG_SPEC_WIDTH = $clog2(`MREG_COUNT);
    //localparam MINST_TYPE_WIDTH = $clog2(`MINST_COUNT);

    /*Inputs*/
    //Input micro-instruction
    input   [`MINST_WIDTH-1:0] minstr_in;

    /*Outputs*/
    /*Micro instruction type*/
    output [`MINST_TYPE_WIDTH-1:0] minstr_type;
    //Microinstruction source and destination register mapping
    output  [`MREG_SPEC_WIDTH-1:0] reg_src_md, reg_dst_md;
    //Immediate value
    output  [`IMM_WIDTH-1:0] imm_md;
    //Branch target value
    output  [`MBRANCH_ADDR_WIDTH-1:0] mbranch_target_md;
    
    /*Output control signals*/ 
    output  alu_en_A_md, alu_en_B_md;
    output  [$clog2(`ALU_OPS)-1:0] alu_op_md;
    output  is_imm_active_md;
    output  reg_file_en_md, reg_file_rw_md;
    //output  mem_en_md, mem_rw_md; 
    output  is_branch_md;   

    

    /*Args Field in the instruction*/
    wire [`BUS_ARGS-1:0] m_args;

    /*Extract the fields*/
    assign minstr_type = minstr_in[43:41];
    assign reg_src_md = minstr_in[40:36];
    assign reg_dst_md = minstr_in[35:31];
    assign imm_md = minstr_in[27:20];
    assign mbranch_target_md = minstr_in[17:10];
    assign m_args = minstr_in[9:0];
    
    /*ALU operation field*/
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
    //ALU Enable
    assign alu_en_A_md = m_args[0];
    assign alu_en_B_md = m_args[8];

    //ALU operation
    assign alu_op_md = m_args[3:1];
    /*Determine if immediate bit is active*/
    assign is_imm_active_md = (minstr_type == 3'b001) || 
                              (minstr_type == 3'b010) || 
                              (minstr_type == 3'b011);
    //Reg file enable and reg file read/write signal
    assign reg_file_en_md = m_args[4];
    assign reg_file_rw_md = m_args[5];
    //Data memory enable read/write signal
    // assign mem_en_md = m_args[6];
    // assign mem_rw_md = m_args[7];
    //Is branch signal
    assign is_branch_md = (minstr_type == 3'b100) || (minstr_type == 3'b011);
endmodule