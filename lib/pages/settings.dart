import 'package:flutter/material.dart';
import 'package:kzstats/data/shared_preferences.dart';

import 'package:kzstats/global/responsive.dart';
import 'package:kzstats/global/userInfo_class.dart';
import 'package:kzstats/theme/colors.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      ifDrawer: true,
      currentPage: 'Settings',
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.all(40),
          child: Center(
            child: Column(
              children: [
                logOutButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget logOutButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: primarythemeBlue(),
        minimumSize: Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        'Log out',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
      ),
      onPressed: () async {
        UserInfo user = UserInfo(
          steam32: '',
          steam64: '',
          avatarUrl: '',
          name: '',
        );
        await UserSharedPreferences.setUserInfo(user);
      },
    );
  }
}
