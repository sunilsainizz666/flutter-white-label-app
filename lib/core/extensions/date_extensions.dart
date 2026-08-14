import '../utils/date_utils.dart';

extension DateTimeExtensions on DateTime {
  String get shortDate => AppDateUtils.formatShort(this);
  String get longDate => AppDateUtils.formatLong(this);
  String get timeOnly => AppDateUtils.formatTime(this);
  String get dateTime => AppDateUtils.formatDateTime(this);
  String get timeAgo => AppDateUtils.timeAgo(this);

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final y = DateTime.now().subtract(const Duration(days: 1));
    return year == y.year && month == y.month && day == y.day;
  }
}
