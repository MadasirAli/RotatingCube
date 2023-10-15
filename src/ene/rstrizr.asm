.code
; -----------------------------------------------------------------------
;  PROCEDURE
;	Name		: con3d22d
;	Description	: 
;
;	Parametres	:-
;	
;	Returns		: boolean
; -----------------------------------------------------------------------
	con3d22d	PROC
		; setting up stack
		push	rbp
		mov	rbp,	rsp

		;----> IN COMPLETE <----;		
	
		; restoring stack
		pop	rbp	
		ret
	con3d22d	ENDP

	

; making a constant 3d space
.data

	; size of the screen place
	_2D_PLANE_SIZE_X	equ	64
	_2D_PLANE_SIZE_Y	equ	64


	_2D_PLANE:
		qword	(_2D_PLANE_SIZE_X * _2D_PLANE_SIZE_Y)	dup (0)
