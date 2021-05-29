import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/utils/pointsClassification.dart';
import 'package:kzstats/utils/timeConversion.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CustomDataTable extends StatefulWidget {
  final List<dynamic> data;
  final List<String> columns;
  final int initialSortedColumnIndex;
  final bool initialAscending;
  CustomDataTable({
    Key? key,
    required this.data,
    required this.columns,
    required this.initialSortedColumnIndex,
    required this.initialAscending,
  }) : super(key: key);

  @override
  _CustomDataTableState createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  List<Map<String, dynamic>> data = [];
  late int _sortColumnIndex;
  late Map<String, String> identifyAttr;
  late bool _isAscending;
  late List<GridTextColumn> _columns;

  @override
  void initState() {
    super.initState();
    this.identifyAttr = {
      '#': widget.columns[widget.initialSortedColumnIndex],
      'Player': 'playerName',
      'Count': 'count',
      'Average': 'average',
      'Points': 'points',
      'Rating': 'rating',
      'Finishes': 'finishes',
      'Map': 'mapName',
      'Time': 'time',
      'TPs': 'teleports',
      'Date': 'createdOn',
      'Server': 'serverName',
      'Points in total': 'totalPoints',
    };
    this._columns = widget.columns
        .map(
          (String column) => GridTextColumn(
              columnName: column,
              label: Text('$column',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
              allowSorting: true),
        )
        .toList();
    this._sortColumnIndex = widget.initialSortedColumnIndex;
    this._isAscending = widget.initialAscending;
    for (int i = 0; i < widget.data.length; i++) {
      Map<String, dynamic> cur = widget.data[i].toJson();
      cur['index'] = i + 1;
      this.data.add(cur);
    }
    this.data.sort((a, b) => compareString(
        this._isAscending, a, b, widget.initialSortedColumnIndex));
    for (int i = 0; i < this.data.length; i++) this.data[i]['index'] = i + 1;
  }

  void _onSort(int index, bool isAscending) {
    for (int i = 0; i < this.data.length; i++) {
      if (index != i) continue;
      this.data.sort((a, b) => compareString(this._isAscending, a, b, index));
      setState(() {
        this._sortColumnIndex = i;
        this._isAscending = isAscending;
      });
      break;
    }
  }

  int compareString(bool ascending, Map<String, dynamic> a,
          Map<String, dynamic> b, int index) =>
      ascending
          ? a[identifyAttr[widget.columns[index]]]
              .compareTo(b[identifyAttr[widget.columns[index]]])
          : b[identifyAttr[widget.columns[index]]]
              .compareTo(a[identifyAttr[widget.columns[index]]]);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(iconTheme: IconThemeData(color: Colors.white)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SfDataGrid(
            columns: this._columns, columnWidthMode: ColumnWidthMode.fill),
      ),
    );
  }

  DataRow getRow(int index) => DataRow.byIndex(
        index: index,
        color: MaterialStateColor.resolveWith(
            (_) => index % 2 == 0 ? primarythemeBlue() : secondarythemeBlue()),
        cells: [
          for (String column in widget.columns)
            this.getCell(column, this.data[index], index)
        ],
      );
}

class TableDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  TableDataSource({required List<dynamic> data}) {}

  List<DataGridRow> _rows = [];

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }

  Widget vanillaDataCell(dynamic data) =>
      Text('${data == null ? '<Unknown>' : Characters(data.toString())}');

  Widget buttonDataCell(BuildContext context, dynamic data, String destination,
          dynamic parameter) =>
      InkWell(
          onTap: () => Navigator.of(context)
              .pushNamed(destination, arguments: parameter),
          child: Text(
            '${data == null ? '<Unknown>' : Characters(data.toString())}',
            style: TextStyle(color: inkWellBlue()),
          ));

  Widget getCell(String column, dynamic data, int index) {
    switch (column) {
      case '#':
        return vanillaDataCell(data?['index']);
      case 'Player':
        return buttonDataCell(context, data?['playerName'], '/player_detail',
            [data?['steamid64'], data?['playerName']]);
      case 'Count':
        return vanillaDataCell(data?['count']);
      case 'Average':
        return vanillaDataCell(data?['average']);
      case 'Points':
        return classifyPoints(data?['points']);
      case 'Rating':
        return vanillaDataCell(data?['rating']);
      case 'Finishes':
        return vanillaDataCell(data?['finishes']);
      case 'Map':
        return buttonDataCell(
            context, data?['mapName'], '/map_detail', widget.data[index]);
      case 'Time':
        return vanillaDataCell(toMinSec(data?['time']));
      case 'TPs':
        return vanillaDataCell(data?['teleports']);
      case 'Date':
        return vanillaDataCell(data?['createdOn'].toString().substring(0, 19));
      case 'Server':
        return vanillaDataCell(data?['serverName']);
      case 'Points in total':
        return vanillaDataCell(data?['totalPoints']);
      default:
        return vanillaDataCell('error');
    }
  }
}
