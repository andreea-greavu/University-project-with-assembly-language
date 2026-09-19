section .text


global check_column
global check_row
global check_box

check_row:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	
	;vr sa calculez ce mi se da in hint adica size * (size + 1) / 2 care e de fapt suma de la 1 la size
	;aici o sa am suma de la 1 la size
	mov r8, 0
	;contorul pt elemente
	mov r9, 1
suma_rand:
	;verific daca am pus toate el
	cmp r9, rsi
	jg rez_rand
	;adaug la suma
	add r8, r9
	;trec la nr urmator
	inc r9
	jmp suma_rand
rez_rand:
	;vr sa calculez produsul dat in hint adica factorial de size
	mov r10, 1
	;incep de la 1
	mov r11, 1
factorial_rand:
	;vad daca am inmultit toate numerele
	cmp r11, rsi
	jg rezultat_rand
	;in rax pun produsul de pana acum
	mov rax, r10
	;inmultesc
	mul r11
	;pun inapoi in r10 produsul
	mov r10, rax
	;trec la urmatorul
	inc r11
	jmp factorial_rand
rezultat_rand:
	;iau un pointer la randul pe care il verific
	mov r12, [rdi + rdx * 8]
	;contorul ca sa parcurg randul
	xor rcx, rcx
	;suma de pe rand
	mov r13, 0
	;produsul de pe rand
	mov r14, 1
calcul_rand:
	;vedem daca am verificat tot
	cmp rcx, rsi
	jge verificare_rand
	;iau un element
	mov r15d, [r12 + rcx * 4]
	;il adaugam la suma
	add r13, r15
	;il adaugam in produs
	mov rax, r14
	mul r15
	mov r14, rax
	;ne ducem la urmatorul element de pe rand
	inc rcx
	jmp calcul_rand
verificare_rand:
	;setez rax 0 ca fiind gresit randul
	mov rax, 0
	;verific daca suma el = size * (size + 1) / 2
	cmp r13, r8
	jne incorect_rand
	;verific daca produsul elementelor = factorial(size)
	cmp r14, r10
	jne incorect_rand
	;daca ambele reguli sunt respectate atunci stiu ca randul e corect
	mov rax, 1
incorect_rand:
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
	
check_column:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	
	;o sa calculez in r8 suma de la 1 la size
	mov r8, 0
	;iau un contor pt elemente
	mov r9, 1
suma_col:
	;daca am pus tot
	cmp r9, rsi
	jg rez_col
	;adaug la suma
	add r8, r9
	inc r9
	jmp suma_col
rez_col:
	;aflu cat e factorial de size
	mov r10, 1
	;incep de la 1
	mov r11, 1
factorial_col:
	;vad daca am pus toate numerele
	cmp r11, rsi
	jg rezultat_col
	;inmultesc
	mov rax, r10
	mul r11
	mov r10, rax
	inc r11
	jmp factorial_col
rezultat_col:
	;iau un contor pt index ca sa parcurg coloana
	xor rcx, rcx
	;suma pe coloana
	mov r13, 0
	;produsul pe coloana
	mov r14, 1
calcul_col:
	;iau pointer la randul rcx ca dupa sa pot sa iau elementul de pe coloana la care sunt
	mov r12, [rdi + rcx * 8]
	;vedem daca am parcurs tot
	cmp rcx, rsi
	jge verificare_col
	;iau un element
	mov r15d, [r12 + rdx * 4]
	;adaugam la suma
	add r13, r15
	;adaugam in produs
	mov rax, r14
	mul r15
	mov r14, rax
	;trec la urmatorul element din coloana
	inc rcx
	jmp calcul_col
verificare_col:
	;setez rax ca fiind gresit
	mov rax, 0
	;verific daca suma el = size * (size + 1) / 2)
	cmp r13, r8
	jne incorect_col
	;verific daca produsul elementelor = factorial(size)
	cmp r14, r10
	jne incorect_col
	;daca sunt aici inseamna ca e corecta coloana
	mov rax, 1
incorect_col:
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
	
check_box:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	
	;calculez suma de la 1 la size
	mov r8, 0
	;incepem de la 1
	mov r9, 1
suma:
	;daca am pus tot
	cmp r9, rsi
	jg rez
	;adaug la suma
	add r8, r9
	;cresc
	inc r9
	jmp suma
rez:
	;aflu cat e factorial de size
	mov r10, 1
	;incep de la 1
	mov r11, 1
factorial:
	;vad daca am pus toate numerele
	cmp r11, rsi
	jg rezultat
	;inmultesc
	mov rax, r10
	mul r11
	mov r10, rax
	inc r11
	jmp factorial
rezultat:
	;vreau sa vad cate boxuri pot avea in matrice
	;am vazut in cerinta pot fi doar matrici de 4x4 , 9x9 sau 16x16
	;deci pot sa am in ele doar "matrici" de 2x2, 3x3 sau 4x4
	;daca dimensiunea e 4 atunci avem submatrici 2x2
	cmp rsi, 4
	je avem_2x2
	;daca dimensiunea e 9 avem submatrici 3x3
	cmp rsi, 9
	je avem_3x3
	;daca dimensiunea e 16 avem submatrici 4x4
	cmp rsi, 16
	je avem_4x4
	;acum cautam in care bucatica din matricee vrem sa verificam
avem_2x2:
	;retinem dimensiunea 2
	mov rbx, 2
	jmp cauta
avem_3x3:
	;retinem dimensiunea 3
	mov rbx, 3
	jmp cauta
avem_4x4:
	;retinem dimensiuena 4
	mov rbx, 4
cauta:
	;calculam randul si coloana de la care incep cautarea
	;pt i adica rand merge formula (nrcutiei / nr cutiei mini) * nr cutiei mini
	;punem in eax nr cutiei
	mov eax, edx
	;pe edx il folosesc la impartire deci trb sa fie 0
	xor edx, edx
	;fac impratirea si mi se duce in eax catul si restul in edx
	div ebx
	;salvez restul
	mov r15d, edx
	;il aflu pe i
	mul ebx
	;il salvez pe i
	mov r12d, eax
	;pt j adica coloana merge formula (nrcutiei % nr cutiei mini) * nr cutiei mini
	mov eax, r15d
	;aflu j
	mul ebx
	;il salvez pe j
	mov r15d, eax
	;aici o sa am suma pt submatricea in care caut
	xor r13, r13
	;aici o sa am produsul pt submatricea in care caut
	mov r14, 1
	;contor pt i
	xor rcx, rcx
	;bulca pt i adica pt randuri
for_rand:
	;vedem daca am verificat toate randurile
	cmp ecx, ebx
	jge verificare
	;il facem pe j 0 ca sa cautam si pe coloane
	xor r9d, r9d
	;bucla pt j adica pt coloane
for_coloana:
	;vedem daca le am verificat pe toate
	cmp r9d, ebx
	jge urmatorul
	;vreau sa aflu randul
	mov eax, r12d
	add eax, ecx
	;pointer la rand
	mov r11, [rdi + rax * 8]
	;vreau sa aflu coloana
	mov eax, r15d
	add eax, r9d
	;iau elementul
	mov eax, [r11 + rax * 4]
	;adaug la suma
	add r13, rax
	;salvam elementul
	mov r11, rax
	;produsul de pana acum
	mov rax, r14
	;inmultim
	mul r11
	;adaugam la produs
	mov r14, rax
	;crestem contorul pt j
	inc r9d
	jmp for_coloana
urmatorul:
	;cresc contorul pt i
	inc ecx
	jmp for_rand
verificare:
	;pun 0 ca si cum ar fi gresit
	mov rax, 0
	;vad daca suma el = size * (size + 1) / 2)
	cmp r13, r8
	jne incorect
	;vad daca produsul elementelor = factorial(size)
	cmp r14, r10
	jne	incorect
	;inseamna ca e corect
	mov rax, 1
incorect:
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
