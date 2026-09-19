class Education {
  final String id;
  final String degree;
  final String institution;
  final String location;
  final String startDate;
  final String endDate;
  final String gradeOrCgpa;
  final String? description;

  const Education({
    required this.id,
    required this.degree,
    required this.institution,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.gradeOrCgpa,
    this.description,
  });

  Education copyWith({
    String? id,
    String? degree,
    String? institution,
    String? location,
    String? startDate,
    String? endDate,
    String? gradeOrCgpa,
    String? description,
  }) {
    return Education(
      id: id ?? this.id,
      degree: degree ?? this.degree,
      institution: institution ?? this.institution,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      gradeOrCgpa: gradeOrCgpa ?? this.gradeOrCgpa,
      description: description ?? this.description,
    );
  }
}
