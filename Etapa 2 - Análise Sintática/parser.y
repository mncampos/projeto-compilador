/* Lucas Guaitanelli da Silveira - 208695  */
/* Mateus Nunes Campos - 00268613  */

%define parse.error verbose
%{
int yylex(void);
void yyerror (char const *mensagem);
%}

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
%token TK_IDENTIFICADOR
%token TK_LIT_INT
%token TK_LIT_FLOAT
%token TK_LIT_FALSE
%token TK_LIT_TRUE
%token TK_ERRO

%%

program: item_list |;
element_list : element_list function | element_list global_var | function | global_var;

global_var : type id_list ','; 
id_list : TK_IDENTIFICADOR ';' id_list | TK_IDENTIFICADOR;

function : header body;
header: params TK_OC_OR type '\' TK_IDENTIFICADOR ;

params: '(' params_list ')' | '(' ')';
params_list: type TK_IDENTIFICADOR ';' params_list | type TK_IDENTIFICADOR;

body: '{' cmd_block '}' | '{' '}';

cmd_block: cmd_block cmd | cmd;
cmd: var ',' | assignment ',' | func_call ',' | return ',' | flow_control ',' | body ',' ;

var : type var_names
var_names : TK_IDENTIFICADOR ';' var | TK_IDENTIFICADOR ; 

assignment: TK_IDENTIFICADOR '=' exp;

func_call : TK_IDENTIFICADOR args;
args: '(' args_list ')' | '(' ')';
args_list: exp ';' args_list | exp;

return : TK_PR_RETURN exp;

if: TK_PR_IF '(' exp ')' body | TK_PR_IF '(' exp ')' body TK_PR_ELSE body ;
while: TK_PR_WHILE  '(' exp ')' body ; 

type: TK_PR_BOOL | TK_PR_FLOAT | TK_PR_INT;

exp : exp TK_OC_OR exp2 | exp2;
exp2: exp2 TK_OC_AND exp3 | exp3;
exp3: exp3 TK_OC_NE exp4 | exp3 TK_OC_EQ exp4 | exp4;
exp4: exp4 '<' exp5 | exp4 '>' exp5 | exp4 TK_OC_LE exp5 | exp4 TK_OC_GE exp5 | exp5;
exp5: exp5 '+' exp6 | exp5 '-' exp6 | exp6;
exp6: exp6 '*' exp7 | exp6 '/' exp7 | exp6 '%' exp7 | exp7;
exp7: '!' exp8 | '-' exp8 | exp8 ;
exp8: operand | '(' exp ')';

operand : TK_IDENTIFICADOR | function;

%%
