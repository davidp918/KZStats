import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:kzstats/web/urls.dart';
import '../model/kzjson.dart';

List<KzTime> result;

Future<List<KzTime>> getTopRecords(String currentMode) async {
  try {
    var response = await http.get(Uri.parse(
      currentMode == 'Kztimer'
          ? kz_timerTopRecords
          : currentMode == 'SimpleKZ'
              ? kz_simpleTopRecords
              : kz_vanillaTopRecords,
    ));
    response.statusCode == HttpStatus.ok
        ? result = kzInfoFromJson(response.body)
        : print('something wrong');
  } catch (exception) {}

  return result;
}
