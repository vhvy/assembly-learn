assume cs:code

code segment
start:  mov ax,cs
        mov ds,ax
        mov si,offset handle

        mov ax,0
        mov es,ax
        mov di,0200H

        mov cx,offset handlend-offset handle

        cld

        rep movsb

        mov ax,0
        mov ds,ax
        mov word ptr ds:[0],0200H
        mov word ptr ds:[2],0

        mov ax,1000H
        mov dx,10
        div dx

        mov ax,4C00H
        int 21H

handle: jmp short handle1
        db "Oops!Error!",0
handle1:
        mov ax,cs
        mov ds,ax
        mov si,202H
        
        mov ax,0B800H
        mov es,ax
        mov di,12*160+36*2
        mov cx,11
    s:  mov al,[si]
        mov es:[di],al
        inc si
        add di,2
        loop s

        mov ax,4C00H
        int 21H

handlend:
        nop

code ends

end start