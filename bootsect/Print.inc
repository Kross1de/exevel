; IN:
; SI = points to a 0x00 terminated string
print:
	push	ax		; Save registers
	push	si
	mov	ah, 0x0E	; int 10h, function 0x0E (print character)
	.loop:
	lodsb			; Load character from string
	test	al, al		; Is this the 0x00 terminator?
	jz	.done		; If it is, exit routine
	int	0x10		; Call BIOS
	jmp	.loop		; Again
	.done:
	pop	si		; Restore registers
	pop	ax
	ret			; Exit routine
