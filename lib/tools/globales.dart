import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rive/rive.dart';

FlutterTts flutterTts = FlutterTts(); //texto a voz
enum TTSState { playing, stopped, paused, continued }
String nombre="Samanta";
TTSState ttsState = TTSState.stopped;
bool moverBoca=true;
late Timer timer;
int segundos = 0;
String texto = "";
TextEditingController controller = TextEditingController();
ScrollController scrollController = ScrollController();
String response ="";
List<String> textoDividido = [];
SMIInput<double>? visemaNum;
SMIInput<double>? miradaNum;
SMIInput<double>? gestoNum;
int selectedEmotion = 0;
int esperaVisemas = 0;
Artboard? riveArtboard;
bool hablando=false;
String riv='chica_rubia0';
List<String> caras= ["chica_rubia0","nene0","pelota0","primercara0"];
int caraIndex = 0;
int cara=0;
String fileContent = '';
List<dynamic> voices = [];
String ejemploAbc =
    ". a. be. ce. de. efe. ge. hache. i. jota. ka. ele. eme. ene. eñe. o. pe. ku. erre. ese. te. u. ve. doble ve. equis. y griega. seta.";
List<Map<String, String>> voiceMaps = [
  {"name": "es-us-x-sfb-network", "locale": "es-US"},//0//mujer ES
  {"name": "es-US-language", "locale": "es-US"},//1//hombre LA
  {"name": "es-us-x-esc-network", "locale": "es-US"},//2 mujer LA
  {"name": "es-us-x-esf-local", "locale": "es-US"},//3 h la
  {"name": "es-us-x-esc-local", "locale": "es-US"},//4 m la
  {"name": "es-us-x-esf-network", "locale": "es-US"},//5 h la
  {"name": "es-us-x-esd-network", "locale": "es-US"},//6 h la nene
];

String poema = '''
En un océano de emociones,
donde la felicidad reina,
bailan las risas con alegría,
y los abrazos son la cadena.

La gratitud, con su luz brillante,
ilumina cada rincón,
y la paz, como su amante,
nos envuelve en su canción.

La serenidad, como un manto,
cubre nuestros corazones,
y la esperanza, como un encanto,
nos guía en nuestras acciones.

Optimismo en cada paso,
plenitud en cada instante,
comprensión, un dulce abrazo,
compasión, un suave canto.

Entusiasmo y éxito se entrelazan,
en una danza sin fin,
celebrando cada logro,
con inspiración sin fin.

Agradecimiento, la melodía,
que en nuestros labios florece,
generosidad, la armonía,
que en nuestros gestos crece.

Bajo el cielo de la vida,
con unión y caridad,
en cada alma compartida,
la verdadera felicidad.

Pero en la sombra, el enojo,
y el asco, su cruel reflejo,
tristeza, un oscuro abismo,
que se cierne como un presagio.

Pero aún en la oscuridad,
brilla la luz de la esperanza,
con amor y voluntad,
venciendo toda templanza.

Así en este vaivén constante,
de emociones que nos tocan,
navegamos adelante,
en este mar que nos provoca.
''';

