import 'package:intl/intl.dart';

String dateConverter(int time) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);

  return DateFormat('dd MMM yyyy').format(dateTime);
}
