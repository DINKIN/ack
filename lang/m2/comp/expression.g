/*
 * (c) copyright 1987 by the Vrije Universiteit, Amsterdam, The Netherlands.
 * See the copyright notice in the ACK home directory, in the file "Copyright".
 *
 * Author: Ceriel J.H. Jacobs
 */

/* E X P R E S S I O N S */

/* $Header$ */

{
#include	"debug.h"

#include	<alloc.h>
#include	<em_arith.h>
#include	<em_label.h>
#include	<assert.h>

#include	"LLlex.h"
#include	"idf.h"
#include	"def.h"
#include	"node.h"
#include	"const.h"
#include	"type.h"
#include	"chk_expr.h"
#include	"warning.h"

extern char	options[];
}

/* inline, we need room for pdp/11
number(struct node **p;) :
[
	%default
	INTEGER
|
	REAL
]			{ *p = MkLeaf(Value, &dot);
			  (*p)->nd_type = toktype;
			}
;
*/

qualident(struct node **p;)
{
} :
	IDENT	{ *p = MkLeaf(Name, &dot); }
	[
		selector(p)
	]*
;

selector(struct node **pnd;):
	'.'	{ *pnd = MkNode(Link,*pnd,NULLNODE,&dot); }
	IDENT	{ (*pnd)->nd_IDF = dot.TOK_IDF; }
;

ExpList(struct node **pnd;)
{
	register struct node *nd;
} :
	expression(pnd)		{ *pnd = nd = MkNode(Link,*pnd,NULLNODE,&dot);
				  nd->nd_symb = ',';
				}
	[
		','		{ nd->nd_right = MkLeaf(Link, &dot);
				  nd = nd->nd_right;
				}
		expression(&(nd->nd_left))
	]*
;

ConstExpression(struct node **pnd;)
{
	register struct node *nd;
}:
	expression(pnd)
	/*
	 * Changed rule in new Modula-2.
	 * Check that the expression is a constant expression and evaluate!
	 */
		{ nd = *pnd;
		  DO_DEBUG(options['C'], print("CONSTANT EXPRESSION\n"));
		  DO_DEBUG(options['C'], PrNode(nd, 0));

		  if (ChkExpression(nd) &&
		      ((nd)->nd_class != Set && (nd)->nd_class != Value)) {
			error("constant expression expected");
		  }

		  DO_DEBUG(options['C'], print("RESULTS IN\n"));
		  DO_DEBUG(options['C'], PrNode(nd, 0));
		}
;

expression(struct node **pnd;)
{
} :
	SimpleExpression(pnd)
	[
		/* relation */
		[ '=' | '#' | '<' | LESSEQUAL | '>' | GREATEREQUAL | IN ]
			{ *pnd = MkNode(Oper, *pnd, NULLNODE, &dot); }
		SimpleExpression(&((*pnd)->nd_right))
	]?
;

/* Inline in expression
relation:
	'=' | '#' | '<' | LESSEQUAL | '>' | GREATEREQUAL | IN
;
*/

SimpleExpression(struct node **pnd;)
{
	register struct node *nd = 0;
} :
	[
		[ '+' | '-' ]
			{ nd = MkLeaf(Uoper, &dot);
			  /* priority of unary operator ??? */
			}
	]?
	term(pnd)
			{ if (nd) {
				nd->nd_right = *pnd;
				*pnd = nd;
			  }
			  nd = *pnd;
			}
	[
		/* AddOperator */
		[ '+' | '-' | OR ]
			{ nd = MkNode(Oper, nd, NULLNODE, &dot); }
		term(&(nd->nd_right))
	]*
			{ *pnd = nd; }
;

/* Inline in "SimpleExpression"
AddOperator:
	'+' | '-' | OR
;
*/

term(struct node **pnd;)
{
}:
	factor(pnd)
	[
		/* MulOperator */
		[ '*' | '/' | DIV | MOD | AND | '&' ]
			{ *pnd = MkNode(Oper, *pnd, NULLNODE, &dot); }
		factor(&((*pnd)->nd_right))
	]*
;

/* inline in "term"
MulOperator:
	'*' | '/' | DIV | MOD | AND | '&'
;
*/

factor(register struct node **p;)
{
	struct node *nd;
} :
	qualident(p)
	[
		designator_tail(p)?
		[
			{ *p = MkNode(Call, *p, NULLNODE, &dot); }
			ActualParameters(&((*p)->nd_right))
		]?
	|
		bare_set(&nd)
			{ nd->nd_left = *p; *p = nd; }
	]
|
	bare_set(p)
| %default
	[
		%default
		INTEGER
	|
		REAL
	|
		STRING
	]		{ *p = MkLeaf(Value, &dot);
			  (*p)->nd_type = toktype;
			}
|
	'(' 	{ nd = MkLeaf(Uoper, &dot); }
	expression(p)
		{ /*	In some cases we must leave the '(' as an unary
			operator, because otherwise we cannot see that the
			factor was not a designator
		  */
		  register int class = (*p)->nd_class;

		  if (class == Arrsel ||
		      class == Arrow ||
		      class == Name ||
		      class == Link) {
			nd->nd_right = *p;
			*p = nd;
		  }
		  else free_node(nd);
		}
	')'
|
	NOT		{ *p = MkLeaf(Uoper, &dot); }
	factor(&((*p)->nd_right))
;

bare_set(struct node **pnd;)
{
	register struct node *nd;
} :
	'{'		{ dot.tk_symb = SET;
			  *pnd = nd = MkLeaf(Xset, &dot);
			  nd->nd_type = bitset_type;
			}
	[
		element(nd)
		[	{ nd = nd->nd_right; }
			',' element(nd)
		]*
	]?
	'}'
;

ActualParameters(struct node **pnd;):
	'(' ExpList(pnd)? ')'
;

element(register struct node *nd;)
{
	struct node *nd1;
} :
	expression(&nd1)
	[
		UPTO
			{ nd1 = MkNode(Link, nd1, NULLNODE, &dot);}
		expression(&(nd1->nd_right))
	]?
			{ nd->nd_right = MkNode(Link, nd1, NULLNODE, &dot);
			  nd->nd_right->nd_symb = ',';
			}
;

designator(struct node **pnd;)
:
	qualident(pnd)
	designator_tail(pnd)?
;

designator_tail(struct node **pnd;):
	visible_designator_tail(pnd)
	[ %persistent
		%default
		selector(pnd)
	|
		visible_designator_tail(pnd)
	]*
;

visible_designator_tail(struct node **pnd;)
{
	register struct node *nd = *pnd;
}:
[
	'['		{ nd = MkNode(Arrsel, nd, NULLNODE, &dot); }
		expression(&(nd->nd_right))
		[
			','
			{ nd = MkNode(Arrsel, nd, NULLNODE, &dot);
			  nd->nd_symb = '[';
			}
			expression(&(nd->nd_right))
		]*
	']'
|
	'^'		{ nd = MkNode(Arrow, NULLNODE, nd, &dot); }
]
			{ *pnd = nd; }
;
