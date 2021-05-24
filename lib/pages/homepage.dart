import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/mode_cubit.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/utils/strCheckLen.dart';
import 'package:kzstats/utils/svg.dart';
import 'package:kzstats/utils/timeConversion.dart';
import 'package:kzstats/web/urls.dart';
import 'package:kzstats/web/withNation.dart';
import 'package:kzstats/global/recordInfo_class.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Homepage extends StatelessWidget {
  final int pageSize = 12;

  @override
  Widget build(BuildContext context) {
    final state = context.read<ModeCubit>().state;
    return Scaffold(
      appBar: HomepageAppBar('Latest'),
      drawer: HomepageDrawer(),
      body: FutureBuilder(
        future: getInfoWithNation(state.mode, state.nub, this.pageSize, 0),
        builder:
            (BuildContext context, AsyncSnapshot<List<RecordInfo>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            return loadingFromApi();
          if (!snapshot.hasData || snapshot.data == []) return errorScreen();
          return HomepageBody(items: snapshot.data!);
        },
      ),
    );
  }
}

class HomepageBody extends StatefulWidget {
  final List<RecordInfo> items;

  const HomepageBody({Key? key, required this.items}) : super(key: key);
  @override
  _HomepageBodyState createState() => _HomepageBodyState(items: items);
}

class _HomepageBodyState extends State<HomepageBody> {
  List<RecordInfo> items;
  _HomepageBodyState({required this.items});
  int pageSize = 12;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh(state) async {
    this.items =
        await getInfoWithNation(state.mode, state.nub, this.pageSize, 0);
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading(state) async {
    // monitor network fetch
    this.items += await getInfoWithNation(
        state.mode, state.nub, this.pageSize, this.items.length);
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length + 1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ModeCubit, ModeState>(
      listener: (context, state) => _refreshController.requestRefresh(
        duration: Duration(milliseconds: 100),
      ),
      builder: (context, state) {
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          controller: _refreshController,
          onRefresh: () => _onRefresh(state),
          onLoading: () => _onLoading(state),
          child: ListView.builder(
            itemBuilder: this._itemBuilder,
            itemCount: this.items.length,
          ),
        );
      },
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    double ratio = 113 / 200;
    double imageWidth = 200;
    double crossWidth = min((size.width / 2) * 33 / 41, imageWidth);
    double crossHeight = min((size.height - 56) / 6.4, imageWidth * ratio);
    double padding = (size.width - 2 * crossWidth - 30) / 2;
    RecordInfo info = this.items[index];
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Divider(height: 4, color: dividerColor()),
        ),
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
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/map_detail',
                          arguments: info,
                        );
                      },
                      child: GetNetworkImage(
                        fileName: info.mapName,
                        url: '$imageBaseURL${info.mapName}.webp',
                        errorImage: AssetImage('assets/icon/noimage.png'),
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
                              info.nation != 'null'
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
      ],
    );
  }
}
