; -----------------------------------------------------------------------------------
;	Name		: winutils.asm
;	Description	: Contains Useful Precedures dealing with windows WINDOW SUBSYSTEM
;
;	Date Created	: 25 / 9 / 2023
;	Last Modified	: 25 / 9 / 2023
; -----------------------------------------------------------------------------------

INCLUDELIB	kernel32.lib
INCLUDELIB	user32.lib

RegisterClassExA	PROTO
CreateWindowExA		PROTO
ShowWindow		PROTO

.data
	; defining windows class stuture
	; WNDCLASSEX
	; ENDCLASSEX	SIZE
	WNDCLASSEX_SIZE	equ	80
	WNDCLASSEX:
	dword	0	; cbSize
	dword 	0	; style
	qword	0	; lpFnWndProc
	dword	0	; cbClsExtra
	dword	0	; cbWndExtra
	qword	0	; hInstance
	qword	0	; hIcon
	qword	0	; hCursor
	qword	0	; hbrBackground
	qword	0	; lpszMenuName
	qword	0	; lpszClassName
	qword	0	; hIconSm

	; DEFAULTS
	POS_X		equ	0
	POS_Y		equ	0
	WND_WIDTH	equ	800
	WND_HEIGHT	equ	600

.code
; -----------------------------------------------------------------------------------
; 	Name		: shwnd
;	Description	: Set Specified Window's shows state
;
;	Parametres	:-
;			    rcx = handle to window
;			    rdx = show stats
;	Returns		:   boolean representing windows previous show state, 0 for previosly hidden
; -----------------------------------------------------------------------------------
	shwnd	PROC
		; setting stack
		; saving old stack base
		push	rbp
		; creating new stack frame
		mov	rbp,	rsp

		; cleaning parametres registers
		xor	r8,	r8
		mov	r9,	r9

		; adding shadow space on stack
		sub	rsp,	32
		
		; calling win32
		call	ShowWindow

		; cleaning shadow space
		add	rsp,	32

		; resotring stack
		pop 	rbp
		; returning to caller
		ret
	shwnd	ENDP	

; -----------------------------------------------------------------------------------
;	Name		: crtewnd
;	Description	: Creates a Window Object from a Registered Window Class
;	
;	Parametres	:-
;			   rcx	= dwExStyle
;			   rdx 	= lpClassNamei
;			   r8	= lpWindowName
;			   r9 	= dwStyle
;			   stack= X, Y, nWidth, nHeight, hWndParent, hMenu, hInstance, 	 			       lpParam
;       Returns		: handle to the created window object
; -----------------------------------------------------------------------------------
	crtewnd	PROC
		; saving old stack base pointer
		push 	rbp
		; creating new stack frame
		mov	rbp,	rsp
		
		; setting parametres
		; adding shadow space for registers parametres
		sub	rsp,	32
		; pushing stack parametres
		xor	rax,	rax
		mov 	eax,	dword ptr [rsp + 120]
		push	rax

		mov	rax,	qword ptr [rsp + 120]
		push	rax

		mov 	rax,	qword ptr [rsp + 120]
		push	rax

		mov 	rax,	qword ptr [rsp + 120]
		push 	rax
		
		mov	rax, 	qword ptr [rsp + 120]
		push 	rax

		mov	rax,	qword ptr [rsp + 120]
		push 	rax

		mov	rax,	qword ptr [rsp + 120]
		push	rax

		mov	rax,	qword ptr [rsp + 120]
		push 	rax

		mov 	rax,	qword ptr [rsp + 120]
		push 	rax

		mov	rax,	qword ptr [rsp + 120]
		push	rax

		mov	rax,	qword ptr [rsp + 120]
		push 	rax
		
		mov	rax,	qword ptr [rsp + 120]
		push	rax

		; calling win32 api
		call	CreateWindowExA

		; restoring stack
		pop	rbp
		; returning to caller
		ret
	crtewnd	ENDP

; -----------------------------------------------------------------------------------
;	Name		: regcls
;	Description 	: Registers a Window Class on WIN32 API
;
;	Parametres	:-
;			   rcx = pointer to WNDCLASSEX structure
;	Returns		: zero (0) for error and atom for success
; -----------------------------------------------------------------------------------
	regcls PROC
		; saving old stack base pointer
		push	rbp
		; creating new stack frame
		mov	rbp,	rsp

		; cleaning parametres registers
		xor	rdx,	rdx
		mov	r8,	rdx
		mov 	r9,	rdx

		; adding shadow space
		sub	rsp,	32

		; calling RegisterWindowEXA
		call	RegisterClassExA

		; cleaning stack
		; cleaning shadow space
		add	rsp,	32
		; restoring stack
		pop	rbx

		; returning to caller
		ret

	regcls ENDP
