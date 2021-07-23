assume cs:codesg

data segment
	db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983'
	db '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992'
	db '1993', '1994', '1995'
	;以上是表示21年的21个字符串382, 1356, 2390, 8000, 16000, 24486, 50065, 97479, 140417, 197514197514197514
; 0000 0000 0000 000084	
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


codesg segment
start:	mov ax,data
		mov ds,ax
		mov ax,table
		mov es,ax

		mov cx,21
		mov si,0
		mov di,0
	s:  mov bp,si
		add si,si

		mov ax,ds:[si]
		mov es:[di],ax
		add di,2

		mov ax,ds:[si+2]
		mov es:[di],ax
		add di,2

		mov byte ptr es:[di],0
		add di,1

		mov ax,ds:[84+si]
		mov es:[di],ax
		add di,2

		mov ax,ds:[84+si+2]
		mov es:[di],ax
		add di,2

		mov byte ptr es:[di],0
		add di,1

		mov si,bp


		mov ax,ds:[168+si]
		mov es:[di],ax
		add di,2

		mov byte ptr es:[di],0
		add di,1


		add si,si
		mov ax,ds:[84+si]
		mov dx,ds:[84+si+2]
		mov si,bp
		div word ptr ds:[168+si]
		mov es:[di],ax
		add di,2

		mov byte ptr es:[di],0
		add di,1

		add si,2
		loop s

		mov ax,4C00H
		int 21H
codesg ends

end start