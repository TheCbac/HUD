''********************************************
''*  VGA 512x384 2-Color Bitmap Driver v1.0  *
''*  Author: Craig Cheney                    *
''*       *
''*  See end of file for terms of use.       *
''********************************************

CON

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000

  tiles    = vga#xtiles * vga#ytiles
  tiles32  = tiles * 32

  basePin = 0

  'bkgnd = $14
  bkgnd =$00
  frgnd = $38




OBJ

  vga : "VGA_Driver"
  f: "FloatMath"
  'pst : "Parallax Serial Terminal"


VAR

  long  sync, pixels[tiles32]
  word  colors[tiles]
  byte thickness, fontWd, fontHt






PUB start | h, i, j, k, x, y , c, d, e, center, tipY, arrowY, arrowX

  'start vga

  vga.start(basePin, @colors, @pixels, @sync)
  'pst.start(115200)

  'init colors to cyan on blue
  repeat i from 0 to tiles - 1
    'colors[i] := $2804
    '$FGBG
    colors[i] := frgnd << 8 + bkgnd

  thickness := 2
  fontWd := 5
  fontHt := 10

  'text("b",100,100)
  '(x, y, fontHt, width)

  {'randomize the colors and pixels
  repeat y from 1 to 8
    repeat x from 1 to 511
      plot(x, x/y)

  repeat
    colors[||?h // tiles] := ?i
    repeat 100
      pixels[||?j // tiles32] := k?
    '}


PUB plot(x,y) | i

  if x => 0 and x < 512 and y => 0 and y < 384
    pixels[y << 4 + x >> 5] |= |< x

PUB line(x1, y1, x2, y2) | i, x , y, dx, dy, q , p , n, m,t, thalf , tdir
' This function draws a line from (x1, y1) to (x2,y2)
    ' Set the color ( in case it was cleared )

    'thickness:= 2
    thalf := thickness/2

    {'
    repeat i from 0 to tiles - 1
    'colors[i] := $2804
    '$FGBG
      colors[i] := $1414
      '}



    'Calculate the Deltas
    dx:=x2-x1
    dy:=y2-y1

    ' If horizontal or vertical, draw directly
    if dx == 0                                          ' if veritcal
      if y2 < y1
        tdir := -1
      else
        tdir := 1

      repeat i from y1 to y2
        repeat t from 0 to thickness-1
          'plot(x1-thalf+t, i)
          plot(x1+(t*tdir), i)

    elseif dy == 0
      if x2 <x1
        tdir := 1
      else
        tdir:= -1
      repeat i from x1 to x2
        repeat t from 0 to thickness -1
          'plot(i, y1-thalf+t)
          plot(i, y1+(t*tdir))

    else
        ' calculate slope and direction (n)
        m:=f.FDiv(f.FFloat(dx), f.FFloat(dy))
        if dx <0
          n := -1
        else
          n:=1
        if f.FAbs(m)>1
        ' always bigger than 1, not 1.0
        ' if slope is greater than 1, draw through Y
        '{'
          repeat i from 0 to dy
             y:= i +y1
             p:= f.FRound(f.FMul(m, F.FFloat(i)))
             x:=p+x1
             repeat t from 0 to thickness-1
                plot(x-thalf+t,y)
          '}
          {'

          repeat t from 0 to thickness-1
             repeat i from 0 to dy+thalf +t
                y:= i +y1
                p:= f.FRound(f.FMul(m, F.FFloat(i)))
                x:=p+x1
                plot(x-thalf+t,y)
          '}

        else
          ' Draw through x
          repeat i from 0 to dx
            x:= i + x1
            p:=f.FRound(f.FDiv(m,f.FFloat(i)))
            y :=  y1- (n*p)
            'y:= y1+p
            repeat t from 0 to thickness-1
               plot(x,y-thalf+t)

     {'
    repeat i from 0 to tiles - 1
    'colors[i] := $2804
      '$FGBG
      colors[i] := $3814
      '}

PUB rect(cx1, cy1, cx2, cy2)
  ' Draws a rectangle with one corner at (cx1, cy1)
  ' and the opposite corner at (cx2, cy2)
  ' Returns: Nothing
  line (cx1, cy1, cx2, cy1)                             'Top Left to top Right
  line (cx2, cy1, cx2, cy2)                             'Top Right to bottom right
  line (cx2, cy2, cx1, cy2)                             'Bottom Right to Bottom Left
  line (cx1, cy2, cx1, cy1)                             'Bottom Left to Top Left



PUB triangle( x1, y1, x2, y2, x3, y3)
  'Draws a trangle defined by three vertices
  line(x1, y1, x2, y2)
  line(x2, y2, x3, y3)
  line(x3, y3, x1, y1)

PUB Clear| i, j

  {'
  repeat i from 0 to tiles - 1
    'colors[i] := $2804
    '$FGBG
    colors[i] := bkgnd + bkgnd<<8

    '}

  Blank

  repeat i from 0 to tiles32-1
    pixels[i]  := $00

  Fill

PUB Thick(t)
  ' Changes the thickness of the line
  ' this is passed from main.spin
  thickness:= t

PUB Blank |i
  ' this turns the background color to match the foreground
  repeat i from 0 to tiles - 1
    'colors[i] := $2804
    '$FGBG
    colors[i] := bkgnd + bkgnd<<8

PUB Fill | i

  repeat i from 0 to tiles - 1
    'colors[i] := $2804
    '$FGBG
    colors[i] := frgnd << 8 + bkgnd



PUB circle(x,y,radius) | i
  repeat i from 0 to 360  'draw circle
    plot(x+sin(i,radius), y+cos(i,radius))

PUB arc(x, y, radius, startAngle, endAngle) |i
  repeat i from startAngle to endAngle  'draw circle
    plot(x+sin(i,radius), y+cos(i,radius))

PUB sin(degree, range) : s | c,z,angle
  angle := (degree*91)~>2  ' *22.75
  c := angle & $800
  z := angle & $1000
  if c
    angle := -angle
  angle |= $E000>>1
  angle <<= 1
  s := word[angle]
  if z
    s := -s
  return (s*range)~>16     ' return sin = -range..+range

PUB cos(degree,range)
  return sin(degree+90,range)


{'
PUB A(x, y)
  'Crosshair(x,y)

  'line(x-7, y-10, x-7, y+10)
  'line(x+7, y-10, x+7, y+10)
  'line(x-7,y,x+7,y)
  'line(x-7, y-10, x+7, y-10)

  vline(x-fontWd, y-fontHt, y+fontHt)
  vline(x+fontWd, y-fontHt, y+fontHt)
  hline(y, x-fontWd, x+fontWd)
  hline(y-fontHt, x+fontWd, x-fontWd)
'}

PUB Crosshair(x,y) | size
  size:=3
  line(x-size, y, x+size, y)
  line(x, y-size, x, y+size)

PUB vLine(x, y1, y2)
  line(x , y1, x, y2)

PUB HLine( y, x1, x2)
  line(x1, y, x2, y)

PUB centRect(centerX, centerY, width, height) | cx1, cy1, cx2, cy2
    'Draws a rectangle centered at (x,y) with specified width and height
    'Returns: Nothing

    cx1 := centerX - width/2                            ' Top Left X
    cy2 := centerY - height/2                           ' Top Left Y
    cx2 := centerX + width/2                            ' Bottom Right X
    cy1 := centerY + height/2                           ' Bottom Right Y

    rect(cx1, cy1, cx2, cy2)



' #################### Block Font Library ####


PUB text(letter, x, y) |edge, off
  case letter
    "a":
      vline(x-fontWd, y-fontHt, y+fontHt)
      vline(x+fontWd, y-fontHt, y+fontHt)
      hline(y, x-fontWd, x+fontWd)
      hline(y-fontHt, x-fontWd, x+fontWd)
    "b":
      edge:=2
      CentRect(x,y + fontHt/2, fontWd * 2, fontHt)
      vline(x-fontWd,y-fontHt, y)
      hline( y-fontHt, x-fontWd, x+fontWd-edge)
      vline(x+fontWd-edge, y-fontHt, y)
    "c":
      vline(x-fontWd, y-fontHt, y+fontHt)
      hline(y+fontHt, x-fontWd, x+fontWd)
      hline(y-fontHt, x-fontWd, x+fontWd)
    "d":
      off:=1
      vline(x-fontWd, y-fontHt, y+fontHt)
      hline(y+fontHt, x-fontWd, x+fontWd-off)
      hline(y-fontHt, x-fontWd, x+fontWd-off)
      vline(x+fontWd,y+(fontHt-off), y-(fontHt-off))
    "e":
      off:=3
      vline(x-fontWd, y-fontHt, y+fontHt)
      hline(y+fontHt, x-fontWd, x+fontWd)
      hline(y-fontHt, x-fontWd, x+fontWd)
      hline(y, x-fontWd, x+fontWd-off)
    "f":
      off:=3
      vline(x-fontWd, y-fontHt, y+fontHt)
      hline(y, x-fontWd, x+fontWd-off)
      hline(y-fontHt, x-fontWd, x+fontWd)
    "g":
      off:=4
      vline(x-fontWd, y-fontHt, y+fontHt)
      hline(y+fontHt, x-fontWd, x+fontWd)
      hline(y-fontHt, x-fontWd, x+fontWd)
      vline(x+fontWd,y-fontHt+off, y-fontHt)
      vline(x+fontWd, y+fontHt, y)
      hline(y, x+fontWd, x+fontWd - off)
    "h":
      vline(x-fontWd, y-fontHt-thickness/2, y)
      vline(x+fontWd, y-fontHt-thickness/2, y+fontHt)
      hline(y, x-fontWd, x+fontWd)
      vline(x-fontWd, y, y+fontHt)
    "i":
      vline(x, y-fontHt, y+fontHt)
      hline(y-fontHt,x-fontWd, x+fontWd)
      hline(y+fontHt,x-fontWd, x+fontWd)
    "j":
      off:=1
      vline(x+off, y-fontHt, y+fontHt)
      hline(y-fontHt,x-fontWd, x+fontWd)
      hline(y+fontHt,x-fontWd, x+off)
    "k":
      off:=1
      vline(x-fontWd, y-fontHt-thickness/2, y+fontHt)
      line(x-fontWd+thickness, y, x+fontWd+off, y-fontHt-thickness/2)
      line(x-fontWd+thickness, y, x+fontWd+off, y+fontHt)
    "l":
      vline(x-fontWd, y-fontHt-thickness/2, y+fontHt)
      hline(y+fontHt, x-fontWd, x+fontWd)
    "m":
      vline(x-fontWd, y+fontHt, y-fontHt-thickness/2)
      vline(x+fontWd, y-fontHt-thickness/2, y+fontHt)
      line(x , y, x-fontWd ,y-fontHt-thickness/2)
      line(x, y, x+fontWd, y-fontHt-thickness/2)
    "n":
      vline(x-fontWd, y+fontHt, y-fontHt-thickness/2)
      vline(x+fontWd, y-fontHt-thickness/2, y+fontHt)
      line(x-fontWd, y-fontHt, x+fontWd, y+fontHt)
    "o":
      off:=1
      vline(x-fontWd, y-(fontHt-off), y+(fontHt-off))
      hline(y+fontHt, x-fontWd+off, x+fontWd-off)
      hline(y-fontHt, x-fontWd+off, x+fontWd-off)
      vline(x+fontWd,y+(fontHt-off), y-(fontHt-off))
    "p":
      CentRect(x,y - fontHt/2  - thickness/2, fontWd * 2, fontHt)
      vline(x-fontWd,y, y+fontHt)
    "q":
      off:=1
      vline(x-fontWd, y-(fontHt-off), y+(fontHt-off))
      hline(y+fontHt, x-fontWd+off, x+fontWd-off)
      hline(y-fontHt, x-fontWd+off, x+fontWd-off)
      vline(x+fontWd,y+(fontHt-off), y-(fontHt-off))
      line(x+off, y+off, x+fontWd,y+fontHt)
    "r":
      CentRect(x,y - fontHt/2  - thickness/2, fontWd * 2, fontHt)
      vline(x-fontWd,y, y+fontHt)
      line(x-fontWd+thickness/2, y, x+fontWd+thickness/2, y+fontHt)
    "s":
      off:=2
      vline(x-fontWd, y-fontHt, y)
      vline(x+fontWd, y+fontHt, y)
      hline(y-fontHt, x-fontWd, x+fontWd)
      hline(y, x-fontWd, x+fontWd)
      hline(y+fontHt, x-fontWd, x+fontWd)
      vline(x-fontWd, y+(fontHt-off), y+fontHt)
      vline(x+fontWd, y-(fontHt-off), y-fontHt )
    "t":
      vline(x, y-fontHt, y+fontHt)
      hline(y-fontHt,x-fontWd, x+fontWd)
    "u":
      vline( x-fontWd, y-fontHt, y+fontHt)
      vline( x+fontWd, y-fontHt, y+fontHt)
      hline( y+fontHt, x-fontWd, x+fontWd)
    "v":
      line(x-fontWd, y-fontHt, x,y+fontHt)
      line(x+fontWd, y-fontHt, x,y+fontHt)
    "w":
      vline(x-fontWd, y+fontHt, y-fontHt-thickness/2)
      vline(x+fontWd, y-fontHt-thickness/2, y+fontHt)
      line(x , y, x-fontWd ,y+(fontHt-thickness/2))
      line(x, y, x+fontWd, y+(fontHt-thickness/2))
    "x":
      line(x-fontWd, y-fontHt, x+fontWd, y+fontHt)
      line(x-fontWd, y+fontHt, x+fontWd, y-fontHt)
    "y":
      vline( x,  y+fontHt,y)
      line(x,y,x-fontWd, y-fontHt)
      line(x,y, x+fontWd,y-fontHt)
    "z":
      hline(y-fontHt, x+fontWd, x-fontWd)
      hline(y+fontHt, x-fontWd, x+fontWd)
      line(x-fontWd, y+fontHt, x+fontWd, y- fontHt)
    "0":
      off:=1
      vline(x-fontWd, y+(fontHt-off), y-(fontHt-off))
      hline(y+fontHt, x-fontWd+off, x+fontWd-off)
      hline(y-fontHt, x-fontWd+off, x+fontWd-off)
      vline(x+fontWd,y+(fontHt-off), y-(fontHt-off))
    "1":
      vline(x, y-fontHt, y+fontHt)
      hline(y+fontHt,x-fontWd, x+fontWd)
      line(x,y-fontHt, x-fontWd, y)
    "2":
      vline(x-fontWd,y, y+fontHt)
      vline(x+fontWd,y, y-fontHt)
      hline(y+fontHt, x-fontWd, x+fontWd)
      hline(y, x-fontWd, x+fontWd)
      hline(y-fontHt, x+fontWd, x-fontWd)
    "3":
      off:=3
      vline(x+fontWd, y-fontHt, y+fontHt)
      hline(y+fontHt, x-fontWd, x+fontWd)
      hline(y-fontHt, x+fontWd, x-fontWd)
      hline(y, x+fontWd, x-(fontWd-off))
    "4":
      vline(x-fontWd, y-fontHt-thickness/2, y)
      vline(x+fontWd, y-fontHt-thickness/2, y+fontHt)
      hline(y, x-fontWd, x+fontWd)
    "5":
      vline(x-fontWd, y-fontHt, y)
      vline(x+fontWd, y+fontHt, y)
      hline(y-fontHt, x-fontWd, x+fontWd)
      hline(y, x-fontWd, x+fontWd)
      hline(y+fontHt, x-fontWd, x+fontWd)
    "6":
      vline(x-fontWd, y-fontHt, y+fontHt)
      hline(y+fontHt, x-fontWd, x+fontWd)
      hline(y-fontHt, x-fontWd, x+fontWd)
      hline(y, x-fontWd, x+ fontWd)
      vline(x+fontWd, y+fontHt, y)
    "7":
      hline(y-fontHt, x-fontWd, x+fontWd)
      vline(x+fontWd, y+fontHt, y-fontHt)
    "8":
      off:=1
      vline(x-fontWd, y-(fontHt-off), y+(fontHt-off))
      hline(y+fontHt, x-fontWd+off, x+fontWd-off)
      hline(y-fontHt, x-fontWd+off, x+fontWd-off)
      vline(x+fontWd,y+(fontHt-off), y-(fontHt-off))
      hline(y, x-fontWd, x+fontWd)
    "9":
      hline(y-fontHt, x-fontWd, x+fontWd)
      vline(x+fontWd, y+fontHt, y-fontHt)
      vline(x-fontWd, y-fontHt, y)
      hline(y, x-fontWd, x+fontWd)
    ".":
      off:=thickness*3
      centRect(x, y+(fontHt-off/2), off, off)





{{
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                   TERMS OF USE: MIT License                                                  │                                                            
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation    │ 
│files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,    │
│modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software│
│is furnished to do so, subject to the following conditions:                                                                   │
│                                                                                                                              │
│The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.│
│                                                                                                                              │
│THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE          │
│WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR         │
│COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   │
│ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                         │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
}}    
