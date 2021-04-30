import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'package:kzstats/theme/colors.dart';

class HomepageDrawer extends StatefulWidget {
  @override
  _HomepageDrawerState createState() => _HomepageDrawerState();
}

class _HomepageDrawerState extends State<HomepageDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: primarythemeBlue(),
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            userHeader(
              context,
              name: 'Click to login',
              avatar: Icons.person_add_alt,
              routeName: '/login',
            ),
            SizedBox(height: 15),
            Divider(color: Colors.white),
            buildItem(context,
                text: 'Homepage', icon: Icons.ac_unit, routeName: '/homepage'),
            buildItem(context,
                text: 'Players', icon: Icons.person_pin, routeName: '/players'),
            buildItem(context,
                text: 'Maps', icon: Icons.map_sharp, routeName: '/maps'),
            buildItem(context,
                text: 'Bans', icon: Icons.not_interested, routeName: '/bans'),
            Divider(color: Colors.white),
            buildItem(context,
                text: 'Settings', icon: EvilIcons.gear, routeName: '/settings'),
            buildItem(context,
                text: 'About', icon: EvilIcons.question, routeName: '/about'),
          ],
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
    final color = Colors.white;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          color: color,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: color,
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

  Widget userHeader(
    BuildContext context, {
    required String name,
    required IconData avatar,
    required String routeName,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacementNamed(
          context,
          routeName,
        );
      },
      child: Center(
        child: Column(
          children: <Widget>[
            Icon(
              avatar,
              color: Colors.white,
              size: 100,
            ),
            SizedBox(height: 5),
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
