	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 14, 0
	.globl	_run_compile                    ; -- Begin function run_compile
	.p2align	2
_run_compile:                           ; @run_compile
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
	sub	sp, sp, #48
	mov	x19, x0
Lloh0:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh1:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh2:
	ldr	x8, [x8]
	stur	x8, [x29, #-56]
	bl	_strlen
	add	x0, x0, #1
	bl	_malloc
	adrp	x8, _file@PAGE
	str	x0, [x8, _file@PAGEOFF]
	mov	x1, x19
	bl	_strcpy
Lloh3:
	adrp	x1, l_.str@PAGE
Lloh4:
	add	x1, x1, l_.str@PAGEOFF
	mov	x0, x19
	bl	_fopen
	cbz	x0, LBB0_16
; %bb.1:
	mov	x22, x0
	mov	x1, #0
	mov	w2, #2
	bl	_fseek
	mov	x0, x22
	bl	_ftell
	mov	x20, x0
	mov	x0, x22
	mov	x1, #0
	mov	w2, #0
	bl	_fseek
	mov	x23, sp
	add	x9, x20, #1
Lloh5:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh6:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	mov	x8, sp
	add	x9, x20, #16
	and	x9, x9, #0xfffffffffffffff0
	sub	x21, x8, x9
	mov	sp, x21
	mov	x0, x21
	mov	w1, #1
	mov	x2, x20
	mov	x3, x22
	bl	_fread
	strb	wzr, [x21, x20]
	mov	x0, x22
	bl	_fclose
	cbz	x20, LBB0_13
; %bb.2:
	mov	x12, #0
	mov	w11, #0
	mov	w9, #0
	mov	w8, #0
	mov	w10, #32
	b	LBB0_5
LBB0_3:                                 ;   in Loop: Header=BB0_5 Depth=1
	cbz	w8, LBB0_9
LBB0_4:                                 ;   in Loop: Header=BB0_5 Depth=1
	eor	w9, w9, #0x1
	and	w9, w12, w9
	add	w11, w11, #1
	sxtw	x12, w11
	cmp	x20, x12
	b.ls	LBB0_13
LBB0_5:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_11 Depth 2
	ldrb	w13, [x21, x12]
	cmp	w13, #34
	cset	w12, ne
	orr	w12, w12, w9
	cmp	w8, #0
	cset	w14, eq
	tst	w12, #0x1
	csel	w8, w8, w14, ne
	cmp	w13, #92
	ccmp	w8, #0, #4, eq
	cset	w12, ne
	cmp	w13, #10
	ccmp	w8, #0, #4, eq
	b.ne	LBB0_17
; %bb.6:                                ;   in Loop: Header=BB0_5 Depth=1
	cmp	w13, #35
	b.eq	LBB0_3
; %bb.7:                                ;   in Loop: Header=BB0_5 Depth=1
	cmp	w13, #59
	b.eq	LBB0_3
; %bb.8:                                ;   in Loop: Header=BB0_5 Depth=1
	cmp	w13, #64
	b.eq	LBB0_3
	b	LBB0_4
LBB0_9:                                 ;   in Loop: Header=BB0_5 Depth=1
	mov	x13, x11
	sxtw	x13, w13
	ldrb	w14, [x21, x13]
	cmp	w14, #10
	b.eq	LBB0_4
; %bb.10:                               ;   in Loop: Header=BB0_5 Depth=1
	cmp	x20, x13
	b.ls	LBB0_4
LBB0_11:                                ;   Parent Loop BB0_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	x11, x21, x13
	strb	w10, [x11]
	add	x13, x13, #1
	ldrb	w11, [x11, #1]
	cmp	w11, #10
	ccmp	x20, x13, #0, ne
	b.hi	LBB0_11
; %bb.12:                               ;   in Loop: Header=BB0_5 Depth=1
	mov	x11, x13
	b	LBB0_4
LBB0_13:
	mov	w0, #32768
	bl	_malloc
	mov	x19, x0
	adrp	x20, _src@PAGE
	str	x21, [x20, _src@PAGEOFF]
	ldrb	w8, [x21]
	cbz	w8, LBB0_18
; %bb.14:
	mov	x21, #0
	mov	x22, x19
LBB0_15:                                ; =>This Inner Loop Header: Depth=1
	add	x21, x21, #1
	sub	x8, x29, #88
	bl	_nextToken
	ldur	q0, [x29, #-88]
	ldur	q1, [x29, #-72]
	stp	q0, q1, [x22], #32
	ldr	x8, [x20, _src@PAGEOFF]
	ldrb	w8, [x8]
	cbnz	w8, LBB0_15
	b	LBB0_19
LBB0_16:
	str	x19, [sp, #-16]!
Lloh7:
	adrp	x0, l_.str.1@PAGE
Lloh8:
	add	x0, x0, l_.str.1@PAGEOFF
	bl	_printf
	add	sp, sp, #16
	mov	x0, #0
	b	LBB0_21
LBB0_17:
                                        ; kill: def $w11 killed $w11 killed $x11 def $x11
	stp	x19, x11, [sp, #-16]!
Lloh9:
	adrp	x0, l_.str.2@PAGE
Lloh10:
	add	x0, x0, l_.str.2@PAGEOFF
	bl	_printf
	add	sp, sp, #16
	mov	x0, #0
	b	LBB0_20
LBB0_18:
	mov	x21, #0
LBB0_19:
	add	x8, x19, x21, lsl #5
	str	xzr, [x8]
	mov	w9, #-1
	str	w9, [x8, #8]
	stur	xzr, [x8, #20]
	stur	xzr, [x8, #12]
	str	wzr, [x8, #28]
	mov	x0, x19
	bl	_compile
LBB0_20:
	mov	sp, x23
LBB0_21:
	ldur	x8, [x29, #-56]
Lloh11:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh12:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh13:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB0_23
; %bb.22:
	sub	sp, x29, #48
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp], #64             ; 16-byte Folded Reload
	ret
LBB0_23:
	bl	___stack_chk_fail
	.loh AdrpAdd	Lloh3, Lloh4
	.loh AdrpLdrGotLdr	Lloh0, Lloh1, Lloh2
	.loh AdrpLdrGot	Lloh5, Lloh6
	.loh AdrpAdd	Lloh7, Lloh8
	.loh AdrpAdd	Lloh9, Lloh10
	.loh AdrpLdrGotLdr	Lloh11, Lloh12, Lloh13
	.cfi_endproc
                                        ; -- End function
	.globl	_parse                          ; -- Begin function parse
	.p2align	2
_parse:                                 ; @parse
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
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
	mov	x20, x0
	mov	w0, #32768
	bl	_malloc
	mov	x19, x0
	adrp	x21, _src@PAGE
	str	x20, [x21, _src@PAGEOFF]
	ldrb	w8, [x20]
	cbz	w8, LBB1_3
; %bb.1:
	mov	x20, #0
	mov	x22, x19
LBB1_2:                                 ; =>This Inner Loop Header: Depth=1
	add	x20, x20, #1
	mov	x8, sp
	bl	_nextToken
	ldp	q0, q1, [sp]
	stp	q0, q1, [x22], #32
	ldr	x8, [x21, _src@PAGEOFF]
	ldrb	w8, [x8]
	cbnz	w8, LBB1_2
	b	LBB1_4
LBB1_3:
	mov	x20, #0
LBB1_4:
	add	x8, x19, x20, lsl #5
	str	xzr, [x8]
	mov	w9, #-1
	str	w9, [x8, #8]
	stur	xzr, [x8, #20]
	stur	xzr, [x8, #12]
	str	wzr, [x8, #28]
	mov	x0, x19
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #80
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__literal8,8byte_literals
	.p2align	3, 0x0                          ; -- Begin function compile
lCPI2_0:
	.long	4                               ; 0x4
	.long	0                               ; 0x0
lCPI2_1:
	.long	1                               ; 0x1
	.long	0                               ; 0x0
lCPI2_2:
	.long	2                               ; 0x2
	.long	0                               ; 0x0
lCPI2_3:
	.long	3                               ; 0x3
	.long	0                               ; 0x0
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_compile
	.p2align	2
_compile:                               ; @compile
	.cfi_startproc
; %bb.0:
	stp	d13, d12, [sp, #-144]!          ; 16-byte Folded Spill
	.cfi_def_cfa_offset 144
	stp	d11, d10, [sp, #16]             ; 16-byte Folded Spill
	stp	d9, d8, [sp, #32]               ; 16-byte Folded Spill
	stp	x28, x27, [sp, #48]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #64]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #80]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #96]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #112]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #128]            ; 16-byte Folded Spill
	add	x29, sp, #128
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
	.cfi_offset b8, -104
	.cfi_offset b9, -112
	.cfi_offset b10, -120
	.cfi_offset b11, -128
	.cfi_offset b12, -136
	.cfi_offset b13, -144
	sub	sp, sp, #400
	mov	x27, x0
	mov	w0, #8
	bl	_malloc
	mov	x19, x0
	mov	w0, #96
	bl	_malloc
	mov	x20, x0
	mov	w9, #1
	str	x0, [x19]
	add	x8, sp, #128
	orr	x10, x8, #0x2
	strh	w9, [x0]
	add	x28, x8, #33
	add	x11, x8, #49
	add	x9, x8, #65
	stp	x9, x11, [sp, #48]              ; 16-byte Folded Spill
	add	x11, x8, #66
	add	x9, x8, #60
	stp	x9, x11, [sp, #32]              ; 16-byte Folded Spill
	add	x9, x8, #17
	stp	x9, x10, [sp, #112]             ; 16-byte Folded Spill
	add	x9, x8, #18
	stp	x19, x9, [sp, #96]              ; 16-byte Folded Spill
	add	x10, x8, #12
	add	x11, x8, #24
	orr	x23, x8, #0x1
	add	x9, x8, #44
	stp	x9, x11, [sp, #80]              ; 16-byte Folded Spill
Lloh14:
	adrp	x21, lJTI2_0@PAGE
Lloh15:
	add	x21, x21, lJTI2_0@PAGEOFF
	add	x8, x8, #50
	stp	x10, x8, [sp, #64]              ; 16-byte Folded Spill
Lloh16:
	adrp	x8, lCPI2_0@PAGE
Lloh17:
	ldr	d9, [x8, lCPI2_0@PAGEOFF]
Lloh18:
	adrp	x8, lCPI2_1@PAGE
Lloh19:
	ldr	d10, [x8, lCPI2_1@PAGEOFF]
Lloh20:
	adrp	x8, lCPI2_3@PAGE
Lloh21:
	ldr	d11, [x8, lCPI2_3@PAGEOFF]
Lloh22:
	adrp	x8, lCPI2_2@PAGE
Lloh23:
	ldr	d12, [x8, lCPI2_2@PAGEOFF]
Lloh24:
	adrp	x26, lJTI2_1@PAGE
Lloh25:
	add	x26, x26, lJTI2_1@PAGEOFF
Lloh26:
	adrp	x25, lJTI2_2@PAGE
Lloh27:
	add	x25, x25, lJTI2_2@PAGEOFF
	b	LBB2_4
LBB2_1:                                 ;   in Loop: Header=BB2_4 Depth=1
	strb	wzr, [x8]
LBB2_2:                                 ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x20
	bl	_add_symbol
	ldr	x8, [x20, #88]
	mov	w9, #24
	smaddl	x8, w0, w9, x8
	str	xzr, [x8, #8]
LBB2_3:                                 ;   in Loop: Header=BB2_4 Depth=1
	add	x27, x27, #32
LBB2_4:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB2_95 Depth 2
                                        ;     Child Loop BB2_66 Depth 2
                                        ;     Child Loop BB2_472 Depth 2
                                        ;     Child Loop BB2_445 Depth 2
                                        ;     Child Loop BB2_402 Depth 2
                                        ;     Child Loop BB2_356 Depth 2
                                        ;     Child Loop BB2_309 Depth 2
                                        ;     Child Loop BB2_169 Depth 2
	ldr	w8, [x27, #8]
	add	w8, w8, #1
	cmp	w8, #7
	b.hi	LBB2_3
; %bb.5:                                ;   in Loop: Header=BB2_4 Depth=1
	adr	x9, LBB2_3
	ldrh	w10, [x21, x8, lsl  #1]
	add	x9, x9, x10, lsl #2
	br	x9
LBB2_6:                                 ;   in Loop: Header=BB2_4 Depth=1
	ldr	x24, [x27]
	mov	x0, x24
Lloh28:
	adrp	x1, l_.str.3@PAGE
Lloh29:
	add	x1, x1, l_.str.3@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_114
; %bb.7:                                ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh30:
	adrp	x1, l_.str.4@PAGE
Lloh31:
	add	x1, x1, l_.str.4@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_112
; %bb.8:                                ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh32:
	adrp	x1, l_.str.5@PAGE
Lloh33:
	add	x1, x1, l_.str.5@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_112
; %bb.9:                                ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh34:
	adrp	x1, l_.str.6@PAGE
Lloh35:
	add	x1, x1, l_.str.6@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_131
; %bb.10:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh36:
	adrp	x1, l_.str.11@PAGE
Lloh37:
	add	x1, x1, l_.str.11@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_150
; %bb.11:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh38:
	adrp	x1, l_.str.13@PAGE
Lloh39:
	add	x1, x1, l_.str.13@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_194
; %bb.12:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh40:
	adrp	x1, l_.str.14@PAGE
Lloh41:
	add	x1, x1, l_.str.14@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_219
; %bb.13:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh42:
	adrp	x1, l_.str.15@PAGE
Lloh43:
	add	x1, x1, l_.str.15@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_273
; %bb.14:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh44:
	adrp	x1, l_.str.17@PAGE
Lloh45:
	add	x1, x1, l_.str.17@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_337
; %bb.15:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh46:
	adrp	x1, l_.str.18@PAGE
Lloh47:
	add	x1, x1, l_.str.18@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_380
; %bb.16:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh48:
	adrp	x1, l_.str.19@PAGE
Lloh49:
	add	x1, x1, l_.str.19@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_420
; %bb.17:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh50:
	adrp	x1, l_.str.20@PAGE
Lloh51:
	add	x1, x1, l_.str.20@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_460
; %bb.18:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh52:
	adrp	x1, l_.str.21@PAGE
Lloh53:
	add	x1, x1, l_.str.21@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_489
; %bb.19:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh54:
	adrp	x1, l_.str.22@PAGE
Lloh55:
	add	x1, x1, l_.str.22@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_499
; %bb.20:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh56:
	adrp	x1, l_.str.23@PAGE
Lloh57:
	add	x1, x1, l_.str.23@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_508
; %bb.21:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh58:
	adrp	x1, l_.str.24@PAGE
Lloh59:
	add	x1, x1, l_.str.24@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_516
; %bb.22:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh60:
	adrp	x1, l_.str.25@PAGE
Lloh61:
	add	x1, x1, l_.str.25@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_525
; %bb.23:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh62:
	adrp	x1, l_.str.26@PAGE
Lloh63:
	add	x1, x1, l_.str.26@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_530
; %bb.24:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh64:
	adrp	x1, l_.str.27@PAGE
Lloh65:
	add	x1, x1, l_.str.27@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_534
; %bb.25:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh66:
	adrp	x1, l_.str.28@PAGE
Lloh67:
	add	x1, x1, l_.str.28@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_538
; %bb.26:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh68:
	adrp	x1, l_.str.29@PAGE
Lloh69:
	add	x1, x1, l_.str.29@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_542
; %bb.27:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh70:
	adrp	x1, l_.str.30@PAGE
Lloh71:
	add	x1, x1, l_.str.30@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_546
; %bb.28:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh72:
	adrp	x1, l_.str.31@PAGE
Lloh73:
	add	x1, x1, l_.str.31@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_550
; %bb.29:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh74:
	adrp	x1, l_.str.32@PAGE
Lloh75:
	add	x1, x1, l_.str.32@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_555
; %bb.30:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh76:
	adrp	x1, l_.str.33@PAGE
Lloh77:
	add	x1, x1, l_.str.33@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_559
; %bb.31:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh78:
	adrp	x1, l_.str.34@PAGE
Lloh79:
	add	x1, x1, l_.str.34@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_565
; %bb.32:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh80:
	adrp	x1, l_.str.35@PAGE
Lloh81:
	add	x1, x1, l_.str.35@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_570
; %bb.33:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh82:
	adrp	x1, l_.str.36@PAGE
Lloh83:
	add	x1, x1, l_.str.36@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_572
; %bb.34:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh84:
	adrp	x1, l_.str.37@PAGE
Lloh85:
	add	x1, x1, l_.str.37@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_573
; %bb.35:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh86:
	adrp	x1, l_.str.38@PAGE
Lloh87:
	add	x1, x1, l_.str.38@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_575
; %bb.36:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh88:
	adrp	x1, l_.str.39@PAGE
Lloh89:
	add	x1, x1, l_.str.39@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_576
; %bb.37:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh90:
	adrp	x1, l_.str.40@PAGE
Lloh91:
	add	x1, x1, l_.str.40@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_580
; %bb.38:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh92:
	adrp	x1, l_.str.41@PAGE
Lloh93:
	add	x1, x1, l_.str.41@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_581
; %bb.39:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh94:
	adrp	x1, l_.str.42@PAGE
Lloh95:
	add	x1, x1, l_.str.42@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_585
; %bb.40:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh96:
	adrp	x1, l_.str.43@PAGE
Lloh97:
	add	x1, x1, l_.str.43@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_588
; %bb.41:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh98:
	adrp	x1, l_.str.44@PAGE
Lloh99:
	add	x1, x1, l_.str.44@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_596
; %bb.42:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh100:
	adrp	x1, l_.str.45@PAGE
Lloh101:
	add	x1, x1, l_.str.45@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_602
; %bb.43:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh102:
	adrp	x1, l_.str.46@PAGE
Lloh103:
	add	x1, x1, l_.str.46@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_608
; %bb.44:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh104:
	adrp	x1, l_.str.47@PAGE
Lloh105:
	add	x1, x1, l_.str.47@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_615
; %bb.45:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh106:
	adrp	x1, l_.str.48@PAGE
Lloh107:
	add	x1, x1, l_.str.48@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_622
; %bb.46:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh108:
	adrp	x1, l_.str.49@PAGE
Lloh109:
	add	x1, x1, l_.str.49@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_629
; %bb.47:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh110:
	adrp	x1, l_.str.50@PAGE
Lloh111:
	add	x1, x1, l_.str.50@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_636
; %bb.48:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh112:
	adrp	x1, l_.str.51@PAGE
Lloh113:
	add	x1, x1, l_.str.51@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_643
; %bb.49:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh114:
	adrp	x1, l_.str.52@PAGE
Lloh115:
	add	x1, x1, l_.str.52@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_650
; %bb.50:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh116:
	adrp	x1, l_.str.53@PAGE
Lloh117:
	add	x1, x1, l_.str.53@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_658
; %bb.51:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh118:
	adrp	x1, l_.str.54@PAGE
Lloh119:
	add	x1, x1, l_.str.54@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_664
; %bb.52:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh120:
	adrp	x1, l_.str.55@PAGE
Lloh121:
	add	x1, x1, l_.str.55@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_667
; %bb.53:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh122:
	adrp	x1, l_.str.56@PAGE
Lloh123:
	add	x1, x1, l_.str.56@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_675
; %bb.54:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x24
Lloh124:
	adrp	x1, l_.str.57@PAGE
Lloh125:
	add	x1, x1, l_.str.57@PAGEOFF
	bl	_strcmp
	cbnz	w0, LBB2_725
; %bb.55:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #1
	b.ne	LBB2_704
; %bb.56:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #32]
	add	x0, x8, #1
	bl	_parse8
	ldr	w8, [x27, #72]
	cbnz	w8, LBB2_726
; %bb.57:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x24, x0
	ldr	x19, [x27, #64]
	mov	x0, x19
Lloh126:
	adrp	x1, l_.str.59@PAGE
Lloh127:
	add	x1, x1, l_.str.59@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_676
; %bb.58:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x19
Lloh128:
	adrp	x1, l_.str.60@PAGE
Lloh129:
	add	x1, x1, l_.str.60@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_677
; %bb.59:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x19
Lloh130:
	adrp	x1, l_.str.61@PAGE
Lloh131:
	add	x1, x1, l_.str.61@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_61
; %bb.60:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x19
Lloh132:
	adrp	x1, l_.str.62@PAGE
Lloh133:
	add	x1, x1, l_.str.62@PAGEOFF
	bl	_strcmp
	cbnz	w0, LBB2_727
LBB2_61:                                ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x19
Lloh134:
	adrp	x1, l_.str.61@PAGE
Lloh135:
	add	x1, x1, l_.str.61@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_678
; %bb.62:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x19
Lloh136:
	adrp	x1, l_.str.62@PAGE
Lloh137:
	add	x1, x1, l_.str.62@PAGEOFF
	bl	_strcmp
	cmp	w0, #0
	cset	w8, eq
	lsl	w21, w8, #3
	b	LBB2_679
LBB2_63:                                ;   in Loop: Header=BB2_4 Depth=1
	ldr	x19, [x27]
	mov	x0, x19
	bl	_strlen
	add	x0, x0, #1
	bl	_malloc
	mov	x1, x0
	mov	x8, x0
	b	LBB2_66
LBB2_64:                                ;   in Loop: Header=BB2_66 Depth=2
	cbz	w9, LBB2_1
LBB2_65:                                ;   in Loop: Header=BB2_66 Depth=2
	strb	w9, [x8], #1
	add	x19, x19, #1
LBB2_66:                                ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w9, [x19]
	cmp	w9, #92
	b.ne	LBB2_64
; %bb.67:                               ;   in Loop: Header=BB2_66 Depth=2
	ldrsb	w10, [x19, #1]!
	cmp	w10, #91
	b.le	LBB2_71
; %bb.68:                               ;   in Loop: Header=BB2_66 Depth=2
	sub	w11, w10, #92
	cmp	w11, #24
	b.hi	LBB2_126
; %bb.69:                               ;   in Loop: Header=BB2_66 Depth=2
	mov	w9, #10
	adr	x12, LBB2_65
	ldrh	w13, [x26, x11, lsl  #1]
	add	x12, x12, x13, lsl #2
	br	x12
LBB2_70:                                ;   in Loop: Header=BB2_66 Depth=2
	mov	w9, #92
	b	LBB2_65
LBB2_71:                                ;   in Loop: Header=BB2_66 Depth=2
	cmp	w10, #34
	b.eq	LBB2_78
; %bb.72:                               ;   in Loop: Header=BB2_66 Depth=2
	cmp	w10, #39
	b.eq	LBB2_77
; %bb.73:                               ;   in Loop: Header=BB2_66 Depth=2
	cmp	w10, #48
	b.ne	LBB2_126
; %bb.74:                               ;   in Loop: Header=BB2_66 Depth=2
	mov	w9, #0
	b	LBB2_65
LBB2_75:                                ;   in Loop: Header=BB2_66 Depth=2
	mov	w9, #9
	b	LBB2_65
LBB2_76:                                ;   in Loop: Header=BB2_66 Depth=2
	mov	w9, #13
	b	LBB2_65
LBB2_77:                                ;   in Loop: Header=BB2_66 Depth=2
	mov	w9, #39
	b	LBB2_65
LBB2_78:                                ;   in Loop: Header=BB2_66 Depth=2
	mov	w9, #34
	b	LBB2_65
LBB2_79:                                ;   in Loop: Header=BB2_4 Depth=1
	ldr	x19, [x27]
	mov	x0, x19
Lloh138:
	adrp	x1, l_.str.66@PAGE
Lloh139:
	add	x1, x1, l_.str.66@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_91
; %bb.80:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x19
Lloh140:
	adrp	x1, l_.str.67@PAGE
Lloh141:
	add	x1, x1, l_.str.67@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_91
; %bb.81:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x19
Lloh142:
	adrp	x1, l_.str.59@PAGE
Lloh143:
	add	x1, x1, l_.str.59@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_120
; %bb.82:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x19
Lloh144:
	adrp	x1, l_.str.60@PAGE
Lloh145:
	add	x1, x1, l_.str.60@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_137
; %bb.83:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x19
Lloh146:
	adrp	x1, l_.str.61@PAGE
Lloh147:
	add	x1, x1, l_.str.61@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_156
; %bb.84:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x19
Lloh148:
	adrp	x1, l_.str.62@PAGE
Lloh149:
	add	x1, x1, l_.str.62@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_188
; %bb.85:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x19
Lloh150:
	adrp	x1, l_.str.70@PAGE
Lloh151:
	add	x1, x1, l_.str.70@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_225
; %bb.86:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x19
Lloh152:
	adrp	x1, l_.str.71@PAGE
Lloh153:
	add	x1, x1, l_.str.71@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_280
; %bb.87:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x19
Lloh154:
	adrp	x1, l_.str.72@PAGE
Lloh155:
	add	x1, x1, l_.str.72@PAGEOFF
	bl	_strcmp
	cbnz	w0, LBB2_710
; %bb.88:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cbnz	w8, LBB2_712
; %bb.89:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x19, [x27, #32]!
	ldp	x8, x9, [x20, #32]
	add	x10, x8, #1
	str	x10, [x20, #32]
	cmp	x8, x9
	b.ne	LBB2_298
; %bb.90:                               ;   in Loop: Header=BB2_4 Depth=1
	lsl	x9, x8, #1
	cmp	x8, #0
	mov	w8, #16
	csel	x8, x8, x9, eq
	str	x8, [x20, #40]
	ldr	x0, [x20, #24]
	add	x8, x8, x8, lsl #4
	lsl	x1, x8, #4
	bl	_realloc
	str	x0, [x20, #24]
	ldr	x8, [x20, #32]
	sub	x8, x8, #1
	b	LBB2_299
LBB2_91:                                ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #5
	b.ne	LBB2_702
; %bb.92:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x22, x27, #32
	ldr	x19, [x22]
	mov	x0, x19
	bl	_strlen
	add	x0, x0, #1
	bl	_malloc
	mov	x24, x0
	mov	x8, x0
	b	LBB2_95
LBB2_93:                                ;   in Loop: Header=BB2_95 Depth=2
	cbz	w9, LBB2_108
LBB2_94:                                ;   in Loop: Header=BB2_95 Depth=2
	strb	w9, [x8], #1
	add	x19, x19, #1
LBB2_95:                                ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w9, [x19]
	cmp	w9, #92
	b.ne	LBB2_93
; %bb.96:                               ;   in Loop: Header=BB2_95 Depth=2
	ldrsb	w10, [x19, #1]!
	cmp	w10, #91
	b.le	LBB2_100
; %bb.97:                               ;   in Loop: Header=BB2_95 Depth=2
	sub	w11, w10, #92
	cmp	w11, #24
	b.hi	LBB2_149
; %bb.98:                               ;   in Loop: Header=BB2_95 Depth=2
	mov	w9, #10
	adr	x12, LBB2_94
	ldrh	w13, [x25, x11, lsl  #1]
	add	x12, x12, x13, lsl #2
	br	x12
LBB2_99:                                ;   in Loop: Header=BB2_95 Depth=2
	mov	w9, #92
	b	LBB2_94
LBB2_100:                               ;   in Loop: Header=BB2_95 Depth=2
	cmp	w10, #34
	b.eq	LBB2_107
; %bb.101:                              ;   in Loop: Header=BB2_95 Depth=2
	cmp	w10, #39
	b.eq	LBB2_106
; %bb.102:                              ;   in Loop: Header=BB2_95 Depth=2
	cmp	w10, #48
	b.ne	LBB2_149
; %bb.103:                              ;   in Loop: Header=BB2_95 Depth=2
	mov	w9, #0
	b	LBB2_94
LBB2_104:                               ;   in Loop: Header=BB2_95 Depth=2
	mov	w9, #9
	b	LBB2_94
LBB2_105:                               ;   in Loop: Header=BB2_95 Depth=2
	mov	w9, #13
	b	LBB2_94
LBB2_106:                               ;   in Loop: Header=BB2_95 Depth=2
	mov	w9, #39
	b	LBB2_94
LBB2_107:                               ;   in Loop: Header=BB2_95 Depth=2
	mov	w9, #34
	b	LBB2_94
LBB2_108:                               ;   in Loop: Header=BB2_4 Depth=1
	strb	wzr, [x8]
LBB2_109:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x27]
Lloh156:
	adrp	x1, l_.str.67@PAGE
Lloh157:
	add	x1, x1, l_.str.67@PAGEOFF
	bl	_strcmp
	mov	x19, x0
	mov	x0, x24
	bl	_strlen
	mov	x27, x0
	cbz	w19, LBB2_116
; %bb.110:                              ;   in Loop: Header=BB2_4 Depth=1
	ldp	x8, x9, [x20, #32]
	add	x10, x8, #1
	str	x10, [x20, #32]
	cmp	x8, x9
	b.ne	LBB2_118
; %bb.111:                              ;   in Loop: Header=BB2_4 Depth=1
	lsl	x9, x8, #1
	cmp	x8, #0
	mov	w8, #16
	csel	x8, x8, x9, eq
	str	x8, [x20, #40]
	ldr	x0, [x20, #24]
	add	x8, x8, x8, lsl #4
	lsl	x1, x8, #4
	bl	_realloc
	str	x0, [x20, #24]
	ldr	x8, [x20, #32]
	sub	x8, x8, #1
	b	LBB2_119
LBB2_112:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #16
	strb	w8, [sp, #128]
LBB2_113:                               ;   in Loop: Header=BB2_4 Depth=1
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x23]
	stp	q0, q0, [x23, #32]
	stp	q0, q0, [x23, #64]
	stp	q0, q0, [x23, #96]
	stp	q0, q0, [x23, #128]
	stp	q0, q0, [x23, #160]
	stp	q0, q0, [x23, #192]
	stp	q0, q0, [x23, #224]
	stur	xzr, [x23, #255]
	b	LBB2_115
LBB2_114:                               ;   in Loop: Header=BB2_4 Depth=1
	str	xzr, [sp, #384]
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [sp, #352]
	stp	q0, q0, [sp, #320]
	stp	q0, q0, [sp, #288]
	stp	q0, q0, [sp, #256]
	stp	q0, q0, [sp, #224]
	stp	q0, q0, [sp, #192]
	stp	q0, q0, [sp, #160]
	stp	q0, q0, [sp, #128]
LBB2_115:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x1, sp, #128
	mov	x0, x20
	bl	_add_instruction
	add	x27, x27, #32
	b	LBB2_4
LBB2_116:                               ;   in Loop: Header=BB2_4 Depth=1
	ldp	x8, x9, [x20, #32]
	add	x10, x8, #1
	str	x10, [x20, #32]
	cmp	x8, x9
	b.ne	LBB2_127
; %bb.117:                              ;   in Loop: Header=BB2_4 Depth=1
	lsl	x9, x8, #1
	cmp	x8, #0
	mov	w8, #16
	csel	x8, x8, x9, eq
	str	x8, [x20, #40]
	ldr	x0, [x20, #24]
	add	x8, x8, x8, lsl #4
	lsl	x1, x8, #4
	bl	_realloc
	str	x0, [x20, #24]
	ldr	x8, [x20, #32]
	sub	x8, x8, #1
	b	LBB2_128
LBB2_118:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x20, #24]
LBB2_119:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #1
	mov	w21, #272
	madd	x27, x8, x21, x0
	str	wzr, [x27]
	mov	x0, x19
	bl	_malloc
	str	x0, [x27, #8]
	ldp	x8, x9, [x20, #24]
	madd	x8, x9, x21, x8
	sub	x8, x8, #264
	ldr	x0, [x8]
	mov	x1, x24
	mov	x2, x19
	bl	_memcpy
	ldp	x8, x9, [x20, #24]
	madd	x8, x9, x21, x8
	stur	x19, [x8, #-256]
	ldr	x8, [x20, #48]
	add	x8, x8, x19
	b	LBB2_129
LBB2_120:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #3
	b.ne	LBB2_703
; %bb.121:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x27, #32]!
	ldrb	w8, [x0]
	cmp	w8, #48
	b.ne	LBB2_143
; %bb.122:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w8, [x0, #1]
	cmp	w8, #98
	b.eq	LBB2_260
; %bb.123:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #111
	b.eq	LBB2_259
; %bb.124:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #120
	b.ne	LBB2_143
; %bb.125:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #16
	b	LBB2_144
LBB2_126:                               ;   in Loop: Header=BB2_4 Depth=1
	str	x10, [sp]
Lloh158:
	adrp	x0, l_.str.74@PAGE
Lloh159:
	add	x0, x0, l_.str.74@PAGEOFF
	bl	_printf
	mov	x1, #0
	b	LBB2_2
LBB2_127:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x20, #24]
LBB2_128:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w21, #272
	madd	x19, x8, x21, x0
	str	wzr, [x19]
	mov	x0, x27
	bl	_malloc
	str	x0, [x19, #8]
	ldp	x8, x9, [x20, #24]
	madd	x8, x9, x21, x8
	sub	x8, x8, #264
	ldr	x0, [x8]
	mov	x1, x24
	mov	x2, x27
	bl	_memcpy
	ldp	x8, x9, [x20, #24]
	madd	x8, x9, x21, x8
	stur	x27, [x8, #-256]
	ldr	x8, [x20, #48]
	add	x8, x8, x27
LBB2_129:                               ;   in Loop: Header=BB2_4 Depth=1
	str	x8, [x20, #48]
LBB2_130:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x22
Lloh160:
	adrp	x21, lJTI2_0@PAGE
Lloh161:
	add	x21, x21, lJTI2_0@PAGEOFF
	add	x27, x22, #32
	b	LBB2_4
LBB2_131:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #1
	b.ne	LBB2_704
; %bb.132:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #32]
	mov	x0, x8
	ldrb	w9, [x0, #1]!
	cmp	w9, #48
	b.ne	LBB2_162
; %bb.133:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w9, [x8, #2]
	cmp	w9, #98
	b.eq	LBB2_295
; %bb.134:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #111
	b.eq	LBB2_293
; %bb.135:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #120
	b.ne	LBB2_162
; %bb.136:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #16
	b	LBB2_163
LBB2_137:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #3
	b.ne	LBB2_703
; %bb.138:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x27, #32]!
	ldrb	w8, [x0]
	cmp	w8, #48
	b.ne	LBB2_182
; %bb.139:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w8, [x0, #1]
	cmp	w8, #98
	b.eq	LBB2_296
; %bb.140:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #111
	b.eq	LBB2_294
; %bb.141:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #120
	b.ne	LBB2_182
; %bb.142:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #16
	b	LBB2_183
LBB2_143:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_144:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoul
LBB2_145:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x19, x0
	ldp	x8, x9, [x20, #32]
	add	x10, x8, #1
	str	x10, [x20, #32]
	cmp	x8, x9
	b.ne	LBB2_147
; %bb.146:                              ;   in Loop: Header=BB2_4 Depth=1
	lsl	x9, x8, #1
	cmp	x8, #0
	mov	w8, #16
	csel	x8, x8, x9, eq
	str	x8, [x20, #40]
	ldr	x0, [x20, #24]
	add	x8, x8, x8, lsl #4
	lsl	x1, x8, #4
	bl	_realloc
	str	x0, [x20, #24]
	ldr	x8, [x20, #32]
	sub	x8, x8, #1
	b	LBB2_148
LBB2_147:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x20, #24]
LBB2_148:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w21, #272
	madd	x22, x8, x21, x0
	str	wzr, [x22]
	mov	w0, #1
	bl	_malloc
	str	x0, [x22, #8]
	ldp	x8, x9, [x20, #24]
	madd	x8, x9, x21, x8
	sub	x8, x8, #264
	ldr	x8, [x8]
	strb	w19, [x8]
	ldp	x8, x9, [x20, #24]
	madd	x8, x9, x21, x8
	mov	w9, #1
	stur	x9, [x8, #-256]
	ldr	x8, [x20, #48]
	add	x8, x8, #1
	b	LBB2_372
LBB2_149:                               ;   in Loop: Header=BB2_4 Depth=1
	str	x10, [sp]
Lloh162:
	adrp	x0, l_.str.74@PAGE
Lloh163:
	add	x0, x0, l_.str.74@PAGEOFF
	bl	_printf
	mov	x24, #0
	b	LBB2_109
LBB2_150:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #1
	b.ne	LBB2_704
; %bb.151:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #32]
	mov	x0, x8
	ldrb	w9, [x0, #1]!
	cmp	w9, #48
	b.ne	LBB2_203
; %bb.152:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w9, [x8, #2]
	cmp	w9, #98
	b.eq	LBB2_351
; %bb.153:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #111
	b.eq	LBB2_349
; %bb.154:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #120
	b.ne	LBB2_203
; %bb.155:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #16
	b	LBB2_204
LBB2_156:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #3
	b.ne	LBB2_703
; %bb.157:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x27, #32]!
	ldrb	w8, [x0]
	cmp	w8, #48
	b.ne	LBB2_200
; %bb.158:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w8, [x0, #1]
	cmp	w8, #98
	b.eq	LBB2_352
; %bb.159:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #111
	b.eq	LBB2_350
; %bb.160:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #120
	b.ne	LBB2_200
; %bb.161:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #16
	b	LBB2_201
LBB2_162:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_163:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoul
LBB2_164:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x24, x0
	ldr	w8, [x27, #72]
	cmp	w8, #7
	b.hi	LBB2_711
; %bb.165:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #64
Lloh164:
	adrp	x11, lJTI2_7@PAGE
Lloh165:
	add	x11, x11, lJTI2_7@PAGEOFF
	adr	x9, LBB2_166
	ldrh	w10, [x11, x8, lsl  #1]
	add	x9, x9, x10, lsl #2
	br	x9
LBB2_166:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x27, [x19]
	mov	x0, x27
	bl	_strlen
	add	x0, x0, #1
	bl	_malloc
	mov	x8, x0
	b	LBB2_169
LBB2_167:                               ;   in Loop: Header=BB2_169 Depth=2
	cbz	w9, LBB2_257
LBB2_168:                               ;   in Loop: Header=BB2_169 Depth=2
	strb	w9, [x8], #1
	add	x27, x27, #1
LBB2_169:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w9, [x27]
	cmp	w9, #92
	b.ne	LBB2_167
; %bb.170:                              ;   in Loop: Header=BB2_169 Depth=2
	ldrsb	w10, [x27, #1]!
	cmp	w10, #91
	b.le	LBB2_174
; %bb.171:                              ;   in Loop: Header=BB2_169 Depth=2
	sub	w11, w10, #92
	cmp	w11, #24
	b.hi	LBB2_458
; %bb.172:                              ;   in Loop: Header=BB2_169 Depth=2
	mov	w9, #10
Lloh166:
	adrp	x14, lJTI2_9@PAGE
Lloh167:
	add	x14, x14, lJTI2_9@PAGEOFF
	adr	x12, LBB2_168
	ldrh	w13, [x14, x11, lsl  #1]
	add	x12, x12, x13, lsl #2
	br	x12
LBB2_173:                               ;   in Loop: Header=BB2_169 Depth=2
	mov	w9, #92
	b	LBB2_168
LBB2_174:                               ;   in Loop: Header=BB2_169 Depth=2
	cmp	w10, #34
	b.eq	LBB2_181
; %bb.175:                              ;   in Loop: Header=BB2_169 Depth=2
	cmp	w10, #39
	b.eq	LBB2_180
; %bb.176:                              ;   in Loop: Header=BB2_169 Depth=2
	cmp	w10, #48
	b.ne	LBB2_458
; %bb.177:                              ;   in Loop: Header=BB2_169 Depth=2
	mov	w9, #0
	b	LBB2_168
LBB2_178:                               ;   in Loop: Header=BB2_169 Depth=2
	mov	w9, #9
	b	LBB2_168
LBB2_179:                               ;   in Loop: Header=BB2_169 Depth=2
	mov	w9, #13
	b	LBB2_168
LBB2_180:                               ;   in Loop: Header=BB2_169 Depth=2
	mov	w9, #39
	b	LBB2_168
LBB2_181:                               ;   in Loop: Header=BB2_169 Depth=2
	mov	w9, #34
	b	LBB2_168
LBB2_182:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_183:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoul
LBB2_184:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x19, x0
	ldp	x8, x9, [x20, #32]
	add	x10, x8, #1
	str	x10, [x20, #32]
	cmp	x8, x9
	b.ne	LBB2_186
; %bb.185:                              ;   in Loop: Header=BB2_4 Depth=1
	lsl	x9, x8, #1
	cmp	x8, #0
	mov	w8, #16
	csel	x8, x8, x9, eq
	str	x8, [x20, #40]
	ldr	x0, [x20, #24]
	add	x8, x8, x8, lsl #4
	lsl	x1, x8, #4
	bl	_realloc
	str	x0, [x20, #24]
	ldr	x8, [x20, #32]
	sub	x8, x8, #1
	b	LBB2_187
LBB2_186:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x20, #24]
LBB2_187:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w21, #272
	madd	x22, x8, x21, x0
	str	wzr, [x22]
	mov	w0, #2
	bl	_malloc
	str	x0, [x22, #8]
	ldp	x8, x9, [x20, #24]
	madd	x8, x9, x21, x8
	sub	x9, x8, #264
	ldr	x9, [x9]
	strh	w19, [x9]
	mov	w9, #2
	stur	x9, [x8, #-256]
	ldr	x8, [x20, #48]
	add	x8, x8, #2
	b	LBB2_372
LBB2_188:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #3
	b.ne	LBB2_703
; %bb.189:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x27, #32]!
	ldrb	w8, [x0]
	cmp	w8, #48
	b.ne	LBB2_245
; %bb.190:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w8, [x0, #1]
	cmp	w8, #98
	b.eq	LBB2_394
; %bb.191:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #111
	b.eq	LBB2_392
; %bb.192:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #120
	b.ne	LBB2_245
; %bb.193:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #16
	b	LBB2_246
LBB2_194:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #1
	b.ne	LBB2_704
; %bb.195:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #32]
	mov	x0, x8
	ldrb	w9, [x0, #1]!
	cmp	w9, #48
	b.ne	LBB2_248
; %bb.196:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w9, [x8, #2]
	cmp	w9, #98
	b.eq	LBB2_395
; %bb.197:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #111
	b.eq	LBB2_393
; %bb.198:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #120
	b.ne	LBB2_248
; %bb.199:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #16
	b	LBB2_249
LBB2_200:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_201:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoul
	mov	x19, x0
	ldp	x8, x9, [x20, #32]
	add	x10, x8, #1
	str	x10, [x20, #32]
	cmp	x8, x9
	b.ne	LBB2_212
; %bb.202:                              ;   in Loop: Header=BB2_4 Depth=1
	lsl	x9, x8, #1
	cmp	x8, #0
	mov	w8, #16
	csel	x8, x8, x9, eq
	str	x8, [x20, #40]
	ldr	x0, [x20, #24]
	add	x8, x8, x8, lsl #4
	lsl	x1, x8, #4
	bl	_realloc
	str	x0, [x20, #24]
	ldr	x8, [x20, #32]
	sub	x8, x8, #1
	b	LBB2_213
LBB2_203:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_204:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoul
LBB2_205:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x24, x0
	add	x19, x27, #64
	ldr	w8, [x27, #72]
	cmp	w8, #3
	b.eq	LBB2_214
; %bb.206:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_708
; %bb.207:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x19]
	mov	x0, x8
	ldrb	w9, [x0, #1]!
	cmp	w9, #48
	b.ne	LBB2_268
; %bb.208:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w9, [x8, #2]
	cmp	w9, #98
	b.eq	LBB2_429
; %bb.209:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #111
	b.eq	LBB2_427
; %bb.210:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #120
	b.ne	LBB2_268
; %bb.211:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #16
	b	LBB2_269
LBB2_212:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x20, #24]
LBB2_213:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w21, #272
	madd	x22, x8, x21, x0
	str	wzr, [x22]
	mov	w0, #4
	bl	_malloc
	str	x0, [x22, #8]
	ldp	x8, x9, [x20, #24]
	madd	x8, x9, x21, x8
	sub	x9, x8, #264
	ldr	x9, [x9]
	str	w19, [x9]
	b	LBB2_305
LBB2_214:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	ldrb	w8, [x0]
	cmp	w8, #48
	b.ne	LBB2_270
; %bb.215:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w8, [x0, #1]
	cmp	w8, #98
	b.eq	LBB2_430
; %bb.216:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #111
	b.eq	LBB2_428
; %bb.217:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #120
	b.ne	LBB2_270
; %bb.218:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #16
	b	LBB2_271
LBB2_219:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #1
	b.ne	LBB2_704
; %bb.220:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #32]!
	mov	x0, x8
	ldrb	w9, [x0, #1]!
	cmp	w9, #48
	b.ne	LBB2_290
; %bb.221:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w9, [x8, #2]
	cmp	w9, #98
	b.eq	LBB2_439
; %bb.222:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #111
	b.eq	LBB2_438
; %bb.223:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #120
	b.ne	LBB2_290
; %bb.224:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #16
	b	LBB2_291
LBB2_225:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #4
	b.ne	LBB2_703
; %bb.226:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x27, #32]!
	bl	_atof
	fmov	d8, d0
	ldp	x8, x9, [x20, #32]
	add	x10, x8, #1
	str	x10, [x20, #32]
	cmp	x8, x9
	b.ne	LBB2_303
; %bb.227:                              ;   in Loop: Header=BB2_4 Depth=1
	lsl	x9, x8, #1
	cmp	x8, #0
	mov	w8, #16
	csel	x8, x8, x9, eq
	str	x8, [x20, #40]
	ldr	x0, [x20, #24]
	add	x8, x8, x8, lsl #4
	lsl	x1, x8, #4
	bl	_realloc
	str	x0, [x20, #24]
	ldr	x8, [x20, #32]
	sub	x8, x8, #1
	b	LBB2_304
LBB2_228:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x19]
	mov	x0, x8
	ldrb	w9, [x0, #1]!
	cmp	w9, #48
	b.ne	LBB2_283
; %bb.229:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w9, [x8, #2]
	cmp	w9, #98
	b.eq	LBB2_435
; %bb.230:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #111
	b.eq	LBB2_434
; %bb.231:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #120
	b.ne	LBB2_283
; %bb.232:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #16
	b	LBB2_284
LBB2_233:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #104]
	cbz	w8, LBB2_306
; %bb.234:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_716
; %bb.235:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #96]
	mov	x0, x8
	ldrb	w9, [x0, #1]!
	cmp	w9, #48
	b.ne	LBB2_373
; %bb.236:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w9, [x8, #2]
	cmp	w9, #98
	b.eq	LBB2_488
; %bb.237:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #111
	b.eq	LBB2_487
; %bb.238:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #120
	b.ne	LBB2_373
; %bb.239:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #16
	b	LBB2_374
LBB2_240:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	ldrb	w8, [x0]
	cmp	w8, #48
	b.ne	LBB2_286
; %bb.241:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w8, [x0, #1]
	cmp	w8, #98
	b.eq	LBB2_437
; %bb.242:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #111
	b.eq	LBB2_436
; %bb.243:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #120
	b.ne	LBB2_286
; %bb.244:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #16
	b	LBB2_287
LBB2_245:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_246:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoull
	mov	x19, x0
	ldp	x8, x9, [x20, #32]
	add	x10, x8, #1
	str	x10, [x20, #32]
	cmp	x8, x9
	b.ne	LBB2_261
; %bb.247:                              ;   in Loop: Header=BB2_4 Depth=1
	lsl	x9, x8, #1
	cmp	x8, #0
	mov	w8, #16
	csel	x8, x8, x9, eq
	str	x8, [x20, #40]
	ldr	x0, [x20, #24]
	add	x8, x8, x8, lsl #4
	lsl	x1, x8, #4
	bl	_realloc
	str	x0, [x20, #24]
	ldr	x8, [x20, #32]
	sub	x8, x8, #1
	b	LBB2_262
LBB2_248:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_249:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoul
LBB2_250:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x24, x0
	add	x19, x27, #64
	ldr	w8, [x27, #72]
	cmp	w8, #3
	b.eq	LBB2_263
; %bb.251:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_708
; %bb.252:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x19]
	mov	x0, x8
	ldrb	w9, [x0, #1]!
	cmp	w9, #48
	b.ne	LBB2_322
; %bb.253:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w9, [x8, #2]
	cmp	w9, #98
	b.eq	LBB2_463
; %bb.254:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #111
	b.eq	LBB2_464
; %bb.255:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #120
	b.ne	LBB2_322
; %bb.256:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #16
	b	LBB2_323
LBB2_257:                               ;   in Loop: Header=BB2_4 Depth=1
	strb	wzr, [x8]
LBB2_258:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #41
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d9, [sp, #136]
	b	LBB2_330
LBB2_259:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #8
	b	LBB2_144
LBB2_260:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #2
	bl	_strtol
	b	LBB2_145
LBB2_261:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x20, #24]
LBB2_262:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w21, #272
	madd	x22, x8, x21, x0
	str	wzr, [x22]
	mov	w0, #8
	bl	_malloc
	str	x0, [x22, #8]
	ldp	x8, x9, [x20, #24]
	madd	x9, x9, x21, x8
	sub	x9, x9, #264
	ldr	x9, [x9]
	str	x19, [x9]
	b	LBB2_371
LBB2_263:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	ldrb	w8, [x0]
	cmp	w8, #48
	b.ne	LBB2_326
; %bb.264:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w8, [x0, #1]
	cmp	w8, #98
	b.eq	LBB2_465
; %bb.265:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #111
	b.eq	LBB2_466
; %bb.266:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #120
	b.ne	LBB2_326
; %bb.267:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #16
	b	LBB2_327
LBB2_268:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_269:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoul
	mov	w8, #50
	b	LBB2_325
LBB2_270:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_271:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoull
	cmp	x0, w0, sxth
	b.eq	LBB2_289
; %bb.272:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #57
	b	LBB2_329
LBB2_273:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x22, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_353
; %bb.274:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_714
; %bb.275:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x22]
	mov	x0, x8
	ldrb	w9, [x0, #1]!
	cmp	w9, #48
	b.ne	LBB2_396
; %bb.276:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w9, [x8, #2]
	cmp	w9, #98
	b.eq	LBB2_497
; %bb.277:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #111
	b.eq	LBB2_498
; %bb.278:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #120
	b.ne	LBB2_396
; %bb.279:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #16
	b	LBB2_397
LBB2_280:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #4
	b.ne	LBB2_703
; %bb.281:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x27, #32]!
	bl	_atof
	fmov	d8, d0
	ldp	x8, x9, [x20, #32]
	add	x10, x8, #1
	str	x10, [x20, #32]
	cmp	x8, x9
	b.ne	LBB2_369
; %bb.282:                              ;   in Loop: Header=BB2_4 Depth=1
	lsl	x9, x8, #1
	cmp	x8, #0
	mov	w8, #16
	csel	x8, x8, x9, eq
	str	x8, [x20, #40]
	ldr	x0, [x20, #24]
	add	x8, x8, x8, lsl #4
	lsl	x1, x8, #4
	bl	_realloc
	str	x0, [x20, #24]
	ldr	x8, [x20, #32]
	sub	x8, x8, #1
	b	LBB2_370
LBB2_283:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_284:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoul
LBB2_285:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #34
	b	LBB2_325
LBB2_286:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_287:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoull
	cmp	x0, w0, sxth
	b.eq	LBB2_297
; %bb.288:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #41
	b	LBB2_329
LBB2_289:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #51
	b	LBB2_345
LBB2_290:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_291:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoul
LBB2_292:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #81
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d10, [sp, #136]
	strb	w0, [sp, #144]
	ldr	x8, [sp, #112]                  ; 8-byte Folded Reload
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #160]
	stp	q0, q0, [x8, #192]
	str	q0, [x8, #224]
	stur	xzr, [x8, #239]
	b	LBB2_115
LBB2_293:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #8
	b	LBB2_163
LBB2_294:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #8
	b	LBB2_183
LBB2_295:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #2
	bl	_strtol
	b	LBB2_164
LBB2_296:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #2
	bl	_strtol
	b	LBB2_184
LBB2_297:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #35
	b	LBB2_345
LBB2_298:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x20, #24]
LBB2_299:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w9, #272
	madd	x8, x8, x9, x0
	mov	w9, #2
	str	w9, [x8]
	str	x19, [x8, #8]
	ldp	x8, x9, [x20, #56]
	add	x10, x8, #1
	str	x10, [x20, #56]
	cmp	x8, x9
	b.ne	LBB2_301
; %bb.300:                              ;   in Loop: Header=BB2_4 Depth=1
	lsl	x9, x8, #1
	cmp	x8, #0
	mov	w8, #16
	csel	x8, x8, x9, eq
	str	x8, [x20, #64]
	ldr	x0, [x20, #72]
	lsl	x1, x8, #3
	bl	_realloc
	str	x0, [x20, #72]
	ldr	x8, [x20, #56]
	sub	x8, x8, #1
	b	LBB2_302
LBB2_301:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x20, #72]
LBB2_302:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x9, [x20, #48]
	str	x9, [x0, x8, lsl  #3]
	ldr	x8, [x20, #48]
	add	x8, x8, #8
	str	x8, [x20, #48]
	add	x27, x27, #32
	b	LBB2_4
LBB2_303:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x20, #24]
LBB2_304:                               ;   in Loop: Header=BB2_4 Depth=1
	fcvt	s8, d8
	mov	w21, #272
	madd	x19, x8, x21, x0
	str	wzr, [x19]
	mov	w0, #4
	bl	_malloc
	str	x0, [x19, #8]
	ldp	x8, x9, [x20, #24]
	madd	x8, x9, x21, x8
	sub	x9, x8, #264
	ldr	x9, [x9]
	str	s8, [x9]
LBB2_305:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w9, #4
	stur	x9, [x8, #-256]
	ldr	x8, [x20, #48]
	add	x8, x8, #4
	b	LBB2_372
LBB2_306:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x19, [x27, #96]
	mov	x0, x19
	bl	_strlen
	add	x0, x0, #1
	bl	_malloc
	mov	x22, x0
	mov	x8, x0
	b	LBB2_309
LBB2_307:                               ;   in Loop: Header=BB2_309 Depth=2
	cbz	w9, LBB2_331
LBB2_308:                               ;   in Loop: Header=BB2_309 Depth=2
	strb	w9, [x8], #1
	add	x19, x19, #1
LBB2_309:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w9, [x19]
	cmp	w9, #92
	b.ne	LBB2_307
; %bb.310:                              ;   in Loop: Header=BB2_309 Depth=2
	ldrsb	w10, [x19, #1]!
	cmp	w10, #91
	b.le	LBB2_314
; %bb.311:                              ;   in Loop: Header=BB2_309 Depth=2
	sub	w11, w10, #92
	cmp	w11, #24
	b.hi	LBB2_492
; %bb.312:                              ;   in Loop: Header=BB2_309 Depth=2
	mov	w9, #10
Lloh168:
	adrp	x14, lJTI2_8@PAGE
Lloh169:
	add	x14, x14, lJTI2_8@PAGEOFF
	adr	x12, LBB2_308
	ldrh	w13, [x14, x11, lsl  #1]
	add	x12, x12, x13, lsl #2
	br	x12
LBB2_313:                               ;   in Loop: Header=BB2_309 Depth=2
	mov	w9, #92
	b	LBB2_308
LBB2_314:                               ;   in Loop: Header=BB2_309 Depth=2
	cmp	w10, #34
	b.eq	LBB2_321
; %bb.315:                              ;   in Loop: Header=BB2_309 Depth=2
	cmp	w10, #39
	b.eq	LBB2_320
; %bb.316:                              ;   in Loop: Header=BB2_309 Depth=2
	cmp	w10, #48
	b.ne	LBB2_492
; %bb.317:                              ;   in Loop: Header=BB2_309 Depth=2
	mov	w9, #0
	b	LBB2_308
LBB2_318:                               ;   in Loop: Header=BB2_309 Depth=2
	mov	w9, #9
	b	LBB2_308
LBB2_319:                               ;   in Loop: Header=BB2_309 Depth=2
	mov	w9, #13
	b	LBB2_308
LBB2_320:                               ;   in Loop: Header=BB2_309 Depth=2
	mov	w9, #39
	b	LBB2_308
LBB2_321:                               ;   in Loop: Header=BB2_309 Depth=2
	mov	w9, #34
	b	LBB2_308
LBB2_322:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_323:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoul
LBB2_324:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #66
LBB2_325:                               ;   in Loop: Header=BB2_4 Depth=1
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d10, [sp, #136]
	strb	w24, [sp, #144]
	ldr	x8, [sp, #112]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	stur	wzr, [x8, #3]
	str	d10, [sp, #152]
	strb	w0, [sp, #160]
	b	LBB2_347
LBB2_326:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_327:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoull
	cmp	x0, w0, sxth
	b.eq	LBB2_344
; %bb.328:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #73
LBB2_329:                               ;   in Loop: Header=BB2_4 Depth=1
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d11, [sp, #136]
LBB2_330:                               ;   in Loop: Header=BB2_4 Depth=1
	str	x0, [sp, #144]
	b	LBB2_346
LBB2_331:                               ;   in Loop: Header=BB2_4 Depth=1
	strb	wzr, [x8]
LBB2_332:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #128
	ldr	w8, [x27, #136]
	cmp	w8, #8
	b.eq	LBB2_419
; %bb.333:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #3
	b.eq	LBB2_416
; %bb.334:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_723
; %bb.335:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #128]
	add	x0, x8, #1
	bl	_parse8
	ldr	w8, [x27, #168]
	cmp	w8, #8
	b.ne	LBB2_719
; %bb.336:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x27, x27, #160
	add	x27, x27, #32
	b	LBB2_4
LBB2_337:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x22, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_399
; %bb.338:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_714
; %bb.339:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x22]
	mov	x0, x8
	ldrb	w9, [x0, #1]!
	cmp	w9, #48
	b.ne	LBB2_440
; %bb.340:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w9, [x8, #2]
	cmp	w9, #98
	b.eq	LBB2_507
; %bb.341:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #111
	b.eq	LBB2_506
; %bb.342:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #120
	b.ne	LBB2_440
; %bb.343:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #16
	b	LBB2_441
LBB2_344:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #67
LBB2_345:                               ;   in Loop: Header=BB2_4 Depth=1
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d12, [sp, #136]
	strh	w0, [sp, #144]
	ldr	x8, [sp, #104]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
LBB2_346:                               ;   in Loop: Header=BB2_4 Depth=1
	str	d10, [sp, #152]
	strb	w24, [sp, #160]
LBB2_347:                               ;   in Loop: Header=BB2_4 Depth=1
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x28]
	stp	q0, q0, [x28, #32]
	stp	q0, q0, [x28, #64]
	stp	q0, q0, [x28, #96]
	stp	q0, q0, [x28, #128]
	stp	q0, q0, [x28, #160]
	stp	q0, q0, [x28, #192]
	stur	xzr, [x28, #223]
LBB2_348:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x1, sp, #128
	mov	x0, x20
	bl	_add_instruction
	mov	x27, x19
	add	x27, x19, #32
	b	LBB2_4
LBB2_349:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #8
	b	LBB2_204
LBB2_350:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #8
	b	LBB2_201
LBB2_351:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #2
	bl	_strtol
	b	LBB2_205
LBB2_352:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #2
	b	LBB2_201
LBB2_353:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x19, [x22]
	mov	x0, x19
	bl	_strlen
	add	x0, x0, #1
	bl	_malloc
	mov	x8, x0
Lloh170:
	adrp	x14, lJTI2_6@PAGE
Lloh171:
	add	x14, x14, lJTI2_6@PAGEOFF
	b	LBB2_356
LBB2_354:                               ;   in Loop: Header=BB2_356 Depth=2
	cbz	w9, LBB2_378
LBB2_355:                               ;   in Loop: Header=BB2_356 Depth=2
	strb	w9, [x8], #1
	add	x19, x19, #1
LBB2_356:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w9, [x19]
	cmp	w9, #92
	b.ne	LBB2_354
; %bb.357:                              ;   in Loop: Header=BB2_356 Depth=2
	ldrsb	w10, [x19, #1]!
	cmp	w10, #91
	b.le	LBB2_361
; %bb.358:                              ;   in Loop: Header=BB2_356 Depth=2
	sub	w11, w10, #92
	cmp	w11, #24
	b.hi	LBB2_502
; %bb.359:                              ;   in Loop: Header=BB2_356 Depth=2
	mov	w9, #10
	adr	x12, LBB2_355
	ldrh	w13, [x14, x11, lsl  #1]
	add	x12, x12, x13, lsl #2
	br	x12
LBB2_360:                               ;   in Loop: Header=BB2_356 Depth=2
	mov	w9, #92
	b	LBB2_355
LBB2_361:                               ;   in Loop: Header=BB2_356 Depth=2
	cmp	w10, #34
	b.eq	LBB2_368
; %bb.362:                              ;   in Loop: Header=BB2_356 Depth=2
	cmp	w10, #39
	b.eq	LBB2_367
; %bb.363:                              ;   in Loop: Header=BB2_356 Depth=2
	cmp	w10, #48
	b.ne	LBB2_502
; %bb.364:                              ;   in Loop: Header=BB2_356 Depth=2
	mov	w9, #0
	b	LBB2_355
LBB2_365:                               ;   in Loop: Header=BB2_356 Depth=2
	mov	w9, #9
	b	LBB2_355
LBB2_366:                               ;   in Loop: Header=BB2_356 Depth=2
	mov	w9, #13
	b	LBB2_355
LBB2_367:                               ;   in Loop: Header=BB2_356 Depth=2
	mov	w9, #39
	b	LBB2_355
LBB2_368:                               ;   in Loop: Header=BB2_356 Depth=2
	mov	w9, #34
	b	LBB2_355
LBB2_369:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x20, #24]
LBB2_370:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w21, #272
	madd	x19, x8, x21, x0
	str	wzr, [x19]
	mov	w0, #8
	bl	_malloc
	str	x0, [x19, #8]
	ldp	x8, x9, [x20, #24]
	madd	x9, x9, x21, x8
	sub	x9, x9, #264
	ldr	x9, [x9]
	str	d8, [x9]
LBB2_371:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x9, [x20, #32]
	madd	x8, x9, x21, x8
	mov	w9, #8
	stur	x9, [x8, #-256]
	ldr	x8, [x20, #48]
	add	x8, x8, #8
LBB2_372:                               ;   in Loop: Header=BB2_4 Depth=1
	str	x8, [x20, #48]
Lloh172:
	adrp	x21, lJTI2_0@PAGE
Lloh173:
	add	x21, x21, lJTI2_0@PAGEOFF
	add	x27, x27, #32
	b	LBB2_4
LBB2_373:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_374:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoul
LBB2_375:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x19, x0
	add	x22, x27, #128
	ldr	w8, [x27, #136]
	cmp	w8, #3
	b.eq	LBB2_387
; %bb.376:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #8
	b.ne	LBB2_721
; %bb.377:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #36
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d10, [sp, #136]
	strb	w24, [sp, #144]
	ldr	x8, [sp, #112]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	stur	wzr, [x8, #3]
	str	d10, [sp, #152]
	strb	w19, [sp, #160]
	str	wzr, [x28]
	stur	wzr, [x28, #3]
	mov	w8, #2
	str	w8, [sp, #168]
	ldr	x8, [sp, #80]                   ; 8-byte Folded Reload
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #160]
	str	q0, [x8, #192]
	stur	q0, [x8, #204]
	b	LBB2_521
LBB2_378:                               ;   in Loop: Header=BB2_4 Depth=1
	strb	wzr, [x8]
LBB2_379:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #104
	b	LBB2_520
LBB2_380:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x22, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_442
; %bb.381:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_714
; %bb.382:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x22]
	mov	x0, x8
	ldrb	w9, [x0, #1]!
	cmp	w9, #48
	b.ne	LBB2_467
; %bb.383:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w9, [x8, #2]
	cmp	w9, #98
	b.eq	LBB2_513
; %bb.384:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #111
	b.eq	LBB2_515
; %bb.385:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #120
	b.ne	LBB2_467
; %bb.386:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #16
	b	LBB2_468
LBB2_387:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x22]
	ldrb	w8, [x0]
	cmp	w8, #48
	b.ne	LBB2_431
; %bb.388:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w8, [x0, #1]
	cmp	w8, #98
	b.eq	LBB2_503
; %bb.389:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #111
	b.eq	LBB2_504
; %bb.390:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #120
	b.ne	LBB2_431
; %bb.391:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #16
	b	LBB2_432
LBB2_392:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #8
	b	LBB2_246
LBB2_393:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #8
	b	LBB2_249
LBB2_394:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #2
	b	LBB2_246
LBB2_395:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #2
	bl	_strtol
	b	LBB2_250
LBB2_396:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_397:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoul
LBB2_398:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #97
	b	LBB2_514
LBB2_399:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x19, [x22]
	mov	x0, x19
	bl	_strlen
	add	x0, x0, #1
	bl	_malloc
	mov	x8, x0
Lloh174:
	adrp	x14, lJTI2_5@PAGE
Lloh175:
	add	x14, x14, lJTI2_5@PAGEOFF
	b	LBB2_402
LBB2_400:                               ;   in Loop: Header=BB2_402 Depth=2
	cbz	w9, LBB2_415
LBB2_401:                               ;   in Loop: Header=BB2_402 Depth=2
	strb	w9, [x8], #1
	add	x19, x19, #1
LBB2_402:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w9, [x19]
	cmp	w9, #92
	b.ne	LBB2_400
; %bb.403:                              ;   in Loop: Header=BB2_402 Depth=2
	ldrsb	w10, [x19, #1]!
	cmp	w10, #91
	b.le	LBB2_407
; %bb.404:                              ;   in Loop: Header=BB2_402 Depth=2
	sub	w11, w10, #92
	cmp	w11, #24
	b.hi	LBB2_511
; %bb.405:                              ;   in Loop: Header=BB2_402 Depth=2
	mov	w9, #10
	adr	x12, LBB2_401
	ldrh	w13, [x14, x11, lsl  #1]
	add	x12, x12, x13, lsl #2
	br	x12
LBB2_406:                               ;   in Loop: Header=BB2_402 Depth=2
	mov	w9, #92
	b	LBB2_401
LBB2_407:                               ;   in Loop: Header=BB2_402 Depth=2
	cmp	w10, #34
	b.eq	LBB2_414
; %bb.408:                              ;   in Loop: Header=BB2_402 Depth=2
	cmp	w10, #39
	b.eq	LBB2_413
; %bb.409:                              ;   in Loop: Header=BB2_402 Depth=2
	cmp	w10, #48
	b.ne	LBB2_511
; %bb.410:                              ;   in Loop: Header=BB2_402 Depth=2
	mov	w9, #0
	b	LBB2_401
LBB2_411:                               ;   in Loop: Header=BB2_402 Depth=2
	mov	w9, #13
	b	LBB2_401
LBB2_412:                               ;   in Loop: Header=BB2_402 Depth=2
	mov	w9, #9
	b	LBB2_401
LBB2_413:                               ;   in Loop: Header=BB2_402 Depth=2
	mov	w9, #39
	b	LBB2_401
LBB2_414:                               ;   in Loop: Header=BB2_402 Depth=2
	mov	w9, #34
	b	LBB2_401
LBB2_415:                               ;   in Loop: Header=BB2_4 Depth=1
	strb	wzr, [x8]
	mov	w8, #120
	b	LBB2_520
LBB2_416:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	bl	_parse64
	cmp	x0, w0, sxth
	b.ne	LBB2_717
; %bb.417:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #168]
	cmp	w8, #8
	b.ne	LBB2_719
; %bb.418:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x27, x27, #160
	mov	w8, #43
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d9, [sp, #136]
	str	x22, [sp, #144]
	str	d10, [sp, #152]
	strb	w24, [sp, #160]
	str	wzr, [x28]
	stur	wzr, [x28, #3]
	str	d12, [sp, #168]
	strh	w0, [sp, #176]
	ldr	x8, [sp, #72]                   ; 8-byte Folded Reload
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #160]
	str	q0, [x8, #192]
	stur	xzr, [x8, #206]
	b	LBB2_115
LBB2_419:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #43
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d9, [sp, #136]
	str	x22, [sp, #144]
	str	d10, [sp, #152]
	strb	w24, [sp, #160]
	str	wzr, [x28]
	stur	wzr, [x28, #3]
	mov	w8, #2
	str	w8, [sp, #168]
	ldr	x8, [sp, #80]                   ; 8-byte Folded Reload
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #160]
	str	q0, [x8, #192]
	stur	q0, [x8, #204]
	b	LBB2_348
LBB2_420:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x22, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_469
; %bb.421:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_714
; %bb.422:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x22]
	mov	x0, x8
	ldrb	w9, [x0, #1]!
	cmp	w9, #48
	b.ne	LBB2_493
; %bb.423:                              ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w9, [x8, #2]
	cmp	w9, #98
	b.eq	LBB2_523
; %bb.424:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #111
	b.eq	LBB2_524
; %bb.425:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #120
	b.ne	LBB2_493
; %bb.426:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #16
	b	LBB2_494
LBB2_427:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #8
	b	LBB2_269
LBB2_428:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #8
	b	LBB2_271
LBB2_429:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #2
	bl	_strtol
	mov	w8, #50
	b	LBB2_325
LBB2_430:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #2
	b	LBB2_271
LBB2_431:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_432:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoull
	cmp	x0, w0, sxth
	b.ne	LBB2_717
; %bb.433:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #36
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d10, [sp, #136]
	strb	w24, [sp, #144]
	ldr	x8, [sp, #112]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	stur	wzr, [x8, #3]
	str	d10, [sp, #152]
	strb	w19, [sp, #160]
	str	wzr, [x28]
	stur	wzr, [x28, #3]
	str	d12, [sp, #168]
	strh	w0, [sp, #176]
	ldr	x8, [sp, #72]                   ; 8-byte Folded Reload
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #160]
	str	q0, [x8, #192]
	stur	xzr, [x8, #206]
	b	LBB2_521
LBB2_434:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #8
	b	LBB2_284
LBB2_435:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #2
	bl	_strtol
	b	LBB2_285
LBB2_436:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #8
	b	LBB2_287
LBB2_437:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #2
	b	LBB2_287
LBB2_438:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #8
	b	LBB2_291
LBB2_439:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #2
	bl	_strtol
	b	LBB2_292
LBB2_440:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_441:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoul
	mov	w8, #113
	b	LBB2_514
LBB2_442:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x19, [x22]
	mov	x0, x19
	bl	_strlen
	add	x0, x0, #1
	bl	_malloc
	mov	x8, x0
Lloh176:
	adrp	x14, lJTI2_4@PAGE
Lloh177:
	add	x14, x14, lJTI2_4@PAGEOFF
	b	LBB2_445
LBB2_443:                               ;   in Loop: Header=BB2_445 Depth=2
	cbz	w9, LBB2_459
LBB2_444:                               ;   in Loop: Header=BB2_445 Depth=2
	strb	w9, [x8], #1
	add	x19, x19, #1
LBB2_445:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w9, [x19]
	cmp	w9, #92
	b.ne	LBB2_443
; %bb.446:                              ;   in Loop: Header=BB2_445 Depth=2
	ldrsb	w10, [x19, #1]!
	cmp	w10, #91
	b.le	LBB2_450
; %bb.447:                              ;   in Loop: Header=BB2_445 Depth=2
	sub	w11, w10, #92
	cmp	w11, #24
	b.hi	LBB2_519
; %bb.448:                              ;   in Loop: Header=BB2_445 Depth=2
	mov	w9, #10
	adr	x12, LBB2_444
	ldrh	w13, [x14, x11, lsl  #1]
	add	x12, x12, x13, lsl #2
	br	x12
LBB2_449:                               ;   in Loop: Header=BB2_445 Depth=2
	mov	w9, #92
	b	LBB2_444
LBB2_450:                               ;   in Loop: Header=BB2_445 Depth=2
	cmp	w10, #34
	b.eq	LBB2_457
; %bb.451:                              ;   in Loop: Header=BB2_445 Depth=2
	cmp	w10, #39
	b.eq	LBB2_456
; %bb.452:                              ;   in Loop: Header=BB2_445 Depth=2
	cmp	w10, #48
	b.ne	LBB2_519
; %bb.453:                              ;   in Loop: Header=BB2_445 Depth=2
	mov	w9, #0
	b	LBB2_444
LBB2_454:                               ;   in Loop: Header=BB2_445 Depth=2
	mov	w9, #13
	b	LBB2_444
LBB2_455:                               ;   in Loop: Header=BB2_445 Depth=2
	mov	w9, #9
	b	LBB2_444
LBB2_456:                               ;   in Loop: Header=BB2_445 Depth=2
	mov	w9, #39
	b	LBB2_444
LBB2_457:                               ;   in Loop: Header=BB2_445 Depth=2
	mov	w9, #34
	b	LBB2_444
LBB2_458:                               ;   in Loop: Header=BB2_4 Depth=1
	str	x10, [sp]
Lloh178:
	adrp	x0, l_.str.74@PAGE
Lloh179:
	add	x0, x0, l_.str.74@PAGEOFF
	bl	_printf
	mov	x0, #0
	b	LBB2_258
LBB2_459:                               ;   in Loop: Header=BB2_4 Depth=1
	strb	wzr, [x8]
	mov	w8, #136
	b	LBB2_520
LBB2_460:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_496
; %bb.461:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_714
; %bb.462:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x19]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #161
	b	LBB2_553
LBB2_463:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #2
	bl	_strtol
	b	LBB2_324
LBB2_464:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #8
	b	LBB2_323
LBB2_465:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #2
	b	LBB2_327
LBB2_466:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #8
	b	LBB2_327
LBB2_467:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_468:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoul
	mov	w8, #129
	b	LBB2_514
LBB2_469:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x19, [x22]
	mov	x0, x19
	bl	_strlen
	add	x0, x0, #1
	bl	_malloc
	mov	x8, x0
Lloh180:
	adrp	x14, lJTI2_3@PAGE
Lloh181:
	add	x14, x14, lJTI2_3@PAGEOFF
	b	LBB2_472
LBB2_470:                               ;   in Loop: Header=BB2_472 Depth=2
	cbz	w9, LBB2_485
LBB2_471:                               ;   in Loop: Header=BB2_472 Depth=2
	strb	w9, [x8], #1
	add	x19, x19, #1
LBB2_472:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w9, [x19]
	cmp	w9, #92
	b.ne	LBB2_470
; %bb.473:                              ;   in Loop: Header=BB2_472 Depth=2
	ldrsb	w10, [x19, #1]!
	cmp	w10, #91
	b.le	LBB2_477
; %bb.474:                              ;   in Loop: Header=BB2_472 Depth=2
	sub	w11, w10, #92
	cmp	w11, #24
	b.hi	LBB2_528
; %bb.475:                              ;   in Loop: Header=BB2_472 Depth=2
	mov	w9, #10
	adr	x12, LBB2_471
	ldrb	w13, [x14, x11]
	add	x12, x12, x13, lsl #2
	br	x12
LBB2_476:                               ;   in Loop: Header=BB2_472 Depth=2
	mov	w9, #92
	b	LBB2_471
LBB2_477:                               ;   in Loop: Header=BB2_472 Depth=2
	cmp	w10, #34
	b.eq	LBB2_484
; %bb.478:                              ;   in Loop: Header=BB2_472 Depth=2
	cmp	w10, #39
	b.eq	LBB2_483
; %bb.479:                              ;   in Loop: Header=BB2_472 Depth=2
	cmp	w10, #48
	b.ne	LBB2_528
; %bb.480:                              ;   in Loop: Header=BB2_472 Depth=2
	mov	w9, #0
	b	LBB2_471
LBB2_481:                               ;   in Loop: Header=BB2_472 Depth=2
	mov	w9, #13
	b	LBB2_471
LBB2_482:                               ;   in Loop: Header=BB2_472 Depth=2
	mov	w9, #9
	b	LBB2_471
LBB2_483:                               ;   in Loop: Header=BB2_472 Depth=2
	mov	w9, #39
	b	LBB2_471
LBB2_484:                               ;   in Loop: Header=BB2_472 Depth=2
	mov	w9, #34
	b	LBB2_471
LBB2_485:                               ;   in Loop: Header=BB2_4 Depth=1
	strb	wzr, [x8]
LBB2_486:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #152
	b	LBB2_520
LBB2_487:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #8
	b	LBB2_374
LBB2_488:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #2
	bl	_strtol
	b	LBB2_375
LBB2_489:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_505
; %bb.490:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_714
; %bb.491:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x19]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #177
	b	LBB2_553
LBB2_492:                               ;   in Loop: Header=BB2_4 Depth=1
	str	x10, [sp]
Lloh182:
	adrp	x0, l_.str.74@PAGE
Lloh183:
	add	x0, x0, l_.str.74@PAGEOFF
	bl	_printf
	mov	x22, #0
	b	LBB2_332
LBB2_493:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, #0
	mov	w2, #10
LBB2_494:                               ;   in Loop: Header=BB2_4 Depth=1
	bl	_strtoul
LBB2_495:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #145
	b	LBB2_514
LBB2_496:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	bl	_unquote
	mov	w8, #168
	b	LBB2_564
LBB2_497:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #2
	bl	_strtol
	b	LBB2_398
LBB2_498:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #8
	b	LBB2_397
LBB2_499:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_512
; %bb.500:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_714
; %bb.501:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x19]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #193
	b	LBB2_553
LBB2_502:                               ;   in Loop: Header=BB2_4 Depth=1
	str	x10, [sp]
Lloh184:
	adrp	x0, l_.str.74@PAGE
Lloh185:
	add	x0, x0, l_.str.74@PAGEOFF
	bl	_printf
	mov	x0, #0
	b	LBB2_379
LBB2_503:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #2
	b	LBB2_432
LBB2_504:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #8
	b	LBB2_432
LBB2_505:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	bl	_unquote
	mov	w8, #184
	b	LBB2_564
LBB2_506:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #8
	b	LBB2_441
LBB2_507:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #2
	bl	_strtol
	mov	w8, #113
	b	LBB2_514
LBB2_508:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_522
; %bb.509:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_714
; %bb.510:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x19]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #209
	b	LBB2_553
LBB2_511:                               ;   in Loop: Header=BB2_4 Depth=1
	str	x10, [sp]
Lloh186:
	adrp	x0, l_.str.74@PAGE
Lloh187:
	add	x0, x0, l_.str.74@PAGEOFF
	bl	_printf
	mov	x0, #0
	mov	w8, #120
	b	LBB2_520
LBB2_512:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	bl	_unquote
	mov	w8, #200
	b	LBB2_564
LBB2_513:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #2
	bl	_strtol
	mov	w8, #129
LBB2_514:                               ;   in Loop: Header=BB2_4 Depth=1
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d10, [sp, #136]
	strb	w0, [sp, #144]
	ldr	x8, [sp, #112]                  ; 8-byte Folded Reload
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #160]
	stp	q0, q0, [x8, #192]
	str	q0, [x8, #224]
	stur	xzr, [x8, #239]
	b	LBB2_521
LBB2_515:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #8
	b	LBB2_468
LBB2_516:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_529
; %bb.517:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_714
; %bb.518:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x19]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #225
	b	LBB2_553
LBB2_519:                               ;   in Loop: Header=BB2_4 Depth=1
	str	x10, [sp]
Lloh188:
	adrp	x0, l_.str.74@PAGE
Lloh189:
	add	x0, x0, l_.str.74@PAGEOFF
	bl	_printf
	mov	x0, #0
	mov	w8, #136
LBB2_520:                               ;   in Loop: Header=BB2_4 Depth=1
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d9, [sp, #136]
	str	x0, [sp, #144]
	ldr	x8, [sp, #88]                   ; 8-byte Folded Reload
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #160]
	stp	q0, q0, [x8, #192]
	str	q0, [x8, #224]
LBB2_521:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x1, sp, #128
	mov	x0, x20
	bl	_add_instruction
	mov	x27, x22
	add	x27, x22, #32
	b	LBB2_4
LBB2_522:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	bl	_unquote
	mov	w8, #216
	b	LBB2_564
LBB2_523:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #2
	bl	_strtol
	b	LBB2_495
LBB2_524:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x0, x8, #3
	mov	x1, #0
	mov	w2, #8
	b	LBB2_494
LBB2_525:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_533
; %bb.526:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_714
; %bb.527:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x19]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #545
	b	LBB2_553
LBB2_528:                               ;   in Loop: Header=BB2_4 Depth=1
	str	x10, [sp]
Lloh190:
	adrp	x0, l_.str.74@PAGE
Lloh191:
	add	x0, x0, l_.str.74@PAGEOFF
	bl	_printf
	mov	x0, #0
	b	LBB2_486
LBB2_529:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	bl	_unquote
	mov	w8, #232
	b	LBB2_564
LBB2_530:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_537
; %bb.531:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_714
; %bb.532:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x19]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #561
	b	LBB2_553
LBB2_533:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	bl	_unquote
	mov	w8, #552
	b	LBB2_564
LBB2_534:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_541
; %bb.535:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_714
; %bb.536:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x19]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #577
	b	LBB2_553
LBB2_537:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	bl	_unquote
	mov	w8, #568
	b	LBB2_564
LBB2_538:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_545
; %bb.539:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_714
; %bb.540:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x19]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #593
	b	LBB2_553
LBB2_541:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	bl	_unquote
	mov	w8, #584
	b	LBB2_564
LBB2_542:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_549
; %bb.543:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_714
; %bb.544:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x19]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #609
	b	LBB2_553
LBB2_545:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	bl	_unquote
	mov	w8, #600
	b	LBB2_564
LBB2_546:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_554
; %bb.547:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_714
; %bb.548:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x19]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #625
	b	LBB2_553
LBB2_549:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	bl	_unquote
	mov	w8, #616
	b	LBB2_564
LBB2_550:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_558
; %bb.551:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_714
; %bb.552:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x19]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #641
LBB2_553:                               ;   in Loop: Header=BB2_4 Depth=1
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d10, [sp, #136]
	strb	w0, [sp, #144]
	ldr	x8, [sp, #112]                  ; 8-byte Folded Reload
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #160]
	stp	q0, q0, [x8, #192]
	str	q0, [x8, #224]
	stur	xzr, [x8, #239]
	b	LBB2_348
LBB2_554:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	bl	_unquote
	mov	w8, #632
	b	LBB2_564
LBB2_555:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_563
; %bb.556:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_714
; %bb.557:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x19]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #657
	b	LBB2_562
LBB2_558:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	bl	_unquote
	mov	w8, #648
	b	LBB2_564
LBB2_559:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_566
; %bb.560:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_714
; %bb.561:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x19]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #673
LBB2_562:                               ;   in Loop: Header=BB2_4 Depth=1
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d10, [sp, #136]
	strb	w0, [sp, #144]
	ldr	x8, [sp, #112]                  ; 8-byte Folded Reload
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #160]
	stp	q0, q0, [x8, #192]
	str	q0, [x8, #224]
	stur	xzr, [x8, #239]
	b	LBB2_568
LBB2_563:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	bl	_unquote
	mov	w8, #664
LBB2_564:                               ;   in Loop: Header=BB2_4 Depth=1
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d9, [sp, #136]
	str	x0, [sp, #144]
	ldr	x8, [sp, #88]                   ; 8-byte Folded Reload
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #160]
	stp	q0, q0, [x8, #192]
	str	q0, [x8, #224]
	b	LBB2_348
LBB2_565:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #240
	strb	w8, [sp, #128]
	b	LBB2_113
LBB2_566:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	bl	_unquote
	mov	w8, #680
LBB2_567:                               ;   in Loop: Header=BB2_4 Depth=1
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d9, [sp, #136]
	str	x0, [sp, #144]
	ldr	x8, [sp, #88]                   ; 8-byte Folded Reload
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #160]
	stp	q0, q0, [x8, #192]
	str	q0, [x8, #224]
LBB2_568:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x1, sp, #128
	mov	x0, x20
	bl	_add_instruction
LBB2_569:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x19
Lloh192:
	adrp	x21, lJTI2_0@PAGE
Lloh193:
	add	x21, x21, lJTI2_0@PAGEOFF
	add	x27, x19, #32
	b	LBB2_4
LBB2_570:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #256
LBB2_571:                               ;   in Loop: Header=BB2_4 Depth=1
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #160]
	stp	q0, q0, [x8, #192]
	stp	q0, q0, [x8, #224]
	stur	xzr, [x8, #254]
	b	LBB2_579
LBB2_572:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #273
	b	LBB2_574
LBB2_573:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #289
LBB2_574:                               ;   in Loop: Header=BB2_4 Depth=1
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	mov	w8, #1
	str	w8, [sp, #136]
	ldr	x8, [sp, #64]                   ; 8-byte Folded Reload
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #160]
	stp	q0, q0, [x8, #192]
	str	q0, [x8, #224]
	stur	q0, [x8, #236]
	b	LBB2_579
LBB2_575:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #273
	b	LBB2_577
LBB2_576:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #289
LBB2_577:                               ;   in Loop: Header=BB2_4 Depth=1
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d10, [sp, #136]
	mov	w8, #1
	strb	w8, [sp, #144]
LBB2_578:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [sp, #112]                  ; 8-byte Folded Reload
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #160]
	stp	q0, q0, [x8, #192]
	str	q0, [x8, #224]
	stur	xzr, [x8, #239]
LBB2_579:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x1, sp, #128
	mov	x0, x20
	bl	_add_instruction
Lloh194:
	adrp	x21, lJTI2_0@PAGE
Lloh195:
	add	x21, x21, lJTI2_0@PAGEOFF
	add	x27, x27, #32
	b	LBB2_4
LBB2_580:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #688
	b	LBB2_571
LBB2_581:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_592
; %bb.582:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #3
	b.eq	LBB2_593
; %bb.583:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_724
; %bb.584:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x19]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #273
	b	LBB2_562
LBB2_585:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #32
	ldr	w8, [x27, #40]
	cbz	w8, LBB2_595
; %bb.586:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_714
; %bb.587:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x19]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #289
	b	LBB2_562
LBB2_588:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #1
	b.ne	LBB2_704
; %bb.589:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #32]
	add	x0, x8, #1
	bl	_parse8
	mov	x19, x0
	add	x22, x27, #64
	ldr	w8, [x27, #72]
	cmp	w8, #3
	b.eq	LBB2_600
; %bb.590:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_708
; %bb.591:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x22]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #306
	b	LBB2_654
LBB2_592:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	bl	_unquote
	mov	w8, #280
	b	LBB2_567
LBB2_593:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	bl	_parse64
	lsr	x8, x0, #16
	cbnz	x8, LBB2_569
; %bb.594:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #274
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d12, [sp, #136]
	strh	w0, [sp, #144]
	ldr	x8, [sp, #104]                  ; 8-byte Folded Reload
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #160]
	stp	q0, q0, [x8, #192]
	str	q0, [x8, #224]
	stur	xzr, [x8, #238]
	b	LBB2_568
LBB2_595:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	bl	_unquote
	mov	w8, #296
	b	LBB2_567
LBB2_596:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #1
	b.ne	LBB2_704
; %bb.597:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #32]
	add	x0, x8, #1
	bl	_parse8
	mov	x19, x0
	add	x22, x27, #64
	ldr	w8, [x27, #72]
	cmp	w8, #3
	b.eq	LBB2_606
; %bb.598:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_708
; %bb.599:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x22]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #322
	b	LBB2_654
LBB2_600:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x22]
	bl	_parse64
	cmp	x0, w0, sxth
	b.eq	LBB2_612
; %bb.601:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #313
	b	LBB2_663
LBB2_602:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #1
	b.ne	LBB2_704
; %bb.603:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #32]
	add	x0, x8, #1
	bl	_parse8
	mov	x19, x0
	add	x22, x27, #64
	ldr	w8, [x27, #72]
	cmp	w8, #3
	b.eq	LBB2_613
; %bb.604:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_708
; %bb.605:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x22]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #338
	b	LBB2_654
LBB2_606:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x22]
	bl	_parse64
	cmp	x0, w0, sxth
	b.eq	LBB2_619
; %bb.607:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #329
	b	LBB2_663
LBB2_608:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #1
	b.ne	LBB2_704
; %bb.609:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #32]
	add	x0, x8, #1
	bl	_parse8
	mov	x19, x0
	add	x22, x27, #64
	ldr	w8, [x27, #72]
	cmp	w8, #3
	b.eq	LBB2_620
; %bb.610:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_708
; %bb.611:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x22]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #354
	b	LBB2_654
LBB2_612:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #307
	b	LBB2_671
LBB2_613:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x22]
	bl	_parse64
	cmp	x0, w0, sxth
	b.eq	LBB2_626
; %bb.614:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #345
	b	LBB2_663
LBB2_615:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #1
	b.ne	LBB2_704
; %bb.616:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #32]
	add	x0, x8, #1
	bl	_parse8
	mov	x19, x0
	add	x22, x27, #64
	ldr	w8, [x27, #72]
	cmp	w8, #3
	b.eq	LBB2_627
; %bb.617:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_708
; %bb.618:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x22]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #370
	b	LBB2_654
LBB2_619:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #323
	b	LBB2_671
LBB2_620:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x22]
	bl	_parse64
	cmp	x0, w0, sxth
	b.eq	LBB2_633
; %bb.621:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #361
	b	LBB2_663
LBB2_622:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #1
	b.ne	LBB2_704
; %bb.623:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #32]
	add	x0, x8, #1
	bl	_parse8
	mov	x19, x0
	add	x22, x27, #64
	ldr	w8, [x27, #72]
	cmp	w8, #3
	b.eq	LBB2_634
; %bb.624:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_708
; %bb.625:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x22]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #386
	b	LBB2_654
LBB2_626:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #339
	b	LBB2_671
LBB2_627:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x22]
	bl	_parse64
	cmp	x0, w0, sxth
	b.eq	LBB2_640
; %bb.628:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #377
	b	LBB2_663
LBB2_629:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #1
	b.ne	LBB2_704
; %bb.630:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #32]
	add	x0, x8, #1
	bl	_parse8
	mov	x19, x0
	add	x22, x27, #64
	ldr	w8, [x27, #72]
	cmp	w8, #3
	b.eq	LBB2_641
; %bb.631:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_708
; %bb.632:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x22]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #402
	b	LBB2_654
LBB2_633:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #355
	b	LBB2_671
LBB2_634:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x22]
	bl	_parse64
	cmp	x0, w0, sxth
	b.eq	LBB2_647
; %bb.635:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #393
	b	LBB2_663
LBB2_636:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #1
	b.ne	LBB2_704
; %bb.637:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #32]
	add	x0, x8, #1
	bl	_parse8
	mov	x19, x0
	add	x22, x27, #64
	ldr	w8, [x27, #72]
	cmp	w8, #3
	b.eq	LBB2_648
; %bb.638:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_708
; %bb.639:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x22]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #418
	b	LBB2_654
LBB2_640:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #371
	b	LBB2_671
LBB2_641:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x22]
	bl	_parse64
	cmp	x0, w0, sxth
	b.eq	LBB2_655
; %bb.642:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #409
	b	LBB2_663
LBB2_643:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #1
	b.ne	LBB2_704
; %bb.644:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #32]
	add	x0, x8, #1
	bl	_parse8
	mov	x19, x0
	add	x22, x27, #64
	ldr	w8, [x27, #72]
	cmp	w8, #3
	b.eq	LBB2_656
; %bb.645:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_708
; %bb.646:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x22]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #434
	b	LBB2_654
LBB2_647:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #387
	b	LBB2_671
LBB2_648:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x22]
	bl	_parse64
	cmp	x0, w0, sxth
	b.eq	LBB2_660
; %bb.649:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #425
	b	LBB2_663
LBB2_650:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #1
	b.ne	LBB2_704
; %bb.651:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #32]
	add	x0, x8, #1
	bl	_parse8
	mov	x19, x0
	add	x22, x27, #64
	ldr	w8, [x27, #72]
	cmp	w8, #3
	b.eq	LBB2_661
; %bb.652:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_708
; %bb.653:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x22]
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #450
LBB2_654:                               ;   in Loop: Header=BB2_4 Depth=1
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d10, [sp, #136]
	strb	w19, [sp, #144]
	ldr	x8, [sp, #112]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	stur	wzr, [x8, #3]
	str	d10, [sp, #152]
	strb	w0, [sp, #160]
	b	LBB2_673
LBB2_655:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #403
	b	LBB2_671
LBB2_656:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x22]
	bl	_parse64
	cmp	x0, w0, sxth
	b.eq	LBB2_666
; %bb.657:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #441
	b	LBB2_663
LBB2_658:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #1
	b.ne	LBB2_704
; %bb.659:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #32]!
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #465
	b	LBB2_669
LBB2_660:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #419
	b	LBB2_671
LBB2_661:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x22]
	bl	_parse64
	cmp	x0, w0, sxth
	b.eq	LBB2_670
; %bb.662:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #457
LBB2_663:                               ;   in Loop: Header=BB2_4 Depth=1
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d11, [sp, #136]
	str	x0, [sp, #144]
	b	LBB2_672
LBB2_664:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #1
	b.ne	LBB2_704
; %bb.665:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #32]!
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #481
	b	LBB2_669
LBB2_666:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #435
	b	LBB2_671
LBB2_667:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #40]
	cmp	w8, #1
	b.ne	LBB2_704
; %bb.668:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #32]!
	add	x0, x8, #1
	bl	_parse8
	mov	w8, #497
LBB2_669:                               ;   in Loop: Header=BB2_4 Depth=1
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d10, [sp, #136]
	strb	w0, [sp, #144]
	b	LBB2_578
LBB2_670:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #451
LBB2_671:                               ;   in Loop: Header=BB2_4 Depth=1
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d12, [sp, #136]
	strh	w0, [sp, #144]
	ldr	x8, [sp, #104]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
LBB2_672:                               ;   in Loop: Header=BB2_4 Depth=1
	str	d10, [sp, #152]
	strb	w19, [sp, #160]
LBB2_673:                               ;   in Loop: Header=BB2_4 Depth=1
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x28]
	stp	q0, q0, [x28, #32]
	stp	q0, q0, [x28, #64]
	stp	q0, q0, [x28, #96]
	stp	q0, q0, [x28, #128]
	stp	q0, q0, [x28, #160]
	stp	q0, q0, [x28, #192]
	stur	xzr, [x28, #223]
LBB2_674:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x1, sp, #128
	mov	x0, x20
	bl	_add_instruction
	b	LBB2_130
LBB2_675:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #512
	b	LBB2_571
LBB2_676:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w21, #1
	b	LBB2_679
LBB2_677:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w21, #2
	b	LBB2_679
LBB2_678:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w21, #4
LBB2_679:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #104]
	cmp	w8, #7
	b.ne	LBB2_728
; %bb.680:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #136]
	cbz	w8, LBB2_686
; %bb.681:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #1
	b.ne	LBB2_729
; %bb.682:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #128]
	add	x0, x8, #1
	bl	_parse8
	mov	x22, x0
	ldr	w8, [x27, #168]
	cmp	w8, #1
	b.eq	LBB2_690
; %bb.683:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x27, #160
	cmp	w8, #3
	b.eq	LBB2_692
; %bb.684:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #8
	b.ne	LBB2_730
; %bb.685:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #533
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	mov	w8, #2
	str	w8, [sp, #136]
	ldr	x8, [sp, #64]                   ; 8-byte Folded Reload
	str	xzr, [x8]
	str	wzr, [x8, #8]
	str	d10, [sp, #152]
	strb	w24, [sp, #160]
	str	wzr, [x28]
	stur	wzr, [x28, #3]
	str	d10, [sp, #168]
	strb	w21, [sp, #176]
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	str	wzr, [x8]
	stur	wzr, [x8, #3]
	str	d10, [sp, #184]
	strb	w22, [sp, #192]
	ldr	x8, [sp, #48]                   ; 8-byte Folded Reload
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #160]
	stur	xzr, [x8, #191]
	b	LBB2_568
LBB2_686:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x27, #128]
	bl	_unquote
	mov	x19, x0
	ldr	w8, [x27, #168]
	cmp	w8, #1
	b.eq	LBB2_696
; %bb.687:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x22, x27, #160
	cmp	w8, #3
	b.eq	LBB2_698
; %bb.688:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w8, #8
	b.ne	LBB2_730
; %bb.689:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #540
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d9, [sp, #136]
	str	x19, [sp, #144]
	str	d10, [sp, #152]
	strb	w24, [sp, #160]
	str	wzr, [x28]
	stur	wzr, [x28, #3]
	str	d10, [sp, #168]
	strb	w21, [sp, #176]
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	str	wzr, [x8]
	stur	wzr, [x8, #3]
	mov	w8, #2
	str	w8, [sp, #184]
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #160]
	stur	q0, [x8, #188]
	b	LBB2_674
LBB2_690:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #160]
	add	x0, x8, #1
	bl	_parse8
	ldr	w8, [x27, #200]
	cmp	w8, #8
	b.ne	LBB2_732
; %bb.691:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x27, x27, #192
	mov	w8, #532
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d10, [sp, #136]
	strb	w24, [sp, #144]
	ldr	x8, [sp, #112]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	stur	wzr, [x8, #3]
	str	d10, [sp, #152]
	strb	w21, [sp, #160]
	str	wzr, [x28]
	stur	wzr, [x28, #3]
	str	d10, [sp, #168]
	strb	w22, [sp, #176]
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	str	wzr, [x8]
	stur	wzr, [x8, #3]
	str	d10, [sp, #184]
	strb	w0, [sp, #192]
	b	LBB2_695
LBB2_692:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x19]
	bl	_parse64
	cmp	x0, w0, sxth
	b.ne	LBB2_731
; %bb.693:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #200]
	cmp	w8, #8
	b.ne	LBB2_732
; %bb.694:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x27, x27, #192
	mov	w8, #533
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d12, [sp, #136]
	strh	w0, [sp, #144]
	ldr	x8, [sp, #104]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d10, [sp, #152]
	strb	w24, [sp, #160]
	str	wzr, [x28]
	stur	wzr, [x28, #3]
	str	d10, [sp, #168]
	strb	w21, [sp, #176]
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	str	wzr, [x8]
	stur	wzr, [x8, #3]
	str	d10, [sp, #184]
	strb	w22, [sp, #192]
LBB2_695:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [sp, #48]                   ; 8-byte Folded Reload
	stur	xzr, [x8, #191]
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8, #160]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8]
	b	LBB2_579
LBB2_696:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #160]
	add	x0, x8, #1
	bl	_parse8
	ldr	w8, [x27, #200]
	cmp	w8, #8
	b.ne	LBB2_732
; %bb.697:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x27, x27, #192
	mov	w8, #539
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d9, [sp, #136]
	str	x19, [sp, #144]
	str	d10, [sp, #152]
	strb	w24, [sp, #160]
	str	wzr, [x28]
	stur	wzr, [x28, #3]
	str	d10, [sp, #168]
	strb	w21, [sp, #176]
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	str	wzr, [x8]
	stur	wzr, [x8, #3]
	str	d10, [sp, #184]
	strb	w0, [sp, #192]
	ldr	x8, [sp, #48]                   ; 8-byte Folded Reload
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #160]
	stur	xzr, [x8, #191]
	b	LBB2_579
LBB2_698:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x22]
	bl	_parse64
	cmp	x0, w0, sxth
	b.ne	LBB2_731
; %bb.699:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [x27, #200]
	cmp	w8, #8
	b.ne	LBB2_732
; %bb.700:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x27, x27, #192
	mov	w8, #540
	strh	w8, [sp, #128]
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	wzr, [x8]
	strh	wzr, [x8, #4]
	str	d9, [sp, #136]
	str	x19, [sp, #144]
	str	d10, [sp, #152]
	strb	w24, [sp, #160]
	str	wzr, [x28]
	stur	wzr, [x28, #3]
	str	d10, [sp, #168]
	strb	w21, [sp, #176]
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	str	wzr, [x8]
	stur	wzr, [x8, #3]
	str	d12, [sp, #184]
	strh	w0, [sp, #192]
	ldr	x8, [sp, #40]                   ; 8-byte Folded Reload
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x8]
	stp	q0, q0, [x8, #32]
	stp	q0, q0, [x8, #64]
	stp	q0, q0, [x8, #96]
	stp	q0, q0, [x8, #128]
	stp	q0, q0, [x8, #160]
	stur	xzr, [x8, #190]
	b	LBB2_579
LBB2_701:
	ldr	x0, [sp, #96]                   ; 8-byte Folded Reload
	mov	w1, #16
	bl	_realloc
	str	xzr, [x0, #8]
	b	LBB2_707
LBB2_702:
	ldr	x8, [x27, #48]
	ldr	x9, [x27, #32]
	ldr	w10, [x27, #56]
	stp	x10, x9, [sp, #8]
	str	x8, [sp]
Lloh196:
	adrp	x0, l_.str.68@PAGE
Lloh197:
	add	x0, x0, l_.str.68@PAGEOFF
	b	LBB2_706
LBB2_703:
	ldr	x8, [x27, #48]
	ldr	x9, [x27, #32]
	ldr	w10, [x27, #56]
	stp	x10, x9, [sp, #8]
	str	x8, [sp]
Lloh198:
	adrp	x0, l_.str.69@PAGE
Lloh199:
	add	x0, x0, l_.str.69@PAGEOFF
	b	LBB2_706
LBB2_704:
	ldr	x8, [x27, #48]
	ldr	x9, [x27, #32]
	ldr	w10, [x27, #56]
LBB2_705:
	stp	x10, x9, [sp, #8]
	str	x8, [sp]
Lloh200:
	adrp	x0, l_.str.7@PAGE
Lloh201:
	add	x0, x0, l_.str.7@PAGEOFF
LBB2_706:
	bl	_printf
	mov	x0, #0
LBB2_707:
	add	sp, sp, #400
	ldp	x29, x30, [sp, #128]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #112]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #96]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #80]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #64]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #48]             ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #32]               ; 16-byte Folded Reload
	ldp	d11, d10, [sp, #16]             ; 16-byte Folded Reload
	ldp	d13, d12, [sp], #144            ; 16-byte Folded Reload
	ret
LBB2_708:
	ldr	x8, [x27, #80]
	ldr	x9, [x27, #64]
	ldr	w10, [x27, #88]
LBB2_709:
	stp	x10, x9, [sp, #8]
	str	x8, [sp]
Lloh202:
	adrp	x0, l_.str.12@PAGE
Lloh203:
	add	x0, x0, l_.str.12@PAGEOFF
	b	LBB2_706
LBB2_710:
	ldr	x8, [x27, #16]
	ldr	w9, [x27, #24]
	stp	x9, x19, [sp, #8]
	str	x8, [sp]
Lloh204:
	adrp	x0, l_.str.73@PAGE
Lloh205:
	add	x0, x0, l_.str.73@PAGEOFF
	b	LBB2_706
LBB2_711:
	ldr	x8, [x27, #80]
	ldr	x9, [x27, #64]
	ldr	w10, [x27, #88]
	b	LBB2_705
LBB2_712:
	ldr	x8, [x27, #48]
	ldr	x9, [x27, #32]
	ldr	w10, [x27, #56]
LBB2_713:
	stp	x10, x9, [sp, #8]
	str	x8, [sp]
Lloh206:
	adrp	x0, l_.str.58@PAGE
Lloh207:
	add	x0, x0, l_.str.58@PAGEOFF
	b	LBB2_706
LBB2_714:
	ldr	x8, [x27, #48]
	ldr	x9, [x27, #32]
	ldr	w10, [x27, #56]
LBB2_715:
	stp	x10, x9, [sp, #8]
	str	x8, [sp]
Lloh208:
	adrp	x0, l_.str.16@PAGE
Lloh209:
	add	x0, x0, l_.str.16@PAGEOFF
	b	LBB2_706
LBB2_716:
	ldr	x8, [x27, #112]
	ldr	x9, [x27, #96]
	ldr	w10, [x27, #120]
	b	LBB2_705
LBB2_717:
	ldr	x8, [x27, #144]
	ldr	w9, [x27, #152]
LBB2_718:
	stp	x8, x9, [sp]
Lloh210:
	adrp	x0, l_.str.8@PAGE
Lloh211:
	add	x0, x0, l_.str.8@PAGEOFF
	b	LBB2_706
LBB2_719:
	ldr	x8, [x27, #176]
	ldr	x9, [x27, #160]
	ldr	w10, [x27, #184]
LBB2_720:
	stp	x10, x9, [sp, #8]
	str	x8, [sp]
Lloh212:
	adrp	x0, l_.str.10@PAGE
Lloh213:
	add	x0, x0, l_.str.10@PAGEOFF
	b	LBB2_706
LBB2_721:
	ldr	x8, [x27, #144]
	ldr	x9, [x27, #128]
	ldr	w10, [x27, #152]
LBB2_722:
	stp	x10, x9, [sp, #8]
	str	x8, [sp]
Lloh214:
	adrp	x0, l_.str.9@PAGE
Lloh215:
	add	x0, x0, l_.str.9@PAGEOFF
	b	LBB2_706
LBB2_723:
	ldr	x8, [x27, #144]
	ldr	x9, [x27, #128]
	ldr	w10, [x27, #152]
	b	LBB2_705
LBB2_724:
	ldr	x8, [x27, #48]
	ldr	x9, [x27, #32]
	ldr	w10, [x27, #56]
	b	LBB2_722
LBB2_725:
	ldr	x8, [x27, #16]
	ldr	w9, [x27, #24]
	stp	x9, x24, [sp, #8]
	str	x8, [sp]
Lloh216:
	adrp	x0, l_.str.65@PAGE
Lloh217:
	add	x0, x0, l_.str.65@PAGEOFF
	b	LBB2_706
LBB2_726:
	ldr	x8, [x27, #80]
	ldr	x9, [x27, #64]
	ldr	w10, [x27, #88]
	b	LBB2_713
LBB2_727:
	ldr	x8, [x27, #80]
	ldr	w9, [x27, #88]
	stp	x9, x19, [sp, #8]
	str	x8, [sp]
Lloh218:
	adrp	x0, l_.str.63@PAGE
Lloh219:
	add	x0, x0, l_.str.63@PAGEOFF
	b	LBB2_706
LBB2_728:
	ldr	x8, [x27, #112]
	ldr	x9, [x27, #96]
	ldr	w10, [x27, #120]
	stp	x10, x9, [sp, #8]
	str	x8, [sp]
Lloh220:
	adrp	x0, l_.str.64@PAGE
Lloh221:
	add	x0, x0, l_.str.64@PAGEOFF
	b	LBB2_706
LBB2_729:
	ldr	x8, [x27, #144]
	ldr	x9, [x27, #128]
	ldr	w10, [x27, #152]
	b	LBB2_715
LBB2_730:
	ldr	x8, [x27, #176]
	ldr	x9, [x27, #160]
	ldr	w10, [x27, #184]
	b	LBB2_709
LBB2_731:
	ldr	x8, [x27, #176]
	ldr	w9, [x27, #184]
	b	LBB2_718
LBB2_732:
	ldr	x8, [x27, #208]
	ldr	x9, [x27, #192]
	ldr	w10, [x27, #216]
	b	LBB2_720
	.loh AdrpAdd	Lloh26, Lloh27
	.loh AdrpAdd	Lloh24, Lloh25
	.loh AdrpLdr	Lloh22, Lloh23
	.loh AdrpAdrp	Lloh20, Lloh22
	.loh AdrpLdr	Lloh20, Lloh21
	.loh AdrpAdrp	Lloh18, Lloh20
	.loh AdrpLdr	Lloh18, Lloh19
	.loh AdrpAdrp	Lloh16, Lloh18
	.loh AdrpLdr	Lloh16, Lloh17
	.loh AdrpAdd	Lloh14, Lloh15
	.loh AdrpAdd	Lloh28, Lloh29
	.loh AdrpAdd	Lloh30, Lloh31
	.loh AdrpAdd	Lloh32, Lloh33
	.loh AdrpAdd	Lloh34, Lloh35
	.loh AdrpAdd	Lloh36, Lloh37
	.loh AdrpAdd	Lloh38, Lloh39
	.loh AdrpAdd	Lloh40, Lloh41
	.loh AdrpAdd	Lloh42, Lloh43
	.loh AdrpAdd	Lloh44, Lloh45
	.loh AdrpAdd	Lloh46, Lloh47
	.loh AdrpAdd	Lloh48, Lloh49
	.loh AdrpAdd	Lloh50, Lloh51
	.loh AdrpAdd	Lloh52, Lloh53
	.loh AdrpAdd	Lloh54, Lloh55
	.loh AdrpAdd	Lloh56, Lloh57
	.loh AdrpAdd	Lloh58, Lloh59
	.loh AdrpAdd	Lloh60, Lloh61
	.loh AdrpAdd	Lloh62, Lloh63
	.loh AdrpAdd	Lloh64, Lloh65
	.loh AdrpAdd	Lloh66, Lloh67
	.loh AdrpAdd	Lloh68, Lloh69
	.loh AdrpAdd	Lloh70, Lloh71
	.loh AdrpAdd	Lloh72, Lloh73
	.loh AdrpAdd	Lloh74, Lloh75
	.loh AdrpAdd	Lloh76, Lloh77
	.loh AdrpAdd	Lloh78, Lloh79
	.loh AdrpAdd	Lloh80, Lloh81
	.loh AdrpAdd	Lloh82, Lloh83
	.loh AdrpAdd	Lloh84, Lloh85
	.loh AdrpAdd	Lloh86, Lloh87
	.loh AdrpAdd	Lloh88, Lloh89
	.loh AdrpAdd	Lloh90, Lloh91
	.loh AdrpAdd	Lloh92, Lloh93
	.loh AdrpAdd	Lloh94, Lloh95
	.loh AdrpAdd	Lloh96, Lloh97
	.loh AdrpAdd	Lloh98, Lloh99
	.loh AdrpAdd	Lloh100, Lloh101
	.loh AdrpAdd	Lloh102, Lloh103
	.loh AdrpAdd	Lloh104, Lloh105
	.loh AdrpAdd	Lloh106, Lloh107
	.loh AdrpAdd	Lloh108, Lloh109
	.loh AdrpAdd	Lloh110, Lloh111
	.loh AdrpAdd	Lloh112, Lloh113
	.loh AdrpAdd	Lloh114, Lloh115
	.loh AdrpAdd	Lloh116, Lloh117
	.loh AdrpAdd	Lloh118, Lloh119
	.loh AdrpAdd	Lloh120, Lloh121
	.loh AdrpAdd	Lloh122, Lloh123
	.loh AdrpAdd	Lloh124, Lloh125
	.loh AdrpAdd	Lloh126, Lloh127
	.loh AdrpAdd	Lloh128, Lloh129
	.loh AdrpAdd	Lloh130, Lloh131
	.loh AdrpAdd	Lloh132, Lloh133
	.loh AdrpAdd	Lloh134, Lloh135
	.loh AdrpAdd	Lloh136, Lloh137
	.loh AdrpAdd	Lloh138, Lloh139
	.loh AdrpAdd	Lloh140, Lloh141
	.loh AdrpAdd	Lloh142, Lloh143
	.loh AdrpAdd	Lloh144, Lloh145
	.loh AdrpAdd	Lloh146, Lloh147
	.loh AdrpAdd	Lloh148, Lloh149
	.loh AdrpAdd	Lloh150, Lloh151
	.loh AdrpAdd	Lloh152, Lloh153
	.loh AdrpAdd	Lloh154, Lloh155
	.loh AdrpAdd	Lloh156, Lloh157
	.loh AdrpAdd	Lloh158, Lloh159
	.loh AdrpAdd	Lloh160, Lloh161
	.loh AdrpAdd	Lloh162, Lloh163
	.loh AdrpAdd	Lloh164, Lloh165
	.loh AdrpAdd	Lloh166, Lloh167
	.loh AdrpAdd	Lloh168, Lloh169
	.loh AdrpAdd	Lloh170, Lloh171
	.loh AdrpAdd	Lloh172, Lloh173
	.loh AdrpAdd	Lloh174, Lloh175
	.loh AdrpAdd	Lloh176, Lloh177
	.loh AdrpAdd	Lloh178, Lloh179
	.loh AdrpAdd	Lloh180, Lloh181
	.loh AdrpAdd	Lloh182, Lloh183
	.loh AdrpAdd	Lloh184, Lloh185
	.loh AdrpAdd	Lloh186, Lloh187
	.loh AdrpAdd	Lloh188, Lloh189
	.loh AdrpAdd	Lloh190, Lloh191
	.loh AdrpAdd	Lloh192, Lloh193
	.loh AdrpAdd	Lloh194, Lloh195
	.loh AdrpAdd	Lloh196, Lloh197
	.loh AdrpAdd	Lloh198, Lloh199
	.loh AdrpAdd	Lloh200, Lloh201
	.loh AdrpAdd	Lloh202, Lloh203
	.loh AdrpAdd	Lloh204, Lloh205
	.loh AdrpAdd	Lloh206, Lloh207
	.loh AdrpAdd	Lloh208, Lloh209
	.loh AdrpAdd	Lloh210, Lloh211
	.loh AdrpAdd	Lloh212, Lloh213
	.loh AdrpAdd	Lloh214, Lloh215
	.loh AdrpAdd	Lloh216, Lloh217
	.loh AdrpAdd	Lloh218, Lloh219
	.loh AdrpAdd	Lloh220, Lloh221
	.cfi_endproc
	.section	__TEXT,__const
	.p2align	1, 0x0
lJTI2_0:
	.short	(LBB2_701-LBB2_3)>>2
	.short	(LBB2_6-LBB2_3)>>2
	.short	(LBB2_3-LBB2_3)>>2
	.short	(LBB2_63-LBB2_3)>>2
	.short	(LBB2_3-LBB2_3)>>2
	.short	(LBB2_3-LBB2_3)>>2
	.short	(LBB2_3-LBB2_3)>>2
	.short	(LBB2_79-LBB2_3)>>2
	.p2align	1, 0x0
lJTI2_1:
	.short	(LBB2_70-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_65-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_76-LBB2_65)>>2
	.short	(LBB2_126-LBB2_65)>>2
	.short	(LBB2_75-LBB2_65)>>2
	.p2align	1, 0x0
lJTI2_2:
	.short	(LBB2_99-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_94-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_105-LBB2_94)>>2
	.short	(LBB2_149-LBB2_94)>>2
	.short	(LBB2_104-LBB2_94)>>2
lJTI2_3:
	.byte	(LBB2_476-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_471-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_481-LBB2_471)>>2
	.byte	(LBB2_528-LBB2_471)>>2
	.byte	(LBB2_482-LBB2_471)>>2
	.p2align	1, 0x0
lJTI2_4:
	.short	(LBB2_449-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_444-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_454-LBB2_444)>>2
	.short	(LBB2_519-LBB2_444)>>2
	.short	(LBB2_455-LBB2_444)>>2
	.p2align	1, 0x0
lJTI2_5:
	.short	(LBB2_406-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_401-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_411-LBB2_401)>>2
	.short	(LBB2_511-LBB2_401)>>2
	.short	(LBB2_412-LBB2_401)>>2
	.p2align	1, 0x0
lJTI2_6:
	.short	(LBB2_360-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_355-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_366-LBB2_355)>>2
	.short	(LBB2_502-LBB2_355)>>2
	.short	(LBB2_365-LBB2_355)>>2
	.p2align	1, 0x0
lJTI2_7:
	.short	(LBB2_166-LBB2_166)>>2
	.short	(LBB2_228-LBB2_166)>>2
	.short	(LBB2_711-LBB2_166)>>2
	.short	(LBB2_240-LBB2_166)>>2
	.short	(LBB2_711-LBB2_166)>>2
	.short	(LBB2_711-LBB2_166)>>2
	.short	(LBB2_711-LBB2_166)>>2
	.short	(LBB2_233-LBB2_166)>>2
	.p2align	1, 0x0
lJTI2_8:
	.short	(LBB2_313-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_308-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_319-LBB2_308)>>2
	.short	(LBB2_492-LBB2_308)>>2
	.short	(LBB2_318-LBB2_308)>>2
	.p2align	1, 0x0
lJTI2_9:
	.short	(LBB2_173-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_168-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_179-LBB2_168)>>2
	.short	(LBB2_458-LBB2_168)>>2
	.short	(LBB2_178-LBB2_168)>>2
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_isValidBegin                   ; -- Begin function isValidBegin
	.p2align	2
_isValidBegin:                          ; @isValidBegin
	.cfi_startproc
; %bb.0:
	and	w8, w0, #0xffffffdf
	sub	w8, w8, #65
	cmp	w0, #95
	ccmp	w8, #26, #0, ne
	cset	w0, lo
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_isValid                        ; -- Begin function isValid
	.p2align	2
_isValid:                               ; @isValid
	.cfi_startproc
; %bb.0:
	mov	x8, x0
	sub	w9, w0, #48
	mov	w0, #1
	cmp	w9, #10
	b.lo	LBB4_4
; %bb.1:
	and	w9, w8, #0xffffffdf
	sub	w9, w9, #65
	cmp	w9, #26
	b.lo	LBB4_4
; %bb.2:
	mov	w0, #1
	sub	w9, w8, #36
	cmp	w9, #59
	b.hi	LBB4_5
; %bb.3:
	mov	w10, #1
	lsl	x9, x10, x9
	mov	x10, #1041
	movk	x10, #2048, lsl #48
	tst	x9, x10
	b.eq	LBB4_5
LBB4_4:
	ret
LBB4_5:
	cmp	w8, #41
	cset	w9, eq
	cmp	w8, #125
	csel	w9, w0, w9, eq
	cmp	w8, #123
	csel	w0, w0, w9, eq
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_lower                          ; -- Begin function lower
	.p2align	2
_lower:                                 ; @lower
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
	mov	x20, x0
	bl	_strlen
	mov	x21, x0
	add	x0, x0, #1
	bl	_malloc
	mov	x19, x0
	cbz	x21, LBB5_3
; %bb.1:
	mov	x21, #0
LBB5_2:                                 ; =>This Inner Loop Header: Depth=1
	ldrsb	w0, [x20, x21]
	bl	___tolower
	strb	w0, [x19, x21]
	add	x21, x21, #1
	mov	x0, x20
	bl	_strlen
	cmp	x0, x21
	b.hi	LBB5_2
	b	LBB5_4
LBB5_3:
	mov	x0, #0
LBB5_4:
	strb	wzr, [x19, x0]
	mov	x0, x19
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_parse64                        ; -- Begin function parse64
	.p2align	2
_parse64:                               ; @parse64
	.cfi_startproc
; %bb.0:
	ldrb	w8, [x0]
	cmp	w8, #48
	b.ne	LBB6_5
; %bb.1:
	ldrb	w8, [x0, #1]
	cmp	w8, #98
	b.eq	LBB6_6
; %bb.2:
	cmp	w8, #111
	b.eq	LBB6_7
; %bb.3:
	cmp	w8, #120
	b.ne	LBB6_5
; %bb.4:
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #16
	b	_strtoull
LBB6_5:
	mov	x1, #0
	mov	w2, #10
	b	_strtoull
LBB6_6:
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #2
	b	_strtoull
LBB6_7:
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #8
	b	_strtoull
	.cfi_endproc
                                        ; -- End function
	.globl	_parse32                        ; -- Begin function parse32
	.p2align	2
_parse32:                               ; @parse32
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldrb	w8, [x0]
	cmp	w8, #48
	b.ne	LBB7_5
; %bb.1:
	ldrb	w8, [x0, #1]
	cmp	w8, #98
	b.eq	LBB7_7
; %bb.2:
	cmp	w8, #111
	b.eq	LBB7_8
; %bb.3:
	cmp	w8, #120
	b.ne	LBB7_5
; %bb.4:
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #16
	b	LBB7_6
LBB7_5:
	mov	x1, #0
	mov	w2, #10
LBB7_6:
	bl	_strtoul
                                        ; kill: def $w0 killed $w0 killed $x0
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
LBB7_7:
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #2
	b	LBB7_6
LBB7_8:
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #8
	b	LBB7_6
	.cfi_endproc
                                        ; -- End function
	.globl	_parse16                        ; -- Begin function parse16
	.p2align	2
_parse16:                               ; @parse16
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldrb	w8, [x0]
	cmp	w8, #48
	b.ne	LBB8_5
; %bb.1:
	ldrb	w8, [x0, #1]
	cmp	w8, #98
	b.eq	LBB8_8
; %bb.2:
	cmp	w8, #111
	b.eq	LBB8_9
; %bb.3:
	cmp	w8, #120
	b.ne	LBB8_5
; %bb.4:
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #16
	b	LBB8_6
LBB8_5:
	mov	x1, #0
	mov	w2, #10
LBB8_6:
	bl	_strtoul
LBB8_7:
	and	w0, w0, #0xffff
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
LBB8_8:
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #2
	bl	_strtol
	b	LBB8_7
LBB8_9:
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #8
	b	LBB8_6
	.cfi_endproc
                                        ; -- End function
	.globl	_parse8                         ; -- Begin function parse8
	.p2align	2
_parse8:                                ; @parse8
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldrb	w8, [x0]
	cmp	w8, #48
	b.ne	LBB9_5
; %bb.1:
	ldrb	w8, [x0, #1]
	cmp	w8, #98
	b.eq	LBB9_8
; %bb.2:
	cmp	w8, #111
	b.eq	LBB9_9
; %bb.3:
	cmp	w8, #120
	b.ne	LBB9_5
; %bb.4:
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #16
	b	LBB9_6
LBB9_5:
	mov	x1, #0
	mov	w2, #10
LBB9_6:
	bl	_strtoul
LBB9_7:
	and	w0, w0, #0xff
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
LBB9_8:
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #2
	bl	_strtol
	b	LBB9_7
LBB9_9:
	add	x0, x0, #2
	mov	x1, #0
	mov	w2, #8
	b	LBB9_6
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function add_instruction
_add_instruction:                       ; @add_instruction
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
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
	mov	x19, x1
	mov	x20, x0
	ldp	x8, x9, [x0, #32]
	add	x10, x8, #1
	str	x10, [x0, #32]
	cmp	x8, x9
	b.ne	LBB10_2
; %bb.1:
	lsl	x9, x8, #1
	mov	w10, #16
	cmp	x8, #0
	csel	x8, x10, x9, eq
	str	x8, [x20, #40]
	ldr	x0, [x20, #24]
	add	x8, x8, x8, lsl #4
	lsl	x1, x8, #4
	bl	_realloc
	str	x0, [x20, #24]
	ldr	x8, [x20, #32]
	sub	x8, x8, #1
	b	LBB10_3
LBB10_2:
	ldr	x0, [x20, #24]
LBB10_3:
	mov	w9, #272
	madd	x0, x8, x9, x0
	mov	w8, #1
	str	w8, [x0], #8
	mov	x1, x19
	mov	w2, #264
	bl	_memcpy
	ldr	x8, [x20, #48]
	add	x8, x8, #2
	str	x8, [x20, #48]
	mov	w22, #8
Lloh222:
	adrp	x21, l_.str.93@PAGE
Lloh223:
	add	x21, x21, l_.str.93@PAGEOFF
Lloh224:
	adrp	x23, lJTI10_0@PAGE
Lloh225:
	add	x23, x23, lJTI10_0@PAGEOFF
	mov	w24, #16
	b	LBB10_9
LBB10_4:                                ;   in Loop: Header=BB10_9 Depth=1
	lsl	x9, x8, #1
	cmp	x8, #0
	csel	x8, x24, x9, eq
	str	x8, [x20, #64]
	ldr	x0, [x20, #72]
	lsl	x1, x8, #3
	bl	_realloc
	str	x0, [x20, #72]
	ldr	x8, [x20, #56]
	sub	x8, x8, #1
LBB10_5:                                ;   in Loop: Header=BB10_9 Depth=1
	ldr	x9, [x20, #48]
	str	x9, [x0, x8, lsl  #3]
LBB10_6:                                ;   in Loop: Header=BB10_9 Depth=1
	ldr	x8, [x20, #48]
	add	x8, x8, #8
LBB10_7:                                ;   in Loop: Header=BB10_9 Depth=1
	str	x8, [x20, #48]
LBB10_8:                                ;   in Loop: Header=BB10_9 Depth=1
	add	x22, x22, #16
	cmp	x22, #72
	b.eq	LBB10_16
LBB10_9:                                ; =>This Inner Loop Header: Depth=1
	ldr	w8, [x19, x22]
	cmp	w8, #4
	b.hi	LBB10_12
; %bb.10:                               ;   in Loop: Header=BB10_9 Depth=1
	adr	x9, LBB10_6
	ldrb	w10, [x23, x8]
	add	x9, x9, x10, lsl #2
	br	x9
LBB10_11:                               ;   in Loop: Header=BB10_9 Depth=1
	ldr	x8, [x20, #48]
	add	x8, x8, #1
	b	LBB10_7
LBB10_12:                               ;   in Loop: Header=BB10_9 Depth=1
	ldrh	w9, [x19]
	and	w10, w9, #0xf
	lsr	w9, w9, #4
	stp	x10, x9, [sp, #8]
	str	x8, [sp]
	mov	x0, x21
	bl	_printf
	b	LBB10_8
LBB10_13:                               ;   in Loop: Header=BB10_9 Depth=1
	ldr	x8, [x20, #48]
	add	x8, x8, #2
	b	LBB10_7
LBB10_14:                               ;   in Loop: Header=BB10_9 Depth=1
	ldp	x8, x9, [x20, #56]
	add	x10, x8, #1
	str	x10, [x20, #56]
	cmp	x8, x9
	b.eq	LBB10_4
; %bb.15:                               ;   in Loop: Header=BB10_9 Depth=1
	ldr	x0, [x20, #72]
	b	LBB10_5
LBB10_16:
	ldp	x29, x30, [sp, #80]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #64]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #48]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #96
	ret
	.loh AdrpAdd	Lloh224, Lloh225
	.loh AdrpAdd	Lloh222, Lloh223
	.cfi_endproc
	.section	__TEXT,__const
lJTI10_0:
	.byte	(LBB10_8-LBB10_6)>>2
	.byte	(LBB10_11-LBB10_6)>>2
	.byte	(LBB10_13-LBB10_6)>>2
	.byte	(LBB10_6-LBB10_6)>>2
	.byte	(LBB10_14-LBB10_6)>>2
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_unquote                        ; -- Begin function unquote
	.p2align	2
_unquote:                               ; @unquote
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
	mov	x19, x0
	bl	_strlen
	add	x0, x0, #1
	bl	_malloc
Lloh226:
	adrp	x9, lJTI11_0@PAGE
Lloh227:
	add	x9, x9, lJTI11_0@PAGEOFF
	mov	x8, x0
	b	LBB11_3
LBB11_1:                                ;   in Loop: Header=BB11_3 Depth=1
	cbz	w10, LBB11_16
LBB11_2:                                ;   in Loop: Header=BB11_3 Depth=1
	strb	w10, [x8], #1
	add	x19, x19, #1
LBB11_3:                                ; =>This Inner Loop Header: Depth=1
	ldrb	w10, [x19]
	cmp	w10, #92
	b.ne	LBB11_1
; %bb.4:                                ;   in Loop: Header=BB11_3 Depth=1
	ldrsb	w11, [x19, #1]!
	cmp	w11, #91
	b.le	LBB11_8
; %bb.5:                                ;   in Loop: Header=BB11_3 Depth=1
	sub	w12, w11, #92
	cmp	w12, #24
	b.hi	LBB11_18
; %bb.6:                                ;   in Loop: Header=BB11_3 Depth=1
	mov	w10, #10
	adr	x13, LBB11_2
	ldrb	w14, [x9, x12]
	add	x13, x13, x14, lsl #2
	br	x13
LBB11_7:                                ;   in Loop: Header=BB11_3 Depth=1
	mov	w10, #92
	b	LBB11_2
LBB11_8:                                ;   in Loop: Header=BB11_3 Depth=1
	cmp	w11, #34
	b.eq	LBB11_14
; %bb.9:                                ;   in Loop: Header=BB11_3 Depth=1
	cmp	w11, #39
	b.eq	LBB11_15
; %bb.10:                               ;   in Loop: Header=BB11_3 Depth=1
	cmp	w11, #48
	b.ne	LBB11_18
; %bb.11:                               ;   in Loop: Header=BB11_3 Depth=1
	mov	w10, #0
	b	LBB11_2
LBB11_12:                               ;   in Loop: Header=BB11_3 Depth=1
	mov	w10, #13
	b	LBB11_2
LBB11_13:                               ;   in Loop: Header=BB11_3 Depth=1
	mov	w10, #9
	b	LBB11_2
LBB11_14:                               ;   in Loop: Header=BB11_3 Depth=1
	mov	w10, #34
	b	LBB11_2
LBB11_15:                               ;   in Loop: Header=BB11_3 Depth=1
	mov	w10, #39
	b	LBB11_2
LBB11_16:
	strb	wzr, [x8]
LBB11_17:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
LBB11_18:
	str	x11, [sp]
Lloh228:
	adrp	x0, l_.str.74@PAGE
Lloh229:
	add	x0, x0, l_.str.74@PAGEOFF
	bl	_printf
	mov	x0, #0
	b	LBB11_17
	.loh AdrpAdd	Lloh226, Lloh227
	.loh AdrpAdd	Lloh228, Lloh229
	.cfi_endproc
	.section	__TEXT,__const
lJTI11_0:
	.byte	(LBB11_7-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_2-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_12-LBB11_2)>>2
	.byte	(LBB11_18-LBB11_2)>>2
	.byte	(LBB11_13-LBB11_2)>>2
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_nextToken                      ; -- Begin function nextToken
	.p2align	2
_nextToken:                             ; @nextToken
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #96
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
	mov	x19, x8
	adrp	x24, _src@PAGE
	ldr	x20, [x24, _src@PAGEOFF]
	adrp	x23, _line@PAGE
Lloh230:
	adrp	x25, __DefaultRuneLocale@GOTPAGE
Lloh231:
	ldr	x25, [x25, __DefaultRuneLocale@GOTPAGEOFF]
LBB12_1:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB12_4 Depth 2
                                        ;     Child Loop BB12_11 Depth 2
	ldr	w10, [x23, _line@PAGEOFF]
	add	x8, x20, #1
	b	LBB12_4
LBB12_2:                                ;   in Loop: Header=BB12_4 Depth=2
	add	w10, w10, #1
	str	w10, [x23, _line@PAGEOFF]
LBB12_3:                                ;   in Loop: Header=BB12_4 Depth=2
	add	x20, x20, #1
	str	x20, [x24, _src@PAGEOFF]
	add	x8, x8, #1
LBB12_4:                                ;   Parent Loop BB12_1 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w9, [x20]
	cmp	w9, #31
	b.gt	LBB12_7
; %bb.5:                                ;   in Loop: Header=BB12_4 Depth=2
	cmp	w9, #10
	b.eq	LBB12_2
; %bb.6:                                ;   in Loop: Header=BB12_4 Depth=2
	cmp	w9, #13
	b.eq	LBB12_3
	b	LBB12_14
LBB12_7:                                ;   in Loop: Header=BB12_4 Depth=2
	cmp	w9, #32
	b.eq	LBB12_3
; %bb.8:                                ;   in Loop: Header=BB12_1 Depth=1
	cmp	w9, #64
	b.eq	LBB12_10
; %bb.9:                                ;   in Loop: Header=BB12_1 Depth=1
	cmp	w9, #59
	b.ne	LBB12_14
LBB12_10:                               ;   in Loop: Header=BB12_1 Depth=1
	ands	w10, w9, #0xff
	b.eq	LBB12_13
LBB12_11:                               ;   Parent Loop BB12_1 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	cmp	w10, #10
	b.eq	LBB12_13
; %bb.12:                               ;   in Loop: Header=BB12_11 Depth=2
	str	x8, [x24, _src@PAGEOFF]
	ldrb	w9, [x8], #1
	ands	w10, w9, #0xff
	b.ne	LBB12_11
LBB12_13:                               ;   in Loop: Header=BB12_1 Depth=1
	sub	x20, x8, #1
LBB12_14:                               ;   in Loop: Header=BB12_1 Depth=1
	and	w8, w9, #0xff
	cmp	w8, #95
	b.eq	LBB12_27
; %bb.15:                               ;   in Loop: Header=BB12_1 Depth=1
	sxtb	w0, w9
	and	w8, w0, #0xffffffdf
	sub	w8, w8, #91
	cmn	w8, #26
	b.hs	LBB12_27
; %bb.16:                               ;   in Loop: Header=BB12_1 Depth=1
	tbnz	w0, #31, LBB12_18
; %bb.17:                               ;   in Loop: Header=BB12_1 Depth=1
	add	x8, x25, w0, uxtw #2
	ldr	w8, [x8, #60]
	and	w0, w8, #0x400
	ldr	x20, [x24, _src@PAGEOFF]
	cbz	w0, LBB12_19
	b	LBB12_30
LBB12_18:                               ;   in Loop: Header=BB12_1 Depth=1
	mov	w1, #1024
	bl	___maskrune
	ldr	x20, [x24, _src@PAGEOFF]
	cbnz	w0, LBB12_30
LBB12_19:                               ;   in Loop: Header=BB12_1 Depth=1
	ldrb	w8, [x20]
	cmp	w8, #45
	b.gt	LBB12_23
; %bb.20:                               ;   in Loop: Header=BB12_1 Depth=1
	cbz	w8, LBB12_102
; %bb.21:                               ;   in Loop: Header=BB12_1 Depth=1
	cmp	w8, #34
	b.eq	LBB12_38
; %bb.22:                               ;   in Loop: Header=BB12_1 Depth=1
	cmp	w8, #39
	b.ne	LBB12_1
	b	LBB12_40
LBB12_23:                               ;   in Loop: Header=BB12_1 Depth=1
	cmp	w8, #46
	b.eq	LBB12_42
; %bb.24:                               ;   in Loop: Header=BB12_1 Depth=1
	cmp	w8, #91
	b.eq	LBB12_50
; %bb.25:                               ;   in Loop: Header=BB12_1 Depth=1
	cmp	w8, #93
	b.ne	LBB12_1
; %bb.26:
	add	x8, x20, #1
	str	x8, [x24, _src@PAGEOFF]
Lloh232:
	adrp	x8, l_.str.92@PAGE
Lloh233:
	add	x8, x8, l_.str.92@PAGEOFF
	str	x8, [x19]
	mov	w8, #8
	b	LBB12_128
LBB12_27:
	mov	x0, x20
	bl	_strdup
	mov	x21, x0
	ldrb	w8, [x0]
	mov	x22, x20
	cmp	w8, #114
	b.ne	LBB12_78
; %bb.28:
	add	x8, x20, #1
	str	x8, [x24, _src@PAGEOFF]
	ldrsb	w0, [x20, #1]
	tbnz	w0, #31, LBB12_76
; %bb.29:
	add	x8, x25, w0, uxtw #2
	ldr	w8, [x8, #60]
	and	w0, w8, #0x400
	ldr	x8, [x24, _src@PAGEOFF]
	cbnz	w0, LBB12_83
	b	LBB12_77
LBB12_30:
	mov	x0, x20
	bl	_strdup
	mov	x21, x0
	ldrb	w8, [x20]
	mov	x22, x20
	cmp	w8, #45
	b.ne	LBB12_32
; %bb.31:
	add	x22, x20, #1
	str	x22, [x24, _src@PAGEOFF]
LBB12_32:
Lloh234:
	adrp	x1, l_.str.88@PAGE
Lloh235:
	add	x1, x1, l_.str.88@PAGEOFF
	mov	x0, x22
	mov	w2, #2
	bl	_strncmp
	cbz	w0, LBB12_67
; %bb.33:
Lloh236:
	adrp	x1, l_.str.89@PAGE
Lloh237:
	add	x1, x1, l_.str.89@PAGEOFF
	mov	x0, x22
	mov	w2, #2
	bl	_strncmp
	cbz	w0, LBB12_72
; %bb.34:
	ldrsb	w0, [x22]
	tbnz	w0, #31, LBB12_36
LBB12_35:
	add	x8, x25, w0, uxtw #2
	ldr	w8, [x8, #60]
	and	w0, w8, #0x400
	ldr	x8, [x24, _src@PAGEOFF]
	cbnz	w0, LBB12_37
	b	LBB12_61
LBB12_36:
	mov	w1, #1024
	bl	___maskrune
	ldr	x8, [x24, _src@PAGEOFF]
	cbz	w0, LBB12_61
LBB12_37:
	add	x22, x8, #1
	str	x22, [x24, _src@PAGEOFF]
	ldrsb	w0, [x22]
	tbz	w0, #31, LBB12_35
	b	LBB12_36
LBB12_38:
	add	x21, x20, #1
	mov	x0, x21
	bl	_strdup
	ldrb	w8, [x20, #1]
	cmp	w8, #34
	b.ne	LBB12_51
; %bb.39:
	mov	x8, x21
	b	LBB12_53
LBB12_40:
	add	x21, x20, #1
	mov	x0, x21
	bl	_strdup
	ldrb	w8, [x20, #1]
	cmp	w8, #39
	b.ne	LBB12_54
; %bb.41:
	mov	x8, x21
	b	LBB12_56
LBB12_42:
	add	x0, x20, #1
	str	x0, [x24, _src@PAGEOFF]
	bl	_strdup
	mov	x8, #0
	mov	w9, #1
	mov	x10, #1041
	movk	x10, #2048, lsl #48
	b	LBB12_44
LBB12_43:                               ;   in Loop: Header=BB12_44 Depth=1
	add	x11, x11, #2
	str	x11, [x24, _src@PAGEOFF]
	add	x8, x8, #1
LBB12_44:                               ; =>This Inner Loop Header: Depth=1
	add	x11, x20, x8
	ldrsb	w12, [x11, #1]
	and	w13, w12, #0xffffffdf
	sub	w13, w13, #65
	sub	w14, w12, #48
	cmp	w14, #10
	ccmp	w13, #26, #0, hs
	b.lo	LBB12_43
; %bb.45:                               ;   in Loop: Header=BB12_44 Depth=1
	sub	w13, w12, #36
	cmp	w13, #59
	lsl	x13, x9, x13
	and	x13, x13, x10
	ccmp	x13, #0, #4, ls
	b.ne	LBB12_43
; %bb.46:                               ;   in Loop: Header=BB12_44 Depth=1
	cmp	w12, #123
	b.eq	LBB12_43
; %bb.47:                               ;   in Loop: Header=BB12_44 Depth=1
	cmp	w12, #125
	b.eq	LBB12_43
; %bb.48:                               ;   in Loop: Header=BB12_44 Depth=1
	cmp	w12, #41
	b.eq	LBB12_43
; %bb.49:
	strb	wzr, [x0, x8]
	str	x0, [x19]
	mov	w8, #6
	b	LBB12_128
LBB12_50:
	add	x8, x20, #1
	str	x8, [x24, _src@PAGEOFF]
Lloh238:
	adrp	x8, l_.str.91@PAGE
Lloh239:
	add	x8, x8, l_.str.91@PAGEOFF
	str	x8, [x19]
	mov	w8, #7
	b	LBB12_128
LBB12_51:
	mov	x8, x21
LBB12_52:                               ; =>This Inner Loop Header: Depth=1
	ldrb	w9, [x8, #1]!
	cmp	w9, #34
	b.ne	LBB12_52
LBB12_53:
	sub	x9, x8, x21
	strb	wzr, [x0, x9]
	add	x8, x8, #1
	str	x8, [x24, _src@PAGEOFF]
	str	x0, [x19]
	mov	w8, #5
	b	LBB12_128
LBB12_54:
	mov	x8, x21
LBB12_55:                               ; =>This Inner Loop Header: Depth=1
	ldrb	w9, [x8, #1]!
	cmp	w9, #39
	b.ne	LBB12_55
LBB12_56:
	sub	x9, x8, x21
	strb	wzr, [x0, x9]
	add	x8, x8, #1
	str	x8, [x24, _src@PAGEOFF]
	ldrb	w21, [x0]
	cmp	w21, #92
	b.ne	LBB12_100
; %bb.57:
	ldrsb	w8, [x0, #1]
	cmp	w8, #91
	b.le	LBB12_86
; %bb.58:
	sub	w9, w8, #92
	cmp	w9, #24
	b.hi	LBB12_101
; %bb.59:
	mov	w21, #10
Lloh240:
	adrp	x10, lJTI12_0@PAGE
Lloh241:
	add	x10, x10, lJTI12_0@PAGEOFF
	adr	x11, LBB12_60
	ldrb	w12, [x10, x9]
	add	x11, x11, x12, lsl #2
	br	x11
LBB12_60:
	mov	w21, #13
	b	LBB12_100
LBB12_61:
	ldrb	w9, [x8]
	cmp	w9, #46
	b.eq	LBB12_64
; %bb.62:
	sub	x8, x8, x20
	b	LBB12_75
LBB12_63:                               ;   in Loop: Header=BB12_64 Depth=1
	mov	w1, #1024
	bl	___maskrune
	ldr	x8, [x24, _src@PAGEOFF]
	cbz	w0, LBB12_66
LBB12_64:                               ; =>This Inner Loop Header: Depth=1
	add	x9, x8, #1
	str	x9, [x24, _src@PAGEOFF]
	ldrsb	w0, [x8, #1]
	tbnz	w0, #31, LBB12_63
; %bb.65:                               ;   in Loop: Header=BB12_64 Depth=1
	add	x8, x25, w0, uxtw #2
	ldr	w8, [x8, #60]
	and	w0, w8, #0x400
	ldr	x8, [x24, _src@PAGEOFF]
	cbnz	w0, LBB12_64
LBB12_66:
	sub	x8, x8, x20
	strb	wzr, [x21, x8]
	str	x21, [x19]
	mov	w8, #4
	b	LBB12_128
LBB12_67:
	ldrsb	w8, [x22, #2]!
	tbnz	w8, #31, LBB12_71
; %bb.68:
	and	x8, x8, #0xff
LBB12_69:                               ; =>This Inner Loop Header: Depth=1
	add	x8, x25, x8, lsl #2
	ldr	w8, [x8, #60]
	tbz	w8, #16, LBB12_71
; %bb.70:                               ;   in Loop: Header=BB12_69 Depth=1
	ldrsb	w9, [x22, #1]!
	and	x8, x9, #0xff
	tbz	w9, #31, LBB12_69
LBB12_71:
	str	x22, [x24, _src@PAGEOFF]
	sub	x8, x22, x20
	b	LBB12_75
LBB12_72:
	add	x9, x22, #1
	sub	x8, x9, x20
LBB12_73:                               ; =>This Inner Loop Header: Depth=1
	ldrb	w10, [x9, #1]!
	and	w10, w10, #0xfe
	add	x8, x8, #1
	cmp	w10, #48
	b.eq	LBB12_73
; %bb.74:
	str	x9, [x24, _src@PAGEOFF]
LBB12_75:
	strb	wzr, [x21, x8]
	str	x21, [x19]
	mov	w8, #3
	b	LBB12_128
LBB12_76:
	mov	w1, #1024
	bl	___maskrune
	ldr	x8, [x24, _src@PAGEOFF]
	cbnz	w0, LBB12_83
LBB12_77:
	sub	x22, x8, #1
	str	x22, [x24, _src@PAGEOFF]
LBB12_78:
Lloh242:
	adrp	x1, l_.str.75@PAGE
Lloh243:
	add	x1, x1, l_.str.75@PAGEOFF
	mov	x0, x22
	mov	w2, #3
	bl	_strncmp
	cbnz	w0, LBB12_104
; %bb.79:
	add	x8, x22, #3
	str	x8, [x24, _src@PAGEOFF]
	ldrsb	w0, [x22, #3]
	tbnz	w0, #31, LBB12_91
; %bb.80:
	add	x8, x25, w0, uxtw #2
	ldr	w8, [x8, #60]
	and	w0, w8, #0x400
	b	LBB12_92
LBB12_81:
	mov	w1, #1024
	bl	___maskrune
	ldr	x8, [x24, _src@PAGEOFF]
	cbz	w0, LBB12_85
LBB12_82:
	add	x8, x8, #1
	str	x8, [x24, _src@PAGEOFF]
	ldrsb	w0, [x8]
	tbz	w0, #31, LBB12_84
	b	LBB12_81
LBB12_83:
	ldrsb	w0, [x8]
	tbnz	w0, #31, LBB12_81
LBB12_84:
	add	x8, x25, w0, uxtw #2
	ldr	w8, [x8, #60]
	and	w0, w8, #0x400
	ldr	x8, [x24, _src@PAGEOFF]
	cbnz	w0, LBB12_82
LBB12_85:
	sub	x8, x8, x20
	strb	wzr, [x21, x8]
	str	x21, [x19]
	b	LBB12_127
LBB12_86:
	cmp	w8, #34
	b.eq	LBB12_90
; %bb.87:
	mov	x21, x8
	cmp	w8, #39
	b.eq	LBB12_100
; %bb.88:
	cmp	w8, #48
	b.ne	LBB12_101
; %bb.89:
	mov	w21, #0
	b	LBB12_100
LBB12_90:
	mov	x21, x8
	b	LBB12_100
LBB12_91:
	mov	w1, #1024
	bl	___maskrune
LBB12_92:
	ldr	x8, [x24, _src@PAGEOFF]
	cbz	w0, LBB12_98
; %bb.93:
	ldrsb	w0, [x8]
	tbnz	w0, #31, LBB12_95
LBB12_94:
	add	x8, x25, w0, uxtw #2
	ldr	w8, [x8, #60]
	and	w0, w8, #0x400
	ldr	x8, [x24, _src@PAGEOFF]
	cbnz	w0, LBB12_96
	b	LBB12_97
LBB12_95:
	mov	w1, #1024
	bl	___maskrune
	ldr	x8, [x24, _src@PAGEOFF]
	cbz	w0, LBB12_97
LBB12_96:
	add	x8, x8, #1
	str	x8, [x24, _src@PAGEOFF]
	ldrsb	w0, [x8]
	tbz	w0, #31, LBB12_94
	b	LBB12_95
LBB12_97:
	sub	x8, x8, x20
	strb	wzr, [x21, x8]
	str	x21, [x19]
	mov	w8, #9
	b	LBB12_128
LBB12_98:
	sub	x22, x8, #3
	b	LBB12_103
LBB12_99:
	mov	w21, #9
LBB12_100:
	mov	w0, #4
	bl	_malloc
	mov	x20, x0
	str	x21, [sp]
Lloh244:
	adrp	x2, l_.str.90@PAGE
Lloh245:
	add	x2, x2, l_.str.90@PAGEOFF
	mov	w1, #4
	bl	_snprintf
	str	x20, [x19]
	mov	w8, #3
	b	LBB12_128
LBB12_101:
	str	x8, [sp]
Lloh246:
	adrp	x0, l_.str.74@PAGE
Lloh247:
	add	x0, x0, l_.str.74@PAGEOFF
	bl	_printf
LBB12_102:
	str	xzr, [x19]
	mov	w8, #-1
	b	LBB12_128
LBB12_103:
	str	x22, [x24, _src@PAGEOFF]
LBB12_104:
	ldrsb	w8, [x22]
	and	w9, w8, #0xffffffdf
	sub	w9, w9, #65
	sub	w10, w8, #48
	cmp	w10, #10
	ccmp	w9, #26, #0, hs
	b.lo	LBB12_107
; %bb.105:
	sub	w9, w8, #36
	cmp	w9, #59
	b.hi	LBB12_108
; %bb.106:
	mov	w10, #1
	lsl	x9, x10, x9
	mov	x10, #1041
	movk	x10, #2048, lsl #48
	tst	x9, x10
	b.eq	LBB12_108
LBB12_107:
	add	x22, x22, #1
	b	LBB12_103
LBB12_108:
	cmp	w8, #123
	b.eq	LBB12_107
; %bb.109:
	cmp	w8, #125
	b.eq	LBB12_107
; %bb.110:
	cmp	w8, #41
	b.eq	LBB12_107
; %bb.111:
	sub	x8, x22, x20
	strb	wzr, [x21, x8]
	ldrb	w8, [x22]
	cmp	w8, #58
	b.ne	LBB12_113
; %bb.112:
	add	x8, x22, #1
	str	x8, [x24, _src@PAGEOFF]
	str	x21, [x19]
	mov	w8, #2
	b	LBB12_128
LBB12_113:
Lloh248:
	adrp	x1, l_.str.76@PAGE
Lloh249:
	add	x1, x1, l_.str.76@PAGEOFF
	mov	x0, x21
	bl	_strcmp
	cbz	w0, LBB12_120
; %bb.114:
Lloh250:
	adrp	x1, l_.str.77@PAGE
Lloh251:
	add	x1, x1, l_.str.77@PAGEOFF
	mov	x0, x21
	bl	_strcmp
	cbz	w0, LBB12_121
; %bb.115:
Lloh252:
	adrp	x1, l_.str.80@PAGE
Lloh253:
	add	x1, x1, l_.str.80@PAGEOFF
	mov	x0, x21
	bl	_strcmp
	cbz	w0, LBB12_122
; %bb.116:
Lloh254:
	adrp	x1, l_.str.82@PAGE
Lloh255:
	add	x1, x1, l_.str.82@PAGEOFF
	mov	x0, x21
	bl	_strcmp
	cbz	w0, LBB12_123
; %bb.117:
Lloh256:
	adrp	x1, l_.str.84@PAGE
Lloh257:
	add	x1, x1, l_.str.84@PAGEOFF
	mov	x0, x21
	bl	_strcmp
	cbz	w0, LBB12_124
; %bb.118:
Lloh258:
	adrp	x1, l_.str.86@PAGE
Lloh259:
	add	x1, x1, l_.str.86@PAGEOFF
	mov	x0, x21
	bl	_strcmp
	cbz	w0, LBB12_125
; %bb.119:
	str	x21, [x19]
	str	wzr, [x19, #8]
	b	LBB12_129
LBB12_120:
Lloh260:
	adrp	x8, l_.str.78@PAGE
Lloh261:
	add	x8, x8, l_.str.78@PAGEOFF
	b	LBB12_126
LBB12_121:
Lloh262:
	adrp	x8, l_.str.79@PAGE
Lloh263:
	add	x8, x8, l_.str.79@PAGEOFF
	b	LBB12_126
LBB12_122:
Lloh264:
	adrp	x8, l_.str.81@PAGE
Lloh265:
	add	x8, x8, l_.str.81@PAGEOFF
	b	LBB12_126
LBB12_123:
Lloh266:
	adrp	x8, l_.str.83@PAGE
Lloh267:
	add	x8, x8, l_.str.83@PAGEOFF
	b	LBB12_126
LBB12_124:
Lloh268:
	adrp	x8, l_.str.85@PAGE
Lloh269:
	add	x8, x8, l_.str.85@PAGEOFF
	b	LBB12_126
LBB12_125:
Lloh270:
	adrp	x8, l_.str.87@PAGE
Lloh271:
	add	x8, x8, l_.str.87@PAGEOFF
LBB12_126:
	str	x8, [x19]
LBB12_127:
	mov	w8, #1
LBB12_128:
	str	w8, [x19, #8]
LBB12_129:
Lloh272:
	adrp	x8, _file@PAGE
Lloh273:
	ldr	x8, [x8, _file@PAGEOFF]
	str	x8, [x19, #16]
	ldr	w8, [x23, _line@PAGEOFF]
	str	w8, [x19, #24]
	ldp	x29, x30, [sp, #80]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #64]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #48]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #32]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #96
	ret
	.loh AdrpLdrGot	Lloh230, Lloh231
	.loh AdrpAdd	Lloh232, Lloh233
	.loh AdrpAdd	Lloh234, Lloh235
	.loh AdrpAdd	Lloh236, Lloh237
	.loh AdrpAdd	Lloh238, Lloh239
	.loh AdrpAdd	Lloh240, Lloh241
	.loh AdrpAdd	Lloh242, Lloh243
	.loh AdrpAdd	Lloh244, Lloh245
	.loh AdrpAdd	Lloh246, Lloh247
	.loh AdrpAdd	Lloh248, Lloh249
	.loh AdrpAdd	Lloh250, Lloh251
	.loh AdrpAdd	Lloh252, Lloh253
	.loh AdrpAdd	Lloh254, Lloh255
	.loh AdrpAdd	Lloh256, Lloh257
	.loh AdrpAdd	Lloh258, Lloh259
	.loh AdrpAdd	Lloh260, Lloh261
	.loh AdrpAdd	Lloh262, Lloh263
	.loh AdrpAdd	Lloh264, Lloh265
	.loh AdrpAdd	Lloh266, Lloh267
	.loh AdrpAdd	Lloh268, Lloh269
	.loh AdrpAdd	Lloh270, Lloh271
	.loh AdrpLdr	Lloh272, Lloh273
	.cfi_endproc
	.section	__TEXT,__const
lJTI12_0:
	.byte	(LBB12_90-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_60-LBB12_60)>>2
	.byte	(LBB12_101-LBB12_60)>>2
	.byte	(LBB12_99-LBB12_60)>>2
                                        ; -- End function
.zerofill __DATA,__bss,_file,8,3        ; @file
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"r"

l_.str.1:                               ; @.str.1
	.asciz	"Could not open file: %s\n"

l_.str.2:                               ; @.str.2
	.asciz	"%s:%d: Unterminated string\n"

l_.str.3:                               ; @.str.3
	.asciz	"nop"

l_.str.4:                               ; @.str.4
	.asciz	"halt"

l_.str.5:                               ; @.str.5
	.asciz	"hlt"

l_.str.6:                               ; @.str.6
	.asciz	"ldr"

l_.str.7:                               ; @.str.7
	.asciz	"%s:%d: Expected register, got %s\n"

l_.str.8:                               ; @.str.8
	.asciz	"%s:%d: Number too large\n"

l_.str.9:                               ; @.str.9
	.asciz	"%s:%d: Expected register, number, or identifier, got %s\n"

l_.str.10:                              ; @.str.10
	.asciz	"%s:%d: Expected ], got %s\n"

l_.str.11:                              ; @.str.11
	.asciz	"str"

l_.str.12:                              ; @.str.12
	.asciz	"%s:%d: Expected register or number, got %s\n"

l_.str.13:                              ; @.str.13
	.asciz	"cmp"

l_.str.14:                              ; @.str.14
	.asciz	"cmpz"

l_.str.15:                              ; @.str.15
	.asciz	"b"

l_.str.16:                              ; @.str.16
	.asciz	"%s:%d: Expected register or identifier, got %s\n"

l_.str.17:                              ; @.str.17
	.asciz	"bne"

l_.str.18:                              ; @.str.18
	.asciz	"beq"

l_.str.19:                              ; @.str.19
	.asciz	"bgt"

l_.str.20:                              ; @.str.20
	.asciz	"blt"

l_.str.21:                              ; @.str.21
	.asciz	"bge"

l_.str.22:                              ; @.str.22
	.asciz	"ble"

l_.str.23:                              ; @.str.23
	.asciz	"bnz"

l_.str.24:                              ; @.str.24
	.asciz	"bz"

l_.str.25:                              ; @.str.25
	.asciz	"bl"

l_.str.26:                              ; @.str.26
	.asciz	"blne"

l_.str.27:                              ; @.str.27
	.asciz	"bleq"

l_.str.28:                              ; @.str.28
	.asciz	"blgt"

l_.str.29:                              ; @.str.29
	.asciz	"bllt"

l_.str.30:                              ; @.str.30
	.asciz	"blge"

l_.str.31:                              ; @.str.31
	.asciz	"blle"

l_.str.32:                              ; @.str.32
	.asciz	"blnz"

l_.str.33:                              ; @.str.33
	.asciz	"blz"

l_.str.34:                              ; @.str.34
	.asciz	"pshi"

l_.str.35:                              ; @.str.35
	.asciz	"ret"

l_.str.36:                              ; @.str.36
	.asciz	"pshx"

l_.str.37:                              ; @.str.37
	.asciz	"ppx"

l_.str.38:                              ; @.str.38
	.asciz	"pshy"

l_.str.39:                              ; @.str.39
	.asciz	"ppy"

l_.str.40:                              ; @.str.40
	.asciz	"svc"

l_.str.41:                              ; @.str.41
	.asciz	"psh"

l_.str.42:                              ; @.str.42
	.asciz	"pp"

l_.str.43:                              ; @.str.43
	.asciz	"add"

l_.str.44:                              ; @.str.44
	.asciz	"sub"

l_.str.45:                              ; @.str.45
	.asciz	"mul"

l_.str.46:                              ; @.str.46
	.asciz	"div"

l_.str.47:                              ; @.str.47
	.asciz	"mod"

l_.str.48:                              ; @.str.48
	.asciz	"and"

l_.str.49:                              ; @.str.49
	.asciz	"or"

l_.str.50:                              ; @.str.50
	.asciz	"xor"

l_.str.51:                              ; @.str.51
	.asciz	"shl"

l_.str.52:                              ; @.str.52
	.asciz	"shr"

l_.str.53:                              ; @.str.53
	.asciz	"not"

l_.str.54:                              ; @.str.54
	.asciz	"inc"

l_.str.55:                              ; @.str.55
	.asciz	"dec"

l_.str.56:                              ; @.str.56
	.asciz	"irq"

l_.str.57:                              ; @.str.57
	.asciz	"mov"

l_.str.58:                              ; @.str.58
	.asciz	"%s:%d: Expected identifier, got %s\n"

l_.str.59:                              ; @.str.59
	.asciz	"byte"

l_.str.60:                              ; @.str.60
	.asciz	"word"

l_.str.61:                              ; @.str.61
	.asciz	"dword"

l_.str.62:                              ; @.str.62
	.asciz	"qword"

l_.str.63:                              ; @.str.63
	.asciz	"%s:%d: Expected byte, word, dword, or qword, got %s\n"

l_.str.64:                              ; @.str.64
	.asciz	"%s:%d: Expected [, got %s\n"

l_.str.65:                              ; @.str.65
	.asciz	"%s:%d: Unknown instruction: %s\n"

l_.str.66:                              ; @.str.66
	.asciz	"asciz"

l_.str.67:                              ; @.str.67
	.asciz	"ascii"

l_.str.68:                              ; @.str.68
	.asciz	"%s:%d: Expected string, got %s\n"

l_.str.69:                              ; @.str.69
	.asciz	"%s:%d: Expected number, got %s\n"

l_.str.70:                              ; @.str.70
	.asciz	"float"

l_.str.71:                              ; @.str.71
	.asciz	"double"

l_.str.72:                              ; @.str.72
	.asciz	"offset"

l_.str.73:                              ; @.str.73
	.asciz	"%s:%d: Unknown directive: %s\n"

l_.str.74:                              ; @.str.74
	.asciz	"Unknown escape sequence: \\%c\n"

.zerofill __DATA,__bss,_src,8,3         ; @src
	.section	__DATA,__data
	.p2align	2, 0x0                          ; @line
_line:
	.long	1                               ; 0x1

	.section	__TEXT,__cstring,cstring_literals
l_.str.75:                              ; @.str.75
	.asciz	"xmm"

l_.str.76:                              ; @.str.76
	.asciz	"x"

l_.str.77:                              ; @.str.77
	.asciz	"y"

l_.str.78:                              ; @.str.78
	.asciz	"r0"

l_.str.79:                              ; @.str.79
	.asciz	"r1"

l_.str.80:                              ; @.str.80
	.asciz	"pc"

l_.str.81:                              ; @.str.81
	.asciz	"r27"

l_.str.82:                              ; @.str.82
	.asciz	"lr"

l_.str.83:                              ; @.str.83
	.asciz	"r28"

l_.str.84:                              ; @.str.84
	.asciz	"sp"

l_.str.85:                              ; @.str.85
	.asciz	"r29"

l_.str.86:                              ; @.str.86
	.asciz	"bp"

l_.str.87:                              ; @.str.87
	.asciz	"r30"

l_.str.88:                              ; @.str.88
	.asciz	"0x"

l_.str.89:                              ; @.str.89
	.asciz	"0b"

l_.str.90:                              ; @.str.90
	.asciz	"%d"

l_.str.91:                              ; @.str.91
	.asciz	"["

l_.str.92:                              ; @.str.92
	.asciz	"]"

l_.str.93:                              ; @.str.93
	.asciz	"Unknown instruction argument type %d in instruction %01x %03x\n"

.subsections_via_symbols
