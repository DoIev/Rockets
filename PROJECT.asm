;DOLEV RAZIEL'S ASSEMBLY 8086 PROJECT
;ROCKETS
;TEACHER: SERGE MENZON

P286N ;NEEDED for the pusha and popa commands
IDEAL
MODEL small
STACK 1000h

MAX_BMP_WIDTH = 320 ;the maximum height and length for a BMP IMAGE
MAX_BMP_HEIGHT = 200
SMALL_BMP_HEIGHT = 0
SMALL_BMP_WIDTH = 0

DATASEG
; --------------------------
;vars for the game itself

string db ' Press ENTER to start $'
string1 db 'Game starts in   seconds$'
string2 db 'Rockets Survived: $'
AsarotNumber db '0' ;rockets survived
YehidotNumber db '0$' ;rockets survived
string3 db 'WELCOME TO MY GAME!$'
string4 db 'you have control, move the plane using$'
string5 db 'the WASD keys and avoid the missiles!$'
string6	db 'W - UP, A - LEFT, D - RIGHT, S - DOWN$'
string9 db 'you can press anytime Q to exit$'
string7 db 'Ready to play? press ENTER to start$'
string10 db 'OH NO, YOU FAILED$'
string11 db 'PRESS ENTER TO TRY AGAIN$'
string12 db 'PRESS Q TO QUIT THE GAME$'
;---------------------------
;vars to open the images needed

filename db 'newmenu.bmp',0
filename2 db 'boom.bmp', 0
OneBmpLine 	db MAX_BMP_WIDTH dup (0)  ; One Color line read buffer
ScreenLineMax 	db MAX_BMP_WIDTH dup (0)  ; One Color line read buffer
;BMP File data
FileHandle	dw ?
Header 	    db 54 dup(0)
Palette 	db 400h dup (0)
BmpFileErrorMsg    	db 'Error At Opening Bmp File .', 0dh, 0ah,'$'
ErrorFile           db 0
BB db "BB..",'$'	 
BmpLeft dw ?
BmpTop dw ?
BmpColSize dw ?
BmpRowSize dw ?	

;---------------------------
;SPRITES VARS: PLANE & ROCKETS

	PlnMW equ 32 
	PlnMH equ 32
    StartPlaneX	dw 50
	StartPlaneY	dw 100
	
    Plane DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,8,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,8,7,8,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,8,7,7,8,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,8,7,7,7,8,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,8,7,7,7,8,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 8,8,15,15,15,15,15,15,15,15,8,7,7,7,7,8
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 8,7,8,15,15,15,15,15,15,15,8,7,7,7,7,7
		  DB 8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 8,7,7,8,15,15,15,15,15,15,15,8,7,7,7,7
		  DB 7,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 8,7,7,8,15,15,15,15,15,15,15,15,7,7,7,7
		  DB 7,7,8,15,15,8,8,8,15,15,15,15,15,15,15,15
		  DB 8,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8
		  DB 8,8,8,8,8,7,7,7,8,8,8,15,15,15,15,15
		  DB 15,8,8,8,8,7,7,7,7,7,7,7,7,7,7,7
		  DB 7,7,7,7,8,8,8,8,8,7,7,8,8,8,15,15
		  DB 15,8,8,8,8,7,7,7,7,7,7,7,8,8,8,8
		  DB 8,8,8,7,7,7,7,7,7,7,7,7,7,7,8,8
		  DB 15,7,7,7,8,7,7,7,7,7,7,8,7,7,7,7
		  DB 7,7,7,8,7,7,7,7,7,7,7,8,8,8,15,15
		  DB 8,7,7,8,8,8,8,8,8,8,8,8,7,7,7,7
		  DB 7,7,8,8,8,8,8,8,8,8,8,15,15,15,15,15
		  DB 8,7,8,15,15,15,15,15,15,15,15,8,7,7,7,7
		  DB 7,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 8,8,15,15,15,15,15,15,15,15,8,7,7,7,7,7
		  DB 8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 8,15,15,15,15,15,15,15,15,15,8,7,7,7,7,8
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,8,7,7,7,8,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,8,7,7,7,8,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,8,7,7,8,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,8,7,8,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,8,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  
    PlaneWhite DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  DB 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		  
		  RktML equ 48
          RktMH equ 15
		  StartRocketX	dw 280
	      StartRocketY	dw 100
		  
	       Rkt db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2, 2, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2, 6, 2, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2, 2,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2, 2, 115, 2, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2, 2, 2,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2, 2, 14, 6, 2, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2, 14, 6, 2,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,12, 12, 12, 12, 12, 12, 4, 4, 4, 4, 15, 15, 15, 15, 15, 15
	db  15, 15, 2, 2, 2, 0, 0, 0, 2, 6, 2, 2, 14, 2, 6, 115, 14, 6, 2, 2, 2, 115, 6, 6, 2, 14, 115, 2, 6, 14, 115, 2,15, 15, 14, 14, 14, 14, 12, 12, 12, 12, 4, 4, 4, 15, 15, 15
	db  2, 2, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 115, 6, 2, 2, 2, 14, 2, 6, 2, 6, 2, 2, 2, 2, 2,15, 15, 15, 14, 14, 14, 14, 14, 14, 14, 12, 12, 12, 4, 4, 4
	db  15, 15, 2, 2, 2, 0, 0, 0, 2, 115, 2, 6, 115, 2, 6, 2, 6, 6, 14, 2, 2, 6, 6, 115, 14, 6, 115, 14, 115, 2, 6, 2,15, 15, 14, 14, 14, 14, 12, 12, 12, 12, 4, 4, 4, 15, 15, 15
	db  15, 15, 15, 15, 15, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,12, 12, 12, 12, 12, 12, 4, 4, 4, 4, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2, 2, 14, 6, 2, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2, 14, 6, 2,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2, 2, 115, 2, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2, 2, 2,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2, 6, 2, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2, 2,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2, 2, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 2,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
		  
	      RktWhite db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	db  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15,15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	
		  ImageX 			dw ?
		  ImageY 			dw ?
		  ImageW			dw ?
		  ImageH			dw ?
		  ImageMaskOffset dw ?
		  Color     		db ?
; --------------------------
;variables for the timer

CLOCK equ es:6Ch ;real PC timer location on memory
seconds db '3$' ;3 seconds to print

;---------------------------
;for identificing the key pressed on the keyboard
;for saving the random number for the rockets

keyPress db ?

;the random number we will get will be stored here
rndNumberGot dw ?
;---------------------------

CODESEG 
;==============================================================================
;========================== PROCEDURES AREA====================================
;==============================================================================
;==============================================================================

;===================================MACRO PROCEDURES
;===================================================
;The procedures here needed for the Plane and the Rockets print.
;RandomNumber - generates number between 0-3 (4 options) and the results determines the Y of the new Rocket.

MACRO DrawMImage ObjX,ObjY,ObjW,ObjH,Obj
pusha
        mov     AX, [ObjX]
        mov     [ImageX],AX
		
        mov     AX, [ObjY]
        mov     [ImageY],AX
        
		mov     AX, ObjW
		mov     [ImageW], AX
        
		mov     AX, ObjH
		mov     [ImageH], AX
		mov     [ImageMaskOffset], offset Obj
        
        call    DrawMovingImage
popa
ENDM DrawMImage
;---------------------------------------
proc DrawMovingImage
pusha
        mov cx, [ImageW]
        mov si, [ImageMaskOffset]
        cycle:
		mov al, [byte si] 
		pusha
		call PutPixel
		popa
		inc si
		inc [ImageX]
		;dec dx
		loop cycle 
		mov cx, [ImageW]
        mov dx, [ImageW]
		sub [ImageX], dx
		inc [ImageY]
        dec [ImageH]
        jnz cycle      
popa
ret
ENDP DrawMovingImage
;----------------------------------
proc PutPixel
pusha
        mov bh,0h
        mov cx,[ImageX]
        mov dx,[ImageY]
        mov ah,0Ch
        int 10h
popa
ret	
endp PutPixel
;----------------------------------------
proc randomNUMBER
pusha

        call randomize
        random_the_Y:
		mov ax,160d
		push ax
		call random
		cmp ax, 30
		jl random_the_Y
		mov [rndNumberGot],ax

popa
ret 
endp randomNUMBER
;----------------------------------------
proc WhatY
pusha
        mov [StartRocketX], 280
        
		mov ax, [rndNumberGot]
		mov [StartRocketY], ax
popa
ret
endp WhatY
;----------------------------------------
proc checkCollide
pusha
    
	 mov dx, [StartPlaneY]
     mov cx, 0
     Collision_Y_CHECK_LOOP_BELOW:
     add dx, cx
     cmp dx, [StartRocketY]
	 je collision_On_Y_CHECK_X
	 inc cx
	 cmp cx, 20
	 jne Collision_Y_CHECK_LOOP_BELOW
	
	mov bx, [StartPlaneY]
	mov cx, 20
	Collision_Y_CHECK_LOOP_ABOVE:
	add bx, cx
	cmp bx, [StartRocketY]
	je collision_On_Y_CHECK_X
	dec cx
	cmp cx, 0
	jne Collision_Y_CHECK_LOOP_ABOVE
	
	no_collision:
	popa
    ret
	
	collision_On_Y_CHECK_X:
	 mov ax, [StartPlaneX]
	 mov cx, 10
     check_X_loop:
	 add ax, cx
     cmp ax, [StartRocketX]
	 je INSANE_COLLISION
	 dec cx
	 cmp cx,0
	 jne check_X_loop

	no_collision2:
	popa
    ret
	
	INSANE_COLLISION:
	call you_lost_Screen
endp checkCollide
;==========================IMAGE-OPENING PROCEDURES
;==================================================
;The procedures here are for the BMP opening, reading and printing.
;MUST - For the Main Menue IMAGE PRINT.

proc OpenShowBmp near
push cx
push bx

	call OpenBmpFile
	cmp [ErrorFile],1
	je @@ExitProc
	call ReadBmpHeader
	; from  here assume bx is global param with file handle. 
	call ReadBmpPalette
	call CopyBmpPalette
	call ShowBMP 
	call CloseBmpFile
	
@@ExitProc:
pop bx
pop cx
ret
endp OpenShowBmp	
;-------------------------------------------
proc OpenBmpFile	near   ;input dx filename to open		 
	mov ah, 3Dh
	xor al, al
	int 21h
	jc @@ErrorAtOpen
	mov [FileHandle], ax
	jmp @@ExitProc	
@@ErrorAtOpen:
	mov [ErrorFile],1
@@ExitProc:	
	ret
endp OpenBmpFile
;-------------------------------------------
proc CloseBmpFile near
pusha

	mov ah,3Eh
	mov bx, [FileHandle]
	int 21h
	
popa
ret
endp CloseBmpFile
;-------------------------------------------
; Read 54 bytes the Header
proc ReadBmpHeader	near					
push cx
push dx

	mov ah,3fh
	mov bx, [FileHandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	
pop dx
pop cx
ret
endp ReadBmpHeader
;-------------------------------------------
proc ReadBmpPalette near ; Read BMP file color palette, 256 colors * 4 bytes (400h)
						 ; 4 bytes for each color BGR + null)			
push cx
push dx

	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	
pop dx
pop cx
ret
endp ReadBmpPalette
;-------------------------------------------
; Will move out to screen memory the colors
; video ports are 3C8h for number of first color
; and 3C9h for all rest
proc CopyBmpPalette		near												
push cx
push dx

	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0  ; black first							
	out dx,al ;3C8h
	inc dx	  ;3C9h
CopyNextColor:
	mov al,[si+2] 		; Red				
	shr al,2 			; divide by 4 Max (cos max is 63 and we have here max 255 ) (loosing color resolution).				
	out dx,al 						
	mov al,[si+1] 		; Green.				
	shr al,2            
	out dx,al 							
	mov al,[si] 		; Blue.				
	shr al,2            
	out dx,al 							
	add si,4 			; Point to next color.  (4 bytes for each color BGR + null)									
	loop CopyNextColor
	
pop dx
pop cx
ret
endp CopyBmpPalette
;-------------------------------------------
proc ShowBMP 
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpRowSize lines in VGA format),
; displaying the lines from bottom to top.
push cx
	mov ax, 0A000h
	mov es, ax
	mov cx,[BmpRowSize]
	mov ax,[BmpColSize] ; row size must dived by 4 so if it less we must calculate the extra padding bytes
	xor dx,dx
	mov si,4
	div si
	mov bp,dx
	mov dx,[BmpLeft]
@@NextLine:
push cx
push dx
	mov di,cx  ; Current Row at the small bmp (each time -1)
	add di,[BmpTop] ; add the Y on entire screen
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	mov cx,di
	shl cx,6
	shl di,8
	add di,cx
	add di,dx
	; small Read one line
	mov ah,3fh
	mov cx,[BmpColSize]  
	add cx,bp  ; extra  bytes to each row must be divided by 4
	mov dx, offset ScreenLineMax
	int 21h
	; Copy one line into video memory
	cld ; Clear direction flag, for movsb
	mov cx,[BmpColSize]  
	mov si,offset ScreenLineMax
	rep movsb ; Copy line to the screen
pop dx
pop cx
	loop @@NextLine
pop cx
ret
endp ShowBMP  

;==========================SCREEN-CLEANING PROCEDURES
;====================================================
Proc clearBLACK
pusha
	mov ax, 00000h ;the color, black
	xor bx,bx
	xor dx,dx
    screenLOOP:
	mov [es:bx],ax
	inc bx
	cmp cx, bx
	jne screenLOOP
popa
ret
endp clearBLACK
;---------------------------------
Proc clearWHITE
pusha
	mov ax, 0FFFFh
	xor bx,bx
	xor dx,dx
	mov cx ,200*320 ;כל הפיקסלים על המסך בגרפיק מוד
    screenLOOP2:
	mov [es:bx],ax
	inc bx
	cmp cx, bx
	jne screenLOOP2
popa
ret
endp clearWHITE
;==================================TIMER PROCEDURES
;==================================================
proc ONEsecond
pusha ;דוחף למחסנית את כל האוגרים
	mov ax, es
	push ax
	mov ax, 40h
	mov es, ax
	mov cx, 18 ;המעבד פועל בתדר של 18 טיקים בשניה
	Delay:
    mov ax, [CLOCK]
    Tick:
    cmp ax, [CLOCK]
    je Tick
	loop Delay
pop ax
	mov es, ax
popa ;מוציא מהמחסנית הכל
ret
endp ONEsecond
;-----------------------------------------------
proc doing1tick
pusha ;דוחף למחסנית את כל האוגרים
	mov ax, es
push ax
	mov ax, 40h
	mov es, ax
	mov cx, 1 ;המעבד פועל בתדר של 18 טיקים בשניה
	Delay2:
    mov ax, [CLOCK]
    Tick2:
    cmp ax, [CLOCK]
    je Tick2
	loop Delay2
pop ax
	mov es, ax
popa ;מוציא מהמחסנית הכל
ret
endp doing1tick
;==================================MODES PROCEDURES
;==================================================
proc graphic_mode
pusha
    mov ax, 13h
    int 10h
popa
ret
endp graphic_mode
;-----------------------------
proc text_mode
pusha
	mov ah, 0
	mov al, 2
	int 10h
popa
ret
endp text_mode
;===================================GAME PROCEDURES
;==================================================
proc menu
pusha

	mov [BmpLeft],0
	mov [BmpTop],0
	mov [BmpColSize], 320
	mov [BmpRowSize] ,200
	mov dx, offset filename
	call OpenShowBmp

	press_enter_to_start:
	; print "press enter to start"
	mov dl, 9 ; ציר איקס
	mov dh, 21 ; ציר וואי
	mov bx, 0
	mov ah, 2h ;משמש להצבעה על המיקום שבחרנו
	int 10h
	mov dx, offset string
	mov ah, 9h ;הוראת ההדפסה, עם אינטרפט 21
	int 21h

	checkENTER: ;until user presses enter
	; Wait for key press - INT16H
	mov ah,0
	int 16h
	cmp al, 0Dh ;the SCAN CODE OF ENTER KEY compared to AL, which stores the pressed key's ASCII code.
	jne checkENTER
	
popa
ret
endp menu
;-------------------------------------------------------------------------
   proc game_instructions
; Process BMP file AGAIN. 
pusha
	call graphic_mode
	mov dl, 1 ; ציר איקס
	mov dh, 3 ; ציר וואי
	mov bx, 0
	mov ah, 2h ;על מנת שידפיס בחלק הרצוי של המסך
	int 10h
	mov dx, offset string3 ;הוראת ההדפסה
	mov ah, 9h 
	int 21h
	mov dl, 1 ; ציר איקס
	mov dh, 5 ; ציר וואי
	mov bx, 0
	mov ah, 2h ;על מנת שידפיס בחלק הרצוי של המסך
	int 10h
	mov dx, offset string4 ;הוראת ההדפסה
	mov ah, 9h 
	int 21h
	mov dl, 1 ; ציר איקס
	mov dh, 7 ; ציר וואי
	mov bx, 0
	mov ah, 2h ;על מנת שידפיס בחלק הרצוי של המסך
	int 10h
	mov dx, offset string5 ;הוראת ההדפסה
	mov ah, 9h 
	int 21h
	mov dl, 1 ; ציר איקס
	mov dh, 9 ; ציר וואי
	mov bx, 0
	mov ah, 2h ;על מנת שידפיס בחלק הרצוי של המסך
	int 10h
	mov dx, offset string6 ;הוראת ההדפסה
	mov ah, 9h 
	int 21h
	mov dl, 1 ; ציר איקס
	mov dh, 13 ; ציר וואי
	mov bx, 0
	mov ah, 2h ;על מנת שידפיס בחלק הרצוי של המסך
	int 10h
	mov dx, offset string7 ;הוראת ההדפסה
	mov ah, 9h 
	int 21h
	mov dl, 1 ; ציר איקס
	mov dh, 11 ; ציר וואי
	mov bx, 0
	mov ah, 2h ;על מנת שידפיס בחלק הרצוי של המסך
	int 10h
	mov dx, offset string9 ;הוראת ההדפסה
	mov ah, 9h 
	int 21h

	checkENTER2: ;until user presses enter
	; Wait for key press - INT16H
	mov ah,0
	int 16h
	cmp al, 0Dh ;the ASCII CODE OF ENTER KEY compared to AL, which stores the pressed key's ASCII code.
	jne checkENTER2
	
popa
ret
endp game_instructions
;----------------------------------------------------------------------
proc game_starts_in
pusha

	call graphic_mode
	;printing the timer and "game starts in"
	; print "game starts in"
	mov dl, 7 ; ציר איקס
	mov dh, 12 ; 12 בציר הוואי כדי שייצא באמצע
	mov ah, 2h ;על מנת שידפיס בחלק הרצוי של המסך
	int 10h
	mov dx, offset string1 ;הוראת ההדפסה
	mov ah, 9h
	int 21h

	mov cx, 4 ;4 שניות לתחילת המשחק
	PRINTINGseconds:
	; print the seconds
	mov dl, 22 ; ציר איקס
	mov dh, 12 ; 12 בציר הוואי כדי שייצא באמצע
	mov bx, 0 ; לוודא שהאוגר לא מצביע על שום מקום אחר בזיכרון לנוחות בלבד
	mov ah, 2h ;על מנת שידפיס בחלק הרצוי של המסך
	int 10h
	mov dx, offset seconds ;הוראת ההדפסה
	mov ah, 9h
	int 21h
	dec [byte ptr seconds]
	call ONEsecond
	loop PRINTINGseconds
	
popa
ret
endp game_starts_in
;--------------------------------------------
proc you_lost_Screen
pusha
    call graphic_mode
    mov [BmpLeft],80
	mov [BmpTop], 0
	mov [BmpColSize], 150
	mov [BmpRowSize] ,150
	mov dx, offset filename2
	call OpenShowBmp
	
	;string 10 - oh no you failed
	mov dl, 10 ; ציר איקס 
	mov dh, 18 ;ציר וואי
	mov ah, 2h ;על מנת שידפיס בחלק הרצוי של המסך
	int 10h
	mov dx, offset string10 ;הוראת ההדפסה
	mov ah, 9h
	int 21h
	
	;rockets survived
	mov dl, 9 ; ציר איקס
	mov dh, 19 ;ציר וואי
	mov ah, 2h ;על מנת שידפיס בחלק הרצוי של המסך
	int 10h
	mov dx, offset string2 ;הוראת ההדפסה
	mov ah, 9h
	int 21h
	
	;number of rockets survived
	mov dl, 27 ; ציר איקס
	mov dh, 19 ; ציר וואי
	mov ah, 2h ;מציאת מיקום ההדפסה
	int 10h
	mov dx, offset AsarotNumber ;הוראת ההדפסה
	mov ah, 9h ;ההדפסה
	int 21h
	
	;press enter to start again
	mov dl, 7 ; ציר איקס
	mov dh, 21 ;ציר וואי
	mov ah, 2h ;על מנת שידפיס בחלק הרצוי של המסך
	int 10h
	mov dx, offset string11 ;הוראת ההדפסה
	mov ah, 9h
	int 21h
	
	;press q to quit
	mov dl, 7 ; ציר איקס
	mov dh, 22 ;ציר וואי
	mov ah, 2h ;על מנת שידפיס בחלק הרצוי של המסך
	int 10h
	mov dx, offset string12 ;הוראת ההדפסה
	mov ah, 9h
	int 21h
	
	
checkWhichKEYpressed: ;until user presses enter
; Wait for key press - INT16H
	mov ah,0
	int 16h
	
	cmp al, 0Dh ;the ASCII CODE OF ENTER KEY compared to AL, which stores the pressed key's ASCII code.
	je CALL_game_starts_in
	cmp al, 'q'
	je call_to_exit
	jne checkWhichKEYpressed
	
	CALL_game_starts_in:
	call play_again
	
	call_to_exit:
	call exit
	popa
	ret
endp you_lost_Screen
;--------------------------------------------
proc background_for_game
pusha

	mov ax, 15
	mov bx, 18*320  
	mov cx, 200*320 
    screenLOOP1:
	mov [es:bx],ax
	inc bx
	cmp cx, bx
	jne screenLOOP1
	
popa
ret
endp background_for_game
;---------------------------------------------
proc clear_plane_trail_W
pusha

	DrawMImage StartPlaneX,StartPlaneY,PlnMW,PlnMH, PlaneWhite
	
popa
ret
endp clear_plane_trail_W
;---------------------------------------------
proc clear_plane_trail_A
pusha

    DrawMImage StartPlaneX,StartPlaneY,PlnMW,PlnMH, PlaneWhite
	
popa
ret
endp clear_plane_trail_A
;---------------------------------------------
proc clear_plane_trail_S
pusha

	DrawMImage StartPlaneX,StartPlaneY,PlnMW,PlnMH, PlaneWhite
	
popa
ret
endp clear_plane_trail_S
;---------------------------------------------
proc clear_plane_trail_D
pusha

	DrawMImage StartPlaneX,StartPlaneY,PlnMW,PlnMH, PlaneWhite
	
popa
ret
endp clear_plane_trail_D
;---------------------------------------------
proc clear_rocket_trail
pusha

	DrawMImage StartRocketX,StartRocketY,RktML,RktMH, RktWhite
	
popa
ret
endp clear_rocket_trail
;---------------------------------------------
proc scoreboard
pusha
;call clearBLACK needs to get the pixels needed to print on black.
;the parameter save on cx.
	mov cx, 18*320
	call clearBLACK
;printing your score text
	mov dl, 1 ; ציר איקס
	mov dh, 1 ; ציר וואי
	mov ah, 2h ;מציאת מיקום ההדפסה
	int 10h
	mov dx, offset string2 ;הוראת ההדפסה
	mov ah, 9h ;ההדפסה
	int 21h

	mov dl, 19 ; ציר איקס
	mov dh, 1 ; ציר וואי
	mov ah, 2h ;מציאת מיקום ההדפסה
	int 10h
	mov dx, offset AsarotNumber ;הוראת ההדפסה
	mov ah, 9h ;ההדפסה
	int 21h
	
popa
ret
endp scoreboard
;---------------------------------------------
proc IncreaseScore
                                      ;IncreaseScore Procedure Explainations
    cmp [byte ptr YehidotNumber], '9' ;Checks if the yehidot number is 9.
    jne DontIncreaseAsarot            ;If yes, xor YehidotNumber, 0 and increase AsarotNumber by 1.
    inc [byte ptr AsarotNumber]       ;If no, just increase YehidotNumber by 1.
    mov [byte ptr YehidotNumber], '0'
	jmp asarot_radial

    DontIncreaseAsarot:
    inc [byte ptr YehidotNumber]
	
	asarot_radial:

ret
endp IncreaseScore
;---------------------------------------------
proc planePrint
;print the plane

DrawMImage StartPlaneX,StartPlaneY,PlnMW,PlnMH, Plane

ret
endp planePrint
;===================================KEYS PROCEDURES
;==================================================
proc IsKeyPressed
pusha

	mov ah, 0Bh
	int 21h
	cmp al,0
	
popa
ret
endp IsKeyPressed
;--------------------------------------------------
Proc movePlane
pusha
	mov ah, 7h ;finding out which key presses - main difference between 7h and 1h 
	int 21h ;is that 7h does not shows the key pressed on the screen.
	mov [keyPress], al
		W_UP:
		    cmp [keyPress], 'w'
		    jne S_DOWN
			call clear_plane_trail_W
		    sub [StartPlaneY], 10
		    jmp goOUT
		S_DOWN:
			cmp [keyPress], 's'
			jne A_LEFT
			call clear_plane_trail_S
			add [StartPlaneY], 10
			jmp goOUT
		A_LEFT:
			cmp [keyPress], 'a'
			jne D_RIGHT
			call clear_plane_trail_A
			sub [StartPlaneX], 10
			jmp goOUT
		D_RIGHT:
			cmp [keyPress], 'd'
			jne ESC_OUT
			call clear_plane_trail_D
			add [StartPlaneX], 10
			jmp goOUT
		ESC_OUT:
            cmp [keyPress], 'q'
            je call_to_exit_2
			jne goOUT
			
			call_to_exit_2:
			call exit
			
		goOUT:
        call scoreboard
		call planePrint
popa
ret
endp movePlane
;------------------------------------------

start:
	mov ax, @data
    mov ds, ax
	
call graphic_mode	
call menu	
call game_instructions
;call clearBLACK needs to get the pixels needed to print on black.
;the parameter save on cx.
mov cx ,200*320 ;כל הפיקסלים על המסך בגרפיק מוד
call clearBLACK
play_again: ;label for those who pressed ENTER after they failed the game
mov [byte ptr AsarotNumber], '0'
mov [byte ptr YehidotNumber], '0'
mov [byte ptr seconds], '3'
mov [StartRocketX], 280
mov [StartPlaneX], 50
mov [StartPlaneY], 100
call game_starts_in
call background_for_game
call scoreboard
call planePrint

mainLOOP:
call IsKeyPressed
jne callThePLANE
continue:
call doing1tick
call clear_rocket_trail
sub [StartRocketX], 10
DrawMImage StartRocketX,StartRocketY,RktML,RktMH, Rkt
cmp [startRocketX], 0
je callNEWrocket
continue2:
call checkCollide
jmp mainLOOP

callTHEplane:
call moveplane
jmp continue

callNEWrocket:
call IncreaseScore
call scoreboard
call clear_rocket_trail
call randomNUMBER
call WhatY
jmp continue2


exit:
call text_mode
mov ax, 4c00h
int 21h
include 'rnd.inc'
END start