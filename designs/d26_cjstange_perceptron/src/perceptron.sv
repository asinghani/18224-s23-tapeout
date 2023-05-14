`default_nettype none

module perceptron
    (input  logic       clk, reset_l,
     input  logic       go, update, correct,
     input  logic [1:0] sel_out,
     input  logic [5:0] in_val,
     output logic       done, classification, sync,
     output logic [5:0] out_val);

    //define internal signal
    logic       en_w0, en_w1, en_w2, ext_w0, ext_w1, ext_w2, sel_add_A;
    logic       en_n, en_x1, en_x2, en_add, en_mult, en_count, clr_count;
    logic [1:0] count, sel_add_B, sel_mult_A, sel_mult_B;

    fsm control(.*);

    datapath data(.*);
endmodule

module datapath
    (input  logic        clk, reset_l,
     input  logic        en_w0, en_w1, en_w2, en_n, clr_count,
     input  logic        en_x1, en_x2, en_count, en_mult, correct,
     input  logic        en_add, ext_w0, ext_w1, ext_w2, sel_add_A,
     input  logic  [1:0] sel_out, sel_add_B,
     input  logic  [1:0] sel_mult_A, sel_mult_B,
     input  logic  [5:0] in_val,
     output logic        classification,
     output logic  [1:0] count,
     output logic  [5:0] out_val);

    //define internal signals
    logic [5:0] w0, w1, w2, n, x1, x2, d;
    logic [5:0] add_out_reg, mult_out_reg, add_out, mult_out;
    logic [5:0] add_A, add_B, mult_A, mult_B;

    //input mux
    mux #(4, 6) input_mux(.in({w0, w1, w2, add_out_reg}),
                          .sel(sel_out),
                          .out(out_val));

    //w0 reg
    register #(6) w0_reg(.clk,
                         .reset_l,
                         .en(en_w0),
                         .D((ext_w0) ? in_val : add_out),
                         .Q(w0));
    
    //w1 reg
    register #(6) w1_reg(.clk,
                         .reset_l,
                         .en(en_w1),
                         .D((ext_w1) ? in_val : add_out),
                         .Q(w1));

    //w2 reg
    register #(6) w2_reg(.clk,
                         .reset_l,
                         .en(en_w2),
                         .D((ext_w2) ? in_val : add_out),
                         .Q(w2));

    //n reg
    register #(6) n_reg(.clk,
                        .reset_l,
                        .en(en_n),
                        .D(in_val),
                        .Q(n));

    //x1 reg
    register #(6) x1_reg(.clk,
                         .reset_l,
                         .en(en_x1),
                         .D(in_val),
                         .Q(x1));

    //x2 reg
    register #(6) x2_reg(.clk,
                         .reset_l,
                         .en(en_x2),
                         .D(in_val),
                         .Q(x2));

    //counter
    counter #(2) counter(.clk,
                         .reset_l,
                         .en(en_count),
                         .clr(clr_count),
                         .count);

    //mult reg
    register #(6) mult_reg(.clk,
                           .reset_l,
                           .en(en_mult),
                           .D(mult_out),
                           .Q(mult_out_reg));

    //mult
    mult mult(.A(mult_A),
              .B(mult_B),
              .M(mult_out));

    //mult_A mux
    mux #(4, 6) mult_A_mux(.in({w1, w2, n, mult_out_reg}),
                           .sel(sel_mult_A),
                           .out(mult_A));

    //mult_B mux
    mux #(4, 6) mult_B_mux(.in({x1, x2, 6'd1, d}),
                           .sel(sel_mult_B),
                           .out(mult_B));

    //add reg
    register #(6) add_reg(.clk,
                          .reset_l,
                          .en(en_add),
                          .D(add_out),
                          .Q(add_out_reg));

    //add
    adder #(6) add(.cin(1'd0),
                   .A(add_A),
                   .B(add_B),
                   .cout(),
                   .sum(add_out));

    //add_A mux
    mux #(2, 6) add_A_mux(.in({6'd0, mult_out_reg}),
                          .sel(sel_add_A),
                          .out(add_A));

    //add_B mux
    mux #(4, 6) add_B_mux(.in({w0, add_out_reg, w1, w2}),
                          .sel(sel_add_B),
                          .out(add_B));

    //non module logic
    //Need to think about these comparions in terms of 
    always_comb begin
        //only look at non decimal bits?
        //Correctness needs to be tested
        if ($signed(add_out_reg[5:3]) > 0) 
            classification = 1'd1;
        else
            classification = 1'd0;

        if (correct)
            d = 6'b001000; //d = 1
        else
            d = 6'b100000; //d = -1
    end
endmodule

module fsm
    (input  logic       clk, reset_l, 
     input  logic       go, update, correct, classification,
     input  logic [1:0] count,
     output logic       done, sync, //external to user
     output logic       en_w0, en_w1, en_w2, ext_w0, ext_w1, ext_w2, sel_add_A,
     output logic       en_n, en_x1, en_x2, en_add, en_mult, en_count, clr_count,
     output logic [1:0] sel_add_B, sel_mult_A, sel_mult_B);

    enum logic [3:0] {INIT, W0, W1, W2, N, X1, X2, COMPI, CHECK, T1, T2} state, nextState;

    //nextState logic
    always_comb begin
        case (state)
            INIT: begin
                if (go) 
                    nextState = W0;
                else
                    nextState = INIT;
            end

            W0: begin
                if (go) 
                    nextState = W1;
                else
                    nextState = W0;
            end

            W1: begin
                if (go) 
                    nextState = W2;
                else
                    nextState = W1;
            end

            W2: begin
                if (go) 
                    nextState = N;
                else
                    nextState = W2;
            end

            N: begin
                if (go) 
                    nextState = X1;
                else
                    nextState = N;
            end

            X1: begin
                if (go) 
                    nextState = X2;
                else
                    nextState = X1;
            end

            X2: nextState = COMPI;

            COMPI: begin
                if (update)
                    nextState = CHECK;
                else
                    nextState = N;
            end

            CHECK: begin
                if ((correct == classification) || (count > 2))
                    nextState = N;
                else
                    nextState = T1;
            end

            T1: nextState = T2;

            T2: nextState = CHECK;

            default: nextState = INIT;
        endcase
    end

    //output logic
    always_comb begin
        //initialize output values
        done =       1'd0;
        // classification = 1'd0;
        sync =           1'd0;
        en_w0 =          1'd0;
        ext_w0 =         1'd0;
        en_w1 =          1'd0;
        ext_w1 =         1'd0;
        en_w2 =          1'd0;
        ext_w2 =         1'd0;
        en_n =           1'd0;
        en_x1 =          1'd0;
        en_x2 =          1'd0;
        sel_add_A =      1'd0;
        sel_add_B =      2'd0;
        en_add =         1'd0;
        sel_mult_B =     2'd0;
        sel_mult_A =     2'd0;
        en_mult =        1'd0;
        en_count =       1'd0;
        clr_count =      1'd0;

        case (state)
            INIT: begin
                if (go) begin
                    en_w0 = 1'd1;
                    ext_w0 = 1'd1;
                    sync = 1'd1;
                end
            end

            W0: begin
                if (go) begin
                    en_w1 = 1'd1;
                    ext_w1 = 1'd1;
                    sync = 1'd1;
                end
            end

            W1: begin
                if (go) begin
                    en_w2 = 1'd1;
                    ext_w2 = 1'd1;
                    sync = 1'd1;
                end
            end

            W2: begin
                if (go) begin
                    en_n = 1'd1;
                    sync = 1'd1;
                end
            end

            N: begin
                if (go) begin
                    en_x1 = 1'd1;
                    sel_add_A = 1'd1; //0
                    sel_add_B = 2'd3; //w0 
                    en_add = 1'd1;
                    sync = 1'd1;
                end
            end

            X1: begin
                if (go) begin
                    en_x2 = 1'd1;
                    sel_mult_A = 2'd3; //w1
                    sel_mult_B = 2'd3; //x1
                    en_mult = 1'd1;
                end
            end


            X2: begin
                sel_add_A = 1'd0; //mult_out_reg
                sel_add_B = 2'd2; //add_out_reg
                en_add = 1'd1;
                sel_mult_A = 2'd2; //w2
                sel_mult_B = 2'd2; //x2
                en_mult = 1'd1;
            end

            COMPI: begin
                sel_add_A = 1'd0; //mult_out_reg
                sel_add_B = 2'd2; //add_out_reg
                en_add = 1'd1;
                if (update)
                    clr_count = 1'd1;
                else begin
                    done= 1'd1;
                end
            end

            CHECK: begin
                if ((correct == classification) || (count > 2))
                    done = 1'd1;
                else begin
                    sel_mult_A = 2'd1; //n
                    en_mult = 1'd1;
                    case (count)
                        2'd0:    sel_mult_B = 2'd1; //1
                        2'd1:    sel_mult_B = 2'd3; //x1
                        default: sel_mult_B = 2'd2; //x2
                    endcase
                end
            end

            T1: begin
                sel_mult_A = 2'd0; //mult_out_reg
                sel_mult_B = 2'd0; //d
                en_mult = 1'd1;
            end

            T2: begin
                en_count = 1'd1;
                sel_add_A = 1'd0; // mult_out_reg
                case (count)
                    2'd0: begin
                        en_w0 = 1'd1;
                        sel_add_B = 2'd3; //w0
                    end

                    2'd1: begin
                        en_w1 = 1'd1;
                        sel_add_B = 2'd1; //w1
                    end

                    default: begin
                        //count == 2
                        en_w2 = 1'd1;
                        sel_add_B = 2'd0; //w2
                    end
                endcase
            end
        endcase
    end

    always_ff @(posedge clk, negedge reset_l) begin
        if (!reset_l)
            state <= INIT;
        else
            state <= nextState;
    end
endmodule