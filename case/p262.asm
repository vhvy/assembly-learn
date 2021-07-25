assume cs:code

data segment
    db "I am a Big Star!",0
data ends

code segment
start:  mov dx,7CH
        call install

        

        mov dh,10
        mov dl,10
        mov cl,2
        mov ax,data
        mov ds,ax
        mov si,0

        int 7CH

        mov ax,4C00H
        int 21H

; @params dx=中断处理程序序号
install:
        push ax
        push ds
        push es
        push di
        push si
        push cx


        mov ax,cs
        mov ds,ax
        mov si,offset handle
        ; 设置中断处理程序指令地址

        mov ax,0
        mov es,ax
        mov di,200H
        ; 设置要安装中断处理程序的地址

        mov cx,offset handlend-offset handle

        cld

        rep movsb
        ; 传送指令

        mov ax,4
        mul dx
        mov si,ax

        mov ax,0
        mov ds,ax
        mov word ptr ds:[si],0200H
        mov word ptr ds:[si+2],0
        ; 设置中断向量表

        pop cx
        pop si
        pop di
        pop es
        pop ds
        pop ax
        ret
        ; 安装完成，返回



handle:
        push ax
        push si
        push cx
        push bx
        push si
        push dx
        mov bl,cl
    g:  mov al,ds:[si]
        cmp al,0
        je ok
        
        mov ah,2
        mov bh,0
        ; mov dh,5
        ; mov dl,12
        int 10H

        mov ah,9
        mov cx,1
        int 10H

        inc si
        inc dl
        jmp short g

    ok: mov ah,2
        mov bh,0
        mov dh,23
        mov dl,1
        int 10H
    
        pop dx
        pop si
        pop bx
        pop cx
        pop si
        pop ax
        iret

handlend:
        nop

code ends

end start