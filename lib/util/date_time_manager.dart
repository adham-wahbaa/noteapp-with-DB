import 'package:timeago/timeago.dart' as timeago;
class DateTimeManager {
  DateTimeManager._();

  static String currentDateTime() {
    final now = DateTime.now();
    return now.toIso8601String();
  }

  static String formateDate(String dateTime){
    final date = DateTime.parse(dateTime);
    return timeago.format(date);
  }
}
