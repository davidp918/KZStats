import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static SharedPreferences? _preferences;

  static const _steam32Id = 'steam32Id';
  static const _steam64Id = 'steam64Id';
  static const _name = 'name';
  static const _avatar = 'avatar';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setSteam64Id(String id) async =>
      await _preferences?.setString(_steam64Id, id);

  static Future setSteam32Id(String id) async =>
      await _preferences?.setString(_steam32Id, id);

  static Future setAvatar(String avatar) async =>
      await _preferences?.setString(_avatar, avatar);

  static Future setName(String name) async =>
      await _preferences?.setString(_name, name);

  static String? getSteam64() => _preferences?.getString(_steam64Id);

  static String? getSteam32() => _preferences?.getString(_steam32Id);

  static String? getAvatar() => _preferences?.getString(_avatar);

  static String? getName() => _preferences?.getString(_name);
}
