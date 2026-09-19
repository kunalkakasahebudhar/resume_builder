class ResumeTemplate {
  final String id;
  final String name;
  final String description;
  final String
  category; // ATS Classic, ATS Professional, ATS Fresher, ATS Experienced
  final String previewImageUrl;
  final bool isAtsOptimized;
  final List<String> tags;

  const ResumeTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.previewImageUrl = '',
    this.isAtsOptimized = true,
    this.tags = const [],
  });
}
