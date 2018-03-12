	.file	"osort_test.c"
	.section	.text.unlikely,"ax",@progbits
.LCOLDB0:
	.text
.LHOTB0:
	.p2align 4,,15
	.globl	CompAndSwap
	.type	CompAndSwap, @function
CompAndSwap:
.LFB45:
	.cfi_startproc
	movslq	%esi, %rsi
	movslq	%edx, %rdx
	movl	%ecx, %eax
	leaq	(%rdi,%rdx,4), %rdx
	leaq	(%rdi,%rsi,4), %rcx
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	xorl	%ebx, %ebx
	movl	(%rcx), %esi
	movl	(%rdx), %edi
	cmpl	%edi, %esi
	setg	%bl
	testl	%r8d, %r8d
	jne	.L6
	cmpl	%eax, %ebx
	je	.L7
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L7:
	.cfi_restore_state
	movl	%edi, (%rcx)
	movl	%esi, (%rdx)
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L6:
	.cfi_restore_state
	movq	%rcx, %rsi
#APP
# 31 "osort_test.c" 1
	cmpl  %eax, %ebx
	movl (%rsi), %eax
	movl (%rdx), %ebx
	movl %eax, %ecx
	cmovel %ebx, %eax
	cmovel %ecx, %ebx
	movl %eax, (%rsi)
	movl %ebx, (%rdx)
# 0 "" 2
#NO_APP
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE45:
	.size	CompAndSwap, .-CompAndSwap
	.section	.text.unlikely
.LCOLDE0:
	.text
.LHOTE0:
	.section	.text.unlikely
.LCOLDB1:
	.text
.LHOTB1:
	.p2align 4,,15
	.globl	BitonicMerge
	.type	BitonicMerge, @function
BitonicMerge:
.LFB46:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$72, %rsp
	.cfi_def_cfa_offset 128
	cmpl	$1, %edx
	movl	%edx, 32(%rsp)
	jle	.L8
	movq	%rdi, %r13
	movl	%ecx, %eax
	movl	%r8d, %r14d
.L19:
	sarl	32(%rsp)
	movl	32(%rsp), %ebx
	addl	%esi, %ebx
	cmpl	%esi, %ebx
	movl	%ebx, 36(%rsp)
	jle	.L15
	movslq	%esi, %rcx
	testl	%r14d, %r14d
	leaq	0(%r13,%rcx,4), %rdx
	jne	.L12
	movl	%esi, %edi
	notl	%edi
	addl	%ebx, %edi
	leaq	1(%rcx,%rdi), %rcx
	leaq	0(%r13,%rcx,4), %r9
	movslq	32(%rsp), %rcx
.L14:
	movl	(%rdx), %edi
	movl	(%rdx,%rcx,4), %r8d
	xorl	%r10d, %r10d
	cmpl	%r8d, %edi
	setg	%r10b
	cmpl	%r10d, %eax
	jne	.L13
	movl	%r8d, (%rdx)
	movl	%edi, (%rdx,%rcx,4)
.L13:
	addq	$4, %rdx
	cmpq	%r9, %rdx
	jne	.L14
.L15:
	cmpl	$1, 32(%rsp)
	je	.L8
	movl	32(%rsp), %ebx
	movl	%esi, %edx
	movl	%ebx, 8(%rsp)
.L27:
	sarl	8(%rsp)
	movl	8(%rsp), %esi
	addl	%edx, %esi
	cmpl	%edx, %esi
	movl	%esi, 40(%rsp)
	jle	.L23
	testl	%r14d, %r14d
	movl	%esi, %ebx
	jne	.L20
	movl	%edx, %edi
	movslq	%edx, %rsi
	notl	%edi
	leaq	0(%r13,%rsi,4), %rcx
	addl	%ebx, %edi
	leaq	1(%rsi,%rdi), %rsi
	leaq	0(%r13,%rsi,4), %r9
	movslq	8(%rsp), %rsi
.L22:
	movl	(%rcx), %edi
	movl	(%rcx,%rsi,4), %r8d
	xorl	%r10d, %r10d
	cmpl	%edi, %r8d
	setl	%r10b
	cmpl	%r10d, %eax
	jne	.L21
	movl	%r8d, (%rcx)
	movl	%edi, (%rcx,%rsi,4)
.L21:
	addq	$4, %rcx
	cmpq	%r9, %rcx
	jne	.L22
.L23:
	cmpl	$1, 8(%rsp)
	movl	36(%rsp), %esi
	je	.L19
	movl	8(%rsp), %esi
	movl	%edx, %edi
	movl	%esi, 12(%rsp)
.L35:
	sarl	12(%rsp)
	movl	12(%rsp), %esi
	addl	%edi, %esi
	cmpl	%edi, %esi
	movl	%esi, 48(%rsp)
	jle	.L31
	movslq	%edi, %rcx
	testl	%r14d, %r14d
	movl	%esi, %ebx
	leaq	0(%r13,%rcx,4), %rdx
	jne	.L28
	movl	%edi, %esi
	notl	%esi
	addl	%ebx, %esi
	leaq	1(%rcx,%rsi), %rcx
	leaq	0(%r13,%rcx,4), %r9
	movslq	12(%rsp), %rcx
.L30:
	movl	(%rdx), %esi
	movl	(%rdx,%rcx,4), %r8d
	xorl	%r10d, %r10d
	cmpl	%esi, %r8d
	setl	%r10b
	cmpl	%r10d, %eax
	jne	.L29
	movl	%r8d, (%rdx)
	movl	%esi, (%rdx,%rcx,4)
.L29:
	addq	$4, %rdx
	cmpq	%r9, %rdx
	jne	.L30
.L31:
	cmpl	$1, 12(%rsp)
	movl	40(%rsp), %edx
	je	.L27
	movl	12(%rsp), %esi
	movl	%esi, 16(%rsp)
	movl	%edi, %esi
.L43:
	sarl	16(%rsp)
	movl	16(%rsp), %ebx
	addl	%esi, %ebx
	cmpl	%esi, %ebx
	movl	%ebx, 52(%rsp)
	jle	.L39
	movslq	%esi, %rcx
	testl	%r14d, %r14d
	leaq	0(%r13,%rcx,4), %rdx
	jne	.L36
	movl	%esi, %edi
	notl	%edi
	addl	%ebx, %edi
	leaq	1(%rcx,%rdi), %rcx
	leaq	0(%r13,%rcx,4), %r9
	movslq	16(%rsp), %rcx
.L38:
	movl	(%rdx), %edi
	movl	(%rdx,%rcx,4), %r8d
	xorl	%r10d, %r10d
	cmpl	%edi, %r8d
	setl	%r10b
	cmpl	%r10d, %eax
	jne	.L37
	movl	%r8d, (%rdx)
	movl	%edi, (%rdx,%rcx,4)
.L37:
	addq	$4, %rdx
	cmpq	%r9, %rdx
	jne	.L38
.L39:
	cmpl	$1, 16(%rsp)
	movl	48(%rsp), %edi
	je	.L35
	movl	16(%rsp), %ebx
	movl	%r14d, %r15d
	movl	%esi, %edx
	movq	%r13, %r14
	movl	%ebx, 20(%rsp)
.L51:
	sarl	20(%rsp)
	movl	20(%rsp), %esi
	addl	%edx, %esi
	cmpl	%edx, %esi
	movl	%esi, 44(%rsp)
	jle	.L47
	testl	%r15d, %r15d
	movl	%esi, %ebx
	jne	.L44
	movl	%edx, %edi
	movslq	%edx, %rsi
	notl	%edi
	leaq	(%r14,%rsi,4), %rcx
	addl	%ebx, %edi
	leaq	1(%rsi,%rdi), %rsi
	leaq	(%r14,%rsi,4), %r9
	movslq	20(%rsp), %rsi
	jmp	.L46
	.p2align 4,,10
	.p2align 3
.L45:
	addq	$4, %rcx
	cmpq	%r9, %rcx
	je	.L47
.L46:
	movl	(%rcx), %edi
	movl	(%rcx,%rsi,4), %r8d
	xorl	%r10d, %r10d
	cmpl	%edi, %r8d
	setl	%r10b
	cmpl	%r10d, %eax
	jne	.L45
	movl	%r8d, (%rcx)
	movl	%edi, (%rcx,%rsi,4)
	addq	$4, %rcx
	cmpq	%r9, %rcx
	jne	.L46
.L47:
	cmpl	$1, 20(%rsp)
	movl	52(%rsp), %esi
	je	.L101
	movl	20(%rsp), %esi
	movl	%r15d, %r12d
	movq	%r14, %r15
	movl	%esi, 24(%rsp)
	movl	%edx, %esi
.L59:
	sarl	24(%rsp)
	movl	24(%rsp), %ebx
	addl	%esi, %ebx
	cmpl	%esi, %ebx
	movl	%ebx, 60(%rsp)
	jle	.L55
	movslq	%esi, %rcx
	testl	%r12d, %r12d
	leaq	(%r15,%rcx,4), %rdx
	jne	.L52
	movl	%esi, %edi
	notl	%edi
	addl	%ebx, %edi
	leaq	1(%rcx,%rdi), %rcx
	leaq	(%r15,%rcx,4), %r10
	movslq	24(%rsp), %rcx
	jmp	.L54
.L53:
	addq	$4, %rdx
	cmpq	%rdx, %r10
	je	.L55
.L54:
	movl	(%rdx), %edi
	movl	(%rdx,%rcx,4), %r8d
	xorl	%r9d, %r9d
	cmpl	%edi, %r8d
	setl	%r9b
	cmpl	%r9d, %eax
	jne	.L53
	movl	%r8d, (%rdx)
	movl	%edi, (%rdx,%rcx,4)
	addq	$4, %rdx
	cmpq	%rdx, %r10
	jne	.L54
.L55:
	cmpl	$1, 24(%rsp)
	movl	44(%rsp), %edx
	je	.L102
	movl	24(%rsp), %ebx
	movq	%r15, %r13
	movl	%ebx, 28(%rsp)
.L67:
	sarl	28(%rsp)
	movl	28(%rsp), %ebx
	addl	%esi, %ebx
	cmpl	%esi, %ebx
	movl	%ebx, 56(%rsp)
	jle	.L63
	movslq	%esi, %rcx
	testl	%r12d, %r12d
	leaq	0(%r13,%rcx,4), %rdx
	jne	.L60
	movl	%esi, %edi
	movslq	28(%rsp), %r10
	notl	%edi
	addl	%ebx, %edi
	leaq	1(%rcx,%rdi), %rcx
	leaq	0(%r13,%rcx,4), %r11
	jmp	.L62
.L61:
	addq	$4, %rdx
	cmpq	%rdx, %r11
	je	.L63
.L62:
	movl	(%rdx), %ecx
	movl	(%rdx,%r10,4), %edi
	xorl	%r8d, %r8d
	cmpl	%ecx, %edi
	setl	%r8b
	cmpl	%r8d, %eax
	jne	.L61
	movl	%edi, (%rdx)
	movl	%ecx, (%rdx,%r10,4)
	addq	$4, %rdx
	cmpq	%rdx, %r11
	jne	.L62
.L63:
	cmpl	$1, 28(%rsp)
	je	.L103
.L58:
	movl	28(%rsp), %ebp
	movq	%r13, %r14
	.p2align 4,,10
	.p2align 3
.L75:
	sarl	%ebp
	leal	0(%rbp,%rsi), %ebx
	cmpl	%esi, %ebx
	movl	%ebx, 4(%rsp)
	jle	.L71
	movslq	%esi, %rcx
	testl	%r12d, %r12d
	leaq	(%r14,%rcx,4), %rdx
	jne	.L68
	movl	%esi, %edi
	movslq	%ebp, %r10
	notl	%edi
	addl	%ebx, %edi
	leaq	1(%rcx,%rdi), %rcx
	leaq	(%r14,%rcx,4), %r11
	jmp	.L70
	.p2align 4,,10
	.p2align 3
.L69:
	addq	$4, %rdx
	cmpq	%r11, %rdx
	je	.L71
.L70:
	movl	(%rdx), %ecx
	movl	(%rdx,%r10,4), %edi
	xorl	%r8d, %r8d
	cmpl	%ecx, %edi
	setl	%r8b
	cmpl	%r8d, %eax
	jne	.L69
	movl	%edi, (%rdx)
	movl	%ecx, (%rdx,%r10,4)
	addq	$4, %rdx
	cmpq	%r11, %rdx
	jne	.L70
	.p2align 4,,10
	.p2align 3
.L71:
	cmpl	$1, %ebp
	je	.L104
.L66:
	movl	%ebp, %r15d
	.p2align 4,,10
	.p2align 3
.L74:
	sarl	%r15d
	leal	(%r15,%rsi), %r13d
	cmpl	%esi, %r13d
	jle	.L79
	movslq	%esi, %rcx
	testl	%r12d, %r12d
	leaq	(%r14,%rcx,4), %rdx
	jne	.L76
	movl	%esi, %edi
	movslq	%r15d, %r9
	notl	%edi
	addl	%r13d, %edi
	leaq	1(%rcx,%rdi), %rcx
	leaq	(%r14,%rcx,4), %r10
	jmp	.L78
	.p2align 4,,10
	.p2align 3
.L77:
	addq	$4, %rdx
	cmpq	%r10, %rdx
	je	.L79
.L78:
	movl	(%rdx), %ecx
	movl	(%rdx,%r9,4), %edi
	xorl	%r8d, %r8d
	cmpl	%ecx, %edi
	setl	%r8b
	cmpl	%r8d, %eax
	jne	.L77
	movl	%edi, (%rdx)
	movl	%ecx, (%rdx,%r9,4)
	addq	$4, %rdx
	cmpq	%r10, %rdx
	jne	.L78
	.p2align 4,,10
	.p2align 3
.L79:
	movl	%eax, %ecx
	movl	%r12d, %r8d
	movl	%r15d, %edx
	movq	%r14, %rdi
	movl	%eax, (%rsp)
	call	BitonicMerge
	cmpl	$1, %r15d
	movl	%r13d, %esi
	movl	(%rsp), %eax
	jne	.L74
	movl	4(%rsp), %esi
	jmp	.L75
.L12:
	movslq	32(%rsp), %rdi
	movl	%esi, %r8d
	notl	%r8d
	addl	%ebx, %r8d
	addq	%rcx, %rdi
	leaq	1(%rcx,%r8), %rcx
	leaq	0(%r13,%rdi,4), %rdi
	leaq	0(%r13,%rcx,4), %r10
.L16:
	movl	(%rdi), %ebx
	cmpl	%ebx, (%rdx)
	movq	%rdx, %r8
	movq	%rdi, %r9
	setg	%bl
	movzbl	%bl, %ebx
#APP
# 31 "osort_test.c" 1
	cmpl  %eax, %ebx
	movl (%r8), %eax
	movl (%r9), %ebx
	movl %eax, %ecx
	cmovel %ebx, %eax
	cmovel %ecx, %ebx
	movl %eax, (%r8)
	movl %ebx, (%r9)
# 0 "" 2
#NO_APP
	addq	$4, %rdx
	addq	$4, %rdi
	cmpq	%r10, %rdx
	jne	.L16
	jmp	.L15
.L20:
	movslq	8(%rsp), %rdi
	movl	%edx, %r8d
	movslq	%edx, %rcx
	notl	%r8d
	leaq	0(%r13,%rcx,4), %rsi
	addl	%ebx, %r8d
	addq	%rcx, %rdi
	leaq	1(%rcx,%r8), %rcx
	leaq	0(%r13,%rdi,4), %rdi
	leaq	0(%r13,%rcx,4), %r10
.L24:
	movl	(%rdi), %ebx
	cmpl	%ebx, (%rsi)
	movq	%rsi, %r8
	movq	%rdi, %r9
	setg	%bl
	movzbl	%bl, %ebx
#APP
# 31 "osort_test.c" 1
	cmpl  %eax, %ebx
	movl (%r8), %eax
	movl (%r9), %ebx
	movl %eax, %ecx
	cmovel %ebx, %eax
	cmovel %ecx, %ebx
	movl %eax, (%r8)
	movl %ebx, (%r9)
# 0 "" 2
#NO_APP
	addq	$4, %rsi
	addq	$4, %rdi
	cmpq	%r10, %rsi
	jne	.L24
	jmp	.L23
.L28:
	movslq	12(%rsp), %rsi
	movl	%edi, %r8d
	notl	%r8d
	addl	%ebx, %r8d
	addq	%rcx, %rsi
	leaq	1(%rcx,%r8), %rcx
	leaq	0(%r13,%rsi,4), %rsi
	leaq	0(%r13,%rcx,4), %r10
.L32:
	movl	(%rsi), %ebx
	cmpl	%ebx, (%rdx)
	movq	%rdx, %r8
	movq	%rsi, %r9
	setg	%bl
	movzbl	%bl, %ebx
#APP
# 31 "osort_test.c" 1
	cmpl  %eax, %ebx
	movl (%r8), %eax
	movl (%r9), %ebx
	movl %eax, %ecx
	cmovel %ebx, %eax
	cmovel %ecx, %ebx
	movl %eax, (%r8)
	movl %ebx, (%r9)
# 0 "" 2
#NO_APP
	addq	$4, %rdx
	addq	$4, %rsi
	cmpq	%r10, %rdx
	jne	.L32
	jmp	.L31
.L36:
	movslq	16(%rsp), %rdi
	movl	%esi, %r8d
	notl	%r8d
	addl	%ebx, %r8d
	addq	%rcx, %rdi
	leaq	1(%rcx,%r8), %rcx
	leaq	0(%r13,%rdi,4), %rdi
	leaq	0(%r13,%rcx,4), %r10
.L40:
	movl	(%rdi), %ebx
	cmpl	%ebx, (%rdx)
	movq	%rdx, %r8
	movq	%rdi, %r9
	setg	%bl
	movzbl	%bl, %ebx
#APP
# 31 "osort_test.c" 1
	cmpl  %eax, %ebx
	movl (%r8), %eax
	movl (%r9), %ebx
	movl %eax, %ecx
	cmovel %ebx, %eax
	cmovel %ecx, %ebx
	movl %eax, (%r8)
	movl %ebx, (%r9)
# 0 "" 2
#NO_APP
	addq	$4, %rdx
	addq	$4, %rdi
	cmpq	%r10, %rdx
	jne	.L40
	jmp	.L39
.L8:
	addq	$72, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L44:
	.cfi_restore_state
	movslq	20(%rsp), %rdi
	movl	%edx, %r8d
	movslq	%edx, %rcx
	notl	%r8d
	leaq	(%r14,%rcx,4), %rsi
	addl	%ebx, %r8d
	addq	%rcx, %rdi
	leaq	1(%rcx,%r8), %rcx
	leaq	(%r14,%rdi,4), %rdi
	leaq	(%r14,%rcx,4), %r10
.L48:
	movl	(%rdi), %ebx
	cmpl	%ebx, (%rsi)
	movq	%rsi, %r8
	movq	%rdi, %r9
	setg	%bl
	movzbl	%bl, %ebx
#APP
# 31 "osort_test.c" 1
	cmpl  %eax, %ebx
	movl (%r8), %eax
	movl (%r9), %ebx
	movl %eax, %ecx
	cmovel %ebx, %eax
	cmovel %ecx, %ebx
	movl %eax, (%r8)
	movl %ebx, (%r9)
# 0 "" 2
#NO_APP
	addq	$4, %rsi
	addq	$4, %rdi
	cmpq	%r10, %rsi
	jne	.L48
	jmp	.L47
	.p2align 4,,10
	.p2align 3
.L76:
	movl	%esi, %r8d
	movslq	%r15d, %rdi
	notl	%r8d
	addq	%rcx, %rdi
	addl	%r13d, %r8d
	leaq	(%r14,%rdi,4), %rdi
	leaq	1(%rcx,%r8), %rcx
	leaq	(%r14,%rcx,4), %r10
	.p2align 4,,10
	.p2align 3
.L80:
	movl	(%rdi), %ebx
	cmpl	%ebx, (%rdx)
	movq	%rdx, %r8
	movq	%rdi, %r9
	setg	%bl
	movzbl	%bl, %ebx
#APP
# 31 "osort_test.c" 1
	cmpl  %eax, %ebx
	movl (%r8), %eax
	movl (%r9), %ebx
	movl %eax, %ecx
	cmovel %ebx, %eax
	cmovel %ecx, %ebx
	movl %eax, (%r8)
	movl %ebx, (%r9)
# 0 "" 2
#NO_APP
	addq	$4, %rdx
	addq	$4, %rdi
	cmpq	%rdx, %r10
	jne	.L80
	jmp	.L79
.L68:
	movl	%esi, %r8d
	movslq	%ebp, %rdi
	notl	%r8d
	addq	%rcx, %rdi
	addl	%ebx, %r8d
	leaq	(%r14,%rdi,4), %rdi
	leaq	1(%rcx,%r8), %rcx
	leaq	(%r14,%rcx,4), %r11
	.p2align 4,,10
	.p2align 3
.L72:
	movl	(%rdi), %ebx
	cmpl	%ebx, (%rdx)
	movq	%rdx, %r8
	movq	%rdi, %r9
	setg	%bl
	movzbl	%bl, %ebx
#APP
# 31 "osort_test.c" 1
	cmpl  %eax, %ebx
	movl (%r8), %eax
	movl (%r9), %ebx
	movl %eax, %ecx
	cmovel %ebx, %eax
	cmovel %ecx, %ebx
	movl %eax, (%r8)
	movl %ebx, (%r9)
# 0 "" 2
#NO_APP
	addq	$4, %rdx
	addq	$4, %rdi
	cmpq	%rdx, %r11
	jne	.L72
	cmpl	$1, %ebp
	jne	.L66
.L104:
	movq	%r14, %r13
	movl	56(%rsp), %esi
	jmp	.L67
.L60:
	movslq	28(%rsp), %rdi
	movl	%esi, %r8d
	notl	%r8d
	addl	%ebx, %r8d
	addq	%rcx, %rdi
	leaq	1(%rcx,%r8), %rcx
	leaq	0(%r13,%rdi,4), %rdi
	leaq	0(%r13,%rcx,4), %r11
.L64:
	movl	(%rdi), %ebx
	cmpl	%ebx, (%rdx)
	movq	%rdx, %r8
	movq	%rdi, %r9
	setg	%bl
	movzbl	%bl, %ebx
#APP
# 31 "osort_test.c" 1
	cmpl  %eax, %ebx
	movl (%r8), %eax
	movl (%r9), %ebx
	movl %eax, %ecx
	cmovel %ebx, %eax
	cmovel %ecx, %ebx
	movl %eax, (%r8)
	movl %ebx, (%r9)
# 0 "" 2
#NO_APP
	addq	$4, %rdx
	addq	$4, %rdi
	cmpq	%rdx, %r11
	jne	.L64
	cmpl	$1, 28(%rsp)
	jne	.L58
.L103:
	movq	%r13, %r15
	movl	60(%rsp), %esi
	jmp	.L59
.L102:
	movq	%r15, %r14
	movl	%r12d, %r15d
	jmp	.L51
.L52:
	movslq	24(%rsp), %rdi
	movl	%esi, %r8d
	notl	%r8d
	addl	%ebx, %r8d
	addq	%rcx, %rdi
	leaq	1(%rcx,%r8), %rcx
	leaq	(%r15,%rdi,4), %rdi
	leaq	(%r15,%rcx,4), %r11
.L56:
	movl	(%rdi), %ebx
	cmpl	%ebx, (%rdx)
	movq	%rdx, %r8
	movq	%rdi, %r9
	setg	%bl
	movzbl	%bl, %ebx
#APP
# 31 "osort_test.c" 1
	cmpl  %eax, %ebx
	movl (%r8), %eax
	movl (%r9), %ebx
	movl %eax, %ecx
	cmovel %ebx, %eax
	cmovel %ecx, %ebx
	movl %eax, (%r8)
	movl %ebx, (%r9)
# 0 "" 2
#NO_APP
	addq	$4, %rdx
	addq	$4, %rdi
	cmpq	%rdx, %r11
	jne	.L56
	jmp	.L55
.L101:
	movq	%r14, %r13
	movl	%r15d, %r14d
	jmp	.L43
	.cfi_endproc
.LFE46:
	.size	BitonicMerge, .-BitonicMerge
	.section	.text.unlikely
.LCOLDE1:
	.text
.LHOTE1:
	.section	.text.unlikely
.LCOLDB2:
	.text
.LHOTB2:
	.p2align 4,,15
	.type	BitonicSort.part.0, @function
BitonicSort.part.0:
.LFB50:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rdi, %r15
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movl	%esi, %r13d
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movl	%edx, %ebx
	shrl	$31, %ebx
	movl	%edx, %ebp
	movl	%ecx, %eax
	addl	%edx, %ebx
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movl	%r8d, %r12d
	sarl	%ebx
	cmpl	$1, %ebx
	jle	.L106
	movl	%ecx, 12(%rsp)
	movl	%ebx, %edx
	movl	$1, %ecx
	call	BitonicSort.part.0
	leal	(%rbx,%r13), %esi
	movl	%r12d, %r8d
	xorl	%ecx, %ecx
	movl	%ebx, %edx
	movq	%r15, %rdi
	call	BitonicSort.part.0
	movl	12(%rsp), %eax
.L106:
	cmpl	$1, %ebp
	jle	.L105
	.p2align 4,,10
	.p2align 3
.L116:
	sarl	%ebp
	leal	0(%rbp,%r13), %r14d
	cmpl	%r14d, %r13d
	jge	.L114
	movslq	%r13d, %rcx
	testl	%r12d, %r12d
	leaq	(%r15,%rcx,4), %rdx
	jne	.L111
	movl	%r13d, %esi
	movslq	%ebp, %r8
	notl	%esi
	addl	%r14d, %esi
	leaq	1(%rcx,%rsi), %rcx
	leaq	(%r15,%rcx,4), %r9
	jmp	.L113
	.p2align 4,,10
	.p2align 3
.L112:
	addq	$4, %rdx
	cmpq	%rdx, %r9
	je	.L114
.L113:
	movl	(%rdx), %ecx
	movl	(%rdx,%r8,4), %esi
	xorl	%edi, %edi
	cmpl	%ecx, %esi
	setl	%dil
	cmpl	%edi, %eax
	jne	.L112
	movl	%esi, (%rdx)
	movl	%ecx, (%rdx,%r8,4)
	addq	$4, %rdx
	cmpq	%rdx, %r9
	jne	.L113
	.p2align 4,,10
	.p2align 3
.L114:
	movl	%eax, %ecx
	movl	%r13d, %esi
	movl	%r12d, %r8d
	movl	%ebp, %edx
	movq	%r15, %rdi
	movl	%eax, 12(%rsp)
	call	BitonicMerge
	cmpl	$1, %ebp
	movl	%r14d, %r13d
	movl	12(%rsp), %eax
	jne	.L116
.L105:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L111:
	.cfi_restore_state
	movl	%r13d, %edi
	movslq	%ebp, %rsi
	notl	%edi
	addq	%rcx, %rsi
	addl	%r14d, %edi
	leaq	(%r15,%rsi,4), %rsi
	leaq	1(%rcx,%rdi), %rcx
	leaq	(%r15,%rcx,4), %r9
	.p2align 4,,10
	.p2align 3
.L115:
	movl	(%rsi), %ebx
	cmpl	%ebx, (%rdx)
	movq	%rdx, %rdi
	movq	%rsi, %r8
	setg	%bl
	movzbl	%bl, %ebx
#APP
# 31 "osort_test.c" 1
	cmpl  %eax, %ebx
	movl (%rdi), %eax
	movl (%r8), %ebx
	movl %eax, %ecx
	cmovel %ebx, %eax
	cmovel %ecx, %ebx
	movl %eax, (%rdi)
	movl %ebx, (%r8)
# 0 "" 2
#NO_APP
	addq	$4, %rdx
	addq	$4, %rsi
	cmpq	%r9, %rdx
	jne	.L115
	jmp	.L114
	.cfi_endproc
.LFE50:
	.size	BitonicSort.part.0, .-BitonicSort.part.0
	.section	.text.unlikely
.LCOLDE2:
	.text
.LHOTE2:
	.section	.text.unlikely
.LCOLDB3:
	.text
.LHOTB3:
	.p2align 4,,15
	.globl	BitonicSort
	.type	BitonicSort, @function
BitonicSort:
.LFB47:
	.cfi_startproc
	cmpl	$1, %edx
	jle	.L121
	jmp	BitonicSort.part.0
	.p2align 4,,10
	.p2align 3
.L121:
	rep ret
	.cfi_endproc
.LFE47:
	.size	BitonicSort, .-BitonicSort
	.section	.text.unlikely
.LCOLDE3:
	.text
.LHOTE3:
	.section	.text.unlikely
.LCOLDB4:
	.text
.LHOTB4:
	.p2align 4,,15
	.globl	Sort
	.type	Sort, @function
Sort:
.LFB48:
	.cfi_startproc
	cmpl	$1, %esi
	jle	.L123
	movl	%ecx, %r8d
	movl	%edx, %ecx
	movl	%esi, %edx
	xorl	%esi, %esi
	jmp	BitonicSort.part.0
	.p2align 4,,10
	.p2align 3
.L123:
	rep ret
	.cfi_endproc
.LFE48:
	.size	Sort, .-Sort
	.section	.text.unlikely
.LCOLDE4:
	.text
.LHOTE4:
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC5:
	.string	"sizeof array = 2^%d = %d\n"
.LC6:
	.string	"Oblivious sort takes  %lu\n"
.LC7:
	.string	"baseline takes %lu\n"
.LC8:
	.string	"speedup = %f\n"
	.section	.text.unlikely
.LCOLDB9:
	.section	.text.startup,"ax",@progbits
.LHOTB9:
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB49:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movl	$2, %r12d
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	call	rand
	movl	$-2004318071, %edx
	movl	%eax, %r13d
	imull	%edx
	movl	%r13d, %eax
	sarl	$31, %eax
	addl	%r13d, %edx
	sarl	$3, %edx
	subl	%eax, %edx
	movl	%edx, %eax
	sall	$4, %eax
	subl	%edx, %eax
	subl	%eax, %r13d
	leal	10(%r13), %eax
	movl	%eax, %ecx
	movl	%eax, 12(%rsp)
	sall	%cl, %r12d
	movslq	%r12d, %rbx
	salq	$2, %rbx
	movq	%rbx, %rdi
	call	malloc
	movq	%rbx, %rdi
	movq	%rax, %r14
	call	malloc
	xorl	%edi, %edi
	movq	%rax, (%rsp)
	call	time
	movl	%eax, %edi
	call	srand
	testl	%r12d, %r12d
	jle	.L130
	leal	-1(%r12), %eax
	movq	(%rsp), %r13
	movq	%r14, %r15
	movl	$1801439851, %ebx
	leaq	4(%r14,%rax,4), %rbp
	.p2align 4,,10
	.p2align 3
.L129:
	call	rand
	movl	%eax, %ecx
	addq	$4, %r15
	addq	$4, %r13
	imull	%ebx
	sarl	$31, %ecx
	sarl	$22, %edx
	subl	%ecx, %edx
	movl	%edx, -4(%r15)
	movl	%edx, -4(%r13)
	cmpq	%rbp, %r15
	jne	.L129
.L130:
#APP
# 16 "osort_test.c" 1
	rdtsc
# 0 "" 2
#NO_APP
	salq	$32, %rdx
	movl	%eax, %eax
	orq	%rax, %rdx
	cmpl	$1, %r12d
	movq	%rdx, %rbp
	jle	.L128
	movl	$1, %r8d
	movl	$1, %ecx
	movl	%r12d, %edx
	xorl	%esi, %esi
	movq	%r14, %rdi
	call	BitonicSort.part.0
.L128:
#APP
# 16 "osort_test.c" 1
	rdtsc
# 0 "" 2
#NO_APP
	salq	$32, %rdx
	movl	%eax, %eax
	orq	%rax, %rdx
	cmpl	$1, %r12d
	movq	%rdx, %r14
	jle	.L131
	movq	(%rsp), %rdi
	xorl	%r8d, %r8d
	movl	$1, %ecx
	movl	%r12d, %edx
	xorl	%esi, %esi
	call	BitonicSort.part.0
.L131:
#APP
# 16 "osort_test.c" 1
	rdtsc
# 0 "" 2
#NO_APP
	movq	%rdx, %rbx
	movq	%r14, %rsi
	movl	12(%rsp), %edx
	subq	%rbp, %rsi
	salq	$32, %rbx
	movl	%eax, %eax
	orq	%rax, %rbx
	movl	%r12d, %ecx
	movq	%rsi, %rbp
	movl	$1, %edi
	movl	$.LC5, %esi
	xorl	%eax, %eax
	call	__printf_chk
	subq	%r14, %rbx
	movq	%rbp, %rdx
	movl	$.LC6, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
	xorl	%eax, %eax
	movq	%rbx, %rdx
	movl	$.LC7, %esi
	movl	$1, %edi
	call	__printf_chk
	testq	%rbx, %rbx
	js	.L132
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rbx, %xmm0
.L133:
	testq	%rbp, %rbp
	js	.L134
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbp, %xmm1
.L135:
	divsd	%xmm1, %xmm0
	movl	$.LC8, %esi
	movl	$1, %edi
	movl	$1, %eax
	call	__printf_chk
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L132:
	.cfi_restore_state
	movq	%rbx, %rax
	pxor	%xmm0, %xmm0
	shrq	%rax
	andl	$1, %ebx
	orq	%rbx, %rax
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L133
.L134:
	movq	%rbp, %rax
	pxor	%xmm1, %xmm1
	shrq	%rax
	andl	$1, %ebp
	orq	%rbp, %rax
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L135
	.cfi_endproc
.LFE49:
	.size	main, .-main
	.section	.text.unlikely
.LCOLDE9:
	.section	.text.startup
.LHOTE9:
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.5) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
