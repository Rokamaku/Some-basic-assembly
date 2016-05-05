.text
	.globl _start
_start:
	movl $8124, %ecx
	movl $92, %ebx
	movl $12, %eax

	addl %ecx, %ebx
	addl %ebx, %eax

	xorl %esi, %esi

loop:
	movl $0, %edx
	movl $10, %ebx
	divl %ebx
	addl $48, %edx
	pushl %edx
	incl %esi
	cmpl $0, %eax
	jz next
	jmp loop
next:
	cmpl $0, %esi
	jz exit
	decl %esi
	movl $1, %edx
	movl %esp, %ecx
	movl $1, %ebx
	movl $4, %eax
	int $0x80
	addl $4, %esp
	jmp next
exit:
	xorl %ebx, %ebx
	movl $1, %eax
	int $0x80
.end