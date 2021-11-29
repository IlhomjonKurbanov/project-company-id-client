import 'package:date_format/date_format.dart';

mixin AppConverters {
  static String dateFromString(String strDate) {
    final DateTime todayDate = DateTime.parse(strDate);
    return formatDate(todayDate, <String>[dd, '/', mm, '/', yyyy]);
  }

  static String monthYearFromDate(DateTime date) {
    return formatDate(date, <String>[MM, ' ', yyyy]);
  }

  static String countYearMonth(DateTime date) {
    final DateTime now = DateTime.now();
    final int totalDays = now.difference(date).inDays;
    final int years = totalDays ~/ 365;
    final int months = (totalDays - years * 365) ~/ 30;
    final int days = totalDays - years * 365 - months * 30;
    String result = '';
    if (years > 0) {
      result += '$years years ';
    }
    if (months > 0) {
      result += '$months months ';
    }
    if (months <= 0 && years <= 0) {
      result = '$days days';
    }
    return result;
  }
}
