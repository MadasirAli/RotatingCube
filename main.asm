; -------------------------------------------------------------------------------------
;	Name		: SegmentMemoryPermissionsTest
;	Description	: Checks the memory write permission to .data segment defined by masm.
;	
;	Date Created	: 22 / 9 / 2023
;	Last Modified	: 22 / 9 / 2023	
; -------------------------------------------------------------------------------------

;INCLUDE		utils.asm
INCLUDE		winutils.asm

; default data segment
.data
	className:
		byte	"WINDOW", 0
	wndClassExInst:
		byte 500 dup(0)
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

		; WNDCLASSEX
		; creating new structure
		;mov	rcx,	WNDCLASSEX
		;mov	rdx,	wndClassExInst
		;mov	r8,	WNDCLASSEX_SIZE
		;call	memcpy

		; filling
		xor	rax,	rax
		mov	eax,	WNDCLASSEX_SIZE
		mov	dword ptr [wndClassEx + 0],	eax
		
		mov	eax,	20h
		mov	dword ptr [wndClassEx + 4],	eax
		
		mov	rax,	wndProc
		mov	qword ptr [wndClassEx + 8], rax
		
		xor	rax,	rax
		mov	dword ptr [wndClassEx + 16], eax
		mov	dword ptr [wndClassEx + 20], eax
		
		mov	qword ptr [wndClassEx + 24], rax
		mov 	qword ptr [wndClassEx + 32], rax
		mov 	qword ptr [wndClassEx + 40], rax
		mov 	qword ptr [wndClassEx + 48], rax
		mov 	qword ptr [wndClassEx + 56], rax
		mov	rax,	className	
		mov 	qword ptr [wndClassEx + 64], rax
		xor	rax,	rax		
		mov 	qword ptr [wndClassEx + 72], rax
		
		; registering window
		mov	rcx,	wndClassEx
		call	regcls

		; creating window
		mov	rcx,	0		; dwStyle
		mov	rdx,	className	; lpClassName
		mov	r8,	className	; lpWindowName
		xor	r9,	r9
		mov	r9,	0		; dwStyle
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

		; showing window
		mov	rcx,	qword ptr [wndHnd]	; handle to window
		mov	rdx,	5			; window show state
		call	shwnd

		; cleaning stack frame
		mov	rsp,	rbp
		; restoring stack
		pop	rbp

		; exiting cleanly
		;mov 	rcx,	0
		;call 	exit
		
	WinMain ENDP

	wndProc PROC
		ret
	wndProc	ENDP

; pointing end of life
END
