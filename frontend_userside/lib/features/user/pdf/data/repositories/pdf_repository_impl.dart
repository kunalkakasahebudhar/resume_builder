import 'dart:typed_data';
import 'package:frontend_userside/features/user/pdf/data/datasources/pdf_remote_datasource.dart';
import 'package:frontend_userside/features/user/pdf/domain/repositories/pdf_repository.dart';

class PdfRepositoryImpl implements PdfRepository {
  final PdfRemoteDataSource remoteDataSource;

  PdfRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Uint8List> generatePdf(String resumeId) async {
    return await remoteDataSource.generatePdf(resumeId);
  }

  @override
  Future<void> downloadPdf(String resumeId, String filename) async {
    await remoteDataSource.downloadPdf(resumeId, filename);
  }
}
