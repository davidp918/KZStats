import 'package:flutter/material.dart';

import 'package:kzstats/details/Players.dart';
import 'package:kzstats/details/bans.dart';
import 'package:kzstats/details/homepage.dart';
import 'package:kzstats/details/jumpstats.dart';
import 'package:kzstats/details/maps.dart';
import 'package:kzstats/details/profile.dart';
import 'package:kzstats/details/servers.dart';
import 'package:kzstats/details/settings.dart';
import 'package:kzstats/others/steamLogin.dart';

class HomepageDrawer extends StatefulWidget {
  const HomepageDrawer({Key key}) : super(key: key);
  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<HomepageDrawer> {
  String steamId;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(5),
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Column(
                children: <Widget>[
                  /*
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 20,
                      bottom: 15,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/d0/d0039fa17e2ebb41db418fe2ee0e4ecceadbbd8b_full.jpg',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  */
                  IconButton(
                    icon: Image(
                      image: AssetImage('assets/login-steam.png'),
                    ),
                    iconSize: 200,
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SteamLogin()),
                      );
                      setState(() {
                        steamId = result;
                      });
                    },
                  ),
                  Text(
                    steamId == null
                        ? 'Click to Login to steam'
                        : 'You are logged in as $steamId',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person_pin_rounded),
            title: Text(
              'Profile',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text(
              'Homepage',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Homepage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text(
              'Maps',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Maps()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Players',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Players()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.run_circle),
            title: Text(
              'Jumpstats',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Jumpstats()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.book_online_outlined),
            title: Text(
              'Servers',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Servers()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.not_interested),
            title: Text(
              'Bans',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bans()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_applications),
            title: Text(
              'Settings',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              );
            },
          ),
        ],
      ),
    );
  }
}
