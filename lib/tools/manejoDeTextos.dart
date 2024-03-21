import 'funciones.dart';

String convertToSSML(String text) {
  // Expresión regular para los signos de puntuación que agregarán pausas
  final punctuationRegex = RegExp(r'[.,;?!:\-\n]');

  // Pausas para cada tipo de signo de puntuación
  final pauseDurations = {
    '.': '500ms',
    ',': '300ms',
    ';': '400ms',
    '?': '800ms',
    '!': '800ms',
    ':': '400ms',
    '-': '200ms',
    '\n': '500ms'
  };

  // Reemplazar signos de puntuación y saltos de línea con SSML que incluye pausas
  String ssmlText = text.replaceAllMapped(punctuationRegex, (match) {
    final punctuation = match.group(0);
    final pauseDuration = pauseDurations[punctuation] ?? '500ms';
    return '$punctuation<break time="$pauseDuration"/>';
  });

  // Envolver el texto en la etiqueta <speak> si no está vacío
  if (ssmlText.isNotEmpty) {
    ssmlText = '<speak>$ssmlText</speak>';
  }
  print(ssmlText);
  return ssmlText;
}

enum Emocion {
  Pregunta, // se agrega la cara de para las preguntas
  Felicidad,
  Enojo,
  Neutral,
  Tristeza,
  Asco,
  MiedoInseguridad,
}

Map<Emocion, List<String>> palabrasClave = {
  Emocion.Pregunta:['?'],
  Emocion.Felicidad: ['feliz','felicidad', 'hola', 'bueno', 'buena', 'buenas', 'buenosdías',
    'amor', 'amar', 'amado', 'amante', 'amantes', 'amable', 'amabilidad', 'amada',
    'alegría', 'alegre', 'alegrías', 'alegremente', 'alegreza', 'alegro',
    'gratitud', 'agradeser', 'agradesido', 'agradesimiento', 'agradesida',
    'risas', 'reír', 'reírse', 'risueño', 'risible', 'reída', 'reído',
    'paz', 'pasífico', 'pasíficamente', 'pasificador', 'pasifismo', 'pasífica',
    'familia', 'familiar', 'familiares', 'familiaridad', 'familiarizasión', 'familiarizado',
    'amistad', 'amigo', 'amiga', 'amistoso', 'amistad', 'amistades', 'amistosa',
    'abrazos', 'abrazar', 'abrazo', 'abrazada', 'abrazado',
    'serenidad', 'sereno', 'serenamente', 'serenar', 'serenidad', 'serena',
    'esperanza', 'esperanzado', 'esperanzadora', 'esperanzadora', 'esperanzar', 'esperanzada',
    'contento', 'contentamiento', 'contentarse', 'contenta', 'contento',
    'optimismo', 'optimista', 'optimistamente', 'optimistico', 'optimista',
    'plenitud', 'pleno', 'plenamente', 'plenitud', 'plena',
    'comprensión', 'comprender', 'comprensivo', 'comprensiblemente', 'comprensión', 'comprensiva',
    'compasión', 'compasivo', 'compasión', 'compasiva',
    'entusiasmo', 'entusiasta', 'entusiasmar', 'entusiasmado', 'entusiasta',
    'éxito', 'exitoso', 'exitosamente', 'exitosa', 'exitosa',
    'selebración', 'celebrar', 'celebratorio', 'celebrar', 'celebrada', 'celebrado',
    'inspiración', 'inspirar', 'inspirado', 'inspirador', 'inspirar', 'inspirada',
    'agradecimiento', 'agradecido', 'agradecer', 'agradecidamente', 'agradecimiento', 'agradecida',
    'generosidad', 'generoso', 'generosamente', 'generosidad', 'generosa',
    'bienestar', 'bien', 'bienvenido', 'bienestar', 'bienvenida',
    'armonía', 'armónico', 'armoniosamente', 'armonía', 'armónica',
    'confianza', 'confiar', 'confiado', 'confiadamente', 'confianza', 'confiada',
    'perdón', 'perdonar', 'perdonado', 'perdonador', 'perdón', 'perdonada',
    'diversión', 'divertido', 'divertirse', 'divertidamente', 'diversión', 'divertida',
    'éxtasis', 'extático', 'extasiado', 'extasiante', 'extasis', 'extasiada',
    'apreciación', 'apreciar', 'apreciativo', 'apreciable', 'apreciación', 'apreciada',
    'unión', 'unir', 'unido', 'unidad', 'unión', 'unida',
    'carcajadas', 'carcajearse', 'carcajada', 'carcajadas', 'carcajeada',
    'paz interior', 'paz mental', 'paz interior', 'paz mental',
    'triunfo', 'triunfar', 'triunfante', 'triunfo', 'triunfadora',
    'caridad', 'caritativo', 'caritativamente', 'caridad', 'caritativa',
    'amabilidad', 'amable', 'amablemente', 'amabilidad', 'amable',
    'solidaridad', 'solidario', 'solidariamente', 'solidaridad', 'solidaria',
    'sorpresa', 'sorprender', 'sorprendido', 'sorprendente', 'sorpresa', 'sorprendida',
    'alivio', 'aliviar', 'aliviado', 'aliviante', 'alivio', 'aliviada',
    'admiración', 'admirar', 'admirado', 'admirable', 'admiración', 'admirada',
    'autoaceptación', 'aceptarse', 'autoaceptación', 'autoaceptada', 'autoaceptado',
    'serendipia', 'serendípico', 'serendipidad', 'serendipia',
    'descanso', 'descansar', 'descansado', 'descansadamente', 'descanso', 'descansada',
    'perseverancia', 'perseverar', 'perseverante', 'perseverantemente', 'perseverancia', 'perseverante',
    'ternura', 'tierno', 'tiernamente', 'ternura', 'tierna',
    'ilusión', 'ilusionar', 'ilusionado', 'ilusionante', 'ilusión', 'ilusionada',
    'reconocimiento', 'reconocer', 'reconocido', 'reconocible', 'reconocimiento', 'reconocida',
    'espontaneidad', 'espontáneo', 'espontáneamente', 'espontaneidad', 'espontánea',
    'crecimiento', 'crecer', 'crecimiento', 'crecida', 'crecido',
    'umor', 'umorístico', 'umorísticamente', 'umor', 'umorístico',
    'recuerdos', 'recordar', 'recordado', 'recordable', 'recuerdos', 'recordada',
    'resiliencia', 'resiliente', 'resilientemente', 'resiliencia', 'resiliente',
    'gratificación', 'gratificar', 'gratificado', 'gratificante', 'gratificación', 'gratificada',
    'libertad', 'libre', 'libremente', 'libertad', 'libre',
    'descubrimiento', 'descubrir', 'descubierto', 'descubrimiento', 'descubierta',
    'superación', 'superar', 'superado', 'superador', 'superación', 'superada',
    'sueños', 'soñar', 'soñador', 'soñadora', 'sueños', 'soñadora',
    'umildad', 'umilde', 'umildemente', 'umildad', 'umilde',
    'aventura', 'aventurero', 'aventurarse', 'aventura', 'aventurera',
    'relajación', 'relajarse', 'relajado', 'relajante', 'relajación', 'relajada',
    'apoyo', 'apoyar', 'apoyado', 'apoyador', 'apoyo', 'apoyada',
    'fiel', 'fielmente', 'fiel',
    'calma', 'calmado', 'calmante', 'calmar', 'calma', 'calmada',
    'trascendencia', 'trascender', 'trascendental', 'trascendentemente', 'trascendencia', 'trascendental',
    'compañerismo', 'compañero', 'compañera', 'compañerismo', 'compañero',
    'pasión', 'apasionado', 'apasionadamente', 'pasión', 'apasionada',
    'euforia', 'eufórico', 'eufóricamente', 'euforia', 'eufórica',
    'compartir', 'compartir', 'compartido', 'compartible', 'compartir', 'compartida',
    'renacimiento', 'renacer', 'renacido', 'renacimientismo', 'renacimiento', 'renacida',
    'bienestar', 'bienestar', 'bien', 'bienvenido', 'bienestar', 'bienvenida',
    'sonría', 'sonríe', 'sonreír', 'sonreía', 'sonrisas', 'sonreído', 'sonreír', 'sonría',
     'amado', 'amante', 'amantes', 'amoroso', 'amada',
    'reír', 'reírse', 'risueño', 'risible', 'risas', 'reído', 'reída', 'reír',
    'pacífico', 'pacificar', 'pacificador', 'pacifismo', 'paz', 'pacífica',
    'agradecer', 'agradecido', 'agradecimiento', 'gratitud', 'agradecida', 'agradecer',
    'comprensivo', 'comprender', 'comprensión', 'comprensiblemente', 'compasión', 'comprensiva',
    'compasivo', 'compasión', 'compasión', 'compasivamente', 'comprensivo', 'compasivo',
    'entusiasta', 'entusiasmo', 'entusiasmar', 'entusiasmo', 'entusiasta',
    'éxito', 'exitoso', 'exitosamente', 'exitosa', 'éxito', 'exitoso',
    'celebrar', 'celebración', 'celebratorio', 'celebración', 'celebrada', 'celebrado',
    'inspirar', 'inspiración', 'inspirador', 'inspirar', 'inspirada', 'inspiración',
    'apreciar', 'apreciación', 'apreciativo', 'apreciable', 'apreciación', 'apreciada',
    'unir', 'unión', 'unidad', 'unión', 'unida', 'unido',
    'sorprender', 'sorpresa', 'sorprendente', 'sorpresa', 'sorprendida',
    'aliviar', 'alivio', 'aliviar', 'aliviante', 'alivio', 'aliviada',
    'admirar', 'admiración', 'admirado', 'admirable', 'admiración', 'admirada',
    'perseverancia', 'perseverar', 'perseverante', 'perseverantemente', 'perseverancia', 'perseverante',
    'tierno', 'ternura', 'tiernamente', 'ternura', 'tierna',
    'reconocimiento', 'reconocer', 'reconocido', 'reconocible', 'reconocimiento', 'reconocida',
    'soñadora', 'sueño', 'sueños', 'soñar', 'sueño', 'soñado',
    'superación', 'superar', 'superado', 'superador', 'superación', 'superada',
    'relajada', 'relajación', 'relajante', 'relajadamente', 'relajación', 'relajada',
    'apoyada', 'apoyo', 'apoyar', 'apoyador', 'apoyo', 'apoyada',
    'fiel', 'fe', 'fielmente', 'fiel', 'fielmente', 'fiel', 'fielmente',
    'calma', 'calmado', 'calmante', 'calmar', 'calma', 'calmada',
    'trascendental', 'trascendencia', 'trascendental', 'trascendentemente', 'trascendental', 'trascendente',
    'apasionada', 'pasión', 'pasional', 'apasionadamente', 'pasión', 'apasionada',
    'compartido', 'compartir', 'compartir', 'compartible', 'compartir', 'compartida'],
  Emocion.Enojo: ['enojo','furia', 'furioso', 'furiosa', 'furiosamente', 'enfurecer', 'enfurecido', 'enfurecida', 'enfurecimiento',
    'ira', 'iracundo', 'iracunda', 'iracundia', 'iracundamente', 'encolerizar', 'encolerizado', 'encolerizada', 'encolerizarse',
    'rabia', 'rabioso', 'rabiosa', 'rabiosamente', 'rabiar', 'rabietas', 'rabiosidad',
    'enfado', 'enojado', 'enojada', 'enojarse', 'enojarse', 'enfadarse', 'enfadadizo', 'enfadadiza',
    'hostilidad', 'hostil', 'hostilmente', 'hostilizar', 'hostilidad',
    'frustración', 'frustrar', 'frustrado', 'frustrada', 'frustrantemente', 'frustración',
    'resentimiento', 'resentido', 'resentida', 'resentir', 'resentimiento', 'resentir',
    'agresión', 'agresivo', 'agresiva', 'agredir', 'agresivamente',
    'amargura', 'amargado', 'amargada', 'amargar', 'amargura', 'amargamente',
    'rencor', 'rencoroso', 'rencorosa', 'rencor', 'rencorosamente',
    'antipatía', 'antipático', 'antipática', 'antipatía', 'antipáticamente',
    'enemistad', 'enemigo', 'enemiga', 'enemistar', 'enemistad',
    'odio', 'odiar', 'odiado', 'odiada', 'odiador', 'odiosamente', 'odio',
    'violencia', 'violento', 'violenta', 'violentamente', 'violentar', 'violencia',
    'gritar', 'grito', 'gritón', 'gritona', 'gritar', 'gritante', 'gritadero',
    'malhumor', 'malhumorado', 'malhumorada', 'malhumorarse', 'malhumor', 'malhumoradamente',
    'desagrado', 'desagradable', 'desagradablemente', 'desagradar', 'desagrado',
    'descontento', 'descontento', 'descontenta', 'descontentar', 'descontentadamente',
    'irritabilidad', 'irritante', 'irritar', 'irritado', 'irritada', 'irritabilidad', 'irritantemente',
    'explosión', 'explotar', 'explosivo', 'explosiva', 'explosión',
    'arrebato', 'arrebatar', 'arrebatado', 'arrebatada', 'arrebatarse', 'arrebatadoramente',
    'discordia', 'discordante', 'discordar', 'discordia', 'discordiosamente',
    'contrariedad', 'contrariar', 'contrariado', 'contrariada', 'contrariedad',
    'rabieta', 'rabietudo', 'rabietuda', 'rabieta', 'rabiosamente',
    'celos', 'celoso', 'celosa', 'celar', 'celosamente', 'celosía',
    'amargarse', 'amargarse', 'amargoso', 'amargosa',
    'descontrol', 'descontrolado', 'descontrolada', 'descontrolarse', 'descontrol',
    'desahogo', 'desahogarse', 'desahogo', 'desahogadamente',
    'enojarse', 'enojarse', 'enojado', 'enojada',
    'disgustarse', 'disgustado', 'disgustada', 'disgustarse', 'disgustante',
    'exasperación', 'exasperar', 'exasperado', 'exasperada', 'exasperante', 'exasperantemente',
    'indignación', 'indignar', 'indignado', 'indignada', 'indignante', 'indignantemente',
    'tensión', 'tenso', 'tensa', 'tensión', 'tensamente',
    'malestar', 'malestar', 'malestaroso', 'malestarosamente',
    'incomodidad', 'incómodo', 'incómoda', 'incómodamente',
    'provocación', 'provocar', 'provocativo', 'provocativa', 'provocadoramente', 'provocación',
    'insatisfacción', 'insatisfactorio', 'insatisfactoria', 'insatisfacción',
    'desprecio', 'despreciar', 'despreciativo', 'despreciativa', 'despreciativamente', 'despreciado', 'despreciada',
    'aspereza', 'áspero', 'áspera', 'aspereza', 'asperar', 'asperamente',
    'inconformidad', 'inconforme', 'inconformidad', 'inconformarse', 'inconformemente',
    'exabrupto', 'exabrupto', 'exabruptamente',
    'fastidio', 'fastidioso', 'fastidiosa', 'fastidiar', 'fastidio', 'fastidiosamente',
    'dolor', 'doler', 'doloroso', 'dolorida', 'doliente', 'dolerse', 'dolosamente',
    'odio', 'odiar', 'odiado', 'odiada', 'odiador', 'odiosamente', 'odio',
    'gritar', 'grito', 'gritón', 'gritona', 'gritar', 'gritante', 'gritadero',
    'represalia', 'represalia', 'represaliar', 'represaliado', 'represaliada',
    'desprecio', 'despreciar', 'despreciativo', 'despreciativa', 'despreciativamente', 'despreciado', 'despreciada',
    'ofensa', 'ofensivo', 'ofensiva', 'ofender', 'ofensa', 'ofensivamente',
    'picar', 'picaresca', 'picarón', 'picardía',
    'cólera', 'colérico', 'colérica', 'colera', 'colerizarse', 'coléricamente',
    'perturbación', 'perturbar', 'perturbador', 'perturbadora', 'perturbación', 'perturbadamente',
    'descontrol', 'descontrolado',  'descontrolada', 'descontrolarse', 'descontrol',
    'despecho', 'despecho', 'despechado', 'despechada', 'despechados', 'despechadas',
    'destemplanza', 'destemplado', 'destemplada', 'destempladamente',
    'veneno', 'venenoso', 'venenosa', 'venenosamente',
    'tergiversación', 'tergiversar', 'tergiversador', 'tergiversadora', 'tergiversación', 'tergiversadamente',
    'acritud', 'acritud', 'acritud', 'acritud',
    'animosidad', 'animoso', 'animosa', 'animosamente', 'animosidad',
    'cisma', 'cismático', 'cismática', 'cisma', 'cismáticamente',
    'animadversión', 'animadversivo', 'animadversiva', 'animadversión', 'animadversivamente',
    'repudio', 'repudiar', 'repudiado', 'repudiada', 'repudio', 'repudiablemente',
    'contrariedad', 'contrariar', 'contrariado', 'contrariada', 'contrariedad',
    'desaliento', 'desalentar', 'desalentador', 'desalentadora', 'desaliento', 'desalentadamente'],
  Emocion.Tristeza: [
    'desilusión', 'desilusionado', 'desilusionada', 'desilusionados', 'desilusionadas', 'desilusionarse', 'desilusiones',
    'desesperanza', 'desesperanzado', 'desesperanzada', 'desesperanzados', 'desesperanzadas', 'desesperanzarse', 'desesperanzas',
    'desconsuelo', 'desconsolado', 'desconsolada', 'desconsolados', 'desconsoladas', 'desconsuelos',
    'desesperación', 'desesperado', 'desesperada', 'desesperados', 'desesperadas', 'desesperarse', 'desesperaciones',
    'desamparo', 'desamparado', 'desamparada', 'desamparados', 'desamparadas', 'desamparos',
    'desolación', 'desolado', 'desolada', 'desolados', 'desoladas', 'desolaciones',
    'desgarrador', 'desgarradora', 'desgarradores', 'desgarradoras', 'desgarramientos',
    'desánimo', 'desanimado', 'desanimada', 'desanimados', 'desanimadas', 'desánimos',
    'desasosiego', 'desasosegado', 'desasosegada', 'desasosegados', 'desasosegadas', 'desasosiegos',
    'desdicha', 'desdichado', 'desdichada', 'desdichados', 'desdichadas', 'desdichas',
    'derrota', 'derrotado', 'derrotada', 'derrotados', 'derrotadas', 'derrotas',
    'desengaño', 'desengañado', 'desengañada', 'desengañados', 'desengañadas', 'desengaños',
    'desaliento', 'desalentado', 'desalentada', 'desalentados', 'desalentadas', 'desalientos',
    'descontento', 'descontento', 'descontenta', 'descontentos', 'descontentas', 'descontentamientos',
    'aflicción', 'afligido', 'afligida', 'afligidos', 'afligidas', 'aflicciones',
    'desconcierto', 'desconcertado', 'desconcertada', 'desconcertados', 'desconcertadas', 'desconciertos',
    'agonía', 'agónico', 'agónica', 'agónicos', 'agónicas', 'agonías',
    'melancolía', 'melancólico', 'melancólica', 'melancólicos', 'melancólicas', 'melancolías',
    'soledad', 'solitario', 'solitaria', 'solitarios', 'solitarias', 'soledades',
    'angustia', 'angustiado', 'angustiada', 'angustiados', 'angustiadas', 'angustias',
    'dolor', 'doler', 'doliente', 'doloroso', 'dolorosa', 'dolores',
    'nostalgia', 'nostálgico', 'nostálgica', 'nostálgicos', 'nostálgicas', 'nostalgias',
    'abatimiento', 'abatido', 'abatida', 'abatidos', 'abatidas', 'abatimientos',
    'pesadumbre', 'pesar', 'pesaroso', 'pesarosa', 'pesares',
    'infortunio', 'infortunado', 'infortunada', 'infortunados', 'infortunadas', 'infortunios',
    'pena', 'penoso', 'penosa', 'penosos', 'penosas', 'penalidades',
    'tristeza', 'triste', 'tristes', 'tristemente',
    'lágrimas', 'llanto', 'llorar', 'llorando', 'lloraba', 'lloraron', 'llorará', 'lloraré', 'llorarás', 'lloramos', 'lloráis', 'lloraban', 'llorarán', 'lloraría', 'llorarías', 'lloraríamos', 'lloraríais', 'llorarían',

    'abatimiento', 'abatido', 'abatida', 'abatidos', 'abatidas', 'abatimientos',
    'congoja', 'congojoso', 'congojosa', 'congojosos', 'congojosas', 'congojas',
    'vergüenza', 'vergonzoso', 'vergonzosa', 'vergonzosos', 'vergonzosas', 'vergüenzas',
    'umillación', 'umillado', 'umillada', 'umillados', 'umilladas', 'umillaciones',
    'amargura', 'amargo', 'amarga', 'amargos', 'amargas', 'amarguras',
  ],
  Emocion.Neutral:[],
  Emocion.Asco: [
    'repugnante', 'repugnancia', 'repugnantes',
    'náuseas', 'náusea', 'nauseabundo', 'nauseabunda',
    'desagradable', 'desagrado', 'desagradables', 'desagradablemente', 'desagradabilidad',
    'vómito', 'vomitar', 'vómitos', 'vomitoso', 'vomitorios',
    'suciedad', 'sucio', 'suciedades', 'sucias',
    'maloliente', 'malolientes', 'malolencia', 'malolencias',
    'inmundo', 'inmundicia', 'inmunda', 'inmundos', 'inmundas',
    'askeroso', 'asco', 'askerosos', 'askerosas',
    'insoportable',
    'pestilente', 'peste', 'pestilentes', 'pestilencia', 'pestilencial',
    'putrefacto', 'putrefacción', 'putrefactos', 'putrefacta', 'putrefactas',
    'infeccioso', 'infección', 'infecciosos', 'infecciosa', 'infecciosas',
    'contaminado', 'contaminar', 'contaminación', 'contaminados', 'contaminada', 'contaminadas',
    'fétido', 'fetidez', 'fétidos', 'fétida', 'fétidas',
    'mugriento', 'mugre', 'mugrientos', 'mugrienta', 'mugrientas',
    'descompuesto', 'descomposición', 'descompuestos', 'descompuesta', 'descompuestas',
    'viscoso', 'viscosidad', 'viscosos', 'viscosa', 'viscosas',
    'inmoral', 'moral', 'inmorales', 'inmoralidad', 'inmoralmente',
    'ediondo', 'edor', 'ediondos', 'edionda', 'ediondas',
    'despreciable', 'desprecio', 'despreciables', 'despreciado', 'despreciada',
    'desagüe', 'desagües', 'desaguado', 'desaguada',
    'insalubre', 'insalubres', 'insalubridad', 'insalubremente',
    'desperdicio', 'desperdiciar', 'desperdicios', 'desperdiciado', 'desperdiciada',
    'inaceptable', 'inaceptables', 'inaceptabilidad', 'inaceptablemente',
    'pútrido', 'putrefacción', 'pútridos', 'pútrida', 'pútridas',
    'desordenado', 'desordenados', 'desordenada', 'desordenadas',
    'desecho', 'deshecho', 'desechos', 'deshecha',
    'cloaca', 'cloacas',
    'podrido', 'podredumbre', 'podridos', 'podrida', 'podridas',
    'rancio', 'rancios', 'rancia', 'rancias', 'ranciedad',
    'enfermizo', 'enfermedad', 'enfermizos', 'enfermiza', 'enfermizas',
    'descomposición', 'descompuestos', 'descompuesta', 'descompuestas',
    'abominable', 'abominar', 'abominables', 'abominación', 'abominado',
    'detestable', 'detestar', 'detestables', 'detestación', 'detestado',
    'indignante', 'indignar', 'indignantes', 'indignación', 'indignado',
    'desvergonzado', 'vergüenza', 'desvergüenza', 'desvergonzados', 'desvergonzada', 'desvergonzadas',
    'indeseable', 'deseo', 'indeseables', 'indeseabilidad', 'indeseablemente',
    'ofensivo', 'ofender', 'ofensa', 'ofensivos', 'ofensiva', 'ofensivas',
    'indigno', 'indignos', 'indigna', 'indignas',
    'deteriorado', 'deteriorar', 'deteriorados', 'deteriorada', 'deterioradas',
    'grotesco', 'grotescos', 'grotesca', 'grotescas'
  ],
  Emocion.MiedoInseguridad: [
    'miedo','miedoso','miedosa','miedosos','miedosas',
    'terror', 'terrorífico', 'terrorífica','terror',
    'pánico', 'pánicos', 'pánica', 'pánicas', 'pánicosamente', 'pánicogénico', 'pánicogenia',
    'angustia', 'angustioso', 'angustiosa', 'angustias', 'angustiado', 'angustiada', 'angustiadamente',
    'ansiedad', 'ansioso', 'ansiosa', 'ansiedades', 'ansiosamente', 'ansiosidad',
    'fobia', 'fóbico', 'fóbica', 'fóbicos', 'fóbicas', 'fobias', 'fóbicamente',
    'horror', 'horroroso', 'horrorosa', 'horrores', 'horrorizar', 'horrorizados', 'horrorizadas', 'horrorización',
    'temor', 'temeroso', 'temerosa', 'temores', 'temoroso', 'temorosa',
    'aprehensión', 'aprehensivo', 'aprehensiva', 'aprehensiones', 'aprehender', 'aprehensivamente',
    'sobresalto', 'sobresaltar', 'sobresaltado', 'sobresaltada', 'sobresaltos', 'sobresaltadamente',
    'desesperación', 'desesperado', 'desesperada', 'desesperanzador', 'desesperanzadora', 'desesperadamente',
    'claustrofobia', 'claustrofóbico', 'claustrofóbica', 'claustrofobias', 'claustrofóbicamente',
    'agonía', 'agonizante', 'agonizar', 'agonizado', 'agonizada', 'agonizadamente',
    'incertidumbre', 'incierto', 'incierta', 'incertidumbres', 'inciertamente',
    'paranoia', 'paranoico', 'paranoica', 'paranoias', 'paranoicamente', 'paranoide',
    'espanto', 'espantoso', 'espantosa', 'espantados', 'espantadas', 'espantar', 'espantadizo', 'espantadiza',
    'agitación', 'agitado', 'agitada', 'agitaciones', 'agitar', 'agitante', 'agitadamente',
    'horrorizante', 'horrorizadamente',
    'amenaza', 'amenazante', 'amenazar', 'amenazador', 'amenazadora', 'amenazados', 'amenazadas',
    'angustiado', 'angustiada', 'angustiados', 'angustiadas', 'angustiadamente',
    'nerviosismo', 'nervioso', 'nerviosa', 'nerviosos', 'nerviosas', 'nerviosamente', 'nerviosidad',
    'desasosiego', 'desasosegado', 'desasosegada', 'desasosiegos',
    'inseguridad', 'inseguro', 'insegura', 'inseguridades', 'inseguramente',
    'impotencia', 'impotente', 'impotencia', 'impotentes',
    'obsesión', 'obsesionado', 'obsesionada', 'obsesiones', 'obsesionante', 'obsesionadamente',
    'desconsuelo', 'desconsolado', 'desconsolada', 'desconsuelos',
    'desamparo', 'desamparado', 'desamparada', 'desamparos', 'desamparadamente',
    'vulnerabilidad', 'vulnerable', 'vulnerabilidades', 'vulnerablemente',
    'pavor', 'pavores', 'pavoroso', 'pavorosa', 'pavorosamente',
    'estremecimiento', 'estremecedor', 'estremecedora', 'estremecimientos',
    'aislamiento', 'aislado', 'aislada', 'aislamientos', 'aisladamente',
    'frustración', 'frustrado', 'frustrada', 'frustraciones', 'frustrantemente',
    'obscuridad', 'oscuro', 'oscura', 'obscuros', 'obscuras', 'obscuridades', 'oscurecer', 'oscuridad',
    'desesperanza', 'desesperanzado', 'desesperanzada', 'desesperanzador', 'desesperanzadora', 'desesperanzadamente',
    'impedimento', 'impedido', 'impedida', 'impedimentos', 'impedir', 'impedimentar',
    'atemorizado', 'atemorizada', 'atemorizados', 'atemorizadas', 'atemorizante', 'atemorizadamente',
    'temblor', 'tembloroso', 'temblorosa', 'temblores', 'temblorosamente',
    'descontrol', 'descontrolado', 'descontrolada', 'descontrolados', 'descontroladas', 'descontrolar', 'descontroladamente',
    'incapacidad', 'incapaz', 'incapacidad', 'incapacidades', 'incapazmente',
    'delirio', 'delirante', 'delirio', 'delirios', 'delirar', 'deliradamente',
    'duda', 'dudoso', 'dudosa', 'dudar', 'dudablemente',
    'recelo', 'receloso', 'recelosa', 'recelos', 'recelosamente',
    'desorientación', 'desorientado', 'desorientada', 'desorientaciones', 'desorientadamente',
    'amenazante', 'amenazador', 'amenazadora', 'amenazados', 'amenazadas',
    'nervios', 'nerviosamente',
    'sudoración', 'sudoroso', 'sudorosa', 'sudoración', 'sudoraciones', 'sudorosamente',
    'inkietud', 'inkietante', 'inkietantes', 'inkietantemente',
    'palpitación', 'palpitante', 'palpitaciones', 'palpitantemente',
    'mareo', 'mareado', 'mareada', 'mareos', 'mareadas', 'mareantemente','insomnio', 'insomnios', 'insomnolencia',
    'pesadillas', 'pesadillesco', 'pesadillesca', 'pesadillas', 'pesadilleo',
    'debilidad', 'débil', 'debilidad', 'debilidades', 'débilmente',
    'desconfianza', 'desconfiado', 'desconfiada', 'desconfiados', 'desconfiadas', 'desconfiadamente',
    'angustiante', 'angustiantes', 'angustiantemente',
    'aturdimiento', 'aturdido', 'aturdida', 'aturdidos', 'aturdidas', 'aturdidor', 'aturdidora', 'aturdidamente',
    'parálisis', 'paralítico', 'paralítica', 'paralizados', 'paralizadas', 'paralizar', 'paralizante', 'paralizantemente',
    'agonía', 'agonizante', 'agonizar', 'agonizado', 'agonizada', 'agonizadamente',
    'fóbico', 'fóbica', 'fóbicos', 'fóbicas', 'fobias', 'fóbicamente',
    'palidez', 'pálido', 'pálida', 'palideces', 'palidecer', 'palidecimiento',
    'inhibición', 'inhibido', 'inhibida', 'inhibiciones', 'inhibidor', 'inhibidora', 'inhibidamente',
    'obsesivo', 'obsesiva', 'obsesivos', 'obsesivas', 'obsesionante', 'obsesionantemente',
    'uida', 'uir', 'uido', 'uida', 'uidor', 'uidora', 'uidos', 'uidas', 'uidista', 'uidizo',
    'estremecimiento', 'estremecedor', 'estremecedora', 'estremecimientos', 'estremecer', 'estremecible', 'estremeciblemente',
    'estigmatización', 'estigmatizado', 'estigmatizada', 'estigmatizaciones', 'estigmatizar', 'estigmatizante', 'estigmatizador', 'estigmatizadora', 'estigmatizadamente',
    'perder', 'perdido', 'perdida', 'perdidos', 'perdidas', 'perdible', 'perdiblemente',
    'conmoción', 'conmocionado', 'conmocionada', 'conmociones', 'conmocionante', 'conmocionador', 'conmocionadora', 'conmocionadamente',
    'vacío', 'vaciar', 'vacíamente', 'vaciedad',
    'aterrador', 'aterradora', 'aterradores', 'aterradoras', 'aterradoramente',
    'estremecedor', 'estremecedora', 'estremecedores', 'estremecedoras', 'estremecedoramente'
  ],
};
Emocion? encontrarEmocion(String palabra, Map<Emocion, List<String>> palabrasClave) {
  //limiar la palabra de la emocion con limpiatexto
  aplicarLimpieza();
  for (var emocion in palabrasClave.keys) {
    if (palabrasClave[emocion]!.contains(palabra)) {
      return emocion;
    }
  }
  return null;
}
Emocion analizarSentimiento(String texto) {
  Map<Emocion, int> emocionesContador = {
    Emocion.Felicidad: 0,
    Emocion.Enojo: 0,
    Emocion.Neutral: 0,
    Emocion.Tristeza: 0,
    Emocion.Asco: 0,
    Emocion.MiedoInseguridad: 0,
    Emocion.Pregunta: 0
  };

  // Convertir el texto a minúsculas para hacer coincidencias sin distinción de mayúsculas y minúsculas
  texto = texto.toLowerCase();

  palabrasClave.forEach((emocion, palabras) {
    palabras.forEach((palabra) {
      if (texto.contains(palabra)) {
        emocionesContador[emocion] = emocionesContador[emocion]! + 1;
        print("palabra clave $palabra");
        print("emocion"+emocion.toString());
        print("emocionesContador[emocion]) "+ emocionesContador[emocion].toString());
      }
    });
  });

  // Encontrar la emoción predominante
  Emocion emocionPredominante = Emocion.Neutral;
  int maxContador = 0;

  emocionesContador.forEach((emocion, contador) {
    if (contador > maxContador) {
      emocionPredominante = emocion;
      maxContador = contador;
    }
  });
  print("emocion final $emocionPredominante");
  return emocionPredominante;
}
// Emocion analizarSentimiento(String texto) {
//   Map<Emocion, int> emocionesContador = {
//     Emocion.Felicidad: 0,
//     Emocion.Enojo: 0,
//     Emocion.Neutral: 0,
//     Emocion.Tristeza: 0,
//     Emocion.Asco: 0,
//     Emocion.MiedoInseguridad: 0,
//     Emocion.Pregunta: 0
//   };
//
//   // Convertir el texto a minúsculas para hacer coincidencias sin distinción de mayúsculas y minúsculas
//   texto = texto.toLowerCase();
//   List<String> palabrasTexto = texto.split(' ');
//
//   for (String palabra in palabrasTexto) {
//     print(palabra);
//     Emocion? emocionencontrada=encontrarEmocion(palabra,palabrasClave);
//
//     if(emocionencontrada!=null){
//       palabra=palabra.toLowerCase();
//       emocionesContador[emocionencontrada] = (emocionesContador[emocionencontrada]! + 1)!;
//       print("PALABRAS CLAVE "+palabra);
//       print(emocionencontrada.toString());
//     }
//   }
//   // palabrasClave.forEach((emocion, palabras) {
//   //   for (var palabra in palabras) {
//   //     print(palabra);
//   //     palabra=palabra.toLowerCase();
//   //
//   //     if(texto.contains(palabra)){
//   //       emocionesContador[emocion] = emocionesContador[emocion]! + 1;
//   //       print("aparece en el texto");
//   //       print("emocion: "+emocion.toString());
//   //     }
//   //     // if (texto.contains(palabra)) {
//   //     //   emocionesContador[emocion] = emocionesContador[emocion]! + 1;
//   //     //   print("palabra clave $palabra");
//   //     //   print("emocion"+emocion.toString());
//   //     //   print("emocionesContador[emocion]) "+ emocionesContador[emocion].toString());
//   //     // }
//   //   }
//   // });
//   emocionesContador.forEach((emocion, contador) {
//     print('$emocion: $contador');
//   });
//
//   // Encontrar la emoción predominante
//   Emocion emocionPredominante = Emocion.Neutral;
//   int maxContador = 0;
//
//   emocionesContador.forEach((emocion, contador) {
//     if (contador > maxContador) {
//       emocionPredominante = emocion;
//       maxContador = contador;
//     }
//   });
//   print("emocion final $emocionPredominante");
//   return emocionPredominante;
// }
double asignarValorEmocion(Emocion emocion) {
  if (emocion == Emocion.Felicidad) {
    return 1.0;
  } else if (emocion == Emocion.Tristeza) {
    return 2.0;
  } else if (emocion == Emocion.MiedoInseguridad) {
    return 3.0;
  } else if (emocion == Emocion.Enojo) {
    return 4.0;
  } else if (emocion == Emocion.Asco) {
    return 5.0;
  } if (emocion == Emocion.Pregunta) {
    return 6.0;
  }else  {
    // Emoción Neutral o cualquier otro caso
    return 0.0;
  }

}
String agregarPuntoDespuesDeConjuncion(String texto) {
  List<String> conjunciones = ['pero', 'aunque', 'sino', 'porque', 'pues'];
  List<String> palabras = texto.split(' ');
  List<String> nuevoTexto = [];

  for (int i = 0; i < palabras.length; i++) {
    nuevoTexto.add(palabras[i]);

    // Verificar si la palabra actual es una conjunción
    if (conjunciones.contains(palabras[i].toLowerCase()) && i + 1 < palabras.length) {
      // Agregar un punto después de la conjunción
      nuevoTexto.add('.');
    }
  }

  return nuevoTexto.join(' ');
}
void aplicarLimpieza() {
  palabrasClave.forEach((emocion, palabras) {
    List<String> palabrasLimpias = palabras.map((palabra) => limpiaTexto(palabra)).toList();
    palabrasClave[emocion] = palabrasLimpias;
  });
}