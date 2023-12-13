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

%token VOID FUNCTION MAIN INT IF WHILE FOR ELSE WRITE READ CALL NUM ID ADD MIN MUL DIV EQL BLBRACKET BRBRACKET SLBRACKET SRBRACKET SEMICOLON COMPARE 

%%
    //    passage: HKEY MKEY BRBRACKET content BLBRACKET
    //             ;

    // //    line_list: line
    // //             | line_list line
    // //             ;

    //     content: judge
    //             | expression
    //             | judge content
    //             | expression content
    //             ;
				

    //   expression: term SEMICOLON
    //             | KEY ID SEMICOLON
    //             ;
    //         judge: KEY SLBRACKET single SRBRACKET BLBRACKET content BRBRACKET
    //             ;
    //         term: single
	// 			| term ALU single
	// 			;
				
	// 	  single: NUM
	// 			| ID
	// 			;
    // line_list: program
    //         | line_list program
    //         ;


    program : fun_de_list  main_declaration {printf("NOW!\n");}
            ;

    fun_de_list : fun_de fun_de_list {}
                |/*empty*/
                ;
    
    fun_de  : FUNKTION ID SLBRACKET SRBRACKET function_body {} 
            ;

	main_declaration:INT MAIN SLBRACKET SRBRACKET function_body{}
                    ;

	function_body : BLBRACKET declaration_list statement_list BRBRACKET{}
                 ;

	// declaration_list:declaration_list declaration_stat
    //                 |ε
    //                 ;

    declaration_list:
                    |declaration_stat {} declaration_list
                    ;

	declaration_stat:INT ID SEMICOLON{}
                    ; 

	// statement_list:statement_list statement
    //               |ε 
    //               ;

    statement_list:statement statement_list{}
                    |/*empty*/
                   ;

	statement:if_stat
             |while_stat
             |for_stat
             |read_stat
             |write_stat
             |compound_stat
             |expression_stat
             |call_stat
             ;

	if_stat:IF SLBRACKET expr SRBRACKET statement else_stat{}
            ;

    else_stat   : ELSE statement {}
                | /*empty*/
                ;

	while_stat: WHILE SLBRACKET expr SRBRACKET statement {}
                ; 

	for_stat: FOR SLBRACKET expr SEMICOLON expr SEMICOLON expr SRBRACKET statement{}
            ;
	
    write_stat:WRITE expr SEMICOLON{}
                ; 

	read_stat:READ ID SEMICOLON{}
            ; 

	expression_stat: expr SEMICOLON
                   |SEMICOLON
                   ;

    compound_stat:BLBRACKET statement_list BRBRACKET{}
                ;

	call_stat: CALL ID SLBRACKET SRBRACKET{}
            ;

    // expr:ID EQL NUM
    //     |ID COMPARE NUM
    //     |ID EQL ID
    //     |ID COMPARE ID
    //     ;

	expr:ID EQL bool_expr{}
              |bool_expr
              ; 

	// bool_expr:additive_expr 
    //           |additive_expr COMPARE additive_expr  
    //           ;

    bool_expr:additive_expr bool_expr_rest{}
             ;
	
    bool_expr_rest:COMPARE additive_expr bool_expr_rest{}
                  |
                  ;

    additive_expr:term additive_expr_rest{}
                 ;
	
    additive_expr_rest:ADD term additive_expr_rest
                      |MIN term additive_expr_rest
                      |
                      ;

    term:factor term_rest {}
        ;
	
    term_rest:MUL factor term_rest{}
             |DIV factor term_rest{}
             |
             ;

    factor:SLBRACKET  additive_expr SRBRACKET 
           |ID
           |NUM
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