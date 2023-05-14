module Register
  #(parameter WIDTH = 3)
  (input  logic [WIDTH-1:0] D,
   input  logic             en, clear, clock,
   output logic [WIDTH-1:0] Q);

  always_ff @(posedge clock)
    if (clear) Q <= '0;
    else if (en) Q <= D;
    else Q <= Q;

endmodule: Register

module random_number (
    input  logic       clear, clock,
    output logic [3:0] Q
);

  logic val;
  assign val = Q[3] ^ Q[0];

  always_ff @(posedge clock)
      if (clear) Q <= 4'hf;
      else Q <= {Q[2:0], val};

endmodule: random_number

module ttt_game_control (
    input  logic b0, b1, b2, b3, b4, b5, b6, b7, b8, player_sel, start,
    input  logic clk, reset,
    output logic led0, led1, led2, led3, led4, led5, led6, led7, led8
);

  logic [8:0] game_state, p1_state, p2_state, game_state_reg, p1_state_reg, p2_state_reg;
  logic [3:0] index;
  logic curr_player, button_pressed, new_game, finished, next, led0_en, led1_en, led2_en, led3_en, led4_en, led5_en,
        led6_en, led7_en, led8_en, game_state_en, p1_state_en, p2_state_en, led0_reg, led1_reg, led2_reg, led3_reg,
        led4_reg, led5_reg, led6_reg, led7_reg, led8_reg, b0_reg0, b0_reg1, b1_reg0, b1_reg1, b2_reg0, b2_reg1,
        b3_reg0, b3_reg1, b4_reg0, b4_reg1, b5_reg0, b5_reg1, b6_reg0, b6_reg1, b7_reg0, b7_reg1, b8_reg0, b8_reg1;

  Register #(1) db0_0(.D(b0), .Q(b0_reg0), .en(1'b1), .clear(reset), .clock(clk));
  Register #(1) db0_1(.D(b0_reg0), .Q(b0_reg1), .en(1'b1), .clear(reset), .clock(clk));

  Register #(1) d1_0(.D(b1), .Q(b1_reg0), .en(1'b1), .clear(reset), .clock(clk));
  Register #(1) db1_1(.D(b1_reg0), .Q(b1_reg1), .en(1'b1), .clear(reset), .clock(clk));

  Register #(1) db2_0(.D(b2), .Q(b2_reg0), .en(1'b1), .clear(reset), .clock(clk));
  Register #(1) db2_1(.D(b2_reg0), .Q(b2_reg1), .en(1'b1), .clear(reset), .clock(clk));

  Register #(1) db3_0(.D(b3), .Q(b3_reg0), .en(1'b1), .clear(reset), .clock(clk));
  Register #(1) db3_1(.D(b3_reg0), .Q(b3_reg1), .en(1'b1), .clear(reset), .clock(clk));

  Register #(1) db4_0(.D(b4), .Q(b4_reg0), .en(1'b1), .clear(reset), .clock(clk));
  Register #(1) db4_1(.D(b4_reg0), .Q(b4_reg1), .en(1'b1), .clear(reset), .clock(clk));

  Register #(1) db5_0(.D(b5), .Q(b5_reg0), .en(1'b1), .clear(reset), .clock(clk));
  Register #(1) db5_1(.D(b5_reg0), .Q(b5_reg1), .en(1'b1), .clear(reset), .clock(clk));

  Register #(1) db6_0(.D(b6), .Q(b6_reg0), .en(1'b1), .clear(reset), .clock(clk));
  Register #(1) db6_1(.D(b6_reg0), .Q(b6_reg1), .en(1'b1), .clear(reset), .clock(clk));

  Register #(1) db7_0(.D(b7), .Q(b7_reg0), .en(1'b1), .clear(reset), .clock(clk));
  Register #(1) db7_1(.D(b7_reg0), .Q(b7_reg1), .en(1'b1), .clear(reset), .clock(clk));

  Register #(1) db8_0(.D(b8), .Q(b8_reg0), .en(1'b1), .clear(reset), .clock(clk));
  Register #(1) db8_1(.D(b8_reg0), .Q(b8_reg1), .en(1'b1), .clear(reset), .clock(clk));

  Register #(1) led0_r(.D(led0_reg), .Q(led0), .en(led0_en), .clear(reset), .clock(clk));
  Register #(1) led1_r(.D(led1_reg), .Q(led1), .en(led1_en), .clear(reset), .clock(clk));
  Register #(1) led2_r(.D(led2_reg), .Q(led2), .en(led2_en), .clear(reset), .clock(clk));
  Register #(1) led3_r(.D(led3_reg), .Q(led3), .en(led3_en), .clear(reset), .clock(clk));
  Register #(1) led4_r(.D(led4_reg), .Q(led4), .en(led4_en), .clear(reset), .clock(clk));
  Register #(1) led5_r(.D(led5_reg), .Q(led5), .en(led5_en), .clear(reset), .clock(clk));
  Register #(1) led6_r(.D(led6_reg), .Q(led6), .en(led6_en), .clear(reset), .clock(clk));
  Register #(1) led7_r(.D(led7_reg), .Q(led7), .en(led7_en), .clear(reset), .clock(clk));
  Register #(1) led8_r(.D(led8_reg), .Q(led8), .en(led8_en), .clear(reset), .clock(clk));

  Register #(9) game_state_r(.D(game_state_reg), .Q(game_state), .en(game_state_en), .clear(reset), .clock(clk));
  Register #(9) p1_state_r(.D(p1_state_reg), .Q(p1_state), .en(p1_state_en), .clear(reset), .clock(clk));
  Register #(9) p2_state_r(.D(p2_state_reg), .Q(p2_state), .en(p2_state_en), .clear(reset), .clock(clk));

  random_number rn(.Q(index), .clear(reset), .clock(clk));

  assign button_pressed = b0_reg1 | b1_reg1 | b2_reg1 | b3_reg1 | b4_reg1 | b5_reg1 | b6_reg1 | b7_reg1 | b8_reg1 | next;

  always_comb begin
    led0_en = 1'b0;
    led1_en = 1'b0;
    led2_en = 1'b0;
    led3_en = 1'b0;
    led4_en = 1'b0;
    led5_en = 1'b0;
    led6_en = 1'b0;
    led7_en = 1'b0;
    led8_en = 1'b0;
    game_state_en = 1'b0;
    p1_state_en = 1'b0;
    p2_state_en = 1'b0;
    led0_reg = 1'b0;
    led1_reg = 1'b0;
    led2_reg = 1'b0;
    led3_reg = 1'b0;
    led4_reg = 1'b0;
    led5_reg = 1'b0;
    led6_reg = 1'b0;
    led7_reg = 1'b0;
    led8_reg = 1'b0;
    game_state_reg = 9'd0;
    p1_state_reg = 9'd0;
    p2_state_reg = 9'd0;
    next = 0;
    if (reset || new_game) begin
      game_state_reg = 9'd0;
      p1_state_reg = 9'd0;
      p2_state_reg = 9'd0;
      game_state_en = 1'b1;
      p1_state_en = 1'b1;
      p2_state_en = 1'b1;
    end
    else if (player_sel == 0) begin
      if (curr_player == 0) begin // player 1
        if (b0_reg1 == 1 && game_state[0] == 0) begin
          led0_reg = 1'b1;
          game_state_reg = game_state | 9'h1;
          p1_state_reg = p1_state | 9'h1;
          led0_en = 1'b1;
          game_state_en = 1'b1;
          p1_state_en = 1'b1;
        end
        else if (b1_reg1 == 1 && game_state[1] == 0) begin
          led1_reg = 1'b1;
          game_state_reg = game_state | 9'h2;
          p1_state_reg = p1_state | 9'h2;
          led1_en = 1'b1;
          game_state_en = 1'b1;
          p1_state_en = 1'b1;
        end
        else if (b2_reg1 == 1 && game_state[2] == 0) begin
          led2_reg = 1'b1;
          game_state_reg = game_state | 9'h4;
          p1_state_reg = p1_state | 9'h4;
          led2_en = 1'b1;
          game_state_en = 1'b1;
          p1_state_en = 1'b1;
        end
        else if (b3_reg1 == 1 && game_state[3] == 0) begin
          led3_reg = 1'b1;
          game_state_reg = game_state | 9'h8;
          p1_state_reg = p1_state | 9'h8;
          led3_en = 1'b1;
          game_state_en = 1'b1;
          p1_state_en = 1'b1;
        end
        else if (b4_reg1 == 1 && game_state[4] == 0) begin
          led4_reg = 1'b1;
          game_state_reg = game_state | 9'h10;
          p1_state_reg = p1_state | 9'h10;
          led4_en = 1'b1;
          game_state_en = 1'b1;
          p1_state_en = 1'b1;
        end
        else if (b5_reg1 == 1 && game_state[5] == 0) begin
          led5_reg = 1'b1;
          game_state_reg = game_state | 9'h20;
          p1_state_reg = p1_state | 9'h20;
          led5_en = 1'b1;
          game_state_en = 1'b1;
          p1_state_en = 1'b1;
        end
        else if (b6_reg1 == 1 && game_state[6] == 0) begin
          led6_reg = 1'b1;
          game_state_reg = game_state | 9'h40;
          p1_state_reg = p1_state | 9'h40;
          led6_en = 1'b1;
          game_state_en = 1'b1;
          p1_state_en = 1'b1;
        end
        else if (b7_reg1 == 1 && game_state[7] == 0) begin
          led7_reg = 1'b1;
          game_state_reg = game_state | 9'h80;
          p1_state_reg = p1_state | 9'h80;
          led7_en = 1'b1;
          game_state_en = 1'b1;
          p1_state_en = 1'b1;
        end
        else if (b8_reg1 == 1 && game_state[8] == 0) begin
          led8_reg = 1'b1;
          game_state_reg = game_state | 9'h100;
          p1_state_reg = p1_state | 9'h100;
          led8_en = 1'b1;
          game_state_en = 1'b1;
          p1_state_en = 1'b1;
        end
        else begin
          led0_en = 1'b0;
          led1_en = 1'b0;
          led2_en = 1'b0;
          led3_en = 1'b0;
          led4_en = 1'b0;
          led5_en = 1'b0;
          led6_en = 1'b0;
          led7_en = 1'b0;
          led8_en = 1'b0;
          game_state_en = 1'b0;
          p1_state_en = 1'b0;
          p2_state_en = 1'b0;
          led0_reg = 1'b0;
          led1_reg = 1'b0;
          led2_reg = 1'b0;
          led3_reg = 1'b0;
          led4_reg = 1'b0;
          led5_reg = 1'b0;
          led6_reg = 1'b0;
          led7_reg = 1'b0;
          led8_reg = 1'b0;
          game_state_reg = 9'd0;
          p1_state_reg = 9'd0;
          p2_state_reg = 9'd0;
        end
      end
      else begin
        if (game_state[0] == 0) begin
          next = 1'b1;
          led0_reg = 1'b1;
          game_state_reg = game_state | 9'h1;
          p2_state_reg = p2_state | 9'h1;
          led0_en = 1'b1;
          game_state_en = 1'b1;
          p2_state_en = 1'b1;
        end
        else if (game_state[1] == 0) begin
          next = 1'b1;
          led1_reg = 1'b1;
          game_state_reg = game_state | 9'h2;
          p2_state_reg = p2_state | 9'h2;
          led1_en = 1'b1;
          game_state_en = 1'b1;
          p2_state_en = 1'b1;
        end
        else if (game_state[2] == 0) begin
          next = 1'b1;
          led2_reg = 1'b1;
          game_state_reg = game_state | 9'h4;
          p2_state_reg = p2_state | 9'h4;
          led2_en = 1'b1;
          game_state_en = 1'b1;
          p2_state_en = 1'b1;
        end
        else if (game_state[3] == 0) begin
          next = 1'b1;
          led3_reg = 1'b1;
          game_state_reg = game_state | 9'h8;
          p2_state_reg = p2_state | 9'h8;
          led3_en = 1'b1;
          game_state_en = 1'b1;
          p2_state_en = 1'b1;
        end
        else if (game_state[4] == 0) begin
          next = 1'b1;
          led4_reg = 1'b1;
          game_state_reg = game_state | 9'h10;
          p2_state_reg = p2_state | 9'h10;
          led4_en = 1'b1;
          game_state_en = 1'b1;
          p2_state_en = 1'b1;
        end
        else if (game_state[5] == 0) begin
          next = 1'b1;
          led5_reg = 1'b1;
          game_state_reg = game_state | 9'h20;
          p2_state_reg = p2_state | 9'h20;
          led5_en = 1'b1;
          game_state_en = 1'b1;
          p2_state_en = 1'b1;
        end
        else if (game_state[6] == 0) begin
          next = 1'b1;
          led6_reg = 1'b1;
          game_state_reg = game_state | 9'h40;
          p2_state_reg = p2_state | 9'h40;
          led6_en = 1'b1;
          game_state_en = 1'b1;
          p2_state_en = 1'b1;
        end
        else if (game_state[7] == 0) begin
          next = 1'b1;
          led7_reg = 1'b1;
          game_state_reg = game_state | 9'h80;
          p2_state_reg = p2_state | 9'h80;
          led7_en = 1'b1;
          game_state_en = 1'b1;
          p2_state_en = 1'b1;
        end
        else if (game_state[8] == 0) begin
          next = 1'b1;
          led8_reg = 1'b1;
          game_state_reg = game_state | 9'h100;
          p2_state_reg = p2_state | 9'h100;
          led8_en = 1'b1;
          game_state_en = 1'b1;
          p2_state_en = 1'b1;
        end
        else begin
          led0_en = 1'b0;
          led1_en = 1'b0;
          led2_en = 1'b0;
          led3_en = 1'b0;
          led4_en = 1'b0;
          led5_en = 1'b0;
          led6_en = 1'b0;
          led7_en = 1'b0;
          led8_en = 1'b0;
          game_state_en = 1'b0;
          p1_state_en = 1'b0;
          p2_state_en = 1'b0;
          led0_reg = 1'b0;
          led1_reg = 1'b0;
          led2_reg = 1'b0;
          led3_reg = 1'b0;
          led4_reg = 1'b0;
          led5_reg = 1'b0;
          led6_reg = 1'b0;
          led7_reg = 1'b0;
          led8_reg = 1'b0;
          game_state_reg = 9'd0;
          p1_state_reg = 9'd0;
          p2_state_reg = 9'd0;
        end
      end
    end
    else begin
      if (curr_player == 0) begin // player 1
        if (b0_reg1 == 1 && game_state[0] == 0) begin
          led0_reg = 1'b1;
          game_state_reg = game_state | 9'h1;
          p1_state_reg = p1_state | 9'h1;
          led0_en = 1'b1;
          game_state_en = 1'b1;
          p1_state_en = 1'b1;
        end
        else if (b1_reg1 == 1 && game_state[1] == 0) begin
          led1_reg = 1'b1;
          game_state_reg = game_state | 9'h2;
          p1_state_reg = p1_state | 9'h2;
          led1_en = 1'b1;
          game_state_en = 1'b1;
          p1_state_en = 1'b1;
        end
        else if (b2_reg1 == 1 && game_state[2] == 0) begin
          led2_reg = 1'b1;
          game_state_reg = game_state | 9'h4;
          p1_state_reg = p1_state | 9'h4;
          led2_en = 1'b1;
          game_state_en = 1'b1;
          p1_state_en = 1'b1;
        end
        else if (b3_reg1 == 1 && game_state[3] == 0) begin
          led3_reg = 1'b1;
          game_state_reg = game_state | 9'h8;
          p1_state_reg = p1_state | 9'h8;
          led3_en = 1'b1;
          game_state_en = 1'b1;
          p1_state_en = 1'b1;
        end
        else if (b4_reg1 == 1 && game_state[4] == 0) begin
          led4_reg = 1'b1;
          game_state_reg = game_state | 9'h10;
          p1_state_reg = p1_state | 9'h10;
          led4_en = 1'b1;
          game_state_en = 1'b1;
          p1_state_en = 1'b1;
        end
        else if (b5_reg1 == 1 && game_state[5] == 0) begin
          led5_reg = 1'b1;
          game_state_reg = game_state | 9'h20;
          p1_state_reg = p1_state | 9'h20;
          led5_en = 1'b1;
          game_state_en = 1'b1;
          p1_state_en = 1'b1;
        end
        else if (b6_reg1 == 1 && game_state[6] == 0) begin
          led6_reg = 1'b1;
          game_state_reg = game_state | 9'h40;
          p1_state_reg = p1_state | 9'h40;
          led6_en = 1'b1;
          game_state_en = 1'b1;
          p1_state_en = 1'b1;
        end
        else if (b7_reg1 == 1 && game_state[7] == 0) begin
          led7_reg = 1'b1;
          game_state_reg = game_state | 9'h80;
          p1_state_reg = p1_state | 9'h80;
          led7_en = 1'b1;
          game_state_en = 1'b1;
          p1_state_en = 1'b1;
        end
        else if (b8_reg1 == 1 && game_state[8] == 0) begin
          led8_reg = 1'b1;
          game_state_reg = game_state | 9'h100;
          p1_state_reg = p1_state | 9'h100;
          led8_en = 1'b1;
          game_state_en = 1'b1;
          p1_state_en = 1'b1;
        end
        else begin
          led0_en = 1'b0;
          led1_en = 1'b0;
          led2_en = 1'b0;
          led3_en = 1'b0;
          led4_en = 1'b0;
          led5_en = 1'b0;
          led6_en = 1'b0;
          led7_en = 1'b0;
          led8_en = 1'b0;
          game_state_en = 1'b0;
          p1_state_en = 1'b0;
          p2_state_en = 1'b0;
          led0_reg = 1'b0;
          led1_reg = 1'b0;
          led2_reg = 1'b0;
          led3_reg = 1'b0;
          led4_reg = 1'b0;
          led5_reg = 1'b0;
          led6_reg = 1'b0;
          led7_reg = 1'b0;
          led8_reg = 1'b0;
          game_state_reg = 9'd0;
          p1_state_reg = 9'd0;
          p2_state_reg = 9'd0;
        end
      end
      else begin
        if (b0_reg1 == 1 && game_state[0] == 0) begin
          led0_reg = 1'b1;
          game_state_reg = game_state | 9'h1;
          p2_state_reg = p2_state | 9'h1;
          led0_en = 1'b1;
          game_state_en = 1'b1;
          p2_state_en = 1'b1;
        end
        else if (b1_reg1 == 1 && game_state[1] == 0) begin
          led1_reg = 1'b1;
          game_state_reg = game_state | 9'h2;
          p2_state_reg = p2_state | 9'h2;
          led1_en = 1'b1;
          game_state_en = 1'b1;
          p2_state_en = 1'b1;
        end
        else if (b2_reg1 == 1 && game_state[2] == 0) begin
          led2_reg = 1'b1;
          game_state_reg = game_state | 9'h4;
          p2_state_reg = p2_state | 9'h4;
          led2_en = 1'b1;
          game_state_en = 1'b1;
          p2_state_en = 1'b1;
        end
        else if (b3_reg1 == 1 && game_state[3] == 0) begin
          led3_reg = 1'b1;
          game_state_reg = game_state | 9'h8;
          p2_state_reg = p2_state | 9'h8;
          led3_en = 1'b1;
          game_state_en = 1'b1;
          p2_state_en = 1'b1;
        end
        else if (b4_reg1 == 1 && game_state[4] == 0) begin
          led4_reg = 1'b1;
          game_state_reg = game_state | 9'h10;
          p2_state_reg = p2_state | 9'h10;
          led4_en = 1'b1;
          game_state_en = 1'b1;
          p2_state_en = 1'b1;
        end
        else if (b5_reg1 == 1 && game_state[5] == 0) begin
          led5_reg = 1'b1;
          game_state_reg = game_state | 9'h20;
          p2_state_reg = p2_state | 9'h20;
          led5_en = 1'b1;
          game_state_en = 1'b1;
          p2_state_en = 1'b1;
        end
        else if (b6_reg1 == 1 && game_state[6] == 0) begin
          led6_reg = 1'b1;
          game_state_reg = game_state | 9'h40;
          p2_state_reg = p2_state | 9'h40;
          led6_en = 1'b1;
          game_state_en = 1'b1;
          p2_state_en = 1'b1;
        end
        else if (b7_reg1 == 1 && game_state[7] == 0) begin
          led7_reg = 1'b1;
          game_state_reg = game_state | 9'h80;
          p2_state_reg = p2_state | 9'h80;
          led7_en = 1'b1;
          game_state_en = 1'b1;
          p2_state_en = 1'b1;
        end
        else if (b8_reg1 == 1 && game_state[8] == 0) begin
          led8_reg = 1'b1;
          game_state_reg = game_state | 9'h100;
          p2_state_reg = p2_state | 9'h100;
          led8_en = 1'b1;
          game_state_en = 1'b1;
          p2_state_en = 1'b1;
        end
        else begin
          led0_en = 1'b0;
          led1_en = 1'b0;
          led2_en = 1'b0;
          led3_en = 1'b0;
          led4_en = 1'b0;
          led5_en = 1'b0;
          led6_en = 1'b0;
          led7_en = 1'b0;
          led8_en = 1'b0;
          game_state_en = 1'b0;
          p1_state_en = 1'b0;
          p2_state_en = 1'b0;
          led0_reg = 1'b0;
          led1_reg = 1'b0;
          led2_reg = 1'b0;
          led3_reg = 1'b0;
          led4_reg = 1'b0;
          led5_reg = 1'b0;
          led6_reg = 1'b0;
          led7_reg = 1'b0;
          led8_reg = 1'b0;
          game_state_reg = 9'd0;
          p1_state_reg = 9'd0;
          p2_state_reg = 9'd0;
        end
      end
    end
  end

  win_detection wd(.p1_state(p1_state), .p2_state(p2_state), .*);
  ttt_fsm fsm(.*);

endmodule: ttt_game_control

module win_detection (
    input  logic [8:0] p1_state, p2_state,
    output logic       finished
);

  always_comb begin
    if (p1_state[0] == 1 && p1_state[1] == 1 && p1_state[2] == 1) finished = '1;
    else if (p1_state[3] == 1 && p1_state[4] == 1 && p1_state[5] == 1) finished = '1;
    else if (p1_state[6] == 1 && p1_state[7] == 1 && p1_state[8] == 1) finished = '1;
    else if (p1_state[0] == 1 && p1_state[3] == 1 && p1_state[6] == 1) finished = '1;
    else if (p1_state[1] == 1 && p1_state[4] == 1 && p1_state[7] == 1) finished = '1;
    else if (p1_state[2] == 1 && p1_state[5] == 1 && p1_state[8] == 1) finished = '1;
    else if (p1_state[0] == 1 && p1_state[4] == 1 && p1_state[8] == 1) finished = '1;
    else if (p1_state[2] == 1 && p1_state[4] == 1 && p1_state[6] == 1) finished = '1;
    else if (p2_state[0] == 1 && p2_state[1] == 1 && p2_state[2] == 1) finished = '1;
    else if (p2_state[3] == 1 && p2_state[4] == 1 && p2_state[5] == 1) finished = '1;
    else if (p2_state[6] == 1 && p2_state[7] == 1 && p2_state[8] == 1) finished = '1;
    else if (p2_state[0] == 1 && p2_state[3] == 1 && p2_state[6] == 1) finished = '1;
    else if (p2_state[1] == 1 && p2_state[4] == 1 && p2_state[7] == 1) finished = '1;
    else if (p2_state[2] == 1 && p2_state[5] == 1 && p2_state[8] == 1) finished = '1;
    else if (p2_state[0] == 1 && p2_state[4] == 1 && p2_state[8] == 1) finished = '1;
    else if (p2_state[2] == 1 && p2_state[4] == 1 && p2_state[6] == 1) finished = '1;
    else finished = '0;
  end

endmodule: win_detection

module ttt_fsm (
    input  logic start, button_pressed, finished,
    input  logic clk, reset,
    output logic curr_player, // 0 = player 1, 1 = player 2
    output logic new_game
);

  enum logic [1:0] {START, WAIT_P1, WAIT_P2, END} state, nextState;

  always_comb begin
    new_game = '0;
    unique case (state)
      START: begin
        curr_player = '0;
        if (start) nextState = WAIT_P1;
        else nextState = START;
      end
      WAIT_P1: begin
        if (finished) begin
          curr_player = '0;
          nextState = END;
        end
        else if (button_pressed) begin
          curr_player = '1;
          nextState = WAIT_P2;
        end
        else begin
          curr_player = '0;
          nextState = WAIT_P1;
        end
      end
      WAIT_P2: begin
        if (finished) begin
          curr_player = '0;
          nextState = END;
        end
        else if (button_pressed) begin
          curr_player = '0;
          nextState = WAIT_P1;
        end
        else begin
          curr_player = '1;
          nextState = WAIT_P2;
        end
      end
      END: begin
        curr_player = '0;
        new_game = '1;
        nextState = START;
      end
    endcase
  end

  always_ff @(posedge clk)
    if (reset) state <= START;
    else state <= nextState;

endmodule: ttt_fsm
