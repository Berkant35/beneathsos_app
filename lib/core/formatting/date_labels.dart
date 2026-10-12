import 'package:intl/intl.dart';

/// "Oct 12, 14:05" / "12 Eki, 14:05" — a day and a 24-hour time in [locale].
String dayAndTime(DateTime when, String locale) =>
    '${DateFormat.MMMd(locale).format(when)}, '
    '${DateFormat.Hm(locale).format(when)}';
