%{
#include "calc.h"
void yyerror(char *);
%}

%%
[a-z]       {yylval = *yytext - 'a'; return VAR;}
[0-9]+       {yylval = atoi(yytext); return NUM;}
"*"         {return VEZES;}
"+"         {return MAIS;}
"-"         {return MENOS;} 
"/"         {return DIV;}
"("         {return ABRE;}
")"         {return FECHA;}
"="         {return RECEBE;}
[ \t\r]+     ;
\n        {return ENTER;}
.           yyerror("Erro Lexico");     
%%


int yywrap(void) { return 1; }