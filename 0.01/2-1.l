%{
#include<stdio.h>
#include<string.h>
#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif
%}
%option yylineno

digit [0-9]
number {digit}+
letter [a-zA-Z]
identifier {letter}({letter}|{digit})*
iderror {digit}({letter}|{digit})*
newline [\n]
whitespace  [\t ]+

%%
"if"    {fprintf(yyout,"%s,%s\n",yytext,yytext);}
"else"  {fprintf(yyout,"%s,%s\n",yytext,yytext);}
"for"   {fprintf(yyout,"%s,%s\n",yytext,yytext);}
"while" {fprintf(yyout,"%s,%s\n",yytext,yytext);}
"int"   {fprintf(yyout,"%s,%s\n",yytext,yytext);}
"="     {fprintf(yyout,"%s,%s\n",yytext,yytext);}
"+" {fprintf(yyout,"%s,%s\n",yytext,yytext);}
"-" {fprintf(yyout,"%s,%s\n",yytext,yytext);}
"*" {fprintf(yyout,"%s,%s\n",yytext,yytext);}
"/" {fprintf(yyout,"%s,%s\n",yytext,yytext);}
"<" {fprintf(yyout,"%s,%s\n",yytext,yytext);}
">" {fprintf(yyout,"%s,%s\n",yytext,yytext);}
"{" {fprintf(yyout,"%s,%s\n",yytext,yytext);}
"}" {fprintf(yyout,"%s,%s\n",yytext,yytext);}
"(" {fprintf(yyout,"%s,%s\n",yytext,yytext);}
")" {fprintf(yyout,"%s,%s\n",yytext,yytext);}
";" {fprintf(yyout,"%s,%s\n",yytext,yytext);}
":" {fprintf(yyout,"%s,%s\n",yytext,yytext);}
"'" {fprintf(yyout,"%s,%s\n",yytext,yytext);}
"," {fprintf(yyout,"%s,%s\n",yytext,yytext);}
"!" {fprintf(yyout,"%s,%s\n",yytext,yytext);}
"=="    {fprintf(yyout,"%s,%s\n",yytext,yytext);}
">="    {fprintf(yyout,"%s,%s\n",yytext,yytext);}
"<="    {fprintf(yyout,"%s,%s\n",yytext,yytext);}
"!="    {fprintf(yyout,"%s,%s\n",yytext,yytext);}
{number}    {fprintf(yyout,"%s,%s\n","num",yytext);}
{identifier}    {fprintf(yyout,"%s,%s\n","ID",yytext);}
{iderror} { fprintf(yyout,"%dline,%s,%s\n", yylineno,"error",yytext);}
{whitespace}    {/*跳过空白*/}

"/*"    {   char c ;
            int done=FALSE,flag=0,count=0,n=0;
            char space[500];
            do
            {
              while((c=input())!='*')
                {
                    space[count]=c;
                    count++;
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
            if (flag==1)
            {
                n=count;
                count = 0;
                while(count<=n)
                {
                    fprintf(yyout,"%s,%s\n",space[count],space[count]);
                    count++;
                }
            }

        }
.       { fprintf(yyout,"%dline,%s,%s\n", yylineno,"error",yytext);}
%%

int main(int argc, char **argv)
{
  if (argc>1)
  {
    FILE *file;
	file=fopen(argv[1],"r");
	if(file)
	  yyin=file;
  }
  if (argc>2)
  {
	FILE *file;
	file=fopen(argv[2],"w");
	if(file)
	{
	  yyout=file;
	  freopen(argv[2],"w",stdout);
	 }
  }
  
  yylex();
}

int yywrap()
{
  return 1;
}
