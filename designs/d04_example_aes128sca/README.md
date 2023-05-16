# Example Design: AES-128 Side Channel Model

An implementation of the first round of AES-128 encryption (one AddRoundKey step and one SubBytes step), to be used for side-channel attack analysis.

There are separation cycles between each step to make it easier to distinguish different operations in the power trace.

`clock` = the clock input to the counter
`reset` = resets the counter to zero when asserted

`io_in[7:0]` = byte input
`io_in[8]` = key input enable (shifts one byte into the "key" register on every rising edge of this signal)
`io_in[9]` = plaintext input enable (shifts one byte into the "plaintext" register on every rising edge of this signal)
`io_in[10]` = start (starts the AES operation on every rising edge of the signal)

`io_out[7:0]` = byte output
`io_out[8]` = active (raised when AES operation is running)

