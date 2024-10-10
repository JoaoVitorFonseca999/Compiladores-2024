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

%%
programa
    : cabecalho variaveis T_INICIO lista_comandos T_FIMPROG
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
    : T_INTEIRO
    | T_LOGICO
    ;

lista_variaveis
    : lista_variaveis T_IDENT
    | T_IDENT

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
    ;

escrita
    : T_ESCREVA expressao
    ;

repeticao
    : T_ENQUANTO expressao T_FACA lista_comandos T_FIMQTO
    ;

selecao
    : T_SE expressao T_ENTAO lista_comandos T_SENAO lista_comandos T_FIMSE


atribuicao
    : T_IDENT T_ATRIB expressao
    ;
    
expressao
    : expressao T_MAIS expressao 
    | expressao T_MENOS expressao 
    | expressao T_VEZES expressao 
    | expressao T_DIV expressao 
    | expressao T_MAIOR expressao
    | expressao T_MENOR expressao
    | expressao T_IGUAL expressao
    | expressao T_E expressao
    | expressao T_OU expressao
    | termo
    ;

termo 
    : T_IDENT
    | T_NUM
    | T_V
    | T_F
    | T_ABRE expressao T_FECHA
    | T_NAO termo
    ;

%%