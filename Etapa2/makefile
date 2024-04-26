#Integrantes do grupo : Mateus Nunes Campos e Lucas Guaitanelli

CC=gcc
LIBS=-lfl 
OBJ = parser.tab.o lex.yy.c main.o
SCANNER = scanner.l
PARSER = parser.y

all: build

lex.yy.c: $(SCANNER)
					flex $(SCANNER)

parser.tab.o: $(PARSER)
							bison -d $(PARSER)

main.o: 
				gcc -c lex.yy.c parser.tab.c main.c

build: $(OBJ)
			 $(CC) -o etapa2 $^ $(LIBS)


clean:
			rm -f $(OBJ) lex.yy.c parser.tab.c parser.tab.h parser.output etapa2 lex.yy.o 
