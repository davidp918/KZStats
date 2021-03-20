import 'package:flutter/material.dart';

import 'homepagesearchBar.dart';

class HomepageAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF192433),
      title: Text('KZStats'),
      actions: <Widget>[
        HomepageSearchBar(),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(50);
}
