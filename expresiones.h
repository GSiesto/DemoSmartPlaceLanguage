/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     TIPO_ENTERO = 258,
     TIPO_REAL = 259,
     TIPO_TEXTO = 260,
     TIPO_POSITION = 261,
     TIPO_TEMPERATURE = 262,
     TIPO_LIGHT = 263,
     TIPO_SMOKE = 264,
     TIPO_ALARM = 265,
     TIPO_SWITCH = 266,
     TIPO_MESSAGE = 267,
     ENTERO = 268,
     REAL = 269,
     LOGICA = 270,
     ID = 271,
     COMA = 272,
     PUNTOCOMA = 273,
     CADENA = 274,
     ESCENARIOS = 275,
     START = 276,
     PAUSE = 277,
     REPEAT = 278,
     SCENE = 279,
     ACTION = 280,
     IF = 281,
     THEN = 282,
     ELSE = 283,
     INI_CONO = 284,
     END_CONO = 285,
     INI_BRACKET = 286,
     END_BRACKET = 287,
     VARIABLES = 288,
     sim_positivo = 289,
     sim_negativo = 290
   };
#endif
/* Tokens.  */
#define TIPO_ENTERO 258
#define TIPO_REAL 259
#define TIPO_TEXTO 260
#define TIPO_POSITION 261
#define TIPO_TEMPERATURE 262
#define TIPO_LIGHT 263
#define TIPO_SMOKE 264
#define TIPO_ALARM 265
#define TIPO_SWITCH 266
#define TIPO_MESSAGE 267
#define ENTERO 268
#define REAL 269
#define LOGICA 270
#define ID 271
#define COMA 272
#define PUNTOCOMA 273
#define CADENA 274
#define ESCENARIOS 275
#define START 276
#define PAUSE 277
#define REPEAT 278
#define SCENE 279
#define ACTION 280
#define IF 281
#define THEN 282
#define ELSE 283
#define INI_CONO 284
#define END_CONO 285
#define INI_BRACKET 286
#define END_BRACKET 287
#define VARIABLES 288
#define sim_positivo 289
#define sim_negativo 290




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 91 "expresiones.y"
{
	int c_entero;
	float c_real;
	char c_cadena[50];
	bool c_logica;
	struct tipo_position *c_position;
}
/* Line 1529 of yacc.c.  */
#line 127 "expresiones.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

