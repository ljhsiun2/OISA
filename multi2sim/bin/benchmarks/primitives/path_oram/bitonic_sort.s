	.file	"bitonic_sort.c"
	.text
	.type	oswap, @function
oswap:
.LFB0:
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
# 13 "../sort/bitonic_sort.c" 1
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
.LFE0:
	.size	oswap, .-oswap
	.section	.rodata
	.align 8
.LC0:
	.string	"ERROR: bitonic sort only works for array with length of power of two!\n"
.LC1:
	.string	"../sort/bitonic_sort.c"
.LC2:
	.string	"val == 1"
	.text
	.type	checkPowerOfTwo, @function
checkPowerOfTwo:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	jmp	.L3
.L4:
	sarl	-4(%rbp)
.L3:
	movl	-4(%rbp), %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L4
	cmpl	$1, -4(%rbp)
	je	.L6
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$70, %edx
	movl	$1, %esi
	movl	$.LC0, %edi
	call	fwrite
	cmpl	$1, -4(%rbp)
	je	.L6
	movl	$__PRETTY_FUNCTION__.2328, %ecx
	movl	$32, %edx
	movl	$.LC1, %esi
	movl	$.LC2, %edi
	call	__assert_fail
.L6:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	checkPowerOfTwo, .-checkPowerOfTwo
	.type	CompAndSwap_Int, @function
CompAndSwap_Int:
.LFB2:
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
	movl	%eax, -8(%rbp)
	movl	-36(%rbp), %eax
	cmpl	-8(%rbp), %eax
	sete	%al
	movzbl	%al, %eax
	movl	%eax, -4(%rbp)
	movl	-32(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	leaq	(%rdx,%rax), %rsi
	movl	-28(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-4(%rbp), %eax
	movl	%eax, %edx
	movq	%rcx, %rdi
	call	oswap
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	CompAndSwap_Int, .-CompAndSwap_Int
	.type	CompAndSwap_Block, @function
CompAndSwap_Block:
.LFB3:
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
	movl	%r8d, -40(%rbp)
	movl	-28(%rbp), %eax
	imull	-40(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %edx
	movl	-32(%rbp), %eax
	imull	-40(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movl	(%rax), %eax
	cmpl	%eax, %edx
	setg	%al
	movzbl	%al, %eax
	movl	%eax, -8(%rbp)
	movl	-36(%rbp), %eax
	cmpl	-8(%rbp), %eax
	sete	%al
	movzbl	%al, %eax
	movl	%eax, -4(%rbp)
	movl	$0, -12(%rbp)
	jmp	.L9
.L10:
	movl	-32(%rbp), %eax
	imull	-40(%rbp), %eax
	movslq	%eax, %rdx
	movl	-12(%rbp), %eax
	cltq
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	leaq	(%rdx,%rax), %rsi
	movl	-28(%rbp), %eax
	imull	-40(%rbp), %eax
	movslq	%eax, %rdx
	movl	-12(%rbp), %eax
	cltq
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-4(%rbp), %eax
	movl	%eax, %edx
	movq	%rcx, %rdi
	call	oswap
	addl	$1, -12(%rbp)
.L9:
	movl	-12(%rbp), %eax
	cmpl	-40(%rbp), %eax
	jl	.L10
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	CompAndSwap_Block, .-CompAndSwap_Block
	.type	CompAndSwap_TwoArray, @function
CompAndSwap_TwoArray:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movl	%edx, -36(%rbp)
	movl	%ecx, -40(%rbp)
	movl	%r8d, -44(%rbp)
	movl	%r9d, -48(%rbp)
	movl	-36(%rbp), %eax
	imull	-48(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %edx
	movl	-40(%rbp), %eax
	imull	-48(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movl	(%rax), %eax
	cmpl	%eax, %edx
	setg	%al
	movzbl	%al, %eax
	movl	%eax, -8(%rbp)
	movl	-44(%rbp), %eax
	cmpl	-8(%rbp), %eax
	sete	%al
	movzbl	%al, %eax
	movl	%eax, -4(%rbp)
	movl	$0, -16(%rbp)
	jmp	.L12
.L13:
	movl	-40(%rbp), %eax
	imull	-48(%rbp), %eax
	movslq	%eax, %rdx
	movl	-16(%rbp), %eax
	cltq
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	leaq	(%rdx,%rax), %rsi
	movl	-36(%rbp), %eax
	imull	-48(%rbp), %eax
	movslq	%eax, %rdx
	movl	-16(%rbp), %eax
	cltq
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-4(%rbp), %eax
	movl	%eax, %edx
	movq	%rcx, %rdi
	call	oswap
	addl	$1, -16(%rbp)
.L12:
	movl	-16(%rbp), %eax
	cmpl	-48(%rbp), %eax
	jl	.L13
	movl	$0, -12(%rbp)
	jmp	.L14
.L15:
	movl	-40(%rbp), %eax
	imull	16(%rbp), %eax
	movslq	%eax, %rdx
	movl	-12(%rbp), %eax
	cltq
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	leaq	(%rdx,%rax), %rsi
	movl	-36(%rbp), %eax
	imull	16(%rbp), %eax
	movslq	%eax, %rdx
	movl	-12(%rbp), %eax
	cltq
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-4(%rbp), %eax
	movl	%eax, %edx
	movq	%rcx, %rdi
	call	oswap
	addl	$1, -12(%rbp)
.L14:
	movl	-12(%rbp), %eax
	cmpl	16(%rbp), %eax
	jl	.L15
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	CompAndSwap_TwoArray, .-CompAndSwap_TwoArray
	.type	BitonicMerge_Int, @function
BitonicMerge_Int:
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
	jle	.L20
	movl	-32(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, -4(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, -8(%rbp)
	jmp	.L18
.L19:
	movl	-8(%rbp), %edx
	movl	-4(%rbp), %eax
	leal	(%rdx,%rax), %edi
	movl	-36(%rbp), %edx
	movl	-8(%rbp), %esi
	movq	-24(%rbp), %rax
	movl	%edx, %ecx
	movl	%edi, %edx
	movq	%rax, %rdi
	call	CompAndSwap_Int
	addl	$1, -8(%rbp)
.L18:
	movl	-28(%rbp), %edx
	movl	-4(%rbp), %eax
	addl	%edx, %eax
	cmpl	-8(%rbp), %eax
	jg	.L19
	movl	-36(%rbp), %ecx
	movl	-4(%rbp), %edx
	movl	-28(%rbp), %esi
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	BitonicMerge_Int
	movl	-28(%rbp), %edx
	movl	-4(%rbp), %eax
	leal	(%rdx,%rax), %esi
	movl	-36(%rbp), %ecx
	movl	-4(%rbp), %edx
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	BitonicMerge_Int
.L20:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	BitonicMerge_Int, .-BitonicMerge_Int
	.type	BitonicMerge_Block, @function
BitonicMerge_Block:
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
	movl	%r8d, -40(%rbp)
	cmpl	$1, -32(%rbp)
	jle	.L25
	movl	-32(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, -4(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, -8(%rbp)
	jmp	.L23
.L24:
	movl	-8(%rbp), %edx
	movl	-4(%rbp), %eax
	leal	(%rdx,%rax), %edi
	movl	-40(%rbp), %ecx
	movl	-36(%rbp), %edx
	movl	-8(%rbp), %esi
	movq	-24(%rbp), %rax
	movl	%ecx, %r8d
	movl	%edx, %ecx
	movl	%edi, %edx
	movq	%rax, %rdi
	call	CompAndSwap_Block
	addl	$1, -8(%rbp)
.L23:
	movl	-28(%rbp), %edx
	movl	-4(%rbp), %eax
	addl	%edx, %eax
	cmpl	-8(%rbp), %eax
	jg	.L24
	movl	-40(%rbp), %edi
	movl	-36(%rbp), %ecx
	movl	-4(%rbp), %edx
	movl	-28(%rbp), %esi
	movq	-24(%rbp), %rax
	movl	%edi, %r8d
	movq	%rax, %rdi
	call	BitonicMerge_Block
	movl	-28(%rbp), %edx
	movl	-4(%rbp), %eax
	leal	(%rdx,%rax), %esi
	movl	-40(%rbp), %edi
	movl	-36(%rbp), %ecx
	movl	-4(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	%edi, %r8d
	movq	%rax, %rdi
	call	BitonicMerge_Block
.L25:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	BitonicMerge_Block, .-BitonicMerge_Block
	.type	BitonicMerge_TwoArray, @function
BitonicMerge_TwoArray:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movl	%edx, -36(%rbp)
	movl	%ecx, -40(%rbp)
	movl	%r8d, -44(%rbp)
	movl	%r9d, -48(%rbp)
	cmpl	$1, -40(%rbp)
	jle	.L30
	movl	-40(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, -4(%rbp)
	movl	-36(%rbp), %eax
	movl	%eax, -8(%rbp)
	jmp	.L28
.L29:
	movl	-8(%rbp), %edx
	movl	-4(%rbp), %eax
	leal	(%rdx,%rax), %edi
	movl	-48(%rbp), %r9d
	movl	-44(%rbp), %r8d
	movl	-8(%rbp), %edx
	movq	-32(%rbp), %rsi
	movq	-24(%rbp), %rax
	movl	16(%rbp), %ecx
	pushq	%rcx
	movl	%edi, %ecx
	movq	%rax, %rdi
	call	CompAndSwap_TwoArray
	addq	$8, %rsp
	addl	$1, -8(%rbp)
.L28:
	movl	-36(%rbp), %edx
	movl	-4(%rbp), %eax
	addl	%edx, %eax
	cmpl	-8(%rbp), %eax
	jg	.L29
	movl	-48(%rbp), %r9d
	movl	-44(%rbp), %r8d
	movl	-4(%rbp), %ecx
	movl	-36(%rbp), %edx
	movq	-32(%rbp), %rsi
	movq	-24(%rbp), %rax
	subq	$8, %rsp
	movl	16(%rbp), %edi
	pushq	%rdi
	movq	%rax, %rdi
	call	BitonicMerge_TwoArray
	addq	$16, %rsp
	movl	-36(%rbp), %edx
	movl	-4(%rbp), %eax
	leal	(%rdx,%rax), %edi
	movl	-48(%rbp), %r9d
	movl	-44(%rbp), %r8d
	movl	-4(%rbp), %edx
	movq	-32(%rbp), %rsi
	movq	-24(%rbp), %rax
	subq	$8, %rsp
	movl	16(%rbp), %ecx
	pushq	%rcx
	movl	%edx, %ecx
	movl	%edi, %edx
	movq	%rax, %rdi
	call	BitonicMerge_TwoArray
	addq	$16, %rsp
.L30:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	BitonicMerge_TwoArray, .-BitonicMerge_TwoArray
	.type	BitonicSubSort_Int, @function
BitonicSubSort_Int:
.LFB8:
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
	jle	.L33
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
	call	BitonicSubSort_Int
	movl	-28(%rbp), %edx
	movl	-4(%rbp), %eax
	leal	(%rdx,%rax), %esi
	movl	-4(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	$0, %ecx
	movq	%rax, %rdi
	call	BitonicSubSort_Int
	movl	-36(%rbp), %ecx
	movl	-32(%rbp), %edx
	movl	-28(%rbp), %esi
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	BitonicMerge_Int
.L33:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	BitonicSubSort_Int, .-BitonicSubSort_Int
	.type	BitonicSubSort_Block, @function
BitonicSubSort_Block:
.LFB9:
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
	movl	%r8d, -40(%rbp)
	cmpl	$1, -32(%rbp)
	jle	.L36
	movl	-32(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, -4(%rbp)
	movl	-40(%rbp), %ecx
	movl	-4(%rbp), %edx
	movl	-28(%rbp), %esi
	movq	-24(%rbp), %rax
	movl	%ecx, %r8d
	movl	$1, %ecx
	movq	%rax, %rdi
	call	BitonicSubSort_Block
	movl	-28(%rbp), %edx
	movl	-4(%rbp), %eax
	leal	(%rdx,%rax), %esi
	movl	-40(%rbp), %ecx
	movl	-4(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	%ecx, %r8d
	movl	$0, %ecx
	movq	%rax, %rdi
	call	BitonicSubSort_Block
	movl	-40(%rbp), %edi
	movl	-36(%rbp), %ecx
	movl	-32(%rbp), %edx
	movl	-28(%rbp), %esi
	movq	-24(%rbp), %rax
	movl	%edi, %r8d
	movq	%rax, %rdi
	call	BitonicMerge_Block
.L36:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	BitonicSubSort_Block, .-BitonicSubSort_Block
	.type	BitonicSubSort_TwoArray, @function
BitonicSubSort_TwoArray:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movl	%edx, -36(%rbp)
	movl	%ecx, -40(%rbp)
	movl	%r8d, -44(%rbp)
	movl	%r9d, -48(%rbp)
	cmpl	$1, -40(%rbp)
	jle	.L39
	movl	-40(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, -4(%rbp)
	movl	-48(%rbp), %r8d
	movl	-4(%rbp), %ecx
	movl	-36(%rbp), %edx
	movq	-32(%rbp), %rsi
	movq	-24(%rbp), %rax
	subq	$8, %rsp
	movl	16(%rbp), %edi
	pushq	%rdi
	movl	%r8d, %r9d
	movl	$1, %r8d
	movq	%rax, %rdi
	call	BitonicSubSort_TwoArray
	addq	$16, %rsp
	movl	-36(%rbp), %edx
	movl	-4(%rbp), %eax
	leal	(%rdx,%rax), %edi
	movl	-48(%rbp), %r8d
	movl	-4(%rbp), %edx
	movq	-32(%rbp), %rsi
	movq	-24(%rbp), %rax
	subq	$8, %rsp
	movl	16(%rbp), %ecx
	pushq	%rcx
	movl	%r8d, %r9d
	movl	$0, %r8d
	movl	%edx, %ecx
	movl	%edi, %edx
	movq	%rax, %rdi
	call	BitonicSubSort_TwoArray
	addq	$16, %rsp
	movl	-48(%rbp), %r9d
	movl	-44(%rbp), %r8d
	movl	-40(%rbp), %ecx
	movl	-36(%rbp), %edx
	movq	-32(%rbp), %rsi
	movq	-24(%rbp), %rax
	subq	$8, %rsp
	movl	16(%rbp), %edi
	pushq	%rdi
	movq	%rax, %rdi
	call	BitonicMerge_TwoArray
	addq	$16, %rsp
.L39:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	BitonicSubSort_TwoArray, .-BitonicSubSort_TwoArray
	.globl	BitonicSort_Int
	.type	BitonicSort_Int, @function
BitonicSort_Int:
.LFB11:
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
	movl	-12(%rbp), %eax
	movl	%eax, %edi
	call	checkPowerOfTwo
	movl	-16(%rbp), %ecx
	movl	-12(%rbp), %edx
	movq	-8(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	BitonicSubSort_Int
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	BitonicSort_Int, .-BitonicSort_Int
	.globl	BitonicSort_Block
	.type	BitonicSort_Block, @function
BitonicSort_Block:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	%edx, -16(%rbp)
	movl	%ecx, -20(%rbp)
	movl	-12(%rbp), %eax
	movl	%eax, %edi
	call	checkPowerOfTwo
	movl	-20(%rbp), %esi
	movl	-16(%rbp), %ecx
	movl	-12(%rbp), %edx
	movq	-8(%rbp), %rax
	movl	%esi, %r8d
	movl	$0, %esi
	movq	%rax, %rdi
	call	BitonicSubSort_Block
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	BitonicSort_Block, .-BitonicSort_Block
	.globl	BitonicSort_TwoArray
	.type	BitonicSort_TwoArray, @function
BitonicSort_TwoArray:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	%edx, -20(%rbp)
	movl	%ecx, -24(%rbp)
	movl	%r8d, -28(%rbp)
	movl	%r9d, -32(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, %edi
	call	checkPowerOfTwo
	movl	-28(%rbp), %r8d
	movl	-24(%rbp), %edi
	movl	-20(%rbp), %edx
	movq	-16(%rbp), %rsi
	movq	-8(%rbp), %rax
	subq	$8, %rsp
	movl	-32(%rbp), %ecx
	pushq	%rcx
	movl	%r8d, %r9d
	movl	%edi, %r8d
	movl	%edx, %ecx
	movl	$0, %edx
	movq	%rax, %rdi
	call	BitonicSubSort_TwoArray
	addq	$16, %rsp
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	BitonicSort_TwoArray, .-BitonicSort_TwoArray
	.section	.rodata
	.align 16
	.type	__PRETTY_FUNCTION__.2328, @object
	.size	__PRETTY_FUNCTION__.2328, 16
__PRETTY_FUNCTION__.2328:
	.string	"checkPowerOfTwo"
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.5) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
