import 'package:flutter/material.dart';
import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';
import 'package:kzstats/global/sizeInfo_class.dart';

class ResponsiveWidget extends StatelessWidget {
  final currentPage;
  final bool ifDrawer;
  final Widget Function(
    BuildContext context,
    SizeInfo constraints,
  ) builder;

  ResponsiveWidget({
    Key? key,
    required this.ifDrawer,
    required this.currentPage,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var orientation = MediaQuery.of(context).orientation;

    SizeInfo information = SizeInfo(
      width,
      height,
      orientation,
    );

    return SafeArea(
      child: Scaffold(
        appBar: HomepageAppBar(currentPage),
        drawer: ifDrawer ? HomepageDrawer() : null,
        resizeToAvoidBottomInset: false,
        body: builder(context, information),
      ),
    );
  }
}
