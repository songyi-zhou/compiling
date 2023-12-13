%{
#include <stdlib.h>
#include <stdio.h>
#include "syntax_tree.h"
#include "syntax_tree.tab.h"
%}
%option yylineno

NUM [0-9]+
ALPHA [a-zA-Z]
ID  {ALPHA}({ALPHA}|{NUM})*
iderror {NUM}({ALPHA}|{NUM})*

/*十进制*/
INT_DEC 0|[1-9][0-9]*
/*十六进制*/
INT_HEX 0[xX][a-fA-F0-9]+
/*八进制*/
INT_OCT 0[1-7][0-7]*
/*二进制*/
INT_BIN 0[bB][01]+
/*INT类型汇总*/
INT {INT_HEX}|{INT_DEC}|{INT_OCT}|{INT_BIN}|{INT_HEX_ERROR}|{INT_OCT_ERROR}|{INT_BIN_ERROR}
/*词法分析输出错误，但是语法分析当做INT进行处理*/
/*十六进制错误*/
INT_HEX_ERROR 0[xX][a-fA-F0-9]*[g-zG-Z]+[a-fA-F0-9]*
/*八进制错误*/
INT_OCT_ERROR 0[0-7]*[89]+[0-7]*
/*二进制错误*/
INT_BIN_ERROR 0[bB][01]*[2-9]+[01]*
/*注释*/
COMMENT ("//".*)|("/*"([*]*(([^*/])+([/])*)*)*"*/")

COMPARE >|<|>=|<=|==|!=

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

/*未定义字符*/
AERROR .

%%
{NUM} {yylval.type_tnode=newAst("NUM",0,yylineno);return NUM;}
{if} {yylval.type_tnode=newAst("IF",0,yylineno);return IF;}
{main} {yylval.type_tnode=newAst("MAIN",0,yylineno);return MAIN;}
{int} {yylval.type_tnode=newAst("INT",0,yylineno);return INT;}
{else} {yylval.type_tnode=newAst("ELSE",0,yylineno);return ELSE;}
{for} {yylval.type_tnode=newAst("FOR",0,yylineno);return FOR;}
{while} {yylval.type_tnode=newAst("WHILE",0,yylineno);return WHILE;}
"function" {yylval.type_tnode=newAst("FUNCTION",0,yylineno);return FUNKTION;}
{write} {yylval.type_tnode=newAst("WRITE",0,yylineno);return WRITE;}
{read} {yylval.type_tnode=newAst("READ",0,yylineno);return READ;}
{call} {yylval.type_tnode=newAst("CALL",0,yylineno);return CALL;}
{ID} {yylval.type_tnode=newAst("ID",0,yylineno);return ID;}
"+"	{yylval.type_tnode=newAst("ADD",0,yylineno);return ADD;}
"-"	{yylval.type_tnode=newAst("MINUS",0,yylineno);return MIN;}
"*"	{yylval.type_tnode=newAst("MULTIPLE",0,yylineno);return MUL;}
"/"	{yylval.type_tnode=newAst("DIVIDE",0,yylineno);return DIV;}
"=" {yylval.type_tnode=newAst("EQUAL",0,yylineno);return EQL;}
"{" {yylval.type_tnode=newAst("BLBRACKET",0,yylineno);return BLBRACKET;}
"}" {yylval.type_tnode=newAst("BRBRACKET",0,yylineno);return BRBRACKET;}
"(" {yylval.type_tnode=newAst("SLBRACKET",0,yylineno);return SLBRACKET;}
")" {yylval.type_tnode=newAst("SRBRACKET",0,yylineno);return SRBRACKET;}
";" {yylval.type_tnode=newAst("SEMICOLON",0,yylineno);return SEMICOLON;}
{COMPARE} {yylval.type_tnode=newAst("COMPARE",0,yylineno);return COMPARE;}
{INT_HEX_ERROR} {printf("INT_HEX_ERROR at line %d: charachters \"%s\"\n",yylineno,yytext);}
{INT_OCT_ERROR} {printf("INT_OCT_ERROR at line %d: charachters \"%s\"\n",yylineno,yytext);}
{INT_BIN_ERROR} {printf("INT_BIN_ERROR at line %d: charachters \"%s\"\n",yylineno,yytext);}
{COMMENT} {}
{iderror} { 
    fprintf(yyout,"line:%10d\t%10s,%10s\n", yylineno,"error",yytext);
    }

"\n" /* ignore end of line */
"[ \t]+" /* ignore whitespace */;

%%
/*第四部分 函数 function*/
int yywrap()
{
	/*此函数必须由用户提供,或者声明 %option noyywrap
	当词法分析程序遇到文件结尾时，它调用例程yywrap()来找出下一步要做什么
	如果返回0，扫描程序继续扫描，如果返回1，扫描程序就返回报告文件结尾*/
    return 1;
}
