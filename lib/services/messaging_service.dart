import 'package:flutter/material.dart';

class MessagingService {
  static Future<void> sendMessageToTeacher(
    BuildContext context,
    String teacherName,
    String message,
  ) async {
    try {
      // Simulate sending message
      await Future.delayed(Duration(seconds: 1));
      return;
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  static void showMessageDialog(BuildContext context, String teacherName) {
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Message to $teacherName',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if (messageController.text.trim().isEmpty) return;

                      try {
                        Navigator.pop(context);
                        await sendMessageToTeacher(
                          context,
                          teacherName,
                          messageController.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Message sent to $teacherName'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to send message'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text('Send'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
