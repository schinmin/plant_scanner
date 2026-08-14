import 'package:intl/intl.dart';

String dateFormat(DateTime? date) {
  DateTime now;
  if (date == null) {
    now = DateTime.now();
    String formattedDate = DateFormat('MMM d yyy').format(now);

    return formattedDate;
  }

  String formattedDate = DateFormat("MMM d yyy").format(date);

  return formattedDate;
}
