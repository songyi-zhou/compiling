%{
#include <stdio.h>
#include <string.h>
#include<unistd.h>
#include <ctype.h>
#include "syntax_tree.h"
int yydebug=1;


%}


%union {
    tnode type_tnode;
	// 这里声明double是为了防止出现指针错误（segmentation fault）
	double d;
}

/*声明记号*/
%token <type_tnode> FUNKTION MAIN 
%token <type_tnode> IF WHILE FOR ELSE WRITE READ CALL 
%token <type_tnode> INT NUM ID 
%token <type_tnode> ADD MIN MUL DIV EQL COMPARE
%token <type_tnode> BLBRACKET BRBRACKET SLBRACKET SRBRACKET SEMICOLON

%type <type_tnode> program ExtDefList function_def function_body declaration_list declaration_stat statement_list statement 
%type <type_tnode> if_stat else_stat while_stat for_stat write_stat read_stat compound_stat expression_stat call_stat expr
%type <type_tnode> bool_expr bool_expr_rest additive_expr additive_expr_rest term term_rest factor

/*优先级*/
%right EQL

%left ADD MIN
%left MUL DIV
%left BLBRACKET BRBRACKET SLBRACKET SRBRACKET
%left COMPARE

%nonassoc ELSE

%%
    program : ExtDefList {$$=newAst("program",1,$1);nodeList[nodeNum]=$$;nodeNum++;}

    ExtDefList : function_def {$$=newAst("ExtDefList",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
            ;
    
    function_def : INT FUNKTION SLBRACKET SRBRACKET function_body function_def {$$=newAst("function declaration",6,$1,$2,$3,$4,$5,$6);nodeList[nodeNum]=$$;nodeNum++;}
                |INT MAIN SLBRACKET SRBRACKET function_body function_def {$$=newAst("function declaration",6,$1,$2,$3,$4,$5,$6);nodeList[nodeNum]=$$;nodeNum++;}
                |/*empty*/ {$$=newAst("function declaration",0,-1);nodeList[nodeNum]=$$;nodeNum++;}
                ;

    // fun_de_list : fun_de fun_de_list {$$=newAst("function declaration list",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;}
    //             |/*empty*/ {$$=newAst("function declaration list",0,-1);nodeList[nodeNum]=$$;nodeNum++;}
    //             ;
    
    // fun_de: FUNKTION ID SLBRACKET SRBRACKET function_body {$$=newAst("function declaration",5,$1,$2,$3,$4,$5);nodeList[nodeNum]=$$;nodeNum++;} 
    //         ;

	// main_declaration:INT MAIN SLBRACKET SRBRACKET function_body {$$=newAst("main declaration",5,$1,$2,$3,$4,$5);nodeList[nodeNum]=$$;nodeNum++;}
    //                 ;
                    

	function_body:BLBRACKET declaration_list statement_list BRBRACKET {$$=newAst("function_body",4,$1,$2,$3,$4);nodeList[nodeNum]=$$;nodeNum++;}
                 ;

    declaration_list:/*empty*/ {$$=newAst("declaration list",0,-1);nodeList[nodeNum]=$$;nodeNum++;}
                    |declaration_stat  declaration_list {$$=newAst("declaration list",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;}
                    ;

	declaration_stat:INT ID SEMICOLON {$$=newAst("declaration stat",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
                    ; 


    statement_list:statement statement_list {$$=newAst("statement list",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;}
                    |/*empty*/ {$$=newAst("statement list",0,-1);nodeList[nodeNum]=$$;nodeNum++;}
                   ;

	statement:if_stat {$$=newAst("statement",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
             |while_stat {$$=newAst("statement",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
             |for_stat {$$=newAst("statement",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
             |read_stat {$$=newAst("statement",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
             |write_stat {$$=newAst("statement",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
             |compound_stat {$$=newAst("statement",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
             |expression_stat {$$=newAst("statement",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
             |call_stat {$$=newAst("statement",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
             ;

	if_stat:IF SLBRACKET expr SRBRACKET statement else_stat {$$=newAst("if stat",6,$1,$2,$3,$4,$5,$6);nodeList[nodeNum]=$$;nodeNum++;}
            ;

    else_stat   : ELSE statement {$$=newAst("else stat",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;}
                | /*empty*/ {$$=newAst("else stat",0,-1);nodeList[nodeNum]=$$;nodeNum++;}
                ;

	while_stat: WHILE SLBRACKET expr SRBRACKET statement {$$=newAst("while stat",5,$1,$2,$3,$4,$5);nodeList[nodeNum]=$$;nodeNum++;}
                ; 

	for_stat: FOR SLBRACKET expr SEMICOLON expr SEMICOLON expr SRBRACKET statement {$$=newAst("for stat",9,$1,$2,$3,$4,$5,$6,$7,$8,$9);nodeList[nodeNum]=$$;nodeNum++;}
            ;
	
    write_stat:WRITE expr SEMICOLON {$$=newAst("write stat",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
                ; 

	read_stat:READ ID SEMICOLON {$$=newAst("read stat",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
            ; 

	expression_stat: expr SEMICOLON {$$=newAst("expression stat",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;}
                   |SEMICOLON {$$=newAst("expression stat",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
                   ;

    compound_stat:BLBRACKET statement_list BRBRACKET {$$=newAst("compound stat",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
                ;

	call_stat: CALL ID SLBRACKET SRBRACKET {$$=newAst("call stat",4,$1,$2,$3,$4);nodeList[nodeNum]=$$;nodeNum++;}
            ;

	expr:ID EQL bool_expr {$$=newAst("bool stat",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
        |bool_expr {$$=newAst("bool stat",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
        ; 

	
    bool_expr:additive_expr bool_expr_rest {$$=newAst("bool expr",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;}
             ;
	
    bool_expr_rest:COMPARE additive_expr bool_expr_rest {$$=newAst("bool expr rest",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
                  |/*empty*/{$$=newAst("bool expr rest",0,-1);nodeList[nodeNum]=$$;nodeNum++;}
                  ;

    additive_expr:term additive_expr_rest {$$=newAst("additive expr",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;}
                 ;
	
    additive_expr_rest:ADD term additive_expr_rest {$$=newAst("additive expr rest",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
                      |MIN term additive_expr_rest {$$=newAst("additive expr rest",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
                      |/*empty*/{$$=newAst("additive expr rest",0,-1);nodeList[nodeNum]=$$;nodeNum++;}
                      ;

    term:factor term_rest {$$=newAst("term",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;}
        ;
	
    term_rest:MUL factor term_rest {$$=newAst("term rest",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
             |DIV factor term_rest {$$=newAst("term rest",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
             |/*empty*/{$$=newAst("term rest",0,-1);nodeList[nodeNum]=$$;nodeNum++;}
             ;

    factor:SLBRACKET additive_expr SRBRACKET {$$=newAst("factor",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
           |ID {$$=newAst("factor",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
           |NUM {$$=newAst("factor",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
           ;

%%
