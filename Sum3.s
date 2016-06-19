#Input 3 integer from user and print their summary

.data
	msg:		.ascii "Input 3 interger first\n"
	lenmsg=	.-msg
	Inputa:		.ascii "a = "
	len1 = . - Inputa		#length of Inputa
	Inputb: 	.ascii "b = "
	len2 = . - Inputb		#length of Inputb
	Inputc:		.ascii "c = "
	len3 = . - Inputc		#length of Inputc
	sumS:		.ascii "Sum (a,b,c) = "
	lenSumS = . - sumS 		#length of sumS
	err:	.ascii "You must input the number\n"
	lenerr=	.-err
	num: 	.int 0

.text
	.globl _start
_start:
	movl $lenmsg, %edx
	movl $msg, %ecx
	movl $1, %ebx
	movl $4, %eax
	int $0x80

firstnum:
	movl $len1, %edx	
	movl $Inputa, %ecx
	movl $1, %ebx
	movl $4, %eax
	int $0x80
	
	xorl %esi, %esi		#clear esi to count the loop from input first num to third num
Input_num:
	movl $10, %edx		#Read 10 characters from stdin
	movl $num, %ecx		#Chacracter will be put in numa
	xorl %ebx, %ebx		#Put (Stdin = 0)
	movl $3, %eax		#Put (Sys_read = 3)
	int $0x80		#System call to interrupt control flow

	xorl %edx, %edx
	xorl %eax, %eax
Loop:
	movzbl (%ecx, %eax), %ebx
	cmpl $0x30, %ebx
	jl Error
	cmpl $0x39, %ebx
	jg Error
	subl $0x30, %ebx
	addl %ebx, %edx
	incl %eax
	movzbl (%ecx, %eax), %ebx
	cmpl $0xA, %ebx
	je Doneloop
	imull $10, %edx
	jmp Loop

#Input second number
secondnum:
	xorl %ecx, %ecx
	movl $len2, %edx
	movl $Inputb, %ecx
	movl $1, %ebx
	movl $4, %eax
	int $0x80
	
	jmp Input_num
#Input third number
thirdnum:
	movl $len3, %edx
	movl $Inputc, %ecx
	movl $1, %ebx
	movl $4, %eax
	int $0x80

	jmp Input_num
Error:
	movl $lenerr, %edx
	movl $err, %ecx
	movl $1, %ebx
	movl $4, %eax
	int $0x80

	cmpl $1, %esi
	je secondnum
	cmpl $2, %esi
	je thirdnum
	jmp firstnum

Doneloop:
	pushl %edx
	incl %esi
	cmpl $1, %esi
	je secondnum
	cmpl $2, %esi
	je thirdnum
	
#Calculate the result
calculate:
	movl $lenSumS, %edx
	movl $sumS, %ecx
	movl $1, %ebx
	movl $4, %eax
	int $0x80

	popl %eax
	popl %ebx
	popl %ecx

	addl %ecx, %ebx
	addl %ebx, %eax

	movl $1, %esi
	movl $10, %ebx
	pushl $0xA

Convert_num:
	xorl %edx, %edx
	idivl %ebx
	addl $0x30, %edx
	pushl %edx
	incl %esi
	cmpl $0, %eax
	jne Convert_num

Print_num:
	popl num
	decl %esi
	movl $1, %edx
	movl $num, %ecx
	movl $1, %ebx
	movl $4, %eax
	int $0x80

	cmpl $0, %esi
	jne Print_num

	xorl %ebx, %ebx		
	movl $1, %eax		#sys_exit = 1
	int $0x80		#system call
.end
