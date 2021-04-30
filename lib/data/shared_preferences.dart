import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static SharedPreferences? _preferences;

  static const _steam64Id = 'steam64Id';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setSteam32Id(String id) async =>
      await _preferences?.setString(_steam64Id, id);

  static String? getSteam64() => _preferences?.getString(_steam64Id);
}
