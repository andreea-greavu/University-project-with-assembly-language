
section .note.GNU-stack

section .text

global my_printf
extern putc
extern stdout
my_printf:
	push rbp
	mov rbp, rsp
	xor rax, rax
	
	;salvez pe stiva
	push r9
	push r8
	push rcx
	push rdx
	push rsi
	;pointer la primul lucru din argumente
	mov r12, rsp
	;pointer la prima chestie din functie
	mov rbx, rdi
	;contor ca sa stiu cate argumente am
	xor r15, r15
parcurgere:
	xor edi, edi
	;iau primul caracter
	mov dil, byte[rbx]
	;vad daca am ajuns la final
	cmp dil, 0
	je final
	;vad daca e %
	cmp dil, '%'
	je procent
	;daca nu e doar afisez
	jmp afisare
procent:
	;cresc rbx sa ajung la urmatorul caracter de dupa %
	inc rbx
	;iau urmatoarea chestie
	mov al, byte[rbx]
	;verific mai intai daca am folosit toate cele 5 argumente si trec la stiva sau le iau pe cele din functie
	cmp r15, 5
	jl din_stiva
	;copiez indexul
	mov r14, r15
	;il scad cu 5 ca sa vad unde e
	sub r14, 5
	;iau adresa
	mov r13, [rbp + 16 + r14 * 8]
	jmp din_functie
din_stiva:
	;iau de la stiva salvata
	mov r13, [r12 + r15 * 8]
din_functie:
	;cresc contorul
	inc r15
	;iau cazurile posibile
	cmp al, 'c'
	je c_
	cmp al, 's'
	je s_
	cmp al, 'l'
	je l_
	jmp parcurgere
c_:
	;am doar de afisat un caracter
	mov rdi, r13
	mov rsi, [stdout]
	call putc
	;trec la urm
	inc rbx
	jmp parcurgere
s_:
	;am un sir si parcurg si afisez caracter cu caracter
	mov dil, byte[r13]
	;daca am terminat
	cmp dil, 0
	je finalsir
	mov rsi, [stdout]
	call putc
	;cresc in sir
	inc r13
	jmp s_
finalsir:
	;merg la urmatoarea chestie
	inc rbx
	jmp parcurgere
l_:
	;am un numar
	;mai intai sar de u din lu
	inc rbx
	;iau numarul pe care il am de afisat
	mov rax, r13
	;contor pt cifre
	xor r11, r11
	;iau cifrele impartind nr la 10
	mov r14, 10
cifre:
	xor rdx, rdx
	div r14
	;il fac caracter
	add rdx, '0'
	;pun cifra pe stiva
	push rdx
	;cresc nr de cifre
	inc r11
	;vad daca am terminat
	cmp rax, 0
	jne cifre
afisnr:
	;vad daca am afisat tot
	cmp r11, 0
	je finalnr
	;scot ultima cifra
	pop rdi
	;salvez sa nu se strice
	push r11
	;afisez
	mov rsi, [stdout]
	call putc
	;reiau
	pop r11
	;merg la urm cifra
	dec r11
	jmp afisnr
finalnr:
	;trec la urmatorul lucru
	inc rbx
	jmp parcurgere
afisare:
	mov rsi, [stdout]
	call putc
	inc rbx
	jmp parcurgere
final:
	leave
	ret
