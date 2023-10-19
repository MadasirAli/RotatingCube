INCLUDE		"3dspace.asm"

.code
	fillmesh	PROC
		push	rbp
		mov	rbp,	rsp

		push	rdi
		xor	rdi,	rdi
		
		DURING:
			cmp	rdi,	DEFAULT_3D_MESH_DATA_COUNT
			je	DONE

			mov	rax,	rdi
			imul	rax,	SIZEOF qword

			; _________ allocate memory and fill the list with strcutures

			inc	rdi
		DONE:
		pop	rdi

		pop	rbp
		ret
	fillmesh	ENDP

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

	DEFAULT_3D_SPACE_MESH_DATA:	
		qword	DEFAULT_3D_MESH_DATA_COUNT dup(0)	; pointer to its 3D mesh data

	DEFAULT_3D_MESH_DATA_COUNT	equ	256
	
; vim:ft=masm	
