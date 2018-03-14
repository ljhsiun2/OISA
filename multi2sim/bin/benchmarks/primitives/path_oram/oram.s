	.file	"oram.c"
	.globl	seed
	.data
	.align 4
	.type	seed, @object
	.size	seed, 4
seed:
	.long	12345
	.globl	zero
	.bss
	.align 4
	.type	zero, @object
	.size	zero, 4
zero:
	.zero	4
	.globl	one
	.data
	.align 4
	.type	one, @object
	.size	one, 4
one:
	.long	1
	.globl	max_int
	.align 4
	.type	max_int, @object
	.size	max_int, 4
max_int:
	.long	268435455
	.comm	oram_tree,16,16
	.comm	oram_controller,56,32
	.globl	wb_path
	.bss
	.align 8
	.type	wb_path, @object
	.size	wb_path, 8
wb_path:
	.zero	8
	.globl	occupied
	.align 8
	.type	occupied, @object
	.size	occupied, 8
occupied:
	.zero	8
	.text
	.type	cmov, @function
cmov:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	.cfi_offset 3, -24
	movl	%edi, -12(%rbp)
	movq	%rsi, -24(%rbp)
	movq	%rdx, -32(%rbp)
	movl	-12(%rbp), %esi
	movq	-24(%rbp), %rcx
	movq	-32(%rbp), %rdx
	movl	%esi, %ebx
#APP
# 38 "oram.c" 1
	movl (%rdx), %eax
	testl %ebx, %ebx
	cmovnel (%rcx), %eax
	movl %eax, (%rdx)
# 0 "" 2
#NO_APP
	nop
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	cmov, .-cmov
	.type	cmovn, @function
cmovn:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$40, %rsp
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movl	%ecx, -24(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L3
.L4:
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rcx
	movq	-32(%rbp), %rax
	addq	%rax, %rcx
	movl	-20(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	cmov
	addl	$1, -4(%rbp)
.L3:
	movl	-4(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jl	.L4
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	cmovn, .-cmovn
	.globl	GenRandLeaf
	.type	GenRandLeaf, @function
GenRandLeaf:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	call	rand
	movl	oram_controller+12(%rip), %ecx
	cltd
	idivl	%ecx
	movl	%edx, -4(%rbp)
	movl	-4(%rbp), %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	GenRandLeaf, .-GenRandLeaf
	.globl	PushBack
	.type	PushBack, @function
PushBack:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$88, %rsp
	.cfi_offset 3, -24
	movl	%edi, -68(%rbp)
	movl	%esi, -72(%rbp)
	movq	%rdx, -80(%rbp)
	movl	%ecx, -84(%rbp)
	movl	$0, -48(%rbp)
	movl	-68(%rbp), %eax
	movl	-84(%rbp), %edx
	movl	%edx, %esi
	movl	%eax, %edi
	call	bitwiseReverse
	movl	%eax, %ebx
	movl	-72(%rbp), %eax
	movl	-84(%rbp), %edx
	movl	%edx, %esi
	movl	%eax, %edi
	call	bitwiseReverse
	xorl	%ebx, %eax
	movl	%eax, -44(%rbp)
	movl	-44(%rbp), %eax
	negl	%eax
	andl	-44(%rbp), %eax
	movl	%eax, -40(%rbp)
	movl	-40(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -36(%rbp)
	movl	$0, -56(%rbp)
	movl	$0, -52(%rbp)
	jmp	.L8
.L10:
	movl	-52(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-80(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %edx
	movl	oram_controller+4(%rip), %eax
	cmpl	%eax, %edx
	jne	.L9
	movl	-52(%rbp), %eax
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	addl	%eax, -56(%rbp)
.L9:
	addl	$1, -52(%rbp)
.L8:
	movl	-52(%rbp), %eax
	cmpl	-84(%rbp), %eax
	jl	.L10
	movl	-56(%rbp), %eax
	notl	%eax
	andl	-36(%rbp), %eax
	movl	%eax, -32(%rbp)
	movl	-32(%rbp), %eax
	movl	-84(%rbp), %edx
	movl	%edx, %esi
	movl	%eax, %edi
	call	bitwiseReverse
	movl	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
	negl	%eax
	andl	-28(%rbp), %eax
	movl	%eax, -24(%rbp)
	movl	-24(%rbp), %eax
	movl	-84(%rbp), %edx
	movl	%edx, %esi
	movl	%eax, %edi
	call	bitwiseReverse
	movl	%eax, -20(%rbp)
	cmpl	$0, -36(%rbp)
	jne	.L11
	movq	-80(%rbp), %rax
	movl	(%rax), %edx
	movl	oram_controller+4(%rip), %eax
	cmpl	%eax, %edx
	jge	.L11
	movl	$0, %eax
	jmp	.L12
.L11:
	cmpl	$0, -20(%rbp)
	jne	.L13
	movl	$-1, %eax
	jmp	.L12
.L13:
	movl	-20(%rbp), %eax
	movl	%eax, %edi
	call	log_2
.L12:
	addq	$88, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	PushBack, .-PushBack
	.globl	Init_Stash
	.type	Init_Stash, @function
Init_Stash:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, oram_controller+32(%rip)
	movl	-20(%rbp), %eax
	cltq
	salq	$4, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, oram_controller+40(%rip)
	movl	oram_controller(%rip), %eax
	movslq	%eax, %rdx
	movl	-20(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, oram_controller+48(%rip)
	movl	$0, -4(%rbp)
	jmp	.L15
.L16:
	movq	oram_controller+40(%rip), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	movl	$0, 4(%rax)
	addl	$1, -4(%rbp)
.L15:
	movl	oram_controller+32(%rip), %eax
	cmpl	-4(%rbp), %eax
	jg	.L16
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	Init_Stash, .-Init_Stash
	.globl	Init_PosMap
	.type	Init_PosMap, @function
Init_PosMap:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, oram_controller+16(%rip)
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, oram_controller+24(%rip)
	movl	$0, -4(%rbp)
	jmp	.L18
.L19:
	movq	oram_controller+24(%rip), %rcx
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$2, %rax
	addq	%rcx, %rax
	movl	$0, (%rax)
	addl	$1, -4(%rbp)
.L18:
	movl	oram_controller+16(%rip), %eax
	cmpl	-4(%rbp), %eax
	jg	.L19
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	Init_PosMap, .-Init_PosMap
	.globl	Init_ORAM_Controller
	.type	Init_ORAM_Controller, @function
Init_ORAM_Controller:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$56, %rsp
	.cfi_offset 3, -24
	movl	%edi, -36(%rbp)
	movl	%esi, -40(%rbp)
	movl	%edx, -44(%rbp)
	movl	%ecx, -48(%rbp)
	movl	%r8d, -52(%rbp)
	movl	-44(%rbp), %eax
	movl	%eax, oram_controller(%rip)
	movl	-36(%rbp), %eax
	movl	%eax, oram_controller+4(%rip)
	movl	-40(%rbp), %eax
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	subl	$1, %eax
	movl	%eax, oram_controller+8(%rip)
	movl	-40(%rbp), %eax
	subl	$1, %eax
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	movl	%eax, oram_controller+12(%rip)
	movl	-40(%rbp), %eax
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	subl	$1, %eax
	imull	-36(%rbp), %eax
	movl	%eax, -24(%rbp)
	movl	oram_controller+4(%rip), %eax
	movl	%eax, %ebx
	movl	-48(%rbp), %eax
	movl	%eax, %edi
	call	log_2
	imull	%eax, %ebx
	movl	%ebx, %edx
	movl	-52(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, %edi
	call	roundToPowerOf2
	movl	%eax, -20(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	Init_PosMap
	movl	-20(%rbp), %eax
	movl	%eax, %edi
	call	Init_Stash
	nop
	addq	$56, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	Init_ORAM_Controller, .-Init_ORAM_Controller
	.globl	Init_ORAM_Tree
	.type	Init_ORAM_Tree, @function
Init_ORAM_Tree:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 3, -24
	movl	%edi, -36(%rbp)
	movl	%esi, -40(%rbp)
	movl	%edx, -44(%rbp)
	movl	-40(%rbp), %eax
	movl	%eax, oram_tree(%rip)
	movl	-40(%rbp), %eax
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, oram_tree+8(%rip)
	movl	$0, -24(%rbp)
	jmp	.L22
.L25:
	movq	oram_tree+8(%rip), %rax
	movl	-24(%rbp), %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	leaq	(%rax,%rdx), %rbx
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, (%rbx)
	movl	$0, -20(%rbp)
	jmp	.L23
.L24:
	movq	oram_tree+8(%rip), %rax
	movl	-24(%rbp), %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	(%rax), %rcx
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movl	$0, (%rax)
	movq	oram_tree+8(%rip), %rax
	movl	-24(%rbp), %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	(%rax), %rcx
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	leaq	(%rcx,%rax), %rbx
	movl	-44(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, 16(%rbx)
	addl	$1, -20(%rbp)
.L23:
	movl	-20(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jl	.L24
	addl	$1, -24(%rbp)
.L22:
	movl	-40(%rbp), %eax
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	cmpl	-24(%rbp), %eax
	jg	.L25
	nop
	addq	$40, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	Init_ORAM_Tree, .-Init_ORAM_Tree
	.globl	Init_ORAM
	.type	Init_ORAM, @function
Init_ORAM:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	%esi, -24(%rbp)
	movl	%edx, -28(%rbp)
	movl	%ecx, -32(%rbp)
	movl	seed(%rip), %eax
	movl	%eax, %edi
	call	srand
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	log_2
	addl	$1, %eax
	movl	%eax, -4(%rbp)
	movl	-32(%rbp), %edi
	movl	-24(%rbp), %ecx
	movl	-28(%rbp), %edx
	movl	-4(%rbp), %esi
	movl	-20(%rbp), %eax
	movl	%edi, %r8d
	movl	%eax, %edi
	call	Init_ORAM_Controller
	movl	-28(%rbp), %edx
	movl	-4(%rbp), %ecx
	movl	-20(%rbp), %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	Init_ORAM_Tree
	movl	oram_tree(%rip), %eax
	movslq	%eax, %rdx
	movl	oram_controller+4(%rip), %eax
	cltq
	imulq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, wb_path(%rip)
	movl	oram_tree(%rip), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, occupied(%rip)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	Init_ORAM, .-Init_ORAM
	.globl	Free_ORAM
	.type	Free_ORAM, @function
Free_ORAM:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	oram_controller+24(%rip), %rax
	movq	%rax, %rdi
	call	free
	movq	oram_controller+40(%rip), %rax
	movq	%rax, %rdi
	call	free
	movq	oram_controller+48(%rip), %rax
	movq	%rax, %rdi
	call	free
	movl	$0, -8(%rbp)
	jmp	.L28
.L31:
	movl	$0, -4(%rbp)
	jmp	.L29
.L30:
	movq	oram_tree+8(%rip), %rax
	movl	-8(%rbp), %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	(%rax), %rcx
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movq	16(%rax), %rax
	movq	%rax, %rdi
	call	free
	addl	$1, -4(%rbp)
.L29:
	movl	oram_controller+4(%rip), %eax
	cmpl	-4(%rbp), %eax
	jg	.L30
	movq	oram_tree+8(%rip), %rax
	movl	-8(%rbp), %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	free
	addl	$1, -8(%rbp)
.L28:
	movl	oram_tree(%rip), %eax
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	cmpl	-8(%rbp), %eax
	jg	.L31
	movq	oram_tree+8(%rip), %rax
	movq	%rax, %rdi
	call	free
	movq	wb_path(%rip), %rax
	movq	%rax, %rdi
	call	free
	movq	occupied(%rip), %rax
	movq	%rax, %rdi
	call	free
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	Free_ORAM, .-Free_ORAM
	.globl	Retrieve_LeafLabel
	.type	Retrieve_LeafLabel, @function
Retrieve_LeafLabel:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$56, %rsp
	movl	%edi, -36(%rbp)
	movl	%esi, -40(%rbp)
	movq	%rdx, -48(%rbp)
	movq	%rcx, -56(%rbp)
	movl	$0, -24(%rbp)
	movl	$0, -16(%rbp)
	movl	$0, -12(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L33
.L41:
	movq	oram_controller+24(%rip), %rcx
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$2, %rax
	addq	%rcx, %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	4(%rax), %edx
	movl	-40(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L34
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	je	.L34
	movl	$1, %eax
	jmp	.L35
.L34:
	movl	$0, %eax
.L35:
	movl	%eax, -16(%rbp)
	movq	-8(%rbp), %rax
	leaq	8(%rax), %rcx
	movq	-48(%rbp), %rdx
	movl	-16(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	cmov
	movq	-8(%rbp), %rax
	leaq	8(%rax), %rdx
	movq	-56(%rbp), %rcx
	movl	-16(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	cmov
	cmpl	$2, -36(%rbp)
	jne	.L36
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jne	.L36
	cmpl	$0, -24(%rbp)
	jne	.L36
	movl	$1, %eax
	jmp	.L37
.L36:
	movl	$0, %eax
.L37:
	movl	%eax, -12(%rbp)
	movq	-8(%rbp), %rax
	leaq	4(%rax), %rdx
	leaq	-40(%rbp), %rcx
	movl	-12(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	cmov
	movq	-8(%rbp), %rdx
	movl	-12(%rbp), %eax
	movl	$one, %esi
	movl	%eax, %edi
	call	cmov
	movq	-8(%rbp), %rax
	leaq	8(%rax), %rdx
	movq	-56(%rbp), %rcx
	movl	-12(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	cmov
	cmpl	$0, -24(%rbp)
	jne	.L38
	cmpl	$0, -16(%rbp)
	jne	.L38
	cmpl	$0, -12(%rbp)
	je	.L39
.L38:
	movl	$1, %eax
	jmp	.L40
.L39:
	movl	$0, %eax
.L40:
	movl	%eax, -24(%rbp)
	addl	$1, -20(%rbp)
.L33:
	movl	oram_controller+16(%rip), %eax
	cmpl	-20(%rbp), %eax
	jg	.L41
	cmpl	$0, -24(%rbp)
	jne	.L42
	movl	$1, %eax
	jmp	.L43
.L42:
	movl	$0, %eax
.L43:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	Retrieve_LeafLabel, .-Retrieve_LeafLabel
	.section	.rodata
.LC0:
	.string	"oram.c"
.LC1:
	.string	"!Stash_Full()"
	.text
	.globl	Fetch_Blocks
	.type	Fetch_Blocks, @function
Fetch_Blocks:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movl	%edi, -84(%rbp)
	movl	%esi, -88(%rbp)
	movq	%rdx, -96(%rbp)
	movl	%ecx, -100(%rbp)
	movl	%r8d, -104(%rbp)
	movl	$1, -72(%rbp)
	movl	oram_tree(%rip), %eax
	leal	-1(%rax), %edx
	movl	-100(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	bitwiseReverse
	movl	%eax, -68(%rbp)
	movl	$0, -64(%rbp)
	jmp	.L45
.L52:
	movq	oram_tree+8(%rip), %rax
	movl	-72(%rbp), %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	movl	$0, -60(%rbp)
	jmp	.L46
.L51:
	movl	$0, -56(%rbp)
	jmp	.L47
.L50:
	movl	-56(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	je	.L48
	movq	oram_controller+40(%rip), %rax
	movl	-60(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	movl	4(%rax), %eax
	testl	%eax, %eax
	jne	.L48
	movl	$1, %eax
	jmp	.L49
.L48:
	movl	$0, %eax
.L49:
	movl	%eax, -44(%rbp)
	movq	oram_controller+40(%rip), %rax
	movl	-60(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	leaq	4(%rax), %rcx
	movl	-56(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rsi
	movl	-44(%rbp), %eax
	movq	%rcx, %rdx
	movl	%eax, %edi
	call	cmov
	movq	oram_controller+40(%rip), %rax
	movl	-60(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	leaq	8(%rax), %rsi
	movl	-56(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	leaq	4(%rax), %rcx
	movl	-44(%rbp), %eax
	movq	%rsi, %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	cmov
	movq	oram_controller+40(%rip), %rax
	movl	-60(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	leaq	12(%rax), %rsi
	movl	-56(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	leaq	8(%rax), %rcx
	movl	-44(%rbp), %eax
	movq	%rsi, %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	cmov
	movl	-56(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdx
	movl	-44(%rbp), %eax
	movl	$zero, %esi
	movl	%eax, %edi
	call	cmov
	movl	oram_controller(%rip), %ecx
	movq	oram_controller+48(%rip), %rdx
	movl	oram_controller(%rip), %eax
	imull	-60(%rbp), %eax
	cltq
	salq	$2, %rax
	leaq	(%rdx,%rax), %rdi
	movl	-56(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	16(%rax), %rsi
	movl	-44(%rbp), %eax
	movq	%rdi, %rdx
	movl	%eax, %edi
	call	cmovn
	addl	$1, -56(%rbp)
.L47:
	movl	oram_controller+4(%rip), %eax
	cmpl	-56(%rbp), %eax
	jg	.L50
	addl	$1, -60(%rbp)
.L46:
	movl	oram_controller+32(%rip), %eax
	cmpl	-60(%rbp), %eax
	jg	.L51
	movl	-72(%rbp), %eax
	leal	(%rax,%rax), %ecx
	movl	-68(%rbp), %eax
	cltd
	shrl	$31, %edx
	addl	%edx, %eax
	andl	$1, %eax
	subl	%edx, %eax
	addl	%ecx, %eax
	movl	%eax, -72(%rbp)
	movl	-68(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, -68(%rbp)
	addl	$1, -64(%rbp)
.L45:
	movl	oram_tree(%rip), %eax
	cmpl	-64(%rbp), %eax
	jg	.L52
	movl	$0, %eax
	call	Stash_Full
	testl	%eax, %eax
	je	.L53
	movl	$__PRETTY_FUNCTION__.3216, %ecx
	movl	$275, %edx
	movl	$.LC0, %esi
	movl	$.LC1, %edi
	call	__assert_fail
.L53:
	movl	$0, -52(%rbp)
	movl	$0, -48(%rbp)
	jmp	.L54
.L66:
	movq	oram_controller+40(%rip), %rax
	movl	-48(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	movq	%rax, -16(%rbp)
	movq	oram_controller+48(%rip), %rdx
	movl	oram_controller(%rip), %eax
	imull	-48(%rbp), %eax
	cltq
	salq	$2, %rax
	addq	%rdx, %rax
	movq	%rax, -8(%rbp)
	movq	-16(%rbp), %rax
	movl	8(%rax), %edx
	movl	-88(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L55
	movq	-16(%rbp), %rax
	movl	4(%rax), %eax
	testl	%eax, %eax
	je	.L55
	movl	$1, %eax
	jmp	.L56
.L55:
	movl	$0, %eax
.L56:
	movl	%eax, -40(%rbp)
	cmpl	$0, -40(%rbp)
	je	.L57
	cmpl	$1, -84(%rbp)
	jne	.L57
	movl	$1, %eax
	jmp	.L58
.L57:
	movl	$0, %eax
.L58:
	movl	%eax, -36(%rbp)
	cmpl	$0, -40(%rbp)
	je	.L59
	cmpl	$2, -84(%rbp)
	jne	.L59
	movl	$1, %eax
	jmp	.L60
.L59:
	movl	$0, %eax
.L60:
	movl	%eax, -32(%rbp)
	movq	-16(%rbp), %rax
	leaq	12(%rax), %rdx
	leaq	-104(%rbp), %rcx
	movl	-40(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	cmov
	movl	oram_controller(%rip), %ecx
	movq	-96(%rbp), %rdx
	movq	-8(%rbp), %rsi
	movl	-36(%rbp), %eax
	movl	%eax, %edi
	call	cmovn
	movl	oram_controller(%rip), %ecx
	movq	-8(%rbp), %rdx
	movq	-96(%rbp), %rsi
	movl	-32(%rbp), %eax
	movl	%eax, %edi
	call	cmovn
	cmpl	$0, -52(%rbp)
	jne	.L61
	movq	-16(%rbp), %rax
	movl	4(%rax), %eax
	testl	%eax, %eax
	jne	.L61
	cmpl	$2, -84(%rbp)
	jne	.L61
	movl	$1, %eax
	jmp	.L62
.L61:
	movl	$0, %eax
.L62:
	movl	%eax, -28(%rbp)
	cmpl	$0, -52(%rbp)
	jne	.L63
	cmpl	$0, -28(%rbp)
	je	.L64
.L63:
	movl	$1, %eax
	jmp	.L65
.L64:
	movl	$0, %eax
.L65:
	movl	%eax, -52(%rbp)
	movq	-16(%rbp), %rax
	leaq	4(%rax), %rdx
	movl	-28(%rbp), %eax
	movl	$one, %esi
	movl	%eax, %edi
	call	cmov
	movq	-16(%rbp), %rax
	leaq	8(%rax), %rdx
	leaq	-88(%rbp), %rcx
	movl	-28(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	cmov
	movq	-16(%rbp), %rax
	leaq	12(%rax), %rdx
	leaq	-104(%rbp), %rcx
	movl	-28(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	cmov
	movl	oram_controller(%rip), %ecx
	movq	-8(%rbp), %rdx
	movq	-96(%rbp), %rsi
	movl	-28(%rbp), %eax
	movl	%eax, %edi
	call	cmovn
	addl	$1, -48(%rbp)
.L54:
	movl	oram_controller+32(%rip), %eax
	cmpl	-48(%rbp), %eax
	jg	.L66
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	Fetch_Blocks, .-Fetch_Blocks
	.globl	Store_Blocks
	.type	Store_Blocks, @function
Store_Blocks:
.LFB14:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$96, %rsp
	movl	%edi, -84(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, -68(%rbp)
	jmp	.L68
.L69:
	movq	wb_path(%rip), %rax
	movl	-68(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	$-1, (%rax)
	addl	$1, -68(%rbp)
.L68:
	movl	oram_tree(%rip), %edx
	movl	oram_controller+4(%rip), %eax
	imull	%edx, %eax
	cmpl	-68(%rbp), %eax
	jg	.L69
	movl	$0, -64(%rbp)
	jmp	.L70
.L71:
	movq	occupied(%rip), %rax
	movl	-64(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	$0, (%rax)
	addl	$1, -64(%rbp)
.L70:
	movl	oram_tree(%rip), %eax
	cmpl	-64(%rbp), %eax
	jg	.L71
	movl	$0, -80(%rbp)
	jmp	.L72
.L75:
	movq	oram_controller+40(%rip), %rax
	movl	-80(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	movl	4(%rax), %eax
	movl	%eax, -40(%rbp)
	movq	oram_controller+40(%rip), %rax
	movl	-80(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	movl	12(%rax), %eax
	movl	%eax, -36(%rbp)
	movl	oram_tree(%rip), %ecx
	movq	occupied(%rip), %rdx
	movl	-36(%rbp), %esi
	movl	-84(%rbp), %eax
	movl	%eax, %edi
	call	PushBack
	movl	%eax, -32(%rbp)
	cmpl	$0, -40(%rbp)
	je	.L73
	cmpl	$0, -32(%rbp)
	js	.L73
	movl	$1, %eax
	jmp	.L74
.L73:
	movl	$0, %eax
.L74:
	movl	%eax, -28(%rbp)
	movl	oram_controller+4(%rip), %eax
	imull	-32(%rbp), %eax
	movl	%eax, %edx
	movq	occupied(%rip), %rax
	movl	-32(%rbp), %ecx
	movslq	%ecx, %rcx
	salq	$2, %rcx
	addq	%rcx, %rax
	movl	(%rax), %eax
	addl	%edx, %eax
	movl	%eax, -76(%rbp)
	movq	wb_path(%rip), %rax
	movl	-76(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rax, %rdx
	leaq	-80(%rbp), %rcx
	movl	-28(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	cmov
	movq	occupied(%rip), %rax
	movl	-32(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	addl	$1, %eax
	movl	%eax, -72(%rbp)
	movq	occupied(%rip), %rax
	movl	-32(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rax, %rdx
	leaq	-72(%rbp), %rcx
	movl	-28(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	cmov
	movq	oram_controller+40(%rip), %rax
	movl	-80(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	movq	%rax, %rdx
	leaq	-76(%rbp), %rcx
	movl	-28(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	cmov
	movq	oram_controller+40(%rip), %rax
	movl	-80(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	movq	%rax, %rdx
	cmpl	$0, -28(%rbp)
	sete	%al
	movzbl	%al, %eax
	movl	$max_int, %esi
	movl	%eax, %edi
	call	cmov
	movl	-80(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -80(%rbp)
.L72:
	movl	oram_controller+32(%rip), %edx
	movl	-80(%rbp), %eax
	cmpl	%eax, %edx
	jg	.L75
	movl	oram_controller(%rip), %ecx
	movl	oram_controller+32(%rip), %edx
	movq	oram_controller+48(%rip), %rsi
	movq	oram_controller+40(%rip), %rax
	movl	%ecx, %r9d
	movl	$4, %r8d
	movl	$1, %ecx
	movq	%rax, %rdi
	call	BitonicSort_TwoArray
	movl	$1, -60(%rbp)
	movl	$0, -56(%rbp)
	movl	oram_tree(%rip), %eax
	leal	-1(%rax), %edx
	movl	-84(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	bitwiseReverse
	movl	%eax, -52(%rbp)
	movl	$0, -48(%rbp)
	jmp	.L76
.L80:
	movq	oram_tree+8(%rip), %rax
	movl	-60(%rbp), %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -16(%rbp)
	movl	$0, -44(%rbp)
	jmp	.L77
.L79:
	movq	wb_path(%rip), %rdx
	movl	oram_controller+4(%rip), %eax
	imull	-48(%rbp), %eax
	movl	%eax, %ecx
	movl	-44(%rbp), %eax
	addl	%ecx, %eax
	cltq
	salq	$2, %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -24(%rbp)
	cmpl	$-1, -24(%rbp)
	setne	%al
	movzbl	%al, %eax
	movl	%eax, -20(%rbp)
	movl	-44(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rsi
	movq	oram_controller+40(%rip), %rax
	movl	-56(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	leaq	4(%rax), %rcx
	movl	-20(%rbp), %eax
	movq	%rsi, %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	cmov
	movl	-44(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	leaq	4(%rax), %rdx
	movq	oram_controller+40(%rip), %rax
	movl	-56(%rbp), %ecx
	movslq	%ecx, %rcx
	salq	$4, %rcx
	addq	%rcx, %rax
	leaq	8(%rax), %rcx
	movl	-20(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	cmov
	movl	-44(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	leaq	8(%rax), %rdx
	movq	oram_controller+40(%rip), %rax
	movl	-56(%rbp), %ecx
	movslq	%ecx, %rcx
	salq	$4, %rcx
	addq	%rcx, %rax
	leaq	12(%rax), %rcx
	movl	-20(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	cmov
	movq	oram_controller+40(%rip), %rax
	movl	-56(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	leaq	4(%rax), %rdx
	movl	-20(%rbp), %eax
	movl	$zero, %esi
	movl	%eax, %edi
	call	cmov
	movl	oram_controller(%rip), %ecx
	movl	-44(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movq	16(%rax), %rdx
	movq	oram_controller+48(%rip), %rsi
	movl	oram_controller(%rip), %eax
	imull	-56(%rbp), %eax
	cltq
	salq	$2, %rax
	addq	%rax, %rsi
	movl	-20(%rbp), %eax
	movl	%eax, %edi
	call	cmovn
	cmpl	$0, -20(%rbp)
	je	.L78
	addl	$1, -56(%rbp)
.L78:
	addl	$1, -44(%rbp)
.L77:
	movl	oram_controller+4(%rip), %eax
	cmpl	-44(%rbp), %eax
	jg	.L79
	movl	-60(%rbp), %eax
	leal	(%rax,%rax), %ecx
	movl	-52(%rbp), %eax
	cltd
	shrl	$31, %edx
	addl	%edx, %eax
	andl	$1, %eax
	subl	%edx, %eax
	addl	%ecx, %eax
	movl	%eax, -60(%rbp)
	movl	-52(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, -52(%rbp)
	addl	$1, -48(%rbp)
.L76:
	movl	oram_tree(%rip), %eax
	cmpl	-48(%rbp), %eax
	jg	.L80
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L81
	call	__stack_chk_fail
.L81:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	Store_Blocks, .-Store_Blocks
	.section	.rodata
.LC2:
	.string	"op == READ || op == WRITE"
.LC3:
	.string	"READ"
.LC4:
	.string	"WRITE"
	.align 8
.LC5:
	.string	" id = %d failed: No such id exists, and no empty slot in ORAM.\n"
	.align 8
.LC6:
	.string	"(op == READ && Find_PosMap(id) == -1) || (op == WRITE && Find_PosMap(id) == -1 && PosMap_Full())"
	.align 8
.LC7:
	.string	"OMG! Bug in program: check Retrieve_LeafLabel.\n"
.LC8:
	.string	"0"
	.text
	.globl	Access_ORAM
	.type	Access_ORAM, @function
Access_ORAM:
.LFB15:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	%edi, -36(%rbp)
	movl	%esi, -40(%rbp)
	movq	%rdx, -48(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	cmpl	$1, -36(%rbp)
	je	.L83
	cmpl	$2, -36(%rbp)
	je	.L83
	movl	$__PRETTY_FUNCTION__.3268, %ecx
	movl	$373, %edx
	movl	$.LC0, %esi
	movl	$.LC2, %edi
	call	__assert_fail
.L83:
	movl	$0, %eax
	call	GenRandLeaf
	movl	%eax, -20(%rbp)
	movl	$0, %eax
	call	GenRandLeaf
	movl	%eax, -16(%rbp)
	leaq	-16(%rbp), %rcx
	leaq	-20(%rbp), %rdx
	movl	-40(%rbp), %esi
	movl	-36(%rbp), %eax
	movl	%eax, %edi
	call	Retrieve_LeafLabel
	movl	%eax, -12(%rbp)
	cmpl	$0, -12(%rbp)
	je	.L84
	cmpl	$1, -36(%rbp)
	jne	.L85
	movl	$.LC3, %edx
	jmp	.L86
.L85:
	movl	$.LC4, %edx
.L86:
	movq	stderr(%rip), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movq	stderr(%rip), %rax
	movl	-40(%rbp), %edx
	movl	$.LC5, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	cmpl	$1, -36(%rbp)
	jne	.L87
	movl	-40(%rbp), %eax
	movl	%eax, %edi
	call	Find_PosMap
	cmpl	$-1, %eax
	je	.L88
.L87:
	cmpl	$2, -36(%rbp)
	jne	.L89
	movl	-40(%rbp), %eax
	movl	%eax, %edi
	call	Find_PosMap
	cmpl	$-1, %eax
	jne	.L89
	movl	$0, %eax
	call	PosMap_Full
	testl	%eax, %eax
	jne	.L88
.L89:
	movl	$__PRETTY_FUNCTION__.3268, %ecx
	movl	$382, %edx
	movl	$.LC0, %esi
	movl	$.LC6, %edi
	call	__assert_fail
.L88:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$47, %edx
	movl	$1, %esi
	movl	$.LC7, %edi
	call	fwrite
	movl	$__PRETTY_FUNCTION__.3268, %ecx
	movl	$385, %edx
	movl	$.LC0, %esi
	movl	$.LC8, %edi
	call	__assert_fail
.L84:
	movl	-16(%rbp), %edi
	movl	-20(%rbp), %ecx
	movq	-48(%rbp), %rdx
	movl	-40(%rbp), %esi
	movl	-36(%rbp), %eax
	movl	%edi, %r8d
	movl	%eax, %edi
	call	Fetch_Blocks
	movl	-20(%rbp), %eax
	movl	%eax, %edi
	call	Store_Blocks
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L90
	call	__stack_chk_fail
.L90:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	Access_ORAM, .-Access_ORAM
	.section	.rodata
	.align 8
.LC9:
	.string	"To print function timing information, turn on MEASURE_FUNC_TIME flag."
	.text
	.globl	Print_Func_Time_Stats
	.type	Print_Func_Time_Stats, @function
Print_Func_Time_Stats:
.LFB16:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	$.LC9, %edi
	call	puts
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	Print_Func_Time_Stats, .-Print_Func_Time_Stats
	.globl	Print_All
	.type	Print_All, @function
Print_All:
.LFB17:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	Print_All, .-Print_All
	.globl	Print_ORAM
	.type	Print_ORAM, @function
Print_ORAM:
.LFB18:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE18:
	.size	Print_ORAM, .-Print_ORAM
	.globl	Print_Stash
	.type	Print_Stash, @function
Print_Stash:
.LFB19:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE19:
	.size	Print_Stash, .-Print_Stash
	.globl	Print_PosMap
	.type	Print_PosMap, @function
Print_PosMap:
.LFB20:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE20:
	.size	Print_PosMap, .-Print_PosMap
	.section	.rodata
.LC10:
	.string	"idx == -1"
	.text
	.globl	Find_PosMap
	.type	Find_PosMap, @function
Find_PosMap:
.LFB21:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	$-1, -8(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L97
.L100:
	movq	oram_controller+24(%rip), %rcx
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$2, %rax
	addq	%rcx, %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	je	.L98
	movq	oram_controller+24(%rip), %rcx
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$2, %rax
	addq	%rcx, %rax
	movl	4(%rax), %eax
	cmpl	-20(%rbp), %eax
	jne	.L98
	cmpl	$-1, -8(%rbp)
	je	.L99
	movl	$__PRETTY_FUNCTION__.3288, %ecx
	movl	$465, %edx
	movl	$.LC0, %esi
	movl	$.LC10, %edi
	call	__assert_fail
.L99:
	movl	-4(%rbp), %eax
	movl	%eax, -8(%rbp)
.L98:
	addl	$1, -4(%rbp)
.L97:
	movl	oram_controller+16(%rip), %eax
	cmpl	-4(%rbp), %eax
	jg	.L100
	movl	-8(%rbp), %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE21:
	.size	Find_PosMap, .-Find_PosMap
	.globl	PosMap_Full
	.type	PosMap_Full, @function
PosMap_Full:
.LFB22:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$0, -4(%rbp)
	jmp	.L103
.L106:
	movq	oram_controller+24(%rip), %rcx
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$2, %rax
	addq	%rcx, %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jne	.L104
	movl	$0, %eax
	jmp	.L105
.L104:
	addl	$1, -4(%rbp)
.L103:
	movl	oram_controller+16(%rip), %eax
	cmpl	-4(%rbp), %eax
	jg	.L106
	movl	$1, %eax
.L105:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE22:
	.size	PosMap_Full, .-PosMap_Full
	.globl	Stash_Full
	.type	Stash_Full, @function
Stash_Full:
.LFB23:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$0, -4(%rbp)
	jmp	.L108
.L111:
	movq	oram_controller+40(%rip), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	movl	4(%rax), %eax
	testl	%eax, %eax
	jne	.L109
	movl	$0, %eax
	jmp	.L110
.L109:
	addl	$1, -4(%rbp)
.L108:
	movl	oram_controller+32(%rip), %eax
	cmpl	-4(%rbp), %eax
	jg	.L111
	movl	$1, %eax
.L110:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE23:
	.size	Stash_Full, .-Stash_Full
	.section	.rodata
	.align 8
	.type	__PRETTY_FUNCTION__.3216, @object
	.size	__PRETTY_FUNCTION__.3216, 13
__PRETTY_FUNCTION__.3216:
	.string	"Fetch_Blocks"
	.align 8
	.type	__PRETTY_FUNCTION__.3268, @object
	.size	__PRETTY_FUNCTION__.3268, 12
__PRETTY_FUNCTION__.3268:
	.string	"Access_ORAM"
	.align 8
	.type	__PRETTY_FUNCTION__.3288, @object
	.size	__PRETTY_FUNCTION__.3288, 12
__PRETTY_FUNCTION__.3288:
	.string	"Find_PosMap"
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.5) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
