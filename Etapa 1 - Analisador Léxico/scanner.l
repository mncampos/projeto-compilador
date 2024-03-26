%{
/* C code to include before the rules section */
%}

/* Definitions Section */
%option noyywrap yylineno

/* Rules Section */
%%
/* Regular expressions and corresponding actions */

%%

/* C code section */
int main(int argc, char *argv[]) {
    /* Code for handling command line arguments and calling yylex() */
    return 0;
}

/* Additional C code and functions */

int get_line_number(void) {
    return yylineno;
}