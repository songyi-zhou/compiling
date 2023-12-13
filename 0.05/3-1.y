%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>
int yydebug=1;
extern int lineno=1;
extern int yylineno;
int yylex(void);
void yyerror(char *);
%}


%union {
    int integer;
    float floating_point;
    char* string;
}

%token /*VOID*/ FUNKTION MAIN INT IF WHILE FOR ELSE WRITE READ CALL NUM ID ADD MIN MUL DIV EQL BLBRACKET BRBRACKET SLBRACKET SRBRACKET SEMICOLON COMPARE 

%%
   
    program : fun_de_list main_declaration {printf("RIGHT\n");}
    // |error '\n' { yyerror("Syntax error"); }
            ;

    // fun_declaration: FUNCTION ID SLBRACKET SRBRACKET function_body{}
    //                 ;

    fun_de_list : fun_de fun_de_list {}
    //|error '\n' { yyerror("Syntax error"); }
                |/*empty*/
                ;
    
    fun_de: FUNKTION ID SLBRACKET SRBRACKET function_body {} 
    //|error '\n' { yyerror("Syntax error"); }
            ;

	main_declaration:MAIN SLBRACKET SRBRACKET function_body{}
                    // |error '\n' { yyerror("Syntax error"); }
                    

	function_body:BLBRACKET declaration_list statement_list BRBRACKET{}
    // |error '\n' { yyerror("Syntax error"); }
                 ;

	// declaration_list:declaration_list declaration_stat
    //                 |ε
    //                 ;

    declaration_list:
                    |declaration_stat {} declaration_list
                    // |error '\n' { yyerror("Syntax error"); }
                    ;

	declaration_stat:INT ID SEMICOLON{}
    // |error '\n' { yyerror("Syntax error"); }
                    ; 

	// statement_list:statement_list statement
    //               |ε 
    //               ;

    statement_list:statement statement_list{}
    // |error '\n' { yyerror("Syntax error"); }
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
            //  |error '\n' { yyerror("Syntax error"); }
             ;

	if_stat:IF SLBRACKET expr SRBRACKET statement else_stat{}
    // |error '\n' { yyerror("Syntax error"); }
            ;

    else_stat   : ELSE statement {}
                | /*empty*/
                // |error '\n' { yyerror("Syntax error"); }
                ;

	while_stat: WHILE SLBRACKET expr SRBRACKET statement {}
    // |error '\n' { yyerror("Syntax error"); }
                ; 

	for_stat: FOR SLBRACKET expr SEMICOLON expr SEMICOLON expr SRBRACKET statement{}
    // |error '\n' { yyerror("Syntax error"); }
            ;
	
    write_stat:WRITE expr SEMICOLON{}
    // |error '\n' { yyerror("Syntax error"); }
                ; 

	read_stat:READ ID SEMICOLON{}
    // |error '\n' { yyerror("Syntax error"); }
            ; 

	expression_stat: expr SEMICOLON
                   |SEMICOLON
                //    |error '\n' { yyerror("Syntax error"); }
                   ;

    compound_stat:BLBRACKET statement_list BRBRACKET{}
    // |error '\n' { yyerror("Syntax error"); }
                ;

	call_stat: CALL ID SLBRACKET SRBRACKET{}
    // |error '\n' { yyerror("Syntax error"); }
            ;

    // expr:ID EQL NUM
    //     |ID COMPARE NUM
    //     |ID EQL ID
    //     |ID COMPARE ID
    //     ;

	expr:ID EQL bool_expr{}
              |bool_expr
            //   |error '\n' { yyerror("Syntax error"); }
              ; 

	// bool_expr:additive_expr 
    //           |additive_expr COMPARE additive_expr  
    //           ;

    bool_expr:additive_expr bool_expr_rest{}
    // |error '\n' { yyerror("Syntax error"); }
             ;
	
    bool_expr_rest:COMPARE additive_expr bool_expr_rest{}
    // |error '\n' { yyerror("Syntax error"); }
                  |
                  ;

    additive_expr:term additive_expr_rest{}
    // |error '\n' { yyerror("Syntax error"); }
                 ;
	
    additive_expr_rest:ADD term additive_expr_rest
                      |MIN term additive_expr_rest
                      |
                    //   |error '\n' { yyerror("Syntax error"); }
                      ;

    term:factor term_rest {}
    // |error '\n' { yyerror("Syntax error"); }
        ;
	
    term_rest:MUL factor term_rest{}
             |DIV factor term_rest{}
            //  |error '\n' { yyerror("Syntax error"); }
             |
             ;

    factor:SLBRACKET  additive_expr SRBRACKET 
    // |error '\n' { yyerror("Syntax error"); }
           |ID
           |NUM
           ;

%%
// int yyerror(char *s) {
//     fprintf(stderr, "Error at line %d: %s\n", yylineno-1, s);
//     return 0;
// }
void yyerror(char *str){
    // fprintf(stderr,"\nerror:%s\n",str);
    fprintf(stderr, "Error at line %d: %s\n", yylineno-1, str);
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