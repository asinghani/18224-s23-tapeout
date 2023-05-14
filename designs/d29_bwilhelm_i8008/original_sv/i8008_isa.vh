

`ifndef I8008_ISA_VH_
`define I8008_ISA_VH_

/*----------------------------------------------------------------------------
 * Opcodes (All Instruction Types)
 *----------------------------------------------------------------------------*/

    // typedef enum logic [2:0] {
    //     Lo_MEM = 3'b111,
    //     Lo_IMM_CAL = 3'b110,
    //     Lo_MACH = 3'b00x,
    //     Lo_DC = 3'bxxx
    // } D2_0_t;

    // typedef enum logic [2:0] {
    //     Lo_JXc = 3'b000,
    //     Lo_CXc = 3'b010,
    //     Lo_JMP = 3'b100,
    //     Lo_CAL = 3'b110,
    //     Lo_IO = 3'bxx1
    // } IO_CTRL_Lo_t;

    // typedef enum logic [2:0] {
    //     Lo_INr = 3'b000,
    //     Lo_DCr = 3'b001,
    //     Lo_ROT = 3'b010,
    //     Lo_RXc = 3'b011,
    //     Lo_ALU = 3'b100,
    //     Lo_RST = 3'b101,
    //     Lo_LOAD = 3'b110,
    //     Lo_RET = 3'b111
    // } IMM_MISC_Lo_t;

    // typedef enum logic [2:0] {
    //     Hi_RLC = 3'b000,
    //     Hi_RRC = 3'b001,
    //     Hi_RAL = 3'b010,
    //     Hi_RAR = 3'b011
    // } IMM_MISC_Hi_t;

    // typedef enum logic [2:0] {
    // } LOAD_Lo_t;

    // typedef enum logic [2:0] {
    // } ALU_IND_MEM_Lo_t;

    // typedef enum logic [2:0] {
    //     ADx = 3'b000,
    //     ACx = 3'b001,
    //     SUx = 3'b010,
    //     SBx = 3'b011,
    //     NDx = 3'b100,
    //     XRx = 3'b101,
    //     ORx = 3'b110,
    //     CPx = 3'b111
    // } ALU_IND_MEM_Hi_t;

    // typedef enum logic [2:0] {
    //     Hi_MEM = 3'b111,
    //     Hi_MACH = 3'b000,
    //     Hi_DC = 3'bxxx
    // } D5_3_t;

    // typedef enum logic [1:0] {
    //     LOAD = 2'b11,
    //     ALU_IND_MEM = 2'b10,
    //     IO_CTRL = 2'b01,
    //     IMM_MISC = 2'b00
    // } D7_6_t;

    typedef enum logic [7:0] {
        // Index register instructions
        Lr1r2 = 8'b11_???_???,      // Load r1 with r2
        LrM = 8'b11_???_111,        // Load r with Mem
        LMr = 8'b11_111_???,        // Load Mem with r
        LrI = 8'b00_???_110,        // Load r with Immediate
        LMI = 8'b00_111_110,        // Load Mem with Immediate
        INr = 8'b00_???_000,        // Increment r (r != A)
        DCr = 8'b00_???_001,        // Decrement r (r != A)

        ALU_op = 8'b10_???_???,
        ALUM = 8'b10_???_111,
        ALUI = 8'b00_???_100,

        // Accumulator group instructions
        ADr = 8'b10_000_???,        // Add contents to A, set carry
        ADM = 8'b10_000_111,
        ADI = 8'b00_000_100,

        ACr = 8'b10_001_???,        // Add contents + carry to A
        ACM = 8'b10_001_111,
        ACI = 8'b00_001_100,

        SUr = 8'b10_010_???,        // Subtract contents from A, set carry
        SUM = 8'b10_010_111,
        SUI = 8'b00_010_100,

        SBr = 8'b10_011_???,        // Subtract contents from A, subtract borrow, set carry
        SBM = 8'b10_011_111,
        SBI = 8'b00_011_100,

        NDr = 8'b10_100_???,        // Logical AND of contents with accumulator
        NDM = 8'b10_100_111,
        NDI = 8'b00_100_100,

        XRr = 8'b10_101_???,        // Logical XOR of contents with accumulator
        XRM = 8'b10_101_111,
        XRI = 8'b00_101_100,

        ORr = 8'b10_110_???,        // Logical OR of contents with accumulator
        ORM = 8'b10_110_111,
        ORI = 8'b00_110_100,

        CPr = 8'b10_111_???,        // Compare contents with accumulator, accumulator unaffected. Sub sets flags
        CPM = 8'b10_111_111,
        CPI = 8'b00_111_100,

        RLC = 8'b00_000_010,        // Rotate accumulator left
        RRC = 8'b00_001_010,        // Rotate accumulator right
        RAL = 8'b00_010_010,        // Rotate accumulator left through carry
        RAR = 8'b00_011_010,        // Rotate accumulator right through carry

        //  = 8'bPC and stack control instructions
        JMP = 8'b01_???_100,        
        JFc = 8'b01_0??_000,        // Jump to B3B2 if false, else continue
        JTc = 8'b01_1??_000,
        CAL = 8'b01_???_110,       
        CFc = 8'b01_0??_010,        // Call subroutine at B3B2 if false, move up in stack, else continue
        CTc = 8'b01_1??_010,
        RET = 8'b00_???_111,    
        RFc = 8'b00_0??_011,        // Return down a level of the stack if false, else continue
        RTc = 8'b00_1??_011,
        RST = 8'b00_???_101,

        //  = 8'bI/O instructions
        INP = 8'b01_00?_??1,        // Read contents of input port into accumulator
        OUT = 8'b01_???_??1,        // Write accumulator into output port, RRMMM, RR != 0

        //  = 8'bMachine
        HLT0 = 8'b00_000_00?,         // Enter stopped state until interrupted
        HLT1 = 8'b11_111_111,         // Enter stopped state until interrupted

        INVALID = 'bx     // Instruction unrecognized
    } instr_t;

`endif 