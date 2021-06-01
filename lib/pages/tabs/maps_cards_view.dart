import 'package:flutter/material.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/mark_cubit.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/utils/tierIdentifier.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:kzstats/web/urls.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapCards extends StatelessWidget {
  final List<MapInfo> prevInfo;
  final bool marked;
  MapCards({Key? key, required this.prevInfo, required this.marked});

  final ScrollController _scrollController = ScrollController();
  final List<MapInfo> mapInfo = [];

  @override
  Widget build(BuildContext context) {
    List<MapInfo> mapInfo = prevInfo;
    if (marked) {
      MarkState markState = context.watch<MarkCubit>().state;
      mapInfo = [];
      for (MapInfo info in prevInfo) {
        if (markState.mapIds.contains(info.mapId.toString()) &&
            !mapInfo.contains(info.mapId.toString())) mapInfo.add(info);
      }
    }
    return CustomScrollView(
      controller: this._scrollController,
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.all(15.0),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _itemBuilder(context, mapInfo[index], index),
              childCount: mapInfo.length,
              addAutomaticKeepAlives: true,
            ),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 1.0,
            ),
          ),
        ),
      ],
    );
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
            child: getNetworkImage(
              entry.mapName,
              '$imageBaseURL${entry.mapName}.webp',
              AssetImage('assets/icon/noimage.png'),
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
                        arguments: [entry.mapId, entry.mapName],
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
