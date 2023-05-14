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
