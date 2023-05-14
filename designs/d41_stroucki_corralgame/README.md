# Corral Game

Michael Stroucken
98-154 Intro to Open-Source Chip Design, Fall 2022

## Description

Implements the Corral game from Basic Computer Games vol 2. 

It has a constrained front end because of the few IO ports available.

Submit values from 1 to 5 in move and assert enter when game asserts ready.

### Inputs

- clock
- reset
- move0             # bit 0 of move
- move1             # bit 1 of move
- move2             # bit 2 of move
- enter             # submit move
- none
- none

### Outputs

- data0         # bit 0 of game data
- data1         # bit 1 of game data
- data2         # bit 2 of game data
- data3         # bit 3 of game data
- gameover      # high if game over
- lostwon       # if game over, then high if won, low if lost
- ready         # high if game is ready for next move
- none
