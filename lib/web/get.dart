import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:kzstats/web/urls.dart';
import '../model/kzjson.dart';

List<KzTime> result;

Future<List<KzTime>> gettimerTopRecords() async {
  try {
    var response = await http.get(Uri.parse(kz_timerTopRecords));
    response.statusCode == HttpStatus.ok
        ? result = kzInfoFromJson(response.body)
        : print('something wrong');
  } catch (exception) {}

  return result;
}
