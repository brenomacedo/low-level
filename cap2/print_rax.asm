section .data
codes: db '0123456789ABCDEF'

section .text
global _start
_start:
	; número 1122... em formato hexadecimal
	mov rax, 0x1122334455667788
	mov rdi, 1
	mov rdx, 1
	mov rcx, 64
	; cada 4 bits devem ser exibidos como um digito hexadecimal
	; use o deslocamento (shift) e a operação bit a bit AND para isolá-los
	; o resultado é o offset no array 'codes'

.loop:
	push rax
	sub rcx, 4
	; cl é um registrador, a parte menor de rcx
	sar rax, cl
	and rax, 0xf
	
	lea rsi, [codes + rax]
	mov rax, 1

	; syscall deixa rcx e r11 alterados
	push rcx
	syscall
	pop rcx

	pop rax
	; test pode ser usado para um verificação mais
	; rápida do tipo 'é um zero?' consulte a documentaçlao do comando 'test'
	; test realiza um and e atualiza as flags ZF, SF, PF
	test rcx, rcx
	jnz .loop

	mov rax, 60
	xor rdi, rdi
	syscall
