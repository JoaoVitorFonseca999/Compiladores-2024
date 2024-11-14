%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lexico.c"
#include "utils.c"

int contaVar = 0;
int tipo = 0;
int rotulo = 0;
%}

%token T_PROGRAMA 
%token T_INICIO
%token T_FIMPROG
%token T_LEIA
%token T_ESCREVA
%token T_SE
%token T_ENTAO
%token T_SENAO
%token T_FIMSE
%token T_ENQUANTO
%token T_FACA
%token T_FIMQTO


%token T_MAIS
%token T_MENOS
%token T_VEZES
%token T_DIV


%token T_MAIOR
%token T_MENOR
%token T_IGUAL


%token T_E
%token T_OU
%token T_NAO


%token T_ATRIB
%token T_ABRE
%token T_FECHA


%token T_INTEIRO
%token T_LOGICO
%token T_V
%token T_F


%token T_IDENT
%token T_NUM

%start programa

%left T_MAIS T_MENOS
%left T_VEZES T_DIV
%left T_MAIOR T_MENOR T_IGUAL
%left T_E T_OU

%%
programa
    :   cabecalho
        {fprintf(yyout, "\tINPP\n");}
    variaveis
        {fprintf(yyout, "\tAMEM\t%d\n",contaVar);}
    T_INICIO lista_comandos T_FIMPROG
        {fprintf(yyout, "\tDMEM\t%d\n\tFIMP\n",contaVar);}
    ;
cabecalho
    : T_PROGRAMA T_IDENT
    ;
variaveis
    : lista_variaveis
    | declaracao_variaveis

declaracao_variaveis
    : tipo lista_variaveis declaracao_variaveis
    | tipo lista_variaveis 
    ;

tipo
    : T_INTEIRO {tipo = INT;}
    | T_LOGICO  {tipo = LOG;}
    ;

lista_variaveis
    : lista_variaveis T_IDENT
        {
            strcpy(elemTab.id,atomo);
            elemTab.end = contaVar;
            elemTab.tip = tipo;
            insereSimbolo(elemTab);
            contaVar++;
            }   
    | T_IDENT
        {strcpy(elemTab.id,atomo);
            elemTab.end = contaVar;
            elemTab.tip = tipo;
            insereSimbolo(elemTab);
            contaVar++;}

lista_comandos
    : lista_comandos comando
    | comando
    ;

comando 
    : leitura
    | escrita
    | repeticao
    | selecao
    | atribuicao
    ;

leitura 
    : T_LEIA T_IDENT
        {
            int pos = buscaSimbolo(atomo);
            fprintf(yyout, "\tLEIA\n");
            fprintf(yyout, "\tARZG\t%d\n", tabSimb[pos].end);
        }
    ;

escrita
    : T_ESCREVA expressao
    {fprintf(yyout, "\tESCR\n");}
    ;

repeticao
    : T_ENQUANTO
        {
            fprintf(yyout, "L%d\tNADA\n", ++rotulo);
            empilha(rotulo);
        }
    expressao T_FACA
        {
            fprintf(yyout, "\tDSVF\tL%d\n", ++rotulo);
            empilha(rotulo);
        }
    lista_comandos
    T_FIMQTO
        {
            int y = desempilha();
            int x = desempilha();
            fprintf(yyout, "\tDSVD\tL%d\nL%d\tNADA\n",x,y);}

    ;

selecao
    : T_SE expressao 
    T_ENTAO
    {
        fprintf(yyout, "\tDSVF\tL%d\n", ++rotulo);
        empilha(rotulo);
    }
    lista_comandos 
    T_SENAO
    {
        int y = desempilha();
        fprintf(yyout, "\tDSVS\tL%d\n", ++rotulo);
        empilha(rotulo);
        fprintf(yyout, "L%d\tNADA\n", y);
    }
    lista_comandos 
    T_FIMSE
    {
        int x = desempilha();
        fprintf(yyout, "L%d\tNADA\n", x);
    }


atribuicao
    : T_IDENT
    {
        int pos = buscaSimbolo(atomo);
        empilha(pos);
    }
    T_ATRIB expressao
    {
        int pos = desempilha();
        fprintf(yyout, "\tARZG\t%d\n", tabSimb[pos].end);
    }
    ;
    
expressao
    : expressao T_MAIS expressao    {fprintf(yyout, "\tSOMA\n");}
    | expressao T_MENOS expressao   {fprintf(yyout, "\tSUBT\n");}
    | expressao T_VEZES expressao   {fprintf(yyout, "\tMULT\n");}
    | expressao T_DIV expressao     {fprintf(yyout, "\tDIVI\n");}
    | expressao T_MAIOR expressao   {fprintf(yyout, "\tCMMA\n");}
    | expressao T_MENOR expressao   {fprintf(yyout, "\tCMME\n");}
    | expressao T_IGUAL expressao   {fprintf(yyout, "\tCMIG\n");}
    | expressao T_E expressao       {fprintf(yyout, "\tCONJ\n");}
    | expressao T_OU expressao      {fprintf(yyout, "\tDISJ\n");}
    | termo 
    ;
termo 
    : T_NUM                         {fprintf(yyout, "\tCRCT\t%s\n",atomo);}
    | T_IDENT                       {fprintf(yyout, "\tCRVG\t%d\n",buscaSimbolo(atomo));}
    | T_V                           {fprintf(yyout, "\tCRCT\t1\n");}
    | T_F                           {fprintf(yyout, "\tCRCT\t0\n");}
    | T_ABRE expressao T_FECHA
    | T_NAO                         {fprintf(yyout, "\tNEGA\n");}                   
     termo
    ;

%%

int main(int argc, char *argv[]){
    char nameIn[30];
    char nameOut[30];
    char *p;

    if(argc < 2){
        printf("Use:\n\t %s <nome fonte>.simples\n", argv[0]);
        return 10;
    }
    p = strstr(argv[1],".simples");
    if(p) *p = 0;
    strcpy(nameIn,argv[1]);
    strcat(nameIn,".simples");
    strcpy(nameOut,argv[1]);
    strcat(nameOut,".mvs");
    printf("Arquivo de entrada: %s\n",nameIn);
    printf("Arquivo de saida: %s\n",nameOut);

    yyin = fopen(nameIn,"rt");
    yyout = fopen(nameOut,"wt");

    yyparse();

    fclose(yyin);
    fclose(yyout);

    puts("Programa ok!");
    return 0;
}