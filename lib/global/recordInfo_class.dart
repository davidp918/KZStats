class RecordInfo {
  String mapName;
  int mapId;
  double time;
  int teleports;
  String playerName;
  String steamid64;
  String playerNation;
  String? nation;
  DateTime? createdOn;
  RecordInfo({
    required this.mapName,
    required this.mapId,
    required this.time,
    required this.teleports,
    required this.playerName,
    required this.steamid64,
    required this.playerNation,
    this.nation,
    this.createdOn,
  });
}
