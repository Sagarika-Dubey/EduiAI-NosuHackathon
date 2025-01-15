import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import 'chat_bot.dart';
import 'screens/progress_screen.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import 'screens/school_screen.dart';
import 'screens/syllabus_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/quiz_landing_screen.dart';
import 'screens/language_learning_screen.dart';
import 'screens/flashcard_screen.dart';
import 'widgets/math_solver.dart';
import 'widgets/voice_assistant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final List<String> subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'History',
    'Literature'
  ];
  final Map<int, bool> _isFlipped = {};
  late TabController _tabController;
  bool isDarkMode = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      floatingActionButton: _buildFloatingActionButton(),
      body: Stack(
        children: [
          _buildBody(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final theme = Theme.of(context);
    return AppBar(
      elevation: 0,
      backgroundColor: theme.colorScheme.surface,
      iconTheme: IconThemeData(color: Colors.black87),
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: Text(
        'EduAI',
        style: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Hi User!',
            style: theme.textTheme.titleMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: ChatBotDialog(),
          ),
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Icon(Icons.chat, color: Colors.white),
      ),
    ).animate().scale(delay: 300.ms);
  }

  Widget _buildBody() {
    switch (_tabController.index) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _buildQuizContent();
      case 2:
        return LanguageLearningScreen();
      case 3:
        return FlashcardScreen();
      case 4:
        return _buildAIFeatures();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Subjects',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _isFlipped[index] = !(_isFlipped[index] ?? false);
                  });
                },
                child: TweenAnimationBuilder(
                  tween: Tween<double>(
                    begin: 0,
                    end: (_isFlipped[index] ?? false) ? 180 : 0,
                  ),
                  duration: Duration(milliseconds: 300),
                  builder: (context, double value, child) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(value * math.pi / 180),
                      alignment: Alignment.center,
                      child: value >= 90
                          ? _buildCardBack(index)
                          : _buildCardFront(index),
                    );
                  },
                ),
              );
            },
          ),
          SizedBox(height: 24),
          _buildAssignmentsSection(),
        ],
      ),
    );
  }

  Widget _buildCardFront(int index) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getGradientColors(index),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getGradientColors(index)[0].withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getSubjectIcon(index),
            size: 44,
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Text(
            subjects[index],
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms).scale(delay: (index * 100).ms);
  }

  Widget _buildCardBack(int index) {
    final theme = Theme.of(context);
    final progress = (index + 1) * 15 % 100;
    return Transform(
      transform: Matrix4.identity()..rotateY(math.pi),
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$progress%',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Completed',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSubjectIcon(int index) {
    switch (index) {
      case 0:
        return Icons.calculate_rounded;
      case 1:
        return Icons.science_rounded;
      case 2:
        return Icons.science_rounded;
      case 3:
        return Icons.biotech_rounded;
      case 4:
        return Icons.history_edu_rounded;
      case 5:
        return Icons.menu_book_rounded;
      default:
        return Icons.book_rounded;
    }
  }

  List<Color> _getGradientColors(int index) {
    final gradients = [
      [Colors.blue.shade400, Colors.blue.shade700],
      [Colors.purple.shade400, Colors.purple.shade700],
      [Colors.orange.shade400, Colors.orange.shade700],
      [Colors.green.shade400, Colors.green.shade700],
      [Colors.red.shade400, Colors.red.shade700],
      [Colors.teal.shade400, Colors.teal.shade700],
    ];
    return gradients[index % gradients.length];
  }

  Widget _buildAssignmentsSection() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pending Assignments',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn().slideX(),
        SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade300,
                          Colors.orange.shade500
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(Icons.assignment, color: Colors.white),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Assignment ${index + 1}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Due in 2 days',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (index * 200).ms).slideX();
          },
        ),
      ],
    );
  }

  Widget _buildQuizContent() {
    return QuizLandingScreen();
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            icon: Icon(Icons.home_rounded),
            text: 'Home',
          ),
          Tab(
            icon: Icon(Icons.quiz_rounded),
            text: 'Quiz',
          ),
          Tab(
            icon: Icon(Icons.book_rounded),
            text: 'Learn',
          ),
          Tab(
            icon: Icon(Icons.flash_on_rounded),
            text: 'Cards',
          ),
          Tab(
            icon: Icon(Icons.smart_toy),
            text: 'AI Tools',
          ),
        ],
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.blue,
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [Colors.grey[900]!, Colors.grey[800]!]
                : [Colors.white, Colors.grey[100]!],
          ),
        ),
        child: Column(
          children: [
            _buildDrawerHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.show_chart,
                    title: 'My Progress',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProgressScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.school,
                    title: 'My School',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SchoolScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.book,
                    title: 'My Syllabus',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SyllabusScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            Divider(),
            _buildThemeToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 50, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 35,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'John Doe',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Class X-A',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: Colors.blue,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      onTap: onTap,
    ).animate().fadeIn().slideX();
  }

  Widget _buildThemeToggle() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dark Mode',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
                activeColor: Colors.blue,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAIFeatures() {
    return Column(
      children: [
        MathSolver(),
        SizedBox(height: 16),
        VoiceAssistant(),
      ],
    );
  }
}
