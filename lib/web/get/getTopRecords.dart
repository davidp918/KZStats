import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kzstats/web/json/record_json.dart';

import 'package:kzstats/web/urls.dart';

List<Wr> topRecords;

Future<List<Wr>> getTopRecords(
  String mode,
  bool ifNub,
  int amount,
) async {
  try {
    var response = await http.get(
      Uri.parse(globalApiWrRecordsUrl(mode, ifNub, amount)),
    );
    response.statusCode == HttpStatus.ok
        ? topRecords = wrFromJson(response.body)
        : print('something wrong');
  } catch (exception) {}
  return topRecords;
}
