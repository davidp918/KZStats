import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/utils/svg.dart';
import 'package:kzstats/utils/tierIdentifier.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:kzstats/web/json/record_json.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PlayerDetailStats extends StatelessWidget {
  final List<Record> records;
  PlayerDetailStats({Key? key, required this.records}) : super(key: key);

  final trash = [0];
  final List<int> playerTierFinishes = [0, 0, 0, 0, 0, 0, 0];
  final List<int> gold = [0, 0, 0, 0, 0, 0, 0];
  final List<int> silver = [0, 0, 0, 0, 0, 0, 0];
  final List<int> bronze = [0, 0, 0, 0, 0, 0, 0];

  @override
  Widget build(BuildContext context) {
    final Set<int> seen = {};
    Size size = MediaQuery.of(context).size;
    double _indicatorWidth = (size.width - 24) * 7 / 10;
    double _indicatorHeight = 22; // size.height / 50;
    Color _bgColor = colorLight();

    final List<MapInfo>? allMapData = UserSharedPreferences.getMapData();
    if (allMapData == null || allMapData.length < 700)
      return Text('failed to retrieve map info, restart the app to retry');

    final Map<String, int> tierMapping =
        UserSharedPreferences.getTierMapping()!;

    final List<int> tierCount = UserSharedPreferences.getTierCount()!;

    for (Record each in this.records) {
      if (seen.contains(each.mapId)) continue;
      seen.add(each.mapId!);
      int curTierIndex = tierMapping[each.mapName!]! - 1;
      playerTierFinishes[curTierIndex] += 1;
      each.points == 1000
          ? this.gold[curTierIndex] += 1
          : each.points! >= 900
              ? this.silver[curTierIndex] += 1
              : each.points! >= 750
                  ? this.bronze[curTierIndex] += 1
                  : trash[0] = 0;
    }

    print(tierCount);
    print(tierMapping);

    List<Widget> indicator(
      int tier,
      int numerator,
      int denominator,
      int gold,
      Color color,
    ) {
      double _percent = numerator / denominator;
      if (numerator == 0) _percent = 0;
      if (denominator == 0) _percent = 1;
      double _percentage = 100 * _percent;
      return <Widget>[
        Row(
          children: [
            Expanded(
              child: Text(
                '${identifyTier(tier)} ($numerator/$denominator)',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            goldSvg(14, 14),
            Text(' $gold', style: TextStyle(fontSize: 12)),
          ],
        ),
        SizedBox(height: 4),
        LinearPercentIndicator(
          width: _indicatorWidth,
          lineHeight: _indicatorHeight,
          percent: _percent,
          backgroundColor: _bgColor,
          linearGradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [color.withOpacity(1), color.withOpacity(0.5)],
          ),
          animation: true,
          animationDuration: 800,
          linearStrokeCap: LinearStrokeCap.roundAll,
          center: Text(
            '${_percentage.toString().substring(0, 5)}%',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ];
    }

    return Center(
      child: Container(
        width: _indicatorWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ...indicator(
                1, playerTierFinishes[0], tierCount[0], gold[0], Colors.amber),
          ],
        ),
      ),
    );
  }

  int getDifficulty(int mapId, List<MapInfo> allMapsData) {
    return allMapsData[mapId - 200].difficulty!;
  }
}
