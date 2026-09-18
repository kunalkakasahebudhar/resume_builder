import 'package:frontend_admin/features/admin/templates/domain/entities/template.dart';

class TemplateModel extends Template {
  const TemplateModel({
    required super.id,
    required super.name,
    required super.description,
    required super.category,
    required super.status,
    required super.usageCount,
    required super.previewColor,
    required super.createdAt,
  });

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'Classic',
      status: json['status'] as String? ?? 'Active',
      usageCount: json['usage_count'] as int? ?? 0,
      previewColor: json['preview_color'] as String? ?? '#4F46E5',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'status': status,
      'usage_count': usageCount,
      'preview_color': previewColor,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
