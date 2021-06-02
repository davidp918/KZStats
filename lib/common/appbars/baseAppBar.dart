import 'package:flutter/material.dart';
import 'package:kzstats/common/appbars/appbar_widgets.dart';

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
      brightness: Brightness.dark,
      actions: this.actions,
    );
  }
}
