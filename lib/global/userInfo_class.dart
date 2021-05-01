class UserInfo {
  String steam32, steam64, name, avatarUrl;

  UserInfo({
    required this.steam32,
    required this.steam64,
    required this.name,
    required this.avatarUrl,
  });

  factory UserInfo.fromJson(Map<String, dynamic> parsedJson) {
    return UserInfo(
      steam32: parsedJson['steam32'] ?? '',
      steam64: parsedJson['steam64'] ?? '',
      name: parsedJson['name'] ?? '',
      avatarUrl: parsedJson['avatarUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steam32': this.steam32,
      'steam64': this.steam64,
      'name': this.name,
      'avatarUrl': this.avatarUrl,
    };
  }
}
