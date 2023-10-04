	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 14, 0
	.p2align	4, 0x90                         ## -- Begin function opcode_nop$0
_opcode_nop$0:                          ## @"opcode_nop$0"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_halt$0
_opcode_halt$0:                         ## @"opcode_halt$0"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movl	(%rdi), %edi
	callq	_exit
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_pshi$0
_opcode_pshi$0:                         ## @"opcode_pshi$0"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	216(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_ret$0
_opcode_ret$0:                          ## @"opcode_ret$0"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	movq	%rax, 216(%rdi)
	leaq	-8(%rcx), %rax
	movq	%rax, 232(%rdi)
	movq	-8(%rcx), %rax
	movq	%rax, 224(%rdi)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_irq$0
_opcode_irq$0:                          ## @"opcode_irq$0"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rdi), %rax
	leaq	_irq_table(%rip), %rcx
	popq	%rbp
	jmpq	*(%rcx,%rax,8)                  ## TAILCALL
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_svc$0
_opcode_svc$0:                          ## @"opcode_svc$0"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	movq	(%rdi), %rax
	movq	216(%rdi), %rcx
	movq	%rcx, 224(%rdi)
	movq	_svc_table(%rip), %rcx
	movq	(%rcx,%rax,8), %rax
	movq	%rax, 216(%rdi)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_cmpz$1
_opcode_cmpz$1:                         ## @"opcode_cmpz$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	(%rsi), %eax
	cmpq	$0, (%rdi,%rax,8)
	sete	%al
	movzbl	248(%rdi), %ecx
	andb	$-2, %cl
	orb	%al, %cl
	movb	%cl, 248(%rdi)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_b$1
_opcode_b$1:                            ## @"opcode_b$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movq	%rax, 216(%rdi)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_bne$1
_opcode_bne$1:                          ## @"opcode_bne$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	testb	$16, 248(%rdi)
	jne	LBB8_2
## %bb.1:
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movq	%rax, 216(%rdi)
LBB8_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_beq$1
_opcode_beq$1:                          ## @"opcode_beq$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	testb	$16, 248(%rdi)
	je	LBB9_2
## %bb.1:
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movq	%rax, 216(%rdi)
LBB9_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_bgt$1
_opcode_bgt$1:                          ## @"opcode_bgt$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	testb	$4, 248(%rdi)
	je	LBB10_2
## %bb.1:
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movq	%rax, 216(%rdi)
LBB10_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_blt$1
_opcode_blt$1:                          ## @"opcode_blt$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	testb	$8, 248(%rdi)
	je	LBB11_2
## %bb.1:
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movq	%rax, 216(%rdi)
LBB11_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_bge$1
_opcode_bge$1:                          ## @"opcode_bge$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	testb	$20, 248(%rdi)
	je	LBB12_2
## %bb.1:
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movq	%rax, 216(%rdi)
LBB12_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_ble$1
_opcode_ble$1:                          ## @"opcode_ble$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	testb	$24, 248(%rdi)
	je	LBB13_2
## %bb.1:
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movq	%rax, 216(%rdi)
LBB13_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_bnz$1
_opcode_bnz$1:                          ## @"opcode_bnz$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	testb	$1, 248(%rdi)
	jne	LBB14_2
## %bb.1:
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movq	%rax, 216(%rdi)
LBB14_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_bz$1
_opcode_bz$1:                           ## @"opcode_bz$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	testb	$1, 248(%rdi)
	je	LBB15_2
## %bb.1:
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movq	%rax, 216(%rdi)
LBB15_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_psh$1
_opcode_psh$1:                          ## @"opcode_psh$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_pp$1
_opcode_pp$1:                           ## @"opcode_pp$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	232(%rdi), %rax
	leaq	-8(%rax), %rcx
	movq	%rcx, 232(%rdi)
	movq	-8(%rax), %rax
	movzbl	(%rsi), %ecx
	movq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_not$1
_opcode_not$1:                          ## @"opcode_not$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	(%rsi), %eax
	notq	(%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_inc$1
_opcode_inc$1:                          ## @"opcode_inc$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	(%rsi), %eax
	incq	(%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_dec$1
_opcode_dec$1:                          ## @"opcode_dec$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	(%rsi), %eax
	decq	(%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_bl$1
_opcode_bl$1:                           ## @"opcode_bl$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	movq	216(%rdi), %rax
	movq	%rax, 224(%rdi)
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movq	%rax, 216(%rdi)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_blne$1
_opcode_blne$1:                         ## @"opcode_blne$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	movq	216(%rdi), %rax
	movq	%rax, 224(%rdi)
	testb	$16, 248(%rdi)
	jne	LBB22_2
## %bb.1:
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movq	%rax, 216(%rdi)
LBB22_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_bleq$1
_opcode_bleq$1:                         ## @"opcode_bleq$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	movq	216(%rdi), %rax
	movq	%rax, 224(%rdi)
	testb	$16, 248(%rdi)
	je	LBB23_2
## %bb.1:
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movq	%rax, 216(%rdi)
LBB23_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_blgt$1
_opcode_blgt$1:                         ## @"opcode_blgt$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	movq	216(%rdi), %rax
	movq	%rax, 224(%rdi)
	testb	$4, 248(%rdi)
	je	LBB24_2
## %bb.1:
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movq	%rax, 216(%rdi)
LBB24_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_bllt$1
_opcode_bllt$1:                         ## @"opcode_bllt$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	movq	216(%rdi), %rax
	movq	%rax, 224(%rdi)
	testb	$8, 248(%rdi)
	je	LBB25_2
## %bb.1:
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movq	%rax, 216(%rdi)
LBB25_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_blge$1
_opcode_blge$1:                         ## @"opcode_blge$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	movq	216(%rdi), %rax
	movq	%rax, 224(%rdi)
	testb	$20, 248(%rdi)
	je	LBB26_2
## %bb.1:
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movq	%rax, 216(%rdi)
LBB26_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_blle$1
_opcode_blle$1:                         ## @"opcode_blle$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	movq	216(%rdi), %rax
	movq	%rax, 224(%rdi)
	testb	$24, 248(%rdi)
	je	LBB27_2
## %bb.1:
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movq	%rax, 216(%rdi)
LBB27_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_blnz$1
_opcode_blnz$1:                         ## @"opcode_blnz$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	movq	216(%rdi), %rax
	movq	%rax, 224(%rdi)
	testb	$1, 248(%rdi)
	jne	LBB28_2
## %bb.1:
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movq	%rax, 216(%rdi)
LBB28_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_blz$1
_opcode_blz$1:                          ## @"opcode_blz$1"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	movq	216(%rdi), %rax
	movq	%rax, 224(%rdi)
	testb	$1, 248(%rdi)
	je	LBB29_2
## %bb.1:
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movq	%rax, 216(%rdi)
LBB29_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_ldr$2
_opcode_ldr$2:                          ## @"opcode_ldr$2"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	1(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movzbl	(%rsi), %ecx
	movq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_str$2
_opcode_str$2:                          ## @"opcode_str$2"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	1(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movzbl	(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rcx
	movq	%rax, (%rcx)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_cmp$2
_opcode_cmp$2:                          ## @"opcode_cmp$2"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	(%rsi), %eax
	movq	(%rdi,%rax,8), %rcx
	movzbl	1(%rsi), %eax
	movq	(%rdi,%rax,8), %rdx
	movb	$0, 248(%rdi)
	movb	$16, %al
	cmpq	%rdx, %rcx
	je	LBB32_4
## %bb.1:
	movb	$4, %al
	jg	LBB32_4
## %bb.2:
	movb	$8, %al
	jge	LBB32_3
LBB32_4:
	movb	%al, 248(%rdi)
	testq	%rcx, %rcx
	je	LBB32_6
LBB32_7:
	js	LBB32_8
## %bb.10:
	popq	%rbp
	retq
LBB32_8:
	movb	$2, %cl
	jmp	LBB32_9
LBB32_3:
	xorl	%eax, %eax
	testq	%rcx, %rcx
	jne	LBB32_7
LBB32_6:
	movb	$1, %cl
LBB32_9:
	orb	%cl, %al
	movb	%al, 248(%rdi)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_psh$2
_opcode_psh$2:                          ## @"opcode_psh$2"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	216(%rdi), %rax
	movq	232(%rdi), %rcx
	movzwl	(%rax), %eax
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_add$2
_opcode_add$2:                          ## @"opcode_add$2"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	1(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movzbl	(%rsi), %ecx
	addq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_sub$2
_opcode_sub$2:                          ## @"opcode_sub$2"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	1(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movzbl	(%rsi), %ecx
	subq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_mul$2
_opcode_mul$2:                          ## @"opcode_mul$2"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	1(%rsi), %eax
	movzbl	(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rdx
	imulq	(%rdi,%rax,8), %rdx
	movq	%rdx, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_div$2
_opcode_div$2:                          ## @"opcode_div$2"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	1(%rsi), %eax
	movq	(%rdi,%rax,8), %r8
	movzbl	(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rax
	movq	%rax, %rdx
	orq	%r8, %rdx
	shrq	$32, %rdx
	je	LBB37_1
## %bb.2:
	xorl	%edx, %edx
	divq	%r8
	jmp	LBB37_3
LBB37_1:
                                        ## kill: def $eax killed $eax killed $rax
	xorl	%edx, %edx
	divl	%r8d
                                        ## kill: def $eax killed $eax def $rax
LBB37_3:
	movq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_mod$2
_opcode_mod$2:                          ## @"opcode_mod$2"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	1(%rsi), %eax
	movq	(%rdi,%rax,8), %r8
	movzbl	(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rax
	movq	%rax, %rdx
	orq	%r8, %rdx
	shrq	$32, %rdx
	je	LBB38_1
## %bb.2:
	xorl	%edx, %edx
	divq	%r8
	jmp	LBB38_3
LBB38_1:
                                        ## kill: def $eax killed $eax killed $rax
	xorl	%edx, %edx
	divl	%r8d
                                        ## kill: def $edx killed $edx def $rdx
LBB38_3:
	movq	%rdx, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_and$2
_opcode_and$2:                          ## @"opcode_and$2"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	1(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movzbl	(%rsi), %ecx
	andq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_or$2
_opcode_or$2:                           ## @"opcode_or$2"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	1(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movzbl	(%rsi), %ecx
	orq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_xor$2
_opcode_xor$2:                          ## @"opcode_xor$2"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	1(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movzbl	(%rsi), %ecx
	xorq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_shl$2
_opcode_shl$2:                          ## @"opcode_shl$2"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	1(%rsi), %eax
	movzbl	(%rdi,%rax,8), %ecx
	movzbl	(%rsi), %eax
	shlq	%cl, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_shr$2
_opcode_shr$2:                          ## @"opcode_shr$2"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	1(%rsi), %eax
	movzbl	(%rdi,%rax,8), %ecx
	movzbl	(%rsi), %eax
	shrq	%cl, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_ldr$3
_opcode_ldr$3:                          ## @"opcode_ldr$3"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movswq	(%rsi), %rax
	movzbl	2(%rsi), %ecx
	movq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_str$3
_opcode_str$3:                          ## @"opcode_str$3"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movswq	(%rsi), %rax
	movzbl	2(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rcx
	movq	%rax, (%rcx)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_cmp$3
_opcode_cmp$3:                          ## @"opcode_cmp$3"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	2(%rsi), %eax
	movq	(%rdi,%rax,8), %rcx
	movswq	(%rsi), %rdx
	movb	$0, 248(%rdi)
	movb	$16, %al
	cmpq	%rdx, %rcx
	je	LBB46_4
## %bb.1:
	movb	$4, %al
	jg	LBB46_4
## %bb.2:
	movb	$8, %al
	jge	LBB46_3
LBB46_4:
	movb	%al, 248(%rdi)
	testq	%rcx, %rcx
	je	LBB46_6
LBB46_7:
	js	LBB46_8
## %bb.10:
	popq	%rbp
	retq
LBB46_8:
	movb	$2, %cl
	jmp	LBB46_9
LBB46_3:
	xorl	%eax, %eax
	testq	%rcx, %rcx
	jne	LBB46_7
LBB46_6:
	movb	$1, %cl
LBB46_9:
	orb	%cl, %al
	movb	%al, 248(%rdi)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_add$3
_opcode_add$3:                          ## @"opcode_add$3"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movswq	(%rsi), %rax
	movzbl	2(%rsi), %ecx
	addq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_sub$3
_opcode_sub$3:                          ## @"opcode_sub$3"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movswq	(%rsi), %rax
	movzbl	2(%rsi), %ecx
	subq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_mul$3
_opcode_mul$3:                          ## @"opcode_mul$3"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movswq	(%rsi), %rax
	movzbl	2(%rsi), %ecx
	imulq	(%rdi,%rcx,8), %rax
	movq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_div$3
_opcode_div$3:                          ## @"opcode_div$3"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movswq	(%rsi), %r8
	movzbl	2(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rax
	movq	%rax, %rdx
	orq	%r8, %rdx
	shrq	$32, %rdx
	je	LBB50_1
## %bb.2:
	xorl	%edx, %edx
	divq	%r8
	jmp	LBB50_3
LBB50_1:
                                        ## kill: def $eax killed $eax killed $rax
	xorl	%edx, %edx
	divl	%r8d
                                        ## kill: def $eax killed $eax def $rax
LBB50_3:
	movq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_mod$3
_opcode_mod$3:                          ## @"opcode_mod$3"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movswq	(%rsi), %r8
	movzbl	2(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rax
	movq	%rax, %rdx
	orq	%r8, %rdx
	shrq	$32, %rdx
	je	LBB51_1
## %bb.2:
	xorl	%edx, %edx
	divq	%r8
	jmp	LBB51_3
LBB51_1:
                                        ## kill: def $eax killed $eax killed $rax
	xorl	%edx, %edx
	divl	%r8d
                                        ## kill: def $edx killed $edx def $rdx
LBB51_3:
	movq	%rdx, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_and$3
_opcode_and$3:                          ## @"opcode_and$3"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movswq	(%rsi), %rax
	movzbl	2(%rsi), %ecx
	andq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_or$3
_opcode_or$3:                           ## @"opcode_or$3"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movswq	(%rsi), %rax
	movzbl	2(%rsi), %ecx
	orq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_xor$3
_opcode_xor$3:                          ## @"opcode_xor$3"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movswq	(%rsi), %rax
	movzbl	2(%rsi), %ecx
	xorq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_shl$3
_opcode_shl$3:                          ## @"opcode_shl$3"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	(%rsi), %ecx
	movzbl	2(%rsi), %eax
	shlq	%cl, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_shr$3
_opcode_shr$3:                          ## @"opcode_shr$3"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	(%rsi), %ecx
	movzbl	2(%rsi), %eax
	shrq	%cl, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_ldr$4
_opcode_ldr$4:                          ## @"opcode_ldr$4"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	1(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movswq	2(%rsi), %rcx
	movq	(%rax,%rcx), %rax
	movzbl	(%rsi), %ecx
	movq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_mov$4
_opcode_mov$4:                          ## @"opcode_mov$4"
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
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movzbl	1(%rsi), %r11d
	testq	%r11, %r11
	je	LBB58_7
## %bb.1:
	movzbl	2(%rsi), %eax
	movq	(%rdi,%rax,8), %rdx
	movzbl	3(%rsi), %eax
	movq	(%rdi,%rax,8), %r10
	movzbl	(%rsi), %esi
	movq	(%rdi,%rsi,8), %r9
	movl	%r11d, %r8d
	andl	$3, %r8d
	cmpb	$4, %r11b
	jae	LBB58_8
## %bb.2:
	xorl	%ebx, %ebx
	jmp	LBB58_3
LBB58_8:
	andl	$-4, %r11d
	leaq	(%r10,%rdx), %r14
	addq	$3, %r14
	movl	$16, %eax
	xorl	%ebx, %ebx
	.p2align	4, 0x90
LBB58_9:                                ## =>This Inner Loop Header: Depth=1
	movzbl	-3(%r14,%rbx), %r15d
	movzbl	-2(%r14,%rbx), %r12d
	leal	-8(%rax), %ecx
                                        ## kill: def $cl killed $cl killed $ecx
	shll	%cl, %r12d
	movzbl	-1(%r14,%rbx), %r13d
	movl	%eax, %ecx
	shll	%cl, %r13d
	orq	%r9, %r15
	movslq	%r12d, %r12
	movzbl	(%r14,%rbx), %r9d
	leal	8(%rax), %ecx
                                        ## kill: def $cl killed $cl killed $ecx
	shll	%cl, %r9d
	orq	%r15, %r12
	movslq	%r13d, %rcx
	movslq	%r9d, %r9
	orq	%rcx, %r9
	orq	%r12, %r9
	addq	$4, %rbx
	addl	$32, %eax
	cmpq	%rbx, %r11
	jne	LBB58_9
LBB58_3:
	testq	%r8, %r8
	je	LBB58_6
## %bb.4:
	leal	(,%rbx,8), %ecx
	addq	%rbx, %r10
	addq	%r10, %rdx
	xorl	%eax, %eax
	.p2align	4, 0x90
LBB58_5:                                ## =>This Inner Loop Header: Depth=1
	movzbl	(%rdx,%rax), %r10d
	shll	%cl, %r10d
	movslq	%r10d, %r10
	orq	%r10, %r9
	incq	%rax
	addl	$8, %ecx
	cmpq	%rax, %r8
	jne	LBB58_5
LBB58_6:
	movq	%r9, (%rdi,%rsi,8)
LBB58_7:
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_add$5
_opcode_add$5:                          ## @"opcode_add$5"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	4(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movzbl	3(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %rdx
	shlq	%cl, %rdx
	movswq	(%rsi), %rcx
	notq	%rdx
	andq	(%rax,%rcx), %rdx
	movzbl	2(%rsi), %eax
	addq	%rdx, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_sub$5
_opcode_sub$5:                          ## @"opcode_sub$5"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	4(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movzbl	3(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %rdx
	shlq	%cl, %rdx
	movswq	(%rsi), %rcx
	notq	%rdx
	andq	(%rax,%rcx), %rdx
	movzbl	2(%rsi), %eax
	subq	%rdx, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_mul$5
_opcode_mul$5:                          ## @"opcode_mul$5"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	4(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movzbl	3(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %rdx
	shlq	%cl, %rdx
	movswq	(%rsi), %rcx
	notq	%rdx
	andq	(%rax,%rcx), %rdx
	movzbl	2(%rsi), %eax
	imulq	(%rdi,%rax,8), %rdx
	movq	%rdx, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_div$5
_opcode_div$5:                          ## @"opcode_div$5"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	4(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movswq	(%rsi), %rdx
	movzbl	3(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %r8
	shlq	%cl, %r8
	notq	%r8
	andq	(%rax,%rdx), %r8
	movzbl	2(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rax
	movq	%rax, %rdx
	orq	%r8, %rdx
	shrq	$32, %rdx
	je	LBB62_1
## %bb.2:
	xorl	%edx, %edx
	divq	%r8
	jmp	LBB62_3
LBB62_1:
                                        ## kill: def $eax killed $eax killed $rax
	xorl	%edx, %edx
	divl	%r8d
                                        ## kill: def $eax killed $eax def $rax
LBB62_3:
	movq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_mod$5
_opcode_mod$5:                          ## @"opcode_mod$5"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	4(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movswq	(%rsi), %rdx
	movzbl	3(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %r8
	shlq	%cl, %r8
	notq	%r8
	andq	(%rax,%rdx), %r8
	movzbl	2(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rax
	movq	%rax, %rdx
	orq	%r8, %rdx
	shrq	$32, %rdx
	je	LBB63_1
## %bb.2:
	xorl	%edx, %edx
	divq	%r8
	jmp	LBB63_3
LBB63_1:
                                        ## kill: def $eax killed $eax killed $rax
	xorl	%edx, %edx
	divl	%r8d
                                        ## kill: def $edx killed $edx def $rdx
LBB63_3:
	movq	%rdx, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_and$5
_opcode_and$5:                          ## @"opcode_and$5"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	4(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movzbl	3(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %rdx
	shlq	%cl, %rdx
	movswq	(%rsi), %rcx
	notq	%rdx
	movzbl	2(%rsi), %esi
	movq	(%rdi,%rsi,8), %r8
	andq	(%rax,%rcx), %r8
	andq	%rdx, %r8
	movq	%r8, (%rdi,%rsi,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_or$5
_opcode_or$5:                           ## @"opcode_or$5"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	4(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movzbl	3(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %rdx
	shlq	%cl, %rdx
	movswq	(%rsi), %rcx
	notq	%rdx
	andq	(%rax,%rcx), %rdx
	movzbl	2(%rsi), %eax
	orq	%rdx, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_xor$5
_opcode_xor$5:                          ## @"opcode_xor$5"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	4(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movzbl	3(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %rdx
	shlq	%cl, %rdx
	movswq	(%rsi), %rcx
	notq	%rdx
	andq	(%rax,%rcx), %rdx
	movzbl	2(%rsi), %eax
	xorq	%rdx, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_shl$5
_opcode_shl$5:                          ## @"opcode_shl$5"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	4(%rsi), %eax
	movq	(%rdi,%rax,8), %rdx
	movzbl	3(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %rax
	shlq	%cl, %rax
	movswq	(%rsi), %rcx
	notl	%eax
	andl	(%rdx,%rcx), %eax
	movzbl	2(%rsi), %edx
	movl	%eax, %ecx
	shlq	%cl, (%rdi,%rdx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_shr$5
_opcode_shr$5:                          ## @"opcode_shr$5"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	4(%rsi), %eax
	movq	(%rdi,%rax,8), %rdx
	movzbl	3(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %rax
	shlq	%cl, %rax
	movswq	(%rsi), %rcx
	notl	%eax
	andl	(%rdx,%rcx), %eax
	movzbl	2(%rsi), %edx
	movl	%eax, %ecx
	shrq	%cl, (%rdi,%rdx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_mov$5
_opcode_mov$5:                          ## @"opcode_mov$5"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	4(%rsi), %eax
	movq	(%rdi,%rax,8), %rax
	movswq	(%rsi), %rdx
	movzbl	3(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %r8
	shlq	%cl, %r8
	notq	%r8
	andq	(%rax,%rdx), %r8
	movzbl	2(%rsi), %eax
	movq	%r8, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_b$8
_opcode_b$8:                            ## @"opcode_b$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movq	%rax, 216(%rdi)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_bne$8
_opcode_bne$8:                          ## @"opcode_bne$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	testb	$16, 248(%rdi)
	jne	LBB71_2
## %bb.1:
	movq	(%rsi), %rax
	movq	%rax, 216(%rdi)
LBB71_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_beq$8
_opcode_beq$8:                          ## @"opcode_beq$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	testb	$16, 248(%rdi)
	je	LBB72_2
## %bb.1:
	movq	(%rsi), %rax
	movq	%rax, 216(%rdi)
LBB72_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_bgt$8
_opcode_bgt$8:                          ## @"opcode_bgt$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	testb	$4, 248(%rdi)
	je	LBB73_2
## %bb.1:
	movq	(%rsi), %rax
	movq	%rax, 216(%rdi)
LBB73_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_blt$8
_opcode_blt$8:                          ## @"opcode_blt$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	testb	$8, 248(%rdi)
	je	LBB74_2
## %bb.1:
	movq	(%rsi), %rax
	movq	%rax, 216(%rdi)
LBB74_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_bge$8
_opcode_bge$8:                          ## @"opcode_bge$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	testb	$20, 248(%rdi)
	je	LBB75_2
## %bb.1:
	movq	(%rsi), %rax
	movq	%rax, 216(%rdi)
LBB75_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_ble$8
_opcode_ble$8:                          ## @"opcode_ble$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	testb	$24, 248(%rdi)
	je	LBB76_2
## %bb.1:
	movq	(%rsi), %rax
	movq	%rax, 216(%rdi)
LBB76_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_bnz$8
_opcode_bnz$8:                          ## @"opcode_bnz$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	testb	$1, 248(%rdi)
	jne	LBB77_2
## %bb.1:
	movq	(%rsi), %rax
	movq	%rax, 216(%rdi)
LBB77_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_bz$8
_opcode_bz$8:                           ## @"opcode_bz$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	testb	$1, 248(%rdi)
	je	LBB78_2
## %bb.1:
	movq	(%rsi), %rax
	movq	%rax, 216(%rdi)
LBB78_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_psh$8
_opcode_psh$8:                          ## @"opcode_psh$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_pp$8
_opcode_pp$8:                           ## @"opcode_pp$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	232(%rdi), %rax
	leaq	-8(%rax), %rcx
	movq	%rcx, 232(%rdi)
	movq	-8(%rax), %rax
	movq	(%rsi), %rcx
	movq	%rax, (%rcx)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_mov$8
_opcode_mov$8:                          ## @"opcode_mov$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movswq	10(%rsi), %rdx
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %r8
	shlq	%cl, %r8
	notq	%r8
	andq	(%rax,%rdx), %r8
	movzbl	8(%rsi), %eax
	movq	%r8, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_bl$8
_opcode_bl$8:                           ## @"opcode_bl$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	movq	216(%rdi), %rax
	movq	%rax, 224(%rdi)
	movq	(%rsi), %rax
	movq	%rax, 216(%rdi)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_blne$8
_opcode_blne$8:                         ## @"opcode_blne$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	movq	216(%rdi), %rax
	movq	%rax, 224(%rdi)
	testb	$16, 248(%rdi)
	jne	LBB83_2
## %bb.1:
	movq	(%rsi), %rax
	movq	%rax, 216(%rdi)
LBB83_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_bleq$8
_opcode_bleq$8:                         ## @"opcode_bleq$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	movq	216(%rdi), %rax
	movq	%rax, 224(%rdi)
	testb	$16, 248(%rdi)
	je	LBB84_2
## %bb.1:
	movq	(%rsi), %rax
	movq	%rax, 216(%rdi)
LBB84_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_blgt$8
_opcode_blgt$8:                         ## @"opcode_blgt$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	movq	216(%rdi), %rax
	movq	%rax, 224(%rdi)
	testb	$4, 248(%rdi)
	je	LBB85_2
## %bb.1:
	movq	(%rsi), %rax
	movq	%rax, 216(%rdi)
LBB85_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_bllt$8
_opcode_bllt$8:                         ## @"opcode_bllt$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	movq	216(%rdi), %rax
	movq	%rax, 224(%rdi)
	testb	$8, 248(%rdi)
	je	LBB86_2
## %bb.1:
	movq	(%rsi), %rax
	movq	%rax, 216(%rdi)
LBB86_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_blge$8
_opcode_blge$8:                         ## @"opcode_blge$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	movq	216(%rdi), %rax
	movq	%rax, 224(%rdi)
	testb	$20, 248(%rdi)
	je	LBB87_2
## %bb.1:
	movq	(%rsi), %rax
	movq	%rax, 216(%rdi)
LBB87_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_blle$8
_opcode_blle$8:                         ## @"opcode_blle$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	movq	216(%rdi), %rax
	movq	%rax, 224(%rdi)
	testb	$24, 248(%rdi)
	je	LBB88_2
## %bb.1:
	movq	(%rsi), %rax
	movq	%rax, 216(%rdi)
LBB88_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_blnz$8
_opcode_blnz$8:                         ## @"opcode_blnz$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	movq	216(%rdi), %rax
	movq	%rax, 224(%rdi)
	testb	$1, 248(%rdi)
	jne	LBB89_2
## %bb.1:
	movq	(%rsi), %rax
	movq	%rax, 216(%rdi)
LBB89_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_blz$8
_opcode_blz$8:                          ## @"opcode_blz$8"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	224(%rdi), %rax
	movq	232(%rdi), %rcx
	leaq	8(%rcx), %rdx
	movq	%rdx, 232(%rdi)
	movq	%rax, (%rcx)
	movq	216(%rdi), %rax
	movq	%rax, 224(%rdi)
	testb	$1, 248(%rdi)
	je	LBB90_2
## %bb.1:
	movq	(%rsi), %rax
	movq	%rax, 216(%rdi)
LBB90_2:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_ldr$9
_opcode_ldr$9:                          ## @"opcode_ldr$9"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	8(%rsi), %ecx
	movq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_str$9
_opcode_str$9:                          ## @"opcode_str$9"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	8(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rcx
	movq	%rax, (%rcx)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_cmp$9
_opcode_cmp$9:                          ## @"opcode_cmp$9"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	8(%rsi), %eax
	movq	(%rdi,%rax,8), %rcx
	movq	(%rsi), %rdx
	movb	$0, 248(%rdi)
	movb	$16, %al
	cmpq	%rdx, %rcx
	je	LBB93_4
## %bb.1:
	movb	$4, %al
	jg	LBB93_4
## %bb.2:
	movb	$8, %al
	jge	LBB93_3
LBB93_4:
	movb	%al, 248(%rdi)
	testq	%rcx, %rcx
	je	LBB93_6
LBB93_7:
	js	LBB93_8
## %bb.10:
	popq	%rbp
	retq
LBB93_8:
	movb	$2, %cl
	jmp	LBB93_9
LBB93_3:
	xorl	%eax, %eax
	testq	%rcx, %rcx
	jne	LBB93_7
LBB93_6:
	movb	$1, %cl
LBB93_9:
	orb	%cl, %al
	movb	%al, 248(%rdi)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_add$9
_opcode_add$9:                          ## @"opcode_add$9"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	8(%rsi), %ecx
	addq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_sub$9
_opcode_sub$9:                          ## @"opcode_sub$9"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	8(%rsi), %ecx
	subq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_mul$9
_opcode_mul$9:                          ## @"opcode_mul$9"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	8(%rsi), %eax
	movq	(%rdi,%rax,8), %rcx
	imulq	(%rsi), %rcx
	movq	%rcx, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_div$9
_opcode_div$9:                          ## @"opcode_div$9"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %r8
	movzbl	8(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rax
	movq	%rax, %rdx
	orq	%r8, %rdx
	shrq	$32, %rdx
	je	LBB97_1
## %bb.2:
	xorl	%edx, %edx
	divq	%r8
	jmp	LBB97_3
LBB97_1:
                                        ## kill: def $eax killed $eax killed $rax
	xorl	%edx, %edx
	divl	%r8d
                                        ## kill: def $eax killed $eax def $rax
LBB97_3:
	movq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_mod$9
_opcode_mod$9:                          ## @"opcode_mod$9"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %r8
	movzbl	8(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rax
	movq	%rax, %rdx
	orq	%r8, %rdx
	shrq	$32, %rdx
	je	LBB98_1
## %bb.2:
	xorl	%edx, %edx
	divq	%r8
	jmp	LBB98_3
LBB98_1:
                                        ## kill: def $eax killed $eax killed $rax
	xorl	%edx, %edx
	divl	%r8d
                                        ## kill: def $edx killed $edx def $rdx
LBB98_3:
	movq	%rdx, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_and$9
_opcode_and$9:                          ## @"opcode_and$9"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	8(%rsi), %ecx
	andq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_or$9
_opcode_or$9:                           ## @"opcode_or$9"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	8(%rsi), %ecx
	orq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_xor$9
_opcode_xor$9:                          ## @"opcode_xor$9"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	8(%rsi), %ecx
	xorq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_shl$9
_opcode_shl$9:                          ## @"opcode_shl$9"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	(%rsi), %ecx
	movzbl	8(%rsi), %eax
	shlq	%cl, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_shr$9
_opcode_shr$9:                          ## @"opcode_shr$9"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movzbl	(%rsi), %ecx
	movzbl	8(%rsi), %eax
	shrq	%cl, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_ldr$10
_opcode_ldr$10:                         ## @"opcode_ldr$10"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	9(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rcx
	movq	(%rax,%rcx,8), %rax
	movzbl	8(%rsi), %ecx
	movq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_ldr$11
_opcode_ldr$11:                         ## @"opcode_ldr$11"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movswq	9(%rsi), %rcx
	movq	(%rax,%rcx,8), %rax
	movzbl	8(%rsi), %ecx
	movq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_add$11
_opcode_add$11:                         ## @"opcode_add$11"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	10(%rsi), %edx
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %r8
	shlq	%cl, %r8
	movq	(%rdi,%rdx,8), %rcx
	notq	%r8
	andq	(%rax,%rcx,8), %r8
	movzbl	8(%rsi), %eax
	addq	%r8, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_sub$11
_opcode_sub$11:                         ## @"opcode_sub$11"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	10(%rsi), %edx
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %r8
	shlq	%cl, %r8
	movq	(%rdi,%rdx,8), %rcx
	notq	%r8
	andq	(%rax,%rcx,8), %r8
	movzbl	8(%rsi), %eax
	subq	%r8, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_mul$11
_opcode_mul$11:                         ## @"opcode_mul$11"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	10(%rsi), %edx
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %r8
	shlq	%cl, %r8
	movq	(%rdi,%rdx,8), %rcx
	notq	%r8
	andq	(%rax,%rcx,8), %r8
	movzbl	8(%rsi), %eax
	imulq	(%rdi,%rax,8), %r8
	movq	%r8, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_div$11
_opcode_div$11:                         ## @"opcode_div$11"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	10(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rdx
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %r8
	shlq	%cl, %r8
	notq	%r8
	andq	(%rax,%rdx,8), %r8
	movzbl	8(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rax
	movq	%rax, %rdx
	orq	%r8, %rdx
	shrq	$32, %rdx
	je	LBB109_1
## %bb.2:
	xorl	%edx, %edx
	divq	%r8
	jmp	LBB109_3
LBB109_1:
                                        ## kill: def $eax killed $eax killed $rax
	xorl	%edx, %edx
	divl	%r8d
                                        ## kill: def $eax killed $eax def $rax
LBB109_3:
	movq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_mod$11
_opcode_mod$11:                         ## @"opcode_mod$11"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	10(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rdx
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %r8
	shlq	%cl, %r8
	notq	%r8
	andq	(%rax,%rdx,8), %r8
	movzbl	8(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rax
	movq	%rax, %rdx
	orq	%r8, %rdx
	shrq	$32, %rdx
	je	LBB110_1
## %bb.2:
	xorl	%edx, %edx
	divq	%r8
	jmp	LBB110_3
LBB110_1:
                                        ## kill: def $eax killed $eax killed $rax
	xorl	%edx, %edx
	divl	%r8d
                                        ## kill: def $edx killed $edx def $rdx
LBB110_3:
	movq	%rdx, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_and$11
_opcode_and$11:                         ## @"opcode_and$11"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	10(%rsi), %edx
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %r8
	shlq	%cl, %r8
	movq	(%rdi,%rdx,8), %rcx
	notq	%r8
	movzbl	8(%rsi), %edx
	movq	(%rdi,%rdx,8), %rsi
	andq	(%rax,%rcx,8), %rsi
	andq	%r8, %rsi
	movq	%rsi, (%rdi,%rdx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_or$11
_opcode_or$11:                          ## @"opcode_or$11"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	10(%rsi), %edx
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %r8
	shlq	%cl, %r8
	movq	(%rdi,%rdx,8), %rcx
	notq	%r8
	andq	(%rax,%rcx,8), %r8
	movzbl	8(%rsi), %eax
	orq	%r8, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_xor$11
_opcode_xor$11:                         ## @"opcode_xor$11"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	10(%rsi), %edx
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %r8
	shlq	%cl, %r8
	movq	(%rdi,%rdx,8), %rcx
	notq	%r8
	andq	(%rax,%rcx,8), %r8
	movzbl	8(%rsi), %eax
	xorq	%r8, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_shl$11
_opcode_shl$11:                         ## @"opcode_shl$11"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rdx
	movzbl	10(%rsi), %r8d
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %rax
	shlq	%cl, %rax
	movq	(%rdi,%r8,8), %rcx
	notl	%eax
	andl	(%rdx,%rcx,8), %eax
	movzbl	8(%rsi), %edx
	movl	%eax, %ecx
	shlq	%cl, (%rdi,%rdx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_shr$11
_opcode_shr$11:                         ## @"opcode_shr$11"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rdx
	movzbl	10(%rsi), %r8d
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %rax
	shlq	%cl, %rax
	movq	(%rdi,%r8,8), %rcx
	notl	%eax
	andl	(%rdx,%rcx,8), %eax
	movzbl	8(%rsi), %edx
	movl	%eax, %ecx
	shrq	%cl, (%rdi,%rdx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_mov$11
_opcode_mov$11:                         ## @"opcode_mov$11"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	10(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rdx
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %r8
	shlq	%cl, %r8
	notq	%r8
	andq	(%rax,%rdx,8), %r8
	movzbl	8(%rsi), %eax
	movq	%r8, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_add$12
_opcode_add$12:                         ## @"opcode_add$12"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %rdx
	shlq	%cl, %rdx
	movswq	10(%rsi), %rcx
	notq	%rdx
	andq	(%rax,%rcx), %rdx
	movzbl	8(%rsi), %eax
	addq	%rdx, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_sub$12
_opcode_sub$12:                         ## @"opcode_sub$12"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %rdx
	shlq	%cl, %rdx
	movswq	10(%rsi), %rcx
	notq	%rdx
	andq	(%rax,%rcx), %rdx
	movzbl	8(%rsi), %eax
	subq	%rdx, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_mul$12
_opcode_mul$12:                         ## @"opcode_mul$12"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %rdx
	shlq	%cl, %rdx
	movswq	10(%rsi), %rcx
	notq	%rdx
	andq	(%rax,%rcx), %rdx
	movzbl	8(%rsi), %eax
	imulq	(%rdi,%rax,8), %rdx
	movq	%rdx, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_div$12
_opcode_div$12:                         ## @"opcode_div$12"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movswq	10(%rsi), %rdx
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %r8
	shlq	%cl, %r8
	notq	%r8
	andq	(%rax,%rdx), %r8
	movzbl	8(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rax
	movq	%rax, %rdx
	orq	%r8, %rdx
	shrq	$32, %rdx
	je	LBB120_1
## %bb.2:
	xorl	%edx, %edx
	divq	%r8
	jmp	LBB120_3
LBB120_1:
                                        ## kill: def $eax killed $eax killed $rax
	xorl	%edx, %edx
	divl	%r8d
                                        ## kill: def $eax killed $eax def $rax
LBB120_3:
	movq	%rax, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_mod$12
_opcode_mod$12:                         ## @"opcode_mod$12"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movswq	10(%rsi), %rdx
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %r8
	shlq	%cl, %r8
	notq	%r8
	andq	(%rax,%rdx), %r8
	movzbl	8(%rsi), %ecx
	movq	(%rdi,%rcx,8), %rax
	movq	%rax, %rdx
	orq	%r8, %rdx
	shrq	$32, %rdx
	je	LBB121_1
## %bb.2:
	xorl	%edx, %edx
	divq	%r8
	jmp	LBB121_3
LBB121_1:
                                        ## kill: def $eax killed $eax killed $rax
	xorl	%edx, %edx
	divl	%r8d
                                        ## kill: def $edx killed $edx def $rdx
LBB121_3:
	movq	%rdx, (%rdi,%rcx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_and$12
_opcode_and$12:                         ## @"opcode_and$12"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %rdx
	shlq	%cl, %rdx
	movswq	10(%rsi), %rcx
	notq	%rdx
	movzbl	8(%rsi), %esi
	movq	(%rdi,%rsi,8), %r8
	andq	(%rax,%rcx), %r8
	andq	%rdx, %r8
	movq	%r8, (%rdi,%rsi,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_or$12
_opcode_or$12:                          ## @"opcode_or$12"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %rdx
	shlq	%cl, %rdx
	movswq	10(%rsi), %rcx
	notq	%rdx
	andq	(%rax,%rcx), %rdx
	movzbl	8(%rsi), %eax
	orq	%rdx, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_xor$12
_opcode_xor$12:                         ## @"opcode_xor$12"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rax
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %rdx
	shlq	%cl, %rdx
	movswq	10(%rsi), %rcx
	notq	%rdx
	andq	(%rax,%rcx), %rdx
	movzbl	8(%rsi), %eax
	xorq	%rdx, (%rdi,%rax,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_shl$12
_opcode_shl$12:                         ## @"opcode_shl$12"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rdx
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %rax
	shlq	%cl, %rax
	movswq	10(%rsi), %rcx
	notl	%eax
	andl	(%rdx,%rcx), %eax
	movzbl	8(%rsi), %edx
	movl	%eax, %ecx
	shlq	%cl, (%rdi,%rdx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opcode_shr$12
_opcode_shr$12:                         ## @"opcode_shr$12"
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	(%rsi), %rdx
	movzbl	9(%rsi), %ecx
	shlb	$3, %cl
	movq	$-1, %rax
	shlq	%cl, %rax
	movswq	10(%rsi), %rcx
	notl	%eax
	andl	(%rdx,%rcx), %eax
	movzbl	8(%rsi), %edx
	movl	%eax, %ecx
	shrq	%cl, (%rdi,%rdx,8)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_exec                           ## -- Begin function exec
	.p2align	4, 0x90
_exec:                                  ## @exec
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
	movq	%rdi, %rbx
	leaq	_funcs(%rip), %r14
	.p2align	4, 0x90
LBB127_1:                               ## =>This Inner Loop Header: Depth=1
	movq	216(%rbx), %rsi
	movzwl	(%rsi), %eax
	movq	%rax, %rcx
	shrq	$12, %rcx
	leaq	(%rcx,%rsi), %rdx
	addq	$2, %rdx
	movq	%rdx, 216(%rbx)
	movq	(%r14,%rcx,8), %rcx
	andl	$4095, %eax                     ## imm = 0xFFF
	addq	$2, %rsi
	movq	%rbx, %rdi
	callq	*(%rcx,%rax,8)
	jmp	LBB127_1
	.cfi_endproc
                                        ## -- End function
	.globl	_add_symbol                     ## -- Begin function add_symbol
	.p2align	4, 0x90
_add_symbol:                            ## @add_symbol
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
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rsi, %r14
	movq	%rdi, %rbx
	movq	88(%rdi), %rdi
	movzwl	80(%rbx), %eax
	leaq	(%rax,%rax,2), %rax
	leaq	24(,%rax,8), %rsi
	callq	_realloc
	movq	%rax, %r15
	movq	%rax, 88(%rbx)
	movzwl	80(%rbx), %eax
	leaq	(%rax,%rax,2), %r12
	movq	%r14, %rdi
	callq	_strlen
	leaq	1(%rax), %rdi
	callq	_malloc
	movq	%rax, 16(%r15,%r12,8)
	movq	%rax, %rdi
	movq	%r14, %rsi
	callq	_strcpy
	movq	48(%rbx), %rax
	movq	%rax, (%r15,%r12,8)
	incw	80(%rbx)
	xorl	%eax, %eax
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_symbol_offset                  ## -- Begin function symbol_offset
	.p2align	4, 0x90
_symbol_offset:                         ## @symbol_offset
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
	movq	%rsi, %r14
	movq	%rdi, %rbx
	movzwl	80(%rdi), %r13d
	movq	88(%rdi), %rax
	movq	%rax, -48(%rbp)                 ## 8-byte Spill
	testq	%r13, %r13
	je	LBB129_4
## %bb.1:
	movq	-48(%rbp), %rax                 ## 8-byte Reload
	leaq	16(%rax), %r12
	xorl	%r15d, %r15d
	.p2align	4, 0x90
LBB129_2:                               ## =>This Inner Loop Header: Depth=1
	movq	(%r12), %rdi
	movq	%r14, %rsi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB129_5
## %bb.3:                               ##   in Loop: Header=BB129_2 Depth=1
	incq	%r15
	addq	$24, %r12
	cmpq	%r15, %r13
	jne	LBB129_2
LBB129_4:
	leaq	(,%r13,2), %rax
	addq	%r13, %rax
	leaq	24(,%rax,8), %rsi
	movq	-48(%rbp), %rdi                 ## 8-byte Reload
	callq	_realloc
	movq	%rax, %r15
	movq	%rax, 88(%rbx)
	movzwl	80(%rbx), %eax
	leaq	(%rax,%rax,2), %r12
	movq	%r14, %rdi
	callq	_strlen
	leaq	1(%rax), %rdi
	callq	_malloc
	movq	%rax, 16(%r15,%r12,8)
	movq	%rax, %rdi
	movq	%r14, %rsi
	callq	_strcpy
	movq	48(%rbx), %rax
	movq	%rax, (%r15,%r12,8)
	movl	80(%rbx), %eax
	incl	%eax
	movw	%ax, 80(%rbx)
	movq	88(%rbx), %rcx
	movzwl	%ax, %r15d
	decq	%r15
	leaq	(%r15,%r15,2), %rax
	movabsq	$-9223372036854775808, %rdx     ## imm = 0x8000000000000000
	orq	%rdx, (%rcx,%rax,8)
LBB129_5:
	movq	%r15, %rax
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_sig_handler                    ## -- Begin function sig_handler
	.p2align	4, 0x90
_sig_handler:                           ## @sig_handler
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%rbx
	subq	$264, %rsp                      ## imm = 0x108
	.cfi_offset %rbx, -24
	movq	%rsi, %rbx
	callq	_strsignal
	movq	___stderrp@GOTPCREL(%rip), %rcx
	movq	(%rcx), %rdi
	movq	24(%rbx), %rcx
	leaq	L_.str(%rip), %rsi
	movq	%rax, %rdx
	xorl	%eax, %eax
	callq	_fprintf
	leaq	-272(%rbp), %rbx
	movq	%rbx, %rdi
	movl	$32, %esi
	callq	_backtrace
	movq	%rbx, %rdi
	movl	%eax, %esi
	movl	$2, %edx
	callq	_backtrace_symbols_fd
	movl	$1, %edi
	callq	_exit
	.cfi_endproc
                                        ## -- End function
	.globl	_find_symbol_in                 ## -- Begin function find_symbol_in
	.p2align	4, 0x90
_find_symbol_in:                        ## @find_symbol_in
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
	movq	%rsi, %rbx
	movq	%rdi, %r14
	movl	24(%rdi), %r15d
	leaq	(,%r15,8), %rdi
	callq	_malloc
	testq	%r15, %r15
	je	LBB131_12
## %bb.1:
	movq	32(%r14), %rcx
	cmpl	$1, %r15d
	jne	LBB131_3
## %bb.2:
	xorl	%edx, %edx
	xorl	%esi, %esi
LBB131_9:
	testb	$1, %r15b
	je	LBB131_12
## %bb.10:
	movq	(%rcx,%rdx,8), %rcx
	cmpw	$2, (%rcx)
	jne	LBB131_12
## %bb.11:
	movl	%esi, %edx
	movq	%rcx, (%rax,%rdx,8)
LBB131_12:
	testq	%rax, %rax
	je	LBB131_19
## %bb.13:
	movq	(%rax), %rcx
	testq	%rcx, %rcx
	je	LBB131_19
## %bb.14:
	movq	8(%rcx), %rax
	cmpq	$24, %rax
	jae	LBB131_15
LBB131_19:
	xorl	%eax, %eax
LBB131_20:
	addq	$8, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
LBB131_3:
	movl	%r15d, %edi
	andl	$-2, %edi
	xorl	%edx, %edx
	xorl	%esi, %esi
	jmp	LBB131_4
	.p2align	4, 0x90
LBB131_8:                               ##   in Loop: Header=BB131_4 Depth=1
	addq	$2, %rdx
	cmpq	%rdx, %rdi
	je	LBB131_9
LBB131_4:                               ## =>This Inner Loop Header: Depth=1
	movq	(%rcx,%rdx,8), %r8
	cmpw	$2, (%r8)
	jne	LBB131_6
## %bb.5:                               ##   in Loop: Header=BB131_4 Depth=1
	movl	%esi, %r9d
	incl	%esi
	movq	%r8, (%rax,%r9,8)
LBB131_6:                               ##   in Loop: Header=BB131_4 Depth=1
	movq	8(%rcx,%rdx,8), %r8
	cmpw	$2, (%r8)
	jne	LBB131_8
## %bb.7:                               ##   in Loop: Header=BB131_4 Depth=1
	movl	%esi, %r9d
	incl	%esi
	movq	%r8, (%rax,%r9,8)
	jmp	LBB131_8
LBB131_15:
	movabsq	$-6148914691236517205, %rdx     ## imm = 0xAAAAAAAAAAAAAAAB
	mulq	%rdx
	movq	%rdx, %r14
	movq	16(%rcx), %r15
	shrq	$4, %r14
	addq	$16, %r15
	jmp	LBB131_16
	.p2align	4, 0x90
LBB131_18:                              ##   in Loop: Header=BB131_16 Depth=1
	addq	$24, %r15
	decq	%r14
	je	LBB131_19
LBB131_16:                              ## =>This Inner Loop Header: Depth=1
	movq	(%r15), %rdi
	movq	%rbx, %rsi
	callq	_strcmp
	testl	%eax, %eax
	jne	LBB131_18
## %bb.17:                              ##   in Loop: Header=BB131_16 Depth=1
	movq	-16(%r15), %rax
	testq	%rax, %rax
	js	LBB131_18
	jmp	LBB131_20
	.cfi_endproc
                                        ## -- End function
	.globl	_find_symbol                    ## -- Begin function find_symbol
	.p2align	4, 0x90
_find_symbol:                           ## @find_symbol
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
	movq	%rdx, -48(%rbp)                 ## 8-byte Spill
	testq	%rdx, %rdx
	je	LBB132_24
## %bb.1:
	movq	%rsi, %r15
	movq	%rdi, %r12
	xorl	%ebx, %ebx
	jmp	LBB132_2
	.p2align	4, 0x90
LBB132_23:                              ##   in Loop: Header=BB132_2 Depth=1
	incq	%rbx
	cmpq	-48(%rbp), %rbx                 ## 8-byte Folded Reload
	je	LBB132_24
LBB132_2:                               ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB132_6 Depth 2
                                        ##     Child Loop BB132_18 Depth 2
	leaq	(%rbx,%rbx,2), %r14
	shlq	$4, %r14
	movl	24(%r15,%r14), %r13d
	leaq	(,%r13,8), %rdi
	callq	_malloc
	testq	%r13, %r13
	je	LBB132_14
## %bb.3:                               ##   in Loop: Header=BB132_2 Depth=1
	movq	32(%r15,%r14), %rcx
	cmpl	$1, %r13d
	jne	LBB132_5
## %bb.4:                               ##   in Loop: Header=BB132_2 Depth=1
	xorl	%edx, %edx
	xorl	%esi, %esi
LBB132_11:                              ##   in Loop: Header=BB132_2 Depth=1
	testb	$1, %r13b
	je	LBB132_14
## %bb.12:                              ##   in Loop: Header=BB132_2 Depth=1
	movq	(%rcx,%rdx,8), %rcx
	cmpw	$2, (%rcx)
	jne	LBB132_14
## %bb.13:                              ##   in Loop: Header=BB132_2 Depth=1
	movl	%esi, %edx
	movq	%rcx, (%rax,%rdx,8)
	.p2align	4, 0x90
LBB132_14:                              ##   in Loop: Header=BB132_2 Depth=1
	testq	%rax, %rax
	je	LBB132_23
## %bb.15:                              ##   in Loop: Header=BB132_2 Depth=1
	movq	(%rax), %rcx
	testq	%rcx, %rcx
	je	LBB132_23
## %bb.16:                              ##   in Loop: Header=BB132_2 Depth=1
	movq	8(%rcx), %rax
	cmpq	$24, %rax
	jb	LBB132_23
## %bb.17:                              ##   in Loop: Header=BB132_2 Depth=1
	movabsq	$-6148914691236517205, %rdx     ## imm = 0xAAAAAAAAAAAAAAAB
	mulq	%rdx
	movq	%rdx, %r13
	movq	16(%rcx), %r14
	shrq	$4, %r13
	addq	$16, %r14
	jmp	LBB132_18
	.p2align	4, 0x90
LBB132_20:                              ##   in Loop: Header=BB132_18 Depth=2
	addq	$24, %r14
	decq	%r13
	je	LBB132_23
LBB132_18:                              ##   Parent Loop BB132_2 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movq	(%r14), %rdi
	movq	%r12, %rsi
	callq	_strcmp
	testl	%eax, %eax
	jne	LBB132_20
## %bb.19:                              ##   in Loop: Header=BB132_18 Depth=2
	movq	-16(%r14), %rax
	testq	%rax, %rax
	js	LBB132_20
## %bb.21:                              ##   in Loop: Header=BB132_2 Depth=1
	je	LBB132_23
## %bb.22:                              ##   in Loop: Header=BB132_2 Depth=1
	js	LBB132_23
	jmp	LBB132_25
	.p2align	4, 0x90
LBB132_5:                               ##   in Loop: Header=BB132_2 Depth=1
	movl	%r13d, %edi
	andl	$-2, %edi
	xorl	%edx, %edx
	xorl	%esi, %esi
	jmp	LBB132_6
	.p2align	4, 0x90
LBB132_10:                              ##   in Loop: Header=BB132_6 Depth=2
	addq	$2, %rdx
	cmpq	%rdx, %rdi
	je	LBB132_11
LBB132_6:                               ##   Parent Loop BB132_2 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movq	(%rcx,%rdx,8), %r8
	cmpw	$2, (%r8)
	jne	LBB132_8
## %bb.7:                               ##   in Loop: Header=BB132_6 Depth=2
	movl	%esi, %r9d
	incl	%esi
	movq	%r8, (%rax,%r9,8)
LBB132_8:                               ##   in Loop: Header=BB132_6 Depth=2
	movq	8(%rcx,%rdx,8), %r8
	cmpw	$2, (%r8)
	jne	LBB132_10
## %bb.9:                               ##   in Loop: Header=BB132_6 Depth=2
	movl	%esi, %r9d
	incl	%esi
	movq	%r8, (%rax,%r9,8)
	jmp	LBB132_10
LBB132_24:
	xorl	%eax, %eax
LBB132_25:
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_relocate                       ## -- Begin function relocate
	.p2align	4, 0x90
_relocate:                              ## @relocate
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
	movq	%rdi, -48(%rbp)                 ## 8-byte Spill
	testq	%rsi, %rsi
	je	LBB133_35
## %bb.1:
	movq	%rsi, %rbx
	movq	___stderrp@GOTPCREL(%rip), %r12
	xorl	%r15d, %r15d
	movq	%rsi, -72(%rbp)                 ## 8-byte Spill
	jmp	LBB133_2
	.p2align	4, 0x90
LBB133_34:                              ##   in Loop: Header=BB133_2 Depth=1
	incq	%r15
	cmpq	%rbx, %r15
	je	LBB133_35
LBB133_2:                               ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB133_6 Depth 2
                                        ##     Child Loop BB133_18 Depth 2
                                        ##     Child Loop BB133_23 Depth 2
                                        ##     Child Loop BB133_28 Depth 2
                                        ##       Child Loop BB133_39 Depth 3
	leaq	(%r15,%r15,2), %rcx
	shlq	$4, %rcx
	movq	-48(%rbp), %rax                 ## 8-byte Reload
	movq	%rcx, -56(%rbp)                 ## 8-byte Spill
	movl	24(%rax,%rcx), %r14d
	leaq	(,%r14,8), %rdi
	callq	_malloc
	testq	%r14, %r14
	je	LBB133_14
## %bb.3:                               ##   in Loop: Header=BB133_2 Depth=1
	movq	-48(%rbp), %rcx                 ## 8-byte Reload
	movq	-56(%rbp), %rdx                 ## 8-byte Reload
	movq	32(%rcx,%rdx), %rcx
	cmpl	$1, %r14d
	jne	LBB133_5
## %bb.4:                               ##   in Loop: Header=BB133_2 Depth=1
	xorl	%edx, %edx
	xorl	%esi, %esi
LBB133_11:                              ##   in Loop: Header=BB133_2 Depth=1
	testb	$1, %r14b
	je	LBB133_14
## %bb.12:                              ##   in Loop: Header=BB133_2 Depth=1
	movq	(%rcx,%rdx,8), %rcx
	cmpw	$2, (%rcx)
	jne	LBB133_14
## %bb.13:                              ##   in Loop: Header=BB133_2 Depth=1
	movl	%esi, %edx
	movq	%rcx, (%rax,%rdx,8)
	.p2align	4, 0x90
LBB133_14:                              ##   in Loop: Header=BB133_2 Depth=1
	testq	%rax, %rax
	je	LBB133_34
## %bb.15:                              ##   in Loop: Header=BB133_2 Depth=1
	movq	(%rax), %rcx
	testq	%rcx, %rcx
	je	LBB133_34
## %bb.16:                              ##   in Loop: Header=BB133_2 Depth=1
	movq	%r15, -64(%rbp)                 ## 8-byte Spill
	movq	8(%rcx), %rax
	movq	16(%rcx), %r14
	cmpq	$24, %rax
	jae	LBB133_17
LBB133_21:                              ##   in Loop: Header=BB133_2 Depth=1
	movq	-48(%rbp), %rax                 ## 8-byte Reload
	movq	-56(%rbp), %rcx                 ## 8-byte Reload
	movl	12(%rax,%rcx), %r15d
	leaq	(,%r15,8), %rdi
	callq	_malloc
	movq	%rax, %r13
                                        ## implicit-def: $rcx
	movq	%r15, -88(%rbp)                 ## 8-byte Spill
	testq	%r15, %r15
	movq	-64(%rbp), %r15                 ## 8-byte Reload
	je	LBB133_27
## %bb.22:                              ##   in Loop: Header=BB133_2 Depth=1
	movq	-48(%rbp), %rax                 ## 8-byte Reload
	movq	-56(%rbp), %rcx                 ## 8-byte Reload
	movq	16(%rax,%rcx), %rax
	movq	%rax, -80(%rbp)                 ## 8-byte Spill
	xorl	%r15d, %r15d
	xorl	%ebx, %ebx
	jmp	LBB133_23
	.p2align	4, 0x90
LBB133_25:                              ##   in Loop: Header=BB133_23 Depth=2
	incq	%r15
	cmpq	%r15, -88(%rbp)                 ## 8-byte Folded Reload
	je	LBB133_26
LBB133_23:                              ##   Parent Loop BB133_2 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movq	-80(%rbp), %rax                 ## 8-byte Reload
	movq	(%rax,%r15,8), %r12
	movl	$16, %edx
	movq	%r12, %rdi
	leaq	L_.str.2(%rip), %rsi
	callq	_strncmp
	testl	%eax, %eax
	jne	LBB133_25
## %bb.24:                              ##   in Loop: Header=BB133_23 Depth=2
	movl	%ebx, %eax
	incl	%ebx
	movq	%r12, (%r13,%rax,8)
	jmp	LBB133_25
	.p2align	4, 0x90
LBB133_5:                               ##   in Loop: Header=BB133_2 Depth=1
	movl	%r14d, %edi
	andl	$-2, %edi
	xorl	%edx, %edx
	xorl	%esi, %esi
	jmp	LBB133_6
	.p2align	4, 0x90
LBB133_10:                              ##   in Loop: Header=BB133_6 Depth=2
	addq	$2, %rdx
	cmpq	%rdx, %rdi
	je	LBB133_11
LBB133_6:                               ##   Parent Loop BB133_2 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movq	(%rcx,%rdx,8), %r8
	cmpw	$2, (%r8)
	jne	LBB133_8
## %bb.7:                               ##   in Loop: Header=BB133_6 Depth=2
	movl	%esi, %r9d
	incl	%esi
	movq	%r8, (%rax,%r9,8)
LBB133_8:                               ##   in Loop: Header=BB133_6 Depth=2
	movq	8(%rcx,%rdx,8), %r8
	cmpw	$2, (%r8)
	jne	LBB133_10
## %bb.9:                               ##   in Loop: Header=BB133_6 Depth=2
	movl	%esi, %r9d
	incl	%esi
	movq	%r8, (%rax,%r9,8)
	jmp	LBB133_10
	.p2align	4, 0x90
LBB133_26:                              ##   in Loop: Header=BB133_2 Depth=1
	movq	(%r13), %rcx
	testq	%rcx, %rcx
	movq	-72(%rbp), %rbx                 ## 8-byte Reload
	movq	___stderrp@GOTPCREL(%rip), %r12
	movq	-64(%rbp), %r15                 ## 8-byte Reload
	je	LBB133_34
LBB133_27:                              ##   in Loop: Header=BB133_2 Depth=1
	movq	-48(%rbp), %rax                 ## 8-byte Reload
	movq	-56(%rbp), %rdx                 ## 8-byte Reload
	movq	32(%rax,%rdx), %rax
	jmp	LBB133_28
	.p2align	4, 0x90
LBB133_33:                              ##   in Loop: Header=BB133_28 Depth=2
	movq	8(%r13), %rcx
	addq	$8, %r13
	testq	%rcx, %rcx
	je	LBB133_34
LBB133_28:                              ##   Parent Loop BB133_2 Depth=1
                                        ## =>  This Loop Header: Depth=2
                                        ##       Child Loop BB133_39 Depth 3
	movl	16(%rcx), %edi
	testq	%rdi, %rdi
	je	LBB133_33
## %bb.29:                              ##   in Loop: Header=BB133_28 Depth=2
	movl	32(%rcx), %edx
	movq	(%rax,%rdx,8), %rsi
	movq	24(%rcx), %rdx
	movq	16(%rsi), %rcx
	movq	%rdi, %rsi
	decq	%rsi
	shrq	$4, %rsi
	incq	%rsi
	cmpl	$17, %edi
	jae	LBB133_38
## %bb.30:                              ##   in Loop: Header=BB133_28 Depth=2
	xorl	%edi, %edi
	jmp	LBB133_31
	.p2align	4, 0x90
LBB133_38:                              ##   in Loop: Header=BB133_28 Depth=2
	movq	%rsi, %r8
	andq	$-2, %r8
	xorl	%edi, %edi
	.p2align	4, 0x90
LBB133_39:                              ##   Parent Loop BB133_2 Depth=1
                                        ##     Parent Loop BB133_28 Depth=2
                                        ## =>    This Inner Loop Header: Depth=3
	movq	(%rdx,%rdi), %r9
	movq	(%rcx,%r9), %r10
	leaq	(%r10,%r10,2), %r10
	movq	(%r14,%r10,8), %r10
	movq	%r10, (%rcx,%r9)
	movq	16(%rdx,%rdi), %r9
	movq	(%rcx,%r9), %r10
	leaq	(%r10,%r10,2), %r10
	movq	(%r14,%r10,8), %r10
	movq	%r10, (%rcx,%r9)
	addq	$32, %rdi
	addq	$-2, %r8
	jne	LBB133_39
LBB133_31:                              ##   in Loop: Header=BB133_28 Depth=2
	testb	$1, %sil
	je	LBB133_33
## %bb.32:                              ##   in Loop: Header=BB133_28 Depth=2
	movq	(%rdx,%rdi), %rdx
	movq	(%rcx,%rdx), %rsi
	leaq	(%rsi,%rsi,2), %rsi
	movq	(%r14,%rsi,8), %rsi
	movq	%rsi, (%rcx,%rdx)
	jmp	LBB133_33
LBB133_17:                              ##   in Loop: Header=BB133_2 Depth=1
	movabsq	$-6148914691236517205, %rcx     ## imm = 0xAAAAAAAAAAAAAAAB
	mulq	%rcx
	movq	%rdx, %r13
	shrq	$4, %r13
	leaq	16(%r14), %r15
	jmp	LBB133_18
LBB133_36:                              ##   in Loop: Header=BB133_18 Depth=2
	movq	(%r12), %rdi
	movq	(%r15), %rdx
	leaq	L_.str.1(%rip), %rsi
	xorl	%eax, %eax
	callq	_fprintf
	.p2align	4, 0x90
LBB133_37:                              ##   in Loop: Header=BB133_18 Depth=2
	addq	$24, %r15
	decq	%r13
	je	LBB133_21
LBB133_18:                              ##   Parent Loop BB133_2 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	cmpq	$0, -16(%r15)
	jns	LBB133_37
## %bb.19:                              ##   in Loop: Header=BB133_18 Depth=2
	movq	(%r15), %rdi
	movq	-48(%rbp), %rsi                 ## 8-byte Reload
	movq	%rbx, %rdx
	callq	_find_symbol
	testq	%rax, %rax
	je	LBB133_36
## %bb.20:                              ##   in Loop: Header=BB133_18 Depth=2
	movq	%rax, -16(%r15)
	jmp	LBB133_37
LBB133_35:
	addq	$56, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_main                           ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
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
	movl	$1049016, %eax                  ## imm = 0x1001B8
	callq	____chkstk_darwin
	subq	%rax, %rsp
	popq	%rax
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rsi, %r12
	movl	%edi, %ebx
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	leaq	_main.act(%rip), %rsi
	movl	$2, %edi
	xorl	%edx, %edx
	callq	_sigaction
	cmpl	$-1, %eax
	jne	LBB134_2
## %bb.1:
	movq	___stderrp@GOTPCREL(%rip), %r14
	movq	(%r14), %rcx
	leaq	L_.str.3(%rip), %rdi
	movl	$32, %esi
	movl	$1, %edx
	callq	_fwrite
	movq	(%r14), %r14
	callq	___error
	movl	(%rax), %edi
	callq	_strerror
	movq	%rax, %r15
	callq	___error
	movl	(%rax), %ecx
	leaq	L_.str.4(%rip), %rsi
	movq	%r14, %rdi
	movq	%r15, %rdx
	xorl	%eax, %eax
	callq	_fprintf
LBB134_2:
	leaq	_main.act(%rip), %rsi
	movl	$4, %edi
	xorl	%edx, %edx
	callq	_sigaction
	cmpl	$-1, %eax
	jne	LBB134_4
## %bb.3:
	movq	___stderrp@GOTPCREL(%rip), %r14
	movq	(%r14), %rcx
	leaq	L_.str.3(%rip), %rdi
	movl	$32, %esi
	movl	$1, %edx
	callq	_fwrite
	movq	(%r14), %r14
	callq	___error
	movl	(%rax), %edi
	callq	_strerror
	movq	%rax, %r15
	callq	___error
	movl	(%rax), %ecx
	leaq	L_.str.4(%rip), %rsi
	movq	%r14, %rdi
	movq	%r15, %rdx
	xorl	%eax, %eax
	callq	_fprintf
LBB134_4:
	leaq	_main.act(%rip), %rsi
	movl	$5, %edi
	xorl	%edx, %edx
	callq	_sigaction
	cmpl	$-1, %eax
	jne	LBB134_6
## %bb.5:
	movq	___stderrp@GOTPCREL(%rip), %r14
	movq	(%r14), %rcx
	leaq	L_.str.3(%rip), %rdi
	movl	$32, %esi
	movl	$1, %edx
	callq	_fwrite
	movq	(%r14), %r14
	callq	___error
	movl	(%rax), %edi
	callq	_strerror
	movq	%rax, %r15
	callq	___error
	movl	(%rax), %ecx
	leaq	L_.str.4(%rip), %rsi
	movq	%r14, %rdi
	movq	%r15, %rdx
	xorl	%eax, %eax
	callq	_fprintf
LBB134_6:
	leaq	_main.act(%rip), %rsi
	movl	$6, %edi
	xorl	%edx, %edx
	callq	_sigaction
	cmpl	$-1, %eax
	jne	LBB134_8
## %bb.7:
	movq	___stderrp@GOTPCREL(%rip), %r14
	movq	(%r14), %rcx
	leaq	L_.str.3(%rip), %rdi
	movl	$32, %esi
	movl	$1, %edx
	callq	_fwrite
	movq	(%r14), %r14
	callq	___error
	movl	(%rax), %edi
	callq	_strerror
	movq	%rax, %r15
	callq	___error
	movl	(%rax), %ecx
	leaq	L_.str.4(%rip), %rsi
	movq	%r14, %rdi
	movq	%r15, %rdx
	xorl	%eax, %eax
	callq	_fprintf
LBB134_8:
	leaq	_main.act(%rip), %rsi
	movl	$10, %edi
	xorl	%edx, %edx
	callq	_sigaction
	cmpl	$-1, %eax
	jne	LBB134_10
## %bb.9:
	movq	___stderrp@GOTPCREL(%rip), %r14
	movq	(%r14), %rcx
	leaq	L_.str.3(%rip), %rdi
	movl	$32, %esi
	movl	$1, %edx
	callq	_fwrite
	movq	(%r14), %r14
	callq	___error
	movl	(%rax), %edi
	callq	_strerror
	movq	%rax, %r15
	callq	___error
	movl	(%rax), %ecx
	leaq	L_.str.4(%rip), %rsi
	movq	%r14, %rdi
	movq	%r15, %rdx
	xorl	%eax, %eax
	callq	_fprintf
LBB134_10:
	leaq	_main.act(%rip), %rsi
	movl	$11, %edi
	xorl	%edx, %edx
	callq	_sigaction
	cmpl	$-1, %eax
	je	LBB134_11
## %bb.12:
	cmpl	$2, %ebx
	jg	LBB134_14
LBB134_13:
	movq	___stderrp@GOTPCREL(%rip), %rbx
	movq	(%rbx), %rdi
	movq	(%r12), %rdx
	leaq	L_.str.5(%rip), %rsi
	xorl	%eax, %eax
	callq	_fprintf
	movq	(%rbx), %rdi
	movq	(%r12), %rdx
	leaq	L_.str.6(%rip), %rsi
	jmp	LBB134_74
LBB134_11:
	movq	___stderrp@GOTPCREL(%rip), %r14
	movq	(%r14), %rcx
	leaq	L_.str.3(%rip), %rdi
	movl	$32, %esi
	movl	$1, %edx
	callq	_fwrite
	movq	(%r14), %r14
	callq	___error
	movl	(%rax), %edi
	callq	_strerror
	movq	%rax, %r15
	callq	___error
	movl	(%rax), %ecx
	leaq	L_.str.4(%rip), %rsi
	movq	%r14, %rdi
	movq	%r15, %rdx
	xorl	%eax, %eax
	callq	_fprintf
	cmpl	$2, %ebx
	jle	LBB134_13
LBB134_14:
	movq	8(%r12), %r14
	leaq	L_.str.7(%rip), %rsi
	movq	%r14, %rdi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB134_15
## %bb.66:
	leaq	L_.str.10(%rip), %rsi
	movq	%r14, %rdi
	callq	_strcmp
	testl	%eax, %eax
	je	LBB134_67
## %bb.73:
	movq	___stderrp@GOTPCREL(%rip), %rax
	movq	(%rax), %rdi
	leaq	L_.str.15(%rip), %rsi
	movq	%r14, %rdx
	jmp	LBB134_74
LBB134_15:
	cmpl	$3, %ebx
	ja	LBB134_17
## %bb.16:
	movq	___stderrp@GOTPCREL(%rip), %rax
	movq	(%rax), %rdi
	movq	(%r12), %rdx
	leaq	L_.str.8(%rip), %rsi
	jmp	LBB134_74
LBB134_67:
	movq	16(%r12), %rdi
	leaq	L_.str.11(%rip), %rsi
	callq	_fopen
	testq	%rax, %rax
	je	LBB134_68
## %bb.69:
	movq	%rax, %rbx
	leaq	_kernel(%rip), %rsi
	leaq	-144(%rbp), %r14
	movq	%r14, %rdi
	callq	_read_translation_unit_bytes
	leaq	-96(%rbp), %rdi
	movq	%rbx, %rsi
	callq	_read_translation_unit
	movq	%rbx, %rdi
	callq	_fclose
	movl	$2, %esi
	movq	%r14, %rdi
	callq	_relocate
	leaq	L_.str.13(%rip), %rdi
	movl	$2, %edx
	movq	%r14, %rsi
	callq	_find_symbol
	movq	%rax, -184(%rbp)
	testq	%rax, %rax
	je	LBB134_72
## %bb.70:
	movq	%rax, %rsi
	leaq	-1048976(%rbp), %rax
	movq	%rax, -168(%rbp)
	movq	%rax, -160(%rbp)
	leaq	_funcs(%rip), %r14
	leaq	-400(%rbp), %rbx
	.p2align	4, 0x90
LBB134_71:                              ## =>This Inner Loop Header: Depth=1
	movzwl	(%rsi), %eax
	movq	%rax, %rcx
	shrq	$12, %rcx
	leaq	(%rcx,%rsi), %rdx
	addq	$2, %rdx
	movq	%rdx, -184(%rbp)
	movq	(%r14,%rcx,8), %rcx
	andl	$4095, %eax                     ## imm = 0xFFF
	addq	$2, %rsi
	movq	%rbx, %rdi
	callq	*(%rcx,%rax,8)
	movq	-184(%rbp), %rsi
	jmp	LBB134_71
LBB134_17:
	movabsq	$8571976398, %rax               ## imm = 0x1FEEDFACE
	movq	%rax, -400(%rbp)
	xorps	%xmm0, %xmm0
	movups	%xmm0, -392(%rbp)
	movq	16(%r12), %rdi
	callq	_run_compile
	movq	%rax, -1049040(%rbp)            ## 8-byte Spill
	movq	(%rax), %r13
	testq	%r13, %r13
	movq	%r12, -1049032(%rbp)            ## 8-byte Spill
	je	LBB134_18
## %bb.19:
	xorl	%edi, %edi
	xorl	%eax, %eax
	movq	%rax, -1049016(%rbp)            ## 8-byte Spill
	xorl	%eax, %eax
	movq	%rax, -1048992(%rbp)            ## 8-byte Spill
	xorl	%eax, %eax
	movq	%rax, -1049024(%rbp)            ## 8-byte Spill
	xorl	%eax, %eax
	movq	%rax, -1048984(%rbp)            ## 8-byte Spill
	xorl	%r15d, %r15d
	jmp	LBB134_20
	.p2align	4, 0x90
LBB134_51:                              ##   in Loop: Header=BB134_20 Depth=1
	movw	$23, 2(%r13)
	movl	%r15d, -376(%rbp)
	movl	%r15d, %eax
	shlq	$5, %rax
	leaq	(%rax,%rax,2), %rsi
	movq	-1049048(%rbp), %rdi            ## 8-byte Reload
	callq	_realloc
	movq	%rax, %rdi
	movq	%rax, -368(%rbp)
	movq	%r13, (%rax,%r14,8)
	movq	-1049040(%rbp), %rax            ## 8-byte Reload
	movq	(%rax,%r15,8), %r13
	testq	%r13, %r13
	je	LBB134_52
LBB134_20:                              ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB134_22 Depth 2
                                        ##       Child Loop BB134_27 Depth 3
                                        ##       Child Loop BB134_32 Depth 3
                                        ##     Child Loop BB134_63 Depth 2
                                        ##     Child Loop BB134_65 Depth 2
	movq	%rdi, -1049048(%rbp)            ## 8-byte Spill
	movq	%r15, %rcx
	cmpq	$0, 32(%r13)
	movq	%r15, %rax
	movq	%r15, -1049000(%rbp)            ## 8-byte Spill
	je	LBB134_28
## %bb.21:                              ##   in Loop: Header=BB134_20 Depth=1
	xorl	%edx, %edx
	jmp	LBB134_22
	.p2align	4, 0x90
LBB134_41:                              ##   in Loop: Header=BB134_22 Depth=2
	movq	%r13, %rdi
	movq	%rbx, %rsi
	callq	_symbol_offset
	movq	%rax, %rbx
	movq	8(%r13), %rsi
	movq	16(%r13), %rdi
	addq	$8, %rsi
	callq	_realloc
	movq	%rax, 16(%r13)
	movq	8(%r13), %rcx
	movq	%rbx, (%rax,%rcx)
	addq	$8, %rcx
	movq	%rcx, 8(%r13)
LBB134_42:                              ##   in Loop: Header=BB134_22 Depth=2
	movq	-1049056(%rbp), %rdx            ## 8-byte Reload
	incq	%rdx
	cmpq	32(%r13), %rdx
	movq	-1049000(%rbp), %rcx            ## 8-byte Reload
	jae	LBB134_28
LBB134_22:                              ##   Parent Loop BB134_20 Depth=1
                                        ## =>  This Loop Header: Depth=2
                                        ##       Child Loop BB134_27 Depth 3
                                        ##       Child Loop BB134_32 Depth 3
	movq	24(%r13), %rsi
	imulq	$272, %rdx, %rax                ## imm = 0x110
	movl	(%rsi,%rax), %ecx
	movq	8(%rsi,%rax), %rbx
	cmpl	$2, %ecx
	leaq	LJTI134_0(%rip), %r12
	movq	%rdx, -1049056(%rbp)            ## 8-byte Spill
	je	LBB134_41
## %bb.23:                              ##   in Loop: Header=BB134_22 Depth=2
	movq	16(%rsi,%rax), %r14
	cmpl	$1, %ecx
	je	LBB134_31
## %bb.24:                              ##   in Loop: Header=BB134_22 Depth=2
	testl	%ecx, %ecx
	jne	LBB134_42
## %bb.25:                              ##   in Loop: Header=BB134_22 Depth=2
	testq	%r14, %r14
	je	LBB134_42
## %bb.26:                              ##   in Loop: Header=BB134_22 Depth=2
	movq	8(%r13), %rsi
	movq	16(%r13), %rax
	xorl	%r15d, %r15d
	.p2align	4, 0x90
LBB134_27:                              ##   Parent Loop BB134_20 Depth=1
                                        ##     Parent Loop BB134_22 Depth=2
                                        ## =>    This Inner Loop Header: Depth=3
	movzbl	(%rbx,%r15), %r12d
	incq	%rsi
	movq	%rsi, 8(%r13)
	movq	%rax, %rdi
	callq	_realloc
	movq	%rax, 16(%r13)
	movq	8(%r13), %rsi
	movb	%r12b, -1(%rsi,%rax)
	incq	%r15
	cmpq	%r15, %r14
	jne	LBB134_27
	jmp	LBB134_42
	.p2align	4, 0x90
LBB134_31:                              ##   in Loop: Header=BB134_22 Depth=2
	addq	%rax, %rsi
	addq	$24, %rsi
	movq	%rbx, -1048976(%rbp)
	movq	%r14, -1048968(%rbp)
	movl	$248, %edx
	leaq	-1048960(%rbp), %rdi
	callq	_memcpy
	movl	%ebx, %r14d
	rolw	$12, %r14w
	movzwl	%bx, %r15d
	movq	8(%r13), %rsi
	movq	16(%r13), %rdi
	addq	$2, %rsi
	callq	_realloc
	movq	%rax, 16(%r13)
	movq	8(%r13), %rcx
	movw	%r14w, (%rax,%rcx)
	addq	$2, %rcx
	movq	%rcx, 8(%r13)
	andl	$15, %ebx
	shrl	$4, %r15d
	movl	%r15d, -1049004(%rbp)           ## 4-byte Spill
	movl	$16, %r15d
	jmp	LBB134_32
LBB134_39:                              ##   in Loop: Header=BB134_32 Depth=3
	leaq	L_.str.17(%rip), %rdi
                                        ## kill: def $esi killed $esi killed $rsi
	movl	%ebx, %edx
	movl	-1049004(%rbp), %ecx            ## 4-byte Reload
	xorl	%eax, %eax
	callq	_printf
	.p2align	4, 0x90
LBB134_40:                              ##   in Loop: Header=BB134_32 Depth=3
	addq	$16, %r15
	cmpq	$80, %r15
	je	LBB134_42
LBB134_32:                              ##   Parent Loop BB134_20 Depth=1
                                        ##     Parent Loop BB134_22 Depth=2
                                        ## =>    This Inner Loop Header: Depth=3
	movl	-1048984(%rbp,%r15), %esi
	cmpq	$4, %rsi
	ja	LBB134_39
## %bb.33:                              ##   in Loop: Header=BB134_32 Depth=3
	movslq	(%r12,%rsi,4), %rax
	addq	%r12, %rax
	jmpq	*%rax
LBB134_34:                              ##   in Loop: Header=BB134_32 Depth=3
	movzbl	-1048976(%rbp,%r15), %r14d
	movq	8(%r13), %rsi
	movq	16(%r13), %rdi
	incq	%rsi
	movq	%rsi, 8(%r13)
	callq	_realloc
	movq	%rax, 16(%r13)
	movq	8(%r13), %rcx
	movb	%r14b, -1(%rcx,%rax)
	jmp	LBB134_40
LBB134_36:                              ##   in Loop: Header=BB134_32 Depth=3
	movq	-1048976(%rbp,%r15), %rsi
	movq	%r13, %rdi
	callq	_symbol_offset
	movq	%rax, %r14
	jmp	LBB134_38
LBB134_35:                              ##   in Loop: Header=BB134_32 Depth=3
	movzwl	-1048976(%rbp,%r15), %r14d
	movq	8(%r13), %rsi
	movq	16(%r13), %rdi
	addq	$2, %rsi
	callq	_realloc
	movq	%rax, 16(%r13)
	movq	8(%r13), %rcx
	movw	%r14w, (%rax,%rcx)
	addq	$2, %rcx
	movq	%rcx, 8(%r13)
	jmp	LBB134_40
LBB134_37:                              ##   in Loop: Header=BB134_32 Depth=3
	movq	-1048976(%rbp,%r15), %r14
LBB134_38:                              ##   in Loop: Header=BB134_32 Depth=3
	movq	8(%r13), %rsi
	movq	16(%r13), %rdi
	addq	$8, %rsi
	callq	_realloc
	movq	%rax, 16(%r13)
	movq	8(%r13), %rcx
	movq	%r14, (%rax,%rcx)
	addq	$8, %rcx
	movq	%rcx, 8(%r13)
	jmp	LBB134_40
	.p2align	4, 0x90
LBB134_28:                              ##   in Loop: Header=BB134_20 Depth=1
	leaq	1(%rcx), %r15
	movl	%r15d, -388(%rbp)
	movl	%r15d, %eax
	shlq	$3, %rax
	leaq	(%rax,%rax,4), %rsi
	movq	-1049016(%rbp), %rdi            ## 8-byte Reload
	movq	%rcx, %r14
	callq	_realloc
	movq	%rax, %r12
	movq	%rax, -384(%rbp)
	movl	$40, %edi
	callq	_malloc
	movq	%rax, %rbx
	movl	%r14d, %r14d
	movq	%r12, -1049016(%rbp)            ## 8-byte Spill
	movq	%rax, (%r12,%r14,8)
	movabsq	$4995689644009735506, %rax      ## imm = 0x455441434F4C4552
	movq	%rax, (%rbx)
	movl	$0, 16(%rbx)
	movzwl	80(%r13), %r12d
	movq	-1049024(%rbp), %rax            ## 8-byte Reload
	addq	%r12, %rax
	movq	%rax, -1049024(%rbp)            ## 8-byte Spill
	leaq	(,%rax,8), %rax
	leaq	(%rax,%rax,2), %rsi
	movq	-1048992(%rbp), %rdi            ## 8-byte Reload
	callq	_realloc
	testq	%r12, %r12
	je	LBB134_46
## %bb.29:                              ##   in Loop: Header=BB134_20 Depth=1
	movq	88(%r13), %r9
	cmpw	$1, %r12w
	jne	LBB134_62
## %bb.30:                              ##   in Loop: Header=BB134_20 Depth=1
	xorl	%ecx, %ecx
	testb	$1, %r12b
	jne	LBB134_45
	jmp	LBB134_46
	.p2align	4, 0x90
LBB134_62:                              ##   in Loop: Header=BB134_20 Depth=1
	movq	-1048984(%rbp), %rcx            ## 8-byte Reload
	leaq	(%rcx,%rcx,2), %rcx
	leaq	(%rax,%rcx,8), %rdx
	movl	%r12d, %esi
	andl	$-2, %esi
	negq	%rsi
	movl	$24, %edi
	xorl	%ecx, %ecx
	movq	-1049000(%rbp), %r10            ## 8-byte Reload
	.p2align	4, 0x90
LBB134_63:                              ##   Parent Loop BB134_20 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movups	-24(%r9,%rdi), %xmm0
	movups	%xmm0, -24(%rdx,%rdi)
	movq	-8(%r9,%rdi), %r8
	movq	%r8, -8(%rdx,%rdi)
	movq	%r10, -16(%rdx,%rdi)
	movups	(%r9,%rdi), %xmm0
	movups	%xmm0, (%rdx,%rdi)
	movq	16(%r9,%rdi), %r8
	movq	%r8, 16(%rdx,%rdi)
	movq	%r10, 8(%rdx,%rdi)
	addq	$-2, %rcx
	addq	$48, %rdi
	cmpq	%rcx, %rsi
	jne	LBB134_63
## %bb.43:                              ##   in Loop: Header=BB134_20 Depth=1
	subq	%rcx, -1048984(%rbp)            ## 8-byte Folded Spill
	negq	%rcx
	testb	$1, %r12b
	je	LBB134_46
LBB134_45:                              ##   in Loop: Header=BB134_20 Depth=1
	movq	-1048984(%rbp), %rsi            ## 8-byte Reload
	leaq	(%rsi,%rsi,2), %rdx
	incq	%rsi
	leaq	(%rcx,%rcx,2), %rcx
	movups	(%r9,%rcx,8), %xmm0
	movups	%xmm0, (%rax,%rdx,8)
	movq	16(%r9,%rcx,8), %rcx
	movq	%rcx, 16(%rax,%rdx,8)
	movq	-1049000(%rbp), %rcx            ## 8-byte Reload
	movq	%rcx, 8(%rax,%rdx,8)
	movq	%rsi, -1048984(%rbp)            ## 8-byte Spill
LBB134_46:                              ##   in Loop: Header=BB134_20 Depth=1
	movq	%rax, -1048992(%rbp)            ## 8-byte Spill
	movq	56(%r13), %r12
	movl	%r12d, %edi
	shll	$4, %edi
	movl	%edi, 16(%rbx)
	callq	_malloc
	movq	%rax, 24(%rbx)
	movq	-1049000(%rbp), %rcx            ## 8-byte Reload
	movl	%ecx, 32(%rbx)
	testq	%r12, %r12
	je	LBB134_51
## %bb.47:                              ##   in Loop: Header=BB134_20 Depth=1
	movq	16(%r13), %rcx
	movq	72(%r13), %rsi
	movq	88(%r13), %rdx
	cmpq	$1, %r12
	jne	LBB134_64
## %bb.48:                              ##   in Loop: Header=BB134_20 Depth=1
	xorl	%edi, %edi
	jmp	LBB134_49
	.p2align	4, 0x90
LBB134_64:                              ##   in Loop: Header=BB134_20 Depth=1
	movq	%r12, %r8
	andq	$-2, %r8
	leaq	24(%rax), %r9
	xorl	%edi, %edi
	.p2align	4, 0x90
LBB134_65:                              ##   Parent Loop BB134_20 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movq	(%rsi,%rdi,8), %r10
	movq	%r10, -24(%r9)
	movq	(%rcx,%r10), %r10
	leaq	(%r10,%r10,2), %r10
	movq	(%rdx,%r10,8), %r10
	movq	%r10, -16(%r9)
	movq	8(%rsi,%rdi,8), %r10
	movq	%r10, -8(%r9)
	movq	(%rcx,%r10), %r10
	leaq	(%r10,%r10,2), %r10
	movq	(%rdx,%r10,8), %r10
	movq	%r10, (%r9)
	addq	$2, %rdi
	addq	$32, %r9
	cmpq	%rdi, %r8
	jne	LBB134_65
LBB134_49:                              ##   in Loop: Header=BB134_20 Depth=1
	testb	$1, %r12b
	je	LBB134_51
## %bb.50:                              ##   in Loop: Header=BB134_20 Depth=1
	movq	(%rsi,%rdi,8), %rsi
	shlq	$4, %rdi
	movq	%rsi, (%rax,%rdi)
	movq	(%rcx,%rsi), %rcx
	leaq	(%rcx,%rcx,2), %rcx
	movq	(%rdx,%rcx,8), %rcx
	movq	%rcx, 8(%rax,%rdi)
	jmp	LBB134_51
LBB134_68:
	movq	___stderrp@GOTPCREL(%rip), %rax
	movq	(%rax), %rdi
	movq	16(%r12), %rdx
	leaq	L_.str.12(%rip), %rsi
LBB134_74:
	xorl	%eax, %eax
	callq	_fprintf
LBB134_75:
	movl	$1, %eax
LBB134_76:
	movq	___stack_chk_guard@GOTPCREL(%rip), %rcx
	movq	(%rcx), %rcx
	cmpq	-48(%rbp), %rcx
	jne	LBB134_78
## %bb.77:
	addq	$1049016, %rsp                  ## imm = 0x1001B8
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
LBB134_18:
	xorl	%edi, %edi
	xorl	%r15d, %r15d
	xorl	%eax, %eax
	movq	%rax, -1048984(%rbp)            ## 8-byte Spill
	xorl	%eax, %eax
	movq	%rax, -1048992(%rbp)            ## 8-byte Spill
LBB134_52:
	leal	1(%r15), %eax
	movl	%eax, -376(%rbp)
	shlq	$5, %rax
	leaq	(%rax,%rax,2), %rsi
	callq	_realloc
	movq	%rax, %r14
	movq	%rax, -368(%rbp)
	movl	$96, %edi
	callq	_malloc
	movq	%rax, %rbx
	movl	%r15d, %eax
	movq	%rbx, (%r14,%rax,8)
	movl	$2162690, (%rbx)                ## imm = 0x210002
	movl	$8, %r15d
	movl	$8, %edi
	callq	_malloc
	movq	%rax, 16(%rbx)
	movq	$8, 8(%rbx)
	movq	-1048984(%rbp), %rcx            ## 8-byte Reload
	movq	%rcx, (%rax)
	testq	%rcx, %rcx
	movq	-1048992(%rbp), %r13            ## 8-byte Reload
	je	LBB134_55
## %bb.53:
	addq	$16, %r13
	.p2align	4, 0x90
LBB134_54:                              ## =>This Inner Loop Header: Depth=1
	movq	%rcx, -1048984(%rbp)            ## 8-byte Spill
	movq	(%r13), %rdi
	callq	_strlen
	movq	%rax, %r12
	leaq	1(%rax), %r14
	movq	16(%rbx), %rdi
	leaq	(%r15,%rax), %rsi
	addq	$17, %rsi
	addq	$17, %r12
	callq	_realloc
	movq	%rax, 16(%rbx)
	movq	8(%rbx), %rcx
	movups	-16(%r13), %xmm0
	movups	%xmm0, (%rax,%rcx)
	leaq	(%rax,%rcx), %rdi
	addq	$16, %rdi
	movq	(%r13), %rsi
	movq	%r14, %rdx
	callq	_strncpy
	movq	-1048984(%rbp), %rcx            ## 8-byte Reload
	addq	8(%rbx), %r12
	movq	%r12, 8(%rbx)
	addq	$24, %r13
	movq	%r12, %r15
	decq	%rcx
	jne	LBB134_54
LBB134_55:
	movq	-1049032(%rbp), %rax            ## 8-byte Reload
	movq	24(%rax), %rdi
	leaq	L_.str.9(%rip), %rsi
	callq	_fopen
	movq	%rax, %rbx
	leaq	-400(%rbp), %rdi
	movl	$4, %esi
	movl	$1, %edx
	movq	%rax, %rcx
	callq	_fwrite
	movl	$4, %esi
	movl	$1, %edx
	leaq	-396(%rbp), %rdi
	movq	%rbx, %rcx
	callq	_fwrite
	movl	$4, %esi
	movl	$1, %edx
	leaq	-392(%rbp), %rdi
	movq	%rbx, %rcx
	callq	_fwrite
	leaq	-388(%rbp), %rdi
	movl	$4, %esi
	movl	$1, %edx
	movq	%rbx, %rcx
	callq	_fwrite
	movl	$4, %esi
	movl	$1, %edx
	leaq	-376(%rbp), %rdi
	movq	%rbx, %rcx
	callq	_fwrite
	cmpl	$0, -388(%rbp)
	je	LBB134_58
## %bb.56:
	xorl	%r14d, %r14d
	.p2align	4, 0x90
LBB134_57:                              ## =>This Inner Loop Header: Depth=1
	movq	-384(%rbp), %rax
	movq	(%rax,%r14,8), %rdi
	movl	$1, %esi
	movl	$16, %edx
	movq	%rbx, %rcx
	callq	_fwrite
	movq	-384(%rbp), %rax
	movq	(%rax,%r14,8), %rdi
	addq	$16, %rdi
	movl	$4, %esi
	movl	$1, %edx
	movq	%rbx, %rcx
	callq	_fwrite
	movq	-384(%rbp), %rax
	movq	(%rax,%r14,8), %rax
	movq	24(%rax), %rdi
	movl	16(%rax), %edx
	movl	$1, %esi
	movq	%rbx, %rcx
	callq	_fwrite
	incq	%r14
	movl	-388(%rbp), %eax
	cmpq	%rax, %r14
	jb	LBB134_57
LBB134_58:
	cmpl	$0, -376(%rbp)
	je	LBB134_61
## %bb.59:
	xorl	%r14d, %r14d
	.p2align	4, 0x90
LBB134_60:                              ## =>This Inner Loop Header: Depth=1
	movq	-368(%rbp), %rax
	movq	(%rax,%r14,8), %rdi
	movl	$2, %esi
	movl	$1, %edx
	movq	%rbx, %rcx
	callq	_fwrite
	movq	-368(%rbp), %rax
	movq	(%rax,%r14,8), %rdi
	addq	$2, %rdi
	movl	$2, %esi
	movl	$1, %edx
	movq	%rbx, %rcx
	callq	_fwrite
	movq	-368(%rbp), %rax
	movq	(%rax,%r14,8), %rdi
	addq	$8, %rdi
	movl	$8, %esi
	movl	$1, %edx
	movq	%rbx, %rcx
	callq	_fwrite
	movq	-368(%rbp), %rax
	movq	(%rax,%r14,8), %rax
	movq	8(%rax), %rdx
	movq	16(%rax), %rdi
	movl	$1, %esi
	movq	%rbx, %rcx
	callq	_fwrite
	incq	%r14
	movl	-376(%rbp), %eax
	cmpq	%rax, %r14
	jb	LBB134_60
LBB134_61:
	movq	%rbx, %rdi
	callq	_fclose
	xorl	%eax, %eax
	jmp	LBB134_76
LBB134_72:
	movq	___stderrp@GOTPCREL(%rip), %rax
	movq	(%rax), %rcx
	leaq	L_.str.14(%rip), %rdi
	movl	$29, %esi
	movl	$1, %edx
	callq	_fwrite
	jmp	LBB134_75
LBB134_78:
	callq	___stack_chk_fail
	.cfi_endproc
	.p2align	2, 0x90
	.data_region jt32
.set L134_0_set_40, LBB134_40-LJTI134_0
.set L134_0_set_34, LBB134_34-LJTI134_0
.set L134_0_set_35, LBB134_35-LJTI134_0
.set L134_0_set_37, LBB134_37-LJTI134_0
.set L134_0_set_36, LBB134_36-LJTI134_0
LJTI134_0:
	.long	L134_0_set_40
	.long	L134_0_set_34
	.long	L134_0_set_35
	.long	L134_0_set_37
	.long	L134_0_set_36
	.end_data_region
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function read_translation_unit_bytes
_read_translation_unit_bytes:           ## @read_translation_unit_bytes
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
	subq	$88, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rsi, %r12
	movq	%rdi, %rbx
	movl	(%rsi), %esi
	cmpl	$-17958194, %esi                ## imm = 0xFEEDFACE
	jne	LBB135_1
## %bb.4:
	movl	4(%r12), %edx
	cmpl	$1, %edx
	jne	LBB135_5
## %bb.6:
	movq	8(%r12), %rax
	movq	%rax, -80(%rbp)                 ## 8-byte Spill
	shrq	$32, %rax
	movl	16(%r12), %r13d
	addq	$20, %r12
	testl	%eax, %eax
	movq	%rbx, -56(%rbp)                 ## 8-byte Spill
	movq	%r13, -88(%rbp)                 ## 8-byte Spill
	je	LBB135_7
## %bb.10:
	movl	%eax, %r14d
	leaq	(,%r14,8), %rax
	leaq	(%rax,%rax,4), %rdi
	callq	_malloc
	movq	%rax, %rbx
	xorl	%r13d, %r13d
	movq	%rax, -64(%rbp)                 ## 8-byte Spill
	jmp	LBB135_11
	.p2align	4, 0x90
LBB135_12:                              ##   in Loop: Header=BB135_11 Depth=1
	movq	-64(%rbp), %rbx                 ## 8-byte Reload
LBB135_14:                              ##   in Loop: Header=BB135_11 Depth=1
	incq	%r13
	cmpq	%r14, %r13
	je	LBB135_15
LBB135_11:                              ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB135_17 Depth 2
	movl	$40, %edi
	callq	_malloc
	movq	%rax, %r15
	movq	%rax, (%rbx,%r13,8)
	movzbl	(%r12), %eax
	movb	%al, (%r15)
	movzbl	1(%r12), %eax
	movb	%al, 1(%r15)
	movzbl	2(%r12), %eax
	movb	%al, 2(%r15)
	movzbl	3(%r12), %eax
	movb	%al, 3(%r15)
	movzbl	4(%r12), %eax
	movb	%al, 4(%r15)
	movzbl	5(%r12), %eax
	movb	%al, 5(%r15)
	movzbl	6(%r12), %eax
	movb	%al, 6(%r15)
	movzbl	7(%r12), %eax
	movb	%al, 7(%r15)
	movzbl	8(%r12), %eax
	movb	%al, 8(%r15)
	movzbl	9(%r12), %eax
	movb	%al, 9(%r15)
	movzbl	10(%r12), %eax
	movb	%al, 10(%r15)
	movzbl	11(%r12), %eax
	movb	%al, 11(%r15)
	movzbl	12(%r12), %eax
	movb	%al, 12(%r15)
	movzbl	13(%r12), %eax
	movb	%al, 13(%r15)
	movzbl	14(%r12), %eax
	movb	%al, 14(%r15)
	movzbl	15(%r12), %eax
	movb	%al, 15(%r15)
	movl	16(%r12), %ebx
	addq	$20, %r12
	movl	%ebx, 16(%r15)
	movq	%rbx, %rdi
	callq	_malloc
	movq	%rax, 24(%r15)
	testq	%rbx, %rbx
	je	LBB135_12
## %bb.16:                              ##   in Loop: Header=BB135_11 Depth=1
	xorl	%eax, %eax
	movq	-64(%rbp), %rbx                 ## 8-byte Reload
	.p2align	4, 0x90
LBB135_17:                              ##   Parent Loop BB135_11 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movzbl	(%r12,%rax), %ecx
	movq	24(%r15), %rdx
	movb	%cl, (%rdx,%rax)
	incq	%rax
	movq	(%rbx,%r13,8), %r15
	movl	16(%r15), %ecx
	cmpq	%rcx, %rax
	jb	LBB135_17
## %bb.13:                              ##   in Loop: Header=BB135_11 Depth=1
	addq	%rax, %r12
	jmp	LBB135_14
LBB135_1:
	leaq	L_.str.18(%rip), %rdi
	xorl	%eax, %eax
	callq	_printf
	jmp	LBB135_2
LBB135_5:
	leaq	L_.str.19(%rip), %rdi
	movl	$1, %esi
	xorl	%eax, %eax
	callq	_printf
LBB135_2:
	xorps	%xmm0, %xmm0
	movups	%xmm0, (%rbx)
	movups	%xmm0, 16(%rbx)
	movups	%xmm0, 32(%rbx)
	jmp	LBB135_3
LBB135_15:
	movq	-56(%rbp), %rbx                 ## 8-byte Reload
	movq	-88(%rbp), %r13                 ## 8-byte Reload
	testl	%r13d, %r13d
	je	LBB135_9
LBB135_18:
	leaq	(,%r13,8), %rdi
	movq	%rdi, -72(%rbp)                 ## 8-byte Spill
	callq	_malloc
	movq	%rax, %r14
	xorl	%r15d, %r15d
	movq	%rax, -48(%rbp)                 ## 8-byte Spill
	jmp	LBB135_19
	.p2align	4, 0x90
LBB135_24:                              ##   in Loop: Header=BB135_19 Depth=1
	movq	-48(%rbp), %r14                 ## 8-byte Reload
LBB135_25:                              ##   in Loop: Header=BB135_19 Depth=1
	incq	%r15
	movq	-88(%rbp), %r13                 ## 8-byte Reload
	cmpq	%r13, %r15
	je	LBB135_26
LBB135_19:                              ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB135_29 Depth 2
	movl	$96, %edi
	callq	_malloc
	movq	%rax, %r13
	movq	%rax, (%r14,%r15,8)
	movzwl	(%r12), %eax
	movw	%ax, (%r13)
	movzwl	2(%r12), %eax
	movw	%ax, 2(%r13)
	movq	4(%r12), %rax
	movq	%rax, 8(%r13)
	movl	$29, %edi
	callq	_sysconf
	movq	%rax, %rcx
	movq	8(%r13), %r14
	movq	%r14, %rax
	orq	%rcx, %rax
	shrq	$32, %rax
	je	LBB135_20
## %bb.21:                              ##   in Loop: Header=BB135_19 Depth=1
	movq	%r14, %rax
	xorl	%edx, %edx
	divq	%rcx
	jmp	LBB135_22
	.p2align	4, 0x90
LBB135_20:                              ##   in Loop: Header=BB135_19 Depth=1
	movl	%r14d, %eax
	xorl	%edx, %edx
	divl	%ecx
                                        ## kill: def $edx killed $edx def $rdx
LBB135_22:                              ##   in Loop: Header=BB135_19 Depth=1
	movq	%rcx, %rbx
	subq	%rdx, %rbx
	testq	%rdx, %rdx
	cmoveq	%rdx, %rbx
	addq	%r14, %rbx
	movq	%rcx, -112(%rbp)                ## 8-byte Spill
	movq	%rcx, %rdi
	movq	%rbx, %rsi
	callq	_aligned_alloc
	testq	%rax, %rax
	je	LBB135_55
## %bb.23:                              ##   in Loop: Header=BB135_19 Depth=1
	addq	$12, %r12
	movq	%rax, 16(%r13)
	testq	%r14, %r14
	je	LBB135_24
## %bb.28:                              ##   in Loop: Header=BB135_19 Depth=1
	xorl	%eax, %eax
	movq	-48(%rbp), %r14                 ## 8-byte Reload
	.p2align	4, 0x90
LBB135_29:                              ##   Parent Loop BB135_19 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movzbl	(%r12), %ecx
	incq	%r12
	movq	16(%r13), %rdx
	movb	%cl, (%rdx,%rax)
	incl	%eax
	movq	(%r14,%r15,8), %r13
	cmpq	%rax, 8(%r13)
	ja	LBB135_29
	jmp	LBB135_25
LBB135_26:
	movq	-72(%rbp), %rdi                 ## 8-byte Reload
	callq	_malloc
	cmpl	$1, %r13d
	jne	LBB135_30
## %bb.27:
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	movq	-56(%rbp), %rbx                 ## 8-byte Reload
LBB135_36:
	testb	$1, %r13b
	je	LBB135_39
## %bb.37:
	movq	(%r14,%rcx,8), %rcx
	cmpw	$2, (%rcx)
	jne	LBB135_39
## %bb.38:
	movl	%edx, %edx
	movq	%rcx, (%rax,%rdx,8)
	jmp	LBB135_39
LBB135_7:
	xorl	%eax, %eax
	movq	%rax, -64(%rbp)                 ## 8-byte Spill
	testl	%r13d, %r13d
	jne	LBB135_18
LBB135_9:
	xorl	%eax, %eax
	movq	%rax, -48(%rbp)                 ## 8-byte Spill
	xorl	%edi, %edi
	callq	_malloc
LBB135_39:
	movsd	-80(%rbp), %xmm0                ## 8-byte Reload
                                        ## xmm0 = mem[0],zero
	movaps	%xmm0, -112(%rbp)               ## 16-byte Spill
	movq	(%rax), %r14
	movq	16(%r14), %rax
	movq	(%rax), %r12
	leaq	(,%r12,8), %rax
	leaq	(%rax,%rax,2), %r15
	movq	%r15, %rdi
	callq	_malloc
	testq	%r12, %r12
	je	LBB135_48
## %bb.40:
	movq	%r12, %rcx
	movq	%r15, -80(%rbp)                 ## 8-byte Spill
	movq	%rax, -72(%rbp)                 ## 8-byte Spill
	leaq	16(%rax), %r12
	movl	$8, %r13d
	movq	%rcx, -120(%rbp)                ## 8-byte Spill
	movq	%rcx, %r15
	.p2align	4, 0x90
LBB135_41:                              ## =>This Inner Loop Header: Depth=1
	movq	16(%r14), %rax
	movups	(%rax,%r13), %xmm0
	movups	%xmm0, -16(%r12)
	leaq	(%rax,%r13), %rbx
	addq	$16, %rbx
	movq	%rbx, %rdi
	callq	_strlen
	leaq	1(%rax), %rdi
	callq	_malloc
	movq	%rax, (%r12)
	movq	%rax, %rdi
	movq	%rbx, %rsi
	callq	_strcpy
	movq	%rbx, %rdi
	callq	_strlen
	addq	%rax, %r13
	addq	$17, %r13
	addq	$24, %r12
	decq	%r15
	jne	LBB135_41
## %bb.42:
	movq	-120(%rbp), %r10                ## 8-byte Reload
	testq	%r10, %r10
	movq	-56(%rbp), %rbx                 ## 8-byte Reload
	movq	-88(%rbp), %r13                 ## 8-byte Reload
	movq	-80(%rbp), %r15                 ## 8-byte Reload
	movq	-72(%rbp), %rax                 ## 8-byte Reload
	je	LBB135_48
## %bb.43:
	cmpq	$1, %r10
	jne	LBB135_49
## %bb.44:
	xorl	%r9d, %r9d
LBB135_45:
	testb	$1, %r10b
	je	LBB135_48
## %bb.46:
	leaq	(%r9,%r9,2), %rcx
	movq	(%rax,%rcx,8), %rdi
	testq	%rdi, %rdi
	js	LBB135_48
## %bb.47:
	leaq	(%rax,%rcx,8), %rdx
	movq	8(%rax,%rcx,8), %rcx
	movq	-48(%rbp), %rsi                 ## 8-byte Reload
	movq	(%rsi,%rcx,8), %rcx
	addq	16(%rcx), %rdi
	movq	%rdi, (%rdx)
LBB135_48:
	movq	%rax, 16(%r14)
	movq	%r15, 8(%r14)
	movabsq	$8571976398, %rax               ## imm = 0x1FEEDFACE
	movq	%rax, (%rbx)
	movaps	-112(%rbp), %xmm0               ## 16-byte Reload
	movlps	%xmm0, 8(%rbx)
	movq	-64(%rbp), %rax                 ## 8-byte Reload
	movq	%rax, 16(%rbx)
	movl	%r13d, 24(%rbx)
	movq	-48(%rbp), %rax                 ## 8-byte Reload
	movq	%rax, 32(%rbx)
LBB135_3:
	movq	%rbx, %rax
	addq	$88, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
LBB135_30:
	movl	%r13d, %esi
	andl	$-2, %esi
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	movq	-56(%rbp), %rbx                 ## 8-byte Reload
	jmp	LBB135_31
	.p2align	4, 0x90
LBB135_35:                              ##   in Loop: Header=BB135_31 Depth=1
	addq	$2, %rcx
	cmpq	%rcx, %rsi
	je	LBB135_36
LBB135_31:                              ## =>This Inner Loop Header: Depth=1
	movq	(%r14,%rcx,8), %rdi
	cmpw	$2, (%rdi)
	jne	LBB135_33
## %bb.32:                              ##   in Loop: Header=BB135_31 Depth=1
	movl	%edx, %r8d
	incl	%edx
	movq	%rdi, (%rax,%r8,8)
LBB135_33:                              ##   in Loop: Header=BB135_31 Depth=1
	movq	8(%r14,%rcx,8), %rdi
	cmpw	$2, (%rdi)
	jne	LBB135_35
## %bb.34:                              ##   in Loop: Header=BB135_31 Depth=1
	movl	%edx, %r8d
	incl	%edx
	movq	%rdi, (%rax,%r8,8)
	jmp	LBB135_35
LBB135_49:
	movq	%r10, %rcx
	andq	$-2, %rcx
	xorl	%r9d, %r9d
	movq	%rax, %rdx
	jmp	LBB135_50
	.p2align	4, 0x90
LBB135_54:                              ##   in Loop: Header=BB135_50 Depth=1
	addq	$2, %r9
	addq	$48, %rdx
	cmpq	%r9, %rcx
	je	LBB135_45
LBB135_50:                              ## =>This Inner Loop Header: Depth=1
	movq	(%rdx), %rsi
	testq	%rsi, %rsi
	js	LBB135_52
## %bb.51:                              ##   in Loop: Header=BB135_50 Depth=1
	movq	8(%rdx), %rdi
	movq	-48(%rbp), %r8                  ## 8-byte Reload
	movq	(%r8,%rdi,8), %rdi
	addq	16(%rdi), %rsi
	movq	%rsi, (%rdx)
LBB135_52:                              ##   in Loop: Header=BB135_50 Depth=1
	movq	24(%rdx), %rsi
	testq	%rsi, %rsi
	js	LBB135_54
## %bb.53:                              ##   in Loop: Header=BB135_50 Depth=1
	movq	32(%rdx), %rdi
	movq	-48(%rbp), %r8                  ## 8-byte Reload
	movq	(%r8,%rdi,8), %rdi
	addq	16(%rdi), %rsi
	movq	%rsi, 24(%rdx)
	jmp	LBB135_54
LBB135_55:
	callq	___error
	movl	(%rax), %edi
	callq	_strerror
	leaq	L_.str.20(%rip), %rdi
	movq	%rbx, %rsi
	movq	-112(%rbp), %rdx                ## 8-byte Reload
	movq	%rax, %rcx
	xorl	%eax, %eax
	callq	_printf
	movl	$1, %edi
	callq	_exit
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function read_translation_unit
_read_translation_unit:                 ## @read_translation_unit
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
	subq	$16, %rsp
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rsi, %r14
	movq	%rdi, %rbx
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	%rsi, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	_fseek
	movq	%r14, %rdi
	callq	_ftell
	movq	%rax, %r15
	movq	%r14, %rdi
	xorl	%esi, %esi
	xorl	%edx, %edx
	callq	_fseek
	movq	%r15, %rax
	callq	____chkstk_darwin
	addq	$15, %rax
	andq	$-16, %rax
	subq	%rax, %rsp
	movq	%rsp, %r12
	movl	$1, %edx
	movq	%r12, %rdi
	movq	%r15, %rsi
	movq	%r14, %rcx
	callq	_fread
	movq	%rbx, %rdi
	movq	%r12, %rsi
	callq	_read_translation_unit_bytes
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	cmpq	-40(%rbp), %rax
	jne	LBB136_2
## %bb.1:
	movq	%rbx, %rax
	leaq	-32(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
LBB136_2:
	callq	___stack_chk_fail
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opc_util_irq_svc_set
_opc_util_irq_svc_set:                  ## @opc_util_irq_svc_set
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	8(%rdi), %rax
	movq	%rax, _svc_table(%rip)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opc_util_malloc
_opc_util_malloc:                       ## @opc_util_malloc
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%rbx
	pushq	%rax
	.cfi_offset %rbx, -24
	movq	%rdi, %rbx
	movq	8(%rdi), %rdi
	callq	_malloc
	movq	%rax, (%rbx)
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function opc_util_print_char
_opc_util_print_char:                   ## @opc_util_print_char
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movzbl	8(%rdi), %eax
	movb	%al, -2(%rbp)
	movb	$0, -1(%rbp)
	movl	16(%rdi), %edi
	leaq	-2(%rbp), %rsi
	movl	$1, %edx
	callq	_write
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_svc_table                      ## @svc_table
.zerofill __DATA,__common,_svc_table,8,3
	.section	__DATA,__data
	.globl	_opc_0                          ## @opc_0
	.p2align	4, 0x0
_opc_0:
	.quad	_opcode_nop$0
	.quad	_opcode_halt$0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	_opcode_pshi$0
	.quad	_opcode_ret$0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	_opcode_irq$0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	_opcode_svc$0
	.space	32416

	.globl	_opc_1                          ## @opc_1
	.p2align	4, 0x0
_opc_1:
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	_opcode_cmpz$1
	.quad	_opcode_b$1
	.quad	_opcode_bne$1
	.quad	_opcode_beq$1
	.quad	_opcode_bgt$1
	.quad	_opcode_blt$1
	.quad	_opcode_bge$1
	.quad	_opcode_ble$1
	.quad	_opcode_bnz$1
	.quad	_opcode_bz$1
	.quad	0
	.quad	0
	.quad	_opcode_psh$1
	.quad	_opcode_pp$1
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	_opcode_not$1
	.quad	_opcode_inc$1
	.quad	_opcode_dec$1
	.quad	0
	.quad	0
	.quad	_opcode_bl$1
	.quad	_opcode_blne$1
	.quad	_opcode_bleq$1
	.quad	_opcode_blgt$1
	.quad	_opcode_bllt$1
	.quad	_opcode_blge$1
	.quad	_opcode_blle$1
	.quad	_opcode_blnz$1
	.quad	_opcode_blz$1
	.space	32424

	.globl	_opc_2                          ## @opc_2
	.p2align	4, 0x0
_opc_2:
	.quad	0
	.quad	0
	.quad	_opcode_ldr$2
	.quad	_opcode_str$2
	.quad	_opcode_cmp$2
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	_opcode_psh$2
	.quad	0
	.quad	_opcode_add$2
	.quad	_opcode_sub$2
	.quad	_opcode_mul$2
	.quad	_opcode_div$2
	.quad	_opcode_mod$2
	.quad	_opcode_and$2
	.quad	_opcode_or$2
	.quad	_opcode_xor$2
	.quad	_opcode_shl$2
	.quad	_opcode_shr$2
	.space	32536

	.globl	_opc_3                          ## @opc_3
	.p2align	4, 0x0
_opc_3:
	.quad	0
	.quad	0
	.quad	_opcode_ldr$3
	.quad	_opcode_str$3
	.quad	_opcode_cmp$3
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	_opcode_add$3
	.quad	_opcode_sub$3
	.quad	_opcode_mul$3
	.quad	_opcode_div$3
	.quad	_opcode_mod$3
	.quad	_opcode_and$3
	.quad	_opcode_or$3
	.quad	_opcode_xor$3
	.quad	_opcode_shl$3
	.quad	_opcode_shr$3
	.space	32536

	.globl	_opc_4                          ## @opc_4
	.p2align	4, 0x0
_opc_4:
	.quad	0
	.quad	0
	.quad	_opcode_ldr$4
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	_opcode_mov$4
	.space	32496

	.globl	_opc_5                          ## @opc_5
	.p2align	4, 0x0
_opc_5:
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	_opcode_add$5
	.quad	_opcode_sub$5
	.quad	_opcode_mul$5
	.quad	_opcode_div$5
	.quad	_opcode_mod$5
	.quad	_opcode_and$5
	.quad	_opcode_or$5
	.quad	_opcode_xor$5
	.quad	_opcode_shl$5
	.quad	_opcode_shr$5
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	_opcode_mov$5
	.space	32496

	.globl	_opc_6                          ## @opc_6
.zerofill __DATA,__common,_opc_6,32768,4
	.globl	_opc_7                          ## @opc_7
.zerofill __DATA,__common,_opc_7,32768,4
	.globl	_opc_8                          ## @opc_8
	.p2align	4, 0x0
_opc_8:
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	_opcode_b$8
	.quad	_opcode_bne$8
	.quad	_opcode_beq$8
	.quad	_opcode_bgt$8
	.quad	_opcode_blt$8
	.quad	_opcode_bge$8
	.quad	_opcode_ble$8
	.quad	_opcode_bnz$8
	.quad	_opcode_bz$8
	.quad	0
	.quad	0
	.quad	_opcode_psh$8
	.quad	_opcode_pp$8
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	_opcode_mov$8
	.quad	_opcode_bl$8
	.quad	_opcode_blne$8
	.quad	_opcode_bleq$8
	.quad	_opcode_blgt$8
	.quad	_opcode_bllt$8
	.quad	_opcode_blge$8
	.quad	_opcode_blle$8
	.quad	_opcode_blnz$8
	.quad	_opcode_blz$8
	.space	32424

	.globl	_opc_9                          ## @opc_9
	.p2align	4, 0x0
_opc_9:
	.quad	0
	.quad	0
	.quad	_opcode_ldr$9
	.quad	_opcode_str$9
	.quad	_opcode_cmp$9
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	_opcode_add$9
	.quad	_opcode_sub$9
	.quad	_opcode_mul$9
	.quad	_opcode_div$9
	.quad	_opcode_mod$9
	.quad	_opcode_and$9
	.quad	_opcode_or$9
	.quad	_opcode_xor$9
	.quad	_opcode_shl$9
	.quad	_opcode_shr$9
	.space	32536

	.globl	_opc_10                         ## @opc_10
	.p2align	4, 0x0
_opc_10:
	.quad	0
	.quad	0
	.quad	_opcode_ldr$10
	.space	32744

	.globl	_opc_11                         ## @opc_11
	.p2align	4, 0x0
_opc_11:
	.quad	0
	.quad	0
	.quad	_opcode_ldr$11
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	_opcode_add$11
	.quad	_opcode_sub$11
	.quad	_opcode_mul$11
	.quad	_opcode_div$11
	.quad	_opcode_mod$11
	.quad	_opcode_and$11
	.quad	_opcode_or$11
	.quad	_opcode_xor$11
	.quad	_opcode_shl$11
	.quad	_opcode_shr$11
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	_opcode_mov$11
	.space	32496

	.globl	_opc_12                         ## @opc_12
	.p2align	4, 0x0
_opc_12:
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	_opcode_add$12
	.quad	_opcode_sub$12
	.quad	_opcode_mul$12
	.quad	_opcode_div$12
	.quad	_opcode_mod$12
	.quad	_opcode_and$12
	.quad	_opcode_or$12
	.quad	_opcode_xor$12
	.quad	_opcode_shl$12
	.quad	_opcode_shr$12
	.space	32536

	.globl	_opc_13                         ## @opc_13
.zerofill __DATA,__common,_opc_13,32768,4
	.globl	_opc_14                         ## @opc_14
.zerofill __DATA,__common,_opc_14,32768,4
	.globl	_opc_15                         ## @opc_15
.zerofill __DATA,__common,_opc_15,32768,4
	.section	__DATA,__const
	.p2align	4, 0x0                          ## @funcs
_funcs:
	.quad	_opc_0
	.quad	_opc_1
	.quad	_opc_2
	.quad	_opc_3
	.quad	_opc_4
	.quad	_opc_5
	.quad	_opc_6
	.quad	_opc_7
	.quad	_opc_8
	.quad	_opc_9
	.quad	_opc_10
	.quad	_opc_11
	.quad	_opc_12
	.quad	_opc_13
	.quad	_opc_14
	.quad	_opc_15

	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"%s at %p\n"

L_.str.1:                               ## @.str.1
	.asciz	"Failed to find symbol %s\n"

L_.str.2:                               ## @.str.2
	.asciz	"RELOCATE"

	.section	__DATA,__data
	.p2align	3, 0x0                          ## @main.act
_main.act:
	.quad	_sig_handler
	.long	1594                            ## 0x63a
	.long	64                              ## 0x40

	.section	__TEXT,__cstring,cstring_literals
L_.str.3:                               ## @.str.3
	.asciz	"Failed to set up signal handler\n"

L_.str.4:                               ## @.str.4
	.asciz	"Error: %s (%d)\n"

L_.str.5:                               ## @.str.5
	.asciz	"Usage: %s run <objfile>\n"

L_.str.6:                               ## @.str.6
	.asciz	"       %s comp <srcfile> <objfile>\n"

L_.str.7:                               ## @.str.7
	.asciz	"comp"

L_.str.8:                               ## @.str.8
	.asciz	"Usage: %s comp <srcfile> <objfile>\n"

L_.str.9:                               ## @.str.9
	.asciz	"wb"

L_.str.10:                              ## @.str.10
	.asciz	"run"

L_.str.11:                              ## @.str.11
	.asciz	"rb"

L_.str.12:                              ## @.str.12
	.asciz	"Could not open file '%s'\n"

	.section	__DATA,__data
	.p2align	4, 0x0                          ## @kernel
_kernel:
	.asciz	"\316\372\355\376\001\000\000\000\000\000\000\000\001\000\000\000\002\000\000\000RELOCATE\000\000\000\000\000\000\000\000\220\000\000\000\007\000\000\000\000\000\000\000\036\000\000\000\000\000\000\000\024\000\000\000\000\000\000\000\310\000\000\000\000\000\000\200\036\000\000\000\000\000\000\000^\000\000\000\000\000\000\000&\000\000\000\000\000\000\000d\000\000\000\000\000\000\000.\000\000\000\000\000\000\000\302\000\000\000\000\000\000\0006\000\000\000\000\000\000\000\304\000\000\000\000\000\000\000>\000\000\000\000\000\000\000\306\000\000\000\000\000\000\000\212\000\000\000\000\000\000\000\256\000\000\000\000\000\000\000\246\000\000\000\000\000\000\000~\000\000\000\000\000\000\000\001\000\027\000\310\000\000\000\000\000\000\000\0020\001\000\000\002\220\001\000\000\000\000\000\000\000\001 \000\"\200\t\000\000\000\000\000\000\000\001\000\002\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\006\000\000\000\000\000\000\000\007\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\002 \000\001\001\000\021\020\000\021\020\001\021\020\002\021\020\017\021\020\020\021\020\021\002 \017\002\002 \021\001!P\000\000\020\001\017\005\020\020\016\200\005\000\000\000\000\000\000\000\0020\016\000\000\002 \001\020\002 \002\021 \000\036\020\017\006\200\004\000\000\000\000\000\000\000\022\020\021\022\020\020\022\020\017\022\020\002\022\020\001\022\020\000\020\000\020\000\020\000\020\000\002\000!\0000\001\000\000\000\000\000\000\n\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000_start\000\036\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000syscall.branchtable\000^\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000syscall.exit\000d\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000syscall.write\000~\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000syscall.write_loop\000\256\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000syscall.write_end\000\302\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000syscall.read\000\304\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000syscall.open\000\306\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000syscall.close\000\310\000\000\000\000\000\000\200\000\000\000\000\000\000\000\000main"

	.section	__TEXT,__cstring,cstring_literals
L_.str.13:                              ## @.str.13
	.asciz	"_start"

L_.str.14:                              ## @.str.14
	.asciz	"Could not find _start symbol\n"

L_.str.15:                              ## @.str.15
	.asciz	"Unknown command '%s'\n"

	.section	__DATA,__const
	.p2align	4, 0x0                          ## @irq_table
_irq_table:
	.quad	0
	.quad	_opc_util_irq_svc_set
	.quad	0
	.quad	_opc_util_malloc
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	_opc_util_print_char
	.space	1928

	.section	__TEXT,__cstring,cstring_literals
L_.str.17:                              ## @.str.17
	.asciz	"Unknown instruction argument type %d in instruction %01x %03x\n"

L_.str.18:                              ## @.str.18
	.asciz	"Invalid object file magic: %08x\n"

L_.str.19:                              ## @.str.19
	.asciz	"Invalid object file version. Expected: %d, got: %d\n"

L_.str.20:                              ## @.str.20
	.asciz	"Failed to allocate %lu bytes aligned to %lu bytes: %s\n"

.subsections_via_symbols
