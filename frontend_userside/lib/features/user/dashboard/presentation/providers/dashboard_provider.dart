import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/resume.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';

class DashboardStats {
  final int totalResumes;
  final int draftResumes;
  final int completedResumes;
  final double averageAtsScore;

  const DashboardStats({
    this.totalResumes = 0,
    this.draftResumes = 0,
    this.completedResumes = 0,
    this.averageAtsScore = 0.0,
  });
}

final dashboardStatsProvider = Provider<DashboardStats>((ref) {
  final resumesState = ref.watch(resumesListProvider);
  final resumes = resumesState.resumes;

  if (resumes.isEmpty) {
    return const DashboardStats();
  }

  final total = resumes.length;
  final drafts = resumes.where((r) => r.status == ResumeStatus.draft).length;
  final completed = resumes
      .where((r) => r.status == ResumeStatus.completed)
      .length;
  final totalScore = resumes.fold<int>(0, (sum, r) => sum + r.atsScore);
  final avgScore = total > 0 ? totalScore / total : 0.0;

  return DashboardStats(
    totalResumes: total,
    draftResumes: drafts,
    completedResumes: completed,
    averageAtsScore: avgScore,
  );
});
