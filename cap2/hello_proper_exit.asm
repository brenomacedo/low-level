section .data
message: db 'hello world', 10

section .text
global _start

_start:
	mov rax, 1 ; numero da syscall 'write'
	mov rdi, 1 ; descritor de stdout
	mov rsi, message ; endereco da string
	mov rdx, 14 ; tamanho da string em bytes
	syscall

	mov rax, 60 ; numero da syscall 'exit'
	xor rdi, rdi
	syscall
