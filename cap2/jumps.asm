mov rax, -1
mov rdx, 2
comp rax, rdx

jg location ; jg (jump greater) e jl (jump less) são apenas para comparações com sinal
ja location ; lógica diferente! ja (jump above) é para números sem sinal, seu opost, jb (jumb below)
	    ; também

cmp rax, rdx
je location ; se rax for igual a rdx
jne location ; se rax for diferente de rdx


