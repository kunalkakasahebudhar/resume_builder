import 'package:frontend_userside/core/network/dio_client.dart';
import 'package:frontend_userside/features/user/templates/data/models/resume_template_model.dart';

abstract class TemplateRemoteDataSource {
  Future<List<ResumeTemplateModel>> getTemplates();
  Future<ResumeTemplateModel> getTemplateById(String id);
}

class TemplateRemoteDataSourceImpl implements TemplateRemoteDataSource {
  final DioClient? dioClient;

  TemplateRemoteDataSourceImpl({this.dioClient});

  static const List<ResumeTemplateModel> _mockTemplates = [
    ResumeTemplateModel(
      id: 'ats_classic',
      name: 'ATS Classic',
      description:
          'Timeless single-column layout with clean standard serif/sans headings, perfect for all industries and strict parser engines.',
      category: 'ATS Classic',
      isAtsOptimized: true,
      tags: [
        'Single Column',
        'Universal',
        'Standard Margins',
        'High ATS Match',
      ],
    ),
    ResumeTemplateModel(
      id: 'ats_professional',
      name: 'ATS Professional',
      description:
          'Modern corporate aesthetic featuring refined typography, clear dividers, and optimized section spacing for mid-senior roles.',
      category: 'ATS Professional',
      isAtsOptimized: true,
      tags: ['Corporate', 'Divider Accents', 'Clear Hierarchy', 'Leadership'],
    ),
    ResumeTemplateModel(
      id: 'ats_fresher',
      name: 'ATS Fresher',
      description:
          'Focused layout highlighting education, academic projects, technical skill categories, and certifications for new graduates.',
      category: 'ATS Fresher',
      isAtsOptimized: true,
      tags: ['Entry-Level', 'Education Focus', 'Skills-First', 'Campus Hiring'],
    ),
    ResumeTemplateModel(
      id: 'ats_experienced',
      name: 'ATS Experienced',
      description:
          'Outcome-driven format engineered for showcasing rich career progression, leadership achievements, and quantifiable results.',
      category: 'ATS Experienced',
      isAtsOptimized: true,
      tags: [
        'Senior Level',
        'Impact-Driven',
        'Quantifiable Bullets',
        'Multi-role',
      ],
    ),
  ];

  @override
  Future<List<ResumeTemplateModel>> getTemplates() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _mockTemplates;
  }

  @override
  Future<ResumeTemplateModel> getTemplateById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _mockTemplates.firstWhere(
      (t) => t.id == id,
      orElse: () => _mockTemplates.first,
    );
  }
}
