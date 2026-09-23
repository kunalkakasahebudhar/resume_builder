import 'package:frontend_userside/config/backend_config.dart';
import 'package:frontend_userside/core/error/exceptions.dart';
import 'package:frontend_userside/core/network/dio_client.dart';
import 'package:frontend_userside/features/user/templates/data/models/resume_template_model.dart';

abstract class TemplateRemoteDataSource {
  Future<List<ResumeTemplateModel>> getTemplates();
  Future<ResumeTemplateModel> getTemplateById(String id);
}

class TemplateRemoteDataSourceImpl implements TemplateRemoteDataSource {
  final DioClient? dioClient;

  TemplateRemoteDataSourceImpl({this.dioClient});

  static const List<ResumeTemplateModel> _localTemplates = [
    ResumeTemplateModel(id: 'ats_harvard', name: 'Harvard Ivy League ATS', description: 'Gold standard Ivy League academic & corporate format.', category: 'Ivy League', isAtsOptimized: true, tags: ['Ivy League Standard', 'Top ATS Match', 'Finance & Tech', 'High Density']),
    ResumeTemplateModel(id: 'ats_tech_minimal', name: 'Silicon Valley Tech ATS', description: 'FAANG & Silicon Valley engineering standard.', category: 'Tech & FAANG', isAtsOptimized: true, tags: ['Software Engineers', 'Skills Matrix', 'GitHub Links', 'FAANG Standard']),
    ResumeTemplateModel(id: 'ats_modern_clean', name: 'Modern Clean Minimalist ATS', description: 'Contemporary slate aesthetic with subtle section accents.', category: 'Modern Clean', isAtsOptimized: true, tags: ['Clean Slate', 'High Scannability', 'Modern Tech', 'Universal Pass']),
    ResumeTemplateModel(id: 'ats_executive', name: 'Executive Leadership & C-Suite', description: 'Outcome-driven executive format.', category: 'Executive', isAtsOptimized: true, tags: ['Executive & VP', 'Milestone Driven', 'Core Competencies', 'Strategic Roles']),
    ResumeTemplateModel(id: 'ats_data_fintech', name: 'Quant, Data & FinTech ATS', description: 'High-density layout for quants and data scientists.', category: 'FinTech & Quant', isAtsOptimized: true, tags: ['FinTech & Banking', 'Data Science', 'KPI Focused', 'Quant Ready']),
    ResumeTemplateModel(id: 'ats_compact', name: 'Compact 1-Page High-Density', description: 'Precision-engineered single-page format.', category: '1-Page Compact', isAtsOptimized: true, tags: ['1-Page Guaranteed', 'Recruiter Favorite', 'Dense Layout', 'Fast Parser']),
    ResumeTemplateModel(id: 'ats_stanford', name: 'Stanford Academic & Research', description: 'Academic research layout highlighting publications.', category: 'Academic', isAtsOptimized: true, tags: ['Research & PhD', 'Publications', 'Grant Awards', 'Academic Standard']),
    ResumeTemplateModel(id: 'ats_professional', name: 'Corporate Professional ATS', description: 'Modern corporate aesthetic with refined typography.', category: 'Corporate', isAtsOptimized: true, tags: ['Corporate', 'Divider Accents', 'Clear Hierarchy', 'Leadership']),
    ResumeTemplateModel(id: 'ats_fresher', name: 'ATS Fresher & Early Career', description: 'Focused layout highlighting education and internships.', category: 'Fresher', isAtsOptimized: true, tags: ['Entry-Level', 'Education Focus', 'Skills-First', 'Campus Hiring']),
    ResumeTemplateModel(id: 'ats_experienced', name: 'Senior Career Progression ATS', description: 'Chronological multi-role career history format.', category: 'Experienced', isAtsOptimized: true, tags: ['Senior Level', 'Impact-Driven', 'Career Growth', 'Multi-role']),
    ResumeTemplateModel(id: 'ats_classic', name: 'ATS Classic Universal', description: 'Timeless single-column layout for all industries.', category: 'Classic', isAtsOptimized: true, tags: ['Single Column', 'Universal', 'Standard Margins', '99.9% ATS Pass']),
  ];

  @override
  Future<List<ResumeTemplateModel>> getTemplates() async {
    if (dioClient == null) return _localTemplates;
    try {
      final response = await dioClient!.get(BackendConfig.templates);
      final data = response.data as Map<String, dynamic>;
      final list = data['data'] as List<dynamic>;
      return list.map((e) => ResumeTemplateModel.fromJson(e as Map<String, dynamic>)).toList();
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<ResumeTemplateModel> getTemplateById(String id) async {
    if (dioClient == null) {
      return _localTemplates.firstWhere((t) => t.id == id, orElse: () => _localTemplates.first);
    }
    try {
      final response = await dioClient!.get(BackendConfig.templateById(id));
      final data = response.data as Map<String, dynamic>;
      return ResumeTemplateModel.fromJson(data['data'] as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    }
  }
}
