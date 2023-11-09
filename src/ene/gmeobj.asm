.data
	; TRANSFORM
	TRANSFORM_SIZE			equ	144
	TRANSFORM_GLOBALS_OFFSET	equ	72
	TRANSFORM:
		qword	0	;	local_x_position
		qword	0	;	local_y_position
		qword	0	;	local_z_position
		qword	0	;	local_x_angles
		qword	0	;	local_y_angles
		qword	0	;	local_z_angles
		qword	0	;	local_x_scale
		qword	0	;	local_y_scale
		qword	0	;	local_z_scale
		qword	0	;	global_x_postion
		qword	0	;	global_y_position
		qword	0	;	global_z_position
		qword	0	;	global_x_angles
		qword	0	;	global_y_angles
		qword	0	;	global_z_angles
		qword	0	;	global_x_scale
		qword	0	;	global_y_scale
		qword	0	;	global_z_scale

	GAMEOBJECT_SIZE_X		equ	120
	GAMEOBJECT_SIZE_Y		equ	100
	GAMEOBJECT_SIZE_Z		equ	1

	GAMEOBJECT_POSITION_X		equ	60
	GAMEOBJECT_POSITION_Y		equ	50
	GAMEOBJECT_POSITION_Z		equ	30

	DEFAULT_3D_MESH_DATA_COUNT	equ	(GAMEOBJECT_SIZE_X * GAMEOBJECT_SIZE_Y * GAMEOBJECT_SIZE_Z)
	DEFAULT_3D_MESH_DATA:	
		qword	DEFAULT_3D_MESH_DATA_COUNT dup(0)	; pointer to its 3D mesh data


.code
	fillmesh	PROC
		push	rbp
		mov	rbp,	rsp

		call	_initmsh

		pop	rbp
		ret
	fillmesh	ENDP
	_initmsh	PROC
		push	rbp
		mov	rbp,	rsp
		push	rsi
		push	rbx
		xor	rsi,	rsi
		mov	r8,	rsi	; x
		mov	r9,	rsi	; y
		mov	r10,	rsi	; z
		mov	r8,	GAMEOBJECT_POSITION_X
		mov	r9,	GAMEOBJECT_POSITION_Y
		mov	r10,	GAMEOBJECT_POSITION_Z
		DURING:
			cmp	rsi,	DEFAULT_3D_MESH_DATA_COUNT
			je 	DONE

			push	r8
			push	r9
			push	r10
		
			mov	rcx,	qword ptr [S_HEAP]
			mov	rdx,	0Ch
			mov	r8,	DOT_SIZE
			call	malloc

			pop	r10
			pop	r9
			pop	r8

			mov	rbx,	rax

			mov	rax,	rsi
			imul	rax,	SIZEOF qword

			mov	qword ptr [rbx],	r8		; x position of current mesh data
			mov	qword ptr [rbx + 8],	r9		; y position of current mesh data
			mov	qword ptr [rbx + 16], 	r10		; z position of current mesh data

			mov	word ptr [rbx + RAW_DOT_OFFSET],	2588h			; filling the space with block
			mov	qword ptr [rax + DEFAULT_3D_MESH_DATA],	rbx 
			inc	rsi
		
			inc	r8
			cmp	r8,	(GAMEOBJECT_POSITION_X + GAMEOBJECT_SIZE_X)
			jne	DURING
			mov	r8,	GAMEOBJECT_POSITION_X
			inc	r9
			cmp	r9,	(GAMEOBJECT_POSITION_Y + GAMEOBJECT_SIZE_Y)
			jne	DURING
			mov	r9,	GAMEOBJECT_POSITION_Y
			inc	r10

			jmp	DURING
		DONE:
		pop	rbx
		pop	rsi
		pop	rbp
		ret
	_initmsh	ENDP
	
; vim:ft=masm	
