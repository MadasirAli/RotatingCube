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
