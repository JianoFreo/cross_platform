import 'package:intl/intl.dart';

class MyDateUtils {
  static String formatDateTime(DateTime date) {
    return DateFormat.yMd().add_jm().format(date);
  }

  static String formatDate(DateTime date) {
    return DateFormat.yMd().format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat.jm().format(date);
  }
}