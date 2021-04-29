import 'package:flutter/material.dart';
import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/theme/colors.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String steam32Id = '';
  @override
  void initState() {
    super.initState();
    steam32Id = UserSharedPreferences.getSteam32Id() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar('Login page'),
      drawer: HomepageDrawer(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(30),
          children: [
            title(),
            SizedBox(height: 32),
            inputField(),
            SizedBox(height: 30),
            saveButton(),
          ],
        ),
      ),
    );
  }

  Widget inputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
          initialValue: steam32Id,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Your steam 32 ID',
          ),
          onChanged: (val) => setState(() => this.steam32Id = val),
        ),
      ],
    );
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
        'Save',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
      ),
      onPressed: () async {
        await UserSharedPreferences.setSteam32Id(steam32Id);
      },
    );
  }

  Widget title() {
    return Column(
      children: [
        Icon(
          Icons.save_alt,
          size: 100,
          color: Colors.white70,
        ),
        const SizedBox(height: 16),
        Text(
          'Login using your Steam 32 ID!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.w300,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
