# load standard Python modules
import time

# load the CircuitPython hardware definition module for pin definitions
import board
import busio

# input output packages
import digitalio

# address constants
BTN_ADDR = 0x6f
LCD_ADDR = 0x72
CHIP_ADDR = 0x20

led = digitalio.DigitalInOut(board.LED)
led.direction = digitalio.Direction.OUTPUT

i2c = busio.I2C(scl=board.GP5, sda=board.GP4, frequency=100000)
uart = busio.UART(tx=board.GP12, rx=board.GP13, baudrate=19200, receiver_buffer_size=1, timeout=.01) 

def checkDevices():
    while not i2c.try_lock():
        time.sleep(0.1)
    l = i2c.scan()
    i2c.unlock()
    return l

def writeBtnLED(brightness):
    while not i2c.try_lock():
        time.sleep(0.1)
    data_write = bytearray([0x19, brightness])
    i2c.writeto(BTN_ADDR, data_write)
    i2c.unlock()

def readBtnStatus():
    while not i2c.try_lock():
        time.sleep(0.1)

    data_write = bytearray([0x03])
    data_read = bytearray(1)

    i2c.writeto_then_readfrom(BTN_ADDR, data_write, data_read)

    i2c.unlock()
    return bool(data_read[0] & 0x04)

def writeLCD(text):
    while not i2c.try_lock():
        time.sleep(0.1)
    i2c.writeto(LCD_ADDR, text)
    i2c.unlock()

def clearLCD():
    while not i2c.try_lock():
        time.sleep(0.1)
    data_write = bytearray([0x7c, 0x2d])
    i2c.writeto(LCD_ADDR, data_write)
    i2c.unlock()

def setBackLight(r, g, b):
    while not i2c.try_lock():
        time.sleep(0.1)
    data_write = bytearray([0x7c, 0x2b, r, g, b])
    i2c.writeto(LCD_ADDR, data_write)
    i2c.unlock()


def writeReg(reg, data):
    while not i2c.try_lock():
        time.sleep(0.1)
    data_write = bytearray([reg] + data)
    try:
        i2c.writeto(CHIP_ADDR, data_write)
    except:
        print("Write failed")
    i2c.unlock()

def readReg(reg, num):
    while not i2c.try_lock():
        time.sleep(0.1)
    data = bytearray(num)
    try:
        i2c.writeto_then_readfrom(CHIP_ADDR, bytearray([reg]), data)
    except:
        print("Read failed")
    i2c.unlock()
    return list(data)

def drivePWM1(high, period):
    hLSB = high % (1<<8)
    hMSB = (high - hLSB)>>8
    pLSB = period % (1<<8)
    pMSB = (period - pLSB)>>8
    writeReg(0x02, [hLSB, hMSB])
    writeReg(0x04, [pLSB, pMSB])
    writeReg(0x06, [0x2F])

def drivePWM2(high, period):
    hLSB = high % (1<<8)
    hMSB = (high - hLSB)>>8
    pLSB = period % (1<<8)
    pMSB = (period - pLSB)>>8
    writeReg(0x07, [hLSB, hMSB])
    writeReg(0x09, [pLSB, pMSB])
    writeReg(0x0b, [0x01])

print("Begining script")
d = list(range(0, 24))
writeReg(0, d)
count = 0
while True:

    #print(checkDevices())
    
    if readBtnStatus():
        count += 1
    else:
        count -= 1
    if count > 255:
        count = 255
    elif count < 0:
        count = 0

    clearLCD()
    writeLCD(f"{count}")
    writeReg(0x01, [count])
    time.sleep(.01)
    writeBtnLED(5*readBtnStatus())
    drivePWM1((count)<<4, 255<<4)
    drivePWM2(count, 255)
    time.sleep(.01)

    print(readReg(0x0, 24))

    color_t = readReg(0x0, 1)[0] 
    r_t = int(((color_t & 0b00110000) << 2) * 1.3)
    g_t = int(((color_t & 0b00001100) << 4) * 1.3)
    b_t = int(((color_t & 0b00000011) << 6) * 1.3)
    writeReg(0x10, [r_t, g_t, b_t])
    color = readReg(0x10, 3)
    setBackLight(color[0], color[1], color[2]) 
    x = uart.read(1) 
    if x == None: x = bytearray(1)
    uart.reset_input_buffer()
    x = int.from_bytes(x, "little")
    print(hex(x)) 
    time.sleep(.01)

