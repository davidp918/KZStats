import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:kzstats/data/shared_preferences.dart';

import 'package:kzstats/global/responsive.dart';
import 'package:kzstats/global/userInfo_class.dart';
import 'package:kzstats/theme/colors.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late UserInfo user;

  @override
  void initState() {
    super.initState();
    user = UserSharedPreferences.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      ifDrawer: true,
      currentPage: 'Settings',
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: primarythemeBlue(),
                child: ListTile(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      '/login',
                    );
                  },
                  title: Text(
                    user.name == '' ? 'Click to Login' : '${user.name}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  leading: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  trailing: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Card(
                color: primarythemeBlue(),
                elevation: 4.0,
                margin: const EdgeInsets.fromLTRB(32, 8, 32, 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        CommunityMaterialIcons.table,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Change Table Layout',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white,
                      ),
                      onTap: () =>
                          Navigator.pushNamed(context, '/table_layout'),
                    ),
                    _buildDivider(),
                    ListTile(
                      leading: Icon(
                        Icons.brightness_6_outlined,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Change Theme',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white,
                      ),
                      onTap: () {
                        //open change password
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: double.infinity,
      height: 1.0,
      color: Colors.white30,
    );
  }
}
