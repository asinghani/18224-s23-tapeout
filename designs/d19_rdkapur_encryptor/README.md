# NoFish

Roman Kapur
18-224/624 Spring 2023 Final Tapeout Project

## Overview

Cryptographic accelator for a example algorithem. The algorithem uses substitution boxes and was an intro to cryptography for myself, loosely based off blowfish. Key and word size are both limited to 16 bits. Entry to key and intxt register are SIPO interfaces. Output is single hexadecimal value from one of 4 16 bit types (key, intxt, decrypt intext, encrypt intext)

## How it Works

Combinational calculation of sbox and P keys done through xor. 

## Inputs/Outputs

2 bit input - mode select
4 bit input - hexidecimal output select
1 bit input - 0/1 for key/intxt entry
1 bit input - key ready, this tells selected SIPO register to shift in a bit

8 bits of output for 7 segment display 

## Hardware Peripherals

Dip switches to control input
7 Segment display output 

## Design Testing / Bringup

Inputting a key of BEEF and intxt of BEEF will produce the out text of 6301 
