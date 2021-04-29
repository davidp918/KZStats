//import 'package:flutter_native_timezone/flutter_native_timezone.dart';

String toMinSec(double sec) {
  String min = (sec / 60).truncate().toString().padLeft(2, '0');
  String seconds = (sec % 60).toStringAsFixed(3).toString().padLeft(6, '0');
  return ('$min:$seconds');
}

String diffofNow(DateTime timeRecordCreated) {
  //final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  var now = DateTime.now().toUtc();
  var diff = now.difference(timeRecordCreated).inSeconds.toInt();

  List<String> time = [
    'second',
    'minute',
    'hour',
    'day',
    'week',
    'month',
    'year'
  ];

  List<int> limit = [
    60,
    60,
    24,
    7,
    5,
    12,
    9999,
  ];

  for (int i = 0; i <= 6; i++) {
    if (diff == 1) {
      return '1 ${time[i]} ago';
    } else if (diff < limit[i]) {
      return '$diff ${time[i]}s ago';
    }
    diff = (diff / limit[i]).truncate();
  }

  return ('Fatal error');
}
