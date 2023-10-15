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
		imul	rcx,	rdx
		imul	rcx,	r8
		; obtaining dot
		mov	rax,	qword ptr [r9 + rcx]

		; cleaning up stack
		pop	rbp
		; returning to caller
		ret
	get3dd	ENDP
; -------------------------------------------------------------------------------------
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

;	Returns:	
; -------------------------------------------------------------------------------------
	drw3dspce	PROC
		; setting up stack
		push	rbp
		mov	rbp,	rsp

		; retriving stack parametres
		mov	r10,	qword ptr [rsp + 16]

		; initial draw in local space
		push	rcx
		push	rdx
		push	r8
		push	r9
		push	r10
		mov	rcx,	r9
		mov	r8,	r10
		call	_initdrw
		pop	r10
		pop	r9
		pop	r8
		pop	rdx
		pop	rcx	

		; restoring stack
		pop	rbp
		; returning to caller
		ret
	drw3dspce	ENDP

	_initdrw	PROC
		; setting up stack
		push	rbp
		mov	rbp,	rsp
		
		; enumerating mesh dots
		; saving buffer registers
		push	rbx
		; saving counters
		push	rsi
		push	rdi
		; clearing counters
		xor	rsi,	rsi
		mov	rdi,	rsi
		DURING:
			cmp	rsi,	r8
			je	DONE
			; getting current dot
			mov	rbx,	qword ptr [r8 + rdi]
			; ________________________________________________
			; -------------- > In Complete < ----------------;
			; ________________________________________________	
			; adding offset to point to next dot
			add	rdi_SIZE
			; contineuing loop
			jmp	DURING
		DONE:
			nop
		; restoring counters
		pop	rdi
		pop	rsi	
		pop	rbx	

		; resotring stack	
		pop	rbp
		; returning to caller
		ret
	_initdrw	ENDP

	_trnspos	PROC
		; setting up stack
		push	rbp
		mov	rbp,	rsp
	
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
			