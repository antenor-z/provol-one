%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "provol-one.tab.h"

// Fonte: https://stackoverflow.com/questions/62115979/how-to-implement-better-error-messages-for-flex-bison
static int proxColuna = 1;
int coluna = 1;
#define COL coluna = proxColuna; proxColuna += strlen(yytext)

void yyerror(char *str);
int yylex();
int erro = 0;
%}

%option yylineno

%%


[ \t]		{ COL; }
[\n]		{ COL; proxColuna = 1;}
ENTRADA		{ COL; return ENTRADA; }
HEADER		{ COL; return HEADER; }
PROGRAMA	{ COL; return PROGRAMA; }
SAIDA		{ COL; return SAIDA; }
FIM		{ COL; return FIM; }
ENQUANTO	{ COL; return ENQUANTO; }
FACA		{ COL; return FACA; }
INC		{ COL; return INC; }
ZERA		{ COL; return ZERA; }
[(]		{ COL; return '('; }
[)]		{ COL; return ')'; }
[=]		{ COL; return IGUAL; }
[A-Za-z][A-Za-z0-9]*	{ COL; yylval.str=strdup(yytext); return id; }
.		{ 
			COL;
			printf("Linha %d: Caractere desconhecido: \"%s\"\n", yylineno, yytext); 
			erro = 1;
		}


%%


int yywrap () 	{ return 1; }
