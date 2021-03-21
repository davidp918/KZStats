import 'package:flutter/material.dart';

import 'homepagesearchBar.dart';

class HomepageAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 25, 36, 51),
      elevation: 20,
      title: Text('KZStats'),
      centerTitle: true,
      actions: <Widget>[
        HomepageSearchBar(),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(50);
}
