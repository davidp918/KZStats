import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/common/appbars/simpleAppbar.dart';
import 'package:kzstats/common/progressIndicator.dart';
import 'package:kzstats/look/colors.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/cubit/user_cubit.dart';
import 'package:kzstats/web/json/kzstatsApiPlayer_json.dart';
import 'package:kzstats/web/urls.dart';

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
    return SafeArea(
      child: Scaffold(
        appBar: defaultAppbar('Login'),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: Image.asset('assets/icon/steam_icon.png'),
              ),
              Text(
                'Login via Steam',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
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
                    userState.playerInfo.steamid == null
                        ? 'You are not logged in'
                        : 'You are logged in as: ${userState.playerInfo.personaname}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  leading: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  trailing: userState.playerInfo.steamid == null
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
                          if (mounted) {
                            BlocProvider.of<UserCubit>(context).load();
                            setState(() {
                              this.steamid64 = steamid64.toString();
                            });
                          }
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
                        if (mounted)
                          BlocProvider.of<UserCubit>(context)
                              .setinfo(KzstatsApiPlayer());
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
            ? progressIndicator()
            : !snapshot.hasData || snapshot.data == null
                ? failed()
                : success(snapshot.data);
      },
    );
  }

  Widget failed() {
    BlocProvider.of<UserCubit>(context).setinfo(KzstatsApiPlayer());
    return Container();
  }

  Widget success(dynamic data) {
    KzstatsApiPlayer userInfo = data;
    BlocProvider.of<UserCubit>(context).setinfo(userInfo);
    return Container();
  }
}
