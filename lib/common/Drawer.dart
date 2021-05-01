import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/data/shared_preferences.dart';

import 'package:kzstats/theme/colors.dart';

class HomepageDrawer extends StatefulWidget {
  @override
  _HomepageDrawerState createState() => _HomepageDrawerState();
}

class _HomepageDrawerState extends State<HomepageDrawer> {
  late String name, avatar, steam64Id, steam32Id;
  @override
  void initState() {
    super.initState();
    steam64Id = UserSharedPreferences.getSteam64() ?? '';
    steam32Id = UserSharedPreferences.getSteam32() ?? '';
    name = UserSharedPreferences.getName() ?? '';
    avatar = UserSharedPreferences.getAvatar() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: primarythemeBlue(),
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            this.name == '' ? clickToLogin(context) : userHeader(),
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

  Widget clickToLogin(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacementNamed(
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
              size: 100,
            ),
            SizedBox(height: 5),
            Text(
              'Click to login',
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget userHeader() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/player_detail',
          arguments: [this.steam64Id, this.name],
        );
      },
      child: Center(
        child: Column(
          children: <Widget>[
            GetNetworkImage(
              fileName: this.steam32Id,
              url: this.avatar,
              errorImage: AssetImage('assets/icon/noimage.png'),
              borderWidth: 2,
            ),
            Text(
              this.name,
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
