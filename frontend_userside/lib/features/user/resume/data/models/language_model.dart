import 'package:frontend_userside/features/user/resume/domain/entities/language.dart';

class LanguageModel extends Language {
  const LanguageModel({
    required super.id,
    required super.language,
    super.proficiency = 'Fluent',
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      id: json['id'] as String? ?? '',
      language: json['language'] as String? ?? '',
      proficiency: json['proficiency'] as String? ?? 'Fluent',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'language': language, 'proficiency': proficiency};
  }

  factory LanguageModel.fromEntity(Language l) {
    return LanguageModel(
      id: l.id,
      language: l.language,
      proficiency: l.proficiency,
    );
  }
}
