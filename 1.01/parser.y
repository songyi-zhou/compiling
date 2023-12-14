%{
#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
    char* value;
    struct Node* left;
    struct Node* right;
} Node;

Node* create_node(char* value, Node* left, Node* right) {
    Node* node = (Node*) malloc(sizeof(Node));
    node->value = value;
    node->left = left;
    node->right = right;
    return node;
}

void print_ast(Node* node, int depth) {
    if (node == NULL) {
        return;
    }
    for (int i = 0; i < depth; i++) {
        printf("  ");
    }
    printf("%s\n", node->value);
    print_ast(node->left, depth + 1);
    print_ast(node->right, depth + 1);
}

%}

%token NUMBER
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%%

program:
    /* empty */
    | program statement
    ;

statement:
    expr '\n' { print_ast($1, 0); }
    ;

expr:
    NUMBER { $$ = create_node($1, NULL, NULL); }
    | expr '+' expr { $$ = create_node("+", $1, $3); }
    | expr '-' expr { $$ = create_node("-", $1, $3); }
    | expr '*' expr { $$ = create_node("*", $1, $3); }
    | expr '/' expr { $$ = create_node("/", $1, $3); }
    | '-' expr %prec UMINUS { $$ = create_node("-", NULL, $2); }
    | '(' expr ')' { $$ = $2; }
    ;

%%

int main() {
    yyparse();
    return 0;
}

int yyerror(char* s) {
    fprintf(stderr, "%s\n", s);
}

extern int yylex(); // declare yylex function

int main() {
    yyparse();
    return 0;
}

int yyerror(char* s) {
    fprintf(stderr, "%s\n", s);
}

int yylex() {
    int c = getchar();
    if (isdigit(c)) {
        ungetc(c, stdin);
        scanf("%d", &yylval);
        return NUMBER;
    }
    if (c == '+' || c == '-' || c == '*' || c == '/' || c == '(' || c == ')') {
        return c;
    }
    if (c == EOF) {
        return 0;
    }
    return -1;
}