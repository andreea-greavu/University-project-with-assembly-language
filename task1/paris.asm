

section .text

global solve_labyrinth

solve_labyrinth:
	push    rbp
	mov     rbp, rsp
	push    rbx
	push    r12
	push    r13
	push    r14
	push    r15

	mov     r12, rdi
	mov     r13, rsi
	mov     r14, rdx	
	mov     r15, rcx
	mov     rbx, r8
	;pozitia la care suntem adica 0 0
	;linia
	xor r9, r9
	;coloana
	xor r10, r10
	;pointer la 0,0
	mov rdx, [rbx + r9 * 8]
	;punem 1 ca sa stim ca am fost aici
	mov byte [rdx + r10], '1'
parcurgere:
	;il folosesc pe r8 ca un aux
	;nr de linii
	mov r8, r14
	dec r8
	;comparam cu pozitia curenta
	cmp r9, r8
	;daca sunt egale s a terminat
	je final
	;nr de coloane
	mov r8, r15
	dec r8
	;comparam cu pozitia curenta
	cmp r10, r8
	;daca sunt egale am ajuns la final
	je final
	;incercam sa o luam in sus
	;vedem daca suntem pe prima linie
	cmp r9, 0
	;daca suntem inseamna ca n o putem lua in sus
	je jos
	;punem numarul liniei
	mov r11, r9
	;scadem cu 1 si avem linia de deasupra
	dec r11
	;pointer la linia de deasupra
	mov rdx, [rbx + r11 * 8]
	;vedem daca e elementul e 1
	cmp byte [rdx + r10], '1'
	;inseamna ca incercam in jos
	je jos
	;ne ducem cu o linie mai sus
	dec r9
	;luam iarasi celula
	mov rdx, [rbx + r9 * 8]
	;punem 1 ca sa stim ca am fost
	mov byte [rdx + r10], '1'
	;continuam
	jmp parcurgere
jos:
	;iau nr de linie la care suntem
	mov r8, r14
	dec r8
	;daca e egal cu pozitia la care suntem
	cmp r9, r8
	;incercam spre stanga
	je stanga
	;iau linia curenta
	mov r11, r9
	;urmatoarea linie de sub
	inc r11
	;pointer la linie
	mov rdx, [rbx + r11 * 8]
	;vedem daca e 0 si putem sa ne ducem in ea
	cmp byte [rdx + r10], '0'
	;daca nu e ne ducem in stanga
	jne stanga
	;inseamna ca ne ducem cu o linie in jos
	inc r9
	;luam pointer la celula
	mov rdx, [rbx + r9 * 8]
	;marcam ca am treut pe aici
	mov byte [rdx + r10], '1'
	jmp parcurgere
stanga:
	;vedem daca suntem pe prima coloana
	cmp r10, 0
	;incercam sa mergem in dreapta
	je dreapta
	;copiem pozitia unde suntem
	mov r8, r10
	dec r8
	;luam pointer spre poizitie
	mov rdx, [rbx + r9 * 8]
	;verificam daca am mai fost
	cmp byte [rdx + r8], '1'
	je dreapta
	;ne mutam la stanga
	dec r10
	;punem 1 sa stim ca am fost acolo
	mov byte [rdx + r10], '1'
	jmp parcurgere
dreapta:
	;vedem daca suntem pe ultima coloana
	mov r8, r15
	dec r8
	cmp r10, r8
	je parcurgere
	;copiem col
	mov r8, r10
	;cresc r8 pt ca il scazusem mai ssu cu 1
	inc r8
	;luam pointer la ea
	mov rdx, [rbx + r9 * 8]
	;verificam daca am fost acolo
	cmp byte [rdx + r8], '1'
	je parcurgere
	;ne mutam in dreapta
	inc r10
	;punem 1 ca sa stim ca am fost acolo
	mov byte [rdx + r10], '1'
	jmp parcurgere

final:
	;salvam pozitiile la care am ajuns
	;linia
	mov [r12], r9d
	;coloana
	mov [r13], r10d
	
	pop     r15
	pop     r14
	pop     r13
	pop     r12
	pop     rbx
	pop     rbp
	ret
	