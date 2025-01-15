import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/gamification_service.dart';

class ProgressTracker extends StatelessWidget {
  const ProgressTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: GamificationService.getUserStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        final stats = snapshot.data!;
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    icon: Icons.stars,
                    value: stats['points'].toString(),
                    label: 'Points',
                    color: Colors.amber,
                  ),
                  _buildStatItem(
                    icon: Icons.local_fire_department,
                    value: '${stats['streak']} days',
                    label: 'Streak',
                    color: Colors.orange,
                  ),
                ],
              ),
              SizedBox(height: 16),
              if (stats['badges'].isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: (stats['badges'] as List).map<Widget>((badge) {
                    return Chip(
                      avatar: Icon(Icons.emoji_events, size: 16),
                      label: Text(badge),
                      backgroundColor: Colors.blue.withOpacity(0.1),
                    );
                  }).toList(),
                ),
            ],
          ),
        ).animate().fadeIn().slideY();
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
