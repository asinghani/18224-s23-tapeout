module my_chip (
    input logic [11:0] io_in,
    output logic [11:0] io_out,
    input logic clock,
    input logic reset
);
    design_instantiations dut (
        .io_in, .io_out,
        .clock, .reset,
        .des_sel(6'd`DES_NUM), .hold_if_not_sel(1'b0),
        .sync_inputs(1'b0)
    );

endmodule
