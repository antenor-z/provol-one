%{
      #include <stdlib.h>
      #include <stdio.h>
      #include <string.h>

char vlist[50];
char* codigo[500];
  
int yylex();
void yyerror(const char *s){
	fprintf(stderr, "%s\n", s);
};

 
%}
%union
{
	char *str;
};

%type <str> program varlist varlist cmds cmd;
%token<str> ENTRADA;
%token<str> SAIDA;
%token<str> FIM;
%token<str> ENQUANTO;
%token<str> FACA;
%token<str> INC;
%token<str> IGUAL;
%token<str> ZERA;
%token<str> id;


%start program
%%
	program : ENTRADA varlist FIM { strcat(codigo, "int ");
				        strcat(codigo, $2);
					strcat(codigo, ";"); }
		;
	varlist : id varlist	{ strcat(vlist, $1);
				  strcat(vlist, ", "); }
		| id		{ strcat(vlist, $1); }
		;

%%

int main(int argc, char *argv[])
{
    yyparse();
    return(0);
}