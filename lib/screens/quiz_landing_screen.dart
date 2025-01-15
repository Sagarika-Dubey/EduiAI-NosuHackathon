import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'quiz_screen.dart';

class QuizLandingScreen extends StatelessWidget {
  final List<Map<String, dynamic>> subjects = [
    {
      'name': 'Mathematics',
      'icon': Icons.functions,
      'color': Colors.blue,
      'description': 'Test your math skills with fun quizzes!',
    },
    {
      'name': 'English',
      'icon': Icons.book,
      'color': Colors.green,
      'description': 'Improve your language proficiency',
    },
    {
      'name': 'Science',
      'icon': Icons.science,
      'color': Colors.purple,
      'description': 'Explore the world of science',
    },
    {
      'name': 'History',
      'icon': Icons.history_edu,
      'color': Colors.orange,
      'description': 'Journey through time with history quizzes',
    },
    {
      'name': 'Geography',
      'icon': Icons.public,
      'color': Colors.teal,
      'description': 'Learn about our world',
    },
  ];

  QuizLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Landing'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(subject: subject['name']),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: subject['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    subject['icon'],
                    size: 48,
                    color: subject['color'],
                  ),
                  SizedBox(height: 16),
                  Text(
                    subject['name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      subject['description'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().scale(delay: (index * 100).ms),
          );
        },
      ),
    );
  }
}
