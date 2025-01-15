import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LanguageLearningScreen extends StatelessWidget {
  final List<Map<String, dynamic>> languages = [
    {
      'name': 'Spanish',
      'flag': '🇪🇸',
      'progress': 0.4,
      'lessons': ['Basics', 'Greetings', 'Numbers', 'Colors'],
    },
    {
      'name': 'French',
      'flag': '🇫🇷',
      'progress': 0.3,
      'lessons': ['Introduction', 'Common Phrases', 'Food', 'Travel'],
    },
    // Add more languages
  ];

  LanguageLearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: languages.length,
      itemBuilder: (context, index) {
        final language = languages[index];
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ExpansionTile(
            leading: Text(
              language['flag'],
              style: TextStyle(fontSize: 24),
            ),
            title: Text(language['name']),
            subtitle: LinearProgressIndicator(
              value: language['progress'],
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: language['lessons'].length,
                itemBuilder: (context, lessonIndex) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      child: Text('${lessonIndex + 1}'),
                    ),
                    title: Text(language['lessons'][lessonIndex]),
                    trailing: Icon(Icons.play_circle_filled),
                    onTap: () {
                      // Start lesson
                    },
                  );
                },
              ),
            ],
          ),
        ).animate().fadeIn().slideX(delay: (index * 100).ms);
      },
    );
  }
}
