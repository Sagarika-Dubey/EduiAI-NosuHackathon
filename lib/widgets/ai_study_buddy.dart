import 'package:flutter/material.dart';
import '../services/enhanced_ai_service.dart';

class AIStudyBuddy extends StatefulWidget {
  final String subject;

  const AIStudyBuddy({super.key, required this.subject});

  @override
  _AIStudyBuddyState createState() => _AIStudyBuddyState();
}

class _AIStudyBuddyState extends State<AIStudyBuddy> {
  final TextEditingController _questionController = TextEditingController();
  final List<Map<String, String>> _conversation = [];
  bool _isLoading = false;

  Future<void> _askQuestion() async {
    if (_questionController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _conversation.add({
        'role': 'user',
        'message': _questionController.text,
      });
    });

    final response = await EnhancedAIService.getStudyBuddyResponse(
      _questionController.text,
      widget.subject,
      _conversation.isNotEmpty ? _conversation.last['message']! : '',
    );

    setState(() {
      _isLoading = false;
      _conversation.add({
        'role': 'ai',
        'message': response,
      });
      _questionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _conversation.length,
            itemBuilder: (context, index) {
              final message = _conversation[index];
              final isUser = message['role'] == 'user';
              return _buildMessageBubble(message['message']!, isUser);
            },
          ),
        ),
        if (_isLoading)
          Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
        _buildInputField(),
      ],
    );
  }

  Widget _buildMessageBubble(String message, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _questionController,
              decoration: InputDecoration(
                hintText: 'Ask your study buddy...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _askQuestion,
          ),
        ],
      ),
    );
  }
}
