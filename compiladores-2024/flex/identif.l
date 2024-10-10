digito [0-9]
letra  [a-z]

%% 
"#"({letra}|{digito})* printf("%s\n", yytext);

.
\n

%%
int yywrap(){ return 1; }
int main(){
    yylex();
}