`default_nettype none

// phase-locked loop that takes in a square wave (i.e. reference clock signal)
// and attempts to generate a new square wave that matches the input in phase (i.e. reconstructed clock signal)
// first, a phase detector is used to compare the reference signal to the reconstructed signal
// if the reconstructed signal leads the reference, then it should "slow down"
// if the reconstructed signal lags the reference, then it should "speed up"
// this information is used to alter the output of the digitally-controlled oscillator accordingly
// viewing i_ref_clk and the output signals on an oscilloscope will help determine how well the PLL functions
// for best results, i_freq_step should be set so that o_rec_clk has roughly the same frequency as i_ref_clk
module phase_locked_loop (
  input wire i_sys_clk, // global system clock
  input wire i_rst, // global reset
  input wire i_ref_clk, // reference clock signal
  input wire [2:0] i_loop_gain, // changes the rate at which we lock onto the phase
  input wire [7:0] i_freq_step, // changes the rate at which the reconstructed signal changes (i.e. its frequency)
  output reg o_rec_clk, // reconstructed clock signal
  output wire o_lead_or_lag, // 1 if leading, 0 if lagging
  output wire o_phase_error // 1 if out-of-phase, 0 if in-phase
  );

  // detect whether the reference and reconstructed clocks are out of phase and, if so, which is ahead/behind
  wire out_of_phase;
  reg lead_or_lag; // 1 for lead, 0 for lag
  phase_detector phase_det(.i_sys_clk(i_sys_clk), .ref_clk(i_ref_clk), .rec_clk(o_rec_clk),
                                .lead_or_lag(lead_or_lag), .out_of_phase(out_of_phase));

  // determine phase correction factor based on loop gain, as controlled by user input
  reg [7:0] phase_corr;
  loop_filter loop_fil(.i_sys_clk(i_sys_clk), .loop_gain(i_loop_gain),
                                .phase_corr(phase_corr));

  // change the generated signal frequency as needed, using the input frequency step and loop gain as defined by the user input
  digital_oscillator dig_osc(.i_sys_clk(i_sys_clk), .i_rst(i_rst), .freq_step(i_freq_step),
                                .phase_corr(phase_corr), .out_of_phase(out_of_phase), .lead_or_lag(lead_or_lag),
                                .rec_clk(o_rec_clk));
 
  // assign outputs - useful for viewing performance of PLL
  assign o_phase_error = out_of_phase;
  assign o_lead_or_lag = lead_or_lag; 

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, phase_locked_loop);
  end

endmodule

// detects phase by using digital logic to evaluate which signal changed first,
// thereby telling us whether we're leading or lagging the reference clock
module phase_detector (
    input wire i_sys_clk,
    input wire ref_clk,
    input wire rec_clk,
    output reg lead_or_lag,
    output wire out_of_phase
    );  
  reg matched; // track whenever the two signals are in-phase
  initial matched = 0;

  // determine whether the two clocks are currently matched
  always @(posedge i_sys_clk)
  begin
	  if (ref_clk && rec_clk) // both clocks are high
		  matched <= 1'b1;
	  else if ((!ref_clk) && (!rec_clk)) // both clocks are low
		  matched <= 1'b0;
  end

  // whenever the reference or generated signals change, we should check which changed first
  always @(*)
	  if (matched)
		  lead_or_lag = ref_clk && !rec_clk; // we're leading since rec went low before ref
	  else
		  lead_or_lag = !ref_clk && rec_clk; // we're lagging since ref went low before rec
  
  assign out_of_phase = ref_clk != rec_clk; // if the two clocks don't match, we're out of phase

endmodule

// applies loop gain factor of 2^(-loop_gain)
// larger loop gains causes the PLL to lock faster, but possibly with more oscillations
// see wiki article on numerically-controlled oscillators for further detail
module loop_filter (
    input wire i_sys_clk,
    input wire [2:0] loop_gain,
    output reg [7:0] phase_corr
    );

  initial phase_corr = 0;
  
  always @(posedge i_sys_clk)
    phase_corr <= ({8'b10000000} >> loop_gain);

endmodule

// uses an internal counter to generate a clock signal
// this clock signal will change frequency based on how out-of-phase it is
// compared to the reference signal at the top-level module
module digital_oscillator (
   input wire i_sys_clk,
   input wire i_rst,
   input wire [7:0] freq_step, // changes rate at which clock changes
   input wire [7:0] phase_corr, // changes how fast the clock changes based on phase error
   input wire out_of_phase, // ref_clk not in phase with counter
   input wire lead_or_lag, // tells us whether we're leading or lagging
   output wire rec_clk // our PLL output
   );

  reg [7:0] ctr; // this is used to generate our square wave output
  
  always @(posedge i_sys_clk) begin
    if (i_rst) begin
        ctr <= 0;
    end else begin // now use phase error to determine how much we speed up or slow down the counter
        if (!out_of_phase) // we're in phase so keep incremening as usual
		ctr <= ctr + freq_step;
	else if (lead_or_lag && (phase_corr < freq_step)) // we're leading, so slow down the clock with phase correction
		ctr <= ctr + freq_step - phase_corr; // but check that we don't decrement the clock value
	else // we're lagging, so speed up the clock
		ctr <= ctr + freq_step + phase_corr;
    end
  end

  assign rec_clk = ctr[7]; // take the MSB of our counter as the regenerated clock signal

endmodule

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);
	
    	// we run at a 1 kHz clock
    
	phase_locked_loop PLL(.i_sys_clk(clock),
			  .i_rst(!reset),
			  .i_ref_clk(io_in[0]),
			  .i_loop_gain(io_in[3:1]),
			  .i_freq_step(io_in[11:4]),
			  .o_rec_clk(io_out[0]),
			  .o_lead_or_lag(io_out[1]),
			  .o_phase_error(io_out[2]));

endmodule
