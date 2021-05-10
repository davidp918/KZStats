import 'dart:convert';

class LocalPlayer {
  // ignore: non_constant_identifier_names
  String player_name;
  String steamid64;

  LocalPlayer({
    // ignore: non_constant_identifier_names
    required this.player_name,
    required this.steamid64,
  });

  factory LocalPlayer.fromJson(Map<String, dynamic> json) => LocalPlayer(
        player_name:
            json['player_name'] == null ? json['name'] : json['player_name'],
        steamid64: json['steamid64'],
      );

  Map<String, dynamic> toJson() => {
        'player_name': player_name,
        'steamid64': steamid64,
      };
}

List<LocalPlayer> localPlayerFromJson(String str) => List<LocalPlayer>.from(
    json.decode(str).map((x) => LocalPlayer.fromJson(x)));
String localPlayerToJson(List<LocalPlayer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
