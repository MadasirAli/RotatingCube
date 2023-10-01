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
DefWindowProcA		PROTO
GetMessageA		PROTO	
TranslateMessage	PROTO
DispatchMessageA	PROTO
PostQuitMessage		PROTO

.data
	; MSG
	MSG_SIZE	equ	46
	MSG:
		qword	0	; hWnd
		dword	0	; message
		word	0	; wParam
		qword	0	; lParam

		dword	0	; time
		POINT: 
			qword	0	; X
			qword	0	; Y
		dword	0	; lPrivate

	; WNDCLASSEX
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

	WM_CLOSE	equ	16

.code
; -----------------------------------------------------------------------------------
;  PROCEDURE
;	Name		: pquitmsg
;	
;	
;	Parametres	:-
;			    rcx = wParam value of message
;	Returns		: None
; -----------------------------------------------------------------------------------
	pquitmsg PROC
		; saving old stack base pointer
		push	rbp
		; creating new stack frame
		mov	rbp,	rsp
		
		; adding shadow space
		sub	rsp,	32

		; cleaning params registers
		xor	rdx,	rdx
		mov	r8,	rdx	
		mov	r9,	rdx

		; calling win32 api
		call	PostQuitMessage
		
		; cleaning shadow space
		add	rsp,	32

		; restoring stack
		pop	rbp
		; returning to caller
		ret
	pquitmsg ENDP
; -----------------------------------------------------------------------------------
;  PROCEDURE
;	Name		: dismsg
;	Description	: Dispatchs a message to the windows procedure
;
;	Parametres	:-
;			    rcx = address of the message strucure 
;	Returns		: value returned by the Windows Procedure
; -----------------------------------------------------------------------------------
	dismsg	PROC
		; setting up stack
		; saving old base pointer
		 push	rbp
		; setting new stack frame
		mov	rbp,	rsp

		; cleaning register params
		xor	rdx,	rdx
		mov	r8,	rdx
		mov	r9,	rdx

		; adding shadow space
		sub	rsp,	32

		; calling win32 api
		call	DispatchMessageA

		; cleaning shadow space
		add	rsp,	32
		
		; restoring stack
		pop	rbp
		; returning to caller
		ret
	dismsg	ENDP
; -----------------------------------------------------------------------------------
;  PROCEDURE
;	Name		: trnsmsg
;	Description	: Translates virtual key messages into character messages and post them to message queue.
;
;	Parametres	:-
;			    rcx = address of the message structure.
;	Returns		: for non character keys the value is non zero.
; -----------------------------------------------------------------------------------
	transmsg	PROC
		; setting up stack
		; saving old stack base pointer
		push	rbp
		; setting new stack frame
		mov	rbp,	rsp

		; cleaning register params
		xor	rdx,	rdx
		mov	r8,	rdx
		mov 	r9,	rdx

		; adding shadow space
		sub	rsp, 	32

		; calling win32 api
		call	TranslateMessage

		; cleaning shadow space
		add 	rsp,	32

		; restoring stack
		pop	rbp
		; returning to caller
		ret
	transmsg	ENDP
; -----------------------------------------------------------------------------------
;  PRECEDURE
;	Name		: getmsg
;	Description	: Fetch a massage from queue.
;
;	Parametres	:-
;			    rcx = address of the massage strucutre
;			    rdx = handle to the window [opt]
;			    r8  = wMsgFilterMin
;			    r9  = wMsgFilterMax
;	Returns		:   0 for WM_QUIT and non zero for other messages
; -----------------------------------------------------------------------------------
	getmsg	PROC
		; settting stack
		; saving old stack pointer
		push 	rbp
		; setting new stack frame
		mov	rbp,	rsp

		; adding shadow space
		sub	rsp,	32
		
		; calling win32 api
		call	GetMessageA

		; cleaning shadow space
		add 	rsp,	32

		; restoring stack	
		pop 	rbp
		; returning to caler
		ret
	getmsg	ENDP
; -----------------------------------------------------------------------------------
; PROCEDURE
;	Name		: dwndp
;	Description	: Default Windows Message Handler
;	
;	Parametres	:-
;			    rcx = handle to window 
;			    rdx = address of message
;			    r8 	= lParam	
;			    r9	= hParam
;	Returns		: LResult 	
; -----------------------------------------------------------------------------------
	dwndp	PROC
		; setting stack
		; saving old stack pointer
		push	rbp
		; setting new stack frame
		mov	rbp, 	rsp

		; adding shadow space
		sub	rsp,	32

		call 	DefWindowProcA

		; cleaning shadow space
		add	rsp,	32

		; restoring stack
		pop	rbp
		; returning to caller
		ret
	dwndp	ENDP
; -----------------------------------------------------------------------------------
; PROCEDURE
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
; PREDECURE
;	Name		: crtewnd
;	Description	: Creates a Window Object from a Registered Window Class
;	
;	Parametres	:-
;			   rcx	= dwExStyle
;			   rdx 	= lpClassName
;			   r8	= lpWindowName
;			   r9 	= dwStyle
;			   stack= X, Y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam
;       Returns		: handle to the created window object
; -----------------------------------------------------------------------------------
	crtewnd	PROC
		; saving old stack base pointer
		push 	rbp
		; creating new stack frame
		mov	rbp,	rsp
		
		; setting parametres
		; pushing stack parametres
		xor	rax,	rax
		mov 	eax,	dword ptr [rsp + 72]
		push	rax

		mov	rax,	qword ptr [rsp + 72]
		push	rax

		mov 	rax,	qword ptr [rsp + 72]
		push	rax

		mov 	rax,	qword ptr [rsp + 72]
		push 	rax
		
		mov	rax, 	qword ptr [rsp + 72]
		push 	rax

		mov	rax,	qword ptr [rsp + 72]
		push 	rax

		mov	rax,	qword ptr [rsp + 72]
		push	rax

		mov	rax,	qword ptr [rsp + 72]
		push 	rax

		; adding shadow space
		sub	rsp,	32

		; calling win32 api
		call	CreateWindowExA

		; cleaning stack params
		add	rsp,	64
		; cleaning shadow space
		add	rsp, 	32

		; restoring stack
		pop	rbp
		; returning to caller
		ret
	crtewnd	ENDP

; -----------------------------------------------------------------------------------
; PROCEDURE
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
		pop	rbp

		; returning to caller
		ret

	regcls ENDP
