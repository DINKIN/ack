/* $Header$ */

/* language-dependent routines and formats, together in one structure: */

struct langdep {
  /* formats (for fprintf): */
  char	*decint_fmt;		/* decimal ints (format for long) */
  char	*octint_fmt;		/* octal ints (format for long) */
  char	*hexint_fmt;		/* hexadecimal ints (format for long) */
  char	*uns_fmt;		/* unsigneds (format for long) */
  char	*addr_fmt;		/* address (format for long) */
  char	*real_fmt;		/* real (format for double) */
  char	*char_fmt;		/* character (format for int) */

  /* display openers and closers: */
  char	*open_array_display;
  char	*close_array_display;
  char	*open_struct_display;
  char	*close_struct_display;
  char	*open_set_display;
  char	*close_set_display;

  /* language dependant routines: */
  int	(*printstring)();
  long	(*arrayelsize)();
};

extern struct langdep	*m2_dep, *currlang;

extern int find_language();

extern int init_languages();