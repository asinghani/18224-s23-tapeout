# Example Design: Endless Runner Game

Run at 640x480 resolution (25MHz pixel clock). Pinout:

```
io_out[5] = blue
io_out[4] = green
io_out[3] = red
io_out[2] = pixel
io_out[1] = vsync
io_out[0] = hsync

io_in[11] = enable config
io_in[10:7] = accel config
io_in[6:3] = speed config
io_in[2] = debug
io_in[1] = halt
io_in[0] = jump
```
