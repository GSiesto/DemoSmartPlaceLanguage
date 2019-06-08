
%{

	// Guillermo Siesto Sanchez (gsiestos)
	// 3 Curso, Ingenieria de software UNEX
	// 2018/2019

#include <iostream>
#include "hashmap/map.h" /* Libreria para almacenar los simbolos */
#include "linkedlist/LinkedList.h" // Ordered HashMap
#include <math.h> /* Libreria para operaciones matematicas como Potencia */
#include <stdbool.h> /* Support booleans */
#include <fstream> /* Support files */
#include <stdio.h> /* Output like printf */
#include <iomanip> /* Columns in the output */
#include <sstream>
#include <string>
#include <vector>
#include <random>


using namespace std;

extern int n_lineas;
extern int yylex();
extern FILE* yyin;

// Banderas
int bTipo;	// 0 Entero | 1 Real
int bErrorSem; // 0 No error semantico | 1 Error semantico
int bErrorYaDefinida; // 0 No se ha definido antes | 1 Ya se ha definido
int bBucle;
int nBucle;
int bLogica; // 0 False | 1 True

// HashMap
map_tipodato_t m;
map_tipoinstruction_t mt;

tipo_datoTS dato;
tipo_datoTS datoAux;
tipo_instruccionTS instruccion;

// LinkedList
LinkedList<tipo_comandoTS> *myListEscenario = new LinkedList<tipo_comandoTS>();
tipo_comandoTS comando;

LinkedList<int> *myListOfRepeated = new LinkedList<int>();


// Fichero salida
ofstream fsal;
FILE* fsalCpp;

// Procedimientos auxiliares
void yyerror(const char* s){
	cout << ">		Error sintáctico en la línea "<< n_lineas+1<<endl;
}

void setTipo(int tipo){
	bTipo = tipo;
}

void setErrSemantico(int er){
	bErrorSem = er;
}

void setErrYaDefinida(int er){
	bErrorYaDefinida = er;
}

std::vector<int> convertStrtoArr(string str) {

	std::vector<int> vect;
	std::stringstream ss(str);

	int i;
	while (ss >> i)
	{
			vect.push_back(i);

			if (ss.peek() == '-')
					ss.ignore();
	}

    return vect;
}

%}

%union{
	int c_entero;
	float c_real;
	char c_cadena[50];
	bool c_logica;
	struct tipo_position *c_position;
}

%start entrada

%token <c_cadena> TIPO_ENTERO
%token <c_cadena> TIPO_REAL
%token <c_cadena> TIPO_TEXTO
%token <c_cadena> TIPO_POSITION

%token <c_cadena> TIPO_TEMPERATURE
%token <c_cadena> TIPO_LIGHT
%token <c_cadena> TIPO_SMOKE
%token <c_cadena> TIPO_ALARM
%token <c_cadena> TIPO_SWITCH
%token <c_cadena> TIPO_MESSAGE


%token <c_entero> ENTERO
%token <c_real> REAL
%token <c_logica> LOGICA
%token <c_cadena> ID


%token <c_cadena> COMA
%token <c_cadena> PUNTOCOMA

%token <c_cadena> CADENA

%token <c_cadena> ESCENARIOS;

%token <c_cadena> START;
%token <c_cadena> PAUSE;
%token <c_cadena> REPEAT;
%token <c_cadena> SCENE;

%token <c_cadena> ACTION;

%token <c_cadena> IF;
%token <c_cadena> THEN;
%token <c_cadena> ELSE;

%token <c_cadena> INI_CONO;
%token <c_cadena> END_CONO;

%token <c_cadena> INI_BRACKET;
%token <c_cadena> END_BRACKET;

%token <c_cadena> VARIABLES


%type <c_real> expr
%type <c_logica> exprLogica
%type <c_cadena> exprTexto
%type <c_position> exprPosition

%left '|' /* asociativo por la izquierda*/
%left '&' /* asociativo por la izquierda*/
%right '!' /* asociativo por la derecha */

%left '+' '-'   /* asociativo por la izquierda, misma prioridad */
%left '*' '/' '%'   /* asociativo por la izquierda, prioridad alta */
%right '^' /* Asociativa por la derecha */

%left sim_negativo sim_positivo /* asociativo por la izquierda, prioridad +alta */

%left '(' /* asociativo por la izquierda */


%%

entrada:
				| zona_uno ESCENARIOS zona_escenarios {
					fprintf(fsalCpp, "		entornoTerminar()\n	} // End entornoIniciar\n	return 0;\n}\n");
				}
				|	error 			{yyerrok;}
    		;

zona_uno: zona_variables zona_asignacion zona_sensores zona_actuadores
				;

/* ======================================================== */
/* ======================VARIABLES========================= */
/* ======================================================== */
zona_variables:	{}
			| zona_variables TIPO_ENTERO id_var_enteros PUNTOCOMA { }
			| zona_variables TIPO_REAL id_var_reales PUNTOCOMA { }
			| zona_variables TIPO_TEXTO id_var_texto PUNTOCOMA { }
			| zona_variables TIPO_POSITION id_var_position PUNTOCOMA { }
			|	error 			{yyerrok;}
			;

id_var_enteros: ID {
									if (map_get(&m, $1) != NULL) {
										cout<<"ERROR: El ID "<<$1<<" ya existe en la tabla"<<endl;
									} else {

										dato.tipo=0;
										map_set(&m, $1, dato);
									}
								}
							| id_var_enteros COMA ID {
								if(map_get(&m, $3) != NULL){
									cout<<"ERROR: El ID "<<$3<<" ya existe en la tabla"<<endl;
								} else {

									dato.tipo=0;
									map_set(&m, $3, dato);
								}
								}
							;

id_var_reales: ID {
									if(map_get(&m, $1) != NULL){
										cout<<"ERROR: El ID "<<$1<<" ya existe en la tabla"<<endl;
									} else {

										dato.tipo=1;
										map_set(&m, $1, dato);
									}
								}
							| id_var_reales COMA ID {
								if(map_get(&m, $3) != NULL){
									cout<<"ERROR: El ID "<<$3<<" ya existe en la tabla"<<endl;
								} else {

									dato.tipo=1;
									map_set(&m, $3, dato);
								}
								}
							;

id_var_texto: ID {
									if(map_get(&m, $1) != NULL){
										cout<<"ERROR: El ID "<<$1<<" ya existe en la tabla"<<endl;
									} else {

										dato.tipo=3;

										map_set(&m, $1, dato);
									}
								}
							| id_var_texto COMA ID  {
								if(map_get(&m, $3) != NULL){
									cout<<"ERROR: El ID "<<$3<<" ya existe en la tabla"<<endl;
								} else {

									dato.tipo=3;

									map_set(&m, $3, dato);
								}
								}
							;

id_var_position: ID {
									if(map_get(&m, $1) != NULL){
										cout<<"ERROR: El ID "<<$1<<" ya existe en la tabla"<<endl;
									} else {

										dato.tipo=2;

										map_set(&m, $1, dato);
									}
								}
							| id_var_position COMA ID {
								if(map_get(&m, $3) != NULL){
									cout<<"ERROR: El ID "<<$3<<" ya existe en la tabla"<<endl;
								} else {

									dato.tipo=2;

									map_set(&m, $3, dato);
								}
								}
							;

/* ======================================================== */
/* ======================ASIGNACION======================== */
/* ======================================================== */
zona_asignacion:{}
								| zona_asignacion asignacion {}
								;

asignacion:	ID '=' expr PUNTOCOMA {
					if(bErrorSem==1) {
						cout<<"Error semántico en la instrucción " <<n_lineas<<", el operador % no se puede utilizar con datos reales"<<endl;
					} else {
						/* +++++++++ No ha sido definida en la tabla, sino, no Hacemos nada */
						if (bErrorYaDefinida != 1) {

							/* +++++++++ El ID ya existe en la tabla */
							if (map_get(&m, $1) != NULL) { // El ID ya existe en la tabla

								dato = *map_get(&m, $1);
								/* +++++++++ El tipo almacenado no coincide con el nuevo */
								if (dato.tipo != bTipo) {
									cout<<"Error semántico en la instruccion "<<n_lineas<<", la variable "<<$1<<" es de tipo entero y no se le puede asignar un valor real"<<endl;
								} else {
								/* +++++++++ El tipo almacenado si coincide con el nuevo */
									if(bTipo==0) {

										if(dato.tipo==0) {
											dato.valor.valor_entero=$3;
											dato.tipo=0;
										}

										if(dato.tipo==1) {
											dato.valor.valor_real=$3;
											dato.tipo=1;
										}
									}

									if(bTipo==1){
										dato.valor.valor_real=$3;
										dato.tipo=1;
									}

									map_set(&m, $1, dato);

								}

							} else {
							/* +++++++++ El ID no existe en la tabla */
							cout<<"Error, la variable " << $1 <<" no ha sido definida con anterioridad indicando el tipo"<<endl;
							}

						}

					}

					setErrSemantico(0); /* Reseteamos */
					setTipo(0);					/* Reseteamos */
					setErrYaDefinida(0);/* Reseteamos */

				}
				| ID '=' exprTexto PUNTOCOMA {

						if(bErrorSem==1) {
							cout<<"Error semántico en la instrucción " <<n_lineas<<", el operador % no se puede utilizar con datos reales"<<endl;
						} else {
							/* +++++++++ No ha sido definida en la tabla, sino, no Hacemos nada */
							if (bErrorYaDefinida != 1) {

								/* +++++++++ El ID ya existe en la tabla */
								if (map_get(&m, $1) != NULL) { // El ID ya existe en la tabla

									dato = *map_get(&m, $1);
									/* +++++++++ El tipo almacenado no coincide con el nuevo */
									if (dato.tipo != bTipo) {
										cout<<"Error semántico en la instruccion "<<n_lineas<<", la variable "<<$1<<" es de tipo entero y no se le puede asignar un valor real"<<endl;
									} else {
									/* +++++++++ El tipo almacenado si coincide con el nuevo */

										strcpy(dato.valor.valor_string, $3);
										dato.tipo=3;

										map_set(&m, $1, dato);

									}

								} else {
								/* +++++++++ El ID no existe en la tabla */
								cout<<"Error, la variable " << $1 <<" no ha sido definida con anterioridad indicando el tipo"<<endl;
								}

							}

						}

						setErrSemantico(0); /* Reseteamos */
						setTipo(0);					/* Reseteamos */
						setErrYaDefinida(0);/* Reseteamos */

					}
				| ID '=' exprPosition PUNTOCOMA {

						if(bErrorSem==1) {
							cout<<"Error semántico en la instrucción " <<n_lineas<<", el operador % no se puede utilizar con datos reales"<<endl;
						} else {
							/* +++++++++ No ha sido definida en la tabla, sino, no Hacemos nada */
							if (bErrorYaDefinida != 1) {

								/* +++++++++ El ID ya existe en la tabla */
								if (map_get(&m, $1) != NULL) { // El ID ya existe en la tabla

									dato = *map_get(&m, $1);
									/* +++++++++ El tipo almacenado no coincide con el nuevo */
									if (dato.tipo != bTipo) {
										cout<<"Error semántico en la instruccion "<<n_lineas<<", la variable "<<$1<<" es de tipo entero y no se le puede asignar un valor real"<<endl;
									} else {
									/* +++++++++ El tipo almacenado si coincide con el nuevo */

										dato.valor.valor_position.x=$3->x;
										dato.valor.valor_position.y=$3->y;
										dato.tipo=2;

										map_set(&m, $1, dato);

									}

								} else {
								/* +++++++++ El ID no existe en la tabla */
								cout<<"Error, la variable " << $1 <<" no ha sido definida con anterioridad indicando el tipo"<<endl;
								}

							}

						}

						setErrSemantico(0); /* Reseteamos */
						setTipo(0);					/* Reseteamos */
						setErrYaDefinida(0);/* Reseteamos */

					}
				;



/* ======================================================== */
/* =====================EXPRESIONES======================== */
/* ======================================================== */
expr:    ENTERO 							{$$=$1;} /*No SetTipo(0) por los casos en los que hay entero y real a la vez*/
			 | REAL									{$$=$1; setTipo(1);}
			 | ID			{
				 					if(map_get(&m, $1) != NULL) {

										dato = *map_get(&m, $1);

										if(dato.tipo==0) {
											$$=dato.valor.valor_entero;
										}

										if(dato.tipo==1) {
											setTipo(1);
											$$=dato.valor.valor_real;
										}

									} else {
										cout<<"Error semántico en la línea " << n_lineas+1 <<", la variable "<<$1<<" no ha sido definida"<<endl;
										setErrYaDefinida(1);
									}
								}
       | expr '+' expr 					{$$=$1+$3;}
       | expr '-' expr    			{$$=$1-$3;}
       | expr '*' expr        	{$$=$1*$3;}
       | expr '/' expr        	{if (bTipo==0) {$$=(int)$1/(int)$3;} else { if (bTipo==1) {$$=$1/$3;} }}
 			 | expr '%' expr					{if (bTipo==0) {$$=(int)$1%(int)$3;} else { setErrSemantico(1); }}
			 | expr '^' expr        	{$$=pow($1,$3);}
       | '(' expr ')'						{$$=$2;}
			 | '+' expr %prec 				sim_positivo {$$=$2;}
       | '-' expr %prec 				sim_negativo {$$=-$2;}
       ;


exprLogica:	LOGICA								{
																		if ($1) {
																			bLogica=1;
																		} else {
																			bLogica=0;
																		}
																		$$=$1;
																	}
						| expr INI_CONO expr				{$$=$1<$3;}
						| expr END_CONO expr				{$$=$1>$3;}
						| expr '<''=' expr		{$$=$1<=$4;}
						| expr '>''=' expr		{$$=$1>=$4;}
						| expr '=''=' expr		{$$=$1==$4;}
						| expr '!''=' expr		{$$=$1!=$4;}
						| '(' exprLogica ')' 	 						{$$=$2;}
						| '!' exprLogica 	 								{$$=!$2;}
						| exprLogica '&''&' exprLogica		{$$=$1&&$4;}
						| exprLogica '|''|' exprLogica		{$$=$1||$4;}
						;

exprTexto: CADENA											{strcpy($$,$1);  setTipo(3);}
					 ;

exprPosition: INI_CONO expr COMA expr END_CONO 	{
																									struct tipo_position pos;
																									pos.x=$2;
																									pos.y=$4;
																									$$=&pos;
																									setTipo(2);
																								}
							| ID	{
		 				 					if(map_get(&m, $1) != NULL) {

		 										dato = *map_get(&m, $1);

		 										if(dato.tipo==2) {
		 											setTipo(2);
		 											$$=&dato.valor.valor_position;
		 										}

		 									} else {
		 										cout<<"Error semántico en la línea " << n_lineas+1 <<", la variable "<<$1<<" no ha sido definida"<<endl;
		 										setErrYaDefinida(1);
		 									}
		 								}
							;


/* ======================================================== */
/* ========================SENSORES======================== */
/* ======================================================== */
zona_sensores:	{}
			| zona_sensores TIPO_TEMPERATURE var_temperature PUNTOCOMA {}
			| zona_sensores TIPO_LIGHT var_light PUNTOCOMA {}
			| zona_sensores TIPO_SMOKE var_smoke PUNTOCOMA {}
			;

var_temperature: ID exprPosition  CADENA {
									if(map_get(&m, $1) != NULL){
										cout<<"ERROR: El ID "<<$1<<" ya existe en la tabla"<<endl;
									} else {

										dato.tipo=10;

										dato.posicion.x=$2->x;
										dato.posicion.y=$2->y;

										strcpy(dato.alias,$3);

										map_set(&m, $1, dato);

										fprintf(fsalCpp, "	entornoPonerSensor(%d,%d,%s,%d,%s);\n",$2->x, $2->y, $1, 0, $3);
									}
								}
							;

var_light: ID exprPosition  CADENA {
									if(map_get(&m, $1) != NULL){
										cout<<"ERROR: El ID "<<$1<<" ya existe en la tabla"<<endl;
									} else {

										dato.tipo=11;

										dato.posicion.x=$2->x;
										dato.posicion.y=$2->y;

										strcpy(dato.alias,$3);

										map_set(&m, $1, dato);

										fprintf(fsalCpp, "	entornoPonerSensor(%d,%d,%s,%d,%s);\n",$2->x, $2->y, $1, 0, $3);
									}
								}
							;

var_smoke: ID exprPosition  CADENA {
									if(map_get(&m, $1) != NULL){
										cout<<"ERROR: El ID "<<$1<<" ya existe en la tabla"<<endl;
									} else {

										dato.tipo=12;

										dato.posicion.x=$2->x;
										dato.posicion.y=$2->y;

										strcpy(dato.alias,$3);

										map_set(&m, $1, dato);

										fprintf(fsalCpp, "	entornoPonerSensor(%d,%d,%s,%d,%s);\n",$2->x, $2->y, $1, 0, $3);
									}
								}
							;

/* ======================================================== */
/* ========================ACTUADORES======================== */
/* ======================================================== */
zona_actuadores: {}
			| zona_actuadores TIPO_ALARM var_alarm PUNTOCOMA {}
			| zona_actuadores TIPO_SWITCH var_switch PUNTOCOMA {}
			| zona_actuadores TIPO_MESSAGE var_message PUNTOCOMA {}
			;

var_alarm:	ID {
								if(map_get(&m, $1) != NULL){
									cout<<"ERROR: El ID "<<$1<<" ya existe en la tabla"<<endl;
								} else {

									dato.tipo=20;

									dato.posicion.x=0;
									dato.posicion.y=0;

									strcpy(dato.alias,"");

									map_set(&m, $1, dato);

								}
							}
						;

var_switch: ID exprPosition CADENA {
									if(map_get(&m, $1) != NULL){
										cout<<"ERROR: El ID "<<$1<<" ya existe en la tabla"<<endl;
									} else {

										dato.tipo=21;

										dato.posicion.x=$2->x;
										dato.posicion.y=$2->y;

										strcpy(dato.alias,$3);

										map_set(&m, $1, dato);

										fprintf(fsalCpp, "	entornoPonerAct_Switch(%d,%d,%s,%s);\n",$2->x, $2->y, "false", $3);
									}
								}
							;

var_message: ID {
									if(map_get(&m, $1) != NULL){
										cout<<"ERROR: El ID "<<$1<<" ya existe en la tabla"<<endl;
									} else {

										dato.tipo=22;

										map_set(&m, $1, dato);
									}
								}
							;


/* ======================================================== */
/* =======================ECENARIOS======================== */
/* ======================================================== */
zona_escenarios: {
									fprintf(fsalCpp, "}\n\nint main(){\n	if (entornoIniciar()){\n");
								 }
								| zona_escenarios SCENE escena INI_BRACKET comportamiento_variables END_BRACKET PUNTOCOMA
									{

										cout <<"\n] { ESCENA }----------------------------------------------------------------------------------------\n";
										for (int i = 0; i < myListEscenario->size(); i++) {
											if (myListEscenario->get(i).id == 0) {
												cout << setw(2) << left << i << "| " << "Comando: "<< setw(3) << left << myListEscenario->get(i).id << " | Parametro 1: " << setw(12) << left << myListEscenario->get(i).param_1.valor_string << setw(12) << left << " | Parametro 2: " << myListEscenario->get(i).param_2.valor_real << endl;
			 								} else if (myListEscenario->get(i).id == 1) {
												cout << setw(2) << left << i << "| " << "Comando: "<< setw(3) << left << myListEscenario->get(i).id << " | Parametro 1: " << setw(12) << left << myListEscenario->get(i).param_1.valor_string << setw(12) << left << " | Parametro 2: " << myListEscenario->get(i).param_2.valor_string << endl;
											} else if (myListEscenario->get(i).id == 2) {
												cout << setw(2) << left << i << "| " << "Comando: "<< setw(3) << left << myListEscenario->get(i).id << " | Parametro 1: " << setw(12) << left << myListEscenario->get(i).param_1.valor_string << setw(12) << left << " | Parametro 2: " << myListEscenario->get(i).param_2.valor_string << endl;
											} else if (myListEscenario->get(i).id == 3) {
												cout << setw(2) << left << i << "| " << "Comando: "<< setw(3) << left << myListEscenario->get(i).id << " | Parametro 1: " << setw(12) << left << myListEscenario->get(i).param_1.valor_entero << setw(12) << left << " | Parametro 2: " << myListEscenario->get(i).param_2.valor_string << endl;
											} else if (myListEscenario->get(i).id == 4) {
												cout << setw(2) << left << i << "| " << "Comando: "<< setw(3) << left << myListEscenario->get(i).id << " | Parametro 1: " << setw(12) << left << myListEscenario->get(i).param_1.valor_entero << setw(12) << left << " | Parametro 2: " << myListEscenario->get(i).param_2.valor_string << endl;
											}
										}
										cout <<"]----------------------------------------------------------------------------------------\n";
									}
								;

escena:  	ID  {
						if (map_get(&m, $1) != NULL) {
							cout<<"ERROR: El ID "<<$1<<" ya existe en la tabla"<<endl;
						} else {

							dato.tipo=30;

							strcpy(dato.valor.valor_string, "");

							dato.posicion.x = 0;
							dato.posicion.y = 0;

							strcpy(dato.alias,"");

							map_set(&m, $1, dato);

							fprintf(fsalCpp, "\n		entornoPonerEscenario(\"%s\");\n", $1);

						}

					}
					;


comportamiento_variables: {}
			| comportamiento_variables START PUNTOCOMA { fprintf(fsalCpp, "		inicio();\n"); }
			| comportamiento_variables PAUSE var_pause PUNTOCOMA {}
			| comportamiento_variables REPEAT bucle INI_BRACKET comportamiento_variables END_BRACKET PUNTOCOMA{ fprintf(fsalCpp, "		} // End for\n"); }
			| comportamiento_variables id_var_action PUNTOCOMA { }
			| comportamiento_variables var_detection PUNTOCOMA { }
			| comportamiento_variables IF exprLogica THEN INI_BRACKET comportamiento_variables END_BRACKET condicion_else { bLogica=1; } // Y reseteamos valor de la condicion
			;

condicion_else: PUNTOCOMA {}
			| ELSE INI_BRACKET comportamiento_variables END_BRACKET PUNTOCOMA { bLogica=1; }
			;

bucle: expr {
							if (bLogica==1) {
								bBucle = 1;
								myListOfRepeated->clear();

								comando.id = 4;
								comando.param_1.valor_entero = $1;
								strcpy(comando.param_2.valor_string, "");

								myListEscenario->add(comando);
								nBucle = myListEscenario->size()-1;

								std::string str("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz");
								std::random_device rd;
								std::mt19937 generator(rd());
								std::shuffle(str.begin(), str.end(), generator);
								string index = str.substr(0, 6);
								fprintf(fsalCpp, "		for (int %s = 0 ; %s < %f; %s++) {\n",index.c_str(), index.c_str(), $1, index.c_str());

							}
			}
			;


var_detection: ID expr {

												if (bLogica==1) {
													if(map_get(&mt, $1) != NULL){
														cout<<"ERROR: El ID "<<$2<<" ya existe en la tabla"<<endl;
													} else {

														comando.id = 0;
														strcpy(comando.param_1.valor_string, $1);
														comando.param_2.valor_real = $2;
														myListEscenario->add(comando);

														if (bBucle == 1){
															myListOfRepeated->add(myListEscenario->size()-1);
														}

														// Imprimir en cpp
														datoAux = *map_get(&m, $1);
														fprintf(fsalCpp, "		entornoPonerSensor(%d, %d, %s, %f, %s);\n", datoAux.posicion.x, datoAux.posicion.y, $1, $2, datoAux.alias);

														}
													}
												}
							;


var_pause:	{
							if (bLogica==1) {
								fprintf(fsalCpp, "		entornoPulsarTecla();\n");
							}
						}
						| expr {
											if (bLogica==1) {
												comando.id = 3;
												comando.param_1.valor_entero = $1;
												strcpy(comando.param_2.valor_string, "");
												myListEscenario->add(comando);

												if (bBucle == 1){
													myListOfRepeated->add(myListEscenario->size()-1);
												}

												fprintf(fsalCpp, "		entornoPausa(%f);\n", $1);
											}
								 	}
					;

id_var_action: ID ACTION CADENA { // Caso: Whatsapp On "Message
																	if (bLogica==1) {
																		comando.id = 1;
																		strcpy(comando.param_1.valor_string, $1);
																		strcpy(comando.param_2.valor_string, $3);
																		myListEscenario->add(comando);

																		if (bBucle == 1){
																			myListOfRepeated->add(myListEscenario->size()-1);
																		}

																		if (strcmp($2, "ON")==0) {
																			fprintf(fsalCpp, "		entornoMostrarMensaje(%s); //1\n", $3);
																		} else {
																			fprintf(fsalCpp, "		entornoMostrarMensaje(%s); //1 ERROR: Ha querido decir ON\n", $3);
																		}
																	}
																}

						| ID CADENA { // Caso: A "mensaje"
													if (bLogica==1) {
														comando.id = 1;
														strcpy(comando.param_1.valor_string, $1);
														strcpy(comando.param_2.valor_string, "");
														myListEscenario->add(comando);

														fprintf(fsalCpp, "		action2(%s);\n", $1);
													}

												}

						| ID ACTION ID { // Caso: Whatsapp On "Message"

															if (bLogica==1) {
																comando.id = 1;
																strcpy(comando.param_1.valor_string, $1);
																strcpy(comando.param_2.valor_string, map_get(&m, $3)->valor.valor_string);
																myListEscenario->add(comando);

																if (bBucle == 1){
																	myListOfRepeated->add(myListEscenario->size()-1);
																}

																dato = *map_get(&m, $3);
																fprintf(fsalCpp, "		entornoMostrarMensaje(%s); //3\n", dato.valor.valor_string);
															}
														}
						| ID ACTION { // Caso Lamp/Heat ON/OFF / Whataspp ON/OFF
													if (bLogica==1) {
														comando.id = 1;
														strcpy(comando.param_1.valor_string, $1);
														strcpy(comando.param_2.valor_string, $2);
														myListEscenario->add(comando);

														if (bBucle == 1){
															myListOfRepeated->add(myListEscenario->size()-1);
														}

														datoAux = *map_get(&m, $1);

														if (datoAux.tipo == 20 ){	// Alarma
															if (strcmp($2, "ON")==0) {
																fprintf(fsalCpp, "		entornoAlarma(); //4.1\n");
															} else {
																// nada
															}
														} else if (datoAux.tipo == 21 ) { // Lampara
															if (strcmp($2, "ON")==0) {
																fprintf(fsalCpp, "		entornoPonerAct_Switch(%d,%d,%s,%s); //4.2.1\n", datoAux.posicion.x, datoAux.posicion.y, "true", datoAux.alias);
															} else {
																fprintf(fsalCpp, "		entornoPonerAct_Switch(%d,%d,%s,%s); //4.2.2\n", datoAux.posicion.x, datoAux.posicion.y, "false", datoAux.alias);
															}
														} else if (datoAux.tipo == 22 ) { // Whatsapp
															if (strcmp($2, "ON")==0) {
																fprintf(fsalCpp, "		entornoMostrarMensaje(%s); //4.3.1\n", datoAux.valor.valor_string);
															} else {
																fprintf(fsalCpp, "		entornoBorrarMensaje(); //4.3.2\n");
															}
														} else {
															fprintf(fsalCpp, "		TODO(TODO); //4.e\n");
														}
													}

												}
						;


%%

int main( int argc, char *argv[] ){

	if (argc != 2) {
			cout <<"USE: ./traductor entrada.dsp"<<endl;
			return 0;
	}

	// Entrada
	yyin=fopen(argv[1],"rt");

	// Salida
	fsal.open("hashmap.txt");
	if(!fsal.is_open()){
		cout<<"Error al abrir fichero de salida'"<<argv[2]<<"'"<<endl;
		return 0;
	}


	// SALIDA CPP
	fsalCpp=fopen("dslp.cpp","w");
	if (fsalCpp == NULL) {
		fprintf(fsalCpp, "Can't open output file %s!\n", "dslp.cpp");
		exit(1);
	}

	fprintf(fsalCpp, "#include <iostream>\n#include \"entorno_dspl.h\"\n\nusing namespace std;\n\nvoid inicio (){\n");



	// Variables
	n_lineas = 0;
	bTipo = 0;
	bErrorSem = 0;
	bErrorYaDefinida = 0;

	bBucle = 0;
	nBucle = 0;

	bLogica = 1;

	// Map
	map_init(&m);
	map_init(&mt);

	// LinkedList
	//LinkedList<tipo_comandoTS> *myListEscenario = new LinkedList<tipo_comandoTS>();

	typedef map_t(tipo_datoTS) utipodato_map_t;
	typedef map_t(tipo_instruccionTS) utipoinstruction_map_t;

	cout <<"\n\n******************************************************"<<endl;
	yyparse();
	cout <<"******************************************************\n\n"<<endl;

	/* Print HashMap ===================================== */
	const char *key;
	map_iter_t iter = map_iter(&m);
	cout << "------------- HashMap ------------------------------------------------------------------\n";
	fsal << "------------- HashMap ------------------------------------------------------------------\n";
	char *cadena;
	while ((key = map_next(&m, &iter))) {
		asprintf(&cadena, "Key: %16s  | Type: %3d | Value: ", key, map_get(&m, key)->tipo);
		cout << cadena;
		fsal << cadena;
		if (map_get(&m, key)->tipo == 0) {
			asprintf(&cadena, "%12d | Posicion: <%3d,%3d> | Alias: %3s\n", map_get(&m, key)->valor.valor_entero, map_get(&m, key)->posicion.x, map_get(&m, key)->posicion.y, map_get(&m, key)->alias);
			cout << cadena;
			fsal << cadena;
		} else if (map_get(&m, key)->tipo == 1) {
			asprintf(&cadena, "%12f | Posicion: <%3d,%3d> | Alias: %3s\n", map_get(&m, key)->valor.valor_real, map_get(&m, key)->posicion.x, map_get(&m, key)->posicion.y, map_get(&m, key)->alias);
			cout << cadena;
			fsal << cadena;
		} else if (map_get(&m, key)->tipo == 2) {
			asprintf(&cadena, "%4s<%3d,%3d> | Posicion: <%3d,%3d> | Alias: %3s\n", map_get(&m, key)->valor.valor_string, map_get(&m, key)->valor.valor_position.x, map_get(&m, key)->valor.valor_position.y, map_get(&m, key)->posicion.x, map_get(&m, key)->posicion.y, map_get(&m, key)->alias);
			cout << cadena;
			fsal << cadena;
		} else if (map_get(&m, key)->tipo == 3) {
			asprintf(&cadena, "%1s | Posicion: <%3d,%3d> | Alias: %3s\n", map_get(&m, key)->valor.valor_string, map_get(&m, key)->posicion.x, map_get(&m, key)->posicion.y, map_get(&m, key)->alias);
			cout << cadena;
			fsal << cadena;
		} else if (map_get(&m, key)->tipo == 10) {
			asprintf(&cadena, "%13s | Posicion: <%3d,%3d> | Alias: %3s\n", map_get(&m, key)->valor.valor_string, map_get(&m, key)->posicion.x, map_get(&m, key)->posicion.y, map_get(&m, key)->alias);
			cout << cadena;
			fsal << cadena;
		} else if (map_get(&m, key)->tipo == 11) {
			asprintf(&cadena, "%13s | Posicion: <%3d,%3d> | Alias: %3s\n", map_get(&m, key)->valor.valor_string, map_get(&m, key)->posicion.x, map_get(&m, key)->posicion.y, map_get(&m, key)->alias);
			cout << cadena;
			fsal << cadena;
		} else if (map_get(&m, key)->tipo == 12) {
			asprintf(&cadena, "%13s | Posicion: <%3d,%3d> | Alias: %3s\n", map_get(&m, key)->valor.valor_string, map_get(&m, key)->posicion.x, map_get(&m, key)->posicion.y, map_get(&m, key)->alias);
			cout << cadena;
			fsal << cadena;
		} else if (map_get(&m, key)->tipo == 20) {
			asprintf(&cadena, "%13s | Posicion: <%3d,%3d> | Alias: %3s\n", map_get(&m, key)->valor.valor_string, map_get(&m, key)->posicion.x, map_get(&m, key)->posicion.y, map_get(&m, key)->alias);
			cout << cadena;
			fsal << cadena;
		} else if (map_get(&m, key)->tipo == 21) {
			asprintf(&cadena, "%13s | Posicion: <%3d,%3d> | Alias: %3s\n", map_get(&m, key)->valor.valor_string, map_get(&m, key)->posicion.x, map_get(&m, key)->posicion.y, map_get(&m, key)->alias);
			cout << cadena;
			fsal << cadena;
		} else if (map_get(&m, key)->tipo == 22) {
			asprintf(&cadena, "%13s | Posicion: <%3d,%3d> | Alias: %3s\n", map_get(&m, key)->valor.valor_string, map_get(&m, key)->posicion.x, map_get(&m, key)->posicion.y, map_get(&m, key)->alias);
			cout << cadena;
			fsal << cadena;
		} else if (map_get(&m, key)->tipo == 30) {
			asprintf(&cadena, "%12s | Posicion: <%3d,%3d> | Alias: %3s\n", map_get(&m, key)->valor.valor_string, map_get(&m, key)->posicion.x, map_get(&m, key)->posicion.y, map_get(&m, key)->alias);
			cout << cadena;
			fsal << cadena;
		}
	}
	cout << "----------------------------------------------------------------------------------------\n";
	fsal << "----------------------------------------------------------------------------------------\n\n";

	map_deinit(&m); /* Liberamos la memoria ocupada por el hashmap */
	map_deinit(&mt); /* Liberamos la memoria ocupada por el linkedlist */


	fsal.close();

	fclose(fsalCpp);
	return 0;
}
