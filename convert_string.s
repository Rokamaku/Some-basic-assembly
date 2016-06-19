.data
	msgst:	.ascii "Input a string to convert: "
	lenmsgst=	.-msgst
	msgend:	.ascii "The result: "
	lenmsgend=	.-msgend
	.lcomm string, 100
.text
	.globl _start
_start:
	movl $lenmsgst, %edx
	movl $msgst, %ecx
	movl $1, %ebx
	movl $4, %eax
	int $0x80

	movl $100, %edx
	movl $string, %ecx
	xorl %ebx, %ebx
	movl $3, %eax
	int $0x80

	xorl %eax, %eax
	movl $1, %esi

Loop1:	
	movzbl (%ecx,%eax), %ebx
	incl %esi
	cmpl $0x61, %ebx
	jb Uppercase
	cmpl $0x7A, %ebx
	ja Nextc
	subl $0x20, %ebx
	movb %bl, (%ecx, %eax)
	jmp Nextc

Uppercase:
	cmpl $0x41, %ebx
	jb Nextc
	cmpl $0x5A, %ebx
	ja Nextc
	addl $0x20, %ebx
	movb %bl, (%ecx, %eax)
	jmp Nextc
	
Nextc:
	incl %eax
	cmpb $0xA, (%ecx, %eax)
	je Print
	jmp Loop1

Print:
	movl $lenmsgend, %edx
	movl $msgend, %ecx	
	movl $1, %ebx
	movl $4, %eax
	int $0x80

	movl %esi, %edx
	movl $string, %ecx
	movl $1, %ebx
	movl $4, %eax
	int $0x80

	xorl %ebx, %ebx
	movl $1, %eax
	int $0x80
.end
