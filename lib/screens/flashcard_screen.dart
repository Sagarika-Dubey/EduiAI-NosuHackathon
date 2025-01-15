import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../services/enhanced_ai_service.dart';

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
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(32),
                        child: Transform(
                          transform: Matrix4.identity()
                            ..rotateY(isFront ? 0 : math.pi),
                          alignment: Alignment.center,
                          child: Center(
                            child: Text(
                              isFront
                                  ? flashcards[_currentIndex]['front']!
                                  : flashcards[_currentIndex]['back']!,
                              style: TextStyle(fontSize: 24),
                              textAlign: TextAlign.center,
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
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _previousCard,
              ),
              Text('${_currentIndex + 1}/${flashcards.length}'),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _nextCard,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
