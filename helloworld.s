.data
	msg:	.ascii	"Hello, world!\n"
	len = . - msg
.text
	.global _start
_start:
	movl $len,%edx	#put length of string
	movl $msg,%ecx	#put string to ecx
	movl $1,%ebx	#stdout = 1 to ebx
	movl $4,%eax	#sys_write = 4
	int $0x80	#system call

	movl $0,%ebx	
	movl $1,%eax	#sys_exit = 1
	int $0x80
.end
