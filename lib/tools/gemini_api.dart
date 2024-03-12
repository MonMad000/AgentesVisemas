import 'dart:convert';

import 'package:http/http.dart' as http;

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
                'text': 'mensaje: $mensaje, no superes la cantidad de tokens',
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.2, // it may vary from 0 to 1
          'maxOutputTokens': 200 //its the max tokens to generate result
        }
      };
      String url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.0-pro:generateContent?key=';
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
