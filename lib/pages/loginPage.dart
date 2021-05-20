import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:kzstats/common/AppBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/cubit/user_cubit.dart';
import 'package:kzstats/web/json/kzstatsApiPlayer_json.dart';
import 'package:kzstats/web/urls.dart';
import 'package:kzstats/global/userInfo_class.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String steamid64 = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserState userState = context.watch<UserCubit>().state;
    return Scaffold(
      appBar: HomepageAppBar('Login'),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Icon(
              Icons.save_alt,
              size: 80,
              color: Colors.white70,
            ),
            Text(
              'Login through Steam',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              color: primarythemeBlue(),
              child: ListTile(
                title: Text(
                  userState.info.steam64 == ''
                      ? 'You are not logged in'
                      : 'You are logged in as: ${userState.info.name}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                leading: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                trailing: userState.info.steam64 == ''
                    ? Icon(LineariconsFree.cross, color: Colors.red)
                    : Icon(Icons.check, color: Colors.green),
              ),
            ),
            SizedBox(height: 8),
            Card(
              color: primarythemeBlue(),
              elevation: 4.0,
              margin: const EdgeInsets.fromLTRB(36, 8, 36, 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      CommunityMaterialIcons.login,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white,
                    ),
                    onTap: () async {
                      final steamid64 = await Navigator.pushNamed(
                        context,
                        '/steamLogin',
                      );
                      if (steamid64 != null) {
                        BlocProvider.of<UserCubit>(context).load();
                        setState(() {
                          this.steamid64 = steamid64.toString();
                        });
                      }
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(
                      CommunityMaterialIcons.logout,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white,
                    ),
                    onTap: () async {
                      UserInfo user = UserInfo(
                        steam32: '',
                        steam64: '',
                        avatarUrl: '',
                        name: '',
                      );
                      BlocProvider.of<UserCubit>(context).setinfo(user);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            progress(userState),
          ],
        ),
      ),
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

  Widget progress(UserState state) {
    if (!state.loading) return Container();
    return FutureBuilder(
      future: getRequest(
        kzstatsApiPlayerInfoUrl(this.steamid64),
        kzstatsApiPlayerFromJson,
      ),
      builder: (
        BuildContext context,
        AsyncSnapshot<dynamic> snapshot,
      ) {
        return snapshot.connectionState != ConnectionState.done
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.white70,
                ),
              )
            : !snapshot.hasData || snapshot.data == null
                ? failed()
                : success(snapshot.data);
      },
    );
  }

  Widget failed() {
    UserInfo user = UserInfo(steam32: '', steam64: '', avatarUrl: '', name: '');
    BlocProvider.of<UserCubit>(context).setinfo(user);
    return Container();
  }

  Widget success(dynamic data) {
    KzstatsApiPlayer userInfo = data;
    UserInfo user = UserInfo(
      steam32: userInfo.steamid32.toString(),
      steam64: userInfo.steamid.toString(),
      avatarUrl: userInfo.avatarfull ?? '',
      name: userInfo.personaname ?? '',
    );
    BlocProvider.of<UserCubit>(context).setinfo(user);
    return Container();
  }
}
