%{
      #include <stdlib.h>
      #include <stdio.h>
      #include <string.h>

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
%token<str> HEADER;
%token<str> PROGRAMA;
%token<str> SAIDA;
%token<str> FIM;
%token<str> ENQUANTO;
%token<str> FACA;
%token<str> INC;
%token<str> IGUAL;
%token<str> ZERA;
%token<str> id;

%right IGUAL

%start program
%%
	program : HEADER ENTRADA varlist SAIDA varlist FIM PROGRAMA cmds FIM
	{
		char* result = malloc(strlen($3) + strlen($5) + strlen($8) + 20);
		strcpy(result, "int ");
		strcat(result, $3);
		strcat(result, ";\n");
		strcat(result, "int ");
		strcat(result, $5);
		strcat(result, ";\n");
		strcat(result, $8);
		$$ = result;
		printf("%s", $$);
	
	}
		;
	varlist : id varlist
	{
		char* result = malloc(strlen($1) + strlen($2) + 3);
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
	cmds	: cmd cmds
	{
		char* result = malloc(strlen($1) + strlen($2) + 1);
		strcpy(result, $1);
		strcat(result, "\n");
		strcat(result, $2);
		$$ = result;
	}
		| cmd
	{
		char* result = malloc(strlen($1) + 1);
		strcpy(result, $1);
		strcat(result, "\n");
		$$ = result;
	}
		;
	cmd	: INC '(' id ')'
	{
		char* result = malloc(strlen($1) + 4);
		strcpy(result, $3);
		strcat(result, "++;");
		$$ = result;

	}
		| ZERA '(' id ')'
	{
		char* result = malloc(strlen($1) + 6);
		strcpy(result, $3);
		strcat(result, " = 0;");
		$$ = result;
	}
		| id IGUAL id	
	{
		char* result = malloc(strlen($1) + strlen($3) + 5);
		strcpy(result, $1);
		strcat(result, " = ");
		strcat(result, $3);
		strcat(result, ";");
		$$ = result;
	}
		| ENQUANTO id FACA cmds FIM	
	{
		// Contar quando \n temos para poder alocar mem. suficiente para caber
		// as tabulações
		int novasLinhas = 0;
		for(int i = 0; *($4 + i); i++)
		{
			if(*($4 + i) == '\n') novasLinhas++;
		}

		char* result = malloc(strlen($2) + strlen($4) + 12 + novasLinhas);
		strcpy(result, "while(");
		strcat(result, $2);
		strcat(result, ") {\n\t");

		char* comTabulacoes = malloc(strlen($4) + novasLinhas + 1);
		int j = 0;
		for(int i = 0; *($4 + i); i++)
		{
			*(comTabulacoes + j) = *($4 + i);
			j++;
			if(*($4 + i) == '\n')
			{
				*(comTabulacoes + j) = '\t';
				j++;
			}
		}
		
		strcat(result, comTabulacoes);
		strcat(result, "}");
		$$ = result;
	}
		;


%%

int main(int argc, char *argv[])
{
    yyparse();
    return(0);
}
