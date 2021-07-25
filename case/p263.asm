assume cs:code


code segment
start:  mov dx,7CH
        call install

        
        mov ax,0B800H
        mov es,ax
        mov di,160*12
        mov bx,offset s-offset se
        mov cx,80
    s:  mov byte ptr es:[di],'!'
        add di,2
        int 7CH

    se: nop
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
        push bp
        cmp cx,1
        je ok
        mov bp,sp
        add ss:[bp+2],bx
        dec cx

    ok: pop bp
        iret

handlend:
        nop

code ends

end start