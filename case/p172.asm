assume cs:codesg

data segment
 db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983'
 db '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992'
 db '1993', '1994', '1995'
 ;以上是表示21年的21个字符串382, 1356, 2390, 8000, 16000, 24486, 50065, 97479, 140417, 197514197514197514

 dd 16, 22, 382, 1356, 2390, 8000, 16000, 24486, 50065, 97479, 140417, 197514
 dd 345980, 590827, 803530, 1183000, 1843000, 2759000, 3753000, 4649000, 5937000
 ;以上是表示21年公司总收入的21个dword型数据, 130, 220, 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8226, 8226, 8226

 dw 3, 7, 9, 13, 28, 38, 130, 220, 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8226
 dw 11542, 14430, 15257, 17800
 ;以上是表示21年公司雇员人数的21个word型数据
 
data ends
 
table segment
 db 21 dup ('year summ ne ?? ')
table ends

stack segment
 db 16 dup (0)
stack ends

codesg segment
 start:  mov ax,data
   mov ds,ax

   
   mov bx,table

   mov ax,stack
   mov ss,ax
   mov sp,10H

   mov cx,21
   mov si,0 ;+4
   mov di,0 ;+2
  s:  mov ax,ds:[si]
   push ax
   mov ax,ds:[si].2H
   push ax
   ; push year

   mov ax,ds:[54H+si]
   push ax
   mov ax,ds:[54H+si].2H
   push ax
   ; push year price

   mov ax,ds:[0A8H+di]
   push ax
   ; push clerk total

   push cx

   mov ax,ds:[54H+si]
   mov dx,ds:[54H+si].2H
   ; prepare dividend
   mov cx,ds:[0A8H+di]

   div cx

   pop cx
   push ax

   
    mov bx,ds
    mov ax,table
    mov ds,ax

    mov ax,di
    add di,ax
    add di,ax
    add di,ax
    add di,ax
    add di,ax
    add di,ax
    add di,ax

    mov byte ptr ds:[di+0FH],0
    pop ds:[di+0DH]
    mov byte ptr ds:[di+0CH],0
    pop ds:[di+0AH]
    mov byte ptr ds:[di+9H],0
    pop ds:[di+07H]
    pop ds:[di+05H]
    mov byte ptr ds:[di+4H],0
    pop ds:[di+02H]
    pop ds:[di]
    
   
    mov ds,bx
    mov di,ax

    add si,4
    add di,2
    loop s

   mov ax,4C00H
   int 21H
codesg ends

end start