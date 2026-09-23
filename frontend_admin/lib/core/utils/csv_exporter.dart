class CsvExporter {
  static String generateCsv({
    required List<String> headers,
    required List<List<dynamic>> rows,
  }) {
    final buffer = StringBuffer();
    // Headers
    buffer.writeln(headers.map((h) => _escape(h)).join(','));

    // Rows
    for (final row in rows) {
      buffer.writeln(row.map((cell) => _escape(cell?.toString() ?? '')).join(','));
    }

    return buffer.toString();
  }

  static String exportToCsv({
    required String fileName,
    required List<Map<String, dynamic>> data,
  }) {
    if (data.isEmpty) return '';
    final headers = data.first.keys.toList();
    final rows =
        data.map((map) => headers.map((h) => map[h]).toList()).toList();
    return generateCsv(headers: headers, rows: rows);
  }

  static String _escape(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
