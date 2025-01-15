import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SchoolScreen extends StatelessWidget {
  final List<Map<String, dynamic>> schedule = [
    {
      'time': '8:00 AM',
      'subject': 'Mathematics',
      'teacher': 'Dr. Smith',
      'room': 'Room 101'
    },
    {
      'time': '9:30 AM',
      'subject': 'Physics',
      'teacher': 'Mrs. Johnson',
      'room': 'Lab 202'
    },
    {
      'time': '11:00 AM',
      'subject': 'Chemistry',
      'teacher': 'Mr. Brown',
      'room': 'Lab 203'
    },
    {
      'time': '1:00 PM',
      'subject': 'Biology',
      'teacher': 'Ms. Davis',
      'room': 'Lab 204'
    },
  ];

  SchoolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My School'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTodaySchedule(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaySchedule(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Schedule",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideX(),
          SizedBox(height: 16),
          ...schedule.map((lesson) => _buildScheduleCard(context, lesson)),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(BuildContext context, Map<String, dynamic> lesson) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              lesson['time'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson['subject'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${lesson['teacher']} • ${lesson['room']}',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideX();
  }
}
