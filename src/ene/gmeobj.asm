.data
	; TRANSFORM
	TRANSFORM_SIZE		equ	144
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

	LOCAL_3D_SPACE_COUNT:
		qword	0	; number of dots in local 3d space
	LOCAL_3D_SPACE:		; pointer to its local space instance
		qword	0
	_3D_SPACE_DOTS_DATA_COUNT:
		qword	0	; numbes of dot initial mesh
	_3D_SPACE_MESH_DATA:
		qword	0	; pointer to its 3D mesh data	
