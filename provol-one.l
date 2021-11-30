%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "provol-one.tab.h"

void yyerror(char *str);
int yylex();
%}

%option yylineno

%%


[ \t\n]		{ ; }
ENTRADA		{ return ENTRADA; }
HEADER		{ return HEADER; }
PROGRAMA	{ return PROGRAMA; }
SAIDA		{ return SAIDA; }
FIM		{ return FIM; }
ENQUANTO	{ return ENQUANTO; }
FACA		{ return FACA; }
INC		{ return INC; }
ZERA		{ return ZERA; }
[(]		{ return '('; }
[)]		{ return ')'; }
[=]		{ return IGUAL; }
[A-Za-z]+ 	{ yylval.str=strdup(yytext); return id; }
.		{ printf("Token desconhecido\n"); }


%%


int yywrap () 	{ return 1; }
