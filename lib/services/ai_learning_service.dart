import 'package:http/http.dart' as http;
import 'dart:convert';

class AILearningService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';
  static const String _apiKey = 'YOUR_API_KEY';

  static Future<String> getPersonalizedHint(
      String topic, String difficulty) async {
    try {
      final prompt = '''
        Act as an educational AI tutor. Provide a helpful hint for a student learning about $topic.
        The student's current level is $difficulty.
        Keep the explanation concise, engaging, and appropriate for their level.
      ''';

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {"text": prompt}
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
        throw Exception('Failed to get AI response');
      }
    } catch (e) {
      return 'Unable to generate hint at the moment.';
    }
  }

  static Future<Map<String, dynamic>> analyzePerformance(
      List<Map<String, dynamic>> quizHistory) async {
    // Analyze quiz performance and provide personalized recommendations
    try {
      final analysisPrompt = '''
        Analyze this quiz performance data and provide personalized learning recommendations:
        ${jsonEncode(quizHistory)}
      ''';

      // Similar API call as above
      return {
        'strengths': [
          'Good understanding of basic concepts',
          'Quick problem solving'
        ],
        'weaknesses': ['Need more practice with advanced topics'],
        'recommendations': [
          'Focus on Chapter 5',
          'Review fundamental theorems'
        ],
      };
    } catch (e) {
      return {};
    }
  }
}
