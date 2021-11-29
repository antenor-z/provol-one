# Provol-One
Trabalho de Analisadores Léxicos e Sintáticos
## Dicas
* Ao fazer o parsing vai adicionando o contexto para, quando ocorrer um erro, a mensagem poder mostrar onde ocorreu.
* Usar a função de concatenação de string para fazer a geração de código.
---
program : ENTRADA varlist SAIDA varlist cmds FIM { strcat(result, "int main() {\n");
						   strcat(result, "int "); // ENTRADA
						   strcat(result, $2); //
						   strcat(result, int "); // SAIDA
						   strcat(result, $4);


					           strcat(result, "return 0;\n");
					           strcat(result, "}\n");

---
