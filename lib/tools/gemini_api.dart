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
                'text': 'mensaje: $mensaje',
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.3,
          'maxOutputTokens': 500
        }
      };
      String url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.0-pro:generateContent?key=${API_KEY}';
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
