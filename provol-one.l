%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "provol-one.tab.h"

void yyerror(char *str);
int yylex();
%}


%%


[ \t\n]		{ ; }
ENTRADA		{ return ENTRADA; }
SAIDA		{ return SAIDA; }
FIM		{ return FIM; }
ENQUANTO	{ return ENQUANTO; }
FACA		{ return FACA; }
INC		{ return INC; }
ZERA		{ return ZERA; }
[=]		{ return IGUAL; }
[a-zA-z]+ 	{ yylval.str=strdup(yytext); return id; }
.		{ printf("Token desconhecido\n"); }


%%


int yywrap () 	{ return 1; }
