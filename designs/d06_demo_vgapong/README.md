# Example Design: Pong Game

Run at 640x480 resolution (25MHz pixel clock). Pinout:

```
io_out[7] = red[1]
io_out[6] = red[0]
io_out[5] = green[1]
io_out[4] = green[0]
io_out[3] = blue[1]
io_out[2] = blue[0]
io_out[1] = vsync
io_out[0] = hsync

io_in[5] = serve
io_in[4] = game reset
io_in[3] = right player DOWN
io_in[2] = right player UP
io_in[1] = left player DOWN
io_in[0] = left player UP
```

