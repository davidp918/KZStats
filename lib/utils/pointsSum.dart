import 'package:kzstats/web/json/record_json.dart';

int pointsSum(dynamic records) {
  if (records == null) {
    return 0;
  }
  int total = 0;
  for (Record each in records) {
    total += each.points ?? 0;
  }
  return total;
}
