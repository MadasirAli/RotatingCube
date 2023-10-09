INCLUDELIB	kernel32.lib

SetConsoleTitleA	PROTO
GetStdHandle		PROTO
AllocConsole		PROTO
AttachConsole		PROTO

.data
	; CHAR_INFO
	CHAR_INFO_SIZE:
		qword	4
	CHAR_INFO:
		word	0	; uniCode or asCII
		word	0 	; attributesv

	; Constants
	STD_INPUT_HANDLE	equ 	-10
	STD_OUTPUT_HANDLE	equ	-11
	STD_ERROR_HANDLE	equ	-12

	INVALID_HANDLE_VALUE	equ	-1

	ATTACH_PARENT_PROCESS	equ	-1

.code
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
