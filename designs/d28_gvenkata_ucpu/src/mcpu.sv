`include "defines.vh"

module cpu_fsm(
    sys_clk,
    sys_reset,
    cpu_state,
    //pc,
    //mpc,
    is_nop,
    is_micro_nop
    );

    /*Internal FSM counter to keep track of states*/
    input sys_clk, sys_reset;
    input is_nop, is_micro_nop;
    reg [5:0] fsm_assist;
    reg [4:0] current_minst;
    
    output reg [$clog2(`CPU_STATES)-1:0] cpu_state;
    
    parameter M_INST_ADDR_WIDTH = 9;

    always @(posedge sys_clk) begin
        if(sys_reset) begin
            cpu_state <= `SEND_PC;
            fsm_assist <= 6'b0;
            current_minst <= 5'b0;
        end
        else begin
            if(cpu_state == `SEND_PC) begin
                if(fsm_assist == `PC_WIDTH-1) begin
                    cpu_state  <= `FETCH;
                    fsm_assist <= 6'b0;
                end
                else begin 
                    fsm_assist <= fsm_assist + 6'b1;
                end
            end
            else if(cpu_state == `FETCH) begin
                if(fsm_assist == `INST_WIDTH-1) begin
                    cpu_state  <= `DECODE;
                    fsm_assist <= 6'b0;
                end
                else begin 
                    fsm_assist <= fsm_assist + 6'b1;
                end
            end
            else if(cpu_state == `DECODE) begin
                if(is_nop) begin
                    cpu_state <= `FETCH;
                end
                else begin
                    cpu_state <= `SEND_MPC;
                end
                fsm_assist <= 6'b0;
            end
            else if(cpu_state == `SEND_MPC) begin
                if(fsm_assist == M_INST_ADDR_WIDTH-1) begin
                    cpu_state  <= `FETCH_MINST;
                    fsm_assist <= 6'b0;
                end
                else begin 
                    fsm_assist <= fsm_assist + 6'b1;
                end
            end
            else if(cpu_state == `FETCH_MINST) begin
                if(fsm_assist == `MINST_WIDTH-1) begin
                    cpu_state  <= `DECODE_MINST;
                    fsm_assist <= 6'b0;
                end
                else begin 
                    fsm_assist <= fsm_assist + 6'b1;
                end
            end
            else if(cpu_state == `DECODE_MINST) begin
                if(is_micro_nop) begin
                    cpu_state <= `FETCH_MINST;
                    current_minst <= current_minst + 5'b1; 
                end
                else begin
                    cpu_state <= `EXECUTE1;
                end
            end
            else if(cpu_state == `EXECUTE1) begin
                cpu_state <= `EXECUTE2;
            end
            else if(cpu_state == `EXECUTE2) begin
                if(current_minst == 5'd31) begin
                    current_minst <= 5'b0; 
                    cpu_state <= `FETCH;
                end
                else begin
                    current_minst <= current_minst + 5'b1; 
                    cpu_state <= `SEND_MPC;
                end
            end
        end
    end
endmodule


module top_cpu(
    sys_clk,
    sys_reset,
    instr_in,
    m_instr_in,
    inst_addr_stream, 
    m_inst_addr_stream

);
    input sys_clk, sys_reset;
    //Instruction sequence
    input instr_in;
    //Micro-instruction sequence
    input m_instr_in;
    //Instruction address sequence
    output inst_addr_stream;
    //Micro-instruction address sequence
    output m_inst_addr_stream;
    
    // Register to Track CPU FSM state
    reg [$clog2(`CPU_STATES)-1:0] cpu_state;

    //Signal to track if current instruction/micro-instruction is a NOP

    wire is_current_inst_nop, is_current_micro_inst_nop;
    assign is_current_inst_nop = 1'b0;
    assign is_current_micro_inst_nop = 1'b0;
    //Instantiate CPU FSM
    cpu_fsm cpu_fsm_top( .sys_clk(sys_clk),
                        .sys_reset(sys_reset),
                        .cpu_state(cpu_state),
                        .is_nop(is_current_micro_inst_nop),
                        .is_micro_nop(is_current_micro_inst_nop)
                        );

    /*
    Instantiate PC register and associated signals
        1. load_pc_en - PC register load enable
        2. next_pc    - Next PC value
        3. pc         - Current PC value, registered
    */
    wire load_pc_en;
    wire [`PC_WIDTH-1:0] pc, next_pc;
    assign load_pc_en = (cpu_state == `EXECUTE2 && cpu_fsm_top.current_minst == 5'd31)  ? 1'b1 : 1'b0;
    pc_reg pc_top(.sys_clk(sys_clk), .sys_reset(sys_reset), 
            .load_pc_en(load_pc_en),
            .next_pc(next_pc), 
            .pc(pc));   

    /*
    Instantiate instruction address serialiser
        1. cpu_state - Current CPU state
        2. pc - Current PC value, registered
    */
    inst_addr_serialise inst_to_bit(.sys_clk(sys_clk), .sys_reset(sys_reset),
                                    .cpu_state(cpu_state),
                                    .inst_addr(pc),
                                    .inst_addr_stream(inst_addr_stream));
    
    /*
    Instantiate Instruction register
        1. instr_in - Input instruction stream
        2. instr_reg - Current CPU instruction under execution 
    */
    wire [`INST_WIDTH-1:0] instr_reg;
    wire instr_reg_en = (cpu_state == `FETCH) ? 1'b1: 1'b0;
    instr_reg_interface instr_reg_top(.sys_clk(sys_clk), .sys_reset(sys_reset),
                                        .instr_in(instr_in),
                                        .instr_reg(instr_reg),
                                        .enable(instr_reg_en)
                                    );
    
    /*
    Instantiate Instruction decoder and declare related decode field signals

    */
    
    wire [4:0] inst_type;
    wire is_imm_active_id;
    wire [3:0] reg_src_1_id, reg_src_2_id, reg_dst_id;
    wire [7:0] imm_id;
    wire [7:0] branch_target_id;
    instruction_decoder ir_decode_top(
                        .instr_in(instr_reg),
                        .inst_type(inst_type),
                        .is_imm_active_id(is_imm_active_id),
                        .reg_dst_id(reg_dst_id), 
                        .reg_src_1_id(reg_src_1_id), 
                        .reg_src_2_id(reg_src_2_id), 
                        .imm_id(imm_id),
                        .branch_target_id(branch_target_id)
                        );

    //Micro-instruction sequence
    /*
    Instantiate address offset generator for microinstruction
        1. instr_reg - Instruction
        2. m_inst_addr_offset - offset for micro-instruction
    */
    wire [`M_INST_ADDR_WIDTH-1:0] m_inst_addr_offset;
    m_inst_addr_gen m_inst_addr_offset_gen(.instr_in(instr_reg), 
                                    .m_inst_addr_base(m_inst_addr_offset)
    );

    wire should_branch;
    wire [`MBRANCH_ADDR_WIDTH-1:0] mbranch_target;


    //Instantiate Instruction and micro-instruction register
    
    //Instantiate micro-PC register
    /*
    Instantiate PC register and associated signals
        1. load_m_pc_en - micro-PC register load enable
        2. next_m_pc    - Next micro-PC value
        3. m_pc         - Current micro-PC value, registered
    */
    wire load_m_pc_en;
    wire [`MPC_WIDTH-1:0] m_pc, next_m_pc;
    assign load_m_pc_en = (cpu_state == `DECODE) ? 1'b1 : ((cpu_state == `EXECUTE1 && should_branch) ? 1'b1 : 1'b0);
    assign next_m_pc = (cpu_state == `DECODE) ? {`MPC_WIDTH{1'b0}} : (cpu_state == `EXECUTE1 && should_branch) ? mbranch_target : m_pc + 8'b1;
    m_pc_reg m_pc_top(.sys_clk(sys_clk), .sys_reset(sys_reset), .load_m_pc_en(load_m_pc_en),
            .next_m_pc(next_m_pc), .m_pc(m_pc));
    wire [`M_INST_ADDR_WIDTH-1:0] mpc_offset;
    assign mpc_offset = m_inst_addr_offset+m_pc;
    //Instantiate micro-instruction address serialiser
    m_inst_addr_serialise m_inst_to_bit(.sys_clk(sys_clk), .sys_reset(sys_reset),
                            .cpu_state(cpu_state),
                            .m_inst_addr(mpc_offset),
                            .m_inst_addr_stream(m_inst_addr_stream)
                        );
    /*
    Instantiate Micro-Instruction register
        1. m_instr_in - Input micro-instruction stream
        2. minstr_reg - Current CPU micro-instruction under execution 
    */
    wire [`MINST_WIDTH-1:0] m_instr_reg;
    wire m_instr_reg_en = (cpu_state == `FETCH_MINST) ? 1'b1: 1'b0;
    m_instr_reg m_instr_reg_top(.sys_clk(sys_clk), .sys_reset(sys_reset),
                                .enable(m_instr_reg_en),
                                .minstr_in(m_instr_in),
                                .m_instr_reg(m_instr_reg)
                                );
    
    /*
        Micro-instruction decoder and associated signals
    */

    //Microinstruction source and destination register mapping
    wire [`MREG_SPEC_WIDTH-1:0] reg_src_md, reg_dst_md;
    //Immediate value
    wire [`IMM_WIDTH-1:0] imm_md;
    //Branch target value
    wire [`MBRANCH_ADDR_WIDTH-1:0] mbranch_target_md;
    
    /*Output control signals*/ 
    wire alu_en_md;
    wire [$clog2(`ALU_OPS)-1:0] alu_op_md;
    wire is_imm_active_md;
    wire reg_file_en_md, reg_file_rw_md;
    //wire mem_en_md, mem_rw_md; 
    wire is_branch_md;   

    /*Micro instruction type*/
    wire [`MINST_TYPE_WIDTH-1:0] minstr_type;
    
    micro_inst_decoder m_inst_decode_top(
        .minstr_in(m_instr_reg), 
        .minstr_type(minstr_type),
        .reg_src_md(reg_src_md), 
        .reg_dst_md(reg_dst_md), 
        .imm_md(imm_md), 
        .mbranch_target_md(mbranch_target_md), 
        .is_imm_active_md(is_imm_active_md),
        .reg_file_en_md(reg_file_en_md),
        .reg_file_rw_md(reg_file_rw_md),
        .alu_en_A_md(alu_en_A_md), 
        .alu_en_B_md(alu_en_B_md),
        .alu_op_md(alu_op_md),
        //.mem_en_md(mem_en_md),
        //.mem_rw_md(mem_rw_md),
        .is_branch_md(is_branch_md)
    );
    
    wire [7:0] shared_write_bus;

    wire [`MREG_SPEC_WIDTH-1:0] reg_dst, reg_src;
    wire [`IMM_WIDTH-1:0] imm;
    // wire [`MBRANCH_ADDR_WIDTH-1:0] mbranch_target;

    /*Registered control signals*/
    wire  is_imm_active;

    /*Registered args*/
    wire alu_en;
    wire [$clog2(`ALU_OPS)-1:0] alu_op;
    wire reg_file_en, reg_file_rw;
    //wire wire mem_en, mem_rw;
    wire is_branch;

    mdecode_reg mdecode_reg_top(
        .sys_clk(sys_clk), .sys_reset(sys_reset),
        /*Decode fields*/
        .is_imm_active_md(is_imm_active_md),
        .reg_dst_md(reg_dst_md), 
        .reg_src_md(reg_src_md), 
        .imm_md(imm_md), 
        .mbranch_target_md(mbranch_target_md), 
        /*Flags*/
        .alu_en_A_md(alu_en_A_md), 
        .alu_en_B_md(alu_en_B_md), 
        .alu_op_md(alu_op_md),
        .reg_file_en_md(reg_file_en_md),
        .reg_file_rw_md(reg_file_rw_md),
        .is_branch_md(is_branch_md),
        /*Registered Decode fields*/
        .is_imm_active(is_imm_active),
        .reg_dst(reg_dst), 
        .reg_src(reg_src), 
        .imm(imm), 
        .mbranch_target(mbranch_target), 
        /*Registered Flags*/
        .alu_en_A(alu_en_A), 
        .alu_en_B(alu_en_B), 
        .alu_op(alu_op),
        .reg_file_en(reg_file_en),
        .reg_file_rw(reg_file_rw),
        .is_branch(is_branch)
    );

    
    //Instantiate micro-branch detector
    reg_src_dst_cmp reg_src_dst_cmp_branch(
            .reg_dst(reg_dst),
            .imm(imm),
            .A(A_reg),
            .B(B_Reg),
            .cc_greater(cc_greater),
            .cc_equal(cc_equal),
            .alu_result(alu_result),
            .is_imm_active(is_imm_active),
            .should_branch(should_branch)
    );

    /*
        ALU and associated signals - Reads from the shared write bus
    */
    wire cc_greater, cc_equal;
    wire [`ALU_WIDTH-1:0] alu_result;
    wire [`ALU_WIDTH-1:0] A_reg, B_reg;
    
    //Instantiate alu unit
    alu_unit_interface alu_top(
        .sys_clk(sys_clk), .sys_reset(sys_reset),
        .cpu_state(cpu_state),
        .A_bus(shared_write_bus),
        .B_bus(shared_write_bus),
        .alu_en_A_reg(alu_en_A), 
        .alu_en_B_reg(alu_en_B), 
        .alu_op(alu_op),
        .cc_greater(cc_greater),
        .cc_equal(cc_equal), 
        .alu_result(alu_result),
        .A_reg(A_reg),
        .B_reg(B_reg)
    );
    

    
    //wire [`REG_SPEC_WIDTH-1:0] reg_sel;
    //wire [`DATA_WIDTH-1:0] reg_wr_data;
    wire [`DATA_WIDTH-1:0] reg_rd_data;


    //Instantiate Register File 
    micro_reg_file reg_file_interface(
        .sys_clk(sys_clk), .sys_reset(sys_reset),
        .cpu_state(cpu_state),
        .reg_file_en(reg_file_en), 
        .reg_file_rw(reg_file_rw), 
        .reg_dst(reg_dst_id),
        .shared_write_bus(shared_write_bus),
        .reg_rd_data(reg_rd_data)
    );
    
    

    write_bus shared_mcpu_bus(
        .minstr_type(minstr_type),
        //fields in IR
        .rs1(reg_src_1_id),
        .rs2(reg_src_2_id), 
        //source register
        .reg_src(reg_src),
        //destination register
        .reg_dst(reg_dst),
        //bus args
        // .is_imm_active(is_imm_active),
        // .reg_file_en(reg_file_en),
        // .reg_file_rw(reg_file_rw),
        // .alu_en_A(alu_en_A), 
        // .alu_en_B(alu_en_B),
        // alu_op,
        // is_branch,
        .should_branch(should_branch),
        //producer - micro-decode registers 
        .imm(imm), 
        .m_pc(m_pc),
        .mbranch_target(mbranch_target),    
        //producer - ALU operations
        .alu_result(alu_result),
        .cc_greater(cc_greater),
        .cc_equal(cc_equal),
        //producer - register file
        .reg_rd_data(reg_rd_data),
        .write_bus_out(shared_write_bus)
    );

endmodule
