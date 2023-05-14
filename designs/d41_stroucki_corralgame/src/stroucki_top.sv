// Michael Stroucken
// 98-154
// Tinytapeout Corral project

`default_nettype none

module stroucki_top
  (input logic [7:0] io_in,
  output logic [7:0] io_out);

  // assign inputs
  logic clock, reset, enter;
  logic [2:0] move;
  assign {enter, move, reset, clock} = io_in;
  // assign outputs
  logic ready, lostwon, gameover;
  logic [3:0] data;
  assign io_out = {ready, lostwon, gameover, data};

  typedef enum logic [2:0] {COWBOY, HORSE, GAME, IDLE} state_t;
  state_t state = IDLE, nextState;

  // want sequential:
  // data, gameover, lostwon, ready, state

  logic [3:0] horsepos;
  logic [3:0] cowboypos;

  logic gameenter, gamegameover, gamelostwon, gameready;
  logic [2:0] gamemove;
  

  logic reset_n;
  assign reset_n =  !reset;

  game gameinstance(.clock(clock), .reset_n(reset_n),
    .cowboyPos(cowboypos), .horsePos(horsepos), .gameover(gamegameover),
    .lostwon(gamelostwon), .ready(gameready), .enter(gameenter),
    .move(gamemove));

  // current state logic
  always_comb begin
    gameenter = 0;
    gamemove = 3'b0;
    data = 4'b0;

    unique case (state)
      IDLE: if (enter)
        begin
          gameenter = 1;
          gamemove = move;
          nextState = COWBOY;
        end
        else nextState = IDLE;
      COWBOY: nextState = HORSE;
      HORSE: nextState = GAME;
      GAME: if (enter)
        begin
          nextState = COWBOY;
        end
        else nextState = IDLE;
    endcase
  end

  always @(posedge clock, negedge reset_n) begin
    if (~reset_n) begin
      state <= IDLE;
      data <= 4'b0;
      gameover <= 1;
    end
    else begin
      gameover <= gamegameover;
      ready <= gameready;
      lostwon <= gamelostwon;
      ready <= gameready;

    end
  end

endmodule: stroucki_top
