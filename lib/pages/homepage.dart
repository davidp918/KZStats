import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';
import 'package:kzstats/cubit/cubit_update.dart';
import 'package:kzstats/web/json/kztime_json.dart';
import 'package:kzstats/others/strCheckLen.dart';
import 'package:kzstats/web/get/getTopRecords.dart';
import 'package:kzstats/web/urls.dart';
import 'package:kzstats/others/timeConversion.dart';
import 'package:kzstats/web/future/kzstatsApiPlayerNation.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/svg.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/common/error.dart';

class Homepage extends StatelessWidget {
  final String currentPage = 'KZStats';

  void notifySwitching(String mode, bool nub, BuildContext context) {
    String temp;
    nub ? temp = 'Nub' : temp = 'Pro';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Switching to $temp $mode'),
        duration: Duration(milliseconds: 4000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar(currentPage),
      drawer: HomepageDrawer(),
      body: BlocConsumer<ModeCubit, ModeState>(
        listenWhen: (previous, current) {
          return previous.mode != current.mode || previous.nub != current.nub;
        },
        listener: (context, state) => notifySwitching(
          '${state.mode}',
          state.nub,
          context,
        ),
        builder: (context, state) {
          return FutureBuilder<List<KzTime>>(
            future: getTopRecords(state.mode, state.nub, 20),
            builder: (
              BuildContext kzInfocontext,
              AsyncSnapshot<List<KzTime>> kzInfosnapshot,
            ) {
              return FutureBuilder(
                future: getPlayerKzstatsNation(kzInfosnapshot),
                builder: (
                  BuildContext kzstatsPlayerContext,
                  AsyncSnapshot<List<String>> kzstatsPlayerNation,
                ) =>
                    mainBody(
                  kzInfocontext,
                  kzInfosnapshot,
                  kzstatsPlayerContext,
                  kzstatsPlayerNation,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget mainBody(
    BuildContext context,
    AsyncSnapshot<List<KzTime>> kzInfosnapshot,
    BuildContext kzstatsPlayerContext,
    AsyncSnapshot<List<String>> kzstatsPlayerNation,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: (kzInfosnapshot.connectionState == ConnectionState.done &&
              kzstatsPlayerNation.connectionState == ConnectionState.done)
          ? kzInfosnapshot.hasData
              ? EasyRefresh(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => snippet(
                            context,
                            kzInfosnapshot,
                            kzstatsPlayerContext,
                            kzstatsPlayerNation,
                            index,
                          ),
                          childCount: kzInfosnapshot.data.length,
                        ),
                      )
                    ],
                  ),
                  onRefresh: () async =>
                      BlocProvider.of<ModeCubit>(context).refresh(),
                  // avoid rebuilding the whole widget so previous
                  // list is not replaced by the refresh indicator
                  // while loading
                  onLoad: () async {
                    await Future.delayed(Duration(seconds: 2));
                  },
                  // need to accomplish onRefresh rebuild first as
                  // loading more will rebuild the whole widget
                  // tree as well
                )
              : RefreshIndicator(
                  child: errorScreen(),
                  onRefresh: () async =>
                      BlocProvider.of<ModeCubit>(context).refresh(),
                )
          : loadingFromApi(),
    );
  }

  Widget snippet(
          BuildContext context,
          AsyncSnapshot<List<KzTime>> kzInfosnapshot,
          BuildContext kzstatsPlayerContext,
          AsyncSnapshot<List<String>> kzstatsPlayerNation,
          int index) =>
      Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(35, 15, 0, 15),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 11),
                child: Container(
                  height: 90,
                  width: 160,
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(),
                        height: 30,
                        width: 30,
                      ),
                    ),
                    errorWidget: (context, url, error) => Image(
                      image: AssetImage('assets/icon/noimage.png'),
                    ),
                    imageUrl:
                        '$imageBaseURL${kzInfosnapshot.data[index].mapName}.webp',
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    child: Container(
                      width: 145,
                      child: Text(
                        //'${lenCheck(kzInfosnapshot.data[index].mapName, 20)}',
                        kzInfosnapshot.data[index].mapName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: inkwellBlue(),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/map_detail',
                        arguments: kzInfosnapshot.data[index],
                      );
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '${toMinSec(kzInfosnapshot.data[index].time)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      trophy(14, 14),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        kzInfosnapshot.data[index].teleports == 1
                            ? '(${kzInfosnapshot.data[index].teleports.toString()} tp)'
                            : kzInfosnapshot.data[index].teleports > 1
                                ? '(${kzInfosnapshot.data[index].teleports.toString()} tps)'
                                : '',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Text(
                        'by ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.5,
                        ),
                      ),
                      InkWell(
                        child: Text(
                          '${lenCheck(kzInfosnapshot.data[index].playerName, 15)}',
                          style: TextStyle(
                            color: Colors.blue.shade100,
                            fontSize: 14.5,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/map_detail',
                            arguments: kzInfosnapshot.data[index].steamid64,
                          );
                        },
                      ),
                      SizedBox(
                        width: 4.5,
                      ),
                      kzstatsPlayerNation.hasData
                          ? Image(
                              image: AssetImage(
                                'assets/flag/${kzstatsPlayerNation.data[index]}.png',
                              ),
                            )
                          : Container(
                              child: Text('${kzstatsPlayerNation.data}'),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '${diffofNow(kzInfosnapshot.data[index].createdOn)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          height: 1.0,
          indent: 0,
          color: Colors.black,
        ),
      ]);
}
