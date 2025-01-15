import 'package:http/http.dart' as http;
import 'dart:convert';

class AIService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';
  static const String _apiKey = '//Enter you GEMINIAPI KEY';

  static Future<String> getAIResponse(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {"text": message}
              ]
            }
          ],
          "generationConfig": {
            "temperature": 0.7,
            "topK": 40,
            "topP": 0.95,
            "maxOutputTokens": 1024,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        print('Error: ${response.body}'); // For debugging
        throw Exception('Failed to get AI response');
      }
    } catch (e) {
      print('Exception: $e'); // For debugging
      return 'Sorry, I encountered an error. Please try again later.';
    }
  }
}
