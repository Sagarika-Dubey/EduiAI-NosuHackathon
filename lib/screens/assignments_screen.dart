import 'package:flutter/material.dart';
import '../models/assignment.dart';
import './assignment_detail_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AssignmentsScreen extends StatefulWidget {
  final List<Assignment> assignments;

  const AssignmentsScreen({
    super.key,
    required this.assignments,
  });

  @override
  _AssignmentsScreenState createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  @override
  Widget build(BuildContext context) {
    final sortedAssignments = List<Assignment>.from(widget.assignments)
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: sortedAssignments.length,
        itemBuilder: (context, index) {
          final assignment = sortedAssignments[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: _buildAssignmentTypeIcon(assignment.type),
              title: Text(
                assignment.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(assignment.subject),
                  Text('Due: ${assignment.dueDate.toString().split(' ')[0]}'),
                  _buildStatusChip(assignment.status),
                ],
              ),
              trailing: _buildPriorityIndicator(assignment.priority),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssignmentDetailScreen(
                      assignment: assignment,
                    ),
                  ),
                );
              },
            ),
          ).animate().fadeIn().slideX();
        },
      ),
    );
  }

  Widget _buildAssignmentTypeIcon(AssignmentType type) {
    final iconData = {
      AssignmentType.homework: Icons.assignment,
      AssignmentType.project: Icons.science_outlined,
      AssignmentType.essay: Icons.edit_note,
      AssignmentType.quiz: Icons.quiz,
      AssignmentType.lab: Icons.biotech,
    }[type];

    return CircleAvatar(
      backgroundColor: Colors.blue.withOpacity(0.1),
      child: Icon(iconData ?? Icons.assignment, color: Colors.blue),
    );
  }

  Widget _buildStatusChip(AssignmentStatus status) {
    final statusData = {
      AssignmentStatus.pending: (Colors.grey, 'Pending'),
      AssignmentStatus.overdue: (Colors.red, 'Overdue'),
      AssignmentStatus.dueSoon: (Colors.orange, 'Due Soon'),
      AssignmentStatus.completed: (Colors.green, 'Completed'),
    }[status]!;

    return Container(
      margin: EdgeInsets.only(top: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: statusData.$1.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusData.$2,
        style: TextStyle(
          color: statusData.$1,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(AssignmentPriority priority) {
    final color = {
      AssignmentPriority.low: Colors.green,
      AssignmentPriority.medium: Colors.orange,
      AssignmentPriority.high: Colors.red,
    }[priority]!;

    return Container(
      width: 4,
      height: 36,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
