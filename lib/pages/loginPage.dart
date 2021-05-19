import 'package:flutter/material.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/global/responsive.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/utils/checkisNum.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json/kzstatsApiPlayer_json.dart';
import 'package:kzstats/web/urls.dart';
import 'package:kzstats/global/userInfo_class.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late UserInfo user;
  late String steam64;

  late bool validatedAsNum,
      validatedLen,
      isLoggedIn,
      showLogging,
      showErrorSection;
  @override
  void initState() {
    super.initState();
    user = UserSharedPreferences.getUserInfo();
    steam64 = user.steam64;
    validatedAsNum = false;
    validatedLen = false;
    showErrorSection = false;
    isLoggedIn = steam64 == '' ? false : true;
    showLogging = false;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      currentPage: 'Login page',
      ifDrawer: true,
      builder: (context, constraints) => Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            ...title(),
            SizedBox(height: 32),
            ...inputField(),
            SizedBox(height: 30),
            loginButton(),
            SizedBox(height: 15),
            logOutButton(),
            SizedBox(height: 15),
            errorSection(),
            showLoggedIn(),
          ],
        ),
      ),
    );
  }

  List<Widget> inputField() {
    return [
      Text(
        'Steam ID',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w300,
          fontSize: 18,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        initialValue: steam64,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Your steam 64 ID',
        ),
        onChanged: (val) {
          setState(() => this.steam64 = val);
        },
      ),
    ];
  }

  Widget loginButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: primarythemeBlue(),
        minimumSize: Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        'Login',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
      ),
      onPressed: () async {
        showErrorSection = true;

        setState(() {
          if (isNumber(this.steam64)) {
            validatedAsNum = true;
          } else {
            validatedAsNum = false;
          }
          if (this.steam64.length == 17) {
            validatedLen = true;
          } else {
            validatedLen = false;
          }
        });

        if (validatedAsNum && validatedLen) {
          setState(() {
            showLogging = true;
          });
        }
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
        Navigator.pushReplacementNamed(
          context,
          '/login',
        );
      },
    );
  }

  List<Widget> title() {
    return <Widget>[
      Icon(
        Icons.save_alt,
        size: 80,
        color: Colors.white70,
      ),
      const SizedBox(height: 16),
      Text(
        'Login using your Steam 64 ID',
        style: TextStyle(
          color: Colors.white,
          fontSize: 34,
          fontWeight: FontWeight.w300,
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }

  Widget errorSection() {
    return showErrorSection
        ? Column(
            children: [
              validatedAsNum == false
                  ? Text('Steam 64 Id should only consists of numbers')
                  : Container(),
              validatedLen == false
                  ? Text('Steam 64 Id should be 17 characters long')
                  : Container(),
            ],
          )
        : Container();
  }

  Widget showLoggedIn() {
    return showLogging
        ? FutureBuilder(
            future: getRequest(
              kzstatsApiPlayerInfoUrl(this.steam64),
              kzstatsApiPlayerFromJson,
            ),
            builder: (
              BuildContext context,
              AsyncSnapshot<dynamic> snapshot,
            ) {
              return snapshot.connectionState == ConnectionState.done
                  ? snapshot.hasData
                      ? loginSucceed(snapshot.data)
                      : loginFailed()
                  : Center(child: CircularProgressIndicator());
            },
          )
        : Container();
  }

  Widget loginSucceed(KzstatsApiPlayer userInfo) {
    saveToSharedPreferences(userInfo);
    return Text('You are logged in as: ${userInfo.personaname}');
  }

  saveToSharedPreferences(KzstatsApiPlayer userInfo) async {
    UserInfo user = UserInfo(
      steam32: userInfo.steamid32.toString(),
      steam64: this.steam64,
      avatarUrl: userInfo.avatarfull ?? '',
      name: userInfo.personaname ?? '',
    );
    await UserSharedPreferences.setUserInfo(user);
  }

  Widget loginFailed() {
    return Text('Could not login');
  }
}
