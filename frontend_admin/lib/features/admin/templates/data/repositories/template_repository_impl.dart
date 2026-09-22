import 'package:frontend_admin/features/admin/templates/domain/entities/template.dart';
import 'package:frontend_admin/features/admin/templates/domain/repositories/template_repository.dart';
import 'package:frontend_admin/features/admin/templates/data/datasources/template_remote_datasource.dart';
import 'package:frontend_admin/features/admin/templates/data/models/template_model.dart';

class TemplateRepositoryImpl implements TemplateRepository {
  final TemplateRemoteDataSource remoteDataSource;

  TemplateRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Template>> getTemplates() {
    return remoteDataSource.getTemplates();
  }

  @override
  Future<Template?> getTemplateById(String id) {
    return remoteDataSource.getTemplateById(id);
  }

  @override
  Future<void> createTemplate(Template template) {
    final model = TemplateModel(
      id: template.id,
      name: template.name,
      description: template.description,
      category: template.category,
      status: template.status,
      usageCount: template.usageCount,
      previewColor: template.previewColor,
      createdAt: template.createdAt,
    );
    return remoteDataSource.createTemplate(model);
  }

  @override
  Future<void> updateTemplate(Template template) {
    final model = TemplateModel(
      id: template.id,
      name: template.name,
      description: template.description,
      category: template.category,
      status: template.status,
      usageCount: template.usageCount,
      previewColor: template.previewColor,
      createdAt: template.createdAt,
    );
    return remoteDataSource.updateTemplate(model);
  }

  @override
  Future<void> updateTemplateStatus(String id, String status) {
    return remoteDataSource.updateTemplateStatus(id, status);
  }

  @override
  Future<void> deleteTemplate(String id) {
    return remoteDataSource.deleteTemplate(id);
  }
}
