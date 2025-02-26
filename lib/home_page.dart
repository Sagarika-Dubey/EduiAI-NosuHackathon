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
import 'models/assignment.dart';
import 'screens/assignment_detail_screen.dart';
import 'screens/assignments_screen.dart';

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
  double _buttonX = 20;
  double _buttonY = 80;
  final List<Assignment> pendingAssignments = [
    Assignment(
      id: '1',
      subject: 'Mathematics',
      title: 'Algebra Homework',
      description: 'Complete the following problems',
      dueDate: DateTime.now().add(Duration(days: 7)),
      type: AssignmentType.homework,
      priority: AssignmentPriority.high,
      questions: [
        AssignmentQuestion(
          question: 'Solve: 2x + 5 = 15',
          type: 'text',
        ),
        AssignmentQuestion(
          question: 'What is the value of y²-4 when y=3?',
          type: 'mcq',
          options: ['5', '7', '9', '5'],
        ),
      ],
    ),
    Assignment(
      id: '2',
      subject: 'Physics',
      title: 'Motion Project',
      description: 'Create a presentation on types of motion',
      dueDate: DateTime.now().add(Duration(days: 1)),
      type: AssignmentType.project,
      priority: AssignmentPriority.high,
      questions: [
        AssignmentQuestion(
          question: 'Explain different types of motion with examples',
          type: 'text',
        ),
      ],
    ),
    // Add more assignments
  ];

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
      body: Stack(
        children: [
          _buildBody(),
          _buildFloatingActionButton(),
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
    return Positioned(
      left: _buttonX,
      top: _buttonY,
      child: Draggable(
        feedback: _buildChatButton(),
        childWhenDragging: Container(),
        child: _buildChatButton(),
        onDragEnd: (details) {
          setState(() {
            final renderBox = context.findRenderObject() as RenderBox;
            final offset = renderBox.globalToLocal(details.offset);

            _buttonX = offset.dx - 30;
            _buttonY = offset.dy - 30;

            _buttonX = _buttonX.clamp(0.0, renderBox.size.width - 60);
            _buttonY = _buttonY.clamp(0.0, renderBox.size.height - 60);
          });
        },
      ),
    );
  }

  Widget _buildChatButton() {
    return GestureDetector(
      onTap: () {
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
    switch (_selectedIndex) {
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
          _buildPendingAssignments(),
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

  Widget _buildPendingAssignments() {
    final sortedAssignments = List<Assignment>.from(pendingAssignments)
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return Card(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pending Assignments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssignmentsScreen(
                            assignments: pendingAssignments,
                          ),
                        ),
                      );
                    },
                    child: Text('View All'),
                  ),
                ],
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: math.min(sortedAssignments.length, 3),
            itemBuilder: (context, index) {
              final assignment = sortedAssignments[index];
              return ListTile(
                leading: _buildAssignmentTypeIcon(assignment.type),
                title: Text(assignment.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Due: ${assignment.dueDate.toString().split(' ')[0]}'),
                    _buildStatusChip(assignment.status),
                  ],
                ),
                trailing: _buildPriorityIndicator(assignment.priority),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssignmentDetailScreen(
                        assignment: assignment,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn().slideX();
  }

  Widget _buildAssignmentTypeIcon(AssignmentType type) {
    final iconData = {
      AssignmentType.homework: Icons.assignment,
      AssignmentType.project: Icons.science_outlined,
      AssignmentType.essay: Icons.edit_note,
      AssignmentType.quiz: Icons.quiz,
      AssignmentType.lab: Icons.biotech,
    }[type];

    return CircleAvatar(
      backgroundColor: Colors.blue.withOpacity(0.1),
      child: Icon(iconData ?? Icons.assignment, color: Colors.blue),
    );
  }

  Widget _buildStatusChip(AssignmentStatus status) {
    final statusData = {
      AssignmentStatus.pending: (Colors.grey, 'Pending'),
      AssignmentStatus.overdue: (Colors.red, 'Overdue'),
      AssignmentStatus.dueSoon: (Colors.orange, 'Due Soon'),
      AssignmentStatus.completed: (Colors.green, 'Completed'),
    }[status]!;

    return Container(
      margin: EdgeInsets.only(top: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: statusData.$1.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusData.$2,
        style: TextStyle(
          color: statusData.$1,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(AssignmentPriority priority) {
    final color = {
      AssignmentPriority.low: Colors.green,
      AssignmentPriority.medium: Colors.orange,
      AssignmentPriority.high: Colors.red,
    }[priority]!;

    return Container(
      width: 4,
      height: 36,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
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
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        MathSolver(),
        SizedBox(height: 16),
        VoiceAssistant(),
      ],
    );
  }
}
