import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../services/enhanced_ai_service.dart';

final List<LinearGradient> cardGradients = [
  LinearGradient(
      colors: [Color(0xFF4158D0), Color(0xFFC850C0), Color(0xFFFFCC70)]),
  LinearGradient(colors: [Color(0xFF0093E9), Color(0xFF80D0C7)]),
  LinearGradient(colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)]),
  LinearGradient(colors: [Color(0xFFD9AFD9), Color(0xFF97D9E1)]),
  LinearGradient(colors: [Color(0xFF00DBDE), Color(0xFFFC00FF)]),
];

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final List<Map<String, String>> flashcards = [
    {
      'front': 'Photosynthesis',
      'back':
          'The process by which plants convert light energy into chemical energy',
    },
    {
      'front': 'Mitosis',
      'back': 'Cell division resulting in two identical daughter cells',
    },
    // Add more flashcards
  ];

  bool _isFlipped = false;
  int _currentIndex = 0;
  bool _isLoading = false;

  void _nextCard() {
    setState(() {
      _isFlipped = false;
      _currentIndex = (_currentIndex + 1) % flashcards.length;
    });
  }

  void _previousCard() {
    setState(() {
      _isFlipped = false;
      _currentIndex =
          (_currentIndex - 1 + flashcards.length) % flashcards.length;
    });
  }

  Future<void> _generateNewCards() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final newCards = await EnhancedAIService.generateFlashcards(
        'Current Topic', // You can make this dynamic
        5, // Number of cards to generate
      );

      setState(() {
        flashcards.addAll(newCards);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate new cards')),
      );
    }
  }

  void _addCustomCard() {
    final frontController = TextEditingController();
    final backController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Custom Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: frontController,
              decoration: InputDecoration(
                labelText: 'Front (Question)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: backController,
              decoration: InputDecoration(
                labelText: 'Back (Answer)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (frontController.text.isNotEmpty &&
                  backController.text.isNotEmpty) {
                setState(() {
                  flashcards.add({
                    'front': frontController.text,
                    'back': backController.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isFlipped = !_isFlipped;
              });
            },
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: _isFlipped ? 180 : 0),
              duration: Duration(milliseconds: 300),
              builder: (context, double value, child) {
                bool isFront = value < 90;
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY((value * math.pi) / 180),
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.all(32),
                    child: Card(
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: cardGradients[
                              _currentIndex % cardGradients.length],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(32),
                        child: Transform(
                          transform: Matrix4.identity()
                            ..rotateY(isFront ? 0 : math.pi),
                          alignment: Alignment.center,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isFront
                                      ? Icons.question_mark
                                      : Icons.lightbulb,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  isFront
                                      ? flashcards[_currentIndex]['front']!
                                      : flashcards[_currentIndex]['back']!,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: _previousCard,
                color: Colors.blue,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '${_currentIndex + 1}/${flashcards.length}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: _nextCard,
                color: Colors.blue,
              ),
              IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: _addCustomCard,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
