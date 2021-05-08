import 'package:flutter/material.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:kzstats/web/json/record_json.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PlayerDetailStats extends StatelessWidget {
  final List<Record> records;
  const PlayerDetailStats({Key? key, required this.records}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<MapInfo>? allMapData = UserSharedPreferences.getMapData();

    if (allMapData == null || allMapData.length < 700) {
      return Text('failed to retrieve map info, restart the app to retry');
    }

    final List<int> mapStats = [0, 0, 0, 0, 0, 0, 0];
    final List<int> playerStats = [0, 0, 0, 0, 0, 0, 0];
    final Map<String, int> difficultyMapping = {};
    int gold = 0;
    int silver = 0;
    int bronze = 0;

    // sort by mapId, starting from 200, ascending?
    allMapData.sort((a, b) => a.mapId!.compareTo(b.mapId!));

    for (MapInfo each in allMapData) {
      mapStats[each.difficulty! - 1] += 1;
      difficultyMapping[each.mapName!] = each.difficulty!;
    }
    print(difficultyMapping);
    for (Record each in this.records) {
      int curDifficulty = difficultyMapping[each.mapName!]!;
      playerStats[curDifficulty - 1] += 1;
      each.points == 1000
          ? gold += 1
          : each.points! >= 900
              ? silver += 1
              : each.points! >= 750
                  ? bronze += 1
                  : bronze = bronze;
    }
    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          Text(''),
          Text('$mapStats'),
          Text('$playerStats'),
        ],
      ),
    );
  }

  int getDifficulty(int mapId, List<MapInfo> allMapsData) {
    return allMapsData[mapId - 200].difficulty!;
  }
}
