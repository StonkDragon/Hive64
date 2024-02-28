	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 14, 2
	.globl	_run_compile                    ; -- Begin function run_compile
	.p2align	2
_run_compile:                           ; @run_compile
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
	sub	sp, sp, #64
	mov	x20, x2
	mov	x21, x1
	mov	x22, x0
	mov	x19, x8
Lloh0:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh1:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh2:
	ldr	x8, [x8]
	stur	x8, [x29, #-72]
	bl	_strlen
	add	x0, x0, #1
	bl	_malloc
	adrp	x8, _file@PAGE
	str	x0, [x8, _file@PAGEOFF]
	mov	x1, x22
	bl	_strcpy
Lloh3:
	adrp	x1, l_.str@PAGE
Lloh4:
	add	x1, x1, l_.str@PAGEOFF
	mov	x0, x22
	bl	_fopen
	cbz	x0, LBB0_14
; %bb.1:
	mov	x25, x0
	mov	x1, #0
	mov	w2, #2
	bl	_fseek
	mov	x0, x25
	bl	_ftell
	mov	x23, x0
	mov	x0, x25
	mov	x1, #0
	mov	w2, #0
	bl	_fseek
	mov	x26, sp
	add	x9, x23, #1
Lloh5:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh6:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	mov	x8, sp
	add	x9, x23, #16
	and	x9, x9, #0xfffffffffffffff0
	sub	x24, x8, x9
	mov	sp, x24
	mov	x0, x24
	mov	w1, #1
	mov	x2, x23
	mov	x3, x25
	bl	_fread
	strb	wzr, [x24, x23]
	mov	x0, x25
	bl	_fclose
	cbz	x23, LBB0_13
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
	cmp	x23, x12
	b.ls	LBB0_13
LBB0_5:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_11 Depth 2
	ldrb	w13, [x24, x12]
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
	b.ne	LBB0_15
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
	ldrb	w14, [x24, x13]
	cmp	w14, #10
	b.eq	LBB0_4
; %bb.10:                               ;   in Loop: Header=BB0_5 Depth=1
	cmp	x23, x13
	b.ls	LBB0_4
LBB0_11:                                ;   Parent Loop BB0_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	x11, x24, x13
	strb	w10, [x11]
	add	x13, x13, #1
	ldrb	w11, [x11, #1]
	cmp	w11, #10
	ccmp	x23, x13, #0, ne
	b.hi	LBB0_11
; %bb.12:                               ;   in Loop: Header=BB0_5 Depth=1
	mov	x11, x13
	b	LBB0_4
LBB0_13:
	sub	x8, x29, #96
	mov	x0, x24
	bl	_parse
	ldur	q0, [x29, #-96]
	stur	q0, [x29, #-128]
	ldur	x8, [x29, #-80]
	stur	x8, [x29, #-112]
	sub	x0, x29, #128
	mov	x8, x19
	mov	x1, x21
	mov	x2, x20
	bl	_compile
	b	LBB0_16
LBB0_14:
	str	x22, [sp, #-16]!
Lloh7:
	adrp	x0, l_.str.1@PAGE
Lloh8:
	add	x0, x0, l_.str.1@PAGEOFF
	bl	_printf
	add	sp, sp, #16
	stp	xzr, xzr, [x19, #8]
	str	xzr, [x19]
	ldur	x8, [x29, #-72]
Lloh9:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh10:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh11:
	ldr	x9, [x9]
	cmp	x9, x8
	b.eq	LBB0_18
	b	LBB0_19
LBB0_15:
                                        ; kill: def $w11 killed $w11 killed $x11 def $x11
	stp	x22, x11, [sp, #-16]!
Lloh12:
	adrp	x0, l_.str.2@PAGE
Lloh13:
	add	x0, x0, l_.str.2@PAGEOFF
	bl	_printf
	add	sp, sp, #16
	stp	xzr, xzr, [x19, #8]
	str	xzr, [x19]
LBB0_16:
	ldur	x8, [x29, #-72]
Lloh14:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh15:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh16:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB0_19
; %bb.17:
	mov	sp, x26
LBB0_18:
	sub	sp, x29, #64
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #16]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp], #80             ; 16-byte Folded Reload
	ret
LBB0_19:
	bl	___stack_chk_fail
	.loh AdrpAdd	Lloh3, Lloh4
	.loh AdrpLdrGotLdr	Lloh0, Lloh1, Lloh2
	.loh AdrpLdrGot	Lloh5, Lloh6
	.loh AdrpLdrGotLdr	Lloh9, Lloh10, Lloh11
	.loh AdrpAdd	Lloh7, Lloh8
	.loh AdrpAdd	Lloh12, Lloh13
	.loh AdrpLdrGotLdr	Lloh14, Lloh15, Lloh16
	.cfi_endproc
                                        ; -- End function
	.globl	_parse                          ; -- Begin function parse
	.p2align	2
_parse:                                 ; @parse
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #128
	.cfi_def_cfa_offset 128
	stp	x24, x23, [sp, #64]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #80]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #96]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #112]            ; 16-byte Folded Spill
	add	x29, sp, #112
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	mov	x19, x8
Lloh17:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh18:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh19:
	ldr	x8, [x8]
	str	x8, [sp, #56]
	stp	xzr, xzr, [x19]
	str	xzr, [x19, #16]
	adrp	x22, _src@PAGE
	str	x0, [x22, _src@PAGEOFF]
	ldrb	w8, [x0]
	cbz	w8, LBB1_7
; %bb.1:
	mov	x23, #0
	mov	x21, #0
	mov	x20, #0
	mov	w24, #256
	b	LBB1_3
LBB1_2:                                 ;   in Loop: Header=BB1_3 Depth=1
	add	x21, x21, #1
	str	x21, [x19, #8]
	add	x8, x20, x23
	ldp	q0, q1, [sp]
	stp	q0, q1, [x8]
	ldr	x8, [x22, _src@PAGEOFF]
	ldrb	w8, [x8]
	add	x23, x23, #32
	cbz	w8, LBB1_8
LBB1_3:                                 ; =>This Inner Loop Header: Depth=1
	mov	x8, sp
	bl	_nextToken
	ldr	w8, [sp, #8]
	cbz	w8, LBB1_8
; %bb.4:                                ;   in Loop: Header=BB1_3 Depth=1
	ldr	x8, [x19, #16]
	cmp	x21, x8
	b.lo	LBB1_2
; %bb.5:                                ;   in Loop: Header=BB1_3 Depth=1
	lsl	x9, x8, #1
	cmp	x8, #0
	csel	x8, x24, x9, eq
	str	x8, [x19, #16]
	lsl	x1, x8, #5
	mov	x0, x20
	bl	_realloc
	mov	x20, x0
	str	x0, [x19]
	cbnz	x0, LBB1_2
; %bb.6:
	bl	_parse.cold.2
LBB1_7:
	mov	x20, #0
	mov	x21, #0
LBB1_8:
	ldr	x8, [x19, #16]
	cmp	x21, x8
	b.lo	LBB1_10
; %bb.9:
	lsl	x9, x8, #1
	mov	w10, #256
	cmp	x8, #0
	csel	x8, x10, x9, eq
	str	x8, [x19, #16]
	lsl	x1, x8, #5
	mov	x0, x20
	bl	_realloc
	mov	x20, x0
	str	x0, [x19]
	cbz	x0, LBB1_12
LBB1_10:
	add	x8, x21, #1
	str	x8, [x19, #8]
	add	x8, x20, x21, lsl #5
	stp	xzr, xzr, [sp, #32]
	str	wzr, [sp, #48]
	str	xzr, [x8]
	str	wzr, [x8, #8]
	ldr	q0, [sp, #32]
	ldr	w9, [sp, #48]
	str	w9, [x8, #28]
	stur	q0, [x8, #12]
	ldr	x8, [sp, #56]
Lloh20:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh21:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh22:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB1_13
; %bb.11:
	ldp	x29, x30, [sp, #112]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #96]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #80]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #64]             ; 16-byte Folded Reload
	add	sp, sp, #128
	ret
LBB1_12:
	bl	_parse.cold.1
LBB1_13:
	bl	___stack_chk_fail
	.loh AdrpLdrGotLdr	Lloh17, Lloh18, Lloh19
	.loh AdrpLdrGotLdr	Lloh20, Lloh21, Lloh22
	.cfi_endproc
                                        ; -- End function
	.globl	_compile                        ; -- Begin function compile
	.p2align	2
_compile:                               ; @compile
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #224
	.cfi_def_cfa_offset 224
	stp	x28, x27, [sp, #128]            ; 16-byte Folded Spill
	stp	x26, x25, [sp, #144]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #160]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #176]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #192]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #208]            ; 16-byte Folded Spill
	add	x29, sp, #208
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
	str	x2, [sp, #48]                   ; 8-byte Folded Spill
	mov	x27, x1
	str	x8, [sp, #32]                   ; 8-byte Folded Spill
	ldr	x8, [x0, #8]
	str	x1, [sp, #72]                   ; 8-byte Folded Spill
	cbz	x8, LBB2_895
; %bb.1:
	mov	x25, x0
	stp	xzr, xzr, [sp, #56]             ; 16-byte Folded Spill
	mov	x22, #0
	str	xzr, [sp, #40]                  ; 8-byte Folded Spill
	mov	x28, #0
	str	xzr, [sp, #24]                  ; 8-byte Folded Spill
	mov	x24, #0
Lloh23:
	adrp	x21, lJTI2_1@PAGE
Lloh24:
	add	x21, x21, lJTI2_1@PAGEOFF
Lloh25:
	adrp	x23, lJTI2_0@PAGE
Lloh26:
	add	x23, x23, lJTI2_0@PAGEOFF
	b	LBB2_4
LBB2_2:                                 ;   in Loop: Header=BB2_4 Depth=1
	mov	x19, x24
LBB2_3:                                 ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x19, #1
	ldr	x8, [x25, #8]
	cmp	x24, x8
	b.hs	LBB2_896
LBB2_4:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB2_9 Depth 2
                                        ;     Child Loop BB2_250 Depth 2
                                        ;     Child Loop BB2_13 Depth 2
                                        ;     Child Loop BB2_307 Depth 2
                                        ;       Child Loop BB2_321 Depth 3
                                        ;       Child Loop BB2_315 Depth 3
                                        ;       Child Loop BB2_310 Depth 3
                                        ;     Child Loop BB2_339 Depth 2
                                        ;     Child Loop BB2_331 Depth 2
                                        ;     Child Loop BB2_285 Depth 2
                                        ;     Child Loop BB2_277 Depth 2
                                        ;     Child Loop BB2_271 Depth 2
                                        ;     Child Loop BB2_297 Depth 2
                                        ;     Child Loop BB2_262 Depth 2
                                        ;     Child Loop BB2_228 Depth 2
                                        ;     Child Loop BB2_218 Depth 2
                                        ;     Child Loop BB2_50 Depth 2
                                        ;     Child Loop BB2_66 Depth 2
                                        ;     Child Loop BB2_212 Depth 2
                                        ;     Child Loop BB2_191 Depth 2
                                        ;     Child Loop BB2_196 Depth 2
                                        ;     Child Loop BB2_201 Depth 2
                                        ;     Child Loop BB2_206 Depth 2
	ldr	x26, [x25]
	add	x8, x26, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #7
	b.eq	LBB2_26
; %bb.5:                                ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #3
	b.eq	LBB2_10
; %bb.6:                                ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #1
	b.ne	LBB2_2
; %bb.7:                                ;   in Loop: Header=BB2_4 Depth=1
	mov	x21, x28
	ldr	x27, [x8]
	mov	x0, x27
	bl	_strlen
	mov	x19, x0
	add	x0, x0, #1
	bl	_malloc
	mov	x28, x0
	cbz	x19, LBB2_71
; %bb.8:                                ;   in Loop: Header=BB2_4 Depth=1
	mov	x19, #0
LBB2_9:                                 ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrsb	w0, [x27, x19]
	bl	___tolower
	strb	w0, [x28, x19]
	add	x19, x19, #1
	mov	x0, x27
	bl	_strlen
	cmp	x0, x19
	b.hi	LBB2_9
	b	LBB2_72
LBB2_10:                                ;   in Loop: Header=BB2_4 Depth=1
	mov	x20, x28
	ldr	x27, [x8]
	mov	x0, x27
	bl	_strlen
	add	x0, x0, #1
	bl	_malloc
	mov	x28, x0
	mov	x8, x0
	b	LBB2_13
LBB2_11:                                ;   in Loop: Header=BB2_13 Depth=2
	cbz	w9, LBB2_43
LBB2_12:                                ;   in Loop: Header=BB2_13 Depth=2
	strb	w9, [x8], #1
	add	x27, x27, #1
LBB2_13:                                ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w9, [x27]
	cmp	w9, #92
	b.ne	LBB2_11
; %bb.14:                               ;   in Loop: Header=BB2_13 Depth=2
	ldrsb	w10, [x27, #1]!
	cmp	w10, #91
	b.le	LBB2_18
; %bb.15:                               ;   in Loop: Header=BB2_13 Depth=2
	sub	w11, w10, #92
	cmp	w11, #24
	b.hi	LBB2_220
; %bb.16:                               ;   in Loop: Header=BB2_13 Depth=2
	mov	w9, #10
	adr	x12, LBB2_12
	ldrh	w13, [x23, x11, lsl  #1]
	add	x12, x12, x13, lsl #2
	br	x12
LBB2_17:                                ;   in Loop: Header=BB2_13 Depth=2
	mov	w9, #92
	b	LBB2_12
LBB2_18:                                ;   in Loop: Header=BB2_13 Depth=2
	cmp	w10, #34
	b.eq	LBB2_25
; %bb.19:                               ;   in Loop: Header=BB2_13 Depth=2
	cmp	w10, #39
	b.eq	LBB2_24
; %bb.20:                               ;   in Loop: Header=BB2_13 Depth=2
	cmp	w10, #48
	b.ne	LBB2_220
; %bb.21:                               ;   in Loop: Header=BB2_13 Depth=2
	mov	w9, #0
	b	LBB2_12
LBB2_22:                                ;   in Loop: Header=BB2_13 Depth=2
	mov	w9, #9
	b	LBB2_12
LBB2_23:                                ;   in Loop: Header=BB2_13 Depth=2
	mov	w9, #13
	b	LBB2_12
LBB2_24:                                ;   in Loop: Header=BB2_13 Depth=2
	mov	w9, #39
	b	LBB2_12
LBB2_25:                                ;   in Loop: Header=BB2_13 Depth=2
	mov	w9, #34
	b	LBB2_12
LBB2_26:                                ;   in Loop: Header=BB2_4 Depth=1
	mov	x23, x28
	ldr	x28, [x8]
	mov	x0, x28
Lloh27:
	adrp	x1, l_.str.140@PAGE
Lloh28:
	add	x1, x1, l_.str.140@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_46
; %bb.27:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh29:
	adrp	x1, l_.str.141@PAGE
Lloh30:
	add	x1, x1, l_.str.141@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_46
; %bb.28:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh31:
	adrp	x1, l_.str.144@PAGE
Lloh32:
	add	x1, x1, l_.str.144@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_215
; %bb.29:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh33:
	adrp	x1, l_.str.145@PAGE
Lloh34:
	add	x1, x1, l_.str.145@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_225
; %bb.30:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh35:
	adrp	x1, l_.str.146@PAGE
Lloh36:
	add	x1, x1, l_.str.146@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_259
; %bb.31:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh37:
	adrp	x1, l_.str.147@PAGE
Lloh38:
	add	x1, x1, l_.str.147@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_266
; %bb.32:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh39:
	adrp	x1, l_.str.149@PAGE
Lloh40:
	add	x1, x1, l_.str.149@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_274
; %bb.33:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh41:
	adrp	x1, l_.str.151@PAGE
Lloh42:
	add	x1, x1, l_.str.151@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_282
; %bb.34:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh43:
	adrp	x1, l_.str.152@PAGE
Lloh44:
	add	x1, x1, l_.str.152@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_289
; %bb.35:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh45:
	adrp	x1, l_.str.153@PAGE
Lloh46:
	add	x1, x1, l_.str.153@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_302
; %bb.36:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh47:
	adrp	x1, l_.str.154@PAGE
Lloh48:
	add	x1, x1, l_.str.154@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_38
; %bb.37:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh49:
	adrp	x1, l_.str.155@PAGE
Lloh50:
	add	x1, x1, l_.str.155@PAGEOFF
	bl	_strcmp
	cbnz	w0, LBB2_942
LBB2_38:                                ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #1
	add	x8, x26, x19, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #1
	b.ne	LBB2_935
; %bb.39:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x9, [sp, #24]                   ; 8-byte Folded Reload
	cmp	x23, x9
	b.lo	LBB2_42
; %bb.40:                               ;   in Loop: Header=BB2_4 Depth=1
	lsl	x8, x9, #1
	cmp	x9, #0
	mov	w9, #256
	csel	x20, x9, x8, eq
	lsl	x1, x20, #3
	ldr	x0, [sp, #40]                   ; 8-byte Folded Reload
	bl	_realloc
	str	x0, [sp, #40]                   ; 8-byte Folded Spill
	cbz	x0, LBB2_958
; %bb.41:                               ;   in Loop: Header=BB2_4 Depth=1
	str	x20, [sp, #24]                  ; 8-byte Folded Spill
	ldr	x26, [x25]
LBB2_42:                                ;   in Loop: Header=BB2_4 Depth=1
	lsl	x8, x19, #5
	ldr	x8, [x26, x8]
	ldr	x9, [sp, #40]                   ; 8-byte Folded Reload
	str	x8, [x9, x23, lsl  #3]
	add	x28, x23, #1
	b	LBB2_325
LBB2_43:                                ;   in Loop: Header=BB2_4 Depth=1
	strb	wzr, [x8]
LBB2_44:                                ;   in Loop: Header=BB2_4 Depth=1
	ldr	x27, [sp, #72]                  ; 8-byte Folded Reload
	ldp	x8, x9, [x27, #8]
	cmp	x8, x9
	b.hs	LBB2_68
; %bb.45:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x27]
	b	LBB2_70
LBB2_46:                                ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #1
	add	x8, x26, x19, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #6
	b.ne	LBB2_931
; %bb.47:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x27, [x8]
	mov	x0, x27
	bl	_strlen
	add	x0, x0, #1
	bl	_malloc
	mov	x28, x0
	mov	x8, x0
	b	LBB2_50
LBB2_48:                                ;   in Loop: Header=BB2_50 Depth=2
	cbz	w9, LBB2_63
LBB2_49:                                ;   in Loop: Header=BB2_50 Depth=2
	strb	w9, [x8], #1
	add	x27, x27, #1
LBB2_50:                                ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w9, [x27]
	cmp	w9, #92
	b.ne	LBB2_48
; %bb.51:                               ;   in Loop: Header=BB2_50 Depth=2
	ldrsb	w10, [x27, #1]!
	cmp	w10, #91
	b.le	LBB2_55
; %bb.52:                               ;   in Loop: Header=BB2_50 Depth=2
	sub	w11, w10, #92
	cmp	w11, #24
	b.hi	LBB2_258
; %bb.53:                               ;   in Loop: Header=BB2_50 Depth=2
	mov	w9, #10
	adr	x12, LBB2_49
	ldrh	w13, [x21, x11, lsl  #1]
	add	x12, x12, x13, lsl #2
	br	x12
LBB2_54:                                ;   in Loop: Header=BB2_50 Depth=2
	mov	w9, #92
	b	LBB2_49
LBB2_55:                                ;   in Loop: Header=BB2_50 Depth=2
	cmp	w10, #34
	b.eq	LBB2_62
; %bb.56:                               ;   in Loop: Header=BB2_50 Depth=2
	cmp	w10, #39
	b.eq	LBB2_61
; %bb.57:                               ;   in Loop: Header=BB2_50 Depth=2
	cmp	w10, #48
	b.ne	LBB2_258
; %bb.58:                               ;   in Loop: Header=BB2_50 Depth=2
	mov	w9, #0
	b	LBB2_49
LBB2_59:                                ;   in Loop: Header=BB2_50 Depth=2
	mov	w9, #9
	b	LBB2_49
LBB2_60:                                ;   in Loop: Header=BB2_50 Depth=2
	mov	w9, #13
	b	LBB2_49
LBB2_61:                                ;   in Loop: Header=BB2_50 Depth=2
	mov	w9, #39
	b	LBB2_49
LBB2_62:                                ;   in Loop: Header=BB2_50 Depth=2
	mov	w9, #34
	b	LBB2_49
LBB2_63:                                ;   in Loop: Header=BB2_4 Depth=1
	strb	wzr, [x8]
LBB2_64:                                ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
	bl	_strlen
	mov	x27, x0
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	add	x26, x0, x8
	cmp	x26, x22
	b.ls	LBB2_186
; %bb.65:                               ;   in Loop: Header=BB2_4 Depth=1
	cmp	x22, #0
	mov	w8, #256
	csel	x8, x8, x22, eq
LBB2_66:                                ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x22, x8
	lsl	x8, x8, #1
	cmp	x26, x22
	b.hi	LBB2_66
; %bb.67:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [sp, #64]                   ; 8-byte Folded Reload
	mov	x1, x22
	bl	_realloc
	cbnz	x0, LBB2_187
	b	LBB2_943
LBB2_68:                                ;   in Loop: Header=BB2_4 Depth=1
	lsl	x8, x9, #1
	cmp	x9, #0
	mov	w9, #256
	csel	x8, x9, x8, eq
	str	x8, [x27, #16]
	ldr	x0, [x27]
	add	x8, x8, x8, lsl #1
	lsl	x1, x8, #3
	bl	_realloc
	str	x0, [x27]
	cbz	x0, LBB2_938
; %bb.69:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x27, #8]
LBB2_70:                                ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x8, #1
	str	x9, [x27, #8]
	mov	w9, #24
	madd	x8, x8, x9, x0
	ldr	x9, [sp, #56]                   ; 8-byte Folded Reload
	stp	x28, x9, [x8]
	str	xzr, [x8, #16]
	mov	x19, x24
	mov	x28, x20
	b	LBB2_3
LBB2_71:                                ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, #0
LBB2_72:                                ;   in Loop: Header=BB2_4 Depth=1
	strb	wzr, [x28, x0]
	str	wzr, [sp, #104]
	mov	x0, x28
Lloh51:
	adrp	x1, l_.str.13@PAGE
Lloh52:
	add	x1, x1, l_.str.13@PAGEOFF
	bl	_strcmp
	ldr	x27, [sp, #72]                  ; 8-byte Folded Reload
	cbz	w0, LBB2_185
; %bb.73:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh53:
	adrp	x1, l_.str.14@PAGE
Lloh54:
	add	x1, x1, l_.str.14@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_209
; %bb.74:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh55:
	adrp	x1, l_.str.15@PAGE
Lloh56:
	add	x1, x1, l_.str.15@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_232
; %bb.75:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh57:
	adrp	x1, l_.str.16@PAGE
Lloh58:
	add	x1, x1, l_.str.16@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_230
; %bb.76:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh59:
	adrp	x1, l_.str.17@PAGE
Lloh60:
	add	x1, x1, l_.str.17@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_224
; %bb.77:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh61:
	adrp	x1, l_.str.18@PAGE
Lloh62:
	add	x1, x1, l_.str.18@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_224
; %bb.78:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh63:
	adrp	x1, l_.str.19@PAGE
Lloh64:
	add	x1, x1, l_.str.19@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_281
; %bb.79:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh65:
	adrp	x1, l_.str.20@PAGE
Lloh66:
	add	x1, x1, l_.str.20@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_273
; %bb.80:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh67:
	adrp	x1, l_.str.21@PAGE
Lloh68:
	add	x1, x1, l_.str.21@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_273
; %bb.81:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh69:
	adrp	x1, l_.str.22@PAGE
Lloh70:
	add	x1, x1, l_.str.22@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_326
; %bb.82:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh71:
	adrp	x1, l_.str.23@PAGE
Lloh72:
	add	x1, x1, l_.str.23@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_301
; %bb.83:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh73:
	adrp	x1, l_.str.24@PAGE
Lloh74:
	add	x1, x1, l_.str.24@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_301
; %bb.84:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh75:
	adrp	x1, l_.str.25@PAGE
Lloh76:
	add	x1, x1, l_.str.25@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_335
; %bb.85:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh77:
	adrp	x1, l_.str.26@PAGE
Lloh78:
	add	x1, x1, l_.str.26@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_335
; %bb.86:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh79:
	adrp	x1, l_.str.27@PAGE
Lloh80:
	add	x1, x1, l_.str.27@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_336
; %bb.87:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh81:
	adrp	x1, l_.str.28@PAGE
Lloh82:
	add	x1, x1, l_.str.28@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_336
; %bb.88:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh83:
	adrp	x1, l_.str.29@PAGE
Lloh84:
	add	x1, x1, l_.str.29@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_343
; %bb.89:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh85:
	adrp	x1, l_.str.30@PAGE
Lloh86:
	add	x1, x1, l_.str.30@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_342
; %bb.90:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh87:
	adrp	x1, l_.str.31@PAGE
Lloh88:
	add	x1, x1, l_.str.31@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_342
; %bb.91:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh89:
	adrp	x1, l_.str.32@PAGE
Lloh90:
	add	x1, x1, l_.str.32@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_345
; %bb.92:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh91:
	adrp	x1, l_.str.33@PAGE
Lloh92:
	add	x1, x1, l_.str.33@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_344
; %bb.93:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh93:
	adrp	x1, l_.str.34@PAGE
Lloh94:
	add	x1, x1, l_.str.34@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_344
; %bb.94:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh95:
	adrp	x1, l_.str.35@PAGE
Lloh96:
	add	x1, x1, l_.str.35@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_346
; %bb.95:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh97:
	adrp	x1, l_.str.36@PAGE
Lloh98:
	add	x1, x1, l_.str.36@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_346
; %bb.96:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x26, x23
	mov	x0, x28
Lloh99:
	adrp	x1, l_.str.37@PAGE
Lloh100:
	add	x1, x1, l_.str.37@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_347
; %bb.97:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh101:
	adrp	x1, l_.str.39@PAGE
Lloh102:
	add	x1, x1, l_.str.39@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_351
; %bb.98:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh103:
	adrp	x1, l_.str.40@PAGE
Lloh104:
	add	x1, x1, l_.str.40@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_349
; %bb.99:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh105:
	adrp	x1, l_.str.41@PAGE
Lloh106:
	add	x1, x1, l_.str.41@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_349
; %bb.100:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh107:
	adrp	x1, l_.str.42@PAGE
Lloh108:
	add	x1, x1, l_.str.42@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_358
; %bb.101:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh109:
	adrp	x1, l_.str.43@PAGE
Lloh110:
	add	x1, x1, l_.str.43@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_356
; %bb.102:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh111:
	adrp	x1, l_.str.44@PAGE
Lloh112:
	add	x1, x1, l_.str.44@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_356
; %bb.103:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh113:
	adrp	x1, l_.str.45@PAGE
Lloh114:
	add	x1, x1, l_.str.45@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_362
; %bb.104:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh115:
	adrp	x1, l_.str.46@PAGE
Lloh116:
	add	x1, x1, l_.str.46@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_360
; %bb.105:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh117:
	adrp	x1, l_.str.47@PAGE
Lloh118:
	add	x1, x1, l_.str.47@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_360
; %bb.106:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh119:
	adrp	x1, l_.str.48@PAGE
Lloh120:
	add	x1, x1, l_.str.48@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_364
; %bb.107:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh121:
	adrp	x1, l_.str.49@PAGE
Lloh122:
	add	x1, x1, l_.str.49@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_364
; %bb.108:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh123:
	adrp	x1, l_.str.50@PAGE
Lloh124:
	add	x1, x1, l_.str.50@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_366
; %bb.109:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh125:
	adrp	x1, l_.str.51@PAGE
Lloh126:
	add	x1, x1, l_.str.51@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_366
; %bb.110:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh127:
	adrp	x1, l_.str.52@PAGE
Lloh128:
	add	x1, x1, l_.str.52@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_370
; %bb.111:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh129:
	adrp	x1, l_.str.53@PAGE
Lloh130:
	add	x1, x1, l_.str.53@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_368
; %bb.112:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh131:
	adrp	x1, l_.str.54@PAGE
Lloh132:
	add	x1, x1, l_.str.54@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_368
; %bb.113:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh133:
	adrp	x1, l_.str.55@PAGE
Lloh134:
	add	x1, x1, l_.str.55@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_374
; %bb.114:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh135:
	adrp	x1, l_.str.56@PAGE
Lloh136:
	add	x1, x1, l_.str.56@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_372
; %bb.115:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh137:
	adrp	x1, l_.str.57@PAGE
Lloh138:
	add	x1, x1, l_.str.57@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_372
; %bb.116:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh139:
	adrp	x1, l_.str.58@PAGE
Lloh140:
	add	x1, x1, l_.str.58@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_376
; %bb.117:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh141:
	adrp	x1, l_.str.59@PAGE
Lloh142:
	add	x1, x1, l_.str.59@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_376
; %bb.118:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh143:
	adrp	x1, l_.str.60@PAGE
Lloh144:
	add	x1, x1, l_.str.60@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_378
; %bb.119:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh145:
	adrp	x1, l_.str.61@PAGE
Lloh146:
	add	x1, x1, l_.str.61@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_379
; %bb.120:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh147:
	adrp	x1, l_.str.66@PAGE
Lloh148:
	add	x1, x1, l_.str.66@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_390
; %bb.121:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh149:
	adrp	x1, l_.str.67@PAGE
Lloh150:
	add	x1, x1, l_.str.67@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_404
; %bb.122:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh151:
	adrp	x1, l_.str.68@PAGE
Lloh152:
	add	x1, x1, l_.str.68@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_418
; %bb.123:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh153:
	adrp	x1, l_.str.69@PAGE
Lloh154:
	add	x1, x1, l_.str.69@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_433
; %bb.124:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh155:
	adrp	x1, l_.str.70@PAGE
Lloh156:
	add	x1, x1, l_.str.70@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_448
; %bb.125:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh157:
	adrp	x1, l_.str.71@PAGE
Lloh158:
	add	x1, x1, l_.str.71@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_464
; %bb.126:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh159:
	adrp	x1, l_.str.72@PAGE
Lloh160:
	add	x1, x1, l_.str.72@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_480
; %bb.127:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh161:
	adrp	x1, l_.str.73@PAGE
Lloh162:
	add	x1, x1, l_.str.73@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_496
; %bb.128:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh163:
	adrp	x1, l_.str.74@PAGE
Lloh164:
	add	x1, x1, l_.str.74@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_512
; %bb.129:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh165:
	adrp	x1, l_.str.75@PAGE
Lloh166:
	add	x1, x1, l_.str.75@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_528
; %bb.130:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh167:
	adrp	x1, l_.str.76@PAGE
Lloh168:
	add	x1, x1, l_.str.76@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_552
; %bb.131:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh169:
	adrp	x1, l_.str.77@PAGE
Lloh170:
	add	x1, x1, l_.str.77@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_544
; %bb.132:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh171:
	adrp	x1, l_.str.78@PAGE
Lloh172:
	add	x1, x1, l_.str.78@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_544
; %bb.133:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh173:
	adrp	x1, l_.str.82@PAGE
Lloh174:
	add	x1, x1, l_.str.82@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_575
; %bb.134:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh175:
	adrp	x1, l_.str.83@PAGE
Lloh176:
	add	x1, x1, l_.str.83@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_575
; %bb.135:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh177:
	adrp	x1, l_.str.84@PAGE
Lloh178:
	add	x1, x1, l_.str.84@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_602
; %bb.136:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh179:
	adrp	x1, l_.str.85@PAGE
Lloh180:
	add	x1, x1, l_.str.85@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_612
; %bb.137:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh181:
	adrp	x1, l_.str.86@PAGE
Lloh182:
	add	x1, x1, l_.str.86@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_628
; %bb.138:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh183:
	adrp	x1, l_.str.87@PAGE
Lloh184:
	add	x1, x1, l_.str.87@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_640
; %bb.139:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh185:
	adrp	x1, l_.str.88@PAGE
Lloh186:
	add	x1, x1, l_.str.88@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_652
; %bb.140:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh187:
	adrp	x1, l_.str.89@PAGE
Lloh188:
	add	x1, x1, l_.str.89@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_675
; %bb.141:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh189:
	adrp	x1, l_.str.90@PAGE
Lloh190:
	add	x1, x1, l_.str.90@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_664
; %bb.142:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh191:
	adrp	x1, l_.str.91@PAGE
Lloh192:
	add	x1, x1, l_.str.91@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_664
; %bb.143:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh193:
	adrp	x1, l_.str.92@PAGE
Lloh194:
	add	x1, x1, l_.str.92@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_689
; %bb.144:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh195:
	adrp	x1, l_.str.93@PAGE
Lloh196:
	add	x1, x1, l_.str.93@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_689
; %bb.145:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh197:
	adrp	x1, l_.str.94@PAGE
Lloh198:
	add	x1, x1, l_.str.94@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_721
; %bb.146:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh199:
	adrp	x1, l_.str.95@PAGE
Lloh200:
	add	x1, x1, l_.str.95@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_689
; %bb.147:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh201:
	adrp	x1, l_.str.96@PAGE
Lloh202:
	add	x1, x1, l_.str.96@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_735
; %bb.148:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh203:
	adrp	x1, l_.str.97@PAGE
Lloh204:
	add	x1, x1, l_.str.97@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_689
; %bb.149:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh205:
	adrp	x1, l_.str.98@PAGE
Lloh206:
	add	x1, x1, l_.str.98@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_749
; %bb.150:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh207:
	adrp	x1, l_.str.99@PAGE
Lloh208:
	add	x1, x1, l_.str.99@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_689
; %bb.151:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh209:
	adrp	x1, l_.str.100@PAGE
Lloh210:
	add	x1, x1, l_.str.100@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_765
; %bb.152:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh211:
	adrp	x1, l_.str.102@PAGE
Lloh212:
	add	x1, x1, l_.str.102@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_773
; %bb.153:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh213:
	adrp	x1, l_.str.103@PAGE
Lloh214:
	add	x1, x1, l_.str.103@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_778
; %bb.154:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh215:
	adrp	x1, l_.str.104@PAGE
Lloh216:
	add	x1, x1, l_.str.104@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_781
; %bb.155:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh217:
	adrp	x1, l_.str.108@PAGE
Lloh218:
	add	x1, x1, l_.str.108@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_791
; %bb.156:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh219:
	adrp	x1, l_.str.109@PAGE
Lloh220:
	add	x1, x1, l_.str.109@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_800
; %bb.157:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh221:
	adrp	x1, l_.str.110@PAGE
Lloh222:
	add	x1, x1, l_.str.110@PAGEOFF
	bl	_strcmp
	mov	x27, x0
	cbz	w0, LBB2_804
; %bb.158:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh223:
	adrp	x1, l_.str.111@PAGE
Lloh224:
	add	x1, x1, l_.str.111@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_804
; %bb.159:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh225:
	adrp	x1, l_.str.112@PAGE
Lloh226:
	add	x1, x1, l_.str.112@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_808
; %bb.160:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh227:
	adrp	x1, l_.str.113@PAGE
Lloh228:
	add	x1, x1, l_.str.113@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_814
; %bb.161:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh229:
	adrp	x1, l_.str.114@PAGE
Lloh230:
	add	x1, x1, l_.str.114@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_820
; %bb.162:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh231:
	adrp	x1, l_.str.115@PAGE
Lloh232:
	add	x1, x1, l_.str.115@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_820
; %bb.163:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh233:
	adrp	x1, l_.str.118@PAGE
Lloh234:
	add	x1, x1, l_.str.118@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_832
; %bb.164:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh235:
	adrp	x1, l_.str.119@PAGE
Lloh236:
	add	x1, x1, l_.str.119@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_832
; %bb.165:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh237:
	adrp	x1, l_.str.120@PAGE
Lloh238:
	add	x1, x1, l_.str.120@PAGEOFF
	bl	_strcmp
	mov	x19, x0
	cbz	w0, LBB2_844
; %bb.166:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh239:
	adrp	x1, l_.str.121@PAGE
Lloh240:
	add	x1, x1, l_.str.121@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_844
; %bb.167:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh241:
	adrp	x1, l_.str.122@PAGE
Lloh242:
	add	x1, x1, l_.str.122@PAGEOFF
	bl	_strcmp
	mov	x19, x0
	cbz	w0, LBB2_850
; %bb.168:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh243:
	adrp	x1, l_.str.123@PAGE
Lloh244:
	add	x1, x1, l_.str.123@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_850
; %bb.169:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh245:
	adrp	x1, l_.str.124@PAGE
Lloh246:
	add	x1, x1, l_.str.124@PAGEOFF
	bl	_strcmp
	mov	x19, x0
	cbz	w0, LBB2_856
; %bb.170:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh247:
	adrp	x1, l_.str.125@PAGE
Lloh248:
	add	x1, x1, l_.str.125@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_856
; %bb.171:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh249:
	adrp	x1, l_.str.126@PAGE
Lloh250:
	add	x1, x1, l_.str.126@PAGEOFF
	bl	_strcmp
	mov	x19, x0
	cbz	w0, LBB2_862
; %bb.172:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh251:
	adrp	x1, l_.str.127@PAGE
Lloh252:
	add	x1, x1, l_.str.127@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_862
; %bb.173:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh253:
	adrp	x1, l_.str.128@PAGE
Lloh254:
	add	x1, x1, l_.str.128@PAGEOFF
	bl	_strcmp
	mov	x19, x0
	cbz	w0, LBB2_868
; %bb.174:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh255:
	adrp	x1, l_.str.129@PAGE
Lloh256:
	add	x1, x1, l_.str.129@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_868
; %bb.175:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh257:
	adrp	x1, l_.str.130@PAGE
Lloh258:
	add	x1, x1, l_.str.130@PAGEOFF
	bl	_strcmp
	mov	x27, x0
	cbz	w0, LBB2_876
; %bb.176:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh259:
	adrp	x1, l_.str.131@PAGE
Lloh260:
	add	x1, x1, l_.str.131@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_876
; %bb.177:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh261:
	adrp	x1, l_.str.132@PAGE
Lloh262:
	add	x1, x1, l_.str.132@PAGEOFF
	bl	_strcmp
	mov	x27, x0
	cbz	w0, LBB2_880
; %bb.178:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh263:
	adrp	x1, l_.str.133@PAGE
Lloh264:
	add	x1, x1, l_.str.133@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_880
; %bb.179:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh265:
	adrp	x1, l_.str.134@PAGE
Lloh266:
	add	x1, x1, l_.str.134@PAGEOFF
	bl	_strcmp
	mov	x27, x0
	cbz	w0, LBB2_181
; %bb.180:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
Lloh267:
	adrp	x1, l_.str.135@PAGE
Lloh268:
	add	x1, x1, l_.str.135@PAGEOFF
	bl	_strcmp
	cbnz	w0, LBB2_355
LBB2_181:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.182:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.183:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #3
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.184:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x28, x0
	ldr	x0, [x8]
	bl	_parse_reg
	cmp	w27, #0
	mov	w8, #3840
	mov	w9, #3584
	b	LBB2_884
LBB2_185:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #33
	str	w8, [sp, #104]
	b	LBB2_232
LBB2_186:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [sp, #64]                   ; 8-byte Folded Reload
LBB2_187:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x21, x0
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	add	x0, x0, x8
	mov	x1, x28
	mov	x2, x27
	bl	_memcpy
	ldr	x8, [x25]
	lsl	x9, x24, #5
	ldr	x0, [x8, x9]
Lloh269:
	adrp	x1, l_.str.140@PAGE
Lloh270:
	add	x1, x1, l_.str.140@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB2_210
; %bb.188:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x27, [sp, #72]                  ; 8-byte Folded Reload
	mov	x0, x21
	mov	x28, x23
Lloh271:
	adrp	x23, lJTI2_0@PAGE
Lloh272:
	add	x23, x23, lJTI2_0@PAGEOFF
	tst	x26, #0x3
	b.eq	LBB2_223
LBB2_189:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x21, x26, #1
	cmp	x21, x22
	b.ls	LBB2_193
; %bb.190:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	x22, #0
	mov	w8, #256
	csel	x8, x8, x22, eq
LBB2_191:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x22, x8
	lsl	x8, x8, #1
	cmp	x21, x22
	b.hi	LBB2_191
; %bb.192:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, x22
	bl	_realloc
	cbz	x0, LBB2_940
LBB2_193:                               ;   in Loop: Header=BB2_4 Depth=1
	strb	wzr, [x0, x26]
	tst	x21, #0x3
	b.eq	LBB2_214
; %bb.194:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x20, x26, #2
	cmp	x20, x22
	b.ls	LBB2_198
; %bb.195:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	x22, #0
	mov	w8, #256
	csel	x8, x8, x22, eq
LBB2_196:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x22, x8
	lsl	x8, x8, #1
	cmp	x20, x22
	b.hi	LBB2_196
; %bb.197:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, x22
	bl	_realloc
	cbz	x0, LBB2_940
LBB2_198:                               ;   in Loop: Header=BB2_4 Depth=1
	strb	wzr, [x0, x21]
	tst	x20, #0x3
	b.eq	LBB2_255
; %bb.199:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x21, x26, #3
	cmp	x21, x22
	b.ls	LBB2_203
; %bb.200:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	x22, #0
	mov	w8, #256
	csel	x8, x8, x22, eq
LBB2_201:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x22, x8
	lsl	x8, x8, #1
	cmp	x21, x22
	b.hi	LBB2_201
; %bb.202:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, x22
	bl	_realloc
	cbz	x0, LBB2_940
LBB2_203:                               ;   in Loop: Header=BB2_4 Depth=1
	strb	wzr, [x0, x20]
	tst	x21, #0x3
	b.eq	LBB2_214
; %bb.204:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x20, x26, #4
	cmp	x20, x22
	b.ls	LBB2_208
; %bb.205:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	x22, #0
	mov	w8, #256
	csel	x8, x8, x22, eq
LBB2_206:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x22, x8
	lsl	x8, x8, #1
	cmp	x20, x22
	b.hi	LBB2_206
; %bb.207:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, x22
	bl	_realloc
	cbz	x0, LBB2_940
LBB2_208:                               ;   in Loop: Header=BB2_4 Depth=1
	str	x0, [sp, #64]                   ; 8-byte Folded Spill
	strb	wzr, [x0, x21]
	b	LBB2_253
LBB2_209:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #33
	movk	w8, #61376, lsl #16
	str	w8, [sp, #104]
	b	LBB2_232
LBB2_210:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x20, x26, #1
	cmp	x20, x22
	ldr	x27, [sp, #72]                  ; 8-byte Folded Reload
	mov	x28, x23
	b.ls	LBB2_221
; %bb.211:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	x22, #0
	mov	w8, #256
	csel	x8, x8, x22, eq
	mov	x0, x21
Lloh273:
	adrp	x23, lJTI2_0@PAGE
Lloh274:
	add	x23, x23, lJTI2_0@PAGEOFF
LBB2_212:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x22, x8
	lsl	x8, x8, #1
	cmp	x20, x22
	b.hi	LBB2_212
; %bb.213:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, x22
	bl	_realloc
	cbnz	x0, LBB2_222
	b	LBB2_946
LBB2_214:                               ;   in Loop: Header=BB2_4 Depth=1
	stp	x21, x0, [sp, #56]              ; 16-byte Folded Spill
	b	LBB2_254
LBB2_215:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #1
	add	x8, x26, x19, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #4
	b.ne	LBB2_932
; %bb.216:                              ;   in Loop: Header=BB2_4 Depth=1
	lsl	x8, x19, #5
	ldr	x0, [x26, x8]
	bl	_parse64
	strb	w0, [sp, #104]
	ldr	x21, [sp, #56]                  ; 8-byte Folded Reload
	add	x20, x21, #1
	cmp	x20, x22
	b.ls	LBB2_256
; %bb.217:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	x22, #0
	mov	w8, #256
	csel	x8, x8, x22, eq
	ldr	x0, [sp, #64]                   ; 8-byte Folded Reload
	mov	x28, x23
LBB2_218:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x22, x8
	lsl	x8, x8, #1
	cmp	x20, x22
	b.hi	LBB2_218
; %bb.219:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, x22
	bl	_realloc
Lloh275:
	adrp	x23, lJTI2_0@PAGE
Lloh276:
	add	x23, x23, lJTI2_0@PAGEOFF
	cbnz	x0, LBB2_257
	b	LBB2_947
LBB2_220:                               ;   in Loop: Header=BB2_4 Depth=1
	str	x10, [sp]
Lloh277:
	adrp	x0, l_.str.162@PAGE
Lloh278:
	add	x0, x0, l_.str.162@PAGEOFF
	bl	_printf
	mov	x28, #0
	b	LBB2_44
LBB2_221:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x21
Lloh279:
	adrp	x23, lJTI2_0@PAGE
Lloh280:
	add	x23, x23, lJTI2_0@PAGEOFF
LBB2_222:                               ;   in Loop: Header=BB2_4 Depth=1
	strb	wzr, [x0, x26]
	mov	x26, x20
	tst	x26, #0x3
	b.ne	LBB2_189
LBB2_223:                               ;   in Loop: Header=BB2_4 Depth=1
	stp	x26, x0, [sp, #56]              ; 16-byte Folded Spill
	b	LBB2_254
LBB2_224:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #8
	str	w8, [sp, #104]
	b	LBB2_232
LBB2_225:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #1
	add	x8, x26, x19, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #4
	b.ne	LBB2_932
; %bb.226:                              ;   in Loop: Header=BB2_4 Depth=1
	lsl	x8, x19, #5
	ldr	x0, [x26, x8]
	bl	_parse64
	strh	w0, [sp, #104]
	ldr	x21, [sp, #56]                  ; 8-byte Folded Reload
	add	x20, x21, #2
	cmp	x20, x22
	b.ls	LBB2_264
; %bb.227:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	x22, #0
	mov	w8, #256
	csel	x8, x8, x22, eq
	ldr	x0, [sp, #64]                   ; 8-byte Folded Reload
	mov	x28, x23
LBB2_228:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x22, x8
	lsl	x8, x8, #1
	cmp	x20, x22
	b.hi	LBB2_228
; %bb.229:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, x22
	bl	_realloc
Lloh281:
	adrp	x23, lJTI2_0@PAGE
Lloh282:
	add	x23, x23, lJTI2_0@PAGEOFF
	cbnz	x0, LBB2_265
	b	LBB2_948
LBB2_230:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #4
LBB2_231:                               ;   in Loop: Header=BB2_4 Depth=1
	str	w8, [sp, #104]
LBB2_232:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [sp, #104]
	ands	w9, w8, #0x3
	b.ne	LBB2_239
; %bb.233:                              ;   in Loop: Header=BB2_4 Depth=1
	and	w10, w8, #0x78
	cmp	w10, #55
	b.hi	LBB2_239
; %bb.234:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #1
	ldr	x8, [x25]
	add	x8, x8, x19, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #1
	b.ne	LBB2_929
; %bb.235:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x28, x21
	ldr	x20, [x8]
	ldp	x26, x24, [sp, #48]             ; 16-byte Folded Reload
	ldp	x8, x9, [x26, #8]
	cmp	x8, x9
	ldr	x21, [sp, #64]                  ; 8-byte Folded Reload
	b.lo	LBB2_238
; %bb.236:                              ;   in Loop: Header=BB2_4 Depth=1
	lsl	x8, x9, #1
	cmp	x9, #0
	mov	w9, #256
	csel	x8, x9, x8, eq
	str	x8, [x26, #16]
	ldr	x0, [x26]
	add	x8, x8, x8, lsl #1
	lsl	x1, x8, #3
	bl	_realloc
	str	x0, [x26]
	cbz	x0, LBB2_944
; %bb.237:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x26, #8]
LBB2_238:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x9, [x26]
	add	x10, x8, #1
	str	x10, [x26, #8]
	mov	w10, #24
	madd	x8, x8, x10, x9
	str	x20, [x8]
	mov	w9, #1
	b	LBB2_246
LBB2_239:                               ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #3
	mov	x28, x21
	b.ne	LBB2_247
; %bb.240:                              ;   in Loop: Header=BB2_4 Depth=1
	and	w8, w8, #0x7c
	cmp	w8, #11
	b.hi	LBB2_247
; %bb.241:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #1
	ldr	x8, [x25]
	add	x8, x8, x19, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #1
	b.ne	LBB2_929
; %bb.242:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x20, [x8]
	ldp	x26, x24, [sp, #48]             ; 16-byte Folded Reload
	ldp	x8, x9, [x26, #8]
	cmp	x8, x9
	ldr	x21, [sp, #64]                  ; 8-byte Folded Reload
	b.lo	LBB2_245
; %bb.243:                              ;   in Loop: Header=BB2_4 Depth=1
	lsl	x8, x9, #1
	cmp	x9, #0
	mov	w9, #256
	csel	x8, x9, x8, eq
	str	x8, [x26, #16]
	ldr	x0, [x26]
	add	x8, x8, x8, lsl #1
	lsl	x1, x8, #3
	bl	_realloc
	str	x0, [x26]
	cbz	x0, LBB2_945
; %bb.244:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x26, #8]
LBB2_245:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x9, [x26]
	add	x10, x8, #1
	str	x10, [x26, #8]
	mov	w10, #24
	madd	x8, x8, x10, x9
	str	x20, [x8]
	mov	w9, #2
LBB2_246:                               ;   in Loop: Header=BB2_4 Depth=1
	str	x24, [x8, #8]
	stp	w9, wzr, [x8, #16]
	b	LBB2_248
LBB2_247:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x19, x24
	ldp	x24, x21, [sp, #56]             ; 16-byte Folded Reload
LBB2_248:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x20, x24, #4
	cmp	x20, x22
	b.ls	LBB2_252
; %bb.249:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	x22, #0
	mov	w8, #256
	csel	x8, x8, x22, eq
LBB2_250:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x22, x8
	lsl	x8, x8, #1
	cmp	x20, x22
	b.hi	LBB2_250
; %bb.251:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x21
	mov	x1, x22
	bl	_realloc
	mov	x21, x0
	cbz	x0, LBB2_939
LBB2_252:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [sp, #104]
	str	x21, [sp, #64]                  ; 8-byte Folded Spill
	str	w8, [x21, x24]
LBB2_253:                               ;   in Loop: Header=BB2_4 Depth=1
	str	x20, [sp, #56]                  ; 8-byte Folded Spill
LBB2_254:                               ;   in Loop: Header=BB2_4 Depth=1
Lloh283:
	adrp	x21, lJTI2_1@PAGE
Lloh284:
	add	x21, x21, lJTI2_1@PAGEOFF
	b	LBB2_3
LBB2_255:                               ;   in Loop: Header=BB2_4 Depth=1
	str	x0, [sp, #64]                   ; 8-byte Folded Spill
	b	LBB2_253
LBB2_256:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [sp, #64]                   ; 8-byte Folded Reload
	mov	x28, x23
Lloh285:
	adrp	x23, lJTI2_0@PAGE
Lloh286:
	add	x23, x23, lJTI2_0@PAGEOFF
LBB2_257:                               ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w8, [sp, #104]
	str	x0, [sp, #64]                   ; 8-byte Folded Spill
	strb	w8, [x0, x21]
	b	LBB2_253
LBB2_258:                               ;   in Loop: Header=BB2_4 Depth=1
	str	x10, [sp]
Lloh287:
	adrp	x0, l_.str.162@PAGE
Lloh288:
	add	x0, x0, l_.str.162@PAGEOFF
	bl	_printf
	mov	x28, #0
	b	LBB2_64
LBB2_259:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #1
	add	x8, x26, x19, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #4
	b.ne	LBB2_932
; %bb.260:                              ;   in Loop: Header=BB2_4 Depth=1
	lsl	x8, x19, #5
	ldr	x0, [x26, x8]
	bl	_parse64
	str	w0, [sp, #104]
	ldr	x21, [sp, #56]                  ; 8-byte Folded Reload
	add	x20, x21, #4
	cmp	x20, x22
	b.ls	LBB2_279
; %bb.261:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	x22, #0
	mov	w8, #256
	csel	x8, x8, x22, eq
	ldr	x0, [sp, #64]                   ; 8-byte Folded Reload
	mov	x28, x23
LBB2_262:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x22, x8
	lsl	x8, x8, #1
	cmp	x20, x22
	b.hi	LBB2_262
; %bb.263:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, x22
	bl	_realloc
Lloh289:
	adrp	x23, lJTI2_0@PAGE
Lloh290:
	add	x23, x23, lJTI2_0@PAGEOFF
	cbnz	x0, LBB2_280
	b	LBB2_949
LBB2_264:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [sp, #64]                   ; 8-byte Folded Reload
	mov	x28, x23
Lloh291:
	adrp	x23, lJTI2_0@PAGE
Lloh292:
	add	x23, x23, lJTI2_0@PAGEOFF
LBB2_265:                               ;   in Loop: Header=BB2_4 Depth=1
	ldrh	w8, [sp, #104]
	str	x0, [sp, #64]                   ; 8-byte Folded Spill
	strh	w8, [x0, x21]
	b	LBB2_253
LBB2_266:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #1
	add	x8, x26, x19, lsl #5
	ldr	w9, [x8, #8]
	cbz	w9, LBB2_324
; %bb.267:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #1
	mov	x28, x23
	b.eq	LBB2_287
; %bb.268:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w9, #4
	ldr	x21, [sp, #56]                  ; 8-byte Folded Reload
Lloh293:
	adrp	x23, lJTI2_0@PAGE
Lloh294:
	add	x23, x23, lJTI2_0@PAGEOFF
	b.ne	LBB2_937
; %bb.269:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse64
	str	x0, [sp, #104]
	add	x20, x21, #8
	cmp	x20, x22
	b.ls	LBB2_299
; %bb.270:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	x22, #0
	mov	w8, #256
	csel	x8, x8, x22, eq
	ldr	x0, [sp, #64]                   ; 8-byte Folded Reload
LBB2_271:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x22, x8
	lsl	x8, x8, #1
	cmp	x20, x22
	b.hi	LBB2_271
; %bb.272:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, x22
	bl	_realloc
	cbnz	x0, LBB2_300
	b	LBB2_955
LBB2_273:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #16
	str	w8, [sp, #104]
	b	LBB2_232
LBB2_274:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #1
	add	x8, x26, x19, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #5
	b.ne	LBB2_934
; %bb.275:                              ;   in Loop: Header=BB2_4 Depth=1
	lsl	x8, x19, #5
	ldr	x0, [x26, x8]
	bl	_atof
	fcvt	s0, d0
	str	s0, [sp, #104]
	ldr	x21, [sp, #56]                  ; 8-byte Folded Reload
	add	x20, x21, #4
	cmp	x20, x22
	b.ls	LBB2_279
; %bb.276:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	x22, #0
	mov	w8, #256
	csel	x8, x8, x22, eq
	ldr	x0, [sp, #64]                   ; 8-byte Folded Reload
	mov	x28, x23
LBB2_277:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x22, x8
	lsl	x8, x8, #1
	cmp	x20, x22
	b.hi	LBB2_277
; %bb.278:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, x22
	bl	_realloc
Lloh295:
	adrp	x23, lJTI2_0@PAGE
Lloh296:
	add	x23, x23, lJTI2_0@PAGEOFF
	cbnz	x0, LBB2_280
	b	LBB2_951
LBB2_279:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [sp, #64]                   ; 8-byte Folded Reload
	mov	x28, x23
Lloh297:
	adrp	x23, lJTI2_0@PAGE
Lloh298:
	add	x23, x23, lJTI2_0@PAGEOFF
LBB2_280:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	w8, [sp, #104]
	str	x0, [sp, #64]                   ; 8-byte Folded Spill
	str	w8, [x0, x21]
	b	LBB2_253
LBB2_281:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #12
	str	w8, [sp, #104]
	b	LBB2_232
LBB2_282:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #1
	add	x8, x26, x19, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #5
	b.ne	LBB2_934
; %bb.283:                              ;   in Loop: Header=BB2_4 Depth=1
	lsl	x8, x19, #5
	ldr	x0, [x26, x8]
	bl	_atof
	str	d0, [sp, #104]
	ldr	x21, [sp, #56]                  ; 8-byte Folded Reload
	add	x20, x21, #8
	cmp	x20, x22
	b.ls	LBB2_292
; %bb.284:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	x22, #0
	mov	w8, #256
	csel	x8, x8, x22, eq
	ldr	x0, [sp, #64]                   ; 8-byte Folded Reload
	mov	x28, x23
LBB2_285:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x22, x8
	lsl	x8, x8, #1
	cmp	x20, x22
	b.hi	LBB2_285
; %bb.286:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, x22
	bl	_realloc
Lloh299:
	adrp	x23, lJTI2_0@PAGE
Lloh300:
	add	x23, x23, lJTI2_0@PAGEOFF
	cbnz	x0, LBB2_300
	b	LBB2_954
LBB2_287:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x8]
	ldp	x20, x21, [sp, #48]             ; 16-byte Folded Reload
	stp	x8, x21, [sp, #104]
	str	xzr, [sp, #120]
	ldp	x8, x9, [x20, #8]
	cmp	x8, x9
Lloh301:
	adrp	x23, lJTI2_0@PAGE
Lloh302:
	add	x23, x23, lJTI2_0@PAGEOFF
	b.hs	LBB2_293
; %bb.288:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x20]
	ldr	x10, [sp, #64]                  ; 8-byte Folded Reload
	b	LBB2_295
LBB2_289:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #1
	add	x8, x26, x19, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #1
	b.ne	LBB2_935
; %bb.290:                              ;   in Loop: Header=BB2_4 Depth=1
	lsl	x8, x19, #5
	ldr	x8, [x26, x8]
	ldp	x20, x21, [sp, #48]             ; 16-byte Folded Reload
	stp	x8, x21, [sp, #104]
	str	xzr, [sp, #120]
	ldp	x8, x9, [x20, #8]
	cmp	x8, x9
	b.hs	LBB2_327
; %bb.291:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x20]
	ldr	x10, [sp, #64]                  ; 8-byte Folded Reload
	mov	x28, x23
	b	LBB2_329
LBB2_292:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [sp, #64]                   ; 8-byte Folded Reload
	mov	x28, x23
Lloh303:
	adrp	x23, lJTI2_0@PAGE
Lloh304:
	add	x23, x23, lJTI2_0@PAGEOFF
	b	LBB2_300
LBB2_293:                               ;   in Loop: Header=BB2_4 Depth=1
	lsl	x8, x9, #1
	cmp	x9, #0
	mov	w9, #256
	csel	x8, x9, x8, eq
	str	x8, [x20, #16]
	ldr	x0, [x20]
	add	x8, x8, x8, lsl #1
	lsl	x1, x8, #3
	bl	_realloc
	str	x0, [x20]
	ldr	x10, [sp, #64]                  ; 8-byte Folded Reload
	cbz	x0, LBB2_956
; %bb.294:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x20, #8]
LBB2_295:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x8, #1
	str	x9, [x20, #8]
	mov	w9, #24
	madd	x8, x8, x9, x0
	ldur	q0, [sp, #104]
	str	q0, [x8]
	ldr	x9, [sp, #120]
	str	x9, [x8, #16]
	add	x20, x21, #8
	cmp	x20, x22
	b.ls	LBB2_333
; %bb.296:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	x22, #0
	mov	w8, #256
	csel	x8, x8, x22, eq
LBB2_297:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x22, x8
	lsl	x8, x8, #1
	cmp	x20, x22
	b.hi	LBB2_297
; %bb.298:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x10
	mov	x1, x22
	bl	_realloc
	mov	x10, x0
	cbnz	x0, LBB2_333
	b	LBB2_957
LBB2_299:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [sp, #64]                   ; 8-byte Folded Reload
LBB2_300:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [sp, #104]
	str	x0, [sp, #64]                   ; 8-byte Folded Spill
	str	x8, [x0, x21]
	b	LBB2_253
LBB2_301:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #24
	b	LBB2_231
LBB2_302:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #1
	add	x8, x26, x19, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #4
	b.ne	LBB2_932
; %bb.303:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse64
	ands	x8, x0, #0x3
	mov	w9, #4
	sub	x8, x9, x8
	tst	x0, #0x3
	csel	x8, xzr, x8, eq
	adds	x20, x8, x0
	b.eq	LBB2_324
; %bb.304:                              ;   in Loop: Header=BB2_4 Depth=1
	ldp	x24, x0, [sp, #56]              ; 16-byte Folded Reload
	mov	x28, x23
Lloh305:
	adrp	x23, lJTI2_0@PAGE
Lloh306:
	add	x23, x23, lJTI2_0@PAGEOFF
	b	LBB2_307
LBB2_305:                               ;   in Loop: Header=BB2_307 Depth=2
	str	xzr, [x0, x24]
	mov	x8, #-8
LBB2_306:                               ;   in Loop: Header=BB2_307 Depth=2
	mov	x24, x21
	adds	x20, x20, x8
Lloh307:
	adrp	x21, lJTI2_1@PAGE
Lloh308:
	add	x21, x21, lJTI2_1@PAGEOFF
	b.eq	LBB2_334
LBB2_307:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB2_321 Depth 3
                                        ;       Child Loop BB2_315 Depth 3
                                        ;       Child Loop BB2_310 Depth 3
	cmp	x20, #8
	b.lo	LBB2_312
; %bb.308:                              ;   in Loop: Header=BB2_307 Depth=2
	add	x21, x24, #8
	cmp	x21, x22
	b.ls	LBB2_305
; %bb.309:                              ;   in Loop: Header=BB2_307 Depth=2
	cmp	x22, #0
	mov	w8, #256
	csel	x8, x8, x22, eq
LBB2_310:                               ;   Parent Loop BB2_4 Depth=1
                                        ;     Parent Loop BB2_307 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	mov	x22, x8
	lsl	x8, x8, #1
	cmp	x21, x22
	b.hi	LBB2_310
; %bb.311:                              ;   in Loop: Header=BB2_307 Depth=2
	mov	x1, x22
	bl	_realloc
	cbnz	x0, LBB2_305
	b	LBB2_950
LBB2_312:                               ;   in Loop: Header=BB2_307 Depth=2
	cmp	x20, #4
	b.lo	LBB2_318
; %bb.313:                              ;   in Loop: Header=BB2_307 Depth=2
	add	x21, x24, #4
	cmp	x21, x22
	b.ls	LBB2_317
; %bb.314:                              ;   in Loop: Header=BB2_307 Depth=2
	cmp	x22, #0
	mov	w8, #256
	csel	x8, x8, x22, eq
LBB2_315:                               ;   Parent Loop BB2_4 Depth=1
                                        ;     Parent Loop BB2_307 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	mov	x22, x8
	lsl	x8, x8, #1
	cmp	x21, x22
	b.hi	LBB2_315
; %bb.316:                              ;   in Loop: Header=BB2_307 Depth=2
	mov	x1, x22
	bl	_realloc
	cbz	x0, LBB2_952
LBB2_317:                               ;   in Loop: Header=BB2_307 Depth=2
	str	wzr, [x0, x24]
	mov	x8, #-4
	b	LBB2_306
LBB2_318:                               ;   in Loop: Header=BB2_307 Depth=2
	cmp	x20, #2
	b.lo	LBB2_337
; %bb.319:                              ;   in Loop: Header=BB2_307 Depth=2
	add	x21, x24, #2
	cmp	x21, x22
	b.ls	LBB2_323
; %bb.320:                              ;   in Loop: Header=BB2_307 Depth=2
	cmp	x22, #0
	mov	w8, #256
	csel	x8, x8, x22, eq
LBB2_321:                               ;   Parent Loop BB2_4 Depth=1
                                        ;     Parent Loop BB2_307 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	mov	x22, x8
	lsl	x8, x8, #1
	cmp	x21, x22
	b.hi	LBB2_321
; %bb.322:                              ;   in Loop: Header=BB2_307 Depth=2
	mov	x1, x22
	bl	_realloc
	cbz	x0, LBB2_953
LBB2_323:                               ;   in Loop: Header=BB2_307 Depth=2
	strh	wzr, [x0, x24]
	mov	x8, #-2
	b	LBB2_306
LBB2_324:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x28, x23
LBB2_325:                               ;   in Loop: Header=BB2_4 Depth=1
Lloh309:
	adrp	x23, lJTI2_0@PAGE
Lloh310:
	add	x23, x23, lJTI2_0@PAGEOFF
	b	LBB2_3
LBB2_326:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #20
	str	w8, [sp, #104]
	b	LBB2_232
LBB2_327:                               ;   in Loop: Header=BB2_4 Depth=1
	lsl	x8, x9, #1
	cmp	x9, #0
	mov	w9, #256
	csel	x8, x9, x8, eq
	str	x8, [x20, #16]
	ldr	x0, [x20]
	add	x8, x8, x8, lsl #1
	lsl	x1, x8, #3
	bl	_realloc
	str	x0, [x20]
	ldr	x10, [sp, #64]                  ; 8-byte Folded Reload
	cbz	x0, LBB2_959
; %bb.328:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x28, x23
	ldr	x8, [x20, #8]
LBB2_329:                               ;   in Loop: Header=BB2_4 Depth=1
Lloh311:
	adrp	x23, lJTI2_0@PAGE
Lloh312:
	add	x23, x23, lJTI2_0@PAGEOFF
	add	x9, x8, #1
	str	x9, [x20, #8]
	mov	w9, #24
	madd	x8, x8, x9, x0
	ldur	q0, [sp, #104]
	str	q0, [x8]
	ldr	x9, [sp, #120]
	str	x9, [x8, #16]
	add	x20, x21, #8
	cmp	x20, x22
	b.ls	LBB2_333
; %bb.330:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	x22, #0
	mov	w8, #256
	csel	x8, x8, x22, eq
LBB2_331:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x22, x8
	lsl	x8, x8, #1
	cmp	x20, x22
	b.hi	LBB2_331
; %bb.332:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x10
	mov	x1, x22
	bl	_realloc
	mov	x10, x0
	cbz	x0, LBB2_960
LBB2_333:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [sp, #112]
	str	x10, [sp, #64]                  ; 8-byte Folded Spill
	str	x8, [x10, x21]
	b	LBB2_253
LBB2_334:                               ;   in Loop: Header=BB2_4 Depth=1
	stp	x24, x0, [sp, #56]              ; 16-byte Folded Spill
	b	LBB2_3
LBB2_335:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #28
	str	w8, [sp, #104]
	b	LBB2_232
LBB2_336:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #32
	str	w8, [sp, #104]
	b	LBB2_232
LBB2_337:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x20, x24, #1
	cmp	x20, x22
	b.ls	LBB2_341
; %bb.338:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	x22, #0
	mov	w8, #256
	csel	x8, x8, x22, eq
LBB2_339:                               ;   Parent Loop BB2_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x22, x8
	lsl	x8, x8, #1
	cmp	x20, x22
	b.hi	LBB2_339
; %bb.340:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x1, x22
	bl	_realloc
	cbz	x0, LBB2_964
LBB2_341:                               ;   in Loop: Header=BB2_4 Depth=1
	stp	x20, x0, [sp, #56]              ; 16-byte Folded Spill
	strb	wzr, [x0, x24]
	b	LBB2_3
LBB2_342:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #40
	str	w8, [sp, #104]
	b	LBB2_232
LBB2_343:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #36
	str	w8, [sp, #104]
	b	LBB2_232
LBB2_344:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #48
	str	w8, [sp, #104]
	b	LBB2_232
LBB2_345:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #44
	str	w8, [sp, #104]
	b	LBB2_232
LBB2_346:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #52
	str	w8, [sp, #104]
	b	LBB2_232
LBB2_347:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #19
	str	w8, [sp, #104]
	add	x24, x24, #1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.348:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	mov	w8, #19
	b	LBB2_353
LBB2_349:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #27
	str	w8, [sp, #104]
	add	x24, x24, #1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.350:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	mov	w8, #27
	b	LBB2_353
LBB2_351:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #23
	str	w8, [sp, #104]
	add	x24, x24, #1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.352:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	mov	w8, #23
LBB2_353:                               ;   in Loop: Header=BB2_4 Depth=1
	bfi	w8, w0, #27, #5
LBB2_354:                               ;   in Loop: Header=BB2_4 Depth=1
	str	w8, [sp, #104]
LBB2_355:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x27, [sp, #72]                  ; 8-byte Folded Reload
	mov	x23, x26
	b	LBB2_232
LBB2_356:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #35
	str	w8, [sp, #104]
	add	x24, x24, #1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.357:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	mov	w8, #35
	b	LBB2_353
LBB2_358:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #31
	str	w8, [sp, #104]
	add	x24, x24, #1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.359:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	mov	w8, #31
	b	LBB2_353
LBB2_360:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #43
	str	w8, [sp, #104]
	add	x24, x24, #1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.361:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	mov	w8, #43
	b	LBB2_353
LBB2_362:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #39
	str	w8, [sp, #104]
	add	x24, x24, #1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.363:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	mov	w8, #39
	b	LBB2_353
LBB2_364:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #47
	str	w8, [sp, #104]
	add	x24, x24, #1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.365:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	mov	w8, #47
	b	LBB2_353
LBB2_366:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #51
	str	w8, [sp, #104]
	add	x24, x24, #1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.367:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	mov	w8, #51
	b	LBB2_353
LBB2_368:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #59
	str	w8, [sp, #104]
	add	x24, x24, #1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.369:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	mov	w8, #59
	b	LBB2_353
LBB2_370:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #55
	str	w8, [sp, #104]
	add	x24, x24, #1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.371:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	mov	w8, #55
	b	LBB2_353
LBB2_372:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #67
	str	w8, [sp, #104]
	add	x24, x24, #1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.373:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	mov	w8, #67
	b	LBB2_353
LBB2_374:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #63
	str	w8, [sp, #104]
	add	x24, x24, #1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.375:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	mov	w8, #63
	b	LBB2_353
LBB2_376:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #71
	str	w8, [sp, #104]
	add	x24, x24, #1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.377:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	mov	w8, #71
	b	LBB2_353
LBB2_378:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #83
	b	LBB2_354
LBB2_379:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.380:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.381:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	add	x19, x24, #3
	add	x9, x8, x19, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #4
	b.eq	LBB2_401
; %bb.382:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_973
; %bb.383:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x9]
	bl	_parse_reg
	mov	x28, x0
	ldr	x8, [x25]
	add	x9, x8, x24, lsl #5
	ldr	w9, [x9, #136]
	cmp	w9, #11
	b.ne	LBB2_429
; %bb.384:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #5
	add	x9, x8, x24, lsl #5
	ldr	w10, [x9, #8]
	cbz	w10, LBB2_355
; %bb.385:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.eq	LBB2_460
; %bb.386:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.ne	LBB2_982
; %bb.387:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #1
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_389
; %bb.388:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_389:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	lsl	w9, w28, #27
	bfi	w9, w27, #22, #5
	and	w8, w8, #0x7fff
	bfi	w9, w8, #7, #15
	orr	w8, w9, #0x1
	b	LBB2_354
LBB2_390:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.391:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.392:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	add	x19, x24, #3
	add	x9, x8, x19, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #4
	b.eq	LBB2_415
; %bb.393:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_973
; %bb.394:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x9]
	bl	_parse_reg
	mov	x28, x0
	ldr	x8, [x25]
	add	x9, x8, x24, lsl #5
	ldr	w9, [x9, #136]
	cmp	w9, #11
	b.ne	LBB2_444
; %bb.395:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #5
	add	x9, x8, x24, lsl #5
	ldr	w10, [x9, #8]
	cbz	w10, LBB2_355
; %bb.396:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.eq	LBB2_476
; %bb.397:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.ne	LBB2_982
; %bb.398:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #5
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_400
; %bb.399:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_400:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	lsl	w9, w28, #27
	bfi	w9, w27, #22, #5
	and	w8, w8, #0x7fff
	bfi	w9, w8, #7, #15
	mov	w8, #5
	orr	w8, w9, w8
	b	LBB2_354
LBB2_401:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #1
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_403
; %bb.402:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x19, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_403:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	and	w9, w27, #0x1f
	lsl	w10, w27, #27
	bfi	w10, w9, #22, #5
	and	w8, w8, #0x7fff
	bfi	w10, w8, #7, #15
	orr	w8, w10, #0x1
	b	LBB2_574
LBB2_404:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.405:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.406:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	add	x19, x24, #3
	add	x9, x8, x19, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #4
	b.eq	LBB2_430
; %bb.407:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_973
; %bb.408:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x9]
	bl	_parse_reg
	mov	x28, x0
	ldr	x8, [x25]
	add	x9, x8, x24, lsl #5
	ldr	w9, [x9, #136]
	cmp	w9, #11
	b.ne	LBB2_459
; %bb.409:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #5
	add	x9, x8, x24, lsl #5
	ldr	w10, [x9, #8]
	cbz	w10, LBB2_355
; %bb.410:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.eq	LBB2_492
; %bb.411:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.ne	LBB2_982
; %bb.412:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #9
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_414
; %bb.413:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_414:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	lsl	w9, w28, #27
	bfi	w9, w27, #22, #5
	and	w8, w8, #0x7fff
	bfi	w9, w8, #7, #15
	mov	w8, #9
	orr	w8, w9, w8
	b	LBB2_354
LBB2_415:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #5
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_417
; %bb.416:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x19, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_417:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	and	w9, w27, #0x1f
	lsl	w10, w27, #27
	bfi	w10, w9, #22, #5
	and	w8, w8, #0x7fff
	bfi	w10, w8, #7, #15
	mov	w8, #5
	b	LBB2_573
LBB2_418:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.419:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.420:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	add	x19, x24, #3
	add	x9, x8, x19, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #4
	b.eq	LBB2_445
; %bb.421:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_973
; %bb.422:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x9]
	bl	_parse_reg
	mov	x28, x0
	ldr	x8, [x25]
	add	x9, x8, x24, lsl #5
	ldr	w9, [x9, #136]
	cmp	w9, #11
	b.ne	LBB2_475
; %bb.423:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #5
	add	x9, x8, x24, lsl #5
	ldr	w10, [x9, #8]
	cbz	w10, LBB2_355
; %bb.424:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.eq	LBB2_508
; %bb.425:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.ne	LBB2_982
; %bb.426:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #13
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_428
; %bb.427:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_428:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	lsl	w9, w28, #27
	bfi	w9, w27, #22, #5
	and	w8, w8, #0x7fff
	bfi	w9, w8, #7, #15
	mov	w8, #13
	orr	w8, w9, w8
	b	LBB2_354
LBB2_429:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #2
	b	LBB2_592
LBB2_430:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #9
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_432
; %bb.431:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x19, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_432:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	and	w9, w27, #0x1f
	lsl	w10, w27, #27
	bfi	w10, w9, #22, #5
	and	w8, w8, #0x7fff
	bfi	w10, w8, #7, #15
	mov	w8, #9
	b	LBB2_573
LBB2_433:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.434:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.435:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	add	x19, x24, #3
	add	x9, x8, x19, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #4
	b.eq	LBB2_461
; %bb.436:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_973
; %bb.437:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x9]
	bl	_parse_reg
	mov	x28, x0
	ldr	x8, [x25]
	add	x9, x8, x24, lsl #5
	ldr	w9, [x9, #136]
	cmp	w9, #11
	b.ne	LBB2_491
; %bb.438:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #5
	add	x9, x8, x24, lsl #5
	ldr	w10, [x9, #8]
	cbz	w10, LBB2_355
; %bb.439:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.eq	LBB2_524
; %bb.440:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.ne	LBB2_982
; %bb.441:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #17
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_443
; %bb.442:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_443:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	lsl	w9, w28, #27
	bfi	w9, w27, #22, #5
	and	w8, w8, #0x7fff
	bfi	w9, w8, #7, #15
	mov	w8, #17
	orr	w8, w9, w8
	b	LBB2_354
LBB2_444:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #6
	b	LBB2_592
LBB2_445:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #13
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_447
; %bb.446:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x19, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_447:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	and	w9, w27, #0x1f
	lsl	w10, w27, #27
	bfi	w10, w9, #22, #5
	and	w8, w8, #0x7fff
	bfi	w10, w8, #7, #15
	mov	w8, #13
	b	LBB2_573
LBB2_448:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.449:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.450:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	add	x19, x24, #3
	add	x9, x8, x19, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #4
	b.eq	LBB2_477
; %bb.451:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_973
; %bb.452:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x9]
	bl	_parse_reg
	mov	x28, x0
	ldr	x8, [x25]
	add	x9, x8, x24, lsl #5
	ldr	w9, [x9, #136]
	cmp	w9, #11
	b.ne	LBB2_507
; %bb.453:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #5
	add	x9, x8, x24, lsl #5
	ldr	w10, [x9, #8]
	cbz	w10, LBB2_355
; %bb.454:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.eq	LBB2_540
; %bb.455:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.ne	LBB2_982
; %bb.456:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #21
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_458
; %bb.457:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_458:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	lsl	w9, w28, #27
	bfi	w9, w27, #22, #5
	and	w8, w8, #0x7fff
	bfi	w9, w8, #7, #15
	mov	w8, #21
	orr	w8, w9, w8
	b	LBB2_354
LBB2_459:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #10
	b	LBB2_592
LBB2_460:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #2
	b	LBB2_611
LBB2_461:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #17
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_463
; %bb.462:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x19, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_463:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	and	w9, w27, #0x1f
	lsl	w10, w27, #27
	bfi	w10, w9, #22, #5
	and	w8, w8, #0x7fff
	bfi	w10, w8, #7, #15
	mov	w8, #17
	b	LBB2_573
LBB2_464:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.465:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.466:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	add	x19, x24, #3
	add	x9, x8, x19, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #4
	b.eq	LBB2_493
; %bb.467:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_973
; %bb.468:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x9]
	bl	_parse_reg
	mov	x28, x0
	ldr	x8, [x25]
	add	x9, x8, x24, lsl #5
	ldr	w9, [x9, #136]
	cmp	w9, #11
	b.ne	LBB2_523
; %bb.469:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #5
	add	x9, x8, x24, lsl #5
	ldr	w10, [x9, #8]
	cbz	w10, LBB2_355
; %bb.470:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.eq	LBB2_564
; %bb.471:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.ne	LBB2_982
; %bb.472:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #25
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_474
; %bb.473:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_474:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	lsl	w9, w28, #27
	bfi	w9, w27, #22, #5
	and	w8, w8, #0x7fff
	bfi	w9, w8, #7, #15
	mov	w8, #25
	orr	w8, w9, w8
	b	LBB2_354
LBB2_475:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #14
	b	LBB2_592
LBB2_476:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #6
	b	LBB2_611
LBB2_477:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #21
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_479
; %bb.478:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x19, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_479:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	and	w9, w27, #0x1f
	lsl	w10, w27, #27
	bfi	w10, w9, #22, #5
	and	w8, w8, #0x7fff
	bfi	w10, w8, #7, #15
	mov	w8, #21
	b	LBB2_573
LBB2_480:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.481:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.482:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	add	x19, x24, #3
	add	x9, x8, x19, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #4
	b.eq	LBB2_509
; %bb.483:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_973
; %bb.484:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x9]
	bl	_parse_reg
	mov	x28, x0
	ldr	x8, [x25]
	add	x9, x8, x24, lsl #5
	ldr	w9, [x9, #136]
	cmp	w9, #11
	b.ne	LBB2_539
; %bb.485:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #5
	add	x9, x8, x24, lsl #5
	ldr	w10, [x9, #8]
	cbz	w10, LBB2_355
; %bb.486:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.eq	LBB2_569
; %bb.487:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.ne	LBB2_982
; %bb.488:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #29
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_490
; %bb.489:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_490:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	lsl	w9, w28, #27
	bfi	w9, w27, #22, #5
	and	w8, w8, #0x7fff
	bfi	w9, w8, #7, #15
	mov	w8, #29
	orr	w8, w9, w8
	b	LBB2_354
LBB2_491:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #18
	b	LBB2_592
LBB2_492:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #10
	b	LBB2_611
LBB2_493:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #25
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_495
; %bb.494:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x19, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_495:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	and	w9, w27, #0x1f
	lsl	w10, w27, #27
	bfi	w10, w9, #22, #5
	and	w8, w8, #0x7fff
	bfi	w10, w8, #7, #15
	mov	w8, #25
	b	LBB2_573
LBB2_496:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.497:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.498:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	add	x19, x24, #3
	add	x9, x8, x19, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #4
	b.eq	LBB2_525
; %bb.499:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_973
; %bb.500:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x9]
	bl	_parse_reg
	mov	x28, x0
	ldr	x8, [x25]
	add	x9, x8, x24, lsl #5
	ldr	w9, [x9, #136]
	cmp	w9, #11
	b.ne	LBB2_563
; %bb.501:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #5
	add	x9, x8, x24, lsl #5
	ldr	w10, [x9, #8]
	cbz	w10, LBB2_355
; %bb.502:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.eq	LBB2_586
; %bb.503:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.ne	LBB2_982
; %bb.504:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #33
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_506
; %bb.505:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_506:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	lsl	w9, w28, #27
	bfi	w9, w27, #22, #5
	and	w8, w8, #0x7fff
	bfi	w9, w8, #7, #15
	mov	w8, #33
	orr	w8, w9, w8
	b	LBB2_354
LBB2_507:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #22
	b	LBB2_592
LBB2_508:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #14
	b	LBB2_611
LBB2_509:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #29
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_511
; %bb.510:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x19, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_511:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	and	w9, w27, #0x1f
	lsl	w10, w27, #27
	bfi	w10, w9, #22, #5
	and	w8, w8, #0x7fff
	bfi	w10, w8, #7, #15
	mov	w8, #29
	b	LBB2_573
LBB2_512:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.513:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.514:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	add	x19, x24, #3
	add	x9, x8, x19, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #4
	b.eq	LBB2_541
; %bb.515:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_973
; %bb.516:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x9]
	bl	_parse_reg
	mov	x28, x0
	ldr	x8, [x25]
	add	x9, x8, x24, lsl #5
	ldr	w9, [x9, #136]
	cmp	w9, #11
	b.ne	LBB2_568
; %bb.517:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #5
	add	x9, x8, x24, lsl #5
	ldr	w10, [x9, #8]
	cbz	w10, LBB2_355
; %bb.518:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.eq	LBB2_593
; %bb.519:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.ne	LBB2_982
; %bb.520:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #37
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_522
; %bb.521:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_522:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	lsl	w9, w28, #27
	bfi	w9, w27, #22, #5
	and	w8, w8, #0x7fff
	bfi	w9, w8, #7, #15
	mov	w8, #37
	orr	w8, w9, w8
	b	LBB2_354
LBB2_523:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #26
	b	LBB2_592
LBB2_524:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #18
	b	LBB2_611
LBB2_525:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #33
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_527
; %bb.526:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x19, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_527:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	and	w9, w27, #0x1f
	lsl	w10, w27, #27
	bfi	w10, w9, #22, #5
	and	w8, w8, #0x7fff
	bfi	w10, w8, #7, #15
	mov	w8, #33
	b	LBB2_573
LBB2_528:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.529:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.530:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	add	x19, x24, #3
	add	x9, x8, x19, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #4
	b.eq	LBB2_565
; %bb.531:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_973
; %bb.532:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x9]
	bl	_parse_reg
	mov	x28, x0
	ldr	x8, [x25]
	add	x9, x8, x24, lsl #5
	ldr	w9, [x9, #136]
	cmp	w9, #11
	b.ne	LBB2_585
; %bb.533:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #5
	add	x9, x8, x24, lsl #5
	ldr	w10, [x9, #8]
	cbz	w10, LBB2_355
; %bb.534:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.eq	LBB2_594
; %bb.535:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.ne	LBB2_982
; %bb.536:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #41
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_538
; %bb.537:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_538:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	lsl	w9, w28, #27
	bfi	w9, w27, #22, #5
	and	w8, w8, #0x7fff
	bfi	w9, w8, #7, #15
	mov	w8, #41
	orr	w8, w9, w8
	b	LBB2_354
LBB2_539:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #30
	b	LBB2_592
LBB2_540:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #22
	b	LBB2_611
LBB2_541:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #37
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_543
; %bb.542:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x19, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_543:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	and	w9, w27, #0x1f
	lsl	w10, w27, #27
	bfi	w10, w9, #22, #5
	and	w8, w8, #0x7fff
	bfi	w10, w8, #7, #15
	mov	w8, #37
	b	LBB2_573
LBB2_544:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.545:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.546:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #8
	b.ne	LBB2_969
; %bb.547:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #4
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.548:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x8, x24, #5
	ldr	x9, [x25]
	add	x10, x9, x8, lsl #5
	ldr	w10, [x10, #8]
	cbz	w10, LBB2_759
; %bb.549:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #11
	b.eq	LBB2_587
; %bb.550:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #9
	b.ne	LBB2_967
; %bb.551:                              ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	ubfiz	w10, w27, #7, #5
	bfi	w10, w9, #12, #5
	mov	w9, #49
	b	LBB2_583
LBB2_552:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.553:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.554:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	add	x19, x24, #3
	add	x9, x8, x19, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #4
	b.eq	LBB2_570
; %bb.555:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_973
; %bb.556:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x9]
	bl	_parse_reg
	mov	x28, x0
	ldr	x8, [x25]
	add	x9, x8, x24, lsl #5
	ldr	w9, [x9, #136]
	cmp	w9, #11
	b.ne	LBB2_591
; %bb.557:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #5
	add	x9, x8, x24, lsl #5
	ldr	w10, [x9, #8]
	cbz	w10, LBB2_355
; %bb.558:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.eq	LBB2_610
; %bb.559:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.ne	LBB2_982
; %bb.560:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #45
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_562
; %bb.561:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_562:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	lsl	w9, w28, #27
	bfi	w9, w27, #22, #5
	and	w8, w8, #0x7fff
	bfi	w9, w8, #7, #15
	mov	w8, #45
	orr	w8, w9, w8
	b	LBB2_354
LBB2_563:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #34
	b	LBB2_592
LBB2_564:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #26
	b	LBB2_611
LBB2_565:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #41
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_567
; %bb.566:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x19, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_567:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	and	w9, w27, #0x1f
	lsl	w10, w27, #27
	bfi	w10, w9, #22, #5
	and	w8, w8, #0x7fff
	bfi	w10, w8, #7, #15
	mov	w8, #41
	b	LBB2_573
LBB2_568:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #38
	b	LBB2_592
LBB2_569:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #30
	b	LBB2_611
LBB2_570:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #45
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse64
	tbz	w0, #15, LBB2_572
; %bb.571:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x19, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_572:                               ;   in Loop: Header=BB2_4 Depth=1
	sxth	w8, w0
	and	w9, w27, #0x1f
	lsl	w10, w27, #27
	bfi	w10, w9, #22, #5
	and	w8, w8, #0x7fff
	bfi	w10, w8, #7, #15
	mov	w8, #45
LBB2_573:                               ;   in Loop: Header=BB2_4 Depth=1
	orr	w8, w10, w8
LBB2_574:                               ;   in Loop: Header=BB2_4 Depth=1
	str	w8, [sp, #104]
	mov	x24, x19
	b	LBB2_355
LBB2_575:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.576:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.577:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #8
	b.ne	LBB2_969
; %bb.578:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #4
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.579:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x8, x24, #5
	ldr	x9, [x25]
	add	x10, x9, x8, lsl #5
	ldr	w10, [x10, #8]
	cbz	w10, LBB2_759
; %bb.580:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #11
	b.eq	LBB2_595
; %bb.581:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #9
	b.ne	LBB2_967
; %bb.582:                              ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	ubfiz	w10, w27, #7, #5
	bfi	w10, w9, #12, #5
	mov	w9, #53
LBB2_583:                               ;   in Loop: Header=BB2_4 Depth=1
	orr	w9, w10, w9
LBB2_584:                               ;   in Loop: Header=BB2_4 Depth=1
	str	w9, [sp, #104]
	mov	x24, x8
	b	LBB2_355
LBB2_585:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #42
	b	LBB2_592
LBB2_586:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #34
	b	LBB2_611
LBB2_587:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #6
	add	x8, x9, x19, lsl #5
	ldr	w10, [x8, #8]
	cbz	w10, LBB2_626
; %bb.588:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.eq	LBB2_601
; %bb.589:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_975
; %bb.590:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w9, #50
	b	LBB2_599
LBB2_591:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #46
LBB2_592:                               ;   in Loop: Header=BB2_4 Depth=1
	str	w8, [sp, #104]
	strb	w27, [sp, #105]
	strb	w27, [sp, #106]
	mov	x24, x19
	strb	w28, [sp, #107]
	b	LBB2_355
LBB2_593:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #38
	b	LBB2_611
LBB2_594:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #42
	b	LBB2_611
LBB2_595:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #6
	add	x8, x9, x19, lsl #5
	ldr	w10, [x8, #8]
	cbz	w10, LBB2_626
; %bb.596:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.eq	LBB2_621
; %bb.597:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_975
; %bb.598:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w9, #54
LBB2_599:                               ;   in Loop: Header=BB2_4 Depth=1
	bfi	w9, w27, #11, #8
	strb	w0, [sp, #106]
LBB2_600:                               ;   in Loop: Header=BB2_4 Depth=1
	strh	w9, [sp, #104]
	ldr	x0, [x8]
	bl	_parse_reg
	strb	w0, [sp, #107]
	b	LBB2_626
LBB2_601:                               ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	lsl	w9, w9, #12
	bfi	w9, w27, #7, #5
	mov	w10, #49
	b	LBB2_622
LBB2_602:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.603:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.604:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #8
	b.ne	LBB2_969
; %bb.605:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #4
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.606:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x8, x24, #5
	ldr	x9, [x25]
	add	x10, x9, x8, lsl #5
	ldr	w10, [x10, #8]
	cbz	w10, LBB2_759
; %bb.607:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #11
	b.eq	LBB2_636
; %bb.608:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #9
	b.ne	LBB2_967
; %bb.609:                              ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	ubfiz	w10, w27, #7, #5
	bfi	w10, w9, #12, #5
	mov	w9, #49
	movk	w9, #2, lsl #16
	b	LBB2_583
LBB2_610:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #46
LBB2_611:                               ;   in Loop: Header=BB2_4 Depth=1
	str	w8, [sp, #104]
	ldr	x0, [x9]
	bl	_parse_reg
	strb	w27, [sp, #105]
	strb	w28, [sp, #106]
	strb	w0, [sp, #107]
	b	LBB2_355
LBB2_612:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.613:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.614:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #8
	b.ne	LBB2_969
; %bb.615:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #4
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.616:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x8, x24, #5
	ldr	x9, [x25]
	add	x10, x9, x8, lsl #5
	ldr	w10, [x10, #8]
	cbz	w10, LBB2_759
; %bb.617:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #11
	b.eq	LBB2_648
; %bb.618:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #9
	b.ne	LBB2_967
; %bb.619:                              ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	ubfiz	w10, w27, #7, #5
	bfi	w10, w9, #12, #5
	mov	w9, #49
	movk	w9, #2, lsl #16
	orr	w9, w10, w9
LBB2_620:                               ;   in Loop: Header=BB2_4 Depth=1
	orr	w9, w9, #0x4
	b	LBB2_584
LBB2_621:                               ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	lsl	w9, w9, #12
	bfi	w9, w27, #7, #5
	mov	w10, #53
LBB2_622:                               ;   in Loop: Header=BB2_4 Depth=1
	orr	w20, w9, w10
LBB2_623:                               ;   in Loop: Header=BB2_4 Depth=1
	str	w20, [sp, #104]
	ldr	x0, [x8]
	bl	_parse64
	and	w8, w0, #0xffff
	sub	w8, w8, #1, lsl #12             ; =4096
	lsr	w8, w8, #13
	cmp	w8, #6
	b.hi	LBB2_625
; %bb.624:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x19, lsl #5
	ldr	w9, [x8, #8]
	cbnz	w9, LBB2_983
LBB2_625:                               ;   in Loop: Header=BB2_4 Depth=1
	bfi	w20, w0, #19, #13
	str	w20, [sp, #104]
LBB2_626:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #7
LBB2_627:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #9
	ldr	x27, [sp, #72]                  ; 8-byte Folded Reload
	mov	x23, x26
	b.eq	LBB2_232
	b	LBB2_966
LBB2_628:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.629:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.630:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #8
	b.ne	LBB2_969
; %bb.631:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #4
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.632:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x8, x24, #5
	ldr	x9, [x25]
	add	x10, x9, x8, lsl #5
	ldr	w10, [x10, #8]
	cbz	w10, LBB2_759
; %bb.633:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #11
	b.eq	LBB2_660
; %bb.634:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #9
	b.ne	LBB2_967
; %bb.635:                              ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	ubfiz	w10, w27, #7, #5
	bfi	w10, w9, #12, #5
	mov	w9, #49
	movk	w9, #2, lsl #16
	orr	w9, w10, w9
	add	w9, w9, #32, lsl #12            ; =131072
	b	LBB2_584
LBB2_636:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #6
	add	x8, x9, x19, lsl #5
	ldr	w10, [x8, #8]
	cbz	w10, LBB2_626
; %bb.637:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.eq	LBB2_674
; %bb.638:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_975
; %bb.639:                              ;   in Loop: Header=BB2_4 Depth=1
	strb	w0, [sp, #106]
	mov	w9, #562
	b	LBB2_709
LBB2_640:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.641:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.642:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #8
	b.ne	LBB2_969
; %bb.643:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #4
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.644:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x8, x24, #5
	ldr	x9, [x25]
	add	x10, x9, x8, lsl #5
	ldr	w10, [x10, #8]
	cbz	w10, LBB2_759
; %bb.645:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #11
	b.eq	LBB2_683
; %bb.646:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #9
	b.ne	LBB2_967
; %bb.647:                              ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	ubfiz	w10, w27, #7, #5
	bfi	w10, w9, #12, #5
	mov	w9, #53
	movk	w9, #4, lsl #16
	b	LBB2_583
LBB2_648:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #6
	add	x8, x9, x19, lsl #5
	ldr	w10, [x8, #8]
	cbz	w10, LBB2_626
; %bb.649:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.eq	LBB2_687
; %bb.650:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_975
; %bb.651:                              ;   in Loop: Header=BB2_4 Depth=1
	strb	w0, [sp, #106]
	mov	w9, #566
	b	LBB2_709
LBB2_652:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.653:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.654:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #8
	b.ne	LBB2_969
; %bb.655:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #4
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.656:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x8, x24, #5
	ldr	x9, [x25]
	add	x10, x9, x8, lsl #5
	ldr	w10, [x10, #8]
	cbz	w10, LBB2_759
; %bb.657:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #11
	b.eq	LBB2_700
; %bb.658:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #9
	b.ne	LBB2_967
; %bb.659:                              ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	ubfiz	w10, w27, #7, #5
	bfi	w10, w9, #12, #5
	mov	w9, #49
	movk	w9, #6, lsl #16
	b	LBB2_583
LBB2_660:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #6
	add	x8, x9, x19, lsl #5
	ldr	w10, [x8, #8]
	cbz	w10, LBB2_626
; %bb.661:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.eq	LBB2_704
; %bb.662:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_975
; %bb.663:                              ;   in Loop: Header=BB2_4 Depth=1
	strb	w0, [sp, #106]
	mov	w9, #1074
	b	LBB2_709
LBB2_664:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.665:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.666:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.667:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #4
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.668:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #5
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #8
	b.ne	LBB2_969
; %bb.669:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #6
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.670:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x28, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x8, x24, #7
	ldr	x9, [x25]
	add	x10, x9, x8, lsl #5
	ldr	w10, [x10, #8]
	cbz	w10, LBB2_759
; %bb.671:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #11
	b.eq	LBB2_710
; %bb.672:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #9
	b.ne	LBB2_967
; %bb.673:                              ;   in Loop: Header=BB2_4 Depth=1
	ubfiz	w9, w28, #14, #5
	bfi	w9, w27, #9, #5
	bfi	w9, w0, #19, #5
	mov	w10, #65
	b	LBB2_699
LBB2_674:                               ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	lsl	w9, w9, #12
	bfi	w9, w27, #7, #5
	mov	w10, #49
	movk	w10, #2, lsl #16
	b	LBB2_622
LBB2_675:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.676:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.677:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #8
	b.ne	LBB2_969
; %bb.678:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #4
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.679:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x8, x24, #5
	ldr	x9, [x25]
	add	x10, x9, x8, lsl #5
	ldr	w10, [x10, #8]
	cbz	w10, LBB2_759
; %bb.680:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #11
	b.eq	LBB2_705
; %bb.681:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #9
	b.ne	LBB2_967
; %bb.682:                              ;   in Loop: Header=BB2_4 Depth=1
	ubfiz	w9, w0, #12, #5
	bfi	w9, w27, #7, #5
	mov	w10, #49
	movk	w10, #6, lsl #16
	orr	w9, w9, w10
	b	LBB2_620
LBB2_683:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #6
	add	x8, x9, x19, lsl #5
	ldr	w10, [x8, #8]
	cbz	w10, LBB2_626
; %bb.684:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.eq	LBB2_714
; %bb.685:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_975
; %bb.686:                              ;   in Loop: Header=BB2_4 Depth=1
	strb	w0, [sp, #106]
	mov	w9, #1078
	b	LBB2_709
LBB2_687:                               ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	lsl	w9, w9, #12
	bfi	w9, w27, #7, #5
	mov	w10, #49
	movk	w10, #2, lsl #16
LBB2_688:                               ;   in Loop: Header=BB2_4 Depth=1
	orr	w9, w9, w10
	orr	w20, w9, #0x4
	b	LBB2_623
LBB2_689:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.690:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.691:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.692:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #4
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.693:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #5
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #8
	b.ne	LBB2_969
; %bb.694:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #6
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.695:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x28, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x8, x24, #7
	ldr	x9, [x25]
	add	x10, x9, x8, lsl #5
	ldr	w10, [x10, #8]
	cbz	w10, LBB2_759
; %bb.696:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #11
	b.eq	LBB2_716
; %bb.697:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #9
	b.ne	LBB2_967
; %bb.698:                              ;   in Loop: Header=BB2_4 Depth=1
	ubfiz	w9, w28, #14, #5
	bfi	w9, w27, #9, #5
	bfi	w9, w0, #19, #5
	mov	w10, #69
LBB2_699:                               ;   in Loop: Header=BB2_4 Depth=1
	orr	w9, w9, w10
	b	LBB2_584
LBB2_700:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #6
	add	x8, x9, x19, lsl #5
	ldr	w10, [x8, #8]
	cbz	w10, LBB2_626
; %bb.701:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.eq	LBB2_715
; %bb.702:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_975
; %bb.703:                              ;   in Loop: Header=BB2_4 Depth=1
	strb	w0, [sp, #106]
	mov	w9, #1586
	b	LBB2_709
LBB2_704:                               ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	lsl	w9, w9, #12
	bfi	w9, w27, #7, #5
	mov	w10, #49
	movk	w10, #2, lsl #16
	orr	w9, w9, w10
	add	w20, w9, #32, lsl #12           ; =131072
	b	LBB2_623
LBB2_705:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #6
	add	x8, x9, x19, lsl #5
	ldr	w10, [x8, #8]
	cbz	w10, LBB2_626
; %bb.706:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #4
	b.eq	LBB2_720
; %bb.707:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_975
; %bb.708:                              ;   in Loop: Header=BB2_4 Depth=1
	strb	w0, [sp, #106]
	mov	w9, #1590
LBB2_709:                               ;   in Loop: Header=BB2_4 Depth=1
	bfi	w9, w27, #11, #8
	b	LBB2_600
LBB2_710:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x10, x24, #8
	add	x8, x9, x10, lsl #5
	ldr	w11, [x8, #8]
	cbz	w11, LBB2_734
; %bb.711:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w11, #4
	b.eq	LBB2_731
; %bb.712:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w11, #2
	b.ne	LBB2_968
; %bb.713:                              ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w28, #0x1f
	lsl	w19, w9, #13
	bfi	w19, w27, #8, #5
	and	w9, w0, #0x1f
	bfi	w19, w9, #19, #5
	ldr	x0, [x8]
	bl	_parse_reg
	bfi	w19, w0, #27, #5
	mov	w8, #66
	b	LBB2_733
LBB2_714:                               ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	lsl	w9, w9, #12
	bfi	w9, w27, #7, #5
	mov	w10, #53
	movk	w10, #4, lsl #16
	b	LBB2_622
LBB2_715:                               ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	lsl	w9, w9, #12
	bfi	w9, w27, #7, #5
	mov	w10, #49
	movk	w10, #6, lsl #16
	b	LBB2_622
LBB2_716:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x10, x24, #8
	add	x8, x9, x10, lsl #5
	ldr	w11, [x8, #8]
	cbz	w11, LBB2_734
; %bb.717:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w11, #4
	b.eq	LBB2_732
; %bb.718:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w11, #2
	b.ne	LBB2_968
; %bb.719:                              ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w28, #0x1f
	lsl	w19, w9, #13
	bfi	w19, w27, #8, #5
	and	w9, w0, #0x1f
	bfi	w19, w9, #19, #5
	ldr	x0, [x8]
	bl	_parse_reg
	bfi	w19, w0, #27, #5
	mov	w8, #70
	b	LBB2_733
LBB2_720:                               ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	lsl	w9, w9, #12
	bfi	w9, w27, #7, #5
	mov	w10, #49
	movk	w10, #6, lsl #16
	b	LBB2_688
LBB2_721:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.722:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.723:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.724:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #4
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.725:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #5
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #8
	b.ne	LBB2_969
; %bb.726:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #6
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.727:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x28, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x8, x24, #7
	ldr	x9, [x25]
	add	x10, x9, x8, lsl #5
	ldr	w10, [x10, #8]
	cbz	w10, LBB2_759
; %bb.728:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #11
	b.eq	LBB2_745
; %bb.729:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #9
	b.ne	LBB2_967
; %bb.730:                              ;   in Loop: Header=BB2_4 Depth=1
	ubfiz	w9, w28, #14, #5
	bfi	w9, w27, #9, #5
	bfi	w9, w0, #19, #5
	mov	w10, #193
	b	LBB2_699
LBB2_731:                               ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	ubfiz	w19, w28, #14, #5
	bfi	w19, w27, #9, #5
	bfi	w19, w9, #19, #5
	ldr	x0, [x8]
	bl	_parse64
	bfi	w19, w0, #24, #8
	mov	w8, #65
	b	LBB2_733
LBB2_732:                               ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	ubfiz	w19, w28, #14, #5
	bfi	w19, w27, #9, #5
	bfi	w19, w9, #19, #5
	ldr	x0, [x8]
	bl	_parse64
	bfi	w19, w0, #24, #8
	mov	w8, #69
LBB2_733:                               ;   in Loop: Header=BB2_4 Depth=1
	orr	w8, w19, w8
	str	w8, [sp, #104]
LBB2_734:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #9
	b	LBB2_627
LBB2_735:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.736:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.737:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.738:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #4
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.739:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #5
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #8
	b.ne	LBB2_969
; %bb.740:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #6
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.741:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x28, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x8, x24, #7
	ldr	x9, [x25]
	add	x10, x9, x8, lsl #5
	ldr	w10, [x10, #8]
	cbz	w10, LBB2_759
; %bb.742:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #11
	b.eq	LBB2_760
; %bb.743:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #9
	b.ne	LBB2_967
; %bb.744:                              ;   in Loop: Header=BB2_4 Depth=1
	ubfiz	w9, w28, #14, #5
	bfi	w9, w27, #9, #5
	bfi	w9, w0, #19, #5
	mov	w10, #321
	b	LBB2_699
LBB2_745:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x10, x24, #8
	add	x8, x9, x10, lsl #5
	ldr	w11, [x8, #8]
	cbz	w11, LBB2_734
; %bb.746:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w11, #4
	b.eq	LBB2_764
; %bb.747:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w11, #2
	b.ne	LBB2_968
; %bb.748:                              ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w28, #0x1f
	lsl	w19, w9, #13
	bfi	w19, w27, #8, #5
	and	w9, w0, #0x1f
	bfi	w19, w9, #19, #5
	ldr	x0, [x8]
	bl	_parse_reg
	bfi	w19, w0, #27, #5
	mov	w8, #66
	movk	w8, #512, lsl #16
	b	LBB2_733
LBB2_749:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.750:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.751:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.752:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #4
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.753:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #5
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #8
	b.ne	LBB2_969
; %bb.754:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #6
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.755:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x28, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x8, x24, #7
	ldr	x9, [x25]
	add	x10, x9, x8, lsl #5
	ldr	w10, [x10, #8]
	cbz	w10, LBB2_759
; %bb.756:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #11
	b.eq	LBB2_769
; %bb.757:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #9
	b.ne	LBB2_967
; %bb.758:                              ;   in Loop: Header=BB2_4 Depth=1
	ubfiz	w9, w28, #14, #5
	bfi	w9, w27, #9, #5
	bfi	w9, w0, #19, #5
	mov	w10, #449
	b	LBB2_699
LBB2_759:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x24, x8
	b	LBB2_355
LBB2_760:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x10, x24, #8
	add	x8, x9, x10, lsl #5
	ldr	w11, [x8, #8]
	cbz	w11, LBB2_734
; %bb.761:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w11, #4
	b.eq	LBB2_777
; %bb.762:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w11, #2
	b.ne	LBB2_968
; %bb.763:                              ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w28, #0x1f
	lsl	w19, w9, #13
	bfi	w19, w27, #8, #5
	and	w9, w0, #0x1f
	bfi	w19, w9, #19, #5
	ldr	x0, [x8]
	bl	_parse_reg
	bfi	w19, w0, #27, #5
	mov	w8, #66
	movk	w8, #1024, lsl #16
	b	LBB2_733
LBB2_764:                               ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	ubfiz	w19, w28, #14, #5
	bfi	w19, w27, #9, #5
	bfi	w19, w9, #19, #5
	ldr	x0, [x8]
	bl	_parse64
	bfi	w19, w0, #24, #8
	mov	w8, #193
	b	LBB2_733
LBB2_765:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.766:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.767:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #3
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #1
	b.ne	LBB2_929
; %bb.768:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #3
	b	LBB2_353
LBB2_769:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x10, x24, #8
	add	x8, x9, x10, lsl #5
	ldr	w11, [x8, #8]
	cbz	w11, LBB2_734
; %bb.770:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w11, #4
	b.eq	LBB2_790
; %bb.771:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w11, #2
	b.ne	LBB2_968
; %bb.772:                              ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w28, #0x1f
	lsl	w19, w9, #13
	bfi	w19, w27, #8, #5
	and	w9, w0, #0x1f
	bfi	w19, w9, #19, #5
	ldr	x0, [x8]
	bl	_parse_reg
	bfi	w19, w0, #27, #5
	mov	w8, #66
	movk	w8, #1536, lsl #16
	b	LBB2_733
LBB2_773:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.774:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.775:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #3
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #1
	b.ne	LBB2_929
; %bb.776:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #7
	b	LBB2_353
LBB2_777:                               ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	ubfiz	w19, w28, #14, #5
	bfi	w19, w27, #9, #5
	bfi	w19, w9, #19, #5
	ldr	x0, [x8]
	bl	_parse64
	bfi	w19, w0, #24, #8
	mov	w8, #321
	b	LBB2_733
LBB2_778:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.779:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x24, x24, #2
	ldr	x8, [x25]
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #11
	b.ne	LBB2_980
; %bb.780:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #11
	b	LBB2_353
LBB2_781:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.782:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.783:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x20, x24, #3
	add	x8, x8, x20, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #4
	b.ne	LBB2_970
; %bb.784:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse64
	mov	x23, x0
	ldr	x19, [x25]
	add	x8, x19, x24, lsl #5
	ldr	w8, [x8, #136]
	cmp	w8, #11
	b.ne	LBB2_886
; %bb.785:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x20, x24, #5
	add	x8, x19, x20, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #1
	b.ne	LBB2_984
; %bb.786:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x28, [x8]
	mov	x0, x28
Lloh313:
	adrp	x1, l_.str.73@PAGE
Lloh314:
	add	x1, x1, l_.str.73@PAGEOFF
	bl	_strcmp
	cbnz	w0, LBB2_985
; %bb.787:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #6
	add	x8, x19, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #4
	b.ne	LBB2_970
; %bb.788:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse64
	and	w8, w0, #0xff
	cmp	w8, #4
	b.lo	LBB2_887
; %bb.789:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x9, [x25]
	add	x9, x9, x24, lsl #5
	ldr	w10, [x9, #8]
	cbz	w10, LBB2_887
	b	LBB2_978
LBB2_790:                               ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w0, #0x1f
	ubfiz	w19, w28, #14, #5
	bfi	w19, w27, #9, #5
	bfi	w19, w9, #19, #5
	ldr	x0, [x8]
	bl	_parse64
	bfi	w19, w0, #24, #8
	mov	w8, #449
	b	LBB2_733
LBB2_791:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.792:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.793:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x20, x24, #3
	add	x8, x8, x20, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #4
	b.ne	LBB2_970
; %bb.794:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse64
	mov	x23, x0
	ldr	x19, [x25]
	add	x8, x19, x24, lsl #5
	ldr	w8, [x8, #136]
	cmp	w8, #11
	b.ne	LBB2_888
; %bb.795:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x20, x24, #5
	add	x8, x19, x20, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #1
	b.ne	LBB2_984
; %bb.796:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x28, [x8]
	mov	x0, x28
Lloh315:
	adrp	x1, l_.str.73@PAGE
Lloh316:
	add	x1, x1, l_.str.73@PAGEOFF
	bl	_strcmp
	cbnz	w0, LBB2_985
; %bb.797:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #6
	add	x8, x19, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #4
	b.ne	LBB2_970
; %bb.798:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse64
	and	w8, w0, #0xff
	cmp	w8, #4
	b.lo	LBB2_889
; %bb.799:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x9, [x25]
	add	x9, x9, x24, lsl #5
	ldr	w10, [x9, #8]
	cbz	w10, LBB2_889
	b	LBB2_978
LBB2_800:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.801:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.802:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #3
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.803:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse_reg
	ubfiz	w8, w27, #22, #5
	bfi	w8, w0, #27, #5
	mov	w9, #33
	b	LBB2_894
LBB2_804:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x19, x24, #1
	ldr	x8, [x25]
	add	x8, x8, x19, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.805:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	mov	x28, x0
	ldr	x8, [x25]
	add	x9, x8, x24, lsl #5
	ldr	w9, [x9, #72]
	cmp	w9, #11
	b.ne	LBB2_890
; %bb.806:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #3
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.807:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	b	LBB2_891
LBB2_808:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.809:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.810:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #3
	add	x9, x8, x24, lsl #5
	ldr	w10, [x9, #8]
	cbz	w10, LBB2_355
; %bb.811:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	cmp	w10, #4
	b.eq	LBB2_892
; %bb.812:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_972
; %bb.813:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x9]
	bl	_parse_reg
	lsl	w8, w0, #27
	bfi	w8, w27, #22, #5
	mov	w9, #58
	b	LBB2_894
LBB2_814:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.815:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.816:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #3
	add	x9, x8, x24, lsl #5
	ldr	w10, [x9, #8]
	cbz	w10, LBB2_355
; %bb.817:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	cmp	w10, #4
	b.eq	LBB2_893
; %bb.818:                              ;   in Loop: Header=BB2_4 Depth=1
	cmp	w10, #2
	b.ne	LBB2_972
; %bb.819:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x9]
	bl	_parse_reg
	lsl	w8, w0, #27
	bfi	w8, w27, #22, #5
	orr	w8, w8, #0x3e
	b	LBB2_354
LBB2_820:                               ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w8, [x28]
	cmp	w8, #115
	mov	w8, #4
	mov	w9, #4100
	csel	w19, w9, w8, eq
	str	w19, [sp, #104]
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.821:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.822:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.823:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x23, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #4
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.824:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x20, x24, #5
	add	x8, x8, x20, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #4
	b.ne	LBB2_970
; %bb.825:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x28, x0
	ldr	x0, [x8]
	bl	_parse64
	mov	x27, x0
	ldr	x8, [x25]
	tst	x0, #0xc0
	b.eq	LBB2_827
; %bb.826:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x8, x20, lsl #5
	ldr	w10, [x9, #8]
	cbnz	w10, LBB2_971
LBB2_827:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #6
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.828:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #7
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #4
	b.ne	LBB2_970
; %bb.829:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse64
	and	w8, w0, #0xff
	cmp	w8, #64
	b.lo	LBB2_831
; %bb.830:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x9, [x25]
	add	x9, x9, x24, lsl #5
	ldr	w10, [x9, #8]
	cbnz	w10, LBB2_979
LBB2_831:                               ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w19, #0x1000
	and	w10, w23, #0x1f
	bfi	w9, w10, #7, #5
	and	w8, w8, #0x3f
	bfi	w9, w28, #13, #5
	bfi	w9, w27, #26, #6
	bfi	w9, w8, #18, #6
	orr	w8, w9, #0x38
	b	LBB2_354
LBB2_832:                               ;   in Loop: Header=BB2_4 Depth=1
	ldrb	w8, [x28]
	cmp	w8, #115
	mov	w8, #4
	mov	w9, #4100
	csel	w19, w9, w8, eq
	str	w19, [sp, #104]
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.833:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.834:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.835:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x23, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #4
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.836:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x20, x24, #5
	add	x8, x8, x20, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #4
	b.ne	LBB2_970
; %bb.837:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x28, x0
	ldr	x0, [x8]
	bl	_parse64
	mov	x27, x0
	ldr	x8, [x25]
	tst	x0, #0xc0
	b.eq	LBB2_839
; %bb.838:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x8, x20, lsl #5
	ldr	w10, [x9, #8]
	cbnz	w10, LBB2_971
LBB2_839:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #6
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.840:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #7
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #4
	b.ne	LBB2_970
; %bb.841:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse64
	and	w8, w0, #0xff
	cmp	w8, #64
	b.lo	LBB2_843
; %bb.842:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x9, [x25]
	add	x9, x9, x24, lsl #5
	ldr	w10, [x9, #8]
	cbnz	w10, LBB2_979
LBB2_843:                               ;   in Loop: Header=BB2_4 Depth=1
	and	w9, w19, #0x1000
	and	w10, w23, #0x1f
	bfi	w9, w10, #7, #5
	and	w8, w8, #0x3f
	bfi	w9, w28, #13, #5
	bfi	w9, w27, #26, #6
	bfi	w9, w8, #18, #6
	orr	w8, w9, #0x3c
	b	LBB2_354
LBB2_844:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.845:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.846:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.847:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x28, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #4
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.848:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #5
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.849:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	cmp	w19, #0
	cset	w19, ne
	ldr	x0, [x8]
	bl	_parse_reg
	lsl	w8, w19, #8
	b	LBB2_875
LBB2_850:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.851:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.852:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.853:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x28, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #4
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.854:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #5
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.855:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse_reg
	cmp	w19, #0
	mov	w8, #768
	mov	w9, #512
	b	LBB2_874
LBB2_856:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.857:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.858:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.859:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x28, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #4
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.860:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #5
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.861:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse_reg
	cmp	w19, #0
	mov	w8, #1280
	mov	w9, #1024
	b	LBB2_874
LBB2_862:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.863:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.864:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.865:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x28, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #4
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.866:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #5
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.867:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse_reg
	cmp	w19, #0
	mov	w8, #1792
	mov	w9, #1536
	b	LBB2_874
LBB2_868:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.869:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.870:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x9, x24, #3
	add	x8, x8, x9, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.871:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x28, x0
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #4
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.872:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #5
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.873:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x27, x0
	ldr	x0, [x8]
	bl	_parse_reg
	cmp	w19, #0
	mov	w8, #2304
	mov	w9, #2048
LBB2_874:                               ;   in Loop: Header=BB2_4 Depth=1
	csel	w8, w9, w8, eq
LBB2_875:                               ;   in Loop: Header=BB2_4 Depth=1
	bfi	w8, w28, #17, #5
	bfi	w8, w27, #22, #5
	bfi	w8, w0, #27, #5
	b	LBB2_885
LBB2_876:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.877:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.878:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #3
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.879:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x28, x0
	ldr	x0, [x8]
	bl	_parse_reg
	cmp	w27, #0
	mov	w8, #2816
	mov	w9, #2560
	b	LBB2_884
LBB2_880:                               ;   in Loop: Header=BB2_4 Depth=1
	add	x8, x24, #1
	ldr	x9, [x25]
	add	x8, x9, x8, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.881:                              ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x8]
	bl	_parse_reg
	add	x9, x24, #2
	ldr	x8, [x25]
	add	x9, x8, x9, lsl #5
	ldr	w10, [x9, #8]
	cmp	w10, #11
	b.ne	LBB2_965
; %bb.882:                              ;   in Loop: Header=BB2_4 Depth=1
	add	x24, x24, #3
	add	x8, x8, x24, lsl #5
	ldr	w9, [x8, #8]
	cmp	w9, #2
	b.ne	LBB2_963
; %bb.883:                              ;   in Loop: Header=BB2_4 Depth=1
	mov	x28, x0
	ldr	x0, [x8]
	bl	_parse_reg
	cmp	w27, #0
	mov	w8, #3328
	mov	w9, #3072
LBB2_884:                               ;   in Loop: Header=BB2_4 Depth=1
	csel	w8, w9, w8, eq
	and	w9, w0, #0x1f
	bfi	w8, w28, #17, #5
	bfi	w8, w9, #22, #5
LBB2_885:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w9, #74
	b	LBB2_894
LBB2_886:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #0
	mov	x24, x20
LBB2_887:                               ;   in Loop: Header=BB2_4 Depth=1
	and	w8, w8, #0x3
	lsl	w8, w8, #9
	bfi	w8, w27, #11, #5
	bfi	w8, w23, #16, #16
	orr	w8, w8, #0xf
	b	LBB2_354
LBB2_888:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	w8, #0
	mov	x24, x20
LBB2_889:                               ;   in Loop: Header=BB2_4 Depth=1
	and	w8, w8, #0x3
	lsl	w8, w8, #9
	bfi	w8, w27, #11, #5
	bfi	w8, w23, #16, #16
	mov	w9, #271
	b	LBB2_894
LBB2_890:                               ;   in Loop: Header=BB2_4 Depth=1
	mov	x0, x28
	mov	x24, x19
LBB2_891:                               ;   in Loop: Header=BB2_4 Depth=1
	cmp	w27, #0
	cset	w8, ne
	ubfiz	w9, w28, #22, #5
	bfi	w9, w8, #2, #1
	bfi	w9, w0, #27, #5
	mov	w8, #129
	orr	w8, w9, w8
	b	LBB2_354
LBB2_892:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x9]
	bl	_parse64
	lsl	w8, w27, #27
	bfi	w8, w0, #7, #20
	mov	w9, #75
	b	LBB2_894
LBB2_893:                               ;   in Loop: Header=BB2_4 Depth=1
	ldr	x0, [x9]
	bl	_parse64
	lsl	w8, w27, #27
	bfi	w8, w0, #7, #20
	mov	w9, #79
LBB2_894:                               ;   in Loop: Header=BB2_4 Depth=1
	orr	w8, w8, w9
	b	LBB2_354
LBB2_895:
	mov	x28, #0
	str	xzr, [sp, #40]                  ; 8-byte Folded Spill
	mov	x22, #0
	stp	xzr, xzr, [sp, #56]             ; 16-byte Folded Spill
LBB2_896:
	ldr	x19, [x27, #8]
	cbz	x19, LBB2_904
; %bb.897:
	mov	x20, #0
	mov	w21, #24
	b	LBB2_900
LBB2_898:                               ;   in Loop: Header=BB2_900 Depth=1
	madd	x8, x20, x21, x23
	ldr	w9, [x8, #20]
	orr	w9, w9, #0x1
	str	w9, [x8, #20]
LBB2_899:                               ;   in Loop: Header=BB2_900 Depth=1
	add	x20, x20, #1
	cmp	x20, x19
	b.eq	LBB2_904
LBB2_900:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB2_902 Depth 2
	cbz	x28, LBB2_899
; %bb.901:                              ;   in Loop: Header=BB2_900 Depth=1
	ldr	x23, [x27]
	mul	x8, x20, x21
	ldr	x25, [x23, x8]
	ldr	x24, [sp, #40]                  ; 8-byte Folded Reload
	mov	x26, x28
LBB2_902:                               ;   Parent Loop BB2_900 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	x1, [x24]
	mov	x0, x25
	bl	_strcmp
	cbz	w0, LBB2_898
; %bb.903:                              ;   in Loop: Header=BB2_902 Depth=2
	add	x24, x24, #8
	subs	x26, x26, #1
	b.ne	LBB2_902
	b	LBB2_899
LBB2_904:
	ldr	x9, [sp, #48]                   ; 8-byte Folded Reload
	ldr	x8, [x9, #8]
	cbz	x8, LBB2_926
; %bb.905:
	mov	x26, #0
	mov	x27, #0
	mov	x19, #0
	mov	x28, #0
	mov	x24, #0
	b	LBB2_908
LBB2_906:                               ;   in Loop: Header=BB2_908 Depth=1
	mov	w8, #24
	madd	x8, x28, x8, x24
	stp	x25, x23, [x8]
	add	x28, x28, #1
	stp	w20, w21, [x8, #16]
LBB2_907:                               ;   in Loop: Header=BB2_908 Depth=1
	ldr	x9, [sp, #48]                   ; 8-byte Folded Reload
	add	x27, x27, #1
	ldr	x8, [x9, #8]
	add	x26, x26, #24
	cmp	x27, x8
	b.hs	LBB2_927
LBB2_908:                               ; =>This Inner Loop Header: Depth=1
	ldr	x8, [x9]
	add	x8, x8, x26
	ldp	x25, x23, [x8]
	ldp	w20, w21, [x8, #16]
	ldr	x8, [sp, #72]                   ; 8-byte Folded Reload
	ldr	q0, [x8]
	str	q0, [sp, #80]
	ldr	x8, [x8, #16]
	str	x8, [sp, #96]
	add	x8, sp, #104
	add	x0, sp, #80
	mov	x1, x25
	bl	_find_symbol
	ldr	x8, [sp, #112]
	cmn	x8, #1
	b.eq	LBB2_916
; %bb.909:                              ;   in Loop: Header=BB2_908 Depth=1
	cmp	w20, #2
	b.eq	LBB2_922
; %bb.910:                              ;   in Loop: Header=BB2_908 Depth=1
	cmp	w20, #1
	b.eq	LBB2_919
; %bb.911:                              ;   in Loop: Header=BB2_908 Depth=1
	cbnz	w20, LBB2_907
; %bb.912:                              ;   in Loop: Header=BB2_908 Depth=1
	ldr	x9, [sp, #64]                   ; 8-byte Folded Reload
	str	x8, [x9, x23]
	cmp	x28, x19
	b.lo	LBB2_915
; %bb.913:                              ;   in Loop: Header=BB2_908 Depth=1
	lsl	x8, x19, #1
	cmp	x19, #0
	mov	w9, #256
	csel	x19, x9, x8, eq
	add	x8, x19, x19, lsl #1
	lsl	x1, x8, #3
	mov	x0, x24
	bl	_realloc
	cbz	x0, LBB2_941
; %bb.914:                              ;   in Loop: Header=BB2_908 Depth=1
	mov	x24, x0
LBB2_915:                               ;   in Loop: Header=BB2_908 Depth=1
	mov	w8, #24
	madd	x8, x28, x8, x24
	stp	x25, x23, [x8]
	add	x28, x28, #1
	stp	wzr, w21, [x8, #16]
	b	LBB2_907
LBB2_916:                               ;   in Loop: Header=BB2_908 Depth=1
	cmp	x28, x19
	b.lo	LBB2_906
; %bb.917:                              ;   in Loop: Header=BB2_908 Depth=1
	lsl	x8, x19, #1
	cmp	x19, #0
	mov	w9, #256
	csel	x19, x9, x8, eq
	add	x8, x19, x19, lsl #1
	lsl	x1, x8, #3
	mov	x0, x24
	bl	_realloc
	cbz	x0, LBB2_936
; %bb.918:                              ;   in Loop: Header=BB2_908 Depth=1
	mov	x24, x0
	b	LBB2_906
LBB2_919:                               ;   in Loop: Header=BB2_908 Depth=1
	sub	w11, w8, w23
	tst	w11, #0x3
	b.ne	LBB2_961
; %bb.920:                              ;   in Loop: Header=BB2_908 Depth=1
	ldr	x9, [sp, #64]                   ; 8-byte Folded Reload
	add	x9, x9, x23
	asr	w10, w11, #2
	mov	w12, #-67108864
	add	w11, w11, w12
	lsr	w11, w11, #27
	cmp	w11, #30
	b.ls	LBB2_962
; %bb.921:                              ;   in Loop: Header=BB2_908 Depth=1
	ldr	w8, [x9]
	bfi	w8, w10, #7, #25
	b	LBB2_925
LBB2_922:                               ;   in Loop: Header=BB2_908 Depth=1
	sub	w11, w8, w23
	tst	w11, #0x3
	b.ne	LBB2_961
; %bb.923:                              ;   in Loop: Header=BB2_908 Depth=1
	ldr	x9, [sp, #64]                   ; 8-byte Folded Reload
	add	x9, x9, x23
	asr	w10, w11, #2
	sub	w11, w11, #512, lsl #12         ; =2097152
	lsr	w11, w11, #22
	cmp	w11, #1022
	b.ls	LBB2_962
; %bb.924:                              ;   in Loop: Header=BB2_908 Depth=1
	ldr	w8, [x9]
	bfi	w8, w10, #12, #20
LBB2_925:                               ;   in Loop: Header=BB2_908 Depth=1
	str	w8, [x9]
	b	LBB2_907
LBB2_926:
	mov	x24, #0
	mov	x28, #0
	mov	x19, #0
LBB2_927:
	stp	x24, x28, [x9]
	str	x19, [x9, #16]
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	ldr	x10, [sp, #64]                  ; 8-byte Folded Reload
	ldr	x9, [sp, #56]                   ; 8-byte Folded Reload
	stp	x10, x9, [x8]
	str	x22, [x8, #16]
LBB2_928:
	ldp	x29, x30, [sp, #208]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #192]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #176]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #160]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #144]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #128]            ; 16-byte Folded Reload
	add	sp, sp, #224
	ret
LBB2_929:
	ldr	x9, [x8, #16]
	ldr	x10, [x8]
	ldr	w8, [x8, #24]
	stp	x8, x10, [sp, #8]
	str	x9, [sp]
Lloh317:
	adrp	x0, l_.str.101@PAGE
Lloh318:
	add	x0, x0, l_.str.101@PAGEOFF
LBB2_930:
	bl	_printf
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	stp	xzr, xzr, [x8]
	str	xzr, [x8, #16]
	b	LBB2_928
LBB2_931:
	ldr	x9, [x8, #16]
	ldr	x10, [x8]
	ldr	w8, [x8, #24]
	stp	x8, x10, [sp, #8]
	str	x9, [sp]
Lloh319:
	adrp	x0, l_.str.142@PAGE
Lloh320:
	add	x0, x0, l_.str.142@PAGEOFF
	b	LBB2_933
LBB2_932:
	ldr	x9, [x8, #16]
	ldr	x10, [x8]
	ldr	w8, [x8, #24]
	stp	x8, x10, [sp, #8]
	str	x9, [sp]
Lloh321:
	adrp	x0, l_.str.105@PAGE
Lloh322:
	add	x0, x0, l_.str.105@PAGEOFF
LBB2_933:
	bl	_printf
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	stp	xzr, xzr, [x8, #8]
	str	xzr, [x8]
	b	LBB2_928
LBB2_934:
	ldr	x9, [x8, #16]
	ldr	x10, [x8]
	ldr	w8, [x8, #24]
	stp	x8, x10, [sp, #8]
	str	x9, [sp]
Lloh323:
	adrp	x0, l_.str.150@PAGE
Lloh324:
	add	x0, x0, l_.str.150@PAGEOFF
	b	LBB2_933
LBB2_935:
	ldr	x9, [x8, #16]
	ldr	x10, [x8]
	ldr	w8, [x8, #24]
	stp	x8, x10, [sp, #8]
	str	x9, [sp]
Lloh325:
	adrp	x0, l_.str.101@PAGE
Lloh326:
	add	x0, x0, l_.str.101@PAGEOFF
	b	LBB2_933
LBB2_936:
	bl	_compile.cold.1
LBB2_937:
	add	x9, x26, x19, lsl #5
	ldr	x10, [x9, #16]
	ldr	x8, [x8]
	ldr	w9, [x9, #24]
	stp	x9, x8, [sp, #8]
	str	x10, [sp]
Lloh327:
	adrp	x0, l_.str.148@PAGE
Lloh328:
	add	x0, x0, l_.str.148@PAGEOFF
	b	LBB2_933
LBB2_938:
	bl	_compile.cold.24
LBB2_939:
	bl	_compile.cold.3
LBB2_940:
	bl	_compile.cold.8
LBB2_941:
	bl	_compile.cold.2
LBB2_942:
	add	x8, x26, x24, lsl #5
	ldr	x9, [x8, #16]
	ldr	w8, [x8, #24]
	stp	x8, x28, [sp, #8]
	str	x9, [sp]
Lloh329:
	adrp	x0, l_.str.157@PAGE
Lloh330:
	add	x0, x0, l_.str.157@PAGEOFF
	b	LBB2_933
LBB2_943:
	bl	_compile.cold.6
LBB2_944:
	bl	_compile.cold.4
LBB2_945:
	bl	_compile.cold.5
LBB2_946:
	bl	_compile.cold.7
LBB2_947:
	bl	_compile.cold.9
LBB2_948:
	bl	_compile.cold.10
LBB2_949:
	bl	_compile.cold.11
LBB2_950:
	bl	_compile.cold.19
LBB2_951:
	bl	_compile.cold.15
LBB2_952:
	bl	_compile.cold.20
LBB2_953:
	bl	_compile.cold.21
LBB2_954:
	bl	_compile.cold.16
LBB2_955:
	bl	_compile.cold.12
LBB2_956:
	bl	_compile.cold.14
LBB2_957:
	bl	_compile.cold.13
LBB2_958:
	bl	_compile.cold.23
LBB2_959:
	bl	_compile.cold.18
LBB2_960:
	bl	_compile.cold.17
LBB2_961:
Lloh331:
	adrp	x8, ___stderrp@GOTPAGE
Lloh332:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh333:
	ldr	x3, [x8]
Lloh334:
	adrp	x0, l_.str.160@PAGE
Lloh335:
	add	x0, x0, l_.str.160@PAGEOFF
	mov	w1, #28
	mov	w2, #1
	bl	_fwrite
	mov	w0, #1
	bl	_exit
LBB2_962:
Lloh336:
	adrp	x11, ___stderrp@GOTPAGE
Lloh337:
	ldr	x11, [x11, ___stderrp@GOTPAGEOFF]
Lloh338:
	ldr	x0, [x11]
	stp	x9, x8, [sp, #8]
	str	x10, [sp]
Lloh339:
	adrp	x1, l_.str.161@PAGE
Lloh340:
	add	x1, x1, l_.str.161@PAGEOFF
	bl	_fprintf
	mov	w0, #1
	bl	_exit
LBB2_963:
	ldr	x9, [x8, #16]
	ldr	x10, [x8]
	ldr	w8, [x8, #24]
	stp	x8, x10, [sp, #8]
	str	x9, [sp]
Lloh341:
	adrp	x0, l_.str.38@PAGE
Lloh342:
	add	x0, x0, l_.str.38@PAGEOFF
	b	LBB2_930
LBB2_964:
	bl	_compile.cold.22
LBB2_965:
	ldr	x8, [x9, #16]
	ldr	x10, [x9]
	ldr	w9, [x9, #24]
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
	b	LBB2_981
LBB2_966:
	ldr	x9, [x8, #16]
	ldr	x10, [x8]
	ldr	w8, [x8, #24]
	stp	x8, x10, [sp, #8]
	str	x9, [sp]
Lloh343:
	adrp	x0, l_.str.80@PAGE
Lloh344:
	add	x0, x0, l_.str.80@PAGEOFF
	b	LBB2_930
LBB2_967:
	add	x8, x9, x8, lsl #5
	ldr	x9, [x8, #16]
	ldr	x10, [x8]
	ldr	w8, [x8, #24]
	stp	x8, x10, [sp, #8]
	str	x9, [sp]
Lloh345:
	adrp	x0, l_.str.81@PAGE
Lloh346:
	add	x0, x0, l_.str.81@PAGEOFF
	b	LBB2_930
LBB2_968:
	add	x9, x9, x10, lsl #5
	b	LBB2_976
LBB2_969:
	ldr	x8, [x9, #16]
	ldr	x10, [x9]
	ldr	w9, [x9, #24]
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh347:
	adrp	x0, l_.str.79@PAGE
Lloh348:
	add	x0, x0, l_.str.79@PAGEOFF
	b	LBB2_930
LBB2_970:
	ldr	x9, [x8, #16]
	ldr	x10, [x8]
	ldr	w8, [x8, #24]
	stp	x8, x10, [sp, #8]
	str	x9, [sp]
Lloh349:
	adrp	x0, l_.str.105@PAGE
Lloh350:
	add	x0, x0, l_.str.105@PAGEOFF
	b	LBB2_930
LBB2_971:
	ldr	x8, [x9, #16]
	ldr	x10, [x9]
	ldr	w9, [x9, #24]
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh351:
	adrp	x0, l_.str.116@PAGE
Lloh352:
	add	x0, x0, l_.str.116@PAGEOFF
	b	LBB2_930
LBB2_972:
	add	x8, x8, x24, lsl #5
	b	LBB2_974
LBB2_973:
	add	x8, x8, x19, lsl #5
LBB2_974:
	ldr	x10, [x8, #16]
	ldr	x9, [x9]
	ldr	w8, [x8, #24]
	stp	x8, x9, [sp, #8]
	b	LBB2_977
LBB2_975:
	add	x9, x9, x19, lsl #5
LBB2_976:
	ldr	x10, [x9, #16]
	ldr	x8, [x8]
	ldr	w9, [x9, #24]
	stp	x9, x8, [sp, #8]
LBB2_977:
	str	x10, [sp]
Lloh353:
	adrp	x0, l_.str.65@PAGE
Lloh354:
	add	x0, x0, l_.str.65@PAGEOFF
	b	LBB2_930
LBB2_978:
	ldr	x8, [x9, #16]
	ldr	x10, [x9]
	ldr	w9, [x9, #24]
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh355:
	adrp	x0, l_.str.107@PAGE
Lloh356:
	add	x0, x0, l_.str.107@PAGEOFF
	b	LBB2_930
LBB2_979:
	ldr	x8, [x9, #16]
	ldr	x10, [x9]
	ldr	w9, [x9, #24]
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh357:
	adrp	x0, l_.str.117@PAGE
Lloh358:
	add	x0, x0, l_.str.117@PAGEOFF
	b	LBB2_930
LBB2_980:
	ldr	x9, [x8, #16]
	ldr	x10, [x8]
	ldr	w8, [x8, #24]
	stp	x8, x10, [sp, #8]
	str	x9, [sp]
LBB2_981:
Lloh359:
	adrp	x0, l_.str.62@PAGE
Lloh360:
	add	x0, x0, l_.str.62@PAGEOFF
	b	LBB2_930
LBB2_982:
	add	x8, x8, x24, lsl #5
	ldr	x10, [x8, #16]
	ldr	x9, [x9]
	ldr	w8, [x8, #24]
	stp	x8, x9, [sp, #8]
	str	x10, [sp]
Lloh361:
	adrp	x0, l_.str.64@PAGE
Lloh362:
	add	x0, x0, l_.str.64@PAGEOFF
	b	LBB2_930
LBB2_983:
	ldr	x9, [x8, #16]
	ldr	x10, [x8]
	ldr	w8, [x8, #24]
	stp	x8, x10, [sp, #8]
	str	x9, [sp]
Lloh363:
	adrp	x0, l_.str.63@PAGE
Lloh364:
	add	x0, x0, l_.str.63@PAGEOFF
	b	LBB2_930
LBB2_984:
	ldr	x9, [x8, #16]
	ldr	x10, [x8]
	ldr	w8, [x8, #24]
	str	x10, [sp, #16]
	b	LBB2_986
LBB2_985:
	add	x8, x19, x20, lsl #5
	ldr	x9, [x8, #16]
	ldr	w8, [x8, #24]
	str	x28, [sp, #16]
LBB2_986:
	stp	x9, x8, [sp]
Lloh365:
	adrp	x0, l_.str.106@PAGE
Lloh366:
	add	x0, x0, l_.str.106@PAGEOFF
	b	LBB2_930
	.loh AdrpAdd	Lloh25, Lloh26
	.loh AdrpAdd	Lloh23, Lloh24
	.loh AdrpAdd	Lloh27, Lloh28
	.loh AdrpAdd	Lloh29, Lloh30
	.loh AdrpAdd	Lloh31, Lloh32
	.loh AdrpAdd	Lloh33, Lloh34
	.loh AdrpAdd	Lloh35, Lloh36
	.loh AdrpAdd	Lloh37, Lloh38
	.loh AdrpAdd	Lloh39, Lloh40
	.loh AdrpAdd	Lloh41, Lloh42
	.loh AdrpAdd	Lloh43, Lloh44
	.loh AdrpAdd	Lloh45, Lloh46
	.loh AdrpAdd	Lloh47, Lloh48
	.loh AdrpAdd	Lloh49, Lloh50
	.loh AdrpAdd	Lloh51, Lloh52
	.loh AdrpAdd	Lloh53, Lloh54
	.loh AdrpAdd	Lloh55, Lloh56
	.loh AdrpAdd	Lloh57, Lloh58
	.loh AdrpAdd	Lloh59, Lloh60
	.loh AdrpAdd	Lloh61, Lloh62
	.loh AdrpAdd	Lloh63, Lloh64
	.loh AdrpAdd	Lloh65, Lloh66
	.loh AdrpAdd	Lloh67, Lloh68
	.loh AdrpAdd	Lloh69, Lloh70
	.loh AdrpAdd	Lloh71, Lloh72
	.loh AdrpAdd	Lloh73, Lloh74
	.loh AdrpAdd	Lloh75, Lloh76
	.loh AdrpAdd	Lloh77, Lloh78
	.loh AdrpAdd	Lloh79, Lloh80
	.loh AdrpAdd	Lloh81, Lloh82
	.loh AdrpAdd	Lloh83, Lloh84
	.loh AdrpAdd	Lloh85, Lloh86
	.loh AdrpAdd	Lloh87, Lloh88
	.loh AdrpAdd	Lloh89, Lloh90
	.loh AdrpAdd	Lloh91, Lloh92
	.loh AdrpAdd	Lloh93, Lloh94
	.loh AdrpAdd	Lloh95, Lloh96
	.loh AdrpAdd	Lloh97, Lloh98
	.loh AdrpAdd	Lloh99, Lloh100
	.loh AdrpAdd	Lloh101, Lloh102
	.loh AdrpAdd	Lloh103, Lloh104
	.loh AdrpAdd	Lloh105, Lloh106
	.loh AdrpAdd	Lloh107, Lloh108
	.loh AdrpAdd	Lloh109, Lloh110
	.loh AdrpAdd	Lloh111, Lloh112
	.loh AdrpAdd	Lloh113, Lloh114
	.loh AdrpAdd	Lloh115, Lloh116
	.loh AdrpAdd	Lloh117, Lloh118
	.loh AdrpAdd	Lloh119, Lloh120
	.loh AdrpAdd	Lloh121, Lloh122
	.loh AdrpAdd	Lloh123, Lloh124
	.loh AdrpAdd	Lloh125, Lloh126
	.loh AdrpAdd	Lloh127, Lloh128
	.loh AdrpAdd	Lloh129, Lloh130
	.loh AdrpAdd	Lloh131, Lloh132
	.loh AdrpAdd	Lloh133, Lloh134
	.loh AdrpAdd	Lloh135, Lloh136
	.loh AdrpAdd	Lloh137, Lloh138
	.loh AdrpAdd	Lloh139, Lloh140
	.loh AdrpAdd	Lloh141, Lloh142
	.loh AdrpAdd	Lloh143, Lloh144
	.loh AdrpAdd	Lloh145, Lloh146
	.loh AdrpAdd	Lloh147, Lloh148
	.loh AdrpAdd	Lloh149, Lloh150
	.loh AdrpAdd	Lloh151, Lloh152
	.loh AdrpAdd	Lloh153, Lloh154
	.loh AdrpAdd	Lloh155, Lloh156
	.loh AdrpAdd	Lloh157, Lloh158
	.loh AdrpAdd	Lloh159, Lloh160
	.loh AdrpAdd	Lloh161, Lloh162
	.loh AdrpAdd	Lloh163, Lloh164
	.loh AdrpAdd	Lloh165, Lloh166
	.loh AdrpAdd	Lloh167, Lloh168
	.loh AdrpAdd	Lloh169, Lloh170
	.loh AdrpAdd	Lloh171, Lloh172
	.loh AdrpAdd	Lloh173, Lloh174
	.loh AdrpAdd	Lloh175, Lloh176
	.loh AdrpAdd	Lloh177, Lloh178
	.loh AdrpAdd	Lloh179, Lloh180
	.loh AdrpAdd	Lloh181, Lloh182
	.loh AdrpAdd	Lloh183, Lloh184
	.loh AdrpAdd	Lloh185, Lloh186
	.loh AdrpAdd	Lloh187, Lloh188
	.loh AdrpAdd	Lloh189, Lloh190
	.loh AdrpAdd	Lloh191, Lloh192
	.loh AdrpAdd	Lloh193, Lloh194
	.loh AdrpAdd	Lloh195, Lloh196
	.loh AdrpAdd	Lloh197, Lloh198
	.loh AdrpAdd	Lloh199, Lloh200
	.loh AdrpAdd	Lloh201, Lloh202
	.loh AdrpAdd	Lloh203, Lloh204
	.loh AdrpAdd	Lloh205, Lloh206
	.loh AdrpAdd	Lloh207, Lloh208
	.loh AdrpAdd	Lloh209, Lloh210
	.loh AdrpAdd	Lloh211, Lloh212
	.loh AdrpAdd	Lloh213, Lloh214
	.loh AdrpAdd	Lloh215, Lloh216
	.loh AdrpAdd	Lloh217, Lloh218
	.loh AdrpAdd	Lloh219, Lloh220
	.loh AdrpAdd	Lloh221, Lloh222
	.loh AdrpAdd	Lloh223, Lloh224
	.loh AdrpAdd	Lloh225, Lloh226
	.loh AdrpAdd	Lloh227, Lloh228
	.loh AdrpAdd	Lloh229, Lloh230
	.loh AdrpAdd	Lloh231, Lloh232
	.loh AdrpAdd	Lloh233, Lloh234
	.loh AdrpAdd	Lloh235, Lloh236
	.loh AdrpAdd	Lloh237, Lloh238
	.loh AdrpAdd	Lloh239, Lloh240
	.loh AdrpAdd	Lloh241, Lloh242
	.loh AdrpAdd	Lloh243, Lloh244
	.loh AdrpAdd	Lloh245, Lloh246
	.loh AdrpAdd	Lloh247, Lloh248
	.loh AdrpAdd	Lloh249, Lloh250
	.loh AdrpAdd	Lloh251, Lloh252
	.loh AdrpAdd	Lloh253, Lloh254
	.loh AdrpAdd	Lloh255, Lloh256
	.loh AdrpAdd	Lloh257, Lloh258
	.loh AdrpAdd	Lloh259, Lloh260
	.loh AdrpAdd	Lloh261, Lloh262
	.loh AdrpAdd	Lloh263, Lloh264
	.loh AdrpAdd	Lloh265, Lloh266
	.loh AdrpAdd	Lloh267, Lloh268
	.loh AdrpAdd	Lloh269, Lloh270
	.loh AdrpAdd	Lloh271, Lloh272
	.loh AdrpAdd	Lloh273, Lloh274
	.loh AdrpAdd	Lloh275, Lloh276
	.loh AdrpAdd	Lloh277, Lloh278
	.loh AdrpAdd	Lloh279, Lloh280
	.loh AdrpAdd	Lloh281, Lloh282
	.loh AdrpAdd	Lloh283, Lloh284
	.loh AdrpAdd	Lloh285, Lloh286
	.loh AdrpAdd	Lloh287, Lloh288
	.loh AdrpAdd	Lloh289, Lloh290
	.loh AdrpAdd	Lloh291, Lloh292
	.loh AdrpAdd	Lloh293, Lloh294
	.loh AdrpAdd	Lloh295, Lloh296
	.loh AdrpAdd	Lloh297, Lloh298
	.loh AdrpAdd	Lloh299, Lloh300
	.loh AdrpAdd	Lloh301, Lloh302
	.loh AdrpAdd	Lloh303, Lloh304
	.loh AdrpAdd	Lloh305, Lloh306
	.loh AdrpAdd	Lloh307, Lloh308
	.loh AdrpAdd	Lloh309, Lloh310
	.loh AdrpAdd	Lloh311, Lloh312
	.loh AdrpAdd	Lloh313, Lloh314
	.loh AdrpAdd	Lloh315, Lloh316
	.loh AdrpAdd	Lloh317, Lloh318
	.loh AdrpAdd	Lloh319, Lloh320
	.loh AdrpAdd	Lloh321, Lloh322
	.loh AdrpAdd	Lloh323, Lloh324
	.loh AdrpAdd	Lloh325, Lloh326
	.loh AdrpAdd	Lloh327, Lloh328
	.loh AdrpAdd	Lloh329, Lloh330
	.loh AdrpAdd	Lloh334, Lloh335
	.loh AdrpLdrGotLdr	Lloh331, Lloh332, Lloh333
	.loh AdrpAdd	Lloh339, Lloh340
	.loh AdrpLdrGotLdr	Lloh336, Lloh337, Lloh338
	.loh AdrpAdd	Lloh341, Lloh342
	.loh AdrpAdd	Lloh343, Lloh344
	.loh AdrpAdd	Lloh345, Lloh346
	.loh AdrpAdd	Lloh347, Lloh348
	.loh AdrpAdd	Lloh349, Lloh350
	.loh AdrpAdd	Lloh351, Lloh352
	.loh AdrpAdd	Lloh353, Lloh354
	.loh AdrpAdd	Lloh355, Lloh356
	.loh AdrpAdd	Lloh357, Lloh358
	.loh AdrpAdd	Lloh359, Lloh360
	.loh AdrpAdd	Lloh361, Lloh362
	.loh AdrpAdd	Lloh363, Lloh364
	.loh AdrpAdd	Lloh365, Lloh366
	.cfi_endproc
	.section	__TEXT,__const
	.p2align	1, 0x0
lJTI2_0:
	.short	(LBB2_17-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_12-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_23-LBB2_12)>>2
	.short	(LBB2_220-LBB2_12)>>2
	.short	(LBB2_22-LBB2_12)>>2
	.p2align	1, 0x0
lJTI2_1:
	.short	(LBB2_54-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_49-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_60-LBB2_49)>>2
	.short	(LBB2_258-LBB2_49)>>2
	.short	(LBB2_59-LBB2_49)>>2
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
	mov	x10, #17
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
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x9, x0
	ldrb	w8, [x9], #1
	cmp	w8, #45
	csel	x9, x0, x9, ne
	ldrb	w11, [x9]
	cbz	w11, LBB6_15
; %bb.1:
	cmp	w11, #48
	b.ne	LBB6_12
; %bb.2:
	ldrb	w10, [x9, #1]
	cmp	w10, #98
	b.eq	LBB6_16
; %bb.3:
	cmp	w10, #111
	b.eq	LBB6_20
; %bb.4:
	cmp	w10, #120
	b.ne	LBB6_12
; %bb.5:
	ldrb	w14, [x9, #2]!
	cbz	w14, LBB6_24
; %bb.6:
	mov	x10, #0
	mov	w12, #-48
	sub	x11, x12, #39
	sub	x12, x12, #7
	b	LBB6_8
LBB6_7:                                 ;   in Loop: Header=BB6_8 Depth=1
	lsl	x10, x10, #4
	add	w13, w14, w13
	add	x10, x13, x10
	ldrb	w14, [x9, #1]!
	cbz	w14, LBB6_25
LBB6_8:                                 ; =>This Inner Loop Header: Depth=1
	sxtb	x13, w14
	sub	w14, w14, #48
	and	w15, w14, #0xff
	mov	w14, #-48
	cmp	w15, #10
	b.lo	LBB6_7
; %bb.9:                                ;   in Loop: Header=BB6_8 Depth=1
	sub	w14, w13, #97
	and	w15, w14, #0xff
	mov	x14, x11
	cmp	w15, #6
	b.lo	LBB6_7
; %bb.10:                               ;   in Loop: Header=BB6_8 Depth=1
	sub	w14, w13, #65
	and	w15, w14, #0xff
	mov	x14, x12
	cmp	w15, #6
	b.lo	LBB6_7
; %bb.11:
Lloh367:
	adrp	x8, ___stderrp@GOTPAGE
Lloh368:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh369:
	ldr	x0, [x8]
	str	x9, [sp]
Lloh370:
	adrp	x1, l_.str.3@PAGE
Lloh371:
	add	x1, x1, l_.str.3@PAGEOFF
	b	LBB6_27
LBB6_12:
	mov	x10, #0
	mov	w12, #-48
	mov	w13, #10
LBB6_13:                                ; =>This Inner Loop Header: Depth=1
	sub	w14, w11, #48
	cmp	w14, #9
	b.hi	LBB6_26
; %bb.14:                               ;   in Loop: Header=BB6_13 Depth=1
	add	w11, w11, w12
	madd	x10, x10, x13, x11
	ldrb	w11, [x9, #1]!
	cbnz	w11, LBB6_13
	b	LBB6_25
LBB6_15:
	mov	x10, x11
	b	LBB6_25
LBB6_16:
	ldrb	w11, [x9, #2]!
	cbz	w11, LBB6_24
; %bb.17:
	mov	x10, #0
LBB6_18:                                ; =>This Inner Loop Header: Depth=1
	and	w12, w11, #0xfe
	cmp	w12, #48
	b.ne	LBB6_28
; %bb.19:                               ;   in Loop: Header=BB6_18 Depth=1
	lsl	x10, x10, #1
	add	x10, x10, w11, uxtw
	sub	x10, x10, #48
	ldrb	w11, [x9, #1]!
	cbnz	w11, LBB6_18
	b	LBB6_25
LBB6_20:
	ldrb	w11, [x9, #2]!
	cbz	w11, LBB6_24
; %bb.21:
	mov	x10, #0
	mov	w12, #-48
LBB6_22:                                ; =>This Inner Loop Header: Depth=1
	and	w13, w11, #0xf8
	cmp	w13, #48
	b.ne	LBB6_29
; %bb.23:                               ;   in Loop: Header=BB6_22 Depth=1
	add	w11, w11, w12
	add	x10, x11, x10, lsl #3
	ldrb	w11, [x9, #1]!
	cbnz	w11, LBB6_22
	b	LBB6_25
LBB6_24:
	mov	x10, #0
LBB6_25:
	cmp	w8, #45
	cneg	x0, x10, eq
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
LBB6_26:
Lloh372:
	adrp	x8, ___stderrp@GOTPAGE
Lloh373:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh374:
	ldr	x0, [x8]
	str	x9, [sp]
Lloh375:
	adrp	x1, l_.str.6@PAGE
Lloh376:
	add	x1, x1, l_.str.6@PAGEOFF
LBB6_27:
	bl	_fprintf
	mov	w0, #1
	bl	_exit
LBB6_28:
Lloh377:
	adrp	x8, ___stderrp@GOTPAGE
Lloh378:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh379:
	ldr	x0, [x8]
	str	x9, [sp]
Lloh380:
	adrp	x1, l_.str.4@PAGE
Lloh381:
	add	x1, x1, l_.str.4@PAGEOFF
	b	LBB6_27
LBB6_29:
Lloh382:
	adrp	x8, ___stderrp@GOTPAGE
Lloh383:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh384:
	ldr	x0, [x8]
	str	x9, [sp]
Lloh385:
	adrp	x1, l_.str.5@PAGE
Lloh386:
	add	x1, x1, l_.str.5@PAGEOFF
	b	LBB6_27
	.loh AdrpAdd	Lloh370, Lloh371
	.loh AdrpLdrGotLdr	Lloh367, Lloh368, Lloh369
	.loh AdrpAdd	Lloh375, Lloh376
	.loh AdrpLdrGotLdr	Lloh372, Lloh373, Lloh374
	.loh AdrpAdd	Lloh380, Lloh381
	.loh AdrpLdrGotLdr	Lloh377, Lloh378, Lloh379
	.loh AdrpAdd	Lloh385, Lloh386
	.loh AdrpLdrGotLdr	Lloh382, Lloh383, Lloh384
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
	bl	_parse64
                                        ; kill: def $w0 killed $w0 killed $x0
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
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
	bl	_parse64
	and	w0, w0, #0xffff
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
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
	bl	_parse64
	and	w0, w0, #0xff
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_parse_reg                      ; -- Begin function parse_reg
	.p2align	2
_parse_reg:                             ; @parse_reg
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
	ldrb	w8, [x0]
	cmp	w8, #114
	b.ne	LBB10_2
; %bb.1:
	add	x0, x19, #1
	mov	x1, #0
	mov	w2, #0
	bl	_strtoul
	b	LBB10_11
LBB10_2:
Lloh387:
	adrp	x1, l_.str.7@PAGE
Lloh388:
	add	x1, x1, l_.str.7@PAGEOFF
	mov	x0, x19
	bl	_strcmp
	cbz	w0, LBB10_8
; %bb.3:
Lloh389:
	adrp	x1, l_.str.8@PAGE
Lloh390:
	add	x1, x1, l_.str.8@PAGEOFF
	mov	x0, x19
	bl	_strcmp
	cbz	w0, LBB10_9
; %bb.4:
Lloh391:
	adrp	x1, l_.str.9@PAGE
Lloh392:
	add	x1, x1, l_.str.9@PAGEOFF
	mov	x0, x19
	bl	_strcmp
	cbz	w0, LBB10_10
; %bb.5:
Lloh393:
	adrp	x1, l_.str.10@PAGE
Lloh394:
	add	x1, x1, l_.str.10@PAGEOFF
	mov	x0, x19
	bl	_strcmp
	cbz	w0, LBB10_11
; %bb.6:
Lloh395:
	adrp	x1, l_.str.11@PAGE
Lloh396:
	add	x1, x1, l_.str.11@PAGEOFF
	mov	x0, x19
	bl	_strcmp
	cbnz	w0, LBB10_12
; %bb.7:
	mov	w0, #1
	b	LBB10_11
LBB10_8:
	mov	w0, #29
	b	LBB10_11
LBB10_9:
	mov	w0, #30
	b	LBB10_11
LBB10_10:
	mov	w0, #31
LBB10_11:
	and	w0, w0, #0xff
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
LBB10_12:
Lloh397:
	adrp	x8, ___stderrp@GOTPAGE
Lloh398:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh399:
	ldr	x0, [x8]
	str	x19, [sp]
Lloh400:
	adrp	x1, l_.str.12@PAGE
Lloh401:
	add	x1, x1, l_.str.12@PAGEOFF
	bl	_fprintf
	mov	w0, #1
	bl	_exit
	.loh AdrpAdd	Lloh387, Lloh388
	.loh AdrpAdd	Lloh389, Lloh390
	.loh AdrpAdd	Lloh391, Lloh392
	.loh AdrpAdd	Lloh393, Lloh394
	.loh AdrpAdd	Lloh395, Lloh396
	.loh AdrpAdd	Lloh400, Lloh401
	.loh AdrpLdrGotLdr	Lloh397, Lloh398, Lloh399
	.cfi_endproc
                                        ; -- End function
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
Lloh402:
	adrp	x9, lJTI11_0@PAGE
Lloh403:
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
Lloh404:
	adrp	x0, l_.str.162@PAGE
Lloh405:
	add	x0, x0, l_.str.162@PAGEOFF
	bl	_printf
	mov	x0, #0
	b	LBB11_17
	.loh AdrpAdd	Lloh402, Lloh403
	.loh AdrpAdd	Lloh404, Lloh405
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
Lloh406:
	adrp	x25, __DefaultRuneLocale@GOTPAGE
Lloh407:
	ldr	x25, [x25, __DefaultRuneLocale@GOTPAGEOFF]
Lloh408:
	adrp	x21, lJTI12_0@PAGE
Lloh409:
	add	x21, x21, lJTI12_0@PAGEOFF
	b	LBB12_2
LBB12_1:                                ;   in Loop: Header=BB12_2 Depth=1
	cbz	w8, LBB12_50
LBB12_2:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB12_5 Depth 2
                                        ;     Child Loop BB12_12 Depth 2
	ldr	w10, [x23, _line@PAGEOFF]
	add	x8, x20, #1
	b	LBB12_5
LBB12_3:                                ;   in Loop: Header=BB12_5 Depth=2
	add	w10, w10, #1
	str	w10, [x23, _line@PAGEOFF]
LBB12_4:                                ;   in Loop: Header=BB12_5 Depth=2
	add	x20, x20, #1
	str	x20, [x24, _src@PAGEOFF]
	add	x8, x8, #1
LBB12_5:                                ;   Parent Loop BB12_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w9, [x20]
	cmp	w9, #31
	b.gt	LBB12_8
; %bb.6:                                ;   in Loop: Header=BB12_5 Depth=2
	cmp	w9, #10
	b.eq	LBB12_3
; %bb.7:                                ;   in Loop: Header=BB12_5 Depth=2
	cmp	w9, #13
	b.eq	LBB12_4
	b	LBB12_15
LBB12_8:                                ;   in Loop: Header=BB12_5 Depth=2
	cmp	w9, #32
	b.eq	LBB12_4
; %bb.9:                                ;   in Loop: Header=BB12_2 Depth=1
	cmp	w9, #64
	b.eq	LBB12_11
; %bb.10:                               ;   in Loop: Header=BB12_2 Depth=1
	cmp	w9, #59
	b.ne	LBB12_15
LBB12_11:                               ;   in Loop: Header=BB12_2 Depth=1
	ands	w10, w9, #0xff
	b.eq	LBB12_14
LBB12_12:                               ;   Parent Loop BB12_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	cmp	w10, #10
	b.eq	LBB12_14
; %bb.13:                               ;   in Loop: Header=BB12_12 Depth=2
	str	x8, [x24, _src@PAGEOFF]
	ldrb	w9, [x8], #1
	ands	w10, w9, #0xff
	b.ne	LBB12_12
LBB12_14:                               ;   in Loop: Header=BB12_2 Depth=1
	sub	x20, x8, #1
LBB12_15:                               ;   in Loop: Header=BB12_2 Depth=1
	and	w8, w9, #0xff
	cmp	w8, #95
	b.eq	LBB12_24
; %bb.16:                               ;   in Loop: Header=BB12_2 Depth=1
	sxtb	w0, w9
	and	w8, w0, #0xffffffdf
	sub	w8, w8, #91
	cmn	w8, #26
	b.hs	LBB12_24
; %bb.17:                               ;   in Loop: Header=BB12_2 Depth=1
	tbnz	w0, #31, LBB12_19
; %bb.18:                               ;   in Loop: Header=BB12_2 Depth=1
	add	x8, x25, w0, uxtw #2
	ldr	w8, [x8, #60]
	and	w0, w8, #0x400
	cbz	w0, LBB12_20
	b	LBB12_63
LBB12_19:                               ;   in Loop: Header=BB12_2 Depth=1
	mov	w1, #1024
	bl	___maskrune
	cbnz	w0, LBB12_63
LBB12_20:                               ;   in Loop: Header=BB12_2 Depth=1
	ldr	x20, [x24, _src@PAGEOFF]
	ldrb	w8, [x20]
	sub	w9, w8, #34
	cmp	w9, #59
	b.hi	LBB12_1
; %bb.21:                               ;   in Loop: Header=BB12_2 Depth=1
	adr	x8, LBB12_2
	ldrb	w10, [x21, x9]
	add	x8, x8, x10, lsl #2
	br	x8
LBB12_22:
	add	x21, x20, #1
	mov	x0, x21
	bl	_strdup
	ldrb	w8, [x20, #1]
	cmp	w8, #34
	b.ne	LBB12_51
; %bb.23:
	mov	x8, x21
	b	LBB12_53
LBB12_24:
	mov	x0, x20
	bl	_strdup
	mov	x21, x0
	ldrb	w8, [x0]
	cmp	w8, #114
	b.ne	LBB12_49
; %bb.25:
	add	x8, x20, #1
	str	x8, [x24, _src@PAGEOFF]
	ldrsb	w0, [x20, #1]
	tbnz	w0, #31, LBB12_91
; %bb.26:
	add	x8, x25, w0, uxtw #2
	ldr	w8, [x8, #60]
	and	w0, w8, #0x400
	ldr	x8, [x24, _src@PAGEOFF]
	cbz	w0, LBB12_92
LBB12_27:
	ldrsb	w0, [x8]
	tbnz	w0, #31, LBB12_29
LBB12_28:
	add	x8, x25, w0, uxtw #2
	ldr	w8, [x8, #60]
	and	w0, w8, #0x400
	ldr	x8, [x24, _src@PAGEOFF]
	cbnz	w0, LBB12_30
	b	LBB12_61
LBB12_29:
	mov	w1, #1024
	bl	___maskrune
	ldr	x8, [x24, _src@PAGEOFF]
	cbz	w0, LBB12_61
LBB12_30:
	add	x8, x8, #1
	str	x8, [x24, _src@PAGEOFF]
	ldrsb	w0, [x8]
	tbz	w0, #31, LBB12_28
	b	LBB12_29
LBB12_31:
	add	x21, x20, #1
	mov	x0, x21
	bl	_strdup
	ldrb	w8, [x20, #1]
	cmp	w8, #39
	b.ne	LBB12_54
; %bb.32:
	mov	x8, x21
	b	LBB12_56
LBB12_33:
	add	x8, x20, #1
	str	x8, [x24, _src@PAGEOFF]
	ldrsb	w0, [x20, #1]
	tbnz	w0, #31, LBB12_62
; %bb.34:
	add	x8, x25, w0, uxtw #2
	ldr	w8, [x8, #60]
	and	w0, w8, #0x400
	cbnz	w0, LBB12_63
	b	LBB12_90
LBB12_35:
	add	x8, x20, #1
	str	x8, [x24, _src@PAGEOFF]
Lloh410:
	adrp	x8, l_.str.170@PAGE
Lloh411:
	add	x8, x8, l_.str.170@PAGEOFF
	str	x8, [x19]
	mov	w8, #11
	b	LBB12_86
LBB12_36:
	add	x8, x20, #1
	str	x8, [x24, _src@PAGEOFF]
	ldrsb	w0, [x20, #1]
	tbnz	w0, #31, LBB12_88
; %bb.37:
	add	x8, x25, w0, uxtw #2
	ldr	w8, [x8, #60]
	and	w0, w8, #0x400
	cbz	w0, LBB12_89
LBB12_38:
	ldr	x8, [x24, _src@PAGEOFF]
	sub	x8, x8, #1
	str	x8, [x24, _src@PAGEOFF]
	b	LBB12_63
LBB12_39:
	add	x0, x20, #1
	str	x0, [x24, _src@PAGEOFF]
	bl	_strdup
	mov	x8, #0
	mov	w9, #1
	mov	x10, #17
	movk	x10, #2048, lsl #48
	b	LBB12_41
LBB12_40:                               ;   in Loop: Header=BB12_41 Depth=1
	add	x11, x11, #2
	str	x11, [x24, _src@PAGEOFF]
	add	x8, x8, #1
LBB12_41:                               ; =>This Inner Loop Header: Depth=1
	add	x11, x20, x8
	ldrsb	w12, [x11, #1]
	and	w13, w12, #0xffffffdf
	sub	w13, w13, #65
	sub	w14, w12, #48
	cmp	w14, #10
	ccmp	w13, #26, #0, hs
	b.lo	LBB12_40
; %bb.42:                               ;   in Loop: Header=BB12_41 Depth=1
	sub	w13, w12, #36
	cmp	w13, #59
	lsl	x13, x9, x13
	and	x13, x13, x10
	ccmp	x13, #0, #4, ls
	b.ne	LBB12_40
; %bb.43:                               ;   in Loop: Header=BB12_41 Depth=1
	cmp	w12, #123
	b.eq	LBB12_40
; %bb.44:                               ;   in Loop: Header=BB12_41 Depth=1
	cmp	w12, #125
	b.eq	LBB12_40
; %bb.45:                               ;   in Loop: Header=BB12_41 Depth=1
	cmp	w12, #41
	b.eq	LBB12_40
; %bb.46:
	strb	wzr, [x0, x8]
	str	x0, [x19]
	mov	w8, #7
	b	LBB12_86
LBB12_47:
	add	x8, x20, #1
	str	x8, [x24, _src@PAGEOFF]
Lloh412:
	adrp	x8, l_.str.168@PAGE
Lloh413:
	add	x8, x8, l_.str.168@PAGEOFF
	str	x8, [x19]
	mov	w8, #8
	b	LBB12_86
LBB12_48:
	add	x8, x20, #1
	str	x8, [x24, _src@PAGEOFF]
Lloh414:
	adrp	x8, l_.str.169@PAGE
Lloh415:
	add	x8, x8, l_.str.169@PAGEOFF
	str	x8, [x19]
	mov	w8, #9
	b	LBB12_86
LBB12_49:
	mov	x8, x20
	b	LBB12_102
LBB12_50:
	str	xzr, [x19]
	str	wzr, [x19, #8]
	b	LBB12_87
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
	mov	w8, #6
	b	LBB12_86
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
	b.ne	LBB12_99
; %bb.57:
	ldrsb	w8, [x0, #1]
	cmp	w8, #91
	b.le	LBB12_93
; %bb.58:
	sub	w9, w8, #92
	cmp	w9, #24
	b.hi	LBB12_100
; %bb.59:
	mov	w21, #10
Lloh416:
	adrp	x10, lJTI12_1@PAGE
Lloh417:
	add	x10, x10, lJTI12_1@PAGEOFF
	adr	x11, LBB12_60
	ldrb	w12, [x10, x9]
	add	x11, x11, x12, lsl #2
	br	x11
LBB12_60:
	mov	w21, #13
	b	LBB12_99
LBB12_61:
	sub	x8, x8, x20
	strb	wzr, [x21, x8]
	str	x21, [x19]
	mov	w8, #2
	b	LBB12_86
LBB12_62:
	mov	w1, #1024
	bl	___maskrune
	cbz	w0, LBB12_90
LBB12_63:
	ldr	x21, [x24, _src@PAGEOFF]
	mov	x0, x21
	bl	_strdup
	mov	x20, x0
	ldrb	w8, [x21]
	mov	x22, x21
	cmp	w8, #45
	b.ne	LBB12_65
; %bb.64:
	add	x22, x21, #1
	str	x22, [x24, _src@PAGEOFF]
LBB12_65:
Lloh418:
	adrp	x1, l_.str.165@PAGE
Lloh419:
	add	x1, x1, l_.str.165@PAGEOFF
	mov	x0, x22
	mov	w2, #2
	bl	_strncmp
	cbz	w0, LBB12_77
; %bb.66:
Lloh420:
	adrp	x1, l_.str.166@PAGE
Lloh421:
	add	x1, x1, l_.str.166@PAGEOFF
	mov	x0, x22
	mov	w2, #2
	bl	_strncmp
	cbz	w0, LBB12_82
; %bb.67:
	ldrsb	w0, [x22]
	tbnz	w0, #31, LBB12_69
LBB12_68:
	add	x8, x25, w0, uxtw #2
	ldr	w8, [x8, #60]
	and	w0, w8, #0x400
	ldr	x8, [x24, _src@PAGEOFF]
	cbnz	w0, LBB12_70
	b	LBB12_71
LBB12_69:
	mov	w1, #1024
	bl	___maskrune
	ldr	x8, [x24, _src@PAGEOFF]
	cbz	w0, LBB12_71
LBB12_70:
	add	x22, x8, #1
	str	x22, [x24, _src@PAGEOFF]
	ldrsb	w0, [x22]
	tbz	w0, #31, LBB12_68
	b	LBB12_69
LBB12_71:
	ldrb	w9, [x8]
	cmp	w9, #46
	b.eq	LBB12_74
; %bb.72:
	sub	x8, x8, x21
	b	LBB12_85
LBB12_73:                               ;   in Loop: Header=BB12_74 Depth=1
	mov	w1, #1024
	bl	___maskrune
	ldr	x8, [x24, _src@PAGEOFF]
	cbz	w0, LBB12_76
LBB12_74:                               ; =>This Inner Loop Header: Depth=1
	add	x9, x8, #1
	str	x9, [x24, _src@PAGEOFF]
	ldrsb	w0, [x8, #1]
	tbnz	w0, #31, LBB12_73
; %bb.75:                               ;   in Loop: Header=BB12_74 Depth=1
	add	x8, x25, w0, uxtw #2
	ldr	w8, [x8, #60]
	and	w0, w8, #0x400
	ldr	x8, [x24, _src@PAGEOFF]
	cbnz	w0, LBB12_74
LBB12_76:
	sub	x8, x8, x21
	strb	wzr, [x20, x8]
	str	x20, [x19]
	mov	w8, #5
	b	LBB12_86
LBB12_77:
	ldrsb	w8, [x22, #2]!
	tbnz	w8, #31, LBB12_81
; %bb.78:
	and	x8, x8, #0xff
LBB12_79:                               ; =>This Inner Loop Header: Depth=1
	add	x8, x25, x8, lsl #2
	ldr	w8, [x8, #60]
	tbz	w8, #16, LBB12_81
; %bb.80:                               ;   in Loop: Header=BB12_79 Depth=1
	ldrsb	w9, [x22, #1]!
	and	x8, x9, #0xff
	tbz	w9, #31, LBB12_79
LBB12_81:
	str	x22, [x24, _src@PAGEOFF]
	sub	x8, x22, x21
	b	LBB12_85
LBB12_82:
	add	x9, x22, #1
	sub	x8, x9, x21
LBB12_83:                               ; =>This Inner Loop Header: Depth=1
	ldrb	w10, [x9, #1]!
	and	w10, w10, #0xfe
	add	x8, x8, #1
	cmp	w10, #48
	b.eq	LBB12_83
; %bb.84:
	str	x9, [x24, _src@PAGEOFF]
LBB12_85:
	strb	wzr, [x20, x8]
	str	x20, [x19]
	mov	w8, #4
LBB12_86:
	str	w8, [x19, #8]
LBB12_87:
Lloh422:
	adrp	x8, _file@PAGE
Lloh423:
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
LBB12_88:
	mov	w1, #1024
	bl	___maskrune
	cbnz	w0, LBB12_38
LBB12_89:
Lloh424:
	adrp	x8, l_.str.172@PAGE
Lloh425:
	add	x8, x8, l_.str.172@PAGEOFF
	str	x8, [x19]
	mov	w8, #13
	b	LBB12_86
LBB12_90:
Lloh426:
	adrp	x8, l_.str.171@PAGE
Lloh427:
	add	x8, x8, l_.str.171@PAGEOFF
	str	x8, [x19]
	mov	w8, #12
	b	LBB12_86
LBB12_91:
	mov	w1, #1024
	bl	___maskrune
	ldr	x8, [x24, _src@PAGEOFF]
	cbnz	w0, LBB12_27
LBB12_92:
	sub	x8, x8, #1
	b	LBB12_101
LBB12_93:
	cmp	w8, #34
	b.eq	LBB12_97
; %bb.94:
	mov	x21, x8
	cmp	w8, #39
	b.eq	LBB12_99
; %bb.95:
	cmp	w8, #48
	b.ne	LBB12_100
; %bb.96:
	mov	w21, #0
	b	LBB12_99
LBB12_97:
	mov	x21, x8
	b	LBB12_99
LBB12_98:
	mov	w21, #9
LBB12_99:
	mov	w22, #4
	mov	w0, #4
	bl	_malloc
	mov	x20, x0
	str	x21, [sp]
Lloh428:
	adrp	x2, l_.str.167@PAGE
Lloh429:
	add	x2, x2, l_.str.167@PAGEOFF
	mov	w1, #4
	bl	_snprintf
	str	x20, [x19]
	str	w22, [x19, #8]
	b	LBB12_87
LBB12_100:
	str	x8, [sp]
Lloh430:
	adrp	x0, l_.str.162@PAGE
Lloh431:
	add	x0, x0, l_.str.162@PAGEOFF
	bl	_printf
	str	xzr, [x19]
	mov	w8, #-1
	b	LBB12_86
LBB12_101:
	str	x8, [x24, _src@PAGEOFF]
LBB12_102:
	ldrsb	w9, [x8]
	and	w10, w9, #0xffffffdf
	sub	w10, w10, #65
	sub	w11, w9, #48
	cmp	w11, #10
	ccmp	w10, #26, #0, hs
	b.lo	LBB12_108
; %bb.103:
	sub	w10, w9, #36
	cmp	w10, #59
	b.hi	LBB12_105
; %bb.104:
	mov	w11, #1
	lsl	x10, x11, x10
	mov	x11, #17
	movk	x11, #2048, lsl #48
	tst	x10, x11
	b.ne	LBB12_108
LBB12_105:
	cmp	w9, #123
	b.eq	LBB12_108
; %bb.106:
	cmp	w9, #125
	b.eq	LBB12_108
; %bb.107:
	cmp	w9, #41
	b.ne	LBB12_109
LBB12_108:
	add	x8, x8, #1
	b	LBB12_101
LBB12_109:
	sub	x9, x8, x20
	strb	wzr, [x21, x9]
	ldrb	w9, [x8]
	cmp	w9, #58
	b.ne	LBB12_111
; %bb.110:
	add	x8, x8, #1
	str	x8, [x24, _src@PAGEOFF]
	str	x21, [x19]
	mov	w8, #3
	b	LBB12_86
LBB12_111:
Lloh432:
	adrp	x20, l_.str.10@PAGE
Lloh433:
	add	x20, x20, l_.str.10@PAGEOFF
	mov	x0, x21
	mov	x1, x20
	bl	_strcmp
	cbz	w0, LBB12_118
; %bb.112:
Lloh434:
	adrp	x20, l_.str.11@PAGE
Lloh435:
	add	x20, x20, l_.str.11@PAGEOFF
	mov	x0, x21
	mov	x1, x20
	bl	_strcmp
	cbz	w0, LBB12_118
; %bb.113:
Lloh436:
	adrp	x20, l_.str.9@PAGE
Lloh437:
	add	x20, x20, l_.str.9@PAGEOFF
	mov	x0, x21
	mov	x1, x20
	bl	_strcmp
	cbz	w0, LBB12_118
; %bb.114:
Lloh438:
	adrp	x20, l_.str.7@PAGE
Lloh439:
	add	x20, x20, l_.str.7@PAGEOFF
	mov	x0, x21
	mov	x1, x20
	bl	_strcmp
	cbz	w0, LBB12_118
; %bb.115:
Lloh440:
	adrp	x20, l_.str.8@PAGE
Lloh441:
	add	x20, x20, l_.str.8@PAGEOFF
	mov	x0, x21
	mov	x1, x20
	bl	_strcmp
	cbz	w0, LBB12_118
; %bb.116:
Lloh442:
	adrp	x20, l_.str.164@PAGE
Lloh443:
	add	x20, x20, l_.str.164@PAGEOFF
	mov	x0, x21
	mov	x1, x20
	bl	_strcmp
	cbz	w0, LBB12_118
; %bb.117:
	str	x21, [x19]
	mov	w8, #1
	b	LBB12_86
LBB12_118:
	str	x20, [x19]
	mov	w8, #2
	b	LBB12_86
	.loh AdrpAdd	Lloh408, Lloh409
	.loh AdrpLdrGot	Lloh406, Lloh407
	.loh AdrpAdd	Lloh410, Lloh411
	.loh AdrpAdd	Lloh412, Lloh413
	.loh AdrpAdd	Lloh414, Lloh415
	.loh AdrpAdd	Lloh416, Lloh417
	.loh AdrpAdd	Lloh418, Lloh419
	.loh AdrpAdd	Lloh420, Lloh421
	.loh AdrpLdr	Lloh422, Lloh423
	.loh AdrpAdd	Lloh424, Lloh425
	.loh AdrpAdd	Lloh426, Lloh427
	.loh AdrpAdd	Lloh428, Lloh429
	.loh AdrpAdd	Lloh430, Lloh431
	.loh AdrpAdd	Lloh432, Lloh433
	.loh AdrpAdd	Lloh434, Lloh435
	.loh AdrpAdd	Lloh436, Lloh437
	.loh AdrpAdd	Lloh438, Lloh439
	.loh AdrpAdd	Lloh440, Lloh441
	.loh AdrpAdd	Lloh442, Lloh443
	.cfi_endproc
	.section	__TEXT,__const
lJTI12_0:
	.byte	(LBB12_22-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_31-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_33-LBB12_2)>>2
	.byte	(LBB12_35-LBB12_2)>>2
	.byte	(LBB12_36-LBB12_2)>>2
	.byte	(LBB12_39-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_47-LBB12_2)>>2
	.byte	(LBB12_2-LBB12_2)>>2
	.byte	(LBB12_48-LBB12_2)>>2
lJTI12_1:
	.byte	(LBB12_97-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_99-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_60-LBB12_60)>>2
	.byte	(LBB12_100-LBB12_60)>>2
	.byte	(LBB12_98-LBB12_60)>>2
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2                               ; -- Begin function parse.cold.1
_parse.cold.1:                          ; @parse.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh444:
	adrp	x0, l___func__.parse@PAGE
Lloh445:
	add	x0, x0, l___func__.parse@PAGEOFF
Lloh446:
	adrp	x1, l_.str.137@PAGE
Lloh447:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh448:
	adrp	x3, l_.str.163@PAGE
Lloh449:
	add	x3, x3, l_.str.163@PAGEOFF
	mov	w2, #1219
	bl	___assert_rtn
	.loh AdrpAdd	Lloh448, Lloh449
	.loh AdrpAdd	Lloh446, Lloh447
	.loh AdrpAdd	Lloh444, Lloh445
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function parse.cold.2
_parse.cold.2:                          ; @parse.cold.2
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh450:
	adrp	x0, l___func__.parse@PAGE
Lloh451:
	add	x0, x0, l___func__.parse@PAGEOFF
Lloh452:
	adrp	x1, l_.str.137@PAGE
Lloh453:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh454:
	adrp	x3, l_.str.163@PAGE
Lloh455:
	add	x3, x3, l_.str.163@PAGEOFF
	mov	w2, #1217
	bl	___assert_rtn
	.loh AdrpAdd	Lloh454, Lloh455
	.loh AdrpAdd	Lloh452, Lloh453
	.loh AdrpAdd	Lloh450, Lloh451
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.1
_compile.cold.1:                        ; @compile.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh456:
	adrp	x0, l___func__.compile@PAGE
Lloh457:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh458:
	adrp	x1, l_.str.137@PAGE
Lloh459:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh460:
	adrp	x3, l_.str.159@PAGE
Lloh461:
	add	x3, x3, l_.str.159@PAGEOFF
	mov	w2, #1118
	bl	___assert_rtn
	.loh AdrpAdd	Lloh460, Lloh461
	.loh AdrpAdd	Lloh458, Lloh459
	.loh AdrpAdd	Lloh456, Lloh457
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.2
_compile.cold.2:                        ; @compile.cold.2
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh462:
	adrp	x0, l___func__.compile@PAGE
Lloh463:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh464:
	adrp	x1, l_.str.137@PAGE
Lloh465:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh466:
	adrp	x3, l_.str.159@PAGE
Lloh467:
	add	x3, x3, l_.str.159@PAGEOFF
	mov	w2, #1125
	bl	___assert_rtn
	.loh AdrpAdd	Lloh466, Lloh467
	.loh AdrpAdd	Lloh464, Lloh465
	.loh AdrpAdd	Lloh462, Lloh463
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.3
_compile.cold.3:                        ; @compile.cold.3
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh468:
	adrp	x0, l___func__.compile@PAGE
Lloh469:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh470:
	adrp	x1, l_.str.137@PAGE
Lloh471:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh472:
	adrp	x3, l_.str.139@PAGE
Lloh473:
	add	x3, x3, l_.str.139@PAGEOFF
	mov	w2, #993
	bl	___assert_rtn
	.loh AdrpAdd	Lloh472, Lloh473
	.loh AdrpAdd	Lloh470, Lloh471
	.loh AdrpAdd	Lloh468, Lloh469
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.4
_compile.cold.4:                        ; @compile.cold.4
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh474:
	adrp	x0, l___func__.compile@PAGE
Lloh475:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh476:
	adrp	x1, l_.str.137@PAGE
Lloh477:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh478:
	adrp	x3, l_.str.138@PAGE
Lloh479:
	add	x3, x3, l_.str.138@PAGEOFF
	mov	w2, #982
	bl	___assert_rtn
	.loh AdrpAdd	Lloh478, Lloh479
	.loh AdrpAdd	Lloh476, Lloh477
	.loh AdrpAdd	Lloh474, Lloh475
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.5
_compile.cold.5:                        ; @compile.cold.5
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh480:
	adrp	x0, l___func__.compile@PAGE
Lloh481:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh482:
	adrp	x1, l_.str.137@PAGE
Lloh483:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh484:
	adrp	x3, l_.str.138@PAGE
Lloh485:
	add	x3, x3, l_.str.138@PAGEOFF
	mov	w2, #991
	bl	___assert_rtn
	.loh AdrpAdd	Lloh484, Lloh485
	.loh AdrpAdd	Lloh482, Lloh483
	.loh AdrpAdd	Lloh480, Lloh481
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.6
_compile.cold.6:                        ; @compile.cold.6
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh486:
	adrp	x0, l___func__.compile@PAGE
Lloh487:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh488:
	adrp	x1, l_.str.137@PAGE
Lloh489:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh490:
	adrp	x3, l_.str.139@PAGE
Lloh491:
	add	x3, x3, l_.str.139@PAGEOFF
	mov	w2, #1000
	bl	___assert_rtn
	.loh AdrpAdd	Lloh490, Lloh491
	.loh AdrpAdd	Lloh488, Lloh489
	.loh AdrpAdd	Lloh486, Lloh487
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.7
_compile.cold.7:                        ; @compile.cold.7
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh492:
	adrp	x0, l___func__.compile@PAGE
Lloh493:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh494:
	adrp	x1, l_.str.137@PAGE
Lloh495:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh496:
	adrp	x3, l_.str.139@PAGE
Lloh497:
	add	x3, x3, l_.str.139@PAGEOFF
	mov	w2, #1002
	bl	___assert_rtn
	.loh AdrpAdd	Lloh496, Lloh497
	.loh AdrpAdd	Lloh494, Lloh495
	.loh AdrpAdd	Lloh492, Lloh493
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.8
_compile.cold.8:                        ; @compile.cold.8
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh498:
	adrp	x0, l___func__.compile@PAGE
Lloh499:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh500:
	adrp	x1, l_.str.137@PAGE
Lloh501:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh502:
	adrp	x3, l_.str.139@PAGE
Lloh503:
	add	x3, x3, l_.str.139@PAGEOFF
	mov	w2, #1005
	bl	___assert_rtn
	.loh AdrpAdd	Lloh502, Lloh503
	.loh AdrpAdd	Lloh500, Lloh501
	.loh AdrpAdd	Lloh498, Lloh499
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.9
_compile.cold.9:                        ; @compile.cold.9
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh504:
	adrp	x0, l___func__.compile@PAGE
Lloh505:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh506:
	adrp	x1, l_.str.137@PAGE
Lloh507:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh508:
	adrp	x3, l_.str.139@PAGE
Lloh509:
	add	x3, x3, l_.str.139@PAGEOFF
	mov	w2, #1011
	bl	___assert_rtn
	.loh AdrpAdd	Lloh508, Lloh509
	.loh AdrpAdd	Lloh506, Lloh507
	.loh AdrpAdd	Lloh504, Lloh505
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.10
_compile.cold.10:                       ; @compile.cold.10
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh510:
	adrp	x0, l___func__.compile@PAGE
Lloh511:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh512:
	adrp	x1, l_.str.137@PAGE
Lloh513:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh514:
	adrp	x3, l_.str.139@PAGE
Lloh515:
	add	x3, x3, l_.str.139@PAGEOFF
	mov	w2, #1016
	bl	___assert_rtn
	.loh AdrpAdd	Lloh514, Lloh515
	.loh AdrpAdd	Lloh512, Lloh513
	.loh AdrpAdd	Lloh510, Lloh511
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.11
_compile.cold.11:                       ; @compile.cold.11
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh516:
	adrp	x0, l___func__.compile@PAGE
Lloh517:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh518:
	adrp	x1, l_.str.137@PAGE
Lloh519:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh520:
	adrp	x3, l_.str.139@PAGE
Lloh521:
	add	x3, x3, l_.str.139@PAGEOFF
	mov	w2, #1021
	bl	___assert_rtn
	.loh AdrpAdd	Lloh520, Lloh521
	.loh AdrpAdd	Lloh518, Lloh519
	.loh AdrpAdd	Lloh516, Lloh517
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.12
_compile.cold.12:                       ; @compile.cold.12
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh522:
	adrp	x0, l___func__.compile@PAGE
Lloh523:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh524:
	adrp	x1, l_.str.137@PAGE
Lloh525:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh526:
	adrp	x3, l_.str.139@PAGE
Lloh527:
	add	x3, x3, l_.str.139@PAGEOFF
	mov	w2, #1026
	bl	___assert_rtn
	.loh AdrpAdd	Lloh526, Lloh527
	.loh AdrpAdd	Lloh524, Lloh525
	.loh AdrpAdd	Lloh522, Lloh523
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.13
_compile.cold.13:                       ; @compile.cold.13
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh528:
	adrp	x0, l___func__.compile@PAGE
Lloh529:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh530:
	adrp	x1, l_.str.137@PAGE
Lloh531:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh532:
	adrp	x3, l_.str.139@PAGE
Lloh533:
	add	x3, x3, l_.str.139@PAGEOFF
	mov	w2, #1034
	bl	___assert_rtn
	.loh AdrpAdd	Lloh532, Lloh533
	.loh AdrpAdd	Lloh530, Lloh531
	.loh AdrpAdd	Lloh528, Lloh529
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.14
_compile.cold.14:                       ; @compile.cold.14
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh534:
	adrp	x0, l___func__.compile@PAGE
Lloh535:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh536:
	adrp	x1, l_.str.137@PAGE
Lloh537:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh538:
	adrp	x3, l_.str.138@PAGE
Lloh539:
	add	x3, x3, l_.str.138@PAGEOFF
	mov	w2, #1033
	bl	___assert_rtn
	.loh AdrpAdd	Lloh538, Lloh539
	.loh AdrpAdd	Lloh536, Lloh537
	.loh AdrpAdd	Lloh534, Lloh535
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.15
_compile.cold.15:                       ; @compile.cold.15
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh540:
	adrp	x0, l___func__.compile@PAGE
Lloh541:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh542:
	adrp	x1, l_.str.137@PAGE
Lloh543:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh544:
	adrp	x3, l_.str.139@PAGE
Lloh545:
	add	x3, x3, l_.str.139@PAGEOFF
	mov	w2, #1042
	bl	___assert_rtn
	.loh AdrpAdd	Lloh544, Lloh545
	.loh AdrpAdd	Lloh542, Lloh543
	.loh AdrpAdd	Lloh540, Lloh541
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.16
_compile.cold.16:                       ; @compile.cold.16
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh546:
	adrp	x0, l___func__.compile@PAGE
Lloh547:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh548:
	adrp	x1, l_.str.137@PAGE
Lloh549:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh550:
	adrp	x3, l_.str.139@PAGE
Lloh551:
	add	x3, x3, l_.str.139@PAGEOFF
	mov	w2, #1047
	bl	___assert_rtn
	.loh AdrpAdd	Lloh550, Lloh551
	.loh AdrpAdd	Lloh548, Lloh549
	.loh AdrpAdd	Lloh546, Lloh547
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.17
_compile.cold.17:                       ; @compile.cold.17
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh552:
	adrp	x0, l___func__.compile@PAGE
Lloh553:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh554:
	adrp	x1, l_.str.137@PAGE
Lloh555:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh556:
	adrp	x3, l_.str.139@PAGE
Lloh557:
	add	x3, x3, l_.str.139@PAGEOFF
	mov	w2, #1057
	bl	___assert_rtn
	.loh AdrpAdd	Lloh556, Lloh557
	.loh AdrpAdd	Lloh554, Lloh555
	.loh AdrpAdd	Lloh552, Lloh553
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.18
_compile.cold.18:                       ; @compile.cold.18
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh558:
	adrp	x0, l___func__.compile@PAGE
Lloh559:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh560:
	adrp	x1, l_.str.137@PAGE
Lloh561:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh562:
	adrp	x3, l_.str.138@PAGE
Lloh563:
	add	x3, x3, l_.str.138@PAGEOFF
	mov	w2, #1056
	bl	___assert_rtn
	.loh AdrpAdd	Lloh562, Lloh563
	.loh AdrpAdd	Lloh560, Lloh561
	.loh AdrpAdd	Lloh558, Lloh559
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.19
_compile.cold.19:                       ; @compile.cold.19
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh564:
	adrp	x0, l___func__.compile@PAGE
Lloh565:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh566:
	adrp	x1, l_.str.137@PAGE
Lloh567:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh568:
	adrp	x3, l_.str.139@PAGE
Lloh569:
	add	x3, x3, l_.str.139@PAGEOFF
	mov	w2, #1067
	bl	___assert_rtn
	.loh AdrpAdd	Lloh568, Lloh569
	.loh AdrpAdd	Lloh566, Lloh567
	.loh AdrpAdd	Lloh564, Lloh565
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.20
_compile.cold.20:                       ; @compile.cold.20
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh570:
	adrp	x0, l___func__.compile@PAGE
Lloh571:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh572:
	adrp	x1, l_.str.137@PAGE
Lloh573:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh574:
	adrp	x3, l_.str.139@PAGE
Lloh575:
	add	x3, x3, l_.str.139@PAGEOFF
	mov	w2, #1070
	bl	___assert_rtn
	.loh AdrpAdd	Lloh574, Lloh575
	.loh AdrpAdd	Lloh572, Lloh573
	.loh AdrpAdd	Lloh570, Lloh571
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.21
_compile.cold.21:                       ; @compile.cold.21
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh576:
	adrp	x0, l___func__.compile@PAGE
Lloh577:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh578:
	adrp	x1, l_.str.137@PAGE
Lloh579:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh580:
	adrp	x3, l_.str.139@PAGE
Lloh581:
	add	x3, x3, l_.str.139@PAGEOFF
	mov	w2, #1073
	bl	___assert_rtn
	.loh AdrpAdd	Lloh580, Lloh581
	.loh AdrpAdd	Lloh578, Lloh579
	.loh AdrpAdd	Lloh576, Lloh577
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.22
_compile.cold.22:                       ; @compile.cold.22
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh582:
	adrp	x0, l___func__.compile@PAGE
Lloh583:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh584:
	adrp	x1, l_.str.137@PAGE
Lloh585:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh586:
	adrp	x3, l_.str.139@PAGE
Lloh587:
	add	x3, x3, l_.str.139@PAGEOFF
	mov	w2, #1076
	bl	___assert_rtn
	.loh AdrpAdd	Lloh586, Lloh587
	.loh AdrpAdd	Lloh584, Lloh585
	.loh AdrpAdd	Lloh582, Lloh583
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.23
_compile.cold.23:                       ; @compile.cold.23
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh588:
	adrp	x0, l___func__.compile@PAGE
Lloh589:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh590:
	adrp	x1, l_.str.137@PAGE
Lloh591:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh592:
	adrp	x3, l_.str.156@PAGE
Lloh593:
	add	x3, x3, l_.str.156@PAGEOFF
	mov	w2, #1085
	bl	___assert_rtn
	.loh AdrpAdd	Lloh592, Lloh593
	.loh AdrpAdd	Lloh590, Lloh591
	.loh AdrpAdd	Lloh588, Lloh589
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compile.cold.24
_compile.cold.24:                       ; @compile.cold.24
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh594:
	adrp	x0, l___func__.compile@PAGE
Lloh595:
	add	x0, x0, l___func__.compile@PAGEOFF
Lloh596:
	adrp	x1, l_.str.137@PAGE
Lloh597:
	add	x1, x1, l_.str.137@PAGEOFF
Lloh598:
	adrp	x3, l_.str.158@PAGE
Lloh599:
	add	x3, x3, l_.str.158@PAGEOFF
	mov	w2, #1096
	bl	___assert_rtn
	.loh AdrpAdd	Lloh598, Lloh599
	.loh AdrpAdd	Lloh596, Lloh597
	.loh AdrpAdd	Lloh594, Lloh595
	.cfi_endproc
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
	.asciz	"Invalid hex number: %s\n"

l_.str.4:                               ; @.str.4
	.asciz	"Invalid binary number: %s\n"

l_.str.5:                               ; @.str.5
	.asciz	"Invalid octal number: %s\n"

l_.str.6:                               ; @.str.6
	.asciz	"Invalid decimal number: %s\n"

l_.str.7:                               ; @.str.7
	.asciz	"lr"

l_.str.8:                               ; @.str.8
	.asciz	"sp"

l_.str.9:                               ; @.str.9
	.asciz	"pc"

l_.str.10:                              ; @.str.10
	.asciz	"x"

l_.str.11:                              ; @.str.11
	.asciz	"y"

l_.str.12:                              ; @.str.12
	.asciz	"Invalid register: %s\n"

l_.str.13:                              ; @.str.13
	.asciz	"nop"

l_.str.14:                              ; @.str.14
	.asciz	"ret"

l_.str.15:                              ; @.str.15
	.asciz	"b"

l_.str.16:                              ; @.str.16
	.asciz	"bl"

l_.str.17:                              ; @.str.17
	.asciz	"blt"

l_.str.18:                              ; @.str.18
	.asciz	"bmi"

l_.str.19:                              ; @.str.19
	.asciz	"bgt"

l_.str.20:                              ; @.str.20
	.asciz	"bge"

l_.str.21:                              ; @.str.21
	.asciz	"bpl"

l_.str.22:                              ; @.str.22
	.asciz	"ble"

l_.str.23:                              ; @.str.23
	.asciz	"beq"

l_.str.24:                              ; @.str.24
	.asciz	"bz"

l_.str.25:                              ; @.str.25
	.asciz	"bne"

l_.str.26:                              ; @.str.26
	.asciz	"bnz"

l_.str.27:                              ; @.str.27
	.asciz	"bllt"

l_.str.28:                              ; @.str.28
	.asciz	"blmi"

l_.str.29:                              ; @.str.29
	.asciz	"blgt"

l_.str.30:                              ; @.str.30
	.asciz	"blge"

l_.str.31:                              ; @.str.31
	.asciz	"blpl"

l_.str.32:                              ; @.str.32
	.asciz	"blle"

l_.str.33:                              ; @.str.33
	.asciz	"bleq"

l_.str.34:                              ; @.str.34
	.asciz	"blz"

l_.str.35:                              ; @.str.35
	.asciz	"blne"

l_.str.36:                              ; @.str.36
	.asciz	"blnz"

l_.str.37:                              ; @.str.37
	.asciz	"br"

l_.str.38:                              ; @.str.38
	.asciz	"%s:%d: Expected register, got %s\n"

l_.str.39:                              ; @.str.39
	.asciz	"blr"

l_.str.40:                              ; @.str.40
	.asciz	"brlt"

l_.str.41:                              ; @.str.41
	.asciz	"brmi"

l_.str.42:                              ; @.str.42
	.asciz	"brgt"

l_.str.43:                              ; @.str.43
	.asciz	"brge"

l_.str.44:                              ; @.str.44
	.asciz	"brpl"

l_.str.45:                              ; @.str.45
	.asciz	"brle"

l_.str.46:                              ; @.str.46
	.asciz	"breq"

l_.str.47:                              ; @.str.47
	.asciz	"brz"

l_.str.48:                              ; @.str.48
	.asciz	"brne"

l_.str.49:                              ; @.str.49
	.asciz	"brnz"

l_.str.50:                              ; @.str.50
	.asciz	"blrlt"

l_.str.51:                              ; @.str.51
	.asciz	"blrmi"

l_.str.52:                              ; @.str.52
	.asciz	"blrgt"

l_.str.53:                              ; @.str.53
	.asciz	"blrge"

l_.str.54:                              ; @.str.54
	.asciz	"blrpl"

l_.str.55:                              ; @.str.55
	.asciz	"blrle"

l_.str.56:                              ; @.str.56
	.asciz	"blreq"

l_.str.57:                              ; @.str.57
	.asciz	"blrz"

l_.str.58:                              ; @.str.58
	.asciz	"blrne"

l_.str.59:                              ; @.str.59
	.asciz	"blrnz"

l_.str.60:                              ; @.str.60
	.asciz	"svc"

l_.str.61:                              ; @.str.61
	.asciz	"add"

l_.str.62:                              ; @.str.62
	.asciz	"%s:%d: Expected comma, got %s\n"

l_.str.63:                              ; @.str.63
	.asciz	"%s:%d: Number too large: %s\n"

l_.str.64:                              ; @.str.64
	.asciz	"%s:%d: Expected number or register, got %s\n"

l_.str.65:                              ; @.str.65
	.asciz	"%s:%d: Expected register or number, got %s\n"

l_.str.66:                              ; @.str.66
	.asciz	"sub"

l_.str.67:                              ; @.str.67
	.asciz	"mul"

l_.str.68:                              ; @.str.68
	.asciz	"div"

l_.str.69:                              ; @.str.69
	.asciz	"mod"

l_.str.70:                              ; @.str.70
	.asciz	"and"

l_.str.71:                              ; @.str.71
	.asciz	"or"

l_.str.72:                              ; @.str.72
	.asciz	"xor"

l_.str.73:                              ; @.str.73
	.asciz	"shl"

l_.str.74:                              ; @.str.74
	.asciz	"shr"

l_.str.75:                              ; @.str.75
	.asciz	"rol"

l_.str.76:                              ; @.str.76
	.asciz	"ror"

l_.str.77:                              ; @.str.77
	.asciz	"ldr"

l_.str.78:                              ; @.str.78
	.asciz	"ldrq"

l_.str.79:                              ; @.str.79
	.asciz	"%s:%d: Expected '[', got %s\n"

l_.str.80:                              ; @.str.80
	.asciz	"%s:%d: Expected ']', got %s\n"

l_.str.81:                              ; @.str.81
	.asciz	"%s:%d: Expected comma or ']', got %s\n"

l_.str.82:                              ; @.str.82
	.asciz	"str"

l_.str.83:                              ; @.str.83
	.asciz	"strq"

l_.str.84:                              ; @.str.84
	.asciz	"ldrd"

l_.str.85:                              ; @.str.85
	.asciz	"strd"

l_.str.86:                              ; @.str.86
	.asciz	"ldrw"

l_.str.87:                              ; @.str.87
	.asciz	"strw"

l_.str.88:                              ; @.str.88
	.asciz	"ldrb"

l_.str.89:                              ; @.str.89
	.asciz	"strb"

l_.str.90:                              ; @.str.90
	.asciz	"ldp"

l_.str.91:                              ; @.str.91
	.asciz	"ldpq"

l_.str.92:                              ; @.str.92
	.asciz	"stp"

l_.str.93:                              ; @.str.93
	.asciz	"stpq"

l_.str.94:                              ; @.str.94
	.asciz	"ldpd"

l_.str.95:                              ; @.str.95
	.asciz	"stpd"

l_.str.96:                              ; @.str.96
	.asciz	"ldpw"

l_.str.97:                              ; @.str.97
	.asciz	"stpw"

l_.str.98:                              ; @.str.98
	.asciz	"ldpb"

l_.str.99:                              ; @.str.99
	.asciz	"stpb"

l_.str.100:                             ; @.str.100
	.asciz	"cbz"

l_.str.101:                             ; @.str.101
	.asciz	"%s:%d: Expected identifier, got %s\n"

l_.str.102:                             ; @.str.102
	.asciz	"cbnz"

l_.str.103:                             ; @.str.103
	.asciz	"lea"

l_.str.104:                             ; @.str.104
	.asciz	"movz"

l_.str.105:                             ; @.str.105
	.asciz	"%s:%d: Expected number, got %s\n"

l_.str.106:                             ; @.str.106
	.asciz	"%s:%d: Expected 'shl', got %s\n"

l_.str.107:                             ; @.str.107
	.asciz	"%s:%d: Shift must be <= 3, but is %s\n"

l_.str.108:                             ; @.str.108
	.asciz	"movk"

l_.str.109:                             ; @.str.109
	.asciz	"mov"

l_.str.110:                             ; @.str.110
	.asciz	"inc"

l_.str.111:                             ; @.str.111
	.asciz	"dec"

l_.str.112:                             ; @.str.112
	.asciz	"tst"

l_.str.113:                             ; @.str.113
	.asciz	"cmp"

l_.str.114:                             ; @.str.114
	.asciz	"sbxt"

l_.str.115:                             ; @.str.115
	.asciz	"ubxt"

l_.str.116:                             ; @.str.116
	.asciz	"%s:%d: Lowest bit out of range: %s\n"

l_.str.117:                             ; @.str.117
	.asciz	"%s:%d: Number of bits out of range: %s\n"

l_.str.118:                             ; @.str.118
	.asciz	"sbdp"

l_.str.119:                             ; @.str.119
	.asciz	"ubdp"

l_.str.120:                             ; @.str.120
	.asciz	"fadd"

l_.str.121:                             ; @.str.121
	.asciz	"faddi"

l_.str.122:                             ; @.str.122
	.asciz	"fsub"

l_.str.123:                             ; @.str.123
	.asciz	"fsubi"

l_.str.124:                             ; @.str.124
	.asciz	"fmul"

l_.str.125:                             ; @.str.125
	.asciz	"fmuli"

l_.str.126:                             ; @.str.126
	.asciz	"fdiv"

l_.str.127:                             ; @.str.127
	.asciz	"fdivi"

l_.str.128:                             ; @.str.128
	.asciz	"fmod"

l_.str.129:                             ; @.str.129
	.asciz	"fmodi"

l_.str.130:                             ; @.str.130
	.asciz	"i2f"

l_.str.131:                             ; @.str.131
	.asciz	"f2i"

l_.str.132:                             ; @.str.132
	.asciz	"fsin"

l_.str.133:                             ; @.str.133
	.asciz	"fsqrt"

l_.str.134:                             ; @.str.134
	.asciz	"fcmp"

l_.str.135:                             ; @.str.135
	.asciz	"fcmpi"

l___func__.compile:                     ; @__func__.compile
	.asciz	"compile"

l_.str.137:                             ; @.str.137
	.asciz	"h64c.c"

l_.str.138:                             ; @.str.138
	.asciz	"(relocations)->items != NULL && \"Buy more RAM lol\""

l_.str.139:                             ; @.str.139
	.asciz	"(&data)->items != NULL && \"Buy more RAM lol\""

l_.str.140:                             ; @.str.140
	.asciz	"asciz"

l_.str.141:                             ; @.str.141
	.asciz	"ascii"

l_.str.142:                             ; @.str.142
	.asciz	"%s:%d: Expected string, got %s\n"

l_.str.144:                             ; @.str.144
	.asciz	"byte"

l_.str.145:                             ; @.str.145
	.asciz	"word"

l_.str.146:                             ; @.str.146
	.asciz	"dword"

l_.str.147:                             ; @.str.147
	.asciz	"qword"

l_.str.148:                             ; @.str.148
	.asciz	"%s:%d: Expected number or identifier, got %s\n"

l_.str.149:                             ; @.str.149
	.asciz	"float"

l_.str.150:                             ; @.str.150
	.asciz	"%s:%d: Expected float, got %s\n"

l_.str.151:                             ; @.str.151
	.asciz	"double"

l_.str.152:                             ; @.str.152
	.asciz	"offset"

l_.str.153:                             ; @.str.153
	.asciz	"zerofill"

l_.str.154:                             ; @.str.154
	.asciz	"global"

l_.str.155:                             ; @.str.155
	.asciz	"globl"

l_.str.156:                             ; @.str.156
	.asciz	"(&exported_symbols)->items != NULL && \"Buy more RAM lol\""

l_.str.157:                             ; @.str.157
	.asciz	"%s:%d: Unknown directive: %s\n"

l_.str.158:                             ; @.str.158
	.asciz	"(syms)->items != NULL && \"Buy more RAM lol\""

l_.str.159:                             ; @.str.159
	.asciz	"(&extern_relocs)->items != NULL && \"Buy more RAM lol\""

l_.str.160:                             ; @.str.160
	.asciz	"Relative target not aligned!"

l_.str.161:                             ; @.str.161
	.asciz	"Relative address too far: %x (%llx -> %llx)\n"

l_.str.162:                             ; @.str.162
	.asciz	"Unknown escape sequence: \\%c\n"

.zerofill __DATA,__bss,_src,8,3         ; @src
l___func__.parse:                       ; @__func__.parse
	.asciz	"parse"

l_.str.163:                             ; @.str.163
	.asciz	"(&tokens)->items != NULL && \"Buy more RAM lol\""

	.section	__DATA,__data
	.p2align	2, 0x0                          ; @line
_line:
	.long	1                               ; 0x1

	.section	__TEXT,__cstring,cstring_literals
l_.str.164:                             ; @.str.164
	.asciz	"fr"

l_.str.165:                             ; @.str.165
	.asciz	"0x"

l_.str.166:                             ; @.str.166
	.asciz	"0b"

l_.str.167:                             ; @.str.167
	.asciz	"%d"

l_.str.168:                             ; @.str.168
	.asciz	"["

l_.str.169:                             ; @.str.169
	.asciz	"]"

l_.str.170:                             ; @.str.170
	.asciz	","

l_.str.171:                             ; @.str.171
	.asciz	"+"

l_.str.172:                             ; @.str.172
	.asciz	"-"

.subsections_via_symbols
