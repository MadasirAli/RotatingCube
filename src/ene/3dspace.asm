.code
; -----------------------------------------------------------------------
;  PROCEDURE
;	Name		: get3dd
;	Description	: Gets the Dot from 3D space from given coordinates.
;
;	^		
;	J
;			^
;	^		k
;	|            .
;	|         . 
;	|      .
;	|   .
;	|.		  ^
;      -----------------> i
;      0|
;	Parametres:-
;	rcx = coordinates in X
;	rdx = coordinates in Y
; 	r8  = coordinate in Z
;	r9  = address of the space
;
;	Returns:	The Address of the deried dot.
; ----------------------------------------------------------------------
	get3dd	PROC
		; setting up stack
		push	rbp
		mov	rbp,	rsp
		
		; getting dot offset in linear from 3d coordinates
		imul	rcx,	r10
		imul	rcx,	r10
		; obtaining dot
		mov	rax,	qword ptr [r9 + rcx]

		; cleaning up stack
		pop	rbp
		; returning to caller
		ret
	get3dd	ENDP
; ------------------------------------------------------------------------------------
;  PRODECURE
;	Name		: drw3dspce
;	Description	: Rewrites the Local 3D space
;
;	Parametres:-
;	rcx = pointer to transform
;	rdx = pointer to local space
;	r8  = pointer to global space
;	r9  = pointer to 3d space mesh data
;	Stack:	size of the mesh data
;		size of local space
;	 	size of global space
;
;	Returns:	
; ------------------------------------------------------------------------------------
	drw3dspce	PROC
		; setting up stack
		push	rbp
		mov	rbp,	rsp

		; retriving stack parametres
		mov	r10,	qword ptr [rsp + 16]	; size of mesh data
		mov	r11,	qword ptr [rsp + 24]	; size of local space
		mov	r12,	qword ptr [rsp + 32]	; size of global space

		; initial draw in local space
		push	rcx
		push	rdx
		push	r8
		push	r9
		push	r10
		push	r11
		push	r12
		mov	r11,	rcx
		mov	rcx,	r9	; mesh data
		mov	rdx,	rdx	; local space
		mov	r8,	r10	; mesh data dots count
		mov	r9,	r11	; transform
		push	r11		; size of local space
		call	_initdrw
		pop	r12
		pop	r11
		pop	r10
		pop	r9
		pop	r8
		pop	rdx
		pop	rcx

		; cleaning parametre from stack
		sub	rsp,	8

		; IN COMPLETE ______________________________________________	

		; restoring stack
		pop	rbp
		; returning to caller
		ret
	drw3dspce	ENDP

; -----------------------------------------------------------------------------------
;  PROCEDURE (Internal)
;	Name		: _initdrw
;	Description	: Redraws the mesh in local space without transformations.
;
;	Parametres	:-
;	rcx = pointer to mesh data
;	rdx = pointer to local space
;	r8  = mesh data length
;	r9  = pointer to transform
;	Stack:-	size of local space
;
;	Returns		: NONE
; -----------------------------------------------------------------------------------
	_initdrw	PROC
		; setting up stack
		push	rbp
		mov	rbp,	rsp

		; retriving stack parametres
		mov	r15,	qword ptr [rsp + 16]	; size of local space

		; saving volatile registers (are currently holding parametres for this procedure)
		push	rcx
		push	rdx
		mov	rcx,	rdx
		mov	rdx,	r15
		call	_clenspce	
		pop	rdx
		pop	rcx
		
		; enumerating mesh dots
		; saving non volatile registers
		push	rbx
		; saving counters
		push	rsi	; holding count
		; clearing counters
		xor	rsi,	rsi
		mov	rdi,	rsi
		DURING:
			cmp	rsi,	r8
			je	DONE
			; rbx pointing to next dot
			; reading current dot coordinates
			mov	r10,	qword ptr [rbx]		; dot's x coord
			mov	r11,	qword ptr [rbx + 8] 	; dot's y coord
			mov	r12,	qword ptr [rbx + 16]	; dot's z coord
			; ________________________________________________
			; -------------- > In Complete < ----------------;
			; getting coordinate in linear space
			imul	r10,	r11
			imul	r10,	r12	; product of 3 coordinates (x * y * z)
			; getting current dot pixel and color
			xor	r13,	r13
			mov	r13d,	dword ptr [rbx + 24]
			mov	dword ptr [rdx + r10], 	r13d	; writing the mesh pixel and color at 		
			; ________________________________________________	
			; adding offset to point to next pointer
			add	rcx,	SIZEOF qword
			; contineuing loop
			jmp	DURING
		DONE:
			nop
		; restoring counters
		pop	rsi	
		; restoring non volatile registers
		pop	rbx	

		; resotring stack	
		pop	rbp
		; returning to caller
		ret
	_initdrw	ENDP

; ----------------------------------------------------------------------------------
;  PROCEDURE (Internal)
;	Name		: _clenspce
;	Description	: Overwrites the given space to 0
;
;	Parametres	:-
;	rcx = pointer to space
; 	rdx = length of space
;
;	Returns		: NONE
; ----------------------------------------------------------------------------------
	_clenspce	PROC
		; saving callers stack
		push	rbp
		; creating new stack frame
		mov	rbp,	rsp

		; saving non volatile registers
		push	rsi
		
		; iternating through space
		; setting counters
		xor	rdi,	rdi	; offset
		DURING:
			cmp	rsi,	rdx
			je	DONE
			; rcx pointing to current dot
			; setting current dot to 0
			mov	dword ptr [rcx],	0	; word char code, word color
			inc	rsi
			add	rcx,	SIZEOF qword
			jmp	DURING
		DONE:
			nop

		; restoring non volatile registers
		pop	rsi

		; restoring stack
		pop rbp
		; returning to caller
		ret
	_clenspce	ENDP

	_trnspos	PROC
		; setting up stack
		push	rbp
		mov	rbp,	rsp
		; IN COMPLETE _____________________________________	
		; resotring stack
		pop	rbp
		; returning to caller
		ret
	_trnspos	ENDP

.data	
	; size of spaces in 3 dimensions
	DEFAULT_3D_SPACE_SIZE_X		equ	256
	DEFAULT_3D_SPACE_SIZE_Y		equ	256
	DEFAULT_3D_SPACE_SIZE_Z		equ	256
	DEFAULT_3D_LOCAL_SPACE_SIZE_X	equ	64
	DEFAULT_3D_LOCAL_SPACE_SIZE_Y	equ	64
	DEFAULT_3D_LOCAL_SPACE_SIZE_Z	equ	64

	; Dot Strucutre
	DOT_SIZE	equ		28
	RAW_DOT_SIZE	equ		4
	DOT:
		qword	0	; local_x_coordinates
		qword	0	; local_y_coordinates
		qword	0	; local_z_coordinates
		RAW_DOT:
			word	0	; pixel
			word	0	; background and front color

	; buffer to hold 3d space
	DEFAULT_3D_SPACE:
		qword	((DEFAULT_3D_SPACE_SIZE_X * DEFAULT_3D_SPACE_SIZE_Y * DEFAULT_3D_SPACE_SIZE_Z) * 1)	dup (0)
	
	; LOCAL SPACE STRUCTURE
	DEFAULT_3D_LOCAL_SPACE:
		qword	0	; x-dimensions
		qword	0	; y-dimensions
		qword	0 	; z-dimensions
		qword	0	; pointer to raw space

; vim:ft=masm
			
