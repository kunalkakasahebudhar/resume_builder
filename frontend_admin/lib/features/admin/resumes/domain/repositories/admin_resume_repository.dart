import 'package:frontend_admin/features/admin/resumes/domain/entities/admin_resume.dart';

abstract class AdminResumeRepository {
  Future<List<AdminResume>> getResumes({
    String? search,
    String? template,
    String? scoreTier,
  });
  Future<AdminResume?> getResumeById(String id);
  Future<void> deleteResume(String id);
}
