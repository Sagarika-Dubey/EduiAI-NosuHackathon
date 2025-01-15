import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class MathVisionService {
  static final _textRecognizer = TextRecognizer();
  static final _picker = ImagePicker();

  static Future<String> solveMathProblem() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) return 'No image selected';

      final inputImage = InputImage.fromFile(File(image.path));
      final recognizedText = await _textRecognizer.processImage(inputImage);
      final text = recognizedText.text;

      // Basic math operations
      if (text.contains('+')) {
        final numbers =
            text.split('+').map((s) => int.tryParse(s.trim())).whereType<int>();
        if (numbers.length == 2) {
          return '${numbers.first} + ${numbers.last} = ${numbers.first + numbers.last}';
        }
      } else if (text.contains('-')) {
        final parts = text.split('-');
        if (parts.length == 2) {
          final num1 = int.tryParse(parts[0].trim());
          final num2 = int.tryParse(parts[1].trim());
          if (num1 != null && num2 != null) {
            return '$num1 - $num2 = ${num1 - num2}';
          }
        }
      } else if (text.contains('×') || text.contains('*')) {
        final numbers = text
            .split(RegExp(r'[×*]'))
            .map((s) => int.tryParse(s.trim()))
            .whereType<int>();
        if (numbers.length == 2) {
          return '${numbers.first} × ${numbers.last} = ${numbers.first * numbers.last}';
        }
      }

      return 'Recognized text: $text\nPlease write the math problem clearly';
    } catch (e) {
      return 'Error processing image: $e';
    }
  }
}
