#define PREPROC_NARG(...) \
         PREPROC_NARG_(__VA_ARGS__,PREPROC_RSEQ_N())
#define PREPROC_NARG_(...) \
         PREPROC_ARG_N(__VA_ARGS__)
#define PREPROC_ARG_N( \
          _1, _2, _3, _4, _5, _6, _7, _8, _9,_10, \
         _11,_12,_13,_14,_15,_16,_17,_18,_19,_20, \
         _21,_22,_23,_24,_25,_26,_27,_28,_29,_30, \
         _31,_32,_33,_34,_35,_36,_37,_38,_39,_40, \
         _41,_42,_43,_44,_45,_46,_47,_48,_49,_50, \
         _51,_52,_53,_54,_55,_56,_57,_58,_59,_60, \
         _61,_62,_63,N,...) N
#define PREPROC_RSEQ_N() \
         63,62,61,60,                   \
         59,58,57,56,55,54,53,52,51,50, \
         49,48,47,46,45,44,43,42,41,40, \
         39,38,37,36,35,34,33,32,31,30, \
         29,28,27,26,25,24,23,22,21,20, \
         19,18,17,16,15,14,13,12,11,10, \
         9,8,7,6,5,4,3,2,1,0

#define PREPROC_REPEAT_N(n, what) PREPROC_REPEAT_N_(n, what)
#define PREPROC_REPEAT_N_(n, what) PREPROC_REPEAT_ ## n(what)
#define PREPROC_REPEAT_0(what)
#define PREPROC_REPEAT_1(what) what
#define PREPROC_REPEAT_2(what) PREPROC_REPEAT_1(what), what
#define PREPROC_REPEAT_3(what) PREPROC_REPEAT_2(what), what
#define PREPROC_REPEAT_4(what) PREPROC_REPEAT_3(what), what
#define PREPROC_REPEAT_5(what) PREPROC_REPEAT_4(what), what
#define PREPROC_REPEAT_6(what) PREPROC_REPEAT_5(what), what
#define PREPROC_REPEAT_7(what) PREPROC_REPEAT_6(what), what
#define PREPROC_REPEAT_8(what) PREPROC_REPEAT_7(what), what
#define PREPROC_REPEAT_9(what) PREPROC_REPEAT_8(what), what
#define PREPROC_REPEAT_10(what) PREPROC_REPEAT_9(what), what
#define PREPROC_REPEAT_11(what) PREPROC_REPEAT_10(what), what
#define PREPROC_REPEAT_12(what) PREPROC_REPEAT_11(what), what
#define PREPROC_REPEAT_13(what) PREPROC_REPEAT_12(what), what
#define PREPROC_REPEAT_14(what) PREPROC_REPEAT_13(what), what
#define PREPROC_REPEAT_15(what) PREPROC_REPEAT_14(what), what
#define PREPROC_REPEAT_16(what) PREPROC_REPEAT_15(what), what
#define PREPROC_REPEAT_17(what) PREPROC_REPEAT_16(what), what
#define PREPROC_REPEAT_18(what) PREPROC_REPEAT_17(what), what
#define PREPROC_REPEAT_19(what) PREPROC_REPEAT_18(what), what
#define PREPROC_REPEAT_20(what) PREPROC_REPEAT_19(what), what
#define PREPROC_REPEAT_21(what) PREPROC_REPEAT_20(what), what
#define PREPROC_REPEAT_22(what) PREPROC_REPEAT_21(what), what
#define PREPROC_REPEAT_23(what) PREPROC_REPEAT_22(what), what
#define PREPROC_REPEAT_24(what) PREPROC_REPEAT_23(what), what
#define PREPROC_REPEAT_25(what) PREPROC_REPEAT_24(what), what
#define PREPROC_REPEAT_26(what) PREPROC_REPEAT_25(what), what
#define PREPROC_REPEAT_27(what) PREPROC_REPEAT_26(what), what
#define PREPROC_REPEAT_28(what) PREPROC_REPEAT_27(what), what
#define PREPROC_REPEAT_29(what) PREPROC_REPEAT_28(what), what
#define PREPROC_REPEAT_30(what) PREPROC_REPEAT_29(what), what
#define PREPROC_REPEAT_31(what) PREPROC_REPEAT_30(what), what
#define PREPROC_REPEAT_32(what) PREPROC_REPEAT_31(what), what
#define PREPROC_REPEAT_33(what) PREPROC_REPEAT_32(what), what
#define PREPROC_REPEAT_34(what) PREPROC_REPEAT_33(what), what
#define PREPROC_REPEAT_35(what) PREPROC_REPEAT_34(what), what
#define PREPROC_REPEAT_36(what) PREPROC_REPEAT_35(what), what
#define PREPROC_REPEAT_37(what) PREPROC_REPEAT_36(what), what
#define PREPROC_REPEAT_38(what) PREPROC_REPEAT_37(what), what
#define PREPROC_REPEAT_39(what) PREPROC_REPEAT_38(what), what
#define PREPROC_REPEAT_40(what) PREPROC_REPEAT_39(what), what
#define PREPROC_REPEAT_41(what) PREPROC_REPEAT_40(what), what
#define PREPROC_REPEAT_42(what) PREPROC_REPEAT_41(what), what
#define PREPROC_REPEAT_43(what) PREPROC_REPEAT_42(what), what
#define PREPROC_REPEAT_44(what) PREPROC_REPEAT_43(what), what
#define PREPROC_REPEAT_45(what) PREPROC_REPEAT_44(what), what
#define PREPROC_REPEAT_46(what) PREPROC_REPEAT_45(what), what
#define PREPROC_REPEAT_47(what) PREPROC_REPEAT_46(what), what
#define PREPROC_REPEAT_48(what) PREPROC_REPEAT_47(what), what
#define PREPROC_REPEAT_49(what) PREPROC_REPEAT_48(what), what
#define PREPROC_REPEAT_50(what) PREPROC_REPEAT_49(what), what
#define PREPROC_REPEAT_51(what) PREPROC_REPEAT_50(what), what
#define PREPROC_REPEAT_52(what) PREPROC_REPEAT_51(what), what
#define PREPROC_REPEAT_53(what) PREPROC_REPEAT_52(what), what
#define PREPROC_REPEAT_54(what) PREPROC_REPEAT_53(what), what
#define PREPROC_REPEAT_55(what) PREPROC_REPEAT_54(what), what
#define PREPROC_REPEAT_56(what) PREPROC_REPEAT_55(what), what
#define PREPROC_REPEAT_57(what) PREPROC_REPEAT_56(what), what
#define PREPROC_REPEAT_58(what) PREPROC_REPEAT_57(what), what
#define PREPROC_REPEAT_59(what) PREPROC_REPEAT_58(what), what
#define PREPROC_REPEAT_60(what) PREPROC_REPEAT_59(what), what
#define PREPROC_REPEAT_61(what) PREPROC_REPEAT_60(what), what
#define PREPROC_REPEAT_62(what) PREPROC_REPEAT_61(what), what
#define PREPROC_REPEAT_63(what) PREPROC_REPEAT_62(what), what
#define PREPROC_REPEAT_64(what) PREPROC_REPEAT_63(what), what
