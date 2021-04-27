import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kzstats/web/json/mapTop_json.dart';

import 'package:kzstats/web/urls.dart';

List<Record>? records;

Future<List<Record>?> getPlayerRecordsGlobalApi(
  String mode,
  bool ifNub,
  int limit,
  String steamId64,
) async {
  try {
    var response = await http.get(
      Uri.parse(
        globalApiPlayerRecordsUrl(mode, ifNub, limit, steamId64),
      ),
    );
    response.statusCode == HttpStatus.ok
        ? records = mapTopFromJson(response.body)
        : print('something wrong');
  } catch (exception) {
    throw UnimplementedError();
  }

  return records;
}
