; vers�o de 10/05/2007
; corrigido erro de arredondamento na rotina line.
; circle e full_circle disponibilizados por Jefferson Moro em 10/2009
;
segment code
..start:
    		mov 		ax,data
    		mov 		ds,ax
    		mov 		ax,stack
    		mov 		ss,ax
    		mov 		sp,stacktop

; salvar modo corrente de video(vendo como est� o modo de video da maquina)
            mov  		ah,0Fh
    		int  		10h
    		mov  		[modo_anterior],al   

; alterar modo de video para gr�fico 640x480 16 cores
    	mov     	al,12h
   		mov     	ah,0
    	int     	10h

call draw_GUI
main:
	call start_mouse
	jmp main

segment functions


draw_GUI:
	;---Inicio Borda GUI---
			; bottom GUI
			mov		byte[cor],branco_intenso
			mov		ax,0
			push		ax
			mov		ax,0
			push		ax
			mov		ax,639
			push		ax
			mov		ax,0
			push		ax
			call		line
			
			; right GUI
			mov		byte[cor],branco_intenso
			mov		ax,639
			push		ax
			mov		ax,0
			push		ax
			mov		ax,639
			push		ax
			mov		ax,479
			push		ax
			call		line
			
			; top GUI
			mov		byte[cor],branco_intenso
			mov		ax,0
			push		ax
			mov		ax,479
			push		ax
			mov		ax,639
			push		ax
			mov		ax,479
			push		ax
			call		line

			; left GUI
			mov		byte[cor],branco_intenso
			mov		ax,0
			push		ax
			mov		ax,0
			push		ax
			mov		ax,0
			push		ax
			mov		ax,479
			push		ax
			call		line
	;---Fim Borda GUI---

	;---Inicio Borda Menu---

			; line h1
			mov		byte[cor],branco_intenso
			mov		ax,0
			push		ax
			mov		ax,79
			push		ax
			mov		ax,639
			push		ax
			mov		ax,79
			push		ax
			call		line
			
			; line h2
			mov		byte[cor],branco_intenso
			mov		ax,0
			push		ax
			mov		ax,159
			push		ax
			mov		ax,64
			push		ax
			mov		ax,159
			push		ax
			call		line
			
			; line h3
			mov		byte[cor],branco_intenso
			mov		ax,0
			push		ax
			mov		ax,239
			push		ax
			mov		ax,64
			push		ax
			mov		ax,239
			push		ax
			call		line

			; line h4
			mov		byte[cor],branco_intenso
			mov		ax,0
			push		ax
			mov		ax,319
			push		ax
			mov		ax,64
			push		ax
			mov		ax,319
			push		ax
			call		line

			; line h5
			mov		byte[cor],branco_intenso
			mov		ax,0
			push		ax
			mov		ax,399
			push		ax
			mov		ax,64
			push		ax
			mov		ax,399
			push		ax
			call		line

			; line v1
			mov		byte[cor],branco_intenso
			mov		ax,64
			push		ax
			mov		ax,0
			push		ax
			mov		ax,64
			push		ax
			mov		ax,479
			push		ax
			call		line
	;---Fim Borda Menu---

	;---Inicio Borda Abas---

			; line v1
			mov		byte[cor],branco_intenso
			mov		ax,384
			push		ax
			mov		ax,79
			push		ax
			mov		ax,384
			push		ax
			mov		ax,639
			push		ax
			call		line

			; line h1
			mov		byte[cor],branco_intenso
			mov		ax,64
			push		ax
			mov		ax,249
			push		ax
			mov		ax,639
			push		ax
			mov		ax,249
			push		ax
			call		line

	;---Fim Borda Abas---		    

	;---Init Texts Menu---
	mov bx, txt_abrir
	mov     	dh,2			;line 0-29
	mov     	dl,1			;column 0-79
	call print_string

	mov bx, txt_fir1
	mov     	dh,7			;line 0-29
	mov     	dl,1			;column 0-79
	call print_string

	mov bx, txt_fir2
	mov     	dh,12			;line 0-29
	mov     	dl,1			;column 0-79
	call print_string

	mov bx, txt_fir3
	mov     	dh,17			;line 0-29
	mov     	dl,1			;column 0-79
	call print_string

	mov bx, txt_histogramas
	mov     	dh,22			;line 0-29
	mov     	dl,1			;column 0-79
	call print_string

	mov bx, txt_sair
	mov     	dh,27			;line 0-29
	mov     	dl,1			;column 0-79
	call print_string

	mov bx, txt_nome
	mov     	dh,27			;line 0-29
	mov     	dl,35			;column 0-79
	call print_string

	mov bx, txt_turma
	mov     	dh,28			;line 0-29
	mov     	dl,35			;column 0-79
	call print_string
	;---End Texts Menu---

	;mov word[y],-10
	;mov word[x],100
	;call plotX
	;mov word[y],-8
	;mov word[x],105
	;call plotX
	;mov word[y],-5
	;mov word[x],110
	;call plotX

	;---End test plot_xy---

	;---Axis x of graphs---
	; axis x graph 1
	mov		byte[cor],magenta_claro
	mov		ax,65
	push		ax
	mov		ax,335
	push		ax
	mov		ax,385
	push		ax
	mov		ax,335
	push		ax
	call		line

	; axis x graph 2
	mov		byte[cor],magenta_claro
	mov		ax,65
	push		ax
	mov		ax,125
	push		ax
	mov		ax,385
	push		ax
	mov		ax,125
	push		ax
	call		line
	;---End x of graphs---
	ret


;
;   Mouse click functions
;
;-->
	; this function start mouse
	start_mouse:
		mov ax,0
		int 33h
		mov ax,1
		int 33h 
		jmp click_check

	;_____________________________________________________________________________
	; this function check if mouse click is on range from buttons on UI and call choose_click if this is true
	click_check:
		mov ax,5              
		mov bx,0
		int 33h               
		cmp bx,0              
		je click_check ; if don't have click on screen -> bx = 0
		cmp cx, 1
		jb click_check ; if x < 1 is false
		cmp cx, 64
		jnb click_check ; if x > 64 is false
		call choose_click
		jmp click_check

	;_____________________________________________________________________________
	; this function finds out which button was clicked on click check and call respectve button select function	
	choose_click:

		;testa abrir botão
		abrir_botao:
			cmp dx, 1
			jb click_check ; if y < 1
			;then y>1
			cmp dx, 79
			jnb fir1_botao ; if y > 79
			;then 1<y<79
			pusha
				mov ax,0600h	;clear screen instruction
				mov ch,1	;start row
				mov cl,9	;start col
				mov dh,12	;end of row
				mov dl,48	;end of col
				int 10h		;BIOS interrupt
				call draw_GUI
			popa
			call read_all
			mov		byte[cor],amarelo
			mov ax, dx
			mov bx, txt_abrir
			mov     	dh,2			;line 0-29
			mov     	dl,1			;column 0-79
			call print_string
			mov dx, ax
			ret
		ret
			

		;testa fir1 botão
		fir1_botao:
			cmp dx, 79
			jb click_check ;if y<79
			;then y>79
			cmp dx, 179
			jnb fir2_botao ;if y>179
			;then 79<y<179
			pusha
				mov ax,0600h	;clear screen instruction
				mov ch,13	;start row
				mov cl,9	;start col
				mov dh,24	;end of row
				mov dl,48	;end of col
				int 10h		;BIOS interrupt
				call draw_GUI
			popa
			call fir1
			call draw_histogram_fir1
			mov		byte[cor],magenta
			mov ax, dx
			mov bx, txt_fir1
			mov     	dh,7			;line 0-29
			mov     	dl,1			;column 0-79
			call print_string
			mov dx, ax
			ret
		ret

		;testa fir2 botão
		fir2_botao:
			cmp dx, 179
			jb near click_check ;if y<179
			cmp dx, 239
			jnb fir3_botao ;if y>239
			;then 179<y<239
			pusha
				mov ax,0600h	;clear screen instruction
				mov ch,13	;start row
				mov cl,9	;start col
				mov dh,24	;end of row
				mov dl,48	;end of col
				int 10h		;BIOS interrupt
				call draw_GUI
			popa
			call fir2
			call draw_histogram_fir2
			mov		byte[cor],magenta
			mov ax, dx
			mov bx, txt_fir2
			mov     	dh,12			;line 0-29
			mov     	dl,1			;column 0-79
			call print_string
			mov dx, ax
			ret
		ret

		;fix error short jump of jb and jnb
		click_check2:		
			jmp click_check
		;testa fir3 botão
		fir3_botao:
			cmp dx, 239
			jb click_check2 ;if y<239
			cmp dx, 319
			jnb histogramas_botao ;if y>239
			;then 239<y<319
			pusha
				mov ax,0600h	;clear screen instruction
				mov ch,13	;start row
				mov cl,9	;start col
				mov dh,24	;end of row
				mov dl,48	;end of col
				int 10h		;BIOS interrupt
				call draw_GUI
			popa
			call fir3
			call draw_histogram_fir3
			mov		byte[cor],magenta
			mov ax, dx
			mov bx, txt_fir3
			mov     	dh,17			;line 0-29
			mov     	dl,1			;column 0-79
			call print_string
			mov dx, ax
			ret
		ret
		;testa histogramas botão
		histogramas_botao:
			cmp dx, 319
			jb click_check2 ;if y<319
			cmp dx, 399
			jnb sair_botao ;if y>399
			;then 319<y<399
			call draw_histograms
			mov		byte[cor],magenta
			mov ax, dx
			mov bx, txt_histogramas
			mov     	dh,22			;line 0-29
			mov     	dl,1			;column 0-79
			call print_string
			mov dx, ax
			ret
		ret
		;testa sair botão
		sair_botao:
			cmp dx, 399
			jb click_check2 ;if y<399
			cmp dx, 479
			jnb click_check2 ;if y>479
			;then 399<y<479
			mov		byte[cor],magenta
			mov ax, dx
			mov bx, txt_sair
			mov     	dh,27			;line 0-29
			mov     	dl,1			;column 0-79
			call print_string
			mov dx, ax
			jmp exit_service
			ret
		ret


;_____________________________________________________________________________
;
;   function to do fir 1 and plot 
fir1:
	pusha
	mov bx,-2
	mov word[x],75
	xor si,si
	mov si,buffer_signal_process
	mov di,buffer_signal_fir1
	mov dx,294
	mov ax,0

	mov bx,16
	empty_intensidade1:
		mov byte[intensidade_fir+bx],0
		dec bx
		jnz empty_intensidade1

	loop_plot_fir1:
		mov ax, 0
		mov bx, 0
		mov bx,si

		push dx
		mov dx,6
		loop_sum_fir1:
			mov cx,word[bx]
			add bx,2
			add ax,cx
			dec dx
			jnz loop_sum_fir1
		end_loop_sum_fir1:
		pop dx
		add si,2

		cmp ax,0
		js divisao_negativa
		divisao_positiva:
		push dx
		push bx
		xor dx,dx
		mov bx,6
		div bx
		pop bx
		pop dx
		jmp fim_divisao
		divisao_negativa:
		;multiply ax by -1
		not ax
		add ax,1
		push dx
		push bx
		xor dx,dx
		mov bx,6
		div bx
		pop bx
		pop dx
		not ax
		add ax,1
		fim_divisao:

		;generate buffer of fir 1 to do histogram after
		mov cx,ax
		mov [di],cx
		add di,2

		pusha
		mov bx,-1
		mov dx,-127
		his1:
			add dx,16
			inc bx
			cmp ax,dx
			jns his1
			add byte[intensidade_fir+bx],15
		popa

		mov word[y],ax
		add word[x],1
		mov word[middle_y],125
		call plotX

		dec dx
		jnz near loop_plot_fir1
	popa
	ret
;_____________________________________________________________________________


;_____________________________________________________________________________
;
;   function to do fir 2 and plot 
fir2:
	pusha
	mov bx,-2
	mov word[x],75
	xor si,si
	mov si,buffer_signal_process
	mov di,buffer_signal_fir2
	mov dx,289 ; index of loop
	mov ax,0

	mov bx,16
	empty_intensidade2:
		mov byte[intensidade_fir+bx],0
		dec bx
		jnz empty_intensidade2

	loop_plot_fir2:
		mov ax, 0
		mov bx, 0
		mov bx,si

		push dx
		mov dx,11
		loop_sum_fir2:
			mov cx,word[bx]
			add bx,2
			add ax,cx
			dec dx
			jnz loop_sum_fir2
		end_loop_sum_fir2:
		pop dx
		add si,2

		cmp ax,0
		js divisao_negativa_fir2
		divisao_positiva_fir2:
		push dx
		push bx
		xor dx,dx
		mov bx,11
		div bx
		pop bx
		pop dx
		jmp fim_divisao_fir2
		divisao_negativa_fir2:
		;multiply ax by -1
		not ax
		add ax,1
		push dx
		push bx
		xor dx,dx
		mov bx,11
		div bx
		pop bx
		pop dx
		not ax
		add ax,1
		fim_divisao_fir2:

		;generate buffer of fir 1 to do histogram after
		mov cx,ax
		mov [di],cx
		add di,2

		pusha
		mov bx,-1
		mov dx,-127
		his2:
			add dx,16
			inc bx
			cmp ax,dx
			jns his2
			add byte[intensidade_fir+bx],15
		popa

		mov word[y],ax
		add word[x],1
		mov word[middle_y],125
		call plotX

		dec dx
		jnz loop_plot_fir2
	popa
	ret
;_____________________________________________________________________________


;_____________________________________________________________________________
;
;   function to do fir 3 and plot 
fir3:
	pusha
	mov bx,-2
	mov word[x],75
	xor si,si
	mov si,buffer_signal_process
	mov di,buffer_signal_fir3
	mov dx,282 ; index of loop
	mov ax,0

	mov bx,16
	empty_intensidade3:
		mov byte[intensidade_fir+bx],0
		dec bx
		jnz empty_intensidade3

	loop_plot_fir3:
		mov ax, 0
		mov bx, 0
		mov bx,si

		push dx
		mov dx,18
		loop_sum_fir3:
			mov cx,word[bx]
			add bx,2
			add ax,cx
			dec dx
			jnz loop_sum_fir3
		end_loop_sum_fir3:
		pop dx
		add si,2

		cmp ax,0
		js divisao_negativa_fir3
		divisao_positiva_fir3:
		push dx
		push bx
		xor dx,dx
		mov bx,18
		div bx
		pop bx
		pop dx
		jmp fim_divisao_fir3
		divisao_negativa_fir3:
		;multiply ax by -1
		not ax
		add ax,1
		push dx
		push bx
		xor dx,dx
		mov bx,18
		div bx
		pop bx
		pop dx
		not ax
		add ax,1
		fim_divisao_fir3:

		;generate buffer of fir 1 to do histogram after
		mov cx,ax
		mov [di],cx
		add di,2

		pusha
		mov bx,-1
		mov dx,-127
		his3:
			add dx,16
			inc bx
			cmp ax,dx
			jns his3
			add byte[intensidade_fir+bx],15
		popa

		mov word[y],ax
		add word[x],1
		mov word[middle_y],125
		call plotX

		dec dx
		jnz loop_plot_fir3
	popa
	ret
;_____________________________________________________________________________

draw_histogram_fir1:
	; Draw --> histogram 2
	pusha
		mov ax,0600h	;clear screen instruction
		mov ch,16	;start row
		mov cl,48	;start col
		mov dh,24	;end of row
		mov dl,79	;end of col
		int 10h		;BIOS interrupt
		mov byte[cor],magenta
		call draw_GUI
	
		mov word[middle_y],125
		mov bx, intensidade_fir
		call draw_image_hist
	popa
	ret

draw_histogram_fir2:
	; Draw --> histogram 2
	pusha
		mov ax,0600h	;clear screen instruction
		mov ch,16	;start row
		mov cl,48	;start col
		mov dh,24	;end of row
		mov dl,79	;end of col
		int 10h		;BIOS interrupt
		mov byte[cor],preto
		call draw_GUI
	
		mov word[middle_y],125
		mov bx, intensidade_fir
		call draw_image_hist
	popa
	ret

draw_histogram_fir3:
	; Draw --> histogram 2

	pusha
		mov ax,0600h	;clear screen instruction
		mov ch,16	;start row
		mov cl,48	;start col
		mov dh,24	;end of row
		mov dl,79	;end of col
		int 10h		;BIOS interrupt
		mov byte[cor],preto
		call draw_GUI

		mov word[middle_y],125
		mov bx, intensidade_fir
		call draw_image_hist
	popa

	ret

draw_histograms:
	; Draw --> histogram 1

	pusha
		mov ax,0600h	;clear screen instruction
		mov ch,1	;start row
		mov cl,48	;start col
		mov dh,12	;end of row
		mov dl,79	;end of col
		int 10h		;BIOS interrupt
		mov byte[cor],preto
		call draw_GUI

		mov word[middle_y],335
		mov bx, intensidade_plot
		call draw_image_hist
	popa

	ret

;_____________________________________________________________________________
;   Function to print string on UI
;
; 	the user give string to pirnt on bx, and collum on dl and line on dh
;-->
print_string:
	call	cursor
	mov     al,[bx]
	cmp 	al, 0x00      ; verify if the caracter is null
	call	caracter
	inc     bx			;next caracter
	inc		dl			;next columm
	mov     al,[bx]
	cmp 	al, 0x00       ; verify if the caracter is null
	jne		print_string
	ret
print_string_word_bl:
	call	cursor
	mov     al,bl
	call	caracter
	ret
print_string_word_bh:
	call	cursor
	mov     al,bh
	call	caracter
	ret
;_____________________________________________________________________________


;_____________________________________________________________________________
;Exit function
	exit_service:
		mov ax, 3 ;Clear screen
		int 10h
		mov ah,0Ah
		int 21h
		mov ax,4c00h
		int 21h
;_____________________________________________________________________________



;_____________________________________________________________________________
;---Init Function to X---
;Inputs - word[x], word[y] with axis x,y coordenate
;Adjustments - cx scale for plot_xy
;Output - draw X in x,y with a dot in the middle
plotX:
	pusha
	mov ax, word[y]
	mov cx,1 ; Adjustment<------>Scale for plot_xy
	mul cx
	mov word[y],ax
	; Transform coordenates of y to plot_xy
	mov cx, word[middle_y]
	add word[y],cx
	; init of line bottom left
	push word[x] 
	push word[y]
	sub word[x],3
	sub word[y],3
	mov ax,0
	mov bx,0
	loop_plot_1:
		mov byte[cor],magenta
		add word[x],1
		add word[y],1
		push word[x] 
		push word[y]
		call plot_xy
		inc bx
		cmp bx,5
		jne loop_plot_1
	pop word[y]
	pop word[x]
	; init of line top left
	push word[x] 
	push word[y]
	sub word[x],3
	add word[y],3
	mov ax,0
	mov bx,0
	loop_plot_2:
		mov byte[cor],magenta
		add word[x],1
		sub word[y],1
		push word[x] 
		push word[y]
		call plot_xy
		inc bx
		cmp bx,5
		jne loop_plot_2
	pop word[y]
	pop word[x]

	mov byte[cor],branco_intenso
	push word[x]
	push word[y]
	call plot_xy
	popa
	ret
;---End Function to X---
;_____________________________________________________________________________



;_____________________________________________________________________________



;_____________________________________________________________________________
; Function to read file
; input - file already open
; output - buffer_str
read_byte:
	pusha	; push all content registers in order AX, CX, DX, BX, SP, BP, SI, and DI
	mov ah, 3Fh   ; Read option
	mov bx, [file_handle]                 
	mov cx, 1 ; Specify one byte to read
	mov dx, buffer_str
	int 21h
	jc Error_Byte ; jump if carry flag is on
	popa	; pop all content registers in order DI,SI, BP, SP, BX, DX, CX, and AX
	ret
	Error_Byte:
		jmp exit_service
;_____________________________________________________________________________

;_____________________________________________________________________________
; Function to convert string to int
; input - byte[buffer_str]
; output - number with most significant bit as signal
string2int:
	pusha	; push all content registers in order AX, CX, DX, BX, SP, BP, SI, and DI
	mov cl, byte[buffer_str]
	cmp cl,30h ; number 0 in ascii
	jb not_number
	cmp cl,39h  ; number 9 in ascii
	ja not_number
	;is_number
	popa	; pop all content registers in order DI,SI, BP, SP, BX, DX, CX, and AX
	mov cl, byte[buffer_str]
	mov ch, 00h ;+(0) signal in the most significant bit
	ret
	not_number:
		cmp cl,0x2d ; minus signal
		je signal_label
		;not_signal and not number
		popa	; pop all content registers in order DI,SI, BP, SP, BX, DX, CX, and AX
		mov cx, 0000h;
		ret
	ret
	signal_label:
		popa	; pop all content registers in order DI,SI, BP, SP, BX, DX, CX, and AX
		mov cl, byte[buffer_str]
		mov ch, 80h ;-(1) signal in the most significant bit
		ret
	ret

;_____________________________________________________________________________


;_____________________________________________________________________________
; Function to read file
read_all:
	pusha	; push all content registers in order AX, CX, DX, BX, SP, BP, SI, and DI
	;____________OPEN____________
	mov ah,3Dh ; Function 3Dh: open file: interrupt 21h
	mov al,0x00 ; bit 0-2: 000 = read only bit 4-6: 100 = deny none
	mov dx, file_name ;to get return
	int 21h ;Call DOS service
	mov [file_handle], ax
	;jc Error_Open; jmp if flag Carry is on - error!

	pusha
	mov bx,16
	empty_intensidade0:
		mov byte[intensidade_plot+bx],0
		dec bx
		jnz empty_intensidade0
	popa

	;____________READ____________
	loop_init:
		mov bx,-1
		mov word[number_of_signals],299 ;number of signals uint8 to read (not 1)
		mov ax,0
		mov dx,0
		jmp loop_start
	loop_read:
		loop_start:
			inc bx
			call read_byte
			mov cl, byte[buffer_str]
			call write_buffer
			cmp cl,00h ;0a break line ascii
			je end_loop_read ;if char is breakline
			cmp cl,0ah ;0a break line ascii
			jne loop_read ;if char is breakline
	; return to loop read
	inc ax
	cmp ax,word[number_of_signals]
	jne loop_read
	end_loop_read:
	; bx is the size of my buffer
	;____________PROCESS THE READ____________
	loop_init_process:
		push dx
		mov dx,bx
		mov bx,buffer_signal_process
		mov word[index_l],bx
		mov bx,0 ;index
		mov word[case],0000h
		mov word[number],0000h
		mov cx,0
		mov word[x],75
	loop_read_process:
		;call write_break
		cmp bx,dx
		je near end_loop_read_process ;if end buffer size

		mov ch,0
		mov cl, byte[buffer_signal+bx]

		;pusha
		;add cl,30h
		;mov bx, cx
		;mov     	dh,15			;line 0-29
		;mov     	dl,40			;column 0-79
		;call print_string_word_bl
		;popa

		cmp cl,0ah ;0a break line ascii
		jne else_0ah
			push ax
			push bx
			push cx
			;if char is breakline
			
			mov ax, word[number]
			mov cx, word[signal]
			mul cx
			
			;plot X
			;----------
			;mov word[y],ax
			;call plotX
			;add word[x],1
			;----------
			mov bx,word[index_l]
			mov [bx],ax ;add null to the end of the number
			add bx,2
			mov word[index_l],bx

			pop cx
			pop bx
			pop ax

			mov word[case],0x0000
			inc bx
			jmp loop_read_process

			else_0ah:

			cmp cl,0dh ;0a break line ascii
			jne else_0dh ;if char is breakline
			mov word[case],0x0000
			inc bx
			jmp loop_read_process
		else_0dh:

		cmp cl,00h ;0a break line ascii
		jne else_00h ;if char is breakline
		inc bx
		jmp end_loop_read_process
		else_00h:

		; Convert string to int number
		; here the char is not break line and not retorno de carro
		cmp word[case],0x0000
		jne else_case_0 
		;if case 0
			cmp cl,2dh 
			jne else_2dh
			;if - signal
				mov word[signal],-1
				mov word[case],1
				inc bx
				mov word[case],0x0001
				jmp loop_read_process
			else_2dh: ;else - signal
				mov word[signal],1
				mov word[case],0x0001
				jmp loop_read_process
		else_case_0:
		cmp word[case],0x0001
		jne else_case_1 ;if case 1
			mov ax, 1
			mov ch,0
			mov cl, byte[buffer_signal+bx]
			sub cl,30h
			mul cx
			mov word[number],ax
			mov word[case],0x0010
			inc bx
			jmp loop_read_process
		else_case_1:
		cmp word[case],0x0010
		jne else_case_10 ;if case 10
			mov ax,10
			mul word[number]
			mov word[number],ax

			mov ax,1
			mov ch,0
			mov cl, byte[buffer_signal+bx]
			sub cl,30h
			mul cx
			add ax,word[number]
			mov word[number],ax
			mov word[case],0x0100
			inc bx
			jmp loop_read_process
		else_case_10:
		cmp word[case],0x0100
		jne else_case_100 ;if case 100
			mov ax,10
			mul word[number]
			mov word[number],ax

			mov ax,1
			mov ch,0
			mov cl, byte[buffer_signal+bx]
			sub cl,30h
			mul cx
			add ax,word[number]
			mov word[number],ax
			inc bx
			jmp loop_read_process
		else_case_100:
		inc bx
		jmp loop_read_process

	end_loop_read_process:
		mov word[index_process_read],dx
		pop dx
	;call string2number
	
	;mov word[number],0xfff6
	;mov word[number],0x000A
	;mov ax, -1
	;mul word[number]
	;mov bx,ax

	mov bx,-2
	mov word[x],75
	mov dx,0
	loop_plot_sinal_top:
		inc dx
		add bx,2
		mov ax,word[buffer_signal_process+bx]
	
		pusha
		mov bx,-1
		mov dx,-127
		his0:
			add dx,16
			inc bx
			cmp ax,dx
			jns his0
			add byte[intensidade_plot+bx],15
		popa

		mov word[y],ax
		add word[x],1
		mov word[middle_y],335
		call plotX
		cmp dx,299
		jb loop_plot_sinal_top
	end_loop_plot_sinal_top:



	;mov word[y],-10
	;mov word[x],100
	;call plotX

	print_buffer:
		;mov bx, word[number]
		;mov     	dh,21			;line 0-29
		;mov     	dl,40			;column 0-79
		;call print_string_word_bh
		;mov bx, word[number]
		;mov     	dh,21			;line 0-29
		;mov     	dl,41			;column 0-79
		;call print_string_word_bl
		;mov bx, buffer_signal
		;mov     	dh,22			;line 0-29
		;mov     	dl,40			;column 0-79
		;call print_string

	;mov bx,-1
	;mov word[x],100
	;mov ax,word[number]
	;mov word[y],ax
	;call plotX
	;add word[x],1

	;____________CLOSE____________
	mov ah,3Eh ; close file
	int 21h

	popa	; pop all content registers in order DI,SI, BP, SP, BX, DX, CX, and AX
	ret
	Error_Open:
		jmp exit_service
	write_buffer:
		;call string2int
		mov byte[buffer_signal+bx],cl
		ret
	write_break:
		mov byte[buffer_signal+bx],5fh
		ret

index_l dw 0x0000


;_____________________________________________________________________________
;
;   function draw histogram graphic from image or LBP image 
;
; take address buffer from that user give on bx
; (can be image histogram or image LBP histogram)
; and follow all positions color and display this information 
; like a graphic
;-->
	draw_image_hist:
	;push all
		pushf
		push ax
		push bx
		push cx
		push dx
		push si
		push di
		push bp
	;function body
		mov cx, 15
		mov dx, 400
		mov si, 1
		hist_loop_image:
			mov al, byte[fixed_scale_vector + si] 
			mov byte[cor], al
			;plot pixel
				push cx
				mov cx, 15
				repeat_lines_to_large_hist:
					push bx
					mov		ax, dx
					push		ax
					mov ax,word[middle_y]
					sub ax,5
					push		ax
					mov		ax, dx
					push		ax

					mov		ah, 0
					mov al, byte[bx]
					mov bh, 0
					mov bl, 3
					div bl
					mov		ah, 0

					mov bx,word[middle_y]
					add ax,bx
					push		ax
					call		line
					add dx, 1
					pop bx  
					loop repeat_lines_to_large_hist
				pop cx
				add bx, 1
				inc si
			loop hist_loop_image
	;pop all
		pop	bp
		pop	di
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		popf
		ret

;_____________________________________________________________________________

;***************************************************************************

;
;   fun��o cursor
;
; dh = linha (0-29) e  dl=coluna  (0-79)
cursor:
		pushf
		push 		ax
		push 		bx
		push		cx
		push		dx
		push		si
		push		di
		push		bp
		mov     	ah,2
		mov     	bh,0
		int     	10h
		pop		bp
		pop		di
		pop		si
		pop		dx
		pop		cx
		pop		bx
		pop		ax
		popf
		ret
;_____________________________________________________________________________
;
;   fun��o caracter escrito na posi��o do cursor
;
; al= caracter a ser escrito
; cor definida na variavel cor
caracter:
		pushf
		push 		ax
		push 		bx
		push		cx
		push		dx
		push		si
		push		di
		push		bp
    		mov     	ah,9
    		mov     	bh,0
    		mov     	cx,1
   		mov     	bl,[cor]
    		int     	10h
		pop		bp
		pop		di
		pop		si
		pop		dx
		pop		cx
		pop		bx
		pop		ax
		popf
		ret
;_____________________________________________________________________________
;
;   fun��o plot_xy
;
; push x; push y; call plot_xy;  (x<639, y<479)
; cor definida na variavel cor
plot_xy:
		push		bp
		mov		bp,sp
		pushf
		push 		ax
		push 		bx
		push		cx
		push		dx
		push		si
		push		di
	    mov     	ah,0ch
	    mov     	al,[cor]
	    mov     	bh,0
	    mov     	dx,479
		sub		dx,[bp+4]
	    mov     	cx,[bp+6]
	    int     	10h
		pop		di
		pop		si
		pop		dx
		pop		cx
		pop		bx
		pop		ax
		popf
		pop		bp
		ret		4
;_____________________________________________________________________________
;    fun��o circle
;	 push xc; push yc; push r; call circle;  (xc+r<639,yc+r<479)e(xc-r>0,yc-r>0)
; cor definida na variavel cor
circle:
	push 	bp
	mov	 	bp,sp
	pushf                        ;coloca os flags na pilha
	push 	ax
	push 	bx
	push	cx
	push	dx
	push	si
	push	di
	
	mov		ax,[bp+8]    ; resgata xc
	mov		bx,[bp+6]    ; resgata yc
	mov		cx,[bp+4]    ; resgata r
	
	mov 	dx,bx	
	add		dx,cx       ;ponto extremo superior
	push    ax			
	push	dx
	call plot_xy
	
	mov		dx,bx
	sub		dx,cx       ;ponto extremo inferior
	push    ax			
	push	dx
	call plot_xy
	
	mov 	dx,ax	
	add		dx,cx       ;ponto extremo direita
	push    dx			
	push	bx
	call plot_xy
	
	mov		dx,ax
	sub		dx,cx       ;ponto extremo esquerda
	push    dx			
	push	bx
	call plot_xy
		
	mov		di,cx
	sub		di,1	 ;di=r-1
	mov		dx,0  	;dx ser� a vari�vel x. cx � a variavel y
	
;aqui em cima a l�gica foi invertida, 1-r => r-1
;e as compara��es passaram a ser jl => jg, assim garante 
;valores positivos para d

stay:				;loop
	mov		si,di
	cmp		si,0
	jg		inf       ;caso d for menor que 0, seleciona pixel superior (n�o  salta)
	mov		si,dx		;o jl � importante porque trata-se de conta com sinal
	sal		si,1		;multiplica por doi (shift arithmetic left)
	add		si,3
	add		di,si     ;nesse ponto d=d+2*dx+3
	inc		dx		;incrementa dx
	jmp		plotar
inf:	
	mov		si,dx
	sub		si,cx  		;faz x - y (dx-cx), e salva em di 
	sal		si,1
	add		si,5
	add		di,si		;nesse ponto d=d+2*(dx-cx)+5
	inc		dx		;incrementa x (dx)
	dec		cx		;decrementa y (cx)
	
plotar:	
	mov		si,dx
	add		si,ax
	push    si			;coloca a abcisa x+xc na pilha
	mov		si,cx
	add		si,bx
	push    si			;coloca a ordenada y+yc na pilha
	call plot_xy		;toma conta do segundo octante
	mov		si,ax
	add		si,dx
	push    si			;coloca a abcisa xc+x na pilha
	mov		si,bx
	sub		si,cx
	push    si			;coloca a ordenada yc-y na pilha
	call plot_xy		;toma conta do s�timo octante
	mov		si,ax
	add		si,cx
	push    si			;coloca a abcisa xc+y na pilha
	mov		si,bx
	add		si,dx
	push    si			;coloca a ordenada yc+x na pilha
	call plot_xy		;toma conta do segundo octante
	mov		si,ax
	add		si,cx
	push    si			;coloca a abcisa xc+y na pilha
	mov		si,bx
	sub		si,dx
	push    si			;coloca a ordenada yc-x na pilha
	call plot_xy		;toma conta do oitavo octante
	mov		si,ax
	sub		si,dx
	push    si			;coloca a abcisa xc-x na pilha
	mov		si,bx
	add		si,cx
	push    si			;coloca a ordenada yc+y na pilha
	call plot_xy		;toma conta do terceiro octante
	mov		si,ax
	sub		si,dx
	push    si			;coloca a abcisa xc-x na pilha
	mov		si,bx
	sub		si,cx
	push    si			;coloca a ordenada yc-y na pilha
	call plot_xy		;toma conta do sexto octante
	mov		si,ax
	sub		si,cx
	push    si			;coloca a abcisa xc-y na pilha
	mov		si,bx
	sub		si,dx
	push    si			;coloca a ordenada yc-x na pilha
	call plot_xy		;toma conta do quinto octante
	mov		si,ax
	sub		si,cx
	push    si			;coloca a abcisa xc-y na pilha
	mov		si,bx
	add		si,dx
	push    si			;coloca a ordenada yc-x na pilha
	call plot_xy		;toma conta do quarto octante
	
	cmp		cx,dx
	jb		fim_circle  ;se cx (y) est� abaixo de dx (x), termina     
	jmp		stay		;se cx (y) est� acima de dx (x), continua no loop
	
	
fim_circle:
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	popf
	pop		bp
	ret		6
;-----------------------------------------------------------------------------
;    fun��o full_circle
;	 push xc; push yc; push r; call full_circle;  (xc+r<639,yc+r<479)e(xc-r>0,yc-r>0)
; cor definida na variavel cor					  
full_circle:
	push 	bp
	mov	 	bp,sp
	pushf                        ;coloca os flags na pilha
	push 	ax
	push 	bx
	push	cx
	push	dx
	push	si
	push	di

	mov		ax,[bp+8]    ; resgata xc
	mov		bx,[bp+6]    ; resgata yc
	mov		cx,[bp+4]    ; resgata r
	
	mov		si,bx
	sub		si,cx
	push    ax			;coloca xc na pilha			
	push	si			;coloca yc-r na pilha
	mov		si,bx
	add		si,cx
	push	ax		;coloca xc na pilha
	push	si		;coloca yc+r na pilha
	call line
	
		
	mov		di,cx
	sub		di,1	 ;di=r-1
	mov		dx,0  	;dx ser� a vari�vel x. cx � a variavel y
	
;aqui em cima a l�gica foi invertida, 1-r => r-1
;e as compara��es passaram a ser jl => jg, assim garante 
;valores positivos para d

stay_full:				;loop
	mov		si,di
	cmp		si,0
	jg		inf_full       ;caso d for menor que 0, seleciona pixel superior (n�o  salta)
	mov		si,dx		;o jl � importante porque trata-se de conta com sinal
	sal		si,1		;multiplica por doi (shift arithmetic left)
	add		si,3
	add		di,si     ;nesse ponto d=d+2*dx+3
	inc		dx		;incrementa dx
	jmp		plotar_full
inf_full:	
	mov		si,dx
	sub		si,cx  		;faz x - y (dx-cx), e salva em di 
	sal		si,1
	add		si,5
	add		di,si		;nesse ponto d=d+2*(dx-cx)+5
	inc		dx		;incrementa x (dx)
	dec		cx		;decrementa y (cx)
	
plotar_full:	
	mov		si,ax
	add		si,cx
	push	si		;coloca a abcisa y+xc na pilha			
	mov		si,bx
	sub		si,dx
	push    si		;coloca a ordenada yc-x na pilha
	mov		si,ax
	add		si,cx
	push	si		;coloca a abcisa y+xc na pilha	
	mov		si,bx
	add		si,dx
	push    si		;coloca a ordenada yc+x na pilha	
	call 	line
	
	mov		si,ax
	add		si,dx
	push	si		;coloca a abcisa xc+x na pilha			
	mov		si,bx
	sub		si,cx
	push    si		;coloca a ordenada yc-y na pilha
	mov		si,ax
	add		si,dx
	push	si		;coloca a abcisa xc+x na pilha	
	mov		si,bx
	add		si,cx
	push    si		;coloca a ordenada yc+y na pilha	
	call	line
	
	mov		si,ax
	sub		si,dx
	push	si		;coloca a abcisa xc-x na pilha			
	mov		si,bx
	sub		si,cx
	push    si		;coloca a ordenada yc-y na pilha
	mov		si,ax
	sub		si,dx
	push	si		;coloca a abcisa xc-x na pilha	
	mov		si,bx
	add		si,cx
	push    si		;coloca a ordenada yc+y na pilha	
	call	line
	
	mov		si,ax
	sub		si,cx
	push	si		;coloca a abcisa xc-y na pilha			
	mov		si,bx
	sub		si,dx
	push    si		;coloca a ordenada yc-x na pilha
	mov		si,ax
	sub		si,cx
	push	si		;coloca a abcisa xc-y na pilha	
	mov		si,bx
	add		si,dx
	push    si		;coloca a ordenada yc+x na pilha	
	call	line
	
	cmp		cx,dx
	jb		fim_full_circle  ;se cx (y) est� abaixo de dx (x), termina     
	jmp		stay_full		;se cx (y) est� acima de dx (x), continua no loop
	
	
fim_full_circle:
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	popf
	pop		bp
	ret		6
;-----------------------------------------------------------------------------
;
;   fun��o line
;
; push x1; push y1; push x2; push y2; call line;  (x<639, y<479)
line:
		push		bp
		mov		bp,sp
		pushf                        ;coloca os flags na pilha
		push 		ax
		push 		bx
		push		cx
		push		dx
		push		si
		push		di
		mov		ax,[bp+10]   ; resgata os valores das coordenadas
		mov		bx,[bp+8]    ; resgata os valores das coordenadas
		mov		cx,[bp+6]    ; resgata os valores das coordenadas
		mov		dx,[bp+4]    ; resgata os valores das coordenadas
		cmp		ax,cx
		je		line2
		jb		line1
		xchg		ax,cx
		xchg		bx,dx
		jmp		line1
line2:		; deltax=0
		cmp		bx,dx  ;subtrai dx de bx
		jb		line3
		xchg		bx,dx        ;troca os valores de bx e dx entre eles
line3:	; dx > bx
		push		ax
		push		bx
		call 		plot_xy
		cmp		bx,dx
		jne		line31
		jmp		fim_line
line31:		inc		bx
		jmp		line3
;deltax <>0
line1:
; comparar m�dulos de deltax e deltay sabendo que cx>ax
	; cx > ax
		push		cx
		sub		cx,ax
		mov		[deltax],cx
		pop		cx
		push		dx
		sub		dx,bx
		ja		line32
		neg		dx
line32:		
		mov		[deltay],dx
		pop		dx

		push		ax
		mov		ax,[deltax]
		cmp		ax,[deltay]
		pop		ax
		jb		line5

	; cx > ax e deltax>deltay
		push		cx
		sub		cx,ax
		mov		[deltax],cx
		pop		cx
		push		dx
		sub		dx,bx
		mov		[deltay],dx
		pop		dx

		mov		si,ax
line4:
		push		ax
		push		dx
		push		si
		sub		si,ax	;(x-x1)
		mov		ax,[deltay]
		imul		si
		mov		si,[deltax]		;arredondar
		shr		si,1
; se numerador (DX)>0 soma se <0 subtrai
		cmp		dx,0
		jl		ar1
		add		ax,si
		adc		dx,0
		jmp		arc1
ar1:		sub		ax,si
		sbb		dx,0
arc1:
		idiv		word [deltax]
		add		ax,bx
		pop		si
		push		si
		push		ax
		call		plot_xy
		pop		dx
		pop		ax
		cmp		si,cx
		je		fim_line
		inc		si
		jmp		line4

line5:		cmp		bx,dx
		jb 		line7
		xchg		ax,cx
		xchg		bx,dx
line7:
		push		cx
		sub		cx,ax
		mov		[deltax],cx
		pop		cx
		push		dx
		sub		dx,bx
		mov		[deltay],dx
		pop		dx



		mov		si,bx
line6:
		push		dx
		push		si
		push		ax
		sub		si,bx	;(y-y1)
		mov		ax,[deltax]
		imul		si
		mov		si,[deltay]		;arredondar
		shr		si,1
; se numerador (DX)>0 soma se <0 subtrai
		cmp		dx,0
		jl		ar2
		add		ax,si
		adc		dx,0
		jmp		arc2
ar2:		sub		ax,si
		sbb		dx,0
arc2:
		idiv		word [deltay]
		mov		di,ax
		pop		ax
		add		di,ax
		pop		si
		push		di
		push		si
		call		plot_xy
		pop		dx
		cmp		si,dx
		je		fim_line
		inc		si
		jmp		line6

fim_line:
		pop		di
		pop		si
		pop		dx
		pop		cx
		pop		bx
		pop		ax
		popf
		pop		bp
		ret		8
;*******************************************************************
segment data



;--Init Strings GUI--
txt_abrir   	db  		'Abrir',0
txt_fir1     db      'FIR1', 0
txt_fir2        db      'FIR2', 0 
txt_fir3        db      'FIR3', 0
txt_histogramas       db      'Hist.', 0
txt_sair        db      'Sair', 0
txt_nome       db      'Lorenzo Piccoli', 0
txt_turma        db      '2024-01 ', 0
string_current_speed        db      '1', 0
string_exit     db '>>> Voce saiu do jogo!', 0
string_student_win     db '>>> Nice!!! Voce venceu o computador.', 0
string_machine_win     db '>>> Boa sorte na proxima :/ O computador venceu.', 0
;--End Strings GUI--

;--Init Strings FILE--
file_name		db		"sinalep1.txt", 0
file_handle		dw	0
file_handle_suscessful db "suscessfull sinal.txt", 0
file_handle_error db "error sinal.txt", 0
;--End Strings FILE--

buffer_str times 512 db 0
buffer_signal times  6000  db 0
buffer_signal_process times  6000  dw 0
buffer_signal_fir1 times  6000  dw 0
buffer_signal_fir2 times  6000  dw 0
buffer_signal_fir3 times  6000  dw 0


; x and y coordenates to plot X
x dw 0
y dw 0

; for read process string to number
signal dw 1
d1 dw 0
d2 dw 0
case dw 0
number dw 0
size_anterior dw 0
size dw 0

middle_y dw 0

index_process_read dw 0000

last_hist dw 0

fixed_scale_vector db 0, 8, 1, 9, 2, 10, 3, 11, 4, 12, 5, 13, 6, 14, 7,15

intensidade_fir times 20 db 0
intensidade_plot times 20 db 0

; for read text
number_of_signals dw 0

str_name db "o error",0

cor		db		branco_intenso

;	I R G B COR
;	0 0 0 0 preto
;	0 0 0 1 azul
;	0 0 1 0 verde
;	0 0 1 1 cyan
;	0 1 0 0 vermelho
;	0 1 0 1 magenta
;	0 1 1 0 marrom
;	0 1 1 1 branco
;	1 0 0 0 cinza
;	1 0 0 1 azul claro
;	1 0 1 0 verde claro
;	1 0 1 1 cyan claro
;	1 1 0 0 rosa
;	1 1 0 1 magenta claro
;	1 1 1 0 amarelo
;	1 1 1 1 branco intenso

preto		equ		0
azul		equ		1
verde		equ		2
cyan		equ		3
vermelho	equ		4
magenta		equ		5
marrom		equ		6
branco		equ		7
cinza		equ		8
azul_claro	equ		9
verde_claro	equ		10
cyan_claro	equ		11
rosa		equ		12
magenta_claro	equ		13
amarelo		equ		14
branco_intenso	equ		15

modo_anterior	db		0
linha   	dw  		0
coluna  	dw  		0
deltax		dw		0
deltay		dw		0	
mens    	db  		'Funcao Grafica'
;*************************************************************************
segment stack stack
    		resb 		512
stacktop: