{'
This is the main file for 2.009 Oragnge HUD Helmet

Date: Wed 11/27/13

Author: Craig Cheney
'}
CON
  rxpin = 15
  txpin = 12
  mode = 0
  baud =9600

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000

OBJ

  '##### Library that communicates with the bluetooth dongle ########
  blue :"BlueTooth01"
  {'
  blue
    |
    Bluetooth01
        |
        FASTSERIAL-080927
    '}

  ' ##### Library to draw shapes on the screen ######
  draw :"VGA_Draw_Craig01"

  {'
  draw
    |
    VGA_DRAW_CRAIG01
        |
        VGA_Driver
  '}




PUB main | hold, m

  dira[0] := 1
  blue.start(rxpin, txpin, mode, baud)
  draw.start




  repeat
     'blue.echo

'{'
    hold:= blue.receive(30)     ' Wait for a byte to be received
    blue.transmit(hold)         ' Echo byte back

    case hold                   ' draw shape based on command
      "q": draw.rect(5,5,100,200)
      "w": draw.line(20,20,200, 25)
      "r": draw.line(5,5,100,100)
      "t":


        draw.triangle(50, 50, 300, 200, 200, 25)






