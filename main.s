	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 14, 0
	.p2align	2                               ; -- Begin function opcode_nop$0
_opcode_nop$0:                          ; @"opcode_nop$0"
	.cfi_startproc
; %bb.0:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_halt$0
_opcode_halt$0:                         ; @"opcode_halt$0"
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x8, [x0]
	ldr	w0, [x8]
	bl	_exit
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_pshi$0
_opcode_pshi$0:                         ; @"opcode_pshi$0"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #216]
	ldr	x8, [x8]
	ldr	x9, [x0, #232]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_ret$0
_opcode_ret$0:                          ; @"opcode_ret$0"
	.cfi_startproc
; %bb.0:
	ldp	x9, x8, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
	ldr	x8, [x0, #232]
	ldr	x9, [x8]
	sub	x10, x9, #8
	str	x10, [x8]
	ldur	x8, [x9, #-8]
	ldr	x9, [x0, #224]
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_irq$0
_opcode_irq$0:                          ; @"opcode_irq$0"
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x20, x19, [sp, #16]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	ldr	x19, [x0]
	ldr	x8, [x19]
	cmp	x8, #14
	b.eq	LBB4_4
; %bb.1:
	cmp	x8, #3
	b.eq	LBB4_5
; %bb.2:
	cmp	x8, #1
	b.ne	LBB4_6
; %bb.3:
	ldr	x8, [x0, #8]
	ldr	x8, [x8]
	adrp	x9, _svc_table@PAGE
	str	x8, [x9, _svc_table@PAGEOFF]
	b	LBB4_6
LBB4_4:
	ldp	x8, x9, [x0, #8]
	ldr	x8, [x8]
	strb	w8, [sp, #14]
	strb	wzr, [sp, #15]
	ldr	w0, [x9]
	add	x1, sp, #14
	mov	w2, #1
	bl	_write
	b	LBB4_6
LBB4_5:
	ldr	x8, [x0, #8]
	ldr	x0, [x8]
	bl	_malloc
	str	x0, [x19]
LBB4_6:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_svc$0
_opcode_svc$0:                          ; @"opcode_svc$0"
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0, #224]
	ldr	x8, [x8]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ldp	x8, x9, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
Lloh0:
	adrp	x8, _svc_table@PAGE
Lloh1:
	ldr	x8, [x8, _svc_table@PAGEOFF]
	ldr	x9, [x0]
	ldr	x9, [x9]
	ldr	x8, [x8, x9, lsl  #3]
	ldr	x9, [x0, #216]
	str	x8, [x9]
	ret
	.loh AdrpLdr	Lloh0, Lloh1
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_cmpz$1
_opcode_cmpz$1:                         ; @"opcode_cmpz$1"
	.cfi_startproc
; %bb.0:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	cmp	x8, #0
	cset	w8, eq
	ldr	x9, [x0, #248]
	ldrb	w10, [x9]
	and	w10, w10, #0xfe
	orr	w8, w10, w8
	strb	w8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_b$1
_opcode_b$1:                            ; @"opcode_b$1"
	.cfi_startproc
; %bb.0:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #216]
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_bne$1
_opcode_bne$1:                          ; @"opcode_bne$1"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbnz	w8, #4, LBB8_2
; %bb.1:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #216]
	str	x8, [x9]
LBB8_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_beq$1
_opcode_beq$1:                          ; @"opcode_beq$1"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbz	w8, #4, LBB9_2
; %bb.1:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #216]
	str	x8, [x9]
LBB9_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_bgt$1
_opcode_bgt$1:                          ; @"opcode_bgt$1"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbz	w8, #2, LBB10_2
; %bb.1:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #216]
	str	x8, [x9]
LBB10_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_blt$1
_opcode_blt$1:                          ; @"opcode_blt$1"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbz	w8, #3, LBB11_2
; %bb.1:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #216]
	str	x8, [x9]
LBB11_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_bge$1
_opcode_bge$1:                          ; @"opcode_bge$1"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	mov	w9, #20
	tst	w8, w9
	b.eq	LBB12_2
; %bb.1:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #216]
	str	x8, [x9]
LBB12_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_ble$1
_opcode_ble$1:                          ; @"opcode_ble$1"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tst	w8, #0x18
	b.eq	LBB13_2
; %bb.1:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #216]
	str	x8, [x9]
LBB13_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_bnz$1
_opcode_bnz$1:                          ; @"opcode_bnz$1"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbnz	w8, #0, LBB14_2
; %bb.1:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #216]
	str	x8, [x9]
LBB14_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_bz$1
_opcode_bz$1:                           ; @"opcode_bz$1"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbz	w8, #0, LBB15_2
; %bb.1:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #216]
	str	x8, [x9]
LBB15_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_psh$1
_opcode_psh$1:                          ; @"opcode_psh$1"
	.cfi_startproc
; %bb.0:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #232]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_pp$1
_opcode_pp$1:                           ; @"opcode_pp$1"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #232]
	ldr	x9, [x8]
	sub	x10, x9, #8
	str	x10, [x8]
	ldur	x8, [x9, #-8]
	and	x9, x1, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_not$1
_opcode_not$1:                          ; @"opcode_not$1"
	.cfi_startproc
; %bb.0:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x9, [x8]
	mvn	x9, x9
	str	x9, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_inc$1
_opcode_inc$1:                          ; @"opcode_inc$1"
	.cfi_startproc
; %bb.0:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x9, [x8]
	add	x9, x9, #1
	str	x9, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_dec$1
_opcode_dec$1:                          ; @"opcode_dec$1"
	.cfi_startproc
; %bb.0:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x9, [x8]
	sub	x9, x9, #1
	str	x9, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_bl$1
_opcode_bl$1:                           ; @"opcode_bl$1"
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0, #224]
	ldr	x8, [x8]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ldp	x8, x9, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #216]
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_blne$1
_opcode_blne$1:                         ; @"opcode_blne$1"
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0, #224]
	ldr	x8, [x8]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ldp	x8, x9, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbnz	w8, #4, LBB22_2
; %bb.1:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #216]
	str	x8, [x9]
LBB22_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_bleq$1
_opcode_bleq$1:                         ; @"opcode_bleq$1"
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0, #224]
	ldr	x8, [x8]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ldp	x8, x9, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbz	w8, #4, LBB23_2
; %bb.1:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #216]
	str	x8, [x9]
LBB23_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_blgt$1
_opcode_blgt$1:                         ; @"opcode_blgt$1"
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0, #224]
	ldr	x8, [x8]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ldp	x8, x9, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbz	w8, #2, LBB24_2
; %bb.1:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #216]
	str	x8, [x9]
LBB24_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_bllt$1
_opcode_bllt$1:                         ; @"opcode_bllt$1"
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0, #224]
	ldr	x8, [x8]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ldp	x8, x9, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbz	w8, #3, LBB25_2
; %bb.1:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #216]
	str	x8, [x9]
LBB25_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_blge$1
_opcode_blge$1:                         ; @"opcode_blge$1"
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0, #224]
	ldr	x8, [x8]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ldp	x8, x9, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	mov	w9, #20
	tst	w8, w9
	b.eq	LBB26_2
; %bb.1:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #216]
	str	x8, [x9]
LBB26_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_blle$1
_opcode_blle$1:                         ; @"opcode_blle$1"
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0, #224]
	ldr	x8, [x8]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ldp	x8, x9, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tst	w8, #0x18
	b.eq	LBB27_2
; %bb.1:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #216]
	str	x8, [x9]
LBB27_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_blnz$1
_opcode_blnz$1:                         ; @"opcode_blnz$1"
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0, #224]
	ldr	x8, [x8]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ldp	x8, x9, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbnz	w8, #0, LBB28_2
; %bb.1:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #216]
	str	x8, [x9]
LBB28_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_blz$1
_opcode_blz$1:                          ; @"opcode_blz$1"
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0, #224]
	ldr	x8, [x8]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ldp	x8, x9, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbz	w8, #0, LBB29_2
; %bb.1:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #216]
	str	x8, [x9]
LBB29_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_ldr$2
_opcode_ldr$2:                          ; @"opcode_ldr$2"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #8, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	and	x9, x1, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_str$2
_opcode_str$2:                          ; @"opcode_str$2"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #8, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	and	x9, x1, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x9, [x9]
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_cmp$2
_opcode_cmp$2:                          ; @"opcode_cmp$2"
	.cfi_startproc
; %bb.0:
	and	x8, x1, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ubfx	x9, x1, #8, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x9, [x9]
	ldr	x10, [x0, #248]
	strb	wzr, [x10]
	cmp	x8, x9
	b.ne	LBB32_2
; %bb.1:
	mov	w9, #16
	b	LBB32_6
LBB32_2:
	b.le	LBB32_4
; %bb.3:
	mov	w9, #4
	b	LBB32_6
LBB32_4:
	cmp	x8, x9
	b.ge	LBB32_7
; %bb.5:
	mov	w9, #8
LBB32_6:
	ldr	x10, [x0, #248]
	ldrb	w11, [x10]
	orr	w9, w11, w9
	strb	w9, [x10]
LBB32_7:
	cbz	x8, LBB32_10
; %bb.8:
	tbnz	x8, #63, LBB32_11
; %bb.9:
	ret
LBB32_10:
	mov	w8, #1
	b	LBB32_12
LBB32_11:
	mov	w8, #2
LBB32_12:
	ldr	x9, [x0, #248]
	ldrb	w10, [x9]
	orr	w8, w10, w8
	strb	w8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_psh$2
_opcode_psh$2:                          ; @"opcode_psh$2"
	.cfi_startproc
; %bb.0:
	sxth	x8, w1
	ldr	x9, [x0, #232]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_add$2
_opcode_add$2:                          ; @"opcode_add$2"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #8, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	and	x9, x1, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	add	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_sub$2
_opcode_sub$2:                          ; @"opcode_sub$2"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #8, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	and	x9, x1, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	sub	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_mul$2
_opcode_mul$2:                          ; @"opcode_mul$2"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #8, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	and	x9, x1, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	mul	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_div$2
_opcode_div$2:                          ; @"opcode_div$2"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #8, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	and	x9, x1, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	udiv	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_mod$2
_opcode_mod$2:                          ; @"opcode_mod$2"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #8, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	and	x9, x1, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	udiv	x11, x10, x8
	msub	x8, x11, x8, x10
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_and$2
_opcode_and$2:                          ; @"opcode_and$2"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #8, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	and	x9, x1, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	and	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_or$2
_opcode_or$2:                           ; @"opcode_or$2"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #8, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	and	x9, x1, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	orr	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_xor$2
_opcode_xor$2:                          ; @"opcode_xor$2"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #8, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	and	x9, x1, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	eor	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_shl$2
_opcode_shl$2:                          ; @"opcode_shl$2"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #8, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	and	x9, x1, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	lsl	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_shr$2
_opcode_shr$2:                          ; @"opcode_shr$2"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #8, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	and	x9, x1, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	lsr	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_ldr$3
_opcode_ldr$3:                          ; @"opcode_ldr$3"
	.cfi_startproc
; %bb.0:
	sxth	x8, w1
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_str$3
_opcode_str$3:                          ; @"opcode_str$3"
	.cfi_startproc
; %bb.0:
	sxth	x8, w1
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x9, [x9]
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_cmp$3
_opcode_cmp$3:                          ; @"opcode_cmp$3"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #16, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	sxth	x9, w1
	ldr	x10, [x0, #248]
	strb	wzr, [x10]
	cmp	x8, x9
	b.ne	LBB46_2
; %bb.1:
	mov	w9, #16
	b	LBB46_6
LBB46_2:
	b.le	LBB46_4
; %bb.3:
	mov	w9, #4
	b	LBB46_6
LBB46_4:
	cmp	x8, x9
	b.ge	LBB46_7
; %bb.5:
	mov	w9, #8
LBB46_6:
	ldr	x10, [x0, #248]
	ldrb	w11, [x10]
	orr	w9, w11, w9
	strb	w9, [x10]
LBB46_7:
	cbz	x8, LBB46_10
; %bb.8:
	tbnz	x8, #63, LBB46_11
; %bb.9:
	ret
LBB46_10:
	mov	w8, #1
	b	LBB46_12
LBB46_11:
	mov	w8, #2
LBB46_12:
	ldr	x9, [x0, #248]
	ldrb	w10, [x9]
	orr	w8, w10, w8
	strb	w8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_add$3
_opcode_add$3:                          ; @"opcode_add$3"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #16, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x9, [x8]
	add	x9, x9, w1, sxth
	str	x9, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_sub$3
_opcode_sub$3:                          ; @"opcode_sub$3"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #16, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x9, [x8]
	sub	x9, x9, w1, sxth
	str	x9, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_mul$3
_opcode_mul$3:                          ; @"opcode_mul$3"
	.cfi_startproc
; %bb.0:
	sxth	x8, w1
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	mul	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_div$3
_opcode_div$3:                          ; @"opcode_div$3"
	.cfi_startproc
; %bb.0:
	sxth	x8, w1
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	udiv	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_mod$3
_opcode_mod$3:                          ; @"opcode_mod$3"
	.cfi_startproc
; %bb.0:
	sxth	x8, w1
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	udiv	x11, x10, x8
	msub	x8, x11, x8, x10
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_and$3
_opcode_and$3:                          ; @"opcode_and$3"
	.cfi_startproc
; %bb.0:
	sxth	x8, w1
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	and	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_or$3
_opcode_or$3:                           ; @"opcode_or$3"
	.cfi_startproc
; %bb.0:
	sxth	x8, w1
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	orr	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_xor$3
_opcode_xor$3:                          ; @"opcode_xor$3"
	.cfi_startproc
; %bb.0:
	sxth	x8, w1
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	eor	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_shl$3
_opcode_shl$3:                          ; @"opcode_shl$3"
	.cfi_startproc
; %bb.0:
	sxth	w8, w1
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	lsl	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_shr$3
_opcode_shr$3:                          ; @"opcode_shr$3"
	.cfi_startproc
; %bb.0:
	sxth	w8, w1
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	lsr	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_ldr$4
_opcode_ldr$4:                          ; @"opcode_ldr$4"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #8, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	asr	w9, w1, #16
	ldr	x8, [x8, w9, sxtw]
	and	x9, x1, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_mov$4
_opcode_mov$4:                          ; @"opcode_mov$4"
	.cfi_startproc
; %bb.0:
	ubfx	w11, w1, #8, #8
	cbz	w11, LBB58_3
; %bb.1:
	mov	x8, #0
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x9, [x9]
	ubfx	x10, x1, #24, #8
	ldr	x10, [x0, x10, lsl  #3]
	ldr	x10, [x10]
	add	x9, x9, x10
	and	x10, x1, #0xff
	ubfiz	x11, x11, #3, #32
LBB58_2:                                ; =>This Inner Loop Header: Depth=1
	ldrb	w12, [x9], #1
	lsl	w12, w12, w8
	ldr	x13, [x0, x10, lsl  #3]
	sxtw	x12, w12
	ldr	x14, [x13]
	orr	x12, x14, x12
	str	x12, [x13]
	add	x8, x8, #8
	cmp	x11, x8
	b.ne	LBB58_2
LBB58_3:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_add$5
_opcode_add$5:                          ; @"opcode_add$5"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #32, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	sxth	w9, w1
	ldrb	w8, [x8, w9, sxtw]
	lsr	x9, x1, #21
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	add	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_sub$5
_opcode_sub$5:                          ; @"opcode_sub$5"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #32, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	sxth	w9, w1
	ldrb	w8, [x8, w9, sxtw]
	lsr	x9, x1, #21
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	sub	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_mul$5
_opcode_mul$5:                          ; @"opcode_mul$5"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #32, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	sxth	w9, w1
	ldrb	w8, [x8, w9, sxtw]
	lsr	x9, x1, #21
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	mul	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_div$5
_opcode_div$5:                          ; @"opcode_div$5"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #32, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	sxth	w9, w1
	ldrb	w8, [x8, w9, sxtw]
	lsr	x9, x1, #21
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	udiv	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_mod$5
_opcode_mod$5:                          ; @"opcode_mod$5"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #32, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	sxth	w9, w1
	ldrb	w8, [x8, w9, sxtw]
	lsr	x9, x1, #21
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	udiv	x11, x10, x8
	msub	x8, x11, x8, x10
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_and$5
_opcode_and$5:                          ; @"opcode_and$5"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #32, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	sxth	w9, w1
	ldrb	w8, [x8, w9, sxtw]
	lsr	x9, x1, #21
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	and	x8, x8, x10
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_or$5
_opcode_or$5:                           ; @"opcode_or$5"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #32, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	sxth	w9, w1
	ldrb	w8, [x8, w9, sxtw]
	lsr	x9, x1, #21
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	orr	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_xor$5
_opcode_xor$5:                          ; @"opcode_xor$5"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #32, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	sxth	w9, w1
	ldrb	w8, [x8, w9, sxtw]
	lsr	x9, x1, #21
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	eor	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_shl$5
_opcode_shl$5:                          ; @"opcode_shl$5"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #32, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	sxth	w9, w1
	ldrb	w8, [x8, w9, sxtw]
	lsr	x9, x1, #21
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	lsl	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_shr$5
_opcode_shr$5:                          ; @"opcode_shr$5"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #32, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	sxth	w9, w1
	ldrb	w8, [x8, w9, sxtw]
	lsr	x9, x1, #21
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	lsr	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_mov$5
_opcode_mov$5:                          ; @"opcode_mov$5"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x1, #32, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	sxth	w9, w1
	ldrb	w8, [x8, w9, sxtw]
	lsr	x9, x1, #21
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	ubfx	x9, x1, #16, #8
	ldr	x9, [x0, x9, lsl  #3]
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_b$8
_opcode_b$8:                            ; @"opcode_b$8"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #216]
	str	x1, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_bne$8
_opcode_bne$8:                          ; @"opcode_bne$8"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbnz	w8, #4, LBB71_2
; %bb.1:
	ldr	x8, [x0, #216]
	str	x1, [x8]
LBB71_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_beq$8
_opcode_beq$8:                          ; @"opcode_beq$8"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbz	w8, #4, LBB72_2
; %bb.1:
	ldr	x8, [x0, #216]
	str	x1, [x8]
LBB72_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_bgt$8
_opcode_bgt$8:                          ; @"opcode_bgt$8"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbz	w8, #2, LBB73_2
; %bb.1:
	ldr	x8, [x0, #216]
	str	x1, [x8]
LBB73_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_blt$8
_opcode_blt$8:                          ; @"opcode_blt$8"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbz	w8, #3, LBB74_2
; %bb.1:
	ldr	x8, [x0, #216]
	str	x1, [x8]
LBB74_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_bge$8
_opcode_bge$8:                          ; @"opcode_bge$8"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	mov	w9, #20
	tst	w8, w9
	b.eq	LBB75_2
; %bb.1:
	ldr	x8, [x0, #216]
	str	x1, [x8]
LBB75_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_ble$8
_opcode_ble$8:                          ; @"opcode_ble$8"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tst	w8, #0x18
	b.eq	LBB76_2
; %bb.1:
	ldr	x8, [x0, #216]
	str	x1, [x8]
LBB76_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_bnz$8
_opcode_bnz$8:                          ; @"opcode_bnz$8"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbnz	w8, #0, LBB77_2
; %bb.1:
	ldr	x8, [x0, #216]
	str	x1, [x8]
LBB77_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_bz$8
_opcode_bz$8:                           ; @"opcode_bz$8"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbz	w8, #0, LBB78_2
; %bb.1:
	ldr	x8, [x0, #216]
	str	x1, [x8]
LBB78_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_psh$8
_opcode_psh$8:                          ; @"opcode_psh$8"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #232]
	ldr	x9, [x8]
	add	x10, x9, #8
	str	x10, [x8]
	str	x1, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_pp$8
_opcode_pp$8:                           ; @"opcode_pp$8"
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #232]
	ldr	x9, [x8]
	sub	x10, x9, #8
	str	x10, [x8]
	ldur	x8, [x9, #-8]
	str	x8, [x1]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_mov$8
_opcode_mov$8:                          ; @"opcode_mov$8"
	.cfi_startproc
; %bb.0:
	extr	x8, x2, x1, #32
	asr	x8, x8, #48
	ldr	x8, [x8, x1]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_bl$8
_opcode_bl$8:                           ; @"opcode_bl$8"
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0, #224]
	ldr	x8, [x8]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ldp	x8, x9, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
	ldr	x8, [x0, #216]
	str	x1, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_blne$8
_opcode_blne$8:                         ; @"opcode_blne$8"
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0, #224]
	ldr	x8, [x8]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ldp	x8, x9, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbnz	w8, #4, LBB83_2
; %bb.1:
	ldr	x8, [x0, #216]
	str	x1, [x8]
LBB83_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_bleq$8
_opcode_bleq$8:                         ; @"opcode_bleq$8"
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0, #224]
	ldr	x8, [x8]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ldp	x8, x9, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbz	w8, #4, LBB84_2
; %bb.1:
	ldr	x8, [x0, #216]
	str	x1, [x8]
LBB84_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_blgt$8
_opcode_blgt$8:                         ; @"opcode_blgt$8"
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0, #224]
	ldr	x8, [x8]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ldp	x8, x9, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbz	w8, #2, LBB85_2
; %bb.1:
	ldr	x8, [x0, #216]
	str	x1, [x8]
LBB85_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_bllt$8
_opcode_bllt$8:                         ; @"opcode_bllt$8"
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0, #224]
	ldr	x8, [x8]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ldp	x8, x9, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbz	w8, #3, LBB86_2
; %bb.1:
	ldr	x8, [x0, #216]
	str	x1, [x8]
LBB86_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_blge$8
_opcode_blge$8:                         ; @"opcode_blge$8"
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0, #224]
	ldr	x8, [x8]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ldp	x8, x9, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	mov	w9, #20
	tst	w8, w9
	b.eq	LBB87_2
; %bb.1:
	ldr	x8, [x0, #216]
	str	x1, [x8]
LBB87_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_blle$8
_opcode_blle$8:                         ; @"opcode_blle$8"
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0, #224]
	ldr	x8, [x8]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ldp	x8, x9, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tst	w8, #0x18
	b.eq	LBB88_2
; %bb.1:
	ldr	x8, [x0, #216]
	str	x1, [x8]
LBB88_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_blnz$8
_opcode_blnz$8:                         ; @"opcode_blnz$8"
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0, #224]
	ldr	x8, [x8]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ldp	x8, x9, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbnz	w8, #0, LBB89_2
; %bb.1:
	ldr	x8, [x0, #216]
	str	x1, [x8]
LBB89_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_blz$8
_opcode_blz$8:                          ; @"opcode_blz$8"
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0, #224]
	ldr	x8, [x8]
	ldr	x10, [x9]
	add	x11, x10, #8
	str	x11, [x9]
	str	x8, [x10]
	ldp	x8, x9, [x0, #216]
	ldr	x8, [x8]
	str	x8, [x9]
	ldr	x8, [x0, #248]
	ldrb	w8, [x8]
	tbz	w8, #0, LBB90_2
; %bb.1:
	ldr	x8, [x0, #216]
	str	x1, [x8]
LBB90_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_ldr$9
_opcode_ldr$9:                          ; @"opcode_ldr$9"
	.cfi_startproc
; %bb.0:
	and	x8, x2, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	str	x1, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_str$9
_opcode_str$9:                          ; @"opcode_str$9"
	.cfi_startproc
; %bb.0:
	and	x8, x2, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	str	x1, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_cmp$9
_opcode_cmp$9:                          ; @"opcode_cmp$9"
	.cfi_startproc
; %bb.0:
	and	x8, x2, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x9, [x0, #248]
	strb	wzr, [x9]
	cmp	x8, x1
	b.ne	LBB93_2
; %bb.1:
	mov	w9, #16
	b	LBB93_6
LBB93_2:
	b.le	LBB93_4
; %bb.3:
	mov	w9, #4
	b	LBB93_6
LBB93_4:
	cmp	x8, x1
	b.ge	LBB93_7
; %bb.5:
	mov	w9, #8
LBB93_6:
	ldr	x10, [x0, #248]
	ldrb	w11, [x10]
	orr	w9, w11, w9
	strb	w9, [x10]
LBB93_7:
	cbz	x8, LBB93_10
; %bb.8:
	tbnz	x8, #63, LBB93_11
; %bb.9:
	ret
LBB93_10:
	mov	w8, #1
	b	LBB93_12
LBB93_11:
	mov	w8, #2
LBB93_12:
	ldr	x9, [x0, #248]
	ldrb	w10, [x9]
	orr	w8, w10, w8
	strb	w8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_add$9
_opcode_add$9:                          ; @"opcode_add$9"
	.cfi_startproc
; %bb.0:
	and	x8, x2, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x9, [x8]
	add	x9, x9, x1
	str	x9, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_sub$9
_opcode_sub$9:                          ; @"opcode_sub$9"
	.cfi_startproc
; %bb.0:
	and	x8, x2, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x9, [x8]
	sub	x9, x9, x1
	str	x9, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_mul$9
_opcode_mul$9:                          ; @"opcode_mul$9"
	.cfi_startproc
; %bb.0:
	and	x8, x2, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x9, [x8]
	mul	x9, x9, x1
	str	x9, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_div$9
_opcode_div$9:                          ; @"opcode_div$9"
	.cfi_startproc
; %bb.0:
	and	x8, x2, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x9, [x8]
	udiv	x9, x9, x1
	str	x9, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_mod$9
_opcode_mod$9:                          ; @"opcode_mod$9"
	.cfi_startproc
; %bb.0:
	and	x8, x2, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x9, [x8]
	udiv	x10, x9, x1
	msub	x9, x10, x1, x9
	str	x9, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_and$9
_opcode_and$9:                          ; @"opcode_and$9"
	.cfi_startproc
; %bb.0:
	and	x8, x2, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x9, [x8]
	and	x9, x9, x1
	str	x9, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_or$9
_opcode_or$9:                           ; @"opcode_or$9"
	.cfi_startproc
; %bb.0:
	and	x8, x2, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x9, [x8]
	orr	x9, x9, x1
	str	x9, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_xor$9
_opcode_xor$9:                          ; @"opcode_xor$9"
	.cfi_startproc
; %bb.0:
	and	x8, x2, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x9, [x8]
	eor	x9, x9, x1
	str	x9, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_shl$9
_opcode_shl$9:                          ; @"opcode_shl$9"
	.cfi_startproc
; %bb.0:
	and	x8, x2, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x9, [x8]
	lsl	x9, x9, x1
	str	x9, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_shr$9
_opcode_shr$9:                          ; @"opcode_shr$9"
	.cfi_startproc
; %bb.0:
	and	x8, x2, #0xff
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x9, [x8]
	lsr	x9, x9, x1
	str	x9, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_ldr$10
_opcode_ldr$10:                         ; @"opcode_ldr$10"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x2, #8, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x8, [x8, x1]
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_ldr$11
_opcode_ldr$11:                         ; @"opcode_ldr$11"
	.cfi_startproc
; %bb.0:
	extr	x8, x2, x1, #24
	asr	x8, x8, #48
	ldr	x8, [x8, x1]
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_add$11
_opcode_add$11:                         ; @"opcode_add$11"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x2, #16, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x8, [x1, x8, lsl  #3]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	add	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_sub$11
_opcode_sub$11:                         ; @"opcode_sub$11"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x2, #16, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x8, [x1, x8, lsl  #3]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	sub	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_mul$11
_opcode_mul$11:                         ; @"opcode_mul$11"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x2, #16, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x8, [x1, x8, lsl  #3]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	mul	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_div$11
_opcode_div$11:                         ; @"opcode_div$11"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x2, #16, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x8, [x1, x8, lsl  #3]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	udiv	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_mod$11
_opcode_mod$11:                         ; @"opcode_mod$11"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x2, #16, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x8, [x1, x8, lsl  #3]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	udiv	x11, x10, x8
	msub	x8, x11, x8, x10
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_and$11
_opcode_and$11:                         ; @"opcode_and$11"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x2, #16, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x8, [x1, x8, lsl  #3]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	and	x8, x8, x10
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_or$11
_opcode_or$11:                          ; @"opcode_or$11"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x2, #16, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x8, [x1, x8, lsl  #3]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	orr	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_xor$11
_opcode_xor$11:                         ; @"opcode_xor$11"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x2, #16, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x8, [x1, x8, lsl  #3]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	eor	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_shl$11
_opcode_shl$11:                         ; @"opcode_shl$11"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x2, #16, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x8, [x1, x8, lsl  #3]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	lsl	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_shr$11
_opcode_shr$11:                         ; @"opcode_shr$11"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x2, #16, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x8, [x1, x8, lsl  #3]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	lsr	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_mov$11
_opcode_mov$11:                         ; @"opcode_mov$11"
	.cfi_startproc
; %bb.0:
	ubfx	x8, x2, #16, #8
	ldr	x8, [x0, x8, lsl  #3]
	ldr	x8, [x8]
	ldr	x8, [x1, x8, lsl  #3]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_add$12
_opcode_add$12:                         ; @"opcode_add$12"
	.cfi_startproc
; %bb.0:
	extr	x8, x2, x1, #32
	asr	x8, x8, #48
	ldr	x8, [x8, x1]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	add	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_sub$12
_opcode_sub$12:                         ; @"opcode_sub$12"
	.cfi_startproc
; %bb.0:
	extr	x8, x2, x1, #32
	asr	x8, x8, #48
	ldr	x8, [x8, x1]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	sub	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_mul$12
_opcode_mul$12:                         ; @"opcode_mul$12"
	.cfi_startproc
; %bb.0:
	extr	x8, x2, x1, #32
	asr	x8, x8, #48
	ldr	x8, [x8, x1]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	mul	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_div$12
_opcode_div$12:                         ; @"opcode_div$12"
	.cfi_startproc
; %bb.0:
	extr	x8, x2, x1, #32
	asr	x8, x8, #48
	ldr	x8, [x8, x1]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	udiv	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_mod$12
_opcode_mod$12:                         ; @"opcode_mod$12"
	.cfi_startproc
; %bb.0:
	extr	x8, x2, x1, #32
	asr	x8, x8, #48
	ldr	x8, [x8, x1]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	udiv	x11, x10, x8
	msub	x8, x11, x8, x10
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_and$12
_opcode_and$12:                         ; @"opcode_and$12"
	.cfi_startproc
; %bb.0:
	extr	x8, x2, x1, #32
	asr	x8, x8, #48
	ldr	x8, [x8, x1]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	and	x8, x8, x10
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_or$12
_opcode_or$12:                          ; @"opcode_or$12"
	.cfi_startproc
; %bb.0:
	extr	x8, x2, x1, #32
	asr	x8, x8, #48
	ldr	x8, [x8, x1]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	orr	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_xor$12
_opcode_xor$12:                         ; @"opcode_xor$12"
	.cfi_startproc
; %bb.0:
	extr	x8, x2, x1, #32
	asr	x8, x8, #48
	ldr	x8, [x8, x1]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	eor	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_shl$12
_opcode_shl$12:                         ; @"opcode_shl$12"
	.cfi_startproc
; %bb.0:
	extr	x8, x2, x1, #32
	asr	x8, x8, #48
	ldr	x8, [x8, x1]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	lsl	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function opcode_shr$12
_opcode_shr$12:                         ; @"opcode_shr$12"
	.cfi_startproc
; %bb.0:
	extr	x8, x2, x1, #32
	asr	x8, x8, #48
	ldr	x8, [x8, x1]
	lsr	x9, x2, #5
	and	x9, x9, #0x7f8
	mov	x10, #-1
	lsl	x9, x10, x9
	bic	x8, x8, x9
	and	x9, x2, #0xff
	ldr	x9, [x0, x9, lsl  #3]
	ldr	x10, [x9]
	lsr	x8, x10, x8
	str	x8, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_add_symbol                     ; -- Begin function add_symbol
	.p2align	2
_add_symbol:                            ; @add_symbol
	.cfi_startproc
; %bb.0:
	stp	x22, x21, [sp, #-48]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 48
	stp	x20, x19, [sp, #16]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	mov	x19, x1
	mov	x20, x0
	ldr	x0, [x0, #88]
	ldrh	w8, [x20, #80]
	mov	w21, #24
	mov	x9, #24
	madd	x1, x8, x21, x9
	bl	_realloc
	str	x0, [x20, #88]
	ldrh	w8, [x20, #80]
	madd	x21, x8, x21, x0
	mov	x0, x19
	bl	_strlen
	add	x0, x0, #1
	bl	_malloc
	str	x0, [x21, #16]
	mov	x1, x19
	bl	_strcpy
	ldr	x8, [x20, #48]
	str	x8, [x21]
	ldrh	w8, [x20, #80]
	add	w8, w8, #1
	strh	w8, [x20, #80]
	mov	w0, #0
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_symbol_offset                  ; -- Begin function symbol_offset
	.p2align	2
_symbol_offset:                         ; @symbol_offset
	.cfi_startproc
; %bb.0:
	stp	x24, x23, [sp, #-64]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 64
	stp	x22, x21, [sp, #16]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #32]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #48]             ; 16-byte Folded Spill
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	mov	x20, x1
	mov	x19, x0
	ldrh	w23, [x0, #80]
	ldr	x22, [x0, #88]
	cbz	x23, LBB128_4
; %bb.1:
	mov	x21, #0
	add	x24, x22, #16
LBB128_2:                               ; =>This Inner Loop Header: Depth=1
	ldr	x0, [x24]
	mov	x1, x20
	bl	_strcmp
	cbz	w0, LBB128_5
; %bb.3:                                ;   in Loop: Header=BB128_2 Depth=1
	add	x21, x21, #1
	add	x24, x24, #24
	cmp	x23, x21
	b.ne	LBB128_2
LBB128_4:
	mov	w24, #24
	mov	x8, #24
	madd	x1, x23, x24, x8
	mov	x0, x22
	bl	_realloc
	str	x0, [x19, #88]
	ldrh	w8, [x19, #80]
	madd	x21, x8, x24, x0
	mov	x0, x20
	bl	_strlen
	add	x0, x0, #1
	bl	_malloc
	str	x0, [x21, #16]
	mov	x1, x20
	bl	_strcpy
	ldr	x8, [x19, #48]
	str	x8, [x21]
	ldrh	w8, [x19, #80]
	add	w8, w8, #1
	strh	w8, [x19, #80]
	ldr	x9, [x19, #88]
	and	x8, x8, #0xffff
	sub	x21, x8, #1
	mul	x8, x21, x24
	ldr	x10, [x9, x8]
	orr	x10, x10, #0x8000000000000000
	str	x10, [x9, x8]
LBB128_5:
	mov	x0, x21
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp], #64             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_sig_handler                    ; -- Begin function sig_handler
	.p2align	2
_sig_handler:                           ; @sig_handler
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #304
	.cfi_def_cfa_offset 304
	stp	x20, x19, [sp, #272]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #288]            ; 16-byte Folded Spill
	add	x29, sp, #288
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x1
	bl	_strsignal
Lloh2:
	adrp	x8, ___stderrp@GOTPAGE
Lloh3:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh4:
	ldr	x8, [x8]
	ldr	x9, [x19, #24]
	stp	x0, x9, [sp]
Lloh5:
	adrp	x1, l_.str@PAGE
Lloh6:
	add	x1, x1, l_.str@PAGEOFF
	mov	x0, x8
	bl	_fprintf
	add	x0, sp, #16
	mov	w1, #32
	bl	_backtrace
	mov	x1, x0
	add	x0, sp, #16
	mov	w2, #2
	bl	_backtrace_symbols_fd
	mov	w0, #1
	bl	_exit
	.loh AdrpAdd	Lloh5, Lloh6
	.loh AdrpLdrGotLdr	Lloh2, Lloh3, Lloh4
	.cfi_endproc
                                        ; -- End function
	.globl	_find_symbol_in                 ; -- Begin function find_symbol_in
	.p2align	2
_find_symbol_in:                        ; @find_symbol_in
	.cfi_startproc
; %bb.0:
	stp	x22, x21, [sp, #-48]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 48
	stp	x20, x19, [sp, #16]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	mov	x19, x1
	mov	x20, x0
	ldr	w21, [x0, #24]
	lsl	x0, x21, #3
	bl	_malloc
	cbz	w21, LBB130_5
; %bb.1:
	mov	w9, #0
	ldr	x8, [x20, #32]
	b	LBB130_3
LBB130_2:                               ;   in Loop: Header=BB130_3 Depth=1
	add	x8, x8, #8
	subs	x21, x21, #1
	b.eq	LBB130_5
LBB130_3:                               ; =>This Inner Loop Header: Depth=1
	ldr	x10, [x8]
	ldrh	w11, [x10]
	cmp	w11, #2
	b.ne	LBB130_2
; %bb.4:                                ;   in Loop: Header=BB130_3 Depth=1
	str	x10, [x0, w9, uxtw  #3]
	add	w9, w9, #1
	b	LBB130_2
LBB130_5:
	cbz	x0, LBB130_9
; %bb.6:
	ldr	x8, [x0]
	cbz	x8, LBB130_8
; %bb.7:
	ldr	x9, [x8, #8]
	cmp	x9, #24
	b.hs	LBB130_10
LBB130_8:
	mov	x0, #0
LBB130_9:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
LBB130_10:
	ldr	x8, [x8, #16]
	mov	x10, #-6148914691236517206
	movk	x10, #43691
	umulh	x9, x9, x10
	lsr	x20, x9, #4
	add	x21, x8, #16
	b	LBB130_12
LBB130_11:                              ;   in Loop: Header=BB130_12 Depth=1
	add	x21, x21, #24
	subs	x20, x20, #1
	b.eq	LBB130_8
LBB130_12:                              ; =>This Inner Loop Header: Depth=1
	ldr	x0, [x21]
	mov	x1, x19
	bl	_strcmp
	cbnz	w0, LBB130_11
; %bb.13:                               ;   in Loop: Header=BB130_12 Depth=1
	ldur	x0, [x21, #-16]
	tbnz	x0, #63, LBB130_11
	b	LBB130_9
	.cfi_endproc
                                        ; -- End function
	.globl	_find_symbol                    ; -- Begin function find_symbol
	.p2align	2
_find_symbol:                           ; @find_symbol
	.cfi_startproc
; %bb.0:
	stp	x26, x25, [sp, #-80]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 80
	stp	x24, x23, [sp, #16]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #32]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #48]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #64]             ; 16-byte Folded Spill
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	cbz	x2, LBB131_17
; %bb.1:
	mov	x19, x2
	mov	x20, x1
	mov	x21, x0
	mov	x22, #0
	mov	w23, #48
	mov	x24, #-6148914691236517206
	movk	x24, #43691
	b	LBB131_3
LBB131_2:                               ;   in Loop: Header=BB131_3 Depth=1
	add	x22, x22, #1
	cmp	x22, x19
	b.eq	LBB131_17
LBB131_3:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB131_6 Depth 2
                                        ;     Child Loop BB131_13 Depth 2
	madd	x8, x22, x23, x20
	ldr	w25, [x8, #24]
	lsl	x0, x25, #3
	bl	_malloc
	cbz	w25, LBB131_8
; %bb.4:                                ;   in Loop: Header=BB131_3 Depth=1
	mov	w8, #0
	madd	x9, x22, x23, x20
	ldr	x9, [x9, #32]
	b	LBB131_6
LBB131_5:                               ;   in Loop: Header=BB131_6 Depth=2
	add	x9, x9, #8
	subs	x25, x25, #1
	b.eq	LBB131_8
LBB131_6:                               ;   Parent Loop BB131_3 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	x10, [x9]
	ldrh	w11, [x10]
	cmp	w11, #2
	b.ne	LBB131_5
; %bb.7:                                ;   in Loop: Header=BB131_6 Depth=2
	str	x10, [x0, w8, uxtw  #3]
	add	w8, w8, #1
	b	LBB131_5
LBB131_8:                               ;   in Loop: Header=BB131_3 Depth=1
	cbz	x0, LBB131_2
; %bb.9:                                ;   in Loop: Header=BB131_3 Depth=1
	ldr	x8, [x0]
	cbz	x8, LBB131_2
; %bb.10:                               ;   in Loop: Header=BB131_3 Depth=1
	ldr	x9, [x8, #8]
	cmp	x9, #24
	b.lo	LBB131_2
; %bb.11:                               ;   in Loop: Header=BB131_3 Depth=1
	ldr	x8, [x8, #16]
	umulh	x9, x9, x24
	lsr	x25, x9, #4
	add	x26, x8, #16
	b	LBB131_13
LBB131_12:                              ;   in Loop: Header=BB131_13 Depth=2
	add	x26, x26, #24
	subs	x25, x25, #1
	b.eq	LBB131_2
LBB131_13:                              ;   Parent Loop BB131_3 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	x0, [x26]
	mov	x1, x21
	bl	_strcmp
	cbnz	w0, LBB131_12
; %bb.14:                               ;   in Loop: Header=BB131_13 Depth=2
	ldur	x0, [x26, #-16]
	tbnz	x0, #63, LBB131_12
; %bb.15:                               ;   in Loop: Header=BB131_3 Depth=1
	cbz	x0, LBB131_2
; %bb.16:                               ;   in Loop: Header=BB131_3 Depth=1
	tbnz	x0, #63, LBB131_2
	b	LBB131_18
LBB131_17:
	mov	x0, #0
LBB131_18:
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #16]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp], #80             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_relocate                       ; -- Begin function relocate
	.p2align	2
_relocate:                              ; @relocate
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #112
	.cfi_def_cfa_offset 112
	stp	x28, x27, [sp, #16]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #32]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #48]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #64]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #80]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #96]             ; 16-byte Folded Spill
	add	x29, sp, #96
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	cbz	x1, LBB132_28
; %bb.1:
	mov	x19, x1
	mov	x20, x0
	mov	x25, #0
	mov	w24, #48
Lloh7:
	adrp	x21, l_.str.2@PAGE
Lloh8:
	add	x21, x21, l_.str.2@PAGEOFF
	mov	w27, #24
Lloh9:
	adrp	x26, ___stderrp@GOTPAGE
Lloh10:
	ldr	x26, [x26, ___stderrp@GOTPAGEOFF]
	str	x1, [sp, #8]                    ; 8-byte Folded Spill
	b	LBB132_3
LBB132_2:                               ;   in Loop: Header=BB132_3 Depth=1
	add	x25, x25, #1
	cmp	x25, x19
	b.eq	LBB132_28
LBB132_3:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB132_6 Depth 2
                                        ;     Child Loop BB132_25 Depth 2
                                        ;     Child Loop BB132_14 Depth 2
                                        ;     Child Loop BB132_19 Depth 2
                                        ;       Child Loop BB132_21 Depth 3
	madd	x8, x25, x24, x20
	ldr	w22, [x8, #24]
	lsl	x0, x22, #3
	bl	_malloc
	cbz	w22, LBB132_8
; %bb.4:                                ;   in Loop: Header=BB132_3 Depth=1
	mov	w8, #0
	madd	x9, x25, x24, x20
	ldr	x9, [x9, #32]
	b	LBB132_6
LBB132_5:                               ;   in Loop: Header=BB132_6 Depth=2
	add	x9, x9, #8
	subs	x22, x22, #1
	b.eq	LBB132_8
LBB132_6:                               ;   Parent Loop BB132_3 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	x10, [x9]
	ldrh	w11, [x10]
	cmp	w11, #2
	b.ne	LBB132_5
; %bb.7:                                ;   in Loop: Header=BB132_6 Depth=2
	str	x10, [x0, w8, uxtw  #3]
	add	w8, w8, #1
	b	LBB132_5
LBB132_8:                               ;   in Loop: Header=BB132_3 Depth=1
	cbz	x0, LBB132_2
; %bb.9:                                ;   in Loop: Header=BB132_3 Depth=1
	ldr	x8, [x0]
	cbz	x8, LBB132_2
; %bb.10:                               ;   in Loop: Header=BB132_3 Depth=1
	ldp	x8, x28, [x8, #8]
	cmp	x8, #24
	b.hs	LBB132_22
LBB132_11:                              ;   in Loop: Header=BB132_3 Depth=1
	madd	x8, x25, x24, x20
	ldr	w22, [x8, #12]
	lsl	x0, x22, #3
	bl	_malloc
	mov	x23, x0
                                        ; implicit-def: $x9
	cbz	w22, LBB132_17
; %bb.12:                               ;   in Loop: Header=BB132_3 Depth=1
	mov	w8, #48
	mov	w26, #0
	madd	x8, x25, x8, x20
	ldr	x19, [x8, #16]
	b	LBB132_14
LBB132_13:                              ;   in Loop: Header=BB132_14 Depth=2
	add	x19, x19, #8
	subs	x22, x22, #1
	b.eq	LBB132_16
LBB132_14:                              ;   Parent Loop BB132_3 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	x24, [x19]
	mov	x0, x24
	mov	x1, x21
	mov	w2, #16
	bl	_strncmp
	cbnz	w0, LBB132_13
; %bb.15:                               ;   in Loop: Header=BB132_14 Depth=2
	str	x24, [x23, w26, uxtw  #3]
	add	w26, w26, #1
	b	LBB132_13
LBB132_16:                              ;   in Loop: Header=BB132_3 Depth=1
	ldr	x9, [x23]
	ldr	x19, [sp, #8]                   ; 8-byte Folded Reload
	mov	w24, #48
Lloh11:
	adrp	x26, ___stderrp@GOTPAGE
Lloh12:
	ldr	x26, [x26, ___stderrp@GOTPAGEOFF]
	cbz	x9, LBB132_2
LBB132_17:                              ;   in Loop: Header=BB132_3 Depth=1
	madd	x8, x25, x24, x20
	ldr	x8, [x8, #32]
	b	LBB132_19
LBB132_18:                              ;   in Loop: Header=BB132_19 Depth=2
	ldr	x9, [x23, #8]!
	cbz	x9, LBB132_2
LBB132_19:                              ;   Parent Loop BB132_3 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB132_21 Depth 3
	ldr	w10, [x9, #16]
	cbz	w10, LBB132_18
; %bb.20:                               ;   in Loop: Header=BB132_19 Depth=2
	mov	x11, #0
	ldr	w12, [x9, #32]
	ldr	x12, [x8, x12, lsl  #3]
	ldr	x9, [x9, #24]
	ldr	x12, [x12, #16]
LBB132_21:                              ;   Parent Loop BB132_3 Depth=1
                                        ;     Parent Loop BB132_19 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ldr	x13, [x9, x11]
	ldr	x14, [x12, x13]
	mul	x14, x14, x27
	ldr	x14, [x28, x14]
	str	x14, [x12, x13]
	add	x11, x11, #16
	cmp	x11, x10
	b.lo	LBB132_21
	b	LBB132_18
LBB132_22:                              ;   in Loop: Header=BB132_3 Depth=1
	mov	x9, #-6148914691236517206
	movk	x9, #43691
	umulh	x8, x8, x9
	lsr	x22, x8, #4
	add	x23, x28, #16
	b	LBB132_25
LBB132_23:                              ;   in Loop: Header=BB132_25 Depth=2
	ldr	x0, [x26]
	ldr	x8, [x23]
	str	x8, [sp]
Lloh13:
	adrp	x1, l_.str.1@PAGE
Lloh14:
	add	x1, x1, l_.str.1@PAGEOFF
	bl	_fprintf
LBB132_24:                              ;   in Loop: Header=BB132_25 Depth=2
	add	x23, x23, #24
	subs	x22, x22, #1
	b.eq	LBB132_11
LBB132_25:                              ;   Parent Loop BB132_3 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldur	x8, [x23, #-16]
	tbz	x8, #63, LBB132_24
; %bb.26:                               ;   in Loop: Header=BB132_25 Depth=2
	ldr	x0, [x23]
	mov	x1, x20
	mov	x2, x19
	bl	_find_symbol
	cbz	x0, LBB132_23
; %bb.27:                               ;   in Loop: Header=BB132_25 Depth=2
	stur	x0, [x23, #-16]
	b	LBB132_24
LBB132_28:
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
	.loh AdrpLdrGot	Lloh9, Lloh10
	.loh AdrpAdd	Lloh7, Lloh8
	.loh AdrpLdrGot	Lloh11, Lloh12
	.loh AdrpAdd	Lloh13, Lloh14
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__literal8,8byte_literals
	.p2align	3, 0x0                          ; -- Begin function main
lCPI133_0:
	.long	4277009102                      ; 0xfeedface
	.long	1                               ; 0x1
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	stp	x28, x27, [sp, #-96]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 96
	stp	x26, x25, [sp, #16]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #32]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #48]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #64]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #80]             ; 16-byte Folded Spill
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	mov	w9, #512
	movk	w9, #16, lsl #16
Lloh15:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh16:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	sp, sp, #256, lsl #12           ; =1048576
	sub	sp, sp, #512
	mov	x19, sp
	mov	x24, x1
	mov	x21, x0
Lloh17:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh18:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh19:
	ldr	x8, [x8]
	stur	x8, [x29, #-104]
Lloh20:
	adrp	x1, _main.act@PAGE
Lloh21:
	add	x1, x1, _main.act@PAGEOFF
	mov	w0, #2
	mov	x2, #0
	bl	_sigaction
	cmn	w0, #1
	b.ne	LBB133_2
; %bb.1:
Lloh22:
	adrp	x20, ___stderrp@GOTPAGE
Lloh23:
	ldr	x20, [x20, ___stderrp@GOTPAGEOFF]
	ldr	x3, [x20]
Lloh24:
	adrp	x0, l_.str.3@PAGE
Lloh25:
	add	x0, x0, l_.str.3@PAGEOFF
	mov	w1, #32
	mov	w2, #1
	bl	_fwrite
	ldr	x22, [x20]
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	mov	x23, x0
	bl	___error
	ldr	w8, [x0]
	stp	x23, x8, [sp, #-16]!
Lloh26:
	adrp	x1, l_.str.4@PAGE
Lloh27:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	x0, x22
	bl	_fprintf
	add	sp, sp, #16
LBB133_2:
Lloh28:
	adrp	x1, _main.act@PAGE
Lloh29:
	add	x1, x1, _main.act@PAGEOFF
	mov	w0, #4
	mov	x2, #0
	bl	_sigaction
	cmn	w0, #1
	b.ne	LBB133_4
; %bb.3:
Lloh30:
	adrp	x20, ___stderrp@GOTPAGE
Lloh31:
	ldr	x20, [x20, ___stderrp@GOTPAGEOFF]
	ldr	x3, [x20]
Lloh32:
	adrp	x0, l_.str.3@PAGE
Lloh33:
	add	x0, x0, l_.str.3@PAGEOFF
	mov	w1, #32
	mov	w2, #1
	bl	_fwrite
	ldr	x22, [x20]
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	mov	x23, x0
	bl	___error
	ldr	w8, [x0]
	stp	x23, x8, [sp, #-16]!
Lloh34:
	adrp	x1, l_.str.4@PAGE
Lloh35:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	x0, x22
	bl	_fprintf
	add	sp, sp, #16
LBB133_4:
Lloh36:
	adrp	x1, _main.act@PAGE
Lloh37:
	add	x1, x1, _main.act@PAGEOFF
	mov	w0, #5
	mov	x2, #0
	bl	_sigaction
	cmn	w0, #1
	b.ne	LBB133_6
; %bb.5:
Lloh38:
	adrp	x20, ___stderrp@GOTPAGE
Lloh39:
	ldr	x20, [x20, ___stderrp@GOTPAGEOFF]
	ldr	x3, [x20]
Lloh40:
	adrp	x0, l_.str.3@PAGE
Lloh41:
	add	x0, x0, l_.str.3@PAGEOFF
	mov	w1, #32
	mov	w2, #1
	bl	_fwrite
	ldr	x22, [x20]
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	mov	x23, x0
	bl	___error
	ldr	w8, [x0]
	stp	x23, x8, [sp, #-16]!
Lloh42:
	adrp	x1, l_.str.4@PAGE
Lloh43:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	x0, x22
	bl	_fprintf
	add	sp, sp, #16
LBB133_6:
Lloh44:
	adrp	x1, _main.act@PAGE
Lloh45:
	add	x1, x1, _main.act@PAGEOFF
	mov	w0, #6
	mov	x2, #0
	bl	_sigaction
	cmn	w0, #1
	b.ne	LBB133_8
; %bb.7:
Lloh46:
	adrp	x20, ___stderrp@GOTPAGE
Lloh47:
	ldr	x20, [x20, ___stderrp@GOTPAGEOFF]
	ldr	x3, [x20]
Lloh48:
	adrp	x0, l_.str.3@PAGE
Lloh49:
	add	x0, x0, l_.str.3@PAGEOFF
	mov	w1, #32
	mov	w2, #1
	bl	_fwrite
	ldr	x22, [x20]
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	mov	x23, x0
	bl	___error
	ldr	w8, [x0]
	stp	x23, x8, [sp, #-16]!
Lloh50:
	adrp	x1, l_.str.4@PAGE
Lloh51:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	x0, x22
	bl	_fprintf
	add	sp, sp, #16
LBB133_8:
Lloh52:
	adrp	x1, _main.act@PAGE
Lloh53:
	add	x1, x1, _main.act@PAGEOFF
	mov	w0, #10
	mov	x2, #0
	bl	_sigaction
	cmn	w0, #1
	b.ne	LBB133_10
; %bb.9:
Lloh54:
	adrp	x20, ___stderrp@GOTPAGE
Lloh55:
	ldr	x20, [x20, ___stderrp@GOTPAGEOFF]
	ldr	x3, [x20]
Lloh56:
	adrp	x0, l_.str.3@PAGE
Lloh57:
	add	x0, x0, l_.str.3@PAGEOFF
	mov	w1, #32
	mov	w2, #1
	bl	_fwrite
	ldr	x22, [x20]
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	mov	x23, x0
	bl	___error
	ldr	w8, [x0]
	stp	x23, x8, [sp, #-16]!
Lloh58:
	adrp	x1, l_.str.4@PAGE
Lloh59:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	x0, x22
	bl	_fprintf
	add	sp, sp, #16
LBB133_10:
Lloh60:
	adrp	x1, _main.act@PAGE
Lloh61:
	add	x1, x1, _main.act@PAGEOFF
	mov	w0, #11
	mov	x2, #0
	bl	_sigaction
	cmn	w0, #1
	b.eq	LBB133_13
; %bb.11:
	cmp	w21, #2
	b.gt	LBB133_14
LBB133_12:
Lloh62:
	adrp	x20, ___stderrp@GOTPAGE
Lloh63:
	ldr	x20, [x20, ___stderrp@GOTPAGEOFF]
	ldr	x0, [x20]
	ldr	x8, [x24]
	str	x8, [sp, #-16]!
Lloh64:
	adrp	x1, l_.str.5@PAGE
Lloh65:
	add	x1, x1, l_.str.5@PAGEOFF
	bl	_fprintf
	add	sp, sp, #16
	ldr	x0, [x20]
	ldr	x8, [x24]
	str	x8, [sp, #-16]!
Lloh66:
	adrp	x1, l_.str.6@PAGE
Lloh67:
	add	x1, x1, l_.str.6@PAGEOFF
	b	LBB133_54
LBB133_13:
Lloh68:
	adrp	x20, ___stderrp@GOTPAGE
Lloh69:
	ldr	x20, [x20, ___stderrp@GOTPAGEOFF]
	ldr	x3, [x20]
Lloh70:
	adrp	x0, l_.str.3@PAGE
Lloh71:
	add	x0, x0, l_.str.3@PAGEOFF
	mov	w1, #32
	mov	w2, #1
	bl	_fwrite
	ldr	x22, [x20]
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	mov	x23, x0
	bl	___error
	ldr	w8, [x0]
	stp	x23, x8, [sp, #-16]!
Lloh72:
	adrp	x1, l_.str.4@PAGE
Lloh73:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	x0, x22
	bl	_fprintf
	add	sp, sp, #16
	cmp	w21, #2
	b.le	LBB133_12
LBB133_14:
	add	x26, x19, #256, lsl #12         ; =1048576
	add	x26, x26, #136
	ldr	x22, [x24, #8]
Lloh74:
	adrp	x1, l_.str.7@PAGE
Lloh75:
	add	x1, x1, l_.str.7@PAGEOFF
	mov	x0, x22
	bl	_strcmp
	cbz	w0, LBB133_17
; %bb.15:
Lloh76:
	adrp	x1, l_.str.10@PAGE
Lloh77:
	add	x1, x1, l_.str.10@PAGEOFF
	mov	x0, x22
	bl	_strcmp
	cbz	w0, LBB133_19
; %bb.16:
Lloh78:
	adrp	x8, ___stderrp@GOTPAGE
Lloh79:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh80:
	ldr	x0, [x8]
	str	x22, [sp, #-16]!
Lloh81:
	adrp	x1, l_.str.15@PAGE
Lloh82:
	add	x1, x1, l_.str.15@PAGEOFF
	b	LBB133_54
LBB133_17:
	cmp	w21, #3
	b.hi	LBB133_23
; %bb.18:
Lloh83:
	adrp	x8, ___stderrp@GOTPAGE
Lloh84:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh85:
	ldr	x0, [x8]
	ldr	x8, [x24]
	str	x8, [sp, #-16]!
Lloh86:
	adrp	x1, l_.str.8@PAGE
Lloh87:
	add	x1, x1, l_.str.8@PAGEOFF
	b	LBB133_54
LBB133_19:
	ldr	x0, [x24, #16]
Lloh88:
	adrp	x1, l_.str.11@PAGE
Lloh89:
	add	x1, x1, l_.str.11@PAGEOFF
	bl	_fopen
	cbz	x0, LBB133_53
; %bb.20:
	mov	x21, x0
Lloh90:
	adrp	x0, _bios@PAGE
Lloh91:
	add	x0, x0, _bios@PAGEOFF
	sub	x20, x29, #200
	sub	x8, x29, #200
	bl	_read_translation_unit_bytes
	add	x8, x20, #48
	mov	x0, x21
	bl	_read_translation_unit
	mov	x0, x21
	bl	_fclose
	sub	x0, x29, #200
	mov	w1, #2
	bl	_relocate
	mov	w9, #8
Lloh92:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh93:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26]
	mov	w9, #8
Lloh94:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh95:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #8]
	mov	w9, #8
Lloh96:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh97:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #16]
	mov	w9, #8
Lloh98:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh99:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #24]
	mov	w9, #8
Lloh100:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh101:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #32]
	mov	w9, #8
Lloh102:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh103:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #40]
	mov	w9, #8
Lloh104:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh105:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #48]
	mov	w9, #8
Lloh106:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh107:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #56]
	mov	w9, #8
Lloh108:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh109:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #64]
	mov	w9, #8
Lloh110:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh111:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #72]
	mov	w9, #8
Lloh112:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh113:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #80]
	mov	w9, #8
Lloh114:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh115:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #88]
	mov	w9, #8
Lloh116:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh117:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #96]
	mov	w9, #8
Lloh118:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh119:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #104]
	mov	w9, #8
Lloh120:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh121:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #112]
	mov	w9, #8
Lloh122:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh123:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #120]
	mov	w9, #8
Lloh124:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh125:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #128]
	mov	w9, #8
Lloh126:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh127:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #136]
	mov	w9, #8
Lloh128:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh129:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #144]
	mov	w9, #8
Lloh130:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh131:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #152]
	mov	w9, #8
Lloh132:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh133:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #160]
	mov	w9, #8
Lloh134:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh135:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #168]
	mov	w9, #8
Lloh136:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh137:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #176]
	mov	w9, #8
Lloh138:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh139:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #184]
	mov	w9, #8
Lloh140:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh141:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #192]
	mov	w9, #8
Lloh142:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh143:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #200]
	mov	w9, #8
Lloh144:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh145:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #208]
	mov	w9, #8
Lloh146:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh147:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	mov	x22, sp
	sub	x8, x22, #16
	mov	sp, x8
	str	x8, [x26, #216]
	mov	w9, #8
Lloh148:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh149:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #224]
	mov	w9, #8
Lloh150:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh151:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x20, sp, #16
	mov	sp, x20
	str	x20, [x26, #232]
	mov	w9, #8
Lloh152:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh153:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x21, sp, #16
	mov	sp, x21
	str	x21, [x26, #240]
	mov	w9, #8
Lloh154:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh155:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	x8, sp, #16
	mov	sp, x8
	str	x8, [x26, #248]
Lloh156:
	adrp	x0, l_.str.13@PAGE
Lloh157:
	add	x0, x0, l_.str.13@PAGEOFF
	sub	x1, x29, #200
	mov	w2, #2
	bl	_find_symbol
	stur	x0, [x22, #-16]
	cbz	x0, LBB133_68
; %bb.21:
	add	x8, x19, #136
	str	x8, [x20]
	str	x8, [x21]
	stp	xzr, xzr, [x19, #112]
Lloh158:
	adrp	x22, _funcs@PAGE
Lloh159:
	add	x22, x22, _funcs@PAGEOFF
	mov	w23, #51712
	movk	w23, #15258, lsl #16
Lloh160:
	adrp	x20, l_.str.20@PAGE
Lloh161:
	add	x20, x20, l_.str.20@PAGEOFF
LBB133_22:                              ; =>This Inner Loop Header: Depth=1
	add	x1, x19, #96
	mov	w0, #0
	bl	_clock_gettime
	ldr	x8, [x26, #216]
	ldr	x9, [x8]
	ldrh	w24, [x9], #2
	str	x9, [x8]
	lsr	x21, x24, #12
	ldr	x25, [x26, #216]
	ldr	x1, [x25]
	add	x0, x19, #112
	mov	x2, x21
	mov	w3, #16
	bl	___memcpy_chk
	ldr	x8, [x25]
	add	x8, x8, x21
	str	x8, [x25]
	ldr	x8, [x22, x21, lsl  #3]
	and	x9, x24, #0xfff
	ldr	x8, [x8, x9, lsl  #3]
	ldp	x1, x2, [x19, #112]
	add	x0, x19, #256, lsl #12          ; =1048576
	add	x0, x0, #136
	blr	x8
	add	x1, x19, #80
	mov	w0, #0
	bl	_clock_gettime
	ldp	x8, x9, [x19, #80]
	ldp	x10, x11, [x19, #96]
	sub	x8, x8, x10
	sub	x9, x9, x11
	madd	x8, x8, x23, x9
	str	x8, [sp, #-16]!
	mov	x0, x20
	bl	_printf
	add	sp, sp, #16
	b	LBB133_22
LBB133_23:
	add	x9, x19, #256, lsl #12          ; =1048576
	add	x9, x9, #136
	orr	x21, x9, #0x4
Lloh162:
	adrp	x8, lCPI133_0@PAGE
Lloh163:
	ldr	d0, [x8, lCPI133_0@PAGEOFF]
	str	d0, [x26]
	add	x20, x9, #8
	stp	xzr, xzr, [x26, #8]
	ldr	x0, [x24, #16]
	bl	_run_compile
	stp	x24, x0, [x19, #24]             ; 16-byte Folded Spill
	ldr	x26, [x0]
	stp	x21, x20, [x19, #8]             ; 16-byte Folded Spill
	mov	x0, #0
	cbz	x26, LBB133_57
; %bb.24:
	stp	xzr, xzr, [x19, #48]            ; 16-byte Folded Spill
	stp	xzr, xzr, [x19, #64]            ; 16-byte Folded Spill
	mov	x20, #0
	add	x23, x19, #136
	add	x22, x23, #16
	mov	w27, #272
	b	LBB133_26
LBB133_25:                              ;   in Loop: Header=BB133_26 Depth=1
	mov	w8, #23
	strh	w8, [x26, #2]
	add	x21, x19, #256, lsl #12         ; =1048576
	add	x21, x21, #136
	str	w28, [x21, #24]
	and	x8, x28, #0xffffffff
	add	x8, x8, w28, uxtw #1
	lsl	x1, x8, #5
	ldr	x0, [x19, #40]                  ; 8-byte Folded Reload
	bl	_realloc
	str	x0, [x21, #32]
	ldr	x8, [x19, #72]                  ; 8-byte Folded Reload
	str	x26, [x0, w8, uxtw  #3]
	ldr	x8, [x19, #32]                  ; 8-byte Folded Reload
	ldr	x26, [x8, x28, lsl  #3]
	str	x28, [x19, #72]                 ; 8-byte Folded Spill
	cbz	x26, LBB133_58
LBB133_26:                              ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB133_30 Depth 2
                                        ;       Child Loop BB133_34 Depth 3
                                        ;       Child Loop BB133_38 Depth 3
                                        ;     Child Loop BB133_48 Depth 2
                                        ;     Child Loop BB133_52 Depth 2
	str	x0, [x19, #40]                  ; 8-byte Folded Spill
	ldr	x8, [x26, #32]
	cbz	x8, LBB133_46
; %bb.27:                               ;   in Loop: Header=BB133_26 Depth=1
	mov	x28, #0
	b	LBB133_30
LBB133_28:                              ;   in Loop: Header=BB133_30 Depth=2
	mov	x0, x26
	mov	x1, x21
	bl	_symbol_offset
	mov	x21, x0
	ldp	x8, x0, [x26, #8]
	add	x1, x8, #8
	bl	_realloc
	str	x0, [x26, #16]
	ldr	x8, [x26, #8]
	str	x21, [x0, x8]
	add	x8, x8, #8
	str	x8, [x26, #8]
LBB133_29:                              ;   in Loop: Header=BB133_30 Depth=2
	add	x28, x28, #1
	ldr	x8, [x26, #32]
	cmp	x28, x8
	b.hs	LBB133_46
LBB133_30:                              ;   Parent Loop BB133_26 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB133_34 Depth 3
                                        ;       Child Loop BB133_38 Depth 3
	ldr	x8, [x26, #24]
	madd	x8, x28, x27, x8
	ldr	w9, [x8]
	ldr	x21, [x8, #8]
	cmp	w9, #2
	b.eq	LBB133_28
; %bb.31:                               ;   in Loop: Header=BB133_30 Depth=2
	ldr	x24, [x8, #16]
	cmp	w9, #1
	b.eq	LBB133_35
; %bb.32:                               ;   in Loop: Header=BB133_30 Depth=2
	cmp	w9, #0
	ccmp	x24, #0, #4, eq
	b.eq	LBB133_29
; %bb.33:                               ;   in Loop: Header=BB133_30 Depth=2
	ldp	x8, x0, [x26, #8]
LBB133_34:                              ;   Parent Loop BB133_26 Depth=1
                                        ;     Parent Loop BB133_30 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ldrb	w25, [x21], #1
	add	x1, x8, #1
	str	x1, [x26, #8]
	bl	_realloc
	str	x0, [x26, #16]
	ldr	x8, [x26, #8]
	add	x9, x8, x0
	sturb	w25, [x9, #-1]
	subs	x24, x24, #1
	b.ne	LBB133_34
	b	LBB133_29
LBB133_35:                              ;   in Loop: Header=BB133_30 Depth=2
	stp	x21, x24, [x19, #136]
	ldur	q0, [x8, #216]
	str	q0, [x22, #192]
	ldur	q0, [x8, #232]
	str	q0, [x22, #208]
	ldur	q0, [x8, #248]
	str	q0, [x22, #224]
	ldr	x9, [x8, #264]
	str	x9, [x22, #240]
	ldur	q0, [x8, #152]
	str	q0, [x22, #128]
	ldur	q0, [x8, #168]
	str	q0, [x22, #144]
	ldur	q0, [x8, #184]
	str	q0, [x22, #160]
	ldur	q0, [x8, #200]
	str	q0, [x22, #176]
	ldur	q0, [x8, #88]
	str	q0, [x22, #64]
	ldur	q0, [x8, #104]
	str	q0, [x22, #80]
	ldur	q0, [x8, #120]
	str	q0, [x22, #96]
	ldur	q0, [x8, #136]
	str	q0, [x22, #112]
	ldur	q0, [x8, #24]
	str	q0, [x22]
	ldur	q0, [x8, #40]
	str	q0, [x22, #16]
	ldur	q0, [x8, #56]
	str	q0, [x22, #32]
	ldur	q0, [x8, #72]
	str	q0, [x22, #48]
	ubfx	w27, w21, #4, #12
	mov	x24, x27
	bfi	w24, w21, #12, #20
	ldp	x8, x0, [x26, #8]
	add	x1, x8, #2
	bl	_realloc
	mov	x25, #0
	str	x0, [x26, #16]
	ldr	x8, [x26, #8]
	strh	w24, [x0, x8]
	add	x8, x8, #2
	str	x8, [x26, #8]
	and	w24, w21, #0xf
	b	LBB133_38
LBB133_36:                              ;   in Loop: Header=BB133_38 Depth=3
	sub	sp, sp, #32
	stp	x24, x27, [sp, #8]
	str	x8, [sp]
Lloh164:
	adrp	x0, l_.str.16@PAGE
Lloh165:
	add	x0, x0, l_.str.16@PAGEOFF
	bl	_printf
	add	sp, sp, #32
LBB133_37:                              ;   in Loop: Header=BB133_38 Depth=3
	add	x25, x25, #16
	cmp	x25, #64
	b.eq	LBB133_45
LBB133_38:                              ;   Parent Loop BB133_26 Depth=1
                                        ;     Parent Loop BB133_30 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	add	x8, x23, x25
	ldr	w8, [x8, #8]
	cmp	w8, #4
	b.hi	LBB133_36
; %bb.39:                               ;   in Loop: Header=BB133_38 Depth=3
Lloh166:
	adrp	x11, lJTI133_0@PAGE
Lloh167:
	add	x11, x11, lJTI133_0@PAGEOFF
	adr	x9, LBB133_37
	ldrb	w10, [x11, x8]
	add	x9, x9, x10, lsl #2
	br	x9
LBB133_40:                              ;   in Loop: Header=BB133_38 Depth=3
	add	x8, x23, x25
	ldrb	w21, [x8, #16]
	ldp	x8, x0, [x26, #8]
	add	x1, x8, #1
	str	x1, [x26, #8]
	bl	_realloc
	str	x0, [x26, #16]
	ldr	x8, [x26, #8]
	add	x8, x8, x0
	sturb	w21, [x8, #-1]
	b	LBB133_37
LBB133_41:                              ;   in Loop: Header=BB133_38 Depth=3
	add	x8, x23, x25
	ldr	x1, [x8, #16]
	mov	x0, x26
	bl	_symbol_offset
	mov	x21, x0
	b	LBB133_44
LBB133_42:                              ;   in Loop: Header=BB133_38 Depth=3
	add	x8, x23, x25
	ldrh	w21, [x8, #16]
	ldp	x8, x0, [x26, #8]
	add	x1, x8, #2
	bl	_realloc
	str	x0, [x26, #16]
	ldr	x8, [x26, #8]
	strh	w21, [x0, x8]
	add	x8, x8, #2
	str	x8, [x26, #8]
	b	LBB133_37
LBB133_43:                              ;   in Loop: Header=BB133_38 Depth=3
	add	x8, x23, x25
	ldr	x21, [x8, #16]
LBB133_44:                              ;   in Loop: Header=BB133_38 Depth=3
	ldp	x8, x0, [x26, #8]
	add	x1, x8, #8
	bl	_realloc
	str	x0, [x26, #16]
	ldr	x8, [x26, #8]
	str	x21, [x0, x8]
	add	x8, x8, #8
	str	x8, [x26, #8]
	b	LBB133_37
LBB133_45:                              ;   in Loop: Header=BB133_30 Depth=2
	mov	w27, #272
	b	LBB133_29
LBB133_46:                              ;   in Loop: Header=BB133_26 Depth=1
	ldr	x25, [x19, #72]                 ; 8-byte Folded Reload
	add	x28, x25, #1
	add	x21, x19, #256, lsl #12         ; =1048576
	add	x21, x21, #136
	str	w28, [x21, #12]
	and	x8, x28, #0xffffffff
	add	x8, x8, w28, uxtw #2
	lsl	x1, x8, #3
	ldr	x0, [x19, #48]                  ; 8-byte Folded Reload
	bl	_realloc
	mov	x24, x0
	str	x0, [x21, #16]
	mov	w0, #40
	bl	_malloc
	mov	x21, x0
	str	x24, [x19, #48]                 ; 8-byte Folded Spill
	str	x0, [x24, w25, uxtw  #3]
	mov	x8, #17746
	movk	x8, #20300, lsl #16
	movk	x8, #16707, lsl #32
	movk	x8, #17748, lsl #48
	str	x8, [x0]
	str	wzr, [x0, #16]
	ldrh	w24, [x26, #80]
	ldp	x8, x0, [x19, #56]              ; 16-byte Folded Reload
	add	x8, x8, x24
	str	x8, [x19, #56]                  ; 8-byte Folded Spill
	add	x8, x8, x8, lsl #1
	lsl	x1, x8, #3
	bl	_realloc
	str	x0, [x19, #64]                  ; 8-byte Folded Spill
	cbz	x24, LBB133_49
; %bb.47:                               ;   in Loop: Header=BB133_26 Depth=1
	ldr	x8, [x26, #88]
	mov	w9, #24
	madd	x9, x20, x9, x0
	add	x9, x9, #8
	ldr	x11, [x19, #72]                 ; 8-byte Folded Reload
LBB133_48:                              ;   Parent Loop BB133_26 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	x20, x20, #1
	ldr	q0, [x8]
	stur	q0, [x9, #-8]
	ldr	x10, [x8, #16]
	stp	x11, x10, [x9], #24
	add	x8, x8, #24
	subs	x24, x24, #1
	b.ne	LBB133_48
	b	LBB133_50
LBB133_49:                              ;   in Loop: Header=BB133_26 Depth=1
	ldr	x11, [x19, #72]                 ; 8-byte Folded Reload
LBB133_50:                              ;   in Loop: Header=BB133_26 Depth=1
	ldr	x24, [x26, #56]
	mov	x25, x11
	lsl	w0, w24, #4
	str	w0, [x21, #16]
	bl	_malloc
	str	x0, [x21, #24]
	str	w25, [x21, #32]
	mov	w13, #24
	cbz	x24, LBB133_25
; %bb.51:                               ;   in Loop: Header=BB133_26 Depth=1
	ldr	x8, [x26, #72]
	ldr	x9, [x26, #16]
	add	x10, x0, #8
	ldr	x11, [x26, #88]
LBB133_52:                              ;   Parent Loop BB133_26 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	x12, [x8], #8
	stur	x12, [x10, #-8]
	ldr	x12, [x9, x12]
	mul	x12, x12, x13
	ldr	x12, [x11, x12]
	str	x12, [x10], #16
	subs	x24, x24, #1
	b.ne	LBB133_52
	b	LBB133_25
LBB133_53:
Lloh168:
	adrp	x8, ___stderrp@GOTPAGE
Lloh169:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh170:
	ldr	x0, [x8]
	ldr	x8, [x24, #16]
	str	x8, [sp, #-16]!
Lloh171:
	adrp	x1, l_.str.12@PAGE
Lloh172:
	add	x1, x1, l_.str.12@PAGEOFF
LBB133_54:
	bl	_fprintf
	add	sp, sp, #16
	mov	w20, #1
LBB133_55:
	ldur	x8, [x29, #-104]
Lloh173:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh174:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh175:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB133_69
; %bb.56:
	mov	x0, x20
	sub	sp, x29, #80
	ldp	x29, x30, [sp, #80]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #64]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #48]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #32]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #16]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp], #96             ; 16-byte Folded Reload
	ret
LBB133_57:
	mov	w28, #0
	mov	x20, #0
	str	xzr, [x19, #64]                 ; 8-byte Folded Spill
LBB133_58:
	add	x8, x19, #256, lsl #12          ; =1048576
	add	x8, x8, #136
	add	x22, x8, #24
	add	w8, w28, #1
	add	x21, x19, #256, lsl #12         ; =1048576
	add	x21, x21, #136
	str	w8, [x21, #24]
	mov	w9, #96
	umull	x1, w8, w9
	bl	_realloc
	mov	x24, x0
	str	x0, [x21, #32]
	mov	w0, #96
	bl	_malloc
	mov	x21, x0
	str	x0, [x24, w28, uxtw  #3]
	mov	w8, #2
	movk	w8, #33, lsl #16
	str	w8, [x0]
	mov	w23, #8
	mov	w0, #8
	bl	_malloc
	stp	x23, x0, [x21, #8]
	str	x20, [x0]
	cbz	x20, LBB133_61
; %bb.59:
	ldr	x8, [x19, #64]                  ; 8-byte Folded Reload
	add	x24, x8, #16
	mov	w25, #8
LBB133_60:                              ; =>This Inner Loop Header: Depth=1
	ldr	x0, [x24]
	bl	_strlen
	add	x23, x0, #1
	add	x26, x0, #17
	ldr	x0, [x21, #16]
	add	x1, x25, x26
	bl	_realloc
	str	x0, [x21, #16]
	ldr	x8, [x21, #8]
	add	x0, x0, x8
	ldur	q0, [x24, #-16]
	str	q0, [x0], #16
	ldr	x1, [x24], #24
	mov	x2, x23
	bl	_strncpy
	ldr	x8, [x21, #8]
	add	x25, x8, x26
	str	x25, [x21, #8]
	subs	x20, x20, #1
	b.ne	LBB133_60
LBB133_61:
	ldr	x8, [x19, #24]                  ; 8-byte Folded Reload
	ldr	x0, [x8, #24]
Lloh176:
	adrp	x1, l_.str.9@PAGE
Lloh177:
	add	x1, x1, l_.str.9@PAGEOFF
	bl	_fopen
	mov	x20, x0
	add	x21, x19, #256, lsl #12         ; =1048576
	add	x21, x21, #136
	add	x0, x19, #256, lsl #12          ; =1048576
	add	x0, x0, #136
	mov	w1, #4
	mov	w2, #1
	mov	x3, x20
	bl	_fwrite
	ldr	x0, [x19, #8]                   ; 8-byte Folded Reload
	mov	w1, #4
	mov	w2, #1
	mov	x3, x20
	bl	_fwrite
	ldr	x0, [x19, #16]                  ; 8-byte Folded Reload
	mov	w1, #4
	mov	w2, #1
	mov	x3, x20
	bl	_fwrite
	add	x0, x21, #12
	mov	w1, #4
	mov	w2, #1
	mov	x3, x20
	bl	_fwrite
	mov	x0, x22
	mov	w1, #4
	mov	w2, #1
	mov	x3, x20
	bl	_fwrite
	add	x23, x19, #256, lsl #12         ; =1048576
	add	x23, x23, #136
	ldr	w8, [x23, #12]
	cbz	w8, LBB133_64
; %bb.62:
	mov	x21, #0
LBB133_63:                              ; =>This Inner Loop Header: Depth=1
	ldr	x8, [x23, #16]
	lsl	x22, x21, #3
	ldr	x0, [x8, x22]
	mov	w1, #1
	mov	w2, #16
	mov	x3, x20
	bl	_fwrite
	ldr	x8, [x23, #16]
	ldr	x8, [x8, x22]
	add	x0, x8, #16
	mov	w1, #4
	mov	w2, #1
	mov	x3, x20
	bl	_fwrite
	ldr	x8, [x23, #16]
	ldr	x8, [x8, x22]
	ldr	x0, [x8, #24]
	ldr	w2, [x8, #16]
	mov	w1, #1
	mov	x3, x20
	bl	_fwrite
	add	x21, x21, #1
	ldr	w8, [x23, #12]
	cmp	x21, x8
	b.lo	LBB133_63
LBB133_64:
	ldr	w8, [x23, #24]
	cbz	w8, LBB133_67
; %bb.65:
	mov	x21, #0
LBB133_66:                              ; =>This Inner Loop Header: Depth=1
	ldr	x8, [x23, #32]
	lsl	x22, x21, #3
	ldr	x0, [x8, x22]
	mov	w1, #2
	mov	w2, #1
	mov	x3, x20
	bl	_fwrite
	ldr	x8, [x23, #32]
	ldr	x8, [x8, x22]
	add	x0, x8, #2
	mov	w1, #2
	mov	w2, #1
	mov	x3, x20
	bl	_fwrite
	ldr	x8, [x23, #32]
	ldr	x8, [x8, x22]
	add	x0, x8, #8
	mov	w1, #8
	mov	w2, #1
	mov	x3, x20
	bl	_fwrite
	ldr	x8, [x23, #32]
	ldr	x8, [x8, x22]
	ldp	x2, x0, [x8, #8]
	mov	w1, #1
	mov	x3, x20
	bl	_fwrite
	add	x21, x21, #1
	ldr	w8, [x23, #24]
	cmp	x21, x8
	b.lo	LBB133_66
LBB133_67:
	mov	x0, x20
	bl	_fclose
	mov	w20, #0
	b	LBB133_55
LBB133_68:
Lloh178:
	adrp	x8, ___stderrp@GOTPAGE
Lloh179:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh180:
	ldr	x3, [x8]
Lloh181:
	adrp	x0, l_.str.14@PAGE
Lloh182:
	add	x0, x0, l_.str.14@PAGEOFF
	mov	w20, #1
	mov	w1, #29
	mov	w2, #1
	bl	_fwrite
	b	LBB133_55
LBB133_69:
	bl	___stack_chk_fail
	.loh AdrpAdd	Lloh20, Lloh21
	.loh AdrpLdrGotLdr	Lloh17, Lloh18, Lloh19
	.loh AdrpLdrGot	Lloh15, Lloh16
	.loh AdrpAdd	Lloh26, Lloh27
	.loh AdrpAdd	Lloh24, Lloh25
	.loh AdrpLdrGot	Lloh22, Lloh23
	.loh AdrpAdd	Lloh28, Lloh29
	.loh AdrpAdd	Lloh34, Lloh35
	.loh AdrpAdd	Lloh32, Lloh33
	.loh AdrpLdrGot	Lloh30, Lloh31
	.loh AdrpAdd	Lloh36, Lloh37
	.loh AdrpAdd	Lloh42, Lloh43
	.loh AdrpAdd	Lloh40, Lloh41
	.loh AdrpLdrGot	Lloh38, Lloh39
	.loh AdrpAdd	Lloh44, Lloh45
	.loh AdrpAdd	Lloh50, Lloh51
	.loh AdrpAdd	Lloh48, Lloh49
	.loh AdrpLdrGot	Lloh46, Lloh47
	.loh AdrpAdd	Lloh52, Lloh53
	.loh AdrpAdd	Lloh58, Lloh59
	.loh AdrpAdd	Lloh56, Lloh57
	.loh AdrpLdrGot	Lloh54, Lloh55
	.loh AdrpAdd	Lloh60, Lloh61
	.loh AdrpAdd	Lloh66, Lloh67
	.loh AdrpAdd	Lloh64, Lloh65
	.loh AdrpLdrGot	Lloh62, Lloh63
	.loh AdrpAdd	Lloh72, Lloh73
	.loh AdrpAdd	Lloh70, Lloh71
	.loh AdrpLdrGot	Lloh68, Lloh69
	.loh AdrpAdd	Lloh74, Lloh75
	.loh AdrpAdd	Lloh76, Lloh77
	.loh AdrpAdd	Lloh81, Lloh82
	.loh AdrpLdrGotLdr	Lloh78, Lloh79, Lloh80
	.loh AdrpAdd	Lloh86, Lloh87
	.loh AdrpLdrGotLdr	Lloh83, Lloh84, Lloh85
	.loh AdrpAdd	Lloh88, Lloh89
	.loh AdrpAdd	Lloh156, Lloh157
	.loh AdrpLdrGot	Lloh154, Lloh155
	.loh AdrpLdrGot	Lloh152, Lloh153
	.loh AdrpLdrGot	Lloh150, Lloh151
	.loh AdrpLdrGot	Lloh148, Lloh149
	.loh AdrpLdrGot	Lloh146, Lloh147
	.loh AdrpLdrGot	Lloh144, Lloh145
	.loh AdrpLdrGot	Lloh142, Lloh143
	.loh AdrpLdrGot	Lloh140, Lloh141
	.loh AdrpLdrGot	Lloh138, Lloh139
	.loh AdrpLdrGot	Lloh136, Lloh137
	.loh AdrpLdrGot	Lloh134, Lloh135
	.loh AdrpLdrGot	Lloh132, Lloh133
	.loh AdrpLdrGot	Lloh130, Lloh131
	.loh AdrpLdrGot	Lloh128, Lloh129
	.loh AdrpLdrGot	Lloh126, Lloh127
	.loh AdrpLdrGot	Lloh124, Lloh125
	.loh AdrpLdrGot	Lloh122, Lloh123
	.loh AdrpLdrGot	Lloh120, Lloh121
	.loh AdrpLdrGot	Lloh118, Lloh119
	.loh AdrpLdrGot	Lloh116, Lloh117
	.loh AdrpLdrGot	Lloh114, Lloh115
	.loh AdrpLdrGot	Lloh112, Lloh113
	.loh AdrpLdrGot	Lloh110, Lloh111
	.loh AdrpLdrGot	Lloh108, Lloh109
	.loh AdrpLdrGot	Lloh106, Lloh107
	.loh AdrpLdrGot	Lloh104, Lloh105
	.loh AdrpLdrGot	Lloh102, Lloh103
	.loh AdrpLdrGot	Lloh100, Lloh101
	.loh AdrpLdrGot	Lloh98, Lloh99
	.loh AdrpLdrGot	Lloh96, Lloh97
	.loh AdrpLdrGot	Lloh94, Lloh95
	.loh AdrpLdrGot	Lloh92, Lloh93
	.loh AdrpAdd	Lloh90, Lloh91
	.loh AdrpAdd	Lloh160, Lloh161
	.loh AdrpAdd	Lloh158, Lloh159
	.loh AdrpLdr	Lloh162, Lloh163
	.loh AdrpAdd	Lloh164, Lloh165
	.loh AdrpAdd	Lloh166, Lloh167
	.loh AdrpAdd	Lloh171, Lloh172
	.loh AdrpLdrGotLdr	Lloh168, Lloh169, Lloh170
	.loh AdrpLdrGotLdr	Lloh173, Lloh174, Lloh175
	.loh AdrpAdd	Lloh176, Lloh177
	.loh AdrpAdd	Lloh181, Lloh182
	.loh AdrpLdrGotLdr	Lloh178, Lloh179, Lloh180
	.cfi_endproc
	.section	__TEXT,__const
lJTI133_0:
	.byte	(LBB133_37-LBB133_37)>>2
	.byte	(LBB133_40-LBB133_37)>>2
	.byte	(LBB133_42-LBB133_37)>>2
	.byte	(LBB133_43-LBB133_37)>>2
	.byte	(LBB133_41-LBB133_37)>>2
                                        ; -- End function
	.section	__TEXT,__literal8,8byte_literals
	.p2align	3, 0x0                          ; -- Begin function read_translation_unit_bytes
lCPI134_0:
	.long	4277009102                      ; 0xfeedface
	.long	1                               ; 0x1
	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
_read_translation_unit_bytes:           ; @read_translation_unit_bytes
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #160
	.cfi_def_cfa_offset 160
	stp	x28, x27, [sp, #64]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #80]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #96]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #112]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #128]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #144]            ; 16-byte Folded Spill
	add	x29, sp, #144
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	mov	x26, x8
	ldr	w8, [x0]
	mov	w9, #64206
	movk	w9, #65261, lsl #16
	cmp	w8, w9
	b.ne	LBB134_9
; %bb.1:
	ldr	w8, [x0, #4]
	cmp	w8, #1
	b.ne	LBB134_10
; %bb.2:
	ldp	w8, w24, [x0, #8]
	str	w8, [sp, #52]                   ; 4-byte Folded Spill
	add	x27, x0, #20
	ldr	w25, [x0, #16]
	cbz	w24, LBB134_12
; %bb.3:
	add	x8, x24, x24, lsl #2
	lsl	x0, x8, #3
	bl	_malloc
	mov	x20, x0
	mov	x23, #0
	b	LBB134_5
LBB134_4:                               ;   in Loop: Header=BB134_5 Depth=1
	add	x23, x23, #1
	cmp	x23, x24
	b.eq	LBB134_13
LBB134_5:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB134_7 Depth 2
	mov	x19, x27
	mov	w0, #40
	bl	_malloc
	mov	x21, x0
	str	x0, [x20, x23, lsl  #3]
	ldrb	w8, [x27]
	strb	w8, [x0]
	ldrb	w8, [x27, #1]
	strb	w8, [x0, #1]
	ldrb	w8, [x27, #2]
	strb	w8, [x0, #2]
	ldrb	w8, [x27, #3]
	strb	w8, [x0, #3]
	ldrb	w8, [x27, #4]
	strb	w8, [x0, #4]
	ldrb	w8, [x27, #5]
	strb	w8, [x0, #5]
	ldrb	w8, [x27, #6]
	strb	w8, [x0, #6]
	ldrb	w8, [x27, #7]
	strb	w8, [x0, #7]
	ldrb	w8, [x27, #8]
	strb	w8, [x0, #8]
	ldrb	w8, [x27, #9]
	strb	w8, [x0, #9]
	ldrb	w8, [x27, #10]
	strb	w8, [x0, #10]
	ldrb	w8, [x27, #11]
	strb	w8, [x0, #11]
	ldrb	w8, [x27, #12]
	strb	w8, [x0, #12]
	ldrb	w8, [x27, #13]
	strb	w8, [x0, #13]
	ldrb	w8, [x27, #14]
	strb	w8, [x0, #14]
	ldrb	w8, [x27, #15]
	strb	w8, [x0, #15]
	add	x27, x27, #20
	ldr	w22, [x19, #16]
	str	w22, [x0, #16]
	mov	x0, x22
	bl	_malloc
	str	x0, [x21, #24]
	cbz	w22, LBB134_4
; %bb.6:                                ;   in Loop: Header=BB134_5 Depth=1
	mov	x8, #0
LBB134_7:                               ;   Parent Loop BB134_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w9, [x27, x8]
	ldr	x10, [x21, #24]
	strb	w9, [x10, x8]
	add	x8, x8, #1
	ldr	x21, [x20, x23, lsl  #3]
	ldr	w9, [x21, #16]
	cmp	x8, x9
	b.lo	LBB134_7
; %bb.8:                                ;   in Loop: Header=BB134_5 Depth=1
	add	x27, x27, x8
	b	LBB134_4
LBB134_9:
	str	x8, [sp]
Lloh183:
	adrp	x0, l_.str.17@PAGE
Lloh184:
	add	x0, x0, l_.str.17@PAGEOFF
	b	LBB134_11
LBB134_10:
	mov	w9, #1
	stp	x9, x8, [sp]
Lloh185:
	adrp	x0, l_.str.18@PAGE
Lloh186:
	add	x0, x0, l_.str.18@PAGEOFF
LBB134_11:
	bl	_printf
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x26]
	str	q0, [x26, #32]
	b	LBB134_35
LBB134_12:
	mov	x20, #0
LBB134_13:
	mov	x28, x24
	str	x25, [sp, #56]                  ; 8-byte Folded Spill
	cbz	w25, LBB134_25
; %bb.14:
	str	x26, [sp, #40]                  ; 8-byte Folded Spill
	lsl	x22, x25, #3
	mov	x0, x22
	bl	_malloc
	mov	x21, x0
	mov	x19, #0
	b	LBB134_17
LBB134_15:                              ;   in Loop: Header=BB134_17 Depth=1
	mov	x24, x28
	ldr	x11, [sp, #56]                  ; 8-byte Folded Reload
LBB134_16:                              ;   in Loop: Header=BB134_17 Depth=1
	add	x19, x19, #1
	cmp	x19, x11
	b.eq	LBB134_21
LBB134_17:                              ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB134_20 Depth 2
	mov	w0, #96
	bl	_malloc
	mov	x23, x0
	str	x0, [x21, x19, lsl  #3]
	ldrh	w8, [x27]
	strh	w8, [x0]
	ldrh	w8, [x27, #2]
	strh	w8, [x0, #2]
	ldur	x8, [x27, #4]
	str	x8, [x0, #8]
	mov	w0, #29
	bl	_sysconf
	mov	x24, x0
	ldr	x26, [x23, #8]
	udiv	x8, x26, x0
	msub	x8, x8, x0, x26
	sub	x9, x0, x8
	cmp	x8, #0
	csel	x8, xzr, x9, eq
	add	x25, x8, x26
	mov	x1, x25
	bl	_aligned_alloc
	cbz	x0, LBB134_36
; %bb.18:                               ;   in Loop: Header=BB134_17 Depth=1
	add	x27, x27, #12
	str	x0, [x23, #16]
	cbz	x26, LBB134_15
; %bb.19:                               ;   in Loop: Header=BB134_17 Depth=1
	mov	x8, #0
	mov	x24, x28
	ldr	x11, [sp, #56]                  ; 8-byte Folded Reload
LBB134_20:                              ;   Parent Loop BB134_17 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w9, [x27], #1
	ldr	x10, [x23, #16]
	strb	w9, [x10, x8]
	add	w8, w8, #1
	ldr	x23, [x21, x19, lsl  #3]
	ldr	x9, [x23, #8]
	cmp	x9, x8
	b.hi	LBB134_20
	b	LBB134_16
LBB134_21:
	mov	x0, x22
	bl	_malloc
	mov	x8, #0
	mov	w9, #0
	ldr	x26, [sp, #40]                  ; 8-byte Folded Reload
	b	LBB134_23
LBB134_22:                              ;   in Loop: Header=BB134_23 Depth=1
	add	x8, x8, #8
	cmp	x22, x8
	b.eq	LBB134_26
LBB134_23:                              ; =>This Inner Loop Header: Depth=1
	ldr	x10, [x21, x8]
	ldrh	w11, [x10]
	cmp	w11, #2
	b.ne	LBB134_22
; %bb.24:                               ;   in Loop: Header=BB134_23 Depth=1
	str	x10, [x0, w9, uxtw  #3]
	add	w9, w9, #1
	b	LBB134_22
LBB134_25:
	mov	x0, #0
	bl	_malloc
	mov	x21, #0
LBB134_26:
	ldr	x25, [x0]
	ldr	x8, [x25, #16]
	ldr	x23, [x8]
	add	x8, x23, x23, lsl #1
	lsl	x19, x8, #3
	mov	x0, x19
	bl	_malloc
	cbz	x23, LBB134_34
; %bb.27:
	stp	x0, x19, [sp, #32]              ; 16-byte Folded Spill
	add	x19, x0, #16
	mov	w22, #8
	mov	x27, x23
LBB134_28:                              ; =>This Inner Loop Header: Depth=1
	ldr	x8, [x25, #16]
	add	x24, x8, x22
	ldr	q0, [x24], #16
	stur	q0, [x19, #-16]
	mov	x0, x24
	bl	_strlen
	add	x0, x0, #1
	bl	_malloc
	str	x0, [x19], #24
	mov	x1, x24
	bl	_strcpy
	mov	x0, x24
	bl	_strlen
	add	x8, x22, x0
	add	x22, x8, #17
	subs	x27, x27, #1
	b.ne	LBB134_28
; %bb.29:
	mov	x24, x28
	ldp	x0, x19, [sp, #32]              ; 16-byte Folded Reload
	cbz	x23, LBB134_34
; %bb.30:
	mov	x8, x0
	b	LBB134_32
LBB134_31:                              ;   in Loop: Header=BB134_32 Depth=1
	add	x8, x8, #24
	subs	x23, x23, #1
	b.eq	LBB134_34
LBB134_32:                              ; =>This Inner Loop Header: Depth=1
	ldr	x9, [x8]
	tbnz	x9, #63, LBB134_31
; %bb.33:                               ;   in Loop: Header=BB134_32 Depth=1
	ldr	x10, [x8, #8]
	ldr	x10, [x21, x10, lsl  #3]
	ldr	x10, [x10, #16]
	add	x9, x9, x10
	str	x9, [x8]
	b	LBB134_31
LBB134_34:
	stp	x19, x0, [x25, #8]
Lloh187:
	adrp	x8, lCPI134_0@PAGE
Lloh188:
	ldr	d0, [x8, lCPI134_0@PAGEOFF]
	str	d0, [x26]
	ldr	w8, [sp, #52]                   ; 4-byte Folded Reload
	stp	w8, w24, [x26, #8]
	str	x20, [x26, #16]
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	str	w8, [x26, #24]
	str	x21, [x26, #32]
LBB134_35:
	ldp	x29, x30, [sp, #144]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #128]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #112]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #96]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #80]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #64]             ; 16-byte Folded Reload
	add	sp, sp, #160
	ret
LBB134_36:
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	stp	x24, x0, [sp, #8]
	str	x25, [sp]
Lloh189:
	adrp	x0, l_.str.19@PAGE
Lloh190:
	add	x0, x0, l_.str.19@PAGEOFF
	bl	_printf
	mov	w0, #1
	bl	_exit
	.loh AdrpAdd	Lloh183, Lloh184
	.loh AdrpAdd	Lloh185, Lloh186
	.loh AdrpLdr	Lloh187, Lloh188
	.loh AdrpAdd	Lloh189, Lloh190
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function read_translation_unit
_read_translation_unit:                 ; @read_translation_unit
	.cfi_startproc
; %bb.0:
	stp	x22, x21, [sp, #-48]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 48
	stp	x20, x19, [sp, #16]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	sub	sp, sp, #16
	mov	x19, x0
	mov	x20, x8
Lloh191:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh192:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh193:
	ldr	x8, [x8]
	stur	x8, [x29, #-40]
	mov	x1, #0
	mov	w2, #2
	bl	_fseek
	mov	x0, x19
	bl	_ftell
	mov	x21, x0
	mov	x0, x19
	mov	x1, #0
	mov	w2, #0
	bl	_fseek
	mov	x9, x21
Lloh194:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh195:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	mov	x8, sp
	add	x9, x21, #15
	and	x9, x9, #0xfffffffffffffff0
	sub	x22, x8, x9
	mov	sp, x22
	mov	x0, x22
	mov	x1, x21
	mov	w2, #1
	mov	x3, x19
	bl	_fread
	mov	x8, x20
	mov	x0, x22
	bl	_read_translation_unit_bytes
	ldur	x8, [x29, #-40]
Lloh196:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh197:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh198:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB135_2
; %bb.1:
	sub	sp, x29, #32
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
LBB135_2:
	bl	___stack_chk_fail
	.loh AdrpLdrGotLdr	Lloh196, Lloh197, Lloh198
	.loh AdrpLdrGot	Lloh194, Lloh195
	.loh AdrpLdrGotLdr	Lloh191, Lloh192, Lloh193
	.cfi_endproc
                                        ; -- End function
	.globl	_svc_table                      ; @svc_table
.zerofill __DATA,__common,_svc_table,8,3
	.section	__DATA,__data
	.globl	_opc_0                          ; @opc_0
	.p2align	3, 0x0
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

	.globl	_opc_1                          ; @opc_1
	.p2align	3, 0x0
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

	.globl	_opc_2                          ; @opc_2
	.p2align	3, 0x0
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

	.globl	_opc_3                          ; @opc_3
	.p2align	3, 0x0
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

	.globl	_opc_4                          ; @opc_4
	.p2align	3, 0x0
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

	.globl	_opc_5                          ; @opc_5
	.p2align	3, 0x0
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

	.globl	_opc_6                          ; @opc_6
.zerofill __DATA,__common,_opc_6,32768,3
	.globl	_opc_7                          ; @opc_7
.zerofill __DATA,__common,_opc_7,32768,3
	.globl	_opc_8                          ; @opc_8
	.p2align	3, 0x0
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

	.globl	_opc_9                          ; @opc_9
	.p2align	3, 0x0
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

	.globl	_opc_10                         ; @opc_10
	.p2align	3, 0x0
_opc_10:
	.quad	0
	.quad	0
	.quad	_opcode_ldr$10
	.space	32744

	.globl	_opc_11                         ; @opc_11
	.p2align	3, 0x0
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

	.globl	_opc_12                         ; @opc_12
	.p2align	3, 0x0
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

	.globl	_opc_13                         ; @opc_13
.zerofill __DATA,__common,_opc_13,32768,3
	.globl	_opc_14                         ; @opc_14
.zerofill __DATA,__common,_opc_14,32768,3
	.globl	_opc_15                         ; @opc_15
.zerofill __DATA,__common,_opc_15,32768,3
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"%s at %p\n"

l_.str.1:                               ; @.str.1
	.asciz	"Failed to find symbol %s\n"

l_.str.2:                               ; @.str.2
	.asciz	"RELOCATE"

	.section	__DATA,__data
	.p2align	3, 0x0                          ; @main.act
_main.act:
	.quad	_sig_handler
	.long	1594                            ; 0x63a
	.long	64                              ; 0x40

	.section	__TEXT,__cstring,cstring_literals
l_.str.3:                               ; @.str.3
	.asciz	"Failed to set up signal handler\n"

l_.str.4:                               ; @.str.4
	.asciz	"Error: %s (%d)\n"

l_.str.5:                               ; @.str.5
	.asciz	"Usage: %s run <objfile>\n"

l_.str.6:                               ; @.str.6
	.asciz	"       %s comp <srcfile> <objfile>\n"

l_.str.7:                               ; @.str.7
	.asciz	"comp"

l_.str.8:                               ; @.str.8
	.asciz	"Usage: %s comp <srcfile> <objfile>\n"

l_.str.9:                               ; @.str.9
	.asciz	"wb"

l_.str.10:                              ; @.str.10
	.asciz	"run"

l_.str.11:                              ; @.str.11
	.asciz	"rb"

l_.str.12:                              ; @.str.12
	.asciz	"Could not open file '%s'\n"

	.section	__DATA,__data
_bios:                                  ; @bios
	.asciz	"\316\372\355\376\001\000\000\000\000\000\000\000\001\000\000\000\002\000\000\000RELOCATE\000\000\000\000\000\000\000\000\240\000\000\000\007\000\000\000\000\000\000\000\036\000\000\000\000\000\000\000\024\000\000\000\000\000\000\000\330\000\000\000\000\000\000\200\036\000\000\000\000\000\000\000^\000\000\000\000\000\000\000&\000\000\000\000\000\000\000d\000\000\000\000\000\000\000.\000\000\000\000\000\000\000\322\000\000\000\000\000\000\0006\000\000\000\000\000\000\000\324\000\000\000\000\000\000\000>\000\000\000\000\000\000\000\326\000\000\000\000\000\000\000\203\000\000\000\000\000\000\000\276\000\000\000\000\000\000\000\227\000\000\000\000\000\000\000\276\000\000\000\000\000\000\000\266\000\000\000\000\000\000\000~\000\000\000\000\000\000\000\001\000\027\000\330\000\000\000\000\000\000\000\0020\001\000\000\002\220\001\000\000\000\000\000\000\000\001 \000\"\200\t\000\000\000\000\000\000\000\001\000\002\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\006\000\000\000\000\000\000\000\007\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\002 \000\001\001\000\021\020\000\021\020\001\021\020\017\021\020\020\021\020\021\021\020\003\002 \017\002\002 \021\001\005\020\003\016\200\005\000\000\000\000\000\000\000!P\000\000\020\001\017\005\020\020\016\200\005\000\000\000\000\000\000\000\0020\016\000\000\002 \001\020\002 \002\021 \000\036\020\017\037\020\003\006\200\004\000\000\000\000\000\000\000\022\020\003\022\020\021\022\020\020\022\020\017\022\020\001\022\020\000\020\000\020\000\020\000\020\000\002\000!\0000\001\000\000\000\000\000\000\n\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000_start\000\036\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000syscall.branchtable\000^\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000syscall.exit\000d\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000syscall.write\000~\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000syscall.write_loop\000\276\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000syscall.write_end\000\322\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000syscall.read\000\324\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000syscall.open\000\326\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000syscall.close\000\330\000\000\000\000\000\000\200\000\000\000\000\000\000\000\000main"

	.section	__TEXT,__cstring,cstring_literals
l_.str.13:                              ; @.str.13
	.asciz	"_start"

l_.str.14:                              ; @.str.14
	.asciz	"Could not find _start symbol\n"

l_.str.15:                              ; @.str.15
	.asciz	"Unknown command '%s'\n"

l_.str.16:                              ; @.str.16
	.asciz	"Unknown instruction argument type %d in instruction %01x %03x\n"

l_.str.17:                              ; @.str.17
	.asciz	"Invalid object file magic: %08x\n"

l_.str.18:                              ; @.str.18
	.asciz	"Invalid object file version. Expected: %d, got: %d\n"

l_.str.19:                              ; @.str.19
	.asciz	"Failed to allocate %lu bytes aligned to %lu bytes: %s\n"

l_.str.20:                              ; @.str.20
	.asciz	"Executed in %llu ns\n"

	.section	__DATA,__const
	.p2align	3, 0x0                          ; @funcs
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

.subsections_via_symbols
