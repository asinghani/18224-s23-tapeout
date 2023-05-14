module ttt_game_control (
    input  logic b0, b1, b2, b3, b4, b5, b6, b7, b8, player_sel, start,
    input  logic clk, reset,
    output logic led0, led1, led2, led3, led4, led5, led6, led7, led8
);

  logic [8:0] game_state, p1_state, p2_state;
  logic curr_player, button_pressed, new_game;

  assign button_pressed = b0 | b1 | b2 | b3 | b4 | b5 | b6 | b7 | b8;

  always_ff @(posedge clk, posedge reset) begin
    if (reset || new_game) begin
      game_state <= 9'd0;
      p1_state <= 9'd0;
      p2_state <= 9'd0;
    end
    else begin
      if (curr_player == 0) begin // player 1
        if (b0 == 1 && game_state[0] == 0) begin
          led0 <= 1;
          game_state <= {game_state[8:1], 1'b1};
          p1_state <= {p1_state[8:1], 1'b1};
        end
        else if (b1 == 1 && game_state[1] == 0) begin
          led1 <= 1;
          game_state <= {game_state[8:2], 1'b1, game_state[0]};
          p1_state <= {p1_state[8:2], 1'b1, p1_state[0]};
        end
        else if (b2 == 1 && game_state[2] == 0) begin
          led2 <= 1;
          game_state <= {game_state[8:3], 1'b1, game_state[1:0]};
          p1_state <= {p1_state[8:3], 1'b1, p1_state[1:0]};
        end
        else if (b3 == 1 && game_state[3] == 0) begin
          led3 <= 1;
          game_state <= {game_state[8:4], 1'b1, game_state[2:0]};
          p1_state <= {p1_state[8:4], 1'b1, p1_state[2:0]};
        end
        else if (b4 == 1 && game_state[4] == 0) begin
          led4 <= 1;
          game_state <= {game_state[8:5], 1'b1, game_state[3:0]};
          p1_state <= {p1_state[8:5], 1'b1, p1_state[3:0]};
        end
        else if (b5 == 1 && game_state[5] == 0) begin
          led5 <= 1;
          game_state <= {game_state[8:6], 1'b1, game_state[4:0]};
          p1_state <= {p1_state[8:6], 1'b1, p1_state[4:0]};
        end
        else if (b6 == 1 && game_state[6] == 0) begin
          led6 <= 1;
          game_state <= {game_state[8:7], 1'b1, game_state[5:0]};
          p1_state <= {p1_state[8:7], 1'b1, p1_state[5:0]};
        end
        else if (b7 == 1 && game_state[7] == 0) begin
          led7 <= 1;
          game_state <= {game_state[8], 1'b1, game_state[6:0]};
          p1_state <= {p1_state[8], 1'b1, p1_state[6:0]};
        end
        else if (b8 == 1 && game_state[8] == 0) begin
          led8 <= 1;
          game_state <= {1'b1, game_state[7:0]};
          p1_state <= {1'b1, p1_state[7:0]};
        end
      end
      else begin
        if (b0 == 1 && game_state[0] == 0) begin
          led0 <= 1;
          game_state <= {game_state[8:1], 1'b1};
          p1_state <= {p2_state[8:1], 1'b1};
        end
        else if (b1 == 1 && game_state[1] == 0) begin
          led1 <= 1;
          game_state <= {game_state[8:2], 1'b1, game_state[0]};
          p2_state <= {p2_state[8:2], 1'b1, p2_state[0]};
        end
        else if (b2 == 1 && game_state[2] == 0) begin
          led2 <= 1;
          game_state <= {game_state[8:3], 1'b1, game_state[1:0]};
          p2_state <= {p2_state[8:3], 1'b1, p2_state[1:0]};
        end
        else if (b3 == 1 && game_state[3] == 0) begin
          led3 <= 1;
          game_state <= {game_state[8:4], 1'b1, game_state[2:0]};
          p2_state <= {p2_state[8:4], 1'b1, p2_state[2:0]};
        end
        else if (b4 == 1 && game_state[4] == 0) begin
          led4 <= 1;
          game_state <= {game_state[8:5], 1'b1, game_state[3:0]};
          p2_state <= {p2_state[8:5], 1'b1, p2_state[3:0]};
        end
        else if (b5 == 1 && game_state[5] == 0) begin
          led5 <= 1;
          game_state <= {game_state[8:6], 1'b1, game_state[4:0]};
          p2_state <= {p2_state[8:6], 1'b1, p2_state[4:0]};
        end
        else if (b6 == 1 && game_state[6] == 0) begin
          led6 <= 1;
          game_state <= {game_state[8:7], 1'b1, game_state[5:0]};
          p2_state <= {p2_state[8:7], 1'b1, p2_state[5:0]};
        end
        else if (b7 == 1 && game_state[7] == 0) begin
          led7 <= 1;
          game_state <= {game_state[8], 1'b1, game_state[6:0]};
          p2_state <= {p2_state[8], 1'b1, p2_state[6:0]};
        end
        else if (b8 == 1 && game_state[8] == 0) begin
          led8 <= 1;
          game_state <= {1'b1, game_state[7:0]};
          p2_state <= {1'b1, p2_state[7:0]};
        end
      end
    end
  end


  ttt_fsm fsm(.finished(0), .*);

endmodule: ttt_game_control

module win_detection (
    input  logic [8:0] p1_state, p2_state, clk, reset,
    output logic       finished
);

  always_comb begin
    if (p1_state[0] == 1 && p1_state[1] == 1 && p1_state[2] == 1) finished = 1;
    else if (p1_state[3] == 1 && p1_state[4] == 1 && p1_state[5] == 1) finished = 1;
    else if (p1_state[6] == 1 && p1_state[7] == 1 && p1_state[8] == 1) finished = 1;
    else if (p1_state[0] == 1 && p1_state[3] == 1 && p1_state[6] == 1) finished = 1;
    else if (p1_state[1] == 1 && p1_state[4] == 1 && p1_state[7] == 1) finished = 1;
    else if (p1_state[2] == 1 && p1_state[5] == 1 && p1_state[8] == 1) finished = 1;
    else if (p1_state[0] == 1 && p1_state[4] == 1 && p1_state[8] == 1) finished = 1;
    else if (p1_state[2] == 1 && p1_state[4] == 1 && p1_state[6] == 1) finished = 1;
    else if (p2_state[0] == 1 && p2_state[1] == 1 && p2_state[2] == 1) finished = 1;
    else if (p2_state[3] == 1 && p2_state[4] == 1 && p2_state[5] == 1) finished = 1;
    else if (p2_state[6] == 1 && p2_state[7] == 1 && p2_state[8] == 1) finished = 1;
    else if (p2_state[0] == 1 && p2_state[3] == 1 && p2_state[6] == 1) finished = 1;
    else if (p2_state[1] == 1 && p2_state[4] == 1 && p2_state[7] == 1) finished = 1;
    else if (p2_state[2] == 1 && p2_state[5] == 1 && p2_state[8] == 1) finished = 1;
    else if (p2_state[0] == 1 && p2_state[4] == 1 && p2_state[8] == 1) finished = 1;
    else if (p2_state[2] == 1 && p2_state[4] == 1 && p2_state[6] == 1) finished = 1;
    else finished = 0;
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
    new_game = 0;
    unique case (state)
      START: begin
        curr_player = 0;
        if (start) nextState = WAIT_P1;
        else nextState = START;
      end
      WAIT_P1: begin
        if (finished) begin
          curr_player = 0;
          nextState = END;
        end
        else if (button_pressed) begin
          curr_player = 1;
          nextState = WAIT_P2;
        end
        else begin
          curr_player = 0;
          nextState = WAIT_P1;
        end
      end
      WAIT_P2: begin
        if (finished) begin
          curr_player = 0;
          nextState = END;
        end
        else if (button_pressed) begin
          curr_player = 0;
          nextState = WAIT_P1;
        end
        else begin
          curr_player = 1;
          nextState = WAIT_P2;
        end
      end
      END: begin
        curr_player = 0;
        new_game = 1;
        nextState = START;
      end
    endcase
  end

  always_ff @(posedge clk, posedge reset)
    if (reset) state <= START;
    else state <= nextState;

endmodule: ttt_fsm
