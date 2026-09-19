import 'package:frontend_userside/features/user/ats/domain/entities/ats_analysis.dart';

class AtsAnalysisModel extends AtsAnalysis {
  const AtsAnalysisModel({
    required super.resumeId,
    required super.overallScore,
    super.structureScore = 18,
    super.formattingScore = 14,
    super.sectionsScore = 14,
    super.keywordsScore = 16,
    super.contentQualityScore = 12,
    super.contactInfoScore = 5,
    super.consistencyScore = 9,
    super.warnings = const [],
    super.suggestions = const [],
    super.detectedKeywords = const [],
    required super.analyzedAt,
  });

  factory AtsAnalysisModel.fromJson(Map<String, dynamic> json) {
    return AtsAnalysisModel(
      resumeId: json['resume_id'] as String? ?? '',
      overallScore: (json['overall_score'] as num?)?.toInt() ?? 75,
      structureScore: (json['structure_score'] as num?)?.toInt() ?? 18,
      formattingScore: (json['formatting_score'] as num?)?.toInt() ?? 14,
      sectionsScore: (json['sections_score'] as num?)?.toInt() ?? 14,
      keywordsScore: (json['keywords_score'] as num?)?.toInt() ?? 16,
      contentQualityScore:
          (json['content_quality_score'] as num?)?.toInt() ?? 12,
      contactInfoScore: (json['contact_info_score'] as num?)?.toInt() ?? 5,
      consistencyScore: (json['consistency_score'] as num?)?.toInt() ?? 9,
      warnings:
          (json['warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      suggestions:
          (json['suggestions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      detectedKeywords:
          (json['detected_keywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      analyzedAt: json['analyzed_at'] != null
          ? DateTime.parse(json['analyzed_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resume_id': resumeId,
      'overall_score': overallScore,
      'structure_score': structureScore,
      'formatting_score': formattingScore,
      'sections_score': sectionsScore,
      'keywords_score': keywordsScore,
      'content_quality_score': contentQualityScore,
      'contact_info_score': contactInfoScore,
      'consistency_score': consistencyScore,
      'warnings': warnings,
      'suggestions': suggestions,
      'detected_keywords': detectedKeywords,
      'analyzed_at': analyzedAt.toIso8601String(),
    };
  }
}
