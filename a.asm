assume cs:codesg

data segment
	db 41,42,43,44,0
data ends

codesg segment
	start:  mov ax,data
			mov ds,ax

			mov dh,12
			mov dl,4
			mov cl,02
			mov si,0
			call show_str

			mov ax,4C00H
			int 21H

	; dh=行号(0~24)
	; dl=列号(0~79)
	; cl=颜色
	; ds:si=字符串首地址
show_str:	push cx
			push di
			push es
			push bx
			push ax

			mov di,0
			mov ah,0
			mov al,9FH
			mul dh
			mov bx,ax

			mov ah,0
			mov al,2
			mul dl
			mov dl,cl

			add bx,ax
			add bx,0B800H
			mov es,bx

		z:	push di
			add di,si
			mov cl,ds:[di]
			pop di
			mov ch,0
			jcxz endz
			push di
			add di,di
			mov byte ptr es:[di],cl
			mov byte ptr es:[di+1],dl

			pop di
			inc di
			mov cx,2
			loop z

			
	endz:	pop ax
			pop bx
			pop es
			pop di
			pop cx
			ret
codesg ends
end start