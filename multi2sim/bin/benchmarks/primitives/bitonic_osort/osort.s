	.file	"osort.c"
	.text
	.type	oswap, @function
oswap:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	.cfi_offset 3, -24
	movq	%rdi, -16(%rbp)
	movq	%rsi, -24(%rbp)
	movl	%edx, -28(%rbp)
	movq	-16(%rbp), %rdx
	movq	-24(%rbp), %rsi
#APP
# 23 "osort.c" 1
	movl (%rdx), %eax
	movl (%rsi), %ebx
	movl %eax, %ecx
	cmpl $0, -28(%rbp)
	cmovnel %ebx, %eax
	cmovnel %ecx, %ebx
	movl %eax, (%rdx)
	movl %ebx, (%rsi)
# 0 "" 2
#NO_APP
	nop
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	oswap, .-oswap
	.globl	CompAndSwap
	.type	CompAndSwap, @function
CompAndSwap:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$40, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	%edx, -32(%rbp)
	movl	%ecx, -36(%rbp)
	movl	-28(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %edx
	movl	-32(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movl	(%rax), %eax
	cmpl	%eax, %edx
	setg	%al
	movzbl	%al, %eax
	movl	%eax, -4(%rbp)
	movl	-36(%rbp), %eax
	cmpl	-4(%rbp), %eax
	sete	%al
	movzbl	%al, %eax
	movl	-32(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,4), %rcx
	movq	-24(%rbp), %rdx
	leaq	(%rcx,%rdx), %rsi
	movl	-28(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,4), %rcx
	movq	-24(%rbp), %rdx
	addq	%rdx, %rcx
	movl	%eax, %edx
	movq	%rcx, %rdi
	call	oswap
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	CompAndSwap, .-CompAndSwap
	.globl	BitonicMerge
	.type	BitonicMerge, @function
BitonicMerge:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	%edx, -32(%rbp)
	movl	%ecx, -36(%rbp)
	cmpl	$1, -32(%rbp)
	jle	.L7
	movl	-32(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, -4(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, -8(%rbp)
	jmp	.L5
.L6:
	movl	-8(%rbp), %edx
	movl	-4(%rbp), %eax
	leal	(%rdx,%rax), %edi
	movl	-36(%rbp), %edx
	movl	-8(%rbp), %esi
	movq	-24(%rbp), %rax
	movl	%edx, %ecx
	movl	%edi, %edx
	movq	%rax, %rdi
	call	CompAndSwap
	addl	$1, -8(%rbp)
.L5:
	movl	-28(%rbp), %edx
	movl	-4(%rbp), %eax
	addl	%edx, %eax
	cmpl	-8(%rbp), %eax
	jg	.L6
	movl	-36(%rbp), %ecx
	movl	-4(%rbp), %edx
	movl	-28(%rbp), %esi
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	BitonicMerge
	movl	-28(%rbp), %edx
	movl	-4(%rbp), %eax
	leal	(%rdx,%rax), %esi
	movl	-36(%rbp), %ecx
	movl	-4(%rbp), %edx
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	BitonicMerge
.L7:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	BitonicMerge, .-BitonicMerge
	.globl	BitonicSort
	.type	BitonicSort, @function
BitonicSort:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	%edx, -32(%rbp)
	movl	%ecx, -36(%rbp)
	cmpl	$1, -32(%rbp)
	jle	.L10
	movl	-32(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %edx
	movl	-28(%rbp), %esi
	movq	-24(%rbp), %rax
	movl	$1, %ecx
	movq	%rax, %rdi
	call	BitonicSort
	movl	-28(%rbp), %edx
	movl	-4(%rbp), %eax
	leal	(%rdx,%rax), %esi
	movl	-4(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	$0, %ecx
	movq	%rax, %rdi
	call	BitonicSort
	movl	-36(%rbp), %ecx
	movl	-32(%rbp), %edx
	movl	-28(%rbp), %esi
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	BitonicMerge
.L10:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	BitonicSort, .-BitonicSort
	.globl	Sort
	.type	Sort, @function
Sort:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	%edx, -16(%rbp)
	movl	-16(%rbp), %ecx
	movl	-12(%rbp), %edx
	movq	-8(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	BitonicSort
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	Sort, .-Sort
	.section	.rodata
	.align 8
.LC0:
	.string	"generate %d random numbers as an array\n"
.LC1:
	.string	"sort time: %d ms\n"
.LC2:
	.string	"a[%d] = %d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movl	%edi, -52(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-64(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi
	movl	%eax, -40(%rbp)
	movq	-64(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi
	movl	%eax, -36(%rbp)
	movl	-40(%rbp), %eax
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	movl	%eax, -32(%rbp)
	movl	-32(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -24(%rbp)
	movl	-32(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	movl	$0, -48(%rbp)
	jmp	.L13
.L16:
	cmpl	$0, -36(%rbp)
	je	.L14
	movl	-48(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rax, %rdx
	movl	-32(%rbp), %eax
	subl	-48(%rbp), %eax
	movl	%eax, (%rdx)
	jmp	.L15
.L14:
	movl	-48(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rax, %rdx
	movl	-48(%rbp), %eax
	movl	%eax, (%rdx)
.L15:
	addl	$1, -48(%rbp)
.L13:
	movl	-48(%rbp), %eax
	cmpl	-32(%rbp), %eax
	jl	.L16
	call	clock
	movq	%rax, -16(%rbp)
	movl	-32(%rbp), %ecx
	movq	-24(%rbp), %rax
	movl	$1, %edx
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	Sort
	call	clock
	subq	-16(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	imulq	$1000, %rax, %rcx
	movabsq	$4835703278458516699, %rdx
	movq	%rcx, %rax
	imulq	%rdx
	sarq	$18, %rdx
	movq	%rcx, %rax
	sarq	$63, %rax
	subq	%rax, %rdx
	movq	%rdx, %rax
	movl	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	movl	$0, -44(%rbp)
	jmp	.L17
.L18:
	movl	-44(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %edx
	movl	-44(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
	addl	$1, -44(%rbp)
.L17:
	movl	-44(%rbp), %eax
	cmpl	-32(%rbp), %eax
	jl	.L18
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.5) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
