import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';
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

class _MapsState extends State<Maps> with SingleTickerProviderStateMixin {
  static int pageSize = 12;
  late AnimationController animationController;
  late Animation degOneTranslationAnimatinon,
      degTwoTranslationAnimatinon,
      degThreeTranslationAnimatinon,
      rotationAnimation;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

/*   @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
 */
  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));

    degOneTranslationAnimatinon = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimatinon = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimatinon = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);

    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
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
    );
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

  Widget floater(int tier) {
    return Positioned(
      right: 30,
      bottom: 30,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          IgnorePointer(
              child: Container(
                  color: Colors.transparent, height: 150.0, width: 150.0)),
          subFloater(270, degThreeTranslationAnimatinon, Colors.green,
              Icon(Icons.accessible_forward_sharp), () {}),
          subFloater(225, degTwoTranslationAnimatinon, Colors.yellow,
              Icon(Icons.ac_unit), () {}),
          subFloater(180, degOneTranslationAnimatinon, Colors.red,
              Icon(Icons.access_alarm), () {}),
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
                if (animationController.isCompleted) {
                  animationController.reverse();
                } else {
                  animationController.forward();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Transform subFloater(
    double angle,
    Animation<dynamic> parameter,
    Color color,
    Icon icon,
    Function onClick,
  ) {
    return Transform.translate(
      offset: Offset.fromDirection(
        getRadiansFromDegree(angle),
        parameter.value * 90,
      ),
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
          onClick: onClick,
        ),
      ),
    );
  }

  Future<List<MapInfo>> _loadMore(int limit, int offset, int tier) async =>
      getMaps(limit, offset, multiMapInfoFromJson, tier);

  Widget _itemBuilder(BuildContext context, MapInfo entry, _) {
    return Card(
      color: primarythemeBlue(),
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GetNetworkImage(
            fileName: entry.mapName!,
            url: '$imageBaseURL${entry.mapName!}.webp',
            errorImage: AssetImage('assets/icon/noimage.png'),
            borderWidth: 0,
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
                        color: inkwellBlue(),
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

class CircularFloatingButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final onClick;

  CircularFloatingButton({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
    required this.icon,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: icon,
        enableFeedback: true,
        onPressed: onClick,
      ),
    );
  }
}
