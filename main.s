	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 14, 2
	.globl	_nob_mkdir_if_not_exists        ; -- Begin function nob_mkdir_if_not_exists
	.p2align	2
_nob_mkdir_if_not_exists:               ; @nob_mkdir_if_not_exists
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
	mov	w1, #493
	bl	_mkdir
	tbnz	w0, #31, LBB0_2
; %bb.1:
	str	x19, [sp]
Lloh0:
	adrp	x1, l_.str.2@PAGE
Lloh1:
	add	x1, x1, l_.str.2@PAGEOFF
	b	LBB0_4
LBB0_2:
	bl	___error
	ldr	w8, [x0]
	cmp	w8, #17
	b.ne	LBB0_5
; %bb.3:
	str	x19, [sp]
Lloh2:
	adrp	x1, l_.str@PAGE
Lloh3:
	add	x1, x1, l_.str@PAGEOFF
LBB0_4:
	mov	w0, #0
	bl	_nob_log
	mov	w0, #1
	b	LBB0_6
LBB0_5:
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	stp	x19, x0, [sp]
Lloh4:
	adrp	x1, l_.str.1@PAGE
Lloh5:
	add	x1, x1, l_.str.1@PAGEOFF
	mov	w0, #2
	bl	_nob_log
	mov	w0, #0
LBB0_6:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.loh AdrpAdd	Lloh0, Lloh1
	.loh AdrpAdd	Lloh2, Lloh3
	.loh AdrpAdd	Lloh4, Lloh5
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_log                        ; -- Begin function nob_log
	.p2align	2
_nob_log:                               ; @nob_log
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
	mov	x19, x1
Lloh6:
	adrp	x20, ___stderrp@GOTPAGE
Lloh7:
	ldr	x20, [x20, ___stderrp@GOTPAGEOFF]
	cmp	w0, #2
	b.eq	LBB1_4
; %bb.1:
	cmp	w0, #1
	b.eq	LBB1_5
; %bb.2:
	cbnz	w0, LBB1_7
; %bb.3:
	ldr	x3, [x20]
Lloh8:
	adrp	x0, l_.str.27@PAGE
Lloh9:
	add	x0, x0, l_.str.27@PAGEOFF
	mov	w1, #7
	b	LBB1_6
LBB1_4:
	ldr	x3, [x20]
Lloh10:
	adrp	x0, l_.str.29@PAGE
Lloh11:
	add	x0, x0, l_.str.29@PAGEOFF
	mov	w1, #8
	b	LBB1_6
LBB1_5:
	ldr	x3, [x20]
Lloh12:
	adrp	x0, l_.str.28@PAGE
Lloh13:
	add	x0, x0, l_.str.28@PAGEOFF
	mov	w1, #10
LBB1_6:
	mov	w2, #1
	bl	_fwrite
	add	x8, x29, #16
	str	x8, [sp, #8]
	ldr	x0, [x20]
	add	x2, x29, #16
	mov	x1, x19
	bl	_vfprintf
	ldr	x1, [x20]
	mov	w0, #10
	bl	_fputc
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
LBB1_7:
	bl	_nob_log.cold.1
	.loh AdrpLdrGot	Lloh6, Lloh7
	.loh AdrpAdd	Lloh8, Lloh9
	.loh AdrpAdd	Lloh10, Lloh11
	.loh AdrpAdd	Lloh12, Lloh13
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_copy_file                  ; -- Begin function nob_copy_file
	.p2align	2
_nob_copy_file:                         ; @nob_copy_file
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #240
	.cfi_def_cfa_offset 240
	stp	x26, x25, [sp, #160]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #176]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #192]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #208]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #224]            ; 16-byte Folded Spill
	add	x29, sp, #224
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
	mov	x23, x1
	mov	x22, x0
	stp	x0, x1, [sp]
Lloh14:
	adrp	x1, l_.str.3@PAGE
Lloh15:
	add	x1, x1, l_.str.3@PAGEOFF
	mov	w0, #0
	bl	_nob_log
	mov	w0, #32768
	bl	_malloc
	cbz	x0, LBB2_19
; %bb.1:
	mov	x19, x0
	mov	x0, x22
	mov	w1, #0
	bl	_open
	mov	x20, x0
	tbnz	w0, #31, LBB2_10
; %bb.2:
	add	x1, sp, #16
	mov	x0, x20
	bl	_fstat
	tbnz	w0, #31, LBB2_11
; %bb.3:
	ldrh	w8, [sp, #20]
	str	x8, [sp]
	mov	x0, x23
	mov	w1, #1537
	bl	_open
	mov	x21, x0
	tbnz	w0, #31, LBB2_13
; %bb.4:
	mov	x0, x20
	mov	x1, x19
	mov	w2, #32768
	bl	_read
	cbz	x0, LBB2_16
; %bb.5:
	mov	x25, x0
LBB2_6:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB2_7 Depth 2
	mov	x24, x19
	tbnz	x25, #63, LBB2_18
LBB2_7:                                 ;   Parent Loop BB2_6 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x0, x21
	mov	x1, x24
	mov	x2, x25
	bl	_write
	tbnz	x0, #63, LBB2_14
; %bb.8:                                ;   in Loop: Header=BB2_7 Depth=2
	sub	x25, x25, x0
	add	x24, x24, x0
	cmp	x25, #0
	b.gt	LBB2_7
; %bb.9:                                ;   in Loop: Header=BB2_6 Depth=1
	mov	x0, x20
	mov	x1, x19
	mov	w2, #32768
	bl	_read
	mov	x25, x0
	mov	w24, #1
	cbnz	x0, LBB2_6
	b	LBB2_17
LBB2_10:
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	stp	x22, x0, [sp]
Lloh16:
	adrp	x1, l_.str.7@PAGE
Lloh17:
	add	x1, x1, l_.str.7@PAGEOFF
	b	LBB2_12
LBB2_11:
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	stp	x22, x0, [sp]
Lloh18:
	adrp	x1, l_.str.8@PAGE
Lloh19:
	add	x1, x1, l_.str.8@PAGEOFF
LBB2_12:
	mov	w0, #2
	bl	_nob_log
	mov	w24, #0
	mov	w21, #-1
	b	LBB2_17
LBB2_13:
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	stp	x23, x0, [sp]
Lloh20:
	adrp	x1, l_.str.9@PAGE
Lloh21:
	add	x1, x1, l_.str.9@PAGEOFF
	b	LBB2_15
LBB2_14:
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	stp	x23, x0, [sp]
Lloh22:
	adrp	x1, l_.str.11@PAGE
Lloh23:
	add	x1, x1, l_.str.11@PAGEOFF
LBB2_15:
	mov	w0, #2
	bl	_nob_log
	mov	w24, #0
	b	LBB2_17
LBB2_16:
	mov	w24, #1
LBB2_17:
	mov	x0, x19
	bl	_free
	mov	x0, x20
	bl	_close
	mov	x0, x21
	bl	_close
	mov	x0, x24
	ldp	x29, x30, [sp, #224]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #208]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #192]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #176]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #160]            ; 16-byte Folded Reload
	add	sp, sp, #240
	ret
LBB2_18:
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	stp	x22, x0, [sp]
Lloh24:
	adrp	x1, l_.str.10@PAGE
Lloh25:
	add	x1, x1, l_.str.10@PAGEOFF
	b	LBB2_15
LBB2_19:
	bl	_nob_copy_file.cold.1
	.loh AdrpAdd	Lloh14, Lloh15
	.loh AdrpAdd	Lloh16, Lloh17
	.loh AdrpAdd	Lloh18, Lloh19
	.loh AdrpAdd	Lloh20, Lloh21
	.loh AdrpAdd	Lloh22, Lloh23
	.loh AdrpAdd	Lloh24, Lloh25
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_cmd_render                 ; -- Begin function nob_cmd_render
	.p2align	2
_nob_cmd_render:                        ; @nob_cmd_render
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
	ldr	x8, [x0, #8]
	cbz	x8, LBB3_44
; %bb.1:
	mov	x19, x1
	mov	x20, x0
	mov	x23, #0
	mov	w24, #32
	mov	w25, #256
	mov	w26, #39
	b	LBB3_5
LBB3_2:                                 ;   in Loop: Header=BB3_5 Depth=1
	ldr	x0, [x19]
LBB3_3:                                 ;   in Loop: Header=BB3_5 Depth=1
	add	x9, x8, #1
	str	x9, [x19, #8]
	strb	w26, [x0, x8]
LBB3_4:                                 ;   in Loop: Header=BB3_5 Depth=1
	add	x23, x23, #1
	ldr	x8, [x20, #8]
	cmp	x23, x8
	b.hs	LBB3_44
LBB3_5:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB3_12 Depth 2
                                        ;     Child Loop BB3_31 Depth 2
                                        ;     Child Loop BB3_39 Depth 2
	ldr	x8, [x20]
	ldr	x21, [x8, x23, lsl  #3]
	cbz	x21, LBB3_44
; %bb.6:                                ;   in Loop: Header=BB3_5 Depth=1
	cbz	x23, LBB3_17
; %bb.7:                                ;   in Loop: Header=BB3_5 Depth=1
	ldp	x9, x1, [x19, #8]
	add	x8, x9, #1
	cmp	x8, x1
	b.ls	LBB3_10
; %bb.8:                                ;   in Loop: Header=BB3_5 Depth=1
	cbz	x1, LBB3_11
; %bb.9:                                ;   in Loop: Header=BB3_5 Depth=1
	cmp	x8, x1
	b.hi	LBB3_12
	b	LBB3_14
LBB3_10:                                ;   in Loop: Header=BB3_5 Depth=1
	ldr	x0, [x19]
	b	LBB3_16
LBB3_11:                                ;   in Loop: Header=BB3_5 Depth=1
	str	x25, [x19, #16]
	mov	w1, #256
	cmp	x8, x1
	b.ls	LBB3_14
LBB3_12:                                ;   Parent Loop BB3_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	x1, x1, #1
	cmp	x8, x1
	b.hi	LBB3_12
; %bb.13:                               ;   in Loop: Header=BB3_5 Depth=1
	str	x1, [x19, #16]
LBB3_14:                                ;   in Loop: Header=BB3_5 Depth=1
	ldr	x0, [x19]
	bl	_realloc
	str	x0, [x19]
	cbz	x0, LBB3_45
; %bb.15:                               ;   in Loop: Header=BB3_5 Depth=1
	ldr	x9, [x19, #8]
LBB3_16:                                ;   in Loop: Header=BB3_5 Depth=1
	strb	w24, [x0, x9]
	ldr	x8, [x19, #8]
	add	x8, x8, #1
	str	x8, [x19, #8]
LBB3_17:                                ;   in Loop: Header=BB3_5 Depth=1
	mov	x0, x21
	mov	w1, #32
	bl	_strchr
	cbz	x0, LBB3_20
; %bb.18:                               ;   in Loop: Header=BB3_5 Depth=1
	ldp	x8, x9, [x19, #8]
	cmp	x8, x9
	b.hs	LBB3_23
; %bb.19:                               ;   in Loop: Header=BB3_5 Depth=1
	ldr	x0, [x19]
	b	LBB3_25
LBB3_20:                                ;   in Loop: Header=BB3_5 Depth=1
	mov	x0, x21
	bl	_strlen
	mov	x22, x0
	ldp	x9, x1, [x19, #8]
	add	x8, x9, x0
	cmp	x8, x1
	b.ls	LBB3_29
; %bb.21:                               ;   in Loop: Header=BB3_5 Depth=1
	cbz	x1, LBB3_38
; %bb.22:                               ;   in Loop: Header=BB3_5 Depth=1
	cmp	x8, x1
	b.hi	LBB3_39
	b	LBB3_41
LBB3_23:                                ;   in Loop: Header=BB3_5 Depth=1
	lsl	x8, x9, #1
	cmp	x9, #0
	csel	x1, x25, x8, eq
	str	x1, [x19, #16]
	ldr	x0, [x19]
	bl	_realloc
	str	x0, [x19]
	cbz	x0, LBB3_46
; %bb.24:                               ;   in Loop: Header=BB3_5 Depth=1
	ldr	x8, [x19, #8]
LBB3_25:                                ;   in Loop: Header=BB3_5 Depth=1
	add	x9, x8, #1
	str	x9, [x19, #8]
	strb	w26, [x0, x8]
	mov	x0, x21
	bl	_strlen
	mov	x22, x0
	ldp	x9, x1, [x19, #8]
	add	x8, x9, x0
	cmp	x8, x1
	b.ls	LBB3_28
; %bb.26:                               ;   in Loop: Header=BB3_5 Depth=1
	cbz	x1, LBB3_30
; %bb.27:                               ;   in Loop: Header=BB3_5 Depth=1
	cmp	x8, x1
	b.hi	LBB3_31
	b	LBB3_33
LBB3_28:                                ;   in Loop: Header=BB3_5 Depth=1
	ldr	x0, [x19]
	b	LBB3_35
LBB3_29:                                ;   in Loop: Header=BB3_5 Depth=1
	ldr	x0, [x19]
	b	LBB3_43
LBB3_30:                                ;   in Loop: Header=BB3_5 Depth=1
	str	x25, [x19, #16]
	mov	w1, #256
	cmp	x8, x1
	b.ls	LBB3_33
LBB3_31:                                ;   Parent Loop BB3_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	x1, x1, #1
	cmp	x8, x1
	b.hi	LBB3_31
; %bb.32:                               ;   in Loop: Header=BB3_5 Depth=1
	str	x1, [x19, #16]
LBB3_33:                                ;   in Loop: Header=BB3_5 Depth=1
	ldr	x0, [x19]
	bl	_realloc
	str	x0, [x19]
	cbz	x0, LBB3_47
; %bb.34:                               ;   in Loop: Header=BB3_5 Depth=1
	ldr	x9, [x19, #8]
LBB3_35:                                ;   in Loop: Header=BB3_5 Depth=1
	add	x0, x0, x9
	mov	x1, x21
	mov	x2, x22
	bl	_memcpy
	ldp	x8, x9, [x19, #8]
	add	x8, x8, x22
	cmp	x8, x9
	str	x8, [x19, #8]
	b.lo	LBB3_2
; %bb.36:                               ;   in Loop: Header=BB3_5 Depth=1
	lsl	x8, x9, #1
	cmp	x9, #0
	csel	x1, x25, x8, eq
	str	x1, [x19, #16]
	ldr	x0, [x19]
	bl	_realloc
	str	x0, [x19]
	cbz	x0, LBB3_48
; %bb.37:                               ;   in Loop: Header=BB3_5 Depth=1
	ldr	x8, [x19, #8]
	b	LBB3_3
LBB3_38:                                ;   in Loop: Header=BB3_5 Depth=1
	str	x25, [x19, #16]
	mov	w1, #256
	cmp	x8, x1
	b.ls	LBB3_41
LBB3_39:                                ;   Parent Loop BB3_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	x1, x1, #1
	cmp	x8, x1
	b.hi	LBB3_39
; %bb.40:                               ;   in Loop: Header=BB3_5 Depth=1
	str	x1, [x19, #16]
LBB3_41:                                ;   in Loop: Header=BB3_5 Depth=1
	ldr	x0, [x19]
	bl	_realloc
	str	x0, [x19]
	cbz	x0, LBB3_49
; %bb.42:                               ;   in Loop: Header=BB3_5 Depth=1
	ldr	x9, [x19, #8]
LBB3_43:                                ;   in Loop: Header=BB3_5 Depth=1
	add	x0, x0, x9
	mov	x1, x21
	mov	x2, x22
	bl	_memcpy
	ldr	x8, [x19, #8]
	add	x8, x8, x22
	str	x8, [x19, #8]
	b	LBB3_4
LBB3_44:
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #16]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp], #80             ; 16-byte Folded Reload
	ret
LBB3_45:
	bl	_nob_cmd_render.cold.5
LBB3_46:
	bl	_nob_cmd_render.cold.4
LBB3_47:
	bl	_nob_cmd_render.cold.2
LBB3_48:
	bl	_nob_cmd_render.cold.3
LBB3_49:
	bl	_nob_cmd_render.cold.1
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_cmd_run_async              ; -- Begin function nob_cmd_run_async
	.p2align	2
_nob_cmd_run_async:                     ; @nob_cmd_run_async
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #112
	.cfi_def_cfa_offset 112
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
	ldr	x8, [x0, #8]
	cbz	x8, LBB4_6
; %bb.1:
	mov	x19, x0
	stp	xzr, xzr, [sp, #40]
	str	xzr, [sp, #56]
	ldr	q0, [x0]
	str	q0, [sp, #16]
	ldr	x8, [x0, #16]
	str	x8, [sp, #32]
	add	x0, sp, #16
	add	x1, sp, #40
	bl	_nob_cmd_render
	ldp	x21, x9, [sp, #48]
	add	x8, x21, #1
	cmp	x8, x9
	b.ls	LBB4_7
; %bb.2:
	mov	w10, #256
	cmp	x9, #0
	csel	x9, x10, x9, eq
LBB4_3:                                 ; =>This Inner Loop Header: Depth=1
	mov	x1, x9
	lsl	x9, x9, #1
	cmp	x8, x1
	b.hi	LBB4_3
; %bb.4:
	ldr	x0, [sp, #40]
	bl	_realloc
	mov	x20, x0
	cbnz	x0, LBB4_8
; %bb.5:
	bl	_nob_cmd_run_async.cold.1
LBB4_6:
Lloh26:
	adrp	x1, l_.str.15@PAGE
Lloh27:
	add	x1, x1, l_.str.15@PAGEOFF
	b	LBB4_13
LBB4_7:
	ldr	x20, [sp, #40]
LBB4_8:
	strb	wzr, [x20, x21]
	str	x20, [sp]
Lloh28:
	adrp	x1, l_.str.18@PAGE
Lloh29:
	add	x1, x1, l_.str.18@PAGEOFF
	mov	w0, #0
	bl	_nob_log
	mov	x0, x20
	bl	_free
	bl	_fork
	tbnz	w0, #31, LBB4_12
; %bb.9:
	cbnz	w0, LBB4_14
; %bb.10:
	ldr	x8, [x19, #8]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	cbnz	x8, LBB4_15
; %bb.11:
	mov	x20, #0
	mov	x21, #0
	b	LBB4_18
LBB4_12:
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	str	x0, [sp]
Lloh30:
	adrp	x1, l_.str.19@PAGE
Lloh31:
	add	x1, x1, l_.str.19@PAGEOFF
LBB4_13:
	mov	w0, #2
	bl	_nob_log
	mov	w0, #-1
LBB4_14:
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB4_15:
	mov	w8, #256
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
LBB4_16:                                ; =>This Inner Loop Header: Depth=1
	mov	x21, x8
	lsl	x8, x8, #1
	cmp	x9, x21
	b.hi	LBB4_16
; %bb.17:
	lsl	x0, x21, #3
	bl	_malloc
	mov	x20, x0
	cbz	x0, LBB4_25
LBB4_18:
	ldr	x1, [x19]
	ldr	x22, [sp, #8]                   ; 8-byte Folded Reload
	lsl	x2, x22, #3
	mov	x0, x20
	bl	_memcpy
	add	x8, x22, #1
	cmp	x8, x21
	b.ls	LBB4_22
; %bb.19:
	mov	w9, #256
	cmp	x21, #0
	csel	x9, x9, x21, eq
LBB4_20:                                ; =>This Inner Loop Header: Depth=1
	mov	x10, x9
	lsl	x9, x9, #1
	cmp	x8, x10
	b.hi	LBB4_20
; %bb.21:
	lsl	x1, x10, #3
	mov	x0, x20
	bl	_realloc
	mov	x20, x0
	cbz	x0, LBB4_26
LBB4_22:
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	str	xzr, [x20, x8, lsl  #3]
	ldr	x8, [x19]
	ldr	x0, [x8]
	mov	x1, x20
	bl	_execvp
	tbz	w0, #31, LBB4_24
; %bb.23:
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	str	x0, [sp]
Lloh32:
	adrp	x1, l_.str.21@PAGE
Lloh33:
	add	x1, x1, l_.str.21@PAGEOFF
	mov	w0, #2
	bl	_nob_log
	mov	w0, #1
	bl	_exit
LBB4_24:
	bl	_nob_cmd_run_async.cold.3
LBB4_25:
	bl	_nob_cmd_run_async.cold.4
LBB4_26:
	bl	_nob_cmd_run_async.cold.2
	.loh AdrpAdd	Lloh26, Lloh27
	.loh AdrpAdd	Lloh28, Lloh29
	.loh AdrpAdd	Lloh30, Lloh31
	.loh AdrpAdd	Lloh32, Lloh33
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_procs_wait                 ; -- Begin function nob_procs_wait
	.p2align	2
_nob_procs_wait:                        ; @nob_procs_wait
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
	ldr	x8, [x0, #8]
	cbz	x8, LBB5_3
; %bb.1:
	mov	x20, x0
	mov	x21, #0
	mov	w19, #1
LBB5_2:                                 ; =>This Inner Loop Header: Depth=1
	ldr	x8, [x20]
	ldr	w0, [x8, x21, lsl  #2]
	bl	_nob_proc_wait
	and	w19, w0, w19
	add	x21, x21, #1
	ldr	x8, [x20, #8]
	cmp	x21, x8
	b.lo	LBB5_2
	b	LBB5_4
LBB5_3:
	mov	w19, #1
LBB5_4:
	mov	x0, x19
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_proc_wait                  ; -- Begin function nob_proc_wait
	.p2align	2
_nob_proc_wait:                         ; @nob_proc_wait
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x20, x19, [sp, #32]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #48]             ; 16-byte Folded Spill
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	cmn	w0, #1
	b.eq	LBB6_10
; %bb.1:
	mov	x19, x0
LBB6_2:                                 ; =>This Inner Loop Header: Depth=1
	stur	wzr, [x29, #-20]
	sub	x1, x29, #20
	mov	x0, x19
	mov	w2, #0
	bl	_waitpid
	tbnz	w0, #31, LBB6_7
; %bb.3:                                ;   in Loop: Header=BB6_2 Depth=1
	ldur	w8, [x29, #-20]
	and	w0, w8, #0x7f
	cmp	w0, #127
	b.eq	LBB6_2
; %bb.4:
	cbnz	w0, LBB6_8
; %bb.5:
	ubfx	w8, w8, #8, #8
	cbz	w8, LBB6_12
; %bb.6:
	str	x8, [sp]
Lloh34:
	adrp	x1, l_.str.24@PAGE
Lloh35:
	add	x1, x1, l_.str.24@PAGEOFF
	b	LBB6_9
LBB6_7:
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	stp	x19, x0, [sp]
Lloh36:
	adrp	x1, l_.str.23@PAGE
Lloh37:
	add	x1, x1, l_.str.23@PAGEOFF
	b	LBB6_9
LBB6_8:
	bl	_strsignal
	str	x0, [sp]
Lloh38:
	adrp	x1, l_.str.25@PAGE
Lloh39:
	add	x1, x1, l_.str.25@PAGEOFF
LBB6_9:
	mov	w0, #2
	bl	_nob_log
LBB6_10:
	mov	w0, #0
LBB6_11:
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
LBB6_12:
	mov	w0, #1
	b	LBB6_11
	.loh AdrpAdd	Lloh34, Lloh35
	.loh AdrpAdd	Lloh36, Lloh37
	.loh AdrpAdd	Lloh38, Lloh39
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_cmd_run_sync               ; -- Begin function nob_cmd_run_sync
	.p2align	2
_nob_cmd_run_sync:                      ; @nob_cmd_run_sync
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	q0, [x0]
	str	q0, [sp]
	ldr	x8, [x0, #16]
	str	x8, [sp, #16]
	mov	x0, sp
	bl	_nob_cmd_run_async
	cmn	w0, #1
	b.eq	LBB7_2
; %bb.1:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	b	_nob_proc_wait
LBB7_2:
	mov	w0, #0
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_shift_args                 ; -- Begin function nob_shift_args
	.p2align	2
_nob_shift_args:                        ; @nob_shift_args
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	w9, [x0]
	cmp	w9, #0
	b.le	LBB8_2
; %bb.1:
	ldr	x10, [x1]
	ldr	x8, [x10], #8
	str	x10, [x1]
	sub	w9, w9, #1
	str	w9, [x0]
	mov	x0, x8
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
LBB8_2:
	bl	_nob_shift_args.cold.1
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_read_entire_dir            ; -- Begin function nob_read_entire_dir
	.p2align	2
_nob_read_entire_dir:                   ; @nob_read_entire_dir
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
	mov	x21, x1
	mov	x19, x0
	bl	_opendir
	mov	x20, x0
	bl	___error
	cbz	x20, LBB9_10
; %bb.1:
	str	wzr, [x0]
	mov	x0, x20
	bl	_readdir
	cbz	x0, LBB9_7
; %bb.2:
	mov	x22, x0
	adrp	x25, _nob_temp_size@PAGE
Lloh40:
	adrp	x26, _nob_temp@PAGE
Lloh41:
	add	x26, x26, _nob_temp@PAGEOFF
	mov	w27, #256
LBB9_3:                                 ; =>This Inner Loop Header: Depth=1
	ldp	x9, x8, [x21, #8]
	cmp	x9, x8
	b.lo	LBB9_5
; %bb.4:                                ;   in Loop: Header=BB9_3 Depth=1
	lsl	x9, x8, #1
	cmp	x8, #0
	csel	x8, x27, x9, eq
	str	x8, [x21, #16]
	ldr	x0, [x21]
	lsl	x1, x8, #3
	bl	_realloc
	str	x0, [x21]
	cbz	x0, LBB9_12
LBB9_5:                                 ;   in Loop: Header=BB9_3 Depth=1
	add	x22, x22, #21
	mov	x0, x22
	bl	_strlen
	ldr	x8, [x25, _nob_temp_size@PAGEOFF]
	add	x9, x0, x8
	add	x9, x9, #1
	cmp	x9, #2048, lsl #12              ; =8388608
	b.hi	LBB9_13
; %bb.6:                                ;   in Loop: Header=BB9_3 Depth=1
	mov	x23, x0
	add	x24, x26, x8
	str	x9, [x25, _nob_temp_size@PAGEOFF]
	mov	x0, x24
	mov	x1, x22
	mov	x2, x23
	bl	_memcpy
	strb	wzr, [x24, x23]
	ldp	x8, x9, [x21]
	add	x10, x9, #1
	str	x10, [x21, #8]
	str	x24, [x8, x9, lsl  #3]
	mov	x0, x20
	bl	_readdir
	mov	x22, x0
	cbnz	x0, LBB9_3
LBB9_7:
	bl	___error
	ldr	w8, [x0]
	cmp	w8, #0
	cset	w21, eq
	cbz	w8, LBB9_9
; %bb.8:
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	stp	x19, x0, [sp]
Lloh42:
	adrp	x1, l_.str.33@PAGE
Lloh43:
	add	x1, x1, l_.str.33@PAGEOFF
	mov	w0, #2
	bl	_nob_log
LBB9_9:
	mov	x0, x20
	bl	_closedir
	b	LBB9_11
LBB9_10:
	ldr	w0, [x0]
	bl	_strerror
	stp	x19, x0, [sp]
Lloh44:
	adrp	x1, l_.str.31@PAGE
Lloh45:
	add	x1, x1, l_.str.31@PAGEOFF
	mov	w0, #2
	bl	_nob_log
	mov	w21, #0
LBB9_11:
	mov	x0, x21
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB9_12:
	bl	_nob_read_entire_dir.cold.2
LBB9_13:
	bl	_nob_read_entire_dir.cold.1
	.loh AdrpAdd	Lloh40, Lloh41
	.loh AdrpAdd	Lloh42, Lloh43
	.loh AdrpAdd	Lloh44, Lloh45
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_temp_strdup                ; -- Begin function nob_temp_strdup
	.p2align	2
_nob_temp_strdup:                       ; @nob_temp_strdup
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
	mov	x19, x0
	bl	_strlen
	adrp	x8, _nob_temp_size@PAGE
	ldr	x9, [x8, _nob_temp_size@PAGEOFF]
	add	x10, x0, x9
	add	x10, x10, #1
	cmp	x10, #2048, lsl #12             ; =8388608
	b.hi	LBB10_2
; %bb.1:
	mov	x20, x0
Lloh46:
	adrp	x11, _nob_temp@PAGE
Lloh47:
	add	x11, x11, _nob_temp@PAGEOFF
	add	x21, x11, x9
	str	x10, [x8, _nob_temp_size@PAGEOFF]
	mov	x0, x21
	mov	x1, x19
	mov	x2, x20
	bl	_memcpy
	strb	wzr, [x21, x20]
	mov	x0, x21
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
LBB10_2:
	bl	_nob_temp_strdup.cold.1
	.loh AdrpAdd	Lloh46, Lloh47
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_write_entire_file          ; -- Begin function nob_write_entire_file
	.p2align	2
_nob_write_entire_file:                 ; @nob_write_entire_file
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #80
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
	mov	x21, x2
	mov	x22, x1
	mov	x20, x0
Lloh48:
	adrp	x1, l_.str.34@PAGE
Lloh49:
	add	x1, x1, l_.str.34@PAGEOFF
	bl	_fopen
	cbz	x0, LBB11_5
; %bb.1:
	mov	x19, x0
	cbz	x21, LBB11_4
LBB11_2:                                ; =>This Inner Loop Header: Depth=1
	mov	x0, x22
	mov	w1, #1
	mov	x2, x21
	mov	x3, x19
	bl	_fwrite
	mov	x23, x0
	mov	x0, x19
	bl	_ferror
	cbnz	w0, LBB11_6
; %bb.3:                                ;   in Loop: Header=BB11_2 Depth=1
	add	x22, x22, x23
	subs	x21, x21, x23
	b.ne	LBB11_2
LBB11_4:
	mov	w20, #1
	b	LBB11_7
LBB11_5:
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	stp	x20, x0, [sp]
Lloh50:
	adrp	x1, l_.str.35@PAGE
Lloh51:
	add	x1, x1, l_.str.35@PAGEOFF
	mov	w0, #2
	bl	_nob_log
	mov	w20, #0
	b	LBB11_8
LBB11_6:
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	stp	x20, x0, [sp]
Lloh52:
	adrp	x1, l_.str.36@PAGE
Lloh53:
	add	x1, x1, l_.str.36@PAGEOFF
	mov	w0, #2
	bl	_nob_log
	mov	w20, #0
LBB11_7:
	mov	x0, x19
	bl	_fclose
LBB11_8:
	mov	x0, x20
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #80
	ret
	.loh AdrpAdd	Lloh48, Lloh49
	.loh AdrpAdd	Lloh50, Lloh51
	.loh AdrpAdd	Lloh52, Lloh53
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_get_file_type              ; -- Begin function nob_get_file_type
	.p2align	2
_nob_get_file_type:                     ; @nob_get_file_type
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #192
	.cfi_def_cfa_offset 192
	stp	x20, x19, [sp, #160]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #176]            ; 16-byte Folded Spill
	add	x29, sp, #176
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x0
	add	x1, sp, #16
	bl	_stat
	tbnz	w0, #31, LBB12_2
; %bb.1:
	ldrh	w8, [sp, #20]
	and	w8, w8, #0xf000
	mov	w9, #1
	mov	w10, #2
	mov	w11, #3
	cmp	w8, #8, lsl #12                 ; =32768
	csel	w11, w11, wzr, ne
	cmp	w8, #10, lsl #12                ; =40960
	csel	w10, w10, w11, eq
	cmp	w8, #4, lsl #12                 ; =16384
	csel	w0, w9, w10, eq
	b	LBB12_3
LBB12_2:
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	stp	x19, x0, [sp]
Lloh54:
	adrp	x1, l_.str.37@PAGE
Lloh55:
	add	x1, x1, l_.str.37@PAGEOFF
	mov	w0, #2
	bl	_nob_log
	mov	w0, #-1
LBB12_3:
	ldp	x29, x30, [sp, #176]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #160]            ; 16-byte Folded Reload
	add	sp, sp, #192
	ret
	.loh AdrpAdd	Lloh54, Lloh55
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_copy_directory_recursively ; -- Begin function nob_copy_directory_recursively
	.p2align	2
_nob_copy_directory_recursively:        ; @nob_copy_directory_recursively
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #304
	.cfi_def_cfa_offset 304
	stp	x28, x27, [sp, #208]            ; 16-byte Folded Spill
	stp	x26, x25, [sp, #224]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #240]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #256]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #272]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #288]            ; 16-byte Folded Spill
	add	x29, sp, #288
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
	mov	x21, x1
	mov	x19, x0
	stp	xzr, xzr, [sp, #32]
	str	xzr, [sp, #48]
	adrp	x20, _nob_temp_size@PAGE
	ldr	x23, [x20, _nob_temp_size@PAGEOFF]
	add	x1, sp, #56
	bl	_stat
	tbnz	w0, #31, LBB13_62
; %bb.1:
	ldrh	w8, [sp, #60]
	and	w8, w8, #0xf000
	cmp	w8, #10, lsl #12                ; =40960
	b.eq	LBB13_48
; %bb.2:
	cmp	w8, #8, lsl #12                 ; =32768
	b.eq	LBB13_47
; %bb.3:
	cmp	w8, #4, lsl #12                 ; =16384
	b.ne	LBB13_50
; %bb.4:
	mov	x0, x21
	bl	_nob_mkdir_if_not_exists
	cbz	w0, LBB13_51
; %bb.5:
	add	x1, sp, #32
	mov	x0, x19
	bl	_nob_read_entire_dir
	cbz	w0, LBB13_51
; %bb.6:
	str	x21, [sp, #24]                  ; 8-byte Folded Spill
	ldr	x28, [sp, #40]
	cbz	x28, LBB13_53
; %bb.7:
	mov	x22, #0
	mov	x25, #0
	mov	x21, #0
	mov	x26, #0
	mov	x24, #0
	str	x23, [sp, #16]                  ; 8-byte Folded Spill
	b	LBB13_11
LBB13_8:                                ;   in Loop: Header=BB13_11 Depth=1
	strb	wzr, [x21, x23]
	mov	x0, x22
	mov	x1, x21
	bl	_nob_copy_directory_recursively
	cbz	w0, LBB13_54
; %bb.9:                                ;   in Loop: Header=BB13_11 Depth=1
	ldr	x28, [sp, #40]
	adrp	x20, _nob_temp_size@PAGE
	ldr	x23, [sp, #16]                  ; 8-byte Folded Reload
LBB13_10:                               ;   in Loop: Header=BB13_11 Depth=1
	add	x24, x24, #1
	mov	w27, #1
	cmp	x24, x28
	b.hs	LBB13_52
LBB13_11:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB13_15 Depth 2
                                        ;     Child Loop BB13_19 Depth 2
                                        ;     Child Loop BB13_23 Depth 2
                                        ;     Child Loop BB13_27 Depth 2
                                        ;     Child Loop BB13_32 Depth 2
                                        ;     Child Loop BB13_36 Depth 2
                                        ;     Child Loop BB13_40 Depth 2
                                        ;     Child Loop BB13_44 Depth 2
	ldr	x8, [sp, #32]
	ldr	x27, [x8, x24, lsl  #3]
	mov	x0, x27
Lloh56:
	adrp	x1, l_.str.38@PAGE
Lloh57:
	add	x1, x1, l_.str.38@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB13_10
; %bb.12:                               ;   in Loop: Header=BB13_11 Depth=1
	mov	x0, x27
Lloh58:
	adrp	x1, l_.str.39@PAGE
Lloh59:
	add	x1, x1, l_.str.39@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB13_10
; %bb.13:                               ;   in Loop: Header=BB13_11 Depth=1
	mov	x0, x19
	bl	_strlen
	mov	x27, x0
	cmp	x0, x25
	b.ls	LBB13_17
; %bb.14:                               ;   in Loop: Header=BB13_11 Depth=1
	cmp	x25, #0
	mov	w8, #256
	csel	x8, x8, x25, eq
LBB13_15:                               ;   Parent Loop BB13_11 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x25, x8
	lsl	x8, x8, #1
	cmp	x27, x25
	b.hi	LBB13_15
; %bb.16:                               ;   in Loop: Header=BB13_11 Depth=1
	mov	x0, x22
	mov	x1, x25
	bl	_realloc
	mov	x22, x0
	cbz	x0, LBB13_55
LBB13_17:                               ;   in Loop: Header=BB13_11 Depth=1
	mov	x0, x22
	mov	x1, x19
	mov	x2, x27
	bl	_memcpy
	add	x20, x27, #1
	cmp	x20, x25
	b.ls	LBB13_21
; %bb.18:                               ;   in Loop: Header=BB13_11 Depth=1
	cmp	x25, #0
	mov	w8, #256
	csel	x8, x8, x25, eq
LBB13_19:                               ;   Parent Loop BB13_11 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x25, x8
	lsl	x8, x8, #1
	cmp	x20, x25
	b.hi	LBB13_19
; %bb.20:                               ;   in Loop: Header=BB13_11 Depth=1
	mov	x0, x22
	mov	x1, x25
	bl	_realloc
	mov	x22, x0
	cbz	x0, LBB13_56
LBB13_21:                               ;   in Loop: Header=BB13_11 Depth=1
	mov	w8, #47
	strb	w8, [x22, x27]
	ldr	x8, [sp, #32]
	ldr	x27, [x8, x24, lsl  #3]
	mov	x0, x27
	bl	_strlen
	mov	x28, x0
	add	x23, x0, x20
	cmp	x23, x25
	b.ls	LBB13_25
; %bb.22:                               ;   in Loop: Header=BB13_11 Depth=1
	cmp	x25, #0
	mov	w8, #256
	csel	x8, x8, x25, eq
LBB13_23:                               ;   Parent Loop BB13_11 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x25, x8
	lsl	x8, x8, #1
	cmp	x23, x25
	b.hi	LBB13_23
; %bb.24:                               ;   in Loop: Header=BB13_11 Depth=1
	mov	x0, x22
	mov	x1, x25
	bl	_realloc
	mov	x22, x0
	cbz	x0, LBB13_57
LBB13_25:                               ;   in Loop: Header=BB13_11 Depth=1
	add	x0, x22, x20
	mov	x1, x27
	mov	x2, x28
	bl	_memcpy
	add	x8, x23, #1
	cmp	x8, x25
	b.ls	LBB13_29
; %bb.26:                               ;   in Loop: Header=BB13_11 Depth=1
	cmp	x25, #0
	mov	w9, #256
	csel	x9, x9, x25, eq
	ldr	x20, [sp, #24]                  ; 8-byte Folded Reload
LBB13_27:                               ;   Parent Loop BB13_11 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x25, x9
	lsl	x9, x9, #1
	cmp	x8, x25
	b.hi	LBB13_27
; %bb.28:                               ;   in Loop: Header=BB13_11 Depth=1
	mov	x0, x22
	mov	x1, x25
	bl	_realloc
	mov	x22, x0
	cbnz	x0, LBB13_30
	b	LBB13_58
LBB13_29:                               ;   in Loop: Header=BB13_11 Depth=1
	ldr	x20, [sp, #24]                  ; 8-byte Folded Reload
LBB13_30:                               ;   in Loop: Header=BB13_11 Depth=1
	strb	wzr, [x22, x23]
	mov	x0, x20
	bl	_strlen
	mov	x27, x0
	cmp	x0, x26
	b.ls	LBB13_34
; %bb.31:                               ;   in Loop: Header=BB13_11 Depth=1
	cmp	x26, #0
	mov	w8, #256
	csel	x8, x8, x26, eq
LBB13_32:                               ;   Parent Loop BB13_11 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x26, x8
	lsl	x8, x8, #1
	cmp	x27, x26
	b.hi	LBB13_32
; %bb.33:                               ;   in Loop: Header=BB13_11 Depth=1
	mov	x0, x21
	mov	x1, x26
	bl	_realloc
	mov	x21, x0
	cbz	x0, LBB13_59
LBB13_34:                               ;   in Loop: Header=BB13_11 Depth=1
	mov	x0, x21
	mov	x1, x20
	mov	x2, x27
	bl	_memcpy
	add	x20, x27, #1
	cmp	x20, x26
	b.ls	LBB13_38
; %bb.35:                               ;   in Loop: Header=BB13_11 Depth=1
	cmp	x26, #0
	mov	w8, #256
	csel	x8, x8, x26, eq
LBB13_36:                               ;   Parent Loop BB13_11 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x26, x8
	lsl	x8, x8, #1
	cmp	x20, x26
	b.hi	LBB13_36
; %bb.37:                               ;   in Loop: Header=BB13_11 Depth=1
	mov	x0, x21
	mov	x1, x26
	bl	_realloc
	mov	x21, x0
	cbz	x0, LBB13_60
LBB13_38:                               ;   in Loop: Header=BB13_11 Depth=1
	mov	w8, #47
	strb	w8, [x21, x27]
	ldr	x8, [sp, #32]
	ldr	x27, [x8, x24, lsl  #3]
	mov	x0, x27
	bl	_strlen
	mov	x28, x0
	add	x23, x0, x20
	cmp	x23, x26
	b.ls	LBB13_42
; %bb.39:                               ;   in Loop: Header=BB13_11 Depth=1
	cmp	x26, #0
	mov	w8, #256
	csel	x8, x8, x26, eq
LBB13_40:                               ;   Parent Loop BB13_11 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x26, x8
	lsl	x8, x8, #1
	cmp	x23, x26
	b.hi	LBB13_40
; %bb.41:                               ;   in Loop: Header=BB13_11 Depth=1
	mov	x0, x21
	mov	x1, x26
	bl	_realloc
	mov	x21, x0
	cbz	x0, LBB13_61
LBB13_42:                               ;   in Loop: Header=BB13_11 Depth=1
	add	x0, x21, x20
	mov	x1, x27
	mov	x2, x28
	bl	_memcpy
	add	x8, x23, #1
	cmp	x8, x26
	b.ls	LBB13_8
; %bb.43:                               ;   in Loop: Header=BB13_11 Depth=1
	cmp	x26, #0
	mov	w9, #256
	csel	x9, x9, x26, eq
LBB13_44:                               ;   Parent Loop BB13_11 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x26, x9
	lsl	x9, x9, #1
	cmp	x8, x26
	b.hi	LBB13_44
; %bb.45:                               ;   in Loop: Header=BB13_11 Depth=1
	mov	x0, x21
	mov	x1, x26
	bl	_realloc
	mov	x21, x0
	cbnz	x0, LBB13_8
; %bb.46:
	bl	_nob_copy_directory_recursively.cold.9
LBB13_47:
	mov	x0, x19
	mov	x1, x21
	bl	_nob_copy_file
	mov	x27, x0
	b	LBB13_49
LBB13_48:
Lloh60:
	adrp	x1, l_.str.43@PAGE
Lloh61:
	add	x1, x1, l_.str.43@PAGEOFF
	mov	w27, #1
	mov	w0, #1
	bl	_nob_log
LBB13_49:
	mov	x21, #0
	mov	x22, #0
	b	LBB13_52
LBB13_50:
	str	x19, [sp]
Lloh62:
	adrp	x1, l_.str.44@PAGE
Lloh63:
	add	x1, x1, l_.str.44@PAGEOFF
	mov	w0, #2
	bl	_nob_log
LBB13_51:
	mov	x21, #0
	mov	x22, #0
	mov	w27, #0
LBB13_52:
	str	x23, [x20, _nob_temp_size@PAGEOFF]
	mov	x0, x22
	bl	_free
	mov	x0, x21
	bl	_free
	ldr	x0, [sp, #32]
	bl	_free
	mov	x0, x27
	ldp	x29, x30, [sp, #288]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #272]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #256]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #240]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #224]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #208]            ; 16-byte Folded Reload
	add	sp, sp, #304
	ret
LBB13_53:
	mov	x21, #0
	mov	x22, #0
	mov	w27, #1
	b	LBB13_52
LBB13_54:
	mov	w27, #0
	adrp	x20, _nob_temp_size@PAGE
	ldr	x23, [sp, #16]                  ; 8-byte Folded Reload
	b	LBB13_52
LBB13_55:
	bl	_nob_copy_directory_recursively.cold.2
LBB13_56:
	bl	_nob_copy_directory_recursively.cold.3
LBB13_57:
	bl	_nob_copy_directory_recursively.cold.4
LBB13_58:
	bl	_nob_copy_directory_recursively.cold.5
LBB13_59:
	bl	_nob_copy_directory_recursively.cold.6
LBB13_60:
	bl	_nob_copy_directory_recursively.cold.7
LBB13_61:
	bl	_nob_copy_directory_recursively.cold.8
LBB13_62:
	add	x1, sp, #56
	mov	x0, x19
	bl	_nob_copy_directory_recursively.cold.1
	.loh AdrpAdd	Lloh56, Lloh57
	.loh AdrpAdd	Lloh58, Lloh59
	.loh AdrpAdd	Lloh60, Lloh61
	.loh AdrpAdd	Lloh62, Lloh63
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_temp_save                  ; -- Begin function nob_temp_save
	.p2align	2
_nob_temp_save:                         ; @nob_temp_save
	.cfi_startproc
; %bb.0:
Lloh64:
	adrp	x8, _nob_temp_size@PAGE
Lloh65:
	ldr	x0, [x8, _nob_temp_size@PAGEOFF]
	ret
	.loh AdrpLdr	Lloh64, Lloh65
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_temp_rewind                ; -- Begin function nob_temp_rewind
	.p2align	2
_nob_temp_rewind:                       ; @nob_temp_rewind
	.cfi_startproc
; %bb.0:
	adrp	x8, _nob_temp_size@PAGE
	str	x0, [x8, _nob_temp_size@PAGEOFF]
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_temp_alloc                 ; -- Begin function nob_temp_alloc
	.p2align	2
_nob_temp_alloc:                        ; @nob_temp_alloc
	.cfi_startproc
; %bb.0:
	adrp	x8, _nob_temp_size@PAGE
	ldr	x10, [x8, _nob_temp_size@PAGEOFF]
	add	x9, x10, x0
	cmp	x9, #2048, lsl #12              ; =8388608
	b.ls	LBB16_2
; %bb.1:
	mov	x0, #0
	ret
LBB16_2:
Lloh66:
	adrp	x11, _nob_temp@PAGE
Lloh67:
	add	x11, x11, _nob_temp@PAGEOFF
	add	x0, x11, x10
	str	x9, [x8, _nob_temp_size@PAGEOFF]
	ret
	.loh AdrpAdd	Lloh66, Lloh67
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_temp_sprintf               ; -- Begin function nob_temp_sprintf
	.p2align	2
_nob_temp_sprintf:                      ; @nob_temp_sprintf
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
	add	x8, x29, #16
	str	x8, [sp, #8]
	add	x3, x29, #16
	mov	x0, #0
	mov	x1, #0
	mov	x2, x19
	bl	_vsnprintf
	tbnz	w0, #31, LBB17_3
; %bb.1:
	add	w1, w0, #1
	adrp	x8, _nob_temp_size@PAGE
	ldr	x9, [x8, _nob_temp_size@PAGEOFF]
	add	x10, x9, x1
	cmp	x10, #2048, lsl #12             ; =8388608
	b.hi	LBB17_4
; %bb.2:
Lloh68:
	adrp	x11, _nob_temp@PAGE
Lloh69:
	add	x11, x11, _nob_temp@PAGEOFF
	add	x20, x11, x9
	str	x10, [x8, _nob_temp_size@PAGEOFF]
	add	x8, x29, #16
	str	x8, [sp, #8]
	add	x3, x29, #16
	mov	x0, x20
	mov	x2, x19
	bl	_vsnprintf
	mov	x0, x20
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
LBB17_3:
	bl	_nob_temp_sprintf.cold.1
LBB17_4:
	bl	_nob_temp_sprintf.cold.2
	.loh AdrpAdd	Lloh68, Lloh69
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_temp_reset                 ; -- Begin function nob_temp_reset
	.p2align	2
_nob_temp_reset:                        ; @nob_temp_reset
	.cfi_startproc
; %bb.0:
	adrp	x8, _nob_temp_size@PAGE
	str	xzr, [x8, _nob_temp_size@PAGEOFF]
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_temp_sv_to_cstr            ; -- Begin function nob_temp_sv_to_cstr
	.p2align	2
_nob_temp_sv_to_cstr:                   ; @nob_temp_sv_to_cstr
	.cfi_startproc
; %bb.0:
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	adrp	x8, _nob_temp_size@PAGE
	ldr	x9, [x8, _nob_temp_size@PAGEOFF]
	add	x10, x0, x9
	add	x10, x10, #1
	cmp	x10, #2048, lsl #12             ; =8388608
	b.hi	LBB19_2
; %bb.1:
	mov	x19, x0
Lloh70:
	adrp	x11, _nob_temp@PAGE
Lloh71:
	add	x11, x11, _nob_temp@PAGEOFF
	add	x20, x11, x9
	str	x10, [x8, _nob_temp_size@PAGEOFF]
	mov	x0, x20
	mov	x2, x19
	bl	_memcpy
	strb	wzr, [x20, x19]
	mov	x0, x20
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB19_2:
	bl	_nob_temp_sv_to_cstr.cold.1
	.loh AdrpAdd	Lloh70, Lloh71
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_needs_rebuild              ; -- Begin function nob_needs_rebuild
	.p2align	2
_nob_needs_rebuild:                     ; @nob_needs_rebuild
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #208
	.cfi_def_cfa_offset 208
	stp	x22, x21, [sp, #160]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #176]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #192]            ; 16-byte Folded Spill
	add	x29, sp, #192
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	mov	x20, x2
	mov	x21, x1
	mov	x19, x0
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [sp, #128]
	stp	q0, q0, [sp, #96]
	stp	q0, q0, [sp, #64]
	stp	q0, q0, [sp, #32]
	str	q0, [sp, #16]
	add	x1, sp, #16
	bl	_stat
	tbnz	w0, #31, LBB20_7
; %bb.1:
	cbz	x20, LBB20_6
; %bb.2:
	ldr	w22, [sp, #64]
LBB20_3:                                ; =>This Inner Loop Header: Depth=1
	ldr	x19, [x21]
	add	x1, sp, #16
	mov	x0, x19
	bl	_stat
	tbnz	w0, #31, LBB20_9
; %bb.4:                                ;   in Loop: Header=BB20_3 Depth=1
	ldr	w8, [sp, #64]
	cmp	w8, w22
	b.gt	LBB20_8
; %bb.5:                                ;   in Loop: Header=BB20_3 Depth=1
	add	x21, x21, #8
	subs	x20, x20, #1
	b.ne	LBB20_3
LBB20_6:
	mov	w0, #0
	b	LBB20_10
LBB20_7:
	bl	___error
	ldr	w8, [x0]
	cmp	w8, #2
	b.ne	LBB20_9
LBB20_8:
	mov	w0, #1
	b	LBB20_10
LBB20_9:
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	stp	x19, x0, [sp]
Lloh72:
	adrp	x1, l_.str.50@PAGE
Lloh73:
	add	x1, x1, l_.str.50@PAGEOFF
	mov	w0, #2
	bl	_nob_log
	mov	w0, #-1
LBB20_10:
	ldp	x29, x30, [sp, #192]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #176]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #160]            ; 16-byte Folded Reload
	add	sp, sp, #208
	ret
	.loh AdrpAdd	Lloh72, Lloh73
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_needs_rebuild1             ; -- Begin function nob_needs_rebuild1
	.p2align	2
_nob_needs_rebuild1:                    ; @nob_needs_rebuild1
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x1, [sp, #8]
	add	x1, sp, #8
	mov	w2, #1
	bl	_nob_needs_rebuild
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_rename                     ; -- Begin function nob_rename
	.p2align	2
_nob_rename:                            ; @nob_rename
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
	mov	x20, x1
	mov	x19, x0
	stp	x0, x1, [sp]
Lloh74:
	adrp	x1, l_.str.51@PAGE
Lloh75:
	add	x1, x1, l_.str.51@PAGEOFF
	mov	w0, #0
	bl	_nob_log
	mov	x0, x19
	mov	x1, x20
	bl	_rename
	mov	x21, x0
	tbz	w0, #31, LBB22_2
; %bb.1:
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	stp	x20, x0, [sp, #8]
	str	x19, [sp]
Lloh76:
	adrp	x1, l_.str.52@PAGE
Lloh77:
	add	x1, x1, l_.str.52@PAGEOFF
	mov	w0, #2
	bl	_nob_log
LBB22_2:
	mvn	w8, w21
	lsr	w0, w8, #31
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #80
	ret
	.loh AdrpAdd	Lloh74, Lloh75
	.loh AdrpAdd	Lloh76, Lloh77
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_read_entire_file           ; -- Begin function nob_read_entire_file
	.p2align	2
_nob_read_entire_file:                  ; @nob_read_entire_file
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #80
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
	mov	x21, x1
	mov	x19, x0
Lloh78:
	adrp	x1, l_.str.53@PAGE
Lloh79:
	add	x1, x1, l_.str.53@PAGEOFF
	bl	_fopen
	cbz	x0, LBB23_10
; %bb.1:
	mov	x20, x0
	mov	x1, #0
	mov	w2, #2
	bl	_fseek
	tbnz	w0, #31, LBB23_8
; %bb.2:
	mov	x0, x20
	bl	_ftell
	tbnz	x0, #63, LBB23_8
; %bb.3:
	mov	x22, x0
	mov	x0, x20
	mov	x1, #0
	mov	w2, #0
	bl	_fseek
	tbnz	w0, #31, LBB23_8
; %bb.4:
	ldp	x8, x9, [x21, #8]
	ldr	x0, [x21]
	add	x23, x8, x22
	cmp	x23, x9
	b.ls	LBB23_7
; %bb.5:
	mov	x1, x23
	bl	_realloc
	str	x0, [x21]
	cbz	x0, LBB23_13
; %bb.6:
	str	x23, [x21, #16]
	ldr	x8, [x21, #8]
LBB23_7:
	add	x0, x0, x8
	mov	x1, x22
	mov	w2, #1
	mov	x3, x20
	bl	_fread
	mov	x0, x20
	bl	_ferror
	cbz	w0, LBB23_12
LBB23_8:
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	stp	x19, x0, [sp]
Lloh80:
	adrp	x1, l_.str.56@PAGE
Lloh81:
	add	x1, x1, l_.str.56@PAGEOFF
	mov	w0, #2
	bl	_nob_log
	mov	w19, #0
LBB23_9:
	mov	x0, x20
	bl	_fclose
	b	LBB23_11
LBB23_10:
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	stp	x19, x0, [sp]
Lloh82:
	adrp	x1, l_.str.56@PAGE
Lloh83:
	add	x1, x1, l_.str.56@PAGEOFF
	mov	w0, #2
	bl	_nob_log
	mov	w19, #0
LBB23_11:
	mov	x0, x19
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #80
	ret
LBB23_12:
	str	x23, [x21, #8]
	mov	w19, #1
	b	LBB23_9
LBB23_13:
	bl	_nob_read_entire_file.cold.1
	.loh AdrpAdd	Lloh78, Lloh79
	.loh AdrpAdd	Lloh80, Lloh81
	.loh AdrpAdd	Lloh82, Lloh83
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_sv_chop_by_delim           ; -- Begin function nob_sv_chop_by_delim
	.p2align	2
_nob_sv_chop_by_delim:                  ; @nob_sv_chop_by_delim
	.cfi_startproc
; %bb.0:
	mov	x9, x1
	ldp	x8, x1, [x0]
	cbz	x8, LBB24_4
; %bb.1:
	mov	x10, #0
	and	w11, w9, #0xff
LBB24_2:                                ; =>This Inner Loop Header: Depth=1
	ldrb	w12, [x1, x10]
	add	x9, x10, #1
	cmp	w12, w11
	b.eq	LBB24_5
; %bb.3:                                ;   in Loop: Header=BB24_2 Depth=1
	mov	x10, x9
	cmp	x8, x9
	b.ne	LBB24_2
LBB24_4:
	mov	x11, #0
	mov	x9, x8
	b	LBB24_6
LBB24_5:
	mvn	x11, x10
	add	x11, x11, x8
	mov	x8, x10
LBB24_6:
	add	x9, x1, x9
	stp	x11, x9, [x0]
	mov	x0, x8
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_sv_from_parts              ; -- Begin function nob_sv_from_parts
	.p2align	2
_nob_sv_from_parts:                     ; @nob_sv_from_parts
	.cfi_startproc
; %bb.0:
	mov	x8, x0
	mov	x0, x1
	mov	x1, x8
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_sv_trim_left               ; -- Begin function nob_sv_trim_left
	.p2align	2
_nob_sv_trim_left:                      ; @nob_sv_trim_left
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
	mov	x20, x1
	mov	x19, x0
	mov	x21, #0
	cbz	x0, LBB26_7
; %bb.1:
Lloh84:
	adrp	x22, __DefaultRuneLocale@GOTPAGE
Lloh85:
	ldr	x22, [x22, __DefaultRuneLocale@GOTPAGEOFF]
LBB26_2:                                ; =>This Inner Loop Header: Depth=1
	ldrsb	w0, [x20, x21]
	tbnz	w0, #31, LBB26_4
; %bb.3:                                ;   in Loop: Header=BB26_2 Depth=1
	add	x8, x22, w0, uxtw #2
	ldr	w8, [x8, #60]
	and	w0, w8, #0x4000
	cbnz	w0, LBB26_5
	b	LBB26_7
LBB26_4:                                ;   in Loop: Header=BB26_2 Depth=1
	mov	w1, #16384
	bl	___maskrune
	cbz	w0, LBB26_7
LBB26_5:                                ;   in Loop: Header=BB26_2 Depth=1
	add	x21, x21, #1
	cmp	x19, x21
	b.ne	LBB26_2
; %bb.6:
	mov	x21, x19
LBB26_7:
	add	x1, x20, x21
	sub	x0, x19, x21
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh84, Lloh85
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_sv_trim_right              ; -- Begin function nob_sv_trim_right
	.p2align	2
_nob_sv_trim_right:                     ; @nob_sv_trim_right
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
	mov	x19, x1
	mov	x20, x0
	mov	x21, #0
	cbz	x0, LBB27_7
; %bb.1:
	sub	x22, x19, #1
Lloh86:
	adrp	x23, __DefaultRuneLocale@GOTPAGE
Lloh87:
	ldr	x23, [x23, __DefaultRuneLocale@GOTPAGEOFF]
LBB27_2:                                ; =>This Inner Loop Header: Depth=1
	ldrsb	w0, [x22, x20]
	tbnz	w0, #31, LBB27_4
; %bb.3:                                ;   in Loop: Header=BB27_2 Depth=1
	add	x8, x23, w0, uxtw #2
	ldr	w8, [x8, #60]
	and	w0, w8, #0x4000
	cbnz	w0, LBB27_5
	b	LBB27_7
LBB27_4:                                ;   in Loop: Header=BB27_2 Depth=1
	mov	w1, #16384
	bl	___maskrune
	cbz	w0, LBB27_7
LBB27_5:                                ;   in Loop: Header=BB27_2 Depth=1
	add	x21, x21, #1
	sub	x22, x22, #1
	cmp	x20, x21
	b.ne	LBB27_2
; %bb.6:
	mov	x21, x20
LBB27_7:
	sub	x0, x20, x21
	mov	x1, x19
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp], #64             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh86, Lloh87
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_sv_trim                    ; -- Begin function nob_sv_trim
	.p2align	2
_nob_sv_trim:                           ; @nob_sv_trim
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
	mov	x21, x0
Lloh88:
	adrp	x22, __DefaultRuneLocale@GOTPAGE
Lloh89:
	ldr	x22, [x22, __DefaultRuneLocale@GOTPAGEOFF]
	mov	x23, #0
	cbz	x0, LBB28_6
LBB28_1:                                ; =>This Inner Loop Header: Depth=1
	ldrsb	w0, [x20, x23]
	tbnz	w0, #31, LBB28_3
; %bb.2:                                ;   in Loop: Header=BB28_1 Depth=1
	add	x8, x22, w0, uxtw #2
	ldr	w8, [x8, #60]
	and	w0, w8, #0x4000
	cbnz	w0, LBB28_4
	b	LBB28_6
LBB28_3:                                ;   in Loop: Header=BB28_1 Depth=1
	mov	w1, #16384
	bl	___maskrune
	cbz	w0, LBB28_6
LBB28_4:                                ;   in Loop: Header=BB28_1 Depth=1
	add	x23, x23, #1
	cmp	x21, x23
	b.ne	LBB28_1
; %bb.5:
	mov	x23, x21
LBB28_6:
	add	x19, x20, x23
	mov	x24, #0
	subs	x23, x21, x23
	b.eq	LBB28_13
; %bb.7:
	add	x8, x21, x20
	sub	x20, x8, #1
LBB28_8:                                ; =>This Inner Loop Header: Depth=1
	ldrsb	w0, [x20]
	tbnz	w0, #31, LBB28_10
; %bb.9:                                ;   in Loop: Header=BB28_8 Depth=1
	add	x8, x22, w0, uxtw #2
	ldr	w8, [x8, #60]
	and	w0, w8, #0x4000
	cbnz	w0, LBB28_11
	b	LBB28_13
LBB28_10:                               ;   in Loop: Header=BB28_8 Depth=1
	mov	w1, #16384
	bl	___maskrune
	cbz	w0, LBB28_13
LBB28_11:                               ;   in Loop: Header=BB28_8 Depth=1
	add	x24, x24, #1
	sub	x20, x20, #1
	cmp	x23, x24
	b.ne	LBB28_8
; %bb.12:
	mov	x24, x23
LBB28_13:
	sub	x0, x23, x24
	mov	x1, x19
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp], #64             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh88, Lloh89
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_sv_from_cstr               ; -- Begin function nob_sv_from_cstr
	.p2align	2
_nob_sv_from_cstr:                      ; @nob_sv_from_cstr
	.cfi_startproc
; %bb.0:
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x0
	bl	_strlen
	mov	x1, x19
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_sv_eq                      ; -- Begin function nob_sv_eq
	.p2align	2
_nob_sv_eq:                             ; @nob_sv_eq
	.cfi_startproc
; %bb.0:
	cmp	x0, x2
	b.ne	LBB30_2
; %bb.1:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x0
	mov	x0, x1
	mov	x1, x3
	mov	x2, x8
	bl	_memcmp
	cmp	w0, #0
	cset	w0, eq
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
LBB30_2:
	mov	w0, #0
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_nob_file_exists                ; -- Begin function nob_file_exists
	.p2align	2
_nob_file_exists:                       ; @nob_file_exists
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #192
	.cfi_def_cfa_offset 192
	stp	x20, x19, [sp, #160]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #176]            ; 16-byte Folded Spill
	add	x29, sp, #176
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x0
	add	x1, sp, #16
	bl	_stat
	tbnz	w0, #31, LBB31_2
; %bb.1:
	mov	w0, #1
	b	LBB31_5
LBB31_2:
	bl	___error
	ldr	w8, [x0]
	cmp	w8, #2
	b.ne	LBB31_4
; %bb.3:
	mov	w0, #0
	b	LBB31_5
LBB31_4:
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	stp	x19, x0, [sp]
Lloh90:
	adrp	x1, l_.str.57@PAGE
Lloh91:
	add	x1, x1, l_.str.57@PAGEOFF
	mov	w0, #2
	bl	_nob_log
	mov	w0, #-1
LBB31_5:
	ldp	x29, x30, [sp, #176]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #160]            ; 16-byte Folded Reload
	add	sp, sp, #192
	ret
	.loh AdrpAdd	Lloh90, Lloh91
	.cfi_endproc
                                        ; -- End function
	.globl	_exec_svc                       ; -- Begin function exec_svc
	.p2align	2
_exec_svc:                              ; @exec_svc
	.cfi_startproc
; %bb.0:
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x0
	mov	x20, x8
	ldr	x8, [x0, #64]
Lloh92:
	adrp	x9, _svcs@PAGE
Lloh93:
	add	x9, x9, _svcs@PAGEOFF
	ldr	x8, [x9, x8, lsl  #3]
	ldr	x0, [x0]
	ldp	x1, x2, [x19, #8]
	ldp	x3, x4, [x19, #24]
	ldp	x5, x6, [x19, #40]
	ldr	x7, [x19, #56]
	blr	x8
	str	x0, [x19]
	mov	x0, x20
	mov	x1, x19
	mov	w2, #528
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	b	_memcpy
	.loh AdrpAdd	Lloh92, Lloh93
	.cfi_endproc
                                        ; -- End function
	.globl	_exec_fpu_type                  ; -- Begin function exec_fpu_type
	.p2align	2
_exec_fpu_type:                         ; @exec_fpu_type
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
	mov	x21, x1
	mov	x20, x8
	ubfx	w8, w21, #8, #4
	mov	x19, x0
Lloh94:
	adrp	x9, lJTI33_0@PAGE
Lloh95:
	add	x9, x9, lJTI33_0@PAGEOFF
	adr	x10, LBB33_1
	ldrb	w11, [x9, x8]
	add	x10, x10, x11, lsl #2
	br	x10
LBB33_1:
	ubfx	x8, x21, #22, #5
	ldr	d0, [x19, x8, lsl  #3]
	ubfx	x8, x21, #27, #5
	ldr	d1, [x19, x8, lsl  #3]
	b	LBB33_3
LBB33_2:
	ubfx	x8, x21, #22, #5
	ldr	d0, [x19, x8, lsl  #3]
	ubfx	x8, x21, #27, #5
	ldr	d1, [x19, x8, lsl  #3]
	scvtf	d1, d1
LBB33_3:
	fadd	d0, d0, d1
	b	LBB33_15
LBB33_4:
	ubfx	x8, x21, #22, #5
	ldr	d0, [x19, x8, lsl  #3]
	ubfx	x8, x21, #27, #5
	ldr	d1, [x19, x8, lsl  #3]
	fsub	d0, d0, d1
	b	LBB33_15
LBB33_5:
	ubfx	x8, x21, #22, #5
	ldr	d0, [x19, x8, lsl  #3]
	ubfx	x8, x21, #27, #5
	ldr	d1, [x19, x8, lsl  #3]
	scvtf	d1, d1
	fsub	d0, d0, d1
	b	LBB33_15
LBB33_6:
	ubfx	x8, x21, #22, #5
	ldr	d0, [x19, x8, lsl  #3]
	ubfx	x8, x21, #27, #5
	ldr	d1, [x19, x8, lsl  #3]
	fmul	d0, d0, d1
	b	LBB33_15
LBB33_7:
	ubfx	x8, x21, #22, #5
	ldr	d0, [x19, x8, lsl  #3]
	ubfx	x8, x21, #27, #5
	ldr	d1, [x19, x8, lsl  #3]
	scvtf	d1, d1
	fmul	d0, d0, d1
	b	LBB33_15
LBB33_8:
	ubfx	x8, x21, #22, #5
	ldr	d0, [x19, x8, lsl  #3]
	ubfx	x8, x21, #27, #5
	ldr	d1, [x19, x8, lsl  #3]
	fdiv	d0, d0, d1
	b	LBB33_15
LBB33_9:
	ubfx	x8, x21, #22, #5
	ldr	d0, [x19, x8, lsl  #3]
	ubfx	x8, x21, #27, #5
	ldr	d1, [x19, x8, lsl  #3]
	scvtf	d1, d1
	fdiv	d0, d0, d1
	b	LBB33_15
LBB33_10:
	ubfx	x8, x21, #22, #5
	ldr	d0, [x19, x8, lsl  #3]
	ubfx	x8, x21, #27, #5
	ldr	d1, [x19, x8, lsl  #3]
	bl	_fmod
	b	LBB33_15
LBB33_11:
	ubfx	x8, x21, #22, #5
	ldr	d0, [x19, x8, lsl  #3]
	ubfx	x8, x21, #27, #5
	ldr	d1, [x19, x8, lsl  #3]
	scvtf	d1, d1
	bl	_fmod
	b	LBB33_15
LBB33_12:
	ubfx	x8, x21, #22, #5
	ldr	x8, [x19, x8, lsl  #3]
	cmp	x8, #0
	cset	w9, eq
	scvtf	d0, x8
	ldr	w10, [x19, #256]
	and	w10, w10, #0xfffffffc
	bfi	w10, w9, #1, #1
	lsr	x8, x8, #63
	orr	w8, w10, w8
	b	LBB33_16
LBB33_13:
	ubfx	x8, x21, #22, #5
	ldr	d0, [x19, x8, lsl  #3]
	fcvtzs	x8, d0
	cmp	x8, #0
	cset	w9, eq
	ldr	w10, [x19, #256]
	and	w10, w10, #0xfffffffc
	bfi	w10, w9, #1, #1
	lsr	x9, x8, #63
	orr	w9, w10, w9
	str	w9, [x19, #256]
	ubfx	x9, x21, #17, #5
	str	x8, [x19, x9, lsl  #3]
	b	LBB33_18
LBB33_14:
	ubfx	x8, x21, #22, #5
	ldr	d0, [x19, x8, lsl  #3]
	bl	_sin
LBB33_15:
	fcmp	d0, #0.0
	cset	w8, eq
	ldr	w9, [x19, #256]
	and	w9, w9, #0xfffffffc
	bfi	w9, w8, #1, #1
	cset	w8, mi
	orr	w8, w9, w8
LBB33_16:
	str	w8, [x19, #256]
LBB33_17:
	ubfx	x8, x21, #17, #5
	str	d0, [x19, x8, lsl  #3]
LBB33_18:
	mov	x0, x20
	mov	x1, x19
	mov	w2, #528
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	b	_memcpy
LBB33_19:
	ubfx	x8, x21, #22, #5
	ldr	d0, [x19, x8, lsl  #3]
	fsqrt	d0, d0
	fcmp	d0, #0.0
	cset	w8, eq
	ldr	w9, [x19, #256]
	and	w9, w9, #0xfffffffc
	bfi	w9, w8, #1, #1
	str	w9, [x19, #256]
	b	LBB33_17
LBB33_20:
	ubfx	x8, x21, #22, #5
	ldr	d0, [x19, x8, lsl  #3]
	ubfx	x8, x21, #27, #5
	ldr	d1, [x19, x8, lsl  #3]
	b	LBB33_22
LBB33_21:
	ubfx	x8, x21, #22, #5
	ldr	d0, [x19, x8, lsl  #3]
	ubfx	x8, x21, #27, #5
	ldr	d1, [x19, x8, lsl  #3]
	scvtf	d1, d1
LBB33_22:
	fsub	d0, d0, d1
	fcmp	d0, #0.0
	cset	w8, eq
	ldr	w9, [x19, #256]
	and	w9, w9, #0xfffffffc
	bfi	w9, w8, #1, #1
	cset	w8, mi
	orr	w8, w9, w8
	str	w8, [x19, #256]
	b	LBB33_18
	.loh AdrpAdd	Lloh94, Lloh95
	.cfi_endproc
	.section	__TEXT,__const
lJTI33_0:
	.byte	(LBB33_1-LBB33_1)>>2
	.byte	(LBB33_2-LBB33_1)>>2
	.byte	(LBB33_4-LBB33_1)>>2
	.byte	(LBB33_5-LBB33_1)>>2
	.byte	(LBB33_6-LBB33_1)>>2
	.byte	(LBB33_7-LBB33_1)>>2
	.byte	(LBB33_8-LBB33_1)>>2
	.byte	(LBB33_9-LBB33_1)>>2
	.byte	(LBB33_10-LBB33_1)>>2
	.byte	(LBB33_11-LBB33_1)>>2
	.byte	(LBB33_12-LBB33_1)>>2
	.byte	(LBB33_13-LBB33_1)>>2
	.byte	(LBB33_14-LBB33_1)>>2
	.byte	(LBB33_19-LBB33_1)>>2
	.byte	(LBB33_20-LBB33_1)>>2
	.byte	(LBB33_21-LBB33_1)>>2
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_exec_simd_type                 ; -- Begin function exec_simd_type
	.p2align	2
_exec_simd_type:                        ; @exec_simd_type
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
	mov	x19, x0
	mov	x20, x8
	ubfx	w9, w1, #19, #5
	cmp	w9, #15
	b.hi	LBB34_61
; %bb.1:
	ubfx	w8, w1, #16, #3
Lloh96:
	adrp	x10, lJTI34_0@PAGE
Lloh97:
	add	x10, x10, lJTI34_0@PAGEOFF
	adr	x11, LBB34_2
	ldrh	w12, [x10, x9, lsl  #1]
	add	x11, x11, x12, lsl #2
	br	x11
LBB34_2:
	cmp	w8, #6
	b.hi	LBB34_146
; %bb.3:
Lloh98:
	adrp	x9, lJTI34_14@PAGE
Lloh99:
	add	x9, x9, lJTI34_14@PAGEOFF
	adr	x10, LBB34_4
	ldrh	w11, [x9, x8, lsl  #1]
	add	x10, x10, x11, lsl #2
	br	x10
LBB34_4:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldrb	w11, [x8]
	ldrb	w12, [x10]
	add	w11, w12, w11
	strb	w11, [x9]
	ldrb	w11, [x8, #1]
	ldrb	w12, [x10, #1]
	add	w11, w12, w11
	strb	w11, [x9, #1]
	ldrb	w11, [x8, #2]
	ldrb	w12, [x10, #2]
	add	w11, w12, w11
	strb	w11, [x9, #2]
	ldrb	w8, [x8, #3]
	ldrb	w10, [x10, #3]
	add	w8, w10, w8
	strb	w8, [x9, #3]
	b	LBB34_146
LBB34_5:
	cmp	w8, #6
	b.hi	LBB34_146
; %bb.6:
Lloh100:
	adrp	x9, lJTI34_13@PAGE
Lloh101:
	add	x9, x9, lJTI34_13@PAGEOFF
	adr	x10, LBB34_7
	ldrh	w11, [x9, x8, lsl  #1]
	add	x10, x10, x11, lsl #2
	br	x10
LBB34_7:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldrb	w11, [x8]
	ldrb	w12, [x10]
	sub	w11, w11, w12
	strb	w11, [x9]
	ldrb	w11, [x8, #1]
	ldrb	w12, [x10, #1]
	sub	w11, w11, w12
	strb	w11, [x9, #1]
	ldrb	w11, [x8, #2]
	ldrb	w12, [x10, #2]
	sub	w11, w11, w12
	b	LBB34_57
LBB34_8:
	cmp	w8, #6
	b.hi	LBB34_146
; %bb.9:
Lloh102:
	adrp	x9, lJTI34_12@PAGE
Lloh103:
	add	x9, x9, lJTI34_12@PAGEOFF
	adr	x10, LBB34_10
	ldrh	w11, [x9, x8, lsl  #1]
	add	x10, x10, x11, lsl #2
	br	x10
LBB34_10:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldrb	w11, [x8]
	ldrb	w12, [x10]
	mul	w11, w12, w11
	strb	w11, [x9]
	ldrb	w11, [x8, #1]
	ldrb	w12, [x10, #1]
	mul	w11, w12, w11
	strb	w11, [x9, #1]
	ldrb	w11, [x8, #2]
	ldrb	w12, [x10, #2]
	mul	w11, w12, w11
	strb	w11, [x9, #2]
	ldrb	w8, [x8, #3]
	ldrb	w10, [x10, #3]
	mul	w8, w10, w8
	strb	w8, [x9, #3]
	b	LBB34_146
LBB34_11:
	cmp	w8, #6
	b.hi	LBB34_146
; %bb.12:
Lloh104:
	adrp	x9, lJTI34_11@PAGE
Lloh105:
	add	x9, x9, lJTI34_11@PAGEOFF
	adr	x10, LBB34_13
	ldrh	w11, [x9, x8, lsl  #1]
	add	x10, x10, x11, lsl #2
	br	x10
LBB34_13:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldrb	w11, [x8]
	ldrb	w12, [x10]
	udiv	w11, w11, w12
	strb	w11, [x9]
	ldrb	w11, [x8, #1]
	ldrb	w12, [x10, #1]
	udiv	w11, w11, w12
	strb	w11, [x9, #1]
	ldrb	w11, [x8, #2]
	ldrb	w12, [x10, #2]
	udiv	w11, w11, w12
	strb	w11, [x9, #2]
	ldrb	w8, [x8, #3]
	ldrb	w10, [x10, #3]
	udiv	w8, w8, w10
	strb	w8, [x9, #3]
	b	LBB34_146
LBB34_14:
	cmp	w8, #4
	b.hi	LBB34_61
; %bb.15:
Lloh106:
	adrp	x9, lJTI34_10@PAGE
Lloh107:
	add	x9, x9, lJTI34_10@PAGEOFF
	adr	x10, LBB34_16
	ldrh	w11, [x9, x8, lsl  #1]
	add	x10, x10, x11, lsl #2
	br	x10
LBB34_16:
	ubfx	x8, x1, #10, #3
	add	x12, x19, #272
	lsl	x13, x8, #5
	add	x9, x12, x13
	ubfx	x8, x1, #13, #3
	lsl	x11, x8, #5
	add	x10, x12, x11
	ubfx	x8, x1, #7, #3
	lsl	x14, x8, #5
	add	x8, x12, x14
	add	x12, x14, x19
	add	x12, x12, #272
	add	x13, x13, x19
	sub	x13, x12, x13
	sub	x13, x13, #272
	cmp	x13, #16
	b.lo	LBB34_18
; %bb.17:
	add	x11, x11, x19
	sub	x11, x12, x11
	sub	x11, x11, #272
	cmp	x11, #15
	b.hi	LBB34_77
LBB34_18:
	mov	x11, #0
LBB34_19:                               ; =>This Inner Loop Header: Depth=1
	ldr	x12, [x9, x11]
	ldr	x13, [x10, x11]
	udiv	x14, x12, x13
	msub	x12, x14, x13, x12
	str	x12, [x8, x11]
	add	x11, x11, #8
	cmp	x11, #256
	b.ne	LBB34_19
	b	LBB34_146
LBB34_20:
	cmp	w8, #4
	b.hi	LBB34_61
; %bb.21:
Lloh108:
	adrp	x9, lJTI34_9@PAGE
Lloh109:
	add	x9, x9, lJTI34_9@PAGEOFF
	adr	x10, LBB34_22
	ldrh	w11, [x9, x8, lsl  #1]
	add	x10, x10, x11, lsl #2
	br	x10
LBB34_22:
	ubfx	x8, x1, #10, #3
	add	x12, x19, #272
	lsl	x13, x8, #5
	add	x9, x12, x13
	ubfx	x8, x1, #13, #3
	lsl	x11, x8, #5
	add	x10, x12, x11
	ubfx	x8, x1, #7, #3
	lsl	x14, x8, #5
	add	x8, x12, x14
	add	x12, x14, x19
	add	x12, x12, #272
	add	x13, x13, x19
	sub	x13, x12, x13
	sub	x13, x13, #272
	cmp	x13, #16
	b.lo	LBB34_24
; %bb.23:
	add	x11, x11, x19
	sub	x11, x12, x11
	sub	x11, x11, #272
	cmp	x11, #15
	b.hi	LBB34_77
LBB34_24:
	mov	x11, #0
LBB34_25:                               ; =>This Inner Loop Header: Depth=1
	ldr	x12, [x9, x11]
	ldr	x13, [x10, x11]
	udiv	x14, x12, x13
	msub	x12, x14, x13, x12
	str	x12, [x8, x11]
	add	x11, x11, #8
	cmp	x11, #256
	b.ne	LBB34_25
	b	LBB34_146
LBB34_26:
	cmp	w8, #4
	b.hi	LBB34_61
; %bb.27:
Lloh110:
	adrp	x9, lJTI34_8@PAGE
Lloh111:
	add	x9, x9, lJTI34_8@PAGEOFF
	adr	x10, LBB34_28
	ldrh	w11, [x9, x8, lsl  #1]
	add	x10, x10, x11, lsl #2
	br	x10
LBB34_28:
	ubfx	x8, x1, #10, #3
	add	x12, x19, #272
	lsl	x13, x8, #5
	add	x9, x12, x13
	ubfx	x8, x1, #13, #3
	lsl	x11, x8, #5
	add	x10, x12, x11
	ubfx	x8, x1, #7, #3
	lsl	x14, x8, #5
	add	x8, x12, x14
	add	x12, x14, x19
	add	x12, x12, #272
	add	x13, x13, x19
	sub	x13, x12, x13
	sub	x13, x13, #272
	cmp	x13, #16
	b.lo	LBB34_30
; %bb.29:
	add	x11, x11, x19
	sub	x11, x12, x11
	sub	x11, x11, #272
	cmp	x11, #15
	b.hi	LBB34_77
LBB34_30:
	mov	x11, #0
LBB34_31:                               ; =>This Inner Loop Header: Depth=1
	ldr	x12, [x9, x11]
	ldr	x13, [x10, x11]
	udiv	x14, x12, x13
	msub	x12, x14, x13, x12
	str	x12, [x8, x11]
	add	x11, x11, #8
	cmp	x11, #256
	b.ne	LBB34_31
	b	LBB34_146
LBB34_32:
	cmp	w8, #4
	b.hi	LBB34_61
; %bb.33:
Lloh112:
	adrp	x9, lJTI34_7@PAGE
Lloh113:
	add	x9, x9, lJTI34_7@PAGEOFF
	adr	x10, LBB34_34
	ldrh	w11, [x9, x8, lsl  #1]
	add	x10, x10, x11, lsl #2
	br	x10
LBB34_34:
	ubfx	x8, x1, #10, #3
	add	x12, x19, #272
	lsl	x13, x8, #5
	add	x9, x12, x13
	ubfx	x8, x1, #13, #3
	lsl	x11, x8, #5
	add	x10, x12, x11
	ubfx	x8, x1, #7, #3
	lsl	x14, x8, #5
	add	x8, x12, x14
	add	x12, x14, x19
	add	x12, x12, #272
	add	x13, x13, x19
	sub	x13, x12, x13
	sub	x13, x13, #272
	cmp	x13, #16
	b.lo	LBB34_36
; %bb.35:
	add	x11, x11, x19
	sub	x11, x12, x11
	sub	x11, x11, #272
	cmp	x11, #15
	b.hi	LBB34_77
LBB34_36:
	mov	x11, #0
LBB34_37:                               ; =>This Inner Loop Header: Depth=1
	ldr	x12, [x9, x11]
	ldr	x13, [x10, x11]
	udiv	x14, x12, x13
	msub	x12, x14, x13, x12
	str	x12, [x8, x11]
	add	x11, x11, #8
	cmp	x11, #256
	b.ne	LBB34_37
	b	LBB34_146
LBB34_38:
	cmp	w8, #4
	b.hi	LBB34_61
; %bb.39:
Lloh114:
	adrp	x9, lJTI34_6@PAGE
Lloh115:
	add	x9, x9, lJTI34_6@PAGEOFF
	adr	x10, LBB34_40
	ldrh	w11, [x9, x8, lsl  #1]
	add	x10, x10, x11, lsl #2
	br	x10
LBB34_40:
	ubfx	x8, x1, #10, #3
	add	x12, x19, #272
	lsl	x13, x8, #5
	add	x9, x12, x13
	ubfx	x8, x1, #13, #3
	lsl	x11, x8, #5
	add	x10, x12, x11
	ubfx	x8, x1, #7, #3
	lsl	x14, x8, #5
	add	x8, x12, x14
	add	x12, x14, x19
	add	x12, x12, #272
	add	x13, x13, x19
	sub	x13, x12, x13
	sub	x13, x13, #272
	cmp	x13, #16
	b.lo	LBB34_42
; %bb.41:
	add	x11, x11, x19
	sub	x11, x12, x11
	sub	x11, x11, #272
	cmp	x11, #15
	b.hi	LBB34_77
LBB34_42:
	mov	x11, #0
LBB34_43:                               ; =>This Inner Loop Header: Depth=1
	ldr	x12, [x9, x11]
	ldr	x13, [x10, x11]
	udiv	x14, x12, x13
	msub	x12, x14, x13, x12
	str	x12, [x8, x11]
	add	x11, x11, #8
	cmp	x11, #256
	b.ne	LBB34_43
	b	LBB34_146
LBB34_44:
	cmp	w8, #4
	b.hi	LBB34_61
; %bb.45:
Lloh116:
	adrp	x9, lJTI34_5@PAGE
Lloh117:
	add	x9, x9, lJTI34_5@PAGEOFF
	adr	x10, LBB34_46
	ldrh	w11, [x9, x8, lsl  #1]
	add	x10, x10, x11, lsl #2
	br	x10
LBB34_46:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldrb	w11, [x8]
	ldrb	w12, [x10]
	udiv	w13, w11, w12
	msub	w11, w13, w12, w11
	strb	w11, [x9]
	ldrb	w11, [x8, #1]
	ldrb	w12, [x10, #1]
	udiv	w13, w11, w12
	msub	w11, w13, w12, w11
	strb	w11, [x9, #1]
	ldrb	w11, [x8, #2]
	ldrb	w12, [x10, #2]
	udiv	w13, w11, w12
	msub	w11, w13, w12, w11
	strb	w11, [x9, #2]
	ldrb	w8, [x8, #3]
	ldrb	w10, [x10, #3]
	udiv	w11, w8, w10
	msub	w8, w11, w10, w8
	strb	w8, [x9, #3]
	b	LBB34_146
LBB34_47:
	cmp	w8, #4
	b.hi	LBB34_61
; %bb.48:
Lloh118:
	adrp	x9, lJTI34_4@PAGE
Lloh119:
	add	x9, x9, lJTI34_4@PAGEOFF
	adr	x10, LBB34_49
	ldrh	w11, [x9, x8, lsl  #1]
	add	x10, x10, x11, lsl #2
	br	x10
LBB34_49:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldrb	w11, [x8]
	ldrb	w12, [x10]
	and	w13, w12, #0x7
	lsr	w13, w11, w13
	neg	w12, w12
	and	w12, w12, #0x7
	lsl	w11, w11, w12
	orr	w11, w13, w11
	strb	w11, [x9]
	ldrb	w11, [x8, #1]
	ldrb	w12, [x10, #1]
	and	w13, w12, #0x7
	lsr	w13, w11, w13
	neg	w12, w12
	and	w12, w12, #0x7
	lsl	w11, w11, w12
	orr	w11, w13, w11
	strb	w11, [x9, #1]
	ldrb	w11, [x8, #2]
	ldrb	w12, [x10, #2]
	and	w13, w12, #0x7
	lsr	w13, w11, w13
	neg	w12, w12
	and	w12, w12, #0x7
	lsl	w11, w11, w12
	orr	w11, w13, w11
	strb	w11, [x9, #2]
	ldrb	w8, [x8, #3]
	ldrb	w10, [x10, #3]
	and	w11, w10, #0x7
	lsr	w11, w8, w11
	neg	w10, w10
	and	w10, w10, #0x7
	lsl	w8, w8, w10
	b	LBB34_53
LBB34_50:
	cmp	w8, #4
	b.hi	LBB34_61
; %bb.51:
Lloh120:
	adrp	x9, lJTI34_3@PAGE
Lloh121:
	add	x9, x9, lJTI34_3@PAGEOFF
	adr	x10, LBB34_52
	ldrh	w11, [x9, x8, lsl  #1]
	add	x10, x10, x11, lsl #2
	br	x10
LBB34_52:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldrb	w11, [x8]
	ldrb	w12, [x10]
	and	w13, w12, #0x7
	lsl	w13, w11, w13
	neg	w12, w12
	and	w12, w12, #0x7
	lsr	w11, w11, w12
	orr	w11, w13, w11
	strb	w11, [x9]
	ldrb	w11, [x8, #1]
	ldrb	w12, [x10, #1]
	and	w13, w12, #0x7
	lsl	w13, w11, w13
	neg	w12, w12
	and	w12, w12, #0x7
	lsr	w11, w11, w12
	orr	w11, w13, w11
	strb	w11, [x9, #1]
	ldrb	w11, [x8, #2]
	ldrb	w12, [x10, #2]
	and	w13, w12, #0x7
	lsl	w13, w11, w13
	neg	w12, w12
	and	w12, w12, #0x7
	lsr	w11, w11, w12
	orr	w11, w13, w11
	strb	w11, [x9, #2]
	ldrb	w8, [x8, #3]
	ldrb	w10, [x10, #3]
	and	w11, w10, #0x7
	lsl	w11, w8, w11
	neg	w10, w10
	and	w10, w10, #0x7
	lsr	w8, w8, w10
LBB34_53:
	orr	w8, w11, w8
	strb	w8, [x9, #3]
	b	LBB34_146
LBB34_54:
	cmp	w8, #6
	b.hi	LBB34_146
; %bb.55:
Lloh122:
	adrp	x9, lJTI34_2@PAGE
Lloh123:
	add	x9, x9, lJTI34_2@PAGEOFF
	adr	x10, LBB34_56
	ldrh	w11, [x9, x8, lsl  #1]
	add	x10, x10, x11, lsl #2
	br	x10
LBB34_56:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldrb	w11, [x8]
	ldrb	w12, [x10]
	add	w11, w12, w11
	strb	w11, [x9]
	ldrb	w11, [x8, #1]
	ldrb	w12, [x10, #1]
	sub	w11, w11, w12
	strb	w11, [x9, #1]
	ldrb	w11, [x8, #2]
	ldrb	w12, [x10, #2]
	add	w11, w12, w11
LBB34_57:
	strb	w11, [x9, #2]
	ldrb	w8, [x8, #3]
	ldrb	w10, [x10, #3]
	sub	w8, w8, w10
	strb	w8, [x9, #3]
	b	LBB34_146
LBB34_58:
	cmp	w8, #6
	b.hi	LBB34_61
; %bb.59:
Lloh124:
	adrp	x9, lJTI34_1@PAGE
Lloh125:
	add	x9, x9, lJTI34_1@PAGEOFF
	adr	x10, LBB34_60
	ldrh	w11, [x9, x8, lsl  #1]
	add	x10, x10, x11, lsl #2
	br	x10
LBB34_60:
	ubfx	x8, x1, #10, #3
	add	x10, x19, #272
	add	x8, x10, x8, lsl #5
	ubfx	x9, x1, #13, #3
	add	x9, x10, x9, lsl #5
	ubfx	x11, x1, #7, #3
	ldp	w12, w13, [x9]
	ldr	w12, [x8, x12, lsl  #2]
	add	x10, x10, x11, lsl #5
	str	w12, [x10]
	ldr	w11, [x8, x13, lsl  #2]
	str	w11, [x10, #4]
	ldp	w11, w12, [x9, #8]
	ldr	w11, [x8, x11, lsl  #2]
	str	w11, [x10, #8]
	ldr	w11, [x8, x12, lsl  #2]
	str	w11, [x10, #12]
	ldp	w11, w12, [x9, #16]
	ldr	w11, [x8, x11, lsl  #2]
	str	w11, [x10, #16]
	ldr	w11, [x8, x12, lsl  #2]
	str	w11, [x10, #20]
	ldp	w11, w12, [x9, #24]
	ldr	w11, [x8, x11, lsl  #2]
	str	w11, [x10, #24]
	ldr	w11, [x8, x12, lsl  #2]
	str	w11, [x10, #28]
	ldp	w11, w12, [x9, #32]
	ldr	w11, [x8, x11, lsl  #2]
	str	w11, [x10, #32]
	ldr	w11, [x8, x12, lsl  #2]
	str	w11, [x10, #36]
	ldp	w11, w12, [x9, #40]
	ldr	w11, [x8, x11, lsl  #2]
	str	w11, [x10, #40]
	ldr	w11, [x8, x12, lsl  #2]
	str	w11, [x10, #44]
	ldp	w11, w12, [x9, #48]
	ldr	w11, [x8, x11, lsl  #2]
	str	w11, [x10, #48]
	ldr	w11, [x8, x12, lsl  #2]
	str	w11, [x10, #52]
	ldp	w11, w9, [x9, #56]
	ldr	w11, [x8, x11, lsl  #2]
	str	w11, [x10, #56]
	ldr	w8, [x8, x9, lsl  #2]
	str	w8, [x10, #60]
	b	LBB34_146
LBB34_61:
	mov	w0, #4
	bl	_raise
	b	LBB34_146
LBB34_62:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldrh	w11, [x8]
	ldrh	w12, [x10]
	udiv	w13, w11, w12
	msub	w11, w13, w12, w11
	strh	w11, [x9]
	ldrh	w11, [x8, #2]
	ldrh	w12, [x10, #2]
	udiv	w13, w11, w12
	msub	w11, w13, w12, w11
	strh	w11, [x9, #2]
	ldrh	w11, [x8, #4]
	ldrh	w12, [x10, #4]
	udiv	w13, w11, w12
	msub	w11, w13, w12, w11
	strh	w11, [x9, #4]
	ldrh	w11, [x8, #6]
	ldrh	w12, [x10, #6]
	udiv	w13, w11, w12
	msub	w11, w13, w12, w11
	strh	w11, [x9, #6]
	ldrh	w11, [x8, #8]
	ldrh	w12, [x10, #8]
	udiv	w13, w11, w12
	msub	w11, w13, w12, w11
	strh	w11, [x9, #8]
	ldrh	w11, [x8, #10]
	ldrh	w12, [x10, #10]
	udiv	w13, w11, w12
	msub	w11, w13, w12, w11
	strh	w11, [x9, #10]
	ldrh	w11, [x8, #12]
	ldrh	w12, [x10, #12]
	udiv	w13, w11, w12
	msub	w11, w13, w12, w11
	strh	w11, [x9, #12]
	ldrh	w8, [x8, #14]
	ldrh	w10, [x10, #14]
	udiv	w11, w8, w10
	msub	w8, w11, w10, w8
	strh	w8, [x9, #14]
	b	LBB34_146
LBB34_63:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldp	w11, w12, [x8]
	ldp	w13, w14, [x10]
	udiv	w15, w11, w13
	msub	w11, w15, w13, w11
	udiv	w13, w12, w14
	msub	w12, w13, w14, w12
	stp	w11, w12, [x9]
	ldp	w11, w12, [x8, #8]
	ldp	w13, w14, [x10, #8]
	udiv	w15, w11, w13
	msub	w11, w15, w13, w11
	udiv	w13, w12, w14
	msub	w12, w13, w14, w12
	stp	w11, w12, [x9, #8]
	ldp	w11, w12, [x8, #16]
	ldp	w13, w14, [x10, #16]
	udiv	w15, w11, w13
	msub	w11, w15, w13, w11
	udiv	w13, w12, w14
	msub	w12, w13, w14, w12
	stp	w11, w12, [x9, #16]
	ldp	w11, w12, [x8, #24]
	ldp	w13, w14, [x10, #24]
	udiv	w15, w11, w13
	msub	w11, w15, w13, w11
	udiv	w13, w12, w14
	msub	w12, w13, w14, w12
	ldp	w13, w14, [x8, #32]
	ldp	w15, w16, [x10, #32]
	udiv	w17, w13, w15
	msub	w13, w17, w15, w13
	udiv	w15, w14, w16
	msub	w14, w15, w16, w14
	ldp	w15, w16, [x8, #40]
	ldp	w17, w0, [x10, #40]
	udiv	w1, w15, w17
	msub	w15, w1, w17, w15
	udiv	w17, w16, w0
	msub	w16, w17, w0, w16
	ldp	w17, w0, [x8, #48]
	ldp	w1, w2, [x10, #48]
	udiv	w3, w17, w1
	msub	w17, w3, w1, w17
	udiv	w1, w0, w2
	msub	w0, w1, w2, w0
	stp	w11, w12, [x9, #24]
	stp	w13, w14, [x9, #32]
	stp	w15, w16, [x9, #40]
	stp	w17, w0, [x9, #48]
	ldp	w11, w8, [x8, #56]
	ldp	w12, w10, [x10, #56]
	udiv	w13, w11, w12
	msub	w11, w13, w12, w11
	udiv	w12, w8, w10
	msub	w8, w12, w10, w8
	stp	w11, w8, [x9, #56]
	b	LBB34_146
LBB34_64:
	ubfx	x8, x1, #10, #3
	add	x10, x19, #272
	add	x8, x10, x8, lsl #5
	ubfx	x9, x1, #13, #3
	add	x9, x10, x9, lsl #5
	ubfx	x11, x1, #7, #3
	ldp	x12, x13, [x9]
	ldr	x12, [x8, x12, lsl  #3]
	add	x10, x10, x11, lsl #5
	str	x12, [x10]
	ldr	x11, [x8, x13, lsl  #3]
	str	x11, [x10, #8]
	ldp	x11, x12, [x9, #16]
	ldr	x11, [x8, x11, lsl  #3]
	str	x11, [x10, #16]
	ldr	x11, [x8, x12, lsl  #3]
	str	x11, [x10, #24]
	ldp	x11, x12, [x9, #32]
	ldr	x11, [x8, x11, lsl  #3]
	str	x11, [x10, #32]
	ldr	x11, [x8, x12, lsl  #3]
	str	x11, [x10, #40]
	ldp	x11, x12, [x9, #48]
	ldr	x11, [x8, x11, lsl  #3]
	str	x11, [x10, #48]
	ldr	x11, [x8, x12, lsl  #3]
	str	x11, [x10, #56]
	ldp	x11, x12, [x9, #64]
	ldr	x11, [x8, x11, lsl  #3]
	str	x11, [x10, #64]
	ldr	x11, [x8, x12, lsl  #3]
	str	x11, [x10, #72]
	ldp	x11, x12, [x9, #80]
	ldr	x11, [x8, x11, lsl  #3]
	str	x11, [x10, #80]
	ldr	x11, [x8, x12, lsl  #3]
	str	x11, [x10, #88]
	ldp	x11, x12, [x9, #96]
	ldr	x11, [x8, x11, lsl  #3]
	str	x11, [x10, #96]
	ldr	x11, [x8, x12, lsl  #3]
	str	x11, [x10, #104]
	ldp	x11, x12, [x9, #112]
	ldr	x11, [x8, x11, lsl  #3]
	str	x11, [x10, #112]
	ldr	x11, [x8, x12, lsl  #3]
	str	x11, [x10, #120]
	ldp	x11, x12, [x9, #128]
	ldr	x11, [x8, x11, lsl  #3]
	str	x11, [x10, #128]
	ldr	x11, [x8, x12, lsl  #3]
	str	x11, [x10, #136]
	ldp	x11, x12, [x9, #144]
	ldr	x11, [x8, x11, lsl  #3]
	str	x11, [x10, #144]
	ldr	x11, [x8, x12, lsl  #3]
	str	x11, [x10, #152]
	ldp	x11, x12, [x9, #160]
	ldr	x11, [x8, x11, lsl  #3]
	str	x11, [x10, #160]
	ldr	x11, [x8, x12, lsl  #3]
	str	x11, [x10, #168]
	ldp	x11, x12, [x9, #176]
	ldr	x11, [x8, x11, lsl  #3]
	str	x11, [x10, #176]
	ldr	x11, [x8, x12, lsl  #3]
	str	x11, [x10, #184]
	ldp	x11, x12, [x9, #192]
	ldr	x11, [x8, x11, lsl  #3]
	str	x11, [x10, #192]
	ldr	x11, [x8, x12, lsl  #3]
	str	x11, [x10, #200]
	ldp	x11, x12, [x9, #208]
	ldr	x11, [x8, x11, lsl  #3]
	str	x11, [x10, #208]
	ldr	x11, [x8, x12, lsl  #3]
	str	x11, [x10, #216]
	ldp	x11, x12, [x9, #224]
	ldr	x11, [x8, x11, lsl  #3]
	str	x11, [x10, #224]
	ldr	x11, [x8, x12, lsl  #3]
	str	x11, [x10, #232]
	ldp	x11, x9, [x9, #240]
	ldr	x11, [x8, x11, lsl  #3]
	str	x11, [x10, #240]
	ldr	x8, [x8, x9, lsl  #3]
	str	x8, [x10, #248]
	b	LBB34_146
LBB34_65:
	mov	x21, #0
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x22, x9, x8, lsl #5
	ubfx	x8, x1, #13, #3
	add	x23, x9, x8, lsl #5
	ubfx	x8, x1, #7, #3
	add	x24, x9, x8, lsl #5
LBB34_66:                               ; =>This Inner Loop Header: Depth=1
	add	x8, x22, x21
	ldp	x0, x1, [x8]
	add	x8, x23, x21
	ldp	x2, x3, [x8]
	bl	___umodti3
	add	x8, x24, x21
	stp	x0, x1, [x8]
	add	x21, x21, #16
	cmp	x21, #1024
	b.ne	LBB34_66
	b	LBB34_146
LBB34_67:
	mov	x21, #0
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x22, x9, x8, lsl #5
	ubfx	x8, x1, #13, #3
	add	x23, x9, x8, lsl #5
	ubfx	x8, x1, #7, #3
	add	x24, x9, x8, lsl #5
LBB34_68:                               ; =>This Inner Loop Header: Depth=1
	add	x8, x22, x21
	ldp	x0, x1, [x8]
	add	x8, x23, x21
	ldp	x2, x3, [x8]
	bl	___umodti3
	add	x8, x24, x21
	stp	x0, x1, [x8]
	add	x21, x21, #16
	cmp	x21, #1024
	b.ne	LBB34_68
	b	LBB34_146
LBB34_69:
	mov	x21, #0
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x22, x9, x8, lsl #5
	ubfx	x8, x1, #13, #3
	add	x23, x9, x8, lsl #5
	ubfx	x8, x1, #7, #3
	add	x24, x9, x8, lsl #5
LBB34_70:                               ; =>This Inner Loop Header: Depth=1
	add	x8, x22, x21
	ldp	x0, x1, [x8]
	add	x8, x23, x21
	ldp	x2, x3, [x8]
	bl	___umodti3
	add	x8, x24, x21
	stp	x0, x1, [x8]
	add	x21, x21, #16
	cmp	x21, #1024
	b.ne	LBB34_70
	b	LBB34_146
LBB34_71:
	mov	x21, #0
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x22, x9, x8, lsl #5
	ubfx	x8, x1, #13, #3
	add	x23, x9, x8, lsl #5
	ubfx	x8, x1, #7, #3
	add	x24, x9, x8, lsl #5
LBB34_72:                               ; =>This Inner Loop Header: Depth=1
	add	x8, x22, x21
	ldp	x0, x1, [x8]
	add	x8, x23, x21
	ldp	x2, x3, [x8]
	bl	___umodti3
	add	x8, x24, x21
	stp	x0, x1, [x8]
	add	x21, x21, #16
	cmp	x21, #1024
	b.ne	LBB34_72
	b	LBB34_146
LBB34_73:
	mov	x21, #0
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x22, x9, x8, lsl #5
	ubfx	x8, x1, #13, #3
	add	x23, x9, x8, lsl #5
	ubfx	x8, x1, #7, #3
	add	x24, x9, x8, lsl #5
LBB34_74:                               ; =>This Inner Loop Header: Depth=1
	add	x8, x22, x21
	ldp	x0, x1, [x8]
	add	x8, x23, x21
	ldp	x2, x3, [x8]
	bl	___umodti3
	add	x8, x24, x21
	stp	x0, x1, [x8]
	add	x21, x21, #16
	cmp	x21, #1024
	b.ne	LBB34_74
	b	LBB34_146
LBB34_75:
	ubfx	x8, x1, #10, #3
	add	x12, x19, #272
	lsl	x13, x8, #5
	add	x9, x12, x13
	ubfx	x8, x1, #13, #3
	lsl	x11, x8, #5
	add	x10, x12, x11
	ubfx	x8, x1, #7, #3
	lsl	x14, x8, #5
	add	x8, x12, x14
	add	x12, x14, x19
	add	x12, x12, #272
	add	x13, x13, x19
	sub	x13, x12, x13
	sub	x13, x13, #272
	cmp	x13, #16
	b.lo	LBB34_153
; %bb.76:
	add	x11, x11, x19
	sub	x11, x12, x11
	sub	x11, x11, #272
	cmp	x11, #15
	b.ls	LBB34_153
LBB34_77:
	ldp	q0, q1, [x10]
	mov.d	x11, v0[1]
	ldp	q2, q3, [x9]
	mov.d	x12, v2[1]
	udiv	x13, x12, x11
	msub	x11, x13, x11, x12
	fmov	x12, d0
	fmov	x13, d2
	udiv	x14, x13, x12
	msub	x12, x14, x12, x13
	fmov	d0, x12
	mov.d	v0[1], x11
	mov.d	x11, v1[1]
	mov.d	x12, v3[1]
	udiv	x13, x12, x11
	msub	x11, x13, x11, x12
	fmov	x12, d1
	fmov	x13, d3
	udiv	x14, x13, x12
	msub	x12, x14, x12, x13
	fmov	d1, x12
	mov.d	v1[1], x11
	stp	q0, q1, [x8]
	ldp	q0, q1, [x10, #32]
	mov.d	x11, v0[1]
	ldp	q2, q3, [x9, #32]
	mov.d	x12, v2[1]
	udiv	x13, x12, x11
	msub	x11, x13, x11, x12
	fmov	x12, d0
	fmov	x13, d2
	udiv	x14, x13, x12
	msub	x12, x14, x12, x13
	fmov	d0, x12
	mov.d	v0[1], x11
	mov.d	x11, v1[1]
	mov.d	x12, v3[1]
	udiv	x13, x12, x11
	msub	x11, x13, x11, x12
	fmov	x12, d1
	fmov	x13, d3
	udiv	x14, x13, x12
	msub	x12, x14, x12, x13
	fmov	d1, x12
	mov.d	v1[1], x11
	stp	q0, q1, [x8, #32]
	ldp	q0, q1, [x10, #64]
	mov.d	x11, v0[1]
	ldp	q2, q3, [x9, #64]
	mov.d	x12, v2[1]
	udiv	x13, x12, x11
	msub	x11, x13, x11, x12
	fmov	x12, d0
	fmov	x13, d2
	udiv	x14, x13, x12
	msub	x12, x14, x12, x13
	fmov	d0, x12
	mov.d	v0[1], x11
	mov.d	x11, v1[1]
	mov.d	x12, v3[1]
	udiv	x13, x12, x11
	msub	x11, x13, x11, x12
	fmov	x12, d1
	fmov	x13, d3
	udiv	x14, x13, x12
	msub	x12, x14, x12, x13
	fmov	d1, x12
	mov.d	v1[1], x11
	stp	q0, q1, [x8, #64]
	ldp	q0, q1, [x10, #96]
	mov.d	x11, v0[1]
	ldp	q2, q3, [x9, #96]
	mov.d	x12, v2[1]
	udiv	x13, x12, x11
	msub	x11, x13, x11, x12
	fmov	x12, d0
	fmov	x13, d2
	udiv	x14, x13, x12
	msub	x12, x14, x12, x13
	fmov	d0, x12
	mov.d	v0[1], x11
	mov.d	x11, v1[1]
	mov.d	x12, v3[1]
	udiv	x13, x12, x11
	msub	x11, x13, x11, x12
	fmov	x12, d1
	fmov	x13, d3
	udiv	x14, x13, x12
	msub	x12, x14, x12, x13
	fmov	d1, x12
	mov.d	v1[1], x11
	stp	q0, q1, [x8, #96]
	ldp	q0, q1, [x10, #128]
	mov.d	x11, v0[1]
	ldp	q2, q3, [x9, #128]
	mov.d	x12, v2[1]
	udiv	x13, x12, x11
	msub	x11, x13, x11, x12
	fmov	x12, d0
	fmov	x13, d2
	udiv	x14, x13, x12
	msub	x12, x14, x12, x13
	fmov	d0, x12
	mov.d	v0[1], x11
	mov.d	x11, v1[1]
	mov.d	x12, v3[1]
	udiv	x13, x12, x11
	msub	x11, x13, x11, x12
	fmov	x12, d1
	fmov	x13, d3
	udiv	x14, x13, x12
	msub	x12, x14, x12, x13
	fmov	d1, x12
	mov.d	v1[1], x11
	stp	q0, q1, [x8, #128]
	ldp	q0, q1, [x10, #160]
	mov.d	x11, v0[1]
	ldp	q2, q3, [x9, #160]
	mov.d	x12, v2[1]
	udiv	x13, x12, x11
	msub	x11, x13, x11, x12
	fmov	x12, d0
	fmov	x13, d2
	udiv	x14, x13, x12
	msub	x12, x14, x12, x13
	fmov	d0, x12
	mov.d	v0[1], x11
	mov.d	x11, v1[1]
	mov.d	x12, v3[1]
	udiv	x13, x12, x11
	msub	x11, x13, x11, x12
	fmov	x12, d1
	fmov	x13, d3
	udiv	x14, x13, x12
	msub	x12, x14, x12, x13
	fmov	d1, x12
	mov.d	v1[1], x11
	stp	q0, q1, [x8, #160]
	ldp	q0, q1, [x10, #192]
	mov.d	x11, v0[1]
	ldp	q2, q3, [x9, #192]
	mov.d	x12, v2[1]
	udiv	x13, x12, x11
	msub	x11, x13, x11, x12
	fmov	x12, d0
	fmov	x13, d2
	udiv	x14, x13, x12
	msub	x12, x14, x12, x13
	fmov	d0, x12
	mov.d	v0[1], x11
	mov.d	x11, v1[1]
	mov.d	x12, v3[1]
	udiv	x13, x12, x11
	msub	x11, x13, x11, x12
	fmov	x12, d1
	fmov	x13, d3
	udiv	x14, x13, x12
	msub	x12, x14, x12, x13
	fmov	d1, x12
	mov.d	v1[1], x11
	stp	q0, q1, [x8, #192]
	ldp	q0, q1, [x10, #224]
	mov.d	x10, v0[1]
	ldp	q2, q3, [x9, #224]
	mov.d	x9, v2[1]
	fmov	x11, d0
	fmov	x12, d2
	udiv	x13, x9, x10
	msub	x9, x13, x10, x9
	udiv	x10, x12, x11
	msub	x10, x10, x11, x12
	mov.d	x11, v1[1]
	fmov	x12, d1
	fmov	d0, x10
	mov.d	v0[1], x9
	mov.d	x9, v3[1]
	udiv	x10, x9, x11
	msub	x9, x10, x11, x9
	fmov	x10, d3
	udiv	x11, x10, x12
	msub	x10, x11, x12, x10
	fmov	d1, x10
	mov.d	v1[1], x9
	stp	q0, q1, [x8, #224]
	b	LBB34_146
LBB34_78:
	mov	x21, #0
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x22, x9, x8, lsl #5
	ubfx	x8, x1, #13, #3
	add	x23, x9, x8, lsl #5
	ubfx	x8, x1, #7, #3
	add	x24, x9, x8, lsl #5
LBB34_79:                               ; =>This Inner Loop Header: Depth=1
	add	x8, x22, x21
	ldp	x0, x1, [x8]
	add	x8, x23, x21
	ldp	x2, x3, [x8]
	bl	___umodti3
	add	x8, x24, x21
	stp	x0, x1, [x8]
	add	x21, x21, #16
	cmp	x21, #1024
	b.ne	LBB34_79
	b	LBB34_146
LBB34_80:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	lsl	x8, x8, #5
	ubfx	x10, x1, #13, #3
	lsl	x10, x10, #5
	ubfx	x11, x1, #7, #3
	lsl	x11, x11, #5
	ldr	q0, [x9, x8]
	ldr	q1, [x9, x10]
	neg.8h	v2, v1
	movi.8h	v3, #15
	and.16b	v2, v2, v3
	ushl.8h	v2, v0, v2
	and.16b	v1, v1, v3
	neg.8h	v1, v1
	ushl.8h	v0, v0, v1
	orr.16b	v0, v0, v2
	str	q0, [x9, x11]
	b	LBB34_146
LBB34_81:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldp	q0, q1, [x10]
	neg.4s	v2, v0
	ldp	q3, q4, [x8]
	ushl.4s	v2, v3, v2
	movi.4s	v5, #32
	sub.4s	v0, v5, v0
	ushl.4s	v0, v3, v0
	orr.16b	v0, v0, v2
	neg.4s	v2, v1
	ushl.4s	v2, v4, v2
	sub.4s	v1, v5, v1
	ushl.4s	v1, v4, v1
	orr.16b	v1, v1, v2
	stp	q0, q1, [x9]
	ldp	q0, q1, [x10, #32]
	neg.4s	v2, v0
	ldp	q3, q4, [x8, #32]
	ushl.4s	v2, v3, v2
	sub.4s	v0, v5, v0
	ushl.4s	v0, v3, v0
	orr.16b	v0, v0, v2
	sub.4s	v2, v5, v1
	neg.4s	v1, v1
	ushl.4s	v1, v4, v1
	ushl.4s	v2, v4, v2
	orr.16b	v1, v2, v1
	b	LBB34_145
LBB34_82:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	lsl	x13, x8, #5
	add	x8, x9, x13
	ubfx	x10, x1, #13, #3
	lsl	x11, x10, #5
	add	x10, x9, x11
	ubfx	x12, x1, #7, #3
	lsl	x12, x12, #5
	add	x9, x9, x12
	add	x12, x12, x19
	add	x12, x12, #272
	add	x13, x13, x19
	sub	x13, x12, x13
	sub	x13, x13, #272
	cmp	x13, #16
	b.lo	LBB34_155
; %bb.83:
	add	x11, x11, x19
	sub	x11, x12, x11
	sub	x11, x11, #272
	cmp	x11, #15
	b.ls	LBB34_155
; %bb.84:
	ldp	q1, q2, [x10]
	neg.2d	v0, v1
	ldp	q3, q4, [x8]
	ushl.2d	v5, v3, v0
	mov	w11, #64
	dup.2d	v0, x11
	sub.2d	v1, v0, v1
	ushl.2d	v1, v3, v1
	orr.16b	v1, v1, v5
	neg.2d	v3, v2
	ushl.2d	v3, v4, v3
	sub.2d	v2, v0, v2
	ushl.2d	v2, v4, v2
	orr.16b	v2, v2, v3
	stp	q1, q2, [x9]
	ldp	q1, q2, [x10, #32]
	neg.2d	v3, v1
	ldp	q4, q5, [x8, #32]
	ushl.2d	v3, v4, v3
	sub.2d	v1, v0, v1
	ushl.2d	v1, v4, v1
	orr.16b	v1, v1, v3
	neg.2d	v3, v2
	ushl.2d	v3, v5, v3
	sub.2d	v2, v0, v2
	ushl.2d	v2, v5, v2
	orr.16b	v2, v2, v3
	stp	q1, q2, [x9, #32]
	ldp	q1, q2, [x10, #64]
	neg.2d	v3, v1
	ldp	q4, q5, [x8, #64]
	ushl.2d	v3, v4, v3
	sub.2d	v1, v0, v1
	ushl.2d	v1, v4, v1
	orr.16b	v1, v1, v3
	neg.2d	v3, v2
	ushl.2d	v3, v5, v3
	sub.2d	v2, v0, v2
	ushl.2d	v2, v5, v2
	orr.16b	v2, v2, v3
	stp	q1, q2, [x9, #64]
	ldp	q1, q2, [x10, #96]
	neg.2d	v3, v1
	ldp	q4, q5, [x8, #96]
	ushl.2d	v3, v4, v3
	sub.2d	v1, v0, v1
	ushl.2d	v1, v4, v1
	orr.16b	v1, v1, v3
	neg.2d	v3, v2
	ushl.2d	v3, v5, v3
	sub.2d	v2, v0, v2
	ushl.2d	v2, v5, v2
	orr.16b	v2, v2, v3
	stp	q1, q2, [x9, #96]
	ldp	q1, q2, [x10, #128]
	neg.2d	v3, v1
	ldp	q4, q5, [x8, #128]
	ushl.2d	v3, v4, v3
	sub.2d	v1, v0, v1
	ushl.2d	v1, v4, v1
	orr.16b	v1, v1, v3
	neg.2d	v3, v2
	ushl.2d	v3, v5, v3
	sub.2d	v2, v0, v2
	ushl.2d	v2, v5, v2
	orr.16b	v2, v2, v3
	stp	q1, q2, [x9, #128]
	ldp	q1, q2, [x10, #160]
	neg.2d	v3, v1
	ldp	q4, q5, [x8, #160]
	ushl.2d	v3, v4, v3
	sub.2d	v1, v0, v1
	ushl.2d	v1, v4, v1
	orr.16b	v1, v1, v3
	neg.2d	v3, v2
	ushl.2d	v3, v5, v3
	sub.2d	v2, v0, v2
	ushl.2d	v2, v5, v2
	orr.16b	v2, v2, v3
	stp	q1, q2, [x9, #160]
	ldp	q1, q2, [x10, #192]
	neg.2d	v3, v1
	ldp	q4, q5, [x8, #192]
	ushl.2d	v3, v4, v3
	sub.2d	v1, v0, v1
	ushl.2d	v1, v4, v1
	orr.16b	v1, v1, v3
	neg.2d	v3, v2
	ushl.2d	v3, v5, v3
	sub.2d	v2, v0, v2
	ushl.2d	v2, v5, v2
	orr.16b	v2, v2, v3
	stp	q1, q2, [x9, #192]
	ldp	q1, q2, [x10, #224]
	neg.2d	v3, v1
	ldp	q4, q5, [x8, #224]
	ushl.2d	v3, v4, v3
	sub.2d	v1, v0, v1
	ushl.2d	v1, v4, v1
	orr.16b	v1, v1, v3
	sub.2d	v0, v0, v2
	neg.2d	v2, v2
	ushl.2d	v2, v5, v2
	ushl.2d	v0, v5, v0
	orr.16b	v0, v0, v2
	b	LBB34_92
LBB34_85:
	mov	x8, #0
	ubfx	x9, x1, #10, #3
	add	x12, x19, #272
	add	x9, x12, x9, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x12, x10, lsl #5
	ubfx	x13, x1, #7, #3
	mov	w11, #128
	add	x12, x12, x13, lsl #5
LBB34_86:                               ; =>This Inner Loop Header: Depth=1
	add	x13, x9, x8
	ldp	x13, x14, [x13]
	ldr	x15, [x10, x8]
	lsr	x16, x13, x15
	mvn	w17, w15
	lsl	x0, x14, #1
	lsl	x17, x0, x17
	orr	x16, x17, x16
	lsr	x17, x14, x15
	tst	x15, #0x40
	csel	x16, x17, x16, ne
	csel	x17, xzr, x17, ne
	sub	x15, x11, x15
	mvn	w0, w15
	lsl	x14, x14, x15
	lsr	x1, x13, #1
	lsr	x0, x1, x0
	orr	x14, x14, x0
	lsl	x13, x13, x15
	tst	x15, #0x40
	csel	x14, x13, x14, ne
	csel	x13, xzr, x13, ne
	orr	x14, x14, x17
	orr	x13, x13, x16
	add	x15, x12, x8
	stp	x13, x14, [x15]
	add	x8, x8, #16
	cmp	x8, #1024
	b.ne	LBB34_86
	b	LBB34_146
LBB34_87:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	lsl	x8, x8, #5
	ubfx	x10, x1, #13, #3
	lsl	x10, x10, #5
	ubfx	x11, x1, #7, #3
	lsl	x11, x11, #5
	ldr	q0, [x9, x8]
	ldr	q1, [x9, x10]
	movi.8h	v2, #15
	and.16b	v3, v1, v2
	ushl.8h	v3, v0, v3
	neg.8h	v1, v1
	and.16b	v1, v1, v2
	neg.8h	v1, v1
	ushl.8h	v0, v0, v1
	orr.16b	v0, v3, v0
	str	q0, [x9, x11]
	b	LBB34_146
LBB34_88:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldp	q0, q1, [x8]
	ldp	q2, q3, [x10]
	ushl.4s	v4, v0, v2
	movi.4s	v5, #32
	sub.4s	v2, v2, v5
	ushl.4s	v0, v0, v2
	orr.16b	v0, v0, v4
	ushl.4s	v2, v1, v3
	sub.4s	v3, v3, v5
	ushl.4s	v1, v1, v3
	orr.16b	v1, v1, v2
	stp	q0, q1, [x9]
	ldp	q0, q1, [x8, #32]
	ldp	q2, q3, [x10, #32]
	ushl.4s	v4, v0, v2
	sub.4s	v2, v2, v5
	ushl.4s	v0, v0, v2
	orr.16b	v0, v0, v4
	sub.4s	v2, v3, v5
	ushl.4s	v3, v1, v3
	ushl.4s	v1, v1, v2
	orr.16b	v1, v1, v3
	b	LBB34_145
LBB34_89:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	lsl	x13, x8, #5
	add	x8, x9, x13
	ubfx	x10, x1, #13, #3
	lsl	x11, x10, #5
	add	x10, x9, x11
	ubfx	x12, x1, #7, #3
	lsl	x12, x12, #5
	add	x9, x9, x12
	add	x12, x12, x19
	add	x12, x12, #272
	add	x13, x13, x19
	sub	x13, x12, x13
	sub	x13, x13, #272
	cmp	x13, #16
	b.lo	LBB34_157
; %bb.90:
	add	x11, x11, x19
	sub	x11, x12, x11
	sub	x11, x11, #272
	cmp	x11, #15
	b.ls	LBB34_157
; %bb.91:
	mov	w11, #64
	dup.2d	v0, x11
	ldp	q1, q2, [x8]
	ldp	q3, q4, [x10]
	ushl.2d	v5, v1, v3
	sub.2d	v3, v3, v0
	ushl.2d	v1, v1, v3
	orr.16b	v1, v1, v5
	ushl.2d	v3, v2, v4
	sub.2d	v4, v4, v0
	ushl.2d	v2, v2, v4
	orr.16b	v2, v2, v3
	stp	q1, q2, [x9]
	ldp	q1, q2, [x8, #32]
	ldp	q3, q4, [x10, #32]
	ushl.2d	v5, v1, v3
	sub.2d	v3, v3, v0
	ushl.2d	v1, v1, v3
	orr.16b	v1, v1, v5
	ushl.2d	v3, v2, v4
	sub.2d	v4, v4, v0
	ushl.2d	v2, v2, v4
	orr.16b	v2, v2, v3
	stp	q1, q2, [x9, #32]
	ldp	q1, q2, [x8, #64]
	ldp	q3, q4, [x10, #64]
	ushl.2d	v5, v1, v3
	sub.2d	v3, v3, v0
	ushl.2d	v1, v1, v3
	orr.16b	v1, v1, v5
	ushl.2d	v3, v2, v4
	sub.2d	v4, v4, v0
	ushl.2d	v2, v2, v4
	orr.16b	v2, v2, v3
	stp	q1, q2, [x9, #64]
	ldp	q1, q2, [x8, #96]
	ldp	q3, q4, [x10, #96]
	ushl.2d	v5, v1, v3
	sub.2d	v3, v3, v0
	ushl.2d	v1, v1, v3
	orr.16b	v1, v1, v5
	ushl.2d	v3, v2, v4
	sub.2d	v4, v4, v0
	ushl.2d	v2, v2, v4
	orr.16b	v2, v2, v3
	stp	q1, q2, [x9, #96]
	ldp	q1, q2, [x8, #128]
	ldp	q3, q4, [x10, #128]
	ushl.2d	v5, v1, v3
	sub.2d	v3, v3, v0
	ushl.2d	v1, v1, v3
	orr.16b	v1, v1, v5
	ushl.2d	v3, v2, v4
	sub.2d	v4, v4, v0
	ushl.2d	v2, v2, v4
	orr.16b	v2, v2, v3
	stp	q1, q2, [x9, #128]
	ldp	q1, q2, [x8, #160]
	ldp	q3, q4, [x10, #160]
	ushl.2d	v5, v1, v3
	sub.2d	v3, v3, v0
	ushl.2d	v1, v1, v3
	orr.16b	v1, v1, v5
	ushl.2d	v3, v2, v4
	sub.2d	v4, v4, v0
	ushl.2d	v2, v2, v4
	orr.16b	v2, v2, v3
	stp	q1, q2, [x9, #160]
	ldp	q1, q2, [x8, #192]
	ldp	q3, q4, [x10, #192]
	ushl.2d	v5, v1, v3
	sub.2d	v3, v3, v0
	ushl.2d	v1, v1, v3
	orr.16b	v1, v1, v5
	ushl.2d	v3, v2, v4
	sub.2d	v4, v4, v0
	ushl.2d	v2, v2, v4
	orr.16b	v2, v2, v3
	stp	q1, q2, [x9, #192]
	ldp	q1, q2, [x8, #224]
	ldp	q3, q4, [x10, #224]
	ushl.2d	v5, v1, v3
	sub.2d	v3, v3, v0
	ushl.2d	v1, v1, v3
	orr.16b	v1, v1, v5
	sub.2d	v0, v4, v0
	ushl.2d	v3, v2, v4
	ushl.2d	v0, v2, v0
	orr.16b	v0, v0, v3
LBB34_92:
	stp	q1, q0, [x9, #224]
	b	LBB34_146
LBB34_93:
	mov	x8, #0
	ubfx	x9, x1, #10, #3
	add	x12, x19, #272
	add	x9, x12, x9, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x12, x10, lsl #5
	ubfx	x13, x1, #7, #3
	mov	w11, #128
	add	x12, x12, x13, lsl #5
LBB34_94:                               ; =>This Inner Loop Header: Depth=1
	add	x13, x9, x8
	ldp	x14, x13, [x13]
	ldr	x15, [x10, x8]
	lsl	x16, x13, x15
	mvn	w17, w15
	lsr	x0, x14, #1
	lsr	x17, x0, x17
	orr	x16, x16, x17
	lsl	x17, x14, x15
	tst	x15, #0x40
	csel	x16, x17, x16, ne
	csel	x17, xzr, x17, ne
	sub	x15, x11, x15
	mvn	w0, w15
	lsr	x14, x14, x15
	lsl	x1, x13, #1
	lsl	x0, x1, x0
	orr	x14, x0, x14
	lsr	x13, x13, x15
	tst	x15, #0x40
	csel	x14, x13, x14, ne
	csel	x13, xzr, x13, ne
	orr	x14, x14, x17
	orr	x13, x13, x16
	add	x15, x12, x8
	stp	x14, x13, [x15]
	add	x8, x8, #16
	cmp	x8, #1024
	b.ne	LBB34_94
	b	LBB34_146
LBB34_95:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	lsl	x8, x8, #5
	ubfx	x10, x1, #13, #3
	lsl	x10, x10, #5
	ubfx	x11, x1, #7, #3
	ldr	q0, [x9, x8]
	lsl	x8, x11, #5
	ldr	q1, [x9, x10]
	add.8h	v0, v1, v0
	str	q0, [x9, x8]
	b	LBB34_146
LBB34_96:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldp	q0, q1, [x8]
	ldp	q2, q3, [x10]
	add.4s	v0, v2, v0
	add.4s	v1, v3, v1
	stp	q0, q1, [x9]
	ldp	q0, q1, [x8, #32]
	ldp	q2, q3, [x10, #32]
	add.4s	v0, v2, v0
	add.4s	v1, v3, v1
	b	LBB34_145
LBB34_97:
	ubfx	x8, x1, #10, #3
	add	x10, x19, #272
	lsl	x13, x8, #5
	add	x8, x10, x13
	ubfx	x9, x1, #13, #3
	lsl	x11, x9, #5
	add	x9, x10, x11
	ubfx	x12, x1, #7, #3
	lsl	x12, x12, #5
	add	x10, x10, x12
	add	x12, x12, x19
	add	x12, x12, #272
	add	x13, x13, x19
	sub	x13, x12, x13
	sub	x13, x13, #272
	cmp	x13, #16
	b.lo	LBB34_159
; %bb.98:
	add	x11, x11, x19
	sub	x11, x12, x11
	sub	x11, x11, #272
	cmp	x11, #15
	b.ls	LBB34_159
; %bb.99:
	ldp	q0, q1, [x8]
	ldp	q2, q3, [x9]
	add.2d	v0, v2, v0
	add.2d	v1, v3, v1
	stp	q0, q1, [x10]
	ldp	q0, q1, [x8, #32]
	ldp	q2, q3, [x9, #32]
	add.2d	v0, v2, v0
	add.2d	v1, v3, v1
	stp	q0, q1, [x10, #32]
	ldp	q0, q1, [x8, #64]
	ldp	q2, q3, [x9, #64]
	add.2d	v0, v2, v0
	add.2d	v1, v3, v1
	stp	q0, q1, [x10, #64]
	ldp	q0, q1, [x8, #96]
	ldp	q2, q3, [x9, #96]
	add.2d	v0, v2, v0
	add.2d	v1, v3, v1
	stp	q0, q1, [x10, #96]
	ldp	q0, q1, [x8, #128]
	ldp	q2, q3, [x9, #128]
	add.2d	v0, v2, v0
	add.2d	v1, v3, v1
	stp	q0, q1, [x10, #128]
	ldp	q0, q1, [x8, #160]
	ldp	q2, q3, [x9, #160]
	add.2d	v0, v2, v0
	add.2d	v1, v3, v1
	stp	q0, q1, [x10, #160]
	ldp	q0, q1, [x8, #192]
	ldp	q2, q3, [x9, #192]
	add.2d	v0, v2, v0
	add.2d	v1, v3, v1
	stp	q0, q1, [x10, #192]
	ldp	q0, q1, [x8, #224]
	ldp	q2, q3, [x9, #224]
	add.2d	v0, v2, v0
	add.2d	v1, v3, v1
	b	LBB34_137
LBB34_100:
	mov	x8, #0
	ubfx	x9, x1, #10, #3
	add	x11, x19, #272
	add	x9, x11, x9, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x11, x10, lsl #5
	ubfx	x12, x1, #7, #3
	add	x11, x11, x12, lsl #5
LBB34_101:                              ; =>This Inner Loop Header: Depth=1
	add	x12, x9, x8
	ldp	x12, x13, [x12]
	add	x14, x10, x8
	ldp	x14, x15, [x14]
	adds	x12, x14, x12
	adc	x13, x15, x13
	add	x14, x11, x8
	stp	x12, x13, [x14]
	add	x8, x8, #16
	cmp	x8, #1024
	b.ne	LBB34_101
	b	LBB34_146
LBB34_102:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldp	q0, q1, [x8]
	ldp	q2, q3, [x10]
	fadd.4s	v0, v0, v2
	fadd.4s	v1, v1, v3
	stp	q0, q1, [x9]
	ldp	q0, q1, [x8, #32]
	ldp	q2, q3, [x10, #32]
	fadd.4s	v0, v0, v2
	fadd.4s	v1, v1, v3
	b	LBB34_145
LBB34_103:
	ubfx	x8, x1, #10, #3
	add	x10, x19, #272
	lsl	x13, x8, #5
	add	x8, x10, x13
	ubfx	x9, x1, #13, #3
	lsl	x11, x9, #5
	add	x9, x10, x11
	ubfx	x12, x1, #7, #3
	lsl	x12, x12, #5
	add	x10, x10, x12
	add	x12, x12, x19
	add	x12, x12, #272
	add	x13, x13, x19
	sub	x13, x12, x13
	sub	x13, x13, #272
	cmp	x13, #16
	b.lo	LBB34_161
; %bb.104:
	add	x11, x11, x19
	sub	x11, x12, x11
	sub	x11, x11, #272
	cmp	x11, #15
	b.ls	LBB34_161
; %bb.105:
	ldp	q0, q1, [x8]
	ldp	q2, q3, [x9]
	fadd.2d	v0, v0, v2
	fadd.2d	v1, v1, v3
	stp	q0, q1, [x10]
	ldp	q0, q1, [x8, #32]
	ldp	q2, q3, [x9, #32]
	fadd.2d	v0, v0, v2
	fadd.2d	v1, v1, v3
	stp	q0, q1, [x10, #32]
	ldp	q0, q1, [x8, #64]
	ldp	q2, q3, [x9, #64]
	fadd.2d	v0, v0, v2
	fadd.2d	v1, v1, v3
	stp	q0, q1, [x10, #64]
	ldp	q0, q1, [x8, #96]
	ldp	q2, q3, [x9, #96]
	fadd.2d	v0, v0, v2
	fadd.2d	v1, v1, v3
	stp	q0, q1, [x10, #96]
	ldp	q0, q1, [x8, #128]
	ldp	q2, q3, [x9, #128]
	fadd.2d	v0, v0, v2
	fadd.2d	v1, v1, v3
	stp	q0, q1, [x10, #128]
	ldp	q0, q1, [x8, #160]
	ldp	q2, q3, [x9, #160]
	fadd.2d	v0, v0, v2
	fadd.2d	v1, v1, v3
	stp	q0, q1, [x10, #160]
	ldp	q0, q1, [x8, #192]
	ldp	q2, q3, [x9, #192]
	fadd.2d	v0, v0, v2
	fadd.2d	v1, v1, v3
	stp	q0, q1, [x10, #192]
	ldp	q0, q1, [x8, #224]
	ldp	q2, q3, [x9, #224]
	fadd.2d	v0, v0, v2
	fadd.2d	v1, v1, v3
	b	LBB34_137
LBB34_106:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	lsl	x8, x8, #5
	ubfx	x10, x1, #13, #3
	lsl	x10, x10, #5
	ubfx	x11, x1, #7, #3
	ldr	q0, [x9, x8]
	lsl	x8, x11, #5
	ldr	q1, [x9, x10]
	sub.8h	v0, v0, v1
	str	q0, [x9, x8]
	b	LBB34_146
LBB34_107:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldp	q0, q1, [x8]
	ldp	q2, q3, [x10]
	sub.4s	v0, v0, v2
	sub.4s	v1, v1, v3
	stp	q0, q1, [x9]
	ldp	q0, q1, [x8, #32]
	ldp	q2, q3, [x10, #32]
	sub.4s	v0, v0, v2
	sub.4s	v1, v1, v3
	b	LBB34_145
LBB34_108:
	ubfx	x8, x1, #10, #3
	add	x10, x19, #272
	lsl	x13, x8, #5
	add	x8, x10, x13
	ubfx	x9, x1, #13, #3
	lsl	x11, x9, #5
	add	x9, x10, x11
	ubfx	x12, x1, #7, #3
	lsl	x12, x12, #5
	add	x10, x10, x12
	add	x12, x12, x19
	add	x12, x12, #272
	add	x13, x13, x19
	sub	x13, x12, x13
	sub	x13, x13, #272
	cmp	x13, #16
	b.lo	LBB34_163
; %bb.109:
	add	x11, x11, x19
	sub	x11, x12, x11
	sub	x11, x11, #272
	cmp	x11, #15
	b.ls	LBB34_163
; %bb.110:
	ldp	q0, q1, [x8]
	ldp	q2, q3, [x9]
	sub.2d	v0, v0, v2
	sub.2d	v1, v1, v3
	stp	q0, q1, [x10]
	ldp	q0, q1, [x8, #32]
	ldp	q2, q3, [x9, #32]
	sub.2d	v0, v0, v2
	sub.2d	v1, v1, v3
	stp	q0, q1, [x10, #32]
	ldp	q0, q1, [x8, #64]
	ldp	q2, q3, [x9, #64]
	sub.2d	v0, v0, v2
	sub.2d	v1, v1, v3
	stp	q0, q1, [x10, #64]
	ldp	q0, q1, [x8, #96]
	ldp	q2, q3, [x9, #96]
	sub.2d	v0, v0, v2
	sub.2d	v1, v1, v3
	stp	q0, q1, [x10, #96]
	ldp	q0, q1, [x8, #128]
	ldp	q2, q3, [x9, #128]
	sub.2d	v0, v0, v2
	sub.2d	v1, v1, v3
	stp	q0, q1, [x10, #128]
	ldp	q0, q1, [x8, #160]
	ldp	q2, q3, [x9, #160]
	sub.2d	v0, v0, v2
	sub.2d	v1, v1, v3
	stp	q0, q1, [x10, #160]
	ldp	q0, q1, [x8, #192]
	ldp	q2, q3, [x9, #192]
	sub.2d	v0, v0, v2
	sub.2d	v1, v1, v3
	stp	q0, q1, [x10, #192]
	ldp	q0, q1, [x8, #224]
	ldp	q2, q3, [x9, #224]
	sub.2d	v0, v0, v2
	sub.2d	v1, v1, v3
	b	LBB34_137
LBB34_111:
	mov	x8, #0
	ubfx	x9, x1, #10, #3
	add	x11, x19, #272
	add	x9, x11, x9, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x11, x10, lsl #5
	ubfx	x12, x1, #7, #3
	add	x11, x11, x12, lsl #5
LBB34_112:                              ; =>This Inner Loop Header: Depth=1
	add	x12, x9, x8
	ldp	x12, x13, [x12]
	add	x14, x10, x8
	ldp	x14, x15, [x14]
	subs	x12, x12, x14
	sbc	x13, x13, x15
	add	x14, x11, x8
	stp	x12, x13, [x14]
	add	x8, x8, #16
	cmp	x8, #1024
	b.ne	LBB34_112
	b	LBB34_146
LBB34_113:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldp	q0, q1, [x8]
	ldp	q2, q3, [x10]
	fsub.4s	v0, v0, v2
	fsub.4s	v1, v1, v3
	stp	q0, q1, [x9]
	ldp	q0, q1, [x8, #32]
	ldp	q2, q3, [x10, #32]
	fsub.4s	v0, v0, v2
	fsub.4s	v1, v1, v3
	b	LBB34_145
LBB34_114:
	ubfx	x8, x1, #10, #3
	add	x10, x19, #272
	lsl	x13, x8, #5
	add	x8, x10, x13
	ubfx	x9, x1, #13, #3
	lsl	x11, x9, #5
	add	x9, x10, x11
	ubfx	x12, x1, #7, #3
	lsl	x12, x12, #5
	add	x10, x10, x12
	add	x12, x12, x19
	add	x12, x12, #272
	add	x13, x13, x19
	sub	x13, x12, x13
	sub	x13, x13, #272
	cmp	x13, #16
	b.lo	LBB34_165
; %bb.115:
	add	x11, x11, x19
	sub	x11, x12, x11
	sub	x11, x11, #272
	cmp	x11, #15
	b.ls	LBB34_165
; %bb.116:
	ldp	q0, q1, [x8]
	ldp	q2, q3, [x9]
	fsub.2d	v0, v0, v2
	fsub.2d	v1, v1, v3
	stp	q0, q1, [x10]
	ldp	q0, q1, [x8, #32]
	ldp	q2, q3, [x9, #32]
	fsub.2d	v0, v0, v2
	fsub.2d	v1, v1, v3
	stp	q0, q1, [x10, #32]
	ldp	q0, q1, [x8, #64]
	ldp	q2, q3, [x9, #64]
	fsub.2d	v0, v0, v2
	fsub.2d	v1, v1, v3
	stp	q0, q1, [x10, #64]
	ldp	q0, q1, [x8, #96]
	ldp	q2, q3, [x9, #96]
	fsub.2d	v0, v0, v2
	fsub.2d	v1, v1, v3
	stp	q0, q1, [x10, #96]
	ldp	q0, q1, [x8, #128]
	ldp	q2, q3, [x9, #128]
	fsub.2d	v0, v0, v2
	fsub.2d	v1, v1, v3
	stp	q0, q1, [x10, #128]
	ldp	q0, q1, [x8, #160]
	ldp	q2, q3, [x9, #160]
	fsub.2d	v0, v0, v2
	fsub.2d	v1, v1, v3
	stp	q0, q1, [x10, #160]
	ldp	q0, q1, [x8, #192]
	ldp	q2, q3, [x9, #192]
	fsub.2d	v0, v0, v2
	fsub.2d	v1, v1, v3
	stp	q0, q1, [x10, #192]
	ldp	q0, q1, [x8, #224]
	ldp	q2, q3, [x9, #224]
	fsub.2d	v0, v0, v2
	fsub.2d	v1, v1, v3
	b	LBB34_137
LBB34_117:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	lsl	x8, x8, #5
	ubfx	x10, x1, #13, #3
	lsl	x10, x10, #5
	ubfx	x11, x1, #7, #3
	ldr	q0, [x9, x8]
	lsl	x8, x11, #5
	ldr	q1, [x9, x10]
	mul.8h	v0, v1, v0
	str	q0, [x9, x8]
	b	LBB34_146
LBB34_118:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldp	q0, q1, [x8]
	ldp	q2, q3, [x10]
	mul.4s	v0, v2, v0
	mul.4s	v1, v3, v1
	stp	q0, q1, [x9]
	ldp	q0, q1, [x8, #32]
	ldp	q2, q3, [x10, #32]
	mul.4s	v0, v2, v0
	mul.4s	v1, v3, v1
	b	LBB34_145
LBB34_119:
	mov	x8, #0
	ubfx	x9, x1, #10, #3
	add	x11, x19, #272
	add	x9, x11, x9, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x11, x10, lsl #5
	ubfx	x12, x1, #7, #3
	add	x11, x11, x12, lsl #5
LBB34_120:                              ; =>This Inner Loop Header: Depth=1
	ldr	x12, [x9, x8]
	ldr	x13, [x10, x8]
	mul	x12, x13, x12
	str	x12, [x11, x8]
	add	x8, x8, #8
	cmp	x8, #256
	b.ne	LBB34_120
	b	LBB34_146
LBB34_121:
	mov	x8, #0
	ubfx	x9, x1, #10, #3
	add	x11, x19, #272
	add	x9, x11, x9, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x11, x10, lsl #5
	ubfx	x12, x1, #7, #3
	add	x11, x11, x12, lsl #5
LBB34_122:                              ; =>This Inner Loop Header: Depth=1
	add	x12, x9, x8
	ldp	x13, x12, [x12]
	add	x14, x10, x8
	ldp	x14, x15, [x14]
	umulh	x16, x14, x13
	madd	x12, x14, x12, x16
	madd	x12, x15, x13, x12
	mul	x13, x14, x13
	add	x14, x11, x8
	stp	x13, x12, [x14]
	add	x8, x8, #16
	cmp	x8, #1024
	b.ne	LBB34_122
	b	LBB34_146
LBB34_123:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldp	q0, q1, [x8]
	ldp	q2, q3, [x10]
	fmul.4s	v0, v0, v2
	fmul.4s	v1, v1, v3
	stp	q0, q1, [x9]
	ldp	q0, q1, [x8, #32]
	ldp	q2, q3, [x10, #32]
	fmul.4s	v0, v0, v2
	fmul.4s	v1, v1, v3
	b	LBB34_145
LBB34_124:
	ubfx	x8, x1, #10, #3
	add	x10, x19, #272
	lsl	x13, x8, #5
	add	x8, x10, x13
	ubfx	x9, x1, #13, #3
	lsl	x11, x9, #5
	add	x9, x10, x11
	ubfx	x12, x1, #7, #3
	lsl	x12, x12, #5
	add	x10, x10, x12
	add	x12, x12, x19
	add	x12, x12, #272
	add	x13, x13, x19
	sub	x13, x12, x13
	sub	x13, x13, #272
	cmp	x13, #16
	b.lo	LBB34_167
; %bb.125:
	add	x11, x11, x19
	sub	x11, x12, x11
	sub	x11, x11, #272
	cmp	x11, #15
	b.ls	LBB34_167
; %bb.126:
	ldp	q0, q1, [x8]
	ldp	q2, q3, [x9]
	fmul.2d	v0, v0, v2
	fmul.2d	v1, v1, v3
	stp	q0, q1, [x10]
	ldp	q0, q1, [x8, #32]
	ldp	q2, q3, [x9, #32]
	fmul.2d	v0, v0, v2
	fmul.2d	v1, v1, v3
	stp	q0, q1, [x10, #32]
	ldp	q0, q1, [x8, #64]
	ldp	q2, q3, [x9, #64]
	fmul.2d	v0, v0, v2
	fmul.2d	v1, v1, v3
	stp	q0, q1, [x10, #64]
	ldp	q0, q1, [x8, #96]
	ldp	q2, q3, [x9, #96]
	fmul.2d	v0, v0, v2
	fmul.2d	v1, v1, v3
	stp	q0, q1, [x10, #96]
	ldp	q0, q1, [x8, #128]
	ldp	q2, q3, [x9, #128]
	fmul.2d	v0, v0, v2
	fmul.2d	v1, v1, v3
	stp	q0, q1, [x10, #128]
	ldp	q0, q1, [x8, #160]
	ldp	q2, q3, [x9, #160]
	fmul.2d	v0, v0, v2
	fmul.2d	v1, v1, v3
	stp	q0, q1, [x10, #160]
	ldp	q0, q1, [x8, #192]
	ldp	q2, q3, [x9, #192]
	fmul.2d	v0, v0, v2
	fmul.2d	v1, v1, v3
	stp	q0, q1, [x10, #192]
	ldp	q0, q1, [x8, #224]
	ldp	q2, q3, [x9, #224]
	fmul.2d	v0, v0, v2
	fmul.2d	v1, v1, v3
	b	LBB34_137
LBB34_127:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldrh	w11, [x8]
	ldrh	w12, [x10]
	udiv	w11, w11, w12
	strh	w11, [x9]
	ldrh	w11, [x8, #2]
	ldrh	w12, [x10, #2]
	udiv	w11, w11, w12
	strh	w11, [x9, #2]
	ldrh	w11, [x8, #4]
	ldrh	w12, [x10, #4]
	udiv	w11, w11, w12
	strh	w11, [x9, #4]
	ldrh	w11, [x8, #6]
	ldrh	w12, [x10, #6]
	udiv	w11, w11, w12
	strh	w11, [x9, #6]
	ldrh	w11, [x8, #8]
	ldrh	w12, [x10, #8]
	udiv	w11, w11, w12
	strh	w11, [x9, #8]
	ldrh	w11, [x8, #10]
	ldrh	w12, [x10, #10]
	udiv	w11, w11, w12
	strh	w11, [x9, #10]
	ldrh	w11, [x8, #12]
	ldrh	w12, [x10, #12]
	udiv	w11, w11, w12
	strh	w11, [x9, #12]
	ldrh	w8, [x8, #14]
	ldrh	w10, [x10, #14]
	udiv	w8, w8, w10
	strh	w8, [x9, #14]
	b	LBB34_146
LBB34_128:
	ubfx	x8, x1, #10, #3
	add	x10, x19, #272
	add	x8, x10, x8, lsl #5
	ubfx	x9, x1, #13, #3
	add	x9, x10, x9, lsl #5
	ubfx	x11, x1, #7, #3
	add	x10, x10, x11, lsl #5
	ldp	w11, w12, [x8]
	ldp	w13, w14, [x9]
	udiv	w11, w11, w13
	udiv	w12, w12, w14
	stp	w11, w12, [x10]
	ldp	w11, w12, [x8, #8]
	ldp	w13, w14, [x9, #8]
	udiv	w11, w11, w13
	udiv	w12, w12, w14
	stp	w11, w12, [x10, #8]
	ldp	w11, w12, [x8, #16]
	ldp	w13, w14, [x9, #16]
	udiv	w11, w11, w13
	udiv	w12, w12, w14
	stp	w11, w12, [x10, #16]
	ldp	w11, w12, [x8, #24]
	ldp	w13, w14, [x9, #24]
	udiv	w11, w11, w13
	udiv	w12, w12, w14
	stp	w11, w12, [x10, #24]
	ldp	w11, w12, [x8, #32]
	ldp	w13, w14, [x9, #32]
	udiv	w11, w11, w13
	udiv	w12, w12, w14
	stp	w11, w12, [x10, #32]
	ldp	w11, w12, [x8, #40]
	ldp	w13, w14, [x9, #40]
	udiv	w11, w11, w13
	udiv	w12, w12, w14
	stp	w11, w12, [x10, #40]
	ldp	w11, w12, [x8, #48]
	ldp	w13, w14, [x9, #48]
	udiv	w11, w11, w13
	udiv	w12, w12, w14
	stp	w11, w12, [x10, #48]
	ldp	w11, w8, [x8, #56]
	ldp	w12, w9, [x9, #56]
	udiv	w11, w11, w12
	udiv	w8, w8, w9
	stp	w11, w8, [x10, #56]
	b	LBB34_146
LBB34_129:
	mov	x8, #0
	ubfx	x9, x1, #10, #3
	add	x11, x19, #272
	add	x9, x11, x9, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x11, x10, lsl #5
	ubfx	x12, x1, #7, #3
	add	x11, x11, x12, lsl #5
LBB34_130:                              ; =>This Inner Loop Header: Depth=1
	ldr	x12, [x9, x8]
	ldr	x13, [x10, x8]
	udiv	x12, x12, x13
	str	x12, [x11, x8]
	add	x8, x8, #8
	cmp	x8, #256
	b.ne	LBB34_130
	b	LBB34_146
LBB34_131:
	mov	x21, #0
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x22, x9, x8, lsl #5
	ubfx	x8, x1, #13, #3
	add	x23, x9, x8, lsl #5
	ubfx	x8, x1, #7, #3
	add	x24, x9, x8, lsl #5
LBB34_132:                              ; =>This Inner Loop Header: Depth=1
	add	x8, x22, x21
	ldp	x0, x1, [x8]
	add	x8, x23, x21
	ldp	x2, x3, [x8]
	bl	___udivti3
	add	x8, x24, x21
	stp	x0, x1, [x8]
	add	x21, x21, #16
	cmp	x21, #1024
	b.ne	LBB34_132
	b	LBB34_146
LBB34_133:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldp	q0, q1, [x8]
	ldp	q2, q3, [x10]
	fdiv.4s	v0, v0, v2
	fdiv.4s	v1, v1, v3
	stp	q0, q1, [x9]
	ldp	q0, q1, [x8, #32]
	ldp	q2, q3, [x10, #32]
	fdiv.4s	v0, v0, v2
	fdiv.4s	v1, v1, v3
	b	LBB34_145
LBB34_134:
	ubfx	x8, x1, #10, #3
	add	x10, x19, #272
	lsl	x13, x8, #5
	add	x8, x10, x13
	ubfx	x9, x1, #13, #3
	lsl	x11, x9, #5
	add	x9, x10, x11
	ubfx	x12, x1, #7, #3
	lsl	x12, x12, #5
	add	x10, x10, x12
	add	x12, x12, x19
	add	x12, x12, #272
	add	x13, x13, x19
	sub	x13, x12, x13
	sub	x13, x13, #272
	cmp	x13, #16
	b.lo	LBB34_169
; %bb.135:
	add	x11, x11, x19
	sub	x11, x12, x11
	sub	x11, x11, #272
	cmp	x11, #15
	b.ls	LBB34_169
; %bb.136:
	ldp	q0, q1, [x8]
	ldp	q2, q3, [x9]
	fdiv.2d	v0, v0, v2
	fdiv.2d	v1, v1, v3
	stp	q0, q1, [x10]
	ldp	q0, q1, [x8, #32]
	ldp	q2, q3, [x9, #32]
	fdiv.2d	v0, v0, v2
	fdiv.2d	v1, v1, v3
	stp	q0, q1, [x10, #32]
	ldp	q0, q1, [x8, #64]
	ldp	q2, q3, [x9, #64]
	fdiv.2d	v0, v0, v2
	fdiv.2d	v1, v1, v3
	stp	q0, q1, [x10, #64]
	ldp	q0, q1, [x8, #96]
	ldp	q2, q3, [x9, #96]
	fdiv.2d	v0, v0, v2
	fdiv.2d	v1, v1, v3
	stp	q0, q1, [x10, #96]
	ldp	q0, q1, [x8, #128]
	ldp	q2, q3, [x9, #128]
	fdiv.2d	v0, v0, v2
	fdiv.2d	v1, v1, v3
	stp	q0, q1, [x10, #128]
	ldp	q0, q1, [x8, #160]
	ldp	q2, q3, [x9, #160]
	fdiv.2d	v0, v0, v2
	fdiv.2d	v1, v1, v3
	stp	q0, q1, [x10, #160]
	ldp	q0, q1, [x8, #192]
	ldp	q2, q3, [x9, #192]
	fdiv.2d	v0, v0, v2
	fdiv.2d	v1, v1, v3
	stp	q0, q1, [x10, #192]
	ldp	q0, q1, [x8, #224]
	ldp	q2, q3, [x9, #224]
	fdiv.2d	v0, v0, v2
	fdiv.2d	v1, v1, v3
LBB34_137:
	stp	q0, q1, [x10, #224]
	b	LBB34_146
LBB34_138:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ldrh	w10, [x8]
	ubfx	x11, x1, #13, #3
	add	x11, x9, x11, lsl #5
	ubfx	x12, x1, #7, #3
	add	x9, x9, x12, lsl #5
	ldrh	w12, [x11]
	add	w10, w12, w10
	strh	w10, [x9]
	ldrh	w10, [x8, #2]
	ldrh	w12, [x11, #2]
	sub	w10, w10, w12
	strh	w10, [x9, #2]
	ldrh	w10, [x8, #4]
	ldrh	w12, [x11, #4]
	add	w10, w12, w10
	strh	w10, [x9, #4]
	ldrh	w10, [x8, #6]
	ldrh	w12, [x11, #6]
	sub	w10, w10, w12
	strh	w10, [x9, #6]
	ldrh	w10, [x8, #8]
	ldrh	w12, [x11, #8]
	add	w10, w12, w10
	strh	w10, [x9, #8]
	ldrh	w10, [x8, #10]
	ldrh	w12, [x11, #10]
	sub	w10, w10, w12
	strh	w10, [x9, #10]
	ldrh	w10, [x8, #12]
	ldrh	w12, [x11, #12]
	add	w10, w12, w10
	strh	w10, [x9, #12]
	ldrh	w8, [x8, #14]
	ldrh	w10, [x11, #14]
	sub	w8, w8, w10
	strh	w8, [x9, #14]
	b	LBB34_146
LBB34_139:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldp	q0, q1, [x8]
	ldp	q2, q3, [x10]
	add.4s	v4, v0, v2
	sub.4s	v0, v0, v2
	rev64.4s	v2, v4
	trn2.4s	v0, v2, v0
	add.4s	v2, v1, v3
	sub.4s	v1, v1, v3
	rev64.4s	v2, v2
	trn2.4s	v1, v2, v1
	stp	q0, q1, [x9]
	ldp	q0, q1, [x8, #32]
	ldp	q2, q3, [x10, #32]
	add.4s	v4, v0, v2
	sub.4s	v0, v0, v2
	rev64.4s	v2, v4
	trn2.4s	v0, v2, v0
	add.4s	v2, v1, v3
	sub.4s	v1, v1, v3
	b	LBB34_144
LBB34_140:
	ubfx	x8, x1, #7, #3
	add	x10, x19, #272
	add	x8, x10, x8, lsl #5
	ubfx	x9, x1, #13, #3
	add	x9, x10, x9, lsl #5
	ubfx	x11, x1, #10, #3
	add	x10, x10, x11, lsl #5
	ldp	q0, q1, [x10]
	ldp	q2, q3, [x9]
	add.2d	v4, v0, v2
	sub.2d	v0, v0, v2
	mov.d	v4[1], v0[1]
	add.2d	v0, v1, v3
	sub.2d	v1, v1, v3
	mov.d	v0[1], v1[1]
	stp	q4, q0, [x8]
	ldp	q0, q1, [x10, #32]
	ldp	q2, q3, [x9, #32]
	add.2d	v4, v0, v2
	sub.2d	v0, v0, v2
	mov.d	v4[1], v0[1]
	add.2d	v0, v1, v3
	sub.2d	v1, v1, v3
	mov.d	v0[1], v1[1]
	stp	q4, q0, [x8, #32]
	ldp	q0, q1, [x10, #64]
	ldp	q2, q3, [x9, #64]
	add.2d	v4, v0, v2
	sub.2d	v0, v0, v2
	mov.d	v4[1], v0[1]
	add.2d	v0, v1, v3
	sub.2d	v1, v1, v3
	mov.d	v0[1], v1[1]
	stp	q4, q0, [x8, #64]
	ldp	q0, q1, [x10, #96]
	ldp	q2, q3, [x9, #96]
	add.2d	v4, v0, v2
	sub.2d	v0, v0, v2
	mov.d	v4[1], v0[1]
	add.2d	v0, v1, v3
	sub.2d	v1, v1, v3
	mov.d	v0[1], v1[1]
	stp	q4, q0, [x8, #96]
	ldp	q0, q1, [x10, #128]
	ldp	q2, q3, [x9, #128]
	add.2d	v4, v0, v2
	sub.2d	v0, v0, v2
	mov.d	v4[1], v0[1]
	add.2d	v0, v1, v3
	sub.2d	v1, v1, v3
	mov.d	v0[1], v1[1]
	stp	q4, q0, [x8, #128]
	ldp	q0, q1, [x10, #160]
	ldp	q2, q3, [x9, #160]
	add.2d	v4, v0, v2
	sub.2d	v0, v0, v2
	mov.d	v4[1], v0[1]
	add.2d	v0, v1, v3
	sub.2d	v1, v1, v3
	mov.d	v0[1], v1[1]
	stp	q4, q0, [x8, #160]
	ldp	q0, q1, [x10, #192]
	ldp	q2, q3, [x9, #192]
	add.2d	v4, v0, v2
	sub.2d	v0, v0, v2
	mov.d	v4[1], v0[1]
	add.2d	v0, v1, v3
	sub.2d	v1, v1, v3
	mov.d	v0[1], v1[1]
	stp	q4, q0, [x8, #192]
	ldp	q0, q1, [x10, #224]
	ldp	q2, q3, [x9, #224]
	add.2d	v4, v0, v2
	sub.2d	v0, v0, v2
	mov.d	v4[1], v0[1]
	add.2d	v0, v1, v3
	sub.2d	v1, v1, v3
	b	LBB34_148
LBB34_141:
	ubfx	x10, x1, #10, #3
	ubfx	x9, x1, #13, #3
	ubfx	x8, x1, #7, #3
	add	x8, x19, x8, lsl #5
	add	x8, x8, #288
	add	x9, x19, x9, lsl #5
	add	x9, x9, #288
	add	x10, x19, x10, lsl #5
	add	x10, x10, #288
	mov	x11, #-2
LBB34_142:                              ; =>This Inner Loop Header: Depth=1
	ldp	x13, x12, [x10, #-16]
	ldp	x15, x14, [x9, #-16]
	adds	x13, x15, x13
	adc	x12, x14, x12
	stp	x13, x12, [x8, #-16]
	ldp	x13, x12, [x10], #32
	ldp	x15, x14, [x9], #32
	subs	x13, x13, x15
	sbc	x12, x12, x14
	add	x11, x11, #2
	stp	x13, x12, [x8], #32
	cmp	x11, #62
	b.lo	LBB34_142
	b	LBB34_146
LBB34_143:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldp	q0, q1, [x8]
	ldp	q2, q3, [x10]
	fadd.4s	v4, v0, v2
	fsub.4s	v0, v0, v2
	rev64.4s	v2, v4
	trn2.4s	v0, v2, v0
	fadd.4s	v2, v1, v3
	fsub.4s	v1, v1, v3
	rev64.4s	v2, v2
	trn2.4s	v1, v2, v1
	stp	q0, q1, [x9]
	ldp	q0, q1, [x8, #32]
	ldp	q2, q3, [x10, #32]
	fadd.4s	v4, v0, v2
	fsub.4s	v0, v0, v2
	rev64.4s	v2, v4
	trn2.4s	v0, v2, v0
	fadd.4s	v2, v1, v3
	fsub.4s	v1, v1, v3
LBB34_144:
	rev64.4s	v2, v2
	trn2.4s	v1, v2, v1
LBB34_145:
	stp	q0, q1, [x9, #32]
LBB34_146:
	mov	x0, x20
	mov	x1, x19
	mov	w2, #528
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp], #64             ; 16-byte Folded Reload
	b	_memcpy
LBB34_147:
	ubfx	x8, x1, #7, #3
	add	x10, x19, #272
	add	x8, x10, x8, lsl #5
	ubfx	x9, x1, #13, #3
	add	x9, x10, x9, lsl #5
	ubfx	x11, x1, #10, #3
	add	x10, x10, x11, lsl #5
	ldp	q0, q1, [x10]
	ldp	q2, q3, [x9]
	fadd.2d	v4, v0, v2
	fsub.2d	v0, v0, v2
	mov.d	v4[1], v0[1]
	fadd.2d	v0, v1, v3
	fsub.2d	v1, v1, v3
	mov.d	v0[1], v1[1]
	stp	q4, q0, [x8]
	ldp	q0, q1, [x10, #32]
	ldp	q2, q3, [x9, #32]
	fadd.2d	v4, v0, v2
	fsub.2d	v0, v0, v2
	mov.d	v4[1], v0[1]
	fadd.2d	v0, v1, v3
	fsub.2d	v1, v1, v3
	mov.d	v0[1], v1[1]
	stp	q4, q0, [x8, #32]
	ldp	q0, q1, [x10, #64]
	ldp	q2, q3, [x9, #64]
	fadd.2d	v4, v0, v2
	fsub.2d	v0, v0, v2
	mov.d	v4[1], v0[1]
	fadd.2d	v0, v1, v3
	fsub.2d	v1, v1, v3
	mov.d	v0[1], v1[1]
	stp	q4, q0, [x8, #64]
	ldp	q0, q1, [x10, #96]
	ldp	q2, q3, [x9, #96]
	fadd.2d	v4, v0, v2
	fsub.2d	v0, v0, v2
	mov.d	v4[1], v0[1]
	fadd.2d	v0, v1, v3
	fsub.2d	v1, v1, v3
	mov.d	v0[1], v1[1]
	stp	q4, q0, [x8, #96]
	ldp	q0, q1, [x10, #128]
	ldp	q2, q3, [x9, #128]
	fadd.2d	v4, v0, v2
	fsub.2d	v0, v0, v2
	mov.d	v4[1], v0[1]
	fadd.2d	v0, v1, v3
	fsub.2d	v1, v1, v3
	mov.d	v0[1], v1[1]
	stp	q4, q0, [x8, #128]
	ldp	q0, q1, [x10, #160]
	ldp	q2, q3, [x9, #160]
	fadd.2d	v4, v0, v2
	fsub.2d	v0, v0, v2
	mov.d	v4[1], v0[1]
	fadd.2d	v0, v1, v3
	fsub.2d	v1, v1, v3
	mov.d	v0[1], v1[1]
	stp	q4, q0, [x8, #160]
	ldp	q0, q1, [x10, #192]
	ldp	q2, q3, [x9, #192]
	fadd.2d	v4, v0, v2
	fsub.2d	v0, v0, v2
	mov.d	v4[1], v0[1]
	fadd.2d	v0, v1, v3
	fsub.2d	v1, v1, v3
	mov.d	v0[1], v1[1]
	stp	q4, q0, [x8, #192]
	ldp	q0, q1, [x10, #224]
	ldp	q2, q3, [x9, #224]
	fadd.2d	v4, v0, v2
	fsub.2d	v0, v0, v2
	mov.d	v4[1], v0[1]
	fadd.2d	v0, v1, v3
	fsub.2d	v1, v1, v3
LBB34_148:
	mov.d	v0[1], v1[1]
	stp	q4, q0, [x8, #224]
	b	LBB34_146
LBB34_149:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldrb	w11, [x10]
	ldrb	w11, [x8, x11]
	strb	w11, [x9]
	ldrb	w11, [x10, #1]
	ldrb	w11, [x8, x11]
	strb	w11, [x9, #1]
	ldrb	w11, [x10, #2]
	ldrb	w11, [x8, x11]
	strb	w11, [x9, #2]
	ldrb	w10, [x10, #3]
	ldrb	w8, [x8, x10]
	strb	w8, [x9, #3]
	b	LBB34_146
LBB34_150:
	ubfx	x8, x1, #10, #3
	add	x9, x19, #272
	add	x8, x9, x8, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x9, x10, lsl #5
	ubfx	x11, x1, #7, #3
	add	x9, x9, x11, lsl #5
	ldrh	w11, [x10]
	ldrh	w11, [x8, x11, lsl  #1]
	strh	w11, [x9]
	ldrh	w11, [x10, #2]
	ldrh	w11, [x8, x11, lsl  #1]
	strh	w11, [x9, #2]
	ldrh	w11, [x10, #4]
	ldrh	w11, [x8, x11, lsl  #1]
	strh	w11, [x9, #4]
	ldrh	w11, [x10, #6]
	ldrh	w11, [x8, x11, lsl  #1]
	strh	w11, [x9, #6]
	ldrh	w11, [x10, #8]
	ldrh	w11, [x8, x11, lsl  #1]
	strh	w11, [x9, #8]
	ldrh	w11, [x10, #10]
	ldrh	w11, [x8, x11, lsl  #1]
	strh	w11, [x9, #10]
	ldrh	w11, [x10, #12]
	ldrh	w11, [x8, x11, lsl  #1]
	strh	w11, [x9, #12]
	ldrh	w10, [x10, #14]
	ldrh	w8, [x8, x10, lsl  #1]
	strh	w8, [x9, #14]
	b	LBB34_146
LBB34_151:
	mov	x8, #0
	ubfx	x9, x1, #10, #3
	add	x11, x19, #272
	add	x9, x11, x9, lsl #5
	ubfx	x10, x1, #13, #3
	add	x10, x11, x10, lsl #5
	ubfx	x12, x1, #7, #3
	add	x11, x11, x12, lsl #5
LBB34_152:                              ; =>This Inner Loop Header: Depth=1
	ldr	x12, [x10, x8]
	add	x12, x9, x12, lsl #4
	ldp	x12, x13, [x12]
	add	x14, x11, x8
	stp	x12, x13, [x14]
	add	x8, x8, #16
	cmp	x8, #1024
	b.ne	LBB34_152
	b	LBB34_146
LBB34_153:
	mov	x11, #0
LBB34_154:                              ; =>This Inner Loop Header: Depth=1
	ldr	x12, [x9, x11]
	ldr	x13, [x10, x11]
	udiv	x14, x12, x13
	msub	x12, x14, x13, x12
	str	x12, [x8, x11]
	add	x11, x11, #8
	cmp	x11, #256
	b.ne	LBB34_154
	b	LBB34_146
LBB34_155:
	mov	x11, #0
LBB34_156:                              ; =>This Inner Loop Header: Depth=1
	ldr	x12, [x8, x11]
	ldr	x13, [x10, x11]
	ror	x12, x12, x13
	str	x12, [x9, x11]
	add	x11, x11, #8
	cmp	x11, #256
	b.ne	LBB34_156
	b	LBB34_146
LBB34_157:
	mov	x11, #0
LBB34_158:                              ; =>This Inner Loop Header: Depth=1
	ldr	x12, [x8, x11]
	ldr	w13, [x10, x11]
	neg	w13, w13
	ror	x12, x12, x13
	str	x12, [x9, x11]
	add	x11, x11, #8
	cmp	x11, #256
	b.ne	LBB34_158
	b	LBB34_146
LBB34_159:
	mov	x11, #0
LBB34_160:                              ; =>This Inner Loop Header: Depth=1
	ldr	x12, [x8, x11]
	ldr	x13, [x9, x11]
	add	x12, x13, x12
	str	x12, [x10, x11]
	add	x11, x11, #8
	cmp	x11, #256
	b.ne	LBB34_160
	b	LBB34_146
LBB34_161:
	mov	x11, #0
LBB34_162:                              ; =>This Inner Loop Header: Depth=1
	ldr	d0, [x8, x11]
	ldr	d1, [x9, x11]
	fadd	d0, d0, d1
	str	d0, [x10, x11]
	add	x11, x11, #8
	cmp	x11, #256
	b.ne	LBB34_162
	b	LBB34_146
LBB34_163:
	mov	x11, #0
LBB34_164:                              ; =>This Inner Loop Header: Depth=1
	ldr	x12, [x8, x11]
	ldr	x13, [x9, x11]
	sub	x12, x12, x13
	str	x12, [x10, x11]
	add	x11, x11, #8
	cmp	x11, #256
	b.ne	LBB34_164
	b	LBB34_146
LBB34_165:
	mov	x11, #0
LBB34_166:                              ; =>This Inner Loop Header: Depth=1
	ldr	d0, [x8, x11]
	ldr	d1, [x9, x11]
	fsub	d0, d0, d1
	str	d0, [x10, x11]
	add	x11, x11, #8
	cmp	x11, #256
	b.ne	LBB34_166
	b	LBB34_146
LBB34_167:
	mov	x11, #0
LBB34_168:                              ; =>This Inner Loop Header: Depth=1
	ldr	d0, [x8, x11]
	ldr	d1, [x9, x11]
	fmul	d0, d0, d1
	str	d0, [x10, x11]
	add	x11, x11, #8
	cmp	x11, #256
	b.ne	LBB34_168
	b	LBB34_146
LBB34_169:
	mov	x11, #0
LBB34_170:                              ; =>This Inner Loop Header: Depth=1
	ldr	d0, [x8, x11]
	ldr	d1, [x9, x11]
	fdiv	d0, d0, d1
	str	d0, [x10, x11]
	add	x11, x11, #8
	cmp	x11, #256
	b.ne	LBB34_170
	b	LBB34_146
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
	.cfi_endproc
	.section	__TEXT,__const
	.p2align	1, 0x0
lJTI34_0:
	.short	(LBB34_2-LBB34_2)>>2
	.short	(LBB34_5-LBB34_2)>>2
	.short	(LBB34_8-LBB34_2)>>2
	.short	(LBB34_11-LBB34_2)>>2
	.short	(LBB34_14-LBB34_2)>>2
	.short	(LBB34_20-LBB34_2)>>2
	.short	(LBB34_26-LBB34_2)>>2
	.short	(LBB34_32-LBB34_2)>>2
	.short	(LBB34_38-LBB34_2)>>2
	.short	(LBB34_44-LBB34_2)>>2
	.short	(LBB34_47-LBB34_2)>>2
	.short	(LBB34_50-LBB34_2)>>2
	.short	(LBB34_54-LBB34_2)>>2
	.short	(LBB34_146-LBB34_2)>>2
	.short	(LBB34_58-LBB34_2)>>2
	.short	(LBB34_146-LBB34_2)>>2
	.p2align	1, 0x0
lJTI34_1:
	.short	(LBB34_149-LBB34_60)>>2
	.short	(LBB34_150-LBB34_60)>>2
	.short	(LBB34_60-LBB34_60)>>2
	.short	(LBB34_64-LBB34_60)>>2
	.short	(LBB34_151-LBB34_60)>>2
	.short	(LBB34_60-LBB34_60)>>2
	.short	(LBB34_64-LBB34_60)>>2
	.p2align	1, 0x0
lJTI34_2:
	.short	(LBB34_56-LBB34_56)>>2
	.short	(LBB34_138-LBB34_56)>>2
	.short	(LBB34_139-LBB34_56)>>2
	.short	(LBB34_140-LBB34_56)>>2
	.short	(LBB34_141-LBB34_56)>>2
	.short	(LBB34_143-LBB34_56)>>2
	.short	(LBB34_147-LBB34_56)>>2
	.p2align	1, 0x0
lJTI34_3:
	.short	(LBB34_52-LBB34_52)>>2
	.short	(LBB34_87-LBB34_52)>>2
	.short	(LBB34_88-LBB34_52)>>2
	.short	(LBB34_89-LBB34_52)>>2
	.short	(LBB34_93-LBB34_52)>>2
	.p2align	1, 0x0
lJTI34_4:
	.short	(LBB34_49-LBB34_49)>>2
	.short	(LBB34_80-LBB34_49)>>2
	.short	(LBB34_81-LBB34_49)>>2
	.short	(LBB34_82-LBB34_49)>>2
	.short	(LBB34_85-LBB34_49)>>2
	.p2align	1, 0x0
lJTI34_5:
	.short	(LBB34_46-LBB34_46)>>2
	.short	(LBB34_62-LBB34_46)>>2
	.short	(LBB34_63-LBB34_46)>>2
	.short	(LBB34_75-LBB34_46)>>2
	.short	(LBB34_78-LBB34_46)>>2
	.p2align	1, 0x0
lJTI34_6:
	.short	(LBB34_46-LBB34_40)>>2
	.short	(LBB34_62-LBB34_40)>>2
	.short	(LBB34_63-LBB34_40)>>2
	.short	(LBB34_40-LBB34_40)>>2
	.short	(LBB34_73-LBB34_40)>>2
	.p2align	1, 0x0
lJTI34_7:
	.short	(LBB34_46-LBB34_34)>>2
	.short	(LBB34_62-LBB34_34)>>2
	.short	(LBB34_63-LBB34_34)>>2
	.short	(LBB34_34-LBB34_34)>>2
	.short	(LBB34_71-LBB34_34)>>2
	.p2align	1, 0x0
lJTI34_8:
	.short	(LBB34_46-LBB34_28)>>2
	.short	(LBB34_62-LBB34_28)>>2
	.short	(LBB34_63-LBB34_28)>>2
	.short	(LBB34_28-LBB34_28)>>2
	.short	(LBB34_69-LBB34_28)>>2
	.p2align	1, 0x0
lJTI34_9:
	.short	(LBB34_46-LBB34_22)>>2
	.short	(LBB34_62-LBB34_22)>>2
	.short	(LBB34_63-LBB34_22)>>2
	.short	(LBB34_22-LBB34_22)>>2
	.short	(LBB34_67-LBB34_22)>>2
	.p2align	1, 0x0
lJTI34_10:
	.short	(LBB34_46-LBB34_16)>>2
	.short	(LBB34_62-LBB34_16)>>2
	.short	(LBB34_63-LBB34_16)>>2
	.short	(LBB34_16-LBB34_16)>>2
	.short	(LBB34_65-LBB34_16)>>2
	.p2align	1, 0x0
lJTI34_11:
	.short	(LBB34_13-LBB34_13)>>2
	.short	(LBB34_127-LBB34_13)>>2
	.short	(LBB34_128-LBB34_13)>>2
	.short	(LBB34_129-LBB34_13)>>2
	.short	(LBB34_131-LBB34_13)>>2
	.short	(LBB34_133-LBB34_13)>>2
	.short	(LBB34_134-LBB34_13)>>2
	.p2align	1, 0x0
lJTI34_12:
	.short	(LBB34_10-LBB34_10)>>2
	.short	(LBB34_117-LBB34_10)>>2
	.short	(LBB34_118-LBB34_10)>>2
	.short	(LBB34_119-LBB34_10)>>2
	.short	(LBB34_121-LBB34_10)>>2
	.short	(LBB34_123-LBB34_10)>>2
	.short	(LBB34_124-LBB34_10)>>2
	.p2align	1, 0x0
lJTI34_13:
	.short	(LBB34_7-LBB34_7)>>2
	.short	(LBB34_106-LBB34_7)>>2
	.short	(LBB34_107-LBB34_7)>>2
	.short	(LBB34_108-LBB34_7)>>2
	.short	(LBB34_111-LBB34_7)>>2
	.short	(LBB34_113-LBB34_7)>>2
	.short	(LBB34_114-LBB34_7)>>2
	.p2align	1, 0x0
lJTI34_14:
	.short	(LBB34_4-LBB34_4)>>2
	.short	(LBB34_95-LBB34_4)>>2
	.short	(LBB34_96-LBB34_4)>>2
	.short	(LBB34_97-LBB34_4)>>2
	.short	(LBB34_100-LBB34_4)>>2
	.short	(LBB34_102-LBB34_4)>>2
	.short	(LBB34_103-LBB34_4)>>2
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_exec_data_type                 ; -- Begin function exec_data_type
	.p2align	2
_exec_data_type:                        ; @exec_data_type
	.cfi_startproc
; %bb.0:
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x0
	mov	x20, x8
	ubfx	w8, w1, #2, #5
	cmp	w8, #13
	b.hi	LBB35_3
; %bb.1:
Lloh126:
	adrp	x9, lJTI35_0@PAGE
Lloh127:
	add	x9, x9, lJTI35_0@PAGEOFF
	adr	x10, LBB35_2
	ldrb	w11, [x9, x8]
	add	x10, x10, x11, lsl #2
	br	x10
LBB35_2:
	ldrb	w8, [x19, #256]
	tbnz	w8, #0, LBB35_9
	b	LBB35_12
LBB35_3:
	mov	w0, #4
	bl	_raise
	b	LBB35_12
LBB35_4:
	ldrb	w8, [x19, #256]
	tst	w8, #0x3
	b.ne	LBB35_12
	b	LBB35_9
LBB35_5:
	ldrb	w8, [x19, #256]
	tbz	w8, #0, LBB35_9
	b	LBB35_12
LBB35_6:
	ldrb	w8, [x19, #256]
	tst	w8, #0x3
	b.ne	LBB35_9
	b	LBB35_12
LBB35_7:
	ldrb	w8, [x19, #256]
	tbnz	w8, #1, LBB35_9
	b	LBB35_12
LBB35_8:
	ldrb	w8, [x19, #256]
	tbnz	w8, #1, LBB35_12
LBB35_9:
	ldr	x8, [x19, #248]
	b	LBB35_16
LBB35_10:
	ldrb	w8, [x19, #256]
	tbz	w8, #0, LBB35_12
	b	LBB35_15
LBB35_11:
	ldrb	w8, [x19, #256]
	tst	w8, #0x3
	b.eq	LBB35_15
LBB35_12:
	ldr	x8, [x19, #248]
	add	x8, x8, #4
	b	LBB35_17
LBB35_13:
	ldrb	w8, [x19, #256]
	tbnz	w8, #0, LBB35_12
	b	LBB35_15
LBB35_14:
	ldrb	w8, [x19, #256]
	tst	w8, #0x3
	b.eq	LBB35_12
LBB35_15:
	ldr	x8, [x19, #248]
	str	x8, [x19, #232]
LBB35_16:
	asr	w9, w1, #7
	add	x8, x8, w9, sxtw #2
LBB35_17:
	str	x8, [x19, #248]
	mov	x0, x20
	mov	x1, x19
	mov	w2, #528
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	b	_memcpy
LBB35_18:
	ldrb	w8, [x19, #256]
	tbz	w8, #1, LBB35_12
	b	LBB35_15
LBB35_19:
	ldrb	w8, [x19, #256]
	tbnz	w8, #1, LBB35_12
	b	LBB35_15
	.loh AdrpAdd	Lloh126, Lloh127
	.cfi_endproc
	.section	__TEXT,__const
lJTI35_0:
	.byte	(LBB35_9-LBB35_2)>>2
	.byte	(LBB35_15-LBB35_2)>>2
	.byte	(LBB35_2-LBB35_2)>>2
	.byte	(LBB35_4-LBB35_2)>>2
	.byte	(LBB35_5-LBB35_2)>>2
	.byte	(LBB35_6-LBB35_2)>>2
	.byte	(LBB35_7-LBB35_2)>>2
	.byte	(LBB35_8-LBB35_2)>>2
	.byte	(LBB35_10-LBB35_2)>>2
	.byte	(LBB35_11-LBB35_2)>>2
	.byte	(LBB35_13-LBB35_2)>>2
	.byte	(LBB35_14-LBB35_2)>>2
	.byte	(LBB35_18-LBB35_2)>>2
	.byte	(LBB35_19-LBB35_2)>>2
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_exec_rri_type                  ; -- Begin function exec_rri_type
	.p2align	2
_exec_rri_type:                         ; @exec_rri_type
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
	sub	sp, sp, #1056
	mov	x21, x1
	mov	x19, x0
	mov	x20, x8
	ubfx	w8, w21, #2, #5
	cmp	w8, #18
	b.hi	LBB36_31
; %bb.1:
Lloh128:
	adrp	x9, lJTI36_0@PAGE
Lloh129:
	add	x9, x9, lJTI36_0@PAGEOFF
Ltmp0:
	adr	x10, Ltmp0
	ldrsw	x11, [x9, x8, lsl  #2]
	add	x10, x10, x11
	br	x10
LBB36_2:
	ubfx	x8, x21, #27, #5
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #7, #15
	adds	x8, x8, x9
	b	LBB36_13
LBB36_3:
	ubfx	x8, x21, #27, #5
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #7, #15
	subs	x8, x8, x9
	b	LBB36_13
LBB36_4:
	ubfx	x8, x21, #27, #5
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #7, #15
	mul	x8, x8, x9
	b	LBB36_12
LBB36_5:
	ubfx	x8, x21, #27, #5
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #7, #15
	cmp	x9, x8
	cset	w10, hi
	udiv	x8, x8, x9
	ldr	w9, [x19, #256]
	and	w9, w9, #0xfffffffc
	bfi	w9, w10, #1, #1
	str	w9, [x19, #256]
	b	LBB36_14
LBB36_6:
	ubfx	x8, x21, #27, #5
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #7, #15
	udiv	x10, x8, x9
	msub	x8, x10, x9, x8
	b	LBB36_12
LBB36_7:
	ubfx	x8, x21, #27, #5
	ldr	x8, [x19, x8, lsl  #3]
	and	w8, w8, w21, lsr #7
	ands	x8, x8, #0x7fff
	b	LBB36_13
LBB36_8:
	ubfx	x8, x21, #27, #5
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #7, #15
	orr	x8, x8, x9
	b	LBB36_12
LBB36_9:
	ubfx	x8, x21, #27, #5
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #7, #15
	eor	x8, x8, x9
	b	LBB36_12
LBB36_10:
	ubfx	x8, x21, #27, #5
	ldr	x8, [x19, x8, lsl  #3]
	lsr	x9, x21, #7
	lsl	x8, x8, x9
	b	LBB36_12
LBB36_11:
	ubfx	x8, x21, #27, #5
	ldr	x8, [x19, x8, lsl  #3]
	lsr	x9, x21, #7
	lsr	x8, x8, x9
LBB36_12:
	cmp	x8, #0
LBB36_13:
	cset	w9, eq
	ldr	w10, [x19, #256]
	and	w10, w10, #0xfffffffc
	bfi	w10, w9, #1, #1
	str	w10, [x19, #256]
LBB36_14:
	ubfx	x9, x21, #22, #5
LBB36_15:
	str	x8, [x19, x9, lsl  #3]
LBB36_16:
	ldr	x8, [x19, #248]
	add	x8, x8, #4
	str	x8, [x19, #248]
	mov	x0, x20
	mov	x1, x19
	mov	w2, #528
	bl	_memcpy
	add	sp, sp, #1056
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
LBB36_17:
	ubfx	x8, x21, #22, #5
	ubfx	x9, x21, #27, #5
	ldr	x9, [x19, x9, lsl  #3]
	ubfx	x10, x21, #7, #15
	mov	w11, #64
	sub	x10, x11, x10
	; InlineAsm Start
	ror	x9, x9, x10
	; InlineAsm End
	b	LBB36_19
LBB36_18:
	ubfx	x8, x21, #22, #5
	ubfx	x9, x21, #27, #5
	ldr	x9, [x19, x9, lsl  #3]
	ubfx	x10, x21, #7, #15
	; InlineAsm Start
	ror	x9, x9, x10
	; InlineAsm End
LBB36_19:
	cmp	x9, #0
	cset	w10, eq
	str	x9, [x19, x8, lsl  #3]
	ldr	w8, [x19, #256]
	and	w8, w8, #0xfffffffc
	bfi	w8, w10, #1, #1
	str	w8, [x19, #256]
	b	LBB36_16
LBB36_20:
	ubfx	w8, w21, #17, #2
Lloh130:
	adrp	x9, lJTI36_4@PAGE
Lloh131:
	add	x9, x9, lJTI36_4@PAGEOFF
Ltmp1:
	adr	x10, Ltmp1
	ldrsw	x11, [x9, x8, lsl  #2]
	add	x10, x10, x11
	br	x10
LBB36_21:
	ubfx	x8, x21, #12, #5
	ldr	x8, [x19, x8, lsl  #3]
	asr	w9, w21, #19
	ldr	x8, [x8, w9, sxtw]
	cmp	x8, #0
	cset	w9, eq
	ldr	w10, [x19, #256]
	and	w10, w10, #0xfffffffc
	bfi	w10, w9, #1, #1
	lsr	x9, x8, #63
	orr	w9, w10, w9
	str	w9, [x19, #256]
	ubfx	x9, x21, #7, #5
	b	LBB36_15
LBB36_22:
	ubfx	w8, w21, #17, #2
Lloh132:
	adrp	x9, lJTI36_3@PAGE
Lloh133:
	add	x9, x9, lJTI36_3@PAGEOFF
Ltmp2:
	adr	x10, Ltmp2
	ldrsw	x11, [x9, x8, lsl  #2]
	add	x10, x10, x11
	br	x10
LBB36_23:
	ubfx	x8, x21, #7, #5
	ldr	x8, [x19, x8, lsl  #3]
	cmp	x8, #0
	cset	w9, eq
	ldr	w10, [x19, #256]
	and	w10, w10, #0xfffffffc
	bfi	w10, w9, #1, #1
	lsr	x9, x8, #63
	orr	w9, w10, w9
	str	w9, [x19, #256]
	ubfx	x9, x21, #12, #5
	ldr	x9, [x19, x9, lsl  #3]
	asr	w10, w21, #19
	str	x8, [x9, w10, sxtw]
	b	LBB36_16
LBB36_24:
	lsr	x8, x21, #26
	lsr	w9, w21, #18
	ubfx	w10, w21, #18, #6
	mov	x11, #-1
	lsl	x9, x11, x9
	mvn	x11, x9
	ubfx	x12, x21, #27, #5
	ldr	x12, [x19, x12, lsl  #3]
	lsl	x11, x11, x8
	and	x11, x12, x11
	lsr	x8, x11, x8
	sub	w10, w10, #1
	mov	w11, #1
	lsl	x10, x11, x10
	and	w10, w10, w8
	tst	x10, #0xff
	csel	x9, xzr, x9, eq
	orr	x9, x9, x8
	tst	w21, #0x1000
	csel	x8, x8, x9, eq
	b	LBB36_14
LBB36_25:
	lsr	x8, x21, #26
	lsr	x9, x21, #18
	mov	x10, #-1
	lsl	x9, x10, x9
	mvn	x10, x9
	lsl	x10, x10, x8
	ubfx	x11, x21, #22, #5
	lsl	x11, x11, #3
	ldr	x12, [x19, x11]
	bic	x10, x12, x10
	str	x10, [x19, x11]
	ubfx	x12, x21, #27, #5
	ldr	x12, [x19, x12, lsl  #3]
	bic	x9, x12, x9
	lsl	x8, x9, x8
	orr	x8, x8, x10
	str	x8, [x19, x11]
	b	LBB36_16
LBB36_26:
	ubfx	w8, w21, #7, #2
Lloh134:
	adrp	x9, lJTI36_2@PAGE
Lloh135:
	add	x9, x9, lJTI36_2@PAGEOFF
Ltmp3:
	adr	x10, Ltmp3
	ldrsw	x11, [x9, x8, lsl  #2]
	add	x10, x10, x11
	br	x10
LBB36_27:
	ubfx	x8, x21, #19, #5
	lsl	x8, x8, #3
	ldr	x9, [x19, x8]
	ubfx	x10, x21, #24, #8
	ldr	x9, [x9, x10]
	ubfx	x11, x21, #9, #5
	str	x9, [x19, x11, lsl  #3]
	ldr	x8, [x19, x8]
	add	x8, x10, x8
	ldr	x8, [x8, #8]
	ubfx	x9, x21, #14, #5
	b	LBB36_15
LBB36_28:
	ubfx	w8, w21, #7, #2
Lloh136:
	adrp	x9, lJTI36_1@PAGE
Lloh137:
	add	x9, x9, lJTI36_1@PAGEOFF
Ltmp4:
	adr	x10, Ltmp4
	ldrsw	x11, [x9, x8, lsl  #2]
	add	x10, x10, x11
	br	x10
LBB36_29:
	ubfx	x8, x21, #9, #5
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #19, #5
	lsl	x9, x9, #3
	ldr	x10, [x19, x9]
	ubfx	x11, x21, #24, #8
	str	x8, [x10, x11]
	ubfx	x8, x21, #14, #5
	ldr	x8, [x19, x8, lsl  #3]
	ldr	x9, [x19, x9]
	add	x9, x11, x9
	str	x8, [x9, #8]
	b	LBB36_16
LBB36_30:
	mov	x0, sp
	mov	x1, x19
	mov	w2, #528
	bl	_memcpy
	and	x1, x21, #0xffffffff
	add	x8, sp, #528
	mov	x0, sp
	bl	_exec_simd_type
	add	x1, sp, #528
	mov	x0, x19
	mov	w2, #528
	bl	_memcpy
	b	LBB36_16
LBB36_31:
	mov	w0, #4
	bl	_raise
	b	LBB36_16
LBB36_32:
	ubfx	x8, x21, #12, #5
	ldr	x8, [x19, x8, lsl  #3]
	asr	w9, w21, #19
	ldr	w8, [x8, w9, sxtw]
	cmp	w8, #0
	cset	w9, eq
	ldr	w10, [x19, #256]
	and	w10, w10, #0xfffffffc
	extr	w9, w9, w8, #31
	orr	w9, w9, w10
	str	w9, [x19, #256]
	ubfx	x9, x21, #7, #5
	lsl	x9, x9, #3
	str	w8, [x19, x9]
	b	LBB36_16
LBB36_33:
	ubfx	x8, x21, #12, #5
	ldr	x8, [x19, x8, lsl  #3]
	asr	w9, w21, #19
	ldrh	w8, [x8, w9, sxtw]
	cmp	w8, #0
	cset	w9, eq
	ldr	w10, [x19, #256]
	and	w10, w10, #0xfffffffc
	bfi	w10, w9, #1, #1
	orr	w9, w10, w8, lsr #15
	str	w9, [x19, #256]
	ubfx	x9, x21, #7, #5
	lsl	x9, x9, #3
	strh	w8, [x19, x9]
	b	LBB36_16
LBB36_34:
	ubfx	x8, x21, #12, #5
	ldr	x8, [x19, x8, lsl  #3]
	asr	w9, w21, #19
	ldrb	w8, [x8, w9, sxtw]
	cmp	w8, #0
	cset	w9, eq
	ldr	w10, [x19, #256]
	and	w10, w10, #0xfffffffc
	bfi	w10, w9, #1, #1
	orr	w9, w10, w8, lsr #7
	str	w9, [x19, #256]
	ubfx	x9, x21, #7, #5
	lsl	x9, x9, #3
	strb	w8, [x19, x9]
	b	LBB36_16
LBB36_35:
	ubfx	x8, x21, #7, #5
	lsl	x8, x8, #3
	ldr	w8, [x19, x8]
	cmp	w8, #0
	cset	w9, eq
	ldr	w10, [x19, #256]
	and	w10, w10, #0xfffffffc
	extr	w9, w9, w8, #31
	orr	w9, w9, w10
	str	w9, [x19, #256]
	ubfx	x9, x21, #12, #5
	ldr	x9, [x19, x9, lsl  #3]
	asr	w10, w21, #19
	str	w8, [x9, w10, sxtw]
	b	LBB36_16
LBB36_36:
	ubfx	x8, x21, #7, #5
	lsl	x8, x8, #3
	ldrh	w8, [x19, x8]
	cmp	w8, #0
	cset	w9, eq
	ldr	w10, [x19, #256]
	and	w10, w10, #0xfffffffc
	bfi	w10, w9, #1, #1
	orr	w9, w10, w8, lsr #15
	str	w9, [x19, #256]
	ubfx	x9, x21, #12, #5
	ldr	x9, [x19, x9, lsl  #3]
	asr	w10, w21, #19
	strh	w8, [x9, w10, sxtw]
	b	LBB36_16
LBB36_37:
	ubfx	x8, x21, #7, #5
	lsl	x8, x8, #3
	ldrb	w8, [x19, x8]
	cmp	w8, #0
	cset	w9, eq
	ldr	w10, [x19, #256]
	and	w10, w10, #0xfffffffc
	bfi	w10, w9, #1, #1
	orr	w9, w10, w8, lsr #7
	str	w9, [x19, #256]
	ubfx	x9, x21, #12, #5
	ldr	x9, [x19, x9, lsl  #3]
	asr	w10, w21, #19
	strb	w8, [x9, w10, sxtw]
	b	LBB36_16
LBB36_38:
	ubfx	x8, x21, #19, #5
	lsl	x8, x8, #3
	ldr	x9, [x19, x8]
	ubfx	x10, x21, #24, #8
	ldr	w9, [x9, x10]
	ubfx	x11, x21, #9, #5
	lsl	x11, x11, #3
	str	w9, [x19, x11]
	ldr	x8, [x19, x8]
	add	x8, x10, x8
	ldr	w8, [x8, #4]
	str	w8, [x19, x11]
	b	LBB36_16
LBB36_39:
	ubfx	x8, x21, #19, #5
	lsl	x8, x8, #3
	ldr	x9, [x19, x8]
	ubfx	x10, x21, #24, #8
	ldrh	w9, [x9, x10]
	ubfx	x11, x21, #9, #5
	lsl	x11, x11, #3
	strh	w9, [x19, x11]
	ldr	x8, [x19, x8]
	add	x8, x10, x8
	ldrh	w8, [x8, #2]
	strh	w8, [x19, x11]
	b	LBB36_16
LBB36_40:
	ubfx	x8, x21, #19, #5
	lsl	x8, x8, #3
	ldr	x9, [x19, x8]
	ubfx	x10, x21, #24, #8
	ldrb	w9, [x9, x10]
	ubfx	x11, x21, #9, #5
	lsl	x11, x11, #3
	strb	w9, [x19, x11]
	ldr	x8, [x19, x8]
	add	x8, x10, x8
	ldrb	w8, [x8, #1]
	strb	w8, [x19, x11]
	b	LBB36_16
LBB36_41:
	ubfx	x8, x21, #9, #5
	lsl	x8, x8, #3
	ldr	w8, [x19, x8]
	ubfx	x9, x21, #19, #5
	lsl	x9, x9, #3
	ldr	x10, [x19, x9]
	ubfx	x11, x21, #24, #8
	str	w8, [x10, x11]
	ubfx	x8, x21, #14, #5
	lsl	x8, x8, #3
	ldr	w8, [x19, x8]
	ldr	x9, [x19, x9]
	add	x9, x11, x9
	str	w8, [x9, #4]
	b	LBB36_16
LBB36_42:
	ubfx	x8, x21, #9, #5
	lsl	x8, x8, #3
	ldrh	w8, [x19, x8]
	ubfx	x9, x21, #19, #5
	lsl	x9, x9, #3
	ldr	x10, [x19, x9]
	ubfx	x11, x21, #24, #8
	strh	w8, [x10, x11]
	ubfx	x8, x21, #14, #5
	lsl	x8, x8, #3
	ldrh	w8, [x19, x8]
	ldr	x9, [x19, x9]
	add	x9, x11, x9
	strh	w8, [x9, #2]
	b	LBB36_16
LBB36_43:
	ubfx	x8, x21, #9, #5
	lsl	x8, x8, #3
	ldrb	w8, [x19, x8]
	ubfx	x9, x21, #19, #5
	lsl	x9, x9, #3
	ldr	x10, [x19, x9]
	ubfx	x11, x21, #24, #8
	strb	w8, [x10, x11]
	ubfx	x8, x21, #14, #5
	lsl	x8, x8, #3
	ldrb	w8, [x19, x8]
	ldr	x9, [x19, x9]
	add	x9, x11, x9
	strb	w8, [x9, #1]
	b	LBB36_16
	.loh AdrpAdd	Lloh128, Lloh129
	.loh AdrpAdd	Lloh130, Lloh131
	.loh AdrpAdd	Lloh132, Lloh133
	.loh AdrpAdd	Lloh134, Lloh135
	.loh AdrpAdd	Lloh136, Lloh137
	.cfi_endproc
	.p2align	2
lJTI36_0:
	.long	LBB36_2-Ltmp0
	.long	LBB36_3-Ltmp0
	.long	LBB36_4-Ltmp0
	.long	LBB36_5-Ltmp0
	.long	LBB36_6-Ltmp0
	.long	LBB36_7-Ltmp0
	.long	LBB36_8-Ltmp0
	.long	LBB36_9-Ltmp0
	.long	LBB36_10-Ltmp0
	.long	LBB36_11-Ltmp0
	.long	LBB36_17-Ltmp0
	.long	LBB36_18-Ltmp0
	.long	LBB36_20-Ltmp0
	.long	LBB36_22-Ltmp0
	.long	LBB36_24-Ltmp0
	.long	LBB36_25-Ltmp0
	.long	LBB36_26-Ltmp0
	.long	LBB36_28-Ltmp0
	.long	LBB36_30-Ltmp0
	.p2align	2
lJTI36_1:
	.long	LBB36_29-Ltmp4
	.long	LBB36_41-Ltmp4
	.long	LBB36_42-Ltmp4
	.long	LBB36_43-Ltmp4
	.p2align	2
lJTI36_2:
	.long	LBB36_27-Ltmp3
	.long	LBB36_38-Ltmp3
	.long	LBB36_39-Ltmp3
	.long	LBB36_40-Ltmp3
	.p2align	2
lJTI36_3:
	.long	LBB36_23-Ltmp2
	.long	LBB36_35-Ltmp2
	.long	LBB36_36-Ltmp2
	.long	LBB36_37-Ltmp2
	.p2align	2
lJTI36_4:
	.long	LBB36_21-Ltmp1
	.long	LBB36_32-Ltmp1
	.long	LBB36_33-Ltmp1
	.long	LBB36_34-Ltmp1
                                        ; -- End function
	.globl	_exec_rrr_type                  ; -- Begin function exec_rrr_type
	.p2align	2
_exec_rrr_type:                         ; @exec_rrr_type
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
	sub	sp, sp, #1056
	mov	x21, x1
	mov	x19, x0
	mov	x20, x8
	ubfx	w8, w21, #2, #6
	cmp	w8, #18
	b.hi	LBB37_30
; %bb.1:
Lloh138:
	adrp	x9, lJTI37_0@PAGE
Lloh139:
	add	x9, x9, lJTI37_0@PAGEOFF
Ltmp5:
	adr	x10, Ltmp5
	ldrsw	x11, [x9, x8, lsl  #2]
	add	x10, x10, x11
	br	x10
LBB37_2:
	ubfx	x8, x21, #16, #8
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #24, #8
	ldr	x9, [x19, x9, lsl  #3]
	adds	x8, x9, x8
	b	LBB37_13
LBB37_3:
	ubfx	x8, x21, #16, #8
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #24, #8
	ldr	x9, [x19, x9, lsl  #3]
	subs	x8, x8, x9
	b	LBB37_13
LBB37_4:
	ubfx	x8, x21, #16, #8
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #24, #8
	ldr	x9, [x19, x9, lsl  #3]
	mul	x8, x9, x8
	b	LBB37_12
LBB37_5:
	ubfx	x8, x21, #16, #8
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #24, #8
	ldr	x9, [x19, x9, lsl  #3]
	cmp	x9, x8
	cset	w10, hi
	udiv	x8, x8, x9
	ldr	w9, [x19, #256]
	and	w9, w9, #0xfffffffc
	bfi	w9, w10, #1, #1
	str	w9, [x19, #256]
	b	LBB37_14
LBB37_6:
	ubfx	x8, x21, #16, #8
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #24, #8
	ldr	x9, [x19, x9, lsl  #3]
	udiv	x10, x8, x9
	msub	x8, x10, x9, x8
	b	LBB37_12
LBB37_7:
	ubfx	x8, x21, #16, #8
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #24, #8
	ldr	x9, [x19, x9, lsl  #3]
	ands	x8, x9, x8
	b	LBB37_13
LBB37_8:
	ubfx	x8, x21, #16, #8
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #24, #8
	ldr	x9, [x19, x9, lsl  #3]
	orr	x8, x9, x8
	b	LBB37_12
LBB37_9:
	ubfx	x8, x21, #16, #8
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #24, #8
	ldr	x9, [x19, x9, lsl  #3]
	eor	x8, x9, x8
	b	LBB37_12
LBB37_10:
	ubfx	x8, x21, #16, #8
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #24, #8
	ldr	x9, [x19, x9, lsl  #3]
	lsl	x8, x8, x9
	b	LBB37_12
LBB37_11:
	ubfx	x8, x21, #16, #8
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #24, #8
	ldr	x9, [x19, x9, lsl  #3]
	lsr	x8, x8, x9
LBB37_12:
	cmp	x8, #0
LBB37_13:
	cset	w9, eq
	ldr	w10, [x19, #256]
	and	w10, w10, #0xfffffffc
	bfi	w10, w9, #1, #1
	str	w10, [x19, #256]
LBB37_14:
	ubfx	x9, x21, #8, #8
	str	x8, [x19, x9, lsl  #3]
LBB37_15:
	ldr	x8, [x19, #248]
	add	x8, x8, #4
	str	x8, [x19, #248]
	mov	x0, x20
	mov	x1, x19
	mov	w2, #528
	bl	_memcpy
	add	sp, sp, #1056
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
LBB37_16:
	ubfx	x8, x21, #16, #8
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #24, #8
	ldr	x9, [x19, x9, lsl  #3]
	ubfx	x10, x21, #8, #8
	mov	w11, #64
	sub	x9, x11, x9
	; InlineAsm Start
	ror	x8, x8, x9
	; InlineAsm End
	cmp	x8, #0
	cset	w9, eq
	str	x8, [x19, x10, lsl  #3]
	ldr	w8, [x19, #256]
	and	w8, w8, #0xfffffffc
	bfi	w8, w9, #1, #1
	str	w8, [x19, #256]
	b	LBB37_15
LBB37_17:
	ubfx	x8, x21, #8, #8
	ubfx	x9, x21, #16, #8
	ldr	x9, [x19, x9, lsl  #3]
	ubfx	x10, x21, #24, #8
	ldr	x10, [x19, x10, lsl  #3]
	; InlineAsm Start
	ror	x9, x9, x10
	; InlineAsm End
	cmp	x9, #0
	cset	w10, eq
	str	x9, [x19, x8, lsl  #3]
	ldr	w8, [x19, #256]
	and	w8, w8, #0xfffffffc
	bfi	w8, w10, #1, #1
	str	w8, [x19, #256]
	b	LBB37_15
LBB37_18:
	lsr	x9, x21, #8
	lsl	w8, w9, #8
	ubfx	w9, w9, #1, #2
Lloh140:
	adrp	x10, lJTI37_4@PAGE
Lloh141:
	add	x10, x10, lJTI37_4@PAGEOFF
Ltmp6:
	adr	x11, Ltmp6
	ldrsw	x12, [x10, x9, lsl  #2]
	add	x11, x11, x12
	br	x11
LBB37_19:
	ubfx	x9, x21, #16, #8
	ldr	x9, [x19, x9, lsl  #3]
	ubfx	x10, x21, #24, #8
	ldr	x10, [x19, x10, lsl  #3]
	ldr	x9, [x10, x9]
	cmp	x9, #0
	cset	w10, eq
	ldr	w11, [x19, #256]
	and	w11, w11, #0xfffffffc
	bfi	w11, w10, #1, #1
	lsr	x10, x9, #63
	orr	w10, w11, w10
	str	w10, [x19, #256]
	ubfx	w8, w8, #11, #5
	str	x9, [x19, w8, uxtw  #3]
	b	LBB37_15
LBB37_20:
	lsr	x9, x21, #8
	lsl	w8, w9, #8
	ubfx	w9, w9, #1, #2
Lloh142:
	adrp	x10, lJTI37_3@PAGE
Lloh143:
	add	x10, x10, lJTI37_3@PAGEOFF
Ltmp7:
	adr	x11, Ltmp7
	ldrsw	x12, [x10, x9, lsl  #2]
	add	x11, x11, x12
	br	x11
LBB37_21:
	ubfx	w8, w8, #11, #5
	ldr	x8, [x19, w8, uxtw  #3]
	cmp	x8, #0
	cset	w9, eq
	ldr	w10, [x19, #256]
	and	w10, w10, #0xfffffffc
	bfi	w10, w9, #1, #1
	lsr	x9, x8, #63
	orr	w9, w10, w9
	str	w9, [x19, #256]
	ubfx	x9, x21, #16, #8
	ldr	x9, [x19, x9, lsl  #3]
	ubfx	x10, x21, #24, #8
	ldr	x10, [x19, x10, lsl  #3]
	str	x8, [x10, x9]
	b	LBB37_15
LBB37_22:
	ubfx	x8, x21, #8, #8
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #16, #8
	ldr	x9, [x19, x9, lsl  #3]
	tst	x9, x8
	b	LBB37_24
LBB37_23:
	ubfx	x8, x21, #8, #8
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x21, #16, #8
	ldr	x9, [x19, x9, lsl  #3]
	cmp	x8, x9
LBB37_24:
	cset	w8, eq
	ldr	w9, [x19, #256]
	and	w9, w9, #0xfffffffc
	bfi	w9, w8, #1, #1
	str	w9, [x19, #256]
	b	LBB37_15
LBB37_25:
	lsr	x10, x21, #24
	lsl	w8, w10, #24
	and	w9, w21, #0xffff0000
	ubfx	w10, w10, #1, #2
Lloh144:
	adrp	x11, lJTI37_2@PAGE
Lloh145:
	add	x11, x11, lJTI37_2@PAGEOFF
Ltmp8:
	adr	x12, Ltmp8
	ldrsw	x13, [x11, x10, lsl  #2]
	add	x12, x12, x13
	br	x12
LBB37_26:
	ubfx	w10, w9, #19, #5
	ubfiz	x10, x10, #3, #32
	ldr	x11, [x19, x10]
	lsr	w8, w8, #27
	ubfiz	x8, x8, #3, #32
	ldr	x12, [x19, x8]
	ldr	x11, [x12, x11]
	lsr	x12, x21, #8
	lsl	w12, w12, #8
	and	w12, w12, #0xe000
	ubfx	x13, x21, #8, #5
	str	x11, [x19, x13, lsl  #3]
	ldr	x10, [x19, x10]
	ldr	x8, [x19, x8]
	orr	w9, w12, w9
	add	x8, x10, x8
	ldr	x8, [x8, #8]
	ubfx	w9, w9, #13, #5
	str	x8, [x19, w9, uxtw  #3]
	b	LBB37_15
LBB37_27:
	lsr	x11, x21, #24
	lsl	w9, w11, #24
	and	w10, w21, #0xffff0000
	and	w8, w21, #0xffff00
	ubfx	w11, w11, #1, #2
Lloh146:
	adrp	x12, lJTI37_1@PAGE
Lloh147:
	add	x12, x12, lJTI37_1@PAGEOFF
Ltmp9:
	adr	x13, Ltmp9
	ldrsw	x14, [x12, x11, lsl  #2]
	add	x13, x13, x14
	br	x13
LBB37_28:
	ubfx	x11, x21, #8, #5
	ldr	x11, [x19, x11, lsl  #3]
	ubfx	w10, w10, #19, #5
	ubfiz	x10, x10, #3, #32
	ldr	x12, [x19, x10]
	lsr	w9, w9, #27
	ubfiz	x9, x9, #3, #32
	ldr	x13, [x19, x9]
	str	x11, [x13, x12]
	ubfx	w8, w8, #13, #5
	ldr	x8, [x19, w8, uxtw  #3]
	ldr	x10, [x19, x10]
	ldr	x9, [x19, x9]
	add	x9, x10, x9
	str	x8, [x9, #8]
	b	LBB37_15
LBB37_29:
	mov	x0, sp
	mov	x1, x19
	mov	w2, #528
	bl	_memcpy
	and	x1, x21, #0xffffffff
	add	x8, sp, #528
	mov	x0, sp
	bl	_exec_fpu_type
	add	x1, sp, #528
	mov	x0, x19
	mov	w2, #528
	bl	_memcpy
	b	LBB37_15
LBB37_30:
	mov	w0, #4
	bl	_raise
	b	LBB37_15
LBB37_31:
	ubfx	x9, x21, #16, #8
	ldr	x9, [x19, x9, lsl  #3]
	ubfx	x10, x21, #24, #8
	ldr	x10, [x19, x10, lsl  #3]
	ldr	w9, [x10, x9]
	cmp	w9, #0
	cset	w10, eq
	ldr	w11, [x19, #256]
	and	w11, w11, #0xfffffffc
	extr	w10, w10, w9, #31
	orr	w10, w10, w11
	str	w10, [x19, #256]
	ubfx	w8, w8, #11, #5
	ubfiz	x8, x8, #3, #32
	str	w9, [x19, x8]
	b	LBB37_15
LBB37_32:
	ubfx	x9, x21, #16, #8
	ldr	x9, [x19, x9, lsl  #3]
	ubfx	x10, x21, #24, #8
	ldr	x10, [x19, x10, lsl  #3]
	ldrh	w9, [x10, x9]
	cmp	w9, #0
	cset	w10, eq
	ldr	w11, [x19, #256]
	and	w11, w11, #0xfffffffc
	bfi	w11, w10, #1, #1
	orr	w10, w11, w9, lsr #15
	str	w10, [x19, #256]
	ubfx	w8, w8, #11, #5
	ubfiz	x8, x8, #3, #32
	strh	w9, [x19, x8]
	b	LBB37_15
LBB37_33:
	ubfx	x9, x21, #16, #8
	ldr	x9, [x19, x9, lsl  #3]
	ubfx	x10, x21, #24, #8
	ldr	x10, [x19, x10, lsl  #3]
	ldrb	w9, [x10, x9]
	cmp	w9, #0
	cset	w10, eq
	ldr	w11, [x19, #256]
	and	w11, w11, #0xfffffffc
	bfi	w11, w10, #1, #1
	orr	w10, w11, w9, lsr #7
	str	w10, [x19, #256]
	ubfx	w8, w8, #11, #5
	ubfiz	x8, x8, #3, #32
	strb	w9, [x19, x8]
	b	LBB37_15
LBB37_34:
	ubfx	w8, w8, #11, #5
	ubfiz	x8, x8, #3, #32
	ldr	w8, [x19, x8]
	cmp	w8, #0
	cset	w9, eq
	ldr	w10, [x19, #256]
	extr	w9, w9, w8, #31
	and	w10, w10, #0xfffffffc
	orr	w9, w9, w10
	str	w9, [x19, #256]
	ubfx	x9, x21, #16, #8
	ldr	x9, [x19, x9, lsl  #3]
	ubfx	x10, x21, #24, #8
	ldr	x10, [x19, x10, lsl  #3]
	str	w8, [x10, x9]
	b	LBB37_15
LBB37_35:
	ubfx	w8, w8, #11, #5
	ubfiz	x8, x8, #3, #32
	ldrh	w8, [x19, x8]
	cmp	w8, #0
	cset	w9, eq
	ldr	w10, [x19, #256]
	and	w10, w10, #0xfffffffc
	bfi	w10, w9, #1, #1
	orr	w9, w10, w8, lsr #15
	str	w9, [x19, #256]
	ubfx	x9, x21, #16, #8
	ldr	x9, [x19, x9, lsl  #3]
	ubfx	x10, x21, #24, #8
	ldr	x10, [x19, x10, lsl  #3]
	strh	w8, [x10, x9]
	b	LBB37_15
LBB37_36:
	ubfx	w8, w8, #11, #5
	ubfiz	x8, x8, #3, #32
	ldrb	w8, [x19, x8]
	cmp	w8, #0
	cset	w9, eq
	ldr	w10, [x19, #256]
	and	w10, w10, #0xfffffffc
	bfi	w10, w9, #1, #1
	orr	w9, w10, w8, lsr #7
	str	w9, [x19, #256]
	ubfx	x9, x21, #16, #8
	ldr	x9, [x19, x9, lsl  #3]
	ubfx	x10, x21, #24, #8
	ldr	x10, [x19, x10, lsl  #3]
	strb	w8, [x10, x9]
	b	LBB37_15
LBB37_37:
	ubfx	w9, w9, #19, #5
	ubfiz	x9, x9, #3, #32
	ldr	x10, [x19, x9]
	lsr	w8, w8, #27
	ubfiz	x8, x8, #3, #32
	ldr	x11, [x19, x8]
	ldr	w10, [x11, x10]
	ubfx	x11, x21, #8, #5
	lsl	x11, x11, #3
	str	w10, [x19, x11]
	ldr	x9, [x19, x9]
	ldr	x8, [x19, x8]
	add	x8, x9, x8
	ldr	w8, [x8, #4]
	str	w8, [x19, x11]
	b	LBB37_15
LBB37_38:
	ubfx	w9, w9, #19, #5
	ubfiz	x9, x9, #3, #32
	ldr	x10, [x19, x9]
	lsr	w8, w8, #27
	ubfiz	x8, x8, #3, #32
	ldr	x11, [x19, x8]
	ldrh	w10, [x11, x10]
	ubfx	x11, x21, #8, #5
	lsl	x11, x11, #3
	strh	w10, [x19, x11]
	ldr	x9, [x19, x9]
	ldr	x8, [x19, x8]
	add	x8, x9, x8
	ldrh	w8, [x8, #2]
	strh	w8, [x19, x11]
	b	LBB37_15
LBB37_39:
	ubfx	w9, w9, #19, #5
	ubfiz	x9, x9, #3, #32
	ldr	x10, [x19, x9]
	lsr	w8, w8, #27
	ubfiz	x8, x8, #3, #32
	ldr	x11, [x19, x8]
	ldrb	w10, [x11, x10]
	ubfx	x11, x21, #8, #5
	lsl	x11, x11, #3
	strb	w10, [x19, x11]
	ldr	x9, [x19, x9]
	ldr	x8, [x19, x8]
	add	x8, x9, x8
	ldrb	w8, [x8, #1]
	strb	w8, [x19, x11]
	b	LBB37_15
LBB37_40:
	ubfx	x11, x21, #8, #5
	lsl	x11, x11, #3
	ldr	w11, [x19, x11]
	ubfx	w10, w10, #19, #5
	ubfiz	x10, x10, #3, #32
	ldr	x12, [x19, x10]
	lsr	w9, w9, #27
	ubfiz	x9, x9, #3, #32
	ldr	x13, [x19, x9]
	str	w11, [x13, x12]
	ubfx	w8, w8, #13, #5
	ubfiz	x8, x8, #3, #32
	ldr	w8, [x19, x8]
	ldr	x10, [x19, x10]
	ldr	x9, [x19, x9]
	add	x9, x10, x9
	str	w8, [x9, #4]
	b	LBB37_15
LBB37_41:
	ubfx	x11, x21, #8, #5
	lsl	x11, x11, #3
	ldrh	w11, [x19, x11]
	ubfx	w10, w10, #19, #5
	ubfiz	x10, x10, #3, #32
	ldr	x12, [x19, x10]
	lsr	w9, w9, #27
	ubfiz	x9, x9, #3, #32
	ldr	x13, [x19, x9]
	strh	w11, [x13, x12]
	ubfx	w8, w8, #13, #5
	ubfiz	x8, x8, #3, #32
	ldrh	w8, [x19, x8]
	ldr	x10, [x19, x10]
	ldr	x9, [x19, x9]
	add	x9, x10, x9
	strh	w8, [x9, #2]
	b	LBB37_15
LBB37_42:
	ubfx	x11, x21, #8, #5
	lsl	x11, x11, #3
	ldrb	w11, [x19, x11]
	ubfx	w10, w10, #19, #5
	ubfiz	x10, x10, #3, #32
	ldr	x12, [x19, x10]
	lsr	w9, w9, #27
	ubfiz	x9, x9, #3, #32
	ldr	x13, [x19, x9]
	strb	w11, [x13, x12]
	ubfx	w8, w8, #13, #5
	ubfiz	x8, x8, #3, #32
	ldrb	w8, [x19, x8]
	ldr	x10, [x19, x10]
	ldr	x9, [x19, x9]
	add	x9, x10, x9
	strb	w8, [x9, #1]
	b	LBB37_15
	.loh AdrpAdd	Lloh138, Lloh139
	.loh AdrpAdd	Lloh140, Lloh141
	.loh AdrpAdd	Lloh142, Lloh143
	.loh AdrpAdd	Lloh144, Lloh145
	.loh AdrpAdd	Lloh146, Lloh147
	.cfi_endproc
	.p2align	2
lJTI37_0:
	.long	LBB37_2-Ltmp5
	.long	LBB37_3-Ltmp5
	.long	LBB37_4-Ltmp5
	.long	LBB37_5-Ltmp5
	.long	LBB37_6-Ltmp5
	.long	LBB37_7-Ltmp5
	.long	LBB37_8-Ltmp5
	.long	LBB37_9-Ltmp5
	.long	LBB37_10-Ltmp5
	.long	LBB37_11-Ltmp5
	.long	LBB37_16-Ltmp5
	.long	LBB37_17-Ltmp5
	.long	LBB37_18-Ltmp5
	.long	LBB37_20-Ltmp5
	.long	LBB37_22-Ltmp5
	.long	LBB37_23-Ltmp5
	.long	LBB37_25-Ltmp5
	.long	LBB37_27-Ltmp5
	.long	LBB37_29-Ltmp5
	.p2align	2
lJTI37_1:
	.long	LBB37_28-Ltmp9
	.long	LBB37_40-Ltmp9
	.long	LBB37_41-Ltmp9
	.long	LBB37_42-Ltmp9
	.p2align	2
lJTI37_2:
	.long	LBB37_26-Ltmp8
	.long	LBB37_37-Ltmp8
	.long	LBB37_38-Ltmp8
	.long	LBB37_39-Ltmp8
	.p2align	2
lJTI37_3:
	.long	LBB37_21-Ltmp7
	.long	LBB37_34-Ltmp7
	.long	LBB37_35-Ltmp7
	.long	LBB37_36-Ltmp7
	.p2align	2
lJTI37_4:
	.long	LBB37_19-Ltmp6
	.long	LBB37_31-Ltmp6
	.long	LBB37_32-Ltmp6
	.long	LBB37_33-Ltmp6
                                        ; -- End function
	.globl	_exec_ri_type                   ; -- Begin function exec_ri_type
	.p2align	2
_exec_ri_type:                          ; @exec_ri_type
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
	sub	sp, sp, #496
	mov	x19, x0
	mov	x20, x8
Lloh148:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh149:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh150:
	ldr	x8, [x8]
	stur	x8, [x29, #-96]
	ubfx	w8, w1, #2, #5
	cmp	w8, #20
	b.hi	LBB38_3
; %bb.1:
Lloh151:
	adrp	x9, lJTI38_0@PAGE
Lloh152:
	add	x9, x9, lJTI38_0@PAGEOFF
	adr	x10, LBB38_2
	ldrb	w11, [x9, x8]
	add	x10, x10, x11, lsl #2
	br	x10
LBB38_2:
	ubfx	x8, x1, #27, #5
	ldr	x8, [x19, x8, lsl  #3]
	cmp	x8, #0
	cset	w9, eq
	ldr	w10, [x19, #256]
	and	w10, w10, #0xfffffffc
	bfi	w10, w9, #1, #1
	str	w10, [x19, #256]
	cbnz	x8, LBB38_26
	b	LBB38_5
LBB38_3:
	mov	w0, #4
	bl	_raise
	b	LBB38_26
LBB38_4:
	ubfx	x8, x1, #27, #5
	ldr	x8, [x19, x8, lsl  #3]
	cmp	x8, #0
	cset	w9, eq
	ldr	w10, [x19, #256]
	and	w10, w10, #0xfffffffc
	bfi	w10, w9, #1, #1
	str	w10, [x19, #256]
	cbz	x8, LBB38_26
LBB38_5:
	ldr	x8, [x19, #248]
	asr	w9, w1, #7
	add	x8, x8, w9, sxtw #2
	b	LBB38_27
LBB38_6:
	ldr	x8, [x19, #248]
	asr	w9, w1, #12
	add	x8, x8, w9, sxtw #2
	ubfx	x9, x1, #27, #5
	str	x8, [x19, x9, lsl  #3]
	b	LBB38_26
LBB38_7:
	lsr	x8, x1, #5
	and	x8, x8, #0x30
	mov	x9, #-65536
	lsl	x9, x9, x8
	ubfx	x10, x1, #16, #16
	lsl	x8, x10, x8
	ubfx	x10, x1, #11, #5
	lsl	x10, x10, #3
	ldr	x11, [x19, x10]
	lsl	x12, x1, #55
	and	x9, x9, x12, asr #63
	and	x9, x11, x9
	orr	x8, x9, x8
	cmp	x8, #0
	cset	w9, eq
	str	x8, [x19, x10]
	ldr	w8, [x19, #256]
	and	w8, w8, #0xfffffffc
	bfi	w8, w9, #1, #1
	str	w8, [x19, #256]
	b	LBB38_26
LBB38_8:
	ldrb	w8, [x19, #256]
	tbnz	w8, #0, LBB38_21
	b	LBB38_26
LBB38_9:
	ldrb	w8, [x19, #256]
	tst	w8, #0x3
	b.ne	LBB38_26
	b	LBB38_21
LBB38_10:
	ldrb	w8, [x19, #256]
	tbz	w8, #0, LBB38_21
	b	LBB38_26
LBB38_11:
	ldrb	w8, [x19, #256]
	tst	w8, #0x3
	b.ne	LBB38_21
	b	LBB38_26
LBB38_12:
	ldrb	w8, [x19, #256]
	tbnz	w8, #1, LBB38_21
	b	LBB38_26
LBB38_13:
	ldrb	w8, [x19, #256]
	tbz	w8, #1, LBB38_21
	b	LBB38_26
LBB38_14:
	ldrb	w8, [x19, #256]
	tbnz	w8, #0, LBB38_20
	b	LBB38_26
LBB38_15:
	ldrb	w8, [x19, #256]
	tst	w8, #0x3
	b.ne	LBB38_26
	b	LBB38_20
LBB38_16:
	ldrb	w8, [x19, #256]
	tbz	w8, #0, LBB38_20
	b	LBB38_26
LBB38_17:
	ldrb	w8, [x19, #256]
	tst	w8, #0x3
	b.ne	LBB38_20
	b	LBB38_26
LBB38_18:
	ldrb	w8, [x19, #256]
	tbnz	w8, #1, LBB38_20
	b	LBB38_26
LBB38_19:
	ldrb	w8, [x19, #256]
	tbnz	w8, #1, LBB38_26
LBB38_20:
	ldr	x8, [x19, #248]
	str	x8, [x19, #232]
LBB38_21:
	ubfx	x8, x1, #27, #5
	ldr	x8, [x19, x8, lsl  #3]
	b	LBB38_27
LBB38_22:
	ubfx	x8, x1, #27, #5
	ldr	x8, [x19, x8, lsl  #3]
	and	w8, w8, w1, lsr #7
	tst	x8, #0xfffff
	b	LBB38_24
LBB38_23:
	ubfx	x8, x1, #27, #5
	ldr	x8, [x19, x8, lsl  #3]
	ubfx	x9, x1, #7, #20
	cmp	x8, x9
LBB38_24:
	cset	w8, eq
	ldr	w9, [x19, #256]
	and	w9, w9, #0xfffffffc
	bfi	w9, w8, #1, #1
	str	w9, [x19, #256]
	b	LBB38_26
LBB38_25:
	ldp	x8, x22, [x19]
	ldp	x23, x24, [x19, #16]
	ldp	x25, x26, [x19, #32]
	ldp	x27, x28, [x19, #48]
	add	x1, x19, #72
	stp	x8, x1, [sp, #8]                ; 16-byte Folded Spill
	ldr	x21, [x19, #64]
	add	x0, sp, #24
	mov	w2, #456
	bl	_memcpy
Lloh153:
	adrp	x8, _svcs@PAGE
Lloh154:
	add	x8, x8, _svcs@PAGEOFF
	ldr	x8, [x8, x21, lsl  #3]
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	mov	x1, x22
	mov	x2, x23
	mov	x3, x24
	mov	x4, x25
	mov	x5, x26
	mov	x6, x27
	mov	x7, x28
	blr	x8
	stp	x0, x22, [x19]
	stp	x23, x24, [x19, #16]
	stp	x25, x26, [x19, #32]
	stp	x27, x28, [x19, #48]
	str	x21, [x19, #64]
	add	x1, sp, #24
	ldr	x0, [sp, #16]                   ; 8-byte Folded Reload
	mov	w2, #456
	bl	_memcpy
LBB38_26:
	ldr	x8, [x19, #248]
	add	x8, x8, #4
LBB38_27:
	str	x8, [x19, #248]
	ldur	x8, [x29, #-96]
Lloh155:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh156:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh157:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB38_29
; %bb.28:
	mov	x0, x20
	mov	x1, x19
	mov	w2, #528
	add	sp, sp, #496
	ldp	x29, x30, [sp, #80]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #64]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #48]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #32]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #16]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp], #96             ; 16-byte Folded Reload
	b	_memcpy
LBB38_29:
	bl	___stack_chk_fail
	.loh AdrpLdrGotLdr	Lloh148, Lloh149, Lloh150
	.loh AdrpAdd	Lloh151, Lloh152
	.loh AdrpAdd	Lloh153, Lloh154
	.loh AdrpLdrGotLdr	Lloh155, Lloh156, Lloh157
	.cfi_endproc
	.section	__TEXT,__const
lJTI38_0:
	.byte	(LBB38_2-LBB38_2)>>2
	.byte	(LBB38_4-LBB38_2)>>2
	.byte	(LBB38_6-LBB38_2)>>2
	.byte	(LBB38_7-LBB38_2)>>2
	.byte	(LBB38_21-LBB38_2)>>2
	.byte	(LBB38_20-LBB38_2)>>2
	.byte	(LBB38_8-LBB38_2)>>2
	.byte	(LBB38_9-LBB38_2)>>2
	.byte	(LBB38_10-LBB38_2)>>2
	.byte	(LBB38_11-LBB38_2)>>2
	.byte	(LBB38_12-LBB38_2)>>2
	.byte	(LBB38_13-LBB38_2)>>2
	.byte	(LBB38_14-LBB38_2)>>2
	.byte	(LBB38_15-LBB38_2)>>2
	.byte	(LBB38_16-LBB38_2)>>2
	.byte	(LBB38_17-LBB38_2)>>2
	.byte	(LBB38_18-LBB38_2)>>2
	.byte	(LBB38_19-LBB38_2)>>2
	.byte	(LBB38_22-LBB38_2)>>2
	.byte	(LBB38_23-LBB38_2)>>2
	.byte	(LBB38_25-LBB38_2)>>2
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_strformat                      ; -- Begin function strformat
	.p2align	2
_strformat:                             ; @strformat
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #64
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
	mov	x19, x0
	add	x8, x29, #16
	str	x8, [sp, #8]
	add	x3, x29, #16
	mov	x0, #0
	mov	x1, #0
	mov	x2, x19
	bl	_vsnprintf
	mov	x20, #0
	adds	w8, w0, #1
	b.hs	LBB39_2
; %bb.1:
	sxtw	x21, w8
	mov	x0, x21
	bl	_malloc
	mov	x20, x0
	ldr	x3, [sp, #8]
	mov	x1, x21
	mov	x2, x19
	bl	_vsnprintf
LBB39_2:
	mov	x0, x20
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_str_data_type                  ; -- Begin function str_data_type
	.p2align	2
_str_data_type:                         ; @str_data_type
	.cfi_startproc
; %bb.0:
	ubfx	w8, w0, #2, #5
	cmp	w8, #13
	b.hi	LBB40_2
; %bb.1:
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh158:
	adrp	x9, l_switch.table.dis@PAGE
Lloh159:
	add	x9, x9, l_switch.table.dis@PAGEOFF
	ldr	x8, [x9, w8, uxtw  #3]
	asr	w9, w0, #7
	str	x9, [sp]
	mov	x0, x8
	bl	_strformat
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
LBB40_2:
	mov	x0, #0
	ret
	.loh AdrpAdd	Lloh158, Lloh159
	.cfi_endproc
                                        ; -- End function
	.globl	_str_rri_type                   ; -- Begin function str_rri_type
	.p2align	2
_str_rri_type:                          ; @str_rri_type
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ubfx	w8, w0, #2, #5
	cmp	w8, #17
	b.hi	LBB41_3
; %bb.1:
Lloh160:
	adrp	x9, lJTI41_0@PAGE
Lloh161:
	add	x9, x9, lJTI41_0@PAGEOFF
	adr	x10, LBB41_2
	ldrb	w11, [x9, x8]
	add	x10, x10, x11, lsl #2
	br	x10
LBB41_2:
	ubfx	w8, w0, #22, #5
	lsr	w9, w0, #27
	ubfx	w10, w0, #7, #15
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh162:
	adrp	x0, l_.str.72@PAGE
Lloh163:
	add	x0, x0, l_.str.72@PAGEOFF
	b	LBB41_57
LBB41_3:
	mov	x0, #0
	b	LBB41_58
LBB41_4:
	ubfx	w8, w0, #22, #5
	lsr	w9, w0, #27
	ubfx	w10, w0, #7, #15
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh164:
	adrp	x0, l_.str.73@PAGE
Lloh165:
	add	x0, x0, l_.str.73@PAGEOFF
	b	LBB41_57
LBB41_5:
	ubfx	w8, w0, #22, #5
	lsr	w9, w0, #27
	ubfx	w10, w0, #7, #15
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh166:
	adrp	x0, l_.str.74@PAGE
Lloh167:
	add	x0, x0, l_.str.74@PAGEOFF
	b	LBB41_57
LBB41_6:
	ubfx	w8, w0, #22, #5
	lsr	w9, w0, #27
	ubfx	w10, w0, #7, #15
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh168:
	adrp	x0, l_.str.75@PAGE
Lloh169:
	add	x0, x0, l_.str.75@PAGEOFF
	b	LBB41_57
LBB41_7:
	ubfx	w8, w0, #22, #5
	lsr	w9, w0, #27
	ubfx	w10, w0, #7, #15
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh170:
	adrp	x0, l_.str.76@PAGE
Lloh171:
	add	x0, x0, l_.str.76@PAGEOFF
	b	LBB41_57
LBB41_8:
	ubfx	w8, w0, #22, #5
	lsr	w9, w0, #27
	ubfx	w10, w0, #7, #15
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh172:
	adrp	x0, l_.str.77@PAGE
Lloh173:
	add	x0, x0, l_.str.77@PAGEOFF
	b	LBB41_57
LBB41_9:
	ubfx	w8, w0, #22, #5
	lsr	w9, w0, #27
	ubfx	w10, w0, #7, #15
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh174:
	adrp	x0, l_.str.78@PAGE
Lloh175:
	add	x0, x0, l_.str.78@PAGEOFF
	b	LBB41_57
LBB41_10:
	ubfx	w8, w0, #22, #5
	lsr	w9, w0, #27
	ubfx	w10, w0, #7, #15
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh176:
	adrp	x0, l_.str.79@PAGE
Lloh177:
	add	x0, x0, l_.str.79@PAGEOFF
	b	LBB41_57
LBB41_11:
	ubfx	w8, w0, #22, #5
	lsr	w9, w0, #27
	and	x10, x0, #0x3fff80
	cmp	w8, w9
	b.ne	LBB41_13
; %bb.12:
	cbz	x10, LBB41_20
LBB41_13:
	cmp	w8, #31
	b.ne	LBB41_16
; %bb.14:
	cmp	w9, #29
	b.ne	LBB41_16
; %bb.15:
	cbz	x10, LBB41_38
LBB41_16:
	ubfx	w10, w0, #7, #15
	cbz	w10, LBB41_56
; %bb.17:
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh178:
	adrp	x0, l_.str.83@PAGE
Lloh179:
	add	x0, x0, l_.str.83@PAGEOFF
	b	LBB41_57
LBB41_18:
	ubfx	w8, w0, #22, #5
	lsr	w9, w0, #27
	and	x10, x0, #0x3fff80
	cmp	w8, w9
	b.ne	LBB41_35
; %bb.19:
	cbnz	x10, LBB41_35
LBB41_20:
Lloh180:
	adrp	x0, l_.str.80@PAGE
Lloh181:
	add	x0, x0, l_.str.80@PAGEOFF
	b	LBB41_39
LBB41_21:
	ubfx	w8, w0, #22, #5
	lsr	w9, w0, #27
	ubfx	w10, w0, #7, #15
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh182:
	adrp	x0, l_.str.85@PAGE
Lloh183:
	add	x0, x0, l_.str.85@PAGEOFF
	b	LBB41_57
LBB41_22:
	ubfx	w8, w0, #22, #5
	lsr	w9, w0, #27
	ubfx	w10, w0, #7, #15
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh184:
	adrp	x0, l_.str.86@PAGE
Lloh185:
	add	x0, x0, l_.str.86@PAGEOFF
	b	LBB41_57
LBB41_23:
	ubfx	w8, w0, #17, #2
Lloh186:
	adrp	x9, lJTI41_4@PAGE
Lloh187:
	add	x9, x9, lJTI41_4@PAGEOFF
	adr	x10, LBB41_24
	ldrb	w11, [x9, x8]
	add	x10, x10, x11, lsl #2
	br	x10
LBB41_24:
	ubfx	w8, w0, #7, #5
	ubfx	w9, w0, #12, #5
	asr	w10, w0, #19
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh188:
	adrp	x0, l_.str.87@PAGE
Lloh189:
	add	x0, x0, l_.str.87@PAGEOFF
	b	LBB41_57
LBB41_25:
	ubfx	w8, w0, #17, #2
Lloh190:
	adrp	x9, lJTI41_3@PAGE
Lloh191:
	add	x9, x9, lJTI41_3@PAGEOFF
	adr	x10, LBB41_26
	ldrb	w11, [x9, x8]
	add	x10, x10, x11, lsl #2
	br	x10
LBB41_26:
	ubfx	w8, w0, #7, #5
	ubfx	w9, w0, #12, #5
	asr	w10, w0, #19
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh192:
	adrp	x0, l_.str.91@PAGE
Lloh193:
	add	x0, x0, l_.str.91@PAGEOFF
	b	LBB41_57
LBB41_27:
	ubfx	w8, w0, #22, #5
	lsr	w9, w0, #27
	lsr	w10, w0, #26
	ubfx	w11, w0, #18, #6
	tbnz	w0, #12, LBB41_40
; %bb.28:
	stp	x10, x11, [sp, #16]
	stp	x8, x9, [sp]
Lloh194:
	adrp	x0, l_.str.96@PAGE
Lloh195:
	add	x0, x0, l_.str.96@PAGEOFF
	b	LBB41_57
LBB41_29:
	ubfx	w8, w0, #22, #5
	lsr	w9, w0, #27
	lsr	w10, w0, #26
	ubfx	w11, w0, #18, #6
	tbnz	w0, #12, LBB41_41
; %bb.30:
	stp	x10, x11, [sp, #16]
	stp	x8, x9, [sp]
Lloh196:
	adrp	x0, l_.str.98@PAGE
Lloh197:
	add	x0, x0, l_.str.98@PAGEOFF
	b	LBB41_57
LBB41_31:
	ubfx	w8, w0, #7, #2
Lloh198:
	adrp	x9, lJTI41_2@PAGE
Lloh199:
	add	x9, x9, lJTI41_2@PAGEOFF
	adr	x10, LBB41_32
	ldrb	w11, [x9, x8]
	add	x10, x10, x11, lsl #2
	br	x10
LBB41_32:
	ubfx	w8, w0, #9, #5
	ubfx	w9, w0, #14, #5
	ubfx	w10, w0, #19, #5
	lsr	w11, w0, #24
	stp	x10, x11, [sp, #16]
	stp	x8, x9, [sp]
Lloh200:
	adrp	x0, l_.str.99@PAGE
Lloh201:
	add	x0, x0, l_.str.99@PAGEOFF
	b	LBB41_57
LBB41_33:
	ubfx	w8, w0, #7, #2
Lloh202:
	adrp	x9, lJTI41_1@PAGE
Lloh203:
	add	x9, x9, lJTI41_1@PAGEOFF
	adr	x10, LBB41_34
	ldrb	w11, [x9, x8]
	add	x10, x10, x11, lsl #2
	br	x10
LBB41_34:
	ubfx	w8, w0, #9, #5
	ubfx	w9, w0, #14, #5
	ubfx	w10, w0, #19, #5
	lsr	w11, w0, #24
	stp	x10, x11, [sp, #16]
	stp	x8, x9, [sp]
Lloh204:
	adrp	x0, l_.str.103@PAGE
Lloh205:
	add	x0, x0, l_.str.103@PAGEOFF
	b	LBB41_57
LBB41_35:
	cmp	w8, #31
	b.ne	LBB41_54
; %bb.36:
	cmp	w9, #29
	b.ne	LBB41_54
; %bb.37:
	cbnz	x10, LBB41_54
LBB41_38:
Lloh206:
	adrp	x0, l_.str.81@PAGE
Lloh207:
	add	x0, x0, l_.str.81@PAGEOFF
LBB41_39:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	b	_strformat
LBB41_40:
	stp	x10, x11, [sp, #16]
	stp	x8, x9, [sp]
Lloh208:
	adrp	x0, l_.str.95@PAGE
Lloh209:
	add	x0, x0, l_.str.95@PAGEOFF
	b	LBB41_57
LBB41_41:
	stp	x10, x11, [sp, #16]
	stp	x8, x9, [sp]
Lloh210:
	adrp	x0, l_.str.97@PAGE
Lloh211:
	add	x0, x0, l_.str.97@PAGEOFF
	b	LBB41_57
LBB41_42:
	ubfx	w8, w0, #7, #5
	ubfx	w9, w0, #12, #5
	asr	w10, w0, #19
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh212:
	adrp	x0, l_.str.88@PAGE
Lloh213:
	add	x0, x0, l_.str.88@PAGEOFF
	b	LBB41_57
LBB41_43:
	ubfx	w8, w0, #7, #5
	ubfx	w9, w0, #12, #5
	asr	w10, w0, #19
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh214:
	adrp	x0, l_.str.89@PAGE
Lloh215:
	add	x0, x0, l_.str.89@PAGEOFF
	b	LBB41_57
LBB41_44:
	ubfx	w8, w0, #7, #5
	ubfx	w9, w0, #12, #5
	asr	w10, w0, #19
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh216:
	adrp	x0, l_.str.90@PAGE
Lloh217:
	add	x0, x0, l_.str.90@PAGEOFF
	b	LBB41_57
LBB41_45:
	ubfx	w8, w0, #7, #5
	ubfx	w9, w0, #12, #5
	asr	w10, w0, #19
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh218:
	adrp	x0, l_.str.92@PAGE
Lloh219:
	add	x0, x0, l_.str.92@PAGEOFF
	b	LBB41_57
LBB41_46:
	ubfx	w8, w0, #7, #5
	ubfx	w9, w0, #12, #5
	asr	w10, w0, #19
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh220:
	adrp	x0, l_.str.93@PAGE
Lloh221:
	add	x0, x0, l_.str.93@PAGEOFF
	b	LBB41_57
LBB41_47:
	ubfx	w8, w0, #7, #5
	ubfx	w9, w0, #12, #5
	asr	w10, w0, #19
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh222:
	adrp	x0, l_.str.94@PAGE
Lloh223:
	add	x0, x0, l_.str.94@PAGEOFF
	b	LBB41_57
LBB41_48:
	ubfx	w8, w0, #9, #5
	ubfx	w9, w0, #14, #5
	ubfx	w10, w0, #19, #5
	lsr	w11, w0, #24
	stp	x10, x11, [sp, #16]
	stp	x8, x9, [sp]
Lloh224:
	adrp	x0, l_.str.100@PAGE
Lloh225:
	add	x0, x0, l_.str.100@PAGEOFF
	b	LBB41_57
LBB41_49:
	ubfx	w8, w0, #9, #5
	ubfx	w9, w0, #14, #5
	ubfx	w10, w0, #19, #5
	lsr	w11, w0, #24
	stp	x10, x11, [sp, #16]
	stp	x8, x9, [sp]
Lloh226:
	adrp	x0, l_.str.101@PAGE
Lloh227:
	add	x0, x0, l_.str.101@PAGEOFF
	b	LBB41_57
LBB41_50:
	ubfx	w8, w0, #9, #5
	ubfx	w9, w0, #14, #5
	ubfx	w10, w0, #19, #5
	lsr	w11, w0, #24
	stp	x10, x11, [sp, #16]
	stp	x8, x9, [sp]
Lloh228:
	adrp	x0, l_.str.102@PAGE
Lloh229:
	add	x0, x0, l_.str.102@PAGEOFF
	b	LBB41_57
LBB41_51:
	ubfx	w8, w0, #9, #5
	ubfx	w9, w0, #14, #5
	ubfx	w10, w0, #19, #5
	lsr	w11, w0, #24
	stp	x10, x11, [sp, #16]
	stp	x8, x9, [sp]
Lloh230:
	adrp	x0, l_.str.104@PAGE
Lloh231:
	add	x0, x0, l_.str.104@PAGEOFF
	b	LBB41_57
LBB41_52:
	ubfx	w8, w0, #9, #5
	ubfx	w9, w0, #14, #5
	ubfx	w10, w0, #19, #5
	lsr	w11, w0, #24
	stp	x10, x11, [sp, #16]
	stp	x8, x9, [sp]
Lloh232:
	adrp	x0, l_.str.105@PAGE
Lloh233:
	add	x0, x0, l_.str.105@PAGEOFF
	b	LBB41_57
LBB41_53:
	ubfx	w8, w0, #9, #5
	ubfx	w9, w0, #14, #5
	ubfx	w10, w0, #19, #5
	lsr	w11, w0, #24
	stp	x10, x11, [sp, #16]
	stp	x8, x9, [sp]
Lloh234:
	adrp	x0, l_.str.106@PAGE
Lloh235:
	add	x0, x0, l_.str.106@PAGEOFF
	b	LBB41_57
LBB41_54:
	ubfx	w10, w0, #7, #15
	cbz	w10, LBB41_56
; %bb.55:
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh236:
	adrp	x0, l_.str.84@PAGE
Lloh237:
	add	x0, x0, l_.str.84@PAGEOFF
	b	LBB41_57
LBB41_56:
	stp	x8, x9, [sp]
Lloh238:
	adrp	x0, l_.str.82@PAGE
Lloh239:
	add	x0, x0, l_.str.82@PAGEOFF
LBB41_57:
	bl	_strformat
LBB41_58:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
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
	.loh AdrpAdd	Lloh222, Lloh223
	.loh AdrpAdd	Lloh224, Lloh225
	.loh AdrpAdd	Lloh226, Lloh227
	.loh AdrpAdd	Lloh228, Lloh229
	.loh AdrpAdd	Lloh230, Lloh231
	.loh AdrpAdd	Lloh232, Lloh233
	.loh AdrpAdd	Lloh234, Lloh235
	.loh AdrpAdd	Lloh236, Lloh237
	.loh AdrpAdd	Lloh238, Lloh239
	.cfi_endproc
	.section	__TEXT,__const
lJTI41_0:
	.byte	(LBB41_2-LBB41_2)>>2
	.byte	(LBB41_4-LBB41_2)>>2
	.byte	(LBB41_5-LBB41_2)>>2
	.byte	(LBB41_6-LBB41_2)>>2
	.byte	(LBB41_7-LBB41_2)>>2
	.byte	(LBB41_8-LBB41_2)>>2
	.byte	(LBB41_9-LBB41_2)>>2
	.byte	(LBB41_10-LBB41_2)>>2
	.byte	(LBB41_11-LBB41_2)>>2
	.byte	(LBB41_18-LBB41_2)>>2
	.byte	(LBB41_21-LBB41_2)>>2
	.byte	(LBB41_22-LBB41_2)>>2
	.byte	(LBB41_23-LBB41_2)>>2
	.byte	(LBB41_25-LBB41_2)>>2
	.byte	(LBB41_27-LBB41_2)>>2
	.byte	(LBB41_29-LBB41_2)>>2
	.byte	(LBB41_31-LBB41_2)>>2
	.byte	(LBB41_33-LBB41_2)>>2
lJTI41_1:
	.byte	(LBB41_34-LBB41_34)>>2
	.byte	(LBB41_51-LBB41_34)>>2
	.byte	(LBB41_52-LBB41_34)>>2
	.byte	(LBB41_53-LBB41_34)>>2
lJTI41_2:
	.byte	(LBB41_32-LBB41_32)>>2
	.byte	(LBB41_48-LBB41_32)>>2
	.byte	(LBB41_49-LBB41_32)>>2
	.byte	(LBB41_50-LBB41_32)>>2
lJTI41_3:
	.byte	(LBB41_26-LBB41_26)>>2
	.byte	(LBB41_45-LBB41_26)>>2
	.byte	(LBB41_46-LBB41_26)>>2
	.byte	(LBB41_47-LBB41_26)>>2
lJTI41_4:
	.byte	(LBB41_24-LBB41_24)>>2
	.byte	(LBB41_42-LBB41_24)>>2
	.byte	(LBB41_43-LBB41_24)>>2
	.byte	(LBB41_44-LBB41_24)>>2
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_str_fpu_type                   ; -- Begin function str_fpu_type
	.p2align	2
_str_fpu_type:                          ; @str_fpu_type
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ubfx	w8, w0, #8, #4
Lloh240:
	adrp	x9, lJTI42_0@PAGE
Lloh241:
	add	x9, x9, lJTI42_0@PAGEOFF
	adr	x10, LBB42_1
	ldrb	w11, [x9, x8]
	add	x10, x10, x11, lsl #2
	br	x10
LBB42_1:
	ubfx	w8, w0, #17, #5
	ubfx	w9, w0, #22, #5
	lsr	w10, w0, #27
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh242:
	adrp	x0, l_.str.107@PAGE
Lloh243:
	add	x0, x0, l_.str.107@PAGEOFF
	b	LBB42_17
LBB42_2:
	ubfx	w8, w0, #17, #5
	ubfx	w9, w0, #22, #5
	lsr	w10, w0, #27
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh244:
	adrp	x0, l_.str.108@PAGE
Lloh245:
	add	x0, x0, l_.str.108@PAGEOFF
	b	LBB42_17
LBB42_3:
	ubfx	w8, w0, #17, #5
	ubfx	w9, w0, #22, #5
	lsr	w10, w0, #27
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh246:
	adrp	x0, l_.str.109@PAGE
Lloh247:
	add	x0, x0, l_.str.109@PAGEOFF
	b	LBB42_17
LBB42_4:
	ubfx	w8, w0, #17, #5
	ubfx	w9, w0, #22, #5
	lsr	w10, w0, #27
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh248:
	adrp	x0, l_.str.110@PAGE
Lloh249:
	add	x0, x0, l_.str.110@PAGEOFF
	b	LBB42_17
LBB42_5:
	ubfx	w8, w0, #17, #5
	ubfx	w9, w0, #22, #5
	lsr	w10, w0, #27
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh250:
	adrp	x0, l_.str.111@PAGE
Lloh251:
	add	x0, x0, l_.str.111@PAGEOFF
	b	LBB42_17
LBB42_6:
	ubfx	w8, w0, #17, #5
	ubfx	w9, w0, #22, #5
	lsr	w10, w0, #27
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh252:
	adrp	x0, l_.str.112@PAGE
Lloh253:
	add	x0, x0, l_.str.112@PAGEOFF
	b	LBB42_17
LBB42_7:
	ubfx	w8, w0, #17, #5
	ubfx	w9, w0, #22, #5
	lsr	w10, w0, #27
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh254:
	adrp	x0, l_.str.113@PAGE
Lloh255:
	add	x0, x0, l_.str.113@PAGEOFF
	b	LBB42_17
LBB42_8:
	ubfx	w8, w0, #17, #5
	ubfx	w9, w0, #22, #5
	lsr	w10, w0, #27
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh256:
	adrp	x0, l_.str.114@PAGE
Lloh257:
	add	x0, x0, l_.str.114@PAGEOFF
	b	LBB42_17
LBB42_9:
	ubfx	w8, w0, #17, #5
	ubfx	w9, w0, #22, #5
	lsr	w10, w0, #27
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh258:
	adrp	x0, l_.str.115@PAGE
Lloh259:
	add	x0, x0, l_.str.115@PAGEOFF
	b	LBB42_17
LBB42_10:
	ubfx	w8, w0, #17, #5
	ubfx	w9, w0, #22, #5
	lsr	w10, w0, #27
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh260:
	adrp	x0, l_.str.116@PAGE
Lloh261:
	add	x0, x0, l_.str.116@PAGEOFF
	b	LBB42_17
LBB42_11:
	ubfx	w8, w0, #17, #5
	ubfx	w9, w0, #22, #5
	stp	x8, x9, [sp]
Lloh262:
	adrp	x0, l_.str.117@PAGE
Lloh263:
	add	x0, x0, l_.str.117@PAGEOFF
	b	LBB42_17
LBB42_12:
	ubfx	w8, w0, #17, #5
	ubfx	w9, w0, #22, #5
	stp	x8, x9, [sp]
Lloh264:
	adrp	x0, l_.str.118@PAGE
Lloh265:
	add	x0, x0, l_.str.118@PAGEOFF
	b	LBB42_17
LBB42_13:
	ubfx	w8, w0, #17, #5
	ubfx	w9, w0, #22, #5
	stp	x8, x9, [sp]
Lloh266:
	adrp	x0, l_.str.119@PAGE
Lloh267:
	add	x0, x0, l_.str.119@PAGEOFF
	b	LBB42_17
LBB42_14:
	ubfx	w8, w0, #17, #5
	ubfx	w9, w0, #22, #5
	stp	x8, x9, [sp]
Lloh268:
	adrp	x0, l_.str.120@PAGE
Lloh269:
	add	x0, x0, l_.str.120@PAGEOFF
	b	LBB42_17
LBB42_15:
	ubfx	w8, w0, #17, #5
	ubfx	w9, w0, #22, #5
	stp	x8, x9, [sp]
Lloh270:
	adrp	x0, l_.str.121@PAGE
Lloh271:
	add	x0, x0, l_.str.121@PAGEOFF
	b	LBB42_17
LBB42_16:
	ubfx	w8, w0, #17, #5
	ubfx	w9, w0, #22, #5
	stp	x8, x9, [sp]
Lloh272:
	adrp	x0, l_.str.122@PAGE
Lloh273:
	add	x0, x0, l_.str.122@PAGEOFF
LBB42_17:
	bl	_strformat
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
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
	.loh AdrpAdd	Lloh272, Lloh273
	.cfi_endproc
	.section	__TEXT,__const
lJTI42_0:
	.byte	(LBB42_1-LBB42_1)>>2
	.byte	(LBB42_2-LBB42_1)>>2
	.byte	(LBB42_3-LBB42_1)>>2
	.byte	(LBB42_4-LBB42_1)>>2
	.byte	(LBB42_5-LBB42_1)>>2
	.byte	(LBB42_6-LBB42_1)>>2
	.byte	(LBB42_7-LBB42_1)>>2
	.byte	(LBB42_8-LBB42_1)>>2
	.byte	(LBB42_9-LBB42_1)>>2
	.byte	(LBB42_10-LBB42_1)>>2
	.byte	(LBB42_11-LBB42_1)>>2
	.byte	(LBB42_12-LBB42_1)>>2
	.byte	(LBB42_13-LBB42_1)>>2
	.byte	(LBB42_14-LBB42_1)>>2
	.byte	(LBB42_15-LBB42_1)>>2
	.byte	(LBB42_16-LBB42_1)>>2
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_str_rrr_type                   ; -- Begin function str_rrr_type
	.p2align	2
_str_rrr_type:                          ; @str_rrr_type
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ubfx	w8, w0, #2, #6
	cmp	w8, #18
	b.hi	LBB43_25
; %bb.1:
Lloh274:
	adrp	x9, lJTI43_0@PAGE
Lloh275:
	add	x9, x9, lJTI43_0@PAGEOFF
	adr	x10, LBB43_2
	ldrb	w11, [x9, x8]
	add	x10, x10, x11, lsl #2
	br	x10
LBB43_2:
	ubfx	x8, x0, #24, #8
	ubfx	w9, w0, #8, #8
	ubfx	w10, w0, #16, #8
                                        ; kill: def $w8 killed $w8 killed $x8 def $x8
	stp	x10, x8, [sp, #8]
	str	x9, [sp]
Lloh276:
	adrp	x0, l_.str.123@PAGE
Lloh277:
	add	x0, x0, l_.str.123@PAGEOFF
	b	LBB43_38
LBB43_3:
	ubfx	w8, w0, #8, #8
	ubfx	w9, w0, #16, #8
	ubfx	x10, x0, #24, #8
                                        ; kill: def $w10 killed $w10 killed $x10 def $x10
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh278:
	adrp	x0, l_.str.124@PAGE
Lloh279:
	add	x0, x0, l_.str.124@PAGEOFF
	b	LBB43_38
LBB43_4:
	ubfx	w8, w0, #8, #8
	ubfx	w9, w0, #16, #8
	ubfx	x10, x0, #24, #8
                                        ; kill: def $w10 killed $w10 killed $x10 def $x10
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh280:
	adrp	x0, l_.str.125@PAGE
Lloh281:
	add	x0, x0, l_.str.125@PAGEOFF
	b	LBB43_38
LBB43_5:
	ubfx	w8, w0, #8, #8
	ubfx	w9, w0, #16, #8
	ubfx	x10, x0, #24, #8
                                        ; kill: def $w10 killed $w10 killed $x10 def $x10
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh282:
	adrp	x0, l_.str.126@PAGE
Lloh283:
	add	x0, x0, l_.str.126@PAGEOFF
	b	LBB43_38
LBB43_6:
	ubfx	w8, w0, #8, #8
	ubfx	w9, w0, #16, #8
	ubfx	x10, x0, #24, #8
                                        ; kill: def $w10 killed $w10 killed $x10 def $x10
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh284:
	adrp	x0, l_.str.127@PAGE
Lloh285:
	add	x0, x0, l_.str.127@PAGEOFF
	b	LBB43_38
LBB43_7:
	ubfx	w8, w0, #8, #8
	ubfx	w9, w0, #16, #8
	ubfx	x10, x0, #24, #8
                                        ; kill: def $w10 killed $w10 killed $x10 def $x10
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh286:
	adrp	x0, l_.str.128@PAGE
Lloh287:
	add	x0, x0, l_.str.128@PAGEOFF
	b	LBB43_38
LBB43_8:
	ubfx	w8, w0, #8, #8
	ubfx	w9, w0, #16, #8
	ubfx	x10, x0, #24, #8
                                        ; kill: def $w10 killed $w10 killed $x10 def $x10
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh288:
	adrp	x0, l_.str.129@PAGE
Lloh289:
	add	x0, x0, l_.str.129@PAGEOFF
	b	LBB43_38
LBB43_9:
	ubfx	w8, w0, #8, #8
	ubfx	w9, w0, #16, #8
	ubfx	x10, x0, #24, #8
                                        ; kill: def $w10 killed $w10 killed $x10 def $x10
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh290:
	adrp	x0, l_.str.130@PAGE
Lloh291:
	add	x0, x0, l_.str.130@PAGEOFF
	b	LBB43_38
LBB43_10:
	ubfx	w8, w0, #8, #8
	ubfx	w9, w0, #16, #8
	ubfx	x10, x0, #24, #8
                                        ; kill: def $w10 killed $w10 killed $x10 def $x10
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh292:
	adrp	x0, l_.str.131@PAGE
Lloh293:
	add	x0, x0, l_.str.131@PAGEOFF
	b	LBB43_38
LBB43_11:
	ubfx	w8, w0, #8, #8
	ubfx	w9, w0, #16, #8
	ubfx	x10, x0, #24, #8
                                        ; kill: def $w10 killed $w10 killed $x10 def $x10
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh294:
	adrp	x0, l_.str.132@PAGE
Lloh295:
	add	x0, x0, l_.str.132@PAGEOFF
	b	LBB43_38
LBB43_12:
	ubfx	w8, w0, #8, #8
	ubfx	w9, w0, #16, #8
	ubfx	x10, x0, #24, #8
                                        ; kill: def $w10 killed $w10 killed $x10 def $x10
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh296:
	adrp	x0, l_.str.133@PAGE
Lloh297:
	add	x0, x0, l_.str.133@PAGEOFF
	b	LBB43_38
LBB43_13:
	ubfx	w8, w0, #8, #8
	ubfx	w9, w0, #16, #8
	ubfx	x10, x0, #24, #8
                                        ; kill: def $w10 killed $w10 killed $x10 def $x10
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh298:
	adrp	x0, l_.str.134@PAGE
Lloh299:
	add	x0, x0, l_.str.134@PAGEOFF
	b	LBB43_38
LBB43_14:
	lsr	x8, x0, #8
	ubfx	w9, w8, #1, #2
Lloh300:
	adrp	x10, lJTI43_4@PAGE
Lloh301:
	add	x10, x10, lJTI43_4@PAGEOFF
	adr	x11, LBB43_15
	ldrb	w12, [x10, x9]
	add	x11, x11, x12, lsl #2
	br	x11
LBB43_15:
	and	w8, w8, #0xff
	ubfx	w9, w0, #16, #8
	ubfx	x10, x0, #24, #8
                                        ; kill: def $w10 killed $w10 killed $x10 def $x10
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh302:
	adrp	x0, l_.str.135@PAGE
Lloh303:
	add	x0, x0, l_.str.135@PAGEOFF
	b	LBB43_38
LBB43_16:
	lsr	x8, x0, #8
	ubfx	w9, w8, #1, #2
Lloh304:
	adrp	x10, lJTI43_3@PAGE
Lloh305:
	add	x10, x10, lJTI43_3@PAGEOFF
	adr	x11, LBB43_17
	ldrb	w12, [x10, x9]
	add	x11, x11, x12, lsl #2
	br	x11
LBB43_17:
	and	w8, w8, #0xff
	ubfx	w9, w0, #16, #8
	ubfx	x10, x0, #24, #8
                                        ; kill: def $w10 killed $w10 killed $x10 def $x10
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh306:
	adrp	x0, l_.str.139@PAGE
Lloh307:
	add	x0, x0, l_.str.139@PAGEOFF
	b	LBB43_38
LBB43_18:
	ubfx	w8, w0, #8, #8
	ubfx	w9, w0, #16, #8
	stp	x8, x9, [sp]
Lloh308:
	adrp	x0, l_.str.143@PAGE
Lloh309:
	add	x0, x0, l_.str.143@PAGEOFF
	b	LBB43_38
LBB43_19:
	ubfx	w8, w0, #8, #8
	ubfx	w9, w0, #16, #8
	stp	x8, x9, [sp]
Lloh310:
	adrp	x0, l_.str.144@PAGE
Lloh311:
	add	x0, x0, l_.str.144@PAGEOFF
	b	LBB43_38
LBB43_20:
	lsr	x12, x0, #24
	lsr	x9, x0, #8
	lsl	w8, w12, #24
	and	w10, w0, #0xffff0000
	and	w11, w0, #0xff0000
	bfi	w11, w9, #8, #8
	ubfx	w12, w12, #1, #2
Lloh312:
	adrp	x13, lJTI43_2@PAGE
Lloh313:
	add	x13, x13, lJTI43_2@PAGEOFF
	adr	x14, LBB43_21
	ldrb	w15, [x13, x12]
	add	x14, x14, x15, lsl #2
	br	x14
LBB43_21:
	ubfx	w11, w11, #13, #5
	and	w9, w9, #0x1f
	ubfx	w10, w10, #19, #5
	lsr	w8, w8, #27
	stp	x10, x8, [sp, #16]
	stp	x9, x11, [sp]
Lloh314:
	adrp	x0, l_.str.145@PAGE
Lloh315:
	add	x0, x0, l_.str.145@PAGEOFF
	b	LBB43_38
LBB43_22:
	lsr	x12, x0, #24
	lsr	x9, x0, #8
	lsl	w8, w12, #24
	and	w10, w0, #0xffff0000
	and	w11, w0, #0xff0000
	bfi	w11, w9, #8, #8
	ubfx	w12, w12, #1, #2
Lloh316:
	adrp	x13, lJTI43_1@PAGE
Lloh317:
	add	x13, x13, lJTI43_1@PAGEOFF
	adr	x14, LBB43_23
	ldrb	w15, [x13, x12]
	add	x14, x14, x15, lsl #2
	br	x14
LBB43_23:
	ubfx	w11, w11, #13, #5
	and	w9, w9, #0x1f
	ubfx	w10, w10, #19, #5
	lsr	w8, w8, #27
	stp	x10, x8, [sp, #16]
	stp	x9, x11, [sp]
Lloh318:
	adrp	x0, l_.str.149@PAGE
Lloh319:
	add	x0, x0, l_.str.149@PAGEOFF
	b	LBB43_38
LBB43_24:
	and	x0, x0, #0xffffffff
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	b	_str_fpu_type
LBB43_25:
	mov	x0, #0
	b	LBB43_39
LBB43_26:
	and	w8, w8, #0xff
	ubfx	w9, w0, #16, #8
	ubfx	x10, x0, #24, #8
                                        ; kill: def $w10 killed $w10 killed $x10 def $x10
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh320:
	adrp	x0, l_.str.136@PAGE
Lloh321:
	add	x0, x0, l_.str.136@PAGEOFF
	b	LBB43_38
LBB43_27:
	and	w8, w8, #0xff
	ubfx	w9, w0, #16, #8
	ubfx	x10, x0, #24, #8
                                        ; kill: def $w10 killed $w10 killed $x10 def $x10
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh322:
	adrp	x0, l_.str.137@PAGE
Lloh323:
	add	x0, x0, l_.str.137@PAGEOFF
	b	LBB43_38
LBB43_28:
	and	w8, w8, #0xff
	ubfx	w9, w0, #16, #8
	ubfx	x10, x0, #24, #8
                                        ; kill: def $w10 killed $w10 killed $x10 def $x10
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh324:
	adrp	x0, l_.str.138@PAGE
Lloh325:
	add	x0, x0, l_.str.138@PAGEOFF
	b	LBB43_38
LBB43_29:
	and	w8, w8, #0xff
	ubfx	w9, w0, #16, #8
	ubfx	x10, x0, #24, #8
                                        ; kill: def $w10 killed $w10 killed $x10 def $x10
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh326:
	adrp	x0, l_.str.140@PAGE
Lloh327:
	add	x0, x0, l_.str.140@PAGEOFF
	b	LBB43_38
LBB43_30:
	and	w8, w8, #0xff
	ubfx	w9, w0, #16, #8
	ubfx	x10, x0, #24, #8
                                        ; kill: def $w10 killed $w10 killed $x10 def $x10
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh328:
	adrp	x0, l_.str.141@PAGE
Lloh329:
	add	x0, x0, l_.str.141@PAGEOFF
	b	LBB43_38
LBB43_31:
	and	w8, w8, #0xff
	ubfx	w9, w0, #16, #8
	ubfx	x10, x0, #24, #8
                                        ; kill: def $w10 killed $w10 killed $x10 def $x10
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh330:
	adrp	x0, l_.str.142@PAGE
Lloh331:
	add	x0, x0, l_.str.142@PAGEOFF
	b	LBB43_38
LBB43_32:
	ubfx	w11, w11, #13, #5
	and	w9, w9, #0x1f
	ubfx	w10, w10, #19, #5
	lsr	w8, w8, #27
	stp	x10, x8, [sp, #16]
	stp	x9, x11, [sp]
Lloh332:
	adrp	x0, l_.str.146@PAGE
Lloh333:
	add	x0, x0, l_.str.146@PAGEOFF
	b	LBB43_38
LBB43_33:
	ubfx	w11, w11, #13, #5
	and	w9, w9, #0x1f
	ubfx	w10, w10, #19, #5
	lsr	w8, w8, #27
	stp	x10, x8, [sp, #16]
	stp	x9, x11, [sp]
Lloh334:
	adrp	x0, l_.str.147@PAGE
Lloh335:
	add	x0, x0, l_.str.147@PAGEOFF
	b	LBB43_38
LBB43_34:
	ubfx	w11, w11, #13, #5
	and	w9, w9, #0x1f
	ubfx	w10, w10, #19, #5
	lsr	w8, w8, #27
	stp	x10, x8, [sp, #16]
	stp	x9, x11, [sp]
Lloh336:
	adrp	x0, l_.str.148@PAGE
Lloh337:
	add	x0, x0, l_.str.148@PAGEOFF
	b	LBB43_38
LBB43_35:
	ubfx	w11, w11, #13, #5
	and	w9, w9, #0x1f
	ubfx	w10, w10, #19, #5
	lsr	w8, w8, #27
	stp	x10, x8, [sp, #16]
	stp	x9, x11, [sp]
Lloh338:
	adrp	x0, l_.str.150@PAGE
Lloh339:
	add	x0, x0, l_.str.150@PAGEOFF
	b	LBB43_38
LBB43_36:
	ubfx	w11, w11, #13, #5
	and	w9, w9, #0x1f
	ubfx	w10, w10, #19, #5
	lsr	w8, w8, #27
	stp	x10, x8, [sp, #16]
	stp	x9, x11, [sp]
Lloh340:
	adrp	x0, l_.str.151@PAGE
Lloh341:
	add	x0, x0, l_.str.151@PAGEOFF
	b	LBB43_38
LBB43_37:
	ubfx	w11, w11, #13, #5
	and	w9, w9, #0x1f
	ubfx	w10, w10, #19, #5
	lsr	w8, w8, #27
	stp	x10, x8, [sp, #16]
	stp	x9, x11, [sp]
Lloh342:
	adrp	x0, l_.str.152@PAGE
Lloh343:
	add	x0, x0, l_.str.152@PAGEOFF
LBB43_38:
	bl	_strformat
LBB43_39:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.loh AdrpAdd	Lloh274, Lloh275
	.loh AdrpAdd	Lloh276, Lloh277
	.loh AdrpAdd	Lloh278, Lloh279
	.loh AdrpAdd	Lloh280, Lloh281
	.loh AdrpAdd	Lloh282, Lloh283
	.loh AdrpAdd	Lloh284, Lloh285
	.loh AdrpAdd	Lloh286, Lloh287
	.loh AdrpAdd	Lloh288, Lloh289
	.loh AdrpAdd	Lloh290, Lloh291
	.loh AdrpAdd	Lloh292, Lloh293
	.loh AdrpAdd	Lloh294, Lloh295
	.loh AdrpAdd	Lloh296, Lloh297
	.loh AdrpAdd	Lloh298, Lloh299
	.loh AdrpAdd	Lloh300, Lloh301
	.loh AdrpAdd	Lloh302, Lloh303
	.loh AdrpAdd	Lloh304, Lloh305
	.loh AdrpAdd	Lloh306, Lloh307
	.loh AdrpAdd	Lloh308, Lloh309
	.loh AdrpAdd	Lloh310, Lloh311
	.loh AdrpAdd	Lloh312, Lloh313
	.loh AdrpAdd	Lloh314, Lloh315
	.loh AdrpAdd	Lloh316, Lloh317
	.loh AdrpAdd	Lloh318, Lloh319
	.loh AdrpAdd	Lloh320, Lloh321
	.loh AdrpAdd	Lloh322, Lloh323
	.loh AdrpAdd	Lloh324, Lloh325
	.loh AdrpAdd	Lloh326, Lloh327
	.loh AdrpAdd	Lloh328, Lloh329
	.loh AdrpAdd	Lloh330, Lloh331
	.loh AdrpAdd	Lloh332, Lloh333
	.loh AdrpAdd	Lloh334, Lloh335
	.loh AdrpAdd	Lloh336, Lloh337
	.loh AdrpAdd	Lloh338, Lloh339
	.loh AdrpAdd	Lloh340, Lloh341
	.loh AdrpAdd	Lloh342, Lloh343
	.cfi_endproc
	.section	__TEXT,__const
lJTI43_0:
	.byte	(LBB43_2-LBB43_2)>>2
	.byte	(LBB43_3-LBB43_2)>>2
	.byte	(LBB43_4-LBB43_2)>>2
	.byte	(LBB43_5-LBB43_2)>>2
	.byte	(LBB43_6-LBB43_2)>>2
	.byte	(LBB43_7-LBB43_2)>>2
	.byte	(LBB43_8-LBB43_2)>>2
	.byte	(LBB43_9-LBB43_2)>>2
	.byte	(LBB43_10-LBB43_2)>>2
	.byte	(LBB43_11-LBB43_2)>>2
	.byte	(LBB43_12-LBB43_2)>>2
	.byte	(LBB43_13-LBB43_2)>>2
	.byte	(LBB43_14-LBB43_2)>>2
	.byte	(LBB43_16-LBB43_2)>>2
	.byte	(LBB43_18-LBB43_2)>>2
	.byte	(LBB43_19-LBB43_2)>>2
	.byte	(LBB43_20-LBB43_2)>>2
	.byte	(LBB43_22-LBB43_2)>>2
	.byte	(LBB43_24-LBB43_2)>>2
lJTI43_1:
	.byte	(LBB43_23-LBB43_23)>>2
	.byte	(LBB43_35-LBB43_23)>>2
	.byte	(LBB43_36-LBB43_23)>>2
	.byte	(LBB43_37-LBB43_23)>>2
lJTI43_2:
	.byte	(LBB43_21-LBB43_21)>>2
	.byte	(LBB43_32-LBB43_21)>>2
	.byte	(LBB43_33-LBB43_21)>>2
	.byte	(LBB43_34-LBB43_21)>>2
lJTI43_3:
	.byte	(LBB43_17-LBB43_17)>>2
	.byte	(LBB43_29-LBB43_17)>>2
	.byte	(LBB43_30-LBB43_17)>>2
	.byte	(LBB43_31-LBB43_17)>>2
lJTI43_4:
	.byte	(LBB43_15-LBB43_15)>>2
	.byte	(LBB43_26-LBB43_15)>>2
	.byte	(LBB43_27-LBB43_15)>>2
	.byte	(LBB43_28-LBB43_15)>>2
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_str_ri_type                    ; -- Begin function str_ri_type
	.p2align	2
_str_ri_type:                           ; @str_ri_type
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ubfx	w8, w0, #2, #5
	cmp	w8, #20
	b.hi	LBB44_11
; %bb.1:
Lloh344:
	adrp	x9, lJTI44_0@PAGE
Lloh345:
	add	x9, x9, lJTI44_0@PAGEOFF
	adr	x10, LBB44_2
	ldrb	w11, [x9, x8]
	add	x10, x10, x11, lsl #2
	br	x10
LBB44_2:
	ubfx	w8, w0, #7, #5
	asr	w9, w0, #12
	stp	x8, x9, [sp]
Lloh346:
	adrp	x0, l_.str.153@PAGE
Lloh347:
	add	x0, x0, l_.str.153@PAGEOFF
	b	LBB44_26
LBB44_3:
	ubfx	w8, w0, #7, #5
	asr	w9, w0, #12
	stp	x8, x9, [sp]
Lloh348:
	adrp	x0, l_.str.155@PAGE
Lloh349:
	add	x0, x0, l_.str.155@PAGEOFF
	b	LBB44_26
LBB44_4:
	lsr	w8, w0, #27
	str	x8, [sp]
Lloh350:
	adrp	x0, l_.str.159@PAGE
Lloh351:
	add	x0, x0, l_.str.159@PAGEOFF
	b	LBB44_26
LBB44_5:
	lsr	w8, w0, #27
	str	x8, [sp]
Lloh352:
	adrp	x0, l_.str.164@PAGE
Lloh353:
	add	x0, x0, l_.str.164@PAGEOFF
	b	LBB44_26
LBB44_6:
	lsr	w8, w0, #27
	str	x8, [sp]
Lloh354:
	adrp	x0, l_.str.166@PAGE
Lloh355:
	add	x0, x0, l_.str.166@PAGEOFF
	b	LBB44_26
LBB44_7:
	lsr	w8, w0, #27
	str	x8, [sp]
Lloh356:
	adrp	x0, l_.str.167@PAGE
Lloh357:
	add	x0, x0, l_.str.167@PAGEOFF
	b	LBB44_26
LBB44_8:
	lsr	w8, w0, #27
	str	x8, [sp]
Lloh358:
	adrp	x0, l_.str.169@PAGE
Lloh359:
	add	x0, x0, l_.str.169@PAGEOFF
	b	LBB44_26
LBB44_9:
	lsr	w8, w0, #27
	str	x8, [sp]
Lloh360:
	adrp	x0, l_.str.170@PAGE
Lloh361:
	add	x0, x0, l_.str.170@PAGEOFF
	b	LBB44_26
LBB44_10:
	lsr	w8, w0, #27
	str	x8, [sp]
Lloh362:
	adrp	x0, l_.str.171@PAGE
Lloh363:
	add	x0, x0, l_.str.171@PAGEOFF
	b	LBB44_26
LBB44_11:
	mov	x0, #0
	b	LBB44_27
LBB44_12:
	ubfx	w8, w0, #7, #5
	asr	w9, w0, #12
	stp	x8, x9, [sp]
Lloh364:
	adrp	x0, l_.str.154@PAGE
Lloh365:
	add	x0, x0, l_.str.154@PAGEOFF
	b	LBB44_26
LBB44_13:
	lsr	w8, w0, #27
	lsr	w9, w0, #16
	ubfx	w10, w0, #9, #2
	tbnz	w0, #8, LBB44_25
; %bb.14:
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh366:
	adrp	x0, l_.str.157@PAGE
Lloh367:
	add	x0, x0, l_.str.157@PAGEOFF
	b	LBB44_26
LBB44_15:
	lsr	w8, w0, #27
	str	x8, [sp]
Lloh368:
	adrp	x0, l_.str.160@PAGE
Lloh369:
	add	x0, x0, l_.str.160@PAGEOFF
	b	LBB44_26
LBB44_16:
	lsr	w8, w0, #27
	str	x8, [sp]
Lloh370:
	adrp	x0, l_.str.161@PAGE
Lloh371:
	add	x0, x0, l_.str.161@PAGEOFF
	b	LBB44_26
LBB44_17:
	lsr	w8, w0, #27
	str	x8, [sp]
Lloh372:
	adrp	x0, l_.str.162@PAGE
Lloh373:
	add	x0, x0, l_.str.162@PAGEOFF
	b	LBB44_26
LBB44_18:
	lsr	w8, w0, #27
	str	x8, [sp]
Lloh374:
	adrp	x0, l_.str.163@PAGE
Lloh375:
	add	x0, x0, l_.str.163@PAGEOFF
	b	LBB44_26
LBB44_19:
	lsr	w8, w0, #27
	str	x8, [sp]
Lloh376:
	adrp	x0, l_.str.165@PAGE
Lloh377:
	add	x0, x0, l_.str.165@PAGEOFF
	b	LBB44_26
LBB44_20:
	lsr	w8, w0, #27
	str	x8, [sp]
Lloh378:
	adrp	x0, l_.str.168@PAGE
Lloh379:
	add	x0, x0, l_.str.168@PAGEOFF
	b	LBB44_26
LBB44_21:
	lsr	w8, w0, #27
	str	x8, [sp]
Lloh380:
	adrp	x0, l_.str.172@PAGE
Lloh381:
	add	x0, x0, l_.str.172@PAGEOFF
	b	LBB44_26
LBB44_22:
	lsr	w8, w0, #27
	ubfx	w9, w0, #7, #20
	stp	x8, x9, [sp]
Lloh382:
	adrp	x0, l_.str.173@PAGE
Lloh383:
	add	x0, x0, l_.str.173@PAGEOFF
	b	LBB44_26
LBB44_23:
	lsr	w8, w0, #27
	ubfx	w9, w0, #7, #20
	stp	x8, x9, [sp]
Lloh384:
	adrp	x0, l_.str.174@PAGE
Lloh385:
	add	x0, x0, l_.str.174@PAGEOFF
	b	LBB44_26
LBB44_24:
Lloh386:
	adrp	x0, l_.str.158@PAGE
Lloh387:
	add	x0, x0, l_.str.158@PAGEOFF
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	b	_strformat
LBB44_25:
	stp	x9, x10, [sp, #8]
	str	x8, [sp]
Lloh388:
	adrp	x0, l_.str.156@PAGE
Lloh389:
	add	x0, x0, l_.str.156@PAGEOFF
LBB44_26:
	bl	_strformat
LBB44_27:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.loh AdrpAdd	Lloh344, Lloh345
	.loh AdrpAdd	Lloh346, Lloh347
	.loh AdrpAdd	Lloh348, Lloh349
	.loh AdrpAdd	Lloh350, Lloh351
	.loh AdrpAdd	Lloh352, Lloh353
	.loh AdrpAdd	Lloh354, Lloh355
	.loh AdrpAdd	Lloh356, Lloh357
	.loh AdrpAdd	Lloh358, Lloh359
	.loh AdrpAdd	Lloh360, Lloh361
	.loh AdrpAdd	Lloh362, Lloh363
	.loh AdrpAdd	Lloh364, Lloh365
	.loh AdrpAdd	Lloh366, Lloh367
	.loh AdrpAdd	Lloh368, Lloh369
	.loh AdrpAdd	Lloh370, Lloh371
	.loh AdrpAdd	Lloh372, Lloh373
	.loh AdrpAdd	Lloh374, Lloh375
	.loh AdrpAdd	Lloh376, Lloh377
	.loh AdrpAdd	Lloh378, Lloh379
	.loh AdrpAdd	Lloh380, Lloh381
	.loh AdrpAdd	Lloh382, Lloh383
	.loh AdrpAdd	Lloh384, Lloh385
	.loh AdrpAdd	Lloh386, Lloh387
	.loh AdrpAdd	Lloh388, Lloh389
	.cfi_endproc
	.section	__TEXT,__const
lJTI44_0:
	.byte	(LBB44_2-LBB44_2)>>2
	.byte	(LBB44_12-LBB44_2)>>2
	.byte	(LBB44_3-LBB44_2)>>2
	.byte	(LBB44_13-LBB44_2)>>2
	.byte	(LBB44_4-LBB44_2)>>2
	.byte	(LBB44_15-LBB44_2)>>2
	.byte	(LBB44_16-LBB44_2)>>2
	.byte	(LBB44_17-LBB44_2)>>2
	.byte	(LBB44_18-LBB44_2)>>2
	.byte	(LBB44_5-LBB44_2)>>2
	.byte	(LBB44_19-LBB44_2)>>2
	.byte	(LBB44_6-LBB44_2)>>2
	.byte	(LBB44_7-LBB44_2)>>2
	.byte	(LBB44_20-LBB44_2)>>2
	.byte	(LBB44_8-LBB44_2)>>2
	.byte	(LBB44_9-LBB44_2)>>2
	.byte	(LBB44_10-LBB44_2)>>2
	.byte	(LBB44_21-LBB44_2)>>2
	.byte	(LBB44_22-LBB44_2)>>2
	.byte	(LBB44_23-LBB44_2)>>2
	.byte	(LBB44_24-LBB44_2)>>2
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_dis                            ; -- Begin function dis
	.p2align	2
_dis:                                   ; @dis
	.cfi_startproc
; %bb.0:
	and	w8, w0, #0x3
Lloh390:
	adrp	x9, lJTI45_0@PAGE
Lloh391:
	add	x9, x9, lJTI45_0@PAGEOFF
	adr	x10, LBB45_1
	ldrb	w11, [x9, x8]
	add	x10, x10, x11, lsl #2
	br	x10
LBB45_1:
	ubfx	w8, w0, #2, #5
	cmp	w8, #13
	b.hi	LBB45_6
; %bb.2:
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh392:
	adrp	x9, l_switch.table.dis@PAGE
Lloh393:
	add	x9, x9, l_switch.table.dis@PAGEOFF
	ldr	x8, [x9, w8, uxtw  #3]
	asr	w9, w0, #7
	str	x9, [sp]
	mov	x0, x8
	bl	_strformat
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
LBB45_3:
	and	x0, x0, #0xffffffff
	b	_str_rrr_type
LBB45_4:
	and	x0, x0, #0xffffffff
	b	_str_ri_type
LBB45_5:
	and	x0, x0, #0xffffffff
	b	_str_rri_type
LBB45_6:
	mov	x0, #0
	ret
	.loh AdrpAdd	Lloh390, Lloh391
	.loh AdrpAdd	Lloh392, Lloh393
	.cfi_endproc
	.section	__TEXT,__const
lJTI45_0:
	.byte	(LBB45_1-LBB45_1)>>2
	.byte	(LBB45_5-LBB45_1)>>2
	.byte	(LBB45_3-LBB45_1)>>2
	.byte	(LBB45_4-LBB45_1)>>2
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_exec                           ; -- Begin function exec
	.p2align	2
_exec:                                  ; @exec
	.cfi_startproc
; %bb.0:
	stp	x28, x27, [sp, #-80]!           ; 16-byte Folded Spill
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
	.cfi_offset w27, -72
	.cfi_offset w28, -80
	sub	sp, sp, #1088
	mov	x19, x0
	mov	x20, x8
	ldr	x24, [x0, #248]
	cmp	x24, #4
	b.ne	LBB46_2
LBB46_1:
	mov	x0, x20
	mov	x1, x19
	mov	w2, #528
	bl	_memcpy
	add	sp, sp, #1088
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #16]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp], #80             ; 16-byte Folded Reload
	ret
LBB46_2:
Lloh394:
	adrp	x21, l_.str.175@PAGE
Lloh395:
	add	x21, x21, l_.str.175@PAGEOFF
Lloh396:
	adrp	x23, lJTI46_0@PAGE
Lloh397:
	add	x23, x23, lJTI46_0@PAGEOFF
	b	LBB46_5
LBB46_3:                                ;   in Loop: Header=BB46_5 Depth=1
	add	x0, sp, #32
	mov	x1, x19
	mov	w2, #528
	bl	_memcpy
	add	x8, sp, #560
	add	x0, sp, #32
	mov	x1, x22
	bl	_exec_rrr_type
LBB46_4:                                ;   in Loop: Header=BB46_5 Depth=1
	add	x1, sp, #560
	mov	x0, x19
	mov	w2, #528
	bl	_memcpy
	ldr	x24, [x19, #248]
	cmp	x24, #4
	b.eq	LBB46_1
LBB46_5:                                ; =>This Inner Loop Header: Depth=1
	ldr	w22, [x24]
	mov	x0, x22
	bl	_dis
	stp	x22, x0, [sp, #8]
	str	x24, [sp]
	mov	x0, x21
	bl	_printf
	and	x8, x22, #0x3
	adr	x9, LBB46_3
	ldrb	w10, [x23, x8]
	add	x9, x9, x10, lsl #2
	br	x9
LBB46_6:                                ;   in Loop: Header=BB46_5 Depth=1
	add	x0, sp, #32
	mov	x1, x19
	mov	w2, #528
	bl	_memcpy
	add	x8, sp, #560
	add	x0, sp, #32
	mov	x1, x22
	bl	_exec_data_type
	b	LBB46_4
LBB46_7:                                ;   in Loop: Header=BB46_5 Depth=1
	add	x0, sp, #32
	mov	x1, x19
	mov	w2, #528
	bl	_memcpy
	add	x8, sp, #560
	add	x0, sp, #32
	mov	x1, x22
	bl	_exec_rri_type
	b	LBB46_4
LBB46_8:                                ;   in Loop: Header=BB46_5 Depth=1
	add	x0, sp, #32
	mov	x1, x19
	mov	w2, #528
	bl	_memcpy
	add	x8, sp, #560
	add	x0, sp, #32
	mov	x1, x22
	bl	_exec_ri_type
	b	LBB46_4
	.loh AdrpAdd	Lloh396, Lloh397
	.loh AdrpAdd	Lloh394, Lloh395
	.cfi_endproc
	.section	__TEXT,__const
lJTI46_0:
	.byte	(LBB46_6-LBB46_3)>>2
	.byte	(LBB46_7-LBB46_3)>>2
	.byte	(LBB46_3-LBB46_3)>>2
	.byte	(LBB46_8-LBB46_3)>>2
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_disassemble                    ; -- Begin function disassemble
	.p2align	2
_disassemble:                           ; @disassemble
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
	lsr	x8, x0, #32
	cbnz	x8, LBB47_2
LBB47_1:
	ldp	x29, x30, [sp, #80]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #64]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #48]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #32]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #96
	ret
LBB47_2:
	mov	x19, x1
	mov	x24, #0
	add	x25, x1, x8
Lloh398:
	adrp	x20, l_.str.176@PAGE
Lloh399:
	add	x20, x20, l_.str.176@PAGEOFF
Lloh400:
	adrp	x21, l_.str.177@PAGE
Lloh401:
	add	x21, x21, l_.str.177@PAGEOFF
	b	LBB47_5
LBB47_3:                                ;   in Loop: Header=BB47_5 Depth=1
	mov	x0, x23
	bl	_puts
	mov	x0, x23
	bl	_free
LBB47_4:                                ;   in Loop: Header=BB47_5 Depth=1
	add	x24, x24, #4
	cmp	x19, x25
	b.hs	LBB47_1
LBB47_5:                                ; =>This Inner Loop Header: Depth=1
	ldr	w22, [x19], #4
	mov	x0, x22
	bl	_dis
	mov	x23, x0
	stp	x24, x22, [sp]
	mov	x0, x20
	bl	_printf
	cbnz	x23, LBB47_3
; %bb.6:                                ;   in Loop: Header=BB47_5 Depth=1
                                        ; kill: def $w22 killed $w22 killed $x22 def $x22
	str	x22, [sp]
	mov	x0, x21
	bl	_printf
	b	LBB47_4
	.loh AdrpAdd	Lloh400, Lloh401
	.loh AdrpAdd	Lloh398, Lloh399
	.cfi_endproc
                                        ; -- End function
	.globl	_read_hive_file                 ; -- Begin function read_hive_file
	.p2align	2
_read_hive_file:                        ; @read_hive_file
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
	mov	x19, x0
	mov	x20, x8
	mov	x0, x8
	mov	w1, #4
	mov	w2, #1
	mov	x3, x19
	bl	_fread
	add	x0, x20, #16
	mov	w1, #8
	mov	w2, #1
	mov	x3, x19
	bl	_fread
	ldr	x22, [x20, #16]
	str	x22, [x20, #24]
	lsl	x0, x22, #4
	bl	_malloc
	str	x0, [x20, #8]
	cbz	x22, LBB48_5
; %bb.1:
	add	x20, x0, #4
	b	LBB48_3
LBB48_2:                                ;   in Loop: Header=BB48_3 Depth=1
	add	x20, x20, #16
	subs	x22, x22, #1
	b.eq	LBB48_5
LBB48_3:                                ; =>This Inner Loop Header: Depth=1
	mov	x0, x20
	mov	w1, #4
	mov	w2, #1
	mov	x3, x19
	bl	_fread
	sub	x0, x20, #4
	mov	w1, #4
	mov	w2, #1
	mov	x3, x19
	bl	_fread
	ldr	w21, [x20]
	cbz	w21, LBB48_2
; %bb.4:                                ;   in Loop: Header=BB48_3 Depth=1
	mov	x0, x21
	bl	_malloc
	stur	x0, [x20, #4]
	mov	w1, #1
	mov	x2, x21
	mov	x3, x19
	bl	_fread
	b	LBB48_2
LBB48_5:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_get_all_files                  ; -- Begin function get_all_files
	.p2align	2
_get_all_files:                         ; @get_all_files
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
	mov	x19, x8
	add	x8, sp, #32
	bl	_read_hive_file
	mov	w8, #256
	str	x8, [x19, #16]
	mov	w0, #8192
	bl	_malloc
	str	x0, [x19]
	cbz	x0, LBB49_27
; %bb.1:
	mov	w8, #1
	str	x8, [x19, #8]
	ldp	q0, q1, [sp, #32]
	stp	q0, q1, [x0]
	ldr	x9, [sp, #48]
	cbz	x9, LBB49_25
; %bb.2:
	ldr	x8, [sp, #40]
LBB49_3:                                ; =>This Inner Loop Header: Depth=1
	ldr	w10, [x8]
	cmp	w10, #8
	b.eq	LBB49_5
; %bb.4:                                ;   in Loop: Header=BB49_3 Depth=1
	add	x8, x8, #16
	subs	x9, x9, #1
	b.ne	LBB49_3
	b	LBB49_25
LBB49_5:
	ldr	x21, [x8, #8]
	cbz	x21, LBB49_25
; %bb.6:
	ldr	x8, [x8]
	lsr	x8, x8, #32
	cbz	x8, LBB49_25
; %bb.7:
	mov	x23, #0
	mov	x20, #0
	mov	x26, #0
	add	x24, x21, x8
	mov	w25, #256
	b	LBB49_9
LBB49_8:                                ;   in Loop: Header=BB49_9 Depth=1
	add	x8, x26, #1
	str	x21, [x20, x26, lsl  #3]
	add	x9, x22, x21
	add	x21, x9, #1
	mov	x26, x8
	cmp	x21, x24
	b.hs	LBB49_12
LBB49_9:                                ; =>This Inner Loop Header: Depth=1
	mov	x0, x21
	bl	_strlen
	mov	x22, x0
	cmp	x26, x23
	b.lo	LBB49_8
; %bb.10:                               ;   in Loop: Header=BB49_9 Depth=1
	lsl	x8, x23, #1
	cmp	x23, #0
	csel	x23, x25, x8, eq
	lsl	x1, x23, #3
	mov	x0, x20
	bl	_realloc
	cbz	x0, LBB49_26
; %bb.11:                               ;   in Loop: Header=BB49_9 Depth=1
	mov	x20, x0
	b	LBB49_8
LBB49_12:
	cbz	x8, LBB49_25
; %bb.13:
	mov	x23, #0
	sub	x24, x8, #1
	ldp	x27, x25, [x19, #8]
Lloh402:
	adrp	x21, l_.str.53@PAGE
Lloh403:
	add	x21, x21, l_.str.53@PAGEOFF
	b	LBB49_16
LBB49_14:                               ;   in Loop: Header=BB49_16 Depth=1
	ldr	x0, [x19]
LBB49_15:                               ;   in Loop: Header=BB49_16 Depth=1
	ldr	x1, [sp, #8]
	lsl	x2, x26, #5
	add	x0, x0, x27, lsl #5
	bl	_memcpy
	str	x28, [x19, #8]
	mov	x0, x22
	bl	_fclose
	add	x8, x23, #1
	mov	x27, x28
	cmp	x24, x23
	mov	x23, x8
	b.eq	LBB49_25
LBB49_16:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB49_21 Depth 2
	ldr	x0, [x20, x23, lsl  #3]
	mov	x1, x21
	bl	_fopen
	cbz	x0, LBB49_28
; %bb.17:                               ;   in Loop: Header=BB49_16 Depth=1
	mov	x22, x0
	add	x8, sp, #8
	bl	_get_all_files
	ldr	x26, [sp, #16]
	add	x28, x26, x27
	cmp	x28, x25
	b.ls	LBB49_14
; %bb.18:                               ;   in Loop: Header=BB49_16 Depth=1
	cbz	x25, LBB49_20
; %bb.19:                               ;   in Loop: Header=BB49_16 Depth=1
	cmp	x28, x25
	b.hi	LBB49_21
	b	LBB49_23
LBB49_20:                               ;   in Loop: Header=BB49_16 Depth=1
	mov	w8, #256
	str	x8, [x19, #16]
	mov	w25, #256
	cmp	x28, x25
	b.ls	LBB49_23
LBB49_21:                               ;   Parent Loop BB49_16 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	x25, x25, #1
	cmp	x28, x25
	b.hi	LBB49_21
; %bb.22:                               ;   in Loop: Header=BB49_16 Depth=1
	str	x25, [x19, #16]
LBB49_23:                               ;   in Loop: Header=BB49_16 Depth=1
	ldr	x0, [x19]
	lsl	x1, x25, #5
	bl	_realloc
	str	x0, [x19]
	cbnz	x0, LBB49_15
; %bb.24:
	bl	_get_all_files.cold.2
LBB49_25:
	ldp	x29, x30, [sp, #144]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #128]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #112]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #96]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #80]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #64]             ; 16-byte Folded Reload
	add	sp, sp, #160
	ret
LBB49_26:
	bl	_get_all_files.cold.3
LBB49_27:
	bl	_get_all_files.cold.1
LBB49_28:
Lloh404:
	adrp	x8, ___stderrp@GOTPAGE
Lloh405:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh406:
	ldr	x0, [x8]
	ldr	x8, [x20, x23, lsl  #3]
	str	x8, [sp]
Lloh407:
	adrp	x1, l_.str.181@PAGE
Lloh408:
	add	x1, x1, l_.str.181@PAGEOFF
	bl	_fprintf
	mov	w0, #1
	bl	_exit
	.loh AdrpAdd	Lloh402, Lloh403
	.loh AdrpAdd	Lloh407, Lloh408
	.loh AdrpLdrGotLdr	Lloh404, Lloh405, Lloh406
	.cfi_endproc
                                        ; -- End function
	.globl	_create_ld_section              ; -- Begin function create_ld_section
	.p2align	2
_create_ld_section:                     ; @create_ld_section
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
	stp	xzr, xzr, [x8]
	str	xzr, [x8, #16]
	cbz	x1, LBB50_2
; %bb.1:
	mov	x20, x8
	lsr	x8, x0, #32
	cbnz	x8, LBB50_3
LBB50_2:
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #16]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp], #80             ; 16-byte Folded Reload
	ret
LBB50_3:
	mov	x19, x1
	mov	x24, #0
	mov	x21, #0
	add	x23, x1, x8
	mov	w25, #256
	b	LBB50_5
LBB50_4:                                ;   in Loop: Header=BB50_5 Depth=1
	str	x19, [x21, x24, lsl  #3]
	add	x24, x24, #1
	str	x24, [x20, #8]
	add	x8, x22, x19
	add	x19, x8, #1
	cmp	x19, x23
	b.hs	LBB50_2
LBB50_5:                                ; =>This Inner Loop Header: Depth=1
	mov	x0, x19
	bl	_strlen
	mov	x22, x0
	ldr	x8, [x20, #16]
	cmp	x24, x8
	b.lo	LBB50_4
; %bb.6:                                ;   in Loop: Header=BB50_5 Depth=1
	lsl	x9, x8, #1
	cmp	x8, #0
	csel	x8, x25, x9, eq
	str	x8, [x20, #16]
	lsl	x1, x8, #3
	mov	x0, x21
	bl	_realloc
	mov	x21, x0
	str	x0, [x20]
	cbnz	x0, LBB50_4
; %bb.7:
	bl	_create_ld_section.cold.1
	.cfi_endproc
                                        ; -- End function
	.globl	_get_section                    ; -- Begin function get_section
	.p2align	2
_get_section:                           ; @get_section
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #16]
	cbz	x8, LBB51_4
; %bb.1:
	ldr	x9, [x0, #8]
LBB51_2:                                ; =>This Inner Loop Header: Depth=1
	ldr	w10, [x9]
	cmp	w10, w1
	b.eq	LBB51_5
; %bb.3:                                ;   in Loop: Header=BB51_2 Depth=1
	add	x9, x9, #16
	subs	x8, x8, #1
	b.ne	LBB51_2
LBB51_4:
	mov	x1, #0
	mov	x0, #0
	ret
LBB51_5:
	ldp	x0, x1, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_write_hive_file                ; -- Begin function write_hive_file
	.p2align	2
_write_hive_file:                       ; @write_hive_file
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
	mov	w1, #4
	mov	w2, #1
	mov	x3, x19
	bl	_fwrite
	add	x0, x20, #16
	mov	w1, #8
	mov	w2, #1
	mov	x3, x19
	bl	_fwrite
	ldr	x8, [x20, #16]
	cbz	x8, LBB52_3
; %bb.1:
	mov	x21, #0
	mov	x22, #0
LBB52_2:                                ; =>This Inner Loop Header: Depth=1
	ldr	x8, [x20, #8]
	add	x8, x8, x21
	add	x0, x8, #4
	mov	w1, #4
	mov	w2, #1
	mov	x3, x19
	bl	_fwrite
	ldr	x8, [x20, #8]
	add	x0, x8, x21
	mov	w1, #4
	mov	w2, #1
	mov	x3, x19
	bl	_fwrite
	ldr	x8, [x20, #8]
	add	x8, x8, x21
	ldr	x0, [x8, #8]
	ldr	w2, [x8, #4]
	mov	w1, #1
	mov	x3, x19
	bl	_fwrite
	add	x22, x22, #1
	ldr	x8, [x20, #16]
	add	x21, x21, #16
	cmp	x22, x8
	b.lo	LBB52_2
LBB52_3:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_create_symbol_section          ; -- Begin function create_symbol_section
	.p2align	2
_create_symbol_section:                 ; @create_symbol_section
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
	stp	xzr, xzr, [x8]
	str	xzr, [x8, #16]
	cbz	x1, LBB53_4
; %bb.1:
	mov	x19, x1
	mov	x20, x8
	ldr	x21, [x1]
	dup.2d	v0, x21
	stur	q0, [x8, #8]
	add	x8, x21, x21, lsl #1
	lsl	x0, x8, #3
	bl	_malloc
	str	x0, [x20]
	cbz	x21, LBB53_4
; %bb.2:
	add	x22, x0, #8
LBB53_3:                                ; =>This Inner Loop Header: Depth=1
	add	x19, x19, #8
	mov	x0, x19
	bl	_strlen
	mov	x20, x0
	bl	_malloc
	stur	x0, [x22, #-8]
	mov	x1, x19
	bl	_strcpy
	add	x19, x20, x19
	ldr	x8, [x19, #1]!
	str	x8, [x22], #24
	subs	x21, x21, #1
	b.ne	LBB53_3
LBB53_4:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_create_relocation_section      ; -- Begin function create_relocation_section
	.p2align	2
_create_relocation_section:             ; @create_relocation_section
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
	stp	xzr, xzr, [x8]
	str	xzr, [x8, #16]
	cbz	x1, LBB54_4
; %bb.1:
	mov	x19, x1
	mov	x20, x8
	ldr	x21, [x1]
	dup.2d	v0, x21
	stur	q0, [x8, #8]
	add	x8, x21, x21, lsl #1
	lsl	x0, x8, #3
	bl	_malloc
	str	x0, [x20]
	cbz	x21, LBB54_4
; %bb.2:
	add	x19, x19, #8
	add	x22, x0, #16
LBB54_3:                                ; =>This Inner Loop Header: Depth=1
	mov	x0, x19
	bl	_strlen
	add	x20, x0, #1
	mov	x0, x20
	bl	_malloc
	stur	x0, [x22, #-16]
	mov	x1, x19
	bl	_strcpy
	add	x8, x19, x20
	ldr	x9, [x8]
	stur	x9, [x22, #-8]
	ldr	w9, [x8, #8]
	add	x19, x8, #12
	str	w9, [x22], #24
	subs	x21, x21, #1
	b.ne	LBB54_3
LBB54_4:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_get_code_section_address       ; -- Begin function get_code_section_address
	.p2align	2
_get_code_section_address:              ; @get_code_section_address
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #16]
	cbz	x8, LBB55_4
; %bb.1:
	ldr	x9, [x0, #8]
	add	x9, x9, #8
LBB55_2:                                ; =>This Inner Loop Header: Depth=1
	ldur	w10, [x9, #-8]
	cmp	w10, #1
	b.eq	LBB55_5
; %bb.3:                                ;   in Loop: Header=BB55_2 Depth=1
	add	x9, x9, #16
	subs	x8, x8, #1
	b.ne	LBB55_2
LBB55_4:
	mov	x0, #0
	ret
LBB55_5:
	ldr	x0, [x9]
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_find_symbol_address            ; -- Begin function find_symbol_address
	.p2align	2
_find_symbol_address:                   ; @find_symbol_address
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
	ldr	x20, [x0, #8]
	cbz	x20, LBB56_4
; %bb.1:
	mov	x19, x1
	ldr	x8, [x0]
	add	x21, x8, #8
LBB56_2:                                ; =>This Inner Loop Header: Depth=1
	ldur	x0, [x21, #-8]
	mov	x1, x19
	bl	_strcmp
	cbz	w0, LBB56_5
; %bb.3:                                ;   in Loop: Header=BB56_2 Depth=1
	add	x21, x21, #24
	subs	x20, x20, #1
	b.ne	LBB56_2
LBB56_4:
	mov	x0, #-1
	b	LBB56_6
LBB56_5:
	ldr	x0, [x21]
LBB56_6:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_find_symbol                    ; -- Begin function find_symbol
	.p2align	2
_find_symbol:                           ; @find_symbol
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
	mov	x19, x8
	ldr	x21, [x0, #8]
	cbz	x21, LBB57_4
; %bb.1:
	mov	x20, x1
	ldr	x22, [x0]
LBB57_2:                                ; =>This Inner Loop Header: Depth=1
	ldr	x0, [x22]
	mov	x1, x20
	bl	_strcmp
	cbz	w0, LBB57_5
; %bb.3:                                ;   in Loop: Header=BB57_2 Depth=1
	add	x22, x22, #24
	subs	x21, x21, #1
	b.ne	LBB57_2
LBB57_4:
	mov	x8, #-1
	stp	xzr, x8, [x19]
	str	xzr, [x19, #16]
	b	LBB57_6
LBB57_5:
	ldr	q0, [x22]
	str	q0, [x19]
	ldr	x8, [x22, #16]
	str	x8, [x19, #16]
LBB57_6:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_pack_symbol_table              ; -- Begin function pack_symbol_table
	.p2align	2
_pack_symbol_table:                     ; @pack_symbol_table
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #128
	.cfi_def_cfa_offset 128
	stp	x28, x27, [sp, #32]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #48]             ; 16-byte Folded Spill
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
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	mov	x19, x0
	mov	x20, x8
	ldr	x23, [x0, #8]
	cbz	x23, LBB58_3
; %bb.1:
	ldr	x8, [x19]
	cmp	x23, #8
	b.hs	LBB58_4
; %bb.2:
	mov	x9, #0
	mov	x10, #0
	b	LBB58_7
LBB58_3:
	mov	x10, #0
	b	LBB58_9
LBB58_4:
	and	x9, x23, #0xfffffffffffffff8
	add	x10, x8, #116
	movi.2d	v0, #0000000000000000
	movi.2s	v1, #1
	mov	x11, x9
	movi.2d	v2, #0000000000000000
	movi.2d	v3, #0000000000000000
	movi.2d	v4, #0000000000000000
LBB58_5:                                ; =>This Inner Loop Header: Depth=1
	sub	x12, x10, #72
	sub	x13, x10, #24
	add	x14, x10, #24
	add	x15, x10, #72
	ldur	w16, [x10, #-96]
	fmov	s5, w16
	ld1.s	{ v5 }[1], [x12]
	ldur	w12, [x10, #-48]
	fmov	s6, w12
	ld1.s	{ v6 }[1], [x13]
	ldr	s7, [x10]
	ld1.s	{ v7 }[1], [x14]
	ldr	s16, [x10, #48]
	ld1.s	{ v16 }[1], [x15]
	and.8b	v5, v5, v1
	and.8b	v6, v6, v1
	and.8b	v7, v7, v1
	and.8b	v16, v16, v1
	uaddw.2d	v0, v0, v5
	uaddw.2d	v2, v2, v6
	uaddw.2d	v3, v3, v7
	uaddw.2d	v4, v4, v16
	add	x10, x10, #192
	subs	x11, x11, #8
	b.ne	LBB58_5
; %bb.6:
	add.2d	v0, v2, v0
	add.2d	v0, v3, v0
	add.2d	v0, v4, v0
	addp.2d	d0, v0
	fmov	x10, d0
	cmp	x23, x9
	b.eq	LBB58_9
LBB58_7:
	sub	x11, x23, x9
	mov	w12, #24
	madd	x8, x9, x12, x8
	add	x8, x8, #20
LBB58_8:                                ; =>This Inner Loop Header: Depth=1
	ldr	w9, [x8], #24
	and	x9, x9, #0x1
	add	x10, x10, x9
	subs	x11, x11, #1
	b.ne	LBB58_8
LBB58_9:
	str	x10, [sp, #24]
	mov	w8, #256
	str	x8, [x20, #16]
	mov	w0, #256
	bl	_malloc
	str	x0, [x20]
	cbz	x0, LBB58_32
; %bb.10:
	mov	x21, x0
	ldr	x8, [sp, #24]
	str	x8, [x0]
	mov	w8, #8
	str	x8, [x20, #8]
	cbz	x23, LBB58_29
; %bb.11:
	mov	x25, #0
	mov	w26, #256
	mov	w24, #8
	mov	w27, #24
	mov	w22, #256
	b	LBB58_15
LBB58_12:                               ;   in Loop: Header=BB58_15 Depth=1
	mov	x0, x21
	mov	x1, x22
	bl	_realloc
	mov	x21, x0
	str	x0, [x20]
	cbz	x0, LBB58_30
LBB58_13:                               ;   in Loop: Header=BB58_15 Depth=1
	ldr	x8, [sp, #8]
	str	x8, [x21, x23]
	str	x24, [x20, #8]
	ldr	x23, [x19, #8]
LBB58_14:                               ;   in Loop: Header=BB58_15 Depth=1
	add	x25, x25, #1
	cmp	x25, x23
	b.hs	LBB58_29
LBB58_15:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB58_20 Depth 2
                                        ;     Child Loop BB58_27 Depth 2
	ldr	x8, [x19]
	madd	x8, x25, x27, x8
	ldr	x9, [x8, #16]
	str	x9, [sp, #16]
	ldr	q0, [x8]
	str	q0, [sp]
	ubfx	x8, x9, #32, #8
	tbz	w8, #0, LBB58_14
; %bb.16:                               ;   in Loop: Header=BB58_15 Depth=1
	ldr	x23, [sp]
	mov	x0, x23
	bl	_strlen
	add	x28, x24, #1
	add	x8, x28, x0
	cmp	x8, x22
	b.ls	LBB58_23
; %bb.17:                               ;   in Loop: Header=BB58_15 Depth=1
	cbz	x22, LBB58_19
; %bb.18:                               ;   in Loop: Header=BB58_15 Depth=1
	cmp	x8, x22
	b.hi	LBB58_20
	b	LBB58_22
LBB58_19:                               ;   in Loop: Header=BB58_15 Depth=1
	str	x26, [x20, #16]
	mov	w22, #256
	cmp	x8, x22
	b.ls	LBB58_22
LBB58_20:                               ;   Parent Loop BB58_15 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	x22, x22, #1
	cmp	x8, x22
	b.hi	LBB58_20
; %bb.21:                               ;   in Loop: Header=BB58_15 Depth=1
	str	x22, [x20, #16]
LBB58_22:                               ;   in Loop: Header=BB58_15 Depth=1
	mov	x0, x21
	mov	x1, x22
	bl	_realloc
	mov	x21, x0
	str	x0, [x20]
	cbz	x0, LBB58_31
LBB58_23:                               ;   in Loop: Header=BB58_15 Depth=1
	add	x24, x21, x24
	mov	x0, x23
	bl	_strlen
	add	x2, x0, #1
	mov	x0, x24
	mov	x1, x23
	bl	_memcpy
	mov	x0, x23
	bl	_strlen
	add	x23, x28, x0
	str	x23, [x20, #8]
	add	x24, x23, #8
	cmp	x24, x22
	b.ls	LBB58_13
; %bb.24:                               ;   in Loop: Header=BB58_15 Depth=1
	cbz	x22, LBB58_26
; %bb.25:                               ;   in Loop: Header=BB58_15 Depth=1
	cmp	x24, x22
	b.hi	LBB58_27
	b	LBB58_12
LBB58_26:                               ;   in Loop: Header=BB58_15 Depth=1
	str	x26, [x20, #16]
	mov	w22, #256
	cmp	x24, x22
	b.ls	LBB58_12
LBB58_27:                               ;   Parent Loop BB58_15 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	x22, x22, #1
	cmp	x24, x22
	b.hi	LBB58_27
; %bb.28:                               ;   in Loop: Header=BB58_15 Depth=1
	str	x22, [x20, #16]
	b	LBB58_12
LBB58_29:
	ldp	x29, x30, [sp, #112]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #96]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #80]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #64]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #48]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #128
	ret
LBB58_30:
	bl	_pack_symbol_table.cold.3
LBB58_31:
	bl	_pack_symbol_table.cold.2
LBB58_32:
	bl	_pack_symbol_table.cold.1
	.cfi_endproc
                                        ; -- End function
	.globl	_pack_relocation_table          ; -- Begin function pack_relocation_table
	.p2align	2
_pack_relocation_table:                 ; @pack_relocation_table
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #128
	.cfi_def_cfa_offset 128
	stp	x28, x27, [sp, #32]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #48]             ; 16-byte Folded Spill
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
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	mov	x19, x0
	mov	x20, x8
	mov	w8, #256
	str	x8, [x20, #16]
	mov	w0, #256
	bl	_malloc
	str	x0, [x20]
	cbz	x0, LBB59_29
; %bb.1:
	mov	x21, x0
	ldr	x8, [x19, #8]
	str	x8, [x0]
	mov	w9, #8
	str	x9, [x20, #8]
	cbz	x8, LBB59_25
; %bb.2:
	mov	x25, #0
	mov	w26, #256
	mov	w24, #8
	mov	w27, #24
	mov	w22, #256
	b	LBB59_5
LBB59_3:                                ;   in Loop: Header=BB59_5 Depth=1
	mov	x0, x21
	mov	x1, x22
	bl	_realloc
	mov	x21, x0
	str	x0, [x20]
	cbz	x0, LBB59_26
LBB59_4:                                ;   in Loop: Header=BB59_5 Depth=1
	ldr	w8, [sp, #16]
	str	w8, [x21, x23]
	str	x24, [x20, #8]
	add	x25, x25, #1
	ldr	x8, [x19, #8]
	cmp	x25, x8
	b.hs	LBB59_25
LBB59_5:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB59_9 Depth 2
                                        ;     Child Loop BB59_16 Depth 2
                                        ;     Child Loop BB59_23 Depth 2
	ldr	x8, [x19]
	madd	x8, x25, x27, x8
	ldr	q0, [x8]
	str	q0, [sp]
	ldr	x8, [x8, #16]
	str	x8, [sp, #16]
	ldr	x23, [sp]
	mov	x0, x23
	bl	_strlen
	add	x28, x24, #1
	add	x8, x28, x0
	cmp	x8, x22
	b.ls	LBB59_12
; %bb.6:                                ;   in Loop: Header=BB59_5 Depth=1
	cbz	x22, LBB59_8
; %bb.7:                                ;   in Loop: Header=BB59_5 Depth=1
	cmp	x8, x22
	b.hi	LBB59_9
	b	LBB59_11
LBB59_8:                                ;   in Loop: Header=BB59_5 Depth=1
	str	x26, [x20, #16]
	mov	w22, #256
	cmp	x8, x22
	b.ls	LBB59_11
LBB59_9:                                ;   Parent Loop BB59_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	x22, x22, #1
	cmp	x8, x22
	b.hi	LBB59_9
; %bb.10:                               ;   in Loop: Header=BB59_5 Depth=1
	str	x22, [x20, #16]
LBB59_11:                               ;   in Loop: Header=BB59_5 Depth=1
	mov	x0, x21
	mov	x1, x22
	bl	_realloc
	mov	x21, x0
	str	x0, [x20]
	cbz	x0, LBB59_27
LBB59_12:                               ;   in Loop: Header=BB59_5 Depth=1
	add	x24, x21, x24
	mov	x0, x23
	bl	_strlen
	add	x2, x0, #1
	mov	x0, x24
	mov	x1, x23
	bl	_memcpy
	mov	x0, x23
	bl	_strlen
	add	x24, x28, x0
	str	x24, [x20, #8]
	add	x23, x24, #8
	cmp	x23, x22
	b.ls	LBB59_19
; %bb.13:                               ;   in Loop: Header=BB59_5 Depth=1
	cbz	x22, LBB59_15
; %bb.14:                               ;   in Loop: Header=BB59_5 Depth=1
	cmp	x23, x22
	b.hi	LBB59_16
	b	LBB59_18
LBB59_15:                               ;   in Loop: Header=BB59_5 Depth=1
	str	x26, [x20, #16]
	mov	w22, #256
	cmp	x23, x22
	b.ls	LBB59_18
LBB59_16:                               ;   Parent Loop BB59_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	x22, x22, #1
	cmp	x23, x22
	b.hi	LBB59_16
; %bb.17:                               ;   in Loop: Header=BB59_5 Depth=1
	str	x22, [x20, #16]
LBB59_18:                               ;   in Loop: Header=BB59_5 Depth=1
	mov	x0, x21
	mov	x1, x22
	bl	_realloc
	mov	x21, x0
	str	x0, [x20]
	cbz	x0, LBB59_28
LBB59_19:                               ;   in Loop: Header=BB59_5 Depth=1
	ldr	x8, [sp, #8]
	str	x8, [x21, x24]
	str	x23, [x20, #8]
	add	x24, x24, #12
	cmp	x24, x22
	b.ls	LBB59_4
; %bb.20:                               ;   in Loop: Header=BB59_5 Depth=1
	cbz	x22, LBB59_22
; %bb.21:                               ;   in Loop: Header=BB59_5 Depth=1
	cmp	x24, x22
	b.hi	LBB59_23
	b	LBB59_3
LBB59_22:                               ;   in Loop: Header=BB59_5 Depth=1
	str	x26, [x20, #16]
	mov	w22, #256
	cmp	x24, x22
	b.ls	LBB59_3
LBB59_23:                               ;   Parent Loop BB59_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	x22, x22, #1
	cmp	x24, x22
	b.hi	LBB59_23
; %bb.24:                               ;   in Loop: Header=BB59_5 Depth=1
	str	x22, [x20, #16]
	b	LBB59_3
LBB59_25:
	ldp	x29, x30, [sp, #112]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #96]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #80]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #64]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #48]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #128
	ret
LBB59_26:
	bl	_pack_relocation_table.cold.4
LBB59_27:
	bl	_pack_relocation_table.cold.2
LBB59_28:
	bl	_pack_relocation_table.cold.3
LBB59_29:
	bl	_pack_relocation_table.cold.1
	.cfi_endproc
                                        ; -- End function
	.globl	_relocate                       ; -- Begin function relocate
	.p2align	2
_relocate:                              ; @relocate
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #128
	.cfi_def_cfa_offset 128
	stp	x28, x27, [sp, #32]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #48]             ; 16-byte Folded Spill
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
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	ldr	x8, [x2, #8]
	cbz	x8, LBB60_21
; %bb.1:
	mov	x19, x3
	mov	x20, x2
	mov	x21, x1
	mov	x23, #0
	mov	w24, #24
	b	LBB60_4
LBB60_2:                                ;   in Loop: Header=BB60_4 Depth=1
	str	w8, [x9]
LBB60_3:                                ;   in Loop: Header=BB60_4 Depth=1
	add	x23, x23, #1
	ldr	x8, [x20, #8]
	cmp	x23, x8
	b.hs	LBB60_21
LBB60_4:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB60_6 Depth 2
	ldr	x8, [x20]
	madd	x8, x23, x24, x8
	ldp	x22, x26, [x8]
	ldr	w27, [x8, #16]
	ldr	x28, [x19, #8]
	cbz	x28, LBB60_13
; %bb.5:                                ;   in Loop: Header=BB60_4 Depth=1
	ldr	x8, [x19]
	add	x25, x8, #8
LBB60_6:                                ;   Parent Loop BB60_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldur	x0, [x25, #-8]
	mov	x1, x22
	bl	_strcmp
	cbz	w0, LBB60_8
; %bb.7:                                ;   in Loop: Header=BB60_6 Depth=2
	add	x25, x25, #24
	subs	x28, x28, #1
	b.ne	LBB60_6
	b	LBB60_13
LBB60_8:                                ;   in Loop: Header=BB60_4 Depth=1
	ldr	x8, [x25]
	cmn	x8, #1
	b.eq	LBB60_13
; %bb.9:                                ;   in Loop: Header=BB60_4 Depth=1
	cmp	w27, #2
	b.eq	LBB60_15
; %bb.10:                               ;   in Loop: Header=BB60_4 Depth=1
	cmp	w27, #1
	b.eq	LBB60_18
; %bb.11:                               ;   in Loop: Header=BB60_4 Depth=1
	cbnz	w27, LBB60_3
; %bb.12:                               ;   in Loop: Header=BB60_4 Depth=1
	str	x8, [x21, x26]
	b	LBB60_3
LBB60_13:                               ;   in Loop: Header=BB60_4 Depth=1
	cbnz	w27, LBB60_22
; %bb.14:                               ;   in Loop: Header=BB60_4 Depth=1
	ldr	x8, [x21, x26]
	add	x8, x8, x21
	str	x8, [x21, x26]
	b	LBB60_3
LBB60_15:                               ;   in Loop: Header=BB60_4 Depth=1
	add	x9, x21, x26
	sub	w11, w8, w9
	tst	w11, #0x3
	b.ne	LBB60_24
; %bb.16:                               ;   in Loop: Header=BB60_4 Depth=1
	asr	w10, w11, #2
	sub	w11, w11, #512, lsl #12         ; =2097152
	lsr	w11, w11, #22
	cmp	w11, #1022
	b.ls	LBB60_25
; %bb.17:                               ;   in Loop: Header=BB60_4 Depth=1
	ldr	w8, [x9]
	bfi	w8, w10, #12, #20
	b	LBB60_2
LBB60_18:                               ;   in Loop: Header=BB60_4 Depth=1
	add	x9, x21, x26
	sub	w11, w8, w9
	tst	w11, #0x3
	b.ne	LBB60_24
; %bb.19:                               ;   in Loop: Header=BB60_4 Depth=1
	asr	w10, w11, #2
	mov	w12, #-67108864
	add	w11, w11, w12
	lsr	w11, w11, #27
	cmp	w11, #30
	b.ls	LBB60_25
; %bb.20:                               ;   in Loop: Header=BB60_4 Depth=1
	ldr	w8, [x9]
	bfi	w8, w10, #7, #25
	b	LBB60_2
LBB60_21:
	ldp	x29, x30, [sp, #112]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #96]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #80]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #64]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #48]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #128
	ret
LBB60_22:
Lloh409:
	adrp	x8, ___stderrp@GOTPAGE
Lloh410:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh411:
	ldr	x0, [x8]
	str	x22, [sp]
Lloh412:
	adrp	x1, l_.str.184@PAGE
Lloh413:
	add	x1, x1, l_.str.184@PAGEOFF
LBB60_23:
	bl	_fprintf
	mov	w0, #1
	bl	_exit
LBB60_24:
Lloh414:
	adrp	x8, ___stderrp@GOTPAGE
Lloh415:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh416:
	ldr	x3, [x8]
Lloh417:
	adrp	x0, l_.str.185@PAGE
Lloh418:
	add	x0, x0, l_.str.185@PAGEOFF
	mov	w1, #28
	mov	w2, #1
	bl	_fwrite
	mov	w0, #1
	bl	_exit
LBB60_25:
Lloh419:
	adrp	x11, ___stderrp@GOTPAGE
Lloh420:
	ldr	x11, [x11, ___stderrp@GOTPAGEOFF]
Lloh421:
	ldr	x0, [x11]
	stp	x9, x8, [sp, #8]
	str	x10, [sp]
Lloh422:
	adrp	x1, l_.str.186@PAGE
Lloh423:
	add	x1, x1, l_.str.186@PAGEOFF
	b	LBB60_23
	.loh AdrpAdd	Lloh412, Lloh413
	.loh AdrpLdrGotLdr	Lloh409, Lloh410, Lloh411
	.loh AdrpAdd	Lloh417, Lloh418
	.loh AdrpLdrGotLdr	Lloh414, Lloh415, Lloh416
	.loh AdrpAdd	Lloh422, Lloh423
	.loh AdrpLdrGotLdr	Lloh419, Lloh420, Lloh421
	.cfi_endproc
                                        ; -- End function
	.globl	_main                           ; -- Begin function main
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
	mov	w9, #1200
	movk	w9, #16, lsl #16
Lloh424:
	adrp	x16, ___chkstk_darwin@GOTPAGE
Lloh425:
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	sp, sp, #256, lsl #12           ; =1048576
	sub	sp, sp, #1200
	mov	x25, x1
Lloh426:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh427:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh428:
	ldr	x8, [x8]
	stur	x8, [x29, #-96]
	cmp	w0, #2
	b.gt	LBB61_5
; %bb.1:
Lloh429:
	adrp	x19, ___stderrp@GOTPAGE
Lloh430:
	ldr	x19, [x19, ___stderrp@GOTPAGEOFF]
	ldr	x0, [x19]
	ldr	x8, [x25]
	str	x8, [sp]
Lloh431:
	adrp	x1, l_.str.187@PAGE
Lloh432:
	add	x1, x1, l_.str.187@PAGEOFF
	bl	_fprintf
	ldr	x0, [x19]
	ldr	x8, [x25]
	str	x8, [sp]
Lloh433:
	adrp	x1, l_.str.188@PAGE
Lloh434:
	add	x1, x1, l_.str.188@PAGEOFF
LBB61_2:
	bl	_fprintf
	mov	w19, #1
LBB61_3:
	ldur	x8, [x29, #-96]
Lloh435:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh436:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh437:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB61_114
; %bb.4:
	mov	x0, x19
	add	sp, sp, #256, lsl #12           ; =1048576
	add	sp, sp, #1200
	ldp	x29, x30, [sp, #80]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #64]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #48]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #32]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #16]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp], #96             ; 16-byte Folded Reload
	ret
LBB61_5:
	mov	x21, x0
	ldr	x20, [x25, #8]
Lloh438:
	adrp	x1, l_.str.189@PAGE
Lloh439:
	add	x1, x1, l_.str.189@PAGEOFF
	mov	x0, x20
	bl	_strcmp
	cbz	w0, LBB61_45
; %bb.6:
Lloh440:
	adrp	x1, l_.str.195@PAGE
Lloh441:
	add	x1, x1, l_.str.195@PAGEOFF
	mov	x0, x20
	bl	_strcmp
	cbz	w0, LBB61_9
; %bb.7:
Lloh442:
	adrp	x1, l_.str.196@PAGE
Lloh443:
	add	x1, x1, l_.str.196@PAGEOFF
	mov	x0, x20
	bl	_strcmp
	cbz	w0, LBB61_9
; %bb.8:
Lloh444:
	adrp	x8, ___stderrp@GOTPAGE
Lloh445:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh446:
	ldr	x0, [x8]
	str	x20, [sp]
Lloh447:
	adrp	x1, l_.str.201@PAGE
Lloh448:
	add	x1, x1, l_.str.201@PAGEOFF
	b	LBB61_2
LBB61_9:
	ldr	x0, [x25, #16]
Lloh449:
	adrp	x1, l_.str.53@PAGE
Lloh450:
	add	x1, x1, l_.str.53@PAGEOFF
	bl	_fopen
	cbz	x0, LBB61_76
; %bb.10:
	mov	x20, x0
	add	x8, sp, #1160
	bl	_get_all_files
	mov	x0, x20
	bl	_fclose
	ldr	x8, [sp, #1168]
	str	x8, [sp, #32]                   ; 8-byte Folded Spill
	cbz	x8, LBB61_86
; %bb.11:
	str	x25, [sp, #16]                  ; 8-byte Folded Spill
	mov	x26, #0
	ldr	x23, [sp, #1160]
	mov	w22, #24
                                        ; implicit-def: $x20
                                        ; implicit-def: $x28
                                        ; implicit-def: $x25
	str	x23, [sp, #24]                  ; 8-byte Folded Spill
	b	LBB61_13
LBB61_12:                               ;   in Loop: Header=BB61_13 Depth=1
	madd	x0, x28, x22, x20
	add	x8, x27, x27, lsl #1
	lsl	x2, x8, #3
	mov	x1, x21
	bl	_memcpy
	add	x26, x26, #1
	mov	x28, x19
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	cmp	x26, x8
	b.eq	LBB61_57
LBB61_13:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB61_15 Depth 2
                                        ;     Child Loop BB61_23 Depth 2
                                        ;     Child Loop BB61_27 Depth 2
                                        ;     Child Loop BB61_36 Depth 2
                                        ;     Child Loop BB61_39 Depth 2
                                        ;     Child Loop BB61_42 Depth 2
	add	x24, x23, x26, lsl #5
	ldr	x19, [x24, #16]
	cbz	x19, LBB61_19
; %bb.14:                               ;   in Loop: Header=BB61_13 Depth=1
	ldr	x22, [x24, #8]
	add	x8, x22, #8
	mov	x9, x19
LBB61_15:                               ;   Parent Loop BB61_13 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldur	w10, [x8, #-8]
	cmp	w10, #2
	b.eq	LBB61_20
; %bb.16:                               ;   in Loop: Header=BB61_15 Depth=2
	add	x8, x8, #16
	subs	x9, x9, #1
	b.ne	LBB61_15
; %bb.17:                               ;   in Loop: Header=BB61_13 Depth=1
	mov	x27, #0
	mov	x21, #0
	cbnz	x19, LBB61_26
LBB61_18:                               ;   in Loop: Header=BB61_13 Depth=1
	mov	x8, #0
	mov	w22, #24
	cbnz	x27, LBB61_31
	b	LBB61_40
LBB61_19:                               ;   in Loop: Header=BB61_13 Depth=1
	mov	x27, #0
	mov	x21, #0
	b	LBB61_40
LBB61_20:                               ;   in Loop: Header=BB61_13 Depth=1
	ldr	x23, [x8]
	cbz	x23, LBB61_44
; %bb.21:                               ;   in Loop: Header=BB61_13 Depth=1
	ldr	x27, [x23]
	add	x8, x27, x27, lsl #1
	lsl	x0, x8, #3
	bl	_malloc
	mov	x21, x0
	cbz	x27, LBB61_25
; %bb.22:                               ;   in Loop: Header=BB61_13 Depth=1
	str	x20, [sp, #40]                  ; 8-byte Folded Spill
	add	x19, x21, #8
	mov	x20, x27
LBB61_23:                               ;   Parent Loop BB61_13 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	x22, x23, #8
	mov	x0, x22
	bl	_strlen
	mov	x23, x0
	bl	_malloc
	stur	x0, [x19, #-8]
	mov	x1, x22
	bl	_strcpy
	add	x23, x23, x22
	ldr	x8, [x23, #1]!
	str	x8, [x19], #24
	subs	x20, x20, #1
	b.ne	LBB61_23
; %bb.24:                               ;   in Loop: Header=BB61_13 Depth=1
	ldp	x22, x19, [x24, #8]
	ldr	x20, [sp, #40]                  ; 8-byte Folded Reload
LBB61_25:                               ;   in Loop: Header=BB61_13 Depth=1
	ldr	x23, [sp, #24]                  ; 8-byte Folded Reload
	cbz	x19, LBB61_18
LBB61_26:                               ;   in Loop: Header=BB61_13 Depth=1
	add	x8, x22, #8
	mov	w22, #24
LBB61_27:                               ;   Parent Loop BB61_13 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldur	w9, [x8, #-8]
	cmp	w9, #1
	b.eq	LBB61_30
; %bb.28:                               ;   in Loop: Header=BB61_27 Depth=2
	add	x8, x8, #16
	subs	x19, x19, #1
	b.ne	LBB61_27
; %bb.29:                               ;   in Loop: Header=BB61_13 Depth=1
	mov	x8, #0
	cbnz	x27, LBB61_31
	b	LBB61_40
LBB61_30:                               ;   in Loop: Header=BB61_13 Depth=1
	ldr	x8, [x8]
	cbz	x27, LBB61_40
LBB61_31:                               ;   in Loop: Header=BB61_13 Depth=1
	cmp	x27, #4
	b.hs	LBB61_33
; %bb.32:                               ;   in Loop: Header=BB61_13 Depth=1
	mov	x9, #0
	b	LBB61_38
LBB61_33:                               ;   in Loop: Header=BB61_13 Depth=1
	mov	x9, #0
	sub	x11, x27, #1
	add	x12, x21, #8
	umulh	x10, x11, x22
	cmp	xzr, x10
	cset	w10, ne
	madd	x11, x11, x22, x12
	cmp	x11, x12
	b.lo	LBB61_38
; %bb.34:                               ;   in Loop: Header=BB61_13 Depth=1
	tbnz	w10, #0, LBB61_38
; %bb.35:                               ;   in Loop: Header=BB61_13 Depth=1
	and	x9, x27, #0xfffffffffffffffc
	add	x10, x21, #56
	mov	x11, x9
LBB61_36:                               ;   Parent Loop BB61_13 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldur	x12, [x10, #-48]
	ldur	x13, [x10, #-24]
	ldr	x14, [x10]
	ldr	x15, [x10, #24]
	add	x12, x12, x8
	add	x13, x13, x8
	add	x14, x14, x8
	add	x15, x15, x8
	stur	x12, [x10, #-48]
	stur	x13, [x10, #-24]
	str	x14, [x10]
	str	x15, [x10, #24]
	add	x10, x10, #96
	subs	x11, x11, #4
	b.ne	LBB61_36
; %bb.37:                               ;   in Loop: Header=BB61_13 Depth=1
	cmp	x27, x9
	b.eq	LBB61_40
LBB61_38:                               ;   in Loop: Header=BB61_13 Depth=1
	mov	x10, #8
	madd	x10, x9, x22, x10
LBB61_39:                               ;   Parent Loop BB61_13 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	x11, [x21, x10]
	add	x11, x11, x8
	str	x11, [x21, x10]
	add	x9, x9, #1
	add	x10, x10, #24
	cmp	x27, x9
	b.ne	LBB61_39
LBB61_40:                               ;   in Loop: Header=BB61_13 Depth=1
	add	x19, x27, x28
	cmp	x19, x25
	b.ls	LBB61_12
; %bb.41:                               ;   in Loop: Header=BB61_13 Depth=1
	cmp	x25, #0
	mov	w8, #256
	csel	x8, x8, x25, eq
LBB61_42:                               ;   Parent Loop BB61_13 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x25, x8
	lsl	x8, x8, #1
	cmp	x19, x25
	b.hi	LBB61_42
; %bb.43:                               ;   in Loop: Header=BB61_13 Depth=1
	add	x8, x25, x25, lsl #1
	lsl	x1, x8, #3
	mov	x0, x20
	bl	_realloc
	mov	x20, x0
	cbnz	x0, LBB61_12
	b	LBB61_111
LBB61_44:                               ;   in Loop: Header=BB61_13 Depth=1
	mov	x27, #0
	mov	x21, #0
	ldr	x23, [sp, #24]                  ; 8-byte Folded Reload
	cbnz	x19, LBB61_26
	b	LBB61_18
LBB61_45:
	cmp	w21, #4
	b.hs	LBB61_47
; %bb.46:
Lloh451:
	adrp	x8, ___stderrp@GOTPAGE
Lloh452:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh453:
	ldr	x0, [x8]
	ldr	x8, [x25]
	str	x8, [sp]
Lloh454:
	adrp	x1, l_.str.190@PAGE
Lloh455:
	add	x1, x1, l_.str.190@PAGEOFF
	b	LBB61_2
LBB61_47:
	cmp	w21, #4
	b.ne	LBB61_77
; %bb.48:
	mov	x19, #0
	mov	x20, #0
LBB61_49:
	str	xzr, [sp, #584]
	str	xzr, [sp, #576]
	str	xzr, [sp, #592]
	stp	xzr, xzr, [sp, #48]
	str	xzr, [sp, #64]
	ldr	x0, [x25, #16]
	add	x8, sp, #1160
	add	x1, sp, #576
	add	x2, sp, #48
	bl	_run_compile
	ldr	x22, [sp, #1160]
	cbz	x22, LBB61_96
; %bb.50:
	mov	x28, x25
	ldr	x23, [sp, #1168]
	ldr	q0, [sp, #576]
	str	q0, [sp, #1184]
	ldr	x8, [sp, #592]
	str	x8, [sp, #1200]
	add	x8, sp, #1136
	add	x0, sp, #1184
	bl	_pack_symbol_table
	ldr	q0, [sp, #48]
	str	q0, [sp, #1184]
	ldr	x8, [sp, #64]
	str	x8, [sp, #1200]
	add	x8, sp, #1112
	add	x0, sp, #1184
	bl	_pack_relocation_table
	ldr	x26, [sp, #1144]
	ldr	x27, [sp, #1136]
	ldr	x24, [sp, #1120]
	ldr	x25, [sp, #1112]
	mov	w0, #4096
	bl	_malloc
	cbz	x0, LBB61_113
; %bb.51:
	mov	x21, x0
	mov	w8, #1
	stp	w8, w23, [x0]
	str	x22, [x0, #8]
	mov	w8, #2
	stp	w8, w26, [x0, #16]
	str	x27, [x0, #24]
	mov	w8, #4
	stp	w8, w24, [x0, #32]
	str	x25, [x0, #40]
	cbz	x19, LBB61_100
; %bb.52:
	mov	w22, #0
	mov	x23, x20
	mov	x24, x19
	mov	x25, x28
LBB61_53:                               ; =>This Inner Loop Header: Depth=1
	ldr	x0, [x23], #8
	bl	_strlen
	add	w8, w22, w0
	add	w22, w8, #1
	subs	x24, x24, #1
	b.ne	LBB61_53
; %bb.54:
	mov	x0, x22
	bl	_malloc
	mov	x23, x0
	cmp	x19, #1
	csinc	x19, x19, xzr, hi
LBB61_55:                               ; =>This Inner Loop Header: Depth=1
	add	x0, x23, x24
	ldr	x1, [x20]
	bl	_strcpy
	ldr	x0, [x20], #8
	bl	_strlen
	add	x8, x24, x0
	add	x24, x8, #1
	subs	x19, x19, #1
	b.ne	LBB61_55
; %bb.56:
	mov	w8, #8
	stp	w8, w22, [x21, #48]
	str	x23, [x21, #56]
	mov	w20, #4
	b	LBB61_101
LBB61_57:
	mov	x26, #0
	ldr	x28, [sp, #1160]
	str	x28, [sp, #24]                  ; 8-byte Folded Spill
	b	LBB61_61
LBB61_58:                               ;   in Loop: Header=BB61_61 Depth=1
	mov	x21, #0
	mov	x20, #0
LBB61_59:                               ;   in Loop: Header=BB61_61 Depth=1
	mov	x1, #0
	mov	x0, #0
LBB61_60:                               ;   in Loop: Header=BB61_61 Depth=1
	str	x21, [sp, #1184]
	str	x20, [sp, #1192]
	str	x20, [sp, #1200]
	ldr	x20, [sp, #40]                  ; 8-byte Folded Reload
	str	x20, [sp, #576]
	str	x19, [sp, #584]
	str	x25, [sp, #592]
	add	x2, sp, #1184
	add	x3, sp, #576
	bl	_relocate
	add	x26, x26, #1
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	cmp	x26, x8
	b.eq	LBB61_75
LBB61_61:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB61_63 Depth 2
                                        ;     Child Loop BB61_68 Depth 2
                                        ;     Child Loop BB61_72 Depth 2
	add	x24, x28, x26, lsl #5
	ldr	x23, [x24, #16]
	str	x20, [sp, #40]                  ; 8-byte Folded Spill
	cbz	x23, LBB61_58
; %bb.62:                               ;   in Loop: Header=BB61_61 Depth=1
	ldr	x22, [x24, #8]
	add	x8, x22, #8
	mov	x9, x23
LBB61_63:                               ;   Parent Loop BB61_61 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldur	w10, [x8, #-8]
	cmp	w10, #4
	b.eq	LBB61_65
; %bb.64:                               ;   in Loop: Header=BB61_63 Depth=2
	add	x8, x8, #16
	subs	x9, x9, #1
	b.ne	LBB61_63
	b	LBB61_70
LBB61_65:                               ;   in Loop: Header=BB61_61 Depth=1
	ldr	x27, [x8]
	cbz	x27, LBB61_70
; %bb.66:                               ;   in Loop: Header=BB61_61 Depth=1
	ldr	x20, [x27]
	add	x8, x20, x20, lsl #1
	lsl	x0, x8, #3
	bl	_malloc
	mov	x21, x0
	cbz	x20, LBB61_71
; %bb.67:                               ;   in Loop: Header=BB61_61 Depth=1
	add	x22, x27, #8
	add	x27, x21, #16
	mov	x28, x20
LBB61_68:                               ;   Parent Loop BB61_61 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x0, x22
	bl	_strlen
	add	x23, x0, #1
	mov	x0, x23
	bl	_malloc
	stur	x0, [x27, #-16]
	mov	x1, x22
	bl	_strcpy
	add	x8, x22, x23
	ldr	x9, [x8]
	stur	x9, [x27, #-8]
	ldr	w9, [x8, #8]
	add	x22, x8, #12
	str	w9, [x27], #24
	subs	x28, x28, #1
	b.ne	LBB61_68
; %bb.69:                               ;   in Loop: Header=BB61_61 Depth=1
	ldp	x22, x23, [x24, #8]
	ldr	x28, [sp, #24]                  ; 8-byte Folded Reload
	b	LBB61_71
LBB61_70:                               ;   in Loop: Header=BB61_61 Depth=1
	mov	x20, #0
	mov	x21, #0
LBB61_71:                               ;   in Loop: Header=BB61_61 Depth=1
	cbz	x23, LBB61_59
LBB61_72:                               ;   Parent Loop BB61_61 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	w8, [x22]
	cmp	w8, #1
	b.eq	LBB61_74
; %bb.73:                               ;   in Loop: Header=BB61_72 Depth=2
	add	x22, x22, #16
	subs	x23, x23, #1
	b.ne	LBB61_72
	b	LBB61_59
LBB61_74:                               ;   in Loop: Header=BB61_61 Depth=1
	ldp	x0, x1, [x22]
	b	LBB61_60
LBB61_75:
	ldr	x25, [sp, #16]                  ; 8-byte Folded Reload
	b	LBB61_87
LBB61_76:
Lloh456:
	adrp	x8, ___stderrp@GOTPAGE
Lloh457:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh458:
	ldr	x0, [x8]
	ldr	x8, [x25, #16]
	str	x8, [sp]
Lloh459:
	adrp	x1, l_.str.197@PAGE
Lloh460:
	add	x1, x1, l_.str.197@PAGEOFF
	b	LBB61_2
LBB61_77:
	mov	x20, #0
	mov	x19, #0
	mov	x22, #0
	mov	w23, #4
	mov	w24, #256
	mov	w21, w21
	b	LBB61_80
LBB61_78:                               ;   in Loop: Header=BB61_80 Depth=1
	ldr	x8, [x25, x23, lsl  #3]
	str	x8, [x20, x19, lsl  #3]
	add	x19, x19, #1
LBB61_79:                               ;   in Loop: Header=BB61_80 Depth=1
	add	x23, x23, #1
	cmp	x23, x21
	b.hs	LBB61_49
LBB61_80:                               ; =>This Inner Loop Header: Depth=1
	ldr	x8, [x25, x23, lsl  #3]
	ldrb	w9, [x8]
	cmp	w9, #45
	b.ne	LBB61_79
; %bb.81:                               ;   in Loop: Header=BB61_80 Depth=1
	ldrb	w8, [x8, #1]
	cmp	w8, #108
	b.ne	LBB61_79
; %bb.82:                               ;   in Loop: Header=BB61_80 Depth=1
	add	x23, x23, #1
	cmp	x23, x21
	b.eq	LBB61_109
; %bb.83:                               ;   in Loop: Header=BB61_80 Depth=1
	cmp	x19, x22
	b.lo	LBB61_78
; %bb.84:                               ;   in Loop: Header=BB61_80 Depth=1
	lsl	x8, x22, #1
	cmp	x22, #0
	csel	x22, x24, x8, eq
	lsl	x1, x22, #3
	mov	x0, x20
	bl	_realloc
	cbz	x0, LBB61_112
; %bb.85:                               ;   in Loop: Header=BB61_80 Depth=1
	mov	x20, x0
	b	LBB61_78
LBB61_86:
                                        ; implicit-def: $x20
                                        ; implicit-def: $x19
LBB61_87:
	ldr	x0, [x25, #8]
Lloh461:
	adrp	x1, l_.str.196@PAGE
Lloh462:
	add	x1, x1, l_.str.196@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB61_92
; %bb.88:
	cbz	x19, LBB61_99
; %bb.89:
	add	x21, x20, #8
Lloh463:
	adrp	x20, l_.str.199@PAGE
Lloh464:
	add	x20, x20, l_.str.199@PAGEOFF
LBB61_90:                               ; =>This Inner Loop Header: Depth=1
	ldur	x0, [x21, #-8]
	mov	x1, x20
	bl	_strcmp
	cbz	w0, LBB61_97
; %bb.91:                               ;   in Loop: Header=BB61_90 Depth=1
	add	x21, x21, #24
	subs	x19, x19, #1
	b.ne	LBB61_90
	b	LBB61_99
LBB61_92:
	ldr	x8, [sp, #1160]
	ldr	x9, [x8, #16]
	cbz	x9, LBB61_102
; %bb.93:
	ldr	x8, [x8, #8]
LBB61_94:                               ; =>This Inner Loop Header: Depth=1
	ldr	w10, [x8]
	cmp	w10, #1
	b.eq	LBB61_103
; %bb.95:                               ;   in Loop: Header=BB61_94 Depth=1
	add	x8, x8, #16
	subs	x9, x9, #1
	b.ne	LBB61_94
	b	LBB61_102
LBB61_96:
Lloh465:
	adrp	x8, ___stderrp@GOTPAGE
Lloh466:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh467:
	ldr	x3, [x8]
Lloh468:
	adrp	x0, l_.str.193@PAGE
Lloh469:
	add	x0, x0, l_.str.193@PAGEOFF
	mov	w19, #1
	mov	w1, #19
	b	LBB61_110
LBB61_97:
	ldr	x8, [x21]
	cmn	x8, #1
	b.eq	LBB61_99
; %bb.98:
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [sp, #256]
	add	x9, sp, #1184
	add	x9, x9, #256, lsl #12           ; =1048576
	stp	q0, q0, [sp, #224]
	stp	q0, q0, [sp, #192]
	stp	q0, q0, [sp, #160]
	stp	q0, q0, [sp, #128]
	stp	q0, q0, [sp, #96]
	stp	q0, q0, [sp, #64]
	str	q0, [sp, #48]
	stp	x9, x8, [sp, #288]
	stp	q0, q0, [sp, #304]
	stp	q0, q0, [sp, #336]
	stp	q0, q0, [sp, #368]
	stp	q0, q0, [sp, #400]
	stp	q0, q0, [sp, #432]
	stp	q0, q0, [sp, #464]
	stp	q0, q0, [sp, #496]
	stp	q0, q0, [sp, #528]
	str	q0, [sp, #560]
	add	x8, sp, #576
	add	x0, sp, #48
	bl	_exec
	ldr	w19, [sp, #576]
	b	LBB61_3
LBB61_99:
Lloh470:
	adrp	x8, ___stderrp@GOTPAGE
Lloh471:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh472:
	ldr	x3, [x8]
Lloh473:
	adrp	x0, l_.str.200@PAGE
Lloh474:
	add	x0, x0, l_.str.200@PAGEOFF
	mov	w19, #1
	mov	w1, #29
	mov	w2, #1
	bl	_fwrite
	b	LBB61_3
LBB61_100:
	mov	w20, #3
	mov	x25, x28
LBB61_101:
	ldr	x0, [x25, #24]
Lloh475:
	adrp	x1, l_.str.34@PAGE
Lloh476:
	add	x1, x1, l_.str.34@PAGEOFF
	bl	_fopen
	mov	x19, x0
	mov	w8, #61453
	movk	w8, #65261, lsl #16
	str	w8, [sp, #1184]
	str	x21, [sp, #1192]
	str	x20, [sp, #1200]
	mov	w8, #256
	str	x8, [sp, #1208]
	add	x0, sp, #1184
	mov	x1, x19
	bl	_write_hive_file
	mov	x0, x19
	bl	_fclose
LBB61_102:
	mov	w19, #0
	b	LBB61_3
LBB61_103:
	ldr	x9, [x8]
	lsr	x9, x9, #32
	cbz	x9, LBB61_102
; %bb.104:
	mov	x23, #0
	ldr	x24, [x8, #8]
	add	x25, x24, x9
Lloh477:
	adrp	x19, l_.str.176@PAGE
Lloh478:
	add	x19, x19, l_.str.176@PAGEOFF
Lloh479:
	adrp	x20, l_.str.177@PAGE
Lloh480:
	add	x20, x20, l_.str.177@PAGEOFF
	b	LBB61_107
LBB61_105:                              ;   in Loop: Header=BB61_107 Depth=1
	mov	x0, x22
	bl	_puts
	mov	x0, x22
	bl	_free
LBB61_106:                              ;   in Loop: Header=BB61_107 Depth=1
	add	x23, x23, #4
	add	x8, x24, x23
	cmp	x8, x25
	b.hs	LBB61_102
LBB61_107:                              ; =>This Inner Loop Header: Depth=1
	ldr	w21, [x24, x23]
	mov	x0, x21
	bl	_dis
	mov	x22, x0
	stp	x23, x21, [sp]
	mov	x0, x19
	bl	_printf
	cbnz	x22, LBB61_105
; %bb.108:                              ;   in Loop: Header=BB61_107 Depth=1
                                        ; kill: def $w21 killed $w21 killed $x21 def $x21
	str	x21, [sp]
	mov	x0, x20
	bl	_printf
	b	LBB61_106
LBB61_109:
Lloh481:
	adrp	x8, ___stderrp@GOTPAGE
Lloh482:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh483:
	ldr	x3, [x8]
Lloh484:
	adrp	x0, l_.str.191@PAGE
Lloh485:
	add	x0, x0, l_.str.191@PAGEOFF
	mov	w19, #1
	mov	w1, #25
LBB61_110:
	mov	w2, #1
	bl	_fwrite
                                        ; kill: def $w19 killed $w19 killed $x19 def $x19
	b	LBB61_3
LBB61_111:
	bl	_main.cold.3
LBB61_112:
	bl	_main.cold.2
LBB61_113:
	bl	_main.cold.1
LBB61_114:
	bl	___stack_chk_fail
	.loh AdrpLdrGotLdr	Lloh426, Lloh427, Lloh428
	.loh AdrpLdrGot	Lloh424, Lloh425
	.loh AdrpAdd	Lloh433, Lloh434
	.loh AdrpAdd	Lloh431, Lloh432
	.loh AdrpLdrGot	Lloh429, Lloh430
	.loh AdrpLdrGotLdr	Lloh435, Lloh436, Lloh437
	.loh AdrpAdd	Lloh438, Lloh439
	.loh AdrpAdd	Lloh440, Lloh441
	.loh AdrpAdd	Lloh442, Lloh443
	.loh AdrpAdd	Lloh447, Lloh448
	.loh AdrpLdrGotLdr	Lloh444, Lloh445, Lloh446
	.loh AdrpAdd	Lloh449, Lloh450
	.loh AdrpAdd	Lloh454, Lloh455
	.loh AdrpLdrGotLdr	Lloh451, Lloh452, Lloh453
	.loh AdrpAdd	Lloh459, Lloh460
	.loh AdrpLdrGotLdr	Lloh456, Lloh457, Lloh458
	.loh AdrpAdd	Lloh461, Lloh462
	.loh AdrpAdd	Lloh463, Lloh464
	.loh AdrpAdd	Lloh468, Lloh469
	.loh AdrpLdrGotLdr	Lloh465, Lloh466, Lloh467
	.loh AdrpAdd	Lloh473, Lloh474
	.loh AdrpLdrGotLdr	Lloh470, Lloh471, Lloh472
	.loh AdrpAdd	Lloh475, Lloh476
	.loh AdrpAdd	Lloh479, Lloh480
	.loh AdrpAdd	Lloh477, Lloh478
	.loh AdrpAdd	Lloh484, Lloh485
	.loh AdrpLdrGotLdr	Lloh481, Lloh482, Lloh483
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_log.cold.1
_nob_log.cold.1:                        ; @nob_log.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh486:
	adrp	x0, l___func__.nob_log@PAGE
Lloh487:
	add	x0, x0, l___func__.nob_log@PAGEOFF
Lloh488:
	adrp	x1, l_.str.5@PAGE
Lloh489:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh490:
	adrp	x3, l_.str.22@PAGE
Lloh491:
	add	x3, x3, l_.str.22@PAGEOFF
	mov	w2, #644
	bl	___assert_rtn
	.loh AdrpAdd	Lloh490, Lloh491
	.loh AdrpAdd	Lloh488, Lloh489
	.loh AdrpAdd	Lloh486, Lloh487
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_copy_file.cold.1
_nob_copy_file.cold.1:                  ; @nob_copy_file.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh492:
	adrp	x0, l___func__.nob_copy_file@PAGE
Lloh493:
	add	x0, x0, l___func__.nob_copy_file@PAGEOFF
Lloh494:
	adrp	x1, l_.str.5@PAGE
Lloh495:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh496:
	adrp	x3, l_.str.6@PAGE
Lloh497:
	add	x3, x3, l_.str.6@PAGEOFF
	mov	w2, #414
	bl	___assert_rtn
	.loh AdrpAdd	Lloh496, Lloh497
	.loh AdrpAdd	Lloh494, Lloh495
	.loh AdrpAdd	Lloh492, Lloh493
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_cmd_render.cold.1
_nob_cmd_render.cold.1:                 ; @nob_cmd_render.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh498:
	adrp	x0, l___func__.nob_cmd_render@PAGE
Lloh499:
	add	x0, x0, l___func__.nob_cmd_render@PAGEOFF
Lloh500:
	adrp	x1, l_.str.5@PAGE
Lloh501:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh502:
	adrp	x3, l_.str.14@PAGE
Lloh503:
	add	x3, x3, l_.str.14@PAGEOFF
	mov	w2, #469
	bl	___assert_rtn
	.loh AdrpAdd	Lloh502, Lloh503
	.loh AdrpAdd	Lloh500, Lloh501
	.loh AdrpAdd	Lloh498, Lloh499
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_cmd_render.cold.2
_nob_cmd_render.cold.2:                 ; @nob_cmd_render.cold.2
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh504:
	adrp	x0, l___func__.nob_cmd_render@PAGE
Lloh505:
	add	x0, x0, l___func__.nob_cmd_render@PAGEOFF
Lloh506:
	adrp	x1, l_.str.5@PAGE
Lloh507:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh508:
	adrp	x3, l_.str.14@PAGE
Lloh509:
	add	x3, x3, l_.str.14@PAGEOFF
	mov	w2, #472
	bl	___assert_rtn
	.loh AdrpAdd	Lloh508, Lloh509
	.loh AdrpAdd	Lloh506, Lloh507
	.loh AdrpAdd	Lloh504, Lloh505
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_cmd_render.cold.3
_nob_cmd_render.cold.3:                 ; @nob_cmd_render.cold.3
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh510:
	adrp	x0, l___func__.nob_cmd_render@PAGE
Lloh511:
	add	x0, x0, l___func__.nob_cmd_render@PAGEOFF
Lloh512:
	adrp	x1, l_.str.5@PAGE
Lloh513:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh514:
	adrp	x3, l_.str.14@PAGE
Lloh515:
	add	x3, x3, l_.str.14@PAGEOFF
	mov	w2, #473
	bl	___assert_rtn
	.loh AdrpAdd	Lloh514, Lloh515
	.loh AdrpAdd	Lloh512, Lloh513
	.loh AdrpAdd	Lloh510, Lloh511
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_cmd_render.cold.4
_nob_cmd_render.cold.4:                 ; @nob_cmd_render.cold.4
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh516:
	adrp	x0, l___func__.nob_cmd_render@PAGE
Lloh517:
	add	x0, x0, l___func__.nob_cmd_render@PAGEOFF
Lloh518:
	adrp	x1, l_.str.5@PAGE
Lloh519:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh520:
	adrp	x3, l_.str.14@PAGE
Lloh521:
	add	x3, x3, l_.str.14@PAGEOFF
	mov	w2, #471
	bl	___assert_rtn
	.loh AdrpAdd	Lloh520, Lloh521
	.loh AdrpAdd	Lloh518, Lloh519
	.loh AdrpAdd	Lloh516, Lloh517
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_cmd_render.cold.5
_nob_cmd_render.cold.5:                 ; @nob_cmd_render.cold.5
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh522:
	adrp	x0, l___func__.nob_cmd_render@PAGE
Lloh523:
	add	x0, x0, l___func__.nob_cmd_render@PAGEOFF
Lloh524:
	adrp	x1, l_.str.5@PAGE
Lloh525:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh526:
	adrp	x3, l_.str.14@PAGE
Lloh527:
	add	x3, x3, l_.str.14@PAGEOFF
	mov	w2, #467
	bl	___assert_rtn
	.loh AdrpAdd	Lloh526, Lloh527
	.loh AdrpAdd	Lloh524, Lloh525
	.loh AdrpAdd	Lloh522, Lloh523
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_cmd_run_async.cold.1
_nob_cmd_run_async.cold.1:              ; @nob_cmd_run_async.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh528:
	adrp	x0, l___func__.nob_cmd_run_async@PAGE
Lloh529:
	add	x0, x0, l___func__.nob_cmd_run_async@PAGEOFF
Lloh530:
	adrp	x1, l_.str.5@PAGE
Lloh531:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh532:
	adrp	x3, l_.str.16@PAGE
Lloh533:
	add	x3, x3, l_.str.16@PAGEOFF
	mov	w2, #487
	bl	___assert_rtn
	.loh AdrpAdd	Lloh532, Lloh533
	.loh AdrpAdd	Lloh530, Lloh531
	.loh AdrpAdd	Lloh528, Lloh529
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_cmd_run_async.cold.2
_nob_cmd_run_async.cold.2:              ; @nob_cmd_run_async.cold.2
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh534:
	adrp	x0, l___func__.nob_cmd_run_async@PAGE
Lloh535:
	add	x0, x0, l___func__.nob_cmd_run_async@PAGEOFF
Lloh536:
	adrp	x1, l_.str.5@PAGE
Lloh537:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh538:
	adrp	x3, l_.str.20@PAGE
Lloh539:
	add	x3, x3, l_.str.20@PAGEOFF
	mov	w2, #536
	bl	___assert_rtn
	.loh AdrpAdd	Lloh538, Lloh539
	.loh AdrpAdd	Lloh536, Lloh537
	.loh AdrpAdd	Lloh534, Lloh535
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_cmd_run_async.cold.3
_nob_cmd_run_async.cold.3:              ; @nob_cmd_run_async.cold.3
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh540:
	adrp	x0, l___func__.nob_cmd_run_async@PAGE
Lloh541:
	add	x0, x0, l___func__.nob_cmd_run_async@PAGEOFF
Lloh542:
	adrp	x1, l_.str.5@PAGE
Lloh543:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh544:
	adrp	x3, l_.str.22@PAGE
Lloh545:
	add	x3, x3, l_.str.22@PAGEOFF
	mov	w2, #542
	bl	___assert_rtn
	.loh AdrpAdd	Lloh544, Lloh545
	.loh AdrpAdd	Lloh542, Lloh543
	.loh AdrpAdd	Lloh540, Lloh541
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_cmd_run_async.cold.4
_nob_cmd_run_async.cold.4:              ; @nob_cmd_run_async.cold.4
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh546:
	adrp	x0, l___func__.nob_cmd_run_async@PAGE
Lloh547:
	add	x0, x0, l___func__.nob_cmd_run_async@PAGEOFF
Lloh548:
	adrp	x1, l_.str.5@PAGE
Lloh549:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh550:
	adrp	x3, l_.str.20@PAGE
Lloh551:
	add	x3, x3, l_.str.20@PAGEOFF
	mov	w2, #535
	bl	___assert_rtn
	.loh AdrpAdd	Lloh550, Lloh551
	.loh AdrpAdd	Lloh548, Lloh549
	.loh AdrpAdd	Lloh546, Lloh547
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_shift_args.cold.1
_nob_shift_args.cold.1:                 ; @nob_shift_args.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh552:
	adrp	x0, l___func__.nob_shift_args@PAGE
Lloh553:
	add	x0, x0, l___func__.nob_shift_args@PAGEOFF
Lloh554:
	adrp	x1, l_.str.5@PAGE
Lloh555:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh556:
	adrp	x3, l_.str.26@PAGE
Lloh557:
	add	x3, x3, l_.str.26@PAGEOFF
	mov	w2, #624
	bl	___assert_rtn
	.loh AdrpAdd	Lloh556, Lloh557
	.loh AdrpAdd	Lloh554, Lloh555
	.loh AdrpAdd	Lloh552, Lloh553
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_read_entire_dir.cold.1
_nob_read_entire_dir.cold.1:            ; @nob_read_entire_dir.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh558:
	adrp	x0, l___func__.nob_temp_strdup@PAGE
Lloh559:
	add	x0, x0, l___func__.nob_temp_strdup@PAGEOFF
Lloh560:
	adrp	x1, l_.str.5@PAGE
Lloh561:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh562:
	adrp	x3, l_.str.46@PAGE
Lloh563:
	add	x3, x3, l_.str.46@PAGEOFF
	mov	w2, #810
	bl	___assert_rtn
	.loh AdrpAdd	Lloh562, Lloh563
	.loh AdrpAdd	Lloh560, Lloh561
	.loh AdrpAdd	Lloh558, Lloh559
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_read_entire_dir.cold.2
_nob_read_entire_dir.cold.2:            ; @nob_read_entire_dir.cold.2
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh564:
	adrp	x0, l___func__.nob_read_entire_dir@PAGE
Lloh565:
	add	x0, x0, l___func__.nob_read_entire_dir@PAGEOFF
Lloh566:
	adrp	x1, l_.str.5@PAGE
Lloh567:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh568:
	adrp	x3, l_.str.32@PAGE
Lloh569:
	add	x3, x3, l_.str.32@PAGEOFF
	mov	w2, #668
	bl	___assert_rtn
	.loh AdrpAdd	Lloh568, Lloh569
	.loh AdrpAdd	Lloh566, Lloh567
	.loh AdrpAdd	Lloh564, Lloh565
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_temp_strdup.cold.1
_nob_temp_strdup.cold.1:                ; @nob_temp_strdup.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh570:
	adrp	x0, l___func__.nob_temp_strdup@PAGE
Lloh571:
	add	x0, x0, l___func__.nob_temp_strdup@PAGEOFF
Lloh572:
	adrp	x1, l_.str.5@PAGE
Lloh573:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh574:
	adrp	x3, l_.str.46@PAGE
Lloh575:
	add	x3, x3, l_.str.46@PAGEOFF
	mov	w2, #810
	bl	___assert_rtn
	.loh AdrpAdd	Lloh574, Lloh575
	.loh AdrpAdd	Lloh572, Lloh573
	.loh AdrpAdd	Lloh570, Lloh571
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_copy_directory_recursively.cold.1
_nob_copy_directory_recursively.cold.1: ; @nob_copy_directory_recursively.cold.1
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
	bl	___error
	ldr	w0, [x0]
	bl	_strerror
	stp	x19, x0, [sp]
Lloh576:
	adrp	x1, l_.str.37@PAGE
Lloh577:
	add	x1, x1, l_.str.37@PAGEOFF
	mov	w0, #2
	bl	_nob_log
Lloh578:
	adrp	x0, l___func__.nob_copy_directory_recursively@PAGE
Lloh579:
	add	x0, x0, l___func__.nob_copy_directory_recursively@PAGEOFF
Lloh580:
	adrp	x1, l_.str.5@PAGE
Lloh581:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh582:
	adrp	x3, l_.str.22@PAGE
Lloh583:
	add	x3, x3, l_.str.22@PAGEOFF
	mov	w2, #795
	bl	___assert_rtn
	.loh AdrpAdd	Lloh582, Lloh583
	.loh AdrpAdd	Lloh580, Lloh581
	.loh AdrpAdd	Lloh578, Lloh579
	.loh AdrpAdd	Lloh576, Lloh577
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_copy_directory_recursively.cold.2
_nob_copy_directory_recursively.cold.2: ; @nob_copy_directory_recursively.cold.2
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh584:
	adrp	x0, l___func__.nob_copy_directory_recursively@PAGE
Lloh585:
	add	x0, x0, l___func__.nob_copy_directory_recursively@PAGEOFF
Lloh586:
	adrp	x1, l_.str.5@PAGE
Lloh587:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh588:
	adrp	x3, l_.str.40@PAGE
Lloh589:
	add	x3, x3, l_.str.40@PAGEOFF
	mov	w2, #763
	bl	___assert_rtn
	.loh AdrpAdd	Lloh588, Lloh589
	.loh AdrpAdd	Lloh586, Lloh587
	.loh AdrpAdd	Lloh584, Lloh585
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_copy_directory_recursively.cold.3
_nob_copy_directory_recursively.cold.3: ; @nob_copy_directory_recursively.cold.3
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh590:
	adrp	x0, l___func__.nob_copy_directory_recursively@PAGE
Lloh591:
	add	x0, x0, l___func__.nob_copy_directory_recursively@PAGEOFF
Lloh592:
	adrp	x1, l_.str.5@PAGE
Lloh593:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh594:
	adrp	x3, l_.str.40@PAGE
Lloh595:
	add	x3, x3, l_.str.40@PAGEOFF
	mov	w2, #764
	bl	___assert_rtn
	.loh AdrpAdd	Lloh594, Lloh595
	.loh AdrpAdd	Lloh592, Lloh593
	.loh AdrpAdd	Lloh590, Lloh591
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_copy_directory_recursively.cold.4
_nob_copy_directory_recursively.cold.4: ; @nob_copy_directory_recursively.cold.4
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh596:
	adrp	x0, l___func__.nob_copy_directory_recursively@PAGE
Lloh597:
	add	x0, x0, l___func__.nob_copy_directory_recursively@PAGEOFF
Lloh598:
	adrp	x1, l_.str.5@PAGE
Lloh599:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh600:
	adrp	x3, l_.str.40@PAGE
Lloh601:
	add	x3, x3, l_.str.40@PAGEOFF
	mov	w2, #765
	bl	___assert_rtn
	.loh AdrpAdd	Lloh600, Lloh601
	.loh AdrpAdd	Lloh598, Lloh599
	.loh AdrpAdd	Lloh596, Lloh597
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_copy_directory_recursively.cold.5
_nob_copy_directory_recursively.cold.5: ; @nob_copy_directory_recursively.cold.5
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh602:
	adrp	x0, l___func__.nob_copy_directory_recursively@PAGE
Lloh603:
	add	x0, x0, l___func__.nob_copy_directory_recursively@PAGEOFF
Lloh604:
	adrp	x1, l_.str.5@PAGE
Lloh605:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh606:
	adrp	x3, l_.str.40@PAGE
Lloh607:
	add	x3, x3, l_.str.40@PAGEOFF
	mov	w2, #766
	bl	___assert_rtn
	.loh AdrpAdd	Lloh606, Lloh607
	.loh AdrpAdd	Lloh604, Lloh605
	.loh AdrpAdd	Lloh602, Lloh603
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_copy_directory_recursively.cold.6
_nob_copy_directory_recursively.cold.6: ; @nob_copy_directory_recursively.cold.6
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh608:
	adrp	x0, l___func__.nob_copy_directory_recursively@PAGE
Lloh609:
	add	x0, x0, l___func__.nob_copy_directory_recursively@PAGEOFF
Lloh610:
	adrp	x1, l_.str.5@PAGE
Lloh611:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh612:
	adrp	x3, l_.str.42@PAGE
Lloh613:
	add	x3, x3, l_.str.42@PAGEOFF
	mov	w2, #769
	bl	___assert_rtn
	.loh AdrpAdd	Lloh612, Lloh613
	.loh AdrpAdd	Lloh610, Lloh611
	.loh AdrpAdd	Lloh608, Lloh609
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_copy_directory_recursively.cold.7
_nob_copy_directory_recursively.cold.7: ; @nob_copy_directory_recursively.cold.7
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh614:
	adrp	x0, l___func__.nob_copy_directory_recursively@PAGE
Lloh615:
	add	x0, x0, l___func__.nob_copy_directory_recursively@PAGEOFF
Lloh616:
	adrp	x1, l_.str.5@PAGE
Lloh617:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh618:
	adrp	x3, l_.str.42@PAGE
Lloh619:
	add	x3, x3, l_.str.42@PAGEOFF
	mov	w2, #770
	bl	___assert_rtn
	.loh AdrpAdd	Lloh618, Lloh619
	.loh AdrpAdd	Lloh616, Lloh617
	.loh AdrpAdd	Lloh614, Lloh615
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_copy_directory_recursively.cold.8
_nob_copy_directory_recursively.cold.8: ; @nob_copy_directory_recursively.cold.8
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh620:
	adrp	x0, l___func__.nob_copy_directory_recursively@PAGE
Lloh621:
	add	x0, x0, l___func__.nob_copy_directory_recursively@PAGEOFF
Lloh622:
	adrp	x1, l_.str.5@PAGE
Lloh623:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh624:
	adrp	x3, l_.str.42@PAGE
Lloh625:
	add	x3, x3, l_.str.42@PAGEOFF
	mov	w2, #771
	bl	___assert_rtn
	.loh AdrpAdd	Lloh624, Lloh625
	.loh AdrpAdd	Lloh622, Lloh623
	.loh AdrpAdd	Lloh620, Lloh621
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_copy_directory_recursively.cold.9
_nob_copy_directory_recursively.cold.9: ; @nob_copy_directory_recursively.cold.9
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh626:
	adrp	x0, l___func__.nob_copy_directory_recursively@PAGE
Lloh627:
	add	x0, x0, l___func__.nob_copy_directory_recursively@PAGEOFF
Lloh628:
	adrp	x1, l_.str.5@PAGE
Lloh629:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh630:
	adrp	x3, l_.str.42@PAGE
Lloh631:
	add	x3, x3, l_.str.42@PAGEOFF
	mov	w2, #772
	bl	___assert_rtn
	.loh AdrpAdd	Lloh630, Lloh631
	.loh AdrpAdd	Lloh628, Lloh629
	.loh AdrpAdd	Lloh626, Lloh627
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_temp_sprintf.cold.1
_nob_temp_sprintf.cold.1:               ; @nob_temp_sprintf.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh632:
	adrp	x0, l___func__.nob_temp_sprintf@PAGE
Lloh633:
	add	x0, x0, l___func__.nob_temp_sprintf@PAGEOFF
Lloh634:
	adrp	x1, l_.str.5@PAGE
Lloh635:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh636:
	adrp	x3, l_.str.47@PAGE
Lloh637:
	add	x3, x3, l_.str.47@PAGEOFF
	mov	w2, #831
	bl	___assert_rtn
	.loh AdrpAdd	Lloh636, Lloh637
	.loh AdrpAdd	Lloh634, Lloh635
	.loh AdrpAdd	Lloh632, Lloh633
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_temp_sprintf.cold.2
_nob_temp_sprintf.cold.2:               ; @nob_temp_sprintf.cold.2
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh638:
	adrp	x0, l___func__.nob_temp_sprintf@PAGE
Lloh639:
	add	x0, x0, l___func__.nob_temp_sprintf@PAGEOFF
Lloh640:
	adrp	x1, l_.str.5@PAGE
Lloh641:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh642:
	adrp	x3, l_.str.49@PAGE
Lloh643:
	add	x3, x3, l_.str.49@PAGEOFF
	mov	w2, #833
	bl	___assert_rtn
	.loh AdrpAdd	Lloh642, Lloh643
	.loh AdrpAdd	Lloh640, Lloh641
	.loh AdrpAdd	Lloh638, Lloh639
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_temp_sv_to_cstr.cold.1
_nob_temp_sv_to_cstr.cold.1:            ; @nob_temp_sv_to_cstr.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh644:
	adrp	x0, l___func__.nob_temp_sv_to_cstr@PAGE
Lloh645:
	add	x0, x0, l___func__.nob_temp_sv_to_cstr@PAGEOFF
Lloh646:
	adrp	x1, l_.str.5@PAGE
Lloh647:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh648:
	adrp	x3, l_.str.49@PAGE
Lloh649:
	add	x3, x3, l_.str.49@PAGEOFF
	mov	w2, #860
	bl	___assert_rtn
	.loh AdrpAdd	Lloh648, Lloh649
	.loh AdrpAdd	Lloh646, Lloh647
	.loh AdrpAdd	Lloh644, Lloh645
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function nob_read_entire_file.cold.1
_nob_read_entire_file.cold.1:           ; @nob_read_entire_file.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh650:
	adrp	x0, l___func__.nob_read_entire_file@PAGE
Lloh651:
	add	x0, x0, l___func__.nob_read_entire_file@PAGEOFF
Lloh652:
	adrp	x1, l_.str.5@PAGE
Lloh653:
	add	x1, x1, l_.str.5@PAGEOFF
Lloh654:
	adrp	x3, l_.str.55@PAGE
Lloh655:
	add	x3, x3, l_.str.55@PAGEOFF
	mov	w2, #970
	bl	___assert_rtn
	.loh AdrpAdd	Lloh654, Lloh655
	.loh AdrpAdd	Lloh652, Lloh653
	.loh AdrpAdd	Lloh650, Lloh651
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_all_files.cold.1
_get_all_files.cold.1:                  ; @get_all_files.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh656:
	adrp	x0, l___func__.get_all_files@PAGE
Lloh657:
	add	x0, x0, l___func__.get_all_files@PAGEOFF
Lloh658:
	adrp	x1, l_.str.179@PAGE
Lloh659:
	add	x1, x1, l_.str.179@PAGEOFF
Lloh660:
	adrp	x3, l_.str.180@PAGE
Lloh661:
	add	x3, x3, l_.str.180@PAGEOFF
	mov	w2, #1007
	bl	___assert_rtn
	.loh AdrpAdd	Lloh660, Lloh661
	.loh AdrpAdd	Lloh658, Lloh659
	.loh AdrpAdd	Lloh656, Lloh657
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_all_files.cold.2
_get_all_files.cold.2:                  ; @get_all_files.cold.2
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh662:
	adrp	x0, l___func__.get_all_files@PAGE
Lloh663:
	add	x0, x0, l___func__.get_all_files@PAGEOFF
Lloh664:
	adrp	x1, l_.str.179@PAGE
Lloh665:
	add	x1, x1, l_.str.179@PAGEOFF
Lloh666:
	adrp	x3, l_.str.180@PAGE
Lloh667:
	add	x3, x3, l_.str.180@PAGEOFF
	mov	w2, #1016
	bl	___assert_rtn
	.loh AdrpAdd	Lloh666, Lloh667
	.loh AdrpAdd	Lloh664, Lloh665
	.loh AdrpAdd	Lloh662, Lloh663
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_all_files.cold.3
_get_all_files.cold.3:                  ; @get_all_files.cold.3
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh668:
	adrp	x0, l___func__.create_ld_section@PAGE
Lloh669:
	add	x0, x0, l___func__.create_ld_section@PAGEOFF
Lloh670:
	adrp	x1, l_.str.179@PAGE
Lloh671:
	add	x1, x1, l_.str.179@PAGEOFF
Lloh672:
	adrp	x3, l_.str.182@PAGE
Lloh673:
	add	x3, x3, l_.str.182@PAGEOFF
	mov	w2, #1084
	bl	___assert_rtn
	.loh AdrpAdd	Lloh672, Lloh673
	.loh AdrpAdd	Lloh670, Lloh671
	.loh AdrpAdd	Lloh668, Lloh669
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function create_ld_section.cold.1
_create_ld_section.cold.1:              ; @create_ld_section.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh674:
	adrp	x0, l___func__.create_ld_section@PAGE
Lloh675:
	add	x0, x0, l___func__.create_ld_section@PAGEOFF
Lloh676:
	adrp	x1, l_.str.179@PAGE
Lloh677:
	add	x1, x1, l_.str.179@PAGEOFF
Lloh678:
	adrp	x3, l_.str.182@PAGE
Lloh679:
	add	x3, x3, l_.str.182@PAGEOFF
	mov	w2, #1084
	bl	___assert_rtn
	.loh AdrpAdd	Lloh678, Lloh679
	.loh AdrpAdd	Lloh676, Lloh677
	.loh AdrpAdd	Lloh674, Lloh675
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function pack_symbol_table.cold.1
_pack_symbol_table.cold.1:              ; @pack_symbol_table.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh680:
	adrp	x0, l___func__.pack_symbol_table@PAGE
Lloh681:
	add	x0, x0, l___func__.pack_symbol_table@PAGEOFF
Lloh682:
	adrp	x1, l_.str.179@PAGE
Lloh683:
	add	x1, x1, l_.str.179@PAGEOFF
Lloh684:
	adrp	x3, l_.str.183@PAGE
Lloh685:
	add	x3, x3, l_.str.183@PAGEOFF
	mov	w2, #1131
	bl	___assert_rtn
	.loh AdrpAdd	Lloh684, Lloh685
	.loh AdrpAdd	Lloh682, Lloh683
	.loh AdrpAdd	Lloh680, Lloh681
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function pack_symbol_table.cold.2
_pack_symbol_table.cold.2:              ; @pack_symbol_table.cold.2
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh686:
	adrp	x0, l___func__.pack_symbol_table@PAGE
Lloh687:
	add	x0, x0, l___func__.pack_symbol_table@PAGEOFF
Lloh688:
	adrp	x1, l_.str.179@PAGE
Lloh689:
	add	x1, x1, l_.str.179@PAGEOFF
Lloh690:
	adrp	x3, l_.str.183@PAGE
Lloh691:
	add	x3, x3, l_.str.183@PAGEOFF
	mov	w2, #1135
	bl	___assert_rtn
	.loh AdrpAdd	Lloh690, Lloh691
	.loh AdrpAdd	Lloh688, Lloh689
	.loh AdrpAdd	Lloh686, Lloh687
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function pack_symbol_table.cold.3
_pack_symbol_table.cold.3:              ; @pack_symbol_table.cold.3
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh692:
	adrp	x0, l___func__.pack_symbol_table@PAGE
Lloh693:
	add	x0, x0, l___func__.pack_symbol_table@PAGEOFF
Lloh694:
	adrp	x1, l_.str.179@PAGE
Lloh695:
	add	x1, x1, l_.str.179@PAGEOFF
Lloh696:
	adrp	x3, l_.str.183@PAGE
Lloh697:
	add	x3, x3, l_.str.183@PAGEOFF
	mov	w2, #1136
	bl	___assert_rtn
	.loh AdrpAdd	Lloh696, Lloh697
	.loh AdrpAdd	Lloh694, Lloh695
	.loh AdrpAdd	Lloh692, Lloh693
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function pack_relocation_table.cold.1
_pack_relocation_table.cold.1:          ; @pack_relocation_table.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh698:
	adrp	x0, l___func__.pack_relocation_table@PAGE
Lloh699:
	add	x0, x0, l___func__.pack_relocation_table@PAGEOFF
Lloh700:
	adrp	x1, l_.str.179@PAGE
Lloh701:
	add	x1, x1, l_.str.179@PAGEOFF
Lloh702:
	adrp	x3, l_.str.183@PAGE
Lloh703:
	add	x3, x3, l_.str.183@PAGEOFF
	mov	w2, #1144
	bl	___assert_rtn
	.loh AdrpAdd	Lloh702, Lloh703
	.loh AdrpAdd	Lloh700, Lloh701
	.loh AdrpAdd	Lloh698, Lloh699
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function pack_relocation_table.cold.2
_pack_relocation_table.cold.2:          ; @pack_relocation_table.cold.2
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh704:
	adrp	x0, l___func__.pack_relocation_table@PAGE
Lloh705:
	add	x0, x0, l___func__.pack_relocation_table@PAGEOFF
Lloh706:
	adrp	x1, l_.str.179@PAGE
Lloh707:
	add	x1, x1, l_.str.179@PAGEOFF
Lloh708:
	adrp	x3, l_.str.183@PAGE
Lloh709:
	add	x3, x3, l_.str.183@PAGEOFF
	mov	w2, #1147
	bl	___assert_rtn
	.loh AdrpAdd	Lloh708, Lloh709
	.loh AdrpAdd	Lloh706, Lloh707
	.loh AdrpAdd	Lloh704, Lloh705
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function pack_relocation_table.cold.3
_pack_relocation_table.cold.3:          ; @pack_relocation_table.cold.3
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh710:
	adrp	x0, l___func__.pack_relocation_table@PAGE
Lloh711:
	add	x0, x0, l___func__.pack_relocation_table@PAGEOFF
Lloh712:
	adrp	x1, l_.str.179@PAGE
Lloh713:
	add	x1, x1, l_.str.179@PAGEOFF
Lloh714:
	adrp	x3, l_.str.183@PAGE
Lloh715:
	add	x3, x3, l_.str.183@PAGEOFF
	mov	w2, #1148
	bl	___assert_rtn
	.loh AdrpAdd	Lloh714, Lloh715
	.loh AdrpAdd	Lloh712, Lloh713
	.loh AdrpAdd	Lloh710, Lloh711
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function pack_relocation_table.cold.4
_pack_relocation_table.cold.4:          ; @pack_relocation_table.cold.4
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh716:
	adrp	x0, l___func__.pack_relocation_table@PAGE
Lloh717:
	add	x0, x0, l___func__.pack_relocation_table@PAGEOFF
Lloh718:
	adrp	x1, l_.str.179@PAGE
Lloh719:
	add	x1, x1, l_.str.179@PAGEOFF
Lloh720:
	adrp	x3, l_.str.183@PAGE
Lloh721:
	add	x3, x3, l_.str.183@PAGEOFF
	mov	w2, #1149
	bl	___assert_rtn
	.loh AdrpAdd	Lloh720, Lloh721
	.loh AdrpAdd	Lloh718, Lloh719
	.loh AdrpAdd	Lloh716, Lloh717
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function main.cold.1
_main.cold.1:                           ; @main.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh722:
	adrp	x0, l___func__.main@PAGE
Lloh723:
	add	x0, x0, l___func__.main@PAGEOFF
Lloh724:
	adrp	x1, l_.str.179@PAGE
Lloh725:
	add	x1, x1, l_.str.179@PAGEOFF
Lloh726:
	adrp	x3, l_.str.194@PAGE
Lloh727:
	add	x3, x3, l_.str.194@PAGEOFF
	mov	w2, #1262
	bl	___assert_rtn
	.loh AdrpAdd	Lloh726, Lloh727
	.loh AdrpAdd	Lloh724, Lloh725
	.loh AdrpAdd	Lloh722, Lloh723
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function main.cold.2
_main.cold.2:                           ; @main.cold.2
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh728:
	adrp	x0, l___func__.main@PAGE
Lloh729:
	add	x0, x0, l___func__.main@PAGEOFF
Lloh730:
	adrp	x1, l_.str.179@PAGE
Lloh731:
	add	x1, x1, l_.str.179@PAGEOFF
Lloh732:
	adrp	x3, l_.str.192@PAGE
Lloh733:
	add	x3, x3, l_.str.192@PAGEOFF
	mov	w2, #1228
	bl	___assert_rtn
	.loh AdrpAdd	Lloh732, Lloh733
	.loh AdrpAdd	Lloh730, Lloh731
	.loh AdrpAdd	Lloh728, Lloh729
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function main.cold.3
_main.cold.3:                           ; @main.cold.3
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh734:
	adrp	x0, l___func__.main@PAGE
Lloh735:
	add	x0, x0, l___func__.main@PAGEOFF
Lloh736:
	adrp	x1, l_.str.179@PAGE
Lloh737:
	add	x1, x1, l_.str.179@PAGEOFF
Lloh738:
	adrp	x3, l_.str.198@PAGE
Lloh739:
	add	x3, x3, l_.str.198@PAGEOFF
	mov	w2, #1309
	bl	___assert_rtn
	.loh AdrpAdd	Lloh738, Lloh739
	.loh AdrpAdd	Lloh736, Lloh737
	.loh AdrpAdd	Lloh734, Lloh735
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"directory `%s` already exists"

l_.str.1:                               ; @.str.1
	.asciz	"could not create directory `%s`: %s"

l_.str.2:                               ; @.str.2
	.asciz	"created directory `%s`"

l_.str.3:                               ; @.str.3
	.asciz	"copying %s -> %s"

l___func__.nob_copy_file:               ; @__func__.nob_copy_file
	.asciz	"nob_copy_file"

l_.str.5:                               ; @.str.5
	.asciz	"nob.h"

l_.str.6:                               ; @.str.6
	.asciz	"buf != NULL && \"Buy more RAM lol!!\""

l_.str.7:                               ; @.str.7
	.asciz	"Could not open file %s: %s"

l_.str.8:                               ; @.str.8
	.asciz	"Could not get mode of file %s: %s"

l_.str.9:                               ; @.str.9
	.asciz	"Could not create file %s: %s"

l_.str.10:                              ; @.str.10
	.asciz	"Could not read from file %s: %s"

l_.str.11:                              ; @.str.11
	.asciz	"Could not write to file %s: %s"

l___func__.nob_cmd_render:              ; @__func__.nob_cmd_render
	.asciz	"nob_cmd_render"

l_.str.14:                              ; @.str.14
	.asciz	"(render)->items != NULL && \"Buy more RAM lol\""

l_.str.15:                              ; @.str.15
	.asciz	"Could not run empty command"

l___func__.nob_cmd_run_async:           ; @__func__.nob_cmd_run_async
	.asciz	"nob_cmd_run_async"

l_.str.16:                              ; @.str.16
	.asciz	"(&sb)->items != NULL && \"Buy more RAM lol\""

l_.str.18:                              ; @.str.18
	.asciz	"CMD: %s"

l_.str.19:                              ; @.str.19
	.asciz	"Could not fork child process: %s"

l_.str.20:                              ; @.str.20
	.asciz	"(&cmd_null)->items != NULL && \"Buy more RAM lol\""

l_.str.21:                              ; @.str.21
	.asciz	"Could not exec child process: %s"

l_.str.22:                              ; @.str.22
	.asciz	"0 && \"unreachable\""

l_.str.23:                              ; @.str.23
	.asciz	"could not wait on command (pid %d): %s"

l_.str.24:                              ; @.str.24
	.asciz	"command exited with exit code %d"

l_.str.25:                              ; @.str.25
	.asciz	"command process was terminated by %s"

l___func__.nob_shift_args:              ; @__func__.nob_shift_args
	.asciz	"nob_shift_args"

l_.str.26:                              ; @.str.26
	.asciz	"*argc > 0"

l_.str.27:                              ; @.str.27
	.asciz	"[INFO] "

l_.str.28:                              ; @.str.28
	.asciz	"[WARNING] "

l_.str.29:                              ; @.str.29
	.asciz	"[ERROR] "

l___func__.nob_log:                     ; @__func__.nob_log
	.asciz	"nob_log"

l_.str.31:                              ; @.str.31
	.asciz	"Could not open directory %s: %s"

l___func__.nob_read_entire_dir:         ; @__func__.nob_read_entire_dir
	.asciz	"nob_read_entire_dir"

l_.str.32:                              ; @.str.32
	.asciz	"(children)->items != NULL && \"Buy more RAM lol\""

l_.str.33:                              ; @.str.33
	.asciz	"Could not read directory %s: %s"

l_.str.34:                              ; @.str.34
	.asciz	"wb"

l_.str.35:                              ; @.str.35
	.asciz	"Could not open file %s for writing: %s\n"

l_.str.36:                              ; @.str.36
	.asciz	"Could not write into file %s: %s\n"

l_.str.37:                              ; @.str.37
	.asciz	"Could not get stat of %s: %s"

l_.str.38:                              ; @.str.38
	.asciz	"."

l_.str.39:                              ; @.str.39
	.asciz	".."

l___func__.nob_copy_directory_recursively: ; @__func__.nob_copy_directory_recursively
	.asciz	"nob_copy_directory_recursively"

l_.str.40:                              ; @.str.40
	.asciz	"(&src_sb)->items != NULL && \"Buy more RAM lol\""

l_.str.42:                              ; @.str.42
	.asciz	"(&dst_sb)->items != NULL && \"Buy more RAM lol\""

l_.str.43:                              ; @.str.43
	.asciz	"TODO: Copying symlinks is not supported yet"

l_.str.44:                              ; @.str.44
	.asciz	"Unsupported type of file %s"

l___func__.nob_temp_strdup:             ; @__func__.nob_temp_strdup
	.asciz	"nob_temp_strdup"

l_.str.46:                              ; @.str.46
	.asciz	"result != NULL && \"Increase NOB_TEMP_CAPACITY\""

.zerofill __DATA,__bss,_nob_temp_size,8,3 ; @nob_temp_size
.zerofill __DATA,__bss,_nob_temp,8388608,0 ; @nob_temp
l___func__.nob_temp_sprintf:            ; @__func__.nob_temp_sprintf
	.asciz	"nob_temp_sprintf"

l_.str.47:                              ; @.str.47
	.asciz	"n >= 0"

l_.str.49:                              ; @.str.49
	.asciz	"result != NULL && \"Extend the size of the temporary allocator\""

l___func__.nob_temp_sv_to_cstr:         ; @__func__.nob_temp_sv_to_cstr
	.asciz	"nob_temp_sv_to_cstr"

l_.str.50:                              ; @.str.50
	.asciz	"could not stat %s: %s"

l_.str.51:                              ; @.str.51
	.asciz	"renaming %s -> %s"

l_.str.52:                              ; @.str.52
	.asciz	"could not rename %s to %s: %s"

l_.str.53:                              ; @.str.53
	.asciz	"rb"

l___func__.nob_read_entire_file:        ; @__func__.nob_read_entire_file
	.asciz	"nob_read_entire_file"

l_.str.55:                              ; @.str.55
	.asciz	"sb->items != NULL && \"Buy more RAM lool!!\""

l_.str.56:                              ; @.str.56
	.asciz	"Could not read file %s: %s"

l_.str.57:                              ; @.str.57
	.asciz	"Could not check if file %s exists: %s"

	.section	__DATA,__data
	.globl	_svcs                           ; @svcs
	.p2align	3, 0x0
_svcs:
	.quad	_exit
	.quad	_read
	.quad	_write
	.quad	_open
	.quad	_close
	.quad	_mmap
	.quad	_munmap
	.quad	_mprotect

	.section	__TEXT,__cstring,cstring_literals
l_.str.58:                              ; @.str.58
	.asciz	"b %d"

l_.str.59:                              ; @.str.59
	.asciz	"bl %d"

l_.str.60:                              ; @.str.60
	.asciz	"blt %d"

l_.str.61:                              ; @.str.61
	.asciz	"bgt %d"

l_.str.62:                              ; @.str.62
	.asciz	"bge %d"

l_.str.63:                              ; @.str.63
	.asciz	"ble %d"

l_.str.64:                              ; @.str.64
	.asciz	"beq %d"

l_.str.65:                              ; @.str.65
	.asciz	"bne %d"

l_.str.66:                              ; @.str.66
	.asciz	"bllt %d"

l_.str.67:                              ; @.str.67
	.asciz	"blgt %d"

l_.str.68:                              ; @.str.68
	.asciz	"blge %d"

l_.str.69:                              ; @.str.69
	.asciz	"blle %d"

l_.str.70:                              ; @.str.70
	.asciz	"bleq %d"

l_.str.71:                              ; @.str.71
	.asciz	"blne %d"

l_.str.72:                              ; @.str.72
	.asciz	"add r%d, r%d, %d"

l_.str.73:                              ; @.str.73
	.asciz	"sub r%d, r%d, %d"

l_.str.74:                              ; @.str.74
	.asciz	"mul r%d, r%d, %d"

l_.str.75:                              ; @.str.75
	.asciz	"div r%d, r%d, %d"

l_.str.76:                              ; @.str.76
	.asciz	"mod r%d, r%d, %d"

l_.str.77:                              ; @.str.77
	.asciz	"and r%d, r%d, %d"

l_.str.78:                              ; @.str.78
	.asciz	"or r%d, r%d, %d"

l_.str.79:                              ; @.str.79
	.asciz	"xor r%d, r%d, %d"

l_.str.80:                              ; @.str.80
	.asciz	"nop"

l_.str.81:                              ; @.str.81
	.asciz	"ret"

l_.str.82:                              ; @.str.82
	.asciz	"mov r%d, r%d"

l_.str.83:                              ; @.str.83
	.asciz	"shl r%d, r%d, %d"

l_.str.84:                              ; @.str.84
	.asciz	"shr r%d, r%d, %d"

l_.str.85:                              ; @.str.85
	.asciz	"rol r%d, r%d, %d"

l_.str.86:                              ; @.str.86
	.asciz	"ror r%d, r%d, %d"

l_.str.87:                              ; @.str.87
	.asciz	"ldr r%d, [r%d, %d]"

l_.str.88:                              ; @.str.88
	.asciz	"ldrd r%d, [r%d, %d]"

l_.str.89:                              ; @.str.89
	.asciz	"ldrw r%d, [r%d, %d]"

l_.str.90:                              ; @.str.90
	.asciz	"ldrb r%d, [r%d, %d]"

l_.str.91:                              ; @.str.91
	.asciz	"str r%d, [r%d, %d]"

l_.str.92:                              ; @.str.92
	.asciz	"strd r%d, [r%d, %d]"

l_.str.93:                              ; @.str.93
	.asciz	"strw r%d, [r%d, %d]"

l_.str.94:                              ; @.str.94
	.asciz	"strb r%d, [r%d, %d]"

l_.str.95:                              ; @.str.95
	.asciz	"sbxt r%d, r%d, %d, %d"

l_.str.96:                              ; @.str.96
	.asciz	"ubxt r%d, r%d, %d, %d"

l_.str.97:                              ; @.str.97
	.asciz	"sbdp r%d, r%d, %d, %d"

l_.str.98:                              ; @.str.98
	.asciz	"ubdp r%d, r%d, %d, %d"

l_.str.99:                              ; @.str.99
	.asciz	"ldp r%d, r%d, [r%d, %d]"

l_.str.100:                             ; @.str.100
	.asciz	"ldpd r%d, r%d, [r%d, %d]"

l_.str.101:                             ; @.str.101
	.asciz	"ldpw r%d, r%d, [r%d, %d]"

l_.str.102:                             ; @.str.102
	.asciz	"ldpb r%d, r%d, [r%d, %d]"

l_.str.103:                             ; @.str.103
	.asciz	"stp r%d, r%d, [r%d, %d]"

l_.str.104:                             ; @.str.104
	.asciz	"stpd r%d, r%d, [r%d, %d]"

l_.str.105:                             ; @.str.105
	.asciz	"stpw r%d, r%d, [r%d, %d]"

l_.str.106:                             ; @.str.106
	.asciz	"stpb r%d, r%d, [r%d, %d]"

l_.str.107:                             ; @.str.107
	.asciz	"fadd r%d, r%d, r%d"

l_.str.108:                             ; @.str.108
	.asciz	"faddi r%d, r%d, r%d"

l_.str.109:                             ; @.str.109
	.asciz	"fsub r%d, r%d, r%d"

l_.str.110:                             ; @.str.110
	.asciz	"fsubi r%d, r%d, r%d"

l_.str.111:                             ; @.str.111
	.asciz	"fmul r%d, r%d, r%d"

l_.str.112:                             ; @.str.112
	.asciz	"fmuli r%d, r%d, r%d"

l_.str.113:                             ; @.str.113
	.asciz	"fdiv r%d, r%d, r%d"

l_.str.114:                             ; @.str.114
	.asciz	"fdivi r%d, r%d, r%d"

l_.str.115:                             ; @.str.115
	.asciz	"fmod r%d, r%d, r%d"

l_.str.116:                             ; @.str.116
	.asciz	"fmodi r%d, r%d, r%d"

l_.str.117:                             ; @.str.117
	.asciz	"i2f r%d, r%d"

l_.str.118:                             ; @.str.118
	.asciz	"f2i r%d, r%d"

l_.str.119:                             ; @.str.119
	.asciz	"fsin r%d, r%d"

l_.str.120:                             ; @.str.120
	.asciz	"fsqrt r%d, r%d"

l_.str.121:                             ; @.str.121
	.asciz	"fcmp r%d, r%d"

l_.str.122:                             ; @.str.122
	.asciz	"fcmpi r%d, r%d"

l_.str.123:                             ; @.str.123
	.asciz	"add r%d, r%d, r%d"

l_.str.124:                             ; @.str.124
	.asciz	"sub r%d, r%d, r%d"

l_.str.125:                             ; @.str.125
	.asciz	"mul r%d, r%d, r%d"

l_.str.126:                             ; @.str.126
	.asciz	"div r%d, r%d, r%d"

l_.str.127:                             ; @.str.127
	.asciz	"mod r%d, r%d, r%d"

l_.str.128:                             ; @.str.128
	.asciz	"and r%d, r%d, r%d"

l_.str.129:                             ; @.str.129
	.asciz	"or r%d, r%d, r%d"

l_.str.130:                             ; @.str.130
	.asciz	"xor r%d, r%d, r%d"

l_.str.131:                             ; @.str.131
	.asciz	"shl r%d, r%d, r%d"

l_.str.132:                             ; @.str.132
	.asciz	"shr r%d, r%d, r%d"

l_.str.133:                             ; @.str.133
	.asciz	"rol r%d, r%d, r%d"

l_.str.134:                             ; @.str.134
	.asciz	"ror r%d, r%d, r%d"

l_.str.135:                             ; @.str.135
	.asciz	"ldr r%d, [r%d, r%d]"

l_.str.136:                             ; @.str.136
	.asciz	"ldrd r%d, [r%d, r%d]"

l_.str.137:                             ; @.str.137
	.asciz	"ldrw r%d, [r%d, r%d]"

l_.str.138:                             ; @.str.138
	.asciz	"ldrb r%d, [r%d, r%d]"

l_.str.139:                             ; @.str.139
	.asciz	"str r%d, [r%d, r%d]"

l_.str.140:                             ; @.str.140
	.asciz	"strd r%d, [r%d, r%d]"

l_.str.141:                             ; @.str.141
	.asciz	"strw r%d, [r%d, r%d]"

l_.str.142:                             ; @.str.142
	.asciz	"strb r%d, [r%d, r%d]"

l_.str.143:                             ; @.str.143
	.asciz	"tst r%d, r%d"

l_.str.144:                             ; @.str.144
	.asciz	"cmp r%d, r%d"

l_.str.145:                             ; @.str.145
	.asciz	"ldp r%d, r%d, [r%d, r%d]"

l_.str.146:                             ; @.str.146
	.asciz	"ldpd r%d, r%d, [r%d, r%d]"

l_.str.147:                             ; @.str.147
	.asciz	"ldpw r%d, r%d, [r%d, r%d]"

l_.str.148:                             ; @.str.148
	.asciz	"ldpb r%d, r%d, [r%d, r%d]"

l_.str.149:                             ; @.str.149
	.asciz	"stp r%d, r%d, [r%d, r%d]"

l_.str.150:                             ; @.str.150
	.asciz	"stpd r%d, r%d, [r%d, r%d]"

l_.str.151:                             ; @.str.151
	.asciz	"stpw r%d, r%d, [r%d, r%d]"

l_.str.152:                             ; @.str.152
	.asciz	"stpb r%d, r%d, [r%d, r%d]"

l_.str.153:                             ; @.str.153
	.asciz	"cbz r%d, 0x%08x"

l_.str.154:                             ; @.str.154
	.asciz	"cbnz r%d, 0x%08x"

l_.str.155:                             ; @.str.155
	.asciz	"lea r%d, 0x%08x"

l_.str.156:                             ; @.str.156
	.asciz	"movk r%d, %d, shl %d"

l_.str.157:                             ; @.str.157
	.asciz	"movz r%d, %d, shl %d"

l_.str.158:                             ; @.str.158
	.asciz	"svc"

l_.str.159:                             ; @.str.159
	.asciz	"br r%d"

l_.str.160:                             ; @.str.160
	.asciz	"blr r%d"

l_.str.161:                             ; @.str.161
	.asciz	"brlt r%d"

l_.str.162:                             ; @.str.162
	.asciz	"brgt r%d"

l_.str.163:                             ; @.str.163
	.asciz	"brge r%d"

l_.str.164:                             ; @.str.164
	.asciz	"brle r%d"

l_.str.165:                             ; @.str.165
	.asciz	"breq r%d"

l_.str.166:                             ; @.str.166
	.asciz	"brne r%d"

l_.str.167:                             ; @.str.167
	.asciz	"blrlt r%d"

l_.str.168:                             ; @.str.168
	.asciz	"blrgt r%d"

l_.str.169:                             ; @.str.169
	.asciz	"blrge r%d"

l_.str.170:                             ; @.str.170
	.asciz	"blrle r%d"

l_.str.171:                             ; @.str.171
	.asciz	"blreq r%d"

l_.str.172:                             ; @.str.172
	.asciz	"blrne r%d"

l_.str.173:                             ; @.str.173
	.asciz	"tst r%d, %d"

l_.str.174:                             ; @.str.174
	.asciz	"cmp r%d, %d"

l_.str.175:                             ; @.str.175
	.asciz	"0x%016llx: 0x%08x %s\n"

l_.str.176:                             ; @.str.176
	.asciz	"0x%016llx: 0x%08x\t"

l_.str.177:                             ; @.str.177
	.asciz	".dword 0x%08x\n"

l___func__.get_all_files:               ; @__func__.get_all_files
	.asciz	"get_all_files"

l_.str.179:                             ; @.str.179
	.asciz	"main.c"

l_.str.180:                             ; @.str.180
	.asciz	"(&files)->items != NULL && \"Buy more RAM lol\""

l_.str.181:                             ; @.str.181
	.asciz	"Unable to locate library %s\n"

l___func__.create_ld_section:           ; @__func__.create_ld_section
	.asciz	"create_ld_section"

l_.str.182:                             ; @.str.182
	.asciz	"(&paths)->items != NULL && \"Buy more RAM lol\""

l___func__.pack_symbol_table:           ; @__func__.pack_symbol_table
	.asciz	"pack_symbol_table"

l_.str.183:                             ; @.str.183
	.asciz	"(&s)->items != NULL && \"Buy more RAM lol\""

l___func__.pack_relocation_table:       ; @__func__.pack_relocation_table
	.asciz	"pack_relocation_table"

l_.str.184:                             ; @.str.184
	.asciz	"Undefined symbol: %s\n"

l_.str.185:                             ; @.str.185
	.asciz	"Relative target not aligned!"

l_.str.186:                             ; @.str.186
	.asciz	"Relative address too far: %x (%llx -> %llx)\n"

l_.str.187:                             ; @.str.187
	.asciz	"Usage: %s run <objfile>\n"

l_.str.188:                             ; @.str.188
	.asciz	"       %s comp <srcfile> <objfile>\n"

l_.str.189:                             ; @.str.189
	.asciz	"comp"

l_.str.190:                             ; @.str.190
	.asciz	"Usage: %s comp <srcfile> <objfile>\n"

l_.str.191:                             ; @.str.191
	.asciz	"-l requires an argument!\n"

l___func__.main:                        ; @__func__.main
	.asciz	"main"

l_.str.192:                             ; @.str.192
	.asciz	"(&link_with)->items != NULL && \"Buy more RAM lol\""

l_.str.193:                             ; @.str.193
	.asciz	"Failed to compile!\n"

l_.str.194:                             ; @.str.194
	.asciz	"(&sa)->items != NULL && \"Buy more RAM lol\""

l_.str.195:                             ; @.str.195
	.asciz	"run"

l_.str.196:                             ; @.str.196
	.asciz	"dis"

l_.str.197:                             ; @.str.197
	.asciz	"Could not open file '%s'\n"

l_.str.198:                             ; @.str.198
	.asciz	"(&all_syms)->items != NULL && \"Buy more RAM lol\""

l_.str.199:                             ; @.str.199
	.asciz	"_start"

l_.str.200:                             ; @.str.200
	.asciz	"Could not find _start symbol\n"

l_.str.201:                             ; @.str.201
	.asciz	"Unknown command '%s'\n"

	.section	__DATA,__const
	.p2align	3, 0x0                          ; @switch.table.dis
l_switch.table.dis:
	.quad	l_.str.58
	.quad	l_.str.59
	.quad	l_.str.60
	.quad	l_.str.61
	.quad	l_.str.62
	.quad	l_.str.63
	.quad	l_.str.64
	.quad	l_.str.65
	.quad	l_.str.66
	.quad	l_.str.67
	.quad	l_.str.68
	.quad	l_.str.69
	.quad	l_.str.70
	.quad	l_.str.71

.subsections_via_symbols
