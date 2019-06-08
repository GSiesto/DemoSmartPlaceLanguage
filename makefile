#fichero Makefile

OBJ = expresiones.o lexico.o map.o


traductor : $(OBJ)     #segunda fase de la tradicción. Generación del código ejecutable
	g++ -otraductor $(OBJ)

map.o :
	gcc -c -omap.o hashmap/map.c

expresiones.o : expresiones.c        #primera fase de la traducción del analizador sintáctico
	g++ -c -oexpresiones.o  expresiones.c

lexico.o : lex.yy.c		#primera fase de la traducción del analizador léxico, por eso la c
	g++ -c -olexico.o  lex.yy.c

expresiones.c : expresiones.y       #obtenemos el analizador sintáctico en C
	bison -d -oexpresiones.c expresiones.y

lex.yy.c: lexico.l	#obtenemos el analizador léxico en C
	flex lexico.l

clean :
	rm -f *.c *.o

logger :
	bison -v expresiones.y

run:
	make
	./traductor ejemplo1.dsp
