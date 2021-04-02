class KzTimer {
  KzTimer({
    this.id,
    this.steamid64,
    this.playerName,
    this.steamId,
    this.serverId,
    this.mapId,
    this.stage,
    this.mode,
    this.tickrate,
    this.time,
    this.teleports,
    this.createdOn,
    this.updatedOn,
    this.updatedBy,
    this.place,
    this.top100,
    this.top100Overall,
    this.serverName,
    this.mapName,
    this.points,
    this.recordFilterId,
    this.replayId,
  });

  int id;
  String steamid64;
  String playerName;
  String steamId;
  int serverId;
  int mapId;
  int stage;
  String mode;
  int tickrate;
  double time;
  int teleports;
  DateTime createdOn;
  DateTime updatedOn;
  int updatedBy;
  int place;
  int top100;
  int top100Overall;
  String serverName;
  String mapName;
  int points;
  int recordFilterId;
  int replayId;

  factory KzTimer.fromJson(Map<String, dynamic> json) => KzTimer(
        id: json["id"],
        steamid64: json["steamid64"],
        playerName: json["player_name"],
        steamId: json["steam_id"],
        serverId: json["server_id"],
        mapId: json["map_id"],
        stage: json["stage"],
        mode: json["mode"],
        tickrate: json["tickrate"],
        time: json["time"].toDouble(),
        teleports: json["teleports"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedOn: DateTime.parse(json["updated_on"]),
        updatedBy: json["updated_by"],
        place: json["place"],
        top100: json["top_100"],
        top100Overall: json["top_100_overall"],
        serverName: json["server_name"],
        mapName: json["map_name"],
        points: json["points"],
        recordFilterId: json["record_filter_id"],
        replayId: json["replay_id"],
      );
}
