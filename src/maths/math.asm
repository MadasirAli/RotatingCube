.data
	PIE_DIVISOR_NUMERATOR:
		qword 22.0
	PIE_DIVISOR_DENUMERATOR:
		qword 7.0
	PIE_ANGLE_DEGREE:
		qword 180.0
	PIE_HALF:
		qword 90.0
			
.code
; --------------------------------------------------------------------------------
;  PROCEDURE
;	Name		: atan
;	Description	: Gives the ratio of cos0/sin0
;
;	Parametres	: rcx = angle in degrees
;	Returns		: Result.
; --------------------------------------------------------------------------------
	atan	PROC
		push	rbp
		mov	rbp,	rsp
		push	rcx
		call	cosrad
		pop	rcx
		push	rax	; cos0rad
		push	rcx
		call	sinrad
		pop	rcx
		push	rax	; sin0rad
		fld	qword ptr [rsp + SIZEOF qword]		; cos0rad
		fld	qword ptr [rsp]				; sin0rad
		fdivp
		push	0
		fstp	qword ptr [rsp]
		pop	rax
		mov	rsp,	rbp	
		pop	rbp
		ret
	atan	ENDP
; --------------------------------------------------------------------------------
;  PROCEDURE
;	Name		: sinrad
;	Description	: Takes the sine function of an angle.
;
;	Parametres	: rcx = angle
;	Returns		: value of result
; --------------------------------------------------------------------------------
	sinrad	PROC
		push	rbp
		mov	rbp,	rsp
		mov	rcx,	PIE_HALF
		call	deg2rad
		push	rax
		fld	qword ptr [rcx]
		fld	qword ptr [rsp]
		fsubp
		fstp	qword ptr [rsp]
		pop	rcx
		call	cos
		mov	rsp,	rbp	
		pop	rbp
		ret
	sinrad	ENDP
; --------------------------------------------------------------------------------
;  PROCEDURE
;	Name		: sin
;	Description	: Takes the sine function of an angle.
;
;	Parametres	: rcx = angle
;	Returns		: value of result
; --------------------------------------------------------------------------------
	sin	PROC
		push	rbp
		mov	rbp,	rsp
		push	rcx
		mov	rcx,	PIE_HALF
		fld	qword ptr [rcx]
		fld	qword ptr [rsp]
		fsubp
		fstp	qword ptr [rsp]
		pop	rcx
		call	cos	
		mov	rsp,	rbp
		pop	rbp
		ret
	sin	ENDP
; --------------------------------------------------------------------------------
;  PROCEDURE
;	Name		: cosrad
;	Description	: Takes the cosine function of an angle in radians
;
;	Parametres:	rcx = angle
;	Returns	  :	value of result	
; --------------------------------------------------------------------------------
	cosrad	PROC
		push	rbp
		mov	rbp,	rsp
		push	rcx
		fld	qword ptr [rsp]
		fcos
		fstp	qword ptr [rsp]
		pop	rax
		mov	rsp,	rbp	
		pop	rbp
		ret
	cosrad	ENDP
; --------------------------------------------------------------------------------
;  PROCEDURE
;	Name		: cos
;	Description	: Takes the cosine function of an angle
;
;	Parametres:	rcx = angle
;	Returns	  :	value of result	
; --------------------------------------------------------------------------------
	cos	PROC
		push	rbp
		mov	rbp,	rsp
		call	deg2rad
		push	rax
		fld	qword ptr [rsp]
		fcos
		fstp	qword ptr [rsp]
		pop	rax	
		pop	rbp
		ret
	cos	ENDP
; --------------------------------------------------------------------------------
;  PROCEDURE
;	Name		: pie
;	Description	: Calculates the value of pie.
;
;	Parametres	: None
;	Returns		: value of pie.
; --------------------------------------------------------------------------------
	pie	PROC
		push	rbp
		mov	rbp,	rsp
		mov	rax,	qword ptr [PIE_DIVISOR_NUMERATOR]
		push	rax
		mov	rax,	qword ptr [PIE_DIVISOR_DENUMERATOR]
		push	rax
		fld	qword ptr [rsp + SIZEOF qword]		; st0 containg 22.0
		fld	qword ptr [rsp]				; pushing 22.0 to st1, st0 containg 7.0
		fdivp						; st0 containing the value of pie
		push	0
		fstp	qword ptr [rsp]				; storing pie temporary
		pop	rax
		mov	rsp,	rbp
		pop	rbp
		ret
	pie	ENDP
; --------------------------------------------------------------------------------
;  PROCEDURE
;	Name		: deg2rad
;	Description	: Converts Angles in degress to angle in radians.
;
;	Parametres	: rcx = angle in degrees
;	Returns		: angle in radians
; --------------------------------------------------------------------------------
	deg2rad	PROC
		push	rbp
		mov	rbp,	rsp
		push	rcx
		mov	rax,	qword ptr [PIE_ANGLE_DEGREE]
		push	rax
		call	pie
		push	rax
		fld	qword ptr [rsp]				; loading pie
		fld	qword ptr [rsp + (SIZEOF qword * 1)]	; loading 180
		fdivp						; st0 containg the pie / 180
		fstp	qword ptr [rsp]				; storing pie/180 temporary
		fld	qword ptr [rsp + (SIZEOF qword * 2)]	; angle in degrees in st0
		fld	qword ptr [rsp]				; pushing angle in degress to st1, st0 containg the pie/180
		fmulp						; st0 containg the angle in radians
		fstp	qword ptr [rsp]				; rsp point to the angle in radians
		pop	rax
		mov	rsp,	rbp
		pop	rbp
		ret
	deg2rad	ENDP
; --------------------------------------------------------------------------------
;  PROCEDURE
;	Name		: fctril
;	Description	: Takes the factorial of a given number.
;
;	Parametres:	rcx = the number for which the facortial to take
;	Returns	  :	factorial of the number.
; --------------------------------------------------------------------------------
	fctril	PROC
		push	rbp
		mov	rbp,	rsp
		push	rsi
		xor	rsi,	rsi
		mov	rax,	rsi
		inc	rsi
		inc	rcx
		mov	rax,	rsi
		DURING:
			cmp	rsi,	rcx
			je	DONE
			imul	rax,	rsi
		DONE:
		pop	rsi
		pop	rbp
		ret
	fctril	ENDP

; vim:ft=masm
