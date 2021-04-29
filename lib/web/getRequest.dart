import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:kzstats/utils/emptyListNull.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:kzstats/web/urls.dart';

Future<dynamic> getRequest(String url, Function fromjson) async {
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
  if (res is List) {
    return ifEmptyListReNull(res);
  } else {
    // may need to perform null replace check for
    // other data types
    return res;
  }
}

Future<List<MapInfo>> getMaps(
  int limit,
  int offset,
  Function fromjson,
) async {
  dynamic res;
  try {
    var response = await http.get(
      Uri.parse(globalApiAllMaps(limit,offset)),
    );
    response.statusCode == HttpStatus.ok
        ? res = fromjson(response.body)
        : print('something wrong');
  } catch (exception) {
    throw UnimplementedError();
  }
  if (res is List) {
    return ifEmptyListReNull(res);
  } else {
    // may need to perform null replace check for
    // other data types
    return res;
  }
}
