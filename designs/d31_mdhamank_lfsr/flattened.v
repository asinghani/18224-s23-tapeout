/* Generated by Yosys 0.25+83 (git sha1 755b753e1, aarch64-apple-darwin20.2-clang 10.0.0-4ubuntu1 -fPIC -Os) */

/* top =  1  */
/* src = "d31_mdhamank_lfsr/src/wrapper.v:2.9-13.18" */
module d31_mdhamank_lfsr(io_in, io_out);
  wire _00_;
  wire _01_;
  wire _02_;
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:3.26-3.31" */
  input [13:0] io_in;
  wire [13:0] io_in;
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:4.27-4.33" */
  output [13:0] io_out;
  wire [13:0] io_out;
  /* hdlname = "mchip flipflop1 clk" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:71.16-71.19|d31_mdhamank_lfsr/src/wokwi.v:65.12-69.4" */
  wire \mchip.flipflop1.clk ;
  /* hdlname = "mchip flipflop1 d" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:72.16-72.17|d31_mdhamank_lfsr/src/wokwi.v:65.12-69.4" */
  wire \mchip.flipflop1.d ;
  /* hdlname = "mchip flipflop1 q" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:73.16-73.17|d31_mdhamank_lfsr/src/wokwi.v:65.12-69.4" */
  reg \mchip.flipflop1.q ;
  /* hdlname = "mchip flipflop10 clk" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:71.16-71.19|d31_mdhamank_lfsr/src/wokwi.v:122.12-126.4" */
  wire \mchip.flipflop10.clk ;
  /* hdlname = "mchip flipflop10 q" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:73.16-73.17|d31_mdhamank_lfsr/src/wokwi.v:122.12-126.4" */
  reg \mchip.flipflop10.q ;
  /* hdlname = "mchip flipflop11 clk" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:71.16-71.19|d31_mdhamank_lfsr/src/wokwi.v:127.12-131.4" */
  wire \mchip.flipflop11.clk ;
  /* hdlname = "mchip flipflop11 q" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:73.16-73.17|d31_mdhamank_lfsr/src/wokwi.v:127.12-131.4" */
  reg \mchip.flipflop11.q ;
  /* hdlname = "mchip flipflop12 clk" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:71.16-71.19|d31_mdhamank_lfsr/src/wokwi.v:132.12-136.4" */
  wire \mchip.flipflop12.clk ;
  /* hdlname = "mchip flipflop12 q" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:73.16-73.17|d31_mdhamank_lfsr/src/wokwi.v:132.12-136.4" */
  reg \mchip.flipflop12.q ;
  /* hdlname = "mchip flipflop13 clk" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:71.16-71.19|d31_mdhamank_lfsr/src/wokwi.v:137.12-141.4" */
  wire \mchip.flipflop13.clk ;
  /* hdlname = "mchip flipflop13 q" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:73.16-73.17|d31_mdhamank_lfsr/src/wokwi.v:137.12-141.4" */
  reg \mchip.flipflop13.q ;
  /* hdlname = "mchip flipflop14 clk" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:71.16-71.19|d31_mdhamank_lfsr/src/wokwi.v:142.12-146.4" */
  wire \mchip.flipflop14.clk ;
  /* hdlname = "mchip flipflop14 q" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:73.16-73.17|d31_mdhamank_lfsr/src/wokwi.v:142.12-146.4" */
  reg \mchip.flipflop14.q ;
  /* hdlname = "mchip flipflop15 clk" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:71.16-71.19|d31_mdhamank_lfsr/src/wokwi.v:147.12-151.4" */
  wire \mchip.flipflop15.clk ;
  /* hdlname = "mchip flipflop15 q" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:73.16-73.17|d31_mdhamank_lfsr/src/wokwi.v:147.12-151.4" */
  reg \mchip.flipflop15.q ;
  /* hdlname = "mchip flipflop16 clk" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:71.16-71.19|d31_mdhamank_lfsr/src/wokwi.v:152.12-156.4" */
  wire \mchip.flipflop16.clk ;
  /* hdlname = "mchip flipflop16 q" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:73.16-73.17|d31_mdhamank_lfsr/src/wokwi.v:152.12-156.4" */
  reg \mchip.flipflop16.q ;
  /* hdlname = "mchip flipflop2 clk" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:71.16-71.19|d31_mdhamank_lfsr/src/wokwi.v:60.12-64.4" */
  wire \mchip.flipflop2.clk ;
  /* hdlname = "mchip flipflop2 d" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:72.16-72.17|d31_mdhamank_lfsr/src/wokwi.v:60.12-64.4" */
  wire \mchip.flipflop2.d ;
  /* hdlname = "mchip flipflop2 q" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:73.16-73.17|d31_mdhamank_lfsr/src/wokwi.v:60.12-64.4" */
  reg \mchip.flipflop2.q ;
  /* hdlname = "mchip flipflop3 clk" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:71.16-71.19|d31_mdhamank_lfsr/src/wokwi.v:70.12-74.4" */
  wire \mchip.flipflop3.clk ;
  /* hdlname = "mchip flipflop3 d" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:72.16-72.17|d31_mdhamank_lfsr/src/wokwi.v:70.12-74.4" */
  wire \mchip.flipflop3.d ;
  /* hdlname = "mchip flipflop3 q" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:73.16-73.17|d31_mdhamank_lfsr/src/wokwi.v:70.12-74.4" */
  reg \mchip.flipflop3.q ;
  /* hdlname = "mchip flipflop4 clk" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:71.16-71.19|d31_mdhamank_lfsr/src/wokwi.v:75.12-80.4" */
  wire \mchip.flipflop4.clk ;
  /* hdlname = "mchip flipflop4 d" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:72.16-72.17|d31_mdhamank_lfsr/src/wokwi.v:75.12-80.4" */
  wire \mchip.flipflop4.d ;
  /* hdlname = "mchip flipflop4 notq" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:74.17-74.21|d31_mdhamank_lfsr/src/wokwi.v:75.12-80.4" */
  wire \mchip.flipflop4.notq ;
  /* hdlname = "mchip flipflop4 q" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:73.16-73.17|d31_mdhamank_lfsr/src/wokwi.v:75.12-80.4" */
  reg \mchip.flipflop4.q ;
  /* hdlname = "mchip flipflop5 clk" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:71.16-71.19|d31_mdhamank_lfsr/src/wokwi.v:81.12-85.4" */
  wire \mchip.flipflop5.clk ;
  /* hdlname = "mchip flipflop5 d" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:72.16-72.17|d31_mdhamank_lfsr/src/wokwi.v:81.12-85.4" */
  wire \mchip.flipflop5.d ;
  /* hdlname = "mchip flipflop5 q" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:73.16-73.17|d31_mdhamank_lfsr/src/wokwi.v:81.12-85.4" */
  reg \mchip.flipflop5.q ;
  /* hdlname = "mchip flipflop6 clk" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:71.16-71.19|d31_mdhamank_lfsr/src/wokwi.v:86.12-91.4" */
  wire \mchip.flipflop6.clk ;
  /* hdlname = "mchip flipflop6 d" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:72.16-72.17|d31_mdhamank_lfsr/src/wokwi.v:86.12-91.4" */
  wire \mchip.flipflop6.d ;
  /* hdlname = "mchip flipflop6 notq" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:74.17-74.21|d31_mdhamank_lfsr/src/wokwi.v:86.12-91.4" */
  wire \mchip.flipflop6.notq ;
  /* hdlname = "mchip flipflop6 q" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:73.16-73.17|d31_mdhamank_lfsr/src/wokwi.v:86.12-91.4" */
  reg \mchip.flipflop6.q ;
  /* hdlname = "mchip flipflop7 clk" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:71.16-71.19|d31_mdhamank_lfsr/src/wokwi.v:92.12-96.4" */
  wire \mchip.flipflop7.clk ;
  /* hdlname = "mchip flipflop7 d" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:72.16-72.17|d31_mdhamank_lfsr/src/wokwi.v:92.12-96.4" */
  wire \mchip.flipflop7.d ;
  /* hdlname = "mchip flipflop7 q" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:73.16-73.17|d31_mdhamank_lfsr/src/wokwi.v:92.12-96.4" */
  reg \mchip.flipflop7.q ;
  /* hdlname = "mchip flipflop8 clk" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:71.16-71.19|d31_mdhamank_lfsr/src/wokwi.v:97.12-101.4" */
  wire \mchip.flipflop8.clk ;
  /* hdlname = "mchip flipflop8 d" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:72.16-72.17|d31_mdhamank_lfsr/src/wokwi.v:97.12-101.4" */
  wire \mchip.flipflop8.d ;
  /* hdlname = "mchip flipflop8 q" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:73.16-73.17|d31_mdhamank_lfsr/src/wokwi.v:97.12-101.4" */
  reg \mchip.flipflop8.q ;
  /* hdlname = "mchip flipflop9 clk" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:71.16-71.19|d31_mdhamank_lfsr/src/wokwi.v:117.12-121.4" */
  wire \mchip.flipflop9.clk ;
  /* hdlname = "mchip flipflop9 q" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:73.16-73.17|d31_mdhamank_lfsr/src/wokwi.v:117.12-121.4" */
  reg \mchip.flipflop9.q ;
  /* hdlname = "mchip gate5 in" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:53.16-53.18|d31_mdhamank_lfsr/src/wokwi.v:56.12-59.4" */
  wire \mchip.gate5.in ;
  /* hdlname = "mchip io_in" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:6.15-6.20" */
  /* unused_bits = "3 4 5 6 7" */
  wire [7:0] \mchip.io_in ;
  /* hdlname = "mchip io_out" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:7.16-7.22" */
  wire [7:0] \mchip.io_out ;
  /* hdlname = "mchip mux1 out" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:64.17-64.20|d31_mdhamank_lfsr/src/wokwi.v:157.12-162.4" */
  wire \mchip.mux1.out ;
  /* hdlname = "mchip mux1 sel" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:63.16-63.19|d31_mdhamank_lfsr/src/wokwi.v:157.12-162.4" */
  wire \mchip.mux1.sel ;
  /* hdlname = "mchip mux2 a" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:61.16-61.17|d31_mdhamank_lfsr/src/wokwi.v:163.12-168.4" */
  wire \mchip.mux2.a ;
  /* hdlname = "mchip mux2 b" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:62.16-62.17|d31_mdhamank_lfsr/src/wokwi.v:163.12-168.4" */
  wire \mchip.mux2.b ;
  /* hdlname = "mchip mux2 sel" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:63.16-63.19|d31_mdhamank_lfsr/src/wokwi.v:163.12-168.4" */
  wire \mchip.mux2.sel ;
  /* hdlname = "mchip mux3 a" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:61.16-61.17|d31_mdhamank_lfsr/src/wokwi.v:169.12-174.4" */
  wire \mchip.mux3.a ;
  /* hdlname = "mchip mux3 b" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:62.16-62.17|d31_mdhamank_lfsr/src/wokwi.v:169.12-174.4" */
  wire \mchip.mux3.b ;
  /* hdlname = "mchip mux3 sel" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:63.16-63.19|d31_mdhamank_lfsr/src/wokwi.v:169.12-174.4" */
  wire \mchip.mux3.sel ;
  /* hdlname = "mchip mux4 a" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:61.16-61.17|d31_mdhamank_lfsr/src/wokwi.v:175.12-180.4" */
  wire \mchip.mux4.a ;
  /* hdlname = "mchip mux4 b" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:62.16-62.17|d31_mdhamank_lfsr/src/wokwi.v:175.12-180.4" */
  wire \mchip.mux4.b ;
  /* hdlname = "mchip mux4 sel" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:63.16-63.19|d31_mdhamank_lfsr/src/wokwi.v:175.12-180.4" */
  wire \mchip.mux4.sel ;
  /* hdlname = "mchip mux5 a" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:61.16-61.17|d31_mdhamank_lfsr/src/wokwi.v:181.12-186.4" */
  wire \mchip.mux5.a ;
  /* hdlname = "mchip mux5 b" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:62.16-62.17|d31_mdhamank_lfsr/src/wokwi.v:181.12-186.4" */
  wire \mchip.mux5.b ;
  /* hdlname = "mchip mux5 sel" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:63.16-63.19|d31_mdhamank_lfsr/src/wokwi.v:181.12-186.4" */
  wire \mchip.mux5.sel ;
  /* hdlname = "mchip mux6 a" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:61.16-61.17|d31_mdhamank_lfsr/src/wokwi.v:187.12-192.4" */
  wire \mchip.mux6.a ;
  /* hdlname = "mchip mux6 b" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:62.16-62.17|d31_mdhamank_lfsr/src/wokwi.v:187.12-192.4" */
  wire \mchip.mux6.b ;
  /* hdlname = "mchip mux6 sel" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:63.16-63.19|d31_mdhamank_lfsr/src/wokwi.v:187.12-192.4" */
  wire \mchip.mux6.sel ;
  /* hdlname = "mchip mux7 a" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:61.16-61.17|d31_mdhamank_lfsr/src/wokwi.v:193.12-198.4" */
  wire \mchip.mux7.a ;
  /* hdlname = "mchip mux7 b" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:62.16-62.17|d31_mdhamank_lfsr/src/wokwi.v:193.12-198.4" */
  wire \mchip.mux7.b ;
  /* hdlname = "mchip mux7 sel" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:63.16-63.19|d31_mdhamank_lfsr/src/wokwi.v:193.12-198.4" */
  wire \mchip.mux7.sel ;
  /* hdlname = "mchip mux8 a" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:61.16-61.17|d31_mdhamank_lfsr/src/wokwi.v:199.12-204.4" */
  wire \mchip.mux8.a ;
  /* hdlname = "mchip mux8 b" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:62.16-62.17|d31_mdhamank_lfsr/src/wokwi.v:199.12-204.4" */
  wire \mchip.mux8.b ;
  /* hdlname = "mchip mux8 sel" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:63.16-63.19|d31_mdhamank_lfsr/src/wokwi.v:199.12-204.4" */
  wire \mchip.mux8.sel ;
  /* hdlname = "mchip mux9 a" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:61.16-61.17|d31_mdhamank_lfsr/src/wokwi.v:205.12-210.4" */
  wire \mchip.mux9.a ;
  /* hdlname = "mchip mux9 b" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:62.16-62.17|d31_mdhamank_lfsr/src/wokwi.v:205.12-210.4" */
  wire \mchip.mux9.b ;
  /* hdlname = "mchip mux9 sel" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:63.16-63.19|d31_mdhamank_lfsr/src/wokwi.v:205.12-210.4" */
  wire \mchip.mux9.sel ;
  /* hdlname = "mchip net1" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:9.8-9.12" */
  wire \mchip.net1 ;
  /* hdlname = "mchip net10" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:18.8-18.13" */
  wire \mchip.net10 ;
  /* hdlname = "mchip net11" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:19.8-19.13" */
  wire \mchip.net11 ;
  /* hdlname = "mchip net12" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:20.8-20.13" */
  wire \mchip.net12 ;
  /* hdlname = "mchip net13" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:21.8-21.13" */
  wire \mchip.net13 ;
  /* hdlname = "mchip net15" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:23.8-23.13" */
  wire \mchip.net15 ;
  /* hdlname = "mchip net16" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:24.8-24.13" */
  wire \mchip.net16 ;
  /* hdlname = "mchip net17" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:25.8-25.13" */
  wire \mchip.net17 ;
  /* hdlname = "mchip net18" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:26.8-26.13" */
  wire \mchip.net18 ;
  /* hdlname = "mchip net19" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:27.8-27.13" */
  wire \mchip.net19 ;
  /* hdlname = "mchip net2" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:10.8-10.12" */
  wire \mchip.net2 ;
  /* hdlname = "mchip net20" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:28.8-28.13" */
  wire \mchip.net20 ;
  /* hdlname = "mchip net21" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:29.8-29.13" */
  wire \mchip.net21 ;
  /* hdlname = "mchip net22" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:30.8-30.13" */
  wire \mchip.net22 ;
  /* hdlname = "mchip net23" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:31.8-31.13" */
  wire \mchip.net23 ;
  /* hdlname = "mchip net24" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:32.8-32.13" */
  wire \mchip.net24 ;
  /* hdlname = "mchip net25" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:33.8-33.13" */
  wire \mchip.net25 ;
  /* hdlname = "mchip net26" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:34.8-34.13" */
  wire \mchip.net26 ;
  /* hdlname = "mchip net3" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:11.8-11.12" */
  wire \mchip.net3 ;
  /* hdlname = "mchip net4" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:12.8-12.12" */
  wire \mchip.net4 ;
  /* hdlname = "mchip net5" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:13.8-13.12" */
  wire \mchip.net5 ;
  /* hdlname = "mchip net6" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:14.8-14.12" */
  wire \mchip.net6 ;
  /* hdlname = "mchip net7" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:15.8-15.12" */
  wire \mchip.net7 ;
  /* hdlname = "mchip net8" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:16.8-16.12" */
  wire \mchip.net8 ;
  /* hdlname = "mchip net9" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/wokwi.v:17.8-17.12" */
  wire \mchip.net9 ;
  /* hdlname = "mchip xor2 a" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:35.16-35.17|d31_mdhamank_lfsr/src/wokwi.v:107.12-111.4" */
  wire \mchip.xor2.a ;
  /* hdlname = "mchip xor2 b" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:36.16-36.17|d31_mdhamank_lfsr/src/wokwi.v:107.12-111.4" */
  wire \mchip.xor2.b ;
  /* hdlname = "mchip xor3 a" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:35.16-35.17|d31_mdhamank_lfsr/src/wokwi.v:112.12-116.4" */
  wire \mchip.xor3.a ;
  /* hdlname = "mchip xor3 b" */
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:36.16-36.17|d31_mdhamank_lfsr/src/wokwi.v:112.12-116.4" */
  wire \mchip.xor3.b ;
  assign \mchip.flipflop8.d  = ~\mchip.flipflop6.q ;
  assign \mchip.flipflop5.d  = ~\mchip.flipflop4.q ;
  assign _00_ = \mchip.flipflop7.q  ^ \mchip.flipflop8.q ;
  assign _01_ = \mchip.flipflop5.q  ^ \mchip.flipflop4.q ;
  assign _02_ = ~(_01_ ^ _00_);
  assign \mchip.flipflop2.d  = ~(_02_ & io_in[1]);
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:78.5-79.16|d31_mdhamank_lfsr/src/wokwi.v:142.12-146.4" */
  always @(posedge io_in[12])
    if (!io_in[2]) \mchip.flipflop14.q  <= \mchip.flipflop6.q ;
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:78.5-79.16|d31_mdhamank_lfsr/src/wokwi.v:137.12-141.4" */
  always @(posedge io_in[12])
    if (!io_in[2]) \mchip.flipflop13.q  <= \mchip.flipflop5.q ;
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:78.5-79.16|d31_mdhamank_lfsr/src/wokwi.v:132.12-136.4" */
  always @(posedge io_in[12])
    if (!io_in[2]) \mchip.flipflop12.q  <= \mchip.flipflop4.q ;
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:78.5-79.16|d31_mdhamank_lfsr/src/wokwi.v:127.12-131.4" */
  always @(posedge io_in[12])
    if (!io_in[2]) \mchip.flipflop11.q  <= \mchip.flipflop3.q ;
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:78.5-79.16|d31_mdhamank_lfsr/src/wokwi.v:122.12-126.4" */
  always @(posedge io_in[12])
    if (!io_in[2]) \mchip.flipflop10.q  <= \mchip.flipflop1.q ;
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:78.5-79.16|d31_mdhamank_lfsr/src/wokwi.v:152.12-156.4" */
  always @(posedge io_in[12])
    if (!io_in[2]) \mchip.flipflop16.q  <= \mchip.flipflop8.q ;
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:78.5-79.16|d31_mdhamank_lfsr/src/wokwi.v:97.12-101.4" */
  always @(posedge io_in[12])
    \mchip.flipflop8.q  <= \mchip.flipflop8.d ;
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:78.5-79.16|d31_mdhamank_lfsr/src/wokwi.v:92.12-96.4" */
  always @(posedge io_in[12])
    \mchip.flipflop7.q  <= \mchip.flipflop5.q ;
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:78.5-79.16|d31_mdhamank_lfsr/src/wokwi.v:86.12-91.4" */
  always @(posedge io_in[12])
    \mchip.flipflop6.q  <= \mchip.flipflop7.q ;
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:78.5-79.16|d31_mdhamank_lfsr/src/wokwi.v:81.12-85.4" */
  always @(posedge io_in[12])
    \mchip.flipflop5.q  <= \mchip.flipflop5.d ;
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:78.5-79.16|d31_mdhamank_lfsr/src/wokwi.v:75.12-80.4" */
  always @(posedge io_in[12])
    \mchip.flipflop4.q  <= \mchip.flipflop1.q ;
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:78.5-79.16|d31_mdhamank_lfsr/src/wokwi.v:70.12-74.4" */
  always @(posedge io_in[12])
    \mchip.flipflop3.q  <= \mchip.flipflop2.q ;
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:78.5-79.16|d31_mdhamank_lfsr/src/wokwi.v:65.12-69.4" */
  always @(posedge io_in[12])
    \mchip.flipflop1.q  <= \mchip.flipflop3.q ;
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:78.5-79.16|d31_mdhamank_lfsr/src/wokwi.v:60.12-64.4" */
  always @(posedge io_in[12])
    \mchip.flipflop2.q  <= \mchip.flipflop2.d ;
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:78.5-79.16|d31_mdhamank_lfsr/src/wokwi.v:117.12-121.4" */
  always @(posedge io_in[12])
    if (!io_in[2]) \mchip.flipflop9.q  <= \mchip.flipflop2.q ;
  /* src = "d31_mdhamank_lfsr/src/wrapper.v:8.44-11.14|d31_mdhamank_lfsr/src/cells.v:78.5-79.16|d31_mdhamank_lfsr/src/wokwi.v:147.12-151.4" */
  always @(posedge io_in[12])
    if (!io_in[2]) \mchip.flipflop15.q  <= \mchip.flipflop7.q ;
  assign io_out = { 6'h00, \mchip.flipflop16.q , \mchip.flipflop14.q , \mchip.flipflop15.q , \mchip.flipflop13.q , \mchip.flipflop12.q , \mchip.flipflop10.q , \mchip.flipflop11.q , \mchip.flipflop9.q  };
  assign \mchip.flipflop1.clk  = io_in[12];
  assign \mchip.flipflop1.d  = \mchip.flipflop3.q ;
  assign \mchip.flipflop10.clk  = io_in[12];
  assign \mchip.flipflop11.clk  = io_in[12];
  assign \mchip.flipflop12.clk  = io_in[12];
  assign \mchip.flipflop13.clk  = io_in[12];
  assign \mchip.flipflop14.clk  = io_in[12];
  assign \mchip.flipflop15.clk  = io_in[12];
  assign \mchip.flipflop16.clk  = io_in[12];
  assign \mchip.flipflop2.clk  = io_in[12];
  assign \mchip.flipflop3.clk  = io_in[12];
  assign \mchip.flipflop3.d  = \mchip.flipflop2.q ;
  assign \mchip.flipflop4.clk  = io_in[12];
  assign \mchip.flipflop4.d  = \mchip.flipflop1.q ;
  assign \mchip.flipflop4.notq  = \mchip.flipflop5.d ;
  assign \mchip.flipflop5.clk  = io_in[12];
  assign \mchip.flipflop6.clk  = io_in[12];
  assign \mchip.flipflop6.d  = \mchip.flipflop7.q ;
  assign \mchip.flipflop6.notq  = \mchip.flipflop8.d ;
  assign \mchip.flipflop7.clk  = io_in[12];
  assign \mchip.flipflop7.d  = \mchip.flipflop5.q ;
  assign \mchip.flipflop8.clk  = io_in[12];
  assign \mchip.flipflop9.clk  = io_in[12];
  assign \mchip.gate5.in  = io_in[1];
  assign \mchip.io_in  = { io_in[7:1], io_in[12] };
  assign \mchip.io_out  = { \mchip.flipflop16.q , \mchip.flipflop14.q , \mchip.flipflop15.q , \mchip.flipflop13.q , \mchip.flipflop12.q , \mchip.flipflop10.q , \mchip.flipflop11.q , \mchip.flipflop9.q  };
  assign \mchip.mux1.out  = \mchip.flipflop2.d ;
  assign \mchip.mux1.sel  = io_in[1];
  assign \mchip.mux2.a  = \mchip.flipflop2.q ;
  assign \mchip.mux2.b  = \mchip.flipflop9.q ;
  assign \mchip.mux2.sel  = io_in[2];
  assign \mchip.mux3.a  = \mchip.flipflop3.q ;
  assign \mchip.mux3.b  = \mchip.flipflop11.q ;
  assign \mchip.mux3.sel  = io_in[2];
  assign \mchip.mux4.a  = \mchip.flipflop1.q ;
  assign \mchip.mux4.b  = \mchip.flipflop10.q ;
  assign \mchip.mux4.sel  = io_in[2];
  assign \mchip.mux5.a  = \mchip.flipflop4.q ;
  assign \mchip.mux5.b  = \mchip.flipflop12.q ;
  assign \mchip.mux5.sel  = io_in[2];
  assign \mchip.mux6.a  = \mchip.flipflop5.q ;
  assign \mchip.mux6.b  = \mchip.flipflop13.q ;
  assign \mchip.mux6.sel  = io_in[2];
  assign \mchip.mux7.a  = \mchip.flipflop7.q ;
  assign \mchip.mux7.b  = \mchip.flipflop15.q ;
  assign \mchip.mux7.sel  = io_in[2];
  assign \mchip.mux8.a  = \mchip.flipflop6.q ;
  assign \mchip.mux8.b  = \mchip.flipflop14.q ;
  assign \mchip.mux8.sel  = io_in[2];
  assign \mchip.mux9.a  = \mchip.flipflop8.q ;
  assign \mchip.mux9.b  = \mchip.flipflop16.q ;
  assign \mchip.mux9.sel  = io_in[2];
  assign \mchip.net1  = io_in[12];
  assign \mchip.net10  = \mchip.flipflop14.q ;
  assign \mchip.net11  = \mchip.flipflop16.q ;
  assign \mchip.net12  = 1'h0;
  assign \mchip.net13  = 1'h1;
  assign \mchip.net15  = 1'h1;
  assign \mchip.net16  = \mchip.flipflop2.d ;
  assign \mchip.net17  = \mchip.flipflop2.q ;
  assign \mchip.net18  = \mchip.flipflop3.q ;
  assign \mchip.net19  = \mchip.flipflop1.q ;
  assign \mchip.net2  = io_in[1];
  assign \mchip.net20  = \mchip.flipflop4.q ;
  assign \mchip.net21  = \mchip.flipflop5.d ;
  assign \mchip.net22  = \mchip.flipflop5.q ;
  assign \mchip.net23  = \mchip.flipflop7.q ;
  assign \mchip.net24  = \mchip.flipflop6.q ;
  assign \mchip.net25  = \mchip.flipflop8.d ;
  assign \mchip.net26  = \mchip.flipflop8.q ;
  assign \mchip.net3  = io_in[2];
  assign \mchip.net4  = \mchip.flipflop9.q ;
  assign \mchip.net5  = \mchip.flipflop11.q ;
  assign \mchip.net6  = \mchip.flipflop10.q ;
  assign \mchip.net7  = \mchip.flipflop12.q ;
  assign \mchip.net8  = \mchip.flipflop13.q ;
  assign \mchip.net9  = \mchip.flipflop15.q ;
  assign \mchip.xor2.a  = \mchip.flipflop7.q ;
  assign \mchip.xor2.b  = \mchip.flipflop8.q ;
  assign \mchip.xor3.a  = \mchip.flipflop4.q ;
  assign \mchip.xor3.b  = \mchip.flipflop5.q ;
endmodule
