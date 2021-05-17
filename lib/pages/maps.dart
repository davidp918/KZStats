import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/tier_cubit.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/utils/tierIdentifier.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:kzstats/web/urls.dart';
import 'package:line_icons/line_icons.dart';
import 'package:kzstats/utils/convertDegreeRad.dart';
import 'package:kzstats/global/floater.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> with SingleTickerProviderStateMixin {
  static int pageSize = 12;
  late AnimationController animationController;
  late Animation oneAnimation,
      twoAnimation,
      threeAnimation,
      fourAnimation,
      fiveAnimation,
      sixAnimation,
      sevenAnimation,
      zeroAnimation,
      rotationAnimation;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
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
    threeAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);
    fourAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.1), weight: 85.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.1, end: 1.0), weight: 15.0),
    ]).animate(animationController);
    fiveAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.3), weight: 70.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.3, end: 1.0), weight: 30.0),
    ]).animate(animationController);
    sixAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.5), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.5, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    sevenAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.7), weight: 40.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.7, end: 1.0), weight: 60.0),
    ]).animate(animationController);
    zeroAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.9), weight: 25.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.9, end: 1.0), weight: 75.0),
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: HomepageAppBar('Maps'),
      drawer: HomepageDrawer(),
      body: BlocBuilder<TierCubit, TierState>(
        builder: (context, state) {
          return Container(
            width: size.width,
            height: size.height,
            child: Stack(
              children: <Widget>[
                mapsGridView(state.tier),
                floater(state.tier),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget mapsGridView(int tier) {
    return PagewiseGridView.count(
      pageSize: pageSize,
      crossAxisCount: 2,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      childAspectRatio: 1,
      padding: EdgeInsets.all(15.0),
      itemBuilder: _itemBuilder,
      pageFuture: (pageIndex) =>
          _loadMore(pageSize, pageIndex! * pageSize, tier),
      loadingBuilder: (context) => loadingFromApi(),
    );
  }

  Widget floater(int tier) {
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

  Transform subFloater(double angle, Animation<dynamic> parameter,
      double magnitude, Color color, Icon icon, int newTier) {
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
            BlocProvider.of<TierCubit>(context).set(newTier);
            print(newTier);
            Navigator.pushReplacementNamed(context, '/maps');
          },
        ),
      ),
    );
  }

  List<Transform> subFloaters() {
    return [
      subFloater(270, zeroAnimation, 140, Colors.white70,
          Icon(Icons.looks_5_outlined), 5),
      subFloater(248, sevenAnimation, 140, Colors.white70,
          Icon(Icons.looks_4_outlined), 4),
      subFloater(225, sixAnimation, 140, Colors.white70,
          Icon(Icons.looks_3_outlined), 3),
      subFloater(202, fiveAnimation, 140, Colors.white70,
          Icon(Icons.looks_two_outlined), 2),
      subFloater(180, fourAnimation, 140, Colors.white70,
          Icon(Icons.looks_one_outlined), 1),
      subFloater(
          265, threeAnimation, 80, Colors.white70, Icon(LineIcons.trash), 7),
      subFloater(
          225, twoAnimation, 80, Colors.white70, Icon(Icons.home_outlined), 0),
      subFloater(185, oneAnimation, 80, Colors.white70,
          Icon(Icons.looks_6_outlined), 6),
    ];
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
