import 'package:flutter/material.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/utils/pointsClassification.dart';
import 'package:kzstats/utils/timeConversion.dart';

class CustomDataTable extends StatefulWidget {
  final List<dynamic> data;
  final List<String> columns;
  final String defaultSortKey;
  final int initialSortedColumnIndex;
  final bool initialAscending;
  CustomDataTable({
    Key? key,
    required this.data,
    required this.columns,
    required this.defaultSortKey,
    required this.initialSortedColumnIndex,
    required this.initialAscending,
  }) : super(key: key);

  @override
  _CustomDataTableState createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  List<Map<String, dynamic>> data = [];
  late int _rowsPerPage, _curRowsPerPage, _sortColumnIndex;
  late Map<String, String> identifyAttr;
  late bool _isAscending;

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
    };
    this._rowsPerPage = UserSharedPreferences.getRowsPerPage();

    this._sortColumnIndex = widget.initialSortedColumnIndex;
    this._isAscending = widget.initialAscending;

    for (int i = 0; i < widget.data.length; i++) {
      Map<String, dynamic> cur = widget.data[i].toJson();
      cur['index'] = i + 1;
      this.data.add(cur);
    }
    this.data.sort((a, b) => compareString(
        this._isAscending, a, b, widget.initialSortedColumnIndex));

    for (int i = 0; i < this.data.length; i++) {
      this.data[i]['index'] = i + 1;
    }
    this.setCurRowsPerPage(0);
  }

  List<DataColumn> _columns() => widget.columns
      .map((String column) => DataColumn(
          label: Text('$column',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          onSort: _onSort))
      .toList();

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

  void setCurRowsPerPage(int offset) =>
      offset + this._rowsPerPage > this.data.length
          ? this._curRowsPerPage = this.data.length
          : this._curRowsPerPage = this._rowsPerPage;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: dividerColor(),
        cardTheme: CardTheme(
          color: Color(0xff1D202C),
        ),
      ),
      child: PaginatedDataTable(
        headingRowHeight: 46,
        dataRowHeight: 42,
        horizontalMargin: 12,
        columnSpacing: 15,
        columns: _columns(),
        source: CustomDataTableSource(
            context, this.data, widget.data, widget.columns),
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _isAscending,
        rowsPerPage: this._curRowsPerPage,
        onPageChanged: (index) => setState(() => this.setCurRowsPerPage(index)),
      ),
    );
  }
}

class CustomDataTableSource extends DataTableSource {
  BuildContext context;
  final List<Map<String, dynamic>> data;
  final List<dynamic> rawData;
  final List<String> columns;

  CustomDataTableSource(
    this.context,
    this.data,
    this.rawData,
    this.columns,
  );

  DataCell vanillaDataCell(dynamic data) => DataCell(
      Text('${data == null ? '<Unknown>' : Characters(data.toString())}'));

  DataCell buttonDataCell(BuildContext context, dynamic data,
          String destination, dynamic parameter) =>
      DataCell(
        InkWell(
          onTap: () => Navigator.of(context)
              .pushNamed(destination, arguments: parameter),
          child: Text(
            '${data == null ? '<Unknown>' : Characters(data.toString())}',
            style: TextStyle(
              color: inkWellBlue(),
            ),
          ),
        ),
      );

  DataCell getCell(String column, dynamic data, int index) {
    switch (column) {
      case '#':
        return vanillaDataCell('#${[index, 1].reduce((a, b) => a + b)}');
      case 'Player':
        return buttonDataCell(context, data?['playerName'], '/player_detail',
            [data?['steamid64'], data?['playerName']]);
      case 'Count':
        return vanillaDataCell(data?['count']);
      case 'Average':
        return buttonDataCell(context, data?['mapName'], '/map_detail', data);
      case 'Points':
        return DataCell(classifyPoints(data?['points']));
      case 'Rating':
        return vanillaDataCell(data?['rating']);
      case 'Finishes':
        return vanillaDataCell(data?['finishes']);
      case 'Map':
        return buttonDataCell(
            context, data?['mapName'], '/map_detail', rawData[index]);
      case 'Time':
        return vanillaDataCell(toMinSec(data?['time']));
      case 'TPs':
        return vanillaDataCell(data?['teleports']);
      case 'Date':
        return vanillaDataCell(data?['createdOn'].toString().substring(0, 19));
      case 'Server':
        return vanillaDataCell(data?['serverName']);
      default:
        return vanillaDataCell('error');
    }
  }

  @override
  DataRow getRow(int index) => DataRow.byIndex(
        index: index,
        color: MaterialStateColor.resolveWith(
            (_) => index % 2 == 0 ? primarythemeBlue() : secondarythemeBlue()),
        cells: [
          for (String column in this.columns)
            this.getCell(column, this.data[index], index)
        ],
      );

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
