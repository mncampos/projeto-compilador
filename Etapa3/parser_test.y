/* Lucas Guaitanelli da Silveira - 208695  */
/* Mateus Nunes Campos - 00268613  */
%{
#include <stdlib.h>
#include <stdio.h>
#include "arvore.h"

int yylex(void);
void yyerror (char const *s);
extern int get_line_number (void);
extern char *yytext;
extern void *arvore;
%}

%define parse.error verbose

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
%token TK_OC_MAP
%token<valor_lexico> TK_IDENTIFICADOR
%token<valor_lexico> TK_LIT_INT
%token<valor_lexico> TK_LIT_FLOAT
%token<valor_lexico> TK_LIT_FALSE
%token<valor_lexico> TK_LIT_TRUE
%token TK_ERRO

%type<no> programa
%type<no> array
%type<no> element
%type<valor_lexico> literal
%type<no> operando
%type<no> function
%type<no> header
%type<no> body
%type<no> commands_block
%type<no> simple_command
%type<no> command_list
%type<no> local_var_command
%type<no> local_vars_list
%type<no> local_var_list_complement
%type<no> set_command
%type<no> function_call
%type<no> args_list 
%type<no> args
%type<no> arg
%type<no> return_command
%type<no> flow_control_command
%type<no> condicional
%type<no> condicional_complement
%type<no> iterative
%type<no> opG0
%type<no> opG1
%type<no> opG2
%type<no> opG3
%type<no> opG4
%type<no> opAnd
%type<no> opOr
%type<no> expr
%type<no> expr1
%type<no> expr2
%type<no> expr3
%type<no> expr4
%type<no> expr5
%type<no> expr6
%type<no> expr7

%union {
    struct TipoLexico* valor_lexico;
    struct astNo* no;
}

%%
//done
programa:
    array { arvore = $1;} | 
		{ arvore = NULL; };
array: 
  element array {
		if($1 == NULL) { $$ = $2; } 
		else { 
			if($2 != NULL) { adicionarFilho($1, $2); }
			else { $$ = $1; }
		}
  } | 
	element {
		if($1 != NULL) { $$ = $1; } 
		else { $$ = NULL; }
	} ;

//done
element:
	function { $$ = $1; } | 
	global { $$ = NULL; } ;

//done
function:
	header body { 
		$$ = $1;   
		adicionarFilho($$, $2); 
	};

//done
header:
	TK_IDENTIFICADOR '(' param_list ')' TK_OC_MAP type { $$ = criarNoTipoLexico($1); };

//done
param_list: params | ;

//done
params: params ',' param | param ;

//done
param: type TK_IDENTIFICADOR ;

//done
type:
  TK_PR_INT | 
	TK_PR_FLOAT |
	TK_PR_BOOL;

//done
literal:
	TK_LIT_INT { $$ = $1; } |
	TK_LIT_FLOAT { $$ = $1; } |
	TK_LIT_TRUE { $$ = $1; } |
	TK_LIT_FALSE { $$ = $1; };

//done (verificar function_call)
operando:
	TK_IDENTIFICADOR { $$ = criarNoTipoLexico($1); } |
	literal { $$ = criarNoTipoLexico($1); } |
  function_call { $$ = NULL; };

//done
global:
  type vars ';' ;

//done(id_list)
vars:
	vars ',' TK_IDENTIFICADOR |
	TK_IDENTIFICADOR;

body:
	commands_block { $$ = $1; };

commands_block:
	'{' simple_command '}' { $$ = $2; } |
	'{' '}' { $$ = NULL; };

simple_command:
	command_list simple_command {
		if($1 == NULL) { $$ = $2; }
		else { 
			if($2 != NULL) {
				if(verificaValor($1, "<=") == 1) { 
					No *folha = $1;
					while(folha->n_filhos == 3)
					folha = folha->filhos[2];
					adicionarFilho(folha, $2);
				}
				else { adicionarFilho($1, $2); } 
				$$ = $1;
			} 
			else { $$ = $1; } 
		} 
  } |
	command_list {
		if($1 != NULL) { $$ = $1; } 
		else { $$ = NULL; }
	};

command_list:
	commands_block ';' { $$ = $1; } |
	local_var_command ';' { $$ = $1; } |
	set_command  ';' { $$ = $1; } |
	flow_control_command { $$ = $1; } |
	return_command ';' { $$ = $1; } |
	function_call ';' { $$ = $1; };

local_var_command:
	type local_vars_list { $$ = $2; } ;

local_vars_list:
	TK_IDENTIFICADOR ',' local_vars_list {
		if($3 == NULL) { $$ = NULL; }
		else { $$ = $3; }
	} |
	local_var_list_complement ',' local_vars_list {
		adicionarFilho($1, $3);
		$$ = $1;
	} |
	TK_IDENTIFICADOR { $$ = NULL; } |
	local_var_list_complement { $$ = $1; };

local_var_list_complement:
	TK_IDENTIFICADOR TK_OC_LE literal {
		$$ = criarNo("<=");
		adicionarFilho($$, criarNoTipoLexico($1));
		adicionarFilho($$, criarNoTipoLexico($3));
	};

set_command:
	TK_IDENTIFICADOR '=' expr {
		$$ = criarNo("=");
		adicionarFilho($$, criarNoTipoLexico($1));
		adicionarFilho($$, $3);
	};

function_call:
	TK_IDENTIFICADOR '(' args_list ')' {
		$$ = criarNoTipoLexico($1);
		atualizarValor($$);
		adicionarFilho($$, $3);
	};

args_list: 
	args{ $$ = $1; } |
	 { $$ = NULL; };

args: arg ',' args {
	adicionarFilho($1, $3); 
	$$ = $1; 
	} |
	arg {	$$ = $1;};

arg:
	expr { $$ = $1; };

return_command:
	TK_PR_RETURN expr {
		$$ = criarNo("return");
		adicionarFilho($$, $2);
	};

flow_control_command:
    condicional | iterative ';';

//if
condicional:
	TK_PR_IF '(' expr ')' commands_block condicional_complement {
		$$ = criarNo("condicional");
		adicionarFilho($$, $3);
		adicionarFilho($$, $5);
		adicionarFilho($$, $6);
		if($6 != NULL) { atualizarValor($$); }
	};

//else
condicional_complement:
	TK_PR_ELSE commands_block ';' { $$ = $2; } |
	';' { $$ = NULL; };

//while
iterative:
	TK_PR_WHILE '(' expr ')' commands_block {
		$$ = criarNo("iterative");
		adicionarFilho($$, $3);
		adicionarFilho($$, $5);
	};

opG0:
	'-' { $$ = criarNo("-"); } |
	'!' { $$ = criarNo("!"); } ;

opG1: 
	'*' { $$ = criarNo("*"); } |
	'/' { $$ = criarNo("/"); } |
	'%' { $$ = criarNo("%"); };

opG2:
	'+' { $$ = criarNo("+"); } |
	'-' { $$ = criarNo("-"); };

opG3:
	'<' { $$ = criarNo("<"); } |
	'>' { $$ = criarNo(">"); } |
	TK_OC_LE { $$ = criarNo("<="); } |
	TK_OC_GE { $$ = criarNo(">="); };

opG4: 
	TK_OC_EQ { $$ = criarNo("=="); } |
	TK_OC_NE { $$ = criarNo("!="); };

opAnd:
	TK_OC_AND { $$ = criarNo("&"); };
                        
opOr:
	TK_OC_OR { $$ = criarNo("|"); };

expr:                   
	expr1 { $$ = $1; } |
	expr opOr expr1 {
		adicionarFilho($2, $1);
		adicionarFilho($2, $3);
		$$ = $2;
	};

expr1:
	expr2 { $$ = $1; } |
	expr1 opAnd expr2 {
		adicionarFilho($2, $1);
		adicionarFilho($2, $3);
		$$ = $2;
	};

expr2:
	expr3 { $$ = $1; } |
	expr2 opG4 expr3 { 
		adicionarFilho($2, $1);
		adicionarFilho($2, $3);
		$$ = $2;
	};

expr3:
	expr4 { $$ = $1; } |
	expr3 opG3 expr4 {
		adicionarFilho($2, $1);
		adicionarFilho($2, $3);
		$$ = $2; 
	};

expr4:
	expr5 { $$ = $1; } |
	expr4 opG2 expr5 {
		adicionarFilho($2, $1);
		adicionarFilho($2, $3);
		$$ = $2;
	};

expr5:
	expr6 { $$ = $1; } |
	expr5 opG1 expr6 {
		adicionarFilho($2, $1);
		adicionarFilho($2, $3);
		$$ = $2;
	};

expr6:
	expr7 { $$ = $1; } |
	opG0 expr7 {
		adicionarFilho($1, $2);
		$$ = $1;
		};

expr7:
	operando { $$ = $1; } |
	'(' expr ')' { $$ = $2; };

%%

void yyerror(char const *s){
	printf("ERROR: %s [linha: %d token \"%s\"] \n\n", s,get_line_number(), yytext);
}