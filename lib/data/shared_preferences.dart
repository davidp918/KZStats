import 'dart:convert';

import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kzstats/global/userInfo_class.dart';

class UserSharedPreferences {
  static late SharedPreferences _preferences;

  static const _userInfo = 'userInfo';
  static const _rowsPerPage = 'rowsPerPage';
  static const _mapData = 'mapData';
  static const _history = 'history';
  static const _tierMap = 'tierMapping';
  static const _tierCount = 'tierCount';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
    updateMapData();
  }

  // User settings
  static Future setUserInfo(UserInfo userInfo) async {
    await _preferences.setString(_userInfo, jsonEncode(userInfo.toJson()));
  }

  static UserInfo getUserInfo() {
    dynamic data = _preferences.getString(_userInfo);
    if (data == null) {
      return UserInfo(steam32: '', steam64: '', avatarUrl: '', name: '');
    }
    return UserInfo.fromJson(jsonDecode(data));
  }

  // DataTable row settigns
  static Future setRowsPerPage(int rowsPerPage) async {
    await _preferences.setInt(_rowsPerPage, rowsPerPage);
  }

  static int getRowsPerPage() {
    dynamic data = _preferences.getInt(_rowsPerPage);
    return data == null ? 20 : data;
  }

  // Maps Data
  static void updateMapData() async {
    // first check if need to update by:
    // 1. local is null?
    // 2. if local is null then ofcourse write,
    // 3. if not, check if it is outdated by
    dynamic prev = getMapData();
    if (prev == null) {
      updateAllMapData();
      return;
    }
    int prevLength = prev.length;
    List<MapInfo>? check =
        await getMaps(1, prevLength, multiMapInfoFromJson, 0);
    if (check != null || check == []) updateAllMapData();
  }

  static void updateAllMapData() async {
    List<MapInfo>? allMaps = await getMaps(9999, 0, multiMapInfoFromJson, 0);
    if (allMaps == null) return;
    setMapTierInfo(allMaps);
    allMaps.sort((a, b) => a.mapId!.compareTo(b.mapId!));
    await _preferences.setString(_mapData, multiMapInfoToJson(allMaps));
  }

  static void setMapTierInfo(List<MapInfo> data) async {
    final Map<String, int> tierMap = {};
    final List<int> tierCountInt = [0, 0, 0, 0, 0, 0, 0];
    for (MapInfo each in data) {
      tierMap[each.mapName!] = each.difficulty!;
      tierCountInt[each.difficulty! - 1] += 1;
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

  static List<MapInfo>? getMapData() {
    // sort by mapId, starting from 200, ascending?
    dynamic data = _preferences.getString(_mapData);
    if (data == null) return null;
    return multiMapInfoFromJson(data);
  }

  // search history
  static Future updateHistory(MapInfo newHistory) async {
    var old = getHistory();
    if (old.any((element) => element.mapName == newHistory.mapName))
      old.removeWhere((element) => element.mapName! == newHistory.mapName!);
    old.insert(0, newHistory);
    if (old.length > 20) old.removeAt(20);
    await _preferences.setString(_history, multiMapInfoToJson(old));
  }

  static List<MapInfo> getHistory() {
    dynamic data = _preferences.getString(_history);
    return data == null ? [] : multiMapInfoFromJson(data);
  }

  static Future clearHistory() async {
    await _preferences.remove(_history);
  }
}
