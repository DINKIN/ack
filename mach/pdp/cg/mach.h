/* $Header$ */

/* The next define switches between codegeneration for an ACK assembler
 * or for the standard UNIX V7 assembler.
 * If on code is generated for the ACK assembler.
 */
/* #define ACK_ASS	/* code for ACK assembler */

#ifdef ACK_ASS
#define COMMENTCHAR '!'
#define ex_ap(y)	fprintf(codefile,".extern %s\n",y)
#else
#define COMMENTCHAR '/'
#define ex_ap(y)	fprintf(codefile,".globl %s\n",y)
#endif
#define in_ap(y)	/* nothing */

#define newplb(x)	doplb(x)
#define newilb(x)	fprintf(codefile,"%s:\n",x)
#define newdlb(x)	fprintf(codefile,"%s:\n",x)
#ifdef ACK_ASS
#define newlbss(l,x)	fprintf(codefile,"%s:.space 0%o\n",l,x);
#else
#define newlbss(l,x)	fprintf(codefile,"%s:.=.+0%o\n",l,x);
#endif

#define cst_fmt		"$0%o"
#define off_fmt		"0%o"
#define ilb_fmt		"I%03x%x"
#define dlb_fmt		"_%d"
#define	hol_fmt		"hol%d"

#define hol_off		"0%o+hol%d"

#ifdef ACK_ASS
#define con_cst(x)	fprintf(codefile,".short 0%o\n",x)
#define con_ilb(x)	fprintf(codefile,".short %s\n",x)
#define con_dlb(x)	fprintf(codefile,".short %s\n",x)
#else
#define con_cst(x)	fprintf(codefile,"0%o\n",x)
#define con_ilb(x)	fprintf(codefile,"%s\n",x)
#define con_dlb(x)	fprintf(codefile,"%s\n",x)
#endif

#define id_first	'_'
#define BSS_INIT	0
