#ifndef NORCSID
#define RCS_GROWS "$Header$"
#endif

/* struct used to identify and do bookkeeping for growing strings */

typedef struct {
	char            *gr_string ;    /* Points to start of string */
	unsigned        gr_size ;       /* Current string size */
	unsigned        gr_max ;        /* Maximum string size */
} growstring ;

#define GR_MORE         50      /* Steps to grow */

#define gr_start(id)    (id).gr_string  /* The start of the string */

/* Routines used */

extern  int     gr_throw() ;    /* To free the core */
extern  int     gr_add() ;      /* To add one character */
extern  int     gr_cat() ;      /* concatenate the contents and the string */
extern  int     gr_init() ;     /* Initialize the bookkeeping */
extern  char    *gr_final() ;   /* Transform to a stable storage string */
