import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatDateTime(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
  }

  static String timeAgo(DateTime? date) {
    if (date == null) return '-';
    final duration = DateTime.now().difference(date);
    if (duration.inDays > 365) {
      return '${(duration.inDays / 365).floor()}y ago';
    } else if (duration.inDays > 30) {
      return '${(duration.inDays / 30).floor()}mo ago';
    } else if (duration.inDays > 0) {
      return '${duration.inDays}d ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
