import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/data/shared_preferences.dart';

import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/global/userInfo_class.dart';

class HomepageDrawer extends StatefulWidget {
  @override
  _HomepageDrawerState createState() => _HomepageDrawerState();
}

class _HomepageDrawerState extends State<HomepageDrawer> {
  late UserInfo user;
  @override
  void initState() {
    super.initState();
    user = UserSharedPreferences.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: Container(
        color: primarythemeBlue(),
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            this.user.avatarUrl == '' && this.user.steam32 == ''
                ? clickToLogin(context)
                : userHeader(size),
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

  Widget userHeader(Size size) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/player_detail',
          arguments: [this.user.steam64, this.user.name],
        );
      },
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.width * 2 / 5,
              child: FittedBox(
                fit: BoxFit.fill,
                child: GetNetworkImage(
                  fileName: this.user.steam32,
                  url: this.user.avatarUrl,
                  errorImage: AssetImage('assets/icon/noimage.png'),
                  borderWidth: 2,
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              child: Text(
                this.user.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
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
