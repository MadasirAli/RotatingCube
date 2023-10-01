; ------------------------------------------------------------------------------------
;	Name		: memutils.asm
; 	Description	: Contains memory management procedures
;
;	Date Created	: 25 / 9 / 2023
;	Last Modified	: 25 / 9 / 2023
; ------------------------------------------------------------------------------------

; ------------------------------------------------------------------------------------
; Externel References
INCLUDELIB	kernel32.lib

; EXTERNAL PROTOTYPES


.code
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
