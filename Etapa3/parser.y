/* Lucas Guaitanelli da Silveira - 00208695  */
/* Mateus Nunes Campos - 00268613  */

%{
#include "ast.h"
#include <stdlib.h>
#include <stdio.h>

int yylex(void);
void yyerror (char const *s);
extern int get_line_number();
extern char *yytext;
extern void *ast;
%}

%define parse.error verbose

%union {
  struct Lexic* lex_value;
  struct Tree* node;
}

%token TK_PR_INT
%token TK_PR_FLOAT
%token TK_PR_BOOL
%token TK_PR_IF
%token TK_PR_ELSE
%token TK_PR_WHILE
%token TK_PR_RETURN
%token TK_OC_LE
%token TK_OC_GE
%token TK_OC_EQ
%token TK_OC_NE
%token TK_OC_AND
%token TK_OC_OR
%token<lex_value> TK_IDENTIFICADOR
%token<lex_value> TK_LIT_INT
%token<lex_value> TK_LIT_FLOAT
%token<lex_value> TK_LIT_FALSE
%token<lex_value> TK_LIT_TRUE
%token TK_ERRO

/*Ações para construção de AST */
%type<node> program
%type<node> element_list
%type<node> func_or_global
%type<node> global_var
%type<node> id_list
%type<node> type
%type<lex_value> literal
%type<node> function
%type<node> header
%type<node> params
%type<node> params_list
%type<node> body
%type<node> cmd_block
%type<node> cmd
%type<node> var
%type<node> var_names
%type<node> assignment
%type<node> func_call
%type<node> args
%type<node> args_list
%type<node> return
%type<node> ctrl_flow
%type<node> if
%type<node> while
%type<node> op
%type<node> exp
%type<node> exp2
%type<node> exp3
%type<node> exp4
%type<node> exp5
%type<node> exp6
%type<node> exp7
%type<node> exp8

%%

/* Programa principal */
program: 
	element_list { ast = $1; } | { ast = NULL; };

element_list: 
	func_or_global element_list {
		if($1 == NULL) { $$ = $2; } 
		else { 
			if($2 != NULL) { addChild($1, $2); }
			else { $$ = $1; }
		}
  } |
	func_or_global {
		if($1 != NULL) { $$ = $1; } 
		else { $$ = NULL; }
	} ;

func_or_global: 
	function { $$ = $1; } | 
	global_var { $$ = NULL; } ;

/* Declaração de Variável Global, Tipos e Literais */
global_var: 
	type id_list ','; 

id_list:
	TK_IDENTIFICADOR ';' id_list |
	TK_IDENTIFICADOR;

type: 
	TK_PR_BOOL | 
	TK_PR_FLOAT |
	TK_PR_INT;

literal: 
	TK_LIT_INT { $$ = $1; } |
	TK_LIT_FLOAT { $$ = $1; } |
	TK_LIT_TRUE { $$ = $1; } |
	TK_LIT_FALSE { $$ = $1; };

/* Definição de Funções */
function: 
	header 
	body {
		$$ = $1;   
		addChild($$, $2); 
	};

header: 
	params 
	TK_OC_OR 
	type { $$ = newLexNode($1); }
	'/'
	TK_IDENTIFICADOR;

params: '(' params_list ')' | '(' ')';
params_list: type TK_IDENTIFICADOR ';' params_list | type TK_IDENTIFICADOR;

body: 
	'{' cmd_block '}' { $$ = $2; } |
	'{' '}' { $$ = NULL; };


/* Bloco de Comandos e Comandos Simples*/
cmd_block: 
	cmd_block cmd |
	cmd;

cmd: 
	var ',' { $$ = $1; } |
	assignment ',' { $$ = $1; }  |
	func_call ',' { $$ = $1; }  |
	return ',' | { $$ = $1; } 
	ctrl_flow ',' { $$ = $1; }  |
	body ',' { $$ = $1; }  ;

/* Variável */
var: type var_names
var_names: TK_IDENTIFICADOR ';' var | TK_IDENTIFICADOR ; 

/* Atribuição */
assignment: TK_IDENTIFICADOR '=' exp;

/* Chamada de Função */
func_call: TK_IDENTIFICADOR args;
args: '(' args_list ')' | '(' ')';
args_list: exp ';' args_list | exp;

/* Comando de Retorno */
return: TK_PR_RETURN exp;

/* Controle de Fluxo */
ctrl_flow: if | while;
if: TK_PR_IF '(' exp ')' body | TK_PR_IF '(' exp ')' body TK_PR_ELSE body ;
while: TK_PR_WHILE  '(' exp ')' body ; 

/* Expressões */
exp : exp TK_OC_OR exp2 | exp2;
exp2: exp2 TK_OC_AND exp3 | exp3;
exp3: exp3 TK_OC_NE exp4 | exp3 TK_OC_EQ exp4 | exp4;
exp4: exp4 '<' exp5 | exp4 '>' exp5 | exp4 TK_OC_LE exp5 | exp4 TK_OC_GE exp5 | exp5;
exp5: exp5 '+' exp6 | exp5 '-' exp6 | exp6;
exp6: exp6 '*' exp7 | exp6 '/' exp7 | exp6 '%' exp7 | exp7;
exp7: '!' exp8 | '-' exp8 | exp8 ;
exp8: op | '(' exp ')';

op : 
	TK_IDENTIFICADOR { $$ = newLexNode($1); } |
	literal { $$ = newLexNode($1); } |
	function { $$ = NULL; };

%%

void yyerror(char const *s){
printf("%s at line %d TOKEN ERROR (%s)\n", s, get_line_number(), yytext);
}
