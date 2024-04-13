CC=gcc
LIBS=-lfl
SCANNER = scanner.l
OBJ = lex.yy.o main.o

all: etapa1

%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

lex.yy.c: $(SCANNER)
	flex $(SCANNER)

etapa1: $(OBJ)
	$(CC) -o $@ $^ $(LIBS)

clean:
	rm -f $(OBJ) lex.yy.c etapa1
