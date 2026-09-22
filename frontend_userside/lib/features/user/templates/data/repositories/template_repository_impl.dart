import 'package:frontend_userside/features/user/templates/data/datasources/template_remote_datasource.dart';
import 'package:frontend_userside/features/user/templates/domain/entities/resume_template.dart';
import 'package:frontend_userside/features/user/templates/domain/repositories/template_repository.dart';

class TemplateRepositoryImpl implements TemplateRepository {
  final TemplateRemoteDataSource remoteDataSource;

  TemplateRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ResumeTemplate>> getTemplates() async {
    return await remoteDataSource.getTemplates();
  }

  @override
  Future<ResumeTemplate> getTemplateById(String id) async {
    return await remoteDataSource.getTemplateById(id);
  }
}
