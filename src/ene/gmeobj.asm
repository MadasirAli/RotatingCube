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

	DEFAULT_3D_MESH_DATA_COUNT	equ	60
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
		sub	rsp,	32
		mov	rcx,	qword ptr [S_HEAP]
		mov	rdx,	0Ch
		mov	r8,	(DOT_SIZE * DEFAULT_3D_MESH_DATA_COUNT)
		call	malloc
		add	rsp,	32
		push	rax
		push	rsi
		push	rbx
		xor	rsi,	rsi
		DURING:
			cmp	rsi,	DEFAULT_3D_MESH_DATA_COUNT
			je 	DONE
			mov	rax,	rsi
			imul	rax,	SIZEOF qword
			mov	rbx,	qword ptr [rsp + (SIZEOF qword * 2)]
			mov	rcx,	rsi
			imul	rcx,	DOT_SIZE
			add	rbx,	rcx
			mov	qword ptr [rbx], rsi		; x position of current mesh data
			mov	qword ptr [rbx + 8], rsi	; y position of current mesh data
			mov	qword ptr [rbx + 16], rsi	; z position of current mesh data
			mov	word ptr [rbx + RAW_DOT_OFFSET],	2588h			; filling the space with block
			mov	qword ptr [rax + DEFAULT_3D_MESH_DATA],	rbx 
			inc	rsi
			jmp	DURING
		DONE:
		pop	rbx
		pop	rsi
		pop	rax
		pop	rbp
		ret
	_initmsh	ENDP
	
; vim:ft=masm	
