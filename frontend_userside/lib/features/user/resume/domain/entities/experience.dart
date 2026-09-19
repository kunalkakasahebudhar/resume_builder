class Experience {
  final String id;
  final String jobTitle;
  final String company;
  final String location;
  final String
  employmentType; // Full-time, Part-time, Contract, Internship, Freelance
  final String startDate;
  final String endDate;
  final bool isCurrentlyWorking;
  final String description; // Multi-line bullet points

  const Experience({
    required this.id,
    required this.jobTitle,
    required this.company,
    required this.location,
    this.employmentType = 'Full-time',
    required this.startDate,
    required this.endDate,
    this.isCurrentlyWorking = false,
    required this.description,
  });

  Experience copyWith({
    String? id,
    String? jobTitle,
    String? company,
    String? location,
    String? employmentType,
    String? startDate,
    String? endDate,
    bool? isCurrentlyWorking,
    String? description,
  }) {
    return Experience(
      id: id ?? this.id,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      location: location ?? this.location,
      employmentType: employmentType ?? this.employmentType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrentlyWorking: isCurrentlyWorking ?? this.isCurrentlyWorking,
      description: description ?? this.description,
    );
  }
}
