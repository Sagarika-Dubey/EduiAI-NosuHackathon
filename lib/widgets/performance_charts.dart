import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../services/analytics_service.dart';

class PerformanceCharts extends StatelessWidget {
  final Map<String, dynamic> analytics;

  const PerformanceCharts({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSubjectRadarChart(),
        SizedBox(height: 20),
        _buildProgressLineChart(),
        SizedBox(height: 20),
        _buildStrengthsAndWeaknesses(),
      ],
    );
  }

  Widget _buildSubjectRadarChart() {
    // Implement radar chart for subject performance
    return Container();
  }

  Widget _buildProgressLineChart() {
    final data = analytics['weeklyProgress'] as List;
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: AnalyticsService.getProgressChartData(
                  List<Map<String, dynamic>>.from(data)),
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthsAndWeaknesses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Strengths',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        ...(analytics['strengths'] as List).map((s) => ListTile(
              leading: Icon(Icons.star, color: Colors.amber),
              title: Text(s),
            )),
        SizedBox(height: 16),
        Text(
          'Areas to Improve',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        ...(analytics['areasToImprove'] as List).map((s) => ListTile(
              leading: Icon(Icons.trending_up, color: Colors.blue),
              title: Text(s),
            )),
      ],
    );
  }
}
