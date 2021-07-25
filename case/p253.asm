assume cs:code

code segment
start:  mov dx,7CH
        call install

        mov ax,16
        int 7ch
        ; add ax,ax
        ; adc dx,dx

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
        mul ax
        iret

handlend:
        nop

code ends

end start