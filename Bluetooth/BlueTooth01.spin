'This file is the bluetooth dongle driver


CON
{'
  RXPIN = 15
  TXPIN = 12
  MODE = 0
  BAUD =9600
'}
  _clkmode = xtal1 + pll16x         'Establish speed
  _xinfreq = 5_000_000              '80Mhz

OBJ
  'serial : "FullDuplexSerial"
  serial: "FASTSERIAL-080927"

{'
PUB Main | buff

  dira[1] :=1                   'Set pin 1 to output

  serial.start(RXPIN, TXPIN, MODE, BAUD)            'Begin the serial port
  repeat

  '{'
    buff:= serial.rxcheck
    if buff >0
    'if serial.rx >0
      !outa[1]
      serial.tx(buff)

     'serial.tx(" ")
     'waitcnt(clkfreq +cnt)
     '}

'}

VAR
  byte twait            ' wait time in milliseconds


PUB start (rxpin, txpin, mode, baud)
  ' rxpin - MISO - Prop RX, Dongle TX
  ' txpin - MOSI - Prop TX, Dongle RX
  ' mode - see serial source for documentation. Default is 0
  ' baud rate - dongle uses 9600

  ' Begins the serial port to connect to bluetooth dongle
  ' Returns nothing
    serial.start (rxpin, txpin, mode, baud)          'Begin the serial port


PUB echo | dBuffer
  ' This function reads what was sent to the propeller
  ' and echoes it back
  '
  ' Returns nothing (to propeller)

  twait := 30

  dBuffer := receive(twait)                           ' wait for tout ms for byte
  transmit(dBuffer)                                  ' echo byte

PUB transmit( value)
  ' Transmits value to the Bluetooth receiver immediately
  ' Returns nothing

    serial.tx(value)

PUB transDec( value)
  ' Transmits value to the Bluetooth receiver immediately
  ' Returns nothing

    serial.ndec(value, 3)

PUB receive(ms) : value
  ' This function waits for ms milliseconds
  ' or until a byte has been received
  ' and returns the byte.
  '
  ' Returns -1  on timeout
  '   else byte received

  value := serial.rxtime(ms)

PUB dec (val)
  serial.dec(val)








