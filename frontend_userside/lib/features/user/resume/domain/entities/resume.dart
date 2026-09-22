import 'package:frontend_userside/features/user/profile/domain/entities/profile.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/achievement.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/certification.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/education.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/experience.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/language.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/project.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/skill.dart';

enum ResumeStatus { draft, completed }

class Resume {
  final String id;
  final String title;
  final String
  templateId; // ats_classic, ats_professional, ats_fresher, ats_experienced
  final ResumeStatus status;
  final int atsScore;
  final int completionPercentage;
  final DateTime updatedAt;
  final DateTime createdAt;

  // Sections
  final Profile personalInfo;
  final String summary;
  final List<Education> educations;
  final List<Skill> skills;
  final List<Experience> experiences;
  final List<Project> projects;
  final List<Certification> certifications;
  final List<Achievement> achievements;
  final List<Language> languages;

  const Resume({
    required this.id,
    required this.title,
    this.templateId = 'ats_classic',
    this.status = ResumeStatus.draft,
    this.atsScore = 75,
    this.completionPercentage = 80,
    required this.updatedAt,
    required this.createdAt,
    required this.personalInfo,
    this.summary = '',
    this.educations = const [],
    this.skills = const [],
    this.experiences = const [],
    this.projects = const [],
    this.certifications = const [],
    this.achievements = const [],
    this.languages = const [],
  });

  Resume copyWith({
    String? id,
    String? title,
    String? templateId,
    ResumeStatus? status,
    int? atsScore,
    int? completionPercentage,
    DateTime? updatedAt,
    DateTime? createdAt,
    Profile? personalInfo,
    String? summary,
    List<Education>? educations,
    List<Skill>? skills,
    List<Experience>? experiences,
    List<Project>? projects,
    List<Certification>? certifications,
    List<Achievement>? achievements,
    List<Language>? languages,
  }) {
    return Resume(
      id: id ?? this.id,
      title: title ?? this.title,
      templateId: templateId ?? this.templateId,
      status: status ?? this.status,
      atsScore: atsScore ?? this.atsScore,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      personalInfo: personalInfo ?? this.personalInfo,
      summary: summary ?? this.summary,
      educations: educations ?? this.educations,
      skills: skills ?? this.skills,
      experiences: experiences ?? this.experiences,
      projects: projects ?? this.projects,
      certifications: certifications ?? this.certifications,
      achievements: achievements ?? this.achievements,
      languages: languages ?? this.languages,
    );
  }
}
