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
	xor %rdi, %rdi #rdi = 0 Exit code 0
	mov $60,  %al  #rax = 60 (syscall 60 - exit)
	syscall
prelude:
	call continue
	.ascii "Hello, world!\n"
