import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:kzstats/web/json/globalApiBans_json.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:kzstats/web/json/record_json.dart';
import 'package:kzstats/web/urls.dart';

Future getRequest(String url, Function fromjson) async {
  dynamic res;
  try {
    var response = await retry(
      () => http.get(Uri.parse(url)),
      maxAttempts: 9999,
      retryIf: (e) => e is SocketException || e is TimeoutException,
      onRetry: (e) => print('$e: retrying..'),
    );
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
  String url = globalApiAllMaps(limit, offset, tier);
  try {
    var response = await retry(
      () => http.get(Uri.parse(url)),
      maxAttempts: 9999,
      retryIf: (e) => e is SocketException || e is TimeoutException,
      onRetry: (e) => print('$e: retrying..'),
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
  String url = globalApiBans(limit, offset);
  try {
    var response = await retry(
      () => http.get(Uri.parse(url)),
      maxAttempts: 9999,
      retryIf: (e) => e is SocketException || e is TimeoutException,
      onRetry: (e) => print('$e: retrying..'),
    );
    response.statusCode == HttpStatus.ok
        ? res = fromjson(response.body)
        : print('request failed');
  } catch (exception) {
    throw UnimplementedError();
  }
  return res;
}

Future<List<Record>> getRecentRecords(
    bool ifNub, int limit, String steamid64, String? mode, bool onlyTop) async {
  List<Record> res = [];
  String url = globalApiRecentRecordsUrl(ifNub, limit, steamid64, mode);
  print(url);
  try {
    var response = await retry(
      () => http.get(Uri.parse(url)),
      maxAttempts: 9999,
      retryIf: (e) => e is SocketException || e is TimeoutException,
      onRetry: (e) => print('$e: retrying..'),
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

Future<List<Record>> getTopRecords(
    bool ifNub, int limit, String steamid64, String? mode) async {
  List<Record> res = [];
  String url = globalApiTopRecordsUrl(
      ifNub: ifNub, limit: limit, steamid64: steamid64, mode: mode);
  print(url);
  try {
    var response = await retry(
      () => http.get(Uri.parse(url)),
      maxAttempts: 9999,
      retryIf: (e) => e is SocketException || e is TimeoutException,
      onRetry: (e) => print('$e: retrying..'),
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
