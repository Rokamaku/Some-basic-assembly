.data
	num:	.long 0
	temp:	.long 0
.text
	.globl _start
_start:

	movl $2, %edx
	movl $num, %ecx
	movl $0, %ebx
	movl $3, %eax
	int $0x80
	movl num, %eax
	subb $48, %al
	movb $10, %bl
	cmpb $0x10, %ah
	je onedigit
	jmp twodigit
onedigit:
	xorb %ah, %ah
	xorl %esi, %esi
	jmp loop
twodigit:
	movb %ah, temp
	mul %bl
	movb temp, %ah
	subb $48, %ah
	addb %ah, %al
	xorb %ah, %ah
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


