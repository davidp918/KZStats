import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:steam_login/steam_login.dart';

class SteamLogin extends StatelessWidget {
  final _webView = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    // Listen to the onUrlChanged events, and when we are ready to validate do so.
    _webView.onUrlChanged.listen(
      (String url) async {
        var openId = OpenId.fromUri(Uri.parse(url));
        if (openId.mode == 'id_res') {
          await _webView.close();
          Navigator.of(context).pop(openId.validate());
        }
      },
    );

    var openId = OpenId.raw('https://kzstats', 'https://kzstats/', {});
    return WebviewScaffold(
      url: openId.authUrl().toString(),
      appBar: AppBar(
        title: Text('Steam Login'),
      ),
    );
  }
}
