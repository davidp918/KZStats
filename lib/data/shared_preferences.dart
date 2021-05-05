import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:kzstats/global/userInfo_class.dart';

class UserSharedPreferences {
  static late SharedPreferences _preferences;

  static const _userInfo = 'userInfo';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setUserInfo(UserInfo userInfo) async {
    await _preferences.setString(_userInfo, jsonEncode(userInfo.toJson()));
  }

  static UserInfo getUserInfo() {
    dynamic data = _preferences.getString(_userInfo);
    if (data == null) {
      return UserInfo(
        steam32: '',
        steam64: '',
        avatarUrl: '',
        name: '',
      );
    }
    return UserInfo.fromJson(jsonDecode(data));
  }
}
