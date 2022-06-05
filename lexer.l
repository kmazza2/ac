%{
# include "mpfr.h"
# include "parser.tab.h"
extern unsigned long int PRECISION;
%}

%%
"+"	{ return ADD; }
"-"	{ return SUB; }
"*"	{ return MUL; }
"/"	{ return DIV; }
"("     { return LPAREN; }
")"     { return RPAREN; }
"="     { return EQUAL; }
"**"    { return EXPONENT; }
","     { return COMMA; }

"const_log2"|"const_pi"|"const_euler"|"const_catalan" {
    char *tmp = (char *) malloc((1 + strlen(yytext)) * sizeof(char));
    if (tmp == NULL) yyerror("Failed allocation");
    strcpy(tmp,yytext);
    yylval.func_name = tmp;
    return FUN0;
  }

"sqrt"|"rec_sqrt"|"cbrt"|"neg"|"abs"|"fac"|"sgn"|"log"|"log2"|"log10"|"log1p"|"exp"|"exp2"|"exp10"|"expm1"|"cos"|"sin"|"tan"|"sec"|"csc"|"cot"|"acos"|"asin"|"atan"|"cosh"|"sinh"|"tanh"|"sech"|"csch"|"coth"|"acosh"|"asinh"|"atanh"|"gamma"|"erf"|"erfc"|"j0"|"j1"|"y0"|"y1"|"ceil"|"floor"|"round"|"roundeven"|"trunc" {
    char *tmp = (char *) malloc((1 + strlen(yytext)) * sizeof(char));
    if (tmp == NULL) yyerror("Failed allocation");
    strcpy(tmp,yytext);
    yylval.func_name = tmp;
    return FUN1;
  }


"rootn"|"dim"|"mul_2"|"div_2"|"hypot"|"cmp"|"cmpabs"|"greater"|"greaterequal"|"less"|"lessequal"|"equal"|"lessgreater"|"pow"|"atan2"|"jn"|"yn" {
    char *tmp = (char *) malloc((1 + strlen(yytext)) * sizeof(char));
    if (tmp == NULL) yyerror("Failed allocation");
    strcpy(tmp,yytext);
    yylval.func_name = tmp;
    return FUN2;
  }

"fma"|"fms" {
    char *tmp = (char *) malloc((1 + strlen(yytext)) * sizeof(char));
    if (tmp == NULL) yyerror("Failed allocation");
    strcpy(tmp,yytext);
    yylval.func_name = tmp;
    return FUN3;
  }

"fmma"|"fmms" {
    char *tmp = (char *) malloc((1 + strlen(yytext)) * sizeof(char));
    if (tmp == NULL) yyerror("Failed allocation");
    strcpy(tmp,yytext);
    yylval.func_name = tmp;
    return FUN4;
  }

"SET_PRECISION" { return SETPRECISION; }

0|0\.[0-9]*|[1-9][0-9]*|[1-9][0-9]*\.[0-9]*|\.0*[1-9]+ {
    mpfr_t *tmp = (mpfr_t *) malloc(sizeof(mpfr_t));
    if (tmp == NULL) yyerror("Failed allocation");
    mpfr_init2 (*tmp, PRECISION);
    mpfr_set_str (*tmp, yytext, 10, MPFR_RNDN);
    yylval.mpfr_t_ptr = tmp;
    return NUMBER;
  }

\n      { return EOL; }
[ \t]   { }
.	{ yyerror("unrecognized text\n", *yytext); }
%%
