import 'package:date_format/date_format.dart';

mixin AppConverters {
  static String dateFromString(String strDate) {
    final DateTime todayDate = DateTime.parse(strDate);
    return formatDate(todayDate, <String>[dd, '/', mm, '/', yyyy]);
  }

  static String monthYearFromDate(DateTime date) {
    return formatDate(date, <String>[MM, ' ', yyyy]);
  }
}
