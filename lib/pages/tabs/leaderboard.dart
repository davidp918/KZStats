import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/common/widgets/datatable.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/cubit/mode_cubit.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json.dart';
import 'package:kzstats/web/urls.dart';
import 'package:kzstats/utils/convertDegreeRad.dart';
import 'package:kzstats/global/floater.dart';
import 'package:kzstats/cubit/leaderboard_cubit.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<Leaderboard> {
  late ModeState modeState;
  late LeaderboardState typeState;
  late Future _future;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    modeState = context.watch<ModeCubit>().state;
    typeState = context.watch<LeaderboardCubit>().state;
    this._future = typeState.type == 'points'
        ? getRequest(
            globalApiLeaderboardPoints(modeState.mode, modeState.nub, 100),
            leaderboardPointsFromJson,
          )
        : getRequest(
            globalApiLeaderboardRecords(modeState.mode, modeState.nub, 100),
            leaderboardRecordsFromJson,
          );
  }

  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.connectionState == ConnectionState.done
            ? snapshot.hasData && snapshot.data != null
                ? mainBody(
                    snapshot.data,
                    typeState.type,
                  )
                : errorScreen()
            : loadingFromApi();
      },
    );
  }

  Widget mainBody(List<dynamic> data, String type) {
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.symmetric(horizontal: 8),
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            SizedBox(height: 12),
            Center(
              child: Text(
                'Top - $type',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 8),
            type == 'points'
                ? CustomDataTable(
                    data: data,
                    columns: [
                      '#',
                      'Player',
                      'Average',
                      'Rating',
                      'Finishes',
                      'Points in total'
                    ],
                    initialSortedColumnIndex: 3,
                    initialAscending: false,
                  )
                : CustomDataTable(
                    data: data,
                    columns: ['#', 'Player', 'Count'],
                    initialSortedColumnIndex: 2,
                    initialAscending: false,
                  ),
            Container(height: 100),
          ],
        ),
        LeaderboardFloater(),
      ],
    );
  }
}

class LeaderboardFloater extends StatefulWidget {
  LeaderboardFloater({Key? key}) : super(key: key);

  @override
  _LeaderboardFloaterState createState() => _LeaderboardFloaterState();
}

class _LeaderboardFloaterState extends State<LeaderboardFloater>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation oneAnimation, twoAnimation, rotationAnimation;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));

    oneAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    twoAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
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
          Icon(CommunityMaterialIcons.alpha_r_circle_outline), 'records'),
      subFloater(200, oneAnimation, 100, Colors.white70,
          Icon(CommunityMaterialIcons.alpha_p_circle_outline), 'points'),
    ];
  }

  Transform subFloater(
    double angle,
    Animation<dynamic> parameter,
    double magnitude,
    Color color,
    Icon icon,
    String newType,
  ) {
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
            BlocProvider.of<LeaderboardCubit>(context).set(newType);
          },
        ),
      ),
    );
  }
}
