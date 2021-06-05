import 'dart:convert';

import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json/kzstatsApiPlayer_json.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:kzstats/web/json/record_json.dart';
import 'package:kzstats/web/urls.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:kzstats/data/localPlayerClass.dart';

class UserSharedPreferences {
  static late SharedPreferences _preferences;
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  // check first start
  static Future setStarted() async =>
      await _preferences.setBool(_firstStart, false);
  static bool getFirstStart() => _preferences.getBool(_firstStart) ?? true;

  static const _mapData = 'mapData';
  static const _mapHistory = 'mapHistory';
  static const _playerHistory = 'playerHistory';
  static const _tierMap = 'tierMapping';
  static const _tierCount = 'tierCount';
  static const _firstStart = 'firstStart';

  // save player info
  static Future savePlayerInfo(
      String steamid64, KzstatsApiPlayer kzstatsPlayerinfo) async {
    await _preferences.setString(
        '${steamid64}_info', json.encode(kzstatsPlayerinfo.toJson()));
  }

  static Future<KzstatsApiPlayer> getPlayerInfo(String steamid64) async {
    String? data = _preferences.getString('${steamid64}_info');
    if (data == null) {
      KzstatsApiPlayer info = await getRequest(
          kzstatsApiPlayerInfoUrl(steamid64), kzstatsApiPlayerFromJson);
      await savePlayerInfo(steamid64, info);
      return info;
    }
    return KzstatsApiPlayer.fromJson(json.decode(data));
  }

  static KzstatsApiPlayer? readPlayerInfo(String steamid64) {
    String? data = _preferences.getString('${steamid64}_info');
    if (data == null) return null;
    return KzstatsApiPlayer.fromJson(json.decode(data));
  }

  // set player records
  static Future setPlayerRecords(String steamid64, List<Record> records) async {
    await _preferences.setString(
        '${steamid64}_records', multiRecordsToJson(records));
  }

  static List<Record> getPlayerRecords(String steamid64) {
    String? data = _preferences.getString('${steamid64}_records');
    if (data == null) return [];
    return recordFromJson(data);
  }

  // Local Maps Data
  static Future updateMapData() async {
    print('updating local map data...');
    // first check if need to update by:
    // 1. local is null?
    // 2. if local is null then ofcourse write,
    // 3. if not, check if it is outdated by
    List<MapInfo> prev = getMapData();
    if (prev.length == 0) {
      await updateAllMapData();
      return;
    }
    int prevLength = prev.length;
    List<MapInfo> check = await getMaps(1, prevLength, multiMapInfoFromJson, 0);
    if (check.length == 0)
      await updateAllMapData();
    else
      print('No update available');
  }

  static Future updateAllMapData() async {
    print('Downloading map data...');
    List<MapInfo> allMaps = await getMaps(9999, 0, multiMapInfoFromJson, 0);
    if (allMaps.length == 0) return;
    await setMapTierInfo(allMaps);
    allMaps.sort((a, b) => a.mapId.compareTo(b.mapId));
    await _preferences.setString(_mapData, multiMapInfoToJson(allMaps));
    print('Download success');
  }

  static Future deleteMapData() async => await _preferences.remove(_mapData);

  static Future setMapTierInfo(List<MapInfo> data) async {
    final Map<String, int> tierMap = {};
    final List<int> tierCountInt = [0, 0, 0, 0, 0, 0, 0];
    for (MapInfo each in data) {
      tierMap[each.mapName] = each.difficulty;
      tierCountInt[each.difficulty - 1] += 1;
    }
    final List<String> tierCount =
        tierCountInt.map((e) => e.toString()).toList();
    await _preferences.setStringList(_tierCount, tierCount);
    String json = jsonEncode(tierMap);
    await _preferences.setString(_tierMap, json);
  }

  static List<int>? getTierCount() {
    List<String>? data = _preferences.getStringList(_tierCount);
    if (data == null) return null;
    final List<int> tierCountInt = data.map((e) => int.parse(e)).toList();
    return tierCountInt;
  }

  static Map<String, int>? getTierMapping() {
    dynamic data = _preferences.getString(_tierMap);
    if (data == null) return null;
    return new Map<String, int>.from(jsonDecode(data));
  }

  static String test() {
    return _preferences.getString(_tierMap)!;
  }

  static List<MapInfo> getMapData() {
    // sort by mapId, starting from 200, ascending?
    dynamic data = _preferences.getString(_mapData);
    if (data == null) return [];
    return multiMapInfoFromJson(data);
  }

  // search history
  static Future updateMapHistory(MapInfo newHistory) async {
    var old = getSearchMapHistory();
    if (old.any((element) => element.mapName == newHistory.mapName))
      old.removeWhere((element) => element.mapName == newHistory.mapName);
    old.insert(0, newHistory);
    if (old.length > 20) old.removeAt(20);
    await _preferences.setString(_mapHistory, multiMapInfoToJson(old));
  }

  static List<MapInfo> getSearchMapHistory() {
    dynamic data = _preferences.getString(_mapHistory);
    return data == null ? [] : multiMapInfoFromJson(data);
  }

  static Future clearMapHistory() async {
    await _preferences.remove(_mapHistory);
  }

  static Future updatePlayerHistory(LocalPlayer newHistory) async {
    var old = getSearchPlayerHistory();
    if (old.any((element) => element.steamid64 == newHistory.steamid64))
      old.removeWhere((element) => element.steamid64 == newHistory.steamid64);
    old.insert(0, newHistory);
    if (old.length > 20) old.removeAt(20);
    await _preferences.setString(_playerHistory, localPlayerToJson(old));
  }

  static List<LocalPlayer> getSearchPlayerHistory() {
    String? data = _preferences.getString(_playerHistory);
    if (data == null) return [];
    return localPlayerFromJson(data);
  }

  static Future clearPlayerHistory() async {
    await _preferences.remove(_playerHistory);
  }
}
