import 'package:frontend_userside/features/user/templates/domain/entities/resume_template.dart';

class ResumeTemplateModel extends ResumeTemplate {
  const ResumeTemplateModel({
    required super.id,
    required super.name,
    required super.description,
    required super.category,
    super.previewImageUrl = '',
    super.isAtsOptimized = true,
    super.tags = const [],
  });

  factory ResumeTemplateModel.fromJson(Map<String, dynamic> json) {
    return ResumeTemplateModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'ATS Classic',
      previewImageUrl: json['preview_image_url'] as String? ?? '',
      isAtsOptimized: json['is_ats_optimized'] as bool? ?? true,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'preview_image_url': previewImageUrl,
      'is_ats_optimized': isAtsOptimized,
      'tags': tags,
    };
  }
}
