#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h> // 变长参数函数 头文件

/**********************语法分析**************************/
// 行数
extern int yylineno;
// 文本
extern char *yytext;
// 错误处理
void yyerror(char *msg);

// 抽象语法树
typedef struct treeNode
{
    // 行数
    int line;
    // Token类型
    char *name;
    // 1变量 2函数 3常数 4数组 5结构体
    int tag;
    // 使用孩子数组表示法
    struct treeNode *cld[10];
    int ncld;
    // 语义值
    char *content;
    // 数据类型 int 或 float
    char *type;
    // 变量的值
    float value;
} * Ast, *tnode;

// 构造抽象语法树(节点)
Ast newAst(char *name, int num, ...);

// 先序遍历语法树
void Preorder(Ast ast, int level);

// 所有节点数量
int nodeNum;
// 存放所有节点
tnode nodeList[5000];
int nodeIsChild[5000];
// 设置节点打印状态
void setChildTag(tnode node);

// bison是否有词法语法错误
int hasFault;

/**********************语义分析**************************/
// 分析语法树，建立符号表
void analysis(tnode val);

// 变量符号表的结点
typedef struct var_
{
    char *name;
    char *type;
    // 是否为结构体域
    int inStruc;
    // 所属的结构体编号
    int strucNum;
    struct var_ *next;
}var;
var  *varhead, *vartail;
// 建立变量符号
void newvar(int num,...);
// 变量是否已经定义
int  findvar(tnode val);
// 变量类型
char* typevar(tnode val);
// 这样赋值号左边仅能出现ID、Exp LB Exp RB 以及 Exp DOT ID
int checkleft(tnode val);

// 函数符号表的结点
typedef struct func_
{
    int tag; //0表示未定义，1表示定义
    char *name;
    char *type;
    // 是否为结构体域
    int inStruc;
    // 所属的结构体编号
    int strucNum;
    char *rtype; //声明返回值类型
    int va_num;  //记录函数形参个数
    char *va_type[10];
    struct func_ *next;
}func;
func *funchead,*functail;
// 记录函数实参
int va_num;
char* va_type[10];
void getdetype(tnode val);//定义的参数
void getretype(tnode val);//实际的参数
void getargs(tnode Args);//获取实参
int checkrtype(tnode ID,tnode Args);//检查形参与实参是否一致
// 建立函数符号
void newfunc(int num, ...);
// 函数是否已经定义
int findfunc(tnode val);
// 函数类型
char *typefunc(tnode val);
// 函数的形参个数
int numfunc(tnode val);
// 函数实际返回值类型
char *rtype[10];
int rnum;
void getrtype(tnode val);

// 数组符号表的结点
typedef struct array_
{
    char *name;
    char *type;
    // 是否为结构体域
    int inStruc;
    // 所属的结构体编号
    int strucNum;
    struct array_ *next;
}array;
array *arrayhead,*arraytail;
// 建立数组符号
void newarray(int num, ...);
// 查找数组是否已经定义
int findarray(tnode val);
// 数组类型
char *typearray(tnode val);

// 结构体符号表的结点
typedef struct struc_
{
    char *name;
    char *type;
    // 是否为结构体域
    int inStruc;
    // 所属的结构体编号
    int strucNum;
    struct struc_ *next;
}struc;
struc *struchead, *structail;
// 建立结构体符号
void newstruc(int num, ...);
// 查找结构体是否已经定义
int findstruc(tnode val);
// 当前是结构体域
int inStruc;
// 判断结构体域，{ 和 }是否抵消
int LCnum;
// 当前是第几个结构体
int strucNum;
