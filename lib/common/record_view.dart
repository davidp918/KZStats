import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kzstats/common/customDivider.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/look/animation.dart';
import 'package:kzstats/look/colors.dart';
import 'package:kzstats/pages/details/map_detail.dart';
import 'package:kzstats/utils/strCheckLen.dart';
import 'package:kzstats/utils/svg.dart';
import 'package:kzstats/utils/timeConversion.dart';
import 'package:kzstats/web/urls.dart';
import 'package:kzstats/global/recordInfo_class.dart';

Widget recordCardView(BuildContext context, RecordInfo info) {
  Size size = MediaQuery.of(context).size;
  double ratio = 113 / 200;
  double imageWidth = 200;
  double crossWidth = min((size.width / 2) * 33 / 41, imageWidth);
  double crossHeight =
      imageWidth * ratio; // min((size.height - 56) / 6.4, imageWidth * ratio);
  double padding = (size.width - 2 * crossWidth - 30) / 2;
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: crossWidth,
                  height: crossHeight,
                  child: ContainerAnimationWidget(
                    openBuilder: (context, action) =>
                        MapDetail(mapInfo: [info.mapId, info.mapName]),
                    closedBuilder: (context, action) => getNetworkImage(
                      info.mapName,
                      '$imageBaseURL${info.mapName}.webp',
                      AssetImage('assets/icon/noimage.png'),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: crossWidth,
                  height: crossHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          child: Text(
                            info.mapName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: inkWellBlue(),
                              fontSize: 17,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            '/map_detail',
                            arguments: [info.mapId, info.mapName],
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${toMinSec(info.time)}',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          goldSvg(15, 15),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            info.teleports == 1
                                ? '(${info.teleports.toString()} tp)'
                                : info.teleports > 1
                                    ? '(${info.teleports.toString()} tps)'
                                    : '',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('by ', style: TextStyle(fontSize: 15)),
                            Flexible(
                              fit: FlexFit.loose,
                              child: InkWell(
                                child: Text(
                                  '${lenCheck(info.playerName, 15)}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.blue.shade100,
                                      fontSize: 15),
                                ),
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    '/player_detail',
                                    arguments: [
                                      info.steamid64,
                                      info.playerName
                                    ],
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            info.nation != 'null' && info.nation != ''
                                ? Image(
                                    image: AssetImage(
                                        'assets/flag/${info.nation}.png'),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      Text(
                        '${diffofNow(info.createdOn)}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      customDivider(padding),
    ],
  );
}
