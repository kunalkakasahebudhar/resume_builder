import 'package:frontend_userside/features/user/ats/data/datasources/ats_remote_datasource.dart';
import 'package:frontend_userside/features/user/ats/domain/entities/ats_analysis.dart';
import 'package:frontend_userside/features/user/ats/domain/repositories/ats_repository.dart';

class AtsRepositoryImpl implements AtsRepository {
  final AtsRemoteDataSource remoteDataSource;

  AtsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AtsAnalysis> analyzeResume(String resumeId) async {
    return await remoteDataSource.analyzeResume(resumeId);
  }

  @override
  Future<AtsAnalysis> getAnalysis(String resumeId) async {
    return await remoteDataSource.getAnalysis(resumeId);
  }
}
