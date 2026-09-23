import 'package:frontend_userside/config/backend_config.dart';
import 'package:frontend_userside/core/error/exceptions.dart';
import 'package:frontend_userside/core/network/dio_client.dart';
import 'package:frontend_userside/features/user/ats/data/models/ats_analysis_model.dart';

abstract class AtsRemoteDataSource {
  Future<AtsAnalysisModel> analyzeResume(String resumeId);
  Future<AtsAnalysisModel> getAnalysis(String resumeId);
}

class AtsRemoteDataSourceImpl implements AtsRemoteDataSource {
  final DioClient dioClient;

  AtsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AtsAnalysisModel> analyzeResume(String resumeId) async {
    try {
      final response = await dioClient.post(BackendConfig.atsAnalysis(resumeId));
      final data = response.data as Map<String, dynamic>;
      return AtsAnalysisModel.fromJson(data['data'] as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<AtsAnalysisModel> getAnalysis(String resumeId) async {
    try {
      final response = await dioClient.get(BackendConfig.atsAnalysis(resumeId));
      final data = response.data as Map<String, dynamic>;
      return AtsAnalysisModel.fromJson(data['data'] as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    }
  }
}
