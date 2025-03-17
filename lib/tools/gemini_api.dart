import 'dart:convert';

import 'package:http/http.dart' as http;
String API_KEY="AIzaSyB_QHYZlwisywsFDa2oyFMRHaFu-eE5XuU";
class GeminiAPI {
  static Future<Map<String, String>> getHeader() async {
    return {
      'Content-Type': 'application/json',
    };
  }

  static Future<String> getGeminiData(mensaje) async {
    try {
      final header = await getHeader();
      final Map<String, dynamic> requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': "Responde de forma breve pero asegurando que la idea quede completamente cerrada sin quedar a medias y sin emogis: $mensaje",
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.2, // Mantiene respuestas concretas y directas
          'maxOutputTokens': 300, // Da más espacio para completar la idea
          'topK': 30,
          'topP': 0.5
        }
      };
      //String url ='https://generativelanguage.googleapis.com/v1beta/models/gemini-1.0-pro:generateContent?key=$API_KEY';
      String url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$API_KEY';

      var response = await http.post(
        Uri.parse(url),
        headers: header,
        body: jsonEncode(requestBody),
      );
      print(response.body);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return jsonResponse['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return "";
      }
    } catch (e) {
      print("Error: $e");
      return "";
    }
  }
}
