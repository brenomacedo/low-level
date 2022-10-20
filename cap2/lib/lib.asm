global _start

section .data
str: db "hello world", 10, 0
result: db 0, 10
divisor: dq 10
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

; recebe o codigo ascii de um caractere em rsi
; e o escreve em stdout
print_char:
	push rbp
	mov rbp, rsp
	sub rsp, 1

	mov [rbp - 1], rsi
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
	idiv qword[divisor]
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

_start:
	mov rsi, 0
	call print_uint

	xor rdi, rdi
	call exit

