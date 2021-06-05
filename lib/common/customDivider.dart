import 'package:flutter/material.dart';
import 'package:kzstats/look/colors.dart';

Widget customDivider(double padding) => Padding(
    padding: EdgeInsets.symmetric(horizontal: padding),
    child: Divider(
      color: dividerColor(),
    ));
