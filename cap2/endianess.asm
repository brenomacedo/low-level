section .data

newline_char: db 10
codes: db '0123456789abcdef'

section .text
global _start

print_newline:
	mov rax, 1 ; identificador do syscall 'write'
	mov rdi, 1 ; descritor do arquivo stdout
	mov rsi, newline_char ; local de onde os dados são obitdos
	mov rdx, 1 ; a quantidade de bytes a serem escrita
	syscall
	ret

print_hex:
	mov rax, rdi
	mov rdi, 1
	mov rdx, 1
	mov rcx, 64 ; até que ponto estamos deslocando rax?

iterate:
	push rax ; salva o valor inicial de rax
	sub rcx, 4
	sar rax, cl ; desloca para 60, 56, 52, ... 4, 0
		    ; o registrador cl é a menor parte de rcx

	and rax, 0xf ; limpa todos os bits, exceto os quatro menos significativos
	lea rsi, [codes + rax]; obtém o código de caractere de um digito hedxadecimal

	mov rax, 1
	push rcx ; syscall alterará rcx
	syscall ; rax = 1 (31) - o identificador de write
		; rdi = 1 para stdout
		; rsi = o endereço de um caractere

	pop rcx

	pop rax
	test rcx, rcx
	jnz iterate
	
	ret

_start:
	mov rdi, [demo1]
	call print_hex
	call print_newline

	mov rdi, [demo2]
	call print_hex
	call print_newline

	mov rax, 60
	xor rdi, rdi
	syscall






