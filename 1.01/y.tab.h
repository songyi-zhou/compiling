
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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
     FUNKTION = 258,
     MAIN = 259,
     IF = 260,
     WHILE = 261,
     FOR = 262,
     ELSE = 263,
     WRITE = 264,
     READ = 265,
     CALL = 266,
     INT = 267,
     NUM = 268,
     ID = 269,
     ADD = 270,
     MIN = 271,
     MUL = 272,
     DIV = 273,
     EQL = 274,
     COMPARE = 275,
     BLBRACKET = 276,
     BRBRACKET = 277,
     SLBRACKET = 278,
     SRBRACKET = 279,
     SEMICOLON = 280
   };
#endif
/* Tokens.  */
#define FUNKTION 258
#define MAIN 259
#define IF 260
#define WHILE 261
#define FOR 262
#define ELSE 263
#define WRITE 264
#define READ 265
#define CALL 266
#define INT 267
#define NUM 268
#define ID 269
#define ADD 270
#define MIN 271
#define MUL 272
#define DIV 273
#define EQL 274
#define COMPARE 275
#define BLBRACKET 276
#define BRBRACKET 277
#define SLBRACKET 278
#define SRBRACKET 279
#define SEMICOLON 280




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 13 "3-1.y"

    tnode type_tnode;
	// 这里声明double是为了防止出现指针错误（segmentation fault）
	double d;



/* Line 1676 of yacc.c  */
#line 110 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


