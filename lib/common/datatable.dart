import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kzstats/others/strCheckLen.dart';
import 'package:kzstats/others/timeConversion.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/web/json/mapTop_json.dart';
import 'package:kzstats/others/pointsClassification.dart';

Widget buildPaginatedDataTable(BuildContext context, List<dynamic>? records) {
  return Theme(
    data: Theme.of(context).copyWith(
      cardColor: Color(0xff1D202C),
      dividerColor: Color(0xff333333),
    ),
    child: buildDataTable(context, records as List<Record>?),
  );
}

Widget buildDataTable(BuildContext context, List<Record>? mapTop) {
  final columns = [
    '#',
    'Player',
    'Time',
    'Points',
    'TPs',
    'Date',
    'Server',
  ];
  List<DataColumn> getColumns(List<String> columns) => columns
      .map(
        (String column) => DataColumn(
          label: Text(
            '$column',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      )
      .toList();

  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: PaginatedDataTable(
      dragStartBehavior: DragStartBehavior.down,
      headingRowHeight: 40,
      dataRowHeight: 42,
      horizontalMargin: 12,
      columnSpacing: 20,
      columns: getColumns(columns),
      source: RecordsSource(context, mapTop),
    ),
  );
}

class RecordsSource extends DataTableSource {
  BuildContext context;
  List<Record>? _records;
  RecordsSource(this.context, this._records);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _records!.length) return null;
    final Record record = _records![index];
    return DataRow.byIndex(
      index: index,
      color: MaterialStateColor.resolveWith(
        (states) {
          if (index % 2 == 0) {
            return primarythemeBlue();
          } else {
            return secondarythemeBlue();
          }
        },
      ),
      cells: <DataCell>[
        DataCell(
          Text(
            '#${[index, 1].reduce((a, b) => a + b)}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        DataCell(
          InkWell(
            onTap: () => Navigator.of(context).pushNamed(
              '/player_detail',
              arguments: [
                record.steamid64,
                record.playerName,
              ],
            ),
            child: Text(
              '${lenCheck(record.playerName!, 15)}',
              style: TextStyle(color: inkwellBlue()),
            ),
          ),
        ),
        DataCell(
          Text(
            '${toMinSec(record.time!)}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        DataCell(
          classifyPoints(record.points),
        ),
        DataCell(
          Text(
            '${record.teleports}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        DataCell(
          Text(
            '${record.createdOn.toString()}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        DataCell(
          Text(
            '${record.serverName}',
            style: TextStyle(
              color: inkwellBlue(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _records!.length;

  @override
  int get selectedRowCount => 0;
}
