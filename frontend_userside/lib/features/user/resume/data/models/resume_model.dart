import 'package:frontend_userside/features/user/profile/data/models/profile_model.dart';
import 'package:frontend_userside/features/user/profile/domain/entities/profile.dart';
import 'package:frontend_userside/features/user/resume/data/models/achievement_model.dart';
import 'package:frontend_userside/features/user/resume/data/models/certification_model.dart';
import 'package:frontend_userside/features/user/resume/data/models/education_model.dart';
import 'package:frontend_userside/features/user/resume/data/models/experience_model.dart';
import 'package:frontend_userside/features/user/resume/data/models/language_model.dart';
import 'package:frontend_userside/features/user/resume/data/models/project_model.dart';
import 'package:frontend_userside/features/user/resume/data/models/skill_model.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/resume.dart';

class ResumeModel extends Resume {
  const ResumeModel({
    required super.id,
    required super.title,
    super.templateId = 'ats_classic',
    super.status = ResumeStatus.draft,
    super.atsScore = 75,
    super.completionPercentage = 80,
    required super.updatedAt,
    required super.createdAt,
    required super.personalInfo,
    super.summary = '',
    super.educations = const [],
    super.skills = const [],
    super.experiences = const [],
    super.projects = const [],
    super.certifications = const [],
    super.achievements = const [],
    super.languages = const [],
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    return ResumeModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled Resume',
      templateId: json['template_id'] as String? ?? 'ats_classic',
      status: (json['status'] == 'completed')
          ? ResumeStatus.completed
          : ResumeStatus.draft,
      atsScore: (json['ats_score'] as num?)?.toInt() ?? 75,
      completionPercentage:
          (json['completion_percentage'] as num?)?.toInt() ?? 80,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      personalInfo: json['personal_info'] != null
          ? ProfileModel.fromJson(json['personal_info'] as Map<String, dynamic>)
          : const Profile(
              id: '',
              fullName: '',
              professionalTitle: '',
              email: '',
              phone: '',
              location: '',
            ),
      summary: json['summary'] as String? ?? '',
      educations:
          (json['educations'] as List<dynamic>?)
              ?.map((e) => EducationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      skills:
          (json['skills'] as List<dynamic>?)
              ?.map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      experiences:
          (json['experiences'] as List<dynamic>?)
              ?.map((e) => ExperienceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      projects:
          (json['projects'] as List<dynamic>?)
              ?.map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      certifications:
          (json['certifications'] as List<dynamic>?)
              ?.map(
                (e) => CertificationModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      achievements:
          (json['achievements'] as List<dynamic>?)
              ?.map((e) => AchievementModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      languages:
          (json['languages'] as List<dynamic>?)
              ?.map((e) => LanguageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'template_id': templateId,
      'status': status.name,
      'ats_score': atsScore,
      'completion_percentage': completionPercentage,
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'personal_info': ProfileModel.fromEntity(personalInfo).toJson(),
      'summary': summary,
      'educations': educations
          .map((e) => EducationModel.fromEntity(e).toJson())
          .toList(),
      'skills': skills.map((e) => SkillModel.fromEntity(e).toJson()).toList(),
      'experiences': experiences
          .map((e) => ExperienceModel.fromEntity(e).toJson())
          .toList(),
      'projects': projects
          .map((e) => ProjectModel.fromEntity(e).toJson())
          .toList(),
      'certifications': certifications
          .map((e) => CertificationModel.fromEntity(e).toJson())
          .toList(),
      'achievements': achievements
          .map((e) => AchievementModel.fromEntity(e).toJson())
          .toList(),
      'languages': languages
          .map((e) => LanguageModel.fromEntity(e).toJson())
          .toList(),
    };
  }

  factory ResumeModel.fromEntity(Resume r) {
    return ResumeModel(
      id: r.id,
      title: r.title,
      templateId: r.templateId,
      status: r.status,
      atsScore: r.atsScore,
      completionPercentage: r.completionPercentage,
      updatedAt: r.updatedAt,
      createdAt: r.createdAt,
      personalInfo: r.personalInfo,
      summary: r.summary,
      educations: r.educations,
      skills: r.skills,
      experiences: r.experiences,
      projects: r.projects,
      certifications: r.certifications,
      achievements: r.achievements,
      languages: r.languages,
    );
  }
}
