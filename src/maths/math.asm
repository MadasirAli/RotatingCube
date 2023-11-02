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
;	Name		: rad2deg
;	Description	: Converts radians to degrees
;
;	Parametres	: rcx = angle in radians
;	Returns		: angle in degrees
; --------------------------------------------------------------------------------
rad2deg	PROC	
		push	rbp
		mov	rbp,	rsp
		push	rcx				
		mov	rax,	qword ptr [PIE_ANGLE_DEGREE]
		push	rax
		mov	rax,	qword ptr [PIE_DIVISOR_NUMERATOR]
		push	rax
		mov	rax,	qword ptr [PIE_DIVISOR_DENUMERATOR]
		push	rax
		push	0					; angle in radians
		fld	qword ptr [rsp + (SIZEOF qword * 2)]	; st0 containg 22.0
		fld	qword ptr [rsp + (SIZEOF qword * 1)]	; pushing 22.0 to st1, st0 containg 7.0
		fdivp						; st0 containing the value of pie
		fstp	qword ptr [rsp]				; storing pie temporary	
		fld	qword ptr [rsp + (SIZEOF qword * 3)]	; loading 180
		fld	qword ptr [rsp]				; loading pie
		fdivp						; st0 containg the pie / 180
		fstp	qword ptr [rsp]				; storing pie/180 temporary
		fld	qword ptr [rsp + (SIZEOF qword * 4)]	; angle in degrees in st0
		fld	qword ptr [rsp]				; pushing angle in degress to st1, st0 containg the pie/180
		fmulp						; st0 containg the angle in radians
		fstp	qword ptr [rsp]				; rsp point to the angle in radians
		pop	rax
		pop	rcx
		pop	rcx
		pop	rcx
		pop	rcx
		pop	rbp
		ret
rad2deg	ENDP
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
	mov	rsp,	rbp
	call	cos
	push	rax	; cos0
	call	sin
	push	rax	; sin0
	fld	qword ptr [rsp + SIZEOF qword]		; cos0
	fld	qword ptr [rsp]				; sin0
	fdivp
	push	0
	fstp	qword ptr [rsp]
	mov	rsp,	rbp	
	pop	rbp
	ret
atan	ENDP
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
		pop	rbp
		ret
	sin	ENDP
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
		mov	rax,	qword ptr [PIE_DIVISOR_NUMERATOR]
		push	rax
		mov	rax,	qword ptr [PIE_DIVISOR_DENUMERATOR]
		push	rax
		push	0					; angle in radians
		fld	qword ptr [rsp + (SIZEOF qword * 2)]	; st0 containg 22.0
		fld	qword ptr [rsp + (SIZEOF qword * 1)]	; pushing 22.0 to st1, st0 containg 7.0
		fdivp						; st0 containing the value of pie
		fstp	qword ptr [rsp]				; storing pie temporary
		fld	qword ptr [rsp]				; loading pie
		fld	qword ptr [rsp + (SIZEOF qword * 3)]	; loading 180
		fdivp						; st0 containg the pie / 180
		fstp	qword ptr [rsp]				; storing pie/180 temporary
		fld	qword ptr [rsp + (SIZEOF qword * 4)]	; angle in degrees in st0
		fld	qword ptr [rsp]				; pushing angle in degress to st1, st0 containg the pie/180
		fmulp						; st0 containg the angle in radians
		fstp	qword ptr [rsp]				; rsp point to the angle in radians
		pop	rax
		pop	rcx
		pop	rcx
		pop	rcx
		pop	rcx
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
