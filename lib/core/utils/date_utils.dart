import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static final DateFormat _short = DateFormat('MMM d, yyyy');
  static final DateFormat _long = DateFormat('EEEE, MMM d, yyyy');
  static final DateFormat _time = DateFormat('h:mm a');
  static final DateFormat _dateTime = DateFormat('MMM d, yyyy h:mm a');

  static String formatShort(DateTime date) => _short.format(date);
  static String formatLong(DateTime date) => _long.format(date);
  static String formatTime(DateTime date) => _time.format(date);
  static String formatDateTime(DateTime date) => _dateTime.format(date);

  static String timeAgo(DateTime date, {DateTime? now}) {
    final n = now ?? DateTime.now();
    final diff = n.difference(date);

    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    }
    if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    }
    if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    }
    final years = (diff.inDays / 365).floor();
    return '$years year${years == 1 ? '' : 's'} ago';
  }

  static DateTime? tryParseIso(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }
}
