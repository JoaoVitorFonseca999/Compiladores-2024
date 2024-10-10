%{
int nlet, npal, nlin;
%}

%%
\n         { nlin++; nlet++; }
[^ \t\n]+  { npal++; nlet += yyleng; }
.           {nlet++; }  
%%

int yywrap() { return 1; }

int main() {
    yylex();
    printf("Número de caracteres: %d\n", nlet);
    printf("Número de palavras: %d\n", npal);
    printf("Número de linhas: %d\n", nlin);
    return 0;
}