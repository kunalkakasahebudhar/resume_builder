class AtsCategoryScore {
  final String categoryName;
  final int score;
  final int maxScore;
  final String feedback;

  const AtsCategoryScore({
    required this.categoryName,
    required this.score,
    required this.maxScore,
    required this.feedback,
  });

  double get percentage => maxScore > 0 ? (score / maxScore) * 100 : 0;
}

class AtsAnalysis {
  final String resumeId;
  final int overallScore; // 0 - 100
  final int structureScore; // max 20
  final int formattingScore; // max 15
  final int sectionsScore; // max 15
  final int keywordsScore; // max 20
  final int contentQualityScore; // max 15
  final int contactInfoScore; // max 5
  final int consistencyScore; // max 10
  final List<String> warnings;
  final List<String> suggestions;
  final List<String> detectedKeywords;
  final DateTime analyzedAt;

  const AtsAnalysis({
    required this.resumeId,
    required this.overallScore,
    this.structureScore = 18,
    this.formattingScore = 14,
    this.sectionsScore = 14,
    this.keywordsScore = 16,
    this.contentQualityScore = 12,
    this.contactInfoScore = 5,
    this.consistencyScore = 9,
    this.warnings = const [],
    this.suggestions = const [],
    this.detectedKeywords = const [],
    required this.analyzedAt,
  });

  List<AtsCategoryScore> get categoryScores => [
    AtsCategoryScore(
      categoryName: 'Structure',
      score: structureScore,
      maxScore: 20,
      feedback: 'Single column and clear logical hierarchy',
    ),
    AtsCategoryScore(
      categoryName: 'Formatting',
      score: formattingScore,
      maxScore: 15,
      feedback: 'Standard typography and machine-readable spacing',
    ),
    AtsCategoryScore(
      categoryName: 'Sections',
      score: sectionsScore,
      maxScore: 15,
      feedback: 'All critical sections (Experience, Education, Skills) present',
    ),
    AtsCategoryScore(
      categoryName: 'Keywords',
      score: keywordsScore,
      maxScore: 20,
      feedback: 'Matched industry standard technical keywords',
    ),
    AtsCategoryScore(
      categoryName: 'Content Quality',
      score: contentQualityScore,
      maxScore: 15,
      feedback: 'Action verbs and quantifiable metrics included',
    ),
    AtsCategoryScore(
      categoryName: 'Contact Information',
      score: contactInfoScore,
      maxScore: 5,
      feedback: 'Complete phone, email, location, and social links',
    ),
    AtsCategoryScore(
      categoryName: 'Consistency',
      score: consistencyScore,
      maxScore: 10,
      feedback: 'Consistent date formats and bullet styling',
    ),
  ];
}
