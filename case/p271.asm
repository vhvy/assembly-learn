assume cs:code


code segment

    start:  mov bx,0B800H
            mov es,bx

            mov di,0

            mov al,9
            call show
            mov byte ptr es:[160*12+24*2+4+di],'\'

            mov al,8
            call show
            mov byte ptr es:[160*12+24*2+4+di],'\'

            mov al,7
            call show
            mov byte ptr es:[160*12+24*2+4+di],' '

            mov al,4
            call show
            mov byte ptr es:[160*12+24*2+4+di],':'

            mov al,2
            call show
            mov byte ptr es:[160*12+24*2+4+di],':'

            mov al,0
            call show

            mov ax,4C00H
            int 21H

    ; @params al,port number
    show:   out 70H,al

            
            add di,6
            in al,71H   ;获取值

            mov ah,al
            mov cl,4
            shr ah,cl           ;十位
            and al,00001111B    ;个位

            add ah,30H
            add al,30H          ;转ascii

            mov byte ptr es:[160*12+24*2+di],ah
            mov byte ptr es:[160*12+24*2+2+di],al

            ret
code ends

end start