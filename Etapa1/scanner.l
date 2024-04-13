/* Lucas Guaitanelli da Silveira - 208695  */
/* Mateus Nunes Campos - 00268613  */

%{
#include "tokens.h"
%}

%option yylineno
%option noyywrap
%x COMMENT

%%

    /* Regra do comentário multi-linha, onde entramos no estado COMMENT caso um /* seja identificado, ignorando tudo até encontrar um /*, voltando assim ao estado inicial */

"/*" { BEGIN(COMMENT); }
<COMMENT>"*/" { BEGIN(INITIAL); }
<COMMENT>\n { }
<COMMENT>. { }

    /* Regra do comentário one liner (//) e de ignorar espaços */
(\/\/).* { }
[ \t]+   { }

    /* Regras das palavras reservadas, caracteres especiais e operadores compostos e dos literais true e false*/

"int" {return TK_PR_INT; }
"float" { return TK_PR_FLOAT; }
"bool" { return TK_PR_BOOL; }
"if" { return TK_PR_IF; }
"else" { return TK_PR_ELSE; }
"while" { return TK_PR_WHILE; }
"return" { return TK_PR_RETURN; }
"false" { return TK_LIT_FALSE; }
"true" { return TK_LIT_TRUE; }

"<=" { return TK_OC_LE; }
">=" { return TK_OC_GE; }
"==" { return TK_OC_EQ; }
"!=" { return TK_OC_NE; }
"&" { return TK_OC_AND; }
"|" { return TK_OC_OR; }

"!" { return '!'; }
"*" { return '*'; }
"/" { return '/'; }
"%" { return '%'; }
"+" { return '+'; }
"-" { return '-'; }
"<" { return '<'; }
">" { return '>'; }
"{" { return '{'; }
"}" { return '}'; }
"(" { return '('; }
")" { return ')'; }
"=" { return '='; }
"," { return ','; }
";" { return ';'; }

    /* Regra dos identificadores, começando com um caracter minúsculo ou underline e seguido de dígitos ou repetições opcionalmente */
([a-z]|_)([a-z]|[0-9]|_)* { return TK_IDENTIFICADOR; }

    /*Regras dos Literais */
[0-9]+ { return TK_LIT_INT; }
[0-9]*\.[0-9]+ { return TK_LIT_FLOAT; }

\n { }

. { return TK_ERRO; }

%%

int get_line_number(void) {
    return yylineno;
}
