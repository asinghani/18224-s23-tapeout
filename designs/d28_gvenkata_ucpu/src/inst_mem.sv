`include "defines.vh"

module inst_addr_serialise (
    sys_clk,
    sys_reset,
    cpu_state,
    //Input instruction addr
    inst_addr,
    //Output micro-instruction stream
    inst_addr_stream
);

    input sys_clk, sys_reset;
    input [$clog2(`CPU_STATES)-1:0] cpu_state;
    input [`PC_WIDTH-1:0] inst_addr;
    output inst_addr_stream;
    
    reg [$clog2(`PC_WIDTH)-1:0] current_bit_index;

    assign inst_addr_stream = (sys_reset == 1'b1) ? 1'b0 : (( cpu_state == `SEND_PC ) ? inst_addr[current_bit_index] : 1'b0);

    always @(posedge sys_clk) begin
        if(sys_reset) begin
           current_bit_index <= (1<<$clog2(`PC_WIDTH)) -1;
        end
        else begin
            //Begin sending the address bits in a serial fashion
            if(cpu_state == `SEND_PC) begin
                current_bit_index <= current_bit_index - 1'b1;
            end
        end
    end
endmodule

/*
    Module accepts 32 bits of instruction serially
    Order of bits: most significant bit first
*/
module instr_reg_interface (
    sys_clk,
    instr_in,
    instr_reg,
    sys_reset,
    enable
);
    input instr_in, sys_clk, sys_reset, enable;
    output reg [`INST_WIDTH-1:0] instr_reg;
    
    always @(posedge sys_clk) begin
        if(sys_reset == 1'b1) begin
            instr_reg <= 32'b0;
        end
        else begin
            if(enable) begin
                instr_reg <= {instr_reg[30:0], instr_in};
            end
        end
    end
endmodule

/*
    Micro-instruction address generator
*/
module  m_inst_addr_gen #(
    parameter M_INST_ADDR_WIDTH = 9,
    parameter M_INST_START_ADDR = 0,
    parameter INSTR_TYPE = 5
) (
    instr_in, 
    m_inst_addr_base 
);
    input [`INST_WIDTH-1:0] instr_in;
    output [M_INST_ADDR_WIDTH-1:0] m_inst_addr_base;
    wire [INSTR_TYPE-1:0] instr_type;
    reg [M_INST_ADDR_WIDTH-1:0] offset;
    assign instr_type = instr_in[31:27];
    always @(*) begin 
        case (instr_type)
            /*3 address format ALU instructions*/
            /*add, sub, and, or, lsl, lsr, asr*/
            5'b00000: offset =  0;
            5'b00001: offset =  32;
            5'b00110: offset =  64;
            5'b00111: offset =  96;
            5'b01001: offset =  128;
            5'b01010: offset =  160;
            5'b01011: offset =  192;
            5'b01100: offset =  224;
            /*2 address format ALU instructions*/
            /*cmp, not*/
            5'b00101: offset = 256;
            5'b01000: offset = 288;
            /*Branch - beq, bgt, b*/
            5'b10000: offset = 320;
            5'b10001: offset = 352;
            5'b10010: offset = 384;
            /*nop*/
            5'b01101: offset = 416;
            /*ld,st*/
            5'b01110: offset = 448;
            5'b01111: offset = 480;
            default: offset = 0;
        endcase
    end
    assign m_inst_addr_base = offset;
endmodule

/*
    This module blindly sends out the address bits 
    to the output port on every clock edge when 
    1. reset is off 
    2. cpu_state == FETCH
    
    Order: MSb First
*/

module m_inst_addr_serialise #(
      
    parameter M_INST_ADDR_WIDTH = 9
) (
    sys_clk,
    sys_reset,
    cpu_state,
    //Input micro-instruction addr
    m_inst_addr,
    //Output micro-instruction stream
    m_inst_addr_stream
);

    input sys_clk, sys_reset;
    input [$clog2(`CPU_STATES)-1:0] cpu_state;
    input [M_INST_ADDR_WIDTH-1:0] m_inst_addr;
    output m_inst_addr_stream;
    
    reg [$clog2(M_INST_ADDR_WIDTH)-1:0] current_bit_index;

    assign m_inst_addr_stream = (sys_reset == 1'b1) ? 1'b0 : (( cpu_state == `SEND_MPC ) ? m_inst_addr[current_bit_index] : 1'b0);

    always @(posedge sys_clk) begin
        if(sys_reset) begin
           //m_inst_addr_stream <= 1'b0;
           //TODO: parametrize
           current_bit_index <= (M_INST_ADDR_WIDTH) - 1'b1;
        //    current_bit_index <= (1<<$clog2(M_INST_ADDR_WIDTH)) - 1'b1;
        end
        else begin
            //Begin sending the address bits in a serial fashion
            if(cpu_state == `SEND_MPC) begin
                current_bit_index <= current_bit_index - 1'b1;
            end
            else begin
                current_bit_index <= (M_INST_ADDR_WIDTH) - 1'b1;
            end
        end
    end
endmodule

module m_instr_reg (
    sys_clk,
    minstr_in,
    m_instr_reg,
    sys_reset,
    enable
);
    input minstr_in, sys_clk, sys_reset, enable;
    output reg [`MINST_WIDTH-1:0] m_instr_reg;
    
    always @(posedge sys_clk) begin
        if(sys_reset == 1'b1) begin
            //Hardcoded width
            m_instr_reg <= 44'b0;
        end
        else begin
            if(enable) begin
                m_instr_reg <= {m_instr_reg[42:0], minstr_in};
            end
        end
    end
endmodule

module m_pc_reg (
    sys_clk,
    sys_reset,
    load_m_pc_en,
    next_m_pc,
    m_pc
);
    input sys_clk, sys_reset;
    input load_m_pc_en;
    input [`MPC_WIDTH-1:0] next_m_pc;
    output reg [`MPC_WIDTH-1:0] m_pc;
    always @(posedge sys_clk) begin
        if(sys_reset == 1'b1) begin
            //Hardcoded width
            m_pc <= 8'b0;
        end
        else begin
            if(load_m_pc_en) begin
                m_pc <= next_m_pc;
            end
        end
    end
endmodule

module pc_reg (
    sys_clk,
    sys_reset,
    load_pc_en,
    next_pc,
    pc
);
    input sys_clk, sys_reset;
    input load_pc_en;
    input [`PC_WIDTH-1:0] next_pc;
    output reg [`PC_WIDTH-1:0] pc;
    always @(posedge sys_clk) begin
        if(sys_reset == 1'b1) begin
            //Hardcoded width
            pc <= 8'b0;
        end
        else begin
            if(load_pc_en) begin
                pc <= next_pc;
            end
        end
    end
endmodule
