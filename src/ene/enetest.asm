INCLUDE 	3dspace.asm
INCLUDE		gmeobj.asm
INCLUDE		rstrizr.asm

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
		push	rbx
		push	r12
		push	r13
		push	r14
		push	r15
		push	rsi
		push	rdi

		; 1- Initial Draw
		call	initplne
		call	initspacs
		call	fillmesh
		mov	rcx,	DEFAULT_3D_MESH_DATA		; mesh data
		mov	rdx,	DEFAULT_3D_LOCAL_SPACE		; local space
		mov	r8,	DEFAULT_3D_MESH_DATA_COUNT	; mesh data length
		mov	r9,	TRANSFORM			; transform
		push		DEFAULT_3D_LOCAL_SPACE_SIZE	; size of local space
		call	_initdrw
		; 2- Rasterize
		mov	rcx,	1
		mov	rdx,	rcx
		mov	r8,	rcx
		mov	r9,	DEFAULT_3D_LOCAL_SPACE		; local space
		call	con3d22d
		; 3- Fill Buffer
		mov	rcx,	_2D_PLANE		; plane
		mov	rdx,	_2D_PLANE_SIZE		; plane size
		mov	r9,	DEFAULT_PIXEL_BUFFER	; pixel buffer	
		call	plne2pix

		; restoring non volatile registers
		pop	rdi
		pop	rsi
		pop	r15
		pop	r14
		pop	r13
		pop	r12
		pop	rbx
		
		; restoring stack
		pop	rbp
		; returning to caller
		ret
	enetst	ENDP

.data

; vim:ft=masm
