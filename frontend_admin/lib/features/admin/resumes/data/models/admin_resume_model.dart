import 'package:frontend_admin/features/admin/resumes/domain/entities/admin_resume.dart';

class AdminResumeModel extends AdminResume {
  const AdminResumeModel({
    required super.id,
    required super.resumeName,
    required super.userName,
    required super.userEmail,
    required super.templateName,
    required super.atsScore,
    required super.targetRole,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AdminResumeModel.fromJson(Map<String, dynamic> json) {
    return AdminResumeModel(
      id: json['id'] as String? ?? '',
      resumeName: json['resume_name'] as String? ?? '',
      userName: json['user_name'] as String? ?? '',
      userEmail: json['user_email'] as String? ?? '',
      templateName: json['template_name'] as String? ?? 'ATS Classic',
      atsScore: json['ats_score'] as int? ?? 0,
      targetRole: json['target_role'] as String? ?? 'General',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resume_name': resumeName,
      'user_name': userName,
      'user_email': userEmail,
      'template_name': templateName,
      'ats_score': atsScore,
      'target_role': targetRole,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
