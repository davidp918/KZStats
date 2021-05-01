import 'package:flutter/material.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/global/responsive.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/utils/checkisNum.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json/kzstatsApiPlayer_json.dart';
import 'package:kzstats/web/urls.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String steam64, name;

  late bool validatedAsNum,
      validatedLen,
      isLoggedIn,
      showLogging,
      showErrorSection;
  @override
  void initState() {
    super.initState();
    name = UserSharedPreferences.getName() ?? '';
    steam64 = UserSharedPreferences.getSteam64() ?? '';
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
            saveButton(),
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

  Widget saveButton() {
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

  List<Widget> title() {
    return <Widget>[
      Icon(
        Icons.save_alt,
        size: 100,
        color: Colors.white70,
      ),
      const SizedBox(height: 16),
      Text(
        'Login using your Steam 64 ID',
        style: TextStyle(
          color: Colors.white,
          fontSize: 38,
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
    return Text('You are now logged in as: ${userInfo.personaname}');
  }

  saveToSharedPreferences(KzstatsApiPlayer userInfo) async {
    await UserSharedPreferences.setAvatar(userInfo.avatarfull!);
    await UserSharedPreferences.setName(userInfo.personaname!);
    await UserSharedPreferences.setSteam64Id(steam64);
    await UserSharedPreferences.setSteam32Id(userInfo.steamid32.toString());
  }

  Widget loginFailed() {
    return Text('Could not login');
  }
}
