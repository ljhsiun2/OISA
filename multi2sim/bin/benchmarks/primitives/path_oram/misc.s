	.file	"misc.c"
	.text
	.globl	rdtsc
	.type	rdtsc, @function
rdtsc:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
#APP
# 5 "../lib/misc.c" 1
	rdtsc
# 0 "" 2
#NO_APP
	movl	%eax, -8(%rbp)
	movl	%edx, -4(%rbp)
	movl	-8(%rbp), %eax
	movl	-4(%rbp), %edx
	salq	$32, %rdx
	orq	%rdx, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	rdtsc, .-rdtsc
	.globl	log_2
	.type	log_2, @function
log_2:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L4
.L5:
	addl	$1, -4(%rbp)
.L4:
	shrl	-20(%rbp)
	cmpl	$0, -20(%rbp)
	jne	.L5
	movl	-4(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	log_2, .-log_2
	.globl	bitwiseReverse
	.type	bitwiseReverse, @function
bitwiseReverse:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)
	movl	%esi, -24(%rbp)
	movl	$0, -8(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L8
.L9:
	movl	-8(%rbp), %eax
	leal	(%rax,%rax), %edx
	movl	-20(%rbp), %eax
	andl	$1, %eax
	addl	%edx, %eax
	movl	%eax, -8(%rbp)
	movl	-20(%rbp), %eax
	shrl	%eax
	movl	%eax, -20(%rbp)
	addl	$1, -4(%rbp)
.L8:
	movl	-4(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jl	.L9
	movl	-8(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	bitwiseReverse, .-bitwiseReverse
	.globl	roundToPowerOf2
	.type	roundToPowerOf2, @function
roundToPowerOf2:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)
	movl	$1, -4(%rbp)
	jmp	.L12
.L13:
	addl	$1, -4(%rbp)
.L12:
	sarl	-20(%rbp)
	cmpl	$0, -20(%rbp)
	jne	.L13
	movl	-4(%rbp), %eax
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	roundToPowerOf2, .-roundToPowerOf2
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.5) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
