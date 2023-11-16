import 'dart:io';

import 'package:agentes2d/GUI/DialogCard.dart';
import 'package:agentes2d/GUI/DialogRtaCard.dart';
import 'package:agentes2d/tools/globales.dart';
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
  List<String> mensajes = [];
  bool interactiveMode = false;

  //############### FUNCIONES DE INICIALIZACION##############

  @override
  void initState() {
    //se llama cuando este objeto se agrega al árbol de widget(en este caso al inicio ya q es la raiz)
    texto = "";
    super.initState();
    initTts();
    initRive(riv);
  }

  initTts() async {
    //inicializa el flutterTts, controlador del texto a voz
    flutterTts = FlutterTts();
    await flutterTts.setLanguage('es-MX'); // Establece el idioma
    await flutterTts
        .setSpeechRate(0.46); //0.53 Establece la velocidad del habla
    await flutterTts.setVolume(1); // Establece el volumen
  }

  initRive(String riv) {
    rootBundle.load('assets/Caras/$riv.riv').then(
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
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors
                            .black54, // Color del segundo borde (doble borde)
                        width: 8, // Ancho del segundo borde
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SizedBox(
                        width: 500,
                        height: 500,
                        child: Center(
                          child: riveArtboard != null
                              ? Rive(artboard: riveArtboard!, fit: BoxFit.cover)
                              : CircularProgressIndicator(),
                        )),
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
                    if (interactiveMode) {
                      return DialogRtaCard(txt: mensajes[index]);
                    } else {
                      return DialogCard(txt: mensajes[index]);
                    }
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
                                    interactiveMode = value;
                                  });
                                }),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.attach_file),
                              onPressed: () async {
                                // Verificar si el permiso ya fue concedido
                                var status = await Permission.storage.status;
                                if (status.isGranted) {
                                  // El permiso ya fue concedido, puedes abrir el explorador de archivos
                                  _openFileExplorer();
                                } else {
                                  // El permiso no fue concedido, solicitar permiso
                                  var result = await Permission.storage.request();
                                  if (result.isGranted) {
                                    // El permiso fue concedido después de la solicitud, puedes abrir el explorador de archivos
                                    _openFileExplorer();
                                  } else {
                                    // El usuario no concedió el permiso, puedes mostrar un mensaje o realizar alguna acción adicional
                                    print('El usuario no concedió el permiso de almacenamiento.');
                                  }
                                }
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
                          onPressed: () {
                            if (controller.text.isNotEmpty) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              scrollController.animateTo(
                                  scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut);

                              setMensaje(controller.text);
                              controller.clear();
                              //flutterTts.speak("esto es un ejemplo de audio");
                              printLanguages();
                              hablaSSML(texto);
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

  void _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      final path = result.files.single.path;
      final file = File(path!);

      fileContent = await file.readAsString();
      cargaTXT();
    } else {
      // Se la selección de archivos.
    }
  }

  void cargaTXT() {
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
                            FocusScope.of(context).requestFocus(FocusNode());
                            scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut);
                            setMensaje(controller.text);
                            controller.clear();
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

  void setMensaje(String txt) {
    setState(() {
      mensajes.add(txt);
    });
  }

  //################# FUNCIONES QUE ACTUALIZAN ESTADO###################
  pressHablar(String texto) {
    //se acomoda el texto para poder convertirlo a visemas
    //texto=remplazarNumerosEnPalabras(texto);
    texto = limpiaTexto(texto);
    textoDividido = splitPorPunto(texto);
    for (int j = 0; j < textoDividido.length; j++) {
      print(textoDividido[j]);
    }
    recorrerArregloDeStrings(textoDividido);
  }

  recorrerArregloDeStrings(List<String> textoCompleto) async {
    for (int i = 0; i < textoCompleto.length; i++) {
      recorrerTexto(textoCompleto[i]);
      await habla(textoCompleto[i]);
    }
  }

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

  //hace que mueva la boca basicamente
  void recorrerTexto(String texto) async {
    RegExp regExp = RegExp(r'[;:?!]');
    //se recorre el texto para pasar de caracter a visema

    for (int i = 0; i < texto.length; i++) {
      //este if controla que si es el primer caracter no espere
      if (i == 0) {
        esperaVisemas = 0;
      } else {
        esperaVisemas = 70; //este tiempo deberia ser una variable
      }
      if (texto[i] == ',') {
        //flutterTts.pause();
        await Future.delayed(const Duration(milliseconds: 750));
        //await flutterTts.speak(texto.substring(i));
      }
      if (regExp.hasMatch(texto[i])) {
        //flutterTts.pause();
        await Future.delayed(const Duration(milliseconds: 850));
        //await flutterTts.speak(texto.substring(i));
      }
      await Future.delayed(Duration(milliseconds: esperaVisemas), () {
        if (cara != 2) {
          visemaNum?.value = charToVisemaGenerico(texto[i]).toDouble();
        } else{
          visemaNum?.value = charToVisemaGenerico(texto[i]).toDouble();
        }
      });
    }
  }

  //
  void recorrerTextoSSML(String texto) async {
    //se recorre el texto para pasar de caracter a visema
    for (int i = 0; i < texto.length; i++) {
      //este if controla que si es el primer caracter no espere
      if (i == 0) {
        esperaVisemas = 0;
      } else {
        esperaVisemas = 65; //este tiempo deberia ser una variable
      }
      switch (texto[i]) {
        case '.':
          await Future.delayed(const Duration(milliseconds: 500));
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
        visemaNum?.value = charToVisema(texto[i]).toDouble();
      });
      //recorro la cadena entre signos de puntuacion
      if (texto[i] == '.' ||
          texto[i] == ',' ||
          texto[i] == ';' ||
          texto[i] == '?' ||
          texto[i] == '!' ||
          texto[i] == ':' ||
          i == 0) {
        // Detectar el próximo texto hasta el siguiente signo de puntuación
        String proximoTexto = '';
        for (int j = i + 1; j < texto.length; j++) {
          if (texto[j] == '.' ||
              texto[j] == ',' ||
              texto[j] == ';' ||
              texto[j] == '?' ||
              texto[j] == '!' ||
              texto[j] == ':') {
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
  }

  Future<void> hablaSSML(String txt) async {
    txt = remplazarNumerosEnPalabras(txt);
    String txtSSML = convertToSSML(txt); //se prepara el texto para el tts
    String txtLimpio =
        limpiaTexto(txt); //se prepara el texto para el ttv (text to visem)
    recorrerTextoSSML(txtLimpio);
    habla(txtSSML);
  }

  void printLanguages() async {
    List<dynamic> languages = await flutterTts.getEngines;
    print("engines soportados:");
    print(languages.toString());
  }
}
