enum AssignmentType { homework, project, essay, quiz, lab }

enum AssignmentPriority { low, medium, high }

enum AssignmentStatus { pending, overdue, dueSoon, completed }

class Assignment {
  final String id;
  final String subject;
  final String title;
  final String description;
  final DateTime dueDate;
  final List<AssignmentQuestion> questions;
  final AssignmentType type;
  final AssignmentPriority priority;
  bool isSubmitted;

  Assignment({
    required this.id,
    required this.subject,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.questions,
    required this.type,
    required this.priority,
    this.isSubmitted = false,
  });

  AssignmentStatus get status {
    if (isSubmitted) return AssignmentStatus.completed;

    final now = DateTime.now();
    if (dueDate.isBefore(now)) return AssignmentStatus.overdue;
    if (dueDate.difference(now).inDays <= 2) return AssignmentStatus.dueSoon;
    return AssignmentStatus.pending;
  }
}

class AssignmentQuestion {
  final String question;
  final String type; // 'text', 'mcq', 'file'
  final List<String>? options;
  String? answer;
  String? feedback;

  AssignmentQuestion({
    required this.question,
    required this.type,
    this.options,
    this.answer,
    this.feedback,
  });
}
