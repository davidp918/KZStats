import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:kzstats/utils/emptyListNull.dart';
import 'package:kzstats/web/json/globalApiBans_json.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:kzstats/web/urls.dart';

Future getRequest(String url, Function fromjson) async {
  dynamic res;
  try {
    var response = await http.get(
      Uri.parse(url),
    );
    response.statusCode == HttpStatus.ok
        ? res = fromjson(response.body)
        : print('something wrong');
  } catch (exception) {
    throw UnimplementedError();
  }
  if (res is List) return ifEmptyListReNull(res);
  // may need to perform null replace check for
  // other data types
  return res;
}

Future<List<MapInfo>?> getMaps(
    int limit, int offset, Function fromjson, int tier) async {
  dynamic res;
  try {
    var response = await http.get(
      Uri.parse(globalApiAllMaps(limit, offset, tier)),
    );
    response.statusCode == HttpStatus.ok
        ? res = fromjson(response.body)
        : print('something wrong');
  } catch (exception) {
    throw ('get map exceptions: $exception');
  }
  if (res is List) {
    return ifEmptyListReNull(res);
  }
  return res;
}

Future<List<MapInfo>> getAMaps(
    int limit, int offset, Function fromjson, int tier) async {
  dynamic res;
  try {
    var response = await http.get(
      Uri.parse(globalApiAllMaps(limit, offset, tier)),
    );
    response.statusCode == HttpStatus.ok
        ? res = fromjson(response.body)
        : print('something wrong');
  } catch (exception) {
    throw ('get map exceptions: $exception');
  }
  if (res is List) {
    return ifEmptyListReNull(res);
  }
  return res;
}

Future<List<Ban>> getBans(int limit, int offset, Function fromjson) async {
  dynamic res;
  try {
    var response = await http.get(
      Uri.parse(globalApiBans(limit, offset)),
    );
    response.statusCode == HttpStatus.ok
        ? res = fromjson(response.body)
        : print('something wrong');
  } catch (exception) {
    throw UnimplementedError();
  }
  if (res is List) {
    return ifEmptyListReNull(res);
  }
  return res;
}
