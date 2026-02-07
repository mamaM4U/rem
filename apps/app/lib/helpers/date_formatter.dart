import 'package:intl/intl.dart';

String formatDate(DateTime date, {String dateFormat = 'd MMMM y'}) {
  final DateFormat formatter = DateFormat(dateFormat);
  return formatter.format(date.toLocal());
}
