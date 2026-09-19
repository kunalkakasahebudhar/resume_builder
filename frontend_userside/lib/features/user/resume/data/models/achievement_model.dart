import 'package:frontend_userside/features/user/resume/domain/entities/achievement.dart';

class AchievementModel extends Achievement {
  const AchievementModel({
    required super.id,
    required super.title,
    required super.description,
    required super.date,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      date: json['date'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'description': description, 'date': date};
  }

  factory AchievementModel.fromEntity(Achievement a) {
    return AchievementModel(
      id: a.id,
      title: a.title,
      description: a.description,
      date: a.date,
    );
  }
}
