import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kzstats/common/appbars/appbar_widgets.dart';
import 'package:kzstats/look/colors.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;
  final bool showProfile;
  final List<Widget>? actions;
  final double? height;
  BaseAppBar(this.currentPage, this.showProfile, [this.actions, this.height]);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      brightness: Brightness.dark,
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: appbarColor(),
        statusBarBrightness: Brightness.dark,
      ),
      backgroundColor: appbarColor(),
      floating: true,
      pinned: false,
      toolbarHeight: height ?? kToolbarHeight * 0.9,
      snap: false,
      centerTitle: !this.showProfile,
      leading: showProfile ? userLeadingIcon(context) : null,
      title: Text(
        '$currentPage',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      //brightness: Brightness.dark,
      actions: this.actions,
    );
  }
}
