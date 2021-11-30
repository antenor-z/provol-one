ALL:
	bison -d provol-one.y
	flex provol-one.l
	gcc -o provol-one provol-one.tab.c lex.yy.c
clean:
	rm provol-one.tab.c provol-one.tab.h provol-one
