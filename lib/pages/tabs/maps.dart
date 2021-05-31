import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/tier_cubit.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/utils/tierIdentifier.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:kzstats/web/urls.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> with AutomaticKeepAliveClientMixin<Maps> {
  late Size size;
  late double ratio, imageWidth, crossWidth, crossHeight;
  late int pageSize, rowCount;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    size = MediaQuery.of(context).size;
    ratio = 113 / 200;
    imageWidth = 200;
    crossWidth = min((size.width / 2), imageWidth);
    rowCount = size.width ~/ crossWidth;
    pageSize = rowCount * 10;
    return BlocBuilder<TierCubit, TierState>(
      builder: (context, state) {
        return Container(
          width: size.width,
          height: size.height,
          child: mapsGridView(state.tier),
        );
      },
    );
  }

  Widget mapsGridView(int tier) {
    return PagewiseGridView.count(
      pageSize: pageSize,
      crossAxisCount: rowCount,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      childAspectRatio: 1,
      // physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(15.0),
      itemBuilder: _itemBuilder,
      pageFuture: (pageIndex) =>
          _loadMore(pageSize, pageIndex! * pageSize, tier),
      loadingBuilder: (context) => loadingFromApi(),
    );
  }

  Future<List<MapInfo>> _loadMore(int limit, int offset, int tier) async {
    dynamic temp = getAMaps(limit, offset, multiMapInfoFromJson, tier);
    if (temp != null) {
      return temp;
    } else {
      return [];
    }
  }

  Widget _itemBuilder(BuildContext context, MapInfo entry, _) {
    return Card(
      color: primarythemeBlue(),
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 200 / 113,
            child: GetNetworkImage(
              fileName: entry.mapName!,
              url: '$imageBaseURL${entry.mapName!}.webp',
              errorImage: AssetImage('assets/icon/noimage.png'),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1.5),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/map_detail',
                        arguments: entry,
                      );
                    },
                    child: Text(
                      '${entry.mapName}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: inkWellBlue(),
                        fontSize: 17.5,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1.5),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Tier: ${identifyTier(entry.difficulty)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
