# Async FIFO

Jon Recta
98-154 Intro to Open-Source Chip Design, Fall 2022

## Description

A very small asynchonous FIFO.

After reset, run write_clock and assert write_enable with some data on wdata, then while run_clock is running, assert read_enable. If write_enable is asserted while full is high, the data will be rejected. If read_enable is asserted while empty is high, read_data is invalid.

### Inputs

- write_clock
- read_clock
- reset
- write_enable
- read_enable
- wdata[0]
- wdata[1]
- wdata[2]

### Outputs

- none
- none
- none
- fifo_full
- fifo_empty
- rdata[0]
- rdata[1]
- rdata[2]
