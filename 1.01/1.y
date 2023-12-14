%{
#include <stdio.h>
#include <string.h> 
#include <ctype.h>
int yydebug=1;
int yylex(void);
void yyerror(char *);

%}
%union {
    int integer;
    float floating_point;
    char* string;
}
%token /*VOID*/ FUNKTION MAIN INT IF WHILE FOR WRITE READ CALL NUM ID ELSE OP  /*BLBRACKET BRBRACKET SLBRACKET SRBRACKET SEMICOLON COMPARE*/
%token L "(" R ")" LL "{" RR "}" SEMI ";" ADD "+" MIN "-" MUL"*" DIV "/" EQL "="
%%
    program : fun_de_list  main_de {printf("NOW!\n");}
            ;

    fun_de_list : fun_de fun_de_list {}
                |/*empty*/
                ;
    fun_de  : FUNKTION ID "("  ")" fun_body {} 
            ;

    main_de : MAIN "(" ")" fun_body {}

    fun_body: "{" de_list stat_list "}"{}
            ;

    de_list :  de_stat {} de_list
            |   /*empty*/
            ;

    de_stat : INT ID ";" {}
            ;
    
    stat_list   : stat stat_list {} 
                |/*empty*/
                ;

    stat    : if_stat 
            | while_stat 
            | for_stat 
            | read_stat 
            | write_stat 
            | compound_stat 
            | expr_stat 
            | call_stat 
            ;

    if_stat : IF "(" expr ")"stat else_stat {}
            ;

    else_stat   : ELSE stat {}
                | /*empty*/
                ;

    while_stat  : WHILE "("expr")"stat {} 
                ;

    for_stat    : FOR "(" expr ";" expr ";" expr ")"stat {}
                ;

    write_stat  : WRITE expr ";" {}
                ;

    read_stat   : READ ID ";"{}
                ;

    expr_stat   : expr ";"
                | ";"
                ;

    compound_stat   : "{"stat_list "}" {}
                    ;

    call_stat   :   CALL ID "(" ")" {}
                ;
    expr    : ID "=" bool_expr {}
            |  bool_expr 
            ;

    bool_expr   : additive_expr {} 
                | additive_expr OP additive_expr {} 
                ;
    
    additive_expr   : term term_list {}
                    ;

    term_list   : "-"term term_list
                | "+"term term_list
                | /*empty*/
                ;
    term    : factor factor_list {}
            ;

    factor_list : "*"factor factor_list {}
                | "/"factor factor_list{}
                | /*empty*/
                ;
                
    factor  : "("additive_expr ")"
            | ID
            | NUM
            ;
%%
void yyerror(char *str){
    fprintf(stderr,"\nerror:%s\n",str);
}

int yywrap(){
    return 1;
}
int main(int argc, char** argv)
{
extern FILE* yyin;
    if(argc == 2){
	if((yyin = fopen(argv[1], "r")) == NULL){
	    printf("Can't open file %s\n", argv[1]);
	    return 1;
	}
    }

    yyparse();

    fclose(yyin);

    return 0;
}