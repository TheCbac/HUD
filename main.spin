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
  'blue :"BlueTooth01"
  serial : "FASTSERIAL-080927"
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

VAR
  byte state





PUB main | hold, m , thick , s

  dira[0] := 1
  serial.start(rxpin, txpin, mode, baud)
  draw.start
  state := 0
  's[4]:= "zdds"


  repeat
     'blue.echo

'{'
    hold:= Serial.rxtime(30)    ' Wait for a byte to be received
    serial.tx(hold)         ' Echo byte back

    case hold                   ' draw shape based on command
      "q": draw.rect(5,5,100,200)
      "w": draw.line(20,20,200, 25)
      "r": Right
      "t":
          'serial.str(@s)
          repeat until thick>0
            thick:= serial.rxtime(30)
          serial.dec(thick-$30)
          draw.thick(thick-$30)
          thick:=0

      "l" :
          draw.circle(200, 200, 50)


      "y":
          draw.arc(300,200, 50, 5, 175)

      "u":
        draw.line(30,200, 60,100)
      "m":
        draw.rect(200,150,300,400)
      "n":
          Straight
      "c":
        draw.Clear
      "s":
        draw.Clear
        draw.CentRect(256, 230, 40, 120)
        draw.triangle(256, 80, 190 , 170 , 322 , 170)



PUB Straight
        draw.Blank
        draw.CentRect(256, 230, 40, 120)
        draw.triangle(256, 80, 190 , 170 , 322 , 170)
        draw.Fill


PUB Right
    draw.Blank
    draw.CentRect(256, 150, 120, 40)
    draw.triangle(316, 80, 316, 220, 375, 150)
    draw.Fill



