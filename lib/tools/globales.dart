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
List<String> caras= ["chica_rubia","nene","pelota","primercara"];
int caraIndex = 0;
int cara=0;
String fileContent = '';
List<dynamic> voices = [];
String ejemploAbc =
    ". a. be. ce. de. efe. ge. hache. i. jota. ka. ele. eme. ene. eñe. o. pe. ku. erre. ese. te. u. ve. doble ve. equis. y griega. seta.";


