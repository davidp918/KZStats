import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/utils/pointsSum.dart';
import 'package:kzstats/utils/svg.dart';
import 'package:kzstats/utils/tierIdentifier.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:kzstats/web/json/record_json.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PlayerDetailStats extends StatelessWidget {
  final List<Record> records;
  PlayerDetailStats({Key? key, required this.records}) : super(key: key);
  final List<int> gold = [0, 0, 0, 0, 0, 0, 0];
  final List<int> silver = [0, 0, 0, 0, 0, 0, 0];
  final List<int> bronze = [0, 0, 0, 0, 0, 0, 0];
  final List<int> playerTierFinishes = [0, 0, 0, 0, 0, 0, 0];
  final List<int> playerPtrs = [0, 0, 0, 0, 0, 0, 0];
  final trash = [0];

  @override
  Widget build(BuildContext context) {
    List<Widget> indicators = [];
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
      playerPtrs[curTierIndex] += each.points!;
      playerTierFinishes[curTierIndex] += 1;
      each.points == 1000
          ? gold[curTierIndex] += 1
          : each.points! >= 900
              ? silver[curTierIndex] += 1
              : each.points! >= 750
                  ? bronze[curTierIndex] += 1
                  : trash[0] = 0;
    }

    List<Widget> indicator(
        int tier, int numerator, int denominator, int gold, Color color) {
      double _percent = numerator / denominator;
      if (numerator == 0) _percent = 0;
      if (denominator == 0) _percent = 1;
      String _percentage = (100 * _percent).toString();
      int avg = playerTierFinishes[tier - 1] == 0
          ? 0
          : (playerPtrs[tier - 1] / playerTierFinishes[tier - 1]).truncate();
      return <Widget>[
        Row(
          children: [
            Expanded(
              child: Text(
                '${identifyTier(tier)} ($numerator/$denominator) - Avg: $avg',
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
            colors: [
              color.withOpacity(1),
              color.withOpacity(min(0.6 * sin(_percent) + 0.5, 1))
            ],
          ),
          animation: true,
          animationDuration: 500,
          linearStrokeCap: LinearStrokeCap.roundAll,
          center: Text(
            '${_percentage.substring(0, min(5, _percentage.length))}%',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w300,
              fontSize: 13,
            ),
          ),
        ),
        SizedBox(height: 6),
      ];
    }

    List<int>.generate(7, (i) => i).forEach(
      (i) {
        indicators += indicator(
          i + 1,
          playerTierFinishes[i],
          tierCount[i],
          gold[i],
          tierColors()[i],
        );
      },
    );

    List<Widget> overview() {
      int goldSum = gold.reduce((a, b) => a + b);
      int silverSum = silver.reduce((a, b) => a + b);
      int bronzeSum = bronze.reduce((a, b) => a + b);
      int totalAvg = (pointsSum(records) / records.length).truncate();
      return <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$goldSum',
              style: TextStyle(fontSize: 26),
            ),
            goldSvg(26, 26),
            Text(
              '  $silverSum',
              style: TextStyle(fontSize: 26),
            ),
            silverSvg(26, 26),
            Text(
              '  $bronzeSum',
              style: TextStyle(fontSize: 26),
            ),
            bronzeSvg(26, 26),
          ],
        ),
        Row(
          children: [
            Expanded(child: Container()),
            Text(
              '- Averaging at $totalAvg pts.',
              style: TextStyle(
                color: colorLight(),
                fontStyle: FontStyle.italic,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ];
    }

    Widget sectionTitle(String title) {
      return Text(
        '$title',
        style: TextStyle(
          color: Colors.amber.shade100,
          fontSize: 25,
          fontWeight: FontWeight.w300,
        ),
      );
    }

    return Center(
      child: Container(
        width: _indicatorWidth,
        child: Column(
          children: <Widget>[
            sectionTitle('OverView'),
            SizedBox(height: 4),
            ...overview(),
            SizedBox(height: 4),
            sectionTitle('BreakDown'),
            SizedBox(height: 4),
            ...indicators,
          ],
        ),
      ),
    );
  }
}
