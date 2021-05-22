import 'dart:ui';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';
import 'package:kzstats/common/widgets/toggleButton.dart';
import 'package:kzstats/cubit/notification_cubit.dart';
import 'package:kzstats/data/shared_preferences.dart';

import 'package:kzstats/global/userInfo_class.dart';
import 'package:kzstats/theme/colors.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late UserInfo user;
  late bool enabled;

  @override
  void initState() {
    super.initState();
    user = UserSharedPreferences.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar('Settings'),
      drawer: HomepageDrawer(),
      body: SingleChildScrollView(
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
                onTap: () async => Navigator.pushNamed(context, '/login'),
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
              margin: const EdgeInsets.fromLTRB(32, 8, 32, 6),
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
                    onTap: () {
                      //Navigator.pushNamed(context, '/table_layout');
                    },
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
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 6),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  'coming soon...',
                  style: TextStyle(
                    color: colorLight(),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            _buildDivider(),
            SizedBox(height: 16),
            Text(
              "Notification Settings",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            notificationArea(),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Internet connection required',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget notificationArea() {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        return Column(
          children: [
            SwitchListTile(
              title: Text(
                'Enable Notification',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                '- get subscribed to the latest wr',
                style: TextStyle(
                  color: colorLight(),
                  fontSize: 12,
                ),
              ),
              activeColor: Colors.white70,
              contentPadding: EdgeInsets.all(0),
              value: state.enabled,
              onChanged: (val) {
                BlocProvider.of<NotificationCubit>(context).toggleEnabled();
              },
            ),
            !state.enabled
                ? Container()
                : Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Mode selections:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          ToggleButtons(
                            renderBorder: false,
                            children: [
                              Text('KZT',
                                  style: TextStyle(color: Colors.white)),
                              Text('SKZ',
                                  style: TextStyle(color: Colors.white)),
                              Text('VNL',
                                  style: TextStyle(color: Colors.white)),
                            ],
                            isSelected: [
                              state.kzt,
                              state.skz,
                              state.vnl,
                            ],
                            onPressed: (index) {
                              if (index == 0) {
                                BlocProvider.of<NotificationCubit>(context)
                                    .toggleKZT();
                              } else if (index == 1) {
                                BlocProvider.of<NotificationCubit>(context)
                                    .toggleSKZ();
                              } else if (index == 2) {
                                BlocProvider.of<NotificationCubit>(context)
                                    .toggleVNL();
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'NUB / PRO:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          ToggleButtons(
                            renderBorder: false,
                            children: [
                              Text('PRO',
                                  style: TextStyle(color: Colors.white)),
                              Text('NUB',
                                  style: TextStyle(color: Colors.white)),
                            ],
                            isSelected: [
                              !state.nub,
                              state.nub,
                            ],
                            onPressed: (index) {
                              if (index == 0) {
                                BlocProvider.of<NotificationCubit>(context)
                                    .toggleNUB();
                              } else if (index == 1) {
                                BlocProvider.of<NotificationCubit>(context)
                                    .toggleNUB();
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Frequency:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          ToggleButtons(
                            renderBorder: false,
                            children: [
                              Text('    Always    ',
                                  style: TextStyle(color: Colors.white)),
                              Text('    Usually    ',
                                  style: TextStyle(color: Colors.white)),
                            ],
                            isSelected: [true, false],
                            onPressed: (index) {
                              // TODO: implement last notify time condition
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
          ],
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
