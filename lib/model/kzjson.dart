import 'dart:convert';

class KzTime {
  KzTime({
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

  factory KzTime.fromJson(Map<String, dynamic> json) => KzTime(
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

List<KzTime> kzInfoFromJson(String str) => List<KzTime>.from(
      json.decode(str).map(
            (x) => KzTime.fromJson(x),
          ),
    );

Player playerFromJson(String str) => Player.fromJson(json.decode(str));

class Player {
  Player({
    this.response,
  });

  Response response;

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        response: Response.fromJson(json["response"]),
      );
}

class Response {
  Response({
    this.players,
  });

  List<PlayerElement> players;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        players: List<PlayerElement>.from(
            json["players"].map((x) => PlayerElement.fromJson(x))),
      );
}

class PlayerElement {
  PlayerElement({
    this.steamid,
    this.communityvisibilitystate,
    this.profilestate,
    this.personaname,
    this.commentpermission,
    this.profileurl,
    this.avatar,
    this.avatarmedium,
    this.avatarfull,
    this.avatarhash,
    this.lastlogoff,
    this.personastate,
    this.primaryclanid,
    this.timecreated,
    this.personastateflags,
    this.gameextrainfo,
    this.gameid,
    this.loccountrycode,
  });

  String steamid;
  int communityvisibilitystate;
  int profilestate;
  String personaname;
  int commentpermission;
  String profileurl;
  String avatar;
  String avatarmedium;
  String avatarfull;
  String avatarhash;
  int lastlogoff;
  int personastate;
  String primaryclanid;
  int timecreated;
  int personastateflags;
  String gameextrainfo;
  String gameid;
  String loccountrycode;

  factory PlayerElement.fromJson(Map<String, dynamic> json) => PlayerElement(
        steamid: json["steamid"],
        communityvisibilitystate: json["communityvisibilitystate"],
        profilestate: json["profilestate"],
        personaname: json["personaname"],
        commentpermission: json["commentpermission"],
        profileurl: json["profileurl"],
        avatar: json["avatar"],
        avatarmedium: json["avatarmedium"],
        avatarfull: json["avatarfull"],
        avatarhash: json["avatarhash"],
        lastlogoff: json["lastlogoff"],
        personastate: json["personastate"],
        primaryclanid: json["primaryclanid"],
        timecreated: json["timecreated"],
        personastateflags: json["personastateflags"],
        gameextrainfo: json["gameextrainfo"],
        gameid: json["gameid"],
        loccountrycode: json["loccountrycode"],
      );
}
