	.file	"main.c"
	.section	.rodata
.LC0:
	.string	"main.c"
.LC1:
	.string	"argc == 4"
.LC2:
	.string	"num_access <= N"
.LC3:
	.string	"%d, %d, %d, %d\n"
	.text
	.globl	_start
	.type	_start, @function
_start:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movl	%edi, -52(%rbp)
	movq	%rsi, -64(%rbp)
	cmpl	$4, -52(%rbp)
	je	.L2
	movl	$__PRETTY_FUNCTION__.2945, %ecx
	movl	$99, %edx
	movl	$.LC0, %esi
	movl	$.LC1, %edi
	call	__assert_fail
.L2:
	movl	$4, -36(%rbp)
	movq	-64(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi
	movl	%eax, -32(%rbp)
	movq	-64(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi
	movl	%eax, -28(%rbp)
	movq	-64(%rbp), %rax
	addq	$24, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi
	movl	%eax, -24(%rbp)
	movl	$3, -20(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-32(%rbp), %eax
	jle	.L3
	movl	$__PRETTY_FUNCTION__.2945, %ecx
	movl	$105, %edx
	movl	$.LC0, %esi
	movl	$.LC2, %edi
	call	__assert_fail
.L3:
	movl	-24(%rbp), %ecx
	movl	-28(%rbp), %edx
	movl	-32(%rbp), %esi
	movl	-36(%rbp), %eax
	movl	%eax, %edi
	call	Init_ORAM
	movl	-32(%rbp), %eax
	movslq	%eax, %rdx
	movl	-28(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -16(%rbp)
	movl	$0, -48(%rbp)
	jmp	.L4
.L5:
	movl	-48(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-16(%rbp), %rax
	addq	%rax, %rdx
	movl	-48(%rbp), %eax
	movl	%eax, (%rdx)
	addl	$1, -48(%rbp)
.L4:
	movl	-32(%rbp), %eax
	addl	%eax, %eax
	imull	-28(%rbp), %eax
	cmpl	-48(%rbp), %eax
	jg	.L5
	movl	$0, -44(%rbp)
	jmp	.L6
.L7:
	movl	-44(%rbp), %eax
	imull	-28(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-16(%rbp), %rax
	addq	%rax, %rdx
	movl	-44(%rbp), %eax
	movl	%eax, %esi
	movl	$2, %edi
	call	Access_ORAM
	addl	$1, -44(%rbp)
.L6:
	movl	-44(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L7
	movl	-28(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -8(%rbp)
	movl	$0, -40(%rbp)
	jmp	.L8
.L9:
	movq	-8(%rbp), %rdx
	movl	-40(%rbp), %eax
	movl	%eax, %esi
	movl	$1, %edi
	call	Access_ORAM
	movq	-8(%rbp), %rax
	addq	$12, %rax
	movl	(%rax), %esi
	movq	-8(%rbp), %rax
	addq	$8, %rax
	movl	(%rax), %ecx
	movq	-8(%rbp), %rax
	addq	$4, %rax
	movl	(%rax), %edx
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movl	%esi, %r8d
	movl	%eax, %esi
	movl	$.LC3, %edi
	movl	$0, %eax
	call	printf
	addl	$1, -40(%rbp)
.L8:
	movl	-40(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L9
	movl	$0, %eax
	call	Free_ORAM
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	free
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	_start, .-_start
	.section	.rodata
	.type	__PRETTY_FUNCTION__.2945, @object
	.size	__PRETTY_FUNCTION__.2945, 7
__PRETTY_FUNCTION__.2945:
	.string	"_start"
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.5) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
