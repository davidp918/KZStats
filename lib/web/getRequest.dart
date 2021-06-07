import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:kzstats/web/json/globalApiBans_json.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:kzstats/web/json/record_json.dart';
import 'package:kzstats/web/urls.dart';

Future getRequest(String url, Function fromjson) async {
  dynamic res;
  try {
    var response = await http.get(Uri.parse(url));
    response.statusCode == HttpStatus.ok
        ? res = fromjson(response.body)
        : print('request failed');
  } catch (exception) {
    throw UnimplementedError();
  }
  if (res is List && res.length == 0) return [];
  return res;
}

Future<List<MapInfo>> getMaps(
    int limit, int offset, Function fromjson, int tier) async {
  List<MapInfo> res = [];
  try {
    var response = await http.get(
      Uri.parse(globalApiAllMaps(limit, offset, tier)),
    );
    response.statusCode == HttpStatus.ok
        ? res = fromjson(response.body)
        : print('request failed');
  } catch (exception) {
    throw ('get map exceptions: $exception');
  }
  return res;
}

Future<List<Ban>> getBans(int limit, int offset, Function fromjson) async {
  List<Ban> res = [];
  try {
    var response = await http.get(
      Uri.parse(globalApiBans(limit, offset)),
    );
    response.statusCode == HttpStatus.ok
        ? res = fromjson(response.body)
        : print('request failed');
  } catch (exception) {
    throw UnimplementedError();
  }
  return res;
}

Future<List<Record>> getPlayerRecords(
    bool ifNub, int limit, String steamid64, String? mode, bool onlyTop) async {
  List<Record> res = [];
  try {
    var response = await http.get(
      Uri.parse(
          globalApiPlayerRecordsUrl(ifNub, limit, steamid64, mode, onlyTop)),
    );
    // print('$steamid64 all records: ${response.body}');
    response.statusCode == HttpStatus.ok
        ? res = recordFromJson(response.body)
        : print('request failed');
  } catch (exception) {
    throw UnimplementedError();
  }
  return res;
}
