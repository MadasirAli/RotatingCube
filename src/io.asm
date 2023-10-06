INCLUDELIB	Kernel32.lib

CreateFileA		PROTO
WriteFile		PROTO

.data
	; constants
	GENERIC_READ	equ	80000000h	
	GENERIC_WRITE	equ	40000000h
	GENERIC_EXECUTE	equ	20000000h
	GENERIC_ALL	equ	10000000h
.code
; ------------------------------------------------------------------------
;  PROCEDURE
;	Name		: wrtefil
;	Description	: Writes to a io device.
;
;	Parametres	:-
;			     rcx = handle to device
;			     rdx = lpBuffer
;			     r8  = nNumberOfBytesToWrite
;			     r9  = [out, opt] lpNumberOfBytesWritten
;			Stack:	[in, out, opt] lpOverlapped
; ------------------------------------------------------------------------
	wrtefil	PROC
		push	rbp
		mov	rbp,	rsp
		mov	rax,	qword ptr [rsp + 16]
		push	rax
		sub	rsp,	32
		call	WriteFile
		add	rsp,	32
		add	rsp,	8
		pop	rbp
		ret
	wrtefil	ENDP
; ------------------------------------------------------------------------
;  PROCEDURE
;	Name		: crtefil
;	Description	: Opens a handle to a io device.
;
;	Parametres	:-
;			   rcx = lpFileName
;			   rdx = dwDesiredAccess
;			   r8  = dwShareMode
;			   r9  = lpSecurityAttribute
;			Stack: dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile
;	Returns		: Handle to File or INVALID_HANDLE_VALUE for failture
; ------------------------------------------------------------------------	
	crtefil	PROC
		push	rbp
		mov	rbp,	rcx
		mov	rax,	qword ptr [rsp + 32]
		push	rax
		mov	rax,	qword ptr [rsp + 32]
		push	rax
		mov	rax,	qword ptr [rsp + 32]
		push	rax
		sub	rsp,	32
		call	CreateFileA
		add	rsp,	32
		add	rsp,	24
		pop	rbp
		ret
	crtefil	ENDP
