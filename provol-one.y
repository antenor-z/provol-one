%{
      #include <stdlib.h>
      #include <stdio.h>
      #include <string.h>

char* vlist;
char* codigo;
  
int yylex();
void yyerror(const char *s){
	fprintf(stderr, "%s\n", s);
};

 
%}
%union
{
	char *str;
};

%type <str> program varlist cmds cmd;
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
	program : ENTRADA varlist SAIDA varlist FIM
	{
		char* result = malloc(strlen($2 + 50));
		strcpy(result, "int ");
		strcat(result, $2);
		strcat(result, ";\n");
		strcat(result, "int ");
		strcat(result, $4);
		strcat(result, ";\n");
		$$ = result;
		printf("%s", $$);
	
	}
		;
	varlist : id varlist
	{
		char* result = malloc(strlen($1) + strlen($2) + 1);
		strcpy(result, $1);
		strcat(result, ", ");
		strcat(result, $2);
		$$ = result;
	}
		| id
	{
		char* result = malloc(strlen($1) + 1);
		strcpy(result, $1);
		$$ = result;
	}
		;

%%

int main(int argc, char *argv[])
{
    yyparse();
    return(0);
}
