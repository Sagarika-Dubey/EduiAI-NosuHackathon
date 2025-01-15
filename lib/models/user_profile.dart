class UserProfile {
  final String uid;
  final String name;
  final int level;
  final int xp;
  final List<String> badges;
  final Map<String, int> subjectScores;
  final List<String> friends;
  final List<String> studyGroups;

  UserProfile({
    required this.uid,
    required this.name,
    required this.level,
    required this.xp,
    required this.badges,
    required this.subjectScores,
    required this.friends,
    required this.studyGroups,
  });

  int get xpToNextLevel => level * 1000;
  double get levelProgress => xp / xpToNextLevel;

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      level: map['level'] ?? 1,
      xp: map['xp'] ?? 0,
      badges: List<String>.from(map['badges'] ?? []),
      subjectScores: Map<String, int>.from(map['subjectScores'] ?? {}),
      friends: List<String>.from(map['friends'] ?? []),
      studyGroups: List<String>.from(map['studyGroups'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'level': level,
      'xp': xp,
      'badges': badges,
      'subjectScores': subjectScores,
      'friends': friends,
      'studyGroups': studyGroups,
    };
  }
}
