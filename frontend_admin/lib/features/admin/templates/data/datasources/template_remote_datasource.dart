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
      id: 'ats_harvard',
      name: 'Harvard Ivy League ATS',
      description:
          'Gold standard Ivy League academic & corporate format featuring bold capitalized headers, full-width dividers, and high density.',
      category: 'Ivy League',
      status: 'Active',
      usageCount: 2450,
      previewColor: '#000000',
      createdAt: DateTime(2025, 1, 1),
    ),
    TemplateModel(
      id: 'ats_tech_minimal',
      name: 'Silicon Valley Tech ATS',
      description:
          'FAANG standard with categorized skill matrix (Languages, Frameworks, Cloud, Databases) and bulleted accomplishments.',
      category: 'Tech & FAANG',
      status: 'Active',
      usageCount: 2180,
      previewColor: '#2563EB',
      createdAt: DateTime(2025, 1, 5),
    ),
    TemplateModel(
      id: 'ats_modern_clean',
      name: 'Modern Clean Minimalist ATS',
      description:
          'Contemporary slate aesthetic with subtle section accents, crisp typography, and optimal scannability for fast recruiter review.',
      category: 'Modern Clean',
      status: 'Active',
      usageCount: 1640,
      previewColor: '#0D9488',
      createdAt: DateTime(2025, 1, 8),
    ),
    TemplateModel(
      id: 'ats_executive',
      name: 'Executive Leadership & C-Suite',
      description:
          'Outcome-driven executive format featuring an Executive Profile highlight box, Core Competencies matrix, and revenue milestones.',
      category: 'Executive',
      status: 'Active',
      usageCount: 1390,
      previewColor: '#0F172A',
      createdAt: DateTime(2025, 1, 10),
    ),
    TemplateModel(
      id: 'ats_data_fintech',
      name: 'Quant, Data & FinTech ATS',
      description:
          'High-density layout designed for quants, data scientists, and investment analysts with KPI metrics focus.',
      category: 'FinTech & Quant',
      status: 'Active',
      usageCount: 1120,
      previewColor: '#1E40AF',
      createdAt: DateTime(2025, 1, 15),
    ),
    TemplateModel(
      id: 'ats_compact',
      name: 'Compact 1-Page High-Density',
      description:
          'Precision-engineered single-page format with optimized line heights, ensuring 100% fit on a single A4 page.',
      category: '1-Page Compact',
      status: 'Active',
      usageCount: 1870,
      previewColor: '#334155',
      createdAt: DateTime(2025, 1, 20),
    ),
    TemplateModel(
      id: 'ats_stanford',
      name: 'Stanford Academic & Research',
      description:
          'Academic research layout highlighting publications, grant awards, peer-reviewed papers, and research methodologies.',
      category: 'Academic',
      status: 'Active',
      usageCount: 940,
      previewColor: '#8C1D40',
      createdAt: DateTime(2025, 1, 25),
    ),
    TemplateModel(
      id: 'ats_professional',
      name: 'Corporate Professional ATS',
      description:
          'Modern corporate design with clean typography and subtle divider lines, tailored for mid-senior engineers and managers.',
      category: 'Corporate',
      status: 'Active',
      usageCount: 1780,
      previewColor: '#1E3A8A',
      createdAt: DateTime(2025, 2, 1),
    ),
    TemplateModel(
      id: 'ats_fresher',
      name: 'ATS Fresher & Early Career',
      description:
          'Structured layout emphasizing education, internships, academic projects, and verified skills for early career job seekers.',
      category: 'Fresher',
      status: 'Active',
      usageCount: 1340,
      previewColor: '#10B981',
      createdAt: DateTime(2025, 2, 5),
    ),
    TemplateModel(
      id: 'ats_experienced',
      name: 'Senior Career Progression ATS',
      description:
          'Chronological multi-role career history layout with quantifiable achievements and leadership milestone sections.',
      category: 'Experienced',
      status: 'Active',
      usageCount: 1560,
      previewColor: '#4338CA',
      createdAt: DateTime(2025, 2, 10),
    ),
    TemplateModel(
      id: 'ats_classic',
      name: 'ATS Classic Universal',
      description:
          'Single-column timeless layout with standard section headers, optimized for highest parsing accuracy in traditional ATS parsers.',
      category: 'Classic',
      status: 'Active',
      usageCount: 1920,
      previewColor: '#4F46E5',
      createdAt: DateTime(2025, 2, 15),
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
