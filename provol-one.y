%{
      #include <stdlib.h>
      #include <stdio.h>
      #include <string.h>

extern int yylineno; 
int yylex();
extern int erro;
extern int coluna;
#define C_INC 1

char* entradas[30];
int entradasN = 0;
char* saidas[30];
int saidasN = 0;
int count = 0;

int erroAnterior = 0;

int offset = 0;

void yyerror(const char *s){
	erro = 1;
};

void* xmalloc(size_t size)
{
	void* result = malloc(size);
	if(result == NULL)
	{
		fprintf(stderr, "Sem memória.\n");
		exit(1);
	}
}

 
%}
%union
{
	char *str;
};

%type <str> program varlistEntrada varlistSaida cmds cmd var;
%token<str> ENTRADA;
%token<str> HEADER;
%token<str> PROGRAMA;
%token<str> SAIDA;
%token<str> FIM;
%token<str> ENQUANTO;
%token<str> FACA;
%token<str> INC;
%token<str> DEC;
%token<str> IGUAL;
%token<str> ZERA;
%token<str> id;

%right IGUAL

%start program
%locations
%%
	program : HEADER ENTRADA varlistEntrada SAIDA varlistSaida FIM PROGRAMA cmds FIM
	{
		char* result = malloc(strlen($3)*2 + strlen($5) + strlen($8) + 300 + 18 * saidasN);
		strcpy(result, "#include <stdio.h>\n");
		strcat(result, "#include <stdlib.h>\n");
		strcat(result, "int main(int argc, char* argv[]) {\n");
		for(int i = 0; i < entradasN; i++)
		{
			strcat(result, "\tint ");
			strcat(result, entradas[entradasN - i - 1]);
			strcat(result, " = atoi(argv[");
			char a[3];
			sprintf(a, "%d", i);
			strcat(result, a);
			strcat(result, "]);\n");
		}
		strcat(result, "\tint ");
		strcat(result, $5);
		strcat(result, ";\n");
		strcat(result, $8);

		for(int i = 0; i < saidasN; i++)
		{
			strcat(result, "\tprintf(\"%d\\n\", ");
			strcat(result, saidas[saidasN - i - 1]);
			strcat(result, ");\n");
		}
		strcat(result, "\treturn 0;\n");
		strcat(result, "}\n");
		$$ = result;
		if(erro == 0)
		{
			printf("%s", $$);
		}

	
	}
		;
	varlistEntrada : id varlistEntrada
	{
		char* result = malloc(strlen($1) + strlen($2) + 20);
		strcpy(result, $1);
		strcat(result, " = atoi(argv[0]), ");
		strcat(result, $2);
		$$ = result;
		entradas[entradasN++] = $1;
	}
		| id
	{
		char* result = malloc(strlen($1) + 1);
		strcpy(result, $1);
		strcat(result, " = atoi(argv[0])");
		$$ = result;
		entradas[entradasN++] = $1;
	}
		;
	
	varlistSaida : id varlistSaida
	{
		char* result = malloc(strlen($1) + strlen($2) + 5);
		strcpy(result, $1);
		strcat(result, " = 0");
		strcat(result, ", ");
		strcat(result, $2);
		$$ = result;
		saidas[saidasN++] = $1;
	}
		| id
	{
		char* result = malloc(strlen($1) + 4);
		strcpy(result, $1);
		strcat(result, " = 0");
		$$ = result;
		saidas[saidasN++] = $1;
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
	cmd	: INC '(' var ')'
	{
		char* result = malloc(strlen($3) + 4);
		strcpy(result, $3);
		strcat(result, "++;");
		$$ = result;

	}
		| INC error
	{
			printf("Linha %d:\n", @1.first_line);
			printf("  > O erro está após o INC.\n");
			printf("  > Uso do INC: \"INC(var)\" onde var é uma variável.\n");
			char* result = malloc(1);
			offset = 1;
			*result = '\0';
			$$ = result;
			erroAnterior = @1.first_line;

	}
		| DEC '(' var ')'
	{
		char* result = malloc(strlen($3) + 4);
		strcpy(result, $3);
		strcat(result, "--;");
		$$ = result;

	}
		| DEC error
	{
			printf("Linha %d:\n", @1.first_line);
			printf("  > O erro está após o DEC.\n");
			printf("  > Uso do DEC: \"DEC(var)\" onde var é uma variável.\n");
			offset = 1;
			char* result = malloc(1);
			*result = '\0';
			$$ = result;
			erroAnterior = @1.first_line;
	}

		| ZERA '(' var ')'
	{
		char* result = malloc(strlen($3) + 6);
		strcpy(result, $3);
		strcat(result, " = 0;");
		$$ = result;
	}
		| ZERA error
		{
			printf("Linha %d:\n", @1.first_line);
			printf("  > O erro está após o ZERA.\n");
			printf("  > Uso do ZERA: \"ZERA(var)\" onde var é uma variável.\n");
			offset = 1;
			char* result = malloc(1);
			*result = '\0';
			$$ = result;
			erroAnterior = @1.first_line;

		}
		| var IGUAL var	
	{
		char* result = malloc(strlen($1) + strlen($3) + 5);
		strcpy(result, $1);
		strcat(result, " = ");
		strcat(result, $3);
		strcat(result, ";");
		$$ = result;
	}	
		| var IGUAL error
		{
			printf("Linha %d:\n", @1.first_line);
			printf("  > O erro está após o sinal de igual.\n");
			printf("  > Uso do igual: \"a = b\" onde a e b são variáveis.\n");
			char* result = malloc(1);
			*result = '\0';
			$$ = result;
			erroAnterior = @1.first_line;
		}

		| ENQUANTO var FACA cmds FIM	
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
		| ENQUANTO error
		{
			printf("Linha %d:\n", @1.first_line);
			printf("  > O erro está após o ENQUANTO\n");
			printf("  > Uso do ENQUANTO: ENQUANTO a FACA cmds FIM\n");
			printf("  > onde a é uma variável e cmds um ou mais comandos.\n");
			char* result = malloc(1);
			*result = '\0';
			$$ = result;
			erroAnterior = @1.first_line;
		}
		| ENQUANTO error FACA error
		{
			printf("Linha %d:\n", @1.first_line);
			printf("  > O erro está após o ENQUANTO\n");
			printf("  > Uso do ENQUANTO: ENQUANTO a FACA cmds FIM\n");
			printf("  > onde a é uma variável e cmds um ou mais comandos.\n");
			printf("Linha %d\n", @1.first_line);
			char* result = malloc(1);
			*result = '\0';
			$$ = result;
			erroAnterior = @1.first_line;
		}

		| error
		{

			if(@1.first_line != erroAnterior)
			{
				erroAnterior = @1.first_line;
				printf("Linha %d:\n", @1.first_line);
				printf("  > Erro desconhecido.\n");
				printf("  > Talvez algum ENQUANTO não foi fechado com FIM\n");
			}
			// Ignorar a linha para tentar recuperar do erro
			char* result = malloc(1);
			*result = '\0';
			$$ = result;
		}
		;
	var 	: id
		{
			char* result = malloc(strlen($1) + 1);
			strcpy(result, $1);
			$$ = result;
			int existe = 0;
			for(int i = 0; i < entradasN; i++)
			{
				if(strcmp($$, entradas[i]) == 0)
				{
					existe = 1;
				}
			}
			for(int i = 0; i < saidasN; i++)
			{
				if(strcmp($$, saidas[i]) == 0)
				{
					existe = 1;
				}
			}
			if(!existe)
			{
				erro = 1;
				fprintf(stderr, "Linha %d:\n", @1.first_line);
				fprintf(stderr, "  > Erro: variável ou comando \"%s\" não existe.\n", $$);
				erroAnterior = @1.first_line;
			}

		}
		;


%%

int main(int argc, char *argv[])
{
    yyparse();
    return(0);
}
