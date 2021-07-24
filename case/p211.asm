assume cs:code

; 课程设计1完成，但是在DOSBOX里多次运行编译后的EXE文件
; 除去第一页之外，总会多一个0出来，待修复

idea_data segment
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
 
idea_data ends

data segment
    db 16 dup (0)
data ends

code segment
start:  mov bx,data
        mov ds,bx
        mov bx,idea_data
        mov es,bx

        mov si,0
        call clean

        mov cx,21
        mov di,0
        
        mov dl,0 ; 列号
        mov dh,1 ; 行号
        

    p:  push di
            add di,di
            mov ax,es:[di]
            mov ds:[0],ax
            mov ax,es:[di+2]
            mov ds:[2],ax
        pop di

        mov dl,0
        call printc 
        ; 输出data段里的字符串 年份

        push dx
        push di
            add di,di
            mov ax,es:[di+84]
            mov dx,es:[di+84+2]
            mov si,0
            call dtoc
        pop di
        pop dx
        ; 转换dword字符为ascii
    
        mov dl,10
        call printc
        ; 输出data里的字符串 每年的总收入

        push dx
            mov ax,es:[di+168]
            mov dx,0
            mov si,0
            call dtoc
        pop dx
        ; 转换dword字符为ascii
    
        mov dl,20
        call printc
        ; 输出data里的字符串 公司雇员人数


        push dx
        push cx
            mov cx,es:[di+168] ; 除数
            push di
                add di,di           
                mov ax,es:[di+84]
                mov dx,es:[di+84+2]
            pop di             ; 被除数

            call divdw         ; 计算平均数
                               
            mov si,0
            call dtoc
        pop cx
        pop dx
        ; 转换dword字符为ascii
    
        mov dl,30
        call printc
        ; 输出data里的字符串 公司雇员年均收入




        inc dh ; 输出下一行
        add di,2
        loop p


        mov ax,4C00H
		int 21H

    ; 打印并清理数据
	; dh=行号(0~24)
	; dl=列号(0~79)
	; cl=颜色
	; ds:si=字符串首地址
printc: push cx
        mov ch,0
        mov cl,02H
        mov si,0
        call show_str
        pop cx

        call clean

        ret

    ; 清理 data中的数据
clean:  push ax
        push ds
        push si
        push cx

        mov ax,data
        mov ds,ax
        mov si,0
        mov cx,16
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

    ; 32位除法
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

    ; @params ds:si=字符串首地址
    ; @return dx=字符串长度
str_count:  push cx
            push si
            mov dx,0

        l0: mov cx,ds:[si]
            jcxz r0
            inc si
            inc dx
            loop l0

        r0: pop si
            pop cx
            ret

    ; 在屏幕上输出字符串
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