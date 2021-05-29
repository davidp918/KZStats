import 'package:flutter/material.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/utils/modifyDate.dart';
import 'package:kzstats/utils/pointsClassification.dart';
import 'package:kzstats/utils/timeConversion.dart';
import 'package:syncfusion_flutter_core/theme.dart';
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
  late TableDataSource _tableDataSource;
  final Map<String, double> _width = {
    '#': 50,
    'Player': 130,
    'Count': 40,
    'Average': 60,
    'Points': 78,
    'Rating': 80,
    'Finishes': 80,
    'Map': 160,
    'Time': 80,
    'TPs': 70,
    'Date': 180,
    'Server': 200,
    'Points in total': 80,
  };

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
              width: this._width[column] ?? double.nan,
              columnName: column,
              label: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                color: appbarColor(),
                child: Text(
                  '$column',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
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
    this._tableDataSource = TableDataSource(
      data: this.data,
      rawData: widget.data,
      columns: widget.columns,
      context: context,
      identifyAttr: this.identifyAttr,
    );
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
    return SfDataGridTheme(
      data: SfDataGridThemeData(),
      child: SfDataGrid(
        columnWidthMode: ColumnWidthMode.lastColumnFill,
        columns: this._columns,
        source: this._tableDataSource,
      ),
    );
  }
}

class TableDataSource extends DataGridSource {
  late BuildContext context;
  TableDataSource({
    required List<Map<String, dynamic>> data,
    required List<dynamic> rawData,
    required List<String> columns,
    required BuildContext context,
    required Map<String, String> identifyAttr,
  }) {
    this.context = context;
    this._rows = data
        .map<DataGridRow>((dynamic each) => DataGridRow(
              cells: [
                for (String column in columns)
                  DataGridCell(
                    columnName: column,
                    value: each,
                  )
              ],
            ))
        .toList();
  }

  List<DataGridRow> _rows = [];

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color getBackgroundColor() => (this._rows.indexOf(row) + 1) % 2 == 0
        ? primarythemeBlue()
        : secondarythemeBlue();

    return DataGridRowAdapter(
      color: getBackgroundColor(),
      cells: row.getCells().map<Widget>((each) {
        String name = each.columnName;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          alignment: name == '#' || name == 'Points' || name == 'TPs'
              ? Alignment.center
              : Alignment.centerLeft,
          child: getCell(
            each.columnName,
            each.value,
          ),
        );
      }).toList(),
    );
  }

  @override
  bool shouldRecalculateColumnWidths() {
    return true;
  }

  Widget vanillaDataCell(dynamic data) => Text(
        '${data == null ? '<Unknown>' : Characters(data.toString())}',
        style: TextStyle(color: Colors.white),
        overflow: TextOverflow.ellipsis,
      );

  Widget buttonDataCell(BuildContext context, dynamic data, String destination,
          dynamic parameter) =>
      InkWell(
          onTap: () => Navigator.of(context)
              .pushNamed(destination, arguments: parameter),
          child: Text(
            '${data == null ? '<Unknown>' : Characters(data.toString())}',
            style: TextStyle(color: inkWellBlue()),
            overflow: TextOverflow.ellipsis,
          ));

  Widget getCell(String column, dynamic data) {
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
        return buttonDataCell(context, data?['mapName'], '/map_detail',
            [data['mapId'], data['mapName']]);
      case 'Time':
        return vanillaDataCell(toMinSec(data?['time']));
      case 'TPs':
        return vanillaDataCell(data?['teleports']);
      case 'Date':
        String? date = data?['createdOn'].toString();
        return vanillaDataCell(
            '${date?.substring(0, 11)} ${date?.substring(11, 19)}');
      case 'Server':
        return vanillaDataCell(data?['serverName']);
      case 'Points in total':
        return vanillaDataCell(data?['totalPoints']);
      default:
        return vanillaDataCell('error');
    }
  }
}
