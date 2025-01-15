import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class EnhancedGamificationService {
  static const String _userProfileKey = 'user_profile';
  static const String _leaderboardKey = 'leaderboard';
  static const Map<String, int> _actionPoints = {
    'quiz_completion': 100,
    'perfect_score': 500,
    'daily_login': 50,
    'study_streak': 200,
    'help_friend': 150,
  };

  static Future<void> awardXP(String action) async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_userProfileKey);
    if (profileJson != null) {
      final profile = UserProfile.fromMap(Map<String, dynamic>.from(
          Map.from(const JsonDecoder().convert(profileJson))));

      final pointsEarned = _actionPoints[action] ?? 0;
      final newXP = profile.xp + pointsEarned;
      var newLevel = profile.level;

      // Level up if enough XP
      while (newXP >= profile.xpToNextLevel) {
        newLevel++;
        // Award level-up bonus
        await _awardLevelUpRewards(newLevel);
      }

      final updatedProfile = UserProfile(
        uid: profile.uid,
        name: profile.name,
        level: newLevel,
        xp: newXP,
        badges: profile.badges,
        subjectScores: profile.subjectScores,
        friends: profile.friends,
        studyGroups: profile.studyGroups,
      );

      await prefs.setString(
          _userProfileKey, const JsonEncoder().convert(updatedProfile.toMap()));
    }
  }

  static Future<void> _awardLevelUpRewards(int level) async {
    // Implement level-up rewards
  }

  static Future<List<Map<String, dynamic>>> getLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final leaderboardJson = prefs.getString(_leaderboardKey);
    if (leaderboardJson != null) {
      return List<Map<String, dynamic>>.from(
          const JsonDecoder().convert(leaderboardJson));
    }
    return [];
  }
}
