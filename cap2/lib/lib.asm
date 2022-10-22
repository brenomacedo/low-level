global _start

section .data
str: db "hello world", 10, 0
result: db 0, 10
divisor: dq 10
number: db "123456789", 0
neg_number: db "-123456789", 0
section .text

; recebe o codigo de erro em rax e executa a chamada de sistema
; exit
exit:
	mov rax, 60
	syscall

; recebe o ponteiro para a string em rsi e retorna o tamanho
; da string no registrador rdx
str_len:
	mov rdx, 0
.loop:
	cmp byte[rsi], 0
	je .end
	inc rsi
	inc rdx
	jmp .loop

.end:
	ret

; recebe o ponteiro para a string em rsi
; e escreve em stdout
print_string:
	push rsi
	call str_len
	pop rsi
	mov rax, 1
	mov rdi, 1
	syscall
	ret

; recebe o codigo ascii de um caractere em sil
; e o escreve em stdout
print_char:
	push rbp
	mov rbp, rsp
	sub rsp, 1

	mov [rbp - 1], sil
	lea rsi, [rbp - 1]
	mov rdi, 1
	mov rax, 1
	mov rdx, 1
	syscall

	add rsp, 1
	pop rbp
	ret

; escreve em stdout uma quebra de linha
print_newline:
	mov rsi, 10
	call print_char
	ret

; recebe um unsigned int em rsi e escreve
; em stdout
print_uint:
	push rbp
	mov rbp, rsp

	mov rcx, 0
	mov rax, rsi

.loop:
	mov rdx, 0
	div qword[divisor]
	add rdx, 48
	sub rsp, 1
	inc rcx

	push rbp
	sub rbp, rcx
	mov [rbp], dl
	pop rbp

	cmp rax, 0
	je .end
	jmp .loop

.end:
	push rbx
	mov rbx, rcx

.initprint:
	mov rax, 1

	push rbp
	sub rbp, rbx
	mov rsi, rbp
	pop rbp

	mov rdi, 1
	mov rdx, 1

	push rcx
	syscall
	pop rcx
	
	cmp rbx, 1
	je .endprint
	dec rbx
	jmp .initprint

.endprint:
	pop rbx
	add rsp, rcx	
	pop rbp
	ret

print_int:
	push rbp
	mov rbp, rsp

	sub rsp, 1
	mov byte[rbp - 1], 45

	test rsi, rsi
	jns .print_u
	neg rsi

	push rsi
	lea rsi, [rbp - 1]
	mov rdi, 1
	mov rax, 1
	mov rdx, 1
	syscall
	pop rsi
	
.print_u:
	call print_uint

	add rsp, 1
	pop rbp
	ret

; limpar o buffer (deve ser executado)
; quando se tem certeza que o buffer possui
; ao menos um caractere
clear_buffer:
	push rbp
	mov rbp, rsp
	sub rsp, 1

.loop:
	mov rax, 0
	mov rdi, 0
	lea rsi, [rbp - 1]
	mov rdx, 1
	syscall

	mov cl, [rbp - 1]
	cmp cl, 10
	jne .loop
	
	add rsp, 1
	pop rbp
	ret

; lê um caractere do stdin e devolve seu ascii no cl
get_char:
	push rbp
	mov rbp, rsp
	sub rsp, 1
	
	mov rax, 0
	mov rdi, 0
	mov rdx, 1
	lea rsi, [rbp - 1]
	syscall

	mov cl, [rbp - 1]

	add rsp, 1
	pop rbp
	ret

; recebe um tamanho de buffer em rdx e o endereço em rsi
; e le uma string de stdin e o poe no buffer
get_word:
	push rbx
	
	mov rbx, 0
	dec rdx
.loop:
	push rdx
	push rsi
	call get_char
	pop rsi
	pop rdx

	cmp rbx, rdx
	jg .greater

	push rsi
	add rsi, rbx

	cmp cl, 10;
	je .end_of_string

	mov byte[rsi], cl
	pop rsi
	inc rbx

	jmp .loop

.end_of_string:
	mov byte[rsi], 0
	pop rsi
	jmp .end
	
.greater:
	mov byte[rsi], 0
	jmp .end			

.end:
	pop rbx
	ret

parse_uint:
	mov rax, 0
	mov rdx, 0

.loop:
	mov cl, [rsi]
	test cl, cl
	jz .end

	sub cl, 48

	push rdx
	mul qword[divisor]
	pop rdx

	add rax, rcx
	inc rsi
	inc rdx
	jmp .loop

.end:
	ret	

parse_int:
	cmp byte[rsi], '-'
	je .negative
	call parse_uint
	ret
.negative:
	inc rsi
	call parse_uint
	neg rax
	inc rdx
	ret

str_cmp:
.loop:
	mov cl, [rsi]
	cmp cl, [rdi]
	jne .not_equal
	inc rsi
	inc rdi
	test cl, cl
	jz .equal
	jmp .loop

.equal:
	mov rax, 1
	ret
.not_equal:
	mov rax, 0
	ret

; recebe uma string em rsi e um buffer em rdi
; e o tamanho do buffer em rdx, copia
; a string para o buffer
str_copy:
	push rdx
	push rdi
	push rsi
	call str_len
	
	mov rax, rdx
	pop rsi
	pop rdi
	pop rdx

	inc rax
	cmp rdx, rax
	jl .end
	
.loop:
	cmp rax, 0
	je .end
	mov cl, [rsi]
	mov [rdi], cl
	inc rsi
	inc rdi
	dec rax
	jmp .loop

.end:
	ret

_start:
	mov rdx, 10
	mov rsi, number
	mov rdi, neg_number
	call str_copy

	mov rsi, neg_number
	call print_string

	xor rdi, rdi
	call exit

