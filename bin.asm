DATA SEGMENT

    number db 0
    msgStart db " (C)convert base by Hanan Ouziel(C)",10,13,'$'
	msg_input db "your input was :$" 
    msg_end db "convert another number? <Y/N>",10,13,'$'
    msg_number_prompt db  "Please enter your base to convert from: ",10,13,'$'
    msg_invalid_number db  "    Wrong input. Please try again: ",10,13,'$'
    msgBase db "<'H'=Hex, 'D'=Dec, 'O'=Oct, 'B'=Bin>: ",10,13,'$'
    msg_binary db  "Binary is: ",10,13,'$'
    msg_octal db  "Octal is: " ,10,13,'$'
    msg_decimal db  "Decimal is: ",10,13,'$'
    msg_hex db "Hexadecimal is : ",10,13,'$'
    msgend db "thenk you for using my convert",10,13,'$'
    msgend2 db "     (C) Hanan Ouziel (C)",10,13,'$' 
    CR DB 10,13,'$' 
    NAME1  DB 25+1,25+2 dup('$')
    msg1 db "IN -> $"
    msg2 db "=$"

    BINAR DB 18 dup ('$')  
    TEMPB DB 18 dup ('$')
    OCTAL DB 9 dup ('$')  
    TEMPO DB 9 dup ('$')
    HEX DB 6 dup ('$')  
    TEMPH DB 6 dup ('$')
	DECIMAL1 db 9 dup ('$')  
	TEMPD db 9 dup ('$')
    DECIMAL DW ?
    LEN DB ? 
    mull db ?
    base db ?
	ezer db ? 
	ezer2 dw ?
	letter db ?

DATA ENDS

SSEG SEGMENT STACK
    DW 100 DUP (?)
SSEG ENDS

CODE SEGMENT
ASSUME CS:CODE, DS:DATA, SS:SSEG

START:   MOV AX,DATA         
         MOV DS,AX 
		 
proc yes
  CALL clear
  ;call begin
  
endp 

proc begin
    MOV DX,OFFSET CR
    MOV AH,9
    INT 21H  
	
	MOV dx, OFFSET msgStart      
    mov ah, 9
    int 21h 
	
endp
proc _start
    call reload
	

    MOV DX,OFFSET CR
    MOV AH,9
    INT 21H  
    
    
    MOV dx, OFFSET msg_number_prompt       
    mov ah, 9
    int 21h 
    
    MOV dx, OFFSET msgBase       
    mov ah, 9
    int 21h                      
    
    ; קTOOK THE BASE FROM USER
    mov ah, 1
    int 21h
    
    mov base,al     
    ; CHECK BASE
    cmp al, 'B'
    je b 
    cmp al, 'O'
    je o
    cmp al, 'D'
    je d
    cmp al, 'H'
    je h
	JMP z
	b:
	 call read_binary_number
	  jmp z
	o:
	 call read_octal_number
	jmp z
	d:
	call read_decimal_number
	jmp z
	h:
	call read_hex_number
	z:
	 call MSG_ERROR
	  RET
endp            

proc reload
       MOV DECIMAL,0
	MOV LEN,0
    MOV mull,0
    MOV base,0
	MOV ezer,0
	MOV ezer2,0
	
 ret
endp
  
proc MSG_ERROR
    ; MSG ERROR
	CALL clear
    MOV DX,OFFSET CR
    MOV AH,9
    INT 21H
    
    MOV dx,OFFSET msg_invalid_number 
    mov ah, 9
    int 21h
    
    call _start
	 
endp
proc read_binary_number
    MOV DX,OFFSET CR
    MOV AH,9
    INT 21H 
    
    MOV DX,OFFSET NAME1
    MOV ah,0Ah
	int 21h 
	
	MOV CL,NAME1+1
    MOV LEN,CL
    
    CMP LEN,16
    JG bZ
    
      XOR CX,CX
      MOV CL,LEN
      
    ; THE BINAR IN AL
    ;CHANGE TO OTHER BASE
    call binary_to_decimal
    call print_results
	jmp bE
   bZ:
   call MSG_ERROR
   bE:
    RET
endp
proc read_octal_number
    MOV DX,OFFSET CR
    MOV AH,9
    INT 21H 
    
    MOV DX,OFFSET NAME1
    MOV ah,0Ah
	int 21h 
     
    MOV CL,NAME1+1
    MOV LEN,CL
    
    CMP LEN,6
    JG oZ
    
    call octal_to_decimal
    call print_results
	jmp oE
  oZ:
  call MSG_ERROR
  oE:
    RET
endp
proc read_decimal_number
    MOV DX,OFFSET CR
    MOV AH,9
    INT 21H 
    
    MOV DX,OFFSET NAME1
    MOV ah,0Ah
	int 21h 
     
    MOV CL,NAME1+1
    MOV LEN,CL
	
    CMP LEN,6
    JG dZ
    
    call decimalToDecimal 
    call print_results
	jmp dE
  dZ:
  call MSG_ERROR 
  dE:
    RET
endp
proc read_hex_number
    MOV DX,OFFSET CR
    MOV AH,9
    INT 21H 
    
    MOV DX,OFFSET NAME1
    MOV ah,0Ah
	int 21h 
     
    MOV CL,NAME1+1
    MOV LEN,CL
    
    CMP LEN,4
    JG  hZ
    
    mov bl, 16 ; HRX IN BASE 16
    call hexa_to_decimal
    call print_results
  hZ:
  call MSG_ERROR
  hE:
   RET
endp
proc print_results
    ;PRINT  
    call clear
    MOV DX,OFFSET CR
    MOV AH,9
    INT 21H 
    
     MOV dx,OFFSET msg_input
    mov ah, 9
    int 21h 
  
  
    MOV DX,OFFSET CR
    MOV AH,9
    INT 21H 
     MOV dx,OFFSET msg1
     mov ah, 9
    int 21h
    
    mov dl,base
    mov ah,2
    int 21h
    
     MOV dx,OFFSET msg2
    mov ah, 9
    int 21h
    
     
    
    
    MOV dx,OFFSET NAME1+2
    mov ah, 9
    int 21h 

    
    call printByBase
      RET
endp
proc again
     MOV DX,OFFSET CR
    MOV AH,9
    INT 21H 
	 
	MOV DX,OFFSET CR
    MOV AH,9
    INT 21H    
    
    MOV dx,OFFSET msg_end
    mov ah, 9
    int 21h 
    
    mov ah,1
    int 21h
    
    cmp al,'Y'
    je pS
	
    pE:
	  ; END PROGRAM
	  CALL clear
	MOV DX,OFFSET CR
    MOV AH,9
    INT 21H   
      
	MOV dx,OFFSET msgend
    mov ah, 9
    int 21h  
    
    MOV dx,OFFSET msgend2
    mov ah, 9
    int 21h
      
    mov ah, 4Ch
    int 21h
	pS:
	 call yes
	 RET
endp
proc decimalToDecimal
       
     xor cx,cx 
     mov cl,len 
     mov mull,CL     
     mov si,offset NAME1+2          
loop5:     
     PUSH CX 
     XOR CX,CX 
     XOR DX,DX
     DEC MULL     
     MOV CL,MULL
     XOR AX,AX
     mov Dl,[si]
    
     SUB DL,30H       
     CMP DL,9
     JG ddZ
     cmp MULL,0
     je SKIP4 
     MOV AL,10 
     
LOOP6:
     
     MUL DX 
     mov DX,10
     LOOP LOOP6
     jmp next4
     
SKIP4:
     add DECIMAL,DX
next4:add DECIMAL,ax
     inc si
     POP CX
     LOOP loop5
	 jmp ddE
    ddZ:
      call MSG_ERROR
    ddE:
ret
endp
proc binary_to_decimal
    
     xor cx,cx 
     mov cl,len 
     mov mull,CL     
     mov si,offset NAME1+2
          
loopB:
     PUSH CX 
     XOR CX,CX 
     XOR DX,DX
     DEC MULL     
     MOV CL,MULL
     XOR AX,AX
     mov Dl,[si]
     SUB DL,30H    
     CMP DL,1
     JG bdZ
     cmp MULL,0     
     je SKIP3 
     MOV AL,2 
     
LOOP3: 
     MUL DX
     mov dX,2 
     LOOP LOOP3 
     jmp next3
SKIP3:
     add DECIMAL,dX
next3:add DECIMAL,ax
     inc si
     POP CX
     LOOP loopB
    jmp bdE
    
    bdZ:
	call MSG_ERROR
	bdE:
	  RET
endp

proc octal_to_decimal
     xor cx,cx 
     mov cl,len 
     mov ax,0
     mov bx,0
     
     mov si,offset NAME1+2
        
   loopO:
     
     mov bl,[si]
     SUB bl,30H 
     mov bh,0
     shl ax,3
     add ax,bx
     INC si
     
     CMP bl,7
     JG odZ
    loop loopO  
    mov DECIMAL,ax
  jmp odE
   
   odZ:
   call MSG_ERROR
   odE:
     RET
endp
proc hexa_to_decimal
     
     xor cx,cx 
     mov cl,len 
     mov mull,CL     
     mov si,offset NAME1+2          
loopC:     
     PUSH CX 
     XOR CX,CX 
     XOR DX,DX
     DEC MULL     
     MOV CL,MULL
     XOR AX,AX
     mov Dl,[si]
     cmp dl,'A'
     je tagA
     cmp dl,'B'
     je tagB
     cmp dl,'C' 
     je tagC 
     cmp dl,'D'
     je tagD   
     cmp dl,'E'
     je tagE
     cmp dl,'F'
     je tagF
     SUB DL,30H       
     CMP DL,9
     JG hdZ
     jmp continue
     
tagA:   mov dl,10 
     jmp continue
tagB:   mov dl,11
     jmp continue
tagC:   mov dl,12   
     jmp continue
tagD:   mov dl,13   
     jmp continue
tagE:   mov dl,14   
     jmp continue
tagF:   mov dl,15
continue:
     cmp MULL,0
     je SKIP2 
     MOV AL,16 
     
LOOP2:
     
     MUL DX 
     mov DX,16
     LOOP LOOP2
     jmp next2 
     
SKIP2:
     add DECIMAL,DX
next2:add DECIMAL,ax
     inc si
     POP CX
     LOOP loopC
	 jmp hdE
    hdZ:
      call MSG_ERROR
    hdE:
       RET	
endp

proc clear
	mov ax, 3h
	int 10h
	
	mov ax,0h
    int 10h
	ret
endp  
proc printByBase
  mov al,base
  cmp al,'B'
  je noteB
  cmp al,'O'
  je noteO
  cmp al,'D'
  je noteD
  cmp al,'H'
  je noteH
  noteB:
  call print_decimal
  call print_octal
  call print_hex
  jmp noteE
  noteO:
    call print_binary
	call print_decimal
	call print_hex
	jmp noteE
  noteD:
  call print_binary
  call print_octal
  call print_hex 
  jmp noteE
  noteH:
  call print_binary
  call print_octal
  call print_decimal
  noteE:
  call again
  RET
endp
proc print_binary
   
 MOV DX,OFFSET CR
    MOV AH,9
    INT 21H
   
    MOV dx,OFFSET msg_binary
    mov ah, 9
    int 21h
   
    mov ax,DECIMAL
    mov si, offset BINAR+8
mov di, offset TEMPB
xor bx,bx
mov ezer,2
xor dx,dx
mov dl,ah
xor ah,ah
mov len,8
mov cl,len
    loopfirstB:
   div ezer
   mov bl,ah
   add bl,30h
   mov [di],bl
   mov ah,0
   inc di
   loop loopfirstB
   call backward  
   mov al,dl
   mov cl,len
   mov si, offset BINAR
loopsecondB:
   div ezer
   mov bl,ah
   add bl,30h
   mov [di],bl
   mov ah,0
   inc di
   loop loopsecondB
   call backward
     
    outTotalB:
MOV dx,OFFSET BINAR
    mov ah, 9
    int 21h
  RET
    
    
endp

proc print_octal
    
     MOV DX,OFFSET CR
    MOV AH,9
    INT 21H 
    
    MOV dx,OFFSET msg_octal 
    mov ah, 9
    int 21h
   
       
    mov ax,DECIMAL
    mov si, offset OCTAL
    mov di,offset TEMPO
	
	xor bx,bx
		mov ezer2,8
	xor dx,dx
	mov len,6 
	mov cl,len
    loopfirstO:
	    div ezer2
	    mov bl,dl
	    add bl,30h
	    mov [di],bl
	    mov DL,0
	    inc di
	    loop loopfirstO
	    XOR BH,BH
	    ADC [DI],BH
	    call backward  
	   
	
        
    outTotalO:
	MOV dx,OFFSET OCTAL
    mov ah, 9
    int 21h 
    
    RET
    
endp

proc print_decimal
   
    MOV DX,OFFSET CR
    MOV AH,9
    INT 21H 
    
    MOV dx,OFFSET msg_decimal 
    mov ah, 9 
    int 21h 
   
           
    mov ax,DECIMAL
    mov si, offset DECIMAL1
    mov di,offset TEMPD
	
	xor bx,bx
		mov ezer2,10
	xor dx,dx
	mov len,5 
	mov cl,len
    loopfirstD:
	    div ezer2
	    mov bl,dl
	    add bl,30h
	    mov [di],bl
	    mov DL,0
	    inc di
	    loop loopfirstD
	    XOR BH,BH
	    ADC [DI],BH
	    call backward  
	   
	
     MOV dx,OFFSET DECIMAL1
     mov ah, 9
    int 21h
   
   RET
 
    
      

endp

proc print_hex
    
    MOV DX,OFFSET CR
    MOV AH,9
    INT 21H 
    
    MOV dx,OFFSET msg_hex 
    mov ah, 9 
    int 21h 
    
   
    
    MOV AX,DECIMAL 
    mov si, offset HEX
    mov di,offset TEMPH
	
	xor bx,bx
	mov ezer2,16
	xor dx,dx
	mov len,4
	mov cl,len
    loopfirstH:
	    div ezer2
	    mov bl,dl 
	    add bl,30h
	    mov letter,bl
	    call letters
	    mov bl,letter
	    mov [di],bl
	    mov DL,0
	    inc di
	    loop loopfirstH
	    XOR BH,BH
	    ADC [DI],BH
	    call backward  
	   
	
     MOV dx,OFFSET HEX
     mov ah, 9
    int 21h
  
     
    
    RET
    
endp
  
proc letters
    cmp letter,':'
    jl eL
    je lA
    
    cmp letter,';'
    je lB
    cmp letter,'<'
    je lC
    cmp letter,'='
     je lD
    cmp letter,'>'
     je letterE
    cmp letter,'?'
     je lF
     
     lA:
       mov letter,'A'
       jmp eL
     lB:
       mov letter,'B'
       jmp eL
     lC:
       mov letter,'C'
       jmp eL
     lD:
       mov letter,'D'
       jmp eL
     letterE:
       mov letter,'E'
      jmp eL
     lF:
       mov letter,'F'
     
    eL:
  ret
endp
proc backward
    mov cl,len
    dec di
    inf3: 
	  mov bl,[di]
	  mov [si],bl
	  inc si
	  dec di
	  loop inf3	
    
    ret
endp

CODE ENDS
END START