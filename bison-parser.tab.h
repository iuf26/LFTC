/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     SFREPETA = 258,
     PANACAND = 259,
     REPETA = 260,
     OUTOPF = 261,
     INOPF = 262,
     RETURN = 263,
     MAIN = 264,
     LEFT_PAR = 265,
     RIGHT_PAR = 266,
     LEFT_BR = 267,
     RIGHT_BR = 268,
     PLUS = 269,
     MINUS = 270,
     DIV = 271,
     MUL = 272,
     MOD = 273,
     INOP = 274,
     OUTOP = 275,
     IFSTMT = 276,
     WHILESTMT = 277,
     INTDECL = 278,
     FLOATDECL = 279,
     EQUALS = 280,
     INTEGER = 281,
     FLOAT = 282,
     OTHER = 283,
     SEMICOLON = 284,
     ID = 285,
     IDVECTOR = 286,
     RELATION = 287
   };
#endif
/* Tokens.  */
#define SFREPETA 258
#define PANACAND 259
#define REPETA 260
#define OUTOPF 261
#define INOPF 262
#define RETURN 263
#define MAIN 264
#define LEFT_PAR 265
#define RIGHT_PAR 266
#define LEFT_BR 267
#define RIGHT_BR 268
#define PLUS 269
#define MINUS 270
#define DIV 271
#define MUL 272
#define MOD 273
#define INOP 274
#define OUTOP 275
#define IFSTMT 276
#define WHILESTMT 277
#define INTDECL 278
#define FLOATDECL 279
#define EQUALS 280
#define INTEGER 281
#define FLOAT 282
#define OTHER 283
#define SEMICOLON 284
#define ID 285
#define IDVECTOR 286
#define RELATION 287




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 20 "bison-parser.y"
{
	  char id[250];
      char id_vector[250];
      int int_number;
      float float_number;
}
/* Line 1529 of yacc.c.  */
#line 120 "bison-parser.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

