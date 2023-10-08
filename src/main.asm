; -------------------------------------------------------------------------------------
;	Name		: main.asm
;	Description	: 
;	
;	Date Created	: 22 / 9 / 2023
;	Last Modified	: 22 / 9 / 2023	
; -------------------------------------------------------------------------------------

;INCLUDE		crt.asm
INCLUDE		winutils.asm
INCLUDE		conutils.asm
INCLUDE		io.asm
INCLUDE		input.asm

; default data segment
.data
	className:
		byte	"WINDOW", 0
	wndHnd:
		qword	0
	fr_:
		byte	128 dup (77)
	stdHnd:
		qword	0
	tmp:
		qword	0

; default code segment equilent to ".text" segment of nasm
.code
	main	PROC
		; setting stack
		; saving old stack base pointer
		push	rbp
		; setting new stack frame
		mov	rbp,	rsp

		; saving non volatile registers
		push	rbx
		push	rbx
		; cleaning volatile registers
		xor	rax,	rax
		mov	rcx,	rax
		mov	rdx,	rax
		mov	r8,	rax
		mov	r9,	rax
		mov	r10,	rax
		mov	r11,	rax

		call	fndievntu

		; creating a console
		call	alcon
		xor	rcx,	rcx
		;call	atcon
		; getting std handle
		mov	rcx,	STD_OUTPUT_HANDLE
		call	getstdh
		mov	qword ptr [stdHnd], 	rax
		mov	rcx,	rax
		mov	rdx,	fr_
		mov	r8,	64
		mov	r9,	tmp
		xor	rax,	rax
		push	rax
		call	wrtefil	
		pop	rax	

		; calling the WinMain Entry Point
		call	WinMain

		; restoring non volatile registers
		pop	rbx	
		pop	rbx
			
		; restoring stack
		pop	rbp
		; exiting process
		ret
	main	ENDP

	WinMain PROC
		; setting  stack
		; saving old stack base		
		push	rbp
		; setting new stack frame
		mov	rbp,	rsp

		; cleaning registers
		xor	rax,	rax
		mov	rbx,	rax
		mov	rcx,	rax
		mov	rdx,	rax
		mov	r8,	rax
		mov	r9,	rax
					
		; registering window
		; filling WNDCLASSEX
		xor	rax,	rax
		mov	eax,	WNDCLASSEX_SIZE
		mov	dword ptr [wndClassEx + 0],	eax
		
		mov	eax,	20h
		mov	dword ptr [wndClassEx + 4],	eax
		
		mov	rax,	wndproc
		mov	qword ptr [wndClassEx + 8],	rax
		
		xor	rax,	rax
		mov	dword ptr [wndClassEx + 16],	eax
		mov	dword ptr [wndClassEx + 20],	eax
		
		mov	qword ptr [wndClassEx + 24],	rax
		mov 	qword ptr [wndClassEx + 32],	rax
		mov 	qword ptr [wndClassEx + 40],	rax
		mov 	qword ptr [wndClassEx + 48],	rax
		mov 	qword ptr [wndClassEx + 56],	rax
		mov	rax,	className	
		mov 	qword ptr [wndClassEx + 64],	rax
		xor	rax,	rax		
		mov 	qword ptr [wndClassEx + 72],	rax
		
		; registering window
		mov	rcx,	wndClassEx
		call	regcls

		; creating window
		mov	rcx,	0		; dwStyleEx
		mov	rdx,	className	; lpClassName
		mov	r8,	className	; lpWindowName
		xor	r9,	r9
		mov	r9,	13110200	; dwStyle
		xor	rax,	rax
		push	rax			; lpParam
		push	rax			; hInstance
		push	rax			; hMenu
		push	rax			; hWndParent
		mov	rax,	WND_HEIGHT
		push	rax			; nHeight
		mov	rax,	WND_WIDTH
		push	rax			; nWidth
		mov	rax,	POS_Y
		push 	rax			; Y
		mov	rax,	POS_X
		push	rax			; X
		call	crtewnd			
		; saving window handle
		mov	qword ptr [wndHnd], rax
		; cleaning params from stack
		add	rsp,	64

		; showing window
		mov	rcx,	qword ptr [wndHnd]	; handle to window
		mov	rdx,	5			; window show state
		call	shwnd

		; starting endless loop
		mov	rax,	1	; setting 1 to prevent exit
		DURING:
			; getting message from queue
			mov	rcx,	MSG
			xor	rdx,	rdx
			mov	r8,	rdx
			mov	r9,	rdx
			call	getmsg
			; checking the receive of PostQuitMessage
			cmp	rax,	0
			je	DONE
			DISPATCH_MSG:
				; translating character messages
				mov	rcx,	MSG
				call	transmsg
				; dispatching message to wndproc
				mov	rcx,	MSG
				call	dismsg
		jmp	DURING
		DONE:
			; getting return code
			xor	rax,	rax
			mov	ax,	word ptr [MSG + 12]
		; cleaning stack frame
		mov	rsp,	rbp
		; restoring stack
		pop	rbp
		; exiting process
		ret
	WinMain ENDP

; --------------------------------------------------------------------
; PROCEDURE
;	Name		: wndproc
;	Description	: Intercepts windows messages
;	
;	Parametres	:-
;			    rcx = handle to window
;			    rdx = dword message
;			    r8  = wParam
;     			    r9  = lParam
;	Returns		: Anything.
; --------------------------------------------------------------------
	wndproc	PROC
			; saving old stack pointer
			push	rbp
			; creating new stack frame
			mov	rbp,	rsp

			; CUSTOM MESSAGE HANDLING CAN BE DONE HERE
			;_________________________________________
			;---------------> HERE <------------------

			; logging
		;	push	rcx
		;	push	rdx
		;	push	r8
		;	push	r9
		;	mov	rcx,	fr_
		;	xor	rdx,	rdx
		;	mov	dx,	r8w
		;	call	print
		;	pop	r9
		;	pop	r8
		;	pop	rdx
		;	pop	rcx

			; WM_CLOSE
			cmp	edx,	WM_CLOSE
			je	WM_CLOSE_MSG
			
			; sending to default handler
			jmp	DEFAULT
			;_________________________________________

			WM_CLOSE_MSG:
				; causing get message to return 0
				mov	rcx,	0
				call	pquitmsg
				xor	rax,	rax
				jmp	RETURN

			DEFAULT:

				; adding shadow space
				sub	rsp,	32

				; calling default window procedure
				call	DefWindowProcA

				; cleaning shadow space
				add	rsp,	32
			
			RETURN:
				; restoring stack
				pop	rbp
				; returning to caller
				ret
	wndproc	ENDP

; pointing end of life
END
