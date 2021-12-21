import 'package:intl/intl.dart';

/*
  Credit this Screen
  intl => https://pub.dev/packages/intl
*/

String dateConverter(int time) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);

  return DateFormat('dd MMM yyyy').format(dateTime);
}
