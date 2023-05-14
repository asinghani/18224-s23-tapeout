`default_nettype none

`define REGCOUNT 24

//Top level module for design
module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);
    
    logic SCL_in, SDA_in, SDA_out;
    logic [7:0] reg_out;
    logic [8*`REGCOUNT-1:0] registers_packed;
    logic SDA_out_temp;

    logic [10:0] data_out;

    assign SCL_in = io_in[0];
    assign SDA_in = io_in[1];

    I2C M1 (.SCL_in, .SDA_in, .clock, .reset, .SDA_out(SDA_out_temp), .reg_out, 
            .registers_packed, .parallel_in(io_in[11:4]), .addr_sel(io_in[3:2]));

    IO  M2 (.registers_packed, .data_out, .clock, .reset);

    assign SDA_out = ~SDA_out_temp;

    assign io_out[11:1] = data_out;
    assign io_out[0] = SDA_out; 


endmodule
