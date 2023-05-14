// Types, constants, and functions used in the design
`default_nettype none

typedef enum logic [2:0] {
  IoNone      = 3'b000,   // No output on bus
  IoOpcode    = 3'b001,   // Outputting opcode
  IoAddrHi    = 3'b010,   // Outputting Address MSB
  IoAddrLo    = 3'b011,   // Outputting Address LSB
  IoReadWrite = 3'b100    // Outputting write / inputting read (waits until done)
} IoOp;

typedef enum logic [2:0] {
  BusNone       = 3'b000, // No operation
  BusReadProg   = 3'b010, // Read program memory
  BusReadData   = 3'b100, // Read data memory
  BusWriteData  = 3'b101, // Write data memory
  BusReadIo     = 3'b110, // Read IO
  BusWriteIo    = 3'b111  // Write IO
} BusOp;

typedef enum logic [1:0] {
  AddrNone,
  AddrPc,
  AddrCursor
} AddrSrc;

typedef enum logic [1:0] {
  ValNone,
  ValAcc,
  ValAccInc,
  ValAccDec
} ValSrc;

typedef enum logic [1:0] {
  PcKeep,
  PcInc,
  PcDec
} PcOp;

typedef enum logic [1:0] {
  CursorKeep,
  CursorInc,
  CursorDec
} CursorOp;

typedef enum logic {
  AccKeep,
  AccLoad
} AccOp;

typedef enum logic [1:0] {
  DepthKeep,
  DepthClear,
  DepthInc,
  DepthDec
} DepthOp;

typedef struct packed {
  BusOp bus_op;
  AddrSrc addr_src;
  ValSrc val_src;
  PcOp pc_op;
  CursorOp cursor_op;
  AccOp acc_op;
  DepthOp depth_op;
} Ucode;

typedef enum logic [5:0] {
  // Misc
  Fetch,
  Decode,
  Halt,

  // Inc "+"
  IncFetch,
  IncLoad,
  IncStore,

  // Dec "-"
  DecFetch,
  DecLoad,
  DecStore,

  // Right ">"
  Right,

  // Left "<"
  Left,

  // Print "."
  PrintFetch,
  PrintLoad,
  PrintStore,

  // Read ","
  ReadFetch,
  ReadLoad,
  ReadStore,

  // Brz "["
  BrzFetchVal,
  BrzDecodeVal,
  BrzFetchInstr,
  BrzDecodeInstr,
  BrzInc,
  BrzDec,

  // Brnz "]"
  BrnzFetchVal,
  BrnzDecodeVal,
  BrnzPcDec1,
  BrnzPcDec2,
  BrnzFetchInstr,
  BrnzDecodeInstr,
  BrnzInc,
  BrnzDec,
  BrnzPcInc1,
  BrnzPcInc2
} BFState;

// Simple max function for determining port sizes
function integer max(integer a, integer b);
  max = (a > b) ? a : b;
endfunction
