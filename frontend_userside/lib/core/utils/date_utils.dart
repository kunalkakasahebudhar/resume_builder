import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate(DateTime? date, {String format = 'MMM yyyy'}) {
    if (date == null) return '';
    return DateFormat(format).format(date);
  }

  static String formatDateRange(
    DateTime? start,
    DateTime? end, {
    bool isPresent = false,
  }) {
    if (start == null && end == null) return '';
    final startStr = start != null ? DateFormat('MMM yyyy').format(start) : '';
    if (isPresent) {
      return '$startStr - Present';
    }
    final endStr = end != null ? DateFormat('MMM yyyy').format(end) : 'Present';
    return '$startStr - $endStr';
  }

  static String timeAgo(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return DateFormat('dd MMM yyyy').format(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hr' : 'hrs'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'min' : 'mins'} ago';
    } else {
      return 'Just now';
    }
  }
}
