#include "ast.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

Lexic* newLex(int line_num, int token_type, char* token_value) {
  Lexic* new_lex = (Lexic*) calloc(1, sizeof(Lexic));
  new_lex->line_num = line_num;
  new_lex->token_type = token_type;
  new_lex->label = strdup(token_value);

  return new_lex;
}

Tree* newNode(char* label) {
  Tree* new_node = (Tree*) calloc(1, sizeof(Tree));
  new_node->lex_value = NULL;
  new_node->children_number = 0;
  new_node->children = NULL;
  new_node->label = strdup(label);
  
  return new_node;
}

Tree* newLexNode(Lexic *lex_value) {
  Tree* new_node = (Tree*) calloc(1, sizeof(Tree));
  new_node->lex_value = lex_value;
  new_node->children_number = 0;
  new_node->children = NULL;
  new_node->label = strdup(lex_value->label);

  return new_node;
}

void addChild(Tree *node, Tree *child) {
  node->children_number += 1;
  node->children = (Tree **) realloc(node->children, node->children_number * sizeof(Tree*));
  node->children[node->children_number - 1] = child;
}

void freeNode(Tree *node) {
  if (node == NULL)
    return;

  for (int childIndex = 0; childIndex < node->children_number; childIndex++)
    freeNode(node->children[childIndex]);

  if (node->children != NULL) {
    free(node->children);
    node->children = NULL;
  }
    
  free(node);
  node = NULL;
}

void printTree(Tree *tree) {
  if (tree == NULL)
    return;

  printf("%s", tree->lex_value->label);

  for(int childIndex = 0; childIndex < tree->children_number; childIndex++)
    printTree(tree->children[childIndex]);
}