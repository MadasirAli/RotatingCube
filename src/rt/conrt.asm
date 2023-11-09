INCLUDELIB	kernel32.lib

SetConsoleTitleA		PROTO
GetStdHandle			PROTO
AllocConsole			PROTO
AttachConsole			PROTO
WriteConsoleA			PROTO
WriteConsoleW			PROTO
SetConsoleCursorPosition	PROTO
WriteConsoleOutputW		PROTO

.data
	; CHAR_INFO
	CHAR_INFO_SIZE	equ	4
	CHAR_INFO:
		word	0	; uniCode or asCII
		word	0 	; attributesv
	COORD_SIZE	equ	4
	COORD:
		word	0	; x
		word	0	; y

	SMALL_RECT_SIZE	equ	8
	SMALL_RECT:
		word	0	; left-top-x
		word	0	; left-top-y
		word	0	; right-top-x
		word	0	; right-top-y

	; Constants
	STD_INPUT_HANDLE	equ 	-10
	STD_OUTPUT_HANDLE	equ	-11
	STD_ERROR_HANDLE	equ	-12

	INVALID_HANDLE_VALUE	equ	-1

	ATTACH_PARENT_PROCESS	equ	-1

.code
; -------------------------------------------------------------------------
;  PROCEDURE
;	Name		: wrteconoutw
;	Description	: Writes a 2d buffer of char_info to screen.
;
;	Parametres	:-
;			rcx = handle to console output
;			rdx = pointer to 2d char_info bufffer
;			r8  = coord buffer size
;			r9  = coord buffer start from coord
;			Stack:- lpWriteRegion
; ------------------------------------------------------------------------
	wrteconoutw	PROC
		push	rbp	
		mov	rbp,	rsp
		mov	rax,	qword ptr [rsp + (SIZEOF qword * 2)]
		push	rax
		push	rax
		sub	rsp,	32
		call	WriteConsoleOutputW
		mov	rsp,	rbp
		pop	rbp
		ret
	wrteconoutw	ENDP
; -------------------------------------------------------------------------
;  PROCEDURE
;	Name		: srcrsrps
;	Description	: Sets the Cursor Position to the specified coords.
;
;	Parametres	:-
;				rcx = handle to std out
;				rdx = double word for coords, upper x, lower y
; -------------------------------------------------------------------------
	stcrsrps	PROC
		push	rbp
		mov	rbp,	rsp
		sub	rsp,	32
		call	SetConsoleCursorPosition
		mov	rsp,	rbp
		pop	rbp
		ret
	stcrsrps	ENDP

; -------------------------------------------------------------------------
;  PROCEDURE
;	Name		: wrteconw
;	Description	: Writes UNICODE characters to specified console standard out buffer.
;
;	Parametres	:-
;	rcx = handle to $STDOUT
;	rdx = pointer to buffer of characters to write
;	r8  = number of characters to write
;	r9  = numbers of characters that are written
;	Stack:	qword (lp reserved = null)
; -------------------------------------------------------------------------
	wrteconw	PROC
		; saving previous stack state
		push	rbp
		; creating new stack frame
		mov	rbp, 	rsp
		; pushing 8 bytes to align stack at 16 bits
		xor	rax,	rax
		push	rax
		; retriving stack parametres
		push	qword ptr [rsp + 24]
		; calling win32
		call	WriteConsoleW
		; removing fake space alignment
		add	rsp,	8
		; cleaning stack parametre
		add	rsp,	8
		; adding shadow space
		sub	rsp,	32
		; cleaing shadow space
		add	rsp,	32
		; restoring stack
		pop	rbp
		; returning to caller
		ret
	wrteconw	ENDP
; -------------------------------------------------------------------------
;  PROCEDURE
;	Name		: wrtecona
;	Description	: Writes ASCII characters to specified console standard out buffer.
;
;	Parametres	:-
;	rcx = handle to $STDOUT
;	rdx = pointer to buffer of characters to write
;	r8  = number of characters to write
;	r9  = numbers of characters that are written
;	Stack:	qword (lp reserved = null)
; -------------------------------------------------------------------------
	wrtecona	PROC
		; saving previous stack state
		push	rbp
		; creating new stack frame
		mov	rbp, 	rsp
		; pushing 8 bytes to align stack at 16 bits
		xor	rax,	rax
		push	rax
		; retriving stack parametres
		push	qword ptr [rsp + 24]
		; calling win32
		call	WriteConsoleA
		; removing fake space alignment
		add	rsp,	8
		; cleaning stack parametre
		add	rsp,	8
		; adding shadow space
		sub	rsp,	32
		; cleaing shadow space
		add	rsp,	32
		; restoring stack
		pop	rbp
		; returning to caller
		ret
	wrtecona	ENDP

; -------------------------------------------------------------------------
;  PROCEDURE
;	Name		: atcon
;	Description	: Attaches a console to this process
;
;	Parametres	:-
;			   rcx = dword pid or ATTACH_PARENT_PROCESS
;	Returns		: boolean
; -------------------------------------------------------------------------
	atcon	PROC
		push	rbp
		mov	rsp,	rbp
		sub	rsp,	32
		xor	rax,	rax
		cmp	rcx,	rax
		mov	rax,	ATTACH_PARENT_PROCESS
		cmovz	rcx,	rax
		call	AttachConsole
		add	rsp,	32
		pop	rbp
		ret
	atcon	ENDP
; -------------------------------------------------------------------------
;  PROCEDURE
;	Name		: alcon
;	Description	: Creates a new console window.
;
;	Parametres	: None.
;	Returns		: 0 for failture, non zero for success
; -------------------------------------------------------------------------
	alcon	PROC
		push	rbp
		mov	rbp,	rsp
		sub	rsp,	32
		call	AllocConsole
		add	rsp,	32
		pop	rbp
		ret
	alcon	ENDP
; -------------------------------------------------------------------------
;  PROCEDURE
;	Name		: setcontit
;	Description	: Sets the title of the attached console window.
;
;	Parametres	:-
;			    rcx = pointer to the string
;	Returns		: 0 for error
; -------------------------------------------------------------------------
	setcontit	PROC
		push	rbp
		mov	rbp,	rsp
		sub	rsp,	32
		call	SetConsoleTitleA
		add	rsp,	32
		pop	rbp
		ret
	setcontit	ENDP
; ---------------------------------------------------------
;  PROCEDURE
;	Name		: getstdh
;	Description	: Gets console I/O handle from process table
;
;	Parametres	:-
;			   rcx = nStdHandle
;	Returns		: handle to buffer, or INVALID_HANDLE_VALUE on failture
; ---------------------------------------------------------
	getstdh	PROC
		push	rbp
		mov	rbp,	rsp
		sub	rsp,	32
		call	GetStdHandle
		add	rsp,	32
		pop	rbp
		ret
	getstdh	ENDP

; vim:ft=masm
