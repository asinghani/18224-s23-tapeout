`default_nettype none

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);
    
 S444_Cell s444(
     .feed0_out(io_out[0]),
     .feed1_out(io_out[1]),
     .main_out(io_out[2]),
     .dff0_out(io_out[3]),
     .dff1_out(io_out[4]),
     .sum_out(io_out[8]),
     .c_out(io_out[9]),

     .feed0(io_in[3:0]),
     .feed1({io_in[4], io_in[2:0]}),
     .main(io_in[8:5]),
     .c_in(io_in[9]),
  
     .shift_out(io_out[10]),
     .shift_in(io_in[10]),
     .clk(clock),
     .en(io_in[11]),
     .reset(reset));

 assign io_out[7:5] = 3'b000;
 assign io_out[11] = 1'b0;

endmodule
