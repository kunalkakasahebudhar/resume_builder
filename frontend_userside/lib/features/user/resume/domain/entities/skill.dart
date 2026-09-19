enum SkillCategory {
  technical,
  programmingLanguage,
  framework,
  database,
  tool,
  softSkill,
}

class Skill {
  final String id;
  final String name;
  final SkillCategory category;
  final String? level; // e.g. Beginner, Intermediate, Advanced, Expert

  const Skill({
    required this.id,
    required this.name,
    this.category = SkillCategory.technical,
    this.level,
  });

  Skill copyWith({
    String? id,
    String? name,
    SkillCategory? category,
    String? level,
  }) {
    return Skill(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      level: level ?? this.level,
    );
  }
}
