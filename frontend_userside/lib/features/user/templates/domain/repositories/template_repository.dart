import 'package:frontend_userside/features/user/templates/domain/entities/resume_template.dart';

abstract class TemplateRepository {
  Future<List<ResumeTemplate>> getTemplates();
  Future<ResumeTemplate> getTemplateById(String id);
}
