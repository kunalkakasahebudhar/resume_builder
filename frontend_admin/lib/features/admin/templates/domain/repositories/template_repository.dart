import 'package:frontend_admin/features/admin/templates/domain/entities/template.dart';

abstract class TemplateRepository {
  Future<List<Template>> getTemplates();
  Future<Template?> getTemplateById(String id);
  Future<void> createTemplate(Template template);
  Future<void> updateTemplate(Template template);
  Future<void> updateTemplateStatus(String id, String status);
  Future<void> deleteTemplate(String id);
}
