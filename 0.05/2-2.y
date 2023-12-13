%{
#include <stdio.h>
#include <string.h>
int yylex(void);
void yyerror(char *);
%}



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


    program:main_declaration
            |fun_declaration{fun_declaration} main_declaration
            ;

    fun_declaration: FUNCTION ID SLBRACKET SRBRACKET function_body
                     ;

	main_declaration: MAIN SLBRACKET SRBRACKET function_body
                    ;

	function_body: BLBRACKET declaration_list statement_list BRBRACKET
                 ;

	// declaration_list:declaration_list declaration_stat
    //                 |ε
    //                 ;

    declaration_list:
                    |declaration_stat{declaration_stat}
                    ;

	declaration_stat:INT ID SEMICOLON
                    ; 

	// statement_list:statement_list statement
    //               |ε 
    //               ;

    statement_list:
                |statement{statement}
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

	if_stat:IF SLBRACKET expr SRBRACKET statement 
            ;

	while_stat: WHILE SLBRACKET expr SRBRACKET statement ; 

	for_stat: FOR SLBRACKET expr SEMICOLON expr SEMICOLON expr SRBRACKET statement;
	
    write_stat:WRITE expression SEMICOLON; 

	read_stat:READ ID SEMICOLON; 

	compound_stat:BLBRACKET statement_list BRBRACKET;

	expression_stat: expression SEMICOLON
                   |SEMICOLON
                   ;

	call_stat: CALL ID SLBRACKET SRBRACKET;

    expr:ID EQL NUM
        |ID COMPARE NUM
        |ID EQL ID
        |ID COMPARE ID
        ;

	expression:ID EQL bool_expr
              |bool_expr
              ; 

	// bool_expr:additive_expr 
    //           |additive_expr COMPARE additive_expr  
    //           ;

    bool_expr:additive_expr{COMPARE additive_expr};
	
    additive_expr:term{(ADD|MIN) term };
	
    term:factor{(MUL|DIV) factor };
	
    factor:SLBRACKET  additive_expr SRBRACKET 
           |ID
           |NUM
           ;

%%
void yyerror(char *str){
    fprintf(stderr,"error:%s\n",str);
}

int yywrap(){
    return 1;
}
int main()
{
    yyparse();
}