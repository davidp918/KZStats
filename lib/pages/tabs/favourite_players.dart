import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/common/customDivider.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/common/none.dart';
import 'package:kzstats/cubit/curPlayer_cubit.dart';
import 'package:kzstats/cubit/mark_cubit.dart';
import 'package:kzstats/cubit/user_cubit.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/look/animation.dart';
import 'package:kzstats/look/colors.dart';
import 'package:kzstats/pages/details/map_detail.dart';
import 'package:kzstats/pages/details/player_detail.dart';
import 'package:kzstats/utils/getModeId.dart';
import 'package:kzstats/utils/timeConversion.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json/record_json.dart';
import 'package:kzstats/web/urls.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavouritePlayers extends StatefulWidget {
  FavouritePlayers({Key? key}) : super(key: key);

  @override
  FavouritePlayersState createState() => FavouritePlayersState();
}

class FavouritePlayersState extends State<FavouritePlayers>
    with AutomaticKeepAliveClientMixin<FavouritePlayers> {
  late RefreshController _refreshController;
  late UserState userState;
  late MarkState markState;
  late bool loggedIn;
  late List<String> subscribedPlayersSteam64id;
  late List<Record> latestRecords;
  late Map<String, Map<String, dynamic>> playerDetails;
  late Map<String, bool> gotNewRecord;
  late int curPageSize;
  int pageSize = 15;
  Random random = Random();
  final completeChoices = [
    'was on',
    'completed',
    'finished',
    'played',
    'had beaten',
    'Ran',
  ];

  @override
  void initState() {
    super.initState();
    this.curPageSize = pageSize;
    this.playerDetails = {};
    this.gotNewRecord = {};
    this.subscribedPlayersSteam64id = [];
    this.latestRecords = [];
    this._refreshController = RefreshController(initialRefresh: true);
  }

  void _onRefresh() async {
    print('refreshing ${this.markState.playerIds.length} friends records...');
    await refreshPlayersRecords(this.markState.playerIds);
    this._setPlayerDetails();
    this._loadLatestRecords(this.pageSize);
    this._sortPlayers();
    print('refresh friend records done');
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    this._loadLatestRecords(this.latestRecords.length + this.pageSize);
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (this.subscribedPlayersSteam64id.length == 0)
      return noneView(
        title: 'No Favourite Players Yet...',
        subTitle: 'Go mark a few and keep an eye out of their runs',
      );
    return Scrollbar(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: () => _onRefresh(),
        onLoading: () => _onLoading(),
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(16, 10, 14, 0),
              child: Text(
                'Latest runs',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            playerHeaders(),
            customDivider(16),
            this.latestRecords.length == 0
                ? noneView(
                    title: 'No records available...',
                    subTitle:
                        'may be due to the limit of requests to globalApi, try again in 5 minutes',
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: _itemBuilder,
                    itemCount: this.latestRecords.length,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    Record curRecord = this.latestRecords[index];
    String steamid64 = curRecord.steamid64.toString();
    String playerName = curRecord.playerName ?? '';
    String mapName = curRecord.mapName ?? '';
    double radius = 21;
    Size size = MediaQuery.of(context).size;
    double ratio = 113 / 200;
    double imageWidth = 160;
    double crossWidth = min((size.width / 2) * 33 / 41, imageWidth);
    double crossHeight = imageWidth *
        ratio; // min((size.height - 56) / 6.4, imageWidth * ratio);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 15, 10, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              ContainerAnimationWidget(
                  openBuilder: (context, action) => PlayerDetail(
                        playerInfo: [
                          curRecord.steamid64,
                          curRecord.playerName,
                        ],
                      ),
                  closedBuilder: (context, action) =>
                      getAvatar(steamid64, radius)),
              SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: size.width - 2 * radius - 50,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pushNamed(
                            '/player_detail',
                            arguments: [
                              curRecord.steamid64,
                              curRecord.playerName
                            ],
                          ),
                          child: Text(
                            playerName,
                            style: TextStyle(
                              color: inkWellBlue(),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          ' ${this.completeChoices[this.random.nextInt(this.completeChoices.length)]} ',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.of(context)
                                .pushNamed('/map_detail', arguments: [
                              curRecord.mapId,
                              curRecord.mapName
                            ]),
                            child: Text(
                              '$mapName',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: inkWellBlue(),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${diffofNow(curRecord.createdOn)}',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: radius * 2 + 12,
              ),
              Container(
                width: crossWidth,
                height: crossHeight,
                child: ContainerAnimationWidget(
                  openBuilder: (context, action) =>
                      MapDetail(mapInfo: [curRecord.mapId, curRecord.mapName]),
                  closedBuilder: (context, action) => getNetworkImage(
                    curRecord.mapName ?? '',
                    '$imageBaseURL${curRecord.mapName}.webp',
                    AssetImage('assets/icon/noimage.png'),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Under ${modeConvert(curRecord.mode ?? '')},',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                    ),
                    Text(
                      'in ${toMinSec(curRecord.time)},',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                    ),
                    Text(
                      'used ${curRecord.teleports} teleports,',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                    ),
                    Text(
                      'scored ${curRecord.points} points.',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          customDivider(16),
        ],
      ),
    );
  }

  Widget playerHeaders() {
    double radius = 26;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: 105,
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          for (String steamid64 in this.subscribedPlayersSteam64id)
            Container(
              height: 105,
              padding: const EdgeInsets.fromLTRB(14, 14, 2, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    child: getAvatar(steamid64, radius),
                    onTap: () {
                      //TODO: add go back to all view button, also add a highlight to the focused player header
                      this.gotNewRecord[steamid64] = false;
                      BlocProvider.of<CurPlayerCubit>(context).set(steamid64);
                      this._loadLatestRecords(this.pageSize);
                      if (mounted) setState(() {});
                    },
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: radius * 2 + 6,
                    child: Text(
                      '${this.playerDetails[steamid64]?['info']?.personaname ?? ''}',
                      softWrap: true,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w300,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget getAvatar(String steamid64, double radius) {
    double redDotRadius = 10;
    double distance = radius - sqrt(0.5 * radius * radius) - redDotRadius / 2;
    return Stack(
      children: [
        Container(
          child: CircleAvatar(
            radius: radius,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: getNetworkImage(
                steamid64,
                this.playerDetails[steamid64]?['info']?.avatarfull ?? '',
                AssetImage('assets/icon/noimage.png'),
              ),
            ),
          ),
        ),
        this.gotNewRecord[steamid64] ?? false
            ? Positioned(
                right: distance,
                bottom: distance,
                child: ClipOval(
                  child: Container(
                    height: redDotRadius,
                    width: redDotRadius,
                    color: Colors.red.shade400,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.userState = context.watch<UserCubit>().state;
    this.markState = context.watch<MarkCubit>().state;
    this.loggedIn = !(userState.playerInfo.avatarfull == null &&
        userState.playerInfo.steamid == null);
    this.subscribedPlayersSteam64id = markState.playerIds;
    this._setPlayerDetails();
    this._loadLatestRecords(this.pageSize);
    this._sortPlayers();
  }

  void _sortPlayers() {
    this.subscribedPlayersSteam64id.sort((b, a) {
      if (this.playerDetails[a]?['records'] == null ||
          this.playerDetails[b]?['records'] == null ||
          this.playerDetails[b]?['records']?.length == 0 ||
          this.playerDetails[a]?['records']?.length == 0) return 0;
      DateTime? valA = this.playerDetails[a]?['records']?.first.createdOn;
      DateTime? valB = this.playerDetails[b]?['records']?.first.createdOn;
      if (valA == null || valB == null) return 0;
      return valA.compareTo(valB);
    });
  }

  void _setPlayerDetails() {
    for (String steamid64 in this.subscribedPlayersSteam64id) {
      this.playerDetails[steamid64] = {
        'info': UserSharedPreferences.readPlayerInfo(steamid64),
        'records': UserSharedPreferences.getPlayerRecords(steamid64),
      };
    }
  }

  void _loadLatestRecords(int range) {
    CurPlayerState curPlayerState = context.read<CurPlayerCubit>().state;
    print('Reading: ${curPlayerState.curPlayer}');
    if (curPlayerState.curPlayer == null) {
      List<Record> latest = [
        for (List<Record> each
            in this.playerDetails.values.map((e) => e['records']))
          ...each
      ];
      latest.sort((b, a) {
        if (a.createdOn != null || b.createdOn != null)
          return a.createdOn!.compareTo(b.createdOn!);
        return 0;
      });
      this.latestRecords = latest.take(range).toList();
    } else {
      this.latestRecords = this
          .playerDetails[curPlayerState.curPlayer]?['records']
          .sublist(0, range)
          .toList();
      print(
          this.playerDetails[curPlayerState.curPlayer]?['records'][0].mapName);
    }
  }

  Future refreshPlayersRecords(List<String> playerIds) async {
    List<List<Record>> records = await Future.wait([
      // TODO:not obtaining the latest first run, wtf??? check if the player detail one is also messed up after sort on initialization works
      for (String steamid64 in playerIds) getPlayerRecords(steamid64, true)
    ]);
    for (int i = 0; i < playerIds.length; i++) {
      List<Record> curRecords = records[i];
      String curSteamid64 = playerIds[i];
      List<Record> localData =
          UserSharedPreferences.getPlayerRecords(curSteamid64);
      Record oldLatestRecords = localData.length == 0
          ? Record()
          : UserSharedPreferences.getPlayerRecords(curSteamid64).first;
      curRecords.sort((b, a) {
        if (a.createdOn != null || b.createdOn != null)
          return a.createdOn!.compareTo(b.createdOn!);
        return 0;
      });
      if (curRecords.length != 0 &&
          oldLatestRecords.time == curRecords[0].time) {
        this.gotNewRecord[curSteamid64] = false;
      } else {
        this.gotNewRecord[curSteamid64] = true;
        await UserSharedPreferences.setPlayerRecords(curSteamid64, curRecords);
      }
    }
  }

  @override
  void dispose() {
    this._refreshController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
