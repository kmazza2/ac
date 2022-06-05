%{
#  include <stdio.h>
#  include <string.h>
#  include "mpfr.h"
unsigned long int PRECISION = 2000;
%}

%define parse.error verbose

%union {
    mpfr_t *mpfr_t_ptr;
    char *func_name;
}

%token <mpfr_t_ptr> NUMBER
%right EQUAL
%left ADD SUB
%left MUL DIV
%right EXPONENT
%token LPAREN RPAREN 
%nonassoc UMINUS
%token SETPRECISION
%token EOL
%token COMMA
%token <func_name> FUN0
%token <func_name> FUN1
%token <func_name> FUN2
%token <func_name> FUN3
%token <func_name> FUN4

%type <mpfr_t_ptr> exp

%%

toplevel: 
 | toplevel exp EOL {
    mpfr_out_str (stdout, 10, 0, *$2, MPFR_RNDN);
    printf("\n> ");
    mpfr_clear (*$2);
    free($2);
  }
 | toplevel SETPRECISION EQUAL exp EOL {
    PRECISION = mpfr_get_ui (*$4, MPFR_RNDN);
    mpfr_clear (*$4);
    free($4);
    printf("> ");
  }
 | toplevel EOL { printf("> "); }
 ;

exp:
    NUMBER
 |  exp ADD exp {
    $$ = (mpfr_t *) malloc(sizeof(mpfr_t));
    if ($$ == NULL) yyerror("Failed allocation.");
    mpfr_init2 (*$$, PRECISION);
    mpfr_add (*$$, *$1, *$3, MPFR_RNDN);
    mpfr_clear (*$1);
    mpfr_clear (*$3);
    free($1);
    free($3);
  }
 | exp SUB exp {
    $$ = (mpfr_t *) malloc(sizeof(mpfr_t));
    if ($$ == NULL) yyerror("Failed allocation.");
    mpfr_init2 (*$$, PRECISION);
    mpfr_sub (*$$, *$1, *$3, MPFR_RNDN);
    mpfr_clear (*$1);
    mpfr_clear (*$3);
    free($1);
    free($3);
  }

 | exp MUL exp {
    $$ = (mpfr_t *) malloc(sizeof(mpfr_t));
    if ($$ == NULL) yyerror("Failed allocation.");
    mpfr_init2 (*$$, PRECISION);
    mpfr_mul (*$$, *$1, *$3, MPFR_RNDN);
    mpfr_clear (*$1);
    mpfr_clear (*$3);
    free($1);
    free($3);
  }
 | exp DIV exp {
    $$ = (mpfr_t *) malloc(sizeof(mpfr_t));
    if ($$ == NULL) yyerror("Failed allocation.");
    mpfr_init2 (*$$, PRECISION);
    mpfr_div (*$$, *$1, *$3, MPFR_RNDN);
    mpfr_clear (*$1);
    mpfr_clear (*$3);
    free($1);
    free($3);
  }
 | exp EXPONENT exp {
    $$ = (mpfr_t *) malloc(sizeof(mpfr_t));
    if ($$ == NULL) yyerror("Failed allocation.");
    mpfr_init2 (*$$, PRECISION);
    mpfr_pow (*$$, *$1, *$3, MPFR_RNDN);
    mpfr_clear (*$1);
    mpfr_clear (*$3);
    free($1);
    free($3);
 }
 | LPAREN exp RPAREN { $$ = $2; }


 | FUN0 {
    $$ = (mpfr_t *) malloc(sizeof(mpfr_t));
    if ($$ == NULL) yyerror("Failed allocation.");
    mpfr_init2 (*$$, PRECISION);

    if (strcmp($1, "const_log2") == 0) {
      mpfr_const_log2 (*$$, MPFR_RNDN);
    } else if (strcmp($1, "const_pi") == 0) {
      mpfr_const_pi (*$$, MPFR_RNDN);
    } else if (strcmp($1, "const_euler") == 0) {
      mpfr_const_euler(*$$, MPFR_RNDN);
    } else if (strcmp($1, "const_catalan") == 0) {
      mpfr_const_catalan(*$$, MPFR_RNDN);
    }

    free($1);
 }




 | FUN1 LPAREN exp RPAREN {
    $$ = (mpfr_t *) malloc(sizeof(mpfr_t));
    if ($$ == NULL) yyerror("Failed allocation.");
    mpfr_init2 (*$$, PRECISION);

    if (strcmp($1, "sqrt") == 0) {
      mpfr_sqrt (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "rec_sqrt") == 0) {
      mpfr_rec_sqrt (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "cbrt") == 0) {
      mpfr_cbrt (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "neg") == 0) {
      mpfr_neg (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "abs") == 0) {
      mpfr_abs (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "fac") == 0) {
      mpfr_fac_ui (*$$, mpfr_get_ui (*$3, MPFR_RNDN), MPFR_RNDN);
    } else if (strcmp($1, "sgn") == 0) {
      mpfr_set_si (*$$, mpfr_sgn (*$3), MPFR_RNDN);
    } else if (strcmp($1, "log") == 0) {
      mpfr_log (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "log2") == 0) {
      mpfr_log2 (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "log10") == 0) {
      mpfr_log10 (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "log1p") == 0) {
      mpfr_log1p (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "exp") == 0) {
      mpfr_exp (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "exp2") == 0) {
      mpfr_exp2 (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "exp10") == 0) {
      mpfr_exp10 (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "expm1") == 0) {
      mpfr_expm1 (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "cos") == 0) {
      mpfr_cos (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "sin") == 0) {
      mpfr_sin (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "tan") == 0) {
      mpfr_tan (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "sec") == 0) {
      mpfr_sec (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "csc") == 0) {
      mpfr_csc (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "cot") == 0) {
      mpfr_cot (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "acos") == 0) {
      mpfr_acos (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "asin") == 0) {
      mpfr_asin (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "atan") == 0) {
      mpfr_atan (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "cosh") == 0) {
      mpfr_cosh (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "sinh") == 0) {
      mpfr_sinh (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "tanh") == 0) {
      mpfr_tanh (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "sech") == 0) {
      mpfr_sech (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "csch") == 0) {
      mpfr_csch (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "coth") == 0) {
      mpfr_coth (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "acosh") == 0) {
      mpfr_acosh (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "asinh") == 0) {
      mpfr_asinh (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "atanh") == 0) {
      mpfr_atanh (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "gamma") == 0) {
      mpfr_gamma (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "erf") == 0) {
      mpfr_erf (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "erfc") == 0) {
      mpfr_erfc (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "j0") == 0) {
      mpfr_j0 (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "j1") == 0) {
      mpfr_j1 (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "y0") == 0) {
      mpfr_y0 (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "y1") == 0) {
      mpfr_y1 (*$$, *$3, MPFR_RNDN);
    } else if (strcmp($1, "ceil") == 0) {
      mpfr_ceil (*$$, *$3);
    } else if (strcmp($1, "floor") == 0) {
      mpfr_floor (*$$, *$3);
    } else if (strcmp($1, "round") == 0) {
      mpfr_round (*$$, *$3);
    } else if (strcmp($1, "roundeven") == 0) {
      mpfr_roundeven (*$$, *$3);
    } else if (strcmp($1, "trunc") == 0) {
      mpfr_trunc (*$$, *$3);
    }

    free($1);
    mpfr_clear (*$3);
    free($3);
 }

 | FUN2 LPAREN exp COMMA exp RPAREN {
    $$ = (mpfr_t *) malloc(sizeof(mpfr_t));
    if ($$ == NULL) yyerror("Failed allocation.");
    mpfr_init2 (*$$, PRECISION);

    if (strcmp($1, "rootn") == 0) {
      mpfr_rootn_ui (*$$, *$3, mpfr_get_ui(*$5, MPFR_RNDN), MPFR_RNDN);
    } else if (strcmp($1, "dim") == 0) {
      mpfr_dim (*$$, *$3, *$5, MPFR_RNDN);
    } else if (strcmp($1, "mul_2") == 0) {
      mpfr_mul_2si (*$$, *$3, mpfr_get_si(*$5, MPFR_RNDN), MPFR_RNDN);
    } else if (strcmp($1, "div_2") == 0) {
      mpfr_div_2si (*$$, *$3, mpfr_get_si(*$5, MPFR_RNDN), MPFR_RNDN);
    } else if (strcmp($1, "hypot") == 0) {
      mpfr_hypot (*$$, *$3, *$5, MPFR_RNDN);
    } else if (strcmp($1, "cmp") == 0) {
      mpfr_set_si(*$$, mpfr_cmp (*$3, *$5), MPFR_RNDN);
    } else if (strcmp($1, "cmpabs") == 0) {
      mpfr_set_si(*$$, mpfr_cmpabs (*$3, *$5), MPFR_RNDN);
    } else if (strcmp($1, "greater") == 0) {
      mpfr_set_si(*$$, mpfr_greater_p (*$3, *$5), MPFR_RNDN);
    } else if (strcmp($1, "greaterequal") == 0) {
      mpfr_set_si(*$$, mpfr_greaterequal_p (*$3, *$5), MPFR_RNDN);
    } else if (strcmp($1, "less") == 0) {
      mpfr_set_si(*$$, mpfr_less_p (*$3, *$5), MPFR_RNDN);
    } else if (strcmp($1, "lessequal") == 0) {
      mpfr_set_si(*$$, mpfr_lessequal_p (*$3, *$5), MPFR_RNDN);
    } else if (strcmp($1, "equal") == 0) {
      mpfr_set_si(*$$, mpfr_equal_p (*$3, *$5), MPFR_RNDN);
    } else if (strcmp($1, "lessgreater") == 0) {
      mpfr_set_si(*$$, mpfr_lessgreater_p (*$3, *$5), MPFR_RNDN);
    } else if (strcmp($1, "pow") == 0) {
      mpfr_pow (*$$, *$3, *$5, MPFR_RNDN);
    } else if (strcmp($1, "atan2") == 0) {
      mpfr_atan2 (*$$, *$3, *$5, MPFR_RNDN);
    } else if (strcmp($1, "jn") == 0) {
      mpfr_jn (*$$, mpfr_get_si(*$3, MPFR_RNDN), *$5, MPFR_RNDN);
    } else if (strcmp($1, "yn") == 0) {
      mpfr_yn (*$$, mpfr_get_si(*$3, MPFR_RNDN), *$5, MPFR_RNDN);
    }

    free($1);
    mpfr_clear (*$3);
    free($3);
    mpfr_clear (*$5);
    free($5);
 }

 | FUN3 LPAREN exp COMMA exp COMMA exp RPAREN {
    $$ = (mpfr_t *) malloc(sizeof(mpfr_t));
    if ($$ == NULL) yyerror("Failed allocation.");
    mpfr_init2 (*$$, PRECISION);

    if (strcmp($1, "fma") == 0) {
      mpfr_fma (*$$, *$3, *$5, *$7, MPFR_RNDN);
    } else if (strcmp($1, "fms") == 0) {
      mpfr_fms (*$$, *$3, *$5, *$7, MPFR_RNDN);
    }

    free($1);
    mpfr_clear (*$3);
    free($3);
    mpfr_clear (*$5);
    free($5);
    mpfr_clear (*$7);
    free($7);
 }

 | FUN4 LPAREN exp COMMA exp COMMA exp COMMA exp RPAREN {
    $$ = (mpfr_t *) malloc(sizeof(mpfr_t));
    if ($$ == NULL) yyerror("Failed allocation.");
    mpfr_init2 (*$$, PRECISION);

    if (strcmp($1, "fmma") == 0) {
      mpfr_fmma (*$$, *$3, *$5, *$7, *$9, MPFR_RNDN);
    } else if (strcmp($1, "fmms") == 0) {
      mpfr_fmms (*$$, *$3, *$5, *$7, *$9, MPFR_RNDN);
    }

    free($1);
    mpfr_clear (*$3);
    free($3);
    mpfr_clear (*$5);
    free($5);
    mpfr_clear (*$7);
    free($7);
    mpfr_clear (*$9);
    free($9);
 }

 | SUB exp %prec UMINUS {
    $$ = (mpfr_t *) malloc(sizeof(mpfr_t));
    if ($$ == NULL) yyerror("Failed allocation.");
    mpfr_init2 (*$$, PRECISION);
    mpfr_neg (*$$, *$2, MPFR_RNDN);
    mpfr_clear (*$2);
    free($2);
  }
 ;

%%

main()
{
  printf("> "); 
  yyparse();
}

yyerror(char *s)
{
  fprintf(stderr, "error: %s\n", s);
}
