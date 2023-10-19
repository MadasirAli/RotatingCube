INCLUDE 	"3dspace.asm"
INCLUDE		"gmeobj.asm"
INCLUDE		"rstrizr.asm"

.code
; ---------------------------------------------------------------------------------------
;  PROCEDURE
;	Name		: enetst
;	Description	: Runs the current functionality of the engine.
;
;	Parametres	:-
;	rcx = buffer to wide characters
;	
;	Returns		: None
; ---------------------------------------------------------------------------------------
	enetst	PROC
		; setting stack
		push	rbp
		mov	rbp,	rsp

		; saving non volatile registers
		push	rbx
		push	r12
		push	r13
		push	r14
		push	r15
		push	rsi
		push	rdi

		; 1- Initial Draw
		; 2- Rasterize
		; 3- Fill Buffer

		; restoring non volatile registers
		pop	rdi
		pop	rsi
		pop	r15
		pop	r14
		pop	r13
		pop	r12
		pop	rbx
		
		; restoring stack
		pop	rbp
		; returning to caller
		ret
	enetst	ENDP

.data

; vim:ft=masm
