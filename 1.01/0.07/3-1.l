%{
#include <stdio.h>
#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif
#include "y.tab.h"
extern int yylineno;
%}
%option yylineno

NUM [0-9]+
ALPHA [a-zA-Z]
ID  {ALPHA}({ALPHA}|{NUM})*
iderror {NUM}({ALPHA}|{NUM})*
if [iI][fF]
else [eE][lL][sS]
for [fF][oO][rR]
while [wW][hH][iI][lL][eE]
int [iI][nN][tT]
void [vV][oO][iI][dD]
main    [mM][aA][iI][nN]
function [fF][uU][cC][tT][iI][oO][nN]
write [wW][rR][iI][tT][eE]
call  [cC][aA][lL]
read [rR][eE][aA][dD]


%%
{NUM} return NUM;
{if} return IF;
{main} {return MAIN;}
{int} return INT;
{else} return ELSE;
{for} return FOR;
{while} return WHILE;
"function" return FUNKTION;
{write} return WRITE;
{read} return READ;
{call} return CALL;
{ID} return ID;
"+"	return ADD;
"-"	return MIN;
"*"	return MUL;
"/"	return DIV;
"=" return EQL;
"{" return BLBRACKET;
"}" return BRBRACKET;
"(" return SLBRACKET;
")" return SRBRACKET;
";" return SEMICOLON;
"<" return COMPARE;
">" return COMPARE;
"==" return COMPARE;
"<=" return COMPARE;
">=" return COMPARE;
"!=" return COMPARE;
"/*"    {   char c ;
            int done=FALSE,flag=0;
            do
            {
              while((c=input())!='*')
                {
                if(c==EOF)
                  { 
                    flag = 1;
                    done = TRUE;
                    break;
                  }
                }
              if(flag== 1) break;
              while((c=input())=='*')
              {
                if(c==EOF)
                  { 
                    flag = 1;
                    done = TRUE;
                    break;
                  }
              }
              if(flag== 1) break;
              if(c=='/') done=TRUE;
            }while(!done);

        }

{iderror} { 
    fprintf(yyout,"line:%10d\t%10s,%10s\n", yylineno,"error",yytext);
    }

"\n" /* ignore end of line */{yylineno;}
"[ \t]+" /* ignore whitespace */;
.   
%%