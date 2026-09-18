import 'package:frontend_admin/core/constants/api_constants.dart';
import 'package:frontend_admin/core/network/api_client.dart';
import 'package:frontend_admin/features/admin/templates/data/models/template_model.dart';

abstract class TemplateRemoteDataSource {
  Future<List<TemplateModel>> getTemplates();
  Future<TemplateModel> getTemplateById(String id);
  Future<void> createTemplate(TemplateModel template);
  Future<void> updateTemplate(TemplateModel template);
  Future<void> updateTemplateStatus(String id, String status);
  Future<void> deleteTemplate(String id);
}

class TemplateRemoteDataSourceImpl implements TemplateRemoteDataSource {
  final ApiClient apiClient;

  final List<TemplateModel> _mockTemplates = [
    TemplateModel(
      id: 'tpl_001',
      name: 'ATS Classic',
      description:
          'Single-column timeless layout with standard section headers, optimized for highest parsing accuracy in traditional ATS parsers.',
      category: 'Classic',
      status: 'Active',
      usageCount: 1420,
      previewColor: '#4F46E5',
      createdAt: DateTime(2025, 1, 10),
    ),
    TemplateModel(
      id: 'tpl_002',
      name: 'ATS Professional',
      description:
          'Modern corporate design with clean typography and subtle divider lines, tailored for mid-senior engineers and managers.',
      category: 'Professional',
      status: 'Active',
      usageCount: 1180,
      previewColor: '#0EA5E9',
      createdAt: DateTime(2025, 2, 14),
    ),
    TemplateModel(
      id: 'tpl_003',
      name: 'ATS Fresher',
      description:
          'Structured layout emphasizing education, internships, academic projects, and verified skills for early career job seekers.',
      category: 'Fresher',
      status: 'Active',
      usageCount: 540,
      previewColor: '#10B981',
      createdAt: DateTime(2025, 3, 1),
    ),
    TemplateModel(
      id: 'tpl_004',
      name: 'ATS Experienced',
      description:
          'Chronological multi-role career history layout with quantifiable achievements and leadership milestone sections.',
      category: 'Experienced',
      status: 'Active',
      usageCount: 890,
      previewColor: '#8B5CF6',
      createdAt: DateTime(2025, 3, 20),
    ),
  ];

  TemplateRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TemplateModel>> getTemplates() async {
    try {
      final res = await apiClient.get(ApiConstants.templates);
      if (res.data != null && res.data['data'] != null) {
        final list = res.data['data'] as List;
        return list
            .map((e) => TemplateModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return _mockTemplates;
    } catch (_) {
      return List.from(_mockTemplates);
    }
  }

  @override
  Future<TemplateModel> getTemplateById(String id) async {
    try {
      final res = await apiClient.get(ApiConstants.templateDetails(id));
      if (res.data != null && res.data['data'] != null) {
        return TemplateModel.fromJson(res.data['data'] as Map<String, dynamic>);
      }
      return _mockTemplates.firstWhere((t) => t.id == id);
    } catch (_) {
      return _mockTemplates.firstWhere(
        (t) => t.id == id,
        orElse: () => _mockTemplates.first,
      );
    }
  }

  @override
  Future<void> createTemplate(TemplateModel template) async {
    try {
      await apiClient.post(ApiConstants.templates, data: template.toJson());
    } catch (_) {
      _mockTemplates.add(template);
    }
  }

  @override
  Future<void> updateTemplate(TemplateModel template) async {
    try {
      await apiClient.put(
        ApiConstants.templateDetails(template.id),
        data: template.toJson(),
      );
    } catch (_) {
      final idx = _mockTemplates.indexWhere((t) => t.id == template.id);
      if (idx != -1) {
        _mockTemplates[idx] = template;
      }
    }
  }

  @override
  Future<void> updateTemplateStatus(String id, String status) async {
    try {
      await apiClient.put(
        ApiConstants.templateStatus(id),
        data: {'status': status},
      );
    } catch (_) {
      final idx = _mockTemplates.indexWhere((t) => t.id == id);
      if (idx != -1) {
        final t = _mockTemplates[idx];
        _mockTemplates[idx] = TemplateModel(
          id: t.id,
          name: t.name,
          description: t.description,
          category: t.category,
          status: status,
          usageCount: t.usageCount,
          previewColor: t.previewColor,
          createdAt: t.createdAt,
        );
      }
    }
  }

  @override
  Future<void> deleteTemplate(String id) async {
    try {
      await apiClient.delete(ApiConstants.templateDetails(id));
    } catch (_) {
      _mockTemplates.removeWhere((t) => t.id == id);
    }
  }
}
