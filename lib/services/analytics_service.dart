import 'package:fl_chart/fl_chart.dart';

class AnalyticsService {
  static Future<Map<String, dynamic>> getPerformanceAnalytics(
      String userId) async {
    // Implement detailed analytics
    return {
      'subjectPerformance': {
        'Mathematics': 85,
        'Physics': 78,
        'Chemistry': 92,
      },
      'weeklyProgress': [
        {'day': 'Mon', 'score': 75},
        {'day': 'Tue', 'score': 80},
        {'day': 'Wed', 'score': 85},
        {'day': 'Thu', 'score': 82},
        {'day': 'Fri', 'score': 88},
      ],
      'strengths': ['Problem Solving', 'Quick Learning'],
      'areasToImprove': ['Time Management', 'Theory Questions'],
    };
  }

  static List<FlSpot> getProgressChartData(List<Map<String, dynamic>> data) {
    return data
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value['score'].toDouble()))
        .toList();
  }
}
