`default_nettype none

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);

    ModifiedTetris chip_design(.clock, .reset, .inputs(io_in), .outputs(io_out));

endmodule: my_chip


module ModifiedTetris(
    input  logic clock, reset,
    input  logic [11:0] inputs,
    output logic [11:0] outputs
);

    logic drop_btn;
    logic new_game_btn;
    logic [5:0] initial_game_speed;
    logic [3:0] update_request_location;

    assign drop_btn = inputs[0];
    assign new_game_btn = inputs[1];
    assign update_request_location = inputs[5:2];
    assign initial_game_speed = inputs[11:6];

    logic game_running;
    logic [2:0] bounce_pos;
    logic [7:0] update_value;

    assign outputs[0] = game_running;
    assign outputs[3:1] = bounce_pos;
    assign outputs[11:4] = update_value;

    logic new_game_int, new_game, drop_int, drop_button;

    logic prev_drop_button, start_drop;

    logic [7:0] score;

    //Synchronize Inputs
    always_ff @(posedge clock) begin
        new_game_int <= new_game_btn;
        new_game     <= new_game_int;
        drop_int     <= drop_btn;
        drop_button  <= drop_int;
        prev_drop_button <= drop_button;
    end

    assign start_drop = drop_button && ~prev_drop_button;

    logic bounce_clock, drop_clock;

    ClockGenerator timing(.clock, .reset, .initial_game_speed, .score, .drop_clock, .bounce_clock);
    
    //Bouncing Pixel
    logic pause_bounce;
    
    BouncingPixel bounce(.*);

    //8 Columns
    logic [7:0] drop;
    logic [3:0] drop_pos[7:0];
    logic stack_dec;
    logic game_cl;
    logic [3:0] stack_pos[7:0];
    logic [7:0] drop_done;

    genvar i;
    for(i = 4'b0; i < 4'd8; i++) begin
        SingleColumn col(.clock, .reset, .drop_clock,
                         .drop(drop[i]),
                         .stack_dec,
                         .stack_cl(game_cl),
                         .drop_pos(drop_pos[i]),
                         .stack_pos(stack_pos[i]),
                         .drop_done(drop_done[i]));
    end


    //Row Elimination Logic
    logic [7:0] col_not_zero;

    genvar j;
    for(j = 4'b0; j < 4'd8; j++) begin
        assign col_not_zero[j] = |stack_pos[j];
    end

    assign stack_dec = &col_not_zero;


    //Game Over Logic
    logic game_over;

    assign game_over = stack_pos[0][3] | stack_pos[1][3] | stack_pos[2][3] | stack_pos[3][3] | stack_pos[4][3] | stack_pos[5][3] | stack_pos[6][3] | stack_pos[7][3];
    

    //Scoreboard Logic
    always_ff @(posedge clock) begin
        if(reset || game_cl)
            score <= 8'b0;
        else if(stack_dec)
            score <= score + 1'b1;
    end


    //Game FSM
    enum logic [1:0] {INIT, PLAY, DROP, OVER} state, nextState;

    always_comb begin
        nextState = INIT;
        game_cl = 1'b0;
        game_running = 1'b0;
        pause_bounce = 1'b0;
        drop = 8'b0;

        case(state)
            INIT: begin
                if(new_game)
                    nextState = PLAY;
                else
                    nextState = INIT;

                game_cl = 1'b1;
                game_running = new_game;
            end
            PLAY: begin
                if(game_over && ~new_game) begin
                    nextState = OVER;
                    game_running = 1'b0;
                end
                else if(start_drop && ~game_over && ~new_game) begin
                    nextState = DROP;
                    game_running = 1'b1;
                    pause_bounce = 1'b1;
                    drop[bounce_pos] = 1'b1;
                end
                else begin
                    nextState = PLAY;
                    game_running = 1'b1;
                end

                game_cl = new_game;
            end
            DROP: begin
                if(|drop_done)
                    nextState = PLAY;
                else
                    nextState = DROP;

                pause_bounce = 1'b1;
                game_running = 1'b1;
            end
            OVER: begin
                if(new_game)
                    nextState = PLAY;
                else
                    nextState = OVER;

                game_cl = new_game;
                game_running = new_game;
            end
        endcase
    end

    always_ff @(posedge clock) begin
        if(reset)
            state <= INIT;
        else
            state <= nextState;
    end


    //Output Multiplexer
    logic [7:0] col_encoded;
    assign col_encoded[3:0] = stack_pos[update_request_location[2:0]];
    assign col_encoded[7:4] = drop_pos[update_request_location[2:0]];

    assign update_value = (update_request_location[3]) ? score : col_encoded;

endmodule: ModifiedTetris


module BouncingPixel(
    input  logic clock, reset,
    input  logic bounce_clock,
    input  logic game_running,
    input  logic pause_bounce,
    output logic [2:0] bounce_pos);

    logic up;

    enum logic {LEFT, RIGHT} state, nextState;

    always_comb begin
        nextState = state;
        up = (state == RIGHT) ? 1'b1 : 1'b0;
        if(state == RIGHT && &bounce_pos) begin
            nextState = LEFT;
            up = 1'b0;
        end
        if(state == LEFT && ~|bounce_pos) begin
            nextState = RIGHT;
            up = 1'b1;
        end
    end

    always_ff @(posedge clock) begin
        if(reset) begin
            bounce_pos <= 3'b0;
        end
        else if(bounce_clock && game_running && ~pause_bounce) begin
            if(up)
                bounce_pos <= bounce_pos + 1'b1;
            else
                bounce_pos <= bounce_pos - 1'b1;
        end
    end

    always_ff @(posedge clock) begin
        if(reset)
            state <= RIGHT;
        else
            state <= nextState;
    end

endmodule: BouncingPixel


module SingleColumn(
    input  logic clock, reset,
    input  logic drop_clock,
    input  logic drop,
    input  logic stack_dec,
    input  logic stack_cl,
    output logic [3:0] drop_pos,
    output logic [3:0] stack_pos,
    output logic drop_done);

    enum logic {WAIT, DROP} state, nextState;

    logic drop_init;
    logic drop_en;
    logic stack_incr;
    assign drop_done = stack_incr;

    always_comb begin
        nextState = WAIT;
        drop_init = 1'b0;
        drop_en = 1'b0;
        stack_incr = 1'b0;
        unique case (state)
            WAIT: begin
                if(drop)
                    nextState = DROP;
                else
                    nextState = WAIT;
                drop_init = 1'b1;
            end
            DROP: begin
                if (drop_pos == (stack_pos + 1'b1)) begin
                    nextState = WAIT;
                    stack_incr = 1'b1;
                    drop_init = 1'b1;
                end
                else begin
                    nextState = DROP;
                    drop_en = 1'b1;
                end
            end
        endcase
    end

    always_ff @(posedge clock) begin
        if(reset)
            state <= WAIT;
        else
            state <= nextState;
    end

    //Drop Counter
    always_ff @(posedge clock) begin
        if(reset || drop_init)
            drop_pos <= 4'd9;
        else if(drop_clock && drop_en)
            drop_pos <= drop_pos - 1'b1;
    end

    //Stack Counter
    always_ff @(posedge clock) begin
        if(reset || stack_cl)
            stack_pos <= 4'd0;
        else if(stack_dec)
            stack_pos <= stack_pos - 1'b1;
        else if(stack_incr)
            stack_pos <= stack_pos + 1'b1;
    end

endmodule: SingleColumn


module ClockGenerator(
    input  logic clock, reset,
    input  logic [5:0] initial_game_speed,
    input  logic [7:0] score,
    output logic drop_clock, bounce_clock);


    logic [26:0] drop_max_val;
    logic [26:0] bounce_max_val;

    logic [26:0] initial_game_speed_base, score_base;

    assign drop_max_val = 27'd5000;

    always_comb begin
        initial_game_speed_base = 27'd40000 - (initial_game_speed * 600);
    end

    always_comb begin
        score_base = 27'd0 + (score * 300);
    end

    assign bounce_max_val = initial_game_speed_base - score_base;

    //Drop Clock
    logic [26:0] drop_cnt;

    always_ff @(posedge clock) begin
        if(reset)
            drop_cnt <= 27'b0;
        else begin
            drop_cnt <= drop_cnt + 1'b1;
            if(drop_cnt == (drop_max_val + 1'b1))
                drop_cnt <= 27'b0;
        end
    end
    assign drop_clock = (drop_cnt == drop_max_val);

    //Bounce Clock
    logic [26:0] bounce_cnt;

    always_ff @(posedge clock) begin
        if(reset)
            bounce_cnt <= 27'b0;
        else begin
            bounce_cnt <= bounce_cnt + 1'b1;
            if(bounce_cnt == (bounce_max_val + 1'b1))
                bounce_cnt <= 27'b0;
        end
    end
    assign bounce_clock = (bounce_cnt == bounce_max_val);

endmodule: ClockGenerator
