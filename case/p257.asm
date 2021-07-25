assume cs:code

data segment
    db 'conversation',0
data ends

code segment
start:  mov dx,7CH
        call install

        mov ax,data
        mov ds,ax
        mov si,0
        mov ax,0B800H
        mov es,ax
        mov di,12*160

    s:  cmp byte ptr [si],0
        je ok
        mov al,[si]
        mov es:[di],al
        inc si
        add di,2
        mov bx,offset s-offset ok
        int 7ch
    ok: mov ax,4C00H
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
        mov bp,sp
        
        add [bp+2],bx
        pop bp
        iret

handlend:
        nop

code ends

end start