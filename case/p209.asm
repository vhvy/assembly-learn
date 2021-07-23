assume cs:code

data_str segment
    dw 2465,12666,1,8,3,38
data_str ends

data segment
    db 10 dup (0)
data ends

code segment
start:  mov bx,data
        mov ds,bx
        mov bx,data_str
        mov es,bx

        mov si,0
        call clean

        mov cx,6
        mov di,0
        mov dh,8
        
        mov dl,3
    p:  mov si,0
        mov ax,es:[di]
        push dx
        mov dx,0
        call dtoc

        pop dx

        
        push cx
        mov ch,0
        mov cl,02H
        mov si,0
        call show_str
        pop cx

        call clean
        inc dh
        add di,2
        loop p

        ; mov dh,8
        ; mov dl,3
        ; mov cl,2
        ; call show_str

        mov ax,4C00H
		int 21H

clean:  push ax
        push ds
        push si
        push cx

        mov ax,data
        mov ds,ax
        mov si,0
        mov cx,10
    w:  mov byte ptr ds:[si],0
        inc si
        loop w

        pop cx
        pop si
        pop ds
        pop ax
        ret

    ; ax=dword型数据低16位
    ; dx=dword型数据高16位
    ; ds:si=字符串首地址
dtoc:   push cx
        push dx
        push bx
        ; mov dx,0
        ; mov bx,10
        mov cx,10
    
    s:  call divdw  ; ax 商的低16位
                    ; dx 商的高16位
                    ; cx 余数
        mov bx,cx

        mov cx,ax
        or cx,0
        or cx,dx    ; 判断高16位和低16位是否都为0


        add bx,30H  ;计算当前字符的ascii值
        push bx     ;压栈
        inc si
        jcxz g      ; 商为0时跳转到下一个处理部分
        mov cx,11

        loop s

    g:  mov cx,si
        mov si,0
    s0: pop ds:[si] ;倒序出栈字符ascii值
        inc si
        loop s0

        pop bx
        pop dx
        pop cx
        ret

    ;@params ax=dword lot 16 bit
    ;        dx=dword high 16 bit
    ;        cx=dividor
    ;@return ax=quotient low 16bit
    ;        dx=quotient high 16bit
    ;        cx=remainder
divdw:  push ax
        mov ax,dx
        mov dx,0
        div cx
        mov bx,ax   ; 保存商到bx里，结果的高位部分 
                    ; 余数在dx里

        pop ax      ; 弹出被除数低位数据
        div cx
        
        mov cx,dx
        mov dx,bx

        ret

	; dh=行号(0~24)
	; dl=列号(0~79)
	; cl=颜色
	; ds:si=字符串首地址
show_str:	push cx
			push di
			push es
			push bx
			push ax
            push dx
			mov ax,0B800H
			mov es,ax

			mov di,0
			mov ah,0
			mov al,0A0H
			mul dh
			mov bx,ax

			mov ah,0
			mov al,2
			mul dl
			mov dl,cl

			add bx,ax

		z:	push di
			add di,si
			mov cl,ds:[di]
			pop di
			mov ch,0
			jcxz endz
			push di
			add di,di
			mov byte ptr es:[bx+di],cl
			mov byte ptr es:[bx+di+1],dl

			pop di
			inc di
			mov cx,2
			loop z

			
	endz:	pop dx
            pop ax
			pop bx
			pop es
			pop di
			pop cx
			ret

code ends

end start