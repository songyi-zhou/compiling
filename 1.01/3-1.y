%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>
int yydebug=1;
extern int lineno=1;
extern int yylineno;
int yylex(void);
void yyerror(char *);

typedef struct program_node {
    char* value;
    struct Node* left;
    struct Node* right;
} Node;

// Node* create_node(char* value, Node* left, Node* right) {
//     Node* node = (Node*) malloc(sizeof(Node));
//     node->value = value;
//     node->left = left;
//     node->right = right;
//     return node;
// }

// void print_ast(Node* node, int depth) {
//     if (node == NULL) {
//         return;
//     }
//     for (int i = 0; i < depth; i++) {
//         printf("  ");
//     }
//     printf("%s\n", node->value);
//     print_ast(node->left, depth + 1);
//     print_ast(node->right, depth + 1);
// }

%}


%union {
    int integer;
    float floating_point;
    char* string;
}

%token /*VOID*/ FUNKTION MAIN INT IF WHILE FOR ELSE WRITE READ CALL NUM ID ADD MIN MUL DIV EQL BLBRACKET BRBRACKET SLBRACKET SRBRACKET SEMICOLON COMPARE 

%%
   
    program : fun_de_list main_declaration {printf("line:%d\tprogram done\n",yylineno);lineno=yylineno;}// print_ast($1,0)}
    // |error '\n' { yyerror("Syntax error"); }
            ;

    // fun_declaration: FUNCTION ID SLBRACKET SRBRACKET function_body{}
    //                 ;

    fun_de_list : fun_de fun_de_list {printf("line:%d\tfunction declaration list done\n",yylineno);lineno=yylineno;}
    //|error '\n' { yyerror("Syntax error"); }
                |/*empty*/{printf("line:%d\tfunction declaration list empty done\n",yylineno);lineno=yylineno;}
                ;
    
    fun_de: FUNKTION ID SLBRACKET SRBRACKET function_body {printf("line:%d\tfunction declaration done\n",yylineno);lineno=yylineno;lineno=yylineno;} 
    //|error '\n' { yyerror("Syntax error"); }
            ;

	main_declaration:MAIN SLBRACKET SRBRACKET function_body{printf("line:%d\tmain decalrtion done\n",yylineno);lineno=yylineno;}
                    // |error '\n' { yyerror("Syntax error"); }
                    

	function_body:BLBRACKET declaration_list statement_list BRBRACKET{printf("line:%d\tfunction body done\n",yylineno);lineno=yylineno;}
    // |error '\n' { yyerror("Syntax error"); }
                 ;

	// declaration_list:declaration_list declaration_stat
    //                 |ε
    //                 ;

    declaration_list:{printf("line:%d\tdeclaration list empty done\n",yylineno);lineno=yylineno;}
                    |declaration_stat  declaration_list{printf("line:%d\tdeclaration list done\n",yylineno);lineno=yylineno;}
                    // |error '\n' { yyerror("Syntax error"); }
                    ;

	declaration_stat:INT ID SEMICOLON{printf("line:%d\tdeclaration stat done\n",yylineno);lineno=yylineno;}
    // |error '\n' { yyerror("Syntax error"); }
                    ; 

	// statement_list:statement_list statement
    //               |ε 
    //               ;

    statement_list:statement statement_list{printf("line:%d\tstatement list done\n",yylineno);lineno=yylineno;}
    // |error '\n' { yyerror("Syntax error"); }
                    |/*empty*/{printf("line:%d\tstatement list empty done\n",yylineno);lineno=yylineno;}
                   ;

	statement:if_stat{printf("line:%d\tstatement if done\n",yylineno);lineno=yylineno;}
             |while_stat{printf("line:%d\tstatement while done\n",yylineno);lineno=yylineno;}
             |for_stat{printf("line:%d\tstatement for done\n",yylineno);lineno=yylineno;}
             |read_stat{printf("line:%d\tstatement read done\n",yylineno);lineno=yylineno;}
             |write_stat{printf("line:%d\n",yylineno);lineno=yylineno;}
             |compound_stat{printf("line:%d\tstatement compound done\n",yylineno);lineno=yylineno;}
             |expression_stat{printf("line:%d\tstatement expression done\n",yylineno);lineno=yylineno;}
             |call_stat{printf("line:%d\n",yylineno);lineno=yylineno;}
            //  |error '\n' { yyerror("Syntax error"); }
            {printf("line:%d\n",yylineno);lineno=yylineno;}
             ;

	if_stat:IF SLBRACKET expr SRBRACKET statement else_stat{printf("line:%d\tif done\n",yylineno);lineno=yylineno;}
    // |error '\n' { yyerror("Syntax error"); }
            ;

    else_stat   : ELSE statement {printf("line:%d\tesle done\n",yylineno);lineno=yylineno;}
                | /*empty*/{printf("line:%d\telse empty done\n",yylineno);lineno=yylineno;}
                // |error '\n' { yyerror("Syntax error"); }
                ;

	while_stat: WHILE SLBRACKET expr SRBRACKET statement {printf("line:%d\twhile done\n",yylineno);lineno=yylineno;}
    // |error '\n' { yyerror("Syntax error"); }
                ; 

	for_stat: FOR SLBRACKET expr SEMICOLON expr SEMICOLON expr SRBRACKET statement{printf("line:%d\tfor done\n",yylineno);lineno=yylineno;}
    // |error '\n' { yyerror("Syntax error"); }
            ;
	
    write_stat:WRITE expr SEMICOLON{printf("line:%d\twrite done\n",yylineno);lineno=yylineno;}
    // |error '\n' { yyerror("Syntax error"); }
                ; 

	read_stat:READ ID SEMICOLON{printf("line:%d\n",yylineno);lineno=yylineno;}
    // |error '\n' { yyerror("Syntax error"); }
            ; 

	expression_stat: expr SEMICOLON{printf("line:%d\texpression done\n",yylineno);lineno=yylineno;}
                   |SEMICOLON
                   {printf("line:%d\texpression empty done\n",yylineno);lineno=yylineno;}
                //    |error '\n' { yyerror("Syntax error"); }
                   ;

    compound_stat:BLBRACKET statement_list BRBRACKET{printf("line:%d\tcompound done\n",yylineno);lineno=yylineno;}
    // |error '\n' { yyerror("Syntax error"); }
                ;

	call_stat: CALL ID SLBRACKET SRBRACKET{printf("line:%d\n",yylineno);lineno=yylineno;}
    // |error '\n' { yyerror("Syntax error"); }
            ;

    // expr:ID EQL NUM
    //     |ID COMPARE NUM
    //     |ID EQL ID
    //     |ID COMPARE ID
    //     ;

	expr:ID EQL bool_expr{printf("line:%d\tEQL expr done\n",yylineno);lineno=yylineno;}
              |bool_expr{printf("line:%d\texpr done\n",yylineno);lineno=yylineno;}
            //   |error '\n' { yyerror("Syntax error"); }
              ; 

	// bool_expr:additive_expr 
    //           |additive_expr COMPARE additive_expr  
    //           ;

    bool_expr:additive_expr bool_expr_rest{printf("line:%d\tbool expr done\n",yylineno);lineno=yylineno;}
    // |error '\n' { yyerror("Syntax error"); }
             ;
	
    bool_expr_rest:COMPARE additive_expr bool_expr_rest{printf("line:%d\tbool expr rest done\n",yylineno);lineno=yylineno;}
    // |error '\n' { yyerror("Syntax error"); }
                  |{printf("line:%d\tbool expr rest empty done\n",yylineno);lineno=yylineno;}
                  ;

    additive_expr:term additive_expr_rest{printf("line:%d\tadditive expr done\n",yylineno);lineno=yylineno;}
    // |error '\n' { yyerror("Syntax error"); }
                 ;
	
    additive_expr_rest:ADD term additive_expr_rest{printf("line:%d\tadditive expr rest add done\n",yylineno);lineno=yylineno;}
                      |MIN term additive_expr_rest{printf("line:%d\tadditive expr rest min done\n",yylineno);lineno=yylineno;}
                      |{printf("line:%d\tadditive expr rest empty done\n",yylineno);lineno=yylineno;}
                    //   |error '\n' { yyerror("Syntax error"); }
                      ;

    term:factor term_rest {printf("line:%d\tterm done\n",yylineno);lineno=yylineno;}
    // |error '\n' { yyerror("Syntax error"); }
        ;
	
    term_rest:MUL factor term_rest{printf("line:%d\tterm rest mul done\n",yylineno);lineno=yylineno;}
             |DIV factor term_rest{printf("line:%d\tterm rest div done\n",yylineno);lineno=yylineno;}
            //  |error '\n' { yyerror("Syntax error"); }
             |{printf("line:%d\t term rest qmpty done\n",yylineno);lineno=yylineno;}
             ;

    factor:SLBRACKET  additive_expr SRBRACKET {printf("line:%d\tfactor done\n",yylineno);lineno=yylineno;}
    // |error '\n' { yyerror("Syntax error"); }
           |ID{printf("line:%d\tfactor id done\n",yylineno);lineno=yylineno;}
           |NUM{printf("line:%d\tfactor num done\n",yylineno);lineno=yylineno;}
           ;

%%
// int yyerror(char *s) {
//     fprintf(stderr, "Error at line %d: %s\n", yylineno-1, s);
//     return 0;
// }
void yyerror(char *str){
    // fprintf(stderr,"\nerror:%s\n",str);
    fprintf(stderr, "Error at line %d: %s\n",lineno, str);
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