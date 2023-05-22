`default_nettype none

module multiplexer (
	input logic [11:0] io_in,
	output logic [11:0] io_out,

	input logic [5:0] des_sel,
	input logic hold_if_not_sel,

	output logic [11:0] des_io_in[0:63],
	output logic des_reset[0:63],
	input logic [11:0] des_io_out[0:63],

	input logic clock, reset
);

    logic [63:0] des_sel_dec;
    always_ff @(posedge clock) begin
        des_sel_dec <= '0;
        des_sel_dec[des_sel] <= 1;
    end

    integer i;
    always_ff @(posedge clock) begin
        io_out <= '0;

        for (i = 0; i < 64; i++) begin
            if (des_sel_dec[i]) begin
                io_out <= des_io_out[i];
            end

            // hold_if_not_sel will hold all other designs
            // in reset with all-zero inputs when set
            if (hold_if_not_sel && (!des_sel_dec[i])) begin
                des_io_in[i] <= '0;
                des_reset[i] <= '1;
            end

            else begin
                des_io_in[i] <= io_in;
                des_reset[i] <= reset;
            end
        end
    end

endmodule
