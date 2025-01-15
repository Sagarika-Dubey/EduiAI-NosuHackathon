import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceService {
  static final stt.SpeechToText _speech = stt.SpeechToText();
  static final FlutterTts _flutterTts = FlutterTts();

  static Future<bool> initialize() async {
    final speechInitialized = await _speech.initialize();
    await _flutterTts.setLanguage("en-US");
    return speechInitialized;
  }

  static Future<String> listen() async {
    if (!await _speech.initialize()) return '';

    String recognizedText = '';
    await _speech.listen(
      onResult: (result) {
        recognizedText = result.recognizedWords;
      },
    );

    return recognizedText;
  }

  static Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }
}
