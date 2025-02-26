import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/download_service.dart';
import 'package:open_file/open_file.dart';
import '../services/syllabus_based_ai_service.dart';
import 'quiz_screen.dart';
import '../models/quiz_question.dart';

class SyllabusScreen extends StatefulWidget {
  const SyllabusScreen({super.key});

  @override
  State<SyllabusScreen> createState() => _SyllabusScreenState();
}

class _SyllabusScreenState extends State<SyllabusScreen> {
  final Map<String, double> _downloadProgress = {};
  final List<Map<String, dynamic>> subjects = [
    {
      'name': 'Mathematics',
      'units': [
        {
          'title': 'Algebra',
          'topics': ['Linear Equations', 'Quadratic Equations', 'Polynomials'],
          'resources': ['Chapter Notes', 'Practice Problems', 'Video Lectures'],
        },
        {
          'title': 'Geometry',
          'topics': ['Triangles', 'Circles', 'Coordinate Geometry'],
          'resources': ['Formula Sheet', 'Solved Examples', 'Quiz'],
        },
      ],
    },
    {
      'name': 'Physics',
      'units': [
        {
          'title': 'Mechanics',
          'topics': ['Motion', 'Force', 'Energy'],
          'resources': ['Lab Manual', 'Simulation', 'Practice Tests'],
        },
        {
          'title': 'Electricity',
          'topics': ['Current', 'Voltage', 'Circuits'],
          'resources': ['Circuit Diagrams', 'Video Demos', 'Problems'],
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Syllabus'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: subjects.length,
        itemBuilder: (context, index) =>
            _buildSubjectCard(context, subjects[index], index),
      ),
    );
  }

  Widget _buildSubjectCard(
      BuildContext context, Map<String, dynamic> subject, int index) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          subject['name'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          ...(subject['units'] as List).map(
            (unit) => _buildUnitSection(context, unit),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(delay: (index * 100).ms);
  }

  Widget _buildUnitSection(BuildContext context, Map<String, dynamic> unit) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            unit['title'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ...(unit['topics'] as List).map(
                (topic) => Chip(
                  label: Text(topic),
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Resources',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ...(unit['resources'] as List).map(
            (resource) => ListTile(
              leading: Icon(Icons.file_download),
              title: Text(resource),
              subtitle: _downloadProgress.containsKey(resource)
                  ? LinearProgressIndicator(
                      value: _downloadProgress[resource],
                      backgroundColor:
                          theme.colorScheme.primary.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary),
                    )
                  : null,
              trailing: IconButton(
                icon: _downloadProgress.containsKey(resource)
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : Icon(Icons.download),
                onPressed: () async {
                  if (_downloadProgress.containsKey(resource)) return;

                  try {
                    setState(() {
                      _downloadProgress[resource] = 0.0;
                    });

                    // Simulate progress updates
                    for (var i = 0; i < 100; i++) {
                      await Future.delayed(Duration(milliseconds: 50));
                      setState(() {
                        _downloadProgress[resource] = i / 100;
                      });
                    }

                    final filePath =
                        await DownloadService.downloadResource(resource);

                    try {
                      final result = await OpenFile.open(filePath);
                      if (result.type != ResultType.done) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not open file')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error opening file')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to download $resource')),
                    );
                    setState(() {
                      _downloadProgress.remove(resource);
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startTopicQuiz(String subject, Map<String, dynamic> unit) {
    final questionsMap = SyllabusBasedAIService.generateQuestionsFromSyllabus(
      subject,
      [unit],
      'medium',
    );

    final questions = questionsMap
        .map((q) => QuizQuestion(
              subject: subject,
              question: q['question'],
              options: List<String>.from(q['options']),
              correctAnswer: q['correct'],
              explanation: q['explanation'],
              difficulty: q['difficulty'],
            ))
        .toList();

    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No questions available for this topic')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          subject: subject,
          questions: questions,
        ),
      ),
    );
  }
}
