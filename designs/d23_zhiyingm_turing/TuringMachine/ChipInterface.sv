module hex_to_sevenseg (
    input logic [3:0] hexdigit,
    output logic [7:0] seg
);

    always_comb begin
        seg = '1;
        if (hexdigit == 4'h0) seg = 8'b1100_0000;
        if (hexdigit == 4'h1) seg = 8'b1111_1001;
        if (hexdigit == 4'h2) seg = 8'b1010_0100;
        if (hexdigit == 4'h3) seg = 8'b1011_0000;
        if (hexdigit == 4'h4) seg = 8'b1001_1001;
        if (hexdigit == 4'h5) seg = 8'b1001_0010;
        if (hexdigit == 4'h6) seg = 8'b1000_0010;
        if (hexdigit == 4'h7) seg = 8'b1111_1000;
        if (hexdigit == 4'h8) seg = 8'b1000_0000;
        if (hexdigit == 4'h9) seg = 8'b1001_0000;
        if (hexdigit == 4'hA) seg = 8'b1000_1000;
        if (hexdigit == 4'hB) seg = 8'b1000_0011;
        if (hexdigit == 4'hC) seg = 8'b1100_0110;
        if (hexdigit == 4'hD) seg = 8'b1010_0001;
        if (hexdigit == 4'hE) seg = 8'b1000_0110;
        if (hexdigit == 4'hF) seg = 8'b1000_1110;
    end

endmodule


module ChipInterface (
    input logic CLOCK_50,
    input logic [3:0] KEY,
    input logic [17:0] SW,
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
    output logic [17:0] LEDR,
    output logic [7:0] LEDG
);
    
    logic [5:0] input_data;
    logic clock, reset, Next, Done;
    logic [10:0] display_out;
    logic Compute_done;

    logic [3:0] state;
    logic tape_reg_out, data_reg_out;
    logic [1:0] direction_out;
    logic [5:0] next_state_out, tape_addr_out;

    // Synchronizer sync0 (.async(btn[2]), .sync(clock), .clock(clk));
    Synchronizer sync1 (.async(~KEY[0]), .sync(Next), .clock);
    Synchronizer sync2 (.async(~KEY[1]), .sync(Done), .clock);
    Synchronizer sync3 (.async(SW[0]), .sync(input_data[0]), .clock);
    Synchronizer sync4 (.async(SW[1]), .sync(input_data[1]), .clock);
    Synchronizer sync5 (.async(SW[2]), .sync(input_data[2]), .clock);
    Synchronizer sync6 (.async(SW[3]), .sync(input_data[3]), .clock);
    Synchronizer sync7 (.async(SW[4]), .sync(input_data[4]), .clock);
    Synchronizer sync8 (.async(SW[5]), .sync(input_data[5]), .clock);
    
    TuringMachine TM (.*);

    assign clock = CLOCK_50;
    assign reset = ~KEY[2];
    assign LEDR[10:0] = display_out;
    assign LEDR[11] = Compute_done;
    assign LEDR[17:12] = tape_addr_out;

    hex_to_sevenseg hex(.hexdigit(state), .seg(HEX0));

    assign LEDG[0] = tape_reg_out;
    assign LEDG[1] = data_reg_out;
    assign LEDG[4:3] = direction_out;
    assign LEDG[7:5] = next_state_out;

endmodule