.global _start
.text

_start:
	jmp prelude
continue:
	xor %rax, %rax	#rax = 0
	inc %rax	#rax = 1 (syscall 1 - write)
	mov %rax, %rdi	#rdi = 1 (stdout)
	pop %rsi	# String address
	xor %rdx, %rdx	#rdx = 0
	mov $14, %dl	#Length into dl
	syscall
prelude:
	call continue
	.ascii "Hello, world!\n"
