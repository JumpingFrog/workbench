.global _start
.text

_start:
	xor %rax, %rax	#rax = 0
	inc %rax	#rax = 1 (syscall 1 - write)
	mov %rax, %rdi	#rdi = 1 (stdout)
	lea (%rip), %rsi	#String address, relative.
	xor %rdx, %rdx	#rdx = 0
	mov $14, %dl	#Length into dl
	syscall
msg:
	.ascii "Hello, world!\n"
