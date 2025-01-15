import '../models/quiz_question.dart';

class QuizService {
  static final List<QuizQuestion> allQuestions = [
    // Mathematics Questions
    QuizQuestion(
      subject: 'Mathematics',
      question: 'What is the value of π (pi) to two decimal places?',
      options: ['3.10', '3.14', '3.16', '3.18'],
      correctAnswer: '3.14',
      explanation:
          'Pi (π) is approximately equal to 3.14159..., which rounds to 3.14.',
      difficulty: 'Easy',
    ),
    QuizQuestion(
      subject: 'Mathematics',
      question: 'Solve: 2x + 5 = 15',
      options: ['x = 5', 'x = 7', 'x = 3', 'x = 8'],
      correctAnswer: 'x = 5',
      explanation:
          'Subtract 5 from both sides: 2x = 10, then divide by 2: x = 5',
      difficulty: 'Easy',
    ),
    QuizQuestion(
      subject: 'Mathematics',
      question: 'What is the area of a circle with radius 5 units?',
      options: ['25π', '10π', '15π', '20π'],
      correctAnswer: '25π',
      explanation: 'Area of circle = πr², where r = 5. So, area = π(5²) = 25π',
      difficulty: 'Medium',
    ),

    // English Questions
    QuizQuestion(
      subject: 'English',
      question: 'Which of these is a proper noun?',
      options: ['London', 'city', 'building', 'street'],
      correctAnswer: 'London',
      explanation: 'London is a proper noun as it names a specific city.',
      difficulty: 'Easy',
    ),
    QuizQuestion(
      subject: 'English',
      question: 'What is the past tense of "write"?',
      options: ['wrote', 'written', 'wright', 'writing'],
      correctAnswer: 'wrote',
      explanation: 'The simple past tense of "write" is "wrote".',
      difficulty: 'Easy',
    ),
    QuizQuestion(
      subject: 'English',
      question: 'Identify the figure of speech: "Life is a roller coaster"',
      options: ['Metaphor', 'Simile', 'Hyperbole', 'Personification'],
      correctAnswer: 'Metaphor',
      explanation:
          'This is a metaphor as it directly compares life to a roller coaster without using "like" or "as".',
      difficulty: 'Medium',
    ),
    QuizQuestion(
      subject: 'English',
      question: 'What type of word is "quickly"?',
      options: ['Adverb', 'Adjective', 'Noun', 'Verb'],
      correctAnswer: 'Adverb',
      explanation:
          'Quickly is an adverb as it describes how an action is performed.',
      difficulty: 'Easy',
    ),

    // Science Questions
    QuizQuestion(
      subject: 'Science',
      question: 'What is the chemical symbol for water?',
      options: ['H2O', 'CO2', 'O2', 'NaCl'],
      correctAnswer: 'H2O',
      explanation:
          'Water is composed of two hydrogen atoms and one oxygen atom: H2O',
      difficulty: 'Easy',
    ),
    QuizQuestion(
      subject: 'Science',
      question: 'Which planet is known as the Red Planet?',
      options: ['Mars', 'Venus', 'Jupiter', 'Saturn'],
      correctAnswer: 'Mars',
      explanation: 'Mars appears red due to iron oxide (rust) on its surface.',
      difficulty: 'Easy',
    ),
    QuizQuestion(
      subject: 'Science',
      question: 'What is the process by which plants make their own food?',
      options: ['Photosynthesis', 'Respiration', 'Digestion', 'Fermentation'],
      correctAnswer: 'Photosynthesis',
      explanation:
          'Photosynthesis is the process where plants use sunlight to make glucose from CO2 and water.',
      difficulty: 'Medium',
    ),

    // History Questions
    QuizQuestion(
      subject: 'History',
      question: 'Who was the first President of the United States?',
      options: [
        'George Washington',
        'Thomas Jefferson',
        'John Adams',
        'Benjamin Franklin'
      ],
      correctAnswer: 'George Washington',
      explanation:
          'George Washington served as the first President from 1789 to 1797.',
      difficulty: 'Easy',
    ),
    QuizQuestion(
      subject: 'History',
      question: 'In which year did World War II end?',
      options: ['1945', '1944', '1946', '1943'],
      correctAnswer: '1945',
      explanation:
          'World War II ended in 1945 with the surrender of Germany and Japan.',
      difficulty: 'Easy',
    ),
    QuizQuestion(
      subject: 'History',
      question: 'Which ancient civilization built the pyramids?',
      options: ['Egyptian', 'Greek', 'Roman', 'Persian'],
      correctAnswer: 'Egyptian',
      explanation:
          'The ancient Egyptians built the pyramids as tombs for their pharaohs.',
      difficulty: 'Easy',
    ),

    // Geography Questions
    QuizQuestion(
      subject: 'Geography',
      question: 'What is the capital of France?',
      options: ['Paris', 'London', 'Berlin', 'Madrid'],
      correctAnswer: 'Paris',
      explanation: 'Paris is the capital and largest city of France.',
      difficulty: 'Easy',
    ),
    QuizQuestion(
      subject: 'Geography',
      question: 'Which is the largest ocean on Earth?',
      options: ['Pacific', 'Atlantic', 'Indian', 'Arctic'],
      correctAnswer: 'Pacific',
      explanation:
          'The Pacific Ocean is the largest and deepest ocean on Earth.',
      difficulty: 'Easy',
    ),
    QuizQuestion(
      subject: 'Geography',
      question: 'What is the longest river in the world?',
      options: ['Nile', 'Amazon', 'Mississippi', 'Yangtze'],
      correctAnswer: 'Nile',
      explanation:
          'The Nile River is the longest river in the world at 6,650 kilometers.',
      difficulty: 'Medium',
    ),
    QuizQuestion(
      subject: 'Geography',
      question: 'Which continent is known as the "Dark Continent"?',
      options: ['Africa', 'Asia', 'Europe', 'Australia'],
      correctAnswer: 'Africa',
      explanation:
          'Africa was historically called the Dark Continent due to European unfamiliarity with its interior.',
      difficulty: 'Medium',
    ),
  ];

  static List<QuizQuestion> getQuestionsByDifficulty(String difficulty) {
    return allQuestions.where((q) => q.difficulty == difficulty).toList();
  }

  static List<QuizQuestion> getQuestionsBySubject(String subject) {
    return allQuestions.where((q) => q.subject == subject).toList();
  }

  static List<String> getUniqueSubjects() {
    return allQuestions.map((q) => q.subject).toSet().toList();
  }

  static List<QuizQuestion> getQuestionsBySubjectAndDifficulty(
    String subject,
    String difficulty,
  ) {
    return allQuestions
        .where((q) => q.subject == subject && q.difficulty == difficulty)
        .toList();
  }
}
