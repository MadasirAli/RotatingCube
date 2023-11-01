INCLUDELIB	kernel32.lib 

Sleep		PROTO

.code
; ---------------------------------------------------------------
;  PROCEDURE
;	Name		: slp
;	Description	: Suspends threads execution for specified time.
;
;	Parametres	: rcx = dw time in ms
;	Returns		: None
; ---------------------------------------------------------------
	slp	PROC
		push	rbp
		mov	rbp,	rsp
		sub	rsp,	32
		call	Sleep
		mov	rsp,	rbp
		pop	rbp
		ret
	slp	ENDP
; vim:ft=masm
