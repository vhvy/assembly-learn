assume cs:codesg

data segment
	dd 12345678H
data ends

codesg segment
	start:  mov ax,2000H
			mov ds,ax
			mov bx,0
		s:  mov cl,[bx]
			mov ch,0
			inc cx
			inc bx
			loop s
		ok: dec bx
			mov dx,bx
			mov ax,4C00H
			int 21H
codesg ends
end start