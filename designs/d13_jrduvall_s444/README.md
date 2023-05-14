# FPGA, "from scratch"

Jack Duvall, 18-224 Spring 2023

Synthesizing FPGAs is not a new concept [citation needed]. However,
synthesizing an FPGA this laughably underpowered, is! It is a stretch to even
call this an FPGA, so instead I should probably be calling it a single S444
logic cell, capable of simulating a LUT5 and storing 2 bits. [insert: it ain't
much but it's honest work meme].

## How It Works

I took this:

![A diagram of an S444 logic cell](https://assets.chaos.social/media_attachments/files/110/026/931/020/246/360/original/2f1ade7ba8151455.png)

and turned it into SystemVerilog. and hooked it up to the tapeout's debug
interface. that is it :)

## Testing

The testing harness is run with CocoTB, so have that installed or something,
and then run `make` and wait like 15 seconds for the test to actually start
since CocoTB is a great testing library.
