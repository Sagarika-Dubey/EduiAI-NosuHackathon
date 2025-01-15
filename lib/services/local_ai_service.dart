class LocalAIService {
  static String getResponse(String prompt) {
    // Simple keyword-based responses
    final promptLower = prompt.toLowerCase();
    if (promptLower.contains('math')) {
      return 'Let me help you with that math problem. First, let\'s break it down step by step...';
    } else if (promptLower.contains('history')) {
      return 'This historical event is significant because...';
    } else if (promptLower.contains('science')) {
      return 'The scientific principle behind this is...';
    }
    return 'I can help you learn about this topic. What specific questions do you have?';
  }

  static List<Map<String, String>> generateFlashcards(String topic) {
    // Pre-defined flashcards for common topics
    final flashcards = {
      'math': [
        {'front': 'What is π?', 'back': 'Pi is approximately 3.14159...'},
        {'front': 'What is the Pythagorean theorem?', 'back': 'a² + b² = c²'},
        {
          'front': 'What is BODMAS?',
          'back':
              'Brackets, Orders, Division, Multiplication, Addition, Subtraction'
        },
        {
          'front': 'What is a prime number?',
          'back': 'A number with exactly two factors: 1 and itself'
        },
      ],
      'science': [
        {
          'front': 'What is photosynthesis?',
          'back': 'Process where plants convert sunlight to energy'
        },
        {
          'front': 'What is Newton\'s First Law?',
          'back': 'An object stays at rest or in motion unless acted upon'
        },
        {
          'front': 'What are the states of matter?',
          'back': 'Solid, Liquid, Gas, and Plasma'
        },
      ],
      'history': [
        {'front': 'When did World War II end?', 'back': '1945'},
        {
          'front': 'Who wrote the Declaration of Independence?',
          'back': 'Thomas Jefferson was the primary author'
        },
      ],
      'language': [
        {
          'front': 'What is a verb?',
          'back': 'An action word or state of being'
        },
        {
          'front': 'What is an adjective?',
          'back': 'A word that describes a noun'
        },
      ],
    };

    return flashcards[topic.toLowerCase()] ?? [];
  }

  static String getStudyTip(String subject) {
    final tips = {
      'math': 'Practice solving problems regularly and show your work',
      'science': 'Connect concepts to real-world examples',
      'history': 'Create timelines to visualize events',
      'language': 'Practice speaking and writing daily',
    };

    return tips[subject.toLowerCase()] ??
        'Break down complex topics into smaller parts';
  }

  // New method: Generate practice questions
  static List<Map<String, dynamic>> generatePracticeQuestions(
      String subject, String difficulty) {
    final questions = {
      'math': {
        'easy': [
          {
            'question': 'What is 5 + 7?',
            'options': ['10', '11', '12', '13'],
            'correct': '12',
            'explanation': '5 plus 7 equals 12'
          },
          {
            'question': 'What is 8 × 4?',
            'options': ['24', '28', '32', '36'],
            'correct': '32',
            'explanation': '8 multiplied by 4 equals 32'
          },
        ],
        'medium': [
          {
            'question': 'Solve: 3x + 5 = 20',
            'options': ['x = 3', 'x = 5', 'x = 7', 'x = 8'],
            'correct': 'x = 5',
            'explanation':
                'Subtract 5 from both sides: 3x = 15, then divide by 3'
          },
        ],
      },
      // Add more subjects and questions
    };

    return questions[subject.toLowerCase()]?[difficulty.toLowerCase()] ?? [];
  }

  // New method: Get concept explanation
  static String explainConcept(String concept) {
    final explanations = {
      'photosynthesis': '''
        Photosynthesis is how plants make their food:
        1. They take in sunlight through leaves
        2. Absorb water through roots
        3. Take in carbon dioxide from air
        4. Combine these to make glucose
        5. Release oxygen as a byproduct
      ''',
      'gravity': '''
        Gravity is a force that:
        1. Pulls objects toward each other
        2. Keeps planets in orbit
        3. Makes things fall to Earth
        4. Is stronger for objects with more mass
      ''',
      // Add more concepts
    };

    return explanations[concept.toLowerCase()] ??
        'This concept involves understanding key principles. Let\'s break it down...';
  }

  // New method: Get study schedule suggestion
  static Map<String, String> generateStudySchedule(List<String> subjects) {
    final schedule = <String, String>{};
    final timeSlots = ['9:00 AM', '11:00 AM', '2:00 PM', '4:00 PM'];

    for (var i = 0; i < subjects.length && i < timeSlots.length; i++) {
      schedule[timeSlots[i]] =
          '${subjects[i]} - Focus on key concepts and practice';
    }

    return schedule;
  }

  // New method: Get learning style recommendations
  static Map<String, List<String>> getLearningStyleTips(String style) {
    final tips = {
      'visual': [
        'Use mind maps and diagrams',
        'Watch educational videos',
        'Create colorful notes',
        'Draw concepts when possible',
      ],
      'auditory': [
        'Record and listen to notes',
        'Participate in group discussions',
        'Explain concepts out loud',
        'Use memory songs and rhymes',
      ],
      'kinesthetic': [
        'Use hands-on experiments',
        'Take breaks for movement',
        'Create physical models',
        'Act out concepts when possible',
      ],
    };

    return {style: tips[style.toLowerCase()] ?? []};
  }
}
