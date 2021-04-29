import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static SharedPreferences? _preferences;

  static const _steam32Id = 'steam32Id';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setSteam32Id(String id) async =>
      await _preferences?.setString(_steam32Id, id);

  static String? getSteam32Id() => _preferences?.getString(_steam32Id);
}
