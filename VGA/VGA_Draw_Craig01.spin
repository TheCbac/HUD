''********************************************
''*  VGA 512x384 2-Color Bitmap Driver v1.0  *
''*  Author: Chip Gracey                     *
''*  Copyright (c) 2006 Parallax, Inc.       *
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

  thickness := 1
  fontWd := 3
  fontHt := 10

  '(x, y, height, width)
  {'
  tA(100, 100, fontHt, fontWd)
  tB(120, 100, fontHt, fontWd)
  tC(140, 100, fontHt, fontWd)
  tD(160, 100, fontHt, fontWd)
  tE(180, 100, fontHt, fontWd)
  tF(200, 100, fontHt, fontWd)
  tG(220, 100, fontHt, fontWd)
  tH(240, 100, fontHt, fontWd)
  tI(260, 100, fontHt, fontWd)
  tJ(280, 100, fontHt, fontWd)
  tK(300, 100, fontHt, fontWd)
  tL(320, 100, fontHt, fontWd)
  tM(340, 100, fontHt, fontWd)
  tN(360, 100, fontHt, fontWd)
  t_O(380, 100, fontHt, fontWd)
  tP(400, 100, fontHt, fontWd)
  tQ(420, 100, fontHt, fontWd)
  tR(440, 100, fontHt, fontWd)
  tS(460, 100, fontHt, fontWd)
  tT(480, 100, fontHt, fontWd)
  tU(100, 140, fontHt, fontWd)
  tV(120, 140, fontHt, fontWd)
  tW(140, 140, fontHt, fontWd)
  tX(160, 140, fontHt, fontWd)
  tY(180, 140, fontHt, fontWd)
  tZ(200, 140, fontHt, fontWd)
  t0(220, 140, fontHt, fontWd)
  t1(240, 140, fontHt, fontWd)
  t2(260, 140, fontHt, fontWd)
  t3(280, 140, fontHt, fontWd)
  t4(300, 140, fontHt, fontWd)
  t5(320, 140, fontHt, fontWd)
  t6(340, 140, fontHt, fontWd)
  t7(360, 140, fontHt, fontWd)
  t8(380, 140, fontHt, fontWd)
  t9(400, 140, fontHt, fontWd)
  tPD(420, 140, fontHt, fontWd)

  '}
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

PUB centRect(centerX, centerY, width, height) | cx1, cy1, cx2, cy2
    'Draws a rectangle centered at (x,y) with specified width and height
    'Returns: Nothing

    cx1 := centerX - width/2                            ' Top Left X
    cy2 := centerY - height/2                           ' Top Left Y
    cx2 := centerX + width/2                            ' Bottom Right X
    cy1 := centerY + height/2                           ' Bottom Right Y

    rect(cx1, cy1, cx2, cy2)


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
PUB A(x, y, height, width)
  'Crosshair(x,y)

  'line(x-7, y-10, x-7, y+10)
  'line(x+7, y-10, x+7, y+10)
  'line(x-7,y,x+7,y)
  'line(x-7, y-10, x+7, y-10)

  vline(x-width, y-height, y+height)
  vline(x+width, y-height, y+height)
  hline(y, x-width, x+width)
  hline(y-height, x+width, x-width)
'}

PUB Crosshair(x,y) | size
  size:=3
  line(x-size, y, x+size, y)
  line(x, y-size, x, y+size)

PUB vLine(x, y1, y2)
  line(x , y1, x, y2)

PUB HLine( y, x1, x2)
  line(x1, y, x2, y)




' #################### Block Font Library ####

PUB tA(x, y, height, width)
  'Crosshair(x,y)

  vline(x-width, y-height, y+height)
  vline(x+width, y-height, y+height)
  hline(y, x-width, x+width)
  hline(y-height, x-width, x+width)


PUB tB(x, y, height, width)|  edge
  'Crosshair(x,y)
  edge:=3

  CentRect(x,y + height/2, width * 2, height)
  vline(x-width,y-height, y)
  hline( y-height, x-width, x+width-edge)
  vline(x+width-edge, y-height, y)

PUB tC(x, y, height, width)
  vline(x-width, y-height, y+height)
  hline(y+height, x-width, x+width)
  hline(y-height, x-width, x+width)

PUB tD(x, y, height, width)|off
  off:=1
  vline(x-width, y-height, y+height)
  hline(y+height, x-width, x+width-off)
  hline(y-height, x-width, x+width-off)
  vline(x+width,y+(height-off), y-(height-off))

PUB tE(x, y, height, width)|off
  off:=3
  tC(x, y, height, width)
  hline(y, x-width, x+width-off)

PUB tF(x, y, height, width)|off
  off:=3
  vline(x-width, y-height, y+height)
  hline(y, x-width, x+width-off)
  hline(y-height, x-width, x+width)

PUB tG(x, y, height, width)|off
  off:=4
  tC(x, y, height, width)
  vline(x+width,y-height+off, y-height)
  vline(x+width, y+height, y)
  hline(y, x+width, x+width - off)

PUB tH(x, y, height, width)

  t4(x, y, height, width)
  vline(x-width, y, y+height)

PUB tI(x, y, height, width)
  vline(x, y-height, y+height)
  hline(y-height,x-width, x+width)
  hline(y+height,x-width, x+width)

PUB tJ(x, y, height, width)|off
  off:=1
  vline(x+off, y-height, y+height)
  hline(y-height,x-width, x+width)
  hline(y+height,x-width, x+off)

PUB tK(x, y, height, width)|off
  off:=1
  vline(x-width, y-height-thickness/2, y+height)
  line(x-width+thickness, y, x+width+off, y-height-thickness/2)
  line(x-width+thickness, y, x+width+off, y+height)

PUB tL(x, y, height, width)
  vline(x-width, y-height-thickness/2, y+height)
  hline(y+height, x-width, x+width)

PUB tM(x, y, height, width)
  vline(x-width, y+height, y-height-thickness/2)
  vline(x+width, y-height-thickness/2, y+height)
  line(x , y, x-width ,y-height-thickness/2)
  line(x, y, x+width, y-height-thickness/2)

PUB tN(x, y, height, width)
  vline(x-width, y+height, y-height-thickness/2)
  vline(x+width, y-height-thickness/2, y+height)
  line(x-width, y-height, x+width, y+height)

PUB t_O(x, y, height, width)|off
  off:=1
  vline(x-width, y-(height-off), y+(height-off))
  hline(y+height, x-width+off, x+width-off)
  hline(y-height, x-width+off, x+width-off)
  vline(x+width,y+(height-off), y-(height-off))

PUB tP(x, y, height, width)

  CentRect(x,y - height/2  - thickness/2, width * 2, height)
  vline(x-width,y, y+height)

PUB tQ(x, y, height, width)|off
  off:=1
  vline(x-width, y-(height-off), y+(height-off))
  hline(y+height, x-width+off, x+width-off)
  hline(y-height, x-width+off, x+width-off)
  vline(x+width,y+(height-off), y-(height-off))
  line(x+off, y+off, x+width,y+height)

PUB tR(x, y, height, width)

  CentRect(x,y - height/2  - thickness/2, width * 2, height)
  vline(x-width,y, y+height)
  line(x-width+thickness/2, y, x+width+thickness/2, y+height)

PUB tS(x, y, height, width)|off
  off:=2
  t5(x, y, height, width)
  vline(x-width, y+(height-off), y+height)
  vline(x+width, y-(height-off), y-height )

PUB tT(x, y, height, width)
  vline(x, y-height, y+height)
  hline(y-height,x-width, x+width)

PUB tU(x, y, height, width)
  vline( x-width, y-height, y+height)
  vline( x+width, y-height, y+height)
  hline( y+height, x-width, x+width)

PUB tV(x, y, height, width)
  line(x-width, y-height, x,y+height)
  line(x+width, y-height, x,y+height)

PUB tW(x, y, height, width)
  vline(x-width, y+height, y-height-thickness/2)
  vline(x+width, y-height-thickness/2, y+height)
  line(x , y, x-width ,y+(height-thickness/2))
  line(x, y, x+width, y+(height-thickness/2))

PUB tX(x, y, height, width)
  line(x-width, y-height, x+width, y+height)
  line(x-width, y+height, x+width, y-height)

PUB tY(x, y, height, width)
  vline( x+thickness/2, y+height, y)
  line(x,y,x-width, y-height)
  line(x,y, x+width,y-height)

PUB tZ(x, y, height, width)
  hline(y-height, x+width, x-width)
  hline(y+height, x-width, x+width)
  line(x-width, y+height, x+width, y- height)

PUB t0(x, y, height, width)
  t_O(x, y, height, width)

PUB t1(x, y, height, width)
  vline(x, y-height, y+height)
  hline(y+height,x-width, x+width)
  line(x,y-height, x-width, y)

PUB t2(x, y, height, width)

  vline(x-width,y, y+height)
  vline(x+width,y, y-height)
  hline(y+height, x-width, x+width)
  hline(y, x-width, x+width)
  hline(y-height, x+width, x-width)

PUB t3(x, y, height, width)|off
  off:=3
  vline(x+width, y-height, y+height)
  hline(y+height, x-width, x+width)
  hline(y-height, x+width, x-width)
  hline(y, x+width, x-(width-off))

PUB t4(x,y,height,width)
  vline(x-width, y-height-thickness/2, y)
  vline(x+width, y-height-thickness/2, y+height)
  hline(y, x-width, x+width)

PUB t5(x,y,height,width)
  vline(x-width, y-height, y)
  vline(x+width, y+height, y)
  hline(y-height, x-width, x+width)
  hline(y, x-width, x+width)
  hline(y+height, x-width, x+width)

PUB t6(x,y,height,width)
  tC(x,y,height,width)
  hline(y, x-width, x+ width)
  vline(x+width, y+height, y)

PUB t7(x,y,height,width)
  hline(y-height, x-width, x+width)
  vline(x+width, y+height, y-height)

PUB t8(x,y,height,width)
  t_O(x,y,height,width)
  hline(y, x-width, x+width)

PUB t9(x,y,height,width)
  t7(x,y,height,width)
  vline(x-width, y-height, y)
  hline(y, x-width, x+width)

PUB tPd(x,y,height,width)|off
  'Period
    off:=thickness*4
    centRect(x, y+(height-off/2), off, off)





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
