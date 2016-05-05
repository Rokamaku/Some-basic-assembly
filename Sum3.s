#Input 3 integer from user and print their summary

.data
	Head:	.ascii "Input less or equal two digit number\n"
	lenHead = . - Head 		#length of Head
	Inputa:		.ascii "a = "
	len1 = . - Inputa		#length of Inputa
	Inputb: 	.ascii "b = "
	len2 = . - Inputb		#length of Inputb
	Inputc:		.ascii "c = "
	len3 = . - Inputc		#length of Inputc
	sumS:		.ascii "Sum (a,b,c) = "
	lenSumS = . - sumS 		#length of sumS
	numa: 	.long 0			#initlize numa = 0
	numb: 	.long 0
	numc: 	.long 0
	temp:	.long 0

.text
	.globl _start
_start:
#Print messeage of Head
	movl $lenHead, %edx	#Put length of buffer to %edx
	movl $Head, %ecx	#Put buffer of %ecx
	movl $1, %ebx		#Put (stdout = 1)
	movl $4, %eax		#Put (sys_write = 4)
	int $0x80			#System call to interupt control flow

#Input first number
	movl $len1, %edx	
	movl $Inputa, %ecx
	movl $1, %ebx
	movl $4, %eax
	int $0x80

	movl $3, %edx		#Read 3 characters from stdin
	movl $numa, %ecx	#Chacracter will be put in numa
	movl $0, %ebx		#Put (Stdin = 0)
	movl $3, %eax		#Put (Sys_read = 3)
	int $0x80			#System call to interrupt control flow

	movl numa, %eax		#Copy data from numa to eax
	andl $0xFFFF, %eax	#Make eax = ax (and 0 always return 0
	subb $48, %al 		#Convert the value in %al from ascii to integer
	movb $10, %bl		#Put 10d to %bl
	cmpb $10, %ah		#Compare to determine whether newline or not
	je onedigit1		#jump to label ondigit if %ah == 10 (newline) => one digit number
	jmp twodigit1		#%ah != 10 jump to twodigit
onedigit1:
	xorb %ah, %ah		#Remove newline character in %ah => %eax have the value in integer
	movl %eax, numa		#Put back the value to numa
	jmp secondnum		#jump to input the second number
twodigit1:
	movb %ah, temp		#move the second digit number to temp
	mul %bl				#multiply the value in %al with %bl and save the lower bit to %al, the higher bit in %ah
	movb temp, %ah		#move back the second digit to %ah
	subb $48, %ah		#convert to integer value
	addb %ah, %al 		#add the value to %al => %al have full 2 digit number 
	xorb %ah, %ah		#clear the value in %ah => %eax hold the value in %al
	movl %eax, numa		#Put back the integer value to numa

#Input second number
secondnum:
	xorl %ecx, %ecx
	movl $len2, %edx
	movl $Inputb, %ecx
	movl $1, %ebx
	movl $4, %eax
	int $0x80

	movl $3, %edx
	movl $numb, %ecx
	movl $0, %ebx
	movl $3, %eax
	int $0x80

	movl numb, %eax
	andl $0xFFFF, %eax
	subb $48, %al
	movb $10, %bl
	cmpb $10, %ah
	je onedigit2
	jmp twodigit2
onedigit2:
	xorb %ah, %ah
	movl %eax, numb
	jmp thirdnum
twodigit2:
	movb %ah, temp
	mul %bl
	movb temp, %ah
	subb $48, %ah
	addb %ah, %al
	xorb %ah, %ah
	movl %eax, numb

#Input third number
thirdnum:
	movl $len3, %edx
	movl $Inputc, %ecx
	movl $1, %ebx
	movl $4, %eax
	int $0x80

	movl $3, %edx
	movl $numc, %ecx
	movl $0, %ebx
	movl $3, %eax
	int $0x80

	movl numc, %eax
	andl $0xFFFF, %eax
	subb $48, %al
	movb $10, %bl
	cmpb $10, %ah
	je onedigit3
	jmp twodigit3
onedigit3:
	xorb %ah, %ah
	movl %eax, numc
	jmp calculate
twodigit3:
	movb %ah, temp
	mul %bl
	movb temp, %ah
	subb $48, %ah
	addb %ah, %al
	xorb %ah, %ah
	movl %eax, numc

#Calculate the result
calculate:
	movl $lenSumS, %edx
	movl $sumS, %ecx
	movl $1, %ebx
	movl $4, %eax
	int $0x80

	movl numa, %ecx
	movl numb, %ebx
	movl numc, %eax

	addl %ecx, %ebx		#Sum of numa and numb saving in %ebx
	addl %ebx, %eax		#Sum of numa numb and numc saving in %eax

	xorl %esi, %esi		#clear %esi

loop:
	xorl %edx, %edx		#clear %edx
	movl $10, %ebx		
	divl %ebx			#dividen %eax , divisor %ebx, remainder stored in %edx, quotion stored in %eax
	addl $48, %edx		#convert to ascii
	pushl %edx			#push to stack
	incl %esi			#count the numerous of digit
	cmpl $0, %eax		#compare %eax with 0, if %eax = 0 => complete else continue loop
	jz next				#equal 0 => next
	jmp loop			#not equal => loop
next:
	cmpl $0, %esi		
	jz exit				#if %esi == 0 the whole number have been printed
	decl %esi			#decrease the value of %esi after a loop
	movl $1, %edx		#length = 1 (print 1 digit number)
	movl %esp, %ecx		#buffer = %esp (print the top of stack)
	movl $1, %ebx		#stdout = 1
	movl $4, %eax		#sys_write = 4
	int $0x80			#system call
	addl $4, %esp		#move to next digit address (1 digit = 4 byte)
	jmp next			#repeat
exit:
	xorl %ebx, %ebx		
	movl $1, %eax		#sys_exit = 1
	int $0x80			#system call
.end