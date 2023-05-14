module jxli_fp8mul (input [7:0] io_in, output [7:0] io_out);  
  // 7   6   5   4   3   2   1   0
  //###  DATA........... EN  RST CLK

  enum logic [3:0] {
    AHIGH, ALOW,
    BHIGH, BLOW,
    CALC1, // load
    CALC2, // special cases + denorm
    CALC3,
    CALC4,
    CALC5,
    CALC6,
    CALC7,
    CALC8,
    FINISH
  } state;

  wire clock  = io_in[0];
  wire reset  = io_in[1];
  wire enable  = io_in[2];
  wire [3:0] data = io_in[6:3];

  // E4M3
  // 5 bits exponent registers
  reg [4:0] ae, be, ce;
  // 4 bits mantissa registers
  reg [3:0] am, bm, cm;

  reg [7:0] a, b, c;

  assign io_out = c;

  logic aNaN, bNaN, aInfty, bInfty, aZero, bZero;
  assign aNaN = ($signed(ae) == 8) && (am != 0);
  assign bNaN = ($signed(be) == 8) && (bm != 0);
  assign aInfty = ($signed(ae) == 8) && (am == 0);
  assign bInfty = ($signed(be) == 8) && (bm == 0);
  assign aZero = ($signed(ae) == -7) && (am == 0);
  assign bZero = ($signed(be) == -7) && (bm == 0);
  logic [6:0] NaN, infty;
  assign NaN = 7'b1111_111;
  assign infty = 7'b1111_000;

  logic [7:0] product;
  assign product = am * bm;

  always_ff @(posedge clock) begin
    case(state)
      AHIGH: begin
        if (enable) begin
          a[7:4] <= data;
          state <= ALOW;
        end
      end

      ALOW: begin
        if (enable) begin
          a[3:0] <= data;
          state <= BHIGH;
        end
      end

      BHIGH: begin
        if (enable) begin
          b[7:4] <= data;
          state <= BLOW;
        end
      end

      BLOW: begin
        if (enable) begin
        b[3:0] <= data;
        state <= CALC1;
        end
      end

      CALC1: begin
        ae <= {1'b0, a[6:3]} - 5'd7;
        am <= {1'b0, a[2:0]};
        be <= {1'b0, b[6:3]} - 5'd7;
        bm <= {1'b0, b[2:0]};
        c[7] <= a[7] ^ b[7];
        state <= CALC2;
      end

      CALC2: begin
        // Process all cases where NaN, Inf, or ±0 appear in input
        state <= FINISH;
        if (aNaN || bNaN) begin 
          c[6:0] <= NaN;
        end else if (aInfty) begin 
          // a or b is infty, c is infty
          if (bZero)
            c[6:0] <= NaN;
          else
            c[6:0] <= infty;
        end else if (bInfty) begin
          if (aZero) 
            c[6:0] <= NaN;
          else
            c[6:0] <= infty;
        end else if (aZero || bZero) begin
          // a == 0 or b == 0, c = 0
          c[6:0] <= 7'd0;
        end else begin
          // denormalize numbers
          state <= CALC3;
          if ($signed(ae) == -7) begin
            ae <= -7;
          end else begin
            am[3] <= 1;
          end
          if ($signed(be) == -7) begin
            be <= -7;
          end else begin
            bm[3] <= 1;
          end
        end
      end

      // Align mantissa of a
      CALC3: begin
        if (am[3]) begin
          state <= CALC4;
        end else begin
          am <= am << 1;
          ae <= ae - 1;
        end
      end

      // Align mantissa of b
      CALC4: begin
        if (bm[3]) begin
          state <= CALC5;
        end else begin
          bm <= bm << 1;
          be <= be - 1;
        end
      end

      // Perform computation, no rounding behavior
      CALC5: begin
        ce <= ae + be + 1;
        cm <= product[7:3];
        state <= CALC6;
      end

      // Create normalized format
      CALC6: begin
        if (cm[3]) begin
          state <= CALC7;
        end else begin
          cm <= cm << 1;
          ce <= ce - 1;
        end
      end

      // Part 2
      CALC7: begin
        if ($signed(ce) < -6) begin
          ce <= ce + 1;
          cm <= cm >> 1;
        end else begin
          state <= CALC8;
        end
      end

      // Pack into output register, 
      // Detect denormalized number
      // Detect overflow
      CALC8: begin
        c[6:3] <= ce[3:0] + 7;
        c[2:0] <= cm[2:0];
        if ($signed(ce) == -6 && cm[3] == 0) begin
          c[6:3] <= 0;
        end

        if ($signed(ce) > 7) begin
          c[6:0] <= infty;
        end

        state <= FINISH;
      end

      FINISH: begin
      end
      
    endcase

    if(reset) begin
      state <= AHIGH;
      c <= 8'b1111_1111;
    end
    
  end


endmodule
