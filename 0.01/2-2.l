%{
#include<stdio.h>

#include<string.h>
// using namespace std;
#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif
char text[100][100];
int line[100];
int l=0;
%}
/*标明行号*/
%option yylineno 

digit [0-9]
number {digit}+
letter [a-zA-Z]
identifier {letter}({letter}|{digit})*
iderror {digit}({letter}|{digit})*
newline [\n]
whitespace  [\t ]+
if [iI][fF]
else [eE][lL][sS]
for [fF][oO][rR]
while [wW][hH][iI][lL][eE]
int [iI][nN][tT]
void [vV][oO][iI][dD]
main    [mM][aA][iI][nN]



%%
{if}    {fprintf(yyout,"%10s,%10s\n","if",yytext);}
{else}  {fprintf(yyout,"%10s,%10s\n","else",yytext);}
{for}   {fprintf(yyout,"%10s,%10s\n","for",yytext);}
{while} {fprintf(yyout,"%10s,%10s\n","while",yytext);}
{int}  {fprintf(yyout,"%10s,%10s\n","int",yytext);}
{void}  {fprintf(yyout,"%10s,%10s\n","void",yytext);}
{main}  {fprintf(yyout,"%10s,%10s\n","main",yytext);}
"="     {fprintf(yyout,"%10s,%10s\n",yytext,yytext);}
"+" {fprintf(yyout,"%10s,%10s\n",yytext,yytext);}
"-" {fprintf(yyout,"%10s,%10s\n",yytext,yytext);}
"*" {fprintf(yyout,"%10s,%10s\n",yytext,yytext);}
"/" {fprintf(yyout,"%10s,%10s\n",yytext,yytext);}
"<" {fprintf(yyout,"%10s,%10s\n",yytext,yytext);}
">" {fprintf(yyout,"%10s,%10s\n",yytext,yytext);} 
"{" {fprintf(yyout,"%10s,%10s\n",yytext,yytext);}
"}" {fprintf(yyout,"%10s,%10s\n",yytext,yytext);}
"(" {fprintf(yyout,"%10s,%10s\n",yytext,yytext);}
")" {fprintf(yyout,"%10s,%10s\n",yytext,yytext);}
";" {fprintf(yyout,"%10s,%10s\n",yytext,yytext);}
":" {fprintf(yyout,"%10s,%10s\n",yytext,yytext);}
"'" {fprintf(yyout,"%10s,%10s\n",yytext,yytext);}
"," {fprintf(yyout,"%10s,%10s\n",yytext,yytext);}
"!" {fprintf(yyout,"%10s,%10s\n",yytext,yytext);}
"=="    {fprintf(yyout,"%10s,%10s\n",yytext,yytext);}
">="    {fprintf(yyout,"%10s,%10s\n",yytext,yytext);}
"<="    {fprintf(yyout,"%10s,%10s\n",yytext,yytext);}
"!="    {fprintf(yyout,"%10s,%10s\n",yytext,yytext);}
{number}    {fprintf(yyout,"%10s,%10s\n","num",yytext);}
{identifier}    {fprintf(yyout,"%10s,%10s\n","ID",yytext);}
{iderror} { 
    line[l]=yylineno;
    strcpy(text[l],yytext);
    //fprintf(yyout,"%10s\n",text[l]);
    l++;
    //fprintf(yyout,"%10dline,L=%d\t%10s,%10s\n", yylineno,l,"error",yytext);

    }
{whitespace}    {/*跳过空白*/}

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
.       { 
    line[l]=yylineno;
    strcpy(text[l],yytext);
    //text[l]=yytext;
    l++;
    //fprintf(yyout,"%10dline,L=%d\t%10s,%10s\n", yylineno,l,"error",yytext);
    
    }

%%

int main(int argc, char **argv)
{
    int a=0;
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
    // freopen(argv[2],"w",stdout);
    
	 }
  }
  printf("\n53-周颂轶-2220214066\n");
  yylex();
  //printf("L=%d",l);
  while(a<l)
  {
    //printf("a=%d\n",a);
    printf("line:%d\terror\t",line[a]);
    printf("%10s\n",text[a]);
    //printf("a=%d\n",a);
    a++;
  }
}

int yywrap()
{
  return 1;
}
