import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import '../models/quiz_question.dart';
import '../services/quiz_service.dart';
import '../services/ai_learning_service.dart';
import '../services/gamification_service.dart';
import '../widgets/progress_tracker.dart';

class QuizScreen extends StatefulWidget {
  final String subject;
  final List<QuizQuestion> questions;

  const QuizScreen({
    super.key,
    required this.subject,
    required this.questions,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  final Map<int, String> _selectedAnswers = {};
  bool _showResult = false;
  late Timer _timer;
  int _timeLeft = 30; // 30 seconds per question
  String _selectedDifficulty = 'Easy';
  List<QuizQuestion> _questions = [];
  final bool _showExplanation = false;
  late String _aiHint;
  final bool _showHint = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _startTimer();
    _loadAIHint();
  }

  void _loadQuestions() {
    final questions = QuizService.getQuestionsBySubjectAndDifficulty(
      widget.subject,
      _selectedDifficulty,
    );
    setState(() {
      _questions = questions;
      _currentQuestionIndex = 0;
      _selectedAnswers.clear();
      _showResult = false;
      _timeLeft = 30;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _nextQuestion();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  int get _score {
    int correct = 0;
    _selectedAnswers.forEach((index, answer) {
      if (answer == _questions[index].correctAnswer) correct++;
    });
    return correct;
  }

  Future<void> _loadAIHint() async {
    if (!mounted) return;
    final hint = await AILearningService.getPersonalizedHint(
      widget.subject,
      _selectedDifficulty,
    );
    if (!mounted) return;
    setState(() {
      _aiHint = hint;
    });
  }

  Future<void> _awardPoints() async {
    final points = _score * 10;
    await GamificationService.addPoints(points);

    if (_score == _questions.length) {
      await GamificationService.awardBadge(
          'Perfect Score in ${widget.subject}');
    }

    await GamificationService.updateStreak();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No questions available for $_selectedDifficulty difficulty',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedDifficulty = 'Easy';
                    _loadQuestions();
                  });
                },
                child: Text('Try Easy Questions'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: _showResult ? _buildResult() : _buildQuiz(),
    );
  }

  Widget _buildQuiz() {
    final theme = Theme.of(context);
    final question = _questions[_currentQuestionIndex];

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProgressBar(),
          _buildDifficultySelector(),
          _buildTimer(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.subject,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn().slideX(),
                  SizedBox(height: 8),
                  Text(
                    question.question,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn().slideX(),
                  SizedBox(height: 32),
                  ..._buildOptions(question),
                  if (_showExplanation) ...[
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explanation:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(question.explanation),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: _resetQuiz,
              ),
            ],
          ),
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOptions(QuizQuestion question) {
    return (question.options as List).map((option) {
      final isSelected = _selectedAnswers[_currentQuestionIndex] == option;
      return Container(
        margin: EdgeInsets.only(bottom: 12),
        child: Material(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              setState(() {
                _selectedAnswers[_currentQuestionIndex] = option;
              });
            },
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey.shade300,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade400,
                        width: 2,
                      ),
                      color: isSelected ? Colors.blue : Colors.transparent,
                    ),
                    child: isSelected
                        ? Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected ? Colors.blue : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ).animate().fadeIn().slideX();
    }).toList();
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentQuestionIndex > 0)
            ElevatedButton(
              onPressed: _previousQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black87,
              ),
              child: Row(
                children: [
                  Icon(Icons.arrow_back),
                  SizedBox(width: 8),
                  Text('Previous'),
                ],
              ),
            )
          else
            SizedBox(),
          ElevatedButton(
            onPressed: _selectedAnswers[_currentQuestionIndex] != null
                ? _nextQuestion
                : null,
            child: Row(
              children: [
                Text(_currentQuestionIndex == _questions.length - 1
                    ? 'Finish'
                    : 'Next'),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz Complete!',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn().slideY(),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$_score/${_questions.length}',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ).animate().scale(),
            SizedBox(height: 32),
            Text(
              _getResultMessage(),
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ).animate().fadeIn(),
            SizedBox(height: 32),
            ProgressTracker(),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _resetQuiz,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text('Try Again'),
            ).animate().fadeIn().slideY(),
            SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back to Home'),
            ).animate().fadeIn().slideY(),
          ],
        ),
      ),
    );
  }

  String _getResultMessage() {
    final percentage = (_score / _questions.length) * 100;
    if (percentage == 100) return 'Perfect! You\'re a genius! 🎉';
    if (percentage >= 80) return 'Great job! Keep it up! 🌟';
    if (percentage >= 60) return 'Good effort! Room for improvement! 💪';
    return 'Keep practicing! You can do better! 📚';
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      setState(() {
        _showResult = true;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _selectedAnswers.clear();
      _showResult = false;
    });
  }

  Widget _buildDifficultySelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: ['Easy', 'Medium', 'Hard'].map((difficulty) {
          final isSelected = _selectedDifficulty == difficulty;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDifficulty = difficulty;
                _loadQuestions();
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                difficulty,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimer() {
    final isLowTime = _timeLeft <= 10;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer,
            color: isLowTime ? Colors.red : Colors.grey,
          ),
          SizedBox(width: 8),
          Text(
            '$_timeLeft seconds',
            style: TextStyle(
              color: isLowTime ? Colors.red : Colors.grey,
              fontWeight: isLowTime ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    ).animate(target: isLowTime ? 1 : 0).shake();
  }
}
