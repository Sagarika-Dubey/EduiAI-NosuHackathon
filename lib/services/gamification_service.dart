import 'package:shared_preferences/shared_preferences.dart';

class GamificationService {
  static const String _pointsKey = 'points';
  static const String _streakKey = 'streak';
  static const String _badgesKey = 'badges';
  static const String _lastLoginKey = 'lastLogin';

  static Future<void> addPoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    final currentPoints = prefs.getInt(_pointsKey) ?? 0;
    await prefs.setInt(_pointsKey, currentPoints + points);
  }

  static Future<void> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLogin = prefs.getString(_lastLoginKey);
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastLogin != today) {
      final currentStreak = prefs.getInt(_streakKey) ?? 0;
      await prefs.setInt(_streakKey, currentStreak + 1);
      await prefs.setString(_lastLoginKey, today);
    }
  }

  static Future<void> awardBadge(String badge) async {
    final prefs = await SharedPreferences.getInstance();
    final badges = prefs.getStringList(_badgesKey) ?? [];
    if (!badges.contains(badge)) {
      badges.add(badge);
      await prefs.setStringList(_badgesKey, badges);
    }
  }

  static Future<Map<String, dynamic>> getUserStats() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'points': prefs.getInt(_pointsKey) ?? 0,
      'streak': prefs.getInt(_streakKey) ?? 0,
      'badges': prefs.getStringList(_badgesKey) ?? [],
    };
  }
}
