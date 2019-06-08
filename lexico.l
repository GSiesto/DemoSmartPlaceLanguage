%{
#include "expresiones.h"
#include <math.h>
int n_lineas;
%}

%option noyywrap


%x  COM1 COM2 POS1 POS2

%%

^"#"				          BEGIN(COM2);
"#"                   BEGIN(COM1);
<COM1>\n              {BEGIN(0);n_lineas++;/*return (yytext[0]);*/}
<COM2>\n			        {BEGIN(0);n_lineas++;}
<COM1>.              	;
<COM2>.				        ;


"ON"                  strcpy(yylval.c_cadena, yytext); return ACTION;
"OFF"                 strcpy(yylval.c_cadena, yytext); return ACTION;


";"                   return PUNTOCOMA;
","                   return COMA;

"int"			            return TIPO_ENTERO;
"float"			          return TIPO_REAL;
"string"			        return TIPO_TEXTO;
"position"            return TIPO_POSITION;

"temperature"         return TIPO_TEMPERATURE;
"light"               return TIPO_LIGHT;
"smoke"               return TIPO_SMOKE;

"alarm"               return TIPO_ALARM;
"switch"              return TIPO_SWITCH;
"message"             return TIPO_MESSAGE;

"%%"                  return ESCENARIOS;

["].*["]              {
                        strcpy(yylval.c_cadena, yytext);
                        return CADENA;
                      }

"start"               return START;
"pause"               return PAUSE;
"repeat"              return REPEAT;
"scene"               return SCENE;

"if"                  return IF;
"then"                return THEN;
"else"                return ELSE;

"<"		                return INI_CONO;
">"		                return END_CONO;

"["		                return INI_BRACKET;
"]"		                return END_BRACKET;


[0-9]+                            yylval.c_entero = atoi(yytext); return ENTERO;

[0-9]*[.][0-9]+([e][+-][0-9]*)?   yylval.c_real= atof(yytext); return REAL;

true		                          yylval.c_logica=true; return LOGICA;
false		                          yylval.c_logica=false; return LOGICA;

[a-zA-ZñÑ_][a-zA-ZñÑ_0-9]*        strcpy(yylval.c_cadena,yytext); return ID;


" "					          ;
\t					          ;
^\n					          n_lineas++;
^([ ]|[\t])+\n				n_lineas++;
\n					          n_lineas++;

. 				          	return (yytext[0]);

%%
