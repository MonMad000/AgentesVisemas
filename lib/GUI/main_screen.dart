import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:agentes2d/GUI/DialogCard.dart';
import 'package:agentes2d/GUI/DialogRtaCard.dart';
import 'package:agentes2d/tools/MensajeModelo.dart';
import 'package:agentes2d/tools/gemini_api.dart';
import 'package:agentes2d/tools/globales.dart';
import 'package:agentes2d/tools/openai_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rive/rive.dart';

import '../tools/funciones.dart';
import '../tools/manejoDeTextos.dart';
import 'package:permission_handler/permission_handler.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // Solo orientación vertical
    ]);
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MensajeModelo> mensajes = [];
  bool interactiveMode = false;

  //############### FUNCIONES DE INICIALIZACION##############
  void _iniciarContador() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        segundos++;
      });
    });
  }

  void _reiniciarContador() {
    setState(() {
      segundos = 0;
    });
  }
  @override
  void initState() {
    final Random _random = Random();

    //se llama cuando este objeto se agrega al árbol de widget(en este caso al inicio ya q es la raiz)
    texto = "";
    super.initState();
    _iniciarContador();
    initTts();
    initRive(riv);
    Timer.periodic(const Duration(seconds: 4), (timer) {
      parpadea();
    });

    Timer.periodic(const Duration(seconds: 2), (timer) async {
      print(segundos);
      if (segundos>10){
        print("estuve 10 seg sin hablar");
        double g=_random.nextInt(6).toDouble();
        gestoNum?.value=g;
        visemaNum?.value=-1;
        print("random: "+gestoNum!.value.toString());
        miradaNum?.value=-1;
        await Future.delayed(const Duration(milliseconds: 2000));
        gestoNum?.value=0;
        visemaNum?.value=0;
        print("random: "+gestoNum!.value.toString());
        miradaNum?.value=-1;
        _reiniciarContador();
      }
    });
  }

  initTts() async {
    //inicializa el flutterTts, controlador del texto a voz
    flutterTts = FlutterTts();
    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TTSState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TTSState.stopped;
      });
    });
    //_getAvailableVoices();
    setVoiceRubia();
    await flutterTts.setSpeechRate(0.3); //mi celu android

    //.setSpeechRate(0.4);
    await flutterTts.setVolume(1); // Establece el volumen
  }

  initRive(String riv) {
    rootBundle.load('assets/Caras2/$riv.riv').then(
      //rootBundle.load('assets/Caras/nene.riv').then(
      //se toma el archivo .rive de la animacion
      (data) async {
        // se guarda en la variable file
        final file = RiveFile.import(data);
        //se guarda el artboard del archivo
        final artboard = file.mainArtboard;
        //se crea un controlador de la statemachine tomandola del artboard y por su nombre con el constructor fromArtboard
        var controller = StateMachineController.fromArtboard(artboard, 'Habla');
        //se controla que exista la statemachine
        if (controller != null) {
          //se debe agregar el controller al artboard (la variable)
          artboard.addController(controller);

          //se especifica el input
          visemaNum = controller.findInput('VisemaNum');
          visemaNum?.value = 0;
          gestoNum = controller.findInput('gesto');
          gestoNum?.value = 0;
          miradaNum = controller.findInput('mirada');
          miradaNum?.value = -1;
        }

        setState(() => riveArtboard = artboard);
      },
    );
  }

  //############### FUNCIONES DE INTERFAZ##############
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        color: Colors.orangeAccent,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const SizedBox(height: 35),
            Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[900],
                    border: Border.all(
                      color: Colors.orangeAccent, // Color del borde
                      width: 8.0, // Ancho del borde
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) {
                      // Calcula la diferencia horizontal
                      double deltaX = details.primaryVelocity ?? 0;

                      // Establece un umbral para determinar si es un gesto de desplazamiento a la izquierda o a la derecha
                      if (deltaX > 0) {
                        // Desplazamiento hacia la derecha
                        print('Desplazamiento a la derecha');
                        _moveToNext();
                        initRive(caras[caraIndex]);
                      } else if (deltaX < 0) {
                        // Desplazamiento hacia la izquierda
                        print('Desplazamiento a la izquierda');
                        _moveToPrevious();
                        initRive(caras[caraIndex]);
                      }
                      switch (caraIndex) {
                        case 0:
                          setVoiceRubia();
                          break; // The switch statement must be told to exit, or it will execute every case.
                        case 1:
                          setVoiceNene();
                          break;
                        case 2:
                          setVoicePelota();
                          break;
                        default:
                          setVoiceMujer();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors
                              .black54, // Color del segundo borde (doble borde)
                          width: 8, // Ancho del segundo borde
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: riveArtboard != null
                            ? Rive(artboard: riveArtboard!)
                            : CircularProgressIndicator(),
                      ),
                    ),
                  ),
                )),
            Expanded(
                flex: 1,
                child: ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: mensajes.length + 1,
                  itemBuilder: (context, index) {
                    if (index == mensajes.length) {
                      return Container(
                        height: 40,
                      );
                    }

                    return mensajes[index].tipo == "enviado"
                        ? DialogCard(
                            txt: mensajes[index].mensaje,
                            callback: updateTextField,
                          )
                        : DialogRtaCard(txt: mensajes[index].mensaje);
                  },
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    child: Card(
                      margin:
                          const EdgeInsets.only(left: 5, right: 2, bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        onChanged: (String value) {
                          _onChange(value);
                        },
                        controller: controller,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Hola :D",
                            prefixIcon: Switch(
                                inactiveThumbColor: Colors.blueGrey[900],
                                activeColor: Colors.deepOrange,
                                value: interactiveMode,
                                onChanged: (value) {
                                  setState(() {
                                    print(ttsState);
                                    //parpadea();
                                    interactiveMode = value;
                                  });
                                }),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.attach_file),
                              onPressed: () async {
                                // Verificar si el permiso ya fue concedido
                                // var status = await Permission
                                //     .manageExternalStorage.status;
                                // if (status.isGranted) {
                                //   // El permiso ya fue concedido, puedes abrir el explorador de archivos
                                //   _openFileExplorer();
                                // } else {
                                //   // El usuario no concedió el permiso, puedes mostrar un mensaje o realizar alguna acción adicional
                                //   print(
                                //       'El usuario no concedió el permiso de almacenamiento.');
                                // }
                                fileContent = await rootBundle
                                    .loadString('assets/textos/3cerditos.txt');
                                cargaTXT(fileContent);
                              },
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8, right: 5, left: 2, top: 3),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(0,
                                2), // The shadow offset (horizontal, vertical)
                            blurRadius: 3, // The blur radius
                            spreadRadius: 0, // The spread radius
                          ),
                        ],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3.0, // Ancho del borde
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.blueGrey[900], //
                        radius: 22,
                        child: IconButton(
                          //boton para hablar
                          icon: Icon(
                              interactiveMode
                                  ? Icons.send
                                  : Icons.record_voice_over,
                              color: Colors.white),
                          onPressed: () async {
                            _reiniciarContador();
                            FocusScope.of(context).requestFocus(FocusNode());

                            if (!interactiveMode) {
                              if (ttsState == TTSState.playing) {
                                moverBoca=false;
                                _stop();
                              } else {
                                if (controller.text.isNotEmpty) {
                                  moverBoca=true;
                                  await setMensaje("enviado", controller.text);
                                  print("el texto enviado es $texto");
                                  controller.clear(); //limpia el campo de texto
                                  fragmentarTexto(texto);
                                }
                              }
                            } else {
                              if (controller.text.isNotEmpty) {
                                // print('modo interactivo, el texto tiene $texto');
                                // var res = await sendTextCompletionRequest(texto);
                                // print("res:"+res.toString());
                                // response =res["choices"][0]["text"];
                                // print("response:"+response);
                                // String textoDecodificado = utf8.decode(response.codeUnits);
                                // print(textoDecodificado);
                                await setMensaje("enviado", controller.text);

                                controller.clear(); //limpia el campo de texto
                                //fragmentarTexto(textoDecodificado);
                                String rta =
                                    "Hola.Esto es una respuesta feliz!";
                                rta = await GeminiAPI.getGeminiData(texto);

                                rta = eliminarSimbolos(rta);

                                if (rta == "") {
                                  rta = "Prefiero no hablar de eso";
                                }

                                fragmentarTexto(rta);

                                await setMensaje("recibido", rta);
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  String eliminarSimbolos(String texto) {
    // Expresión regular que busca los símbolos a eliminar.
    final RegExp simbolosAEliminar = RegExp(r'[*\@\#\$%\^\&]');

    // Reemplaza todos los símbolos con una cadena vacía.
    return texto.replaceAll(simbolosAEliminar, '');
  }

  void _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );
    if (result != null) {
      final path = result.files.single.path;
      final file = File(path!);

      fileContent = await file.readAsString();
      cargaTXT(fileContent);
    } else {
      // Se la selección de archivos.
    }
  }

  void cargaTXT(String fileContent) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(
                25)), // Ajusta el radio para controlar la curvatura de los bordes.
      ),
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      elevation: 0,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5 - 55,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Text(
                    fileContent,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8, right: 5, left: 2, top: 3),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(0,
                                2), // The shadow offset (horizontal, vertical)
                            blurRadius: 3, // The blur radius
                            spreadRadius: 0, // The spread radius
                          ),
                        ],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.orange,
                          width: 3.0, // Ancho del borde
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.blueGrey[900], //
                        radius: 22,
                        child: IconButton(
                          icon: Icon(
                              interactiveMode
                                  ? Icons.send
                                  : Icons.record_voice_over,
                              color: Colors.white),
                          onPressed: () {
                            fragmentarTexto(fileContent);
                          },
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> setMensaje(String tipo, String txt) async {
    MensajeModelo mensajeModelo = MensajeModelo(
        mensaje: txt, tipo: tipo, cntLineas: txt.split('\n').length);
    setState(() {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
      mensajes.add(mensajeModelo);
    });
    return Future(() => 1);
  }

  //################# FUNCIONES QUE ACTUALIZAN ESTADO###################

  Future<void> habla(String C) async {
    await flutterTts.awaitSpeakCompletion(true);
    if (C.isNotEmpty) {
      await flutterTts.speak(C);
      await flutterTts.awaitSpeakCompletion(true);
      hablando = false;
      await Future.delayed(const Duration(milliseconds: 1000));
      visemaNum?.value = -1;
    }
  }

// se actualiza el texto q se esta ingresando, se invoca cuando el campo de texto cambia
  void _onChange(String text) {
    setState(() {
      texto = text;
    });
  }

  Future<int> recorrerTextoSSML(String texto) async {
    //se recorre el texto para pasar de caracter a visema

      for (int i = 0; i < texto.length; i++) {
        if(!moverBoca){
          visemaNum?.value=-1;
          return 0;
        }
      //este if controla que si es el primer caracter no espere
      if (i == 0) {
        esperaVisemas = 0;
      } else {
        if (caraIndex == 1 || caraIndex == 2) {
          esperaVisemas = 57;
        } else {
          esperaVisemas = 65;
        }
      }
      switch (texto[i]) {
        case '.':
          await Future.delayed(const Duration(milliseconds: 800));
          break;
        case ',':
          await Future.delayed(const Duration(milliseconds: 300));
          break;
        case ';':
          await Future.delayed(const Duration(milliseconds: 400));
          break;
        case '?':
          await Future.delayed(const Duration(milliseconds: 800));
          break;
        case '!':
          await Future.delayed(const Duration(milliseconds: 800));
          break;
        case ':':
          await Future.delayed(const Duration(milliseconds: 400));
          break;
        case '\n': // Nueva línea
          await Future.delayed(const Duration(milliseconds: 500));
          break;
        case '-': // Guion
          await Future.delayed(const Duration(milliseconds: 200));
          break;
      }
      await Future.delayed(Duration(milliseconds: esperaVisemas), () {
        if (caraIndex == 1 || caraIndex == 2) {
          visemaNum?.value = charToVisemaGenerico(texto[i]).toDouble();
        } else {
          visemaNum?.value = charToVisema(texto[i]).toDouble();
        }
      });
      //recorro la cadena entre signos de puntuacion
      if (texto[i] == '.' ||
          texto[i] == ',' ||
          texto[i] == ';' ||
          //texto[i] == '?' ||
          texto[i] == '!' ||
          texto[i] == ':' ||
          texto[i] == '-' ||
          i == 0) {
        // Detectar el próximo texto hasta el siguiente signo de puntuación
        String proximoTexto = '';
        for (int j = i + 1; j < texto.length; j++) {
          if (texto[j] == '.' ||
              texto[j] == ',' ||
              texto[j] == ';' ||
              //texto[j] == '?' ||
              texto[j] == '!' ||
              texto[j] == ':' ||
              texto[i] == '-') {
            break;
          }
          proximoTexto += texto[j];
        }
        if (proximoTexto.isNotEmpty) {
          Emocion emocionProximoTexto =
              analizarSentimiento(proximoTexto.trim());
          gestoNum?.value = asignarValorEmocion(emocionProximoTexto);
        }
      }
    }
    return 1;
  }

  hablaSSML(String txt) async {
    await flutterTts.awaitSpeakCompletion(true);
    // txt=agregarPuntoDespuesDeConjuncion(txt);
    //print('texo con puntos nuevos $txt');
    txt = remplazarNumerosEnPalabras(txt);
    String txtSSML = convertToSSML(txt); //se prepara el texto para el tts
    String txtLimpio =
        "${limpiaTexto(txt)}."; //se prepara el texto para el ttv (text to visem)
    recorrerTextoSSML(txtLimpio);
    //await flutterTts.speak(txtSSML);
    await _speak(txtSSML);
    visemaNum?.value = -1;
    //habla(txtSSML);
  }

  void printLanguages() async {
    List<dynamic> languages = await flutterTts.getVoices;
    print("engines soportados:");
    languages.forEach((language) {
      print(language);
    });
  }

  void updateTextField(String newText) {
    setState(() {
      controller.text = newText;
      texto = newText;
    });
  }

  Future<void> parpadea() async {
    //await flutterTts.stop();

    miradaNum?.value = 5;
    await Future.delayed(const Duration(milliseconds: 100));
    miradaNum?.value = -1;
  }

//################# FUNCIONES AUXILIARES###################
//fragmentar texto largo
//aca primero deberia llamar a una funcion que invoque a splitPorPunto
// y luego con el arreglo de textos invocar a recorrerArregloDeStrings
//donde ahi dentro recien llamar a hablaSSML
  fragmentarTexto(String texto) {
    textoDividido = splitPorPunto(texto);
    print('el texto dividido es' + textoDividido.toString());
    recorrerArregloDeStrings(textoDividido);
  }

  recorrerArregloDeStrings(List<String> textoCompleto) async {
    for (int i = 0; i < textoCompleto.length; i++) {
      if(moverBoca)
      await hablaSSML(textoCompleto[i]);
    }
  }

  void _moveToNext() {
    setState(() {
      caraIndex = (caraIndex + 1) % caras.length;
    });
  }

  void _moveToPrevious() {
    setState(() {
      caraIndex = (caraIndex - 1 + caras.length) % caras.length;
    });
  }

  Future<void> _getAvailableVoices() async {
    voices = await flutterTts.getVoices;
    List<dynamic> spanishVoices = voices
        .where((voice) => voice['locale'].toString().contains('es'))
        .toList();
    List<Map<String, dynamic>> voiceMaps = [];
    print('Available Spanish Voices:');
    for (var voice in spanishVoices) {
      print('name: ${voice['name']}, locale: ${voice['locale']}');

      // Hablar utilizando la voz actual
      await flutterTts.setVoice({
        "name": voice['name'],
        "locale": voice['locale'],
      });
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak("Hola, estoy probando esta voz.");
      voiceMaps.add({
        "name": voice['name'],
        "locale": voice['locale'],
      });
    }
    print('Voice Maps:');
    voiceMaps.forEach((voiceMap) {
      print('name: ${voiceMap['name']}, locale: ${voiceMap['locale']}');
    });
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
    setState(() {
      ttsState = TTSState.playing;
      print(ttsState);
    });
  }

  Future<void> _stop() async {
    await flutterTts.stop();
    setState(() {
      ttsState = TTSState.stopped;
      print(ttsState);
    });
  }
}
