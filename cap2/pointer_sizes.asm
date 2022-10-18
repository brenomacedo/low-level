section .data
test: dq -1

section .text

mov byte[test], 1 ; 1 byte
mov word[test], 1 ; 2 bytes
mov dword[test], 1 ; 4 bytes
mov qword[test], 1 ; 8 bytes
