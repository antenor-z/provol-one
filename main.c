#include <stdio.h>
#include <stdlib.h>
int main(int argc, char* argv[]) {
	int entrada1 = atoi(argv[0]);
	int entrada2 = atoi(argv[1]);
	int entrada3 = atoi(argv[2]);
	int entrada4 = atoi(argv[3]);
	int saida1 = 0, saida2 = 0, saida3 = 0;
	entrada1 = 0;
	entrada2 = 0;
	entrada2++;
	entrada2++;
	saida3 = entrada2;
	saida1 = entrada3;
	saida2 = entrada4;
	while(saida2) {
		saida1++;
		saida2--;
	}
	printf("%d\n", saida1);
	printf("%d\n", saida2);
	printf("%d\n", saida3);
	return 0;
}
