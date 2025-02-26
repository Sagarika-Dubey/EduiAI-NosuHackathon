class SyllabusBasedAIService {
  static List<Map<String, dynamic>> generateQuestionsFromSyllabus(
      String subject, List<Map<String, dynamic>> units, String difficulty) {
    List<Map<String, dynamic>> questions = [];

    for (var unit in units) {
      // Generate questions for each topic in the unit
      for (var topic in unit['topics']) {
        questions.addAll(_generateTopicQuestions(subject, topic, difficulty));
      }
    }

    return questions;
  }

  static List<Map<String, dynamic>> _generateTopicQuestions(
      String subject, String topic, String difficulty) {
    // Pre-defined questions based on topics
    final questionBank = {
      'Linear Equations': [
        {
          'question': 'Solve for x: 2x + 3 = 11',
          'options': ['x = 4', 'x = 5', 'x = 3', 'x = 6'],
          'correct': 'x = 4',
          'explanation': 'Subtract 3 from both sides, then divide by 2',
          'difficulty': 'easy'
        },
        // Add more questions
      ],
      'Quadratic Equations': [
        {
          'question': 'Find the roots of x² + 5x + 6 = 0',
          'options': ['-2 and -3', '-1 and -4', '2 and 3', '1 and 4'],
          'correct': '-2 and -3',
          'explanation': 'Using factorization: (x+2)(x+3) = 0',
          'difficulty': 'medium'
        },
        // Add more questions
      ],
      // Add more topics
    };

    return questionBank[topic]
            ?.where((q) => q['difficulty'] == difficulty)
            .toList() ??
        [];
  }
}
