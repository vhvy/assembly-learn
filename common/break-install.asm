assume cs:code


code segment
start:  mov dx,7CH
        call install



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
    x:  mov al,ds:[si]
        cmp al,0
        je o
        cmp al,97
        jb o
        cmp al,122
        ja o
        and byte ptr ds:[si],11011111B
        inc si
        jmp short x

    o:  pop si
        pop ax
        iret

handlend:
        nop

code ends

end start