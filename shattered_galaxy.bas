 rem Shattered Galaxy
 
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

 player1:
 %00011000
 %00011000
 %00011000
 %00111100
 %01111110
 %11111111
 %11111111
 %01000010
end


 COLUP0 = $40
 COLUBK = $54
 COLUPF = $00
 scorecolor = $50
 
 rem bool 1/0 : Have we hit a wall
 t = 0 
 
 rem position of gap (1 to 31)
 a = 15 
 
 rem gap width for crevass
 l = 4 
 
 rem bool 1/0 : Player Phase (red or blue)
 p = 0
 
 rem bool 1/0 : Villian Phase (red or blue)
 v = 0
 
 rem joy0fire is down
 j = 0

 player0x = 77
 player0y = 70
 
 player1x = 0
 player1y = 0

mainloop
 drawscreen
 
 rem Player died, stop all action
 if t = 1 then goto mainloop
 
 rem pick phase color based on p (phase) var
 if joy0fire && j = 0 then j = 1
 if !joy0fire && j = 1 then goto switchphase
 if p = 0 then COLUP0 = $80 else COLUP0 = $40
 if v = 0 then COLUP1 = $80 else COLUP1 = $40

 if joy0up then player0y = player0y - 1
 if joy0down then player0y = player0y + 1
 if joy0left then player0x = player0x - 1
 if joy0right then player0x = player0x + 1
 if collision(player0,playfield) then t = 1
 if collision(player0,player1) && p = v then t = 1
 
 player1y = player1y + 1
 n = rand&3
 if n = 0 && player1x < player0x then player1x = player1x + 1
 if n = 3 && player1x > player0x then player1x = player1x - 1
 if player1y > 200 then goto resetvillian
 
 rem if joy0up then pfscroll down
 pfscroll down
 i = 1
 if playfieldpos = 1 goto newline
 pfhline 0 10 31 off
 goto mainloop

 rem swtich phases
switchphase
 j = 0
 rem if score > 300 then score = score - 300
 if p = 0 then p = 1 else p = 0
 goto mainloop
 
 rem create the next line in the scrolling playfield
newline
 score = score + 1
 d = (rand&1)
 l = (rand&7) + 3
 if d = 0 && a > 0 then a = a - 1
 if d = 1 && a < 30 then a = a + 1
 
 b = a-l
 c = a+l
 
 if c < 1 then b = 1
 if c > 31 then c = 31
 pfhline 0 11 31 off rem clear the line
 pfhline 0 11 b on
 pfhline c 11 31 on
 goto mainloop

resetvillian
 v = rand&1
 player1y = 0
 player1x = (rand&120) + 5
 goto mainloop
