`ifndef INTERNAL_DEFINES_VH_
`define INTERNAL_DEFINES_VH_

`define DATA_WIDTH = 8;

// The current state of proc, also to be output
typedef enum logic [2:0] {
    T1 = 3'b010,
    T1I = 3'b110,
    T2 = 3'b100,
    WAIT = 3'b000,
    T3 = 3'b001,
    STOPPED = 3'b011,
    T4 = 3'b111,
    T5 = 3'b101,
    INVALID_STATE = 3'bxxx
} state_t;

// The memory cycle number, needed to determine state transitions
typedef enum logic [1:0] {
    CYCLE1 = 2'b00,
    CYCLE2 = 2'b01,
    CYCLE3 = 2'b10
} cycle_t;

typedef enum logic [1:0] {
    PCI = 2'b00,    // Designates the address is for a memory read (first byte of instruction)
    PCR = 2'b01,    // Designates the address is for a memory read data (additional bytes of instruction or data)
    PCC = 2'b10,    // Designates the data as a command I/O operation
    PCW = 2'b11     // Designates the address is for a memory write data
} cycle_ctrl_t;

typedef enum logic [2:0] {
    Acc = 3'd0,
    //B = 3'd1,
    //C = 3'd2,
    //D = 3'd3,
    //E = 3'd4,
    Hi = 3'd5,      // Upper 6 bits of external register stored here
    Lo = 3'd6,      // Lower 8 bits of external register stored here
    ILLEGAL = 3'd7  // Cannot use this, reserved for instructions
} reg_t;

typedef struct packed {
    logic CARRY;
    logic ZERO;
    logic SIGN;
    logic PARITY;
} flags_t;

typedef enum logic [3:0] {
    CARRY_bit = 4'b0001,
    ZERO_bit  = 4'b0010,
    SIGN_bit  = 4'b0100,
    PARITY_bit  = 4'b1000
} flag_bit_t;

typedef enum logic [1:0] {
    Ca = 2'b00,
    Ze = 2'b01,
    Si = 2'b10,
    Pa = 2'b11
} flag_enc_t;

typedef enum logic {
    PC_L = 1'b1,
    PC_H = 1'b0
} PC_t;

typedef enum logic [2:0] {
    ADD_op = 3'b000,            // Addition
    ADDC_op = 3'b001,            // Addition
    SUB_op = 3'b010,            // Subtraction
    SUBC_op = 3'b011,            // Subtraction
    AND_op = 3'b100,            // Logical And
    XOR_op = 3'b101,            // Exclusive Or
    OR_op = 3'b110,             // Inclusive Or
    CMP_op = 3'b111
} alu_op_t;

typedef enum logic [2:0] {
    RLC_op = 3'b000,
    RRC_op = 3'b001,
    RAL_op = 3'b010,
    RAR_op = 3'b011,
    ADD1_op = 3'b100,
    SUB1_op = 3'b101
} arith_op_t;

typedef struct packed {
    logic re;                    //
    logic we;                    //
    logic clr;
} reg_ctrl_t;

typedef struct packed {
    logic re;                  //
    alu_op_t alu_op;               // Operation for ALU to perform
    arith_op_t arith_op;
    logic ARITH;
    logic en_Flag;
    logic clr_Flag;
} ALU_ctrl_t;

typedef struct packed {
    logic [2:0] sel; //
    logic re;                   //
    logic we;                   //
} rf_ctrl_t;

typedef struct packed {
    logic en_SP;                   //
    logic clr_SP;                  //
    logic inc_SP;                  //
} SP_ctrl_t;

typedef struct packed {
    logic we_Stack;                //
    logic re_Stack;                //
    logic lower;
    logic inc_PC;
    logic D5_3;

    cycle_ctrl_t cycle_ctrl;
} Stack_ctrl_t;

typedef struct packed {
    reg_ctrl_t DBR;

    reg_ctrl_t IR;

    reg_ctrl_t A;
    reg_ctrl_t B;
    reg_ctrl_t flags;

    ALU_ctrl_t ALU;

    rf_ctrl_t rf_ctrl;

    SP_ctrl_t SP_ctrl;
    Stack_ctrl_t Stack_ctrl;
} ctrl_signals_t;

`endif
