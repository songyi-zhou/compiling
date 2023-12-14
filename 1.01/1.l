%{
#include <stdio.h>
#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif
#include "y.tab.h"
%}

NUM [0-9]+
ALPHA [a-zA-Z]
ID  {ALPHA}+[a-zA-Z0-9_]*
OP  >|<|>=|<=|==|!= 

%%
"function"  return FUNKTION;
"main"      {return MAIN;}
"int"       return INT;
"if"        return IF;
"while"     return WHILE;
"for"       return FOR;
"write"     return WRITE;
"read"      return READ;
"call"      return CALL;
{NUM}       return NUM;
{ID}        return ID;
{OP}        return OP;
"else"      return ELSE;
"("         return L;
")"         return R;
"{"         return LL;
"}"         return RR;
";"         return SEMI;
"+"         return ADD;
"-"         return MIN;
"*"         return MUL;
"="         return EQL;
"/*"      {   char c ;
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
"\n" /* ignore end of line */;
" \t"+ /* ignore whitespace */;
.

%%