INCLUDE 	3dspace.asm
INCLUDE		gmeobj.asm
INCLUDE		rstrizr.asm

.data
	SLEEP_TIME	equ	1		; ms
	PER_FRAME_ROT_CHANGE:
		qword	1.0

	BUFFER_SMALL_RECT:
		word	0
		word	0
		word	_2D_PLANE_SIZE_X
		word	_2D_PLANE_SIZE_Y
	BUFFER_POSITION_COORD:
		word	0
		word	0
	BUFFER_SIZE_COORD:
		word	_2D_PLANE_SIZE_X
		word	_2D_PLANE_SIZE_Y		

.code
; ---------------------------------------------------------------------------------------
;  PROCEDURE
;	Name		: enetst
;	Description	: Runs the current functionality of the engine.
;
;	Parametres	:- None.
;	
;	Returns		: None.
; ---------------------------------------------------------------------------------------
	enetst	PROC
		; setting stack
		push	rbp
		mov	rbp,	rsp

		; saving non volatile registers
		push	rax
		push	rbx
		push	rcx
		push	rdx
		push	r8
		push	r9
		push	r10
		push	r11
		push	r12
		push	r13
		push	r14
		push	r15
		push	rsi
		push	rdi

		; initializing spaces
		call	initplne
		call	initspacs
		call	fillmesh

		DURING:
		; adding z rotation angle
		mov	rax,	qword ptr [PER_FRAME_ROT_CHANGE]
		push	rax
		mov	rax,	qword ptr [TEST_ROTATION + (SIZEOF qword * 2)]	; z rot
		push	rax
		fld	qword ptr [rsp]
		fld	qword ptr [rsp + SIZEOF qword]
		faddp
		fstp	qword ptr [rsp]
		pop	rax
		mov	qword ptr [TEST_ROTATION + (SIZEOF qword * 2)], rax
		pop	rax

		; adding x rotation angle
		mov	rax,	qword ptr [PER_FRAME_ROT_CHANGE]
		push	rax
		mov	rax,	qword ptr [TEST_ROTATION]	; x rot
		push	rax
		fld	qword ptr [rsp]
		fld	qword ptr [rsp + SIZEOF qword]
		faddp
		fstp	qword ptr [rsp]
		pop	rax
		mov	qword ptr [TEST_ROTATION], rax
		pop	rax

		; adding y rotation angle
		mov	rax,	qword ptr [PER_FRAME_ROT_CHANGE]
		push	rax
		mov	rax,	qword ptr [TEST_ROTATION + SIZEOF qword]	; y rot
		push	rax
		fld	qword ptr [rsp]
		fld	qword ptr [rsp + SIZEOF qword]
		faddp
		fstp	qword ptr [rsp]
		pop	rax
		mov	qword ptr [TEST_ROTATION + SIZEOF qword], rax
		pop	rax

		; 1- Initial Draw
		mov	rcx,	DEFAULT_3D_MESH_DATA		; mesh data
		mov	rdx,	DEFAULT_3D_LOCAL_SPACE		; local space
		mov	r8,	DEFAULT_3D_MESH_DATA_COUNT	; mesh data length
		mov	r9,	TRANSFORM			; transform
		push		DEFAULT_3D_LOCAL_SPACE_SIZE	; size of local space
		call	_initdrw
		; cleaning stack param
		pop	rcx
		; 2- Rasterize
		mov	rcx,	0
		mov	rdx,	rcx
		mov	r8,	rcx
		mov	r9,	DEFAULT_3D_LOCAL_SPACE		; local space
		call	con3d22d
		; 3- Fill Buffer
		mov	rcx,	_2D_PLANE
		mov	rdx,	_2D_PLANE_SIZE
		mov	r8,	DEFAULT_CHARACTER_BUFFER
		call	plne2chr
;		mov	rcx,	_2D_PLANE		; plane
;		mov	rdx,	_2D_PLANE_SIZE		; plane size
;		mov	r8,	DEFAULT_PIXEL_BUFFER	; pixel buffer	
;		call	plne2pix

		;4- Render
		; setting cursor position to start
		mov	rcx,	qword ptr [stdHnd]
		xor	rdx,	rdx	
		call	stcrsrps


		; Writing buffer full of wide characters
		mov	rcx,	qword ptr [stdHnd]
		mov	rdx,	DEFAULT_CHARACTER_BUFFER
		xor	r8,	r9
		mov	r9,	r8
		mov	r8d,	dword ptr [BUFFER_SIZE_COORD]
		mov	r9d,	dword ptr [BUFFER_POSITION_COORD]
		mov	rax,	BUFFER_SMALL_RECT
		push	rax
		call	wrteconoutw
		pop	rax


;		mov	rcx,	qword ptr [stdHnd]		; handle to console
;		mov	rdx,	DEFAULT_PIXEL_BUFFER		; buffer of wide characters
;		mov	r8,	DEFAULT_PIXEL_BUFFER_SIZE 	; number of chracters to write
;		mov	r9,	tmp				; current numbers of characters written
;		push	0					; reserved
;		call	wrteconw	
;		add	rsp,	8				; cleaning stack parametre

		; sleeping
		mov	rcx,	SLEEP_TIME
		call	slp
		
		jmp	DURING
		
		; restoring non volatile registers
		pop	rdi
		pop	rsi
		pop	r15
		pop	r14
		pop	r13
		pop	r12
		pop	r11
		pop	r10
		pop	r9
		pop	r8
		pop	rdx
		pop	rcx
		pop	rbx
		pop	rax
		; restoring stack
		pop	rbp
		; returning to caller
		ret
	enetst	ENDP
; vim:ft=masm
