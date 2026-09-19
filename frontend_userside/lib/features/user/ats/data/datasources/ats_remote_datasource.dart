import 'package:frontend_userside/core/network/dio_client.dart';
import 'package:frontend_userside/features/user/ats/data/models/ats_analysis_model.dart';

abstract class AtsRemoteDataSource {
  Future<AtsAnalysisModel> analyzeResume(String resumeId);
  Future<AtsAnalysisModel> getAnalysis(String resumeId);
}

class AtsRemoteDataSourceImpl implements AtsRemoteDataSource {
  final DioClient? dioClient;

  AtsRemoteDataSourceImpl({this.dioClient});

  @override
  Future<AtsAnalysisModel> analyzeResume(String resumeId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _buildMockAnalysis(resumeId);
  }

  @override
  Future<AtsAnalysisModel> getAnalysis(String resumeId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _buildMockAnalysis(resumeId);
  }

  AtsAnalysisModel _buildMockAnalysis(String resumeId) {
    return AtsAnalysisModel(
      resumeId: resumeId,
      overallScore: 82,
      structureScore: 18,
      formattingScore: 14,
      sectionsScore: 15,
      keywordsScore: 17,
      contentQualityScore: 13,
      contactInfoScore: 5,
      consistencyScore: 9,
      warnings: const [
        'LinkedIn URL should include custom profile vanity slug.',
        'Project description for "MicroMetrics" could include more measurable impact metrics (% or \$).',
        'Ensure all date ranges follow a uniform "Mon YYYY" pattern.',
      ],
      suggestions: const [
        'Add 2-3 additional cloud infrastructure keywords (e.g. AWS, Terraform, CI/CD).',
        'Start bullet points with strong action verbs (e.g., "Spearheaded", "Architected", "Accelerated").',
        'Quantify achievements where possible (e.g., "Reduced latency by 40%").',
      ],
      detectedKeywords: const [
        'Golang',
        'Flutter',
        'PostgreSQL',
        'Docker',
        'Kubernetes',
        'Microservices',
        'REST APIs',
        'Redis',
        'CI/CD',
      ],
      analyzedAt: DateTime.now(),
    );
  }
}
