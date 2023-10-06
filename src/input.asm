INCLUDE		vkeys.inc

.data
	KEYBOARD_INPUT_BUFFER_SIZE	equ	8
	MOUSE_INPUT_BUFFER_SIZE		equ	8

	KEYBOARD_INPUT_BUFFER:
		dword	KEYBOARD_INPUT_BUFFER_SIZE	dup (0)
	MOUSE_INPUT_BUFFER:
		dword	MOUSE_INPUT_BUFFER_SIZE		dup (0)	

	KEYBOARD_INPUT_BUFFER_POINTER:
		qword	0
	MOUSE_INPUT_BUFFER_POINTER:
		qword	0

.code
	fndevnt PROC
		push	rbp
		mov	rbp,	rsp
		cmp	rdx,	0
		jnz	FIND_MOUSE_INPUT_EVENT
		call	_fkbd
		jmp	FIND_INPUT_EVENT_EXIT
		FIND_MOUSE_INPUT_EVENT:
		call	_fmue
		FIND_INPUT_EVENT_EXIT:
		pop	rbp
		ret
	fndevnt ENDP
	addevnt PROC
		push	rbp
		mov	rbp,	rsp
		cmp	rdx,	0
		jnz	ADD_INPUT_EVENT_MOUSE
		call	_addkbd
		jmp	ADD_INPUT_EVENT_EXIT
		ADD_INPUT_EVENT_MOUSE:
		call	_addmue
		ADD_INPUT_EVENT_EXIT:
		pop	rbp
		ret
	addevnt PROC
	_fmue PROC
		push	rbp
		mov	rbp,	rsp
		mov	rax,	1
		push	rsi
		xor	rsi,	rsi
		DURING:
		cmp	rsi,	MOUSE_INPUT_BUFFER_POINTER
		je	DONE
		xor	r8,	r8
		mov	r9,	rsi
		mul	r9,	SIZEOF dword
		mov	r8d,	dword ptr [MOUSE_INPUT__BUFFER + r9]
		cmp	ecx,	r8d
		je	FOUND
		inc	rsi
		jmp	DURING
		FOUND:
		mov	rax,	0
		mov	rcx,	rsi
		DONE:
		pop	rsi
		pop	rbp
		ret
	_fmue	ENDP
	_fkbd PROC
		push	rbp
		mov	rbp,	rsp
		mov	rax,	1
		push	rsi
		xor	rsi,	rsi
		DURING:
		cmp	rsi,	KEYBOARD_INPUT_BUFFER_POINTER
		je	DONE
		xor	r8,	r8
		mov	r9,	rsi
		mul	r9,	SIZEOF dword
		mov	r8d,	dword ptr [KEYBOARD_INPUT__BUFFER + r9]
		cmp	ecx,	r8d
		je	FOUND
		inc	rsi
		jmp	DURING
		FOUND:
		mov	rax,	0
		mov	rcx,	rsi
		DONE:
		pop	rsi
		pop	rbp
		ret
	_fkbd	ENDP
	_addmue PROC
		push	rbp
		mov	rbp,	rsp
		mov	rax,	1
		push	rdi
		mov	rdi,	qword ptr [MOSUE_INPUT_BUFFER_POINTER]
		mul	rdi,	SIZEOF dword
		cmp	rdi,	MOUSE_INPUT_BUFFER_SIZE
		je	EXIT_ADDMUE
		mov	qword ptr [MOUSE_INPUT_BUFFER + rdi], 	rcx
		add	rdi,	SIZEOF	dword
		mov	dword ptr [MOUSE_INPUT_BUFFER_POINTER],	rdi
		xor	rax,	rax
		EXIT_ADDMUE:
		pop	rdi
		pop	rbp
		ret
	_addmue	ENDP
	_addkbd	PROC
		push	rbp
		mov	rbp,	rsp
		mov	rax,	1
		push	rdi
		mov	rdi,	qword ptr [KEYBOARD_INPUT_BUFFER_POINTER]
		mul	rdi,	SIZEOF	dword
		cmp	rdi,	KEYBOARD_INPUT_BUFFER_SIZE
		je	EXIT_ADDKBD
		mov	dword ptr [KEYBOARD_INPUT_BUFFER + rdi],	rcx
		add	rdi,	SIZEOF dword
		mov	dword ptr [KEYBOARD_INPUT_BUFFER_POINTER],	rdi
		xor 	rax,	rax
		EXIT_ADDKBD:
		pop	rdi
		pop	rbp
		ret
	_addkbd	ENDP
