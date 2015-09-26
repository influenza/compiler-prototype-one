/* scanner for Stanson Clinical Logic files */

%option noyywrap yylineno


%{
#include "scl_parser.h"

void count();

%}

%%

\"[^"]*\" { /* Consume string body */
  count(); return(STRING_LITERAL);
}
"true"    { count(); return(LITERAL_TRUE); }
"false"    { count(); return(LITERAL_FALSE); }
[0-9]+      { count(); return(NUMBER_LITERAL); } /* Scientific notation is not supported */
[0-9]+"."[0-9]*   { count(); return(NUMBER_LITERAL); }

"aggregate" { count(); return(TYPE_AGGREGATE); }
"string"  { count(); return(TYPE_STRING); }
"number"  { count(); return(TYPE_NUMBER); }
"boolean" { count(); return(TYPE_BOOL); }
"type"    { count(); return(TYPE); }
"monitor" { count(); return(MONITOR); }
"given"   { count(); return(GIVEN); }
"when"    { count(); return(WHEN); }
"then"    { count(); return(THEN); }
"all"     { count(); return(ALL); }
"any"     { count(); return(ANY); }
"except"  { count(); return(EXCEPT); }
"show"    { count(); return(SHOW); }

"."           { count(); return('.'); }
","           { count(); return(','); }
"+"           { count(); return('+'); }
"-"           { count(); return('-'); }
"*"           { count(); return('*'); }
"/"           { count(); return('/'); }
"%"           { count(); return('%'); }
"←"           { count(); return('←'); }
"="           { count(); return('='); }
"<"           { count(); return('<'); }
">"           { count(); return('>'); }
"=="          { count(); return(EQ_OP); }
"!="          { count(); return(NEQ_OP); }
"<="          { count(); return(LEQ_OP); }
">="          { count(); return(GEQ_OP); }
"in"          { count(); return(IN_OP); }
"not"         { count(); return(NOT_OP); }
"and"         { count(); return(AND_OP); }
"or"          { count(); return(OR_OP); }

[a-zA-Z]([a-zA-Z]|[0-9])* { count(); return(IDENTIFIER); }

"[" { count(); return('['); }
"]" { count(); return(']'); }
"{" { count(); return('{'); }
"}" { count(); return('}'); }
";" { count(); return(';'); }


<INITIAL>{ /* handle an escape */
    "\\n"   return('\n');
    "\\r"   return('\r');
    "\\t"   return('\t');
    "\\b"   return('\b');
    "\\f"   return('\f');
    "\\0"   return('\0');
}

"//[^\n]*"  {/* eat up one-line comments */ }

[ \t\v\n\f] { count(); }
.           { /* ignore bad chars */ }

%%

int column = 0;

void count()
{
  int i;

  for (i = 0; yytext[i] != '\0'; i++) {
    if (yytext[i] == '\n') {
      column = 0;
    } else if (yytext[i] == '\t') {
      column += 8 - (column % 8);
    } else {
      column++;
    }
  }
  ECHO;
}

