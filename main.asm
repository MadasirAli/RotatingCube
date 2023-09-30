; -------------------------------------------------------------------------------------
;	Name		: SegmentMemoryPermissionsTest
;	Description	: Checks the memory write permission to .data segment defined by masm.
;	
;	Date Created	: 22 / 9 / 2023
;	Last Modified	: 22 / 9 / 2023	
; -------------------------------------------------------------------------------------

INCLUDE		winutils.asm

; default data segment
.data
	className:
		byte	"WINDOW", 0
	wndHnd:
		qword	0

; exposing main symbol
public 	WinMain

; default code segment equilent to ".text" segment of nasm
.code
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
		mov 	r8,	rax
		mov 	r9,	rax
		
		; running test
					
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
		mov	r9,	12582912	; dwStyle
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
			; translating message to add character message to queue
			mov	rcx,	MSG
			call	transmsg
			; dispatching message from queue to message handler
			mov	rcx,	MSG
			call	dismsg
			jmp	DURING
		DONE:
			nop
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
;			    rdx = address to message
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
			;_________________________________________

			; adding shadow space
			sub	rsp,	32

			; calling default window procedure
			call	DefWindowProcA

			; cleaning shadow space
			add	rsp,	32

			; restoring stack
			pop	rbp
			; returning to caller
			ret
	wndproc	ENDP

; pointing end of life
END
