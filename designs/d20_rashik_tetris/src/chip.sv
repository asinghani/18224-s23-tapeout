`default_nettype none

module random_tetromino (
    input logic clk, reset, new_piece_en,
    output logic [15:0] rand_piece);

    logic [2:0] rand_num;
    logic [3:0] block0, block1, block2, block3;
    assign rand_num = 0;

    always_comb begin
        case (rand_num)
            // I 
            3'd0: begin
                block0 = 4'b00_00;
                block1 = 4'b01_00;
                block2 = 4'b10_00;
                block3 = 4'b11_00;
            end 
            // O
            3'd1: begin
                block0 = 4'b00_00;
                block1 = 4'b01_00;
                block2 = 4'b00_01;
                block3 = 4'b01_01;
            end
            // T
            3'd2: begin
                block0 = 4'b00_00;
                block1 = 4'b01_00;
                block2 = 4'b10_00;
                block3 = 4'b01_01;
            end
            // J
            3'd3: begin
                block0 = 4'b01_00;
                block1 = 4'b01_01;
                block2 = 4'b01_10;
                block3 = 4'b00_01;
            end
            // L
            3'd4: begin
                block0 = 4'b00_00;
                block1 = 4'b00_01;
                block2 = 4'b00_10;
                block3 = 4'b01_10;
            end
            // S
            3'd5: begin
                block0 = 4'b01_00;
                block1 = 4'b10_00;
                block2 = 4'b00_01;
                block3 = 4'b01_01;
            end
            // Z
            3'd6: begin
                block0 = 4'b00_00;
                block1 = 4'b01_00;
                block2 = 4'b01_01;
                block3 = 4'b10_01;
            end
            default: begin
                block0 = 4'b00_00;
                block1 = 4'b00_00;
                block2 = 4'b00_00;
                block3 = 4'b00_00;
            end
        endcase
    end

    always_ff @(posedge clk)
        if (reset) begin 
            rand_piece = 16'd0;
        end
        else if (new_piece_en) 
            rand_piece <= {block0, block1, block2, block3};
        else 
            rand_piece <= rand_piece;

endmodule: random_tetromino

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);
    logic clk, read_gs, left, right;
    assign {left, right, read_gs} = io_in[3:0];
    assign clk = clock;

    logic [127:0] game_state;

    // Control points
    logic new_piece_en;

    logic [6:0] x; 
    logic [6:0] y;
    logic [15:0] rand_piece; // each block of the teromino is [3:0], [7:4], [11:8], [15:12]

    // Generate random tetromino and update the the piece state of the falling tetromino
    // random_tetromino (.clk, .reset, .new_piece_en, .rand_piece);
    assign rand_piece = {4'b00_00, 4'b00_01, 4'b00_10, 4'b01_10};

    logic [127:0] piece_state, fallen_state;

    always_comb begin
        piece_state = 128'd0;
        piece_state[(x + {5'd0, rand_piece[3:2]}) + ((y + {5'd0, rand_piece[1:0]}) << 3)] = 1'b1;
        piece_state[(x + {5'd0, rand_piece[7:6]}) + ((y + {5'd0, rand_piece[5:4]}) << 3)] = 1'b1;
        piece_state[(x + {5'd0, rand_piece[11:10]}) + ((y + {5'd0, rand_piece[9:8]}) << 3)] = 1'b1;
        piece_state[(x + {5'd0, rand_piece[15:14]}) + ((y + {5'd0, rand_piece[13:12]}) << 3)] = 1'b1;
    end

    // Collision detection
    // Check bottom of the board
    // logic collision;
    // always_comb begin
    //     if (y == 7'd16) begin
    //         collision = 1'b1;
    //     end
    // end

    // Fallen pieces register. When a collision occurs this is updated.
    always_ff @(posedge clk)
        if (reset) fallen_state <= 128'd0;
        else fallen_state <= fallen_state; 

    // Y position register. Y position is incremented on every clock edge.
    always_ff @(posedge clk)
        if (reset) y <= 7'd0;
        else y <= y + 7'd1;

    // X position register. Update x position depending on left and right button inputs
    always_ff @(posedge clk)
        if (reset) x <= 4'd0;
        else if (left) x <= x + 7'd1;
        else if (right)  x <= x - 7'd1;
        else x <= x;

    assign game_state = fallen_state | piece_state; 

    // Shift out 
    logic [6:0] idx;
    logic [7:0] iout;
    assign iout = game_state >> idx;
    
    always_ff @(posedge clk)
        if (reset) idx <= 7'd0;
        else if (read_gs) begin
            io_out[8:0] <= iout;
            idx <= idx + 7'd8;
        end

endmodule
