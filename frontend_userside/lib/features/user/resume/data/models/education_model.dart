import 'package:frontend_userside/features/user/resume/domain/entities/education.dart';

class EducationModel extends Education {
  const EducationModel({
    required super.id,
    required super.degree,
    required super.institution,
    required super.location,
    required super.startDate,
    required super.endDate,
    required super.gradeOrCgpa,
    super.description,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      id: json['id'] as String? ?? '',
      degree: json['degree'] as String? ?? '',
      institution: json['institution'] as String? ?? '',
      location: json['location'] as String? ?? '',
      startDate:
          json['start_date'] as String? ?? json['startDate'] as String? ?? '',
      endDate: json['end_date'] as String? ?? json['endDate'] as String? ?? '',
      gradeOrCgpa:
          json['grade_or_cgpa'] as String? ??
          json['gradeOrCgpa'] as String? ??
          '',
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'degree': degree,
      'institution': institution,
      'location': location,
      'start_date': startDate,
      'end_date': endDate,
      'grade_or_cgpa': gradeOrCgpa,
      'description': description,
    };
  }

  factory EducationModel.fromEntity(Education e) {
    return EducationModel(
      id: e.id,
      degree: e.degree,
      institution: e.institution,
      location: e.location,
      startDate: e.startDate,
      endDate: e.endDate,
      gradeOrCgpa: e.gradeOrCgpa,
      description: e.description,
    );
  }
}
