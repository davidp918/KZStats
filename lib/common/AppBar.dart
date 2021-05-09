import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'package:kzstats/common/Popup_mode.dart';
import 'package:kzstats/theme/colors.dart';

class HomepageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;
  HomepageAppBar(this.currentPage);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appbarColor(),
      elevation: 20,
      title: Text(currentPage),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(EvilIcons.search),
          onPressed: () {
            Navigator.pushNamed(context, '/search');
          },
        ),
        PopUpModeSelect(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
