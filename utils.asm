; ------------------------------------------------------------------------------------
;	Name		: utils.asm
; 	Description	: Contains some useful procedures
;
;	Date Created	: 25 / 9 / 2023
;	Last Modified	: 25 / 9 / 2023
; ------------------------------------------------------------------------------------

; ------------------------------------------------------------------------------------
; Externel References

; Base References
INCLUDELIB	kernel32.lib

; C Language Runtime
INCLUDELIB	msvcrt.lib
INCLUDELIB	legacy_stdio_definitions.lib
; ------------------------------------------------------------------------------------

; ------------------------------------------------------------------------------------
; Function Prototypes

; Base Prototypes
	ExitProcess 	PROTO

; Standard C Library Prototypes
	printf		PROTO
; ------------------------------------------------------------------------------------

.code
; -----------------------------------------------------------------------------------
; PRECEDURE
;	Name		: strlen
;	Description	: Gives the length of a c string
;
;	Parametres	:-
;			    rcx = address of the string
;	Returns		: length  of the string 
; -----------------------------------------------------------------------------------
	strlen PROC
		; setting stack
		; saving old stack base	
		push	rbp

		; setting new stack frame
		mov	rbp, rsp
		
		xor	rax,	rax
		DURING:
			cmp	byte ptr [rcx + rax],	0
			jz	DONE
			inc	rax
			jmp	DURING
		DONE:
			nop

		; restoring stack
		pop	rbp
		; returning to caller
		ret
	strlen ENDP

; ------------------------------------------------------------------------------------
; PROCEDURE
;	Name		: memcpy
;	Descritpion	: Copies a region of memory to specified region
;
;	Parametres	:-
;			    rcx	= address of region from copy
;			    rdx = address of region to paste
;			    r8  = number of bytes to copy
; ------------------------------------------------------------------------------------
	memcpy	PROC
		; saving old stack base
		push	rbp
		; creating new stack frame
		mov	rbp,	rsp

		; cleaning buffer register
		xor	rbx,	rbx

		; while number of bytes
		mov	r9,	r8
		DURING:
			; condition
			cmp	r9,	0
			jz	DONE
			; during condition
			mov	bl,	byte ptr [rcx + r9]
			mov	byte ptr [rdx + r9],	bl
			; after condition
			dec	r9
			jmp	DURING
		DONE:
			; coping the first remaining byte
			mov	bl,	byte ptr [rcx + r9]
			mov	byte ptr [rdx + r9],	bl

		; restoring stack
		pop	rbp
		
		; returning to caller
		ret	
	memcpy	ENDP

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
		xor 	rdx,	rdx
		mov 	r8,	rdx
		mov 	r9,	rdx

		; Setting up stack
		; saving old stack base
		push	rbp
		; cleaning current stack, keeping old stack value on stack
		mov 	rbp,	rsp
		
		; adding shadow space for 4 register parameters on stack
		sub	rsp,	32

                ; --------------------------------------------------------------------
		; stack will be aligned at 16 (multiple of 16)
		; 16 bytes alignment is required for SIMD instructions
		; adding any extra bytes required to align
		; and	rsp,    -16

		; call will push 8 bytes return address (long pointer) on stack
		; -------------------------------------------------------------------

		; Calling printf from C Standard Library
		call	printf
		
		; cleaning stack
		; cleaning shadow space
		add	rsp,	32
		; restoring old base pointer
		pop	rbp

		; returning to caller
		ret
	print ENDP

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
