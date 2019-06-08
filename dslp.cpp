#include <iostream>
#include "entorno_dspl.h"

using namespace std;

void inicio (){
	entornoPonerSensor(25,25,indoorTemp,0,"T1");
	entornoPonerSensor(250,250,S,0,"SH");
	entornoPonerAct_Switch(150,550,false,"CA");
}

int main(){
	if (entornoIniciar()){

		entornoPonerEscenario("Winter");
		inicio();
		entornoPulsarTecla();
		entornoPonerSensor(25, 25, indoorTemp, 18.200001, "T1");
		entornoPonerAct_Switch(150,550,true,"CA"); //4.2.1
		entornoMostrarMensaje("Calefacción encendida"); //1
		entornoPausa(3.000000);
		entornoBorrarMensaje(); //4.3.2
		entornoPonerSensor(25, 25, indoorTemp, 28.200001, "T1");
		entornoPonerAct_Switch(150,550,false,"CA"); //4.2.2
		entornoMostrarMensaje("Calefacción apagada"); //1
		entornoPulsarTecla();
		entornoBorrarMensaje(); //4.3.2

		entornoPonerEscenario("Fire");
		inicio();
		entornoPausa(1.000000);
		entornoPonerSensor(250, 250, S, 100.000000, "SH");
		entornoMostrarMensaje("Alarma. Alta probabilidad de incendio"); //3
		for (int BjcnPp = 0 ; BjcnPp < 2.000000; BjcnPp++) {
		entornoAlarma(); //4.1
		entornoPausa(1.000000);
		} // End for
		entornoBorrarMensaje(); //4.3.2
		entornoTerminar()
	} // End entornoIniciar
	return 0;
}
