import 'package:intl/intl.dart';

class AppUtils {
  const AppUtils._();

  static final dateFormat = DateFormat('dd MMMM');
  static final timeFormat = DateFormat('HH:mm');
  static final rawDateTimeFormat = DateFormat('ddMMyyHHmmss');
  static final dateTimeRegEx = RegExp(r'(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})');

  static bool isSameDay(DateTime a, DateTime b) => a.day == b.day && a.month == b.month && a.year == b.year;

  static String rawDateTime(DateTime dateTime) => rawDateTimeFormat.format(dateTime);

  static DateTime parseRawDateTime(String raw) {
    final match = dateTimeRegEx.firstMatch(raw)!;
    return DateTime(
      2000 + int.parse(match.group(3)!),
      int.parse(match.group(2)!),
      int.parse(match.group(1)!),
      int.parse(match.group(4)!),
      int.parse(match.group(5)!),
      int.parse(match.group(6)!),
    );
  }

  static String formatDateTime(DateTime dateTime) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    String date;
    if (isSameDay(today, dateTime)) {
      date = 'Сегодня';
    } else if (isSameDay(yesterday, dateTime)) {
      date = 'Вчера';
    } else {
      date = dateFormat.format(dateTime);
    }

    return "$date, ${timeFormat.format(dateTime)}";
  }
}
