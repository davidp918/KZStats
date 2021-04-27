import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:kzstats/others/emptyListNull.dart';

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
