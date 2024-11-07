//Tabela de simbolos

enum
{
    INT,
    LOG
}

#define TAM_TAB 100

struct elemTabSimbolos
{
    char id[50];    //nome do identificador
    int end;    //endereço do identificador
    int tip;   //tipo do identificador
}tabSimb[TAM_TAB], elemTab;


int posTab = 0; // próxima posição livre para inserção na tabela de símbolos

int buscaSimbolo(char *s)
{
    int i;
    for(i = posTab -1; strcmp(tabSimb[i].id, s) && i >= 0; i--);
    if(i==-1){
        char msg[200];
        sprintf(msg, "Erro: identificador [%s] não encontrado!", s);
        yyerror(msg);
    }
    return i;
}

void insereSimbolo(struct elemTabSimbolos elem)
{
   int i;
   if(posTab == TAM_TAB)
   {
       yyerror("Erro: tabela de símbolos cheia!");
   }
    for(i = posTab -1; strcmp(tabSimb[i].id, elem.id) && i >= 0; i--);
    if(i != -1)
    {
        char msg[200];
        sprintf(msg, "Erro: identificador [%s] já declarado!", elem.id);
        yyerror(msg);
    }
    tabSimb[posTab++] = elem;
}