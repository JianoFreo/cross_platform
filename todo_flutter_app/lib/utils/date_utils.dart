// lib/utils/date_utils.dart
import 'package:intl/intl.dart';

class MyDateUtils {
  /// Format a DateTime to 'MM/dd/yyyy HH:mm' style
  static String formatDateTime(DateTime date) {
    return DateFormat.yMd().add_jm().format(date);
  }

  /// Format a DateTime to 'MM/dd/yyyy' only
  static String formatDate(DateTime date) {
    return DateFormat.yMd().format(date);
  }

  /// Format a DateTime to 'HH:mm' only
  static String formatTime(DateTime date) {
    return DateFormat.jm().format(date);
  }
}