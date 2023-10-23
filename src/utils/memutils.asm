; ------------------------------------------------------------------------------------
;	Name		: memutils.asm
; 	Description	: Contains memory management procedures
;
;	Date Created	: 25 / 9 / 2023
;	Last Modified	: 25 / 9 / 2023
; ------------------------------------------------------------------------------------

INCLUDELIB	kernel32.lib

HeapAlloc		PROTO
GetProcessHeap		PROTO
HeapCreate		PROTO
HeapDestroy		PROTO
HeapFree		PROTO

.data
	; Flags

	HEAP_GENERATE_EXCEPTIONS	equ	4h
	HEAP_NO_SERIALIZE		equ	1h

	HEAP_ZERO_MEMORY		equ	8h

	HEAP_CREATE_ENABLE_EXECUTE	equ	262144	
.code
; ------------------------------------------------------------------------------------
;  PROCEDURE
; 	Name		 : freeheap
;	Description	 : Frees a allocated heap's block
;
;	Parametres:-
;	rcx = hHeap,
;	rdx = dwFlags
;	r8  = lpMem
;
;	Returns: BOOL
; ------------------------------------------------------------------------------------
	freeheap	PROC
		push	rbp
		mov	rbp,	rsp
		sub	rsp,	32
		call	FreeHeap
		add	rsi,	32
		pop	rbp
		ret
	freeheap	ENDP
; ------------------------------------------------------------------------------------
;  PROCEDURE
;	Name		: destheap
;	Description	: Destroys Heap Block.
;
;	Parametres	:-
;			    rcx = address to the heap
;	Returns		: non zero for succession, 0 for error
; ------------------------------------------------------------------------------------
	destheap PROC
		push	rbp
		mov	rbp,	rsp
		sub	rsp,	32
		call 	HeapDestroy
		add	rsp,	32
		pop	rbp
		ret
	destheap ENDP
; ------------------------------------------------------------------------------------
;  PROCEDURE
;	Name		: heapcrte
;	Description	: Create a private heap.
;
;	Parametres	:-
;			   rcx = fpOptions
;			   rdx = dwInitSize
;			   r8  = dwMaxSize
;	Returns		: address of new heap, or 0 for failture
; ------------------------------------------------------------------------------------
	heapcrte PROC
		push	rbp
		mov	rbp,	rsp
		sub	rsp,	32
		call	HeapCreate
		add	rsp,	32
		pop	rbp
		ret
	heapcrte ENDP
; ------------------------------------------------------------------------------------
;  PROCEDURE
;	Name		: getprocheap
;	Description	: Retrives process default heap.
;
;	Parametres	: None
;	Returns		: Address of the heap, else 0 for failture
; ------------------------------------------------------------------------------------
	getprocheap PROC
		; saving old stack base
		push	rbp
		; creating new stack frame
		mov	rbp,	rsp
		; adding shadow space
		sub	rsp,	32
		; calling win32
		call 	GetProcessHeap
		; cleaning shadow space
		add	rsp,	32
		; restoring stack
		pop	rbp
		; returning to caller
		ret
	getprocheap ENDP
; ------------------------------------------------------------------------------------
;  PROCEDURE
;	Name		: malloc
;	Description	: Allocates Memory in heap
;
;	Parametres	:-
;			    rcx = address of the heap 
;			    rdx = dwFlags
;			    r8  = dwBytes
;
;	Returns		: address on succession, null on failture
; ------------------------------------------------------------------------------------
	malloc	PROC
		; saving old stack base
		push	rbp
		; creating new stack frame
		mov	rbp,	rsp
		; adding shadow space
		sub	rsp,	32
		; calling win32
		call	HeapAlloc
		; cleaning shadow space
		add	rsp,	32
		; restoring stack
		pop	rbp
		; returning to caller
		ret
	malloc	ENDP
; ------------------------------------------------------------------------------------
; PROCEDURE
;	Name		: memcpy
;	Descritpion	: Copies a region of memory to specified region
;
;	Parametres	:-
;			    rcx	= address of region from copy
;			    rdx = address of region to paste
;			    r8  = number of bytes to copy
; ------------------------------------------------------------------------------------
	memcpy	PROC
		; saving old stack base
		push	rbp
		; creating new stack frame
		mov	rbp,	rsp

		; cleaning buffer register
		xor	rbx,	rbx

		; while number of bytes
		mov	r9,	r8
		DURING:
			; condition
			cmp	r9,	0
			jz	DONE
			; during condition
			mov	bl,	byte ptr [rcx + r9]
			mov	byte ptr [rdx + r9],	bl
			; after condition
			dec	r9
			jmp	DURING
		DONE:
			; coping the first remaining byte
			mov	bl,	byte ptr [rcx + r9]
			mov	byte ptr [rdx + r9],	bl

		; restoring stack
		pop	rbp
		
		; returning to caller
		ret	
	memcpy	ENDP

; vim:ft=masm
