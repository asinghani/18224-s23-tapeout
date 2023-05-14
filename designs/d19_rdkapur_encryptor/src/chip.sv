`default_nettype none
module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);
    
    mychip_wrapper wrapper (.mode_sel(io_in[1:0]),.display_sel(io_in[5:2]),.in_bit(io_in[6]),.ready(io_in[7]), .hex_out(io_out[7:0]), .clock(clock), .reset(reset)); 
    assign io_out [11:8] = 4'b0000; 
    
endmodule
