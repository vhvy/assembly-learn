assume cs:code

stack segment
	db 128 dup (0)
stack ends

data segment
	dw 0,0
data ends

code segment

    start:  mov ax,stack
			mov ss,ax
			mov sp,128

			push cs
			pop ds

			mov ax,0
			mov es,ax

			mov si,offset int9
			mov di,204H
			mov cx,offset int9end-offset int9
			cld
			rep movsb
			; 将新的中断程序传送到到0:204H

			push es:[9*4]
			pop es:[200H]
			push es:[9*4+2]
			pop es:[202H]
			; 将原来的中断程序地址传送到200H处

			
			cli
			mov word ptr es:[9*4],204H
			mov word ptr es:[9*4+2],0
			sti
			; 将9号中断处理程序的地址修改为0:204H

            mov ax,4C00H
            int 21H

	int9:	push ax
			push bx
			push cx
			push es
			
			in al,60H

			pushf
			call dword ptr cs:[200H]
			; 模拟执行原来的中断处理程序，读取输入

			cmp al,3BH
			jne int9ret
			; 检测输入码是否为F1
			
			mov ax,0B800H
			mov es,ax
			mov bx,1
			mov cx,2000
		s:	inc byte ptr es:[bx]
			add bx,2
			loop s
			; 循环更新第一页的页面颜色，约4000个字节

	int9ret:
			pop es
			pop cx
			pop bx
			pop ax
			iret
	int9end:
			nop
code ends

end start