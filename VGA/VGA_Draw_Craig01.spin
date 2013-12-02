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


OBJ

  vga : "VGA_Driver"
  f: "FloatMath"
  'pst : "Parallax Serial Terminal"


VAR

  long  sync, pixels[tiles32]
  word  colors[tiles]



PUB start | h, i, j, k, x, y , c, d, e, center, tipY, arrowY, arrowX

  'start vga

  vga.start(basePin, @colors, @pixels, @sync)
  'pst.start(115200)

  'init colors to cyan on blue
  repeat i from 0 to tiles - 1
    'colors[i] := $2804
    '$FGBG
    colors[i] := $3814



  {'draw some lines
  repeat y from 1 to 8
    repeat x from 0 to 511
      plot(x, x/y)
      '}

  'wait ten seconds
  'waitcnt(clkfreq * 10 + cnt)

  center := 256
  tipY := 100


  {'
  repeat c from 100 to 200
    e:=220
    plot (e+20, c)
    plot (e+25, c)

  repeat d from 0 to 25
      plot (e+d, 100-d)
      plot (e+25+d, 75 +d)

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

    'triangle(220, 150, 255,100, 290, 150)
    'plot(255, 101)

PUB plot(x,y) | i

  if x => 0 and x < 512 and y => 0 and y < 384
    pixels[y << 4 + x >> 5] |= |< x

PUB line(x1, y1, x2, y2) | i, x , y, dx, dy, q , p , n, m
' This function draws a line from (x1, y1) to (x2,y2)

    'Calculate the Deltas
    dx:=x2-x1
    dy:=y2-y1

    ' If horizontal or vertical, draw directly
    if dx == 0
      repeat i from y1 to y2
        plot(x1, i)
    if dy == 0
      repeat i from x1 to x2
        plot(i, y1)

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
          repeat i from 0 to dy
             y:= i +y1
             p:= f.FRound(f.FMul(m, F.FFloat(i)))
             x:=p+x1

             plot(x,y)
        else
          ' Draw through x
          repeat i from 0 to dx
            x:= i + x1
            p:=f.FRound(f.FDiv(m,f.FFloat(i)))
            y :=  y1- (n*p)
            'y:= y1+p

            plot(x,y)


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
    cy1 := centerY - height/2                           ' Top Left Y
    cx2 := centerX + width/2                            ' Bottom Right X
    cy2 := centerY + height/2                           ' Bottom Right Y

    rect(cx1, cy1, cx2, cy2)


PUB triangle( x1, y1, x2, y2, x3, y3)
  'Draws a trangle defined by three vertices
  line(x1, y1, x2, y2)
  line(x2, y2, x3, y3)
  line(x3, y3, x1, y1)

PUB Clear| i, j

  repeat i from 0 to tiles - 1
    'colors[i] := $2804
    '$FGBG
    colors[i] := $3814
  'repeat i from 0 to vga#hp
    'repeat j from 0 to vga#vp
      'plot(i, j)



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
