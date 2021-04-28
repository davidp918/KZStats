import 'package:flutter/material.dart';
import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);
  static const String currentPage = 'Login page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar(currentPage),
      drawer: HomepageDrawer(),
    );
  }
}
