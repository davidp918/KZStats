import 'package:flutter/material.dart';
import 'package:kzstats/theme/colors.dart';

PreferredSizeWidget defaultAppbar(String title) => PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight * 0.9),
      child: AppBar(
        backgroundColor: appbarColor(),
        centerTitle: true,
        brightness: Brightness.dark,
        title: Text('$title'),
      ),
    );
