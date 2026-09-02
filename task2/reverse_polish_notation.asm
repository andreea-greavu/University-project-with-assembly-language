
section .note.GNU-stack
section .data
	;pt citire
	citire db "%s", 0
	;pt afisare
	afisare db "%ld", 10, 0
section .bss
	;locul unde o sa mi puna scanf
	vect resb 256
section .text
extern atol
extern scanf
extern printf
global reverse_polish_notation

reverse_polish_notation:
	push rbp
	mov rbp, rsp
	xor rax, rax
	
	;salvez pe stiva
	push rbx
parcurgere:
	;aliniez
	mov rbx, rsp
	;stiva
	and rsp, -16
	;adresa caracterului citit
	lea rdi, [citire]
	;adresa din vector
	lea rsi, [vect]
	xor eax, eax
	call scanf
	mov rsp, rbx
	;daca am citit ultimul caracter
	cmp eax, 0
	jle final
	;pun iarasi adresa ca sa citesc din el
	lea rsi, [vect]
	;iau doar primul byte care are prima litera
	mov cl, byte[rsi]
	;verific ce operatie am de facut
	cmp cl, '+'
	je plus
	cmp cl, '-'
	je minus
	cmp cl, '*'
	je inmultire
	cmp cl, '/'
	je impartire
	;adresa la ce am citit
	lea rdi, [vect]
	;fac din string numar
	call atol
	;pun pe stiva nr
	push rax
	;citesc in continuare
	jmp parcurgere
	;iau fiecare operatie in parte
plus:
	;iau al doilea nr
	pop rcx
	;iau primul
	pop rax
	;fac adunarea
	add rax, rcx
	;pun rezultatul
	push rax
	;citesc urmatorul
	jmp parcurgere
minus:
	;iau al doilea nr
	pop rcx
	;iau primul
	pop rax
	;fac scaderea
	sub rax, rcx
	;pun rezultatul
	push rax
	;citesc urmatorul
	jmp parcurgere
inmultire:
	;iau al doilea nr
	pop rcx
	;iau primul
	pop rax
	;fac inmultirea
	imul rax, rcx
	;pun rezultatul
	push rax
	;citesc urmatorul
	jmp parcurgere
impartire:
	;iau al doilea nr
	pop rcx
	;iau primul
	pop rax
	;pun 0 in rdx pt impartire
	xor rdx, rdx
	;impart
	div rcx
	;pun rezultatul
	push rax
	;citesc urmatorul
	jmp parcurgere
final:
	;extrag ult element care are rezultatul
	pop rsi
	;aliniez
	mov rbx, rsp
	;stiva
	and rsp, -16
	mov rdi, afisare
	xor rax, rax
	call printf
	mov rsp, rbx
	pop rbx
	leave
	ret
