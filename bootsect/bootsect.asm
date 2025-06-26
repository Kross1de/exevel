org 0x7C00
bits 16

code_start:

cli
jmp 0x0000:initializeCS
initializeCS:
	xor 	ax, ax
	mov	ds, ax
	mov	es, ax
	mov	fs, ax
	mov 	gs, ax
	mov	ss, ax
	mov	sp, 0x7C00
	sti

mov	si, LoadingMsg
call	print

; ================ Load stage 2 ================

mov	si, Stage2MSG
call	print

mov	ax, 1
mov	ebx, 0x7E00
mov	cx, 1 
call	ReadSectors

jc	err

mov	si, DoneMsg
call	print

jmp	0x7E00

err:
	mov	si, ErrMSG
	call	print

halt:
	hlt
	jmp	halt

; Data

LoadingMsg:		db 0x0D, 0x0A, 'Exevel1.0', 0x0D, 0x0A, 0x0A, 0x00
Stage2MSG:		db 'Stage1: Loading stage2...', 0x00
ErrMSG:			db 0x0D, 0x0A, 'Error! System halted...', 0x00
DoneMsg:		db '    done!', 0x0D, 0x0A, 0x00

times 0xda-($-$$) db 0
times 6 db 0

; Includes

%include 'Print.inc'
%include 'Disk.inc'

DriveNumber	db 0

times 0x1b8-($-$$) db 0
times 510-($-$$) db 0
dw 0xaa55

; ********************* Stage 2 *********************

; Load stage 3

mov ax, 2
mov ebx, 0x8000
mov cx, 62 
call ReadSectors

jc err

; Enable A20 

call enable_a20
jc err

; Enter 32 bit pmode

lgdt [GDT]						; Load the GDT

cli

mov eax, cr0
or eax, 00000001b
mov cr0, eax

jmp 0x18:.pmode

bits 32
.pmode:

mov ax, 0x20
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax

jmp 0x8000
bits 16

%include 'a20_enabler.inc'
%include 'gdt.inc'

times 1024-($-$$) db 0
