import 'dart:io';

import 'package:flutter/material.dart';
import 'package:steam_login/steam_login.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:kzstats/look/colors.dart';

class SteamLogin extends StatefulWidget {
  @override
  _SteamLoginState createState() => _SteamLoginState();
}

class _SteamLoginState extends State<SteamLogin> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    var openId = OpenId.raw('https://kzstats', 'https://kzstats/', {});
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appbarColor(),
          elevation: 20,
          title: Text('Steam Login'),
          centerTitle: true,
          brightness: Brightness.dark,
        ),
        body: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: openId.authUrl().toString(),
          navigationDelegate: (navigation) {
            var openId = OpenId.fromUri(Uri.parse(navigation.url));
            if (openId.mode == 'id_res') {
              Navigator.of(context).pop(openId.validate());
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}
