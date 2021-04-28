import 'package:flutter/material.dart';
import 'package:kzstats/others/pointsClassification.dart';
import 'package:kzstats/others/strCheckLen.dart';
import 'package:kzstats/others/timeConversion.dart';
import 'package:kzstats/theme/colors.dart';

DataCell indexDataCell(int index) {
  return DataCell(
    Text(
      '#${[index, 1].reduce((a, b) => a + b)}',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

DataCell playerNameDataCell(
  BuildContext context,
  dynamic record,
) {
  return DataCell(
    InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        '/player_detail',
        arguments: [
          record.steamid64!,
          record.playerName!,
        ],
      ),
      child: Text(
        '${Characters(lenCheck(record.playerName!, 15))}',
        style: TextStyle(color: inkwellBlue()),
      ),
    ),
  );
}

DataCell timeDataCell(dynamic record) {
  return DataCell(
    Text(
      '${toMinSec(record.time!)}',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

DataCell pointsDataCell(dynamic record) {
  return DataCell(
    classifyPoints(record.points),
  );
}

DataCell teleportsDataCell(dynamic record) {
  return DataCell(
    Text(
      '${record.teleports}',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

DataCell createdOnDataCell(dynamic record) {
  return DataCell(
    Text(
      '${record.createdOn.toString()}',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

DataCell serverNameDataCell(dynamic? record) {
  late Characters re;
  record.serverName == null
      ? re = Characters('<Unknown>')
      : re = Characters(record.serverName);
  return DataCell(
    Text(
      '$re',
      style: TextStyle(
        color: inkwellBlue(),
      ),
    ),
  );
}

DataCell mapNameDataCell(
  BuildContext context,
  dynamic record,
) {
  return DataCell(
    InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        '/map_detail',
        arguments: record,
      ),
      child: Text(
        '${record.mapName}',
        style: TextStyle(color: inkwellBlue()),
      ),
    ),
  );
}

int compareString(bool ascending, dynamic value1, dynamic value2) =>
    ascending ? value1.compareTo(value2) : value2.compareTo(value1);
