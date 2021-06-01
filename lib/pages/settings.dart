import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/common/appbar_widgets.dart';
import 'package:kzstats/common/appbars/baseAppbar.dart';
import 'package:kzstats/common/appbars/simpleAppbar.dart';
import 'package:kzstats/cubit/notification_cubit.dart';
import 'package:kzstats/cubit/user_cubit.dart';
import 'package:kzstats/theme/colors.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late ScrollController _scrollController;
  late Widget appbar;
  @override
  void initState() {
    super.initState();
    this._scrollController = ScrollController();
    this.appbar = BaseAppBar('Settings', true, [
      searchWidget(context),
      PopUpModeSelect(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    UserState state = context.watch<UserCubit>().state;
    String steamid64 = state.info.steam64;
    String name = state.info.name;
    return NestedScrollView(
      controller: this._scrollController,
      headerSliverBuilder: (BuildContext context, _) => <Widget>[this.appbar],
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
                onTap: () => Navigator.pushNamed(context, '/login'),
                title: Text(
                  steamid64 == '' ? 'Click to Login' : '$name',
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
              margin: const EdgeInsets.fromLTRB(32, 6, 32, 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: <Widget>[
                  /*      ListTile(
                    leading: Icon(
                      Icons.brightness_6_outlined,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Change Theme',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Icon(
                      EvaIcons.moonOutline,
                      color: Colors.white,
                    ),
                    onTap: () {
                      //open change password
                    },
                  ),
                  _buildDivider(), */
                  ListTile(
                    leading: Icon(
                      EvilIcons.question,
                      color: Colors.white,
                    ),
                    title: Text(
                      'About',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/about');
                    },
                  ),
                ],
              ),
            ),
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
              alignment: Alignment.topRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  permissionText(),
                  Text(
                    'Note that: Internet required',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
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
                            fillColor: appbarColor().withOpacity(0.4),
                            borderColor: appbarColor().withOpacity(0.35),
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
                            fillColor: appbarColor().withOpacity(0.4),
                            borderColor: appbarColor().withOpacity(0.35),
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
                      SizedBox(height: 5),
                    ],
                  ),
          ],
        );
      },
    );
  }

  Widget permissionText() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    return FutureBuilder(
      future: messaging.getNotificationSettings(),
      builder:
          (BuildContext context, AsyncSnapshot<NotificationSettings> snapshot) {
        String txt = 'Detecting...';
        if (snapshot.hasData) {
          if (snapshot.data?.authorizationStatus ==
              AuthorizationStatus.authorized) {
            txt = 'Allowed';
          } else {
            txt = 'Denied';
          }
        }
        return Text(
          'System notification settings: $txt',
          style: TextStyle(
            color: txt == 'Denied' ? Colors.red.shade200 : Colors.white54,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        );
      },
    );
  }
}
