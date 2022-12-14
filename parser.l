/*** Definition iSection ***/
%{
#include <string.h>

#include <stdio.h>  
#include <math.h>  
#include <stdlib.h> 
#include "bison-parser.tab.h"

int errorFound = 0;
int lineNumber = 1;
 struct key_value {
          int key;
          char* value;
 
  };


%}

digit [0-9]*
integer 0|([1-9])[0-9]*
character [a-zA-Z]
vecId ([1-9])[0-9]*
INTEGER      [+-]?(0|[1-9][0-9]*)
STRING       \".*\"
OPERATORS    [-+/%]|==|!=|>|<|>>|<<|=
DELIMITATORS [|]|;|,|[)(}{]
ERROR             [A-Za-z]{9,}
BINARYNUMBER 		    0[bB][01]+
OCTNUMBER           0[0-7]+
HEXNUMBER           0[xX][0-9a-fA-F]+
DECNUMBER           [1-9][0-9]*
SUFFIXINT           ([uU]?([lLzZ]?|ll|LL))|(([lLzZ]?|ll|LL)[uU]?)
DIGITSEQUENCE       [0-9]+
DECIMALEXPONENT     [eE][+-]?
SUFFIXFLOAT         [fFlL]
HEXDIGITSEQUENCE    0[xX][0-9a-fA-F]+
HEXEXPONENT         [pP][+-]?

/*** Rule Section ***/
%%
					/* yytext is the text in the buffer */
int	{return (INTDECL);}
float {return (FLOATDECL);}
while {return (WHILESTMT);}
if {return (IFSTMT);}
cin {return (INOP);}
cout {return (OUTOP);}
return {return (RETURN);}
main {return (MAIN);}
repeta {return (REPETA);}
panacand {return (PANACAND);}
sfrepeta {return (SFREPETA);}
\- {return (MINUS);}
\+ return (PLUS);
\/ return (DIV);
"*" return (MUL);
\% return (MOD);
\== return (RELATION);
\!= return (RELATION);
\> return (RELATION);
\< return (RELATION);
\<< return (OUTOPF);
\>> return (INOPF);
\= return (EQUALS);
\; return (SEMICOLON);
\) return (RIGHT_PAR);
\( return (LEFT_PAR);
\{ return (LEFT_BR);
\} return (RIGHT_BR);
{ERROR}                             { errorFound = 1; printf("Illegal token %s at line %d !", yytext, lineNumber);printf("\n");return -1; }
({DECNUMBER}|0){SUFFIXINT}?  {return (INTEGER);}
{BINARYNUMBER}{SUFFIXINT}?   {return (INTEGER);}
{HEXNUMBER}{SUFFIXINT}? {return (INTEGER);}
{OCTNUMBER}{SUFFIXINT}?  {return (INTEGER);}
{DIGITSEQUENCE}{DECIMALEXPONENT}{DIGITSEQUENCE}{SUFFIXFLOAT}?   {return (FLOAT);}
{DIGITSEQUENCE}\.({DECIMALEXPONENT}{DIGITSEQUENCE})?{SUFFIXFLOAT}? {return (FLOAT);}
{DIGITSEQUENCE}?\.{DIGITSEQUENCE}({DECIMALEXPONENT}{DIGITSEQUENCE})?{SUFFIXFLOAT}? {return (FLOAT);}
{HEXDIGITSEQUENCE}{HEXEXPONENT}{DIGITSEQUENCE}{SUFFIXFLOAT}? {return (FLOAT);}
{HEXDIGITSEQUENCE}?\.{HEXDIGITSEQUENCE}{HEXEXPONENT}{DIGITSEQUENCE}{SUFFIXFLOAT}? {return (FLOAT);}
{HEXDIGITSEQUENCE}\.{HEXEXPONENT}{DIGITSEQUENCE}{SUFFIXFLOAT}? {return (FLOAT);}
{character}|{character}({character}{digit}){0,249} { return (ID);}
{character}"["{vecId}"]"|{character}({character}{digit}){0,249}"["{vecId}"]" {sscanf(yytext, "%s", yylval.id_vector); return (IDVECTOR);}

[\n]					{ ++lineNumber; }
[ \t\n]+             			{ ; /* eat up whitespace */ }
. {errorFound = 1; printf("Illegal token %s at line %d !", yytext, lineNumber);printf("\n");return -1;}
%%

/* yywrap() - wraps the above rule section */
int yywrap() {return 1;}

