import 'dart:typed_data';
import 'package:frontend_userside/core/network/dio_client.dart';

abstract class PdfRemoteDataSource {
  Future<Uint8List> generatePdf(String resumeId);
  Future<void> downloadPdf(String resumeId, String filename);
}

class PdfRemoteDataSourceImpl implements PdfRemoteDataSource {
  final DioClient? dioClient;

  PdfRemoteDataSourceImpl({this.dioClient});

  @override
  Future<Uint8List> generatePdf(String resumeId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Return empty byte array placeholder in phase 1
    return Uint8List(0);
  }

  @override
  Future<void> downloadPdf(String resumeId, String filename) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
