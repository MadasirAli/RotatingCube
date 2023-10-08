INCLUDE		vkeys.inc

.data
	KEYBOARD_INPUT_BUFFER_SIZE	equ	8
	MOUSE_INPUT_BUFFER_SIZE		equ	8

	KEYBOARD_INPUT_KEYDOWN_BUFFER:
		dword	KEYBOARD_INPUT_BUFFER_SIZE	dup (0)
	MOUSE_INPUT_KEYDOWN_BUFFER:
		dword	MOUSE_INPUT_BUFFER_SIZE		dup (0)	
	KEYBOARD_INPUT_KEYUP_BUFFER:
		dword	KEYBOARD_INPUT_BUFFER_SIZE	dup (0)
	MOUSE_INPUT_KEYUP_BUFFER:
		dword	MOUSE_INPUT_BUFFER_SIZE		dup (0)	

	KEYBOARD_INPUT_KEYDOWN_BUFFER_POINTER:
		qword	0
	MOUSE_INPUT_KEYDOWN_BUFFER_POINTER:
		qword	0
	KEYBOARD_INPUT_KEYUP_BUFFER_POINTER:
		qword	0
	MOUSE_INPUT_KEYUP_BUFFER_POINTER:
		qword	0

.code
	fndievntu PROC
		push	rbp
		mov	rbp,	rsp
		cmp	rdx,	0
		jnz	FIND_MOUSE_INPUT_KEYUP_EVENT
		call	_fkbdu
		jmp	FIND_INPUT_KEYUP_EVENT_EXIT
		FIND_MOUSE_INPUT_KEYUP_EVENT:
		call	_fmueu
		FIND_INPUT_KEYUP_EVENT_EXIT:
		pop	rbp
		ret
	fndievntu ENDP
	addievntu PROC
		push	rbp
		mov	rbp,	rsp
		cmp	rdx,	0
		jnz	ADD_INPUT_KEYUP_EVENT_MOUSE
		call	_addkbdu
		jmp	ADD_INPUT_KEYUP_EVENT_EXIT
		ADD_INPUT_KEYUP_EVENT_MOUSE:
		call	_addmueu
		ADD_INPUT_KEYUP_EVENT_EXIT:
		pop	rbp
		ret
	addievntu ENDP
	fndievntd PROC
		push	rbp
		mov	rbp,	rsp
		cmp	rdx,	0
		jnz	FIND_MOUSE_INPUT_KEYDOWN_EVENT
		call	_fkbdd
		jmp	FIND_INPUT_KEYDOWN_EVENT_EXIT
		FIND_MOUSE_INPUT_KEYDOWN_EVENT:
		call	_fmued
		FIND_INPUT_KEYDOWN_EVENT_EXIT:
		pop	rbp
		ret
	fndievntd ENDP
	addievntd PROC
		push	rbp
		mov	rbp,	rsp
		cmp	rdx,	0
		jnz	ADD_INPUT_KEYDOWN_EVENT_MOUSE
		call	_addkbdd
		jmp	ADD_INPUT_KEYDOWN_EVENT_EXIT
		ADD_INPUT_KEYDOWN_EVENT_MOUSE:
		call	_addmued
		ADD_INPUT_KEYDOWN_EVENT_EXIT:
		pop	rbp
		ret
	addievntd ENDP
	_fmued PROC
		push	rbp
		mov	rbp,	rsp
		mov	rax,	1
		push	rsi
		xor	rsi,	rsi
		DURING:
		cmp	rsi,	qword ptr [MOUSE_INPUT_KEYDOWN_BUFFER_POINTER]
		je	DONE
		xor	r8,	r8
		mov	r9,	rsi
		xor	r10,	r10
		mov	r10,	SIZEOF	dword
		imul	r9,	r10
		mov	r8d,	dword ptr [MOUSE_INPUT_KEYDOWN_BUFFER + r9]
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
	_fmued	ENDP
	_fkbdd PROC
		push	rbp
		mov	rbp,	rsp
		mov	rax,	1
		push	rsi
		xor	rsi,	rsi
		DURING:
		cmp	rsi,	qword ptr [KEYBOARD_INPUT_KEYDOWN_BUFFER_POINTER]
		je	DONE
		xor	r8,	r8
		mov	r9,	rsi
		xor	r10,	r10
		mov	r10,	SIZEOF	dword
		imul	r9,	r10
		mov	r8d,	dword ptr [KEYBOARD_INPUT_KEYDOWN_BUFFER + r9]
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
	_fkbdd	ENDP
	_addmued PROC
		push	rbp
		mov	rbp,	rsp
		mov	rax,	1
		push	rdi
		mov	rdi,	qword ptr [MOUSE_INPUT_KEYDOWN_BUFFER_POINTER]
		xor	r10,	r10
		mov	r10,	SIZEOF	dword
		imul	rdi,	r10
		cmp	rdi,	MOUSE_INPUT_BUFFER_SIZE
		je	EXIT_ADDMUED
		mov	rdx,	1
		call	_fmued
		cmp	rax,	0
		je	EXIT_ADDMUED
		mov	qword ptr [MOUSE_INPUT_KEYDOWN_BUFFER + rdi], 	rcx
		add	rdi,	SIZEOF	dword
		mov	qword ptr [MOUSE_INPUT_KEYDOWN_BUFFER_POINTER],	rdi
		xor	rax,	rax
		EXIT_ADDMUED:
		pop	rdi
		pop	rbp
		ret
	_addmued	ENDP
	_addkbdd	PROC
		push	rbp
		mov	rbp,	rsp
		mov	rax,	1
		push	rdi
		mov	rdi,	qword ptr [KEYBOARD_INPUT_KEYDOWN_BUFFER_POINTER]
		xor	r10,	r10
		mov	r10,	SIZEOF	dword
		imul	rdi,	r10
		cmp	rdi,	KEYBOARD_INPUT_BUFFER_SIZE
		je	EXIT_ADDKBDD
		mov	rdx,	0
		call	_fkbdd
		cmp	rax,	0
		je	EXIT_ADDKBDD
		mov	qword ptr [KEYBOARD_INPUT_KEYDOWN_BUFFER + rdi],	rcx
		add	rdi,	SIZEOF dword
		mov	qword ptr [KEYBOARD_INPUT_KEYDOWN_BUFFER_POINTER],	rdi
		xor 	rax,	rax
		EXIT_ADDKBDD:
		pop	rdi
		pop	rbp
		ret
	_addkbdd	ENDP
	_fmueu PROC
		push	rbp
		mov	rbp,	rsp
		mov	rax,	1
		push	rsi
		xor	rsi,	rsi
		DURING:
		cmp	rsi,	qword ptr [MOUSE_INPUT_KEYUP_BUFFER_POINTER]
		je	DONE
		xor	r8,	r8
		mov	r9,	rsi
		xor	r10,	r10
		mov	r10,	SIZEOF	dword
		imul	r9,	r10
		mov	r8d,	dword ptr [MOUSE_INPUT_KEYUP_BUFFER + r9]
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
	_fmueu	ENDP
	_fkbdu PROC
		push	rbp
		mov	rbp,	rsp
		mov	rax,	1
		push	rsi
		xor	rsi,	rsi
		DURING:
		cmp	rsi,	qword ptr [KEYBOARD_INPUT_KEYUP_BUFFER_POINTER]
		je	DONE
		xor	r8,	r8
		mov	r9,	rsi
		xor	r10,	r10
		mov	r10,	SIZEOF	dword
		imul	r9,	r10
		mov	r8d,	dword ptr [KEYBOARD_INPUT_KEYUP_BUFFER + r9]
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
	_fkbdu	ENDP
	_addmueu PROC
		push	rbp
		mov	rbp,	rsp
		mov	rax,	1
		push	rdi
		mov	rdi,	qword ptr [MOUSE_INPUT_KEYUP_BUFFER_POINTER]
		xor	r10,	r10
		mov	r10,	SIZEOF	dword
		imul	rdi,	r10
		cmp	rdi,	MOUSE_INPUT_BUFFER_SIZE
		je	EXIT_ADDMUEU
		mov	rdx,	1
		call	_fmueu
		cmp	rax,	0
		je	EXIT_ADDMUEU
		mov	qword ptr [MOUSE_INPUT_KEYUP_BUFFER + rdi], 	rcx
		add	rdi,	SIZEOF	dword
		mov	qword ptr [MOUSE_INPUT_KEYUP_BUFFER_POINTER],	rdi
		xor	rax,	rax
		EXIT_ADDMUEU:
		pop	rdi
		pop	rbp
		ret
	_addmueu	ENDP
	_addkbdu	PROC
		push	rbp
		mov	rbp,	rsp
		mov	rax,	1
		push	rdi
		mov	rdi,	qword ptr [KEYBOARD_INPUT_KEYUP_BUFFER_POINTER]
		xor	r10,	r10
		mov	r10,	SIZEOF	dword
		imul	rdi,	r10
		cmp	rdi,	KEYBOARD_INPUT_BUFFER_SIZE
		je	EXIT_ADDKBDU
		mov	rdx,	0
		call	_fkbdu
		cmp	rax,	0
		je	EXIT_ADDKBDU
		mov	qword ptr [KEYBOARD_INPUT_KEYUP_BUFFER + rdi],	rcx
		add	rdi,	SIZEOF dword
		mov	qword ptr [KEYBOARD_INPUT_KEYDOWN_BUFFER_POINTER],	rdi
		xor 	rax,	rax
		EXIT_ADDKBDU:
		pop	rdi
		pop	rbp
		ret
	_addkbdu	ENDP
