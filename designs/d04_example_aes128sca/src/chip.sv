`default_nettype none

module my_chip (
    input logic [11:0] io_in, 
    input logic clock, reset,
    output logic [11:0] io_out
);

    wire [7:0] byte_in = io_in[7:0];
    wire key_in = io_in[8];
    wire plaintext_in = io_in[9];
    wire start = io_in[10];

    logic [7:0] byte_out;
    logic is_active;

    assign io_out = {3'b0, is_active, byte_out};

    logic [6:0] state;
    assign is_active = (state != 0);

    logic [127:0] key, plaintext, internal;

    logic [7:0] sbox_out;

    sbox sbox (
        .sbox_in(internal[state - 22]),
        .sbox_out
    );

    logic key_in_last, plaintext_in_last;
    always_ff @(posedge clock) begin
        key_in_last <= key_in;
        plaintext_in_last <= plaintext_in;

        if (key_in && !key_in_last) 
            key <= {key, byte_in};

        if (plaintext_in && !plaintext_in_last) 
            plaintext <= {plaintext, byte_in};
    end

    always_ff @(posedge clock) begin
        if (reset) begin
            state <= 0;
        end

        if (state > 1) begin
            state <= state - 1;
        end

        if ((state == 1) && !start) begin
            state <= 0;
        end
        
        if ((state == 0) && start) begin
            state <= 50;
        end

        // AddRoundKey step
        if (state == 40) begin
            internal <= key ^ plaintext;
        end

        if (state >= 22 && state < 38) begin
            internal[state - 22] <= sbox_out;
        end

        if (state >= 4 && state < 20) begin
            byte_out <= internal[state - 4];
        end
    end


endmodule
