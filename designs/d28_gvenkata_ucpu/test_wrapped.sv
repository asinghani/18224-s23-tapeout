
/*CPU States*/
`define CPU_STATES          10
`define SEND_PC             4'd0
`define FETCH               4'd1
`define DECODE              4'd2
`define SEND_MPC            4'd3
`define FETCH_MINST         4'd4
`define DECODE_MINST        4'd5
`define EXECUTE1            4'd6
`define EXECUTE2            4'd7
`define SET_MAR             4'd8
`define SET_MDR             4'd9
//No. of micro registers
`define MREG_COUNT          'd18
`define MREG_SPEC_WIDTH     'd5
/*Micro-registers Mapping*/
`define A_REG_MAP           5'd0
`define B_REG_MAP           5'd1
`define ALU_RESULT_MAP      5'd2
`define CC_GREATER_MAP      5'd3
`define CC_EQUAL_MAP        5'd4
`define REG_SEL_MAP         5'd5
`define REG_WR_DATA_MAP     5'd6
`define REG_RD_DATA_MAP     5'd7
`define IS_IMM_MAP          5'd8
`define IMM_MAP             5'd9
`define REG_SRC_MAP         5'd10
`define REG_DST_MAP         5'd11
`define MBRANCH_TARGET_MAP  5'd12
`define M_PC_MAP            5'd13
`define RS1_MAP             5'd14
`define RS2_MAP             5'd15
`define RD_MAP              5'd16
`define BRANCH_TARGET_MAP   5'd17
`define IMM_INSTR_MAP       5'd18
/*Register Widths*/
`define INST_WIDTH          32
//No of micro-instructions
`define MINST_COUNT         8
//micro-instruction opcode width
`define MINST_TYPE_WIDTH    3
//Micro-instruction width
`define MINST_WIDTH         44
//
`define M_INST_ADDR_WIDTH   9


//PC Register Width
`define PC_WIDTH            8
//Micro-PC
`define MPC_WIDTH           8
//Branch target
`define MBRANCH_ADDR_WIDTH  8
//Immediate value
`define IMM_WIDTH           8
//Shared write bus
`define WRITE_WIDTH         8
//
`define ADDR_WIDTH          5
//
`define DATA_WIDTH          8
//Register file depth
`define REG_FILE_DEPTH      4
`define DATA_WIDTH          8
//log2(REG_FILE_DEPTH)
`define REG_SPEC_WIDTH      2
`define REG_FILE_READ       1'b0
`define REG_FILE_WRITE      1'b1
//No of ALU operations
`define ALU_OPS             8
//ALU width
`define ALU_WIDTH           8
//parameter MEM_ADR  13
//parameter MEM_DATA  14
//parameter LD_DATA  15
`define BUS_ARGS            10

`ifndef LOCAL_DIR
`define LOCAL_DIR ""
`endif

`timescale 1ns/1ps

module tb_topcpu;
    reg sys_clk, sys_reset;
    localparam INST_MEM_SIZE = 1024;
    localparam M_INST_MEM_SIZE = 160;
    parameter M_INST_ADDR_WIDTH = 9;
    /*Declare Instruction and micro-instruction memory*/
    reg [`INST_WIDTH-1:0] inst_mem [INST_MEM_SIZE-1:0];
    reg [`MINST_WIDTH-1:0]  m_inst_mem [M_INST_MEM_SIZE-1:0];

    reg [`PC_WIDTH-1:0] instr_add_reg;

    reg [M_INST_ADDR_WIDTH-1:0] m_instr_add_reg;


    reg instr_in, m_instr_in;
    wire inst_addr_stream, m_inst_addr_stream;
    wire [3:0] cpu_state;

	
    my_chip mcpu (
        .clock(sys_clk), .reset(sys_reset),
        .io_in({10'b0, m_instr_in, instr_in}),
        .io_out({cpu_state, m_inst_addr_stream, inst_addr_stream})
    );

    initial begin
        $readmemb({`LOCAL_DIR, "imem.txt"}, inst_mem); 
        $readmemb({`LOCAL_DIR, "micro_rom.txt"}, m_inst_mem); 
        instr_add_reg = {`PC_WIDTH{1'b0}};
        m_instr_add_reg = {M_INST_ADDR_WIDTH{1'b0}};
        sys_clk = 1'b0;  
        sys_reset = 1'b1;
    
        #10000
        sys_clk = 1'b1;
        #10000  
        sys_clk = 1'b0;  
        sys_reset = 1'b0;
    
        $display("***************************************");
        $display("Receiving instruction address from CPU");
        $display("CPU_STATE = %h",cpu_state);
        for(int i = 0; i<`PC_WIDTH;i++) begin
            $display("cpu_state = %h",cpu_state);
            $display("inst_addr_stream = %b",inst_addr_stream);
            instr_add_reg <= {instr_add_reg[`PC_WIDTH-2:0], inst_addr_stream};
            #10000
            sys_clk = 1'b1;
            #10000  
            sys_clk = 1'b0;  
        end 
        $display("Completed receiving instruction address from CPU, CPU_STATE = %h",cpu_state);
        $display("instr_add_reg = %h",instr_add_reg);
        $display("Instruction at address: %h = %h", instr_add_reg, inst_mem[instr_add_reg]);
        
        $display("***************************************");
        $display("Sending instruction to CPU(%0d cycles, msb first) ",`INST_WIDTH);
        $display("CPU_STATE = %h",cpu_state);
        for(int i = 0; i<`INST_WIDTH;i++) begin
        $display("CPU_STATE = %h",cpu_state);
            instr_in = inst_mem[instr_add_reg][`INST_WIDTH-1-i];
            #10000
            $display(" i = %0d, instr_in bit = %b",i, instr_in);
            #10000
            sys_clk = 1'b1;
            #10000  
            sys_clk = 1'b0;  
        end 
        $display("Completed sending instruction address from CPU, CPU_STATE = %h",cpu_state);
        $display("***************************************");
        $display("Decoding instruction in CPU and populating decode registers ");
        $display("CPU_STATE = %h",cpu_state);
        #10000
        sys_clk = 1'b1;
        #10000  
        sys_clk = 1'b0;
        $display("Finished Decoding instruction in CPU and populating decode registers, CPU_STATE = %h",cpu_state);
        $display("***************************************");
        for(int j = 0; j < 32 ; j++) begin
            $display("____________________ i=%h________________",j);  
            if(cpu_state == `SEND_MPC) begin
                $display("Receiving micro-instruction address from CPU, cpu_state=%h",cpu_state);
                $display("CPU_STATE = %h",cpu_state);
                for(int i = 0; i<M_INST_ADDR_WIDTH;i++) begin
                    $display("cpu_state = %h",cpu_state);
                    $display("m_inst_addr_stream = %b",m_inst_addr_stream);
                    m_instr_add_reg <= {m_instr_add_reg[`M_INST_ADDR_WIDTH-2:0], m_inst_addr_stream};
                    #10000
                    sys_clk = 1'b1;
                    #10000  
                    sys_clk = 1'b0;  
                end 
                $display("Completed receiving micro-instruction address from CPU, CPU_STATE = %h",cpu_state);
                $display("m_instr_add_reg = %h",m_instr_add_reg);
                $display("Micro-Instruction at address: %h = %h", m_instr_add_reg, m_inst_mem[m_instr_add_reg]);
                $display("***************************************");
            end
            if(cpu_state == `FETCH_MINST) begin
                $display("Sending microinstruction to CPU, CPU_STATE = %h",cpu_state);
                for(int i = 0; i<`MINST_WIDTH;i++) begin
                $display("CPU_STATE = %h",cpu_state);
                    m_instr_in = m_inst_mem[m_instr_add_reg][`MINST_WIDTH-1-i];
                    #10000
                    $display(" i = %0d, m_instr_in bit = %b",`MINST_WIDTH-1-i, m_instr_in);
                    #10000
                    sys_clk = 1'b1;
                    #10000  
                    sys_clk = 1'b0;  
                end 
                $display("Completed Sending microinstruction to CPU, CPU_STATE = %h",cpu_state);
                $display("***************************************");
            end
            if(cpu_state == `DECODE_MINST) begin
                $display("Decoding micro-instruction in CPU and populating micro-decode registers ");
                $display("CPU_STATE = %h",cpu_state);
                #10000
                sys_clk = 1'b1;
                #10000  
                sys_clk = 1'b0;
                $display("Finished Decoding micro-instruction in CPU and populating micro-decode registers, CPU_STATE = %h",cpu_state);
                $display("***************************************");
            end
            if(cpu_state == `EXECUTE1) begin
                $display("In EXECUTE-1 state of Micro-instruction in CPU, CPU_STATE = %h",cpu_state);
                #10000
                
                sys_clk = 1'b1;
                #10000  
                sys_clk = 1'b0;
                $display("Completed EXECUTE-1 for Micro-instruction in CPU, CPU_STATE = %h",cpu_state);
                $display("***************************************");
            end
            if(cpu_state == `EXECUTE2) begin
                $display("In EXECUTE-2 state of Micro-instruction in CPU, CPU_STATE = %h",cpu_state);
                #10000
                sys_clk = 1'b1;
                #10000  
                sys_clk = 1'b0;  
                $display("Completed EXECUTE-2 for Micro-instruction in CPU, CPU_STATE = %h",cpu_state);
                $display("***************************************");
            end
        end
    end
endmodule
