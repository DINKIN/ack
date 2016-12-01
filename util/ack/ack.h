/*
 * (c) copyright 1987 by the Vrije Universiteit, Amsterdam, The Netherlands.
 * See the copyright notice in the ACK home directory, in the file "Copyright".
 */
#ifndef NORCSID
#define RCS_ACK "$Id$"
#endif

#include <stdlib.h> /* size_t, free() */

/****************************************************************************/
/*                      User settable options                               */
/****************************************************************************/

#define FRONTENDS       "fe"    /* The front-end definitions */
#define TMPNAME         "Ack_%x"     /* Naming of temp. files */

/****************************************************************************/
/*         Internal mnemonics, should not be tinkered with                  */
/****************************************************************************/

/* The names of some string variables */

#define HOME    "EM"
#define RTS     "RTS"
#define HEAD    "HEAD"
#define TAIL    "TAIL"
#define SRC     "SOURCE"
#define LIBVAR	"LNAME"
#define SUFFIX	"SUFFIX"

/* Intended for flags, possibly in bit fields */

#define YES     1
#define NO      0
#define MAYBE   2

#define EXTERN  extern

#define SUFCHAR '.'             /* Start of SUFFIX in file name */
#define SPACE   ' '
#define TAB     '\t'
#define EQUAL   '='
#define S_VAR   '{'             /* Start of variable */
#define C_VAR   '}'             /* End of variable */
#define A_VAR   '?'             /* Variable alternative */
#define BSLASH  '\\'            /* Backslash */
#define STAR    '*'             /* STAR */
#define C_IN    '<'             /* Token specifying input */
#define C_OUT   '>'             /* Token specifying output */
#define S_EXPR  '('             /* Start of expression */
#define C_EXPR  ')'             /* End of expression */
#define M_EXPR  ':'             /* Middle of two suffix lists */
#define T_EXPR  '='             /* Start of tail */

#define NO_SCAN 0200            /* Bit set in character to defeat recogn. */

typedef struct {
	char    *p_path;        /* points to the full pathname */
	int     p_keeps:1;      /* The string should be thrown when unused */
	int     p_keep:1;       /* The file should be thrown away after use */
} path ;

#define p_cont(elem) ((path *)l_content(elem))

/* Own routines */

/* rmach.c */
void setlist(char *);

/* svars.c */
void setsvar(char *, char *);
void setpvar(char *, char *(*)(void));
char *getvar(const char *);

/* util.c */
char *ack_basename(const char *);
char *skipblank(char *);
char *firstblank(char *);
void fatal(const char *, ...);
void vprint(const char *, ...);
void fuerror(const char *, ...);
void werror(const char *, ...);
void quit(int);
char *keeps(const char *);
#define throws(str)  free(str)
void *getcore(size_t);
void *changecore(void *, size_t);
#define freecore(area)  free(area)

#define DEBUG	1	/* Allow debugging of Ack */

#ifndef DEBUG
#  define debug 0       /* To surprise all these 'if ( debug ) 's */
#else
extern  int debug ;
#endif
