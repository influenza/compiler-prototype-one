%{

#include <stdio.h>
#include <string.h>

extern int yylex(void);

extern char yytext[];
extern int column;

void scan_file(FILE *file);

int yyerror(char *s) {
  fflush(stdout);
  printf("\n%*s\n%*s\n", column, "^", column, s);
}

%}

%token IDENTIFIER CONSTANT STRING_LITERAL
%token ANY ALL WHEN ALERT DISPLAY PRINT
%token EQ_OP NEQ_OP LEQ_OP GEQ_OP
%token IN_OP NOT_OP AND_OP OR_OP

%%

compilation_unit: statement_list
                | declaration_list statement_list
                ;

compound_statement: '{' '}'
                  | '{' statement_list '}'
                  | '{' declaration_list statement_list '}'
                  ;

declaration_list: declaration
                | declaration declaration_list
                ;

declaration: ALERT IDENTIFIER ';'
           ;

statement_list: statement
          | statement statement_list
          ;

statement: compound_statement
         | expression_statement
         | when_statement
         ;

expression_statement: ';'
                    | expression ';'
                    ;

value_list: /* empty */
          | assignment_expression
          | assignment_expression ',' value_list
          ;

primary_expression: IDENTIFIER
                  | CONSTANT
                  | STRING_LITERAL
                  | '(' expression ')'
                  | '[' value_list ']'
                  ;

postfix_expression: primary_expression
                  | postfix_expression '.' IDENTIFIER /* membership operator */
                  ;

unary_expression: postfix_expression
                | unary_operator cast_expression
                ;

unary_operator: NOT_OP
              ;

cast_expression: unary_expression
               | '(' ALERT ')' cast_expression
               ;

multiplicative_expression: cast_expression
                         | multiplicative_expression '*' cast_expression
                         | multiplicative_expression '/' cast_expression
                         | multiplicative_expression '%' cast_expression
                         ;

additive_expression: multiplicative_expression
                   | additive_expression '+' multiplicative_expression
                   | additive_expression '-' multiplicative_expression
                   ;

relational_expression: additive_expression
                     | relational_expression '<' additive_expression
                     | relational_expression '>' additive_expression
                     | relational_expression LEQ_OP additive_expression
                     | relational_expression GEQ_OP additive_expression
                     ;

equality_expression: relational_expression
                   | equality_expression EQ_OP relational_expression
                   | equality_expression NEQ_OP relational_expression
                   | equality_expression IN_OP relational_expression
                   ;

logical_and_expression: equality_expression
                      | logical_and_expression AND_OP equality_expression
                      ;

logical_or_expression: logical_and_expression
                     | logical_or_expression OR_OP logical_and_expression
                     ;

assignment_expression: logical_or_expression
                     | unary_expression '=' assignment_expression
                     ;

expression: assignment_expression
          ;

when_statement:
              WHEN conditions DISPLAY IDENTIFIER ';'
              | action IDENTIFIER ';'
              ;

action:
      DISPLAY
      | PRINT
      ;

conditions:
          composite
          | composite AND_OP conditions
          | composite AND_OP NOT_OP conditions
          | composite OR_OP conditions
          | composite OR_OP NOT_OP conditions
          ;

composite:
         ANY compound_statement |
         ALL compound_statement
         ;

%%
#include <stdio.h>

extern FILE *yyin;

void scan_file(FILE *file)
{
  yyin = file;
  do {
    yyparse();
  } while (!feof(yyin));
}
