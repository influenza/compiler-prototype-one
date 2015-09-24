/* scanner for Stanson Clinical Logic files */

%{
/* need this for the call to atof() below */
#include "scl.tab.h"
void count();
%}

D [0-9]
A [a-zA-Z_]

%%

\"[^"]*\" { /* Consume string body */
  count(); return(STRING_LITERAL);
}

"any"         { count(); return(ANY); }
"all"         { count(); return(ALL); }
"when"        { count(); return(WHEN); }
"Alert"       { count(); return(ALERT); }
"display"     { count(); return(DISPLAY); }
"print"       { count(); return(PRINT); }
{D}+          { count(); return(CONSTANT); }
{D}+"."{D}*   { count(); return(CONSTANT); }

{D}{4}-{D}{2}-{D}{2}_{D}{2}:{D}{2}:{D}{2} { count(); return(CONSTANT); }


"."           { count(); return('.'); }
","           { count(); return(','); }
"+"           { count(); return('+'); }
"-"           { count(); return('-'); }
"*"           { count(); return('*'); }
"/"           { count(); return('/'); }
"%"           { count(); return('%'); }
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

{A}({A}|{D})* { count(); return(IDENTIFIER); }

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

int yywrap() { return(1); }

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
