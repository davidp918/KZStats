import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget getKzstatsApiPlayerFlag(BuildContext context, AsyncSnapshot snapshot) {
  return snapshot.hasData
      ? snapshot.data.loccountrycode != null
          ? Image(
              image: AssetImage(
                  'assets/flag/${snapshot.data.loccountrycode.toString().toLowerCase()}.png'))
          : Container()
      : Container();
}
