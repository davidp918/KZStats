import 'package:flutter/material.dart';

import 'package:kzstats/common/Popup_mode.dart';
import 'SearchBar.dart';

class HomepageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;
  HomepageAppBar(this.currentPage);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 25, 36, 51),
      elevation: 20,
      title: Text(currentPage),
      centerTitle: true,
      actions: <Widget>[
        HomepageSearchBar(),
        PopUpModeSelect(),
      ],
    );
  }

  @override
  // ignore: todo
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(50);
}
