import 'package:frontend_userside/config/backend_config.dart';
import 'package:frontend_userside/core/error/exceptions.dart';
import 'package:frontend_userside/core/network/dio_client.dart';
import 'package:frontend_userside/features/user/resume/data/models/resume_model.dart';

abstract class ResumeRemoteDataSource {
  Future<List<ResumeModel>> getResumes();
  Future<ResumeModel> getResumeById(String id);
  Future<ResumeModel> createResume({required String title, String? templateId});
  Future<ResumeModel> updateResume(ResumeModel resume);
  Future<void> deleteResume(String id);
  Future<ResumeModel> duplicateResume(String id);
  Future<ResumeModel> renameResume(String id, String newTitle);
}

class ResumeRemoteDataSourceImpl implements ResumeRemoteDataSource {
  final DioClient dioClient;

  ResumeRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<ResumeModel>> getResumes() async {
    try {
      final response = await dioClient.get(BackendConfig.resumes);
      final data = response.data as Map<String, dynamic>;
      final list = data['data'] as List<dynamic>;
      return list.map((e) => ResumeModel.fromJson(e as Map<String, dynamic>)).toList();
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<ResumeModel> getResumeById(String id) async {
    try {
      final response = await dioClient.get(BackendConfig.resumeById(id));
      final data = response.data as Map<String, dynamic>;
      return ResumeModel.fromJson(data['data'] as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<ResumeModel> createResume({required String title, String? templateId}) async {
    try {
      final response = await dioClient.post(
        BackendConfig.resumes,
        data: {'title': title, if (templateId != null) 'template_id': templateId},
      );
      final data = response.data as Map<String, dynamic>;
      return ResumeModel.fromJson(data['data'] as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<ResumeModel> updateResume(ResumeModel resume) async {
    try {
      final response = await dioClient.put(
        BackendConfig.resumeById(resume.id),
        data: resume.toJson(),
      );
      final data = response.data as Map<String, dynamic>;
      return ResumeModel.fromJson(data['data'] as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<void> deleteResume(String id) async {
    try {
      await dioClient.delete(BackendConfig.resumeById(id));
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<ResumeModel> duplicateResume(String id) async {
    try {
      final response = await dioClient.post(BackendConfig.duplicateResume(id));
      final data = response.data as Map<String, dynamic>;
      return ResumeModel.fromJson(data['data'] as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<ResumeModel> renameResume(String id, String newTitle) async {
    try {
      final response = await dioClient.put(
        BackendConfig.resumeById(id),
        data: {'title': newTitle},
      );
      final data = response.data as Map<String, dynamic>;
      return ResumeModel.fromJson(data['data'] as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    }
  }
}
