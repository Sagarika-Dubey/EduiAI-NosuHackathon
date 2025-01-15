import 'dart:convert';

class EnhancedAIService {
  // Using a free API endpoint
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  // For demo/testing, you can use a limited free API
  static Future<String> _getAIResponse(String prompt) async {
    // Simplified response for demo
    switch (prompt.toLowerCase()) {
      case String p when p.contains('math'):
        return 'Here\'s how to solve it: [Step-by-step explanation]';
      case String p when p.contains('history'):
        return 'Let me explain this historical event...';
      case String p when p.contains('science'):
        return 'The scientific explanation is...';
      default:
        return 'I can help you learn about this topic...';
    }
  }

  // Personalized Learning Assistant
  static Future<String> getPersonalizedLearningPlan(
    String subject,
    List<String> strengths,
    List<String> weaknesses,
  ) async {
    final prompt = '''
      Act as an educational expert. Create a personalized learning plan for a student with:
      Subject: $subject
      Strengths: ${strengths.join(', ')}
      Weaknesses: ${weaknesses.join(', ')}
      Provide specific recommendations and study strategies.
    ''';
    return _getAIResponse(prompt);
  }

  // Smart Flashcard Generator
  static Future<List<Map<String, String>>> generateFlashcards(
    String topic,
    int count,
  ) async {
    final prompt = '''
      Create $count flashcards for studying $topic.
      Format: JSON array with 'front' and 'back' for each card.
      Make them concise and educational.
    ''';
    final response = await _getAIResponse(prompt);
    try {
      final List<dynamic> cards = jsonDecode(response);
      return cards
          .map((card) => {
                'front': card['front'] as String,
                'back': card['back'] as String,
              })
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Quiz Question Generator
  static Future<List<Map<String, dynamic>>> generateQuizQuestions(
    String subject,
    String difficulty,
    int count,
  ) async {
    final prompt = '''
      Create $count multiple-choice questions about $subject at $difficulty level.
      Include question, options (4 choices), correct answer, and explanation.
      Format as JSON array.
    ''';
    final response = await _getAIResponse(prompt);
    try {
      final List<dynamic> questions = jsonDecode(response);
      return questions.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  // Study Buddy Chat
  static Future<String> getStudyBuddyResponse(
    String question,
    String subject,
    String context,
  ) async {
    final prompt = '''
      Act as a helpful study buddy. The student is studying $subject.
      Context: $context
      Question: $question
      Provide a helpful, encouraging response with clear explanations.
    ''';
    return _getAIResponse(prompt);
  }

  // Performance Analyzer
  static Future<Map<String, dynamic>> analyzePerformance(
    List<Map<String, dynamic>> quizHistory,
  ) async {
    final prompt = '''
      Analyze this quiz performance data and provide insights:
      ${jsonEncode(quizHistory)}
      Include: strengths, weaknesses, trends, and recommendations.
    ''';
    final response = await _getAIResponse(prompt);
    try {
      return jsonDecode(response);
    } catch (e) {
      return {};
    }
  }

  static Future<String> solveMathProblem(String problem) async {
    final prompt = '''
      Solve this math problem and explain the steps:
      $problem
    ''';
    return _getAIResponse(prompt);
  }

  static Future<String> getVoiceResponse(String query) async {
    final prompt = '''
      Respond to this voice query concisely and conversationally:
      $query
    ''';
    return _getAIResponse(prompt);
  }
}
