%{
      #include <stdlib.h>
      #include <stdio.h>
      #include <string.h>

extern int yylineno; 
int yylex();
extern int erro;
extern int coluna;
#define C_INC 1

void yyerror(const char *s){
	printf("Linha %d coluna %d: Erro de sintaxe\n", yylineno - 1, coluna);
	erro = 1;
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
%locations
%%
	program : HEADER ENTRADA varlist SAIDA varlist FIM PROGRAMA cmds FIM
	{
		char* result = malloc(strlen($3) + strlen($5) + strlen($8) + 80);
		strcpy(result, "#include <stdio.h>\n");
		strcat(result, "#include <stdlib.h>\n");
		strcat(result, "int main() {\n");
		strcat(result, "\tint ");
		strcat(result, $3);
		strcat(result, ";\n");
		strcat(result, "\tint ");
		strcat(result, $5);
		strcat(result, ";\n");
		strcat(result, $8);
		strcat(result, "\treturn 0;\n");
		strcat(result, "}\n");
		$$ = result;
		if(erro == 0)
		{
			printf("%s", $$);
		}
	
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
	cmds	: cmd  cmds
	{
		char* result = malloc(strlen($1) + strlen($2) + 3);
		strcpy(result, "\t");
		strcat(result, $1);
		strcat(result, "\n");
		strcat(result, $2);
		$$ = result;
	}
		| cmd
	{
		char* result = malloc(strlen($1) + 3);
		strcpy(result, "\t");
		strcat(result, $1);
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
		| INC error
		{
			printf("  > O erro está após o INC.\n");
			printf("  > Uso do INC: \"INC(var)\" onde var é uma variável.\n");
			char* result = malloc(1);
			*result = '\0';
			$$ = result;

		}
		| ZERA '(' id ')'
	{
		char* result = malloc(strlen($1) + 6);
		strcpy(result, $3);
		strcat(result, " = 0;");
		$$ = result;
	}
		| ZERA error
		{
			printf("  > O erro está após o ZERA.\n");
			printf("  > Uso do ZERA: \"ZERA(var)\" onde var é uma variável.\n");
			char* result = malloc(1);
			*result = '\0';
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
		| id IGUAL error
		{
			printf("  > O erro está após o sinal de igual.\n");
			printf("  > Uso do igual: \"a = b\" onde a e b são variáveis.\n");
			char* result = malloc(1);
			*result = '\0';
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

		char* result = malloc(strlen($2) + strlen($4) + 13 + novasLinhas);
		strcpy(result, "while(");
		strcat(result, $2);
		strcat(result, ") {\n\t");

		char* comTabulacoes = malloc(strlen($4) + novasLinhas + 2);
		int j = 0;
		for(int i = 0; *($4 + i); i++)
		{
			*(comTabulacoes + j) = *($4 + i);
			j++;
			if(*($4 + i) == '\n' && --novasLinhas)
			{
				*(comTabulacoes + j) = '\t';
				j++;
			}
		}
		
		strcat(result, comTabulacoes);
		strcat(result, "\t}");
		$$ = result;
	}
		| error
		{
			// Ignorar a linha para tentar recuperar do erro
			char* result = malloc(1);
			*result = '\0';
			$$ = result;
		}
		;


%%

int main(int argc, char *argv[])
{
    yyparse();
    return(0);
}
