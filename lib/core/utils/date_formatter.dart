import 'package:intl/intl.dart';

class DateFormatter {
  static String formatNoteDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final mins = difference.inMinutes;
      return '$mins ${mins == 1 ? "min" : "mins"} ago';
    } else if (difference.inHours < 24 && now.day == dateTime.day) {
      return DateFormat('h:mm a').format(dateTime);
    } else if (difference.inDays < 7) {
      return DateFormat('EEE, h:mm a').format(dateTime);
    } else if (now.year == dateTime.year) {
      return DateFormat('MMM d').format(dateTime);
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  static String formatFullDate(DateTime dateTime) {
    return DateFormat('MMMM d, yyyy • h:mm a').format(dateTime);
  }

  static String formatBackupDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd_HH-mm-ss').format(dateTime);
  }
}
