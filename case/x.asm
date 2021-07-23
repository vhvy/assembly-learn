assume cs:codesg

color segment
    db 00000010B,00100100B,01110001B
color ends

string segment
    db 'welcome to masm!'
string ends

codesg segment

start:  mov ax,color
        mov es,ax

        mov ax,string
        mov ds,ax

        mov cx,3
        mov si,0
        mov dx,0B87CH
    s:  mov ah,es:[si]
        push es
        push cx

        mov es,dx
        mov cx,16
        mov di,0
    s0: mov al,ds:[di]
        push di

        add di,di
        mov es:[di],ax

        pop di
        inc di
        loop s0

        add dx,0AH
        pop cx
        pop es
        inc si
        loop s



    mov ax,4C00H
    int 21H

codesg ends

end start