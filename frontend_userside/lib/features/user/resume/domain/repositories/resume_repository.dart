import 'package:frontend_userside/features/user/resume/domain/entities/resume.dart';

abstract class ResumeRepository {
  Future<List<Resume>> getResumes();
  Future<Resume> getResumeById(String id);
  Future<Resume> createResume({required String title, String? templateId});
  Future<Resume> updateResume(Resume resume);
  Future<void> deleteResume(String id);
  Future<Resume> duplicateResume(String id);
  Future<Resume> renameResume(String id, String newTitle);
}
