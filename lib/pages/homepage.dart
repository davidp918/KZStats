import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/mode_cubit.dart';
import 'package:kzstats/global/responsive.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/utils/strCheckLen.dart';
import 'package:kzstats/utils/svg.dart';
import 'package:kzstats/utils/timeConversion.dart';
import 'package:kzstats/web/urls.dart';
import 'package:kzstats/web/withNation.dart';
import 'package:kzstats/global/recordInfo_class.dart';

class Homepage extends StatelessWidget {
  static int pageSize = 12;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      ifDrawer: true,
      currentPage: 'Latest',
      builder: (context, constraints) => BlocBuilder<ModeCubit, ModeState>(
        builder: (context, state) => PagewiseListView<RecordInfo>(
          pageSize: pageSize,
          itemBuilder: this._itemBuilder,
          loadingBuilder: (context) => loadingFromApi(),
          pageFuture: (pageIndex) => getInfoWithNation(
              state.mode, state.nub, pageSize, pageSize * pageIndex!),
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, RecordInfo info, int index) {
    Size size = MediaQuery.of(context).size;
    double ratio = 113 / 200;
    double imageWidth = 200;
    double crossWidth = min((size.width / 2) * 33 / 41, imageWidth);
    double crossHeight = min((size.height - 56) / 6.4, imageWidth * ratio);
    double padding = size.width - 2 * crossWidth - 30;
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
                    child: GetNetworkImage(
                      fileName: info.mapName,
                      url: '$imageBaseURL${info.mapName}.webp',
                      errorImage: AssetImage('assets/icon/noimage.png'),
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
                                fontSize: 16,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/map_detail',
                              arguments: info,
                            );
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '${toMinSec(info.time)}',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            goldSvg(14, 14),
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
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('by ', style: TextStyle(fontSize: 14.5)),
                              Flexible(
                                fit: FlexFit.loose,
                                child: InkWell(
                                  child: Text(
                                    '${lenCheck(info.playerName, 15)}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.blue.shade100,
                                        fontSize: 14.5),
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
                              info.nation != null
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
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Divider(height: 4, color: dividerColor()),
        ),
      ],
    );
  }
}
