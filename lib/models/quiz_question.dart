class QuizQuestion {
  final String subject;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final String difficulty;

  QuizQuestion({
    required this.subject,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.difficulty,
  });
}
