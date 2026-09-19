class Project {
  final String id;
  final String projectName;
  final String role;
  final String description;
  final String technologies; // e.g. "Flutter, Go, PostgreSQL, Redis"
  final String? projectUrl;
  final String? githubUrl;
  final String? startDate;
  final String? endDate;

  const Project({
    required this.id,
    required this.projectName,
    this.role = '',
    required this.description,
    required this.technologies,
    this.projectUrl,
    this.githubUrl,
    this.startDate,
    this.endDate,
  });

  Project copyWith({
    String? id,
    String? projectName,
    String? role,
    String? description,
    String? technologies,
    String? projectUrl,
    String? githubUrl,
    String? startDate,
    String? endDate,
  }) {
    return Project(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      role: role ?? this.role,
      description: description ?? this.description,
      technologies: technologies ?? this.technologies,
      projectUrl: projectUrl ?? this.projectUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
