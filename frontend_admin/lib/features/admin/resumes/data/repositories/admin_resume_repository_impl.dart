import 'package:frontend_admin/features/admin/resumes/domain/entities/admin_resume.dart';
import 'package:frontend_admin/features/admin/resumes/domain/repositories/admin_resume_repository.dart';
import 'package:frontend_admin/features/admin/resumes/data/datasources/admin_resume_remote_datasource.dart';

class AdminResumeRepositoryImpl implements AdminResumeRepository {
  final AdminResumeRemoteDataSource remoteDataSource;

  AdminResumeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AdminResume>> getResumes({
    String? search,
    String? template,
    String? scoreTier,
  }) async {
    final resumes = await remoteDataSource.getResumes();
    var filtered = List<AdminResume>.from(resumes);

    if (search != null && search.trim().isNotEmpty) {
      final q = search.trim().toLowerCase();
      filtered = filtered.where((r) {
        return r.resumeName.toLowerCase().contains(q) ||
            r.userName.toLowerCase().contains(q) ||
            r.targetRole.toLowerCase().contains(q);
      }).toList();
    }

    if (template != null && template != 'All') {
      filtered = filtered.where((r) => r.templateName == template).toList();
    }

    if (scoreTier != null && scoreTier != 'All') {
      if (scoreTier == 'High (80-100)') {
        filtered = filtered.where((r) => r.atsScore >= 80).toList();
      } else if (scoreTier == 'Medium (60-79)') {
        filtered = filtered
            .where((r) => r.atsScore >= 60 && r.atsScore < 80)
            .toList();
      } else if (scoreTier == 'Low (0-59)') {
        filtered = filtered.where((r) => r.atsScore < 60).toList();
      }
    }

    return filtered;
  }

  @override
  Future<AdminResume?> getResumeById(String id) {
    return remoteDataSource.getResumeById(id);
  }

  @override
  Future<void> deleteResume(String id) {
    return remoteDataSource.deleteResume(id);
  }
}
