# Tetris

Rashi Kejriwal
18-224/624 Spring 2023 Final Tapeout Project

## Overview
A simplified implementation of Tetris in SystemVerilog. This will include a 8 x 16 matrix of 1 bit registers that will maintain the game state with pseudo-random tetromino generation, one direction rotation, and right (wrap around) movement.

## How it Works
The Datapath will include the game state matrix. This will contain the pieces that have fallen and have collided with the board edges or with another piece. The game will wait for the start_game button to be pressed. Once this is pressed, the state will transition, and a random piece will appear on the top, right corner of the board. Then, state will transition again. The x and y position of one block of the piece will be maintained in registers and the random piece selected will also be saved in a register to obtain the location of the other blocks. Then the state will transition again, and the y position will increase based on the clock, and x and y based on the other inputs. Once the collision is detected which will be checked every cycle with the game state matrix the piece will update the matrix. Lastly, there will be a transition back to the falling piece state and this will continue until a collision with the top board has been detected and then the game will be over. When a row is cleared, the matrix will be shifted accordingly with logic. The FSM will have 5 states including Start, New Piece, Falling Piece, Collision, and Game Over. Each of these states will maintain how the game state matrix can be modified. 

## Inputs/Outputs
Inputs: Left, Right, Read_gs, Clock, Reset
Outputs: Game state

## Hardware Peripherals
The external hardware peripherals are up to the user. The chip will output the Tetris game state 8 bits at a time. This 
should be read serially by a microcontroller and then can be hooked up with any form of matrix display such as an LED matrix.

