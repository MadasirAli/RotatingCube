.data	
	; size of spaces in 3 dimensions
	DEFAULT_3D_SPACE_SIZE_X		equ	60
	DEFAULT_3D_SPACE_SIZE_Y		equ	60
	DEFAULT_3D_SPACE_SIZE_Z		equ	60

	DEFAULT_3D_LOCAL_SPACE_SIZE_X	equ	60
	DEFAULT_3D_LOCAL_SPACE_SIZE_Y	equ	60
	DEFAULT_3D_LOCAL_SPACE_SIZE_Z	equ	60
	
	DEFAULT_3D_LOCAL_SPACE_SIZE	equ	(DEFAULT_3D_LOCAL_SPACE_SIZE_X * DEFAULT_3D_LOCAL_SPACE_SIZE_Y * DEFAULT_3D_LOCAL_SPACE_SIZE_Z)
	DEFAULT_3D_LOCAL_PLANE_SIZE	equ	(DEFAULT_3D_LOCAL_SPACE_SIZE_X * DEFAULT_3D_LOCAL_SPACE_SIZE_Y)

	DEFAULT_3D_SPACE_SIZE		equ	(DEFAULT_3D_SPACE_SIZE_X * DEFAULT_3D_SPACE_SIZE_Y * DEFAULT_3D_SPACE_SIZE_Z)
	DEFAULT_3D_PLANE_SIZE		equ	(DEFAULT_3D_SPACE_SIZE_X * DEFAULT_3D_SPACE_SIZE_Y)

	; Dot Strucutre
	DOT_SIZE	equ		28
	RAW_DOT_SIZE	equ		4
	RAW_DOT_OFFSET	equ		24

	TEST_ROTATION:
		qword	0.0	; x
		qword 	0.0	; y
		qword 	0.0	; z
	TEST_ROTATION_BUFFER:
		qword 	0	; x
		qword 	0 	; y
		qword 	0 	; z

	DOT:
		qword	0	; local_x_coordinates
		qword	0	; local_y_coordinates
		qword	0	; local_z_coordinates
		RAW_DOT:
			word	0	; pixel
			word	0	; background and front color

	; buffer to hold 3d space
	DEFAULT_3D_SPACE:
		qword	DEFAULT_3D_SPACE_SIZE		dup (0)
	
	; buffer to hold default 2d space
	DEFAULT_3D_LOCAL_SPACE:
		qword	DEFAULT_3D_LOCAL_SPACE_SIZE	dup (0)

.code
; -----------------------------------------------------------------------
;  PROCEDURE
;	Name		: get2dd
;	Description	: Gets the Dot from 2D plane from a given point
;
;	Parametres:-
;	rcx = x coord
;	rdx = y coord
;	r8  = pointer to 2d space strucure
;
;	Returns: pointer to dot
; -----------------------------------------------------------------------
	get2dd	PROC
		; saving caller's stack base
		push	rbp
		; creating new stack frame
		mov	rbp,	rsp
		
		; getting in linear space
		; Y * number of columns in 1 row
		; X will be column in that row
		imul	rdx,	_2D_PLANE_SIZE_X
		; now adding X
		add	rdx,	rcx
		
		; rescaling point by the size of a pointer (QWORD)
		imul	rdx,	SIZEOF qword

		; obtaining the dot pointer
		mov	rax, 	qword ptr [r8 + rdx]
		
		; restoring stack
		pop	rbp
		; returning to caller
		ret
	get2dd	ENDP
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

		; Z * number of planes in space
		; Y * number of columns
		imul	r8,	DEFAULT_3D_LOCAL_PLANE_SIZE
		imul	rdx,	DEFAULT_3D_LOCAL_SPACE_SIZE_X
		add	rcx,	rdx			; adding row offset
		add	rcx,	r8			; adding plane (depth) offset

		; rescaling to per dot size
		imul	rcx,	SIZEOF qword
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

		; ________ TRANSFORMING ___________

		; IN COMPLETE ______________________________________________	
;_______________________________ WARNING ________________________________________
;			    USING HACK ESCAPE

		jmp	HACK_ESCAPE

		; mapping to global space
		push	rcx		; transform
		push	rdx		; local space
		push	r8		; global space
		push	r9
		mov	r9,	r11	; size of local space
		push	r12		; size of global space
		call	_mp3dl2g
		pop	r9
		pop	r8
		pop	rdx
		pop	rcx

	HACK_ESCAPE:
;__________________________________________________________________________________

		; restoring stack
		pop	rbp
		; returning to caller
		ret
	drw3dspce	ENDP
; -----------------------------------------------------------------------------------
;  PROCEDURE (Internal)
;	Name		: _mp3dl2g
;	Description	: Maps a local space to world space with its position.
;
;	Parametres:-
;	rcx = transform
;	rdx = local space
;	r8  = global space
;	r9  = size of local space
;	Stack: qword length of global space
;
;	Returns: None.
; -----------------------------------------------------------------------------------
	_mp3dl2g	PROC
		; saving old stack
		push rbp
		; creating new stack frame
		mov	rbp,	rsp
		
		; saving non volatile registers
		push	rbx
		push	rsi
		push	rdi
		push	r9
		push	r10
		push	r11
		push	r12
		push	r13
		push	r14
		push	r15

		; cleaning global space
		push	rcx
		push	rdx
		mov	rcx,	r8			; global space
		mov	rdx,	qword ptr [rsp + 16]	; length of space
		call	_clenspce	
		pop	rdx
		pop	rcx
		
		; reading positions
		mov	r9,	qword ptr [rcx]		; transform x coord
		mov	r10,	qword ptr [rcx + 8]	; transform y coord
		mov	r11,	qword ptr [rcx + 16]	; transform z coord

		mov	r12,	1			; local position x coord
		mov	r13,	1			; local position y coord
		mov	r14,	1			; local position z coord

		; setting counters
		xor	rsi,	rsi			; global position x coord
		mov	rdi,	rsi			; global position y coord
		mov	r15,	rsi			; global position z coord
		DURING:
			; getting the current dot in local space
			push	rcx
			push	rdx
			push	r8
			push	r9
			push	r10
			push	r11
			mov	r9,	rdx	; local space
			mov	rcx,	r12	; x coord
			mov	rdx,	r13	; y coord
			mov	r8,	r14	; z coord
			call	get3dd
			pop	r11
			pop	r10
			pop	r9
			pop	r8
			pop	rdx
			pop	rcx

			; rax containg the pointer to current dot in local space
			; checking the current dot is empty
			mov	ebx,	dword ptr [rax]		; rbx containg the pixel
			cmp	ebx,	0			; checking 0 pixel
			je	_MP3DL2G_MOVE_NEXT		; skipping the empty dot
			mov	rbx,	rax
			
			; rbx containing the pointer to the current dot in local space

			; converting local coords to global coords
			; adding position offset to current dots
			mov	rsi,	r9		; rsi containing the transform x coord
			mov	rdi,	r10		; rdi containing the transform y coord
			mov	r15,	r11		; r15 containing the transform z coord
			add	rsi,	r12		; global position x = local space x + position x
			add	rdi,	r13		; global position y = local space y + position y
			add	r15,	r14		; global position z = local space z + position z

			; obtaining dot at the global position
			push	rcx
			push	rdx
			push	r8
			push	r9
			push	r10
			push	r11
			mov	r9,	r8	; global space
			mov	rcx,	rsi	; x coord
			mov	rdx,	rdi	; y coord
			mov	r8,	r15	; z coord
			call	get3dd
			pop	r11
			pop	r10
			pop	r9
			pop	r8
			pop	rdx
			pop	rcx

			; rax containg the current dot at global postion
			; rbx containing the current dot at local position
			push	rax
			push	rbx
			xor	rax,	rax			; using rax as temp
			mov	eax,	dword ptr [rsp] 	; eax containing the pixel of dot at local position
			mov	dword ptr [rsp + 8],	eax	; writing local space dot to global space
			pop	rbx
			pop	rax

			_MP3DL2G_MOVE_NEXT:
				nop

			_MP3DL2G_INC_X:
				inc	r12					; moving to next column
				cmp	r12,	DEFAULT_3D_LOCAL_SPACE_SIZE_X	; checking end of column reached
				jne	DURING
			_MP3DL2G_INC_Y:
				inc	r13					; moving to next row
				mov	r12,	1				; setting column to 1 again
				cmp	r13,	DEFAULT_3D_LOCAL_SPACE_SIZE_Y	; checkig end of row reached
				jne	DURING
			_MP3DL2G_INC_Z:
				inc	r14					; moving to nest depth
				mov	r13,	1
				cmp	r14,	DEFAULT_3D_LOCAL_SPACE_SIZE_Z	; checking end of depth reached
				jne	DURING
		DONE:
			nop

		; restoring non volatile registers
		pop	r15
		pop	r14
		pop	r13
		pop	r12
		pop	r11
		pop	r10
		pop	r10
		pop	rdi	
		pop	rsi
		pop	rbx
		; restoring stack
		pop	rbp
		; returning to caller
		ret
	_mp3dl2g	ENDP	
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
		push	r8
		push	r9
		mov	rcx,	rdx		; pointer to space
		mov	rdx,	r15		; length of space
		call	_clenspce	
		pop	r9
		pop	r8
		pop	rdx
		pop	rcx

		; enumerating mesh dots
		; saving non volatile registers
		push	rbx
		push	r14
		; saving counters
		push	rsi	; holding count
		; clearing counters
		xor	rsi,	rsi
		mov	rdi,	rsi
		; setting current buffer pointer to dots
		mov	rbx,	rcx
		DURING:
			cmp	rsi,	r8
			je	DONE
			mov	r14,	qword ptr [rbx]		; r14 holding the pointer to current dot
;---------------------------------------------------------------------------------------------------------
			push	rax
			push	rcx
			mov	rcx,	r14
			call	_transrot
			pop	rcx
			pop	rax
;---------------------------------------------------------------------------------------------------------
			; reading current dot coordinates
			mov	r10,	qword ptr [r14]				; dot's x coord
			mov	r11,	qword ptr [r14 + SIZEOF qword] 		; dot's y coord
			mov	r12,	qword ptr [r14 + (SIZEOF qword * 2)]	; dot's z coord
			; adding rotational transformations
			mov	r10,	qword ptr [TEST_ROTATION_BUFFER]	
			add	r10,	GAMEOBJECT_POSITION_X
			mov	r11,	qword ptr [TEST_ROTATION_BUFFER + (SIZEOF qword)]
			add	r11,	GAMEOBJECT_POSITION_Y
			;add	r12,	qword ptr [TEST_ROTATION_BUFFER + (SIZEOF qword * 2)]
			; getting coordinate in linear space
			push	rcx
			push	rdx
			push	r8
			push	r9
			push	r10
			push	r11
			push	r14
			push	r15
			mov	r9,	rdx	; pointer to local space
			mov	rcx,	r10	; x coord
			mov	rdx,	r11	; y coord
			mov	r8,	r12	; z coord
			call	get3dd
			pop	r15
			pop	r14
			pop	r11
			pop	r10
			pop	r9
			pop	r8
			pop	rdx
			pop	rcx
			; rax holding pointer to current local space's dot
			; getting current dot pixel and color
			xor	r13,	r13
			mov	r13d,	dword ptr [r14 + RAW_DOT_OFFSET]
			; there will never a empty pixel
			mov	dword ptr [rax], 	r13d	; writing the mesh pixel and color at local space	
			; adding offset to point to next pointer in mesh data
			add	rbx,	SIZEOF qword
			inc	rsi
			; contineuing loop
			jmp	DURING
		DONE:
			nop
		; restoring counters
		pop	rsi	
		; restoring non volatile registers
		pop	rbx
		pop	r14	

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
			; rcx pointing in list in dots
			mov	rax,	qword ptr [rcx]		; rax pointing to current dot
			; setting current dot to 0
			mov	dword ptr [rax],	0	; word char code, word color
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

; -------------------------------------------------------------------------
;  PROCEDURE
;	Name		: initspacs
;	Description	: Initializes Spaces
;
;	Parametres	: None.
;
;	Returns		: None.
; -------------------------------------------------------------------------
	initspacs	PROC
		push	rbp
		mov	rbp,	rsp
		; allocating memory in heap
		mov	rcx,	qword ptr [S_HEAP]
		push	rcx
		mov	rdx,	0Ch
		mov	r8,	(DEFAULT_3D_LOCAL_SPACE_SIZE * RAW_DOT_SIZE)
		call	malloc
		pop	rcx
		; rax containg the first dot of local space
		push	rax
		mov	rdx,	0Ch
		mov	r8,	(DEFAULT_3D_SPACE_SIZE * RAW_DOT_SIZE)	
		call	malloc
		; rax containing the first dot of global space
		push	rax
		; filling array of spaces
		; filling global space
		; setting counters
		push	rsi
		push	rbx
		xor	rsi,	rsi
		mov	rbx,	rsi
		mov	rax,	rsi
		DURING_GLOBAL:
			cmp	rsi,	DEFAULT_3D_SPACE_SIZE
			je	DONE_GLOBAL
			mov	rbx,	rsi
			imul	rbx,	SIZEOF qword
			; rbx containing the offset to current index in array
			mov	rax,	rsi
			imul	rax,	RAW_DOT_SIZE
			; rax containing the offset to current raw dot
			mov	rcx,	qword ptr [rsp + (SIZEOF qword * 2)]
			; rax containing base of dots in memory of global space
			; writing the dots address in array
			add	rcx,	rax						; rax containing the address of the dot
			mov	qword ptr [rbx + DEFAULT_3D_SPACE],	rcx
			inc	rsi
			jmp	DURING_GLOBAL	
		DONE_GLOBAL:
			pop	rbx
			pop	rsi
		; filling local space
		; setting counters
		push	rsi
		push	rbx
		xor	rsi,	rsi
		mov	rbx,	rsi
		mov	rax,	rsi
		DURING_LOCAL:
			cmp	rsi,	DEFAULT_3D_LOCAL_SPACE_SIZE
			je	DONE_LOCAL
			mov	rbx,	rsi
			imul	rbx,	SIZEOF qword
			; rbx containing the offset to current index in array
			mov	rax,	rsi
			imul	rax,	RAW_DOT_SIZE
			; rax containing the offset to current raw dot
			mov	rcx,	qword ptr [rsp + (SIZEOF qword * 3)]
			; rax containing base of dots in memory of global space
			; writing the dots address in array
			add	rcx,	rax						; rax containing the address of the dot
			mov	qword ptr [rbx + DEFAULT_3D_LOCAL_SPACE],	rcx
			inc	rsi
			jmp	DURING_LOCAL
		DONE_LOCAL:
			pop	rbx
			pop	rsi
		pop	rax
		pop	rax

		pop	rbp
		ret
	initspacs	ENDP
	
	_transrot	PROC
		push	rbp
		push	rbx
		mov	rbp,	rsp
		; currently only transforming roation along z
		; reading coordinates
		mov	rax,	qword ptr [rcx]				; x coord
		sub	rax,	GAMEOBJECT_POSITION_X
		push	rax
		mov	rax,	qword ptr [rcx + SIZEOF qword]		; y coord
		sub	rax,	GAMEOBJECT_POSITION_Y
		push	rax
		; getting magnitude
		; getting x position from its centre
		mov	rbx,	GAMEOBJECT_SIZE_X
		shr	rbx,	1					; centre coord
		mov	rax,	qword ptr [rsp + (SIZEOF qword)]	; x coord
		sub	rax,	rbx					; position from centre
		push	rax	
		; getting y position from centre
		mov	rbx,	GAMEOBJECT_SIZE_Y
		shr	rbx,	1					; centre coord
		mov	rax,	qword ptr [rsp + SIZEOF qword]	        ; y coord
		sub	rax,	rbx					; position from centre
		push	rax

		fild	qword ptr [rsp]	; y pos
		fild	qword ptr [rsp] ; y pos
		fmulp			; y pos * y pos
		push	0
		fstp	qword ptr [rsp]
		fild 	qword ptr [rsp + (SIZEOF qword * 2)]	; x pos
		fild	qword ptr [rsp + (SIZEOF qword * 2)]	; x pos
		fmulp						; x pos * x pos
		push	0
		fstp	qword ptr [rsp]
		fld	qword ptr [rsp]	; x squr
		fld	qword ptr [rsp + SIZEOF qword] ; y squr
		faddp
		fsqrt
		push	0
		fstp	qword ptr [rsp]	; magnitude		
		

		; getting cos0 => cos(ROTATION_Z)
		push	rcx
		mov	rcx,	qword ptr [TEST_ROTATION + (SIZEOF qword * 2)]	; z rotation
		call	cos
		pop	rcx
		push	rax
		
		; getting Xcos0
		fld	qword ptr [rsp]				; cos0
		fld	qword ptr [rsp + (SIZEOF qword)]	; magnitude
		fmulp
		push	0
		fistp	qword ptr [rsp]

		;  filling new x position
		mov	rbx, 	GAMEOBJECT_SIZE_X
		shr	rbx,	1
		mov	rax,	qword ptr [rsp]	
		;add	rax,	rbx
		push	rcx
		mov	rcx,	qword ptr [rsp + (SIZEOF qword * 7)]
		cmp	rcx,	1
		jnl	X_NOT_LESS
		imul	rax,	-1
		X_NOT_LESS:
		pop	rcx
		add	rax,	rbx

		mov	qword ptr [TEST_ROTATION_BUFFER],	rax

		; resolving its new y position

		
		; getting sin0 => sin(ROTATION_Z)
		push	rcx
		mov	rcx, 	qword ptr [TEST_ROTATION + (SIZEOF qword * 2)]	; z rotation
		call	sin
		pop	rcx
		push	rax

		; getting Ysin0
		fld	qword ptr [rsp]				; sin0
		fld	qword ptr [rsp + (SIZEOF qword * 3)]	; magnitude
		fmulp
		push	0
		fistp	qword ptr [rsp]

		; filling new y position
		mov	rbx,	GAMEOBJECT_SIZE_Y
		shr	rbx,	1
		mov	rax,	qword ptr [rsp]
		push	rcx
		mov	rcx,	qword ptr [rsp + (SIZEOF qword * 9)]
		cmp	rcx,	0
		jnl	Y_NOT_LESS
		imul	rax,	-1
		Y_NOT_LESS:
		pop	rcx
		add	rax,	rbx
		mov	qword ptr [TEST_ROTATION_BUFFER + (SIZEOF qword)],	rax
		
		mov	rax,	TEST_ROTATION_BUFFER

		mov	rsp,	rbp
		pop	rbx
		pop	rbp
		ret	
	_transrot	ENDP

; vim:ft=masm
			
