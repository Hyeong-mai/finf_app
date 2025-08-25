import 'package:intl/intl.dart';

class DateUtil {
  static String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('yy.MM.dd').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
