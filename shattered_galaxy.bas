 rem Shattered Galaxy
 rem 
 
 set kernel_options pfcolors no_blank_lines background

 pfcolors:
   $7A
   $80
   $82
   $84
   $86
   $88
   $5E
   $5C
   $5A
   $58
   $56
   $08
end

 playfield:
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ..X.....XX............XX.....X..
 .XXX....XX............XX....XXX.
 ..X....XXX............XXX....X..
 ..X...XXXX............XXXX...X..
 ................................
end

 player0:
 %01000010
 %11111111
 %11111111
 %01111110
 %00111100
 %00011000
 %00011000
 %00011000
end

 rem COLUP1 = $2
 COLUP0 = $40
 COLUBK = $54
 COLUPF = $00
 scorecolor = $50
 
 t = 0 ; bool 1/0 : Have we hit a wall
 a = 15 ; position of gap (1 to 31)
 l = 4 ; gap width for crevass
 p = 0 ; bool 1/0 : Phase (red or blue)
 j = 0 ; joy0fire is down

 player0x = 77
 player0y = 70

mainloop
 drawscreen
 
 rem Player died, stop all action
 if t = 1 then goto mainloop

 rem pick phase color based on p (phase) var
 if joy0fire && j = 0 then j = 1
 if !joy0fire && j = 1 then goto switchphase
 if p = 0 then COLUP0 = $80 else COLUP0 = $40

 if joy0up then player0y = player0y - 1
 if joy0down then player0y = player0y + 1
 if joy0left then player0x = player0x - 1
 if joy0right then player0x = player0x + 1
 if collision(player0,playfield) then t = 1
 
 rem if joy0up then pfscroll down
 pfscroll down
 i = 1
 if playfieldpos = 1 goto newline
 pfhline 0 10 31 off
 goto mainloop

rem swtich phases
switchphase
 j = 0
 score = score - 300
 if p = 0 then p = 1 else p = 0
 goto mainloop
 
rem create the next line in the scrolling playfield
newline
 if p = 0 then score = score + 1
 d = (rand&1)
 l = (rand&7) + 3
 if d = 0 then a = a - 1
 if d = 1 then a = a + 1
 
 b = a-l
 c = a+l
 pfhline 0 11 31 off rem clear the line
 pfhline 0 11 b on
 pfhline c 11 31 on
 goto mainloop
 