assume cs:code

; https://www.cnblogs.com/Base-Of-Practice/articles/6883929.html

code segment
start:  mov ax,4240H
        mov dx,000FH
        mov cx,0AH
        call divdw

        mov ax,4C00H
        int 21H


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
code ends


end start