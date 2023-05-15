# Example Design: Counter

A resettable counter.

`clock` = the clock input to the counter
`reset` = resets the counter to zero when asserted
`io_out[11:0]` = the counter output
`io_in[0]` = enable (1 = count, 0 = don't count)
`io_in[1]` = up/down (1 = down, 0 = up)
