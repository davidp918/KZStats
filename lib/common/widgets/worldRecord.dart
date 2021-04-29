import 'package:flutter/material.dart';
import 'package:kzstats/utils/svg.dart';
import 'package:kzstats/utils/timeConversion.dart';

Widget worldRecordRow(String prefix, dynamic wr) {
  return wr == null
      ? Container()
      : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            gold(15, 15),
            SizedBox(
              width: 4,
            ),
            Text(
              '$prefix  ${toMinSec(wr?.time)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            Text(
              ' by ${wr.playerName}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 3,
            ),
          ],
        );
}
