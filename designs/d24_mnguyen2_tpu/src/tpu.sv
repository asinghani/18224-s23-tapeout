`default_nettype none
`include "defines.vh"

module tpu
#(parameter MATRIX_DIM=32,
  parameter CONV_DIM=3)
 (input  logic clk, rst,
  input  logic insert_kernal, write_mode, write, ready,
  input  data_t data_in,
  output logic done,
  output data_t data_out);

  typedef struct packed {
    logic [$clog2(MATRIX_DIM)-1:0] x,y;
  } base_coord_t;

  typedef struct packed {
    logic [$clog2(MATRIX_DIM):0] x,y;
  } matrix_coord_t;

  typedef struct packed {
    logic [$clog2(CONV_DIM)-1:0] x,y;
  } conv_coord_t;

  // KERNAL LOGIC
  // HACK: Yosys doesn't support packed arrays https://github.com/YosysHQ/yosys/issues/340
  data_t kernal_data;
  conv_coord_t kernal_addr;
  logic [($clog2(CONV_DIM*CONV_DIM))-1:0] kernal_data_sel;
  always_comb begin
    kernal_data_sel = kernal_addr.y * CONV_DIM
                      + {{$clog2(CONV_DIM){1'b0}},kernal_addr.x};
  end

  matrix #(.MATRIX_DIM(CONV_DIM))
         KERNAL_MAT(.clk, .rst, .we(insert_kernal & write),
                    .D(data_in), .Q(kernal_data),
                    .addr(kernal_data_sel));
  // MATRIX LOGIC
  // HACK: Yosys doesn't support packed arrays https://github.com/YosysHQ/yosys/issues/340
  data_t matrix_data;
  matrix_coord_t matrix_addr;
  logic [($clog2(MATRIX_DIM*MATRIX_DIM))-1:0] matrix_data_sel;
  always_comb begin
    if (write_mode & ~insert_kernal)
    matrix_data_sel = base_addr.y[$clog2(MATRIX_DIM)-1:0] *  MATRIX_DIM
                    + {{$clog2(MATRIX_DIM){1'b0}}, base_addr.x[$clog2(MATRIX_DIM)-1:0]};
    else
    matrix_data_sel = matrix_addr.y[$clog2(MATRIX_DIM)-1:0] *  MATRIX_DIM
                    + {{$clog2(MATRIX_DIM){1'b0}}, matrix_addr.x[$clog2(MATRIX_DIM)-1:0]};
  end
  matrix #(.MATRIX_DIM(MATRIX_DIM))
         MATRIX_MAT(.clk, .rst, .we(~insert_kernal & write),
                    .D(data_in), .Q(matrix_data),
                    .addr(matrix_data_sel));


  // CONVOLUTION CONTROL
  base_coord_t base_addr;

  logic kernal_y_incr, kernal_x_incr;
  assign kernal_x_incr = (write_mode & write & insert_kernal & ready) | ~(write_mode);
  assign kernal_y_incr = kernal_addr.x == CONV_DIM-1;
  counter #($bits(kernal_addr.x), CONV_DIM-1)
          kernal_addr_x_counter(.clk, .rst, .en(kernal_x_incr), .Q(kernal_addr.x));
  counter #($bits(kernal_addr.y), CONV_DIM-1)
          kernal_addr_y_counter(.clk, .rst, .en(kernal_y_incr), .Q(kernal_addr.y));

  logic base_y_incr, base_x_incr;
  assign base_x_incr = ((& kernal_y_incr) & ~write_mode) |
                        (write_mode & write & ~insert_kernal);
  assign base_y_incr = base_addr.x == MATRIX_DIM-1;
  counter #($bits(base_addr.x)) base_addr_x_counter(.clk, .rst, .en(base_x_incr), .Q(base_addr.x));
  counter #($bits(base_addr.y)) base_addr_y_counter(.clk, .rst, .en(base_y_incr), .Q(base_addr.y));

  parameter DIFF = $clog2(MATRIX_DIM)-$clog2(CONV_DIM);
  assign matrix_addr.x = base_addr.x + {{DIFF{1'b0}}, kernal_addr.x};
  assign matrix_addr.y = base_addr.y + {{DIFF{1'b0}}, kernal_addr.y};

  // MAC LOGIC
  // TODO: double check reset logic and its interaction with Done/Ready
  logic mac_en, mac_rst;
  assign mac_rst = (base_x_incr & ready) | rst;
  assign done = mac_rst & ~rst;
  assign mac_en = ~matrix_addr.x[$clog2(MATRIX_DIM)] & ~matrix_addr.y[$clog2(MATRIX_DIM)] & ~write_mode;
  mac #(`DATA_WIDTH,`DATA_WIDTH)
      conv_mac (.clk, .rst(mac_rst), .en(mac_en),
                .a(kernal_data),
                .b(matrix_data),
                .sum(data_out));
  // github synthesis workflow seems to break when it sees assertions
`ifdef SIMULATION
  assertKernalData : assert property
    (isKnown(kernal_data, rst, (mac_en & ~write_mode), clk))
    else $error("kernal data is unknown");
  assertmatrixData : assert property
    (isKnown(matrix_data, rst, (mac_en & ~write_mode), clk))
    else $error("matrix data is unknown");

  property isKnown(signal, reset, en, clock);
    @(posedge clock) (!reset  && en)|-> !$isunknown(signal);
  endproperty : isKnown
`endif //SIMULATION
endmodule : tpu
