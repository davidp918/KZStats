import 'dart:math';

import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/user_cubit.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kzstats/theme/colors.dart';

class HomepageDrawer extends StatefulWidget {
  @override
  _HomepageDrawerState createState() => _HomepageDrawerState();
}

class _HomepageDrawerState extends State<HomepageDrawer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final UserState userState = context.watch<UserCubit>().state;
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          color: primarythemeBlue(),
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Expanded(flex: 1, child: Container()),
              userState.info.avatarUrl == '' && userState.info.steam32 == ''
                  ? clickToLogin(context)
                  : userHeader(size, userState),
              SizedBox(height: 15),
              Divider(color: Colors.white),
              buildItem(context,
                  text: 'Homepage',
                  icon: Icons.ac_unit,
                  routeName: '/homepage'),
              buildItem(context,
                  text: 'Leaderboard',
                  icon: Icons.person_pin,
                  routeName: '/leaderboard'),
              buildItem(context,
                  text: 'Maps', icon: Icons.map_sharp, routeName: '/maps'),
              buildItem(context,
                  text: 'Bans', icon: Icons.not_interested, routeName: '/bans'),
              Divider(color: Colors.white),
              buildItem(context,
                  text: 'Settings',
                  icon: EvilIcons.gear,
                  routeName: '/settings'),
              buildItem(context,
                  text: 'About', icon: EvilIcons.question, routeName: '/about'),
              Expanded(flex: 2, child: Container()),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(
    BuildContext context, {
    required String text,
    required IconData icon,
    required String routeName,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.start,
          ),
        ),
        onTap: () {
          Navigator.pushReplacementNamed(
            context,
            routeName,
          );
        },
      ),
    );
  }

  Widget clickToLogin(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/login',
        );
      },
      child: Center(
        child: Column(
          children: <Widget>[
            Icon(
              Icons.person_add_alt,
              color: Colors.white,
              size: 120,
            ),
            SizedBox(height: 3),
            Text(
              'Click to login',
              style: TextStyle(fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }

  Widget userHeader(Size size, UserState state) {
    double side = min(size.width * 2 / 5, 185);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/player_detail',
          arguments: [state.info.steam64, state.info.name],
        );
      },
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: side,
              child: GetNetworkImage(
                fileName: state.info.steam32,
                url: state.info.avatarUrl,
                errorImage: AssetImage('assets/icon/noimage.png'),
              ),
            ),
            SizedBox(height: 8),
            Container(
              child: Text(
                state.info.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
