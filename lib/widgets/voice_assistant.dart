import 'package:flutter/material.dart';
import '../services/voice_service.dart';
import '../services/enhanced_ai_service.dart';

class VoiceAssistant extends StatefulWidget {
  const VoiceAssistant({super.key});

  @override
  _VoiceAssistantState createState() => _VoiceAssistantState();
}

class _VoiceAssistantState extends State<VoiceAssistant> {
  bool _isListening = false;
  String _lastQuery = '';
  String _response = '';

  Future<void> _startListening() async {
    setState(() {
      _isListening = true;
    });

    final query = await VoiceService.listen();
    final response = await EnhancedAIService.getVoiceResponse(query);
    await VoiceService.speak(response);

    setState(() {
      _isListening = false;
      _lastQuery = query;
      _response = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          onPressed: _isListening ? null : _startListening,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
        if (_lastQuery.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'You said: $_lastQuery',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Response: $_response',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ],
    );
  }
}
