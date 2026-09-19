import 'package:frontend_userside/features/user/resume/domain/entities/experience.dart';

class ExperienceModel extends Experience {
  const ExperienceModel({
    required super.id,
    required super.jobTitle,
    required super.company,
    required super.location,
    super.employmentType = 'Full-time',
    required super.startDate,
    required super.endDate,
    super.isCurrentlyWorking = false,
    required super.description,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      id: json['id'] as String? ?? '',
      jobTitle:
          json['job_title'] as String? ?? json['jobTitle'] as String? ?? '',
      company: json['company'] as String? ?? '',
      location: json['location'] as String? ?? '',
      employmentType:
          json['employment_type'] as String? ??
          json['employmentType'] as String? ??
          'Full-time',
      startDate:
          json['start_date'] as String? ?? json['startDate'] as String? ?? '',
      endDate: json['end_date'] as String? ?? json['endDate'] as String? ?? '',
      isCurrentlyWorking:
          json['is_currently_working'] as bool? ??
          json['isCurrentlyWorking'] as bool? ??
          false,
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_title': jobTitle,
      'company': company,
      'location': location,
      'employment_type': employmentType,
      'start_date': startDate,
      'end_date': endDate,
      'is_currently_working': isCurrentlyWorking,
      'description': description,
    };
  }

  factory ExperienceModel.fromEntity(Experience e) {
    return ExperienceModel(
      id: e.id,
      jobTitle: e.jobTitle,
      company: e.company,
      location: e.location,
      employmentType: e.employmentType,
      startDate: e.startDate,
      endDate: e.endDate,
      isCurrentlyWorking: e.isCurrentlyWorking,
      description: e.description,
    );
  }
}
