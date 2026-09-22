import 'package:frontend_admin/core/constants/api_constants.dart';
import 'package:frontend_admin/core/network/api_client.dart';
import 'package:frontend_admin/features/admin/resumes/data/models/admin_resume_model.dart';

abstract class AdminResumeRemoteDataSource {
  Future<List<AdminResumeModel>> getResumes();
  Future<AdminResumeModel> getResumeById(String id);
  Future<void> deleteResume(String id);
}

class AdminResumeRemoteDataSourceImpl implements AdminResumeRemoteDataSource {
  final ApiClient apiClient;

  final List<AdminResumeModel> _mockResumes = [
    AdminResumeModel(
      id: 'res_201',
      resumeName: 'Senior_FullStack_Resume.pdf',
      userName: 'Rohan Sharma',
      userEmail: 'rohan.sharma@example.com',
      templateName: 'ATS Classic',
      atsScore: 92,
      targetRole: 'Full Stack Engineer',
      createdAt: DateTime(2026, 8, 12, 15, 0),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    AdminResumeModel(
      id: 'res_202',
      resumeName: 'Lead_PM_Resume.pdf',
      userName: 'Priya Patel',
      templateName: 'ATS Professional',
      atsScore: 86,
      userEmail: 'priya.patel@example.com',
      targetRole: 'Lead Product Manager',
      createdAt: DateTime(2026, 7, 24, 11, 0),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 35)),
    ),
    AdminResumeModel(
      id: 'res_203',
      resumeName: 'Junior_DataAnalyst.pdf',
      userName: 'Vikram Singh',
      userEmail: 'vikram.singh@example.com',
      templateName: 'ATS Fresher',
      atsScore: 58,
      targetRole: 'Data Analyst',
      createdAt: DateTime(2026, 6, 11, 17, 0),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    AdminResumeModel(
      id: 'res_204',
      resumeName: 'Cloud_DevOps_2026.pdf',
      userName: 'Ananya Roy',
      userEmail: 'ananya.roy@example.com',
      templateName: 'ATS Experienced',
      atsScore: 94,
      targetRole: 'DevOps Architect',
      createdAt: DateTime(2026, 5, 18, 10, 0),
      updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    AdminResumeModel(
      id: 'res_205',
      resumeName: 'Mobile_Flutter_Resume.pdf',
      userName: 'Sameer Joshi',
      userEmail: 'sameer.j@example.com',
      templateName: 'ATS Professional',
      atsScore: 74,
      targetRole: 'Flutter Engineer',
      createdAt: DateTime(2026, 5, 2, 12, 0),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    AdminResumeModel(
      id: 'res_206',
      resumeName: 'QA_Automation_Eng.pdf',
      userName: 'Kavita Menon',
      userEmail: 'kavita.m@example.com',
      templateName: 'ATS Classic',
      atsScore: 82,
      targetRole: 'QA Automation Lead',
      createdAt: DateTime(2026, 4, 15, 14, 0),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  AdminResumeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<AdminResumeModel>> getResumes() async {
    try {
      final res = await apiClient.get(ApiConstants.resumes);
      if (res.data != null && res.data['data'] != null) {
        final list = res.data['data'] as List;
        return list
            .map((e) => AdminResumeModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return _mockResumes;
    } catch (_) {
      return List.from(_mockResumes);
    }
  }

  @override
  Future<AdminResumeModel> getResumeById(String id) async {
    try {
      final res = await apiClient.get(ApiConstants.resumeDetails(id));
      if (res.data != null && res.data['data'] != null) {
        return AdminResumeModel.fromJson(
          res.data['data'] as Map<String, dynamic>,
        );
      }
      return _mockResumes.firstWhere((r) => r.id == id);
    } catch (_) {
      return _mockResumes.firstWhere(
        (r) => r.id == id,
        orElse: () => _mockResumes.first,
      );
    }
  }

  @override
  Future<void> deleteResume(String id) async {
    try {
      await apiClient.delete(ApiConstants.resumeDetails(id));
    } catch (_) {
      _mockResumes.removeWhere((r) => r.id == id);
    }
  }
}
