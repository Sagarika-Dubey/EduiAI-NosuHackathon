import 'package:flutter/material.dart';
import '../services/math_vision_service.dart';
import '../services/voice_service.dart';

class MathSolver extends StatefulWidget {
  const MathSolver({super.key});

  @override
  _MathSolverState createState() => _MathSolverState();
}

class _MathSolverState extends State<MathSolver> {
  String _solution = '';
  bool _isLoading = false;

  Future<void> _scanAndSolve() async {
    setState(() {
      _isLoading = true;
    });

    final solution = await MathVisionService.solveMathProblem();
    await VoiceService.speak(solution); // Read solution aloud

    setState(() {
      _solution = solution;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _scanAndSolve,
          icon: Icon(Icons.camera_alt),
          label: Text('Scan Math Problem'),
        ),
        if (_isLoading)
          CircularProgressIndicator()
        else if (_solution.isNotEmpty)
          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Solution:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(_solution),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
