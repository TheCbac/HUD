'This method reads in a simple byte from the bluetooth receiver


CON
  rxpin = 15
  txpin = 14
  mode = 0
  baudrate =9600

  _clkmode = xtal1 + pll16x         'Establish speed
  _xinfreq = 5_000_000              '80Mhz

OBJ
  serial : "FullDuplexSerial"
  'serial: "FASTSERIAL-080927"

PUB Main | buff

  dira[1] :=1                   'Set pin 1 to output

  serial.start(rxpin, txpin, mode, baudrate)            'Begin the serial port
  repeat
    'buff:= serial.rxcheck
    'if buff >0
    'if serial.rx >0
     ' !outa[1]
      'serial.tx(buff)
     serial.tx(serial.rx)
     'serial.tx(" ")
     'waitcnt(clkfreq +cnt)
