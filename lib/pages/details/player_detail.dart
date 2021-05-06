import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/datatables/player_detail_datatable.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/mode_cubit.dart';
import 'package:kzstats/cubit/playerdisplay_cubit.dart';
import 'package:kzstats/global/floater.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/utils/convertDegreeRad.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json.dart';
import 'package:kzstats/web/urls.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class PlayerDetail extends StatefulWidget {
  final List<dynamic> playerInfo;
  const PlayerDetail({Key? key, required this.playerInfo}) : super(key: key);

  @override
  _MapDetailState createState() => _MapDetailState(
        // need further test about: if a player does not have any records,
        // will this null checks break as it's a list of null
        playerInfo[0],
        playerInfo[1],
      );
}

class _MapDetailState extends State<PlayerDetail> {
  final String steamId64;
  final String playerName;

  _MapDetailState(this.steamId64, this.playerName);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar(playerName),
      body: FutureBuilder<dynamic>(
        future: getRequest(
            kzstatsApiPlayerInfoUrl(steamId64), kzstatsApiPlayerFromJson),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? snapshot.hasData
                  ? whole(snapshot.data)
                  : errorScreen()
              : loadingFromApi();
        },
      ),
    );
  }

  Widget whole(KzstatsApiPlayer kzstatsPlayerInfo) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Stack(
        children: [
          ListView(
            children: [
              playerHeader(kzstatsPlayerInfo),
              MainBody(steamId64: this.steamId64),
            ],
          ),
          Floater(),
        ],
      ),
    );
  }

  Widget playerHeader(KzstatsApiPlayer kzstatsPlayerInfo) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(width: 2),
            GetNetworkImage(
              fileName: '${kzstatsPlayerInfo.steamid32}',
              url: kzstatsPlayerInfo.avatarfull!,
              errorImage: AssetImage('assets/icon/noimage.png'),
              borderWidth: 2,
              height: 130,
              width: 130,
            ),
            SizedBox(width: 14),
            Expanded(
              child: Container(
                height: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${kzstatsPlayerInfo.personaname}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
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
                      'Points: beta',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
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
  late Animation oneAnimation, twoAnimation, threeAnimation, rotationAnimation;
  @override
  void initState() {
    super.initState();
    this.animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    this.oneAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    this.twoAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    this.threeAnimation = TweenSequence([
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
      subFloater(265, threeAnimation, 100, Colors.white70,
          Icon(CommunityMaterialIcons.format_list_bulleted), 'records'),
      subFloater(225, twoAnimation, 100, Colors.white70,
          Icon(CommunityMaterialIcons.graphql), 'stats'),
      subFloater(185, oneAnimation, 100, Colors.white70,
          Icon(CommunityMaterialIcons.map_marker_distance), 'jumpstats'),
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
  const MainBody({Key? key, required this.steamId64}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final modeState = context.watch<ModeCubit>().state;
    final playerDisplayState = context.watch<PlayerdisplayCubit>().state;
    return FutureBuilder(
      future: getRequest(
        globalApiPlayerRecordsUrl(
            modeState.mode, modeState.nub, 99999, steamId64),
        mapTopFromJson,
      ),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.connectionState == ConnectionState.done
            ? snapshot.hasData
                ? select(playerDisplayState.playerDisplay, snapshot.data)
                : errorScreen(exception: 'none')
            : Container(
                height: size.height - 395,
                child: loadingFromApi(),
              );
      },
    );
  }

  Widget select(String select, dynamic data) {
    if (select == 'records') {
      return PlayerDetailTable(records: data);
    } else if (select == 'jumpstats') {
      return Container(child: Text('jumpststas'));
    } else if (select == 'stats') {
      return Container(child: Text('stats'));
    }
    return Container();
  }
}
