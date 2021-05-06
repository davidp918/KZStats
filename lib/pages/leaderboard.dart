import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/common/datatables/leaderboard_points_datatable.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/cubit/mode_cubit.dart';
import 'package:kzstats/global/responsive.dart';
import 'package:kzstats/global/sizeInfo_class.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json.dart';
import 'package:kzstats/web/urls.dart';
import 'package:kzstats/utils/convertDegreeRad.dart';
import 'package:kzstats/global/floater.dart';
import 'package:kzstats/cubit/leaderboard_cubit.dart';
import 'package:kzstats/common/datatables/leaderboard_records_datatable.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      ifDrawer: true,
      currentPage: 'Leaderboard',
      builder: (context, constraints) {
        final modeState = context.watch<ModeCubit>().state;
        final typeState = context.watch<LeaderboardCubit>().state;
        return FutureBuilder(
          future: typeState.type == 'points'
              ? getRequest(
                  globalApiLeaderboardPoints(
                      modeState.mode, modeState.nub, 100),
                  leaderboardPointsFromJson,
                )
              : getRequest(
                  globalApiLeaderboardRecords(
                      modeState.mode, modeState.nub, 100),
                  leaderboardRecordsFromJson,
                ),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return transition(snapshot, constraints, typeState.type);
          },
        );
      },
    );
  }

  Widget transition(
      AsyncSnapshot<dynamic> snapshot, SizeInfo constraints, String type) {
    return snapshot.connectionState == ConnectionState.done
        ? snapshot.hasData && snapshot.data != null
            ? mainBody(
                snapshot.data,
                constraints,
                type,
              )
            : errorScreen()
        : loadingFromApi();
  }

  Widget mainBody(
    List<dynamic> data,
    SizeInfo constraints,
    String type,
  ) {
    return Container(
      width: constraints.width,
      height: constraints.height,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: ListView(
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
                    ? LeaderboardPointsTable(
                        data: data as List<LeaderboardPoints>)
                    : LeaderboardRecordsTable(
                        data: data as List<LeaderboardRecords>),
              ],
            ),
          ),
          LeaderboardFloater(),
        ],
      ),
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
