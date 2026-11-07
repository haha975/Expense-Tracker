
import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final NumberFormat _currency = NumberFormat.currency(
    symbol: r'$',
    decimalDigits: 2,
  );

  static final DateFormat _displayDate = DateFormat('MMM d, y');
  static final DateFormat _displayDateTime =
      DateFormat('MMM d, y • h:mm a');

  static String currency(num value) => _currency.format(value);

  static String date(DateTime value) => _displayDate.format(value);

  static String dateTime(DateTime value) =>
      _displayDateTime.format(value);
}
