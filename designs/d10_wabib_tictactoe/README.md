# Tic-Tac-Toe

Wahib Abib
18-224/624 Spring 2023 Final Tapeout Project

## Overview

The classic game of Tic-Tac-Toe on an ASIC, with a built in game AI if the user wants to play by themselves. The chip also supports 2 players competing agasint each other.

## How it Works

The user will first select how many players the game will have by flipping the on-board switch. The user can select what move they would like to make on the Tic-Tac-Toe board by pressing the buttons on the game board. If the move is invalid, the position was already selected, then the user has to select another move. During 1-player mode, the AI will select its move which will be displayed on the game board. During 2-player mode, the next player will be allowed to make their next move. When there is a winner, the game board will reset and and the user will have to press the start button the start a new game.

## Inputs/Outputs

The chip uses an external clock input at 2MHz

9 of the inputs are used for the 9 positions on the tic tac toe board (b0-b8) which are driven by the on-board buttons, 1 input is for selecting 1 or 2 player mode (player_sel), and 1 input is to start the game (start). 9 of the outputs are used to drive onboard LEDs to display the player’s move (led0-led8).

## Hardware Peripherals

There will be 9 on-board buttons for each possible move, 9 on-board LED's to display the current game board, and 1 on-board switch to select the number of players

## Design Testing / Bringup

Once the game board is constructed, the chip can be tested by simply pressing the start button and pressing the on-board positions buttons to see if the move was registered and displayed.
