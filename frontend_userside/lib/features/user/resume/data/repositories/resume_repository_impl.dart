import 'package:frontend_userside/features/user/resume/data/datasources/resume_remote_datasource.dart';
import 'package:frontend_userside/features/user/resume/data/models/resume_model.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/resume.dart';
import 'package:frontend_userside/features/user/resume/domain/repositories/resume_repository.dart';

class ResumeRepositoryImpl implements ResumeRepository {
  final ResumeRemoteDataSource remoteDataSource;

  ResumeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Resume>> getResumes() async {
    return await remoteDataSource.getResumes();
  }

  @override
  Future<Resume> getResumeById(String id) async {
    return await remoteDataSource.getResumeById(id);
  }

  @override
  Future<Resume> createResume({
    required String title,
    String? templateId,
  }) async {
    return await remoteDataSource.createResume(
      title: title,
      templateId: templateId,
    );
  }

  @override
  Future<Resume> updateResume(Resume resume) async {
    final model = ResumeModel.fromEntity(resume);
    return await remoteDataSource.updateResume(model);
  }

  @override
  Future<void> deleteResume(String id) async {
    await remoteDataSource.deleteResume(id);
  }

  @override
  Future<Resume> duplicateResume(String id) async {
    return await remoteDataSource.duplicateResume(id);
  }

  @override
  Future<Resume> renameResume(String id, String newTitle) async {
    return await remoteDataSource.renameResume(id, newTitle);
  }
}
