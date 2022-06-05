ac:	parser.y lexer.l
	bison -d parser.y
	flex lexer.l
	gcc -o $@ lex.yy.c parser.tab.c -lfl -lgmp -lmpfr

clean:
	rm *.h *.c ac 
