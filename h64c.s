	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 14, 0
	.globl	_run_compile                    ## -- Begin function run_compile
	.p2align	4, 0x90
_run_compile:                           ## @run_compile
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$56, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rdi, %rbx
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	callq	_strlen
	leaq	1(%rax), %rdi
	callq	_malloc
	movq	%rax, _file(%rip)
	movq	%rax, %rdi
	movq	%rbx, %rsi
	callq	_strcpy
	leaq	L_.str(%rip), %rsi
	movq	%rbx, %rdi
	callq	_fopen
	testq	%rax, %rax
	je	LBB0_1
## %bb.2:
	movq	%rax, %r13
	xorl	%r14d, %r14d
	movq	%rax, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	_fseek
	movq	%r13, %rdi
	callq	_ftell
	movq	%rax, %r15
	movq	%r13, %rdi
	xorl	%esi, %esi
	xorl	%edx, %edx
	callq	_fseek
	movq	%rsp, -56(%rbp)                 ## 8-byte Spill
	leaq	1(%r15), %rax
	callq	____chkstk_darwin
	addq	$15, %rax
	andq	$-16, %rax
	subq	%rax, %rsp
	movq	%rsp, %r12
	movl	$1, %esi
	movq	%r12, %rdi
	movq	%r15, %rdx
	movq	%r13, %rcx
	callq	_fread
	movb	$0, (%r12,%r15)
	movq	%r13, %rdi
	callq	_fclose
	testq	%r15, %r15
	je	LBB0_17
## %bb.3:
	xorl	%ecx, %ecx
	xorl	%esi, %esi
	xorl	%eax, %eax
	jmp	LBB0_4
	.p2align	4, 0x90
LBB0_10:                                ##   in Loop: Header=BB0_4 Depth=1
	testl	%eax, %eax
	je	LBB0_11
LBB0_16:                                ##   in Loop: Header=BB0_4 Depth=1
	andb	%cl, %dl
	incl	%r14d
	movslq	%r14d, %rcx
	movl	%edx, %esi
	cmpq	%rcx, %r15
	jbe	LBB0_17
LBB0_4:                                 ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB0_14 Depth 2
	movl	%eax, %edx
	movzbl	(%r12,%rcx), %edi
	cmpl	$92, %edi
	sete	%cl
	xorl	%eax, %eax
	testl	%edx, %edx
	sete	%al
	testb	$1, %sil
	cmovnel	%edx, %eax
	cmpl	$34, %edi
	cmovnel	%edx, %eax
	testl	%eax, %eax
	setne	%dl
	cmpl	$10, %edi
	jne	LBB0_7
## %bb.5:                               ##   in Loop: Header=BB0_4 Depth=1
	testl	%eax, %eax
	jne	LBB0_6
LBB0_7:                                 ##   in Loop: Header=BB0_4 Depth=1
	xorb	$1, %sil
	andb	%sil, %cl
	cmpl	$35, %edi
	je	LBB0_10
## %bb.8:                               ##   in Loop: Header=BB0_4 Depth=1
	cmpl	$59, %edi
	je	LBB0_10
## %bb.9:                               ##   in Loop: Header=BB0_4 Depth=1
	cmpb	$64, %dil
	je	LBB0_10
	jmp	LBB0_16
	.p2align	4, 0x90
LBB0_11:                                ##   in Loop: Header=BB0_4 Depth=1
	movslq	%r14d, %rsi
	cmpb	$10, (%r12,%rsi)
	je	LBB0_16
## %bb.12:                              ##   in Loop: Header=BB0_4 Depth=1
	cmpq	%rsi, %r15
	jbe	LBB0_16
## %bb.13:                              ##   in Loop: Header=BB0_4 Depth=1
	incq	%rsi
	.p2align	4, 0x90
LBB0_14:                                ##   Parent Loop BB0_4 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movb	$32, -1(%r12,%rsi)
	incl	%r14d
	cmpb	$10, (%r12,%rsi)
	je	LBB0_16
## %bb.15:                              ##   in Loop: Header=BB0_14 Depth=2
	leaq	1(%rsi), %rdi
	cmpq	%rsi, %r15
	movq	%rdi, %rsi
	ja	LBB0_14
	jmp	LBB0_16
LBB0_17:
	movl	$32768, %edi                    ## imm = 0x8000
	callq	_malloc
	movq	%rax, %rbx
	movq	%r12, _src(%rip)
	cmpb	$0, (%r12)
	je	LBB0_18
## %bb.19:
	xorl	%r15d, %r15d
	leaq	-88(%rbp), %r14
	movq	%rbx, %r12
	movq	-56(%rbp), %r13                 ## 8-byte Reload
	.p2align	4, 0x90
LBB0_20:                                ## =>This Inner Loop Header: Depth=1
	incq	%r15
	movq	%r14, %rdi
	callq	_nextToken
	movups	-88(%rbp), %xmm0
	movups	-72(%rbp), %xmm1
	movups	%xmm1, 16(%r12)
	movups	%xmm0, (%r12)
	movq	_src(%rip), %rax
	addq	$32, %r12
	cmpb	$0, (%rax)
	jne	LBB0_20
	jmp	LBB0_21
LBB0_1:
	leaq	L_.str.1(%rip), %rdi
	xorl	%r15d, %r15d
	movq	%rbx, %rsi
	xorl	%eax, %eax
	callq	_printf
	jmp	LBB0_23
LBB0_6:
	leaq	L_.str.2(%rip), %rdi
	xorl	%r15d, %r15d
	movq	%rbx, %rsi
	movl	%r14d, %edx
	xorl	%eax, %eax
	callq	_printf
	movq	-56(%rbp), %r13                 ## 8-byte Reload
	jmp	LBB0_22
LBB0_18:
	xorl	%r15d, %r15d
	movq	-56(%rbp), %r13                 ## 8-byte Reload
LBB0_21:
	shlq	$5, %r15
	movq	$0, (%rbx,%r15)
	movl	$-1, 8(%rbx,%r15)
	xorps	%xmm0, %xmm0
	movups	%xmm0, 12(%rbx,%r15)
	movl	$0, 28(%rbx,%r15)
	movq	%rbx, %rdi
	callq	_compile
	movq	%rax, %r15
LBB0_22:
	movq	%r13, %rsp
LBB0_23:
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	cmpq	-48(%rbp), %rax
	jne	LBB0_25
## %bb.24:
	movq	%r15, %rax
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
LBB0_25:
	callq	___stack_chk_fail
	.cfi_endproc
                                        ## -- End function
	.globl	_parse                          ## -- Begin function parse
	.p2align	4, 0x90
_parse:                                 ## @parse
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
	subq	$32, %rsp
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rdi, %r14
	movl	$32768, %edi                    ## imm = 0x8000
	callq	_malloc
	movq	%rax, %rbx
	movq	%r14, _src(%rip)
	cmpb	$0, (%r14)
	je	LBB1_1
## %bb.2:
	xorl	%r15d, %r15d
	leaq	-64(%rbp), %r14
	movq	%rbx, %r12
	.p2align	4, 0x90
LBB1_3:                                 ## =>This Inner Loop Header: Depth=1
	incq	%r15
	movq	%r14, %rdi
	callq	_nextToken
	movups	-64(%rbp), %xmm0
	movups	-48(%rbp), %xmm1
	movups	%xmm1, 16(%r12)
	movups	%xmm0, (%r12)
	movq	_src(%rip), %rax
	addq	$32, %r12
	cmpb	$0, (%rax)
	jne	LBB1_3
	jmp	LBB1_4
LBB1_1:
	xorl	%r15d, %r15d
LBB1_4:
	shlq	$5, %r15
	movq	$0, (%rbx,%r15)
	movl	$-1, 8(%rbx,%r15)
	xorps	%xmm0, %xmm0
	movups	%xmm0, 12(%rbx,%r15)
	movl	$0, 28(%rbx,%r15)
	movq	%rbx, %rax
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_compile                        ## -- Begin function compile
	.p2align	4, 0x90
_compile:                               ## @compile
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$552, %rsp                      ## imm = 0x228
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rdi, %r12
	movl	$8, %edi
	callq	_malloc
	movq	%rax, %r14
	movl	$96, %edi
	callq	_malloc
	movq	%rax, %r13
	movq	%r14, -328(%rbp)                ## 8-byte Spill
	movq	%rax, (%r14)
	movw	$1, (%rax)
	leaq	LJTI2_0(%rip), %r14
	leaq	LJTI2_1(%rip), %r15
	movq	%rax, -48(%rbp)                 ## 8-byte Spill
	jmp	LBB2_4
	.p2align	4, 0x90
LBB2_1:                                 ##   in Loop: Header=BB2_4 Depth=1
	movb	$0, (%rcx)
LBB2_2:                                 ##   in Loop: Header=BB2_4 Depth=1
	movq	%r13, %rdi
	movq	%rax, %rsi
	callq	_add_symbol
	movq	88(%r13), %rcx
	cltq
	leaq	(%rax,%rax,2), %rax
	movq	$0, 8(%rcx,%rax,8)
LBB2_3:                                 ##   in Loop: Header=BB2_4 Depth=1
	addq	$32, %r12
LBB2_4:                                 ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB2_95 Depth 2
                                        ##     Child Loop BB2_66 Depth 2
                                        ##     Child Loop BB2_476 Depth 2
                                        ##     Child Loop BB2_447 Depth 2
                                        ##     Child Loop BB2_399 Depth 2
                                        ##     Child Loop BB2_355 Depth 2
                                        ##     Child Loop BB2_310 Depth 2
                                        ##     Child Loop BB2_167 Depth 2
	movl	8(%r12), %eax
	incl	%eax
	cmpl	$7, %eax
	ja	LBB2_3
## %bb.5:                               ##   in Loop: Header=BB2_4 Depth=1
	movslq	(%r14,%rax,4), %rax
	addq	%r14, %rax
	jmpq	*%rax
LBB2_6:                                 ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r12), %r15
	movq	%r15, %rdi
	leaq	L_.str.3(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_113
## %bb.7:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.4(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_112
## %bb.8:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.5(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_112
## %bb.9:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.6(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_129
## %bb.10:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.11(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_148
## %bb.11:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.13(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_192
## %bb.12:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.14(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_217
## %bb.13:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.15(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_272
## %bb.14:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.17(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_337
## %bb.15:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.18(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_377
## %bb.16:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.19(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_419
## %bb.17:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.20(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_463
## %bb.18:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.21(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_493
## %bb.19:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.22(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_504
## %bb.20:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.23(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_513
## %bb.21:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.24(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_520
## %bb.22:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.25(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_527
## %bb.23:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.26(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_532
## %bb.24:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.27(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_536
## %bb.25:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.28(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_540
## %bb.26:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.29(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_544
## %bb.27:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.30(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_548
## %bb.28:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.31(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_552
## %bb.29:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.32(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_557
## %bb.30:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.33(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_561
## %bb.31:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.34(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_571
## %bb.32:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.35(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_574
## %bb.33:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.36(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_575
## %bb.34:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.37(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_576
## %bb.35:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.38(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_578
## %bb.36:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.39(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_579
## %bb.37:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.40(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_583
## %bb.38:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.41(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_584
## %bb.39:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.42(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_588
## %bb.40:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.43(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_591
## %bb.41:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.44(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_599
## %bb.42:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.45(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_606
## %bb.43:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.46(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_612
## %bb.44:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.47(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_619
## %bb.45:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.48(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_626
## %bb.46:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.49(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_633
## %bb.47:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.50(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_640
## %bb.48:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.51(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_647
## %bb.49:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.52(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_654
## %bb.50:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.53(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_662
## %bb.51:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.54(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_668
## %bb.52:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.55(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_671
## %bb.53:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.56(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_678
## %bb.54:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%r15, %rdi
	leaq	L_.str.57(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	jne	LBB2_726
## %bb.55:                              ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, 40(%r12)
	jne	LBB2_709
## %bb.56:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	32(%r12), %rdi
	incq	%rdi
	callq	_parse8
	cmpl	$0, 72(%r12)
	jne	LBB2_727
## %bb.57:                              ##   in Loop: Header=BB2_4 Depth=1
	movl	%eax, %r15d
	movq	64(%r12), %rbx
	movq	%rbx, %rdi
	leaq	L_.str.59(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_679
## %bb.58:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%rbx, %rdi
	leaq	L_.str.60(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_680
## %bb.59:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%rbx, %rdi
	leaq	L_.str.61(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_61
## %bb.60:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%rbx, %rdi
	leaq	L_.str.62(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	jne	LBB2_728
LBB2_61:                                ##   in Loop: Header=BB2_4 Depth=1
	movq	%rbx, %rdi
	leaq	L_.str.61(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_681
## %bb.62:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%rbx, %rdi
	leaq	L_.str.62(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	sete	%r14b
	shlb	$3, %r14b
	jmp	LBB2_682
	.p2align	4, 0x90
LBB2_63:                                ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r12), %rbx
	movq	%rbx, %rdi
	callq	_strlen
	leaq	1(%rax), %rdi
	callq	_malloc
	movq	%rax, %rcx
	jmp	LBB2_66
	.p2align	4, 0x90
LBB2_64:                                ##   in Loop: Header=BB2_66 Depth=2
	testl	%edx, %edx
	je	LBB2_1
LBB2_65:                                ##   in Loop: Header=BB2_66 Depth=2
	movb	%dl, (%rcx)
	incq	%rcx
	incq	%rbx
LBB2_66:                                ##   Parent Loop BB2_4 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movzbl	(%rbx), %edx
	cmpl	$92, %edx
	jne	LBB2_64
## %bb.67:                              ##   in Loop: Header=BB2_66 Depth=2
	movsbl	1(%rbx), %esi
	incq	%rbx
	cmpl	$91, %esi
	jle	LBB2_71
## %bb.68:                              ##   in Loop: Header=BB2_66 Depth=2
	leal	-92(%rsi), %edi
	cmpl	$24, %edi
	ja	LBB2_126
## %bb.69:                              ##   in Loop: Header=BB2_66 Depth=2
	movb	$10, %dl
	movslq	(%r15,%rdi,4), %rdi
	addq	%r15, %rdi
	jmpq	*%rdi
LBB2_70:                                ##   in Loop: Header=BB2_66 Depth=2
	movb	$92, %dl
	jmp	LBB2_65
	.p2align	4, 0x90
LBB2_71:                                ##   in Loop: Header=BB2_66 Depth=2
	cmpl	$34, %esi
	je	LBB2_78
## %bb.72:                              ##   in Loop: Header=BB2_66 Depth=2
	cmpl	$39, %esi
	je	LBB2_77
## %bb.73:                              ##   in Loop: Header=BB2_66 Depth=2
	cmpl	$48, %esi
	jne	LBB2_126
## %bb.74:                              ##   in Loop: Header=BB2_66 Depth=2
	xorl	%edx, %edx
	jmp	LBB2_65
LBB2_75:                                ##   in Loop: Header=BB2_66 Depth=2
	movb	$9, %dl
	jmp	LBB2_65
LBB2_76:                                ##   in Loop: Header=BB2_66 Depth=2
	movb	$13, %dl
	jmp	LBB2_65
LBB2_77:                                ##   in Loop: Header=BB2_66 Depth=2
	movb	$39, %dl
	jmp	LBB2_65
LBB2_78:                                ##   in Loop: Header=BB2_66 Depth=2
	movb	$34, %dl
	jmp	LBB2_65
	.p2align	4, 0x90
LBB2_79:                                ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r12), %rbx
	movq	%rbx, %rdi
	leaq	L_.str.66(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_91
## %bb.80:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%rbx, %rdi
	leaq	L_.str.67(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_91
## %bb.81:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%rbx, %rdi
	leaq	L_.str.59(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_120
## %bb.82:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%rbx, %rdi
	leaq	L_.str.60(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_135
## %bb.83:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%rbx, %rdi
	leaq	L_.str.61(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_154
## %bb.84:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%rbx, %rdi
	leaq	L_.str.62(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_186
## %bb.85:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%rbx, %rdi
	leaq	L_.str.70(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_223
## %bb.86:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%rbx, %rdi
	leaq	L_.str.71(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB2_279
## %bb.87:                              ##   in Loop: Header=BB2_4 Depth=1
	movq	%rbx, %rdi
	leaq	L_.str.72(%rip), %rsi
	callq	_strcmp
	testl	%eax, %eax
	jne	LBB2_715
## %bb.88:                              ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$0, 40(%r12)
	jne	LBB2_717
## %bb.89:                              ##   in Loop: Header=BB2_4 Depth=1
	addq	$32, %r12
	movq	(%r12), %rbx
	movq	32(%r13), %rcx
	leaq	1(%rcx), %rax
	movq	%rax, 32(%r13)
	cmpq	40(%r13), %rcx
	jne	LBB2_300
## %bb.90:                              ##   in Loop: Header=BB2_4 Depth=1
	leaq	(%rcx,%rcx), %rax
	testq	%rcx, %rcx
	movl	$16, %ecx
	cmoveq	%rcx, %rax
	movq	%rax, 40(%r13)
	movq	24(%r13), %rdi
	imulq	$272, %rax, %rsi                ## imm = 0x110
	callq	_realloc
	movq	%rax, 24(%r13)
	movq	32(%r13), %rcx
	decq	%rcx
	jmp	LBB2_301
LBB2_91:                                ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$5, 40(%r12)
	jne	LBB2_707
## %bb.92:                              ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movq	(%r14), %rbx
	movq	%rbx, %rdi
	callq	_strlen
	leaq	1(%rax), %rdi
	callq	_malloc
	movq	%rax, %r15
	leaq	LJTI2_2(%rip), %rdi
	jmp	LBB2_95
	.p2align	4, 0x90
LBB2_93:                                ##   in Loop: Header=BB2_95 Depth=2
	testl	%ecx, %ecx
	je	LBB2_108
LBB2_94:                                ##   in Loop: Header=BB2_95 Depth=2
	movb	%cl, (%rax)
	incq	%rax
	incq	%rbx
LBB2_95:                                ##   Parent Loop BB2_4 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movzbl	(%rbx), %ecx
	cmpl	$92, %ecx
	jne	LBB2_93
## %bb.96:                              ##   in Loop: Header=BB2_95 Depth=2
	movsbl	1(%rbx), %esi
	incq	%rbx
	cmpl	$91, %esi
	jle	LBB2_100
## %bb.97:                              ##   in Loop: Header=BB2_95 Depth=2
	leal	-92(%rsi), %edx
	cmpl	$24, %edx
	ja	LBB2_147
## %bb.98:                              ##   in Loop: Header=BB2_95 Depth=2
	movb	$10, %cl
	movslq	(%rdi,%rdx,4), %rdx
	addq	%rdi, %rdx
	jmpq	*%rdx
LBB2_99:                                ##   in Loop: Header=BB2_95 Depth=2
	movb	$92, %cl
	jmp	LBB2_94
	.p2align	4, 0x90
LBB2_100:                               ##   in Loop: Header=BB2_95 Depth=2
	cmpl	$34, %esi
	je	LBB2_107
## %bb.101:                             ##   in Loop: Header=BB2_95 Depth=2
	cmpl	$39, %esi
	je	LBB2_106
## %bb.102:                             ##   in Loop: Header=BB2_95 Depth=2
	cmpl	$48, %esi
	jne	LBB2_147
## %bb.103:                             ##   in Loop: Header=BB2_95 Depth=2
	xorl	%ecx, %ecx
	jmp	LBB2_94
LBB2_104:                               ##   in Loop: Header=BB2_95 Depth=2
	movb	$9, %cl
	jmp	LBB2_94
LBB2_105:                               ##   in Loop: Header=BB2_95 Depth=2
	movb	$13, %cl
	jmp	LBB2_94
LBB2_106:                               ##   in Loop: Header=BB2_95 Depth=2
	movb	$39, %cl
	jmp	LBB2_94
LBB2_107:                               ##   in Loop: Header=BB2_95 Depth=2
	movb	$34, %cl
	jmp	LBB2_94
LBB2_108:                               ##   in Loop: Header=BB2_4 Depth=1
	movb	$0, (%rax)
LBB2_109:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r12), %rdi
	leaq	L_.str.67(%rip), %rsi
	callq	_strcmp
	movl	%eax, %r13d
	movq	%r15, %rdi
	callq	_strlen
	movq	%rax, %rbx
	testl	%r13d, %r13d
	movq	%r14, -56(%rbp)                 ## 8-byte Spill
	je	LBB2_116
## %bb.110:                             ##   in Loop: Header=BB2_4 Depth=1
	incq	%rbx
	movq	-48(%rbp), %r14                 ## 8-byte Reload
	movq	32(%r14), %rax
	leaq	1(%rax), %rcx
	movq	%rcx, 32(%r14)
	cmpq	40(%r14), %rax
	jne	LBB2_118
## %bb.111:                             ##   in Loop: Header=BB2_4 Depth=1
	leaq	(%rax,%rax), %rcx
	testq	%rax, %rax
	movl	$16, %eax
	cmoveq	%rax, %rcx
	movq	%rcx, 40(%r14)
	movq	24(%r14), %rdi
	imulq	$272, %rcx, %rsi                ## imm = 0x110
	callq	_realloc
	movq	%rax, %r13
	movq	%rax, 24(%r14)
	movq	32(%r14), %rax
	decq	%rax
	jmp	LBB2_119
LBB2_112:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %rbx
	movq	%rbx, %rdi
	callq	___bzero
	movb	$16, -320(%rbp)
	jmp	LBB2_114
LBB2_113:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %rbx
	movq	%rbx, %rdi
	callq	___bzero
LBB2_114:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$33, %ecx
	movq	%rsp, %rdi
	movq	%rbx, %rsi
LBB2_115:                               ##   in Loop: Header=BB2_4 Depth=1
	rep;movsq (%rsi), %es:(%rdi)
	movq	%r13, %rdi
	callq	_add_instruction
	leaq	LJTI2_1(%rip), %r15
	addq	$32, %r12
	jmp	LBB2_4
LBB2_116:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	-48(%rbp), %r13                 ## 8-byte Reload
	movq	32(%r13), %rax
	leaq	1(%rax), %rcx
	movq	%rcx, 32(%r13)
	cmpq	40(%r13), %rax
	jne	LBB2_127
## %bb.117:                             ##   in Loop: Header=BB2_4 Depth=1
	leaq	(%rax,%rax), %rcx
	testq	%rax, %rax
	movl	$16, %eax
	cmoveq	%rax, %rcx
	movq	%rcx, 40(%r13)
	movq	24(%r13), %rdi
	imulq	$272, %rcx, %rsi                ## imm = 0x110
	callq	_realloc
	movq	%rax, %r14
	movq	%rax, 24(%r13)
	movq	32(%r13), %rax
	decq	%rax
	jmp	LBB2_128
LBB2_118:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	24(%r14), %r13
LBB2_119:                               ##   in Loop: Header=BB2_4 Depth=1
	imulq	$272, %rax, %r12                ## imm = 0x110
	movl	$0, (%r13,%r12)
	movq	%rbx, %rdi
	callq	_malloc
	movq	%rax, 8(%r13,%r12)
	movq	24(%r14), %rax
	imulq	$272, 32(%r14), %rcx            ## imm = 0x110
	movq	-264(%rcx,%rax), %rdi
	movq	%r15, %rsi
	movq	%rbx, %rdx
	callq	_memcpy
	movq	24(%r14), %rax
	imulq	$272, 32(%r14), %rcx            ## imm = 0x110
	movq	%rbx, -256(%rcx,%rax)
	addq	%rbx, 48(%r14)
	movq	-56(%rbp), %r12                 ## 8-byte Reload
	movq	%r14, %r13
	jmp	LBB2_570
LBB2_120:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$3, 40(%r12)
	jne	LBB2_708
## %bb.121:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$32, %r12
	movq	(%r12), %rdi
	cmpb	$48, (%rdi)
	jne	LBB2_141
## %bb.122:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	1(%rdi), %eax
	cmpl	$98, %eax
	je	LBB2_258
## %bb.123:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %eax
	je	LBB2_257
## %bb.124:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %eax
	jne	LBB2_141
## %bb.125:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_142
LBB2_126:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	L_.str.74(%rip), %rdi
                                        ## kill: def $esi killed $esi killed $rsi
	xorl	%eax, %eax
	callq	_printf
	xorl	%eax, %eax
	jmp	LBB2_2
LBB2_127:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	24(%r13), %r14
LBB2_128:                               ##   in Loop: Header=BB2_4 Depth=1
	imulq	$272, %rax, %r12                ## imm = 0x110
	movl	$0, (%r14,%r12)
	movq	%rbx, %rdi
	callq	_malloc
	movq	%rax, 8(%r14,%r12)
	movq	24(%r13), %rax
	imulq	$272, 32(%r13), %rcx            ## imm = 0x110
	movq	-264(%rcx,%rax), %rdi
	movq	%r15, %rsi
	movq	%rbx, %rdx
	callq	_memcpy
	movq	24(%r13), %rax
	imulq	$272, 32(%r13), %rcx            ## imm = 0x110
	movq	%rbx, -256(%rcx,%rax)
	addq	%rbx, 48(%r13)
	movq	-56(%rbp), %r12                 ## 8-byte Reload
	jmp	LBB2_570
LBB2_129:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, 40(%r12)
	jne	LBB2_709
## %bb.130:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	32(%r12), %rdi
	cmpb	$48, 1(%rdi)
	jne	LBB2_160
## %bb.131:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	2(%rdi), %eax
	cmpl	$98, %eax
	je	LBB2_294
## %bb.132:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %eax
	je	LBB2_292
## %bb.133:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %eax
	jne	LBB2_160
## %bb.134:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_161
LBB2_135:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$3, 40(%r12)
	jne	LBB2_708
## %bb.136:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$32, %r12
	movq	(%r12), %rdi
	cmpb	$48, (%rdi)
	jne	LBB2_180
## %bb.137:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	1(%rdi), %eax
	cmpl	$98, %eax
	je	LBB2_295
## %bb.138:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %eax
	je	LBB2_293
## %bb.139:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %eax
	jne	LBB2_180
## %bb.140:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_181
LBB2_141:                               ##   in Loop: Header=BB2_4 Depth=1
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_142:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoul
LBB2_143:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	%rax, %rbx
	movq	32(%r13), %rax
	leaq	1(%rax), %rcx
	movq	%rcx, 32(%r13)
	cmpq	40(%r13), %rax
	jne	LBB2_145
## %bb.144:                             ##   in Loop: Header=BB2_4 Depth=1
	leaq	(%rax,%rax), %rcx
	testq	%rax, %rax
	movl	$16, %eax
	cmoveq	%rax, %rcx
	movq	%rcx, 40(%r13)
	movq	24(%r13), %rdi
	imulq	$272, %rcx, %rsi                ## imm = 0x110
	callq	_realloc
	movq	%rax, %r15
	movq	%rax, 24(%r13)
	movq	32(%r13), %rax
	decq	%rax
	jmp	LBB2_146
LBB2_145:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	24(%r13), %r15
LBB2_146:                               ##   in Loop: Header=BB2_4 Depth=1
	imulq	$272, %rax, %r14                ## imm = 0x110
	movl	$0, (%r15,%r14)
	movl	$1, %edi
	callq	_malloc
	movq	%rax, 8(%r15,%r14)
	movq	24(%r13), %rax
	imulq	$272, 32(%r13), %rcx            ## imm = 0x110
	movq	-264(%rcx,%rax), %rax
	movb	%bl, (%rax)
	movq	24(%r13), %rax
	imulq	$272, 32(%r13), %rcx            ## imm = 0x110
	movq	$1, -256(%rcx,%rax)
	incq	48(%r13)
	jmp	LBB2_570
LBB2_147:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	L_.str.74(%rip), %rdi
                                        ## kill: def $esi killed $esi killed $rsi
	xorl	%eax, %eax
	callq	_printf
	xorl	%r15d, %r15d
	jmp	LBB2_109
LBB2_148:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, 40(%r12)
	jne	LBB2_709
## %bb.149:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	32(%r12), %rdi
	cmpb	$48, 1(%rdi)
	jne	LBB2_201
## %bb.150:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	2(%rdi), %eax
	cmpl	$98, %eax
	je	LBB2_350
## %bb.151:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %eax
	je	LBB2_348
## %bb.152:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %eax
	jne	LBB2_201
## %bb.153:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_202
LBB2_154:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$3, 40(%r12)
	jne	LBB2_708
## %bb.155:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$32, %r12
	movq	(%r12), %rdi
	cmpb	$48, (%rdi)
	jne	LBB2_198
## %bb.156:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	1(%rdi), %eax
	cmpl	$98, %eax
	je	LBB2_351
## %bb.157:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %eax
	je	LBB2_349
## %bb.158:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %eax
	jne	LBB2_198
## %bb.159:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_199
LBB2_160:                               ##   in Loop: Header=BB2_4 Depth=1
	incq	%rdi
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_161:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoul
LBB2_162:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	72(%r12), %edx
	cmpq	$7, %rdx
	ja	LBB2_716
## %bb.163:                             ##   in Loop: Header=BB2_4 Depth=1
	leaq	64(%r12), %r15
	leaq	LJTI2_7(%rip), %rcx
	movslq	(%rcx,%rdx,4), %rdx
	addq	%rcx, %rdx
	movq	%rax, -56(%rbp)                 ## 8-byte Spill
	jmpq	*%rdx
LBB2_164:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r15), %r13
	movq	%r13, %rdi
	callq	_strlen
	leaq	1(%rax), %rdi
	callq	_malloc
	movq	%rax, %rbx
	leaq	LJTI2_9(%rip), %rdi
	jmp	LBB2_167
	.p2align	4, 0x90
LBB2_165:                               ##   in Loop: Header=BB2_167 Depth=2
	testl	%ecx, %ecx
	je	LBB2_255
LBB2_166:                               ##   in Loop: Header=BB2_167 Depth=2
	movb	%cl, (%rax)
	incq	%rax
	incq	%r13
LBB2_167:                               ##   Parent Loop BB2_4 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movzbl	(%r13), %ecx
	cmpl	$92, %ecx
	jne	LBB2_165
## %bb.168:                             ##   in Loop: Header=BB2_167 Depth=2
	movsbl	1(%r13), %esi
	incq	%r13
	cmpl	$91, %esi
	jle	LBB2_172
## %bb.169:                             ##   in Loop: Header=BB2_167 Depth=2
	leal	-92(%rsi), %edx
	cmpl	$24, %edx
	ja	LBB2_460
## %bb.170:                             ##   in Loop: Header=BB2_167 Depth=2
	movb	$10, %cl
	movslq	(%rdi,%rdx,4), %rdx
	addq	%rdi, %rdx
	jmpq	*%rdx
LBB2_171:                               ##   in Loop: Header=BB2_167 Depth=2
	movb	$92, %cl
	jmp	LBB2_166
	.p2align	4, 0x90
LBB2_172:                               ##   in Loop: Header=BB2_167 Depth=2
	cmpl	$34, %esi
	je	LBB2_179
## %bb.173:                             ##   in Loop: Header=BB2_167 Depth=2
	cmpl	$39, %esi
	je	LBB2_178
## %bb.174:                             ##   in Loop: Header=BB2_167 Depth=2
	cmpl	$48, %esi
	jne	LBB2_460
## %bb.175:                             ##   in Loop: Header=BB2_167 Depth=2
	xorl	%ecx, %ecx
	jmp	LBB2_166
LBB2_176:                               ##   in Loop: Header=BB2_167 Depth=2
	movb	$9, %cl
	jmp	LBB2_166
LBB2_177:                               ##   in Loop: Header=BB2_167 Depth=2
	movb	$13, %cl
	jmp	LBB2_166
LBB2_178:                               ##   in Loop: Header=BB2_167 Depth=2
	movb	$39, %cl
	jmp	LBB2_166
LBB2_179:                               ##   in Loop: Header=BB2_167 Depth=2
	movb	$34, %cl
	jmp	LBB2_166
LBB2_180:                               ##   in Loop: Header=BB2_4 Depth=1
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_181:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoul
LBB2_182:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	%rax, %rbx
	movq	32(%r13), %rax
	leaq	1(%rax), %rcx
	movq	%rcx, 32(%r13)
	cmpq	40(%r13), %rax
	jne	LBB2_184
## %bb.183:                             ##   in Loop: Header=BB2_4 Depth=1
	leaq	(%rax,%rax), %rcx
	testq	%rax, %rax
	movl	$16, %eax
	cmoveq	%rax, %rcx
	movq	%rcx, 40(%r13)
	movq	24(%r13), %rdi
	imulq	$272, %rcx, %rsi                ## imm = 0x110
	callq	_realloc
	movq	%rax, %r15
	movq	%rax, 24(%r13)
	movq	32(%r13), %rax
	decq	%rax
	jmp	LBB2_185
LBB2_184:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	24(%r13), %r15
LBB2_185:                               ##   in Loop: Header=BB2_4 Depth=1
	imulq	$272, %rax, %r14                ## imm = 0x110
	movl	$0, (%r15,%r14)
	movl	$2, %edi
	callq	_malloc
	movq	%rax, 8(%r15,%r14)
	movq	24(%r13), %rax
	imulq	$272, 32(%r13), %rcx            ## imm = 0x110
	movq	-264(%rcx,%rax), %rdx
	movw	%bx, (%rdx)
	movq	$2, -256(%rcx,%rax)
	addq	$2, 48(%r13)
	jmp	LBB2_570
LBB2_186:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$3, 40(%r12)
	jne	LBB2_708
## %bb.187:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$32, %r12
	movq	(%r12), %rdi
	cmpb	$48, (%rdi)
	jne	LBB2_243
## %bb.188:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	1(%rdi), %eax
	cmpl	$98, %eax
	je	LBB2_391
## %bb.189:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %eax
	je	LBB2_389
## %bb.190:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %eax
	jne	LBB2_243
## %bb.191:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_244
LBB2_192:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, 40(%r12)
	jne	LBB2_709
## %bb.193:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	32(%r12), %rdi
	cmpb	$48, 1(%rdi)
	jne	LBB2_246
## %bb.194:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	2(%rdi), %eax
	cmpl	$98, %eax
	je	LBB2_392
## %bb.195:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %eax
	je	LBB2_390
## %bb.196:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %eax
	jne	LBB2_246
## %bb.197:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_247
LBB2_198:                               ##   in Loop: Header=BB2_4 Depth=1
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_199:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoul
	movq	%rax, %rbx
	movq	32(%r13), %rax
	leaq	1(%rax), %rcx
	movq	%rcx, 32(%r13)
	cmpq	40(%r13), %rax
	jne	LBB2_210
## %bb.200:                             ##   in Loop: Header=BB2_4 Depth=1
	leaq	(%rax,%rax), %rcx
	testq	%rax, %rax
	movl	$16, %eax
	cmoveq	%rax, %rcx
	movq	%rcx, 40(%r13)
	movq	24(%r13), %rdi
	imulq	$272, %rcx, %rsi                ## imm = 0x110
	callq	_realloc
	movq	%rax, %r15
	movq	%rax, 24(%r13)
	movq	32(%r13), %rax
	decq	%rax
	jmp	LBB2_211
LBB2_201:                               ##   in Loop: Header=BB2_4 Depth=1
	incq	%rdi
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_202:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoul
LBB2_203:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	%rax, %r15
	leaq	64(%r12), %r14
	movl	72(%r12), %eax
	cmpl	$3, %eax
	je	LBB2_212
## %bb.204:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_714
## %bb.205:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	cmpb	$48, 1(%rdi)
	jne	LBB2_266
## %bb.206:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	2(%rdi), %eax
	cmpl	$98, %eax
	je	LBB2_428
## %bb.207:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %eax
	je	LBB2_426
## %bb.208:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %eax
	jne	LBB2_266
## %bb.209:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_267
LBB2_210:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	24(%r13), %r15
LBB2_211:                               ##   in Loop: Header=BB2_4 Depth=1
	imulq	$272, %rax, %r14                ## imm = 0x110
	movl	$0, (%r15,%r14)
	movl	$4, %edi
	callq	_malloc
	movq	%rax, 8(%r15,%r14)
	movq	24(%r13), %rax
	imulq	$272, 32(%r13), %rcx            ## imm = 0x110
	movq	-264(%rcx,%rax), %rdx
	movl	%ebx, (%rdx)
	movq	$4, -256(%rcx,%rax)
	addq	$4, 48(%r13)
	jmp	LBB2_570
LBB2_212:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	cmpb	$48, (%rdi)
	jne	LBB2_269
## %bb.213:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	1(%rdi), %eax
	cmpl	$98, %eax
	je	LBB2_429
## %bb.214:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %eax
	je	LBB2_427
## %bb.215:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %eax
	jne	LBB2_269
## %bb.216:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_270
LBB2_217:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, 40(%r12)
	jne	LBB2_709
## %bb.218:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$32, %r12
	movq	(%r12), %rdi
	cmpb	$48, 1(%rdi)
	jne	LBB2_289
## %bb.219:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	2(%rdi), %eax
	cmpl	$98, %eax
	je	LBB2_440
## %bb.220:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %eax
	je	LBB2_439
## %bb.221:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %eax
	jne	LBB2_289
## %bb.222:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_290
LBB2_223:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$4, 40(%r12)
	jne	LBB2_708
## %bb.224:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$32, %r12
	movq	(%r12), %rdi
	callq	_atof
	movq	32(%r13), %rax
	leaq	1(%rax), %rcx
	movq	%rcx, 32(%r13)
	cmpq	40(%r13), %rax
	jne	LBB2_305
## %bb.225:                             ##   in Loop: Header=BB2_4 Depth=1
	leaq	(%rax,%rax), %rcx
	testq	%rax, %rax
	movl	$16, %eax
	cmoveq	%rax, %rcx
	movq	%rcx, 40(%r13)
	movq	24(%r13), %rdi
	imulq	$272, %rcx, %rsi                ## imm = 0x110
	movsd	%xmm0, -56(%rbp)                ## 8-byte Spill
	callq	_realloc
	movsd	-56(%rbp), %xmm0                ## 8-byte Reload
                                        ## xmm0 = mem[0],zero
	movq	%rax, %rbx
	movq	%rax, 24(%r13)
	movq	32(%r13), %rax
	decq	%rax
	jmp	LBB2_306
LBB2_226:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r15), %rdi
	cmpb	$48, 1(%rdi)
	jne	LBB2_282
## %bb.227:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	2(%rdi), %ecx
	cmpl	$98, %ecx
	je	LBB2_436
## %bb.228:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %ecx
	je	LBB2_435
## %bb.229:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %ecx
	jne	LBB2_282
## %bb.230:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_283
LBB2_231:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	104(%r12), %ecx
	testl	%ecx, %ecx
	je	LBB2_307
## %bb.232:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %ecx
	jne	LBB2_719
## %bb.233:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	96(%r12), %rdi
	cmpb	$48, 1(%rdi)
	jne	LBB2_370
## %bb.234:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	2(%rdi), %ecx
	cmpl	$98, %ecx
	je	LBB2_492
## %bb.235:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %ecx
	je	LBB2_491
## %bb.236:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %ecx
	jne	LBB2_370
## %bb.237:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_371
LBB2_238:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r15), %rdi
	cmpb	$48, (%rdi)
	jne	LBB2_285
## %bb.239:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	1(%rdi), %ecx
	cmpl	$98, %ecx
	je	LBB2_438
## %bb.240:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %ecx
	je	LBB2_437
## %bb.241:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %ecx
	jne	LBB2_285
## %bb.242:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_286
LBB2_243:                               ##   in Loop: Header=BB2_4 Depth=1
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_244:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoull
	movq	%rax, %rbx
	movq	32(%r13), %rax
	leaq	1(%rax), %rcx
	movq	%rcx, 32(%r13)
	cmpq	40(%r13), %rax
	jne	LBB2_259
## %bb.245:                             ##   in Loop: Header=BB2_4 Depth=1
	leaq	(%rax,%rax), %rcx
	testq	%rax, %rax
	movl	$16, %eax
	cmoveq	%rax, %rcx
	movq	%rcx, 40(%r13)
	movq	24(%r13), %rdi
	imulq	$272, %rcx, %rsi                ## imm = 0x110
	callq	_realloc
	movq	%rax, %r15
	movq	%rax, 24(%r13)
	movq	32(%r13), %rax
	decq	%rax
	jmp	LBB2_260
LBB2_246:                               ##   in Loop: Header=BB2_4 Depth=1
	incq	%rdi
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_247:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoul
LBB2_248:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	%rax, %r15
	leaq	64(%r12), %r14
	movl	72(%r12), %eax
	cmpl	$3, %eax
	je	LBB2_261
## %bb.249:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_714
## %bb.250:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	cmpb	$48, 1(%rdi)
	jne	LBB2_323
## %bb.251:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	2(%rdi), %eax
	cmpl	$98, %eax
	je	LBB2_466
## %bb.252:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %eax
	je	LBB2_467
## %bb.253:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %eax
	jne	LBB2_323
## %bb.254:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_324
LBB2_255:                               ##   in Loop: Header=BB2_4 Depth=1
	movb	$0, (%rax)
LBB2_256:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	callq	___bzero
	movw	$41, -320(%rbp)
	movl	$4, -312(%rbp)
	movq	%rbx, -304(%rbp)
	movl	$1, -296(%rbp)
	movq	-56(%rbp), %rax                 ## 8-byte Reload
	movb	%al, -288(%rbp)
	movl	$33, %ecx
	movq	%rsp, %rdi
	movq	%r12, %rsi
	rep;movsq (%rsi), %es:(%rdi)
	movq	-48(%rbp), %r13                 ## 8-byte Reload
	jmp	LBB2_299
LBB2_257:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_142
LBB2_258:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	_strtol
	jmp	LBB2_143
LBB2_259:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	24(%r13), %r15
LBB2_260:                               ##   in Loop: Header=BB2_4 Depth=1
	imulq	$272, %rax, %r14                ## imm = 0x110
	movl	$0, (%r15,%r14)
	movl	$8, %edi
	callq	_malloc
	movq	%rax, 8(%r15,%r14)
	movq	24(%r13), %rax
	imulq	$272, 32(%r13), %rcx            ## imm = 0x110
	movq	-264(%rcx,%rax), %rcx
	movq	%rbx, (%rcx)
	imulq	$272, 32(%r13), %rcx            ## imm = 0x110
	movq	$8, -256(%rcx,%rax)
	addq	$8, 48(%r13)
	jmp	LBB2_570
LBB2_261:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	cmpb	$48, (%rdi)
	jne	LBB2_327
## %bb.262:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	1(%rdi), %eax
	cmpl	$98, %eax
	je	LBB2_468
## %bb.263:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %eax
	je	LBB2_469
## %bb.264:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %eax
	jne	LBB2_327
## %bb.265:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_328
LBB2_266:                               ##   in Loop: Header=BB2_4 Depth=1
	incq	%rdi
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_267:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoul
LBB2_268:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	callq	___bzero
	movw	$50, -320(%rbp)
	jmp	LBB2_326
LBB2_269:                               ##   in Loop: Header=BB2_4 Depth=1
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_270:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoull
	movq	%rax, %rbx
	movswq	%bx, %rax
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	cmpq	%rbx, %rax
	je	LBB2_288
## %bb.271:                             ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$57, -320(%rbp)
	jmp	LBB2_330
LBB2_272:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_352
## %bb.273:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_718
## %bb.274:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	cmpb	$48, 1(%rdi)
	jne	LBB2_393
## %bb.275:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	2(%rdi), %eax
	cmpl	$98, %eax
	je	LBB2_502
## %bb.276:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %eax
	je	LBB2_503
## %bb.277:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %eax
	jne	LBB2_393
## %bb.278:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_394
LBB2_279:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$4, 40(%r12)
	jne	LBB2_708
## %bb.280:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$32, %r12
	movq	(%r12), %rdi
	callq	_atof
	movsd	%xmm0, -56(%rbp)                ## 8-byte Spill
	movq	32(%r13), %rax
	leaq	1(%rax), %rcx
	movq	%rcx, 32(%r13)
	cmpq	40(%r13), %rax
	jne	LBB2_368
## %bb.281:                             ##   in Loop: Header=BB2_4 Depth=1
	leaq	(%rax,%rax), %rcx
	testq	%rax, %rax
	movl	$16, %eax
	cmoveq	%rax, %rcx
	movq	%rcx, 40(%r13)
	movq	24(%r13), %rdi
	imulq	$272, %rcx, %rsi                ## imm = 0x110
	callq	_realloc
	movq	%rax, %rbx
	movq	%rax, 24(%r13)
	movq	32(%r13), %rax
	decq	%rax
	jmp	LBB2_369
LBB2_282:                               ##   in Loop: Header=BB2_4 Depth=1
	incq	%rdi
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_283:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoul
LBB2_284:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	callq	___bzero
	movw	$34, -320(%rbp)
	movl	$1, -312(%rbp)
	movq	-56(%rbp), %rax                 ## 8-byte Reload
	movb	%al, -304(%rbp)
	movl	$1, -296(%rbp)
	movb	%bl, -288(%rbp)
	jmp	LBB2_298
LBB2_285:                               ##   in Loop: Header=BB2_4 Depth=1
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_286:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoull
	movq	%rax, %rbx
	movswq	%bx, %rax
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	cmpq	%rbx, %rax
	je	LBB2_296
## %bb.287:                             ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$41, -320(%rbp)
	movl	$3, -312(%rbp)
	movq	%rbx, -304(%rbp)
	jmp	LBB2_297
LBB2_288:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$51, -320(%rbp)
	jmp	LBB2_345
LBB2_289:                               ##   in Loop: Header=BB2_4 Depth=1
	incq	%rdi
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_290:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoul
LBB2_291:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$81, -320(%rbp)
	movl	$1, -312(%rbp)
	movb	%bl, -304(%rbp)
	movl	$33, %ecx
	movq	%rsp, %rdi
	movq	%r15, %rsi
	jmp	LBB2_115
LBB2_292:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_161
LBB2_293:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_181
LBB2_294:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	_strtol
	jmp	LBB2_162
LBB2_295:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	_strtol
	jmp	LBB2_182
LBB2_296:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$35, -320(%rbp)
	movl	$2, -312(%rbp)
	movw	%bx, -304(%rbp)
LBB2_297:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$1, -296(%rbp)
	movq	-56(%rbp), %rax                 ## 8-byte Reload
	movb	%al, -288(%rbp)
LBB2_298:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$33, %ecx
	movq	%rsp, %rdi
	movq	%r12, %rsi
	rep;movsq (%rsi), %es:(%rdi)
LBB2_299:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	%r13, %rdi
	callq	_add_instruction
	movq	%r15, %r12
	leaq	LJTI2_1(%rip), %r15
	addq	$32, %r12
	jmp	LBB2_4
LBB2_300:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	24(%r13), %rax
LBB2_301:                               ##   in Loop: Header=BB2_4 Depth=1
	imulq	$272, %rcx, %rcx                ## imm = 0x110
	movl	$2, (%rax,%rcx)
	movq	%rbx, 8(%rax,%rcx)
	movq	56(%r13), %rcx
	leaq	1(%rcx), %rax
	movq	%rax, 56(%r13)
	cmpq	64(%r13), %rcx
	jne	LBB2_303
## %bb.302:                             ##   in Loop: Header=BB2_4 Depth=1
	leaq	(%rcx,%rcx), %rsi
	testq	%rcx, %rcx
	movl	$16, %eax
	cmoveq	%rax, %rsi
	movq	%rsi, 64(%r13)
	movq	72(%r13), %rdi
	shlq	$3, %rsi
	callq	_realloc
	movq	%rax, 72(%r13)
	movq	56(%r13), %rcx
	decq	%rcx
	jmp	LBB2_304
LBB2_303:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	72(%r13), %rax
LBB2_304:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	48(%r13), %rdx
	movq	%rdx, (%rax,%rcx,8)
	addq	$8, 48(%r13)
	addq	$32, %r12
	jmp	LBB2_4
LBB2_305:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	24(%r13), %rbx
LBB2_306:                               ##   in Loop: Header=BB2_4 Depth=1
	cvtsd2ss	%xmm0, %xmm0
	movss	%xmm0, -56(%rbp)                ## 4-byte Spill
	imulq	$272, %rax, %r14                ## imm = 0x110
	movl	$0, (%rbx,%r14)
	movl	$4, %edi
	callq	_malloc
	movq	%rax, 8(%rbx,%r14)
	movq	24(%r13), %rax
	imulq	$272, 32(%r13), %rcx            ## imm = 0x110
	movq	-264(%rcx,%rax), %rdx
	movss	-56(%rbp), %xmm0                ## 4-byte Reload
                                        ## xmm0 = mem[0],zero,zero,zero
	movss	%xmm0, (%rdx)
	movq	$4, -256(%rcx,%rax)
	addq	$4, 48(%r13)
	leaq	LJTI2_0(%rip), %r14
	addq	$32, %r12
	jmp	LBB2_4
LBB2_307:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	96(%r12), %r13
	movq	%r13, %rdi
	callq	_strlen
	leaq	1(%rax), %rdi
	callq	_malloc
	movq	%rax, %rbx
	leaq	LJTI2_8(%rip), %rdi
	jmp	LBB2_310
	.p2align	4, 0x90
LBB2_308:                               ##   in Loop: Header=BB2_310 Depth=2
	testl	%ecx, %ecx
	je	LBB2_331
LBB2_309:                               ##   in Loop: Header=BB2_310 Depth=2
	movb	%cl, (%rax)
	incq	%rax
	incq	%r13
LBB2_310:                               ##   Parent Loop BB2_4 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movzbl	(%r13), %ecx
	cmpl	$92, %ecx
	jne	LBB2_308
## %bb.311:                             ##   in Loop: Header=BB2_310 Depth=2
	movsbl	1(%r13), %esi
	incq	%r13
	cmpl	$91, %esi
	jle	LBB2_315
## %bb.312:                             ##   in Loop: Header=BB2_310 Depth=2
	leal	-92(%rsi), %edx
	cmpl	$24, %edx
	ja	LBB2_496
## %bb.313:                             ##   in Loop: Header=BB2_310 Depth=2
	movb	$10, %cl
	movslq	(%rdi,%rdx,4), %rdx
	addq	%rdi, %rdx
	jmpq	*%rdx
LBB2_314:                               ##   in Loop: Header=BB2_310 Depth=2
	movb	$92, %cl
	jmp	LBB2_309
	.p2align	4, 0x90
LBB2_315:                               ##   in Loop: Header=BB2_310 Depth=2
	cmpl	$34, %esi
	je	LBB2_322
## %bb.316:                             ##   in Loop: Header=BB2_310 Depth=2
	cmpl	$39, %esi
	je	LBB2_321
## %bb.317:                             ##   in Loop: Header=BB2_310 Depth=2
	cmpl	$48, %esi
	jne	LBB2_496
## %bb.318:                             ##   in Loop: Header=BB2_310 Depth=2
	xorl	%ecx, %ecx
	jmp	LBB2_309
LBB2_319:                               ##   in Loop: Header=BB2_310 Depth=2
	movb	$9, %cl
	jmp	LBB2_309
LBB2_320:                               ##   in Loop: Header=BB2_310 Depth=2
	movb	$13, %cl
	jmp	LBB2_309
LBB2_321:                               ##   in Loop: Header=BB2_310 Depth=2
	movb	$39, %cl
	jmp	LBB2_309
LBB2_322:                               ##   in Loop: Header=BB2_310 Depth=2
	movb	$34, %cl
	jmp	LBB2_309
LBB2_323:                               ##   in Loop: Header=BB2_4 Depth=1
	incq	%rdi
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_324:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoul
LBB2_325:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	callq	___bzero
	movw	$66, -320(%rbp)
LBB2_326:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$1, -312(%rbp)
	movb	%r15b, -304(%rbp)
	movl	$1, -296(%rbp)
	movb	%bl, -288(%rbp)
	jmp	LBB2_347
LBB2_327:                               ##   in Loop: Header=BB2_4 Depth=1
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_328:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoull
	movq	%rax, %rbx
	movswq	%bx, %rax
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	cmpq	%rbx, %rax
	je	LBB2_344
## %bb.329:                             ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$73, -320(%rbp)
LBB2_330:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$3, -312(%rbp)
	movq	%rbx, -304(%rbp)
	jmp	LBB2_346
LBB2_331:                               ##   in Loop: Header=BB2_4 Depth=1
	movb	$0, (%rax)
LBB2_332:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	128(%r12), %r14
	movl	136(%r12), %eax
	cmpl	$8, %eax
	movq	-48(%rbp), %r13                 ## 8-byte Reload
	je	LBB2_417
## %bb.333:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$3, %eax
	je	LBB2_414
## %bb.334:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	leaq	LJTI2_0(%rip), %r14
	leaq	LJTI2_1(%rip), %r15
	jne	LBB2_724
## %bb.335:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	128(%r12), %rdi
	incq	%rdi
	callq	_parse8
	cmpl	$8, 168(%r12)
	jne	LBB2_722
## %bb.336:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$160, %r12
	addq	$32, %r12
	jmp	LBB2_4
LBB2_337:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_396
## %bb.338:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_718
## %bb.339:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	cmpb	$48, 1(%rdi)
	jne	LBB2_441
## %bb.340:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	2(%rdi), %eax
	cmpl	$98, %eax
	je	LBB2_512
## %bb.341:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %eax
	je	LBB2_511
## %bb.342:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %eax
	jne	LBB2_441
## %bb.343:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_442
LBB2_344:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$67, -320(%rbp)
LBB2_345:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$2, -312(%rbp)
	movw	%bx, -304(%rbp)
LBB2_346:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$1, -296(%rbp)
	movb	%r15b, -288(%rbp)
LBB2_347:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$33, %ecx
	movq	%rsp, %rdi
	movq	%r12, %rsi
	jmp	LBB2_568
LBB2_348:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_202
LBB2_349:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_199
LBB2_350:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	_strtol
	jmp	LBB2_203
LBB2_351:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	jmp	LBB2_199
LBB2_352:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %r15
	movq	%r15, %rdi
	callq	_strlen
	leaq	1(%rax), %rdi
	callq	_malloc
	movq	%rax, %rbx
	leaq	LJTI2_6(%rip), %rdi
	jmp	LBB2_355
	.p2align	4, 0x90
LBB2_353:                               ##   in Loop: Header=BB2_355 Depth=2
	testl	%ecx, %ecx
	je	LBB2_375
LBB2_354:                               ##   in Loop: Header=BB2_355 Depth=2
	movb	%cl, (%rax)
	incq	%rax
	incq	%r15
LBB2_355:                               ##   Parent Loop BB2_4 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movzbl	(%r15), %ecx
	cmpl	$92, %ecx
	jne	LBB2_353
## %bb.356:                             ##   in Loop: Header=BB2_355 Depth=2
	movsbl	1(%r15), %esi
	incq	%r15
	cmpl	$91, %esi
	jle	LBB2_360
## %bb.357:                             ##   in Loop: Header=BB2_355 Depth=2
	leal	-92(%rsi), %edx
	cmpl	$24, %edx
	ja	LBB2_507
## %bb.358:                             ##   in Loop: Header=BB2_355 Depth=2
	movb	$10, %cl
	movslq	(%rdi,%rdx,4), %rdx
	addq	%rdi, %rdx
	jmpq	*%rdx
LBB2_359:                               ##   in Loop: Header=BB2_355 Depth=2
	movb	$92, %cl
	jmp	LBB2_354
	.p2align	4, 0x90
LBB2_360:                               ##   in Loop: Header=BB2_355 Depth=2
	cmpl	$34, %esi
	je	LBB2_367
## %bb.361:                             ##   in Loop: Header=BB2_355 Depth=2
	cmpl	$39, %esi
	je	LBB2_366
## %bb.362:                             ##   in Loop: Header=BB2_355 Depth=2
	cmpl	$48, %esi
	jne	LBB2_507
## %bb.363:                             ##   in Loop: Header=BB2_355 Depth=2
	xorl	%ecx, %ecx
	jmp	LBB2_354
LBB2_364:                               ##   in Loop: Header=BB2_355 Depth=2
	movb	$9, %cl
	jmp	LBB2_354
LBB2_365:                               ##   in Loop: Header=BB2_355 Depth=2
	movb	$13, %cl
	jmp	LBB2_354
LBB2_366:                               ##   in Loop: Header=BB2_355 Depth=2
	movb	$39, %cl
	jmp	LBB2_354
LBB2_367:                               ##   in Loop: Header=BB2_355 Depth=2
	movb	$34, %cl
	jmp	LBB2_354
LBB2_368:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	24(%r13), %rbx
LBB2_369:                               ##   in Loop: Header=BB2_4 Depth=1
	imulq	$272, %rax, %r14                ## imm = 0x110
	movl	$0, (%rbx,%r14)
	movl	$8, %edi
	callq	_malloc
	movq	%rax, 8(%rbx,%r14)
	movq	24(%r13), %rax
	imulq	$272, 32(%r13), %rcx            ## imm = 0x110
	movq	-264(%rcx,%rax), %rcx
	movsd	-56(%rbp), %xmm0                ## 8-byte Reload
                                        ## xmm0 = mem[0],zero
	movsd	%xmm0, (%rcx)
	imulq	$272, 32(%r13), %rcx            ## imm = 0x110
	movq	$8, -256(%rcx,%rax)
	addq	$8, 48(%r13)
	leaq	LJTI2_0(%rip), %r14
	addq	$32, %r12
	jmp	LBB2_4
LBB2_370:                               ##   in Loop: Header=BB2_4 Depth=1
	incq	%rdi
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_371:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoul
LBB2_372:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	%rax, %rbx
	leaq	128(%r12), %r14
	movl	136(%r12), %eax
	cmpl	$3, %eax
	je	LBB2_384
## %bb.373:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$8, %eax
	jne	LBB2_723
## %bb.374:                             ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$36, -320(%rbp)
	movl	$1, -312(%rbp)
	movq	-56(%rbp), %rax                 ## 8-byte Reload
	movb	%al, -304(%rbp)
	movl	$1, -296(%rbp)
	movb	%bl, -288(%rbp)
	jmp	LBB2_418
LBB2_375:                               ##   in Loop: Header=BB2_4 Depth=1
	movb	$0, (%rax)
LBB2_376:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$104, -320(%rbp)
	jmp	LBB2_566
LBB2_377:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_444
## %bb.378:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_718
## %bb.379:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	cmpb	$48, 1(%rdi)
	jne	LBB2_470
## %bb.380:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	2(%rdi), %eax
	cmpl	$98, %eax
	je	LBB2_518
## %bb.381:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %eax
	je	LBB2_519
## %bb.382:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %eax
	jne	LBB2_470
## %bb.383:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_471
LBB2_384:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	cmpb	$48, (%rdi)
	jne	LBB2_430
## %bb.385:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	1(%rdi), %eax
	cmpl	$98, %eax
	je	LBB2_508
## %bb.386:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %eax
	je	LBB2_509
## %bb.387:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %eax
	jne	LBB2_430
## %bb.388:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_431
LBB2_389:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_244
LBB2_390:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_247
LBB2_391:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	jmp	LBB2_244
LBB2_392:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	_strtol
	jmp	LBB2_248
LBB2_393:                               ##   in Loop: Header=BB2_4 Depth=1
	incq	%rdi
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_394:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoul
LBB2_395:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$97, -320(%rbp)
	jmp	LBB2_500
LBB2_396:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %r15
	movq	%r15, %rdi
	callq	_strlen
	leaq	1(%rax), %rdi
	callq	_malloc
	movq	%rax, %rbx
	leaq	LJTI2_5(%rip), %rdi
	jmp	LBB2_399
	.p2align	4, 0x90
LBB2_397:                               ##   in Loop: Header=BB2_399 Depth=2
	testl	%ecx, %ecx
	je	LBB2_412
LBB2_398:                               ##   in Loop: Header=BB2_399 Depth=2
	movb	%cl, (%rax)
	incq	%rax
	incq	%r15
LBB2_399:                               ##   Parent Loop BB2_4 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movzbl	(%r15), %ecx
	cmpl	$92, %ecx
	jne	LBB2_397
## %bb.400:                             ##   in Loop: Header=BB2_399 Depth=2
	movsbl	1(%r15), %esi
	incq	%r15
	cmpl	$91, %esi
	jle	LBB2_404
## %bb.401:                             ##   in Loop: Header=BB2_399 Depth=2
	leal	-92(%rsi), %edx
	cmpl	$24, %edx
	ja	LBB2_516
## %bb.402:                             ##   in Loop: Header=BB2_399 Depth=2
	movb	$10, %cl
	movslq	(%rdi,%rdx,4), %rdx
	addq	%rdi, %rdx
	jmpq	*%rdx
LBB2_403:                               ##   in Loop: Header=BB2_399 Depth=2
	movb	$92, %cl
	jmp	LBB2_398
	.p2align	4, 0x90
LBB2_404:                               ##   in Loop: Header=BB2_399 Depth=2
	cmpl	$34, %esi
	je	LBB2_411
## %bb.405:                             ##   in Loop: Header=BB2_399 Depth=2
	cmpl	$39, %esi
	je	LBB2_410
## %bb.406:                             ##   in Loop: Header=BB2_399 Depth=2
	cmpl	$48, %esi
	jne	LBB2_516
## %bb.407:                             ##   in Loop: Header=BB2_399 Depth=2
	xorl	%ecx, %ecx
	jmp	LBB2_398
LBB2_408:                               ##   in Loop: Header=BB2_399 Depth=2
	movb	$13, %cl
	jmp	LBB2_398
LBB2_409:                               ##   in Loop: Header=BB2_399 Depth=2
	movb	$9, %cl
	jmp	LBB2_398
LBB2_410:                               ##   in Loop: Header=BB2_399 Depth=2
	movb	$39, %cl
	jmp	LBB2_398
LBB2_411:                               ##   in Loop: Header=BB2_399 Depth=2
	movb	$34, %cl
	jmp	LBB2_398
LBB2_412:                               ##   in Loop: Header=BB2_4 Depth=1
	movb	$0, (%rax)
LBB2_413:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$120, -320(%rbp)
	jmp	LBB2_566
LBB2_414:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_parse64
	movq	%rax, %r13
	movswq	%r13w, %rax
	cmpq	%r13, %rax
	leaq	LJTI2_1(%rip), %r15
	jne	LBB2_720
## %bb.415:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$8, 168(%r12)
	jne	LBB2_722
## %bb.416:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$160, %r12
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r14
	movq	%r14, %rdi
	callq	___bzero
	movw	$43, -320(%rbp)
	movl	$4, -312(%rbp)
	movq	%rbx, -304(%rbp)
	movl	$1, -296(%rbp)
	movq	-56(%rbp), %rax                 ## 8-byte Reload
	movb	%al, -288(%rbp)
	movl	$2, -280(%rbp)
	movw	%r13w, -272(%rbp)
	movl	$33, %ecx
	movq	%rsp, %rdi
	movq	%r14, %rsi
	rep;movsq (%rsi), %es:(%rdi)
	movq	-48(%rbp), %r13                 ## 8-byte Reload
	movq	%r13, %rdi
	callq	_add_instruction
	leaq	LJTI2_0(%rip), %r14
	addq	$32, %r12
	jmp	LBB2_4
LBB2_417:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$43, -320(%rbp)
	movl	$4, -312(%rbp)
	movq	%rbx, -304(%rbp)
	movl	$1, -296(%rbp)
	movq	-56(%rbp), %rax                 ## 8-byte Reload
	movb	%al, -288(%rbp)
LBB2_418:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$2, -280(%rbp)
	jmp	LBB2_567
LBB2_419:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_473
## %bb.420:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_718
## %bb.421:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	cmpb	$48, 1(%rdi)
	jne	LBB2_497
## %bb.422:                             ##   in Loop: Header=BB2_4 Depth=1
	movzbl	2(%rdi), %eax
	cmpl	$98, %eax
	je	LBB2_525
## %bb.423:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$111, %eax
	je	LBB2_526
## %bb.424:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$120, %eax
	jne	LBB2_497
## %bb.425:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB2_498
LBB2_426:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_267
LBB2_427:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_270
LBB2_428:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	_strtol
	jmp	LBB2_268
LBB2_429:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	jmp	LBB2_270
LBB2_430:                               ##   in Loop: Header=BB2_4 Depth=1
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_431:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoull
	movq	%rax, %r13
	movswq	%r13w, %rax
	cmpq	%r13, %rax
	jne	LBB2_720
## %bb.432:                             ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$36, -320(%rbp)
	movl	$1, -312(%rbp)
	movq	-56(%rbp), %rax                 ## 8-byte Reload
	movb	%al, -304(%rbp)
	movl	$1, -296(%rbp)
	movb	%bl, -288(%rbp)
	movl	$2, -280(%rbp)
	movw	%r13w, -272(%rbp)
LBB2_433:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$33, %ecx
	movq	%rsp, %rdi
	movq	%r15, %rsi
LBB2_434:                               ##   in Loop: Header=BB2_4 Depth=1
	rep;movsq (%rsi), %es:(%rdi)
	movq	-48(%rbp), %r13                 ## 8-byte Reload
	jmp	LBB2_569
LBB2_435:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_283
LBB2_436:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	_strtol
	jmp	LBB2_284
LBB2_437:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_286
LBB2_438:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	jmp	LBB2_286
LBB2_439:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_290
LBB2_440:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	_strtol
	jmp	LBB2_291
LBB2_441:                               ##   in Loop: Header=BB2_4 Depth=1
	incq	%rdi
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_442:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoul
LBB2_443:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$113, -320(%rbp)
	jmp	LBB2_500
LBB2_444:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %r15
	movq	%r15, %rdi
	callq	_strlen
	leaq	1(%rax), %rdi
	callq	_malloc
	movq	%rax, %rbx
	leaq	LJTI2_4(%rip), %rdi
	jmp	LBB2_447
	.p2align	4, 0x90
LBB2_445:                               ##   in Loop: Header=BB2_447 Depth=2
	testl	%ecx, %ecx
	je	LBB2_461
LBB2_446:                               ##   in Loop: Header=BB2_447 Depth=2
	movb	%cl, (%rax)
	incq	%rax
	incq	%r15
LBB2_447:                               ##   Parent Loop BB2_4 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movzbl	(%r15), %ecx
	cmpl	$92, %ecx
	jne	LBB2_445
## %bb.448:                             ##   in Loop: Header=BB2_447 Depth=2
	movsbl	1(%r15), %esi
	incq	%r15
	cmpl	$91, %esi
	jle	LBB2_452
## %bb.449:                             ##   in Loop: Header=BB2_447 Depth=2
	leal	-92(%rsi), %edx
	cmpl	$24, %edx
	ja	LBB2_523
## %bb.450:                             ##   in Loop: Header=BB2_447 Depth=2
	movb	$10, %cl
	movslq	(%rdi,%rdx,4), %rdx
	addq	%rdi, %rdx
	jmpq	*%rdx
LBB2_451:                               ##   in Loop: Header=BB2_447 Depth=2
	movb	$92, %cl
	jmp	LBB2_446
	.p2align	4, 0x90
LBB2_452:                               ##   in Loop: Header=BB2_447 Depth=2
	cmpl	$34, %esi
	je	LBB2_459
## %bb.453:                             ##   in Loop: Header=BB2_447 Depth=2
	cmpl	$39, %esi
	je	LBB2_458
## %bb.454:                             ##   in Loop: Header=BB2_447 Depth=2
	cmpl	$48, %esi
	jne	LBB2_523
## %bb.455:                             ##   in Loop: Header=BB2_447 Depth=2
	xorl	%ecx, %ecx
	jmp	LBB2_446
LBB2_456:                               ##   in Loop: Header=BB2_447 Depth=2
	movb	$13, %cl
	jmp	LBB2_446
LBB2_457:                               ##   in Loop: Header=BB2_447 Depth=2
	movb	$9, %cl
	jmp	LBB2_446
LBB2_458:                               ##   in Loop: Header=BB2_447 Depth=2
	movb	$39, %cl
	jmp	LBB2_446
LBB2_459:                               ##   in Loop: Header=BB2_447 Depth=2
	movb	$34, %cl
	jmp	LBB2_446
LBB2_460:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	L_.str.74(%rip), %rdi
                                        ## kill: def $esi killed $esi killed $rsi
	xorl	%eax, %eax
	callq	_printf
	xorl	%ebx, %ebx
	jmp	LBB2_256
LBB2_461:                               ##   in Loop: Header=BB2_4 Depth=1
	movb	$0, (%rax)
LBB2_462:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$136, -320(%rbp)
	jmp	LBB2_566
LBB2_463:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_501
## %bb.464:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_718
## %bb.465:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$161, -320(%rbp)
	jmp	LBB2_555
LBB2_466:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	_strtol
	jmp	LBB2_325
LBB2_467:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_324
LBB2_468:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	jmp	LBB2_328
LBB2_469:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_328
LBB2_470:                               ##   in Loop: Header=BB2_4 Depth=1
	incq	%rdi
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_471:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoul
LBB2_472:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$129, -320(%rbp)
	jmp	LBB2_500
LBB2_473:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %r15
	movq	%r15, %rdi
	callq	_strlen
	leaq	1(%rax), %rdi
	callq	_malloc
	movq	%rax, %rbx
	leaq	LJTI2_3(%rip), %rdi
	jmp	LBB2_476
	.p2align	4, 0x90
LBB2_474:                               ##   in Loop: Header=BB2_476 Depth=2
	testl	%ecx, %ecx
	je	LBB2_489
LBB2_475:                               ##   in Loop: Header=BB2_476 Depth=2
	movb	%cl, (%rax)
	incq	%rax
	incq	%r15
LBB2_476:                               ##   Parent Loop BB2_4 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movzbl	(%r15), %ecx
	cmpl	$92, %ecx
	jne	LBB2_474
## %bb.477:                             ##   in Loop: Header=BB2_476 Depth=2
	movsbl	1(%r15), %esi
	incq	%r15
	cmpl	$91, %esi
	jle	LBB2_481
## %bb.478:                             ##   in Loop: Header=BB2_476 Depth=2
	leal	-92(%rsi), %edx
	cmpl	$24, %edx
	ja	LBB2_530
## %bb.479:                             ##   in Loop: Header=BB2_476 Depth=2
	movb	$10, %cl
	movslq	(%rdi,%rdx,4), %rdx
	addq	%rdi, %rdx
	jmpq	*%rdx
LBB2_480:                               ##   in Loop: Header=BB2_476 Depth=2
	movb	$92, %cl
	jmp	LBB2_475
	.p2align	4, 0x90
LBB2_481:                               ##   in Loop: Header=BB2_476 Depth=2
	cmpl	$34, %esi
	je	LBB2_488
## %bb.482:                             ##   in Loop: Header=BB2_476 Depth=2
	cmpl	$39, %esi
	je	LBB2_487
## %bb.483:                             ##   in Loop: Header=BB2_476 Depth=2
	cmpl	$48, %esi
	jne	LBB2_530
## %bb.484:                             ##   in Loop: Header=BB2_476 Depth=2
	xorl	%ecx, %ecx
	jmp	LBB2_475
LBB2_485:                               ##   in Loop: Header=BB2_476 Depth=2
	movb	$13, %cl
	jmp	LBB2_475
LBB2_486:                               ##   in Loop: Header=BB2_476 Depth=2
	movb	$9, %cl
	jmp	LBB2_475
LBB2_487:                               ##   in Loop: Header=BB2_476 Depth=2
	movb	$39, %cl
	jmp	LBB2_475
LBB2_488:                               ##   in Loop: Header=BB2_476 Depth=2
	movb	$34, %cl
	jmp	LBB2_475
LBB2_489:                               ##   in Loop: Header=BB2_4 Depth=1
	movb	$0, (%rax)
LBB2_490:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$152, -320(%rbp)
	jmp	LBB2_566
LBB2_491:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_371
LBB2_492:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	_strtol
	jmp	LBB2_372
LBB2_493:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_510
## %bb.494:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_718
## %bb.495:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$177, -320(%rbp)
	jmp	LBB2_555
LBB2_496:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	L_.str.74(%rip), %rdi
                                        ## kill: def $esi killed $esi killed $rsi
	xorl	%eax, %eax
	callq	_printf
	xorl	%ebx, %ebx
	jmp	LBB2_332
LBB2_497:                               ##   in Loop: Header=BB2_4 Depth=1
	incq	%rdi
	xorl	%esi, %esi
	movl	$10, %edx
LBB2_498:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	_strtoul
LBB2_499:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$145, -320(%rbp)
LBB2_500:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$1, -312(%rbp)
	movb	%bl, -304(%rbp)
	jmp	LBB2_567
LBB2_501:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_unquote
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$168, -320(%rbp)
	jmp	LBB2_566
LBB2_502:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	_strtol
	jmp	LBB2_395
LBB2_503:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_394
LBB2_504:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_517
## %bb.505:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_718
## %bb.506:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$193, -320(%rbp)
	jmp	LBB2_555
LBB2_507:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	L_.str.74(%rip), %rdi
                                        ## kill: def $esi killed $esi killed $rsi
	xorl	%eax, %eax
	callq	_printf
	xorl	%ebx, %ebx
	jmp	LBB2_376
LBB2_508:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	jmp	LBB2_431
LBB2_509:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_431
LBB2_510:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_unquote
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$184, -320(%rbp)
	jmp	LBB2_566
LBB2_511:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_442
LBB2_512:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	_strtol
	jmp	LBB2_443
LBB2_513:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_524
## %bb.514:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_718
## %bb.515:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$209, -320(%rbp)
	jmp	LBB2_555
LBB2_516:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	L_.str.74(%rip), %rdi
                                        ## kill: def $esi killed $esi killed $rsi
	xorl	%eax, %eax
	callq	_printf
	xorl	%ebx, %ebx
	jmp	LBB2_413
LBB2_517:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_unquote
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$200, -320(%rbp)
	jmp	LBB2_566
LBB2_518:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	_strtol
	jmp	LBB2_472
LBB2_519:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_471
LBB2_520:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_531
## %bb.521:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_718
## %bb.522:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$225, -320(%rbp)
	jmp	LBB2_555
LBB2_523:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	L_.str.74(%rip), %rdi
                                        ## kill: def $esi killed $esi killed $rsi
	xorl	%eax, %eax
	callq	_printf
	xorl	%ebx, %ebx
	jmp	LBB2_462
LBB2_524:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_unquote
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$216, -320(%rbp)
	jmp	LBB2_566
LBB2_525:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	_strtol
	jmp	LBB2_499
LBB2_526:                               ##   in Loop: Header=BB2_4 Depth=1
	addq	$3, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB2_498
LBB2_527:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_535
## %bb.528:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_718
## %bb.529:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$545, -320(%rbp)                ## imm = 0x221
	jmp	LBB2_555
LBB2_530:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	L_.str.74(%rip), %rdi
                                        ## kill: def $esi killed $esi killed $rsi
	xorl	%eax, %eax
	callq	_printf
	xorl	%ebx, %ebx
	jmp	LBB2_490
LBB2_531:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_unquote
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$232, -320(%rbp)
	jmp	LBB2_566
LBB2_532:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_539
## %bb.533:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_718
## %bb.534:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$561, -320(%rbp)                ## imm = 0x231
	jmp	LBB2_555
LBB2_535:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_unquote
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$552, -320(%rbp)                ## imm = 0x228
	jmp	LBB2_566
LBB2_536:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_543
## %bb.537:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_718
## %bb.538:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$577, -320(%rbp)                ## imm = 0x241
	jmp	LBB2_555
LBB2_539:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_unquote
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$568, -320(%rbp)                ## imm = 0x238
	jmp	LBB2_566
LBB2_540:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_547
## %bb.541:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_718
## %bb.542:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$593, -320(%rbp)                ## imm = 0x251
	jmp	LBB2_555
LBB2_543:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_unquote
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$584, -320(%rbp)                ## imm = 0x248
	jmp	LBB2_566
LBB2_544:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_551
## %bb.545:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_718
## %bb.546:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$609, -320(%rbp)                ## imm = 0x261
	jmp	LBB2_555
LBB2_547:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_unquote
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$600, -320(%rbp)                ## imm = 0x258
	jmp	LBB2_566
LBB2_548:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_556
## %bb.549:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_718
## %bb.550:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$625, -320(%rbp)                ## imm = 0x271
	jmp	LBB2_555
LBB2_551:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_unquote
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$616, -320(%rbp)                ## imm = 0x268
	jmp	LBB2_566
LBB2_552:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_560
## %bb.553:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_718
## %bb.554:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$641, -320(%rbp)                ## imm = 0x281
LBB2_555:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$1, -312(%rbp)
	movb	%bl, -304(%rbp)
	jmp	LBB2_567
LBB2_556:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_unquote
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$632, -320(%rbp)                ## imm = 0x278
	jmp	LBB2_566
LBB2_557:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_565
## %bb.558:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_718
## %bb.559:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$657, -320(%rbp)                ## imm = 0x291
	jmp	LBB2_564
LBB2_560:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_unquote
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$648, -320(%rbp)                ## imm = 0x288
	jmp	LBB2_566
LBB2_561:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_572
## %bb.562:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_718
## %bb.563:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$673, -320(%rbp)                ## imm = 0x2A1
LBB2_564:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$1, -312(%rbp)
	movb	%bl, -304(%rbp)
	jmp	LBB2_433
LBB2_565:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_unquote
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$664, -320(%rbp)                ## imm = 0x298
LBB2_566:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$4, -312(%rbp)
	movq	%rbx, -304(%rbp)
LBB2_567:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$33, %ecx
	movq	%rsp, %rdi
	movq	%r15, %rsi
LBB2_568:                               ##   in Loop: Header=BB2_4 Depth=1
	rep;movsq (%rsi), %es:(%rdi)
LBB2_569:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	%r13, %rdi
	callq	_add_instruction
	movq	%r14, %r12
	.p2align	4, 0x90
LBB2_570:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	LJTI2_0(%rip), %r14
	leaq	LJTI2_1(%rip), %r15
	addq	$32, %r12
	jmp	LBB2_4
LBB2_571:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %rbx
	movq	%rbx, %rdi
	callq	___bzero
	movb	$-16, -320(%rbp)
	jmp	LBB2_114
LBB2_572:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_unquote
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$680, -320(%rbp)                ## imm = 0x2A8
LBB2_573:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$4, -312(%rbp)
	movq	%rbx, -304(%rbp)
	jmp	LBB2_433
LBB2_574:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %rbx
	movq	%rbx, %rdi
	callq	___bzero
	movb	$1, -319(%rbp)
	jmp	LBB2_581
LBB2_575:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %rbx
	movq	%rbx, %rdi
	callq	___bzero
	movw	$273, -320(%rbp)                ## imm = 0x111
	jmp	LBB2_577
LBB2_576:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %rbx
	movq	%rbx, %rdi
	callq	___bzero
	movw	$289, -320(%rbp)                ## imm = 0x121
LBB2_577:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$1, -312(%rbp)
	jmp	LBB2_581
LBB2_578:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %rbx
	movq	%rbx, %rdi
	callq	___bzero
	movw	$273, -320(%rbp)                ## imm = 0x111
	jmp	LBB2_580
LBB2_579:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %rbx
	movq	%rbx, %rdi
	callq	___bzero
	movw	$289, -320(%rbp)                ## imm = 0x121
LBB2_580:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$1, -312(%rbp)
	movb	$1, -304(%rbp)
LBB2_581:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$33, %ecx
	movq	%rsp, %rdi
	movq	%rbx, %rsi
LBB2_582:                               ##   in Loop: Header=BB2_4 Depth=1
	rep;movsq (%rsi), %es:(%rdi)
	movq	-48(%rbp), %r13                 ## 8-byte Reload
	movq	%r13, %rdi
	callq	_add_instruction
	jmp	LBB2_570
LBB2_583:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %rbx
	movq	%rbx, %rdi
	callq	___bzero
	movw	$688, -320(%rbp)                ## imm = 0x2B0
	jmp	LBB2_581
LBB2_584:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_595
## %bb.585:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$3, %eax
	je	LBB2_596
## %bb.586:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_725
## %bb.587:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$273, -320(%rbp)                ## imm = 0x111
	jmp	LBB2_564
LBB2_588:                               ##   in Loop: Header=BB2_4 Depth=1
	leaq	32(%r12), %r14
	movl	40(%r12), %eax
	testl	%eax, %eax
	je	LBB2_598
## %bb.589:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_718
## %bb.590:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$289, -320(%rbp)                ## imm = 0x121
	jmp	LBB2_564
LBB2_591:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, 40(%r12)
	jne	LBB2_709
## %bb.592:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	32(%r12), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	leaq	64(%r12), %r14
	movl	72(%r12), %eax
	cmpl	$3, %eax
	je	LBB2_603
## %bb.593:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_714
## %bb.594:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %r15d
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	callq	___bzero
	movw	$306, -320(%rbp)                ## imm = 0x132
	jmp	LBB2_658
LBB2_595:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_unquote
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$280, -320(%rbp)                ## imm = 0x118
	jmp	LBB2_573
LBB2_596:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_parse64
	cmpq	$65535, %rax                    ## imm = 0xFFFF
	jbe	LBB2_605
## %bb.597:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	%r14, %r12
	movq	-48(%rbp), %r13                 ## 8-byte Reload
	jmp	LBB2_570
LBB2_598:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_unquote
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$296, -320(%rbp)                ## imm = 0x128
	jmp	LBB2_573
LBB2_599:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, 40(%r12)
	jne	LBB2_709
## %bb.600:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	32(%r12), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	leaq	64(%r12), %r14
	movl	72(%r12), %eax
	cmpl	$3, %eax
	je	LBB2_610
## %bb.601:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_714
## %bb.602:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %r15d
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	callq	___bzero
	movw	$322, -320(%rbp)                ## imm = 0x142
	jmp	LBB2_658
LBB2_603:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_parse64
	movq	%rax, %r15
	movswq	%r15w, %rax
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	cmpq	%r15, %rax
	je	LBB2_616
## %bb.604:                             ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$313, -320(%rbp)                ## imm = 0x139
	jmp	LBB2_667
LBB2_605:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	%rax, %rbx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r15
	movq	%r15, %rdi
	callq	___bzero
	movw	$274, -320(%rbp)                ## imm = 0x112
	movl	$2, -312(%rbp)
	movw	%bx, -304(%rbp)
	jmp	LBB2_433
LBB2_606:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, 40(%r12)
	jne	LBB2_709
## %bb.607:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	32(%r12), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	leaq	64(%r12), %r14
	movl	72(%r12), %eax
	cmpl	$3, %eax
	je	LBB2_617
## %bb.608:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_714
## %bb.609:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %r15d
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	callq	___bzero
	movw	$338, -320(%rbp)                ## imm = 0x152
	jmp	LBB2_658
LBB2_610:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_parse64
	movq	%rax, %r15
	movswq	%r15w, %rax
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	cmpq	%r15, %rax
	je	LBB2_623
## %bb.611:                             ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$329, -320(%rbp)                ## imm = 0x149
	jmp	LBB2_667
LBB2_612:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, 40(%r12)
	jne	LBB2_709
## %bb.613:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	32(%r12), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	leaq	64(%r12), %r14
	movl	72(%r12), %eax
	cmpl	$3, %eax
	je	LBB2_624
## %bb.614:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_714
## %bb.615:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %r15d
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	callq	___bzero
	movw	$354, -320(%rbp)                ## imm = 0x162
	jmp	LBB2_658
LBB2_616:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$307, -320(%rbp)                ## imm = 0x133
	jmp	LBB2_675
LBB2_617:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_parse64
	movq	%rax, %r15
	movswq	%r15w, %rax
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	cmpq	%r15, %rax
	je	LBB2_630
## %bb.618:                             ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$345, -320(%rbp)                ## imm = 0x159
	jmp	LBB2_667
LBB2_619:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, 40(%r12)
	jne	LBB2_709
## %bb.620:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	32(%r12), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	leaq	64(%r12), %r14
	movl	72(%r12), %eax
	cmpl	$3, %eax
	je	LBB2_631
## %bb.621:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_714
## %bb.622:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %r15d
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	callq	___bzero
	movw	$370, -320(%rbp)                ## imm = 0x172
	jmp	LBB2_658
LBB2_623:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$323, -320(%rbp)                ## imm = 0x143
	jmp	LBB2_675
LBB2_624:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_parse64
	movq	%rax, %r15
	movswq	%r15w, %rax
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	cmpq	%r15, %rax
	je	LBB2_637
## %bb.625:                             ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$361, -320(%rbp)                ## imm = 0x169
	jmp	LBB2_667
LBB2_626:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, 40(%r12)
	jne	LBB2_709
## %bb.627:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	32(%r12), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	leaq	64(%r12), %r14
	movl	72(%r12), %eax
	cmpl	$3, %eax
	je	LBB2_638
## %bb.628:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_714
## %bb.629:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %r15d
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	callq	___bzero
	movw	$386, -320(%rbp)                ## imm = 0x182
	jmp	LBB2_658
LBB2_630:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$339, -320(%rbp)                ## imm = 0x153
	jmp	LBB2_675
LBB2_631:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_parse64
	movq	%rax, %r15
	movswq	%r15w, %rax
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	cmpq	%r15, %rax
	je	LBB2_644
## %bb.632:                             ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$377, -320(%rbp)                ## imm = 0x179
	jmp	LBB2_667
LBB2_633:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, 40(%r12)
	jne	LBB2_709
## %bb.634:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	32(%r12), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	leaq	64(%r12), %r14
	movl	72(%r12), %eax
	cmpl	$3, %eax
	je	LBB2_645
## %bb.635:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_714
## %bb.636:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %r15d
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	callq	___bzero
	movw	$402, -320(%rbp)                ## imm = 0x192
	jmp	LBB2_658
LBB2_637:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$355, -320(%rbp)                ## imm = 0x163
	jmp	LBB2_675
LBB2_638:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_parse64
	movq	%rax, %r15
	movswq	%r15w, %rax
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	cmpq	%r15, %rax
	je	LBB2_651
## %bb.639:                             ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$393, -320(%rbp)                ## imm = 0x189
	jmp	LBB2_667
LBB2_640:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, 40(%r12)
	jne	LBB2_709
## %bb.641:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	32(%r12), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	leaq	64(%r12), %r14
	movl	72(%r12), %eax
	cmpl	$3, %eax
	je	LBB2_652
## %bb.642:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_714
## %bb.643:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %r15d
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	callq	___bzero
	movw	$418, -320(%rbp)                ## imm = 0x1A2
	jmp	LBB2_658
LBB2_644:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$371, -320(%rbp)                ## imm = 0x173
	jmp	LBB2_675
LBB2_645:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_parse64
	movq	%rax, %r15
	movswq	%r15w, %rax
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	cmpq	%r15, %rax
	je	LBB2_659
## %bb.646:                             ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$409, -320(%rbp)                ## imm = 0x199
	jmp	LBB2_667
LBB2_647:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, 40(%r12)
	jne	LBB2_709
## %bb.648:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	32(%r12), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	leaq	64(%r12), %r14
	movl	72(%r12), %eax
	cmpl	$3, %eax
	je	LBB2_660
## %bb.649:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_714
## %bb.650:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %r15d
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	callq	___bzero
	movw	$434, -320(%rbp)                ## imm = 0x1B2
	jmp	LBB2_658
LBB2_651:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$387, -320(%rbp)                ## imm = 0x183
	jmp	LBB2_675
LBB2_652:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_parse64
	movq	%rax, %r15
	movswq	%r15w, %rax
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	cmpq	%r15, %rax
	je	LBB2_664
## %bb.653:                             ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$425, -320(%rbp)                ## imm = 0x1A9
	jmp	LBB2_667
LBB2_654:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, 40(%r12)
	jne	LBB2_709
## %bb.655:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	32(%r12), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	leaq	64(%r12), %r14
	movl	72(%r12), %eax
	cmpl	$3, %eax
	je	LBB2_665
## %bb.656:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_714
## %bb.657:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %r15d
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	callq	___bzero
	movw	$450, -320(%rbp)                ## imm = 0x1C2
LBB2_658:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$1, -312(%rbp)
	movb	%bl, -304(%rbp)
	movl	$1, -296(%rbp)
	movb	%r15b, -288(%rbp)
	jmp	LBB2_677
LBB2_659:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$403, -320(%rbp)                ## imm = 0x193
	jmp	LBB2_675
LBB2_660:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_parse64
	movq	%rax, %r15
	movswq	%r15w, %rax
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	cmpq	%r15, %rax
	je	LBB2_670
## %bb.661:                             ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$441, -320(%rbp)                ## imm = 0x1B9
	jmp	LBB2_667
LBB2_662:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, 40(%r12)
	jne	LBB2_709
## %bb.663:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$32, %r12
	movq	(%r12), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r14
	movq	%r14, %rdi
	callq	___bzero
	movw	$465, -320(%rbp)                ## imm = 0x1D1
	jmp	LBB2_673
LBB2_664:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$419, -320(%rbp)                ## imm = 0x1A3
	jmp	LBB2_675
LBB2_665:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r14), %rdi
	callq	_parse64
	movq	%rax, %r15
	movswq	%r15w, %rax
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	cmpq	%r15, %rax
	je	LBB2_674
## %bb.666:                             ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$457, -320(%rbp)                ## imm = 0x1C9
LBB2_667:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$3, -312(%rbp)
	movq	%r15, -304(%rbp)
	jmp	LBB2_676
LBB2_668:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, 40(%r12)
	jne	LBB2_709
## %bb.669:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$32, %r12
	movq	(%r12), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r14
	movq	%r14, %rdi
	callq	___bzero
	movw	$481, -320(%rbp)                ## imm = 0x1E1
	jmp	LBB2_673
LBB2_670:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$435, -320(%rbp)                ## imm = 0x1B3
	jmp	LBB2_675
LBB2_671:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, 40(%r12)
	jne	LBB2_709
## %bb.672:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$32, %r12
	movq	(%r12), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r14
	movq	%r14, %rdi
	callq	___bzero
	movw	$497, -320(%rbp)                ## imm = 0x1F1
LBB2_673:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$1, -312(%rbp)
	movb	%bl, -304(%rbp)
	movl	$33, %ecx
	movq	%rsp, %rdi
	movq	%r14, %rsi
	jmp	LBB2_582
LBB2_674:                               ##   in Loop: Header=BB2_4 Depth=1
	callq	___bzero
	movw	$451, -320(%rbp)                ## imm = 0x1C3
LBB2_675:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$2, -312(%rbp)
	movw	%r15w, -304(%rbp)
LBB2_676:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$1, -296(%rbp)
	movb	%bl, -288(%rbp)
LBB2_677:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$33, %ecx
	movq	%rsp, %rdi
	movq	%r12, %rsi
	jmp	LBB2_434
LBB2_678:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %rbx
	movq	%rbx, %rdi
	callq	___bzero
	movb	$2, -319(%rbp)
	jmp	LBB2_581
LBB2_679:                               ##   in Loop: Header=BB2_4 Depth=1
	movb	$1, %r14b
	jmp	LBB2_682
LBB2_680:                               ##   in Loop: Header=BB2_4 Depth=1
	movb	$2, %r14b
	jmp	LBB2_682
LBB2_681:                               ##   in Loop: Header=BB2_4 Depth=1
	movb	$4, %r14b
LBB2_682:                               ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$7, 104(%r12)
	jne	LBB2_729
## %bb.683:                             ##   in Loop: Header=BB2_4 Depth=1
	movl	136(%r12), %eax
	testl	%eax, %eax
	je	LBB2_689
## %bb.684:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$1, %eax
	jne	LBB2_730
## %bb.685:                             ##   in Loop: Header=BB2_4 Depth=1
	movq	128(%r12), %rdi
	incq	%rdi
	callq	_parse8
	movl	%eax, %ebx
	movl	168(%r12), %eax
	cmpl	$1, %eax
	je	LBB2_694
## %bb.686:                             ##   in Loop: Header=BB2_4 Depth=1
	leaq	160(%r12), %r13
	cmpl	$3, %eax
	je	LBB2_696
## %bb.687:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$8, %eax
	jne	LBB2_731
## %bb.688:                             ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	callq	___bzero
	movw	$533, -320(%rbp)                ## imm = 0x215
	movl	$2, -312(%rbp)
	movl	$1, -296(%rbp)
	movb	%r15b, -288(%rbp)
	movl	$1, -280(%rbp)
	movb	%r14b, -272(%rbp)
	movl	$1, -264(%rbp)
	movb	%bl, -256(%rbp)
	jmp	LBB2_693
LBB2_689:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	128(%r12), %rdi
	callq	_unquote
	movq	%rax, %rbx
	movl	168(%r12), %eax
	cmpl	$1, %eax
	je	LBB2_699
## %bb.690:                             ##   in Loop: Header=BB2_4 Depth=1
	leaq	160(%r12), %r13
	cmpl	$3, %eax
	je	LBB2_702
## %bb.691:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$8, %eax
	jne	LBB2_731
## %bb.692:                             ##   in Loop: Header=BB2_4 Depth=1
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %r12
	movq	%r12, %rdi
	callq	___bzero
	movw	$540, -320(%rbp)                ## imm = 0x21C
	movl	$4, -312(%rbp)
	movq	%rbx, -304(%rbp)
	movl	$1, -296(%rbp)
	movb	%r15b, -288(%rbp)
	movl	$1, -280(%rbp)
	movb	%r14b, -272(%rbp)
	movl	$2, -264(%rbp)
LBB2_693:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$33, %ecx
	movq	%rsp, %rdi
	movq	%r12, %rsi
	rep;movsq (%rsi), %es:(%rdi)
	movq	-48(%rbp), %rbx                 ## 8-byte Reload
	movq	%rbx, %rdi
	callq	_add_instruction
	movq	%r13, %r12
	movq	%rbx, %r13
	jmp	LBB2_570
LBB2_694:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	160(%r12), %rdi
	incq	%rdi
	callq	_parse8
	cmpl	$8, 200(%r12)
	jne	LBB2_733
## %bb.695:                             ##   in Loop: Header=BB2_4 Depth=1
	movl	%eax, %r13d
	addq	$192, %r12
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %rdi
	callq	___bzero
	movw	$532, -320(%rbp)                ## imm = 0x214
	movl	$1, -312(%rbp)
	movb	%r15b, -304(%rbp)
	movl	$1, -296(%rbp)
	movb	%r14b, -288(%rbp)
	movl	$1, -280(%rbp)
	movb	%bl, -272(%rbp)
	jmp	LBB2_701
LBB2_696:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r13), %rdi
	callq	_parse64
	movq	%rax, %r13
	movswq	%r13w, %rax
	cmpq	%r13, %rax
	jne	LBB2_732
## %bb.697:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$8, 200(%r12)
	jne	LBB2_733
## %bb.698:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$192, %r12
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %rdi
	callq	___bzero
	movw	$533, -320(%rbp)                ## imm = 0x215
	movl	$2, -312(%rbp)
	movw	%r13w, -304(%rbp)
	movl	$1, -296(%rbp)
	movb	%r15b, -288(%rbp)
	movl	$1, -280(%rbp)
	movb	%r14b, -272(%rbp)
	movl	$1, -264(%rbp)
	movb	%bl, -256(%rbp)
	jmp	LBB2_705
LBB2_699:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	160(%r12), %rdi
	incq	%rdi
	callq	_parse8
	cmpl	$8, 200(%r12)
	jne	LBB2_733
## %bb.700:                             ##   in Loop: Header=BB2_4 Depth=1
	movl	%eax, %r13d
	addq	$192, %r12
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %rdi
	callq	___bzero
	movw	$539, -320(%rbp)                ## imm = 0x21B
	movl	$4, -312(%rbp)
	movq	%rbx, -304(%rbp)
	movl	$1, -296(%rbp)
	movb	%r15b, -288(%rbp)
	movl	$1, -280(%rbp)
	movb	%r14b, -272(%rbp)
LBB2_701:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$1, -264(%rbp)
	movb	%r13b, -256(%rbp)
	jmp	LBB2_705
LBB2_702:                               ##   in Loop: Header=BB2_4 Depth=1
	movq	(%r13), %rdi
	callq	_parse64
	movq	%rax, %r13
	movswq	%r13w, %rax
	cmpq	%r13, %rax
	jne	LBB2_732
## %bb.703:                             ##   in Loop: Header=BB2_4 Depth=1
	cmpl	$8, 200(%r12)
	jne	LBB2_733
## %bb.704:                             ##   in Loop: Header=BB2_4 Depth=1
	addq	$192, %r12
	movl	$264, %esi                      ## imm = 0x108
	leaq	-320(%rbp), %rdi
	callq	___bzero
	movw	$540, -320(%rbp)                ## imm = 0x21C
	movl	$4, -312(%rbp)
	movq	%rbx, -304(%rbp)
	movl	$1, -296(%rbp)
	movb	%r15b, -288(%rbp)
	movl	$1, -280(%rbp)
	movb	%r14b, -272(%rbp)
	movl	$2, -264(%rbp)
	movw	%r13w, -256(%rbp)
LBB2_705:                               ##   in Loop: Header=BB2_4 Depth=1
	movl	$33, %ecx
	movq	%rsp, %rdi
	leaq	-320(%rbp), %rsi
	jmp	LBB2_582
LBB2_706:
	movl	$16, %esi
	movq	-328(%rbp), %rdi                ## 8-byte Reload
	callq	_realloc
	movq	$0, 8(%rax)
	jmp	LBB2_713
LBB2_707:
	movq	32(%r12), %rcx
	movq	48(%r12), %rsi
	movl	56(%r12), %edx
	leaq	L_.str.68(%rip), %rdi
	jmp	LBB2_711
LBB2_708:
	movq	32(%r12), %rcx
	movq	48(%r12), %rsi
	movl	56(%r12), %edx
	leaq	L_.str.69(%rip), %rdi
	jmp	LBB2_711
LBB2_709:
	movq	32(%r12), %rcx
	movq	48(%r12), %rsi
	movl	56(%r12), %edx
LBB2_710:
	leaq	L_.str.7(%rip), %rdi
LBB2_711:
	xorl	%eax, %eax
	callq	_printf
LBB2_712:
	xorl	%eax, %eax
LBB2_713:
	addq	$552, %rsp                      ## imm = 0x228
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
LBB2_714:
	movq	64(%r12), %rcx
	movq	80(%r12), %rsi
	movl	88(%r12), %edx
	leaq	L_.str.12(%rip), %rdi
	jmp	LBB2_711
LBB2_715:
	movq	16(%r12), %rsi
	movl	24(%r12), %edx
	leaq	L_.str.73(%rip), %rdi
	movq	%rbx, %rcx
	jmp	LBB2_711
LBB2_716:
	movq	64(%r12), %rcx
	movq	80(%r12), %rsi
	movl	88(%r12), %edx
	jmp	LBB2_710
LBB2_717:
	movq	32(%r12), %rcx
	movq	48(%r12), %rsi
	movl	56(%r12), %edx
	leaq	L_.str.58(%rip), %rdi
	jmp	LBB2_711
LBB2_718:
	movq	32(%r12), %rcx
	movq	48(%r12), %rsi
	movl	56(%r12), %edx
	leaq	L_.str.16(%rip), %rdi
	jmp	LBB2_711
LBB2_719:
	movq	96(%r12), %rcx
	movq	112(%r12), %rsi
	movl	120(%r12), %edx
	jmp	LBB2_710
LBB2_720:
	movq	144(%r12), %rsi
	movl	152(%r12), %edx
LBB2_721:
	leaq	L_.str.8(%rip), %rdi
	xorl	%eax, %eax
	callq	_printf
	jmp	LBB2_712
LBB2_722:
	movq	160(%r12), %rcx
	movq	176(%r12), %rsi
	movl	184(%r12), %edx
	leaq	L_.str.10(%rip), %rdi
	jmp	LBB2_711
LBB2_723:
	movq	128(%r12), %rcx
	movq	144(%r12), %rsi
	movl	152(%r12), %edx
	leaq	L_.str.9(%rip), %rdi
	jmp	LBB2_711
LBB2_724:
	movq	128(%r12), %rcx
	movq	144(%r12), %rsi
	movl	152(%r12), %edx
	jmp	LBB2_710
LBB2_725:
	movq	32(%r12), %rcx
	movq	48(%r12), %rsi
	movl	56(%r12), %edx
	leaq	L_.str.9(%rip), %rdi
	jmp	LBB2_711
LBB2_726:
	movq	16(%r12), %rsi
	movl	24(%r12), %edx
	leaq	L_.str.65(%rip), %rdi
	movq	%r15, %rcx
	jmp	LBB2_711
LBB2_727:
	movq	64(%r12), %rcx
	movq	80(%r12), %rsi
	movl	88(%r12), %edx
	leaq	L_.str.58(%rip), %rdi
	jmp	LBB2_711
LBB2_728:
	movq	80(%r12), %rsi
	movl	88(%r12), %edx
	leaq	L_.str.63(%rip), %rdi
	movq	%rbx, %rcx
	jmp	LBB2_711
LBB2_729:
	movq	96(%r12), %rcx
	movq	112(%r12), %rsi
	movl	120(%r12), %edx
	leaq	L_.str.64(%rip), %rdi
	jmp	LBB2_711
LBB2_730:
	movq	128(%r12), %rcx
	movq	144(%r12), %rsi
	movl	152(%r12), %edx
	leaq	L_.str.16(%rip), %rdi
	jmp	LBB2_711
LBB2_731:
	movq	160(%r12), %rcx
	movq	176(%r12), %rsi
	movl	184(%r12), %edx
	leaq	L_.str.12(%rip), %rdi
	jmp	LBB2_711
LBB2_732:
	movq	176(%r12), %rsi
	movl	184(%r12), %edx
	jmp	LBB2_721
LBB2_733:
	movq	192(%r12), %rcx
	movq	208(%r12), %rsi
	movl	216(%r12), %edx
	leaq	L_.str.10(%rip), %rdi
	jmp	LBB2_711
	.cfi_endproc
	.p2align	2, 0x90
	.data_region jt32
.set L2_0_set_706, LBB2_706-LJTI2_0
.set L2_0_set_6, LBB2_6-LJTI2_0
.set L2_0_set_3, LBB2_3-LJTI2_0
.set L2_0_set_63, LBB2_63-LJTI2_0
.set L2_0_set_79, LBB2_79-LJTI2_0
LJTI2_0:
	.long	L2_0_set_706
	.long	L2_0_set_6
	.long	L2_0_set_3
	.long	L2_0_set_63
	.long	L2_0_set_3
	.long	L2_0_set_3
	.long	L2_0_set_3
	.long	L2_0_set_79
.set L2_1_set_70, LBB2_70-LJTI2_1
.set L2_1_set_126, LBB2_126-LJTI2_1
.set L2_1_set_65, LBB2_65-LJTI2_1
.set L2_1_set_76, LBB2_76-LJTI2_1
.set L2_1_set_75, LBB2_75-LJTI2_1
LJTI2_1:
	.long	L2_1_set_70
	.long	L2_1_set_126
	.long	L2_1_set_126
	.long	L2_1_set_126
	.long	L2_1_set_126
	.long	L2_1_set_126
	.long	L2_1_set_126
	.long	L2_1_set_126
	.long	L2_1_set_126
	.long	L2_1_set_126
	.long	L2_1_set_126
	.long	L2_1_set_126
	.long	L2_1_set_126
	.long	L2_1_set_126
	.long	L2_1_set_126
	.long	L2_1_set_126
	.long	L2_1_set_126
	.long	L2_1_set_126
	.long	L2_1_set_65
	.long	L2_1_set_126
	.long	L2_1_set_126
	.long	L2_1_set_126
	.long	L2_1_set_76
	.long	L2_1_set_126
	.long	L2_1_set_75
.set L2_2_set_99, LBB2_99-LJTI2_2
.set L2_2_set_147, LBB2_147-LJTI2_2
.set L2_2_set_94, LBB2_94-LJTI2_2
.set L2_2_set_105, LBB2_105-LJTI2_2
.set L2_2_set_104, LBB2_104-LJTI2_2
LJTI2_2:
	.long	L2_2_set_99
	.long	L2_2_set_147
	.long	L2_2_set_147
	.long	L2_2_set_147
	.long	L2_2_set_147
	.long	L2_2_set_147
	.long	L2_2_set_147
	.long	L2_2_set_147
	.long	L2_2_set_147
	.long	L2_2_set_147
	.long	L2_2_set_147
	.long	L2_2_set_147
	.long	L2_2_set_147
	.long	L2_2_set_147
	.long	L2_2_set_147
	.long	L2_2_set_147
	.long	L2_2_set_147
	.long	L2_2_set_147
	.long	L2_2_set_94
	.long	L2_2_set_147
	.long	L2_2_set_147
	.long	L2_2_set_147
	.long	L2_2_set_105
	.long	L2_2_set_147
	.long	L2_2_set_104
.set L2_3_set_480, LBB2_480-LJTI2_3
.set L2_3_set_530, LBB2_530-LJTI2_3
.set L2_3_set_475, LBB2_475-LJTI2_3
.set L2_3_set_485, LBB2_485-LJTI2_3
.set L2_3_set_486, LBB2_486-LJTI2_3
LJTI2_3:
	.long	L2_3_set_480
	.long	L2_3_set_530
	.long	L2_3_set_530
	.long	L2_3_set_530
	.long	L2_3_set_530
	.long	L2_3_set_530
	.long	L2_3_set_530
	.long	L2_3_set_530
	.long	L2_3_set_530
	.long	L2_3_set_530
	.long	L2_3_set_530
	.long	L2_3_set_530
	.long	L2_3_set_530
	.long	L2_3_set_530
	.long	L2_3_set_530
	.long	L2_3_set_530
	.long	L2_3_set_530
	.long	L2_3_set_530
	.long	L2_3_set_475
	.long	L2_3_set_530
	.long	L2_3_set_530
	.long	L2_3_set_530
	.long	L2_3_set_485
	.long	L2_3_set_530
	.long	L2_3_set_486
.set L2_4_set_451, LBB2_451-LJTI2_4
.set L2_4_set_523, LBB2_523-LJTI2_4
.set L2_4_set_446, LBB2_446-LJTI2_4
.set L2_4_set_456, LBB2_456-LJTI2_4
.set L2_4_set_457, LBB2_457-LJTI2_4
LJTI2_4:
	.long	L2_4_set_451
	.long	L2_4_set_523
	.long	L2_4_set_523
	.long	L2_4_set_523
	.long	L2_4_set_523
	.long	L2_4_set_523
	.long	L2_4_set_523
	.long	L2_4_set_523
	.long	L2_4_set_523
	.long	L2_4_set_523
	.long	L2_4_set_523
	.long	L2_4_set_523
	.long	L2_4_set_523
	.long	L2_4_set_523
	.long	L2_4_set_523
	.long	L2_4_set_523
	.long	L2_4_set_523
	.long	L2_4_set_523
	.long	L2_4_set_446
	.long	L2_4_set_523
	.long	L2_4_set_523
	.long	L2_4_set_523
	.long	L2_4_set_456
	.long	L2_4_set_523
	.long	L2_4_set_457
.set L2_5_set_403, LBB2_403-LJTI2_5
.set L2_5_set_516, LBB2_516-LJTI2_5
.set L2_5_set_398, LBB2_398-LJTI2_5
.set L2_5_set_408, LBB2_408-LJTI2_5
.set L2_5_set_409, LBB2_409-LJTI2_5
LJTI2_5:
	.long	L2_5_set_403
	.long	L2_5_set_516
	.long	L2_5_set_516
	.long	L2_5_set_516
	.long	L2_5_set_516
	.long	L2_5_set_516
	.long	L2_5_set_516
	.long	L2_5_set_516
	.long	L2_5_set_516
	.long	L2_5_set_516
	.long	L2_5_set_516
	.long	L2_5_set_516
	.long	L2_5_set_516
	.long	L2_5_set_516
	.long	L2_5_set_516
	.long	L2_5_set_516
	.long	L2_5_set_516
	.long	L2_5_set_516
	.long	L2_5_set_398
	.long	L2_5_set_516
	.long	L2_5_set_516
	.long	L2_5_set_516
	.long	L2_5_set_408
	.long	L2_5_set_516
	.long	L2_5_set_409
.set L2_6_set_359, LBB2_359-LJTI2_6
.set L2_6_set_507, LBB2_507-LJTI2_6
.set L2_6_set_354, LBB2_354-LJTI2_6
.set L2_6_set_365, LBB2_365-LJTI2_6
.set L2_6_set_364, LBB2_364-LJTI2_6
LJTI2_6:
	.long	L2_6_set_359
	.long	L2_6_set_507
	.long	L2_6_set_507
	.long	L2_6_set_507
	.long	L2_6_set_507
	.long	L2_6_set_507
	.long	L2_6_set_507
	.long	L2_6_set_507
	.long	L2_6_set_507
	.long	L2_6_set_507
	.long	L2_6_set_507
	.long	L2_6_set_507
	.long	L2_6_set_507
	.long	L2_6_set_507
	.long	L2_6_set_507
	.long	L2_6_set_507
	.long	L2_6_set_507
	.long	L2_6_set_507
	.long	L2_6_set_354
	.long	L2_6_set_507
	.long	L2_6_set_507
	.long	L2_6_set_507
	.long	L2_6_set_365
	.long	L2_6_set_507
	.long	L2_6_set_364
.set L2_7_set_164, LBB2_164-LJTI2_7
.set L2_7_set_226, LBB2_226-LJTI2_7
.set L2_7_set_716, LBB2_716-LJTI2_7
.set L2_7_set_238, LBB2_238-LJTI2_7
.set L2_7_set_231, LBB2_231-LJTI2_7
LJTI2_7:
	.long	L2_7_set_164
	.long	L2_7_set_226
	.long	L2_7_set_716
	.long	L2_7_set_238
	.long	L2_7_set_716
	.long	L2_7_set_716
	.long	L2_7_set_716
	.long	L2_7_set_231
.set L2_8_set_314, LBB2_314-LJTI2_8
.set L2_8_set_496, LBB2_496-LJTI2_8
.set L2_8_set_309, LBB2_309-LJTI2_8
.set L2_8_set_320, LBB2_320-LJTI2_8
.set L2_8_set_319, LBB2_319-LJTI2_8
LJTI2_8:
	.long	L2_8_set_314
	.long	L2_8_set_496
	.long	L2_8_set_496
	.long	L2_8_set_496
	.long	L2_8_set_496
	.long	L2_8_set_496
	.long	L2_8_set_496
	.long	L2_8_set_496
	.long	L2_8_set_496
	.long	L2_8_set_496
	.long	L2_8_set_496
	.long	L2_8_set_496
	.long	L2_8_set_496
	.long	L2_8_set_496
	.long	L2_8_set_496
	.long	L2_8_set_496
	.long	L2_8_set_496
	.long	L2_8_set_496
	.long	L2_8_set_309
	.long	L2_8_set_496
	.long	L2_8_set_496
	.long	L2_8_set_496
	.long	L2_8_set_320
	.long	L2_8_set_496
	.long	L2_8_set_319
.set L2_9_set_171, LBB2_171-LJTI2_9
.set L2_9_set_460, LBB2_460-LJTI2_9
.set L2_9_set_166, LBB2_166-LJTI2_9
.set L2_9_set_177, LBB2_177-LJTI2_9
.set L2_9_set_176, LBB2_176-LJTI2_9
LJTI2_9:
	.long	L2_9_set_171
	.long	L2_9_set_460
	.long	L2_9_set_460
	.long	L2_9_set_460
	.long	L2_9_set_460
	.long	L2_9_set_460
	.long	L2_9_set_460
	.long	L2_9_set_460
	.long	L2_9_set_460
	.long	L2_9_set_460
	.long	L2_9_set_460
	.long	L2_9_set_460
	.long	L2_9_set_460
	.long	L2_9_set_460
	.long	L2_9_set_460
	.long	L2_9_set_460
	.long	L2_9_set_460
	.long	L2_9_set_460
	.long	L2_9_set_166
	.long	L2_9_set_460
	.long	L2_9_set_460
	.long	L2_9_set_460
	.long	L2_9_set_177
	.long	L2_9_set_460
	.long	L2_9_set_176
	.end_data_region
                                        ## -- End function
	.globl	_isValidBegin                   ## -- Begin function isValidBegin
	.p2align	4, 0x90
_isValidBegin:                          ## @isValidBegin
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movl	%edi, %eax
	andl	$-33, %eax
	addl	$-65, %eax
	cmpl	$26, %eax
	setb	%al
	cmpl	$95, %edi
	sete	%cl
	orb	%al, %cl
	movzbl	%cl, %eax
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_isValid                        ## -- Begin function isValid
	.p2align	4, 0x90
_isValid:                               ## @isValid
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
                                        ## kill: def $edi killed $edi def $rdi
	leal	-48(%rdi), %ecx
	movl	$1, %eax
	cmpl	$10, %ecx
	jb	LBB4_7
## %bb.1:
	movl	%edi, %ecx
	andl	$-33, %ecx
	addl	$-65, %ecx
	cmpl	$26, %ecx
	jb	LBB4_7
## %bb.2:
	leal	-36(%rdi), %ecx
	cmpl	$59, %ecx
	ja	LBB4_3
## %bb.6:
	movabsq	$576460752303424529, %rdx       ## imm = 0x800000000000411
	btq	%rcx, %rdx
	jb	LBB4_7
LBB4_3:
	cmpl	$123, %edi
	je	LBB4_7
## %bb.4:
	cmpl	$125, %edi
	jne	LBB4_5
LBB4_7:
	popq	%rbp
	retq
LBB4_5:
	xorl	%eax, %eax
	cmpl	$41, %edi
	sete	%al
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_lower                          ## -- Begin function lower
	.p2align	4, 0x90
_lower:                                 ## @lower
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	pushq	%rax
	.cfi_offset %rbx, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rdi, %r14
	callq	_strlen
	movq	%rax, %r15
	leaq	1(%rax), %rdi
	callq	_malloc
	movq	%rax, %rbx
	testq	%r15, %r15
	je	LBB5_1
## %bb.3:
	xorl	%r15d, %r15d
	.p2align	4, 0x90
LBB5_4:                                 ## =>This Inner Loop Header: Depth=1
	movsbl	(%r14,%r15), %edi
	callq	___tolower
	movb	%al, (%rbx,%r15)
	incq	%r15
	movq	%r14, %rdi
	callq	_strlen
	cmpq	%r15, %rax
	ja	LBB5_4
	jmp	LBB5_2
LBB5_1:
	xorl	%eax, %eax
LBB5_2:
	movb	$0, (%rbx,%rax)
	movq	%rbx, %rax
	addq	$8, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_parse64                        ## -- Begin function parse64
	.p2align	4, 0x90
_parse64:                               ## @parse64
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	cmpb	$48, (%rdi)
	jne	LBB6_7
## %bb.1:
	movzbl	1(%rdi), %eax
	cmpl	$98, %eax
	je	LBB6_5
## %bb.2:
	cmpl	$111, %eax
	je	LBB6_6
## %bb.3:
	cmpl	$120, %eax
	jne	LBB6_7
## %bb.4:
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	popq	%rbp
	jmp	_strtoull                       ## TAILCALL
LBB6_7:
	xorl	%esi, %esi
	movl	$10, %edx
	popq	%rbp
	jmp	_strtoull                       ## TAILCALL
LBB6_5:
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	popq	%rbp
	jmp	_strtoull                       ## TAILCALL
LBB6_6:
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	popq	%rbp
	jmp	_strtoull                       ## TAILCALL
	.cfi_endproc
                                        ## -- End function
	.globl	_parse32                        ## -- Begin function parse32
	.p2align	4, 0x90
_parse32:                               ## @parse32
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	cmpb	$48, (%rdi)
	jne	LBB7_7
## %bb.1:
	movzbl	1(%rdi), %eax
	cmpl	$98, %eax
	je	LBB7_5
## %bb.2:
	cmpl	$111, %eax
	je	LBB7_6
## %bb.3:
	cmpl	$120, %eax
	jne	LBB7_7
## %bb.4:
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB7_8
LBB7_7:
	xorl	%esi, %esi
	movl	$10, %edx
LBB7_8:
	callq	_strtoul
                                        ## kill: def $eax killed $eax killed $rax
	popq	%rbp
	retq
LBB7_5:
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	jmp	LBB7_8
LBB7_6:
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB7_8
	.cfi_endproc
                                        ## -- End function
	.globl	_parse16                        ## -- Begin function parse16
	.p2align	4, 0x90
_parse16:                               ## @parse16
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	cmpb	$48, (%rdi)
	jne	LBB8_7
## %bb.1:
	movzbl	1(%rdi), %eax
	cmpl	$98, %eax
	je	LBB8_5
## %bb.2:
	cmpl	$111, %eax
	je	LBB8_6
## %bb.3:
	cmpl	$120, %eax
	jne	LBB8_7
## %bb.4:
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB8_8
LBB8_7:
	xorl	%esi, %esi
	movl	$10, %edx
LBB8_8:
	callq	_strtoul
LBB8_9:
	movzwl	%ax, %eax
	popq	%rbp
	retq
LBB8_5:
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	_strtol
	jmp	LBB8_9
LBB8_6:
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB8_8
	.cfi_endproc
                                        ## -- End function
	.globl	_parse8                         ## -- Begin function parse8
	.p2align	4, 0x90
_parse8:                                ## @parse8
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	cmpb	$48, (%rdi)
	jne	LBB9_7
## %bb.1:
	movzbl	1(%rdi), %eax
	cmpl	$98, %eax
	je	LBB9_5
## %bb.2:
	cmpl	$111, %eax
	je	LBB9_6
## %bb.3:
	cmpl	$120, %eax
	jne	LBB9_7
## %bb.4:
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$16, %edx
	jmp	LBB9_8
LBB9_7:
	xorl	%esi, %esi
	movl	$10, %edx
LBB9_8:
	callq	_strtoul
LBB9_9:
	movzbl	%al, %eax
	popq	%rbp
	retq
LBB9_5:
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	_strtol
	jmp	LBB9_9
LBB9_6:
	addq	$2, %rdi
	xorl	%esi, %esi
	movl	$8, %edx
	jmp	LBB9_8
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function add_instruction
_add_instruction:                       ## @add_instruction
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	pushq	%rax
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rdi, %rbx
	leaq	16(%rbp), %r14
	movq	32(%rdi), %rcx
	leaq	1(%rcx), %rax
	movq	%rax, 32(%rdi)
	cmpq	40(%rdi), %rcx
	jne	LBB10_1
## %bb.2:
	leaq	(%rcx,%rcx), %rax
	testq	%rcx, %rcx
	movl	$16, %ecx
	cmovneq	%rax, %rcx
	movq	%rcx, 40(%rbx)
	movq	24(%rbx), %rdi
	imulq	$272, %rcx, %rsi                ## imm = 0x110
	callq	_realloc
	movq	%rax, 24(%rbx)
	movq	32(%rbx), %rcx
	decq	%rcx
	jmp	LBB10_3
LBB10_1:
	movq	24(%rbx), %rax
LBB10_3:
	imulq	$272, %rcx, %rcx                ## imm = 0x110
	movl	$1, (%rax,%rcx)
	leaq	(%rax,%rcx), %rdi
	addq	$8, %rdi
	movl	$264, %edx                      ## imm = 0x108
	movq	%r14, %rsi
	callq	_memcpy
	addq	$2, 48(%rbx)
	movzwl	(%r14), %r15d
	movl	%r15d, %eax
	andl	$15, %eax
	movl	%eax, -44(%rbp)                 ## 4-byte Spill
	shrl	$4, %r15d
	leaq	LJTI10_0(%rip), %r13
	xorl	%r12d, %r12d
	jmp	LBB10_4
LBB10_10:                               ##   in Loop: Header=BB10_4 Depth=1
	leaq	(%rcx,%rcx), %rsi
	testq	%rcx, %rcx
	movl	$16, %eax
	cmoveq	%rax, %rsi
	movq	%rsi, 64(%rbx)
	movq	72(%rbx), %rdi
	shlq	$3, %rsi
	callq	_realloc
	movq	%rax, 72(%rbx)
	movq	56(%rbx), %rcx
	decq	%rcx
LBB10_11:                               ##   in Loop: Header=BB10_4 Depth=1
	movq	48(%rbx), %rdx
	movq	%rdx, (%rax,%rcx,8)
LBB10_12:                               ##   in Loop: Header=BB10_4 Depth=1
	addq	$8, 48(%rbx)
LBB10_14:                               ##   in Loop: Header=BB10_4 Depth=1
	addq	$16, %r12
	cmpq	$64, %r12
	je	LBB10_15
LBB10_4:                                ## =>This Inner Loop Header: Depth=1
	movl	8(%r14,%r12), %esi
	cmpq	$4, %rsi
	ja	LBB10_13
## %bb.5:                               ##   in Loop: Header=BB10_4 Depth=1
	movslq	(%r13,%rsi,4), %rax
	addq	%r13, %rax
	jmpq	*%rax
LBB10_6:                                ##   in Loop: Header=BB10_4 Depth=1
	incq	48(%rbx)
	jmp	LBB10_14
LBB10_13:                               ##   in Loop: Header=BB10_4 Depth=1
	leaq	L_.str.93(%rip), %rdi
                                        ## kill: def $esi killed $esi killed $rsi
	movl	-44(%rbp), %edx                 ## 4-byte Reload
	movl	%r15d, %ecx
	xorl	%eax, %eax
	callq	_printf
	jmp	LBB10_14
LBB10_7:                                ##   in Loop: Header=BB10_4 Depth=1
	addq	$2, 48(%rbx)
	jmp	LBB10_14
LBB10_8:                                ##   in Loop: Header=BB10_4 Depth=1
	movq	56(%rbx), %rcx
	leaq	1(%rcx), %rax
	movq	%rax, 56(%rbx)
	cmpq	64(%rbx), %rcx
	je	LBB10_10
## %bb.9:                               ##   in Loop: Header=BB10_4 Depth=1
	movq	72(%rbx), %rax
	jmp	LBB10_11
LBB10_15:
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc
	.p2align	2, 0x90
	.data_region jt32
.set L10_0_set_14, LBB10_14-LJTI10_0
.set L10_0_set_6, LBB10_6-LJTI10_0
.set L10_0_set_7, LBB10_7-LJTI10_0
.set L10_0_set_12, LBB10_12-LJTI10_0
.set L10_0_set_8, LBB10_8-LJTI10_0
LJTI10_0:
	.long	L10_0_set_14
	.long	L10_0_set_6
	.long	L10_0_set_7
	.long	L10_0_set_12
	.long	L10_0_set_8
	.end_data_region
                                        ## -- End function
	.globl	_unquote                        ## -- Begin function unquote
	.p2align	4, 0x90
_unquote:                               ## @unquote
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r14
	pushq	%rbx
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	movq	%rdi, %r14
	callq	_strlen
	leaq	1(%rax), %rdi
	callq	_malloc
	movq	%rax, %rbx
	leaq	LJTI11_0(%rip), %rax
	movq	%rbx, %rcx
	jmp	LBB11_1
	.p2align	4, 0x90
LBB11_2:                                ##   in Loop: Header=BB11_1 Depth=1
	testl	%edx, %edx
	je	LBB11_3
LBB11_18:                               ##   in Loop: Header=BB11_1 Depth=1
	movb	%dl, (%rcx)
	incq	%rcx
	incq	%r14
LBB11_1:                                ## =>This Inner Loop Header: Depth=1
	movzbl	(%r14), %edx
	cmpl	$92, %edx
	jne	LBB11_2
## %bb.4:                               ##   in Loop: Header=BB11_1 Depth=1
	movsbl	1(%r14), %esi
	incq	%r14
	cmpl	$91, %esi
	jle	LBB11_5
## %bb.9:                               ##   in Loop: Header=BB11_1 Depth=1
	leal	-92(%rsi), %edi
	cmpl	$24, %edi
	ja	LBB11_15
## %bb.10:                              ##   in Loop: Header=BB11_1 Depth=1
	movb	$10, %dl
	movslq	(%rax,%rdi,4), %rdi
	addq	%rax, %rdi
	jmpq	*%rdi
LBB11_12:                               ##   in Loop: Header=BB11_1 Depth=1
	movb	$92, %dl
	jmp	LBB11_18
	.p2align	4, 0x90
LBB11_5:                                ##   in Loop: Header=BB11_1 Depth=1
	cmpl	$34, %esi
	je	LBB11_14
## %bb.6:                               ##   in Loop: Header=BB11_1 Depth=1
	cmpl	$39, %esi
	je	LBB11_13
## %bb.7:                               ##   in Loop: Header=BB11_1 Depth=1
	cmpl	$48, %esi
	jne	LBB11_15
## %bb.8:                               ##   in Loop: Header=BB11_1 Depth=1
	xorl	%edx, %edx
	jmp	LBB11_18
LBB11_17:                               ##   in Loop: Header=BB11_1 Depth=1
	movb	$13, %dl
	jmp	LBB11_18
LBB11_11:                               ##   in Loop: Header=BB11_1 Depth=1
	movb	$9, %dl
	jmp	LBB11_18
LBB11_14:                               ##   in Loop: Header=BB11_1 Depth=1
	movb	$34, %dl
	jmp	LBB11_18
LBB11_13:                               ##   in Loop: Header=BB11_1 Depth=1
	movb	$39, %dl
	jmp	LBB11_18
LBB11_3:
	movb	$0, (%rcx)
LBB11_16:
	movq	%rbx, %rax
	popq	%rbx
	popq	%r14
	popq	%rbp
	retq
LBB11_15:
	leaq	L_.str.74(%rip), %rdi
	xorl	%ebx, %ebx
                                        ## kill: def $esi killed $esi killed $rsi
	xorl	%eax, %eax
	callq	_printf
	jmp	LBB11_16
	.cfi_endproc
	.p2align	2, 0x90
	.data_region jt32
.set L11_0_set_12, LBB11_12-LJTI11_0
.set L11_0_set_15, LBB11_15-LJTI11_0
.set L11_0_set_18, LBB11_18-LJTI11_0
.set L11_0_set_17, LBB11_17-LJTI11_0
.set L11_0_set_11, LBB11_11-LJTI11_0
LJTI11_0:
	.long	L11_0_set_12
	.long	L11_0_set_15
	.long	L11_0_set_15
	.long	L11_0_set_15
	.long	L11_0_set_15
	.long	L11_0_set_15
	.long	L11_0_set_15
	.long	L11_0_set_15
	.long	L11_0_set_15
	.long	L11_0_set_15
	.long	L11_0_set_15
	.long	L11_0_set_15
	.long	L11_0_set_15
	.long	L11_0_set_15
	.long	L11_0_set_15
	.long	L11_0_set_15
	.long	L11_0_set_15
	.long	L11_0_set_15
	.long	L11_0_set_18
	.long	L11_0_set_15
	.long	L11_0_set_15
	.long	L11_0_set_15
	.long	L11_0_set_17
	.long	L11_0_set_15
	.long	L11_0_set_11
	.end_data_region
                                        ## -- End function
	.globl	_nextToken                      ## -- Begin function nextToken
	.p2align	4, 0x90
_nextToken:                             ## @nextToken
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	pushq	%rax
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rdi, %rbx
	movq	_src(%rip), %r14
	movq	__DefaultRuneLocale@GOTPCREL(%rip), %r13
	movl	$1024, %r15d                    ## imm = 0x400
LBB12_1:                                ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB12_2 Depth 2
                                        ##     Child Loop BB12_9 Depth 2
	movl	_line(%rip), %edx
	leaq	1(%r14), %rax
	jmp	LBB12_2
	.p2align	4, 0x90
LBB12_11:                               ##   in Loop: Header=BB12_2 Depth=2
	incl	%edx
	movl	%edx, _line(%rip)
LBB12_12:                               ##   in Loop: Header=BB12_2 Depth=2
	incq	%r14
	movq	%r14, _src(%rip)
	incq	%rax
LBB12_2:                                ##   Parent Loop BB12_1 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movzbl	(%r14), %ecx
	movzbl	%cl, %esi
	cmpl	$31, %esi
	jg	LBB12_5
## %bb.3:                               ##   in Loop: Header=BB12_2 Depth=2
	cmpl	$10, %esi
	je	LBB12_11
## %bb.4:                               ##   in Loop: Header=BB12_2 Depth=2
	cmpl	$13, %esi
	je	LBB12_12
	jmp	LBB12_14
	.p2align	4, 0x90
LBB12_5:                                ##   in Loop: Header=BB12_2 Depth=2
	cmpl	$32, %esi
	je	LBB12_12
## %bb.6:                               ##   in Loop: Header=BB12_1 Depth=1
	cmpl	$64, %esi
	je	LBB12_8
## %bb.7:                               ##   in Loop: Header=BB12_1 Depth=1
	cmpl	$59, %esi
	jne	LBB12_14
	.p2align	4, 0x90
LBB12_8:                                ##   in Loop: Header=BB12_1 Depth=1
	testb	%cl, %cl
	je	LBB12_13
LBB12_9:                                ##   Parent Loop BB12_1 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movzbl	%cl, %edx
	cmpl	$10, %edx
	je	LBB12_13
## %bb.10:                              ##   in Loop: Header=BB12_9 Depth=2
	movq	%rax, _src(%rip)
	movzbl	(%rax), %ecx
	incq	%rax
	testb	%cl, %cl
	jne	LBB12_9
LBB12_13:                               ##   in Loop: Header=BB12_1 Depth=1
	decq	%rax
	movq	%rax, %r14
LBB12_14:                               ##   in Loop: Header=BB12_1 Depth=1
	cmpb	$95, %cl
	je	LBB12_16
## %bb.15:                              ##   in Loop: Header=BB12_1 Depth=1
	movsbl	%cl, %edi
	movl	%edi, %eax
	andl	$-33, %eax
	addl	$-91, %eax
	cmpl	$-26, %eax
	jae	LBB12_16
## %bb.66:                              ##   in Loop: Header=BB12_1 Depth=1
	testb	%cl, %cl
	js	LBB12_68
## %bb.67:                              ##   in Loop: Header=BB12_1 Depth=1
	movl	%edi, %eax
	movl	60(%r13,%rax,4), %eax
	andl	%r15d, %eax
	jmp	LBB12_69
	.p2align	4, 0x90
LBB12_68:                               ##   in Loop: Header=BB12_1 Depth=1
	movl	$1024, %esi                     ## imm = 0x400
	callq	___maskrune
LBB12_69:                               ##   in Loop: Header=BB12_1 Depth=1
	movq	_src(%rip), %r14
	testl	%eax, %eax
	jne	LBB12_70
## %bb.97:                              ##   in Loop: Header=BB12_1 Depth=1
	movzbl	(%r14), %eax
	cmpl	$45, %eax
	jg	LBB12_109
## %bb.98:                              ##   in Loop: Header=BB12_1 Depth=1
	testl	%eax, %eax
	je	LBB12_125
## %bb.99:                              ##   in Loop: Header=BB12_1 Depth=1
	cmpl	$34, %eax
	je	LBB12_113
## %bb.100:                             ##   in Loop: Header=BB12_1 Depth=1
	cmpl	$39, %eax
	jne	LBB12_1
	jmp	LBB12_101
	.p2align	4, 0x90
LBB12_109:                              ##   in Loop: Header=BB12_1 Depth=1
	cmpl	$46, %eax
	je	LBB12_126
## %bb.110:                             ##   in Loop: Header=BB12_1 Depth=1
	cmpl	$91, %eax
	je	LBB12_135
## %bb.111:                             ##   in Loop: Header=BB12_1 Depth=1
	cmpl	$93, %eax
	jne	LBB12_1
## %bb.112:
	incq	%r14
	movq	%r14, _src(%rip)
	leaq	L_.str.92(%rip), %rax
	movq	%rax, (%rbx)
	movl	$8, 8(%rbx)
	jmp	LBB12_136
LBB12_16:
	movq	%r14, %rdi
	callq	_strdup
	movq	%rax, %r15
	cmpb	$114, (%rax)
	movq	%r14, %r12
	jne	LBB12_29
## %bb.17:
	leaq	1(%r14), %rax
	movq	%rax, _src(%rip)
	movsbl	1(%r14), %edi
	testl	%edi, %edi
	js	LBB12_19
## %bb.18:
	movl	%edi, %ecx
	movl	$1024, %eax                     ## imm = 0x400
	andl	60(%r13,%rcx,4), %eax
	jmp	LBB12_20
LBB12_70:
	movq	%r14, %rdi
	callq	_strdup
	movq	%rax, %r15
	cmpb	$45, (%r14)
	movq	%r14, %r12
	jne	LBB12_72
## %bb.71:
	leaq	1(%r14), %r12
	movq	%r12, _src(%rip)
LBB12_72:
	leaq	L_.str.88(%rip), %rsi
	movl	$2, %edx
	movq	%r12, %rdi
	callq	_strncmp
	testl	%eax, %eax
	je	LBB12_73
## %bb.78:
	leaq	L_.str.89(%rip), %rsi
	movl	$2, %edx
	movq	%r12, %rdi
	callq	_strncmp
	testl	%eax, %eax
	je	LBB12_82
## %bb.79:
	movq	%r15, -48(%rbp)                 ## 8-byte Spill
	movl	$1024, %r15d                    ## imm = 0x400
	.p2align	4, 0x90
LBB12_80:                               ## =>This Inner Loop Header: Depth=1
	movsbl	(%r12), %edi
	testl	%edi, %edi
	js	LBB12_86
## %bb.81:                              ##   in Loop: Header=BB12_80 Depth=1
	movl	%edi, %eax
	movl	60(%r13,%rax,4), %eax
	andl	%r15d, %eax
	jmp	LBB12_87
	.p2align	4, 0x90
LBB12_86:                               ##   in Loop: Header=BB12_80 Depth=1
	movl	$1024, %esi                     ## imm = 0x400
	callq	___maskrune
LBB12_87:                               ##   in Loop: Header=BB12_80 Depth=1
	movq	_src(%rip), %r12
	testl	%eax, %eax
	je	LBB12_89
## %bb.88:                              ##   in Loop: Header=BB12_80 Depth=1
	incq	%r12
	movq	%r12, _src(%rip)
	jmp	LBB12_80
LBB12_113:
	leaq	1(%r14), %r15
	movq	%r15, %rdi
	callq	_strdup
	cmpb	$34, 1(%r14)
	movq	%r15, %rcx
	je	LBB12_116
## %bb.114:
	movq	%r15, %rdx
	.p2align	4, 0x90
LBB12_115:                              ## =>This Inner Loop Header: Depth=1
	leaq	1(%rdx), %rcx
	cmpb	$34, 1(%rdx)
	movq	%rcx, %rdx
	jne	LBB12_115
LBB12_116:
	movq	%rcx, %rdx
	subq	%r15, %rdx
	movb	$0, (%rax,%rdx)
	incq	%rcx
	movq	%rcx, _src(%rip)
	movq	%rax, (%rbx)
	movl	$5, 8(%rbx)
	jmp	LBB12_136
LBB12_101:
	leaq	1(%r14), %r15
	movq	%r15, %rdi
	callq	_strdup
	cmpb	$39, 1(%r14)
	movq	%r15, %rcx
	je	LBB12_104
## %bb.102:
	movq	%r15, %rdx
	.p2align	4, 0x90
LBB12_103:                              ## =>This Inner Loop Header: Depth=1
	leaq	1(%rdx), %rcx
	cmpb	$39, 1(%rdx)
	movq	%rcx, %rdx
	jne	LBB12_103
LBB12_104:
	movq	%rcx, %rdx
	subq	%r15, %rdx
	movb	$0, (%rax,%rdx)
	incq	%rcx
	movq	%rcx, _src(%rip)
	movzbl	(%rax), %r14d
	cmpl	$92, %r14d
	jne	LBB12_122
## %bb.105:
	movsbl	1(%rax), %esi
	cmpl	$91, %esi
	jle	LBB12_106
## %bb.117:
	leal	-92(%rsi), %eax
	cmpl	$24, %eax
	ja	LBB12_124
## %bb.118:
	movl	$10, %r14d
	leaq	LJTI12_0(%rip), %rcx
	movslq	(%rcx,%rax,4), %rax
	addq	%rcx, %rax
	jmpq	*%rax
LBB12_119:
	movl	$13, %r14d
	jmp	LBB12_122
LBB12_126:
	leaq	1(%r14), %rdi
	movq	%rdi, _src(%rip)
	callq	_strdup
	addq	$2, %r14
	movabsq	$576460752303424529, %rcx       ## imm = 0x800000000000411
	movq	%rax, %rdx
	jmp	LBB12_127
	.p2align	4, 0x90
LBB12_133:                              ##   in Loop: Header=BB12_127 Depth=1
	movq	%r14, _src(%rip)
	incq	%rdx
	incq	%r14
LBB12_127:                              ## =>This Inner Loop Header: Depth=1
	movsbl	-1(%r14), %esi
	movl	%esi, %edi
	andl	$-33, %edi
	addl	$-65, %edi
	leal	-48(%rsi), %r8d
	cmpl	$10, %r8d
	jb	LBB12_133
## %bb.128:                             ##   in Loop: Header=BB12_127 Depth=1
	cmpl	$26, %edi
	jb	LBB12_133
## %bb.129:                             ##   in Loop: Header=BB12_127 Depth=1
	leal	-36(%rsi), %edi
	cmpl	$59, %edi
	ja	LBB12_130
## %bb.138:                             ##   in Loop: Header=BB12_127 Depth=1
	btq	%rdi, %rcx
	jb	LBB12_133
	.p2align	4, 0x90
LBB12_130:                              ##   in Loop: Header=BB12_127 Depth=1
	cmpl	$123, %esi
	je	LBB12_133
## %bb.131:                             ##   in Loop: Header=BB12_127 Depth=1
	cmpl	$125, %esi
	je	LBB12_133
## %bb.132:                             ##   in Loop: Header=BB12_127 Depth=1
	cmpb	$41, %sil
	je	LBB12_133
## %bb.134:
	movb	$0, (%rdx)
	movq	%rax, (%rbx)
	movl	$6, 8(%rbx)
	jmp	LBB12_136
LBB12_135:
	incq	%r14
	movq	%r14, _src(%rip)
	leaq	L_.str.91(%rip), %rax
	movq	%rax, (%rbx)
	movl	$7, 8(%rbx)
	jmp	LBB12_136
LBB12_89:
	cmpb	$46, (%r12)
	jne	LBB12_96
## %bb.90:
	movl	$1024, %r15d                    ## imm = 0x400
	jmp	LBB12_91
	.p2align	4, 0x90
LBB12_93:                               ##   in Loop: Header=BB12_91 Depth=1
	movl	$1024, %esi                     ## imm = 0x400
	callq	___maskrune
LBB12_94:                               ##   in Loop: Header=BB12_91 Depth=1
	movq	_src(%rip), %r12
	testl	%eax, %eax
	je	LBB12_95
LBB12_91:                               ## =>This Inner Loop Header: Depth=1
	leaq	1(%r12), %rax
	movq	%rax, _src(%rip)
	movsbl	1(%r12), %edi
	testl	%edi, %edi
	js	LBB12_93
## %bb.92:                              ##   in Loop: Header=BB12_91 Depth=1
	movl	%edi, %eax
	movl	60(%r13,%rax,4), %eax
	andl	%r15d, %eax
	jmp	LBB12_94
LBB12_73:
	movzbl	2(%r12), %eax
	addq	$2, %r12
	testb	%al, %al
	js	LBB12_77
	.p2align	4, 0x90
LBB12_75:                               ## =>This Inner Loop Header: Depth=1
	movzbl	%al, %eax
	testb	$1, 62(%r13,%rax,4)
	je	LBB12_77
## %bb.76:                              ##   in Loop: Header=BB12_75 Depth=1
	movzbl	1(%r12), %eax
	incq	%r12
	testb	%al, %al
	jns	LBB12_75
LBB12_77:
	movq	%r12, _src(%rip)
	subq	%r14, %r12
	movb	$0, (%r15,%r12)
	jmp	LBB12_85
LBB12_82:
	leaq	(%r15,%r12), %rax
	incq	%rax
	incq	%r12
	subq	%r14, %rax
	.p2align	4, 0x90
LBB12_83:                               ## =>This Inner Loop Header: Depth=1
	movzbl	1(%r12), %ecx
	incq	%r12
	andb	$-2, %cl
	incq	%rax
	cmpb	$48, %cl
	je	LBB12_83
## %bb.84:
	movq	%r12, _src(%rip)
	movb	$0, (%rax)
	jmp	LBB12_85
LBB12_96:
	subq	%r14, %r12
	movq	-48(%rbp), %rax                 ## 8-byte Reload
	movb	$0, (%rax,%r12)
	movq	%rax, (%rbx)
	movl	$3, 8(%rbx)
	jmp	LBB12_136
LBB12_95:
	subq	%r14, %r12
	movq	-48(%rbp), %rax                 ## 8-byte Reload
	movb	$0, (%rax,%r12)
	movq	%rax, (%rbx)
	movl	$4, 8(%rbx)
	jmp	LBB12_136
LBB12_19:
	movl	$1024, %esi                     ## imm = 0x400
	callq	___maskrune
LBB12_20:
	movq	_src(%rip), %r12
	testl	%eax, %eax
	je	LBB12_28
## %bb.21:
	movq	%r15, -48(%rbp)                 ## 8-byte Spill
	movl	$1024, %r15d                    ## imm = 0x400
	.p2align	4, 0x90
LBB12_22:                               ## =>This Inner Loop Header: Depth=1
	movsbl	(%r12), %edi
	testl	%edi, %edi
	js	LBB12_24
## %bb.23:                              ##   in Loop: Header=BB12_22 Depth=1
	movl	%edi, %eax
	movl	60(%r13,%rax,4), %eax
	andl	%r15d, %eax
	jmp	LBB12_25
	.p2align	4, 0x90
LBB12_24:                               ##   in Loop: Header=BB12_22 Depth=1
	movl	$1024, %esi                     ## imm = 0x400
	callq	___maskrune
LBB12_25:                               ##   in Loop: Header=BB12_22 Depth=1
	movq	_src(%rip), %r12
	testl	%eax, %eax
	je	LBB12_27
## %bb.26:                              ##   in Loop: Header=BB12_22 Depth=1
	incq	%r12
	movq	%r12, _src(%rip)
	jmp	LBB12_22
LBB12_27:
	subq	%r14, %r12
	movq	-48(%rbp), %rax                 ## 8-byte Reload
	movb	$0, (%rax,%r12)
	jmp	LBB12_56
LBB12_28:
	decq	%r12
	movq	%r12, _src(%rip)
LBB12_29:
	leaq	L_.str.75(%rip), %rsi
	movl	$3, %edx
	movq	%r12, %rdi
	callq	_strncmp
	testl	%eax, %eax
	jne	LBB12_43
## %bb.30:
	leaq	3(%r12), %rax
	movq	%rax, _src(%rip)
	movsbl	3(%r12), %edi
	testl	%edi, %edi
	js	LBB12_32
## %bb.31:
	movl	%edi, %ecx
	movl	$1024, %eax                     ## imm = 0x400
	andl	60(%r13,%rcx,4), %eax
	jmp	LBB12_33
LBB12_106:
	cmpl	$34, %esi
	je	LBB12_108
## %bb.107:
	cmpl	$39, %esi
	je	LBB12_108
## %bb.123:
	cmpl	$48, %esi
	jne	LBB12_124
## %bb.121:
	xorl	%r14d, %r14d
	jmp	LBB12_122
LBB12_108:
	movl	%esi, %r14d
	jmp	LBB12_122
LBB12_32:
	movl	$1024, %esi                     ## imm = 0x400
	callq	___maskrune
LBB12_33:
	movq	_src(%rip), %r12
	testl	%eax, %eax
	je	LBB12_41
## %bb.34:
	movq	%r15, -48(%rbp)                 ## 8-byte Spill
	movl	$1024, %r15d                    ## imm = 0x400
	.p2align	4, 0x90
LBB12_35:                               ## =>This Inner Loop Header: Depth=1
	movsbl	(%r12), %edi
	testl	%edi, %edi
	js	LBB12_37
## %bb.36:                              ##   in Loop: Header=BB12_35 Depth=1
	movl	%edi, %eax
	movl	60(%r13,%rax,4), %eax
	andl	%r15d, %eax
	jmp	LBB12_38
	.p2align	4, 0x90
LBB12_37:                               ##   in Loop: Header=BB12_35 Depth=1
	movl	$1024, %esi                     ## imm = 0x400
	callq	___maskrune
LBB12_38:                               ##   in Loop: Header=BB12_35 Depth=1
	movq	_src(%rip), %r12
	testl	%eax, %eax
	je	LBB12_40
## %bb.39:                              ##   in Loop: Header=BB12_35 Depth=1
	incq	%r12
	movq	%r12, _src(%rip)
	jmp	LBB12_35
LBB12_40:
	subq	%r14, %r12
	movq	-48(%rbp), %rax                 ## 8-byte Reload
	movb	$0, (%rax,%r12)
	movq	%rax, (%rbx)
	movl	$9, 8(%rbx)
	jmp	LBB12_136
LBB12_41:
	addq	$-3, %r12
	jmp	LBB12_42
LBB12_120:
	movl	$9, %r14d
LBB12_122:
	movl	$4, %edi
	callq	_malloc
	movq	%rax, %r15
	leaq	L_.str.90(%rip), %rdx
	movl	$4, %esi
	movq	%rax, %rdi
	movl	%r14d, %ecx
	xorl	%eax, %eax
	callq	_snprintf
LBB12_85:
	movq	%r15, (%rbx)
	movl	$3, 8(%rbx)
	jmp	LBB12_136
LBB12_124:
	leaq	L_.str.74(%rip), %rdi
                                        ## kill: def $esi killed $esi killed $rsi
	xorl	%eax, %eax
	callq	_printf
LBB12_125:
	movq	$0, (%rbx)
	movl	$-1, 8(%rbx)
	jmp	LBB12_136
LBB12_42:
	movq	%r12, _src(%rip)
LBB12_43:
	movsbl	(%r12), %eax
	movl	%eax, %ecx
	andl	$-33, %ecx
	addl	$-65, %ecx
	leal	-48(%rax), %edx
	cmpl	$10, %edx
	jb	LBB12_49
## %bb.44:
	cmpl	$26, %ecx
	jb	LBB12_49
## %bb.45:
	leal	-36(%rax), %ecx
	cmpl	$59, %ecx
	ja	LBB12_46
## %bb.137:
	movabsq	$576460752303424529, %rdx       ## imm = 0x800000000000411
	btq	%rcx, %rdx
	jae	LBB12_46
LBB12_49:
	incq	%r12
	jmp	LBB12_42
LBB12_46:
	cmpl	$123, %eax
	je	LBB12_49
## %bb.47:
	cmpl	$125, %eax
	je	LBB12_49
## %bb.48:
	cmpb	$41, %al
	je	LBB12_49
## %bb.50:
	movq	%r12, %rax
	subq	%r14, %rax
	movb	$0, (%r15,%rax)
	cmpb	$58, (%r12)
	jne	LBB12_52
## %bb.51:
	incq	%r12
	movq	%r12, _src(%rip)
	movq	%r15, (%rbx)
	movl	$2, 8(%rbx)
	jmp	LBB12_136
LBB12_52:
	leaq	L_.str.76(%rip), %rsi
	movq	%r15, %rdi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB12_55
## %bb.53:
	leaq	L_.str.77(%rip), %rsi
	movq	%r15, %rdi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB12_54
## %bb.57:
	leaq	L_.str.80(%rip), %rsi
	movq	%r15, %rdi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB12_58
## %bb.59:
	leaq	L_.str.82(%rip), %rsi
	movq	%r15, %rdi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB12_60
## %bb.61:
	leaq	L_.str.84(%rip), %rsi
	movq	%r15, %rdi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB12_62
## %bb.63:
	leaq	L_.str.86(%rip), %rsi
	movq	%r15, %rdi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB12_64
## %bb.65:
	movq	%r15, (%rbx)
	movl	$0, 8(%rbx)
	jmp	LBB12_136
LBB12_55:
	leaq	L_.str.78(%rip), %rax
	jmp	LBB12_56
LBB12_54:
	leaq	L_.str.79(%rip), %rax
	jmp	LBB12_56
LBB12_58:
	leaq	L_.str.81(%rip), %rax
	jmp	LBB12_56
LBB12_60:
	leaq	L_.str.83(%rip), %rax
	jmp	LBB12_56
LBB12_62:
	leaq	L_.str.85(%rip), %rax
	jmp	LBB12_56
LBB12_64:
	leaq	L_.str.87(%rip), %rax
LBB12_56:
	movq	%rax, (%rbx)
	movl	$1, 8(%rbx)
LBB12_136:
	movq	_file(%rip), %rax
	movq	%rax, 16(%rbx)
	movl	_line(%rip), %eax
	movl	%eax, 24(%rbx)
	movq	%rbx, %rax
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc
	.p2align	2, 0x90
	.data_region jt32
.set L12_0_set_108, LBB12_108-LJTI12_0
.set L12_0_set_124, LBB12_124-LJTI12_0
.set L12_0_set_122, LBB12_122-LJTI12_0
.set L12_0_set_119, LBB12_119-LJTI12_0
.set L12_0_set_120, LBB12_120-LJTI12_0
LJTI12_0:
	.long	L12_0_set_108
	.long	L12_0_set_124
	.long	L12_0_set_124
	.long	L12_0_set_124
	.long	L12_0_set_124
	.long	L12_0_set_124
	.long	L12_0_set_124
	.long	L12_0_set_124
	.long	L12_0_set_124
	.long	L12_0_set_124
	.long	L12_0_set_124
	.long	L12_0_set_124
	.long	L12_0_set_124
	.long	L12_0_set_124
	.long	L12_0_set_124
	.long	L12_0_set_124
	.long	L12_0_set_124
	.long	L12_0_set_124
	.long	L12_0_set_122
	.long	L12_0_set_124
	.long	L12_0_set_124
	.long	L12_0_set_124
	.long	L12_0_set_119
	.long	L12_0_set_124
	.long	L12_0_set_120
	.end_data_region
                                        ## -- End function
.zerofill __DATA,__bss,_file,8,3        ## @file
	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"r"

L_.str.1:                               ## @.str.1
	.asciz	"Could not open file: %s\n"

L_.str.2:                               ## @.str.2
	.asciz	"%s:%d: Unterminated string\n"

L_.str.3:                               ## @.str.3
	.asciz	"nop"

L_.str.4:                               ## @.str.4
	.asciz	"halt"

L_.str.5:                               ## @.str.5
	.asciz	"hlt"

L_.str.6:                               ## @.str.6
	.asciz	"ldr"

L_.str.7:                               ## @.str.7
	.asciz	"%s:%d: Expected register, got %s\n"

L_.str.8:                               ## @.str.8
	.asciz	"%s:%d: Number too large\n"

L_.str.9:                               ## @.str.9
	.asciz	"%s:%d: Expected register, number, or identifier, got %s\n"

L_.str.10:                              ## @.str.10
	.asciz	"%s:%d: Expected ], got %s\n"

L_.str.11:                              ## @.str.11
	.asciz	"str"

L_.str.12:                              ## @.str.12
	.asciz	"%s:%d: Expected register or number, got %s\n"

L_.str.13:                              ## @.str.13
	.asciz	"cmp"

L_.str.14:                              ## @.str.14
	.asciz	"cmpz"

L_.str.15:                              ## @.str.15
	.asciz	"b"

L_.str.16:                              ## @.str.16
	.asciz	"%s:%d: Expected register or identifier, got %s\n"

L_.str.17:                              ## @.str.17
	.asciz	"bne"

L_.str.18:                              ## @.str.18
	.asciz	"beq"

L_.str.19:                              ## @.str.19
	.asciz	"bgt"

L_.str.20:                              ## @.str.20
	.asciz	"blt"

L_.str.21:                              ## @.str.21
	.asciz	"bge"

L_.str.22:                              ## @.str.22
	.asciz	"ble"

L_.str.23:                              ## @.str.23
	.asciz	"bnz"

L_.str.24:                              ## @.str.24
	.asciz	"bz"

L_.str.25:                              ## @.str.25
	.asciz	"bl"

L_.str.26:                              ## @.str.26
	.asciz	"blne"

L_.str.27:                              ## @.str.27
	.asciz	"bleq"

L_.str.28:                              ## @.str.28
	.asciz	"blgt"

L_.str.29:                              ## @.str.29
	.asciz	"bllt"

L_.str.30:                              ## @.str.30
	.asciz	"blge"

L_.str.31:                              ## @.str.31
	.asciz	"blle"

L_.str.32:                              ## @.str.32
	.asciz	"blnz"

L_.str.33:                              ## @.str.33
	.asciz	"blz"

L_.str.34:                              ## @.str.34
	.asciz	"pshi"

L_.str.35:                              ## @.str.35
	.asciz	"ret"

L_.str.36:                              ## @.str.36
	.asciz	"pshx"

L_.str.37:                              ## @.str.37
	.asciz	"ppx"

L_.str.38:                              ## @.str.38
	.asciz	"pshy"

L_.str.39:                              ## @.str.39
	.asciz	"ppy"

L_.str.40:                              ## @.str.40
	.asciz	"svc"

L_.str.41:                              ## @.str.41
	.asciz	"psh"

L_.str.42:                              ## @.str.42
	.asciz	"pp"

L_.str.43:                              ## @.str.43
	.asciz	"add"

L_.str.44:                              ## @.str.44
	.asciz	"sub"

L_.str.45:                              ## @.str.45
	.asciz	"mul"

L_.str.46:                              ## @.str.46
	.asciz	"div"

L_.str.47:                              ## @.str.47
	.asciz	"mod"

L_.str.48:                              ## @.str.48
	.asciz	"and"

L_.str.49:                              ## @.str.49
	.asciz	"or"

L_.str.50:                              ## @.str.50
	.asciz	"xor"

L_.str.51:                              ## @.str.51
	.asciz	"shl"

L_.str.52:                              ## @.str.52
	.asciz	"shr"

L_.str.53:                              ## @.str.53
	.asciz	"not"

L_.str.54:                              ## @.str.54
	.asciz	"inc"

L_.str.55:                              ## @.str.55
	.asciz	"dec"

L_.str.56:                              ## @.str.56
	.asciz	"irq"

L_.str.57:                              ## @.str.57
	.asciz	"mov"

L_.str.58:                              ## @.str.58
	.asciz	"%s:%d: Expected identifier, got %s\n"

L_.str.59:                              ## @.str.59
	.asciz	"byte"

L_.str.60:                              ## @.str.60
	.asciz	"word"

L_.str.61:                              ## @.str.61
	.asciz	"dword"

L_.str.62:                              ## @.str.62
	.asciz	"qword"

L_.str.63:                              ## @.str.63
	.asciz	"%s:%d: Expected byte, word, dword, or qword, got %s\n"

L_.str.64:                              ## @.str.64
	.asciz	"%s:%d: Expected [, got %s\n"

L_.str.65:                              ## @.str.65
	.asciz	"%s:%d: Unknown instruction: %s\n"

L_.str.66:                              ## @.str.66
	.asciz	"asciz"

L_.str.67:                              ## @.str.67
	.asciz	"ascii"

L_.str.68:                              ## @.str.68
	.asciz	"%s:%d: Expected string, got %s\n"

L_.str.69:                              ## @.str.69
	.asciz	"%s:%d: Expected number, got %s\n"

L_.str.70:                              ## @.str.70
	.asciz	"float"

L_.str.71:                              ## @.str.71
	.asciz	"double"

L_.str.72:                              ## @.str.72
	.asciz	"offset"

L_.str.73:                              ## @.str.73
	.asciz	"%s:%d: Unknown directive: %s\n"

L_.str.74:                              ## @.str.74
	.asciz	"Unknown escape sequence: \\%c\n"

.zerofill __DATA,__bss,_src,8,3         ## @src
	.section	__DATA,__data
	.p2align	2, 0x0                          ## @line
_line:
	.long	1                               ## 0x1

	.section	__TEXT,__cstring,cstring_literals
L_.str.75:                              ## @.str.75
	.asciz	"xmm"

L_.str.76:                              ## @.str.76
	.asciz	"x"

L_.str.77:                              ## @.str.77
	.asciz	"y"

L_.str.78:                              ## @.str.78
	.asciz	"r0"

L_.str.79:                              ## @.str.79
	.asciz	"r1"

L_.str.80:                              ## @.str.80
	.asciz	"pc"

L_.str.81:                              ## @.str.81
	.asciz	"r27"

L_.str.82:                              ## @.str.82
	.asciz	"lr"

L_.str.83:                              ## @.str.83
	.asciz	"r28"

L_.str.84:                              ## @.str.84
	.asciz	"sp"

L_.str.85:                              ## @.str.85
	.asciz	"r29"

L_.str.86:                              ## @.str.86
	.asciz	"bp"

L_.str.87:                              ## @.str.87
	.asciz	"r30"

L_.str.88:                              ## @.str.88
	.asciz	"0x"

L_.str.89:                              ## @.str.89
	.asciz	"0b"

L_.str.90:                              ## @.str.90
	.asciz	"%d"

L_.str.91:                              ## @.str.91
	.asciz	"["

L_.str.92:                              ## @.str.92
	.asciz	"]"

L_.str.93:                              ## @.str.93
	.asciz	"Unknown instruction argument type %d in instruction %01x %03x\n"

.subsections_via_symbols
