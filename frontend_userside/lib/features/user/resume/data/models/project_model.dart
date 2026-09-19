import 'package:frontend_userside/features/user/resume/domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.projectName,
    super.role = '',
    required super.description,
    required super.technologies,
    super.projectUrl,
    super.githubUrl,
    super.startDate,
    super.endDate,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String? ?? '',
      projectName:
          json['project_name'] as String? ??
          json['projectName'] as String? ??
          '',
      role: json['role'] as String? ?? '',
      description: json['description'] as String? ?? '',
      technologies: json['technologies'] as String? ?? '',
      projectUrl:
          json['project_url'] as String? ?? json['projectUrl'] as String?,
      githubUrl: json['github_url'] as String? ?? json['githubUrl'] as String?,
      startDate: json['start_date'] as String? ?? json['startDate'] as String?,
      endDate: json['end_date'] as String? ?? json['endDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_name': projectName,
      'role': role,
      'description': description,
      'technologies': technologies,
      'project_url': projectUrl,
      'github_url': githubUrl,
      'start_date': startDate,
      'end_date': endDate,
    };
  }

  factory ProjectModel.fromEntity(Project p) {
    return ProjectModel(
      id: p.id,
      projectName: p.projectName,
      role: p.role,
      description: p.description,
      technologies: p.technologies,
      projectUrl: p.projectUrl,
      githubUrl: p.githubUrl,
      startDate: p.startDate,
      endDate: p.endDate,
    );
  }
}
