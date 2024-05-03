/*
GRUPO W
Lucas Guaitanelli da Silveira - 00208695
Mateus Nunes Campos - 00268613  */

enum allowed_lexic_types {
    LEX_IDENTIFIER,
    LEX_LIT_INT,
    LEX_LIT_BOOL,
    LEX_LIT_FLOAT
};

 typedef struct Lexic {
    int line_num;
    int token_type;
    char *label;
} Lexic;

Lexic* newLex(int line_num, int token_type, char* token_value);

typedef struct Node {
  char *label;
  Lexic* lex_value;
  int children_number;
  struct Node **children;
} Tree;

/* Cria um nó sem filhos com o label informado. */
Tree* newNode(char* label);
/* Cria um nó do tipo léxico*/
Tree* newLexNode(Lexic *lex_value);
/*Libera recursivamente o nó e seus filhos.*/
void freeNode(Tree *node);
/*Adiciona um nodo como filho.*/
void addChild(Tree *node, Tree *child);
/*Printa recursivamente a árvore (DFS).*/
void printTree(Tree *tree);
