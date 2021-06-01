import 'dart:math';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/common/widgets/datatable.dart';
import 'package:kzstats/global/detailed_pages.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/mode_cubit.dart';
import 'package:kzstats/cubit/playerdisplay_cubit.dart';
import 'package:kzstats/global/floater.dart';
import 'package:kzstats/pages/details/player_detail_stats.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/utils/convertDegreeRad.dart';
import 'package:kzstats/utils/pointsSum.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json.dart';
import 'package:kzstats/web/urls.dart';

class PlayerDetail extends StatefulWidget {
  final List<dynamic> playerInfo;
  const PlayerDetail({Key? key, required this.playerInfo}) : super(key: key);

  @override
  _PlayerDetailState createState() => _PlayerDetailState(
        // need further test about: if a player does not have any records,
        // will this null checks break as it's a list of null
        playerInfo[0],
        playerInfo[1],
      );
}

class _PlayerDetailState extends State<PlayerDetail> {
  final String steamId64;
  final String playerName;
  late Future _future;
  late ModeState modeState;
  _PlayerDetailState(this.steamId64, this.playerName);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.modeState = context.watch<ModeCubit>().state;
    this._future = Future.wait([
      getRequest(kzstatsApiPlayerInfoUrl(steamId64), kzstatsApiPlayerFromJson),
      getRequest(
          globalApiPlayerRecordsUrl(
              modeState.mode, modeState.nub, 99999, steamId64),
          recordFromJson),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return DetailedPage(
      markedType: 'player',
      current: this.steamId64,
      title: this.playerName,
      builder: (BuildContext context) {
        return FutureBuilder<dynamic>(
          future: this._future,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.hasData && snapshot.data[0] != null
                    // snapshot.data[1] can be null
                    ? whole(snapshot.data[0], snapshot.data[1])
                    : errorScreen()
                : loadingFromApi();
          },
        );
      },
    );
  }

  Widget whole(KzstatsApiPlayer kzstatsPlayerInfo, List<Record>? records) {
    int totalPoints = pointsSum(records);
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
            shrinkWrap: true,
            children: [
              playerHeader(kzstatsPlayerInfo, totalPoints),
              MainBody(steamId64: this.steamId64, records: records),
              Container(height: 100),
            ],
          ),
          Floater(),
        ],
      ),
    );
  }

  Widget playerHeader(KzstatsApiPlayer kzstatsPlayerInfo, int totalPoints) {
    Size size = MediaQuery.of(context).size;
    double avatarSize = min(140, size.width / 3);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(width: 2),
            Container(
              width: avatarSize,
              height: avatarSize,
              child: getNetworkImage(
                '${kzstatsPlayerInfo.steamid32}',
                kzstatsPlayerInfo.avatarfull!,
                AssetImage('assets/icon/noimage.png'),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Container(
                height: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${kzstatsPlayerInfo.personaname}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                            fontSize: 28,
                          ),
                        ),
                        Text(
                          '(${kzstatsPlayerInfo.steamid32})',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Points: ${totalPoints.toString()}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    kzstatsPlayerInfo.loccountrycode != null
                        ? Row(
                            children: <Widget>[
                              Image(
                                image: AssetImage(
                                  'assets/flag/${kzstatsPlayerInfo.loccountrycode!.toLowerCase()}.png',
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                '${kzstatsPlayerInfo.country}',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    InkWell(
                      child: Text(
                        'steam profile',
                        style: TextStyle(
                          color: inkWellBlue(),
                          fontSize: 14,
                        ),
                      ),
                      onTap: () async {
                        String url = '${kzstatsPlayerInfo.profileurl}';
                        await canLaunch(url)
                            ? await launch(url)
                            : throw ('could not launch $url');
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
      ],
    );
  }
}

class Floater extends StatefulWidget {
  Floater({Key? key}) : super(key: key);

  @override
  _FloaterState createState() => _FloaterState();
}

class _FloaterState extends State<Floater> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation oneAnimation, twoAnimation, rotationAnimation;
  @override
  void initState() {
    super.initState();
    this.animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    this.oneAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    this.twoAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);
    this.rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 30,
      bottom: 30,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          IgnorePointer(
            child: Container(
                color: Colors.transparent, height: 200.0, width: 200.0),
          ),
          ...subFloaters(),
          Transform(
            transform: Matrix4.rotationZ(
                getRadiansFromDegree(rotationAnimation.value)),
            alignment: Alignment.center,
            child: CircularFloatingButton(
              width: 54,
              height: 54,
              color: Colors.white,
              icon: Icon(Icons.menu),
              onClick: () {
                animationController.isCompleted
                    ? animationController.reverse()
                    : animationController.forward();
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Transform> subFloaters() {
    return [
      subFloater(250, twoAnimation, 100, Colors.white70,
          Icon(CommunityMaterialIcons.format_list_bulleted), 'records'),
      subFloater(200, oneAnimation, 100, Colors.white70,
          Icon(CommunityMaterialIcons.graphql), 'stats'),
    ];
  }

  Transform subFloater(double angle, Animation<dynamic> parameter,
      double magnitude, Color color, Icon icon, String newDisplay) {
    return Transform.translate(
      offset: Offset.fromDirection(
          getRadiansFromDegree(angle), parameter.value * magnitude),
      child: Transform(
        transform:
            Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
              ..scale(parameter.value),
        alignment: Alignment.center,
        child: CircularFloatingButton(
          width: 40,
          height: 40,
          color: color,
          icon: icon,
          onClick: () {
            BlocProvider.of<PlayerdisplayCubit>(context).set(newDisplay);
          },
        ),
      ),
    );
  }
}

class MainBody extends StatelessWidget {
  final String steamId64;
  final List<Record>? records;

  const MainBody({
    Key? key,
    required this.steamId64,
    required this.records,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.records == null) {
      return Align(
        alignment: Alignment.center,
        child: Text('No data available'),
      );
    }
    Size size = MediaQuery.of(context).size;
    final playerDisplayState = context.watch<PlayerdisplayCubit>().state;
    if (playerDisplayState.playerDisplay == 'records') {
      return CustomDataTable(
        data: records!,
        columns: ['Map', 'Time', 'Points', 'TPs', 'Date', 'Server'],
        initialSortedColumnIndex: 4,
        initialAscending: false,
      );
    } else if (playerDisplayState.playerDisplay == 'stats') {
      return PlayerDetailStats(records: records!);
    }
    // minus 395 to make the loading icon center
    return Container(height: size.height - 395, child: loadingFromApi());
  }
}
