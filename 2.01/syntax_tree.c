#include "syntax_tree.h"

// 用于遍历
int i;

Ast newAst(char *name, int num, ...)
{
    //printf("new tree AST\n");
    // 生成父节点
    tnode father = (tnode)malloc(sizeof(struct treeNode));
    memset(father,0,sizeof(struct treeNode));
    // 添加子节点
    tnode temp = (tnode)malloc(sizeof(struct treeNode));
    memset(temp,0,sizeof(struct treeNode));
    if (!father)
    {
        yyerror("create treenode error");
        exit(0);
    }
    father->name = name;

    // 参数列表，详见 stdarg.h 用法
    va_list list;
    // 初始化参数列表
    va_start(list, num);

    // 表示当前节点不是终结符号，还有子节点
    if (num > 0)
    {
       // printf("AST continue\n");
        father->ncld = num;
        // 第一个孩子节点
        temp = va_arg(list, tnode);
        father->cld[0] = temp;
        setChildTag(temp);
        // 父节点行号为第一个孩子节点的行号
        father->line = temp->line;

        if (num == 1)
        {
            //父节点的语义值等于左孩子的语义值
            father->content = temp->content;
            father->tag = temp->tag;
        }
        else
        {
            for (i = 1; i < num; i++)
            {
                temp = va_arg(list, tnode);
                (father->cld)[i] = temp;
                // 该节点为其他节点的子节点
                setChildTag(temp);
            }
        }
    }
    else //表示当前节点是终结符（叶节点）或者空的语法单元，此时num表示行号（空单元为-1）
    {
      //  printf("AST end\n");
        father->ncld = 0;
        father->line = va_arg(list, int);
        // strcmp()==0 表示相同
        if (!strcmp(name, "INT"))
        {
            father->type = "int";
            father->value = atoi(yytext);
        }
        else if (!strcmp(name, "FLOAT"))
        {
            father->type = "float";
            father->value = atof(yytext);
        }
        else
        {
            // 存储词法单元语义值
            char *str;
            str = (char *)malloc(sizeof(char) * 100);
            memset(str,0,sizeof(char)*100);
            strcpy(str, yytext);
            father->content = str;
        }
    }
    nodeList[nodeNum] = father;
    nodeNum++;
    return father;
}

// 父节点->左子节点->右子节点....
void Preorder(Ast ast, int level)
{
   // printf("print tree\n");
    int i;
    if (ast != NULL)
    {
        // 层级结构缩进
        for (i = 0; i < level; ++i)
        {
            printf("\t");
        }
        if (ast->line != -1)
        {
           // printf("print all\n");
            // 打印节点类型
            printf("%s", ast->name);
            // 根据不同类型打印节点数据
            if ((!strcmp(ast->name, "ID")) || (!strcmp(ast->name, "TYPE")))
            {
                printf(": %s", ast->content);
            }
            else if (!strcmp(ast->name, "INT"))
            {
                printf(": %d", (int)ast->value);
            }
            else if (!strcmp(ast->name, "FLOAT"))
            {
                printf(": %f", ast->value);
            }
            else
            {
                // 非叶节点打印行号
                printf("(%d)", ast->line);
            }
        }
        printf("\n");
        for (i = 0; i < ast->ncld; ++i)
        {
         //   printf("print continue\n");
            Preorder((ast->cld)[i], level + 1);
        }
    }
    else
    {
        return;
    }
}

// 错误处理
void yyerror(char *msg)
{
    hasFault = 1;
    printf(stderr, "Error type B at Line %d: %s before %s\n", yylineno, msg, yytext);
}

// 设置节点打印状态 该节点为子节点
void setChildTag(tnode node)
{
  //  printf("set child tag\n");
    int i;
    for (i = 0; i < nodeNum; i++)
    {
        if (nodeList[i] == node)
        {
            nodeIsChild[i] = 1;
        }
    }
}

// 先序遍历分析
void analysis(Ast ast)
{
   // printf("analysis\n");
    int i;
    if (ast != NULL)
    {
        for (i = 0; i < ast->ncld; ++i)
        {
            analysis((ast->cld)[i]);
        }
    }
    else
        return;
}

// 建立变量符号
void newvar(int num, ...)
{
   // printf("new value\n");
    va_list valist;
    va_start(valist, num);

    var *res = (var *)malloc(sizeof(var));
    memset(res,0,sizeof(var));
    tnode temp = (tnode)malloc(sizeof(tnode));
    memset(temp,0,sizeof(tnode));

    if (inStruc && LCnum)
    {
        // 是结构体的域
        res->inStruc = 1;
        res->strucNum = strucNum;
    }
    else
    {
        res->inStruc = 0;
        res->strucNum = 0;
    }

    // 变量声明 int i
    temp = va_arg(valist, tnode);
    res->type = temp->content;
    temp = va_arg(valist, tnode);
    res->name = temp->content;

    vartail->next = res;
    vartail = res;
}
// 查找变量
int findvar(tnode val)
{
 //   printf("find value\n");
    var *temp = (var *)malloc(sizeof(var *));
    memset(temp,0,sizeof(var*));
    temp = varhead->next;
    while (temp != NULL)
    {
      //  printf("temp not null\n");
        //printf("%s\n",tempt->name);
        if (!strcmp(temp->name, val->content))
        {
        //    printf("here?\n");
            if (inStruc && LCnum) // 当前变量是结构体域
            {
                if (!temp->inStruc)
                {
                    // 结构体域与变量重名
                    printf("Error type 9 at Line %d:Struct Field and Variable use the same name.\n", yylineno);
                }
                else if (temp->inStruc && temp->strucNum != strucNum)
                {
                    // 不同结构体中的域重名
                    printf("Error type 10 at Line %d:Struct Fields use the same name.\n", yylineno);
                }
                else
                {
                    // 同一结构体中域名重复
                    return 1;
                }
             //   printf("continue v1\n");
            }
            else // 当前变量是全局变量
            {
                if (temp->inStruc)
                {
                    // 变量与结构体域重名
                    printf("Error type 9 at Line %d:Struct Field and Variable use the same name.\n", yylineno);
                }
                else
                {
                    // 变量与变量重名，即重复定义
                    return 1;
                }
            }
        }
      //  printf("what?\n");
        temp = temp->next;
    }
   // printf("over\n");
    return 0;
}
// 变量类型
char *typevar(tnode val)
{
  //  printf("type value\n");
    var *temp = (var *)malloc(sizeof(var *));
    memset(temp,0,sizeof(var*));
    temp = varhead->next;
    while (temp != NULL)
    {
        if (!strcmp(temp->name, val->content))
            return temp->type; //返回变量类型
        temp = temp->next;
    }
    return NULL;
}
// 赋值号左边只能出现ID、Exp LB Exp RB 以及 Exp DOT ID
int checkleft(tnode val)
{
  //  printf("check left\n");
    if (val->ncld == 1 && !strcmp((val->cld)[0]->name, "ID"))
        return 1;
    else if (val->ncld == 4 && !strcmp((val->cld)[0]->name, "Exp") && !strcmp((val->cld)[1]->name, "LB") && !strcmp((val->cld)[2]->name, "Exp") && !strcmp((val->cld)[3]->name, "RB"))
        return 1;
    else if (val->ncld == 3 && !strcmp((val->cld)[0]->name, "Exp") && !strcmp((val->cld)[1]->name, "DOT") && !strcmp((val->cld)[2]->name, "ID"))
        return 1;
    else
        return 0;
}

// 创建函数符号
void newfunc(int num, ...)
{
 //   printf("new function\n");
    int i;
    va_list valist;
    va_start(valist, num);

    tnode temp = (tnode)malloc(sizeof(struct treeNode));
    memset(temp,0,sizeof(struct treeNode));

    switch (num)
    {
    case 1:
        if (inStruc && LCnum)
        {
            // 是结构体的域
            functail->inStruc = 1;
            functail->strucNum = strucNum;
        }
        else
        {
            functail->inStruc = 0;
            functail->strucNum = 0;
        }
        //设置函数返回值类型
        temp = va_arg(valist, tnode);
        functail->rtype = temp->content;
        functail->type = temp->type;
        for (i = 0; i < rnum; i++)
        {
            if (rtype[i] == NULL || strcmp(rtype[i], functail->rtype))
                printf("Error type 12 at Line %d:Func return type error.\n", yylineno);
        }
        functail->tag = 1; //标志为已定义
        func *new = (func *)malloc(sizeof(func));
        memset(new,0,sizeof(func));
        functail->next = new; //尾指针指向下一个空结点
        functail = new;
        break;
    case 2:
        //记录函数名
        temp = va_arg(valist, tnode);
        functail->name = temp->content;
        //设置函数声明时的参数
        temp = va_arg(valist, tnode);
        functail->va_num = 0;
        getdetype(temp);
        break;
    default:
        break;
    }
}
//定义的参数
void getdetype(tnode val)
{
  //  printf("get de type\n");
    int i;
    if (val != NULL)
    {
        if (!strcmp(val->name, "ParamDec"))
        {
            functail->va_type[functail->va_num] = val->cld[0]->content;
            functail->va_num++;
            return;
        }
        for (i = 0; i < val->ncld; ++i)
        {
            getdetype((val->cld)[i]);
        }
    }
    else
        return;
}
//实际的参数
void getretype(tnode val)
{
  //  printf("get re type\n");
    int i;
    if (val != NULL)
    {
        if (!strcmp(val->name, "Exp"))
        {
            va_type[va_num] = val->type;
            va_num++;
            return;
        }
        for (i = 0; i < val->ncld; ++i)
        {
            getretype((val->cld)[i]);
        }
    }
    else
        return;
}
//函数实际返回值类型
void getrtype(tnode val)
{
 //   printf("get r type\n");
    rtype[rnum] = val->type;
    rnum++;
}
//检查形参与实参是否一致,没有错误返回0
int checkrtype(tnode ID, tnode Args)
{
  //  printf("check r type\n");
    int i;
    va_num = 0;
    getretype(Args);
    func *temp = (func *)malloc(sizeof(func *));
    memset(temp,0,sizeof(func*));
    temp = funchead->next;
    while (temp != NULL && temp->name != NULL && temp->tag == 1)
    {
        if (!strcmp(temp->name, ID->content))
            break;
        temp = temp->next;
    }
    if (va_num != temp->va_num)
        return 1;
    for (i = 0; i < temp->va_num; i++)
    {
        if (temp->va_type[i] == NULL || va_type[i] == NULL || strcmp(temp->va_type[i], va_type[i]) != 0)
            return 1;
    }
    return 0;
}
// 函数是否已经定义
int findfunc(tnode val)
{
  //  printf("find functon\n");
    func *temp = (func *)malloc(sizeof(func *));
    memset(temp,0,sizeof(func*));
    temp = funchead->next;
    while (temp != NULL && temp->name != NULL && temp->tag == 1)
    {
        if (!strcmp(temp->name, val->content))
        {
            if (inStruc && LCnum) // 当前变量是结构体域
            {
                if (!temp->inStruc)
                {
                    // 结构体域与变量重名
                    printf("Error type 9 at Line %d:Struct Field and Variable use the same name.\n", yylineno);
                }
                else if (temp->inStruc && temp->strucNum != strucNum)
                {
                    // 不同结构体中的域重名
                    printf("Error type 10 at Line %d:Struct Fields use the same name.\n", yylineno);
                }
                else
                {
                    // 同一结构体中域名重复
                    return 1;
                }
            }
            else // 当前变量是全局变量
            {
                if (temp->inStruc)
                {
                    // 变量与结构体域重名
                    printf("Error type 9 at Line %d:Struct Field and Variable use the same name.\n", yylineno);
                }
                else
                {
                    // 变量与变量重名，即重复定义
                    return 1;
                }
            }
        }
        temp = temp->next;
    }
    return 0;
}
// 函数类型
char *typefunc(tnode val)
{
  //  printf("type function\n");
    func *temp = (func *)malloc(sizeof(func *));
    memset(temp,0,sizeof(func*));
    temp = funchead->next;
    while (temp != NULL)
    {
        if (!strcmp(temp->name, val->content))
            return temp->type; //返回函数类型
        temp = temp->next;
    }
    return NULL;
}
// 形参个数
int numfunc(tnode val)
{
 //   printf("number function\n");
    func *temp = (func *)malloc(sizeof(func *));
    memset(temp,0,sizeof(struct func*));
    temp = funchead->next;
    while (temp != NULL)
    {
        if (!strcmp(temp->name, val->content))
            return temp->va_num; //返回形参个数
        temp = temp->next;
    }
}
// 创建数组符号表
void newarray(int num, ...)
{
  //  printf("new array\n");
    va_list valist;
    va_start(valist, num);

    array *res = (array *)malloc(sizeof(array));
    memset(res,0,sizeof(array));
    tnode temp = (tnode)malloc(sizeof(struct treeNode));
    memset(temp,0,sizeof(struct treeNode));

    if (inStruc && LCnum)
    {
        // 是结构体的域
        res->inStruc = 1;
        res->strucNum = strucNum;
    }
    else
    {
        res->inStruc = 0;
        res->strucNum = 0;
    }
    // int a[10]
    temp = va_arg(valist, tnode);
    res->type = temp->content;
    temp = va_arg(valist, tnode);
    res->name = temp->content;
    arraytail->next = res;
    arraytail = res;
}
// 数组是否已经定义
int findarray(tnode val)
{
  //  printf("find array");
    array *temp = (array *)malloc(sizeof(array *));
    memset(temp,0,sizeof(array*));
    temp = arrayhead->next;
    while (temp != NULL)
    {
        if (!strcmp(temp->name, val->content))
            return 1;
        temp = temp->next;
    }
    return 0;
}
// 数组类型
char *typearray(tnode val)
{
  //  printf("type array\n");
    array *temp = (array *)malloc(sizeof(array *));
    memset(temp,0,sizeof(array*));
    temp = arrayhead->next;
    while (temp != NULL)
    {
        if (!strcmp(temp->name, val->content))
            return temp->type; //返回数组类型
        temp = temp->next;
    }
    return NULL;
}
// 创建结构体符号表
void newstruc(int num, ...)
{
  //  printf("new struct");
    va_list valist;
    va_start(valist, num);

    struc *res = (struc *)malloc(sizeof(struc));
    memset(res,0,sizeof(struc));
    tnode temp = (tnode)malloc(sizeof(struct treeNode));
    memset(temp,0,sizeof(struct treeNode));

    // struct name{}
    temp = va_arg(valist, tnode);
    res->name = temp->content;
    structail->next = res;
    structail = res;
}
// 结构体是否和结构体或变量的名字重复
int findstruc(tnode val)
{
 //   printf("find struct");
    struc *temp = (struc *)malloc(sizeof(struc *));
    memset(temp,0,sizeof(struc*));
    temp = struchead->next;
    while (temp != NULL)
    {
        if (!strcmp(temp->name, val->content))
            return 1;
        temp = temp->next;
    }
    if (findvar(val) == 1)
        return 1;
    return 0;
}

// 主函数 扫描文件并且分析
// 为bison会自己调用yylex()，所以在main函数中不需要再调用它了
// bison使用yyparse()进行语法分析，所以需要我们在main函数中调用yyparse()和yyrestart()
int main(int argc, char **argv)
{
  //  printf("start\n");
    int j, tem;
    if (argc < 2)
    {
        return 1;
    }
    for (i = 1; i < argc; i++)
    {
        // 初始化，用于记录结构体域
        inStruc = 0;
        LCnum = 0;
        strucNum = 0;

        varhead = (var *)malloc(sizeof(var));
        memset(varhead,0,sizeof(var));
        vartail = varhead;
        funchead = (func *)malloc(sizeof(func));
        memset(funchead,0,sizeof(func));
        functail = (func *)malloc(sizeof(func));
        memset(functail,0,sizeof(func));
        funchead->next = functail;
        functail->va_num = 0;
        arrayhead = (array *)malloc(sizeof(array));
        memset(arrayhead,0,sizeof(array));
        arraytail = arrayhead;
        struchead = (struc *)malloc(sizeof(struc));
        memset(struchead,0,sizeof(struc));
        structail = struchead;
        rnum = 0;

        // 初始化节点记录列表
        nodeNum = 0;
        memset(nodeList, 0, sizeof(tnode) * 100);
        memset(nodeIsChild, 0, sizeof(int) * 100);
        hasFault = 0;

        FILE *f = fopen(argv[i], "r");
        if (!f)
        {
            perror(argv[i]);
            return 1;
        }
        yyrestart(f);
        yyparse();
        fclose(f);

        // 遍历所有非子节点的节点
        if (hasFault)
            continue;
        for (j = 0; j < nodeNum; j++)
        {
            if (nodeIsChild[j] != 1)
            {
              //  Preorder(nodeList[j], 0);
            }
        }
// 初始化符号表
        
        
    }
}
