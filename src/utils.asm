; ------------------------------------------------------------------------------------
;	Name		: utils.asm
; 	Description	: Contains some useful procedures.
;
;	Date Created	: 25 / 9 / 2023
;	Last Modified	: 25 / 9 / 2023
; ------------------------------------------------------------------------------------

; External libs
INCLUDELIB	kernel32.lib

; Externel prototypes
ExitProcess	PROTO

.code
; ------------------------------------------------------------------------------------
; PROCEDURE
;	Name		: exit
;	Description	: return control to the operating system
;
;	Parametres	:-
;			    rcx  =  exit code
; ------------------------------------------------------------------------------------
	exit PROC
		; cleaning parametres registers
		xor 	rdx,	rdx
		mov 	r8,	rdx
		mov 	r9,	rdx

		; setting up stack
		; saving old
		push	rbp
		; creating new stack frame
		mov	rbp,	rsp
		; adding shadow space
		sub	rsp,	32

		; calling ExitProcess to stop execution
		call	ExitProcess
	exit ENDP
