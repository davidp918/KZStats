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

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
    await updateMapData();
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
  static Future updateMapData() async {
    List<MapInfo> allMaps = await getMaps(9999, 0, multiMapInfoFromJson, 0);
    dynamic prev = getMapData();
    if (prev == null || prev.length < allMaps.length) {
      await _preferences.setString(_mapData, multiMapInfoToJson(allMaps));
    }
  }

  static dynamic getMapData() {
    dynamic data = _preferences.getString(_mapData);
    return data == null ? null : multiMapInfoFromJson(data);
  }

  // search history
  static Future updateHistory(MapInfo newHistory) async {
    var old = getHistory();
    old.add(newHistory);
    await _preferences.setString(_history, multiMapInfoToJson(old));
  }

  static List<MapInfo> getHistory() {
    dynamic data = _preferences.getString(_history);
    return data == null ? [] : multiMapInfoFromJson(data);
  }
}
