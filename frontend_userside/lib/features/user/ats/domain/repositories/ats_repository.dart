import 'package:frontend_userside/features/user/ats/domain/entities/ats_analysis.dart';

abstract class AtsRepository {
  Future<AtsAnalysis> analyzeResume(String resumeId);
  Future<AtsAnalysis> getAnalysis(String resumeId);
}
