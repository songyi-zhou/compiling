
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
     INT = 260,
     IF = 261,
     WHILE = 262,
     FOR = 263,
     WRITE = 264,
     READ = 265,
     CALL = 266,
     NUM = 267,
     ID = 268,
     ELSE = 269,
     OP = 270,
     L = 271,
     R = 272,
     LL = 273,
     RR = 274,
     SEMI = 275,
     ADD = 276,
     MIN = 277,
     MUL = 278,
     DIV = 279,
     EQL = 280
   };
#endif
/* Tokens.  */
#define FUNKTION 258
#define MAIN 259
#define INT 260
#define IF 261
#define WHILE 262
#define FOR 263
#define WRITE 264
#define READ 265
#define CALL 266
#define NUM 267
#define ID 268
#define ELSE 269
#define OP 270
#define L 271
#define R 272
#define LL 273
#define RR 274
#define SEMI 275
#define ADD 276
#define MIN 277
#define MUL 278
#define DIV 279
#define EQL 280




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 10 "1.y"

    int integer;
    float floating_point;
    char* string;



/* Line 1676 of yacc.c  */
#line 110 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


