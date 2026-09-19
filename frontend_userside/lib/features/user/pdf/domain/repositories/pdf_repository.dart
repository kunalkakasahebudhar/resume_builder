import 'dart:typed_data';

abstract class PdfRepository {
  Future<Uint8List> generatePdf(String resumeId);
  Future<void> downloadPdf(String resumeId, String filename);
}
