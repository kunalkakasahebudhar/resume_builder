import 'package:frontend_userside/features/user/resume/domain/entities/skill.dart';

class SkillModel extends Skill {
  const SkillModel({
    required super.id,
    required super.name,
    super.category = SkillCategory.technical,
    super.level,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: SkillCategory.values.firstWhere(
        (c) => c.name == (json['category'] as String? ?? 'technical'),
        orElse: () => SkillCategory.technical,
      ),
      level: json['level'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'category': category.name, 'level': level};
  }

  factory SkillModel.fromEntity(Skill s) {
    return SkillModel(
      id: s.id,
      name: s.name,
      category: s.category,
      level: s.level,
    );
  }
}
