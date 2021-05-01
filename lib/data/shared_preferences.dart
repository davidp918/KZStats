import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:kzstats/global/userInfo_class.dart';

class UserSharedPreferences {
  static SharedPreferences? _preferences;

  static const _userInfo = 'userInfo';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setUserInfo(UserInfo userInfo) async {
    await _preferences?.setString(_userInfo, jsonEncode(userInfo.toJson()));
  }

  static UserInfo? getUserInfo() {
    dynamic data = _preferences?.getString(_userInfo);
    return data == null ? null : UserInfo.fromJson(jsonDecode(data));
  }
}
