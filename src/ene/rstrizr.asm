.data

	; size of the screen place
	_2D_PLANE_SIZE_X		equ	32
	_2D_PLANE_SIZE_Y		equ	20

	MAX_DEPTH			equ	32
	
	_2D_PLANE_SIZE			equ	(_2D_PLANE_SIZE_X * _2D_PLANE_SIZE_Y)
	DEFAULT_PIXEL_BUFFER_SIZE	equ	_2D_PLANE_SIZE + _2D_PLANE_SIZE_X

	_2D_PLANE:
		qword	_2D_PLANE_SIZE			dup (0)

	DEFAULT_PIXEL_BUFFER:
		word 	DEFAULT_PIXEL_BUFFER_SIZE	dup (0)

.code
; -----------------------------------------------------------------------
;  PROCEDURE
;	Name		: plne2pix
;	Description	: Converts Raw Dots in the plane to Raw Pixels
;
;	Parametres:-
;	rcx = address of plane
;	rdx = size of plane
;	r8  = address to raw pixels buffer
;
;	Returns: None.
; -----------------------------------------------------------------------
	plne2pix	PROC
		; saving callers stack
		push	rbp
		; creating new stack frame
		mov	rbp,	rsp
		; saving non volatile registers
		push	rbp
		xor	rbp, rbp
		; setting counters
		push	rsi
		push	rdi
		xor	rsi,	rsi
		mov	rdi,	rsi
		; setting buffer register
		mov	rax,	rdi
		xor	r10,	r10	; will contain the current column count
		DURING:
			cmp	rsi,	_2D_PLANE_SIZE
			je	DONE

			mov	r9,	SIZEOF qword
			imul	r9, 	rsi				; r9 giving offset
			mov	rbx,	qword ptr [rcx + r9]		; containg the pointer to raw dot

			mov	ax,	word ptr [rbx]			; the pure pixel
			mov	word ptr [r8  + rdi], ax		; fitting in buffer

			inc	rsi
			add	rdi,	SIZEOF	word	

			inc	r10	
			cmp	r10,	_2D_PLANE_SIZE_X		; checking end row
			jne	DURING
			_PLNE2PIX_ADD_BREAK:
				xor	r10,	r10			; setting the column counter to 0, as next row will start
				mov	word ptr [r8 + rdi],	0Ah	; adding line break, to start new line
				add	rdi,	SIZEOF word
				jmp	DURING
			
		DONE:
		pop	rdi
		pop	rsi
		; restoring non volatile registers
		pop	rbp
		; restoring stack
		pop	rbp
		; returning to caller
		ret		
	plne2pix	ENDP
; -----------------------------------------------------------------------
;  PROCEDURE
;	Name		: con3d22d
;	Description	: Slices a 2d Plane from 3d space 
;
;	Parametres	:-
;	rcx = x coord
;	rdx = y coord
;	r8  = z coord
;	r9  = space
;	
;	Returns		: None
; -----------------------------------------------------------------------
	con3d22d	PROC
		; setting up stack
		push	rbp
		mov	rbp,	rsp

		; saving non volatile registers
		push	rsi	; x element
		push	rdi	; y element
		push	rbx	; next used as temp
		push	r9	; next used as temp
		
		; making a plane keeping the depth (z) constant
		; setting counters
		xor	rsi,	rsi	; x plane coord counter
		mov	rdi,	rsi	; y plane coord counter
		; buffer registers
		push	r11
		push	r12
		push	r13
		; saving starting coords
		mov	r11,	rcx	; starting space x coord
		mov	r12,	rdx	; starting space y coord
		mov	r13,	r8	; starting space z coord
		DURING:
			; getting each row one by one
			; incrementing x to get next element in row
			; incrementing y to get next row
			; both will be contrained to the plane size

			; rsi will contain the current x coord in plane
			; rdi will contain the current y coord in plane

			; by adding plane current coords to space coords will will enable to us to map both.
			
			; enumerating depth on current dot, while obtain we hit the surface
			; adding plane coords for mapping
			mov	r9,	r11	; using r9 as temp
			add	r9,	rsi
			mov	rcx,	r9	; adding x, to move towards right, making a line
			mov	r9,	r12	; using r9 as temp
			add	r9,	rdi
			mov	rdx,	r9	; adding y, to move towards up, making a line
			; both will make a plane
			; enumerating depth
			mov	rbx,	MAX_DEPTH	; containing max depth
			xor	r10,	r10		; containg current delta depth	
			DURING_DEPTH:
				; if max depth reached
				cmp	r10,	rbx
				je	_CON3D22D_EMPTY_DEPTH
				; getting dot at current depth
				push	rcx
				push	rdx
				push	r8
				push	r9
				push	r10
				push	r11
				mov	r8,	r13					; starting depth
				add	r8,	r10					; delta depth
				mov	r9,	qword ptr [rsp + (SIZEOF qword * 9)]	; space
				call	get3dd
				pop	r11
				pop	r10
				pop	r9
				pop	r8
				pop	rdx
				pop	rcx
				; checking if we hit a surface
				cmp	word ptr [rax],	0  
				; if we did not hit surface
				jne	_CON3D22D_OBTAIN_DOT
				inc	r10			; increasing depth
				mov	r9,	r13		; using r9 as temp
				add	r9,	r10
				mov	r8,	r9		; adding depth relative to starting depth
				jmp	DURING_DEPTH		; finding surface again

			; rax holding the pointer to current surface (raw) dot
			; cliping the dot on surface
			_CON3D22D_EMPTY_DEPTH:	
				mov	r9,	-1	; using r9 as signel for empty write
			_CON3D22D_OBTAIN_DOT:
				push	r15	
				xor	r15,	r15	; going to be used as temp holder for pixel
				push	r14	
				xor	r14,	r14 	; going to use as temp holder for surface's dot
				mov	r14,	rax	; rax holding current surface

				; obtaining the current planes dot
				push	rcx
				push	rdx
				push	r8
				push	r9
				push	r10
				push	r11
				mov	rcx,	rsi		; x coord
				mov	rdx,	rdi		; y coord
				mov	r8,	_2D_PLANE	; space
				call	get2dd
				pop	r11
				pop	r10
				pop	r9
				pop	r8
				pop	rdx
				pop	rcx

				; rax containg the pointer to current dot in plane
				; r14 containg the pointer to surface's dot
				; r9 will be the signle for empty write

				; obtaining pixel from surface's dot
				mov	r15d,	dword ptr [r14]	
				; checking empty write
				cmp	r9,	-1
				; writing to surface's pixel
				push	rax
				pushf
				xor	rax,	rax
				popf
				cmove	r15d,	eax			; null will be written on signel
				pop	rax
				mov	dword ptr [rax],	r15d

				pop	r14
				pop	r15
		
			; plane enumeration related
			_CON3D22D_INC_COLUMN:
				inc	rsi
				; checking if end of the row reached
				cmp	rsi,	_2D_PLANE_SIZE_X
				jne	DURING
			_CON3D22D_INC_ROW:
				inc	rdi				; moving to next row
				xor	rsi,	rsi			; moving to first element of first row
				cmp	rdi,	_2D_PLANE_SIZE_Y	; checking the end of rows
				jne	DURING 	 
		DONE:
			nop

		; restoring non volatile registers
		pop	r13
		pop	r12
		pop	r11
		pop	r9
		pop 	rbx
		pop	rdi	
		pop	rsi
	
		; restoring stack
		pop	rbp	
		ret
	con3d22d	ENDP

	initplne	PROC
		push	rbp
		mov	rbp,	rsp
		mov	rcx,	qword ptr [S_HEAP]
		mov	rdx,	0Ch
		mov	r8,	(_2D_PLANE_SIZE * RAW_DOT_SIZE)
		call	malloc
		push	rax
		push	rbx
		push	rsi
		xor	rsi,	rsi
		DURING:
			cmp	rsi,	_2D_PLANE_SIZE
			je	DONE
			mov	rax,	rsi
			imul	rax,	SIZEOF qword
			mov	rdx,	_2D_PLANE	
			add	rax, 	rdx
			mov	rbx,	rsi
			imul	rbx,	RAW_DOT_SIZE
			mov	rcx,	qword ptr [rsp + (SIZEOF qword * 2)]		
			add	rbx,	rcx
			mov	qword ptr [rax],	rbx
			inc 	rsi
			jmp	DURING
		DONE:
		pop	rsi
		pop	rbx
		pop	rax
		pop	rbp
		ret
	initplne	ENDP

; vim:ft=masm
