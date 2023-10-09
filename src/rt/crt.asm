; ------------------------------------------------------------------------------------
;	Name		: crt.asm
; 	Description	: Contains some useful procedures of CRT
;
;	Date Created	: 25 / 9 / 2023
;	Last Modified	: 25 / 9 / 2023
; ------------------------------------------------------------------------------------

INCLUDELIB	msvcrt.lib
INCLUDELIB	legacy_stdio_definitions.lib

; Standard C Library Prototypes
printf		PROTO

.code
; ------------------------------------------------------------------------------------
; PROCEDURE
;	Name		: print
;	Description	: Simply prints string by using C Standard Library.
;	
;	Parametres	:-
;			   rcx	= :wq Memory Address (pointer) to c string.	
; ------------------------------------------------------------------------------------
	print PROC
		; cleaning registers	
		xor 	r8,	r8
		mov 	r9,	r8

		; Setting up stack
		; saving old stack base
		push	rbp
		; cleaning current stack, keeping old stack value on stack
		mov 	rbp,	rsp
		
                ; --------------------------------------------------------------------
		; stack will be aligned at 16 (multiple of 16)
		; 16 bytes alignment is required for SIMD instructions
		; adding any extra bytes required to align
		mov	rbx,	rsp
		and	rsp,    -16
		
		; adding 8 bytes more to make the final alignment the multiple of 16
		sub	rsp,	8

		; adding shadow space
		sub	rsp,	32

		; Calling printf from C Standard Library
		call	printf

		; cleaning shadow space
		add	rsp,	32
		; cleaning extra 8 bytes
		add	rsp,	8
		; cleaning alignent by restoring stack pointer
		mov	rsp,	rbx
		
		; restoring old base pointer
		pop	rbp

		; returning to caller
		ret
	print ENDP
