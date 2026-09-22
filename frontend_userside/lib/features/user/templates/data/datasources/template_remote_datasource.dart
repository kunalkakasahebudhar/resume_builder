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
      id: 'ats_harvard',
      name: 'Harvard Ivy League ATS',
      description:
          'Gold standard Ivy League academic & corporate format featuring bold capitalized headers, full-width section dividers, and high-density content layout.',
      category: 'Ivy League',
      isAtsOptimized: true,
      tags: [
        'Ivy League Standard',
        'Top ATS Match',
        'Finance & Tech',
        'High Density',
      ],
    ),
    ResumeTemplateModel(
      id: 'ats_tech_minimal',
      name: 'Silicon Valley Tech ATS',
      description:
          'FAANG & Silicon Valley engineering standard with categorized skill matrix (Languages, Frameworks, Cloud, Databases) and bulleted technical accomplishments.',
      category: 'Tech & FAANG',
      isAtsOptimized: true,
      tags: [
        'Software Engineers',
        'Skills Matrix',
        'GitHub Links',
        'FAANG Standard',
      ],
    ),
    ResumeTemplateModel(
      id: 'ats_modern_clean',
      name: 'Modern Clean Minimalist ATS',
      description:
          'Contemporary slate aesthetic with subtle section accents, crisp typography, and optimal scannability for fast recruiter review.',
      category: 'Modern Clean',
      isAtsOptimized: true,
      tags: [
        'Clean Slate',
        'High Scannability',
        'Modern Tech',
        'Universal Pass',
      ],
    ),
    ResumeTemplateModel(
      id: 'ats_executive',
      name: 'Executive Leadership & C-Suite',
      description:
          'Outcome-driven executive format featuring an Executive Profile highlight box, Core Competencies matrix, and multi-million dollar career milestones.',
      category: 'Executive',
      isAtsOptimized: true,
      tags: [
        'Executive & VP',
        'Milestone Driven',
        'Core Competencies',
        'Strategic Roles',
      ],
    ),
    ResumeTemplateModel(
      id: 'ats_data_fintech',
      name: 'Quant, Data & FinTech ATS',
      description:
          'High-density layout designed for quants, data scientists, and investment analysts with KPI metrics focus and modeling tool sections.',
      category: 'FinTech & Quant',
      isAtsOptimized: true,
      tags: [
        'FinTech & Banking',
        'Data Science',
        'KPI Focused',
        'Quant Ready',
      ],
    ),
    ResumeTemplateModel(
      id: 'ats_compact',
      name: 'Compact 1-Page High-Density',
      description:
          'Precision-engineered single-page format with optimized line heights and compact metadata, ensuring 100% fit on a single A4 page.',
      category: '1-Page Compact',
      isAtsOptimized: true,
      tags: [
        '1-Page Guaranteed',
        'Recruiter Favorite',
        'Dense Layout',
        'Fast Parser',
      ],
    ),
    ResumeTemplateModel(
      id: 'ats_stanford',
      name: 'Stanford Academic & Research',
      description:
          'Academic research layout highlighting publications, grant awards, peer-reviewed papers, teaching experience, and research methodologies.',
      category: 'Academic',
      isAtsOptimized: true,
      tags: [
        'Research & PhD',
        'Publications',
        'Grant Awards',
        'Academic Standard',
      ],
    ),
    ResumeTemplateModel(
      id: 'ats_professional',
      name: 'Corporate Professional ATS',
      description:
          'Modern corporate aesthetic featuring refined typography, navy divider accents, and optimized section spacing for mid-senior management roles.',
      category: 'Corporate',
      isAtsOptimized: true,
      tags: ['Corporate', 'Divider Accents', 'Clear Hierarchy', 'Leadership'],
    ),
    ResumeTemplateModel(
      id: 'ats_fresher',
      name: 'ATS Fresher & Early Career',
      description:
          'Focused layout highlighting education, academic coursework, verified skill badges, university projects, and internships for new graduates.',
      category: 'Fresher',
      isAtsOptimized: true,
      tags: ['Entry-Level', 'Education Focus', 'Skills-First', 'Campus Hiring'],
    ),
    ResumeTemplateModel(
      id: 'ats_experienced',
      name: 'Senior Career Progression ATS',
      description:
          'Chronological multi-role career history format engineered for showcasing promotions, leadership responsibilities, and metric-based business impact.',
      category: 'Experienced',
      isAtsOptimized: true,
      tags: [
        'Senior Level',
        'Impact-Driven',
        'Career Growth',
        'Multi-role',
      ],
    ),
    ResumeTemplateModel(
      id: 'ats_classic',
      name: 'ATS Classic Universal',
      description:
          'Timeless single-column layout with clean standard serif/sans headings, perfect for all traditional industries and strict legacy parser engines.',
      category: 'Classic',
      isAtsOptimized: true,
      tags: [
        'Single Column',
        'Universal',
        'Standard Margins',
        '99.9% ATS Pass',
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
