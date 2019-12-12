;------------------------------------------
; PURPOSE : A set of routines for generating random numbers
; SYSTEM  : Turbo Assembler Ideal Mode  
; AUTHOR  :  
;------------------------------------------

    	mulnum  dw 8405h
    	rndnum  dd ?
    	temp    dw ?

;----------------------------------------------------------
; Random - generates random number between 0 - (max -1)
;----------------------------------------------------------
; Input:
; 	Stack = number 1 - 65546 
; Output:
; 	Stack = the random number between 0 - (max-1)
; Registers
;	 AX, BH, DX,
;----------------------------------------------------------
PROC Random
    	pop ax
    	mov [temp],ax
    	call rand
    	xor ax,ax
		pop bx
		or  bx,bx
		je  RM_10
		xchg dx,ax
		div bx		; DX:AX / BX -> AX (DX)
		mov ax,dx
    	mov dx,[temp]
    	push dx
RM_10:	ret
ENDP Random
;----------------------------------------------------------
; Rand - generates random number between 1 - 65546
;----------------------------------------------------------
; Input:
; 	rndnum - random number
; Output:
; 	rndnum = the random number between 1 - 65546
; Registers
;	AX, BX, CX, DX
;----------------------------------------------------------
PROC Rand
    	mov ax,[word rndnum]
    	mov bx,[word rndnum+2]
		mov cx,ax
		mul [mulnum] 		; mulnum*AX-> DX:AX
		shl cx,3
		add ch,cl
		add dx,cx
		add dx,bx
		shl bx,2
		add dx,bx
		add dh,bl
		shl bx,5
		add dh,bl
		add ax,1
		adc dx,0 			;destination <- destination + source + CF
		mov [word rndnum],ax
		mov [word rndnum+2],dx
		ret
ENDP Rand
	
;----------------------------------------------------------
; Randomize - initializes the random-number generator
;----------------------------------------------------------
; Input:
; 	none
; Output:
; 	rndnum (dd) = Hour, Minute, Second, 1/100 second
; Registers
;	 AH, CX, DX
;----------------------------------------------------------
PROC Randomize
    	mov ah,2Ch
		int 21h
;----- CH <- Hour
;----- CL <- Minute
;----- DH <- Second
;----- DL <- 1/100 seconds
;----- 0.18 New
    	mov [word rndnum],cx
    	mov [word rndnum+2],dx
		ret
ENDP Randomize
