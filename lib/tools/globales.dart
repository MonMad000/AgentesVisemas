import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rive/rive.dart';

FlutterTts flutterTts = FlutterTts(); //texto a voz
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
String riv='chica_rubia';
List<String> caras= ["chica_rubia","nene","pelota","primercara1"];
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

