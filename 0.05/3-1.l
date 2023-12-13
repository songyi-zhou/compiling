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

%%
[0-9]+ return NUM;
if return IF;
main return MAIN;
int return INT;
else return ELSE;
for return FOR;
while return WHILE;
void return VOID;
function return FUNCTION;
write return WRITE;
read return READ;
call return CALL;
[a-zA-Z]([a-zA-Z]|[0-9])+ return ID;
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
.

\n /* ignore end of line */
[ \t]+ /* ignore whitespace */
%%