import 'package:flutter/material.dart';
import 'package:kzstats/look/colors.dart';

Widget customDivider(double padding) => Padding(
    padding: EdgeInsets.symmetric(horizontal: padding),
    child: Divider(
      thickness: 0.55,
      color: dividerColor(),
    ));

Widget areaDivider(BuildContext context) => Container(
      width: MediaQuery.of(context).size.width,
      height: 8,
      color: backgroundColor(), //blankAreaColor(),
    );
