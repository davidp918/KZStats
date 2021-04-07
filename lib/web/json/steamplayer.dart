import 'dart:convert';

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
