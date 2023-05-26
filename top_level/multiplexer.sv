`default_nettype none

module multiplexer (
	input logic [11:0] io_in,
	output logic [11:0] io_out,

	input logic [5:0] des_sel,
	input logic hold_if_not_sel,
    input logic sync_inputs,

	output logic [11:0] des_io_in[0:63],
	output logic des_reset[0:63],
	input logic [11:0] des_io_out[0:63],

	input logic clock, reset
);

    logic [12:0] io_in_sync1, io_in_sync2, io_in_sync3;
    logic [63:0] des_sel_dec;
    always_ff @(posedge clock) begin
        // Select which project to activate.
        // One-hot decoded for simplicity of `hold_if_not_sel`
        des_sel_dec <= '0;
        des_sel_dec[des_sel] <= 1;

        // 3FF sync the inputs
        io_in_sync3 <= io_in_sync2;
        io_in_sync2 <= io_in_sync1;
        io_in_sync1 <= {reset, io_in};
    end

    integer i;
    always_comb begin
        io_out = '0;

        for (i = 0; i < 64; i++) begin
            if (des_sel_dec[i]) begin
                io_out = des_io_out[i];
            end

            // hold_if_not_sel will hold all others
            // in reset with all-zero inputs when set
            if (hold_if_not_sel && (!(des_sel_dec[i]))) begin
                des_io_in[i] = '0;
                des_reset[i] = '1;
            end

            else begin
                des_io_in[i] = (sync_inputs ? io_in_sync3[11:0] : io_in);
                des_reset[i] = (sync_inputs ? io_in_sync3[12] : reset);
            end
        end
    end

endmodule
