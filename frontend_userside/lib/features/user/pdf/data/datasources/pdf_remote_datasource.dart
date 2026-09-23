import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:frontend_userside/config/backend_config.dart';
import 'package:frontend_userside/core/error/exceptions.dart';
import 'package:frontend_userside/core/network/dio_client.dart';

abstract class PdfRemoteDataSource {
  Future<Uint8List> generatePdf(String resumeId);
  Future<void> downloadPdf(String resumeId, String filename);
}

class PdfRemoteDataSourceImpl implements PdfRemoteDataSource {
  final DioClient dioClient;

  PdfRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Uint8List> generatePdf(String resumeId) async {
    try {
      final response = await dioClient.get<List<int>>(
        BackendConfig.pdf(resumeId),
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data ?? []);
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<void> downloadPdf(String resumeId, String filename) async {
    await generatePdf(resumeId);
  }
}
