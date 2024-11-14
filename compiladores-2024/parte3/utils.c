//Tabela de simbolos

#include <string.h> // Para a função strcpy()

enum {
    INT,
    LOG
};

#define TAM_TAB 100

struct elemTabSimbolos {
    char id[50];    // Nome do identificador
    int end;        // Endereço do identificador
    int tip;        // Tipo do identificador (INT, LOG, etc.)
} tabSimb[TAM_TAB], elemTab;

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

    // printf("Inserido: %s\n", elem.id);
}


//Minha pilha
#define TAM_PILHA 100 // Tamanho máximo da pilha

// Pilha para inteiros
int pilha[TAM_PILHA]; // Vetor que armazena a pilha
int topo = -1; // Índice do topo da pilha (inicialmente vazio)

// Função para empilhar um valor
void empilha(int valor) {
    if (topo == TAM_PILHA - 1) {
        printf("Erro: pilha cheia!\n");
        return;
    }
    pilha[++topo] = valor; // Incrementa o topo e insere o valor
    // printf("Empilhado: %d\n", valor);
}

// Função para desempilhar um valor
int desempilha() {
    if (topo == -1) {
        printf("Erro: pilha vazia!\n");
        return -1; // Retorna -1 indicando erro (pilha vazia)
    }
    int valor = pilha[topo--]; // Retorna o valor e decrementa o topo
    // printf("Desempilhado: %d\n", valor);
    return valor;
}


//tipos

// tipo1 e tipo2 são os tipos esperados na expressão
// ret é o tipo que será empilhado como retorno esperado

void testaTipo(int tipo1, int tipo2, int ret)
{
    int t1 = desempilha();
    int t2 = desempilha();
    if(t1 != tipo1 || t2 != tipo2)
    {
        yyerror("Incompatibilidade de tipos!!");
    }
    empilha(ret);
}
