import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/assignment.dart';

class AssignmentDetailScreen extends StatefulWidget {
  final Assignment assignment;

  const AssignmentDetailScreen({super.key, required this.assignment});

  @override
  _AssignmentDetailScreenState createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {
  final Map<int, TextEditingController> _controllers = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.assignment.questions.length; i++) {
      _controllers[i] = TextEditingController(
        text: widget.assignment.questions[i].answer,
      );
    }
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _submitAssignment() async {
    setState(() => _isSubmitting = true);

    // Save answers
    for (var i = 0; i < widget.assignment.questions.length; i++) {
      widget.assignment.questions[i].answer = _controllers[i]?.text;
    }

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      widget.assignment.isSubmitted = true;
      _isSubmitting = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Assignment submitted successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.assignment.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 24),
            _buildQuestions(),
            SizedBox(height: 32),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.assignment.subject,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.assignment.description,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16),
              SizedBox(width: 8),
              Text(
                'Due: ${widget.assignment.dueDate.toString().split(' ')[0]}',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideX();
  }

  Widget _buildQuestions() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.assignment.questions.length,
      itemBuilder: (context, index) {
        final question = widget.assignment.questions[index];
        return Container(
          margin: EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question ${index + 1}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                question.question,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              if (question.type == 'mcq')
                _buildMCQOptions(question, index)
              else
                TextField(
                  controller: _controllers[index],
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Type your answer here...',
                    border: OutlineInputBorder(),
                  ),
                ),
            ],
          ),
        ).animate().fadeIn().slideX();
      },
    );
  }

  Widget _buildMCQOptions(AssignmentQuestion question, int questionIndex) {
    return Column(
      children: question.options!.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: _controllers[questionIndex]?.text,
          onChanged: (value) {
            setState(() {
              _controllers[questionIndex]?.text = value ?? '';
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitAssignment,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        ),
        child: _isSubmitting
            ? CircularProgressIndicator()
            : Text('Submit Assignment'),
      ),
    ).animate().fadeIn().slideY();
  }
}
